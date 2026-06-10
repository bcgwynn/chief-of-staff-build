#!/bin/bash
export PATH="/Users/YOUR_USERNAME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
cd ~/chief-of-staff

# Once-per-day guard for login-triggered morning run (before noon only)
# Noon and 4pm calendar runs are not guarded — they should always fire.
HOUR=$(date +%H)
if [ "$HOUR" -lt 12 ]; then
    GUARD_FILE="$HOME/chief-of-staff/logs/last-commands-morning-date.txt"
    TODAY=$(date +%Y-%m-%d)
    if [ -f "$GUARD_FILE" ] && [ "$(cat "$GUARD_FILE")" = "$TODAY" ]; then
        echo "Morning command processor already ran today ($TODAY). Exiting."
        exit 0
    fi
    echo "$TODAY" > "$GUARD_FILE"
fi

# Load bot token so the local Slack MCP server posts as Chief of Staff APP
set -a
source .env
set +a

/Users/YOUR_USERNAME/.local/bin/claude -p --dangerously-skip-permissions \
  "Check #cos-updates channel (YOUR_COS_UPDATES_CHANNEL_ID) for any recent messages from the user (not from the Chief of Staff bot) that look like commands. Handle three types:

---

TYPE 1 — SHEET UPDATES
Commands like: 'done AI-007', 'mark AI-001 as in progress', 'snooze AI-003 until next week', 'CI-004 Posted', 'add action item: follow up on the contractor quote by Friday'.

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

TYPE 3 — PROGRESS UPDATES
Messages that mention an AI- item ID (e.g. 'AI-014') but aren't explicit TYPE 1 commands — natural-language updates on what's happening with that item. Examples: 'AI-014 called the contractor, scheduled for next Tuesday', 'AI-009 blocked by waiting on city permit approval', 'AI-021 haven't started yet'. If a message clearly matches a TYPE 1 command pattern, handle it under TYPE 1 instead.

If the message mentions multiple AI- IDs, classify and update each one independently — do not apply one classification to the whole message. If the message describes each ID differently (e.g. 'AI-014 done, AI-015 still waiting on permit'), classify each ID from its own clause/context. If the same update applies to all IDs (e.g. 'AI-014 and AI-015 both blocked by the contractor's quote'), apply that classification to each, sending a separate payload per ID.

For each ID, classify against these categories in order — first match wins — and update the Sheet via the webhook (action 'update', same two-step curl pattern as TYPE 1):

1. DONE — message contains 'done', 'complete', or 'finished':
   {\"action\":\"update\",\"id\":\"AI-xxx\",\"status\":\"Done\",\"completed_date\":\"YYYY-MM-DD\"} (today's date)

2. BLOCKED — message contains 'blocked by', 'waiting on', or 'blocked until':
   Extract the reason that follows the trigger phrase as blocked_by.
   {\"action\":\"update\",\"id\":\"AI-xxx\",\"status\":\"Blocked\",\"blocked_by\":\"<extracted reason>\"}

3. NOT STARTED — message contains 'not started', 'haven't started', or 'not begun':
   {\"action\":\"update\",\"id\":\"AI-xxx\",\"status\":\"Not Started\",\"notes\":\"<message text>\"}

4. ACTIVE MOVEMENT — message contains a progress verb: ordered, scheduled, called, sent, submitted, booked, signed, filed, paid, installed, completed, started, began, working on:
   {\"action\":\"update\",\"id\":\"AI-xxx\",\"status\":\"In Progress\",\"notes\":\"<full message text>\"}

5. NEUTRAL/UNRECOGNIZED — anything else mentioning an AI- ID:
   {\"action\":\"update\",\"id\":\"AI-xxx\",\"notes\":\"<message text>\"} (omit the status field — leave status unchanged)

Note: the live Apps Script auto-prepends a [Mon DD] date stamp and appends to existing Notes content with ' / ' as a separator. Send only the raw message text in 'notes' — do not add your own date stamp.

After updating, post a brief confirmation to #cos-updates using mcp__slack__slack_post_message (NOT mcp__claude_ai_Slack) stating the ID and what changed.

---

If no commands of any type are found, do nothing and exit silently.

Only process messages that do not already have a checkmark confirmation reply following them."
