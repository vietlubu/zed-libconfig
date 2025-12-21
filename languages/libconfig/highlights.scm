; Comments
(line_comment) @comment
(block_comment) @comment

; Strings
(string) @string
(string_content) @string
(escape_sequence) @string.escape

; Numbers
(integer) @number
(integer64) @number
(float) @number
(hex) @number
(binary) @number
(octal) @number

; Booleans
(boolean) @boolean

; Identifiers (setting names/keys)
(identifier) @property

; Operators
"=" @operator
":" @operator

; Punctuation
";" @punctuation.delimiter
"," @punctuation.delimiter

; Brackets
"{" @punctuation.bracket
"}" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"(" @punctuation.bracket
")" @punctuation.bracket

; Include directive
"@include" @keyword

; Field names in settings and groups
(setting name: (identifier) @property)
(group name: (identifier) @property)
(array name: (identifier) @property)
(list name: (identifier) @property)
