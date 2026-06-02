#!/bin/bash
cd ~/chief-of-staff

# Load bot token so the local Slack MCP server posts as Chief of Staff APP
set -a
source .env
set +a

/Users/YOUR_USERNAME/.local/bin/claude -p --dangerously-skip-permissions \
  "Check #cos-updates channel (YOUR_COS_UPDATES_CHANNEL_ID) for any recent messages from the user (not from the Chief of Staff bot) that look like commands. Handle two types:

---

TYPE 1 — SHEET UPDATES
Commands like: 'done AI-007', 'mark AI-001 as in progress', 'snooze AI-003 until next week', 'CI-004 Posted', 'add action item: follow up with recruiter at X company by Friday'.

For each command:
1. Interpret what needs to change (status update, snooze, new item, reprioritization, etc.)
2. Update the Google Sheet via the Apps Script webhook using the two-step curl pattern — Apps Script returns a 302 redirect and curl -L silently converts POST to GET and fails. Always capture the Location header and GET it:

   LOCATION=\$(curl -s -D - -X POST \\
     -H 'Content-Type: application/json' \\
     -d '<payload>' \\
     'YOUR_APPS_SCRIPT_WEBHOOK_URL' \\
     | grep -i '^location:' | tr -d '\r' | awk '{print \$2}') && curl -s \"\$LOCATION\"

   For AI- IDs: use action 'update' — e.g. {\"action\":\"update\",\"id\":\"AI-006\",\"status\":\"Done\",\"completed_date\":\"YYYY-MM-DD\"}
   For CI- IDs: use action 'update_content_idea' — e.g. {\"action\":\"update_content_idea\",\"id\":\"CI-004\",\"status\":\"Posted\",\"post_date\":\"YYYY-MM-DD\"}

3. Post a brief confirmation back to #cos-updates using mcp__slack__slack_post_message (NOT mcp__claude_ai_Slack).

---

TYPE 2 — MEETING PROCESSING
Commands matching: 'process [meeting name]' (e.g. 'process Team Standup', 'process client call')

For each meeting processing command:
1. Search Granola for the meeting by name. If multiple matches, use the most recent.
2. Read the full meeting transcript/notes.
3. Extract all action items from the meeting. For each, POST to the webhook (same two-step curl pattern):
   {\"action_item\": \"...\", \"source\": \"Meeting: [meeting name]\", \"source_date\": \"YYYY-MM-DD\", \"goal\": \"[goal tag]\", \"priority\": \"[High|Medium|Low]\", \"status\": \"Open\", \"due_date\": \"YYYY-MM-DD or blank\", \"content_flag\": \"[Yes|No]\"}
   POST as a JSON array of action item objects.
4. Identify content-worthy moments — non-obvious insights, decisions with interesting tradeoffs, or moments worth a post. For each, POST to the webhook:
   {\"action\": \"content_idea\", \"id\": \"CI-[next]\", \"source\": \"Meeting: [meeting name]\", \"source_date\": \"YYYY-MM-DD\", \"idea_angle\": \"...\", \"hook\": \"...\"}
   Only flag moments that are genuinely interesting. Skip if nothing qualifies.
5. Post a summary to #cos-updates via mcp__slack__slack_post_message (NOT mcp__claude_ai_Slack) in this format:
   ✅ Processed: [Meeting Name] ([date])
   [N] action items added → Sheet
   [N] content ideas flagged (or 'No content ideas flagged')
   [2-3 sentence summary of what the meeting covered and what's now on the list]

---

If no commands of either type are found, do nothing and exit silently.

Only process messages that do not already have a checkmark confirmation reply following them."
