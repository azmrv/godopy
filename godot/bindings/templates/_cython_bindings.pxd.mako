# Generated by PyGodot binding generator
<%!
    from pygodot.cli.binding_generator import python_module_name, remove_nested_type_prefix, CORE_TYPES, clean_signature

    enum_values = set()

    def clean_value_name(value_name):
        enum_values.add(value_name)
        return remove_nested_type_prefix(value_name)
%>
from godot_headers.gdnative_api cimport *

# Avoid c-importing "_Wrapped" and "Object"
from ..cpp.core_types cimport real_t, ${', '.join(CORE_TYPES)}
from ..core_types cimport _Wrapped, VariantType, VariantOperator, Vector3Axis


cdef __register_types()
cdef __init_method_bindings()


cdef struct __method_bindings:
% for class_name, class_def, includes, forwards, methods in classes:
    % for method_name, method, return_type, pxd_signature, signature, args, return_stmt in methods:
    godot_method_bind *__${class_name}__mb_${method_name}
    % endfor
% endfor

cdef __method_bindings __mb
% for class_name, class_def, includes, forwards, methods in classes:

cdef class ${class_name}(${class_def['base_class'] or '_Wrapped'}):
    % for method_name, method, return_type, pxd_signature, signature, args, return_stmt in methods:
    cdef ${return_type}${method_name}(self${', ' if pxd_signature else ''}${clean_signature(pxd_signature, class_name)})
    % endfor
    % if class_def['singleton']:

    @staticmethod
    cdef object get_singleton()

    % elif not class_def['enums'] and not class_def['constants'] and not methods:
        pass
    % endif

    % for enum in class_def['enums']:
cdef enum ${class_name}${enum['name'].lstrip('_')}:
        % for value_name, value in enum['values'].items():
    ${python_module_name(class_name).upper()}_${clean_value_name(value_name)} = ${value}
        % endfor

    % endfor
    % for name, value in ((k, v) for (k, v) in class_def['constants'].items() if k not in enum_values):
cdef int ${python_module_name(class_name).upper()}_${name} = ${value}

    % endfor
% endfor