import sys
import os

from setuptools import setup, Extension
from .enums import ExtType
from .extensions import GDNativeBuildExt


def godot_setup(godot_project, *, library, extensions, **kwargs):
    modules = [
        GodotProject(godot_project, **kwargs),
        library,
        *extensions
    ]

    if len(sys.argv) < 2 or sys.argv[1] != 'install':
        raise SystemExit('Usage: python godot_setup.py install [options]')

    sys.argv = [sys.argv[0], 'build_ext', '-i'] + sys.argv[2:]
    setup(ext_modules=modules, cmdclass={'build_ext': GDNativeBuildExt})


class GodotProject(Extension):
    def __init__(self, name, package=None, *, binary_path=None, set_development_path=False):
        if package is None:
            package = '_' + name

        if binary_path is None:
            binary_path = '.bin'

        self.python_package = package
        self.binary_path = binary_path
        self.set_development_path = set_development_path
        self._gdnative_type = ExtType.PROJECT
        super().__init__(name, sources=[])

    def get_setuptools_name(self, name, validate=None):
        dirname, fullbasename = os.path.split(name)
        basename, extension = os.path.splitext(fullbasename)

        if validate is not None and extension != validate:
            sys.stderr.write("\"%s\" extension was expected for \"%s\".\n" % (validate, name))
            sys.exit(1)

        return os.path.join(self.name, dirname, basename)
