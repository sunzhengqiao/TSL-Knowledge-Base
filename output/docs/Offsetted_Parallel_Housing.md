# Offsetted Parallel Housing

## Overview

The **Offsetted Parallel Housing** script creates a parallel housing (mortise-and-tenon style) connection between intersecting timber beams. It is designed for situations where two beams cross each other at an oblique angle and a mortise joint must be placed at a specific offset from the natural intersection point.

The script works with a **male beam** (the beam that receives the housing cut on its end or side) and a **female beam** (the crossing beam that receives the mortise pocket). When launched, it supports batch selection: you can select multiple male beams and multiple female beams in a single operation, and the script automatically creates one connection instance for every geometrically valid male-female pair.

This tool is commonly used in traditional timber joinery and CNC-fabricated post-and-beam construction where beams meet at angles other than 90 degrees and the joint position must be shifted vertically or laterally from the geometric center of the intersection.

## Script Information

| Field | Value |
|---|---|
| Script name | `Offsetted_Parallel_Housing` |
| Script type | T-Type (Tool) |
| Beams required | 2 (one male, one female per instance) |
| Version | 2.2 (August 2023) |
| Environment | Model Space only |
| Insert command | `TSLINSERT` or hsbCAD ribbon |

## Version History

| Version | Date | Changes |
|---|---|---|
| 2.2 | 19.08.2023 | Fixed sharp edges on male beam when using the relief rounding option |
| 2.1 | 06.04.2023 | Added right-click option to swap the mortise extension direction; added interactive grip for mortise depth adjustment |
| 2.0 | 29.03.2023 | Complete revision: new display, fixed vertical offset bug, FreeProfile used for beveled operations |
| 1.9 | 10.01.2023 | Added rounding of housing on male beams |
| 1.8 | 07.02.2020 | Improved distribution handling; if Mortise shape is Normal, round type forced to "not rounded" |
| 1.7 | 08.11.2017 | Added separate left/right offset properties; reorganized property categories |
| 1.6 | 06.11.2017 | Separate left and right gap options; negative gap values supported |

## Prerequisites

Before using this script, ensure the following conditions are met:

- At least one **male beam** and one **female beam** must already exist in the drawing as GenBeam or Beam entities.
- The male and female beams must **not be parallel** to each other. Parallel beam pairs are automatically skipped during processing.
- The intersection point of each male-female pair must fall **within the physical length** of the female beam. If the projected intersection falls outside the beam boundaries, that pair is skipped.
- The beams should be modeled in **Model Space** (this script does not operate in Paper Space or on shop drawings).

## Step-by-Step Usage

### Step 1 -- Launch the Script

Run the `TSLINSERT` command in AutoCAD and select `Offsetted_Parallel_Housing` from the script list, or launch it from the hsbCAD ribbon toolbar. If a catalog preset has been configured for this script, you can also invoke it silently via the execute key mechanism, which will skip the dialog and apply the preset values directly.

### Step 2 -- Configure Initial Parameters

On first insertion, a standard dialog appears where you can review and modify the default values for all properties (mortise shape, depth, offsets, gaps, and rounding). If catalog presets exist, you can select one from the list to pre-populate the settings. Click **OK** to proceed to beam selection.

### Step 3 -- Select Male Beams

The command line displays:

```
Select male beams
```

Click on each beam that should receive the housing cut (the beam whose end or side will be notched to fit into the pocket). You can select multiple beams. Press **Enter** to confirm the selection.

### Step 4 -- Select Female Beams

The command line displays:

```
Select female beams
```

Click on each crossing beam that should receive the mortise pocket cut. You can select multiple beams. Any beam already selected as a male beam is automatically excluded from the female set to prevent conflicts. Press **Enter** to confirm.

### Step 5 -- Automatic Connection Generation

The script evaluates every possible male-female pair from your selections:

- **Parallel pairs** are silently skipped (no error message).
- Pairs where the **intersection falls outside** the female beam length are silently skipped.
- For each valid pair, the script creates a new TSL instance with the configured parameters.

If you selected 3 male beams and 2 female beams, up to 6 connection instances can be created (one per valid pair).

### Step 6 -- Review and Adjust

Each created connection instance is immediately visible in the viewport. You can:

1. **Select a connection instance** and modify its properties in the Properties Panel (OPM).
2. **Drag the interactive grips** to adjust depth or vertical offset visually (see the Grips section below).
3. **Right-click** on a connection instance to access additional options (see the Context Menu section below).

## Properties Panel (OPM Parameters)

All parameters are organized into three categories and labeled with letter prefixes (A through J) for easy reference.

### Category: Tool Shape

| Property | Label | Type | Default | Description |
|---|---|---|---|---|
| Extend mortise | A | Dropdown (Yes / No) | No | When set to **Yes**, the mortise pocket in the female beam is extended upward to reach the top edge of the female beam. Use this when the male beam must sit flush with the top face of the female beam. |
| Mortise shape | B | Dropdown | Minimum | Controls the geometry of the pocket at the angled contact zone. See the detailed explanation below. |
| Round Type | C | Dropdown | not rounded | Defines how the corners and edges of the mortise tool are treated. Five options available. When Mortise shape is set to **Normal**, this setting is forced to "not rounded" regardless of selection. |
| Mortise depth | D | Number (mm) | 20 mm | The depth of the housing cut into the female beam, measured perpendicular to the contact face. Values of zero or below are automatically corrected to 1 mm with a warning message. |

#### Mortise Shape Options (Parameter B)

| Option | Behavior |
|---|---|
| **Minimum** | All four sides of the male beam cross-section are milled at the contact zone. The pocket is sized to the minimum footprint of the angled intersection. Uses a `ParHouse` tool internally. |
| **Normal** | The inner side of the angled pocket receives a chamfered edge, creating a cleaner fit for oblique connections. Uses a `ChamferedLap` tool internally. The Round Type (C) is always forced to "not rounded" in this mode. |
| **Maximum** | The pocket is enlarged to eliminate any air gap between the male and female beams. Typically only two sides of the male beam are milled. Uses a `ParHouse` tool internally. |

#### Round Type Options (Parameter C)

| Option | Effect |
|---|---|
| not rounded | Sharp corners on the mortise pocket |
| round | Corners are rounded with the standard tool radius |
| relief | Corners include a relief cut (small notch) for CNC tool clearance |
| rounded with small diameter | Corners are rounded with a smaller radius |
| relief with small diameter | Relief cut with a smaller notch diameter |

### Category: Tool Offsets

| Property | Label | Type | Default | Description |
|---|---|---|---|---|
| Offset vertical | E | Number (mm) | 30 mm | Shifts the housing center point along the height direction of the male beam cross-section. Positive values move the joint toward the top of the male beam. Use this to align the joint position when the beam intersection does not correspond to the desired joint location. |
| Offset right | F | Number (mm) | 0 mm | Shifts the housing boundary inward from the right side of the contact zone. A positive value narrows the housing on the right side, effectively trimming the male beam on that edge. |
| Offset left | G | Number (mm) | 0 mm | Shifts the housing boundary inward from the left side of the contact zone. A positive value narrows the housing on the left side. |

### Category: Tool Gaps

| Property | Label | Type | Default | Description |
|---|---|---|---|---|
| Gap in depth | H | Number (mm) | 5 mm | Additional clearance added to the mortise depth beyond the nominal depth. The **actual cut depth** in the female beam equals **Mortise depth (D) + Gap in depth (H)**. This provides assembly clearance so the male beam does not bottom out in the pocket. |
| Gap right | I | Number (mm) | 0 mm | Lateral clearance added to the right side of the mortise opening in the female beam. Negative values are supported to create a tighter-than-nominal fit. |
| Gap left | J | Number (mm) | 0 mm | Lateral clearance added to the left side of the mortise opening in the female beam. Negative values are supported. |

## Interactive Grips

Each connection instance provides two diamond-shaped grips for visual, interactive adjustment:

| Grip | Name | Location | Drag Direction | Controlled Parameter |
|---|---|---|---|---|
| 1 | Depth | On the contact face, offset by the current mortise depth along the joint normal | Along the joint normal (into/out of the female beam) | Mortise depth (D) |
| 2 | OffsetY | On the bottom edge of the contact zone, offset by the current vertical offset | Along the height direction of the male beam | Offset vertical (E) |

### Grip Behavior Details

- **Depth grip**: While dragging, a semi-transparent preview of the male beam cross-section is displayed at the new depth position, with displacement lines showing the movement. The depth value cannot be set to zero or negative; the minimum is constrained.
- **OffsetY grip**: While dragging, a semi-transparent preview of the male beam cross-section is shown at the new offset position. If dragged close to the top of the contact zone (within 20 mm), the grip turns red to indicate you are approaching the limit. The offset cannot be negative (dragging below the bottom edge snaps to zero).

Both grips update the corresponding OPM property value when released, and the connection geometry recalculates immediately.

## Right-Click Context Menu

| Menu Item | Condition | Description |
|---|---|---|
| Swap Mortise Extension | Visible only when **Extend mortise (A)** is set to **Yes** | Toggles the direction in which the mortise extension reaches toward the top face of the female beam. Use this when the extension goes in the wrong direction relative to the joint geometry. The setting is stored in the instance data and persists across recalculations. |

If "Extend mortise" is set to No, the Swap Mortise Extension option does not appear in the context menu.

## How the Tool Geometry Works

Understanding the internal logic helps when troubleshooting unexpected results:

1. **Contact detection**: The script projects the male beam cross-section onto the contact plane between the two beams and intersects it with the female beam's contact face. If the overlapping area is near-zero, the script reports "No tool contact found" and erases itself.

2. **Female beam tool**: Depending on the Mortise shape setting, either a `ParHouse` (Minimum/Maximum) or `ChamferedLap` (Normal) tool is applied to the female beam. The tool dimensions are calculated from the contact zone width (adjusted by left/right offsets and gaps) and height (adjusted by vertical offset and optional top extension).

3. **Male beam tool**: The male beam receives a combination of cuts:
   - A primary **cut or housing** at the mortise depth to shape the tenon end.
   - **BeamCut** operations at the top and/or bottom of the contact zone if vertical offset is applied or relief rounding is active, ensuring the male beam fits precisely.
   - **BeamCut** operations on the left and/or right sides if lateral offsets are applied or relief is active.
   - When the contact geometry is non-standard (not aligned with the female beam's depth axis), a **FreeProfile** milling path is used instead, enabling CNC universal mill operations.

4. **Display**: The connection is visualized with a semi-transparent filled profile at the cut depth, a line from the midpoint to the cut face, and (when vertical offset is positive) a line showing the offset displacement. A small circle marks the center of the cut face.

## Relationship Between Offsets and Gaps

It is important to understand the distinction between offsets and gaps:

- **Offsets (E, F, G)** change the **position and size** of the housing on the male beam. They shift or narrow the actual joint geometry.
- **Gaps (H, I, J)** add **clearance** to the mortise pocket in the female beam only. They make the pocket slightly larger than the male beam's tenon to allow for assembly tolerance.

The male beam is cut to the nominal dimensions (after offsets), while the female beam pocket is cut to the nominal dimensions plus the gap values.

## Tips and Best Practices

- **Batch insertion**: Select all male beams first, then all female beams. The script handles all valid combinations automatically. This is much faster than inserting connections one pair at a time.
- **Parallel beam warning**: If no connections are created despite selecting beams, verify that the beams are not parallel. Parallel pairs are silently skipped without any error message.
- **Depth validation**: The mortise depth (D) cannot be zero or negative. If you enter such a value, the script automatically corrects it to 1 mm and displays a warning on the command line.
- **Negative gaps for tight fits**: Gap right (I) and Gap left (J) accept negative values. A negative gap creates a pocket that is slightly smaller than the male beam, which can be useful for press-fit joints.
- **Mortise shape and rounding interaction**: When Mortise shape (B) is set to **Normal** (chamfered lap), the Round Type (C) setting is ignored and forced to "not rounded". Switch to Minimum or Maximum if you need rounding or relief cuts.
- **Swap direction after enabling extension**: After setting Extend mortise (A) to Yes, if the extension goes in the wrong direction, right-click the connection and select **Swap Mortise Extension** rather than trying to adjust offset values.
- **"No tool contact found" message**: This means the male and female beams do not have a valid geometric intersection within their modeled lengths. Check that the beams actually cross within their boundaries, and that neither beam is too short to reach the other.
- **CNC compatibility**: When the connection produces non-standard geometry (beveled cuts that cannot be described by simple housing tools), the script automatically uses FreeProfile with universal mill CNC mode, ensuring the geometry is machinable.
- **Dark/light theme support**: The visual display automatically adapts to the current AutoCAD background color (dark or light theme), so the connection visualization remains visible in both modes.

## Troubleshooting

| Symptom | Cause | Solution |
|---|---|---|
| No connection created, no error message | Selected beams are parallel to each other | Verify beam angles; parallel pairs are silently skipped |
| "No tool contact found" message, instance erased | Beams do not physically intersect within their modeled lengths | Extend one or both beams so they overlap, or check beam positions |
| Mortise extends in the wrong direction | Extension direction does not match the joint geometry | Right-click the instance and select **Swap Mortise Extension** |
| Round Type has no effect | Mortise shape is set to Normal | Change Mortise shape to Minimum or Maximum to enable rounding options |
| Depth value resets to 1 mm | A zero or negative value was entered | Enter a positive value greater than 0 for Mortise depth |
| Grip turns red while dragging | Vertical offset is approaching the top limit of the contact zone | The offset is being clamped to prevent the housing from exceeding the beam cross-section |
| Male beam has sharp edges despite relief setting | Version issue (fixed in v2.2) | Ensure you are using version 2.2 or later of this script |
