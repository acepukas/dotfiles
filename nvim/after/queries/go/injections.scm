; extends

(short_var_declaration
  left: (expression_list
          (identifier) @_id (#eq? @_id "query"))
  right: (expression_list
           (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)

(assignment_statement
  left: (expression_list
          (identifier) @_id (#eq? @_id "query"))
  right: (expression_list
           (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)
