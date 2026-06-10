# Failures & Lessons

*Each entry includes: what happened, root cause, fix, lesson, content potential. Never condensed. Add new entries here immediately when failures occur — don't wait for the build log.*

### F-001 — Chief of Staff bot posted in WDAI community Slack (May 26, 2026)

**What happened:** While testing the Slack pipeline, Claude Code sent a test message ("Hello from Chief of Staff!") to the WDAI community Slack `#general` channel (1,800 members) instead of the personal Slack workspace.

**Root cause:** Two Slack connections were active simultaneously:
1. The claude.ai Slack connector (HTTP MCP) — authenticated to the WDAI workspace
2. The local bot token MCP server (stdio) — supposed to connect to personal Slack workspace but was showing "Failed to connect" due to a missing SLACK_TEAM_ID environment variable

Claude Code used the only working Slack connection it had — the WDAI connector. Silent fallback to the wrong workspace.

**Fix:** Diagnosed via Claude Code searching which workspace was being used. Disconnected Slack connector in claude.ai settings. Reconnected via incognito browser window (only personal Slack workspace active). Fixed local bot token server by adding SLACK_TEAM_ID. Verified with test message to correct channel.

**Lesson:** When multiple connections of the same type exist, Claude Code uses the working one — not necessarily the right one. Always verify which connection is active before any automated pipeline runs. Now: ask the system to state its assumptions before building anything with external side effects.

**Product observation:** claude.ai doesn't show which Slack workspace is connected anywhere in the UI. Real liability for multi-workspace automations.

**Content potential:** ✅ LinkedIn post drafted. Angle: "My AI chief of staff introduced itself to 1,800 people. One question I now ask before building anything: what are you assuming?" Series tag: AI Chief of Staff [failure edition].

---

### F-002 — launchd PATH issue (May 28, recurred May 29)

**What happened:** Daily nudge set up via launchd at 8am. Woke up to no nudge. Error: `claude: command not found`.

**Root cause:** launchd runs with a stripped PATH. `claude` installed at `/Users/YOUR_USERNAME/.local/bin/claude` but launchd couldn't find it. Fixed with sed on May 28 but lost. Recurred May 29.

**Fix:** Added explicit `export PATH` at top of daily-nudge.sh. Permanent fix.

**Lesson:** launchd PATH ≠ terminal PATH. Always use absolute paths or export PATH explicitly in any script run by launchd.

**Content potential:** ✅ "I scheduled my AI chief of staff to nudge me every morning. It silently failed for two days."

---

### F-003 — Apps Script 302 redirect (May 27)

**What happened:** `curl -X POST` to Apps Script webhook appeared to succeed but nothing was written to the Sheet.

**Root cause:** Apps Script returns a 302 redirect on POST. `curl -L` silently converts POST to GET, losing the request body.

**Fix:** Two-step curl pattern — POST to capture Location header, then GET that URL.

**Lesson:** Verify writes actually landed. Don't assume success from a 200 response.

**Content potential:** ⚠️ Narrow technical audience. Better as part of a broader "things that silently failed" post.

---

### F-004 — Google Drive MCP can't write to existing sheets (May 27)

**What happened:** Designed the entire Granola → Sheet pipeline, tested it, discovered Drive MCP can't edit existing spreadsheet rows.

**Root cause:** Assumed Drive MCP had full read/write capability. Didn't check limitations before building.

**Fix:** Built Google Apps Script webhook as workaround.

**Lesson:** Check tool capabilities before designing a pipeline that depends on them.

**Content potential:** ✅ "I designed my whole data layer around a tool that couldn't do what I needed."

---

### F-005 — CLAUDE.md not loading / multiple versions (May 29)

**What happened:** CI- ID routing kept failing — Claude Code used wrong action 4+ times despite routing rule being in CLAUDE.md.

**Root cause:** Two CLAUDE.md files in project (CLAUDE.md + CLAUDE_5.md). Claude Code read the wrong version. Silent context failure.

**Fix:** Deleted CLAUDE_5.md. Baked routing rules directly into process-commands.sh script prompt.

**Lesson:** Critical instructions can't live only in a context file. Bake them into scripts. One authoritative file, no versions.

**Content potential:** ✅ "The hardest bug I fixed wasn't in the code. It was in the AI's memory."

---

### F-006 — Incomplete close-out instructions (Session 6, June 1, 2026)

**What happened:** At end of Session 6, Claude.ai gave a close-out checklist that missed two things: (1) Sheet updates should go through the Slack bot command processor, not Claude Code directly, and (2) the parity rule and two-repo rationale should be added to CLAUDE.md. Both gaps caught by the user.

**Root cause:** Claude.ai didn't think through the full system before giving instructions — didn't check what the bot already handles. Close-out was generated from visible context, not from a full system audit.

**Fix:** Both items were added manually after being flagged.

**Lesson:** Close-out instructions must account for the full system, not just what Claude.ai can see in the current session. A chief of staff closes the loop completely without being prompted.

**Content potential:** No — behavioral/meta, not a build failure.

---

### F-007 — Over-explaining when called out (Session 6, June 1, 2026)

**What happened:** When the incomplete close-out was flagged, Claude.ai responded with a paragraph explaining why it happened and apologizing instead of just acknowledging and fixing.

**Root cause:** Default model behavior when called out is to explain and justify rather than acknowledge and correct.

**Fix:** None programmatic — behavioral pattern to watch.

**Lesson:** Acknowledge briefly, correct, move on. Don't over-explain mistakes. A chief of staff that defends itself when wrong is more friction, not less.

**Content potential:** No — meta/behavioral.

---

### F-008 — Incorrectly stated launchd jobs count against Claude Code Routines limit (Session 4, May 28, 2026)

**What happened:** Session 4 build log documented "Claude Pro's 5 daily routine runs limit is a real architectural constraint — every scheduled launchd job counts." This is incorrect. launchd runs locally on the Mac, completely outside Anthropic's infrastructure. Only Claude Code Routines count against the daily limit.

**Root cause:** Claude.ai conflated local launchd scheduling with cloud-based Claude Code Routines without understanding the distinction between where code runs.

**Fix:** Corrected understanding. launchd jobs do not count against any Anthropic limit.

**Impact:** Scheduling decisions in Sessions 4 and 5 were made under a false constraint — the "3 runs/day" optimization was unnecessary.

**Lesson:** Understand where code runs before making claims about platform limits.

**Content potential:** ✅ "I optimized for a constraint that didn't exist."

---

### F-009 — Claude.ai stated conclusion without confirmation (June 3, 2026)

**What happened:** After completing the Routines vs GitHub Actions comparison, Claude.ai stated "GitHub Actions is the right path" as a conclusion without getting confirmation. The decision had not been made.

**Root cause:** Claude.ai drew a conclusion from its own analysis and presented it as decided rather than as a recommendation.

**Fix:** Decision correctly marked as open.

**Lesson:** Recommendations are not decisions. Always get explicit confirmation before marking something as decided.

**Content potential:** No.

---

### F-010 — Missed Nisha's June billing warning across multiple sessions (June 4, 2026)

**What happened:** In WDAI Session 2 (May 28), Nisha explicitly said she was waiting for the June API credit announcement before building the agentic layer, because programmatic assembly requires API credits not included in the Pro or Max subscription. Claude.ai never surfaced this across multiple sessions, despite the WDAI cross-check being a required pre-build ritual, and despite those sessions being spent building automation whose viability depends on this exact cost question.

**Root cause:** Claude.ai treated the cross-check as "read the transcript" rather than "connect what's in the transcript to the decision on the table."

**Lesson:** The cross-check only works if Claude.ai actively maps transcript warnings to current decisions. Reading without connecting is not a cross-check.

**Content potential:** ✅ "My AI read the transcript every session and still missed the one warning that mattered."

---

### F-011 — Weak citations lowered trust in analysis (June 4, 2026)

**What happened:** When researching Claude Code billing and ToS, Claude.ai cited sources primarily about general AI career trends rather than building/infrastructure. The citations weren't relevant, lowering confidence in the conclusions.

**Root cause:** Claude.ai pulled from whatever search returned without vetting source relevance. For a consequential decision it should have gone to primary sources (Anthropic docs) first.

**Fix:** Re-ran research against Anthropic's official Legal and Compliance docs, which corrected an earlier wrong claim about ToS.

**Lesson:** For consequential decisions, go to primary sources first. Source quality determines trust.

**Content potential:** ✅ "Good research isn't finding sources, it's vetting them."

---

### F-012 — Solution space stayed narrow until use case was made precise (June 4, 2026)

**What happened:** The daily nudge reliability problem was framed for many sessions as "launchd is unreliable, the options are launchd vs cloud." Only when the actual use case was articulated precisely — not "pull at any time" but "pull at the time that works for me, when I sit down to work" — did a whole class of simpler technical solutions surface (login-triggered LaunchAgent with a once-per-day guard). The real requirement was an event trigger (login), not a clock trigger (9:30am). The clock-based framing had been driving the entire solution search down the wrong path.

**Root cause:** Claude.ai accepted the original framing ("fire at 9:30am") as the requirement instead of probing for the underlying job-to-be-done. Jobs-to-be-done was never applied to the scheduling problem until forced.

**Lesson:** Get the use case precise before searching for solutions. "When does this actually need to happen, and what event does that correspond to?" is a different and better question than "how do I make the scheduled time reliable." A vague requirement produces a narrow, wrong solution set.

**Content potential:** ✅ "I spent days trying to fix the wrong problem because I never questioned the requirement."

---

### F-013 — Limitations and better options surfaced only after pushing (June 4, 2026)

**What happened:** Across this build, key constraints and better solutions repeatedly came to light only after pushing back rather than accepting Claude.ai's first answer. Examples: the launchd sleep limitations, the June 15 billing change, Nisha's wait-and-see warning, the login-trigger solution, the ToS nuance on claude -p. When Claude.ai initially suggested "wait for June 15 / Anthropic's change" as the path, pushing with "has anyone solved the launchd reliability issue?" surfaced the pmset and login-trigger options that were never presented.

**Root cause:** Claude.ai tends to present its first viable answer as sufficient and stop, rather than exhausting the option space proactively. It treats "a solution exists" as the finish line instead of "the best available solution has been found."

**Lesson:** Don't accept the first answer as the final answer. Like working with a TL or dev team, exhaust the options before settling — research thoroughly, surface the full tradeoff space, and don't present a single path as the only path. The user shouldn't have to push to get the thorough version; thoroughness should be the default.

**Content potential:** ✅ "The best solutions came from not taking the AI's first answer."

---

### F-014 — Session-to-date mapping thrashed across multiple corrections (June 5, 2026)

**What happened:** When closing out sessions, Claude.ai repeatedly proposed incorrect session-to-date mappings — treating topic shifts within a single day (June 4: investigation → content ideas → format fix) as session boundaries, and conflating June 3 and June 4 work. It took multiple rounds and supplying git timestamps and dated screenshots to establish the correct mapping.

**Root cause:** Claude.ai reconstructed dates from memory and inference instead of grounding in the authoritative source (git commit timestamps) from the start. It also stated mappings with false confidence rather than verifying first.

**Fix:** Established mapping from git timestamps + dated conversation screenshots. Locked: S6=Jun1, S7=Jun2, S8=Jun3, S9=Jun4.

**Lesson:** For anything with a factual ground truth (dates, commits, file state), check the authoritative source before asserting — don't reconstruct from memory. The brain/hands split makes this worse: Claude.ai can't see Claude Code's history, so it must pull from git rather than guess.

**Content potential:** ✅ Fits the "don't trust the AI's first answer" theme; also a concrete example of why git timestamps beat memory.

---

### F-015 — Gist fetch URL not verified in claude.ai's network environment (June 9, 2026)

**What happened:** A Gist raw URL (`gist.githubusercontent.com`) was added to session start instructions without verifying it in claude.ai specifically. `gist.githubusercontent.com` is blocked in claude.ai's network environment.

**Root cause:** The URL was verified in Claude Code but not in claude.ai — the two environments have different network access constraints.

**Fix:** Switched to the GitHub API endpoint with PAT authentication.

**Lesson:** Always verify fetch URLs in the target environment, not just whichever environment is convenient.

---
