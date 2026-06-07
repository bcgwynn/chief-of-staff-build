# Agentic Chief of Staff — Project Brief

## Outcomes (next few months)

1. **Land a PM role** — actively applying/interviewing for consumer product roles. Highest priority. Strong existing PM track record; need to demonstrate current sharpness and AI fluency.
2. **Build a public presence on LinkedIn** — post 2x/week. Topics: AI builds, work-life integration, product teardowns, lessons/insights. Inspiration sourced from Granola meeting notes and Slack brain dump channel.
3. **Systematize DDC consulting** — currently 2-4 hrs/month. Needs a lightweight repeatable process. Parked until the chief of staff can handle it as a workflow.

## Active Workstreams

- **PM job search:** applications, networking, interview prep, follow-ups (tracked in separate spreadsheet, not in CoS v1)
- **WDAI build:** the agentic chief of staff — this is the primary build project AND the "build in public" subject
- **LinkedIn content:** chief of staff surfaces raw ideas from Granola + brain dump channel weekly; I shape and publish. **Commitment: 1 post per WDAI session (6 minimum) documenting the build journey — decisions, tradeoffs, failures.**
- **DDC consulting:** occasional client work, systematization deferred


## Core Problem the Chief of Staff Solves

Scattered notes (Apple Notes, Granola, Google Docs), no reliable system for resurfacing action items or follow-ups. Things get captured but not completed. LinkedIn content ideas are buried in the same scattered notes.

## Tools Ecosystem

| Tool | Role |
|------|------|
| Google Calendar | Primary calendar (Apple Calendar syncs to it). CoS has write access for deadline reminders only |
| Espa.ai | Email drafting and calendar management — chief of staff does NOT duplicate this |
| Granola | Meeting notes — primary source for action items and LinkedIn content ideas |
| Slack | Three roles: (1) delivery channel for CoS nudges + meeting summaries, (2) brain dump channel for non-meeting captures (temporary — processed daily), (3) daily communication |
| Google Sheets | Persistent action item store with completion statuses. Also permanent archive for brain dump items. Tagged to goals |
| Google Docs/Drive | Documents, shared files, and this project brief |
| Spreadsheet (separate) | PM job application tracking — not integrated in v1 |

## Time Budget

25-35 hours/week across everything.

---

## Architecture Decisions

### Decided

- **Entry point:** text-based (not voice)
- **Espa owns calendar + email** — chief of staff stays out of that lane
- **Chief of staff's lane:** action items, follow-ups, project tracking, content idea surfacing
- **Push, not pull** — the system proactively nudges; it doesn't wait to be asked
- **Delivery channel:** Slack (lowest friction to start)
- **Architecture direction:** Claude Code or hybrid — pure Projects can't push
- **No separate personal OS** — the chief of staff IS the personal OS
- **No content calendar yet** — weekly scan-and-pick ritual first
- **DDC systematization parked** — becomes one of the chief of staff's first real workflows
- **Completion tracking:** Yes — system tracks done vs. not done
- **Persistent store:** Google Sheet for action items with statuses, tagged to goals
- **Calendar integration:** Write-only — CoS creates calendar events when action items have deadlines/follow-up dates. Does not manage schedule (that's Espa)
- **Non-meeting capture:** Slack brain dump channel for quick capture. CoS processes daily and moves valuable items to Google Sheet. Slack is the inbox, Sheet is the filing cabinet (free Slack has 90-day history limit, so nothing valuable stays only in Slack)
- **Job tracking spreadsheet:** Not integrated in v1 — managed separately
- **Content idea approach:** Claude surfaces raw ideas only (not drafts). Filters for genuinely interesting/lesson-worthy moments — not every meeting produces content. I shape the posts myself
- **Reading/listening tracking:** No separate system. Captured via Slack brain dump channel, processed like everything else
- **Goal tracking — layered approach:**
  - CLAUDE.md → goals + context (always loaded, the "why" layer)
  - Google Sheet → action items tagged to goals (the "what" layer)
  - Weekly Slack nudge → progress snapshot mapped to goals
  - Monthly → deeper reflection, build log update in project brief

### Data Flow

**Sources (input):**
- Granola → meeting notes, action items, content-worthy moments
- Slack #brain-dump → non-meeting thoughts, ideas, random captures, reading/listening notes

**Persistent store:**
- Google Sheet → running action item list with statuses (open/done/blocked), tagged to goals. Also permanent archive for brain dump items

**Outputs (push):**
- Slack → daily outstanding action items
- Slack → meeting summaries (post-meeting, dedicated channel)
- Slack → weekly content ideas (only when genuinely interesting)
- Slack → weekly progress snapshot mapped to goals
- Google Calendar → events for time-bound action items

### Post-Meeting Pipeline

**Trigger:** TBD — either auto-detection (check Granola periodically) or semi-auto (Slack command like /process-meetings). Parked for build phase. Tradeoff: auto costs tokens on empty checks, semi-auto adds a manual step but controls cost.

**Process:** Claude reads Granola notes → extracts action items → generates summary → identifies follow-up dates → flags content-worthy moments

**Outputs:**
1. Action items → Google Sheet (owner, status, source meeting, due date, goal tag)
2. Meeting summary → Slack #meeting-summaries
3. Follow-up dates → Google Calendar events
4. Content-worthy flag → queued for weekly content ideas push

### MVP Scope

1. **Post-meeting processing** → extract action items + summary + follow-up dates from every Granola meeting → Sheet + Slack + Calendar
2. **Daily nudge** → scan Sheet for outstanding items + process brain dump channel → push to Slack
3. **Weekly content ideas** → scan Granola for genuinely interesting moments → push raw ideas to Slack
4. **Weekly progress snapshot** → map completed items to goals → push to Slack

### MVP Cadences

- **Post-meeting:** Process Granola notes → action items to Sheet, summary to Slack, follow-ups to Calendar
- **Daily:** Scan brain dump channel + Google Sheet → move brain dump items to Sheet, push outstanding action items to Slack
- **Weekly:** Content ideas scan + goal progress snapshot → push both to Slack
- **Monthly:** Deeper reflection prompt → update project brief build log

### Open Architecture Questions

- What triggers post-meeting processing — time-based cron, event-based, or manual command?
- How does the system learn what "content-worthy" means over time?
- What does the Google Sheet schema look like (columns, statuses, categories, goal tags)?
- What does the CLAUDE.md file need to contain for v1?
- **Image uploads as input:** Want to be able to upload images (photos of whiteboards, screenshots, handwritten notes, etc.) that may contain ideas or action items. Need to figure out: where do images get uploaded (Slack brain dump? Separate channel?), how does the CoS process them (vision/OCR → extract items), and where do they get archived?
- **v2 — Ambiguous brain dump clarification:** When a brain dump message is unclear (note vs. action item vs. content idea), the system should ask "what do you want me to do with this?" and wait for a reply. Requires a state layer (Pending tab in Sheet or Slack thread tracking) so the system remembers it asked a question between runs. For now, system defaults to Content Ideas tab and posts a confirmation ("Captured as content idea — reply if you want this as an action item instead").

## Standing Rituals — Non-Negotiable

These apply to every build session, every conversation, every change. Not just one-time items.

### 1. WDAI Session Cross-Check
Before any architectural decision, new build, or system change:
- Pull ALL WDAI session transcripts from Granola (full transcripts, not summaries)
- Check for: pitfalls, failure modes, approaches tried and abandoned, warnings given
- List what's relevant to what you're about to do
- If something conflicts with the current plan — STOP and flag it before proceeding
- If Granola is unavailable — stop and ask Brittney for the transcripts manually

### 2. Assumption Check
Before writing any code, making any external call, updating any file, or sending any message:
- What am I trying to do?
- What am I assuming about the current state? (which workspace, account, file, channel)
- What could silently fail or land in the wrong place?
- Have I verified the output destination?

Get explicit confirmation before anything with external side effects.

**Why these exist:**
- The WDAI cross-check has been requested multiple times and keeps not happening — it needs to be a gate, not a reminder
- The assumption check exists because of F-001 (bot posting to 1,800-person Slack) and F-005 (CLAUDE.md version confusion) — both preventable with 30 seconds of verification

---

## Before Next Build Session

These must be resolved BEFORE building anything new. Cross-check against WDAI session notes (pull from Granola after Session 2 tonight) before committing to any of these.

**1. Meeting filter for Granola processing**
Not all meetings should be processed — only work/project-related ones. Options:
- Tag meetings in Granola with a label (e.g. "CoS") to flag for processing
- Maintain a list of meeting types/titles to skip (personal calls, doctor appointments, etc.)
- Process all but filter by whether any action items were detected
Decision needed before building the automated meeting trigger.

**2. Daily nudge format standardization**
Claude produces inconsistent formats across sessions — no memory of previous styles. Fix:
- Review nudge formats produced so far — what worked, what didn't
- Define exact sections, order, and formatting rules
- Add the template to CLAUDE.md so every run follows it
This is also an eval opportunity (see #4).

**3. Content ideas tab in Google Sheet**
Content ideas and action items are different objects with different fields. Move content ideas to their own tab:
- Content ideas tab fields: ID, idea/angle, source meeting, source date, status (draft/posted/rejected), post date, notes
- Action items tab: only action items — Content Flag column can point to content tab ID
Decision needed: what fields does the content ideas tab need?

**4. Evals — build as part of this project**
Evals are a critical AI PM skill and this project is a natural fit. Opportunities:
- **Nudge format eval:** given a Sheet state, does the nudge match the defined template?
- **Meeting processing eval:** given meeting notes, does the system extract the expected action items?
- **Command interpreter eval:** given Slack messages, does the system correctly interpret each one (including edge cases)?
- **Content filter eval:** given meeting notes, does the system correctly identify content-worthy moments?
Cross-check with WDAI Session 2 notes — have they covered evals? What frameworks are others using?

**5. Cross-check current architecture against WDAI Session 2 notes**
After tonight's session, pull the Granola transcript and check:
- Did anything come up that contradicts current decisions?
- Did others surface problems we haven't hit yet?
- Are there approaches worth adopting before the next build session?
- Specifically check: meeting filtering, format consistency, eval frameworks, cost management
This must happen BEFORE the next build session, not after.

### Roadmap — v1 / v2 / Future

**v1 — Built and working**
- Daily nudge → Slack (automated, 8am via launchd)
- Brain dump → Action Items tab + Content Ideas tab (routed by message type)
- Meeting processing → Sheet + Slack summary (manual trigger)
- Slack command processor → Sheet updates (noon + 5pm via launchd)
- Bot identity (Chief of Staff APP)
- Apps Script webhook (append, update, content idea)
- Content Ideas tab with full schema

**v2 — Next layer**
- Meeting processing automation (no manual trigger)
- Meeting filter (not all Granola meetings should be processed)
- Daily nudge format standardization (consistent template)
- Weekly content scan (automated, from Granola)
- Weekly progress snapshot (automated)
- Evals framework
- Ambiguous brain dump clarification ("what do you want me to do with this?")
- Job tracking spreadsheet integration
- **Watch/Listen Later tab** — separate from Action Items and Content Ideas. For links, podcasts, videos, articles to consume later. Fields TBD (URL, title, type, source, date added, status)
- **Evaluate Claude Code Routines as launchd replacement** — Routines support remote execution (laptop doesn't need to be awake), which directly solves the daily nudge reliability issue. Claude.ai never recommended this as an option when launchd was built — surfaced in WDAI Session 1 by Habon. Worth testing before investing more in launchd infrastructure. Constraint: same 5 daily runs limit applies.
- **Model performance analysis** — git log is automatically tagged with Co-Authored-By model attribution (e.g. Claude Sonnet 4.6). Future analysis: cross-reference build log decisions, lessons, and failures against model versions to understand performance differences across the build.
- **Reliable midday command processing** — noon/4pm runs can be skipped if Mac is asleep at the trigger moment. Login triggers fire only once per day so they can't cover midday. Needs a different event trigger or cloud-based solution (pending June 15 billing clarity). Resolve in v2.
- **Meeting processing confirmation step (Option C)** — when a meeting is processed, action items require Brittney's approval before writing to the Sheet; content ideas auto-write as Status=Draft; both filtered against goals.md before surfacing. Designed but not built. Currently meeting processing writes directly without a confirmation gate.

**Future**
- True orchestration (system recommends what to do, not just lists)
- Always-on cloud trigger (GitHub Actions, Railway, VPS)
- Real-time Slack command processing
- DDC systematization workflow
- Image upload processing
- Multi-agent structures
- **Content post agent** — a dedicated agent that takes a content idea from the Content Ideas tab, drafts a post in Brittney's voice, and surfaces it for review/edit before publishing
- **Make public repo forkable** — once the system is stable and complete, add setup instructions so others can run their own version with their own credentials. Not yet — the system isn't done.

### Watching / External Dependencies

**June 15 billing change — deferred decision.** Anthropic is moving Agent SDK and claude -p to a separate per-user credit pool at API rates (reported, effective ~June 15). This may affect the cost of the current launchd claude -p automation, not just future cloud options. Per Nisha's WDAI guidance (Session 2), wait and see what actually lands before committing to any always-on / cloud scheduling migration (Routines vs GitHub Actions vs staying local). Revisit after June 15. This decision gates the always-on scheduling choice.

---

### User Interaction Design — CRITICAL PATH

The system's core promise is push, not pull. But right now every pipeline requires manually opening Claude Code and typing a command. That's pull with extra steps — and it contradicts the architecture we built and the story we're telling publicly.

This isn't a v2 problem. It's the gap between "the pipelines work" and "the system actually runs my life." Every day this stays manual is a day the system isn't delivering on its design.

**What needs to be true for the system to be fully agentic:**

1. **Triggering workflows — how does the system run without me initiating it?**
   - Daily nudge fires automatically every morning (cron, scheduled task, or always-on process)
   - Post-meeting processing fires automatically when a new Granola meeting is detected, or on a lightweight schedule
   - Weekly content scan and progress snapshot fire on their own cadence
   - Brain dump channel is scanned as part of the daily nudge, not as a separate manual step
   - I should never need to open Claude Code for routine operations

2. **Responding to nudges — what can I do from Slack?**
   - Reply to mark an item Done
   - Reply to snooze / defer an item
   - Reply to add context or notes
   - Reply to reprioritize
   - These responses need to flow back to the Google Sheet automatically

3. **Capturing things — what's the experience for adding something ad hoc?**
   - Brain dump channel handles free text — Claude figures out if it's an action item, content idea, or just a note
   - But what about items that need a due date or goal tag? Free text and let Claude infer, or structured format?
   - Image uploads (whiteboards, screenshots) — how do these get processed?

4. **System feedback — how do I know the system is working?**
   - When meetings are processed, I should see confirmation in Slack (already works)
   - When brain dump items are extracted, I should see what was captured
   - When writes fail, I should know — not silent failures
   - The daily nudge itself is the primary feedback loop

**Current state vs. target state:**

| Workflow | Current (manual) | Target (agentic) |
|----------|-----------------|-------------------|
| Daily nudge | Open Claude Code, type command | Fires automatically every morning, lands in Slack |
| Meeting processing | Open Claude Code, type command | Fires after each meeting or on schedule |
| Brain dump processing | Open Claude Code, type command | Processed as part of daily nudge automatically |
| Weekly content scan | Not built yet | Fires weekly, lands in Slack |
| Respond to nudge | Manually update Sheet or tell Claude Code | Reply in Slack, Sheet updates automatically |
| Ad hoc capture | Type in #brain-dump | Same — this already works |

**The simplest path to agentic:**
- Step 1: Cron job on Mac (or cloud) that runs daily nudge script every morning
- Step 2: Slack slash commands or bot interactions for responding to nudges
- Step 3: Scheduled meeting processing (check Granola periodically or after calendar events end)

This is the next major build milestone after Thursday's demo.

### Automation → Orchestration Roadmap

The current design is mostly **automation** — take input, process it, put output somewhere. The goal is **orchestration** — the CoS makes decisions about what to prioritize, when to escalate, when to nudge harder, and how to sequence work.

**Automation (v1):** "You have 8 outstanding action items." (list them)
**Orchestration (future):** "You have 8 outstanding items, but 3 are blocking the tenant search which has a deadline. I'd recommend tackling the washer removal today since the contractor is available this week, and deferring the LinkedIn post to tomorrow since you already posted Monday."

**Design for orchestration now, build automation first.** This means the Google Sheet schema should include fields orchestration will eventually need (priority, goal tag, dependencies, due dates, blocked-by) even if v1 just lists items without reasoning about them.

### Platform Options Explored

| Option | Push? | Always-on? | Conversational? | Notes |
|--------|-------|-----------|----------------|-------|
| Claude Projects | ❌ No | N/A | ✅ Yes | Can't push; pull-only. Ruled out for core system |
| Claude Code + Slack | ✅ Yes | ✅ Yes (if on server/VPS) | ❌ No | Most flexible; MVP choice |
| Cowork + Dispatch | ✅ Yes (push notifications) | ⚠️ Only when laptop open | ✅ Yes | Scheduled tasks + phone notifications built in. Viable alternative, but laptop-must-be-open constraint is a limitation |
| Hybrid (Code + Cowork) | ✅ Yes | ✅ Partial | ✅ Partial | Code for always-on pipelines, Cowork for conversational interaction. Worth exploring post-MVP |

**MVP decision: Claude Code + Slack.** Doesn't depend on laptop being open, Slack already connected, Granola/Sheets/Calendar MCPs available. Cowork/Dispatch is worth exploring in a later session as a complementary or replacement delivery layer.

### Transcript Cross-Reference — Preempting Known Challenges

Checked our architecture against pitfalls and lessons from WDAI Session 1 participants:

| Challenge from transcript | Our status | Notes |
|--------------------------|-----------|-------|
| Manual file management (Nisha's #1 pain) | ✅ Addressed | Google Sheet + Granola MCP, no manual markdown updates |
| 70% calendar reading success rate | ✅ Sidestepped | Espa owns calendar reads; CoS only writes events |
| Losing mobile/voice by moving to Claude Code | ⚠️ Known limitation | Slack on mobile is the interface, but it's not conversational like Projects. Cowork/Dispatch could fill this gap later |
| Cross-project file syncing via git | ✅ Not needed | Google Sheet is accessible from anywhere |
| Multiple calendar management | ✅ Not our problem | Single Google Calendar primary |
| Token costs escalation ($20 → $125/mo) | ⚠️ Flagged | Semi-auto trigger helps control costs; need to track usage |
| Knowledge preservation and retrieval | ⚠️ Not in v1 | System extracts and pushes but no "search what I've learned" yet. v2 candidate |

---

## What's Manual vs. Automated

| Task | CoS v1 | How |
|------|--------|-----|
| Reviewing Granola notes | ✅ Auto-processed | Post-meeting pipeline |
| Extracting action items | ✅ Auto-extracted | → Google Sheet |
| Tracking action item completion | ✅ Tracked | Google Sheet with statuses |
| Following up on things | ✅ Pushed to you | Daily Slack nudge + Calendar events |
| Finding LinkedIn content ideas | ✅ Surfaced | Weekly Slack push from Granola + brain dump |
| Writing LinkedIn posts | ❌ Still manual | By design — I shape the posts |
| Checking/updating PM job spreadsheet | ❌ Deferred to v2 | Separate system for now |
| Coordinating rental property tasks | ⚠️ Partial | Action items in sheet, no dependency logic yet |
| Capturing non-meeting thoughts | ✅ New channel | Slack #brain-dump → processed daily to Sheet |
| Weekly planning | ⚠️ Partial | Weekly progress nudge helps, but I still decide priorities |

**6/10 fully automated, 2 partial, 2 intentionally manual.** The partial items (rental property coordination, weekly planning) are v2 candidates.

---

## Strategic Framing — Why This Build Matters

### Triple duty

The chief of staff project simultaneously: solves a real workflow problem, positions for consumer/AI PM roles, and fuels LinkedIn content. No need to build something separate.


### Reference: Ev Chapman's Claude Code Chief of Staff (April 2026)

Ev Chapman's system uses four components: folder structure, CLAUDE.md (the brain), markdown memory files (persist via git), and skills + MCP connections. Key insight: the whole system is "just a folder of files." Our architecture diverges by using Google Sheet instead of markdown for action items (accessibility tradeoff) and Slack as the push channel (Ev's system is more pull-based). Being able to articulate these tradeoffs = PM interview gold.

---

## Build Log

### Session 0 — WDAI Session 1 + initial planning (May 21, 2026)

**What happened:** Attended WDAI Build Hour Session 1. Heard approaches from other participants (Nisha's Claude Projects + markdown files, Carol's multi-calendar management, others using Obsidian + Whisper Flow). After the call, organized scattered notes into structured brief with Claude. Identified goals, constraints, tools ecosystem, and core problem. Connected Granola MCP to Claude.

**Key decisions:**
- Push over pull (rules out pure Projects)
- Slack as delivery channel AND brain dump input channel (two-way)
- Espa handles calendar/email; chief of staff handles thinking/tracking layer
- Slack brain dump channel for non-meeting capture — processed daily, Sheet is permanent archive (free Slack 90-day limit)
- Content ideas surfaced as raw material only; Claude filters for genuinely interesting moments, not every meeting
- Calendar write access for deadline-based action items only
- Job tracking spreadsheet deferred to v2
- Reading/listening tracking flows through brain dump channel — no separate system
- Goal tracking is layered: CLAUDE.md (context) → Sheet (operational) → Weekly nudge (progress) → Monthly reflection (strategic)
- Post-meeting pipeline: every meeting processed → action items to Sheet, summary to Slack, follow-ups to Calendar, content flag if interesting

**Tradeoffs made:**
- Chose to start with Granola as primary source — Granola has API access, Apple Notes doesn't. Slack brain dump fills the gap
- Slack brain dump instead of Apple Notes — solves API access gap but introduces 90-day history limit. Mitigated by daily processing to Sheet
- Content ideas are raw only (not drafts) — prioritizes speed and avoids Claude shaping voice too early
- No separate reading/listening tracker — keeps tool count flat, brain dump handles it

**What I learned:**
- Separating what Espa already does from what the chief of staff should do was critical for scoping
- The push vs pull decision was the most consequential architecture choice — it determined the entire platform direction
- Making Slack two-directional (input + output) kept the tool count flat while solving the Apple Notes capture gap
- Claude's memory vs. Nisha's file system are solving different problems — memory is biographical, files are operational
- Free Slack's 90-day history limit means Slack can be an inbox but not an archive — always process out to a permanent store

### Session 1 — Architecture deep dive + infrastructure build (May 22, 2026)

**What happened:** Reviewed WDAI Session 1 transcript via Granola MCP. Cross-referenced architecture against participant pitfalls. Discovered Cowork + Dispatch as viable push alternative. Identified automation vs. orchestration gap. Flagged user interaction design as missing layer. Reviewed Ev Chapman's Claude Code Chief of Staff video. Designed Google Sheet schema, created the Sheet, drafted CLAUDE.md, defined manual-vs-automated map.

**Key decisions:**
- MVP platform: Claude Code + Slack (not Cowork — laptop-must-be-open constraint)
- Design for orchestration, build automation first — Sheet schema includes priority, dependencies, blocked-by fields even in v1
- MVP = post-meeting processing + daily nudge + weekly content ideas + weekly progress snapshot
- Google Sheet as persistent action item store with completion tracking, tagged to goals
- Trigger mechanism: TBD (auto vs semi-auto, parked for build)
- LinkedIn post #1 angle: push vs. pull as a product design decision
- 1 LinkedIn post per WDAI session commitment (6 minimum)

**Tradeoffs made:**
- Claude Code + Slack over Cowork + Dispatch — loses built-in push notifications and conversational interface, but gains always-on reliability
- Automation-first over orchestration-first — faster to ship, but data model designed for orchestration to avoid restructuring later
- Google Sheet over markdown for action items — less "AI-native" than Ev Chapman's approach but more accessible day-to-day
- Semi-auto trigger likely for v1 — auto-detection wastes tokens; manual Slack command controls cost

**What I learned:**
- Cowork + Dispatch is a real push option that I initially overlooked. Laptop constraint is the dealbreaker for now
- Automation vs. orchestration is a spectrum, not a binary
- Cross-referencing our plan against the transcript caught 7 known challenges — 4 fully addressed, 3 flagged
- User interaction design is the gap between "system works" and "system gets used daily"
- Ev Chapman's system validates Claude Code direction but is more pull-based and markdown-native. Our divergence is worth articulating
- 6/10 daily tasks get automated in v1 — strong signal that MVP scope is right

**Completed:**
- Google Sheet schema designed and created (Sheet ID: YOUR_GOOGLE_SHEET_ID)
- CLAUDE.md v1 drafted
- 7 starter action items pre-populated in Sheet
- Cowork/Dispatch evaluated
- Transcript cross-referenced against architecture
- Automation vs. orchestration framing established
- Project brief saved to Google Drive

### Session 2 — Infrastructure setup + first pipeline test (May 26, 2026)

**What happened:** Reviewed CLAUDE.md edits Brittney made between sessions. Set up all MCP servers in Claude Code (Slack, Granola, Google Drive, Google Calendar). Created Slack app "Chief of Staff" for BG's Playground workspace. Created #brain-dump and #cos-updates channels. Connected claude.ai Slack to BG's Playground (required incognito window workaround). Ran first successful end-to-end pipeline test: Granola → extracted action items → posted summary to Slack. Discovered Google Drive MCP can't write to existing sheets — identified Google Apps Script as the fix.

**Brittney's CLAUDE.md edits (between sessions):**
- Added framing: "You are helping her scale herself. Your job is to help obsolete her self from recurring tasks."
- DDC description refined: "Does project management/execution consulting for DDC"
- Insulation no longer blocks tenant (only washer + microwave do)
- Tenant has a July timeline — "Secure tenant for unit 1 in July ← blocked by 1-2"

**Key decisions:**
- Slack connected to BG's Playground (personal workspace), not WDAI
- Google Apps Script webhook approach to solve Sheet write limitation
- Slack channel IDs hardcoded in CLAUDE.md: #brain-dump (YOUR_BRAIN_DUMP_CHANNEL_ID), #cos-updates (YOUR_COS_UPDATES_CHANNEL_ID)

**Infrastructure completed:**
- Slack app "Chief of Staff" created with bot token + scopes (channels:read, channels:history, chat:write, groups:read, groups:history)
- MCP servers added to Claude Code: slack (local stdio), granola (HTTP), google-drive (HTTP), google-calendar (HTTP)
- claude.ai Slack connector switched to BG's Playground
- #brain-dump and #cos-updates channels created and bot invited
- CLAUDE.md updated with channel IDs and rental property corrections

**Pipeline test results:**
- ✅ Granola → read meeting notes (Brittney/Julian catch-up, May 18)
- ✅ Claude Code extracted action items following the schema (AI-008, AI-009)
- ✅ Summary posted to Slack #cos-updates with action items, themes, and notes
- ❌ Google Sheet write FAILED — Google Drive MCP supports read and create but not editing existing sheets
- 🔧 Fix: Google Apps Script doPost webhook to append rows. Script drafted.

**Failures & blockers documented:**
- Slack MCP server initially failed to connect — missing SLACK_TEAM_ID env var. Server accepted config silently but failed at runtime. No error until `mcp list` check. Lesson: always verify MCP connections with `claude mcp list` after adding
- Slack bot token regeneration required re-inviting bot to channels — not mentioned in any docs, easy to miss
- claude.ai Slack connector doesn't show which workspace is connected — genuine product UX flaw. Had to disconnect and reconnect via incognito window to force workspace picker
- Google Drive MCP can't write to existing spreadsheet cells — critical gap for the action items pipeline. Workaround: Google Apps Script webhook
- Claude Code defaulted to WDAI Slack (claude.ai connector) instead of local bot token because local server failed to connect

**Tradeoffs made:**
- Chose Google Apps Script webhook over finding a Sheets-specific MCP server — faster to implement, no new dependencies
- Connected claude.ai Slack to BG's Playground instead of fixing local stdio MCP server — pragmatic, uses working connection path

**What I learned:**
- MCP server setup has sharp edges — silent failures, missing env vars, no workspace visibility in UI. These are exactly the PM pain points worth writing about
- The pipeline works conceptually (Granola → extract → Slack) but the write layer (Sheet) needs a workaround. This is a real product constraint of the Google Drive MCP
- Testing one connection at a time and verifying with `mcp list` is essential — don't assume config = connected
- The incognito window trick for OAuth workspace selection is a workaround for a real product gap in claude.ai

**Open for next session:**
- Deploy Google Apps Script webhook and test Sheet writes
- Process WDAI Build Hour meeting (May 21) through the full pipeline
- Test daily nudge workflow
- Begin documenting for LinkedIn post #1

### Session 3 — Apps Script deployed, full pipeline + daily nudge working (May 27, 2026)

**What happened:** Deployed Google Apps Script webhook to solve the Sheet write blocker. Hit authorization error (OAuth consent screen not configured), resolved by clicking through "Advanced → Go to unsafe" bypass. Claude Code generated updated script that references Sheet by ID directly. Hit syntax error on first deploy (missing closing bracket from Claude Code's output — had to fix manually). Successfully tested full end-to-end pipeline: Granola → extract action items → write to Google Sheet via webhook → post summary to Slack. Fixed bot identity issue — messages now come from "Chief of Staff APP" instead of personal profile. Got desktop notifications working. Tested full daily nudge with bot identity — organized by goal, priority badges, blocked item references, smart commentary, content flags, and weekly completion count.

**Key milestone:** Full MVP pipeline AND daily nudge are operational with proper bot identity. Ready to demo at WDAI Session 2 on Thursday.

**Infrastructure completed:**
- Google Apps Script webhook deployed and working
- Webhook URL added to CLAUDE.md
- Full pipeline tested: Granola → Sheet → Slack ✅
- Local Slack MCP server connected (was failing yesterday, resolved itself)
- Bot identity working — messages come from "Chief of Staff APP"
- Desktop notifications working for bot messages
- Slack MCP config moved into chief-of-staff project for native access

**Pipeline test results — daily nudge:**
- ✅ Read Google Sheet, identified 10 open items across 3 goals
- ✅ Organized by goal with emoji headers (Rental, WDAI Build, LinkedIn)
- ✅ Priority badges, blocked item references with strikethrough
- ✅ Smart commentary: "pipeline is live — close this?", "Rental clock is ticking — July tenant target"
- ✅ Content flags highlighted
- ✅ Weekly completion count at bottom
- ✅ Sent from Chief of Staff bot identity with desktop notification

**Failures documented:**
- Apps Script authorization error: "OAuth client is not fully created yet" — resolved by using Advanced → unsafe bypass, not by configuring GCP OAuth consent screen
- Claude Code generated script with missing closing bracket — syntax error on deploy. Had to manually fix. Lesson: always verify AI-generated code before deploying
- Apps Script deploy UI gives generic "An error occurred" when code has syntax errors — the actual error is in a red banner at the bottom of the editor, easy to miss
- claude.ai Slack connector sends messages as user profile, not bot — no notifications for own messages. Fixed by using local bot token MCP server via curl
- Mobile Slack notifications not working for bot messages — parked for later

**What I learned:**
- Google Apps Script is the right workaround for the Sheet write gap — lightweight, no new dependencies, deployed in minutes once auth was resolved
- AI-generated code needs human review even for simple scripts — the missing bracket would have been caught by any linter
- The daily nudge output exceeded expectations — Claude Code is already doing orchestration-level thinking (flagging what to close, noting time sensitivity, suggesting next actions) even though we designed for automation first
- Bot identity matters for UX — getting notifications from "Chief of Staff" vs seeing your own messages is the difference between a system that nudges you and one you have to check
- The local MCP server that was "Failed to connect" yesterday resolved itself today — sometimes the answer is just retry

**Open for next session:**
- Process all recent Granola meetings through the pipeline
- Test brain dump channel reading
- User interaction patterns (how to mark items done, snooze, etc.)
- Mobile notification fix
- Demo prep for WDAI Session 2 (Thursday)

**Also completed:**
- LinkedIn post #1 published — push vs. pull angle with architecture diagram
- AI-005 (Write LinkedIn post #1) can be marked Done in the Sheet
- Brain dump channel tested and working — Claude Code reads #brain-dump, extracts action items, flags content ideas, writes to Sheet via webhook
- Apps Script improved with error handling, structured JSON responses, try/catch
- CLAUDE.md updated by Claude Code with working webhook curl pattern (redirect workaround documented)
- Claude Code discovered Apps Script 302 redirect issue and self-documented the fix

**Additional failures documented:**
- Apps Script webhook returns 302 redirect on POST — standard curl -X POST fails silently. Working pattern: POST to capture Location header, then GET the redirect URL. Claude Code figured this out through trial and error and documented it in CLAUDE.md
- Claude Code forgot about the webhook on first brain dump attempt and tried to use Drive MCP to write — needed explicit reminder. The CLAUDE.md instructions weren't prominent enough. Now fixed with IMPORTANT flag
- launchd/cron laptop-must-be-awake constraint was flagged for Cowork earlier but not carried forward when designing the cron approach — should have been caught sooner
- plist file didn't download from chat UI — had to create directly in terminal via heredoc

**Automation infrastructure completed:**
- `daily-nudge.sh` created using `claude -p --dangerously-skip-permissions` for non-interactive execution
- launchd job (`com.cos.dailynudge`) loaded and registered — fires daily at 8am, retries on wake if Mac was asleep
- Logs writing to `~/chief-of-staff/logs/nudge.log` and `nudge-error.log`
- System is now genuinely agentic for the daily nudge — no manual trigger needed

**Known limitation:**
- launchd requires Mac to eventually wake up. True always-on requires cloud solution (GitHub Actions, Railway, VPS). Parked as future improvement.

### Session 4 — launchd PATH fix + Slack command processor + schedule optimization (May 28, 2026)

**What happened:** Daily nudge did not fire at 8am — diagnosed via error log: `claude: command not found`. Fixed by hardcoding full path to claude in daily-nudge.sh. Built and tested process-commands.sh — reads #cos-updates for natural language commands, updates Sheet via Apps Script webhook, confirms via Chief of Staff bot. Deployed Apps Script v2 with both append and update functions. Discovered Pro plan has 5 daily routine runs limit. Optimized schedule to 3 runs/day (8am nudge + noon and 5pm command processor).

**Key decisions:**
- Command processor runs at noon and 5pm only (not every 60 min) — conserves daily routine run budget
- 3 runs/day total: 8am nudge + noon commands + 5pm commands = leaves 2 for manual pipeline work
- Real-time Slack command processing parked — polling is sufficient for now, revisit if latency becomes an issue

**Infrastructure completed:**
- launchd PATH fixed — hardcoded `/Users/YOUR_USERNAME/.local/bin/claude` in all scripts
- process-commands.sh built and tested — natural language command interpreter via Slack
- Apps Script v2 — handles both append (new rows) and update (existing rows by ID)
- CLAUDE.md updated with update pattern for webhook
- com.cos.processcommands launchd job updated to noon + 5pm schedule
- Bot identity confirmed working for both nudge and command confirmation messages

**Failures documented:**
- launchd PATH issue — same root cause as yesterday, should have been caught when building the command processor script. Always use absolute paths in launchd scripts.
- plist heredoc failed with single-quoted EOF delimiter — XML contains single quotes that break the heredoc. Fix: use unquoted ENDOFFILE delimiter instead of 'EOF'
- Apps Script v2 deployed successfully but initial test created duplicate row instead of updating — root cause was CLAUDE.md not yet updated with new update pattern. Fixed by updating CLAUDE.md first.
- Pro plan has 5 daily routine runs limit — not surfaced anywhere obvious, discovered by checking claude.ai settings. Important constraint for scheduling decisions.

**What I learned:**
- Claude Pro's 5 daily routine runs limit is a real architectural constraint — every scheduled launchd job counts. Need to be intentional about how many automated jobs run per day.
- Natural language command interpretation works well for clean commands ("done AI-007") but edge cases like "AI-005 and AI-010 are the same" (deduplication intent) need more robust handling
- The system is now genuinely agentic: morning nudge fires automatically, commands processed twice daily, all without opening Claude Code

**Additional completions:**
- Brain dump processing updated in CLAUDE.md — now routes to Action Items tab (tasks), Content Ideas tab (ideas/observations), or both based on message type. Everything in brain dump lands somewhere.
- Content Ideas tab created in Google Sheet with schema: ID (CI-xxx), Idea/Angle, Hook, Source, Source Date, Status, Post Date, Series Tag, Notes
- Apps Script v3 deployed — handles three operations: append action items, update existing rows, append content ideas
- CLAUDE.md updated with content idea write pattern
- Brain dump + command processor run successfully processed: 3 content ideas extracted to Content Ideas tab with full context, multiple action items marked Done, duplicate detected and noted
- Slack token extraction bug found and fixed by Claude Code mid-run — old grep pattern captured only 5 chars. Fixed to use Python to parse ~/.claude.json directly. CLAUDE.md updated automatically.

**Additional failures documented:**
- Slack bot token extraction via grep was silently broken — grep pattern `SLACK_BOT_TOKEN[^"]*"[^"]*"` only captured 5 characters of token. Silent failure: sheets wrote successfully but Slack post failed. Claude Code self-diagnosed and fixed during the run. New pattern uses Python to parse JSON directly.
- Claude Code self-improved mid-run and updated CLAUDE.md — good behavior but means local CLAUDE.md may diverge from this project's copy. Always check ~/chief-of-staff/CLAUDE.md after runs for self-edits.

### Session 5 — CLAUDE.md cleanup + CI- routing fix (May 29, 2026)

**What happened:** Daily nudge failed again (launchd PATH issue). Fixed by adding explicit PATH export to daily-nudge.sh. Discovered multiple CLAUDE.md versions in project folder (CLAUDE.md and CLAUDE_5.md) causing Claude Code to read the wrong file. Cleaned up to one authoritative CLAUDE.md. Fixed CI- ID routing for Content Ideas tab updates — Apps Script had the update_content_idea action but Claude Code kept using the wrong action because CLAUDE.md wasn't loading correctly. Fixed by baking the routing rules and two-step curl pattern directly into process-commands.sh script so it doesn't depend on CLAUDE.md being loaded. Added 7:55am run to command processor schedule (3 runs/day: 7:55am, noon, 5pm) so commands are processed before the 8am nudge. Added `update_content_idea` action to Apps Script for Content Ideas tab.

**Status of all pipelines:**
- ✅ Daily nudge (8am, launchd) — working with PATH fix
- ✅ Command processor (7:55am, noon, 5pm, launchd) — working, CI- and AI- IDs route correctly
- ✅ Brain dump → Action Items + Content Ideas routing — working
- ✅ Content Ideas tab updates via Slack commands — working
- ✅ Meeting processing (manual trigger) — working
- ❌ Meeting processing automation — blocked on Granola upgrade decision
- ❌ WDAI Session 2 notes cross-check — still not done (MUST do before next build session)

**Key failures documented:**
- launchd PATH issue recurred — daily-nudge.sh lost the PATH fix. Added explicit `export PATH` to the top of the script as a permanent fix
- Multiple CLAUDE.md versions caused Claude Code to read wrong file — CLAUDE.md vs CLAUDE_5.md. Fixed: deleted CLAUDE_5.md, CLAUDE.md is now the single authoritative file
- CI- ID routing kept failing because process-commands.sh prompt didn't mention CI- IDs or the two-step curl pattern — Claude Code guessed wrong. Fix: baked the routing rules directly into the script prompt, not just CLAUDE.md
- Apps Script update_content_idea action was deployed but Claude Code wasn't using it — root cause was CLAUDE.md not loading. Fixed by script-level instructions

**What I learned:**
- Critical instructions need to live in the script itself, not just CLAUDE.md — CLAUDE.md is unreliable as the sole source of truth because it may not load correctly in every session
- Multiple versioned files in the same directory create confusion. One authoritative file, no versions.
- The daily routine runs limit (5/day) makes debugging expensive — each failed process-commands run counts. Better to test manually first, then schedule.

**Open for next session:**
- WDAI Session 2 notes cross-check (overdue — do this first)
- Granola upgrade decision ($14/month) — blocks meeting processing automation
- Watch/Listen Later tab in Google Sheet
- Daily nudge format standardization (consistent template)
- Update brief in Google Drive

### Session 6 — New day, context recovery (June 1, 2026)

**Where things stand coming into today:**

All pipelines status as of end of May 29:
- ✅ Daily nudge (8am launchd) — but broke AGAIN as of June 1 (chatbot identity issue — nudge sending from Brittney's profile not Chief of Staff bot). Parked, not fixing yet.
- ✅ Command processor (7:55am, noon, 5pm launchd) — CI- and AI- routing baked into script
- ✅ Brain dump → Action Items + Content Ideas routing
- ✅ Content Ideas tab — all CI updates via Slack working
- ✅ Meeting processing — manual trigger only
- ❌ Meeting processing automation — blocked on Granola upgrade decision
- ❌ WDAI Session 2 notes cross-check — still not done (MUST do before building anything new)

**Key open items:**
1. Fix daily nudge bot identity issue (parked) — check `claude mcp list` for slack server status, verify token in `~/.claude.json`
2. WDAI Session 2 notes cross-check — overdue
3. Granola upgrade decision ($14/month)
4. Watch/Listen Later tab
5. Daily nudge format standardization

### Apps Script File Structure

Both files live in the same Apps Script project linked to the CoS Action Items Google Sheet:
- `Code.gs` — main webhook handler: append action items, update AI- rows (`action: "update"`), update CI- rows (`action: "update_content_idea"`), add content ideas (`action: "content_idea"`)
- `setup.gs` — one-time setup function `addContentIdeasTab()` — already ran, ignore going forward


### Pending LinkedIn Post — Wrong Slack Workspace Incident

**What happened (May 26, 2026):** While testing the Slack pipeline, the Chief of Staff bot posted "Hello from Chief of Staff!" to the WDAI community's `#general` channel (1,800 members) instead of the personal BG's Playground workspace. Root cause: claude.ai Slack connector was authenticated to the WDAI workspace, not the personal workspace. Had to disconnect, reconnect via incognito window to force workspace picker to BG's Playground.

**Screenshot:** Available in this conversation (May 26 session) and potentially still visible in WDAI Slack `#general` around 11:28am May 26.

**Content angle:** "I accidentally let my AI chief of staff loose in a 1,800-person Slack community. Here's what happened." — Post about the messy reality of building with MCP tools, workspace identity gaps, and why claude.ai doesn't show you which Slack workspace is connected (a real product UX gap). Series tag: AI Chief of Staff [failure edition].

---

### Session 7 — Documentation, rituals, and public repo (June 2, 2026)

**What happened:**

Two standing rituals formalized and baked into CLAUDE.md as hard gates: WDAI session cross-check (full transcripts, not summaries) and assumption check before any build action. These were requested multiple times previously and kept not happening — moving them to CLAUDE.md as REQUIRED pre-build steps was the fix.

Failures & Lessons section restructured as a dedicated standalone section in the brief (F-001 through F-007 with full detail — what happened, root cause, fix, lesson, content potential). Previously failures were buried in build logs and getting condensed.

Public repo (`bcgwynn/chief-of-staff-build`) planned and set up — scrubbed brief, scrubbed scripts, README structure defined. Public framing confirmed: "I built this to solve a real problem" — no job search copy, no PM positioning language.

LinkedIn post #2 published — wrong workspace incident (F-001).

F-006 and F-007 added to Failures & Lessons section (incomplete close-out instructions, over-explaining when called out).

**Key decisions:**

- Standing rituals must be hard gates in CLAUDE.md, not reminders in the brief
- Both claude.ai chat and Claude Code should check full WDAI transcripts, not summaries
- Failures get their own dedicated section, written in full at the time they happen — never condensed
- Public repo framing: build story with decisions and failures, not a portfolio piece signaling PM skills
- README structure: Problem, What I Built, Architecture Decisions, Failures & Lessons, What's Next, How to Use This

**What I learned:**

- Documentation that lives only as a "before next session" reminder doesn't get done — it needs to be a programmatic gate
- F-001 root cause was more interesting than first documented: Claude Code didn't "assume" the wrong workspace — it used the only working connection it had, which happened to be WDAI. Silent fallback to wrong workspace because local bot token server was failing. The system does what it can with what works.
- Failures buried in build logs get condensed and lose detail over time. Standalone section with full entries is the right structure.

**Completed:**

- CLAUDE.md updated with REQUIRED pre-build rituals section
- Failures & Lessons section added to brief with F-001 through F-007 in full detail
- Public repo live (`bcgwynn/chief-of-staff-build`)
- LinkedIn post #2 published

---

### Session 8 — Daily nudge reliability investigation (June 3, 2026)

**What happened:**

Investigated why the daily nudge isn't firing reliably. Confirmed launchd is fundamentally unreliable — not just a sleep issue. Even when the Mac is awake, scheduled jobs don't always fire. Full launchd limitations documented accurately for the first time; previous documentation understated the problem.

Discovered F-008: Session 4 build log incorrectly stated launchd jobs count against Claude Code Routines limit — this was wrong and influenced scheduling decisions in Sessions 4 and 5 unnecessarily.

Completed full comparison of Claude Code Routines vs GitHub Actions in plain terms. Bot identity confirmed as non-negotiable. Decision on which path to take deferred to next session.

F-009 logged: Claude.ai stated "GitHub Actions is the right path" as a conclusion after completing the comparison without getting confirmation — assumption check failure.

**Key decisions:**

- Bot identity (Chief of Staff APP) is non-negotiable — any always-on solution must preserve it
- launchd is not a viable long-term scheduling solution — not just unreliable when Mac is asleep, unreliable period
- Routines vs GitHub Actions comparison complete — decision deferred to next session

**What I learned:**

- launchd failures have been understated in the brief — the real picture is: silent failures, no reliable feedback, unreliable even when Mac is awake, recurring PATH issues
- The always-on problem was flagged in Session 1 as a known gap and parked. It's now actively blocking the system from working as designed.
- Claude.ai stated a conclusion without getting confirmation — assumption check failure, logged as F-009
- The WDAI transcripts are a real resource — Nisha and Habon are hitting the same walls. Worth asking the group directly about scheduling solutions.

**Completed:**

- F-006, F-007, F-008, F-009 added to Failures & Lessons
- Session 7 build log completed with correct date
- Full launchd limitations documented
- Routines vs GitHub Actions comparison completed

**Open for next session:**

- Decide: Routines vs GitHub Actions for always-on scheduling
- Build whichever is chosen
- Daily nudge still running on unreliable launchd in the meantime

**Known limitation:**

The noon and 4pm command processor runs fire via StartCalendarInterval. If the Mac is awake at the trigger time, they run normally. If the Mac is asleep at the exact trigger moment, that run is skipped (modern macOS does not reliably catch up missed launchd intervals on wake). Consequence: only if the Mac is asleep at BOTH noon and 4pm do afternoon Slack commands and brain-dump items wait until the next morning login to be processed — at which point the login-triggered nudge runs the command processor first. Nothing is lost permanently; processing is deferred. The morning nudge itself is reliable because it fires on login, not on a clock time.

### Session 9 — Daily nudge login-trigger fix + format fix (June 4, 2026)

**What happened:**

Pushed past both cloud scheduling options (Routines and GitHub Actions) and chose neither. Researched and landed on a login-triggered LaunchAgent with a once-per-day guard as the actual fix — the nudge owns its own sequencing: runs the command processor synchronously first (brain dump processed before Sheet is read), then posts the nudge. This matches the real use case: "fire when I sit down to work" is a login event, not a clock time.

Daily nudge format regression discovered and fixed. The standardized format was using markdown pipe tables, which Slack doesn't render — nudges showed raw `| col | col |` syntax. Root cause: the pipe-table spec was in the build repo CLAUDE.md and both daily-nudge.sh prompts; the main repo CLAUDE.md had no format section at all.

Found the canonical format: the May 29 daily nudge, which used clean Slack mrkdwn and rendered correctly through the bot token. Discovered the May 27 version (which looked best) used Block Kit tables posted via the claude.ai connector — not reproducible with the current bot-token MCP, which is text-only.

Chose mrkdwn (Option B) over Block Kit via curl (Option A) — Block Kit would require Claude to generate valid JSON in a shell prompt every morning, a fragility risk that contradicts the reliability work done this session.

Locked in the format: header, optional 🚨 URGENT callout, goal sections with emoji headers, inline-context bullets with priority dots (no pipe tables), bold blockers, Content Ideas section, anomalies callout, italic brain-dump footer, and a high-level Analysis synthesis section — both inline reasoning per item AND bottom-line orchestration analysis. Verified the new format renders correctly live in Slack before relying on it.

Identified LinkedIn post #3 angle: "the best solutions came from not taking the AI's first answer" — the better answer was often available the whole time; pushing past the first response is what surfaced it.

F-010 (missed Nisha's June API warning), F-011 (weak citations), F-012 (narrow solution space), F-013 (better options surfaced only after pushing) logged this session.

**Key decisions:**

- Login-triggered LaunchAgent (RunAtLoad + once-per-day guard) chosen over Routines and GitHub Actions — matches the actual use case, no cloud dependency
- Process-commands.sh called synchronously before nudge — brain dump processed before Sheet is read
- Nudge format: mrkdwn bullets only, no pipe tables, verified live in Slack before locking in
- Block Kit via curl rejected — fragility risk outweighs visual improvement

**What I learned:**

- The requirement was wrong, not the solution. "Fire at login" is a different and better requirement than "fire at 9:30am." Jobs-to-be-done applied to a scheduling problem unlocks the right solution set.
- Format consistency efforts can regress quality if the standardized format isn't tested in the actual rendering environment. A spec that looks right isn't verified until it renders live.
- The two repos' CLAUDE.md files had diverged — the main repo never had the format section. Divergence between context files causes silent inconsistency.
- The bot-token MCP is text-only; richer Block Kit formatting was only available through the claude.ai connector. Tool choice constrains output format.
- The WDAI cross-check has been failing not because it wasn't done, but because it wasn't connected — reading the transcript ≠ mapping warnings to current decisions (F-010).

**Completed:**

- Login-trigger nudge built: RunAtLoad plist, once-per-day guard, process-commands.sh called synchronously before nudge
- Daily nudge format fixed (May 29 mrkdwn template) and verified live in Slack
- Format spec aligned across both repos and both scripts, pipe tables explicitly prohibited
- F-010, F-011, F-012, F-013 added to Failures & Lessons
- Public repo scripts and README updated to match new architecture

**Open for next session:**

- PATH error recurred in nudge-error.log (`claude: command not found`) — verify login-triggered nudge is working reliably before closing this out
- June 15 billing change — watch and decide whether it changes the always-on architecture path

### Session 10 — Project structure + ritual improvements (June 5, 2026)

**What happened:**

Updated project instructions with 4 formalized rituals: WDAI cross-check before any build decision, assumption check before any CoS change, state intent before acting on CoS changes, answer directly for everything else. Added ritual #3 to both CLAUDE.md files. Compared private vs public CLAUDE.md — substantively in sync, minor gaps fixed (duplicate code block removed, "Don't duplicate Espa" added to public). Split Failures & Lessons into dedicated failures-and-lessons.md in both repos (F-001 through F-014, 201 lines each). Brief cleaned of F-entries, pointer added. Session date history corrected and locked: S6=Jun1, S7=Jun2, S8=Jun3, S9=Jun4, S10=Jun5. F-014 logged (session date thrash). Brief is now fetchable end-to-end for architecture/decisions but build log still causes truncation — decision on how to fix deferred to next session.

**Key decisions:**

- Rituals formalized in project instructions AND CLAUDE.md — both environments enforce them
- Failures & Lessons split into own file — brief is cleaner, failures are searchable separately
- Brief truncation fix deferred — options are split build log or add current-state.md

**What I learned:**

- Even after Claude Code reports success, verify independently — the confirmation was accepted without checking. Only verified when pushed back.
- The fetch truncation problem is structural — the brief will keep growing and will always truncate unless actively managed

**Completed:**

- Project instructions updated with 4 rituals
- CLAUDE.md ritual #3 added to both repos
- failures-and-lessons.md created in both repos, F-001–F-014
- Brief cleaned of F-entries
- Session history locked and corrected

**Open for next session:**

- Brief truncation fix — split build log or add current-state.md
- June 15 billing change (10 days out)
- Always-on scheduling decision (post-June 15)
- Evals, Watch/Listen Later, meeting processing confirmation, Granola upgrade

### Session 11 — Context management + WDAI pitfalls doc (June 7, 2026)

**What happened:**

Planning session in Claude.ai. Debunked the Reddit "200-line markdown causes instructions to be ignored" claim — not a real Anthropic constraint. Established that token overhead is not a meaningful concern given Opus 4.8's 1M context window. Identified that WDAI cross-check findings were not being reliably surfaced in build decisions despite cross-checks occurring. Built a distilled WDAI Pitfalls & Flags doc (104 lines) extracted strictly from WDAI Sessions 1-3 transcripts — replaces the three raw transcript files previously stored in the Claude.ai project. Brief updated in repo to reference the new doc and retire the Google Drive brief as the canonical source.

**Key decisions:**

- Raw WDAI transcripts removed from Claude.ai project, replaced with distilled pitfalls doc
- Google Drive brief retired — repo `chief-of-staff-brief.md` is now the canonical source of truth
- GitHub repo as file system flagged as an open architecture question worth revisiting (more AI-native than Google Sheet + Drive)
- WDAI Pitfalls & Flags doc to be updated after each of Sessions 4, 5, 6 by appending new findings

**What I learned:**

- The real problem wasn't that cross-checks weren't happening — it was that cross-check findings had no permanent home and weren't being reliably referenced in decisions
- A distilled doc with strict source discipline (WDAI sessions only, not build session findings) is more trustworthy as a cross-check tool than a summary that mixes sources

---

## Failures & Lessons

See failures-and-lessons.md for all failure entries.
