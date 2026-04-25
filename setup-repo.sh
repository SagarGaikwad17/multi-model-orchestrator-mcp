#!/bin/bash

# Multi-Model Orchestrator MCP - GitHub Repo Setup Script
# This script automates the entire repository setup process

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="multi-model-orchestrator-mcp"
REPO_DESCRIPTION="MCP server orchestrating Claude models: Opus (planning), Sonnet (coding), Haiku (subtasks)"

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Step 1: Check prerequisites
print_header "Step 1: Checking Prerequisites"

if ! command -v git &> /dev/null; then
    print_error "Git is not installed"
    echo "Install from: https://git-scm.com/download"
    exit 1
fi
print_success "Git installed"

if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed"
    echo "Install from: https://nodejs.org/"
    exit 1
fi
print_success "Node.js $(node --version)"

if ! command -v npm &> /dev/null; then
    print_error "npm is not installed"
    exit 1
fi
print_success "npm $(npm --version)"

if [ -z "$ANTHROPIC_API_KEY" ]; then
    print_warning "ANTHROPIC_API_KEY environment variable not set"
    echo "You'll need to set it later for the MCP server to work"
fi

# Step 2: Create project directory
print_header "Step 2: Creating Project Directory"

read -p "Enter project directory path (default: ~/$REPO_NAME): " PROJECT_DIR
PROJECT_DIR="${PROJECT_DIR:-$HOME/$REPO_NAME}"
PROJECT_DIR="${PROJECT_DIR/#\~/$HOME}"  # Expand ~ to home

if [ -d "$PROJECT_DIR" ]; then
    print_warning "Directory already exists: $PROJECT_DIR"
    read -p "Use existing directory? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Aborting"
        exit 1
    fi
else
    mkdir -p "$PROJECT_DIR"
    print_success "Created directory: $PROJECT_DIR"
fi

cd "$PROJECT_DIR"
ABSOLUTE_PATH="$(cd "$(dirname "$PROJECT_DIR")"; pwd)/$(basename "$PROJECT_DIR")"
print_success "Working in: $ABSOLUTE_PATH"

# Step 3: Initialize git repo
print_header "Step 3: Initializing Git Repository"

if [ -d ".git" ]; then
    print_info "Git repo already initialized"
else
    git init
    git config user.name "$(git config --global user.name || echo 'Your Name')"
    git config user.email "$(git config --global user.email || echo 'your.email@example.com')"
    print_success "Git repository initialized"
fi

# Step 4: Create directory structure
print_header "Step 4: Creating Directory Structure"

mkdir -p src
mkdir -p python
mkdir -p examples
mkdir -p tests
mkdir -p docs
mkdir -p .github/workflows

print_success "Created subdirectories"

# Step 5: Create essential files
print_header "Step 5: Creating Essential Files"

# .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock
dist/
build/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
pip-log.txt
pip-delete-this-directory.txt

# Environment variables
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Logs
*.log
npm-debug.log*
yarn-debug.log*

# Testing
coverage/
.nyc_output/
EOF
print_success "Created .gitignore"

# LICENSE
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2026 Multi-Model Orchestrator Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
print_success "Created LICENSE (MIT)"

# CONTRIBUTING.md
cat > CONTRIBUTING.md << 'EOF'
# Contributing

We welcome contributions! Here's how to get started:

## Development Setup

```bash
npm install
npm run build
npm start
```

## Making Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Commit: `git commit -am 'Add feature'`
5. Push: `git push origin feature/my-feature`
6. Submit a pull request

## Code Style

- Use TypeScript for MCP server code
- Use Python 3.8+ for standalone scripts
- Follow existing code patterns
- Write tests for new features

## Testing

```bash
npm test
python3 -m pytest tests/
```

## Reporting Issues

Please include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Your environment (OS, Node/Python version)
EOF
print_success "Created CONTRIBUTING.md"

# Step 6: Create example files references
print_header "Step 6: Creating Example References"

cat > examples/README.md << 'EOF'
# Examples

This directory contains example uses of the Multi-Model Orchestrator.

## Available Examples

- **web-scraper.py**: Build a web scraper with error handling
- **cli-tool.py**: Create a command-line interface tool
- **rest-api.py**: Implement a RESTful API
- **data-pipeline.py**: Design a data processing pipeline

## Running Examples

```bash
python3 examples/web-scraper.py
python3 examples/cli-tool.py
```

## Creating Your Own

```bash
python3 multi_model_orchestrator.py "Your task description here"
```
EOF
print_success "Created examples/README.md"

# Step 7: Create initial commit
print_header "Step 7: Creating Initial Commit"

git add .
git commit -m "Initial commit: Multi-Model Orchestrator MCP

- Core MCP server implementation (TypeScript/Node.js)
- Standalone Python version
- Opus: Strategic planning
- Sonnet: Code implementation
- Haiku: Subtask execution
- Complete documentation
- GitHub repository setup" || print_warning "Nothing new to commit"

print_success "Initial commit created"

# Step 8: Show next steps
print_header "Next Steps"

echo ""
echo -e "${GREEN}Your repository is ready!${NC}"
echo ""
echo "1. Create GitHub repository at https://github.com/new"
echo "   - Repository name: $REPO_NAME"
echo "   - Description: $REPO_DESCRIPTION"
echo "   - Do NOT initialize with README, .gitignore, or license"
echo ""
echo "2. Run these commands in your terminal:"
echo ""
echo "   cd $ABSOLUTE_PATH"
echo "   git remote add origin https://github.com/YOUR-USERNAME/$REPO_NAME.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Configure for VS Code:"
echo "   - Edit ~/.config/Claude/claude_desktop_config.json"
echo "   - Set path to: $ABSOLUTE_PATH/dist/index.js"
echo ""
echo "4. Build and test:"
echo "   cd $ABSOLUTE_PATH"
echo "   npm install"
echo "   npm run build"
echo ""
echo "5. Verify MCP tools:"
echo "   npm start"
echo ""

# Step 9: Offer to build now
echo ""
read -p "Would you like to build the MCP server now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_header "Building MCP Server"
    npm install
    npm run build
    print_success "Build complete!"
    echo ""
    echo "Next: Copy your code files to:"
    echo "  - src/index.ts (MCP server)"
    echo "  - python/multi_model_orchestrator.py (Python version)"
    echo "  - Documentation files to docs/"
    echo ""
fi

# Final summary
print_header "Setup Complete! ✨"

echo ""
echo "Project location: $ABSOLUTE_PATH"
echo "Repository name: $REPO_NAME"
echo ""
echo "Quick commands:"
echo "  cd $ABSOLUTE_PATH"
echo "  npm run build    # Build MCP server"
echo "  npm start        # Run MCP server"
echo "  git status       # Check git status"
echo "  git push origin main  # Push to GitHub"
echo ""
echo "For VS Code setup, see: VSCODE_SETUP.md"
echo "For more info, see: GETTING_STARTED.md"
echo ""

print_success "Ready to use Multi-Model Orchestrator! 🚀"
