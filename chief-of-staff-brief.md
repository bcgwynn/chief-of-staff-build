# Agentic Chief of Staff — Project Brief

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

**2. ✅ DONE — Daily nudge format standardization**
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

**5. ✅ DONE — Cross-check current architecture against WDAI Session 2 notes**
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
- ✅ DONE — Daily nudge format standardization (consistent template)
- Weekly content scan (automated, from Granola)
- Weekly progress snapshot (automated)
- Evals framework
- Ambiguous brain dump clarification ("what do you want me to do with this?")
- **Evaluate Claude Code Routines as launchd replacement** — Routines support remote execution (laptop doesn't need to be awake), which directly solves the daily nudge reliability issue. Claude.ai never recommended this as an option when launchd was built — surfaced in WDAI Session 1 by Habon. Worth testing before investing more in launchd infrastructure. Constraint: same 5 daily runs limit applies.
- **Model performance analysis** — git log is automatically tagged with Co-Authored-By model attribution (e.g. Claude Sonnet 4.6). Future analysis: cross-reference build log decisions, lessons, and failures against model versions to understand performance differences across the build.
- **Reliable midday command processing** — noon/4pm runs can be skipped if Mac is asleep at the trigger moment. Login triggers fire only once per day so they can't cover midday. Needs a different event trigger or cloud-based solution (pending June 15 billing clarity). Resolve in v2.
- **Meeting processing confirmation step (Option C)** — when a meeting is processed, action items require Brittney's approval before writing to the Sheet; content ideas auto-write as Status=Draft; both filtered against goals.md before surfacing. Designed but not built. Currently meeting processing writes directly without a confirmation gate.

**Future**
- True orchestration (system recommends what to do, not just lists)
- Always-on cloud trigger (GitHub Actions, Railway, VPS)
- Real-time Slack command processing
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
| Coordinating rental property tasks | ⚠️ Partial | Action items in sheet, no dependency logic yet |
| Capturing non-meeting thoughts | ✅ New channel | Slack #brain-dump → processed daily to Sheet |
| Weekly planning | ⚠️ Partial | Weekly progress nudge helps, but I still decide priorities |

**6/10 fully automated, 2 partial, 2 intentionally manual.** The partial items (rental property coordination, weekly planning) are v2 candidates.

---

## Strategic Framing — Why This Build Matters

### Reference: Ev Chapman's Claude Code Chief of Staff (April 2026)

Ev Chapman's system uses four components: folder structure, CLAUDE.md (the brain), markdown memory files (persist via git), and skills + MCP connections. Key insight: the whole system is "just a folder of files." Our architecture diverges by using Google Sheet instead of markdown for action items (accessibility tradeoff) and Slack as the push channel (Ev's system is more pull-based).

---

## Failures & Lessons

See failures-and-lessons.md for all failure entries.
