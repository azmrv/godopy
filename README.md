# PyGodot

Python and Cython bindings to the [Godot game engine](http://godotengine.org/).

## Work in progress

The bindings are a work in progress. Some planned features are missing and the existing APIs can be unstable!

## Features

- Compilation of Cython and Python code to GDNative binaries
- Running Python code from NativeScript extensions
- Writing Cython methods that run as fast as native C++ methods
- Two specialized sets (Cython and Python) of automatically generatated bindings to the full Godot API
- [Cython] Access to the complete official C++ API from Cython programming language
- [Cython] Automatic type conversions between Godot and Python types
- NumPy array access to core Godot types

This project consists of two parts:
- [**Cython API**](CYTHON_README.md)
- [**Pure Python API**](PYTHON_README.md)
