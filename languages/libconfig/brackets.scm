; Bracket matching for libconfig

; Curly braces for groups
("{" @open "}" @close)

; Square brackets for arrays
("[" @open "]" @close)

; Parentheses for lists
("(" @open ")" @close)

; Double quotes for strings
("\"" @open "\"" @close)
