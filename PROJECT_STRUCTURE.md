# Multi-Model Orchestrator MCP - Project Structure

## 📁 Directory Layout

```
multi-model-orchestrator-mcp/
├── README.md                          # Complete documentation
├── QUICKSTART.md                      # 5-minute setup guide
├── package.json                       # Node.js dependencies
├── tsconfig.json                      # TypeScript configuration
├── multi_model_orchestrator.py        # Standalone Python version
├── claude_desktop_config_example.json # Config template for Claude Desktop
│
├── src/
│   └── index.ts                       # MCP Server (TypeScript/Node.js)
│
└── dist/
    └── index.js                       # Compiled MCP Server
```

## 📄 File Descriptions

### Core Implementation Files

#### `multi_model_orchestrator.py`
- **Purpose**: Standalone Python implementation
- **Models Used**: 
  - Opus: Planning
  - Sonnet: Implementation
  - Haiku: Subtask execution
- **Usage**: `python3 multi_model_orchestrator.py "your task"`
- **Features**:
  - No dependencies except `anthropic`
  - Direct API calls
  - JSON response formatting
  - Step-by-step orchestration

#### `src/index.ts`
- **Purpose**: MCP Server implementation (TypeScript)
- **Transport**: Stdio-based (for Claude Desktop/Code)
- **Tools Exposed**:
  - `plan_task` - Opus planning
  - `implement_code` - Sonnet coding
  - `execute_subtask` - Haiku execution
  - `orchestrate_full_task` - Full pipeline
- **Features**:
  - MCP protocol compliant
  - Tool calling interface
  - Error handling
  - Streaming support

### Configuration Files

#### `package.json`
```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "anthropic": "^0.29.0"
  },
  "scripts": {
    "build": "tsc",
    "dev": "ts-node src/index.ts",
    "start": "node dist/index.js"
  }
}
```

#### `tsconfig.json`
- TypeScript compilation settings
- Target: ES2020
- Module: ESNext
- Output: dist/index.js

#### `claude_desktop_config_example.json`
```json
{
  "mcpServers": {
    "multi-model-orchestrator": {
      "command": "node",
      "args": ["/path/to/dist/index.js"],
      "env": {
        "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

### Documentation

#### `README.md` (Complete Guide)
- Architecture overview
- Installation steps
- Tool descriptions with examples
- Usage examples (API and CLI)
- Configuration options
- Troubleshooting
- Performance tips
- References

#### `QUICKSTART.md` (5-Minute Setup)
- Quick setup (5 steps)
- Real-world examples
- Integration examples
- Common use cases
- Performance expectations
- Cost optimization tips
- Troubleshooting checklist

## 🔄 Data Flow

```
User Task
   ↓
[OPUS MODEL]
- Analyzes task
- Creates structured plan
- Identifies milestones
- Outputs: JSON plan
   ↓
[SONNET MODEL]
- Processes each milestone
- Writes code
- Maintains context
- Outputs: Production code
   ↓
[HAIKU MODEL]
- Executes subtasks
- Quick validation
- Parallel-like execution
- Outputs: Results
   ↓
Formatted Results
```

## 🚀 Deployment Options

### Option 1: Local Standalone (Easiest)
```bash
python3 multi_model_orchestrator.py "Build a web scraper"
```
- Direct Python script
- No server needed
- Immediate results
- Best for testing

### Option 2: MCP Server (Claude Integration)
```bash
npm install
npm run build
npm start
```
- Integrates with Claude Desktop
- Integrates with Claude API
- Reusable server
- Multiple concurrent requests

### Option 3: Remote Server (Production)
```bash
# Deploy to cloud (AWS, GCP, Azure)
# Run MCP server behind HTTP/SSE endpoint
# Connect via Claude API with mcp_servers parameter
```

## 📊 Model Distribution

| Model | Role | Max Tokens | Cost/1M | Best For |
|-------|------|-----------|---------|----------|
| Opus | Planning | 2000 | ~$15 | Strategy, architecture |
| Sonnet | Coding | 3000 | ~$3 | Implementation, detailed work |
| Haiku | Execution | 1000 | ~$0.80 | Quick tasks, tests |

## 🔑 Environment Variables

```bash
ANTHROPIC_API_KEY  # Required: Your Anthropic API key
DEBUG              # Optional: Enable debug logging
MAX_RETRIES        # Optional: API retry attempts
TIMEOUT            # Optional: Request timeout in seconds
```

## 🎯 Use Cases

### 1. Software Development
- Plan architecture (Opus)
- Write implementation (Sonnet)
- Run tests (Haiku)

### 2. Documentation
- Plan structure (Opus)
- Write content (Sonnet)
- Validate format (Haiku)

### 3. Content Creation
- Plan structure (Opus)
- Write content (Sonnet)
- Proofread (Haiku)

### 4. Data Processing
- Plan pipeline (Opus)
- Implement processors (Sonnet)
- Execute jobs (Haiku)

## 🔐 Security Notes

1. **Never commit API keys**
   - Use environment variables
   - Use .gitignore
   - Use secrets management

2. **Rate limiting**
   - Implement per-user limits
   - Monitor token usage
   - Set request timeouts

3. **Error handling**
   - Wrap all API calls in try-catch
   - Log errors securely
   - Never expose API keys in errors

## 📈 Performance Metrics

### Token Usage Estimates
- Simple task: 1-3K tokens
- Medium task: 5-10K tokens
- Complex task: 10-20K tokens

### Response Times
- Planning: 2-10s
- Implementation: 5-40s
- Subtasks: 1-5s per subtask

## 🛠️ Customization Options

### Change Models
Edit model IDs in `src/index.ts` or Python file

### Change Max Tokens
Adjust `max_tokens` parameter per model

### Add Custom Tools
Extend tool list in `server.setRequestHandler`

### Change Planning Format
Modify system prompts in tool functions

## 📚 Key APIs Used

The MCP connector in Claude API enables you to connect to remote MCP servers directly from the Messages API. It supports passing authorization tokens, tool configuration, and requires the beta header "anthropic-beta": "mcp-client-2025-11-20".

### Core Models (2025)
- `claude-opus-4-20250514` - Strategic thinking
- `claude-sonnet-4-20250514` - Fast implementation
- `claude-haiku-4.5-20241022` - Quick execution

### Tool Calling
The Messages API supports mcp_tool_use blocks that show the tool being invoked with its parameters, and mcp_tool_result blocks that contain the actual data returned from the MCP server.

## 🔗 Dependencies

```
Node.js/TypeScript Stack:
├── @modelcontextprotocol/sdk (MCP protocol)
├── anthropic (Claude API SDK)
└── typescript

Python Stack:
└── anthropic (Claude API SDK)
```

## 📋 Checklist for Deployment

- [ ] Clone/copy all files
- [ ] Set ANTHROPIC_API_KEY
- [ ] Run `npm install` (for Node.js)
- [ ] Run `npm run build` (compile TypeScript)
- [ ] Test: `python3 multi_model_orchestrator.py "test task"`
- [ ] Test: `npm start` (run MCP server)
- [ ] Configure Claude Desktop (optional)
- [ ] Monitor token usage
- [ ] Set up logging
- [ ] Document customizations

## 🎓 Learning Path

1. **Start**: Read QUICKSTART.md (5 min)
2. **Try**: Run Python version (2 min)
3. **Understand**: Review README.md (10 min)
4. **Build**: Customize for your use case (varies)
5. **Deploy**: Set up MCP server or cloud instance (varies)

---

**Total Setup Time**: 15-30 minutes ⏱️
**Value**: Intelligent multi-model task orchestration 🚀
