# hsbDrill

## Overview

`hsbDrill` creates a linear distribution of drill holes (round bores), slotted holes (mortises), and sinkholes (counterbores) along the X-direction of one or more selected GenBeams (timber members or panels). It is designed to produce mechanical fastener connections such as bolt groups, dowel patterns, and concealed connector holes in timber framing.

The script operates in two internal modes:

- **Distribution Mode (Mode 0)**: Places the script on the model, prompts for a start point and end point, then spawns individual single-drill instances at each calculated position along the selected beams.
- **Single Drill Mode (Mode 1)**: Each spawned instance manages a single hole location. It applies the actual `Drill` or `Mortise` tool operations to all intersecting GenBeams, handles counterbores on both sides, and displays the graphical representation of the hole in the model.

Because the spawning parent (Mode 0) erases itself after distributing, the user will see only the individual drill entities in the drawing after insertion.

---

## Usage Environment

| Property | Value |
|---|---|
| Script Type | O-Type (Object) |
| Model Space | Supported |
| Paper Space | Not supported |
| Shop Drawing | Not a shop-drawing script |
| Beams Required | 0 (prompt-based selection during insertion) |
| CNC / DXA Output | Yes (`#DxaOut 1`) - drill data is exported for CNC machining |
| Major Version | 2 |
| Minor Version | 7 |

---

## Prerequisites

- At least one **GenBeam** (timber beam, wall stud, panel, SIP, etc.) must exist in the drawing before inserting this script.
- The GenBeam must be accessible in Model Space.
- The UCS (User Coordinate System) should be set to a convenient orientation before insertion; the drill direction is derived from the UCS.

---

## How to Use

### Step 1: Insert the Script

Use `TSLINSERT` and select `hsbDrill.mcr`, or launch it from the hsbCAD menu. A dialog box appears for initial parameter configuration. You may also supply a catalog preset via `_kExecuteKey` to skip the dialog entirely.

### Step 2: Configure Parameters in the Dialog

The dialog allows you to set the core drilling parameters before selection. These values can also be modified later in the Properties Panel (OPM).

### Step 3: Select the Main Beam

```
Command Line Prompt: Select genbeam
```

Click on the primary timber member. The beam's X-axis determines the distribution direction.

### Step 4: Select Additional Beams (Optional)

```
Command Line Prompt: Select additional objects (<ENTER> for none)
```

Click any secondary beams that should also receive the drills (e.g., a rim board bolted to a wall plate). Press Enter if drilling only one beam.

### Step 5: Define the Start Point

```
Command Line Prompt: Select start point <Enter> to use start point of beam
```

Click to place the distribution start. Press Enter to automatically use the beam's start end. The point is projected onto the beam axis so offset errors do not matter.

### Step 6: Define the End Point

```
Command Line Prompt: Select end point <Enter> to use end point of beam
```

Click to define the end of the distribution range. Press Enter to automatically use the beam's far end.

### Step 7: Review Result and Adjust OPM Properties

After insertion, each drill hole appears in the model as a circle(s) on the beam face. Select any drill entity and adjust properties in the Properties Panel (OPM) to fine-tune dimensions, spacing, or hole type.

---

## Properties Panel (OPM Parameters)

Properties are organized into categories in the AutoCAD Properties Palette.

### General

| Property | Type | Default | Range / Options | Description |
|---|---|---|---|---|
| Depth | Number | 0 | >= 0 | Drill depth. **0 = complete through-hole** regardless of beam thickness. Any positive value creates a blind hole of that depth. |
| Diameter | Number | 18 mm | > 0 | Main bore diameter. |
| UCS | Dropdown | -Z | `-Z`, `-Y`, `Z`, `Y` | Selects which UCS axis the drill enters from. Defines the drill direction relative to the beam. Change this if holes are going in the wrong face. |
| Snap to center line | Dropdown | No | `No`, `Yes` | When `Yes`, locks the hole's lateral position to the beam's centerline regardless of where you clicked. |
| Axis offset | Number | 0 | Any | Lateral offset from the beam centerline. **Only active** when `Snap to center line` is set to `No` and this value is non-zero. Use this to offset holes toward an edge. |

### Sinkhole - Reference Side

A counterbore drilled from the entry face (the face the drill enters first). Both Depth and Diameter must be set for the counterbore to appear; the Diameter must be larger than the main bore Diameter.

| Property | Type | Default | Description |
|---|---|---|---|
| Depth | Number | 0 | Depth of the counterbore. A **negative value** shortens the main drill in the primary beam - useful for creating dowel-type connections where the bolt does not fully penetrate the first member. Only applies when the total depth is at least as large as the main beam's thickness. |
| Diameter | Number | 18 mm | Counterbore diameter. Must exceed main Diameter to activate the sinkhole. |

### Sinkhole - Opposite Side

A counterbore drilled from the exit face (back face). Only valid when the main hole is a through-hole (Depth = 0).

| Property | Type | Default | Description |
|---|---|---|---|
| Depth | Number | 0 | Depth of the counterbore on the far face. |
| Diameter | Number | 18 mm | Counterbore diameter. Must exceed main Diameter to activate. |

### Slotted Hole

Creates an elongated slot (mortise) instead of a round hole, allowing for construction tolerances or controlled movement in bolted connections.

| Property | Type | Default | Options / Range | Description |
|---|---|---|---|---|
| Length | Number | 18 mm | >= Diameter | If Length is greater than Diameter, a slotted hole (mortise) is used. Equal to or less than Diameter = round hole. |
| Assignment | Dropdown | none | `none`, `first object`, `second object`, `all` | Specifies which beam(s) receive the slotted version. The remaining beams get a standard round drill. Useful when only one layer should allow movement (slip-critical vs. bearing). If Length is not greater than Diameter this property is automatically reset to `none`. |

### Distribution

Controls how holes are spaced along the beam.

| Property | Type | Default | Options | Description |
|---|---|---|---|---|
| Mode | Dropdown | Even Distribution | `Even Distribution`, `Fixed Distribution` | **Even Distribution**: divides the total span into equal segments (the number of holes is derived from span / inter distance, then the actual spacing is recalculated evenly). **Fixed Distribution**: uses the exact inter-distance value as center-to-center spacing; holes at both the start and end positions are always included. |
| Inter distance | Number | 70 mm | > 0 | Center-to-center spacing between drill holes. Used differently depending on Mode. |
| Distance from startpoint | Number | 0 | >= 0 | Insets the first hole away from the defined start point by this amount. |
| Distance from endpoint | Number | 0 | >= 0 | Insets the last hole away from the defined end point by this amount. |

### Baufritz (Special Project Setting)

This category only appears when the drawing is configured for the Baufritz project special (`projectSpecial()` returns `"BAUFRITZ"`). It selects a predefined hardware type for BOM reporting.

| Property | Type | Options | Description |
|---|---|---|---|
| Hardware | Dropdown | (blank), Schlüsselschraube 16x220, Schlüsselschraube 16x260, Stehbolzen kurz, Stehbolzen lang | Selects the fastener type used at this hole location. Drives BOM (Hardware entity) output with type, model, length, and diameter. Has no effect on hole geometry. |

---

## Right-Click Menu Options

When a single drill instance (Mode 1) is selected, the following context menu options are available:

| Menu Item | Description |
|---|---|
| Add entities | Opens a selection prompt. Select additional GenBeams to include in this drill connection. Useful for adding beams that were missed during insertion or that were added to the model later. |
| Remove entities | Opens a selection prompt. Select GenBeams to remove from this drill connection. The hole will no longer be applied to those beams on the next recalculation. |

---

## Workflow Behavior and Logic Notes

### Two-Phase Execution

The parent distribution script (Mode 0) collects all parameters, calculates drill point positions, creates individual `hsbDrill` instances at each position (Mode 1), then erases itself. The user interacts only with the resulting single-drill entities.

### Automatic Beam Discovery

When the script is inserted not from a direct user pick but from another script (e.g., library insertion), it automatically scans the element's GenBeams to find any that intersect the drill line. This means additional beams that overlap the drill path are included without manual selection.

### Through-Hole Depth Calculation

When `Depth = 0`, the script calculates the actual depth by measuring the distance from the entry face to the far intersection face across all selected beams. The result is the total stack thickness, guaranteeing a complete through-hole regardless of beam size changes.

### Slotted Hole Conflict Check

If the `Length` property is equal to or less than `Diameter`, the `Assignment` property is automatically reset to `none` and the user is warned via the command line. This prevents creating degenerate mortises.

### Beam Coplanarity Validation

When beams are added to a single drill, the script checks that each additional beam's drill-axis direction is parallel to the main drill axis. Beams that are not coplanar with the drill direction are automatically removed from the list with a debug message.

### Element Association

When selected beams belong to hsbCAD Elements (walls, floors), the script assigns itself to those element groups. This ensures the drill recalculates correctly when an element moves or regenerates.

### Copy and Erase Behavior

Single drill instances (Mode 1) are set to copy with all referenced beams (`_kAllBeams`) and to not auto-erase when any single beam is removed (`_kNoBeams`). This prevents accidental loss of a multi-beam drill connection when one beam is deleted.

### CNC Output

Because `#DxaOut 1` is set, the applied `Drill` and `Mortise` tools are included in CNC machining exports (e.g., BTL, DXF-M). The exact hole geometry (diameter, depth, direction) is output for each beam that receives the tool.

---

## Tips and Notes

- **Through holes**: Keep `Depth` at `0`. The script dynamically measures stack thickness, so the hole remains complete through even if beam sizes change after insertion.
- **Counterbores for bolt heads**: Set `Sinkhole Reference Side > Diameter` larger than the washer OD and `Sinkhole Reference Side > Depth` to the required recess depth.
- **Dowel connections**: Set `Sinkhole Reference Side > Depth` to a **negative** value. This shortens the drill in the primary beam only, creating a socket that stops the dowel flush without drilling all the way through.
- **Slotted holes for movement joints**: Set `Length` > `Diameter` and use `Assignment = first object` to allow sliding on the outer ply while fixing the inner ply.
- **Wrong drill direction**: Adjust the `UCS` property. Try `-Z` for a top-face drill, `Z` for bottom, `-Y` for a side-face drill from one side, and `Y` for the other side.
- **Holes not centered on beam**: Set `Snap to center line = Yes` or set `Axis offset` to fine-tune the lateral position. If both options are active, `Snap to center line` takes priority.
- **Add beams after insertion**: Use the right-click `Add entities` context menu rather than re-inserting the script. The drill recalculates and applies to the new beam immediately.
- **Even vs. Fixed distribution**: Use `Even Distribution` when you want a fixed count derived from span/spacing with equal division. Use `Fixed Distribution` when you want exact center-to-center spacing with end points always drilled.
- **Catalog-based insertion**: Set `_kExecuteKey` before insertion to populate all properties from a named catalog entry. This allows standards-compliant bolt patterns to be inserted without user dialogs.
