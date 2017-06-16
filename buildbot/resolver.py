import json
import random

from buildbot.plugins import steps
from buildbot.process import buildstep, logobserver
from twisted.internet import defer


config = json.load(open("./config.json"))


class TriggerWithPackageNames(steps.Trigger, buildstep.ShellMixin):

    def assign_build_props(self, name, dependencies, worker=False):
        """Assign propper build properties"""
        props = self.set_properties.copy()
        props["virtual_builder_name"] = name
        props["package"] = name
        props["dependencies"] = dependencies
        if worker:
            props["workername"] = worker
        return ["build", props]

    def add_build(self, package, needed, worker=False):
        """Check if the build is allready inn the list"""
        if package not in self._build_requests:
            self.sp.append(
                self.assign_build_props(package, needed, worker=worker))
            self._build_requests.append(package)

    def resolve(self, name, packages, graph=[]):
        """Poor mans dependency resolver """
        available = list(packages.keys())
        for i in packages[name]:
            if i in available and i not in graph:
                graph.append(i)
                self.resolve(i, packages, graph=graph)
        return graph

    def extract_deps(self, srcinfo):
        """ Poor mans .SRCINFO parser """
        packages = {}
        pkgname = ""

        for i in srcinfo.split("\n"):
            if not i:
                continue
            if i[0] == "#":
                continue
            option = i.strip()
            key, value = option.split(" = ")
            if key == "pkgbase":
                pkgname = value
                packages[pkgname] = []
            if key == "makedepends":
                packages[pkgname].append(value)
            # if key == "depends":
            #     packages[pkgname].append(value)
        return packages

    def add_package(self, package):
        """Adds a pacakge to our build trigger list"""
        if package in config["ignore_packages"]:
            return

        # Worker for dependenant builds
        worker = False
        needed = self.resolve(package, self.dependencies, graph=[])

        # If we want to build against a dependency, and it's not inn the list; abort
        if self.getProperty("build_with_dependency") and \
           self.getProperty("build_with_dependency") not in needed:
            return

        if needed:
            worker = random.choice(config["localworkers"])

        # Run over all needed packages and find their deps
        for i in needed:
            _needed = self.resolve(i, self.dependencies, graph=[])
            self.add_build(i, _needed, worker=worker)
        self.add_build(package, needed, worker=worker)

    @defer.inlineCallbacks
    def getSchedulersAndProperties(self):
        """Bread and butter.
        This triggers all the needed PKGBUILDS and resolves the dependencies"""
        self.sp = []
        self._build_requests = []

        # I simply dont know how to make the yield stuff recursive
        # so we find all .SRCINFOs available and make a list
        self.observer = logobserver.BufferLogObserver()
        self.addLogObserver('stdio', self.observer)
        cmd = yield self.makeRemoteShellCommand(command="cat */.SRCINFO")
        yield self.runCommand(cmd)
        self.dependencies = self.extract_deps(self.observer.getStdout())

        # Build one package from the force scheduler 
        if self.getProperty("build_package"):
            package = self.getProperty("build_package")
            self.add_package(package)
            return self.sp
       
        # Build all packages
        if self.getProperty("build_all_packages"):
            for package in self.dependencies.keys():
                self.add_package(package)
            return self.sp

        changed = self.build.allFiles()
        packages = []
        for i in changed:
            file = i.split("/")[0]
            if file in self.dependencies.keys() and file not in config["ignore_packages"]:
                packages.append(file)
    
        for package in set(packages):
            self.add_package(package)
        return self.sp
