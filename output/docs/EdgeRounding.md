# EdgeRounding.mcr

## Overview
Applies a parametric convex rounding (bullnose) to the top or bottom longitudinal edges of selected timber beams. This script generates both the 3D material removal (visual model) and the specific CNC toolpath required for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D GenBeam entities. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D shop drawing annotations directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (General Beam) must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: Ensure your CNC machine configuration (Catalog) includes the tool index specified in the script properties.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `EdgeRounding.mcr`.

### Step 2: Configure Parameters
1. The script will load default properties.
2. You may adjust settings (Face, Radius, Tool Index, etc.) via the initial dialog or the Properties Palette (Ctrl+1) after insertion.

### Step 3: Select Beams
```
Command Line: Select GenBeam entities:
Action: Click on the beam(s) you wish to process.
```
*Note: The behavior differs slightly depending on whether you select one or multiple beams.*

### Step 4: Define Toolpath (Interactive Mode for Single Beam)
If only **one beam** is selected, the script enters interactive Jig mode:
```
Command Line: Specify start point or [Contour/Face]:
Action: Click a point on the edge where the rounding should start.
OR Type 'F' to flip between Top/Bottom face.
OR Type 'C' to select the entire beam contour automatically.
```
```
Command Line: Specify end point:
Action: Click the point on the edge where the rounding should end.
```
*If **multiple beams** are selected, the script automatically applies the rounding based on the full beam length or current defaults, skipping the point-picking step.*

### Step 5: Finalize
The script calculates the cut and generates the CNC data.
- If the path is too short or parameters are invalid, the script will erase itself and display an error.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFace | Dropdown | Bottom Face | Selects which side of the beam receives the rounding (Top Face or Bottom Face). |
| dRadius | Number | 40.0 | The radius of the convex milling cutter (e.g., R40, R80). |
| dEdge | Number | 40.0 | The offset distance from the face where the profile begins. *Must be smaller than the Radius.* |
| sOvershoot | Boolean | No | If 'Yes', extends the milling path slightly beyond the start/end points for a cleaner finish (fade-in/out). *Only available for single beam selection.* |
| nToolIndex | Number | 50 | The CNC Tool ID number. Must match a tool defined in your machine's post-processor configuration. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the rounding between the Top Face and Bottom Face of the beam. |
| Update | Recalculates the geometry if manual edits or changes occurred. |
| Erase | Removes the rounding instance and restores the original beam volume. |

## Settings Files
- **Filename**: None specific.
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD Catalogs for CNC tool definitions rather than custom XML settings files.

## Tips
- **Multi-Beam Limitation**: When selecting multiple beams at once, the "Overshoot" feature is automatically disabled. If you need overshoot on specific beams, insert the script on them one by one.
- **Parameter Logic**: The `dEdge` (Offset) is constrained by the `dRadius`. If you try to set the Offset larger than the Radius, the script will automatically reduce the Offset to match the Radius.
- **CNC Export**: Always double-check the `nToolIndex` in the properties palette. If this number does not exist in your CNC machine's tool list, the manufacturing code generation will fail or use the wrong tool.

## FAQ
- **Q: Why can't I pick start and end points when I select multiple beams?**
  - A: The script simplifies batch processing by skipping the interactive Jig mode. It defaults to the full beam contour for multiple selections.
- **Q: What does "Overshoot" actually do?**
  - A: It creates a lead-in and lead-out path for the machine head. This ensures the roundover starts smoothly off the material and doesn't leave a sharp corner exactly at the clicked start point.
- **Q: The script disappeared after I inserted it.**
  - A: This usually happens if the resulting tool path length is zero or if the specified Edge Offset was invalid (e.g., negative). Check your inputs and try again.