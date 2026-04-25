import Anthropic from "@anthropic-ai/sdk";
import {
  Server,
  Tool,
  TextContent,
  CallToolRequest,
  CallToolResult,
} from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

// Model assignments
const OPUS_MODEL = "claude-opus-4-20250514";
const SONNET_MODEL = "claude-sonnet-4-20250514";
const HAIKU_MODEL = "claude-haiku-4.5-20241022";

// ==================== PLANNING (OPUS) ====================
async function createPlan(task: string): Promise<string> {
  console.error(`[OPUS] Creating plan for: ${task}`);

  const response = await client.messages.create({
    model: OPUS_MODEL,
    max_tokens: 2000,
    system: `You are a strategic planner. Break down complex tasks into detailed, actionable steps.

Respond in JSON format with:
{
    "overview": "Brief summary of the task",
    "goals": ["goal1", "goal2"],
    "milestones": [
        {
            "title": "Milestone name",
            "description": "What needs to be done",
            "subtasks": ["subtask1", "subtask2"]
        }
    ],
    "dependencies": "Any dependencies",
    "timeline": "Estimated timeline"
}`,
    messages: [
      {
        role: "user",
        content: `Create a detailed plan for: ${task}`,
      },
    ],
  });

  const textContent = response.content.find((c) => c.type === "text");
  return textContent && textContent.type === "text" ? textContent.text : "";
}

// ==================== IMPLEMENTATION (SONNET) ====================
async function implementCode(
  title: string,
  description: string,
  subtasks: string[],
  previousCode: string = ""
): Promise<string> {
  console.error(`[SONNET] Implementing: ${title}`);

  const context = previousCode ? `Previous code:\n${previousCode}\n\n` : "";
  const subtasksStr = subtasks.map((st) => `- ${st}`).join("\n");

  const response = await client.messages.create({
    model: SONNET_MODEL,
    max_tokens: 3000,
    system: `You are an expert software developer.
Write clean, well-documented code that accomplishes the required tasks.
Focus on production-ready code with proper error handling.`,
    messages: [
      {
        role: "user",
        content: `Implement the following milestone:

Title: ${title}
Description: ${description}

Subtasks:
${subtasksStr}

${context}

Write the complete, working code.`,
      },
    ],
  });

  const textContent = response.content.find((c) => c.type === "text");
  return textContent && textContent.type === "text" ? textContent.text : "";
}

// ==================== SUBTASK EXECUTION (HAIKU) ====================
async function executeSubtask(subtask: string, context: string = ""): Promise<string> {
  console.error(`[HAIKU] Executing: ${subtask}`);

  const response = await client.messages.create({
    model: HAIKU_MODEL,
    max_tokens: 1000,
    system: `You are a quick, efficient task executor.
Complete the assigned task concisely and accurately.
Provide the result directly.`,
    messages: [
      {
        role: "user",
        content: `Task: ${subtask}

Context: ${context || "No additional context"}

Complete this task.`,
      },
    ],
  });

  const textContent = response.content.find((c) => c.type === "text");
  return textContent && textContent.type === "text" ? textContent.text : "";
}

// ==================== ORCHESTRATION ====================
async function orchestrateTask(task: string): Promise<string> {
  console.error("\n=== ORCHESTRATION STARTED ===\n");

  const results: {
    plan?: string;
    implementations: Array<{ title: string; code: string }>;
    subtasks: Array<{ task: string; result: string }>;
  } = {
    implementations: [],
    subtasks: [],
  };

  // Step 1: Plan with Opus
  console.error("📋 STEP 1: Planning with Opus");
  const plan = await createPlan(task);
  results.plan = plan;

  let planData: {
    milestones?: Array<{
      title: string;
      description: string;
      subtasks: string[];
    }>;
  } = {};
  try {
    planData = JSON.parse(plan);
  } catch {
    console.error("Note: Could not parse plan as JSON");
  }

  // Step 2: Implement with Sonnet
  console.error("⚙️  STEP 2: Implementation with Sonnet");
  let previousCode = "";
  const milestones = planData.milestones || [];

  for (const milestone of milestones.slice(0, 2)) {
    const code = await implementCode(
      milestone.title,
      milestone.description,
      milestone.subtasks,
      previousCode
    );
    results.implementations.push({
      title: milestone.title,
      code,
    });
    previousCode = code;
  }

  // Step 3: Execute subtasks with Haiku
  console.error("⚡ STEP 3: Subtask execution with Haiku");
  const allSubtasks = milestones.flatMap((m) => m.subtasks || []);

  for (const subtask of allSubtasks.slice(0, 3)) {
    const result = await executeSubtask(subtask, task);
    results.subtasks.push({
      task: subtask,
      result,
    });
  }

  // Format results
  let output = "\n=== ORCHESTRATION RESULTS ===\n\n";
  output += `Original Task: ${task}\n\n`;

  output += "--- PLAN (Opus) ---\n";
  output += plan.substring(0, 500) + "...\n\n";

  output += "--- IMPLEMENTATIONS (Sonnet) ---\n";
  for (const impl of results.implementations) {
    output += `\n${impl.title}:\n`;
    output += impl.code.substring(0, 300) + "...\n";
  }

  output += "\n--- SUBTASKS (Haiku) ---\n";
  for (const subtask of results.subtasks) {
    output += `\n${subtask.task}:\n`;
    output += subtask.result.substring(0, 200) + "...\n";
  }

  return output;
}

// ==================== MCP SERVER ====================
const server = new Server({
  name: "multi-model-orchestrator",
  version: "1.0.0",
});

// Define tools
const tools: Tool[] = [
  {
    name: "plan_task",
    description: "Use Opus to create a comprehensive plan for a task",
    inputSchema: {
      type: "object" as const,
      properties: {
        task: {
          type: "string",
          description: "The task to plan",
        },
      },
      required: ["task"],
    },
  },
  {
    name: "implement_code",
    description: "Use Sonnet to implement code for a milestone",
    inputSchema: {
      type: "object" as const,
      properties: {
        title: {
          type: "string",
          description: "Milestone title",
        },
        description: {
          type: "string",
          description: "Milestone description",
        },
        subtasks: {
          type: "array",
          items: { type: "string" },
          description: "List of subtasks",
        },
        previous_code: {
          type: "string",
          description: "Previous code for context (optional)",
        },
      },
      required: ["title", "description", "subtasks"],
    },
  },
  {
    name: "execute_subtask",
    description: "Use Haiku to quickly execute a subtask",
    inputSchema: {
      type: "object" as const,
      properties: {
        subtask: {
          type: "string",
          description: "The subtask to execute",
        },
        context: {
          type: "string",
          description: "Additional context (optional)",
        },
      },
      required: ["subtask"],
    },
  },
  {
    name: "orchestrate_full_task",
    description:
      "Full orchestration: Opus plans, Sonnet codes, Haiku executes subtasks",
    inputSchema: {
      type: "object" as const,
      properties: {
        task: {
          type: "string",
          description: "The task to orchestrate",
        },
      },
      required: ["task"],
    },
  },
];

// Register tools
server.setRequestHandler(
  "tools/list" as any,
  async () => ({
    tools,
  })
);

// Handle tool calls
server.setRequestHandler(
  "tools/call" as any,
  async (request: CallToolRequest) => {
    const { name, arguments: args } = request;

    try {
      let result: string;

      switch (name) {
        case "plan_task":
          result = await createPlan((args as any).task);
          break;
        case "implement_code":
          result = await implementCode(
            (args as any).title,
            (args as any).description,
            (args as any).subtasks,
            (args as any).previous_code || ""
          );
          break;
        case "execute_subtask":
          result = await executeSubtask(
            (args as any).subtask,
            (args as any).context || ""
          );
          break;
        case "orchestrate_full_task":
          result = await orchestrateTask((args as any).task);
          break;
        default:
          throw new Error(`Unknown tool: ${name}`);
      }

      return {
        content: [
          {
            type: "text",
            text: result,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: "text",
            text: `Error: ${error instanceof Error ? error.message : String(error)}`,
          },
        ],
        isError: true,
      };
    }
  }
);

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
console.error("Multi-Model Orchestrator MCP Server started");
