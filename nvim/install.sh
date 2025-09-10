#!/bin/bash

# Neovim Configuration Setup Script
# This script helps set up the Neovim configuration on new systems

set -e

echo "🚀 Setting up Neovim configuration..."

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "❌ Neovim is not installed. Please install Neovim first."
    echo "Visit: https://github.com/neovim/neovim/releases"
    exit 1
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -n1 | cut -d' ' -f2 | cut -d'v' -f2)
REQUIRED_VERSION="0.8.0"

if ! printf '%s\n%s\n' "$REQUIRED_VERSION" "$NVIM_VERSION" | sort -V -C; then
    echo "❌ Neovim version $NVIM_VERSION is too old. Required: $REQUIRED_VERSION+"
    exit 1
fi

echo "✅ Neovim version $NVIM_VERSION detected"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Install packer.nvim if not present
PACKER_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_PATH" ]; then
    echo "📦 Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
    echo "✅ Packer installed"
else
    echo "✅ Packer already installed"
fi

# Check for Node.js (needed for some LSP servers)
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js $NODE_VERSION detected"
else
    echo "⚠️  Node.js not found. Some LSP servers may not work."
    echo "   Install from: https://nodejs.org"
fi

# Check for required system tools
echo "🔍 Checking system dependencies..."

check_tool() {
    if command -v "$1" &> /dev/null; then
        echo "✅ $1 found"
    else
        echo "⚠️  $1 not found - $2"
    fi
}

check_tool "rg" "Install ripgrep for better search"
check_tool "fd" "Install fd for better file finding"
check_tool "make" "Install make for compiling"
check_tool "gcc" "Install gcc for compiling"

# Platform-specific checks
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 macOS detected"
    if command -v brew &> /dev/null; then
        echo "✅ Homebrew found"
    else
        echo "⚠️  Homebrew not found. Consider installing for easier package management."
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Linux detected"
fi

echo ""
echo "🎯 Next steps:"
echo "1. Open Neovim: nvim"
echo "2. Run: :PackerSync"
echo "3. Restart Neovim"
echo "4. Run: :checkhealth"
echo ""
echo "📚 Key mappings:"
echo "  <leader>e  - Toggle file explorer"
echo "  <C-f>      - Find files (Telescope)"
echo "  <C-g>      - Live grep"
echo "  gd         - Go to definition"
echo "  <leader>ca - Code actions"
echo "  <leader>cf - Format code"
echo ""
echo "🎉 Setup complete! Happy coding!"