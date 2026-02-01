# Corner Bracket TSL

## Overview
Automates the placement of specific through-drills (27mm and 11mm diameters) at fixed heights on the end studs of a timber wall frame for corner bracket assembly. This script prepares wall panels for structural fasteners by applying precise pre-drilling operations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space and attaches to Wall Elements. |
| Paper Space | No | Not designed for Shop Drawings or 2D views. |
| Shop Drawing | No | Operations are applied to the physical model for production. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Timber Wall Element).
- **Minimum Beam Count**: The selected wall element must contain generated beams (studs).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `Corner Bracket TSL.mcr` from the script list.

### Step 2: Select Wall Elements
```
Command Line: Select a set of elements
Action: Click on the desired Wall Elements in your model and press Enter.
```
*Note: The script will automatically process all selected elements.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(None Exposed)** | N/A | N/A | **No editable properties are displayed in the Properties Palette.**<br><br>However, the script applies the following fixed configurations internally: |
| **27mm Diameter** | Fixed | 27.0 mm | Size of the main structural holes. |
| **11mm Diameter** | Fixed | 11.0 mm | Size of the secondary/dowel holes. |
| **Drill Depths** | Fixed | 400.0 mm | Drills penetrate 400mm into the material. |
| **Heights (27mm)** | Fixed | Specific Set | Holes placed at offsets 108.4, 198.4, 267.4, etc., from Base/Top. |
| **Heights (11mm)** | Fixed | Specific Set | Holes placed at offsets 153.4, 560.9, 1110.9 from Base/Top. |

> **Note:** To change drill sizes or heights, the script code must be edited by a TSL developer.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom options to the right-click context menu. Standard options like *Erase* or *Update* apply. |

## Settings Files
- No external settings files are used. All configurations are hardcoded within the script.

## Tips
- **Target Selection**: The script specifically targets the first and last beam (end studs) of the wall element, sorted perpendicular to the wall's X-axis. Intermediate studs are ignored.
- **Visualization**: Blue indicator lines will appear in the model showing the center points of the drilled holes to help verify placement.
- **Regeneration**: If you modify the wall geometry (e.g., change height or stud spacing), the machining positions will update automatically upon recalculation.

## FAQ
- **Q: Why can't I change the drill diameter in the Properties Palette?**
  - A: The script parameters are not exposed as editable properties. The diameters (27mm and 11mm) are fixed constants in this version of the script.
- **Q: The script didn't create any holes. What went wrong?**
  - A: Ensure you selected a valid `ElementWallSF` (Wall) and that the wall has already been generated/expanded to show its internal beams (studs). The script requires valid studs to function.
- **Q: Can I use this on a single beam?**
  - A: No, this script is designed to attach to Wall Elements (`ElementWallSF`) and specifically looks for the end studs within that wall assembly.