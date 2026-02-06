# SwapBeamWidthHeight.mcr

## Overview
This script allows you to rotate the cross-section of selected timber beams by swapping their width and height values. It corrects the beam orientation (e.g., changing a beam from lying flat to standing upright) while keeping the beam's position in the 3D model exactly the same.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where beam entities exist. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | This is a model modification tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: At least one existing Beam (Glulam, CLT, Solid Timber) in the drawing.
- **Minimum Beam Count**: 1 (Multiple beams can be selected at once).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Navigate to the folder containing `SwapBeamWidthHeight.mcr`.
3. Select the file and click **Open**.

### Step 2: Select Beams
```
Command Line: Select beams
Action: Click on the beam(s) you wish to modify, then press Enter.
```
*Note: You can select multiple beams using a window selection or by picking them individually.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any properties in the AutoCAD Properties Palette. It runs immediately upon selection. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add any custom options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Quick Correction**: Use this tool when you realize a beam was drawn with the wrong rotation (e.g., the width is actually the height).
- **No Geometry Movement**: The script only updates the profile dimensions and orientation data; it does not move the start or end points of the beam.
- **Self-Deleting**: The script instance removes itself from the drawing immediately after processing, so you do not need to delete it manually.

## FAQ
- **Q: Can I use this on curved beams?**
  - A: Yes, as long as the entity is recognized as a standard Beam in hsbCAD, the cross-section dimensions will be swapped.
- **Q: Does this affect the material or machining?**
  - A: The script only swaps the width (Y-axis) and height (Z-axis). If your material or machining rules are dimension-dependent, they will update to the new dimensions automatically.
- **Q: Why did the script disappear after I ran it?**
  - A: This is a "command" style script designed to perform an action and then clean itself up. The changes are applied directly to the selected beams.