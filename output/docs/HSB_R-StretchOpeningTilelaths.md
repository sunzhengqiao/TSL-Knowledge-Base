# HSB_R-StretchOpeningTilelaths

## Overview
Automatically extends roof tile laths (sheets) horizontally within openings so they rest directly on the nearest rafters. This script identifies specific lath materials, calculates the distance to supporting rafters, and regenerates the sheets to ensure proper structural bearing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment modifying Element geometry. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Does not generate 2D drawing annotations. |

## Prerequisites
- **Required Entities**: An Element (e.g., a wall or floor with roof properties) that contains both structural rafters and sheathing sheets in Zone 5.
- **Minimum Beam Count**: 0 (The script filters existing beams; no minimum count is required to start, though rafters must exist for the stretch to function).
- **Required Settings**: The material name specified in the script properties must exactly match the material name assigned to the sheets in the model.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `HSB_R-StretchOpeningTilelaths.mcr`.

### Step 2: Configure Properties
**Dialog:** Properties
Action:
1. A dialog appears automatically upon insertion.
2. Locate the **Material of tilelath to stretch** field.
3. Verify it matches the material name used for your tile laths (Default: `PANLAT O`).
4. Click **OK** to proceed.

### Step 3: Select Element
```
Command Line: Select one or more elements
Action: Click on the Element (wall/floor) containing the roof opening and tile laths you wish to modify.
```

### Step 4: Completion
**Action:** The script will process the selected Element. It will find the specified laths, calculate the new dimensions to reach the rafters, replace the old sheets with new ones, and then remove itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tilelath | Label | N/A | Visual separator header in the properties list. |
| Material of tilelath to stretch | Text | PANLAT O | The exact material name of the sheets you want to extend. Only sheets with this material will be modified. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is a "one-time" tool. It erases itself after execution to keep the drawing clean. There are no persistent right-click options available on the script instance. |

## Settings Files
- **Filename**: None specific (Standard Catalog entries may be used).
- **Location**: N/A
- **Purpose**: Catalog entries can be used to preset the `sMaterialToStretch` property so the dialog does not appear during insertion.

## Tips
- **Undo Function**: You can safely use the standard AutoCAD `UNDO` command if the results are not as expected.
- **Re-running**: Since the script deletes itself after running, you must run `TSLINSERT` again if you modify the roof and need to re-stretch the laths.
- **Zone 5**: Ensure your tile laths are assigned to Construction Zone 5, as the script specifically targets this zone.
- **Material Matching**: The material name is case-sensitive. Ensure the spelling in the properties matches the catalog exactly.

## FAQ
- **Q: I ran the script, but the laths didn't change. Why?**
  A: Check the **Material of tilelath to stretch** property. It likely does not match the actual material name assigned to the sheets in your model.
- **Q: Can I use this on curved roofs?**
  A: The script calculates distances based on coordinates. While it may work on segmented roofs, it is designed for typical conditions where rafters run perpendicular to the laths.
- **Q: Does this script work on Roof Planes?**
  A: No, the script explicitly skips Roof Plane entities and is designed for Elements (walls/floors).