#!/usr/bin/env python3
"""
Multi-Model Orchestrator MCP Server

Orchestrates work across Claude models:
- Opus: Planning and strategy
- Sonnet: Implementation and coding
- Haiku: Sub-tasks and quick execution
"""

import anthropic
import json
import sys
from typing import Any

# Initialize Anthropic client
client = anthropic.Anthropic()

# Define the models for different roles
OPUS_MODEL = "claude-opus-4-20250514"
SONNET_MODEL = "claude-sonnet-4-20250514"
HAIKU_MODEL = "claude-haiku-4.5-20241022"


def create_plan(task: str) -> dict:
    """
    Use Opus to create a comprehensive plan for the task.
    """
    print(f"\n🧠 OPUS: Creating plan for task...\n", file=sys.stderr)
    
    response = client.messages.create(
        model=OPUS_MODEL,
        max_tokens=2000,
        system="""You are a strategic planner. Break down complex tasks into detailed, actionable steps.
        
Respond in JSON format with:
{
    "overview": "Brief summary of the task",
    "goals": ["goal1", "goal2", ...],
    "milestones": [
        {
            "title": "Milestone name",
            "description": "What needs to be done",
            "subtasks": ["subtask1", "subtask2"]
        }
    ],
    "dependencies": "Any dependencies or constraints",
    "estimated_effort": "Simple estimate of complexity"
}""",
        messages=[
            {"role": "user", "content": f"Create a detailed plan for: {task}"}
        ]
    )
    
    try:
        plan = json.loads(response.content[0].text)
    except (json.JSONDecodeError, IndexError):
        plan = {"raw_response": response.content[0].text}
    
    return plan


def implement_code(milestone: dict, previous_code: str = "") -> str:
    """
    Use Sonnet to implement code based on the plan.
    """
    print(f"⚙️  SONNET: Implementing {milestone.get('title', 'code')}...\n", file=sys.stderr)
    
    context = f"Previous code:\n{previous_code}\n\n" if previous_code else ""
    subtasks_str = "\n".join([f"- {st}" for st in milestone.get("subtasks", [])])
    
    response = client.messages.create(
        model=SONNET_MODEL,
        max_tokens=3000,
        system="""You are an expert software developer. 
        
Write clean, well-documented code that accomplishes the required tasks.
Focus on production-ready code with proper error handling and comments.""",
        messages=[
            {
                "role": "user",
                "content": f"""Implement the following milestone:

Title: {milestone.get('title', 'Implementation')}
Description: {milestone.get('description', '')}

Subtasks to complete:
{subtasks_str}

{context}

Write the complete, working code implementation."""
            }
        ]
    )
    
    return response.content[0].text


def execute_subtask(subtask: str, context: str = "") -> str:
    """
    Use Haiku to quickly execute a specific subtask.
    """
    print(f"⚡ HAIKU: Executing subtask: {subtask}\n", file=sys.stderr)
    
    response = client.messages.create(
        model=HAIKU_MODEL,
        max_tokens=1000,
        system="""You are a quick, efficient task executor. 
        
Complete the assigned task concisely and accurately.
Provide the result directly without unnecessary explanation.""",
        messages=[
            {
                "role": "user",
                "content": f"""Task: {subtask}

Context: {context if context else 'No additional context'}

Complete this task and provide the result."""
            }
        ]
    )
    
    return response.content[0].text


def orchestrate_task(user_task: str) -> dict:
    """
    Main orchestration function that coordinates all three models.
    """
    print("\n" + "="*60)
    print("🚀 MULTI-MODEL ORCHESTRATOR STARTED")
    print("="*60)
    
    results = {
        "original_task": user_task,
        "plan": None,
        "implementations": [],
        "subtask_results": [],
        "final_summary": None
    }
    
    # Step 1: Opus creates the plan
    print("\n📋 STEP 1: PLANNING PHASE (Opus)")
    plan = create_plan(user_task)
    results["plan"] = plan
    
    # Step 2: Sonnet implements based on milestones
    print("\n📝 STEP 2: IMPLEMENTATION PHASE (Sonnet)")
    previous_code = ""
    
    milestones = plan.get("milestones", [])
    if not milestones and "raw_response" in plan:
        print(f"Plan response:\n{plan['raw_response']}\n")
        milestones = []
    
    for i, milestone in enumerate(milestones, 1):
        code = implement_code(milestone, previous_code)
        results["implementations"].append({
            "milestone": milestone.get("title", f"Milestone {i}"),
            "code": code
        })
        previous_code = code  # Pass code context to next milestone
    
    # Step 3: Haiku executes subtasks in parallel-like fashion
    print("\n⚡ STEP 3: SUBTASK EXECUTION PHASE (Haiku)")
    
    # Extract all subtasks from all milestones
    all_subtasks = []
    for milestone in milestones:
        for subtask in milestone.get("subtasks", []):
            all_subtasks.append(subtask)
    
    # Execute first few subtasks as examples
    for subtask in all_subtasks[:3]:  # Limit to first 3 for demo
        result = execute_subtask(subtask, f"Task: {user_task}")
        results["subtask_results"].append({
            "subtask": subtask,
            "result": result
        })
    
    # Step 4: Generate final summary
    print("\n📊 STEP 4: FINAL SUMMARY")
    summary_prompt = f"""
    Task: {user_task}
    
    Plan created: {json.dumps(plan, indent=2)[:500]}...
    
    Generate a brief executive summary of what was planned, implemented, and executed.
    """
    
    response = client.messages.create(
        model=HAIKU_MODEL,
        max_tokens=500,
        messages=[{"role": "user", "content": summary_prompt}]
    )
    
    results["final_summary"] = response.content[0].text
    
    return results


def format_results(results: dict) -> str:
    """
    Format results for display.
    """
    output = "\n" + "="*60 + "\n"
    output += "📊 ORCHESTRATION RESULTS\n"
    output += "="*60 + "\n\n"
    
    output += f"Task: {results['original_task']}\n\n"
    
    output += "--- PLAN (Opus) ---\n"
    if results['plan']:
        output += json.dumps(results['plan'], indent=2)[:1000] + "\n\n"
    
    output += "--- IMPLEMENTATIONS (Sonnet) ---\n"
    for impl in results['implementations']:
        output += f"\n{impl['milestone']}:\n"
        output += impl['code'][:500] + "...\n"
    
    output += "\n--- SUBTASK RESULTS (Haiku) ---\n"
    for subtask_result in results['subtask_results']:
        output += f"\nSubtask: {subtask_result['subtask']}\n"
        output += f"Result: {subtask_result['result'][:200]}...\n"
    
    output += "\n--- FINAL SUMMARY ---\n"
    output += results['final_summary'] + "\n"
    
    output += "\n" + "="*60 + "\n"
    
    return output


# ==================== MCP TOOLS ====================

def handle_plan_tool(task: str) -> str:
    """MCP tool: Create a plan using Opus"""
    plan = create_plan(task)
    return json.dumps(plan, indent=2)


def handle_code_tool(title: str, description: str, subtasks: list) -> str:
    """MCP tool: Implement code using Sonnet"""
    milestone = {
        "title": title,
        "description": description,
        "subtasks": subtasks
    }
    code = implement_code(milestone)
    return code


def handle_subtask_tool(subtask: str, context: str = "") -> str:
    """MCP tool: Execute subtask using Haiku"""
    return execute_subtask(subtask, context)


def handle_orchestrate_tool(task: str) -> str:
    """MCP tool: Full orchestration across all models"""
    results = orchestrate_task(task)
    return format_results(results)


# ==================== MCP SERVER IMPLEMENTATION ====================

if __name__ == "__main__":
    # Example usage
    if len(sys.argv) > 1:
        user_task = " ".join(sys.argv[1:])
    else:
        user_task = "Build a Python CLI tool for managing project tasks with SQLite backend"
    
    results = orchestrate_task(user_task)
    print(format_results(results))
