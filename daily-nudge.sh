#!/bin/bash
export PATH="/Users/YOUR_USERNAME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
cd ~/chief-of-staff

# Once-per-day guard — exit if nudge already ran today
GUARD_FILE="$HOME/chief-of-staff/logs/last-nudge-date.txt"
TODAY=$(date +%Y-%m-%d)
if [ -f "$GUARD_FILE" ] && [ "$(cat "$GUARD_FILE")" = "$TODAY" ]; then
    echo "Nudge already ran today ($TODAY). Exiting."
    exit 0
fi
echo "$TODAY" > "$GUARD_FILE"

# Run command processor first so brain-dump is processed before the Sheet is read.
# Runs synchronously — nudge waits for it to finish before proceeding.
# If it errors, log and continue so the nudge still fires.
/path/to/chief-of-staff/process-commands.sh
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]; then
    echo "Warning: command processor exited with code $CMD_EXIT. Proceeding with nudge." >&2
fi

# Load bot token so the local Slack MCP server posts as Chief of Staff APP
set -a
source .env
set +a

/Users/YOUR_USERNAME/.local/bin/claude -p --dangerously-skip-permissions "Run the daily nudge:

1) Scan #brain-dump channel (YOUR_BRAIN_DUMP_CHANNEL_ID) for new entries. For each message: route action items to the Action Items tab via webhook and content ideas/observations to the Content Ideas tab.

2) Read the Google Sheet (all rows with Status = Open or In Progress).

3) Post the daily nudge to #cos-updates (YOUR_COS_UPDATES_CHANNEL_ID) using EXACTLY the format defined in the 'Daily Nudge Format' section of CLAUDE.md. Key rules:
   - Use Slack mrkdwn only — NO markdown pipe tables (| col | col | rows). Tables render as raw text in Slack.
   - Items are bullets with inline context woven into sentences, not columns
   - Priority dots (🔴 🟡 🟢) go at the end of each bullet
   - Bold blockers inline: *Blocked by AI-001 + AI-002.*
   - Include the Analysis section at the bottom — synthesize across all goals, name the highest-leverage action, call out what's slipping

IMPORTANT: post using mcp__slack__slack_post_message (local Slack MCP with bot token) — do NOT use mcp__claude_ai_Slack tools."
