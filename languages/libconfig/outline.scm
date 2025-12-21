; Outline/structure queries for libconfig

; Settings (key-value pairs)
(setting
  name: (identifier) @name) @item

; Groups
(group
  name: (identifier) @name) @item

; Arrays
(array
  name: (identifier) @name) @item

; Lists
(list
  name: (identifier) @name) @item

; Nested context
(group
  (setting) @context)

(group
  (group) @context)
