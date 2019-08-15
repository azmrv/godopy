from setuptools import Extension
from .enums import ExtType


class GenericGDNativeLibrary(Extension):
    def __init__(self, name):
        self._gdnative_type = ExtType.GENERIC_LIBRARY
        super().__init__(name, sources=[])


class GDNativeLibrary(Extension):
    def __init__(self, name, source, extra_sources=None, **gdnative_options):
        self._gdnative_type = ExtType.LIBRARY
        self._gdnative_options = gdnative_options

        sources = [source]

        if extra_sources is not None:
            for src in extra_sources:
                sources.append(src)

        super().__init__(name, sources=sources)