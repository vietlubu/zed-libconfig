# libconfig Extension for Zed Editor

This extension provides comprehensive syntax highlighting and language support for libconfig configuration files (`.conf`).

## Features

### Syntax Highlighting

Full syntax highlighting for all libconfig elements:

- **Settings/Properties**: Keys and identifiers highlighted as properties
- **Values**:
  - Strings with escape sequences (`"text"`, `\n`, `\t`, etc.)
  - Integers (`42`, `-100`)
  - 64-bit integers (`9223372036854775807L`)
  - Floating-point numbers (`3.14`, `1.5e10`)
  - Booleans (`true`, `false`)
  - Hexadecimal values (`0x1FC3`, `0xFF00`)
  - Binary values (`0b1011`, `0b1111`)
  - Octal values (`0o755`, `0o644`)
- **Structures**:
  - Groups with curly braces `{}`
  - Arrays with square brackets `[]`
  - Lists with parentheses `()`
- **Comments**:
  - Line comments (`//`, `#`)
  - Block comments (`/* ... */`)
- **Directives**: Include statements (`@include "file.conf"`)
- **Operators**: Assignment (`:`, `=`), delimiters (`;`, `,`)

### Editor Features

- **Rainbow Brackets**: Color-coded matching brackets for `{}`, `[]`, `()`
- **Auto-indentation**: Smart indentation for nested structures
- **Auto-closing**: Automatic closing of brackets and quotes
- **Bracket Matching**: Highlight matching bracket pairs
- **Comment Toggle**: `Cmd+/` (Mac) or `Ctrl+/` (Linux/Windows)
- **Code Outline**: Structure view for navigation
- **Text Objects**: Vim mode support for navigation (if enabled)

## Installation

### From Source (Local Development)

1. Clone or copy this extension directory:

   **macOS/Linux:**

   ```bash
   ./install.sh
   ```

   **Windows:**

   ```bash
   .\install.bat
   ```

2. Restart Zed or reload extensions:
   - Open Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
   - Run `zed: reload extensions`

### Verify Installation

1. Open any `.conf` file
2. Check the language indicator in the bottom-right corner
3. It should show "libconfig"

## Supported File Types

- `.conf` - Configuration files

## Installation Paths

Zed extensions are installed in different locations depending on your OS:

- **macOS**: `~/Library/Application Support/Zed/extensions/installed`
- **Linux**: `~/.local/share/zed/extensions/installed` (or `$XDG_DATA_HOME/zed/extensions/installed`)
- **Windows**: `%LOCALAPPDATA%\Zed\extensions\installed`

## libconfig Syntax

This extension supports the libconfig syntax.

### Basic Types

```conf
// Strings
name = "value"
name: "value"  // Colon assignment

// Numbers
count = 42
bignum = 9223372036854775807L
pi = 3.14159

// Booleans
enabled = true
disabled = false

// Hex, Binary, Octal
flags = 0x1FC3
bitmask = 0b1011
perms = 0o755
```

### Groups

```conf
server: {
    host = "localhost"
    port = 8080
}
```

### Arrays

```conf
ports = [ 8080, 8081, 8082 ]
names = [ "alice", "bob", "charlie" ]
```

### Lists (mixed types)

```conf
mixed = ( "string", 123, true, 3.14 )
```

### Comments

```conf
// Line comment
# Also a line comment
/* Block
   comment */
```

### Includes

```conf
@include "other_config.conf"
```

### Semicolons (Optional)

```conf
name = "value"  // No semicolon needed
host = "localhost";  // But still accepted
```

## Tree-sitter Grammar

This extension includes a **custom tree-sitter grammar** for libconfig, located in `grammars/tree-sitter-libconfig/`.

Since no official tree-sitter-libconfig grammar exists, we created one specifically for this extension. The grammar supports:

- All standard libconfig syntax
- Include directives (`@include`)
- Multiple comment styles
- All numeric formats (hex, binary, octal)

### Grammar Features

- **Node Types**: `document`, `setting`, `group`, `array`, `list`, `string`, `number`, `boolean`, `comment`
- **Assignment Operators**: Both `=` and `:`
- **Optional Semicolons**: Statements can end with or without `;`
- **Flexible Syntax**: Designed for real-world libconfig files

For grammar source code, see: `grammars/tree-sitter-libconfig/grammar.js`

## Developing

### Modifying Syntax Highlighting

To customize syntax highlighting, edit the query files in `languages/libconfig/`:

- `highlights.scm` - Syntax highlighting rules
- `brackets.scm` - Bracket matching
- `indents.scm` - Auto-indentation
- `outline.scm` - Code structure
- `textobjects.scm` - Vim mode navigation

### Modifying the Grammar

To modify the tree-sitter grammar:

1. Edit `grammars/tree-sitter-libconfig/grammar.js`
2. Rebuild the grammar (requires Node.js and tree-sitter-cli):
   ```bash
   cd grammars/tree-sitter-libconfig
   npm install
   npm run build
   ```
3. Test your changes with sample `.conf` files

## License

GNU General Public License v3.0.

## References

- [libconfig Documentation](https://hyperrealm.github.io/libconfig/libconfig_manual.html)
- [Zed Extension Documentation](https://zed.dev/docs/extensions)
