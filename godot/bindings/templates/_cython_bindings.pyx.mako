# Generated by PyGodot binding generator
<%!
    from pygodot.cli.binding_generator import (
        python_module_name, is_class_type, CORE_TYPES, SPECIAL_ESCAPES,
        remove_nested_type_prefix, clean_signature, cython_nonempty_comparison
    )

    def make_arg(arg):
        if is_class_type(arg[2]['type']):
            return '%s._owner' % arg[1]
        return arg[1]
%>
from godot_headers.gdnative_api cimport godot_object, godot_variant
from ..globals cimport Godot, gdapi, nativescript_1_1_api as ns11api, _cython_language_index

# Avoid c-importing "_Wrapped" and "Object"
from ..cpp.core_types cimport real_t, ${', '.join(CORE_TYPES)}

from ..core_types cimport _Wrapped, register_global_cython_type, get_instance_from_owner
from .cython.__icalls cimport *

from cpython.ref cimport Py_DECREF
% for class_name, class_def, includes, forwards, methods in classes:


% if class_def['singleton']:
cdef object __${class_name}___singleton = None

% endif
% if methods:
cdef __${class_name}__method_bindings __${class_name}__mb

% endif
cdef class ${class_name}(${class_def['base_class'] or '_Wrapped'}):
    % if class_def['singleton']:
    @staticmethod
    cdef object get_singleton():
        global __${class_name}___singleton

        if __${class_name}___singleton is None:
            __${class_name}___singleton = ${class_name}.__new__(${class_name})

        return __${class_name}___singleton

    % endif
    def __cinit__(self):
    % if class_def['singleton']:
        self._owner = gdapi.godot_global_get_singleton(<char *>"${class_name}")
    % else:
        self._owner = NULL
    % endif

    % if class_def['instanciable']:
    def __init__(self):
        # Ensure ${class_name}() call will create a correct wrapper object
        cdef ${class_name} delegate = ${class_name}._new()
        self._owner = delegate._owner
        Py_DECREF(delegate)

    @staticmethod
    cdef ${class_name} _new():
        return <${class_name}>ns11api.godot_nativescript_get_instance_binding_data(_cython_language_index, gdapi.godot_get_class_constructor("${class_def['name']}")())

    % else:
    def __init__(self):
        raise RuntimeError('${class_name} is not instanciable')

    % endif
    % for method_name, method, return_type, pxd_signature, signature, args, return_stmt in methods:
    % if method['name'] in SPECIAL_ESCAPES:
    def ${method_name}(self, ${clean_signature(signature, class_name)}):
    % else:
    cdef ${return_type}${method_name}(self${', ' if signature else ''}${clean_signature(signature, class_name)}):
    % endif
    % if method_name == 'free':
        ## [copied from godot-cpp] dirty hack because Object::free is marked virtual but doesn't actually exist...
        gdapi.godot_object_destroy(self._owner)
        self._owner = NULL
    % elif method['has_varargs']:
        % if is_class_type(method['return_type']):
        cdef Variant __owner = ${icall_names[class_name + '#' + method_name]}(__${class_name}__mb.mb_${method_name}, self._owner${', %s' % ', '.join(make_arg(a) for a in args) if args else ''}, __var_args)
        return get_instance_from_owner(<godot_object *>__owner)
        % else:
        ${return_stmt}${icall_names[class_name + '#' + method_name]}(__${class_name}__mb.mb_${method_name}, self._owner${', %s' % ', '.join(make_arg(a) for a in args) if args else ''}, __var_args)
        % endif
    % else:
        ## not has_varargs
        ${return_stmt}${icall_names[class_name + '#' + method_name]}(__${class_name}__mb.mb_${method_name}, self._owner${', %s' % ', '.join(make_arg(a) for a in args) if args else ''})
    % endif

    % endfor

    @staticmethod
    cdef __init_method_bindings():
    % for method_name, method, return_type, pxd_signature, signature, args, return_stmt in methods:
        __${class_name}__mb.mb_${method_name} = gdapi.godot_method_bind_get_method("${class_def['name']}", "${method['name']}")
    % endfor
    % if not methods:
        pass
    % endif
% endfor


cdef __init_method_bindings():
% for class_name, class_def, includes, forwards, methods in classes:
    ${class_name}.__init_method_bindings()
% endfor


cdef __register_types():
% for class_name, class_def, includes, forwards, methods in classes:
    register_global_cython_type(${class_name}, ${repr(class_def['name'])})
% endfor
