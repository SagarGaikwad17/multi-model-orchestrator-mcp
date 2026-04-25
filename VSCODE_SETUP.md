# 🚀 VS Code Claude Extension Setup Guide

## Overview

Using Multi-Model Orchestrator MCP with VS Code Claude Extension enables you to:
- Write code with Claude's help directly in your editor
- Use Opus for planning code architecture
- Use Sonnet for implementation
- Use Haiku for quick fixes and tests
- Access all MCP tools from the extension

---

## ✅ Prerequisites

1. **VS Code installed** (https://code.visualstudio.com/)
2. **Claude Extension for VS Code**
   - Install from Extensions marketplace
   - OR: `code --install-extension anthropic.claude`
3. **GitHub repo with your code** (see GITHUB_SETUP.md)
4. **Node.js 18+** (`node --version`)
5. **Anthropic API Key** (https://console.anthropic.com)

---

## 🔧 Step-by-Step Setup

### Step 1: Install Claude Extension

```bash
# Option A: From command line
code --install-extension anthropic.claude

# Option B: In VS Code
# - Open Extensions (Ctrl+Shift+X / Cmd+Shift+X)
# - Search "Claude"
# - Click Install
```

### Step 2: Configure API Key

```bash
# Set environment variable
export ANTHROPIC_API_KEY="sk-ant-..."

# Verify it's set
echo $ANTHROPIC_API_KEY
```

**For VS Code to pick it up:**
- Restart VS Code, OR
- Add to your shell profile:
  ```bash
  # ~/.bashrc or ~/.zshrc
  export ANTHROPIC_API_KEY="sk-ant-..."
  ```

### Step 3: Clone Your Repository

```bash
# Option A: Terminal
git clone https://github.com/YOUR-USERNAME/multi-model-orchestrator-mcp.git
cd multi-model-orchestrator-mcp
code .

# Option B: VS Code
# Cmd/Ctrl + Shift + P → "Clone Repository"
# Paste: https://github.com/YOUR-USERNAME/multi-model-orchestrator-mcp.git
```

### Step 4: Build the MCP Server

```bash
# In VS Code terminal (Ctrl+`)
npm install
npm run build
```

### Step 5: Configure MCP in VS Code Settings

**Find your config file:**
- **macOS/Linux**: `~/.config/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

**Add your MCP server:**
```json
{
  "mcpServers": {
    "multi-orchestrator": {
      "command": "node",
      "args": ["/absolute/path/to/dist/index.js"],
      "env": {
        "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

**Replace `/absolute/path/to/` with your actual path:**
```bash
# Get absolute path
pwd  # Copy this output
# Example: /Users/yourname/projects/multi-model-orchestrator-mcp

# Your full path would be:
# /Users/yourname/projects/multi-model-orchestrator-mcp/dist/index.js
```

### Step 6: Restart Claude Extension

- Close and reopen VS Code, OR
- In Claude Extension: Click reload

---

## 🎯 Using with VS Code Claude Extension

### Method 1: Chat with Tools Available

1. Open Claude Extension (sidebar)
2. Type a request:
   ```
   Use the orchestrator to plan a REST API for a blog platform
   ```
3. Claude will have access to:
   - `plan_task` - Opus planning
   - `implement_code` - Sonnet coding
   - `execute_subtask` - Haiku execution
   - `orchestrate_full_task` - Full pipeline

### Method 2: Right-Click in Editor

```
Select code in editor
→ Right-click
→ "Ask Claude"
→ Request task orchestration
```

### Method 3: Create Project from Chat

1. In Claude Extension chat:
   ```
   Generate a Python web scraper using the orchestrator
   ```

2. Claude will:
   - Call `orchestrate_full_task` with your task
   - Get plan, implementation, and results
   - Offer to create files directly in your project

---

## 📝 Configuration Examples

### Basic Setup
```json
{
  "mcpServers": {
    "multi-orchestrator": {
      "command": "node",
      "args": ["/Users/yourname/repos/multi-model-orchestrator-mcp/dist/index.js"],
      "env": {
        "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

### Advanced Setup (with debugging)
```json
{
  "mcpServers": {
    "multi-orchestrator": {
      "command": "node",
      "args": ["--inspect", "/Users/yourname/repos/multi-model-orchestrator-mcp/dist/index.js"],
      "env": {
        "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}",
        "DEBUG": "true",
        "LOG_LEVEL": "info"
      }
    }
  }
}
```

### Multiple Instances
```json
{
  "mcpServers": {
    "orchestrator-main": {
      "command": "node",
      "args": ["/path/to/dist/index.js"],
      "env": { "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}" }
    },
    "orchestrator-dev": {
      "command": "node",
      "args": ["/path/to/dev/dist/index.js"],
      "env": { "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}" }
    }
  }
}
```

---

## 🛠️ Common Workflows

### Workflow 1: Build New Feature

```
1. In VS Code Claude Extension, ask:
   "Use orchestrator to design a user authentication system"

2. Claude calls:
   - plan_task → Get architecture plan
   - implement_code → Get implementation
   - execute_subtask → Test subtasks

3. Results appear in chat
4. Click "Create File" → Files generated in your project
5. VS Code opens files for review
```

### Workflow 2: Refactor Existing Code

```
1. Select code in editor
2. Right-click → "Ask Claude"
3. Request:
   "Use orchestrator to refactor this for performance"

4. Claude:
   - Analyzes current code
   - Plans optimizations
   - Generates improved version
   - Suggests tests

5. Review and merge changes
```

### Workflow 3: Debug Issues

```
1. In Claude chat, explain the issue:
   "Database connection is timing out in production"

2. Use orchestrator to:
   - Plan debugging strategy
   - Generate diagnostic code
   - Create test cases

3. Deploy fixes with confidence
```

### Workflow 4: Write Tests

```
1. Select function in editor
2. Request:
   "Use Haiku to write unit tests for this function"

3. Claude generates:
   - Test cases
   - Edge case coverage
   - Fixtures if needed

4. Copy tests into your test file
```

---

## 🔗 Project Structure in VS Code

**Recommended setup for cleanest workflow:**

```
.
├── src/
│   └── index.ts              (MCP Server - don't edit during dev)
├── python/
│   └── multi_model_orchestrator.py
├── examples/
│   ├── web-scraper.py        (Generated by Claude)
│   ├── api-server.ts         (Generated by Claude)
│   └── cli-tool.py           (Generated by Claude)
├── output/
│   └── [Files generated by Claude]
├── dist/
│   └── index.js              (Compiled MCP Server)
├── package.json
├── README.md
└── claude_desktop_config.json (Your config)
```

---

## ✅ Verification Checklist

Before using in VS Code:

- [ ] VS Code Claude Extension installed
  ```bash
  # Check
  code --list-extensions | grep claude
  ```

- [ ] API key environment variable set
  ```bash
  # Check
  echo $ANTHROPIC_API_KEY | head -c 10  # Should show "sk-ant-..."
  ```

- [ ] Repository cloned locally
  ```bash
  # Check
  cd multi-model-orchestrator-mcp
  pwd  # Note this path
  ```

- [ ] NPM dependencies installed
  ```bash
  # Check
  npm list
  ```

- [ ] MCP server built
  ```bash
  # Check
  ls dist/index.js  # Should exist
  ```

- [ ] Configuration file exists with correct path
  ```bash
  # macOS/Linux
  cat ~/.config/Claude/claude_desktop_config.json
  ```

- [ ] No API key visible in config (use `${ANTHROPIC_API_KEY}`)

---

## 🐛 Troubleshooting

### Problem: "Extension can't find MCP server"

**Solution:**
```bash
# 1. Verify the path in config is absolute
# (not relative like ./dist/index.js)

# 2. Get absolute path
cd /path/to/multi-model-orchestrator-mcp
pwd
# Copy this output and use in config

# 3. Rebuild
npm run build

# 4. Restart VS Code
```

### Problem: "API key not recognized"

**Solution:**
```bash
# 1. Verify API key is set
echo $ANTHROPIC_API_KEY

# 2. Make sure it's exported
export ANTHROPIC_API_KEY="sk-ant-..."

# 3. Add to shell profile for persistence
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
# Then restart VS Code

# 4. Check config uses ${ANTHROPIC_API_KEY}
cat ~/.config/Claude/claude_desktop_config.json
```

### Problem: "Tools not showing in Claude Extension"

**Solution:**
```bash
# 1. Rebuild the MCP server
npm run build

# 2. Check for errors
npm start  # Should start without errors

# 3. Restart VS Code completely

# 4. Try minimal config first
{
  "mcpServers": {
    "test": {
      "command": "node",
      "args": ["/full/path/to/dist/index.js"],
      "env": { "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}" }
    }
  }
}
```

### Problem: "Node.js not found"

**Solution:**
```bash
# Check if installed
node --version  # Should show v18+

# If not, install
# macOS: brew install node
# Ubuntu: sudo apt-get install nodejs
# Windows: https://nodejs.org/

# Verify
node --version
npm --version
```

### Problem: "Port already in use"

**Solution:**
```bash
# If running multiple instances, kill other processes
# macOS/Linux
lsof -i :3000
kill -9 <PID>

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

---

## 📚 VS Code Tips & Tricks

### Keyboard Shortcuts
```
Cmd/Ctrl + K, Cmd/Ctrl + O    Open folder in VS Code
Cmd/Ctrl + Shift + P          Command palette
Cmd/Ctrl + `                  Open terminal
Cmd/Ctrl + /                  Toggle comment
Alt + Shift + F               Format code
```

### Using Terminal in VS Code
```bash
# Terminal always has access to your env vars
# So no need to set API key again if you did it globally

# Just run:
npm run build
npm start

# Or use Python directly:
python3 python/multi_model_orchestrator.py "Your task"
```

### Create Keyboard Shortcut for Orchestrator
1. **File** → **Preferences** → **Keyboard Shortcuts**
2. Search: "ask claude"
3. Assign to: `Cmd/Ctrl + Shift + O` (optional)
4. Now: Select code → `Cmd/Ctrl + Shift + O` → Request orchestration

---

## 🚀 Advanced: Develop MCP Server in VS Code

If you want to **improve** the MCP server itself:

```bash
# Install TypeScript tools
npm install -g typescript

# Run in watch mode during development
npm run build -- --watch

# Or use ts-node
npm install -D ts-node
npx ts-node src/index.ts

# Debug mode
node --inspect dist/index.js
# Then open chrome://inspect
```

---

## 🎯 Example: First Use

### Your First Request
1. **Open Claude Extension** (sidebar)
2. **Type:**
   ```
   Use the multi-model orchestrator to design a blog API:
   - Users can create/read/update/delete posts
   - Support comments on posts
   - Add authentication
   
   Generate the complete architecture and initial code.
   ```

3. **Claude will:**
   - ✅ Call `plan_task` with your requirements
   - ✅ Show detailed plan
   - ✅ Call `implement_code` for each component
   - ✅ Show working implementation
   - ✅ Call `execute_subtask` for tests
   - ✅ Offer to create files in your project

4. **Review and iterate:**
   - Ask for refinements
   - Request tests
   - Add more features

---

## 📖 Next Steps

1. **Complete setup above** ✅
2. **Read GETTING_STARTED.md** for core concepts
3. **Try a simple task** in Claude Extension
4. **Check output in editor** 
5. **Build something great!**

---

## 🔗 Useful Resources

- VS Code docs: https://code.visualstudio.com/docs
- Claude API docs: https://docs.anthropic.com
- GitHub integration: https://docs.github.com/en/get-started
- MCP Spec: https://spec.modelcontextprotocol.io

---

## ✨ Pro Tips

1. **Start simple**: Test with "plan a hello world"
2. **Save your config**: Backup `claude_desktop_config.json`
3. **Use absolute paths**: Avoid path issues
4. **Environment variables**: Keep API key in shell profile
5. **Version control**: Commit your settings to git
6. **Test before committing**: Always verify tools work
7. **Read errors carefully**: They often explain the fix

---

**You're ready to use Multi-Model Orchestrator in VS Code!** 🎉
