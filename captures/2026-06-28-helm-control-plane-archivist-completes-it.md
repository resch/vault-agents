---
type: capture
source: vault-infra-session
date: 2026-06-28
covers: session 2026-06-28 (Helm control-plane design, after the relevance-model/affected-index capture)
description: Helm as the control plane — the worklist tap IS the archivist's promotion gate, user interaction IS the owner-supplied salience the archivist can't infer, and the vault engines are shared not rebuilt
---

For agents working on vault infrastructure/design. Captured from a direct design session designing Helm (the
phone client) as the human's conversational control plane over the self-owned event stream.

## Two-direction conversation surface — and direction 2 is already in the architecture
> *"The way I see this as a UI - there's two pieces. an inbound open chat prompt, that sits alongside the ability
> to submit a screenshot... Secondly, there's the agent driven 'I need this information prompt' - it should allow
> open response, but also have clickable buttons for the most likely responses based on context... Mirror how
> claude works where it provides a few canned responses and a chat about this option"*

Helm carries two directions on one transport: **user→agent open chat** (+ capture), and **agent→user prompts**
(quick-reply buttons + open-response fallback). The second is not new — it is the **"maybe → ask via Helm"** band
of the relevance model; the buttons are derived from the *proposal's* context, and the user's tap resolves the
staged proposal.
- **Lesson:** a "talk to your agent" surface is bidirectional — design the transport to carry agent-initiated
  prompts (pulled + answered), not just user-initiated chat. The agent-prompt half is the relevance model's
  human-gate with a face, so don't design it as a generic chatbot feature.

## The worklist tap IS the archivist's promotion gate; interaction IS the salience it can't infer
> *"Let's not forget the archivist and the vault guide. The archivist is ultimately what decides not just WHAT
> gets recorded to the vault, but HOW/WHERE... I don't wnat to rebuild functionality that should live in the
> archivist... Both of these sit under helm, as I see it - discuss and refine, think deeply"*
> *"User interaction is the key driver of importance / relevance"*

Reading the actual skills made two connections click: (1) the archivist already promotes untrusted-stream facts
from *proposal* (`status: observed/proposed`) to canonical **only on owner confirmation** — so the worklist
quick-reply tap *is literally that promotion step*; the staged `relevant-note`s are the proposals. (2) The archivist
states *"salience/weight is **owner-supplied** (uninferrable)"* — and the user's interaction loop is exactly that
owner-supplied salience. Helm doesn't sit on top of the archivist; it **completes** it (supplies the one input the
write-gate cannot derive) and **surfaces** it (the promotion gate as UI).
- **Lesson:** before building a "capture from the app" or "agent asks me to confirm" feature, check what the
  archivist already owns — propose→promote, dedup, lane placement, owner-confirmation. The interactive surface is
  usually the archivist's existing machinery given a face, plus the interaction signal that is the salience the
  archivist is structurally missing. The deepest insight: **the human-interaction channel is the archivist's
  uninferrable input, not an add-on.**

## Reuse the vault engines as shared, channel-agnostic infra — don't rebuild them per channel
Refinement of "they sit under Helm": the **archivist** (write gate) and **vault-guide** (read strategy) sit under
**every channel** — mail-gate (email/data plane), SMS (later), and Helm (control plane). Helm *invokes* them; it
does not contain them. The wiring is cheap because the skills are invocable **by path** (`skills/archivist/SKILL.md`)
via plain file-read — any agent with vault file access runs them. Latency stays interactive via **propose-async /
promote-fast**: the expensive archivist work (classify/lane/dedup) ran when the email was staged; the tap is the
cheap promotion. Deterministic vs LLM is the *execution mode* of one policy (the email→happening-detail collector is
an optimized archivist-leaf; judgment writes use the LLM archivist).
- **Lesson:** vault-governance engines are infrastructure shared across all channels/agents, not features of the
  newest client. Building them client-side is the "fork the SMS client as the base" trap one layer down — it forces
  a rebuild for the next channel. Invoke-by-path keeps them reusable across heterogeneous agent runtimes.

## Silence decays to a safe default — never rebuild the inbox
> *"Silence decays to a safe option... Silence should bias towards no vault write, or to to a vault write that gets
> cleaned up if it doesn't get future updates. The goal is always minimal interaction / no future manual cleanup
> needed. There's also the urgent answer needed path..."*

A worklist you defer-by-ignoring *is* a pile of unanswered demands — the very thing the system exists to escape. So
**silence must trigger a safe default, not wait forever**: no vault write, or a *provisional* write that self-cleans
if never reinforced (the happenings "transient detail tier" generalized; a janitor retires un-corroborated
proposals). This preserves "minimum interactions" (ignore everything and it still flows) without accumulating cruft
or manual cleanup.
- **Lesson:** any human-in-the-loop queue must define what *silence* does. "Waits until you act" silently rebuilds
  the inbox/backlog you were fleeing. Decay-to-safe (no-write or self-cleaning write + a janitor) makes "no future
  manual cleanup" an architectural property, not a discipline.

## The urgent band is the interaction-absent exception — narrow, deterministic, high-precision
Three attention bands on a *priority* axis: **decay (silent) · worklist (quiet) · alert (loud, repeating)**.
`priority = max(interaction-salience, category-importance)`. Interaction dominates the common case, but the
**category-importance floor** catches the items interaction would wrongly down-rank — fraud/2FA/deadlines you never
reply to. That floor *is* the urgent/alert path: it is high-importance precisely **because interaction is absent**.
And because a false-urgent destroys the channel (one wrong alert trains the user to ignore alerts), the alert band
must be **narrow, high-precision, deterministic-rule-driven** — bias toward under-alerting.
- **Lesson:** "user interaction is the key driver of relevance" must stay paired with the category-importance floor
  (the documented two-axis rule). The urgent path is the exact interaction-absent set — so it is the one place to
  trust deterministic rules over interaction- or model-judgment, and to fear false positives most.

## Build the mechanism slider-shaped; build the control last
> *"Do we build the attention slider first? Or this functionality, but in such a way that implicitly accepts that a
> future attention slider will exist"*

Don't build the slider first — a slider is a control over a stream you can't tune before it exists or has volume
(control-before-mechanism). Build the **mechanism**: every surfaced item carries `priority` + `urgency`; a small
**policy** maps `(priority, urgency) → decay | worklist | alert`, currently constants. The slider is later just a UI
that moves the constants — zero rework. (Same shape as "undo, not confirm" for consequential taps: optimistic +
undoable keeps speed without mis-tap dread.)
- **Lesson:** when asked "build the knob first?", build the scored stream + a constant policy and leave the knob as
  a seam. A control needs a calibrated mechanism underneath it; shipping the knob first is the abstraction with no
  implementation to govern.
