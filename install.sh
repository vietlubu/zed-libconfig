#!/usr/bin/env bash
#=============================================================================
#= libconfig Extension Installer for Zed Editor
#=============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Extension info
EXTENSION_NAME="libconfig"
EXTENSION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Zed extensions directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ZED_EXTENSIONS_DIR="$HOME/Library/Application Support/Zed/extensions/installed"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if [ -n "$XDG_DATA_HOME" ]; then
        ZED_EXTENSIONS_DIR="$XDG_DATA_HOME/zed/extensions/installed"
    else
        ZED_EXTENSIONS_DIR="$HOME/.local/share/zed/extensions/installed"
    fi
else
    echo -e "${RED}Error: Unsupported OS type: $OSTYPE${NC}"
    echo "This script supports macOS and Linux only."
    echo "For Windows, please use install.bat or follow INSTALL.md"
    exit 1
fi

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "============================================================"
    echo "  libconfig Extension Installer for Zed Editor"
    echo "============================================================"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_zed_installed() {
    if ! command -v zed &> /dev/null; then
        print_warning "Zed Editor command 'zed' not found in PATH"
        print_info "Make sure Zed is installed and accessible"
        print_info "Installation will continue, but you may need to restart Zed manually"
        return 1
    fi
    return 0
}

create_extensions_dir() {
    if [ ! -d "$ZED_EXTENSIONS_DIR" ]; then
        print_info "Creating Zed extensions directory..."
        mkdir -p "$ZED_EXTENSIONS_DIR"
        print_success "Created: $ZED_EXTENSIONS_DIR"
    else
        print_success "Zed extensions directory exists"
    fi
}

install_symlink() {
    local target="$ZED_EXTENSIONS_DIR/$EXTENSION_NAME"

    if [ -L "$target" ]; then
        print_warning "Symlink already exists: $target"
        read -p "Remove and recreate? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$target"
            print_success "Removed old symlink"
        else
            print_info "Installation cancelled"
            exit 0
        fi
    elif [ -d "$target" ]; then
        print_error "Directory already exists: $target"
        print_info "Please remove it manually or use --copy mode"
        exit 1
    fi

    print_info "Creating symlink..."
    ln -s "$EXTENSION_DIR" "$target"
    print_success "Symlink created: $target -> $EXTENSION_DIR"
}

install_copy() {
    local target="$ZED_EXTENSIONS_DIR/$EXTENSION_NAME"

    if [ -d "$target" ]; then
        print_warning "Extension directory already exists: $target"
        read -p "Remove and reinstall? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$target"
            print_success "Removed old installation"
        else
            print_info "Installation cancelled"
            exit 0
        fi
    fi

    print_info "Copying extension files..."
    cp -r "$EXTENSION_DIR" "$target"
    print_success "Extension copied to: $target"
}

verify_installation() {
    local target="$ZED_EXTENSIONS_DIR/$EXTENSION_NAME"

    print_info "Verifying installation..."

    # Check if directory/symlink exists
    if [ ! -e "$target" ]; then
        print_error "Installation verification failed: extension not found"
        return 1
    fi

    # Check required files
    local required_files=(
        "extension.toml"
        "languages/libconfig/config.toml"
        "languages/libconfig/highlights.scm"
    )

    for file in "${required_files[@]}"; do
        if [ ! -f "$target/$file" ]; then
            print_error "Missing required file: $file"
            return 1
        fi
    done

    print_success "All required files present"
    return 0
}

show_next_steps() {
    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Zed Editor (or reload extensions)"
    echo "  2. Open any .conf file"
    echo "  3. Check the language indicator in bottom-right"
    echo "  4. You should see 'libconfig'"
    echo ""
    echo "To reload extensions without restarting:"
    echo "  - Open Command Palette: Cmd+Shift+P (macOS) or Ctrl+Shift+P (Linux)"
    echo "  - Run: 'zed: reload extensions'"
    echo ""
    echo "Test with example file:"
    echo "  zed $EXTENSION_DIR/example.conf"
    echo ""
    print_info "For more information, see: $EXTENSION_DIR/README.md"
}

uninstall() {
    local target="$ZED_EXTENSIONS_DIR/$EXTENSION_NAME"

    if [ ! -e "$target" ]; then
        print_warning "Extension not installed: $target"
        exit 0
    fi

    print_warning "This will remove the libconfig extension"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstall cancelled"
        exit 0
    fi

    print_info "Removing extension..."
    rm -rf "$target"
    print_success "Extension uninstalled: $target"
    echo ""
    print_info "Remember to reload Zed extensions"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install the libconfig extension for Zed Editor.

OPTIONS:
    --symlink    Create a symlink (default, recommended for development)
    --copy       Copy files instead of symlinking
    --uninstall  Remove the extension
    --help       Show this help message

EXAMPLES:
    $0                  # Install using symlink (default)
    $0 --symlink        # Install using symlink (explicit)
    $0 --copy           # Install by copying files
    $0 --uninstall      # Remove the extension

For more information, see: $EXTENSION_DIR/INSTALL.md
EOF
}

# Main script
main() {
    local mode="symlink"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --symlink)
                mode="symlink"
                shift
                ;;
            --copy)
                mode="copy"
                shift
                ;;
            --uninstall)
                print_header
                uninstall
                exit 0
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_usage
                exit 1
                ;;
        esac
    done

    # Start installation
    print_header

    print_info "Installation mode: $mode"
    print_info "Extension directory: $EXTENSION_DIR"
    print_info "Zed extensions directory: $ZED_EXTENSIONS_DIR"
    echo ""

    # Check Zed installation
    check_zed_installed || true

    # Create extensions directory
    create_extensions_dir

    # Install
    if [ "$mode" = "symlink" ]; then
        install_symlink
    else
        install_copy
    fi

    # Verify
    if verify_installation; then
        show_next_steps
    else
        print_error "Installation verification failed"
        print_info "Please check the errors above and try again"
        exit 1
    fi
}

# Run main
main "$@"
