# HSB_E-CheckMaximumAllowedSpacing.mcr

## Overview
This script verifies the spacing between vertical studs within a wall element against a defined maximum limit. If gaps are too wide, it visually highlights the error and optionally inserts new studs to ensure compliance with structural or manufacturing requirements.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model on hsbCAD Elements. |
| Paper Space | No | Not intended for 2D drawings or layouts. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities:** An existing hsbCAD **Element** (e.g., a wall) containing **GenBeams** (studs).
- **Minimum Beam Count:** The element should contain at least vertical members to calculate spacing.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the script location and select `HSB_E-CheckMaximumAllowedSpacing.mcr`.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall element(s) you wish to check and press Enter.
```
*Note: Once selected, the script will process the beams within those elements based on the current property settings.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Sequence number** | Number | 0 | Determines the execution order during automatic generation. Higher numbers run later. |
| **Filter beams with beamcode** | Text | [Blank] | Enter beam codes (e.g., `STUD;POST;`) to exclude specific beams from the spacing check. Leave blank to check all vertical beams. |
| **Maximum allowed spacing** | Number | 600 | The maximum distance allowed between two vertical studs (in current document units, usually mm). |
| **Automatic add Studs** | Dropdown | Yes | If "Yes", the script will insert new studs to fix spacing violations. If "No", it only reports errors visually. |
| **Color of the wrong beam** | Number | 1 | The AutoCAD color index used to highlight existing beams that are too far apart. |
| **Color of the added beam** | Number | 3 | The AutoCAD color index used to highlight any new studs that are automatically created. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| MasterToSatellite | Loads property settings from a pre-defined catalog entry, allowing you to quickly switch between different spacing standards (e.g., 400mm vs 600mm centers). |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Check Before Fixing:** Set **Automatic add Studs** to "No" initially. This allows you to visualize where the spacing violations are (via the wrong beam color) before the script actually modifies your wall geometry.
- **Filtering:** If your wall has posts or window trimmers that are naturally spaced further apart than studs, use the **Filter beams with beamcode** option to exclude them so they don't trigger false errors.
- **Order of Operations:** If running automatically via "Generate Construction", ensure the **Sequence number** is higher than your wall generation scripts so the studs exist before this script checks them.

## FAQ
- **Q: Can I undo the changes if the script adds unwanted studs?**
- **A: Yes, simply use the standard AutoCAD `UNDO` command after the script runs to remove the newly added beams.
- **Q: Why are some beams ignored even if the spacing is large?**
- **A: Check the **Filter beams with beamcode** property. You may have defined a filter that excludes specific beam types from the calculation.
- **Q: What unit does the spacing value use?**
- **A: The script uses the internal unit system (usually millimeters), but the input in the Properties palette should respect your current hsbCAD configuration. The default `U(600)` typically represents 600 mm.