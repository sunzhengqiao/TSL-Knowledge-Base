# HSB_E-Ladder.mcr

## Overview
This script transforms a single linear beam (such as a purlin or top plate) into a series of perpendicular "ladder" rungs or blocking members distributed along its length. It is typically used to create wind bracing or fixing sub-structures by replacing a continuous beam with smaller, spaced components.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Runs during element generation or via manual insertion. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This is a 3D generation script. |

## Prerequisites
- **Required Entities**: GenBeam (for manual execution) or Element (for automatic execution).
- **Minimum Beam Count**: 1 source beam.
- **Required Settings**: `HSB_G-Distribution` (Map configuration for distribution logic).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_E-Ladder.mcr` from the file list.

### Step 2: Select Source Beam
```
Command Line: Select beam to transform to ladder
Action: Click on the linear beam in the 3D model that you wish to replace with rungs.
```
*(Note: If run automatically on an element, the script filters beams based on the "BmCode Filter" property instead of prompting.)*

### Step 3: Configure Parameters
```
Action: Press Ctrl+1 to open the Properties Palette if not already visible.
Adjust parameters (e.g., Spacing, Dimensions, Distribution Mode) as required.
```

### Step 4: Execute
```
Action: The script processes immediately upon selection or property change.
The original beam is erased, and the new ladder rungs are generated.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sBmCodeFilter | String | -- | Filter to identify which source beams should be transformed. Only beams matching this code are processed automatically. |
| sBmCodeLadder | String | KSTL-01 | The material/grading code assigned to the newly generated ladder rungs. |
| Sdistribution | Enum | Left | Defines how rungs are positioned: Left, Right, Centre, At Rafter, On Grid, etc. |
| dThicknessLadder | Double | 48 mm | The width of the rung along the axis of the parent beam (extrusion length). |
| dHeightLadder | Double | 200 mm | The height/depth of the rung (perpendicular to the parent beam width). |
| dSpacingLadder | Double | 600 mm | The distance between centerlines of adjacent rungs. |
| dOffsetFirstLadder | Double | 0 mm | Distance from the start of the parent beam to the center of the first rung. |
| dOffsetLastLadder | Double | 0 mm | Distance from the end of the parent beam to the center of the last rung. |
| dOffsetRafterLadder | Double | 0 mm | Shift offset applied specifically when distributing relative to rafters. |
| placeFirstBeam | Boolean | Yes | Controls whether a rung is placed explicitly at the start offset position. |
| SPlaceLastBeam | Boolean | Yes | Controls whether a rung is placed explicitly at the end offset position. |
| SDistrEvenly | Boolean | No | If Yes, calculates exact spacing to fit an integer number of rungs within the bounds. |
| extrusionProfile | String | -- | Assigns a specific cross-section profile from catalogs to the rungs. |
| allowClashWithRafter | Boolean | No | If No, suppresses rung creation if it intersects with a detected rafter. |
| flipY | Boolean | No | Rotates the ladder rung 180 degrees around its own axis. |
| variableThicknessLadder | Integer | -1 | DSP index to override fixed thickness (-1 disables). |
| variableHeightLadder | Integer | -1 | DSP index to override fixed height (-1 disables). |
| variableSpacingLadder | Integer | -1 | DSP index to override fixed spacing (-1 disables). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script instance removes itself immediately after generating the beams. Standard recalculation is not available post-execution. |

## Settings Files
- **Filename**: `HSB_G-Distribution`
- **Location**: Company Standards or hsbCAD Install path
- **Purpose**: Provides configuration data for distribution logic, specifically when using "At Rafter" or "On Grid" modes to locate structural members.

## Tips
- Use the **Sdistribution** "At Rafter" mode to automatically align rungs with underlying structural rafters.
- If your rungs are not fitting perfectly between start and end points, enable **SDistrEvenly** to auto-calculate the spacing.
- If you notice missing rungs in the middle of the span, check if **allowClashWithRafter** is set to "No"; the script may be deleting rungs that overlap with rafters.

## FAQ
- **Q: Why did the original beam disappear?**
  A: The script is designed to erase the source beam and replace it with the individual ladder rungs.
- **Q: Why are no rungs being generated?**
  A: Check the **sBmCodeFilter** property to ensure it matches the code of the beam you selected. Also, verify that the calculated spacing does not exceed the beam length.
- **Q: Can I use variable sizes for the rungs?**
  A: Yes. Set the **variableThicknessLadder**, **variableHeightLadder**, or **variableSpacingLadder** indices to the corresponding Design Standard Property (DSP) indices to control dimensions dynamically.