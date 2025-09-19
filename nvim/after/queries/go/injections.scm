; extends

((comment) @injection.language (#offset! @injection.language 0 3 0 0)
(short_var_declaration
  left: (expression_list
          (identifier))
  right: (expression_list
           (raw_string_literal
             (raw_string_literal_content) @injection.content))
))

((comment) @injection.language (#offset! @injection.language 0 3 0 0)
(assignment_statement
  left: (expression_list
          (identifier))
  right: (expression_list
           (raw_string_literal
             (raw_string_literal_content) @injection.content))
))

((comment) @injection.language (#offset! @injection.language 0 3 0 0)
(const_declaration
  (const_spec
    name: (identifier)
    type: (type_identifier)
    value: (expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content))))
)
