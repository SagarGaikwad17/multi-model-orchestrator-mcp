# Quick Start Guide: Multi-Model Orchestrator

## 5-Minute Setup

### 1. Prerequisites
- Node.js 18+ (for MCP server) OR Python 3.8+
- Anthropic API key: https://console.anthropic.com
- npm or pip

### 2. Clone Files
```bash
git clone <repo> multi-model-orchestrator-mcp
cd multi-model-orchestrator-mcp
```

### 3. Setup
```bash
# For Node.js MCP Server
npm install
npm run build

# OR for Python standalone
pip install anthropic --break-system-packages
```

### 4. Configure API Key
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### 5. Run

**Option A - MCP Server (integrate with Claude Desktop/API):**
```bash
npm start
```

**Option B - Standalone Python:**
```bash
python3 multi_model_orchestrator.py "Build a REST API for a blogging platform"
```

---

## Real-World Examples

### Example 1: Build a Web Scraper

**Input:**
```
Task: Build a Python web scraper for news articles with error handling
```

**What Happens:**
1. **Opus** creates plan:
   - Parse HTML with BeautifulSoup
   - Implement retry logic with exponential backoff
   - Create database schema for articles
   - Build CLI interface
   - Write unit tests

2. **Sonnet** implements:
   - Writes BeautifulSoup-based scraper class
   - Adds requests library with session management
   - Creates SQLite database models
   - Implements error handling

3. **Haiku** executes:
   - Tests HTML parsing
   - Validates error handling
   - Checks database connections

---

### Example 2: Build a CLI Tool

**Using Python directly:**
```bash
python3 multi_model_orchestrator.py "Create a task management CLI using Click and SQLite"
```

**Step by step output:**
```
🧠 OPUS: Planning the architecture...
  ├─ Goal: Create interactive CLI
  ├─ Goal: Persistent data storage
  ├─ Goal: User-friendly interface
  └─ Milestones:
     ├─ Setup Click framework
     ├─ Implement task model
     └─ Add SQLite persistence

⚙️  SONNET: Writing implementation code...
  ├─ Click command structure
  ├─ Database models with SQLAlchemy
  └─ CRUD operations

⚡ HAIKU: Testing subtasks...
  ├─ Validate task creation
  ├─ Test list functionality
  └─ Verify persistence
```

---

### Example 3: Using with Claude API

**Python code:**
```python
from anthropic import Anthropic

client = Anthropic()

response = client.beta.messages.create(
    model="claude-opus-4-20250514",
    max_tokens=4000,
    messages=[{
        "role": "user",
        "content": """
        Use the multi-model-orchestrator to:
        1. Plan a user authentication system
        2. Implement password hashing with bcrypt
        3. Create test cases for login flow
        
        Task: Build a secure user authentication module
        """
    }],
    mcp_servers=[{
        "type": "url",
        "url": "http://localhost:3000/mcp",
        "name": "orchestrator"
    }],
    tools=[{
        "type": "mcp_toolset",
        "mcp_server_name": "orchestrator"
    }],
    betas=["mcp-client-2025-11-20"]
)

print(response.content[0].text)
```

---

### Example 4: Step-by-Step Control

**When you want fine-grained control:**

```python
from multi_model_orchestrator import (
    create_plan,
    implement_code,
    execute_subtask,
    orchestrate_task
)

# Just planning
task = "Build a data pipeline"
plan = create_plan(task)
print(plan)

# Just implementation
milestone = {
    "title": "Data Validation",
    "description": "Validate incoming data",
    "subtasks": ["Check schema", "Validate types", "Handle nulls"]
}
code = implement_code(milestone)

# Just subtask
result = execute_subtask(
    "Write unit tests for validator",
    context="Using pytest"
)

# Full orchestration
results = orchestrate_task(task)
```

---

## Integration Examples

### With Claude Desktop

1. **Edit config file:**
   ```bash
   # On Mac/Linux:
   ~/.config/Claude/claude_desktop_config.json
   
   # On Windows:
   %APPDATA%\Claude\claude_desktop_config.json
   ```

2. **Add this section:**
   ```json
   {
     "mcpServers": {
       "multi-orchestrator": {
         "command": "node",
         "args": ["/path/to/dist/index.js"],
         "env": {
           "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}"
         }
       }
     }
   }
   ```

3. **Restart Claude Desktop**

4. **Use in chat:**
   ```
   User: Use the orchestrator to build a REST API

   Claude will now have access to:
   - plan_task
   - implement_code
   - execute_subtask
   - orchestrate_full_task
   ```

---

## Common Use Cases

### 1. Build Complex Software
```
Task → Opus Plans → Sonnet Codes → Haiku Tests
```

### 2. Generate Documentation
```
Code → Opus Analyzes → Sonnet Writes Docs → Haiku Validates
```

### 3. Refactor Legacy Code
```
Old Code → Opus Plans Refactor → Sonnet Implements → Haiku Validates
```

### 4. Create Project Templates
```
Requirements → Opus Plans Structure → Sonnet Generates Files → Haiku Tests
```

---

## Performance Expectations

| Task | Planning | Implementation | Execution | Total |
|------|----------|-----------------|-----------|-------|
| Simple script | 2-3s | 3-5s | 1-2s | 6-10s |
| Medium project | 5-10s | 10-20s | 3-5s | 18-35s |
| Complex system | 10-20s | 20-40s | 5-10s | 35-70s |

*Estimates based on API response times*

---

## Cost Optimization Tips

1. **Reuse Plans**: Don't replan identical tasks
2. **Batch Operations**: Group similar subtasks for Haiku
3. **Token Limits**: Set reasonable max_tokens for each model
4. **Cache Results**: Store and reuse successful implementations

**Cost Comparison (per 1M tokens):**
- Opus: ~$15
- Sonnet: ~$3
- Haiku: ~$0.80

---

## Troubleshooting Checklist

- [ ] API key set? `echo $ANTHROPIC_API_KEY`
- [ ] Dependencies installed? `npm install` or `pip install`
- [ ] Built TypeScript? `npm run build`
- [ ] Node.js version? `node --version` (need 18+)
- [ ] Port available? Check `lsof -i :3000`
- [ ] Network access? Test with `curl https://api.anthropic.com`

---

## Next Steps

1. **Try standalone**: Run `python3 multi_model_orchestrator.py "your task"`
2. **Build it**: Run `npm run build` for TypeScript version
3. **Integrate**: Add to Claude Desktop config
4. **Customize**: Edit model selections in config
5. **Deploy**: Host MCP server for team usage

---

## Support

- Docs: See README.md
- Issues: Check troubleshooting section
- Examples: Look at examples/ folder
- API Docs: https://docs.anthropic.com

Happy orchestrating! 🚀
