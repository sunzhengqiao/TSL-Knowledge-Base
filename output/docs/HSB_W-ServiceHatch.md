# HSB_W-ServiceHatch

## Overview
This script automatically identifies and visualizes potential locations for service hatches (utility pass-throughs) on selected wall elements. It calculates these locations near wall openings and connections, ensuring there is sufficient clearance between structural studs for pipes or cables.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements (`ElementWallSF`). |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for manufacturing views. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Wall Elements).
- **Minimum Beam Count**: N/A (Script requires Wall Elements, not beams).
- **Required Conditions**: The selected walls must contain either **Openings** (windows/doors) or **Connected Elements** (wall intersections). Walls without these features will report an error and not generate hatch locations.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-ServiceHatch.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Elements you wish to analyze. Press Enter to confirm selection.
```

### Step 3: View Results
The script will process the selected walls. If valid locations are found (based on the default gap size), visual markers (points) will appear on the wall indicating the start and end of the service hatch locations.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum Required Gap | Number | 200 mm | The minimum width of the clear opening required between studs. The script will only display hatch locations where the space between studs is equal to or larger than this value. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | There are no custom context menu options for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Adjusting Sensitivity**: If you see too many potential locations, increase the **Minimum Required Gap** value in the Properties Palette. If you see too few, decrease it.
- **Sheeting Required**: The script looks for the vertical edge of sheeting (cladding) material to refine the hatch location. Ensure your wall definition includes sheet material for accurate results.
- **Dynamic Updates**: If you modify the wall structure (e.g., move a stud or resize a window), the service hatch visualization will automatically update to reflect the new geometry.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  A: This is normal behavior. The script acts as a "master" that creates "satellite" instances attached to each specific wall. The master instance deletes itself once the satellites are created.
- **Q: No points appeared on my wall. Why?**
  A: This usually happens for two reasons:
  1. The wall has no openings or connected walls/elements to use as reference points.
  2. The gap between the studs at the reference points is smaller than the **Minimum Required Gap** (default 200mm). Try reducing this value in the Properties Palette.
- **Q: Can I use this on walls without sheathing?**
  A: The script attempts to locate the vertical edge of the sheet material. If no sheet profile is found at the calculated location, that specific location is skipped.