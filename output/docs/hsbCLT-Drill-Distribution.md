# hsbCLT-Drill-Distribution

## Overview

This script creates a parametric drill distribution pattern on one or more CLT panels (Sip elements). It automatically calculates hole locations along a path defined either by intersecting structural members (GenBeams, Sheets, or Sips) or by manually picked points. Once placed, the entity is live: if a linked panel moves, the drill pattern updates automatically.

Key capabilities:
- Drill and optional countersink (sinkhole) with independent diameter and depth settings
- Two distribution modes: Fixed spacing or Even spacing across the full panel length
- Multi-row patterns with configurable lateral offsets per row
- Column (start) offsets to stagger hole positions along the path
- Angled drilling via Bevel and Rotation properties
- Face selection (Reference Face or Top Face) to control which face the drill enters from
- Conversion to standalone polylines or grip-point-based instances to freeze geometry
- Shop drawing dimension requests compatible with MultiPageStyle stereotypes

**Version history:**
- 1.1 - 01.03.2022 (HSB-14825): Dimension requests prepared
- 1.0 - 16.02.2022 (HSB-14729): Initial release

---

## Usage Environment

| Property | Value |
|---|---|
| Script Type | O (Object / Tool) |
| Working Space | Model Space only |
| Paper Space | Not supported |
| Shop Drawing | Not directly; dimension stereotype can be configured for use in Shop Drawing views |
| Beams Required | 0 (panels are selected interactively during insertion) |

---

## Prerequisites

Before running this script:

- At least one CLT panel (Sip element) must exist in the drawing.
- For intersection-based hole placement, one or more GenBeams, Sheets, or crossing Sip panels must intersect the target panel in the area where holes are needed.
- For grip-point-based placement, no secondary objects are needed; you will click points manually on the panel face.
- All panels included in one distribution instance must be coplanar (same face plane). The script automatically skips panels on a different plane.

---

## How to Use

### Step 1: Start the command

Run the `hsbCLT-Drill-Distribution` command (or use `hsb_ScriptInsert "hsbCLT-Drill-Distribution"` from the AutoCAD command line).

A configuration dialog appears. Set the initial drill parameters (diameter, depth, distribution mode, etc.) and confirm.

### Step 2: Select the target panels

At the prompt **"Select panels"**, click one or more CLT panels (Sip elements) that will receive the drill holes. Press Enter to finish the selection.

- The first panel you select becomes the reference panel. Its coordinate system and face plane define the direction of all drills.
- Additional panels must be coplanar with the reference panel. Panels on a different plane are silently ignored.
- If no valid panel is selected, the script cancels itself.

### Step 3: Define the drill path

At the prompt **"Select intersecting genbeams or polylines"**, you have two choices:

**Option A - Intersection-based path (recommended for framing connections):**
Select one or more GenBeams, Sheets, or crossing Sip panels whose edges cross the target panel. The script calculates the intersection line between the selected members and the panel face to determine the drill line. Press Enter to finish.

**Option B - Grip-point-based path (manual placement):**
Press Enter without selecting anything. You are then prompted to **"Pick point"**. Click successive points on the panel face to draw the drill path as a polyline. Each click adds a vertex. While picking, you can type keywords in the command line:
  - `Fixed` - switch distribution mode to Fixed spacing
  - `Even` - switch distribution mode to Even spacing
  - `flipSide` - toggle the working face between Reference Face and Top Face

Press Enter when the path definition is complete. At least two points are required.

### Step 4: Review the result

The script places drill holes along the defined path and draws a 3D visualization of each hole (circle at entry face, cylinder body, circle at exit or depth). Holes that fall outside the panel boundary are shown in red and are not drilled.

### Step 5: Adjust parameters in the Properties Panel

Select the placed instance and use the AutoCAD Properties Palette (OPM) to fine-tune all parameters. The drill pattern updates automatically each time you change a value.

---

## Properties Panel (OPM Parameters)

### Drill

| Property | Type | Default | Description |
|---|---|---|---|
| Diameter | Number (length) | 12 mm | Diameter of the drill bit / hole. Applied to all holes in the distribution. |
| Depth | Number (length) | 0 | Depth of the hole measured from the entry face. **0 means completely through** the panel thickness. Enter a positive value to create a blind hole of that depth. |

### Sinkhole

| Property | Type | Default | Description |
|---|---|---|---|
| Diameter | Number (length) | 63 mm | Diameter of the countersink (sinkhole) at the entry face. The sinkhole is only active when its Depth is greater than 0 and its Diameter is greater than the Drill Diameter. |
| Depth | Number (length) | 0 | Depth of the countersink measured from the entry face. Set to 0 to disable the countersink entirely. |

### Distribution

| Property | Type | Default | Description |
|---|---|---|---|
| Mode | Dropdown | Fixed | **Fixed**: places holes at exact intervals equal to Interdistance, counting as many as fit along the path. **Even**: divides the path length evenly so that holes are spaced as close as possible to Interdistance, but all gaps are equal. |
| Interdistance | Number (length) | 1000 mm | In Fixed mode: the exact spacing between consecutive holes. In Even mode: the target spacing used to calculate the number of holes; the actual spacing is adjusted to distribute them evenly. |
| Rows | Integer | 1 | Number of parallel rows of holes. Additional rows are offset laterally from the primary path using the Row Offsets list. |
| Row Offsets | Text | (empty) | Lateral offset distances for each additional row, separated by semicolons. Example: `200;150;200` creates row 2 at 200 mm, row 3 at 350 mm (200+150), row 4 at 550 mm (200+150+200) from the primary path. The offsets cycle if there are more rows than values. |
| Column Offsets | Text | (empty) | Start offset distances applied along the path direction, one per row, separated by semicolons. Example: `100;200` trims the primary row path by 100 mm at each end and the second row path by 200 mm at each end. Used to create staggered patterns. |

### Alignment

| Property | Type | Default | Description |
|---|---|---|---|
| Face | Dropdown | Reference Face | **Reference Face**: drills enter from the bottom/back face of the panel (negative Z direction of the Sip). **Top Face**: drills enter from the top/front face. When the path is defined by an intersecting GenBeam, the face is set automatically to face toward that member and becomes read-only. |
| Bevel | Number (angle, degrees) | 0 | Tilts the drill axis in the plane containing the path direction and the face normal. 0 means perpendicular to the face. Valid range: -90° to +90°. Use this for angled connections, such as toenailing or connector-specific angles. |
| Rotation | Number (angle, degrees) | 0 | Rotates the drill axis around the path direction. 0 means no rotation from the beveled axis. Valid range: -90° to +90°. Combines with Bevel to produce compound angles. |

---

## Right-Click Menu Options

Right-click the placed instance to access these commands:

| Menu Item | What It Does |
|---|---|
| **Flip Side** | Switches the working face between Reference Face and Top Face. The drill direction reverses, and the hole entry point moves to the opposite face. Same effect as double-clicking the entity. |
| **Revert Direction** | Flips the calculation direction along the path polyline. This affects which end is treated as the start for offset calculations and dimension reporting. |
| **Add Panels** | Prompts you to select additional CLT panels (Sip elements) to include in this drill distribution. Only panels coplanar with the reference panel are accepted. |
| **Add secondary objects** | Prompts you to select additional GenBeams to use as intersection references for the drill path. When secondary objects are added, any existing polyline references are removed. |
| **Remove genbeams** | Prompts you to select GenBeams or panels to remove from the calculation. Useful when you want to narrow the path after adding members. The script keeps at least one panel. |
| **Convert To Polyline** | Calculates the current drill paths and writes them as permanent AutoCAD polylines into the drawing, assigned to the reference panel group. The instance then tracks those polylines instead of the GenBeam intersection. Use this to freeze the path geometry so it no longer updates if structural members move. |
| **Convert To Grip Points** | Replaces the current instance with a new instance of the same script that uses grip-point-based path definition. The current path vertices become moveable grip points. The original instance is deleted. This is useful when you want to manually adjust the drill path without the overhead of a GenBeam reference. |
| **Configure Shopdrawing** | Opens a dialog to configure the dimension annotation settings that this instance provides to Shop Drawing views. Two settings are available: **Format** (the text string for the distribution annotation, using tokens such as `@(Quantity-2)x @(Diameter)`) and **Stereotype** (the MultiPageStyle chain dimension stereotype to apply). |
| **Edit In Place** | Dissolves the distribution instance and re-creates each hole as an individual `hsbCLT-Drill` instance, which you can then edit separately. The distribution instance is erased after conversion. |

---

## Tips and Notes

**Hole outside panel boundary:** If a calculated hole position falls outside the panel envelope (after accounting for openings), it is drawn in red in the viewport and is not added to the panel as a drill tool. Adjust the path or the spacing to move the hole inside the boundary.

**Depth of 0 means through:** A Drill Depth or Sinkhole Depth of exactly 0 is interpreted as "completely through the panel." The hole extends from the entry face to the opposite face, including a small extension to ensure a clean cut in CNC output.

**Sinkhole activation:** The countersink is only generated when both conditions are true: Sinkhole Depth is greater than 0, and Sinkhole Diameter is greater than Drill Diameter. If either condition is not met, no countersink is created regardless of the other setting.

**Automatic face detection with GenBeams:** When the drill path is defined by an intersecting GenBeam, the script automatically detects which face of the panel is closest to the beam and sets the Face property accordingly. The Face dropdown becomes read-only in this case. To override it, use the Flip Side right-click command.

**Coplanar panels only:** All panels in a single distribution instance must lie on the same face plane. If you select panels on different planes, the non-coplanar ones are silently discarded. Create separate instances for panels on different planes.

**Row Offsets cycling:** If you specify fewer Row Offset values than the number of additional rows (Rows - 1), the offset list cycles. For example, with Rows = 5 and Row Offsets = `100;200`, the offsets applied are: row 2 at 100, row 3 at 300 (100+200), row 4 at 400 (100+200+100), row 5 at 600 (100+200+100+200).

**Grip-point editing:** When the instance uses grip-point definition (either created that way or converted via Convert To Grip Points), blue grip points appear on the path vertices when you select the entity. Drag these to adjust the path. The drill positions update immediately.

**Freezing geometry with Convert To Polyline:** After conversion, the drill positions no longer update when structural members move. This is useful for finalizing a layout before sending to production, but you will need to manually re-run the distribution if the framing changes.

**Shop drawing dimensions:** The dimension requests generated by this script are compatible with the MultiPageStyle chain dimension system. Configure the Format token string and the Stereotype under Configure Shopdrawing to control how the hole pattern is annotated in fabrication drawings. The `@(Quantity-2)x @(Diameter)` default format labels the pattern by excluding the two endpoint holes from the count (a common convention for connection bolt patterns).

**Performance:** This script uses `envelopeBody()` for panel profile extraction, which is faster than `realBody()`. On large drawings with many panels, performance is acceptable for interactive use.
