# StackSpacer

## Overview

StackSpacer generates 3D spacer blocks (dunnage sticks) between timber items within a transport stack. It analyses the gaps between stacked items and places solid spacer bodies at user-defined distribution locations along a chosen axis.

The script works as part of the stacking suite together with StackEntity, StackPack, and StackItem. It supports two physical orientations -- horizontal spacers lying flat between layers and vertical spacers standing between packs side by side -- as well as three distribution strategies: fixed step, evenly spaced, or manually picked vertex points.

Each spacer is registered as a Hardware Component (HardWrComp) and appears automatically in Bill of Materials exports.

**Version:** 2.2 (12 February 2025)

**Important:** Version 2.0 was a complete rewrite and is not compatible with instances created by version 1.x. Old StackSpacer instances must be deleted and re-inserted.

---

## Usage Environment

| Environment | Supported | Notes |
|---|---|---|
| Model Space | Yes | All geometry and BOM output is generated here |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

**Script type:** O (Object) -- attaches to StackEntity and/or StackPack instances as linked entities and recalculates automatically when the stack is modified.

**Beams required:** 0 -- operates on TSL stack/pack instances, not on individual timber beams.

---

## Prerequisites

Before running StackSpacer the following must exist in the drawing:

- At least one **StackPack** instance (a transport pack), or a **StackEntity** (full stack) containing packs.
- The packs must contain **StackItem** instances (the actual stacked timber pieces). Without items there are no bodies to calculate gaps between.
- The `TslUtilities.dll` dialog library must be present in the hsbCAD installation path. This is standard and normally available automatically.

---

## How to Use

### Step 1 -- Start the command

Run the command via `(hsb_ScriptInsert "StackSpacer")` or use the hsbCAD script insert menu and select **StackSpacer**. A catalog preset can also be selected if one has been saved previously.

### Step 2 -- Set spacer properties in the dialog

A properties dialog opens before geometry selection. Configure the settings:

- **Width** -- cross-section width of the spacer sticks (default 100 mm). Must be greater than zero.
- **Length** -- length of each spacer stick. Enter 0 for automatic calculation based on adjacent contact faces.
- **Alignment** -- Horizontal (spacers lie flat, separating layers vertically) or Vertical (spacers stand upright, separating packs side by side). This choice is locked after insertion.
- **Relation** -- which gaps the script fills (see Properties Panel below).
- **Interdistance** -- spacing between consecutive spacer positions.
- **Mode** -- distribution strategy: Fixed, Even, or Vertex Points.

Click OK to confirm.

### Step 3 -- Select packs and/or stacks

The command line prompts:

```
Select packs and/or stacks
```

Click the StackPack and/or StackEntity objects. Press Enter to confirm. If the selection contains no valid stack or pack, a notice dialog appears and the command cancels.

If the chosen Relation mode requires a stack (Pack to Pack or Entire Stack) but none was found, the script automatically falls back to "Items in Pack" and reports this on the command line.

### Step 4 -- Pick distribution points

The command line prompts:

```
Pick first point of distribution [Y-Direction/Vertical/Fixed/Even/PickPoint/Undo]
```

Click a point along the stack to define where the first spacer row is placed. A live preview (jig) shows the spacer positions and dimension string as the cursor moves.

- **Fixed** or **Even** mode: pick two points to define the distribution range. Spacers are placed automatically between them.
- **Vertex** mode: click additional points one by one. Each click adds a spacer row at that location. Press Enter when finished.

**Keyword options at the prompt:**

| Keyword | Effect |
|---|---|
| X-Direction / Y-Direction | Switches the distribution axis between world X and Y (not available in section views) |
| Horizontal / Vertical | Toggles the spacer alignment |
| Fixed | Switches to fixed-step distribution |
| Even | Switches to even-division distribution |
| PickPoint | Switches to vertex mode (manual pick for each spacer) |
| Undo | Removes the last picked point |

Press Escape to cancel insertion entirely.

### Step 5 -- Result

One StackSpacer instance is created per distribution point. Each instance:

- Draws a 3D solid spacer body in display color 45.
- Draws cross-section marker symbols at each end of the spacer.
- Links itself to the referenced stack/pack so it recalculates when the stack moves or changes.
- Exports spacer dimensions (Width x Height x Length) as Hardware Components for BOM output.

---

## Properties Panel (OPM Parameters)

These properties appear in the AutoCAD Properties Palette when a StackSpacer instance is selected.

### Spacer Category

| Property | Type | Default | Description |
|---|---|---|---|
| Width | Length | 100 mm | Cross-section width of the spacer sticks. Must be greater than zero; the script erases itself if set to zero or negative. |
| Length | Length | 0 (Auto) | Length of each spacer stick. When 0, the script calculates length from the overlap of adjacent contact faces. Enter a positive value to force a fixed length for all spacers. |
| Alignment | List | Horizontal | Physical orientation. **Horizontal**: spacers lie flat separating layers in the Z direction. **Vertical**: spacers stand upright separating packs in the Y direction. Read-only after insertion. |

### Distribution Category

| Property | Type | Default | Description |
|---|---|---|---|
| Relation | List | Items in Pack | Controls which gaps receive spacers. See the Relation options table below. Changing this value updates the visibility of dependent properties. |
| Interdistance | Length | 1000 mm | Target spacing between consecutive spacer positions. Used by Fixed and Even modes. Hidden when Mode is set to Vertex Points or when Relation is Pack to Pack. |
| Mode | List | Fixed | Distribution strategy. **Fixed**: spacers at exact multiples of Interdistance. **Even**: divides the range evenly so actual spacing may differ slightly. **Vertex Points**: places one spacer per manually picked point. Hidden when Relation is Pack to Pack. |

**Relation options:**

| Option | What it spaces |
|---|---|
| Items in Pack | Spacers in the gaps between individual StackItem bodies inside each selected pack. Standard mode for separating timber elements within one transport unit. |
| Pack to Pack | Spacers in the gaps between whole packs within the parent stack. Use for dunnage between pack layers. |
| Entire Stack | Combines both: spacers between items within each pack and between packs across the entire stack. |

### Display Category

| Property | Type | Default | Description |
|---|---|---|---|
| Dimstyle | List | (drawing default) | AutoCAD dimension style for the spacing dimension shown during insertion jig. Hidden in normal use. |
| Text Height | Length | 0 (by dimstyle) | Text height for the jig dimension annotation. 0 uses the height from the selected Dimstyle. Hidden in normal use. |

---

## Right-Click Menu Options

Right-click a selected StackSpacer instance to access these context menu commands. They appear dynamically based on the current state.

| Menu Item | When Visible | What it Does |
|---|---|---|
| Add Stack and/or Packs | Relation is "Items in Pack" | Prompts to select additional StackEntity or StackPack objects to include in the spacer calculation. |
| Remove Packs | Two or more packs are linked | Prompts to select which packs to remove from the linked entity set. The spacer recalculates based on remaining packs. |
| Remove Stack | A StackEntity is linked | Unlinks the parent stack from this instance. The spacer recalculates based only on directly linked packs. |

---

## Tips and Notes

**Grip-based repositioning:** Each instance has two interactive grips. A diamond-shaped grip is active in plan (top) view and a star-shaped grip is active in sectional (front/side) view. Drag either grip to slide the spacer to a new position along the stack axis. On release the grip snaps to the nearest spacer centre line.

**Alignment is set at insertion only:** The Alignment property becomes read-only after placement. To change orientation, delete and re-insert the instance.

**Automatic length calculation:** When Length is 0, each spacer length is calculated individually from the actual overlap of the contact faces on either side of the gap. Spacers in the same instance can have different lengths if item profiles are irregular. Set a fixed Length value when uniform spacer sizes are required.

**Automatic self-erasure:** If no valid spacer positions are found (for example, the reference point falls outside all gaps, or the linked packs have no items), the instance erases itself. Check that packs contain StackItem children and that the Width is smaller than the available gap.

**BOM output:** Each spacer body is registered as a Hardware Component with an article number in the format `ScriptName PackNumber WidthxHeightxLength` (dimensions rounded to whole numbers). Identical spacer sizes are automatically summed by quantity.

**Section view behaviour:** The script detects whether you are working in a top/plan view or a front/side section view and adjusts the default distribution direction accordingly. In a section view looking along Y, distribution defaults to X. In a section view looking along X, distribution defaults to Y.

**Pack bottom spacer:** When Relation is Pack to Pack or Entire Stack and the parent pack defines a non-zero Spacer Height property, the script also generates a spacer at the bottom of each pack representing the dunnage between the pack floor and the surface below.

**Stack side spacer:** When Alignment is Vertical and a StackEntity is linked, the script also considers the stack container sides as boundary surfaces, allowing vertical spacers to be placed between the outermost packs and the stack walls.
