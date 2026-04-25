# Multi-Model Orchestrator MCP Server

A sophisticated Model Context Protocol (MCP) server that orchestrates work across Claude models by their strengths:

- **Opus 4**: Strategic planning and architecture
- **Sonnet 4**: Code implementation and engineering
- **Haiku 4.5**: Subtask execution and quick tasks

## 📌 About

**Description:** MCP server orchestrating Claude models with role-based task distribution, planning, implementation, and execution capabilities.

**Tags:** `mcp` `claude` `anthropic` `orchestration` `ai` `typescript` `python`

## 🎯 Architecture

```
User Request
    ↓
[Opus: Planning Phase]  ← Creates detailed plan, goals, milestones
    ↓
[Sonnet: Implementation Phase] ← Writes code based on milestones
    ↓
[Haiku: Execution Phase] ← Executes subtasks in parallel-like fashion
    ↓
Orchestrated Results
```

## 🚀 Quick Start

### 1. Installation

```bash
# Clone or copy the server files
cd multi-model-orchestrator-mcp

# Install dependencies
npm install
```

### 2. Setup Environment

```bash
# Set your Anthropic API key
export ANTHROPIC_API_KEY="your-api-key-here"
```

### 3. Build & Run

#### Option A: Using Node.js (MCP Server Mode)
```bash
npm run build
npm start
```

#### Option B: Using Python (Standalone Script)
```bash
# Install dependencies
pip install anthropic --break-system-packages

# Run directly
python3 multi_model_orchestrator.py "Your task here"
```

## 📋 Tools Available

### 1. `plan_task`
**What**: Use Opus to create a comprehensive plan
**Input**:
```json
{
  "task": "Build a web scraper for news articles"
}
```
**Output**: Structured JSON plan with goals, milestones, and subtasks

### 2. `implement_code`
**What**: Use Sonnet to implement code for a specific milestone
**Input**:
```json
{
  "title": "Core Scraper Engine",
  "description": "Implement the main scraping logic",
  "subtasks": [
    "Create HTTP client with retry logic",
    "Parse HTML with BeautifulSoup",
    "Extract article metadata"
  ],
  "previous_code": "(optional context from prior implementation)"
}
```
**Output**: Production-ready code implementation

### 3. `execute_subtask`
**What**: Use Haiku to quickly execute a single subtask
**Input**:
```json
{
  "subtask": "Create test cases for date parsing",
  "context": "Using Python datetime library"
}
```
**Output**: Immediate subtask results

### 4. `orchestrate_full_task`
**What**: Full end-to-end orchestration (Opus → Sonnet → Haiku)
**Input**:
```json
{
  "task": "Build a Python CLI tool for managing project tasks with SQLite backend"
}
```
**Output**: Complete plan, implementations, and subtask results

## 💡 Usage Examples

### Example 1: Full Orchestration via API

```python
from anthropic import Anthropic

client = Anthropic(api_key="your-key")

response = client.beta.messages.create(
    model="claude-opus-4-20250514",
    max_tokens=4000,
    messages=[{
        "role": "user",
        "content": "Build a Python CLI for managing project tasks with SQLite"
    }],
    mcp_servers=[{
        "type": "url",
        "url": "http://localhost:3000/mcp",  # Your MCP server URL
        "name": "multi-orchestrator"
    }],
    tools=[{
        "type": "mcp_toolset",
        "mcp_server_name": "multi-orchestrator"
    }],
    betas=["mcp-client-2025-11-20"]
)
```

### Example 2: CLI Usage (Python)

```bash
python3 multi_model_orchestrator.py "Build a REST API for a blogging platform"
```

### Example 3: Step-by-Step Orchestration

```python
import sys
sys.path.insert(0, '/path/to/multi_model_orchestrator.py')
from multi_model_orchestrator import (
    create_plan, implement_code, execute_subtask
)

# Step 1: Create plan
plan = create_plan("Build authentication system")

# Step 2: Implement based on milestones
for milestone in plan['milestones']:
    code = implement_code(milestone, "")
    
# Step 3: Execute subtasks
for subtask in plan['goals']:
    result = execute_subtask(subtask, "context here")
```

## 🔧 Configuration

### Setting API Keys

#### Option 1: Environment Variable
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

#### Option 2: In Code (Not Recommended for Production)
```python
import anthropic
client = anthropic.Anthropic(api_key="sk-ant-...")
```

### Customizing Models

Edit the model assignments in `src/index.ts` or `multi_model_orchestrator.py`:

```python
OPUS_MODEL = "claude-opus-4-20250514"      # Planning
SONNET_MODEL = "claude-sonnet-4-20250514"  # Coding
HAIKU_MODEL = "claude-haiku-4.5-20241022"  # Subtasks
```

## 📊 Output Structure

```json
{
  "original_task": "Your task description",
  "plan": {
    "overview": "...",
    "goals": ["..."],
    "milestones": [{
      "title": "...",
      "description": "...",
      "subtasks": ["..."]
    }],
    "timeline": "..."
  },
  "implementations": [{
    "milestone": "...",
    "code": "..."
  }],
  "subtask_results": [{
    "subtask": "...",
    "result": "..."
  }],
  "final_summary": "..."
}
```

## 🎓 How It Works

### 1. Planning Phase (Opus)
- Analyzes the task with strategic thinking
- Breaks it into achievable milestones
- Identifies dependencies and requirements
- Creates a structured roadmap

### 2. Implementation Phase (Sonnet)
- Takes each milestone from the plan
- Writes production-ready code
- Builds on previous implementations for context
- Maintains code quality and consistency

### 3. Execution Phase (Haiku)
- Executes specific subtasks quickly
- Handles quick validation checks
- Performs tests and verification
- Completes auxiliary tasks efficiently

## 🔐 Security Considerations

1. **API Keys**: Never commit `.env` files with real API keys
2. **Rate Limiting**: Implement rate limiting for production use
3. **Token Costs**: Monitor token usage (Opus > Sonnet > Haiku in cost)
4. **Error Handling**: Always wrap MCP calls in try-catch blocks

## 📈 Performance Tips

1. **Reuse Plans**: Create a plan once, use it for multiple implementations
2. **Batch Subtasks**: Group related subtasks for Haiku execution
3. **Stream Responses**: Use streaming for long-running operations
4. **Cache Results**: Store completed plans and implementations

## 🐛 Troubleshooting

### Issue: "ANTHROPIC_API_KEY not found"
```bash
# Solution: Set the environment variable
export ANTHROPIC_API_KEY="your-key-here"
```

### Issue: "Module not found" (TypeScript)
```bash
# Solution: Build first
npm run build
```

### Issue: "Connection timeout" (MCP Server)
- Ensure MCP server is running and accessible
- Check firewall rules
- Verify the URL in mcp_servers configuration

## 📚 References

- [Claude API Documentation](https://docs.claude.com)
- [MCP Specification](https://spec.modelcontextprotocol.io)
- [Anthropic SDK Docs](https://github.com/anthropics/anthropic-sdk-python)

## 📄 License

MIT

## 🤝 Contributing

Contributions welcome! Please submit issues and PRs.

---

**Made for intelligent task orchestration across Claude models** 🚀
