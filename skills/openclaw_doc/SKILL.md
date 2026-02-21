---
name: openclaw_doc
description: Answer questions about OpenClaw — installation, configuration, models, tools, skills, channels, and gateway operations. Use this skill when the user asks how to set up or use OpenClaw.
---

# OpenClaw Documentation Reference

Use this skill to answer questions about OpenClaw. Below is a structured summary of the official docs at https://docs.openclaw.ai/.

---

## Getting Started

- Requires Node 22+.
- Install: `curl -fsSL https://openclaw.ai/install.sh | bash` (macOS/Linux) or `iwr -useb https://openclaw.ai/install.ps1 | iex` (Windows PowerShell).
- Run onboarding wizard: `openclaw onboard --install-daemon` — configures auth, gateway, and optional channels.
- Check gateway: `openclaw gateway status`
- Open Control UI: `openclaw dashboard` → http://127.0.0.1:18789/

Key env vars:
- `OPENCLAW_HOME` — home directory for internal path resolution
- `OPENCLAW_STATE_DIR` — override state directory
- `OPENCLAW_CONFIG_PATH` — override config file path

---

## Configuration (`~/.openclaw/openclaw.json`)

Format is JSON5 (comments + trailing commas allowed). All fields optional — safe defaults apply.

### Channels
Each channel starts when its config section exists (unless `enabled: false`).

DM policies: `pairing` (default), `allowlist`, `allow`

Key channels: WhatsApp, Telegram, Discord, Google Chat, Slack, Mattermost, Signal, iMessage.

```json
{
  "channels": {
    "whatsapp": { "allowFrom": ["+15555550123"] },
    "telegram": {}
  }
}
```

### Agent Defaults (`agents.defaults`)
- `workspace` — agent workspace directory (default: `~/.openclaw/workspace`)
- `repoRoot` — repo root for code tools
- `model` — model selection (see Models)
- `heartbeat.every` — proactive heartbeat interval (e.g. `"30m"`, `"0m"` to disable)
- `compaction` — context compaction settings
- `sandbox` — Docker sandbox settings

### Per-agent overrides (`agents.list[]`)
Each entry can override model, tools, workspace, access profiles, etc.

---

## Models

Model selection order: primary → fallbacks → provider auth failover.

Config keys:
- `agents.defaults.model.primary` — e.g. `"anthropic/claude-opus-4-6"`
- `agents.defaults.model.fallbacks` — array of fallback model refs
- `agents.defaults.imageModel` — model used when primary can't accept images
- `agents.defaults.models` — allowlist/catalog + aliases

```json
{
  "agents": {
    "defaults": {
      "model": { "primary": "anthropic/claude-opus-4-6" }
    }
  }
}
```

CLI commands:
- `openclaw models list` — list available models
- `openclaw models status` — show model status
- `/model` — switch model in chat

If `agents.defaults.models` is set, it becomes the allowlist. Selecting a model outside it returns: `Model "provider/model" is not allowed.`

### Providers
Anthropic, OpenAI, OpenRouter, LiteLLM, Amazon Bedrock, Vercel AI Gateway, Moonshot AI, MiniMax, OpenCode Zen, GLM, Z.AI, Qianfan, Venice AI (privacy-first), Ollama (local), vLLM (local), Hugging Face, NVIDIA, Together AI, Cloudflare AI Gateway, Qwen, xAI, Groq, Mistral.

Recommended for privacy: `venice/llama-3.3-70b` (default), `venice/claude-opus-45` (best overall).

---

## Tools

### Disabling / allowing tools
```json
{
  "tools": {
    "deny": ["browser"],
    "allow": ["web_search"]
  }
}
```
Deny wins. `*` wildcard supported.

### Tool profiles (`tools.profile`)
- `minimal` — session_status only
- `coding` — fs, runtime, sessions, memory, image
- `messaging` — messaging, sessions tools
- `full` — no restriction (default)

### Built-in tools
- `exec` / `process` — run shell commands
- `web_search` / `web_fetch` — web access
- `browser` — OpenClaw-managed browser
- `canvas` — canvas UI
- `nodes` — iOS/Android node control
- `image` — image generation/processing
- `cron` — scheduled jobs
- `apply_patch` — apply unified diffs
- `loop-detection` — tool-call loop guardrails
- `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`, `session_status` — session management
- `agents_list` — list agents

### Tool groups (shorthands)
`group:fs`, `group:runtime`, `group:sessions`, `group:memory`, `group:messaging`

---

## Skills

Skills teach the agent how to use tools. Each skill is a directory with a `SKILL.md` file containing YAML frontmatter + instructions.

### Locations (precedence, highest first)
1. `<workspace>/skills`
2. `~/.openclaw/skills`
3. Bundled skills (shipped with install)
4. `skills.load.extraDirs` (lowest)

### SKILL.md format
```yaml
---
name: my-skill
description: What this skill does
---
Instructions here...
```

Optional frontmatter:
- `homepage` — URL shown in macOS Skills UI
- `user-invocable: true|false` — expose as slash command (default: true)
- `disable-model-invocation: true|false` — exclude from model prompt
- `command-dispatch: tool` — slash command bypasses model

### Skills config (`~/.openclaw/openclaw.json`)
```json
{
  "skills": {
    "allowBundled": ["gemini", "peekaboo"],
    "load": {
      "extraDirs": ["~/Projects/my-skills"],
      "watch": true,
      "watchDebounceMs": 250
    },
    "install": {
      "preferBrew": true,
      "nodeManager": "npm"
    },
    "entries": {
      "my-skill": {
        "enabled": true,
        "apiKey": "KEY_HERE",
        "env": { "MY_API_KEY": "KEY_HERE" }
      }
    }
  }
}
```

### ClawHub
Public skills registry at https://clawhub.com.
- `clawhub install <skill-slug>` — install a skill
- `clawhub update --all` — update all skills
- `clawhub sync --all` — sync and publish updates

---

## Platforms

- macOS: menu bar companion app + LaunchAgent service
- Linux: systemd user service (`openclaw-gateway.service`)
- Windows: WSL2 recommended
- iOS / Android: mobile node apps

Gateway service install:
- Wizard: `openclaw onboard --install-daemon`
- Direct: `openclaw gateway install`
- Repair: `openclaw doctor`

VPS hosting: Fly.io, Hetzner (Docker), GCP Compute Engine, exe.dev.

---

## Personal Assistant Setup

Recommended: use a dedicated second phone number for the assistant WhatsApp.

Quick start:
```bash
openclaw channels login      # pair WhatsApp Web (scan QR with assistant phone)
openclaw gateway --port 18789
```

Minimal config:
```json
{
  "channels": {
    "whatsapp": { "allowFrom": ["+15555550123"] }
  }
}
```

Workspace files (auto-created at `~/.openclaw/workspace`):
- `AGENTS.md` — operating instructions
- `SOUL.md` — agent personality
- `TOOLS.md` — tool instructions
- `IDENTITY.md` — agent identity
- `USER.md` — user context
- `HEARTBEAT.md` — heartbeat instructions
- `MEMORY.md` — optional persistent memory

Safety: always set `channels.whatsapp.allowFrom`. Disable heartbeats until trusted: `agents.defaults.heartbeat.every: "0m"`.

---

## Gateway Operations

- `openclaw gateway status` — check status
- `openclaw gateway --port 18789` — run in foreground
- `openclaw gateway install` — install as service
- `openclaw doctor` — diagnose and repair
- `openclaw dashboard` — open Control UI
- `openclaw message send --target +15555550123 --message "Hello"` — send test message

Control UI: http://127.0.0.1:18789/
OpenAI-compatible endpoint available for integrations.

---

## Key Docs URLs

- Getting started: https://docs.openclaw.ai/start/getting-started
- Configuration reference: https://docs.openclaw.ai/gateway/configuration-reference
- Tools: https://docs.openclaw.ai/tools
- Skills: https://docs.openclaw.ai/tools/skills
- Skills config: https://docs.openclaw.ai/tools/skills-config
- Model providers: https://docs.openclaw.ai/providers
- Models CLI: https://docs.openclaw.ai/concepts/models
- Platforms: https://docs.openclaw.ai/platforms
- Personal assistant setup: https://docs.openclaw.ai/start/openclaw
- Docs directory: https://docs.openclaw.ai/start/docs-directory
