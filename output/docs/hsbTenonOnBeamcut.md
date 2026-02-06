# hsbTenonOnBeamcut.mcr

## Overview
Automatically generates a tenon (male) and mortise (female) connection between two beams using solid intersection logic. This script is particularly useful for complex intersections, such as cuts on hip rafters or half-logs, where standard centerline calculations may fail.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script performs 3D solid operations on beams. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D views or labels. |

## Prerequisites
- **Required Entities**: At least 2 Beams (GenBeam).
- **Minimum Beam Count**: 2 (One male, one female).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbTenonOnBeamcut.mcr`.

### Step 2: Configure Parameters (Optional)
Dialog: Dynamic Properties Dialog
Action: Adjust default values for Width, Depth, and Orientation before selecting beams if desired. You can also change these later in the Properties Palette.

### Step 3: Select Male Beam(s)
```
Command Line: Select male beam(s)
Action: Click on the beam(s) that will have the tenon (protrusion) created.
```

### Step 4: Select Female Beam(s)
```
Command Line: Select female beam(s)
Action: Click on the beam(s) that will have the mortise (slot/recess) cut into it.
```

### Step 5: Finish Selection
Action: Press `Enter` or `Right-click` to confirm selection. The script will automatically detect intersections and create the joinery.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Number | 40 | Defines the width (thickness) of the tenon cheek. |
| **Depth** | Number | 50 | Defines the length of the tenon (how far it penetrates into the female beam). |
| **Shape** | Dropdown | Rectangular | Sets the profile shape of the tenon. Options: Rectangular, Round, Rounded. |
| **Offset 1** | Number | 0 | Aligns the tenon laterally along the primary axis of the intersection. |
| **Offset 2** | Number | 0 | Aligns the tenon laterally along the secondary axis. |
| **Offset from axis** | Number | 0 | Shifts the tenon position relative to the beam's centerline axis. |
| **Orientation** | Dropdown | Parallel female beam | Determines how the tenon is rotated relative to the beams. Options: Parallel female beam, Perpendicular female beam, Parallel with projected Z-axis of tenon beam, Perpendicular to projected Z-axis of tenon beam. |
| **Tolerance length left** | Number | 0 | Adds clearance to the left side of the mortise slot. |
| **Tolerance length right** | Number | 0 | Adds clearance to the right side of the mortise slot. |
| **Tolerance depth** | Number | 0 | Adds clearance (gap) to the depth of the mortise slot. |
| **Gap on Length** | Number | 0 | Adds an additional gap along the length of the connection. |

## Right-Click Menu Options
No specific context menu options are added by this script. Standard hsbCAD element options apply.

## Settings Files
No external settings files are required for this script.

## Tips
- **Complex Geometry**: This script calculates the connection based on the actual 3D solid bodies of the beams. If your beams are already cut (e.g., hip rafters with purlin cuts), this script will align the tenon to the cut face automatically.
- **Adjusting Orientation**: If the tenon appears rotated 90 degrees incorrectly, use the **Orientation** dropdown in the Properties Palette to switch between Parallel and Perpendicular modes.
- **Moving Beams**: You can move the beams after insertion using AutoCAD grips or move commands. The script will detect the change and recalculate the intersection geometry automatically.
- **Batch Processing**: You can select multiple male beams and multiple female beams during the insertion prompts. The script will attempt to find valid T-connections between all selected pairs.

## FAQ
- **Q: The script ran, but no tenon appeared.**
- **A: Ensure the beams physically touch or overlap in 3D space. This script relies on solid body intersections; if there is a gap between the beams, no tool is generated.
- **Q: Can I use this for curved beams?**
- **A: Yes, provided the solid bodies of the beams intersect.
- **Q: How do I make the slot looser?**
- **A: Increase the **Tolerance depth** or **Tolerance length** properties in the Properties Palette. This increases the size of the female slot without changing the male tenon size.