# hsbBeamcutElement

## Overview

**hsbBeamcutElement** is an Element-type TSL tool that automates the creation of beam cuts (notches or recesses) across an entire timber element in one operation. Instead of manually applying individual cuts to each beam, you select a "tooling beam" whose bounding-box geometry defines the cut shape, and the tool automatically finds all intersecting beams in the element and applies a BeamCut to each of them.

A beam-orientation filter lets you restrict the operation to only parallel, only perpendicular, or other geometric relationships relative to the tooling beam. An adjustable gap parameter adds uniform clearance to the cut pocket. The tool is fully parametric: it recalculates whenever the tooling beam moves, resizes, or is split by another operation.

Keywords: `Beamcut`, `Element`
Script version: 1.3 (15 November 2021, author: Thorsten Huck)

---

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | E-Type (Element tool) |
| Working Space | Model Space (3D environment) |
| Beams Required | 1 (the tooling beam that defines the cut shape) |
| Grip Points | None (insertion grip disabled) |
| Recalculation | Automatic when tooling beam moves, resizes, or is split |

The tool must be linked to an hsbCAD Element (wall, floor, or roof panel) or, when no element reference is available, to a manually selected set of loose beams.

---

## Prerequisites

1. **A tooling beam exists in the drawing.** Its solid length, width, and height define the recess that will be carved into the target beams. This is typically a crossing member that frames into or through the beams you want to notch.
2. **Target beams belong to an Element or are available as loose beams.** The tool resolves its target list from the parent element, or accepts a manual beam selection when the tooling beam is not part of any element.
3. **The tooling beam and target beams physically intersect.** An intersection test is performed against the cutting volume. If no intersecting beams remain after filtering, the tool removes itself.

---

## How to Use

### Insertion Workflow

1. Run the command **hsbBeamcutElement** (ribbon, tool palette, or command line).
2. A settings dialog appears for configuring **Orientation** and **Gap**. If a catalog entry is applied by key, the dialog is skipped and saved values are used directly.
3. At the prompt **"Select tooling beams"**, click one or more beams whose geometry will define the cut template, then press Enter.
4. Depending on settings and element membership, additional prompts may appear:
   - **Orientation = bySelection**: You are prompted **"Select beams to be milled"** to pick specific target beams. If no beams are selected, the tool falls back to the "All" orientation automatically.
   - **Tooling beam has no element reference**: You are prompted **"Select element or beams to be milled"** to define the scope manually.
   - **Tooling beam belongs to an element and Orientation is not bySelection**: No further selection is needed; element beams are used automatically.
5. One tool instance is created per tooling beam. Each instance is assigned to the element sublayer, and the BeamCut is applied to all qualifying intersecting beams.

### Working with Multiple Tooling Beams

You can select more than one tooling beam during insertion. The tool creates one independent instance per tooling beam, each managing its own cut volume and target list.

### Behavior When a Tooling Beam Is Split

When the tooling beam is split by another hsbCAD operation, the tool automatically clones itself onto each resulting beam segment. Cloned instances that no longer intersect any target beam are purged automatically.

---

## Properties Panel (OPM Parameters)

Changing any value triggers an immediate recalculation.

### Orientation

| Attribute | Value |
|-----------|-------|
| Type | PropString (dropdown list) |
| Category | General |
| Default | All |

Controls which beams inside the element are eligible for the cut, based on their geometric relationship to the tooling beam's longitudinal axis.

| Option | Behavior |
|--------|----------|
| `All` | Every beam in the element except the tooling beam itself is a candidate. |
| `bySelection` | Only beams manually selected during insertion (or added/removed via right-click) are candidates. |
| `Not parallel` | Only beams whose axis is **not** parallel to the tooling beam are candidates. |
| `Parallel` | Only beams whose axis **is** parallel to the tooling beam are candidates. |
| `Not perpendicular` | Only beams whose axis is **not** perpendicular to the tooling beam are candidates. |
| `perpendicular` | Only beams whose axis **is** perpendicular to the tooling beam are candidates. |

Regardless of the orientation filter, all candidates are still subjected to a physical intersection test against the cut volume. Beams that do not overlap the cutting body are excluded even if they pass the orientation filter.

### Gap

| Attribute | Value |
|-----------|-------|
| Type | PropDouble |
| Category | General |
| Default | 2 mm |

Defines a uniform clearance expansion applied to all six faces of the tooling beam's bounding box before the cut is made:

- **Cut Length** = tooling beam solid length + 2 x Gap
- **Cut Width** = tooling beam solid width + 2 x Gap
- **Cut Height** = tooling beam solid height + 2 x Gap

A Gap of `0` produces a pocket exactly flush with the tooling beam. If any resulting dimension falls below the internal tolerance (0.1 mm), the tool reports "Invalid tool geometry" and removes itself.

---

## Right-Click Menu Options

Two context-menu commands are available when **Orientation** is `bySelection` or when the tooling beam has no element reference and a manual beam list is in use.

### Add Beams

Prompt: **"Select beams to be milled"**

Adds one or more beams to the existing target list and recalculates immediately. Double-clicking the instance also triggers this command.

### Remove Beams

Prompt: **"Select beams not to be milled"**

Removes selected beams from the target list. The tooling beam itself cannot be removed. Changes take effect on the next recalculation.

---

## Tips and Notes

- **Choose the right Orientation filter.** For typical wall and floor panel workflows, `perpendicular` targets only cross members (joists, blocks) while leaving parallel chord members untouched. Using `All` in a dense panel can produce unintended cuts.

- **Gap compensates for assembly tolerances.** A value of 1-3 mm is standard for most timber connections. For steel insert plates or precision pockets, set Gap to `0`.

- **Partial intersections are handled correctly.** When the tooling beam overlaps a target beam only partially along the X-axis, the visual display adjusts to show the actual milled length rather than the full tooling beam length.

- **The grip point is disabled.** You cannot reposition the instance by dragging. The cut position is always derived from the tooling beam's center point. To move the cut, move the tooling beam.

- **Automatic self-deletion keeps the model clean.** If the cut volume no longer intersects any target beam, the tool removes itself rather than leaving an orphaned instance.

- **Catalog entries speed up repeated workflows.** Pre-configured Orientation and Gap combinations can be saved to the hsbCAD catalog and applied by name at insertion time, bypassing the dialog.

- **Visual feedback.** The tool draws a color-coded axis marker at the cut zone:
  - Reference line along the full intersecting range of the tooling beam X-axis
  - Red / Color-14: positive and negative X-direction
  - Green / Color-96: positive and negative Y-direction
  - Color-150 / Color-154: positive and negative Z-direction

- **Element sublayer assignment is automatic.** The tool is placed on the element sublayer upon creation. No manual layer management is required.
