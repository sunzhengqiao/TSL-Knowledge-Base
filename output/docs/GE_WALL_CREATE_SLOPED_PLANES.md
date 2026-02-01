# GE_WALL_CREATE_SLOPED_PLANES.mcr

## Overview
This script generates Roof Plane entities (ERoofPlane) based on the top surface envelope of selected wall elements. It is typically used to define roof geometry for calculations or visualization when a wall element represents a sloped roof structure.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where Element entities exist. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for manufacturing drawings. |

## Prerequisites
- **Required entities**: At least one valid Element (wall) entity in the drawing.
- **Minimum beam count**: 0 (Beams are not processed, only Element envelopes).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_CREATE_SLOPED_PLANES.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: |Select elements|
Action: Click on one or more wall elements in the model and press Enter.
```
**Note**: The script will automatically process the selection and generate roof planes for each valid element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | Dropdown | (None) | Defines the dimension style. **Note:** This parameter is currently defined but not used by the script logic. Changing this value will not affect the output. |

## Right-Click Menu Options
This script does not add specific options to the right-click context menu.

## Settings Files
No external settings files are required or used by this script.

## Tips
- **Visual Identification**: The generated Roof Planes are automatically colored **Red** and assigned to **Element Group 1** for easy filtering or selection later.
- **Script Behavior**: The script instance will automatically erase itself from the drawing immediately after generating the roof planes. The resulting planes are static geometry and are not linked back to the script for future updates.
- **Sloped Walls**: This tool is ideal for converting complex wall shapes (like gable ends or dormer cheeks) into roof planes for further processing.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: The script is designed to "self-destruct" after creating the geometry. The Roof Plane entities created are the intended output, and the script instance is no longer needed.
- **Q: Why does changing the DimStyle property do nothing?**
  A: While the DimStyle property appears in the properties palette, the current version of the script does not utilize it to generate dimensions or alter geometry. It can be safely ignored.