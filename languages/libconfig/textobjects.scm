; Text objects for Vim mode navigation

; Settings as function objects
(setting) @function.around

(setting
  value: (_) @function.inside)

; Groups as class objects
(group) @class.around

(group
  "{"
  (_)* @class.inside
  "}")

; Comments
(line_comment)+ @comment.around
(block_comment) @comment.around

; Arrays as function objects
(array) @function.around

(array
  "["
  (_)* @function.inside
  "]")

; Lists as function objects
(list) @function.around

(list
  "("
  (_)* @function.inside
  ")")
