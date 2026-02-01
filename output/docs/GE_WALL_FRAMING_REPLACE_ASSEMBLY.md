# GE_WALL_FRAMING_REPLACE_ASSEMBLY

## Overview
This script replaces the generic framing at a wall-to-wall intersection (T-junction or L-corner) with a specific, user-defined engineering assembly. It automatically removes existing studs in the connection zone and inserts the new detail, allowing for adjustments to rotation and offset.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed to run strictly in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Two connected Walls (`ElementWall` or `ElementWallSF`) forming a valid T or L connection.
- **Geometry**: Walls must form a clean intersection. End-to-end connections are not supported.
- **Required Settings**: `hsbFramingDefaults.details.dll` (Provides the list of available assemblies).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `GE_WALL_FRAMING_REPLACE_ASSEMBLY.mcr`.

### Step 2: Select Intersection Point
```
Command Line: Select a point near a connection:
Action: Click near the intersection point of the two walls you wish to modify.
```
*Note: The script will automatically detect the two walls involved.*

### Step 3: Select Assembly
**Action**: A dialog box will appear displaying a list of available framing assemblies (e.g., "Corner_2Stud", "T-Junc_Firestop").
- Select the desired assembly pattern from the list.
- Click **OK**.

The script will then assign itself to the "Female" (receiving) wall, erase the old framing, and insert the new assembly.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assembly | Dropdown (String) | (First entry in library) | Selects the specific framing pattern or engineering detail to apply at the connection. |
| Rotate | Dropdown (Int) | 0 | Rotates the assembly around the vertical axis. Options: 0, 90, 180, 270 degrees. Use this to flip the detail orientation. |
| Offset | Number (Double) | 0.0 | Shifts the assembly along the length of the main (receiving) wall from the exact connection point. Use positive or negative values to move it left or right. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to modify Assembly, Rotation, or Offset settings. |
| Erase | Removes the script instance from the wall. |

## Settings Files
- **Filename**: `hsbFramingDefaults.details.dll` (or associated configuration)
- **Location**: hsbCAD installation directory or Company standards folder.
- **Purpose**: This external library provides the list of valid assembly names and their definitions used in the selection dialog.

## Tips
- **Orientation**: If the inserted assembly is facing the wrong direction (e.g., into the wall instead of along it), use the **Rotate** property in the palette to change it to 90 or 270 degrees.
- **Positioning**: If the new assembly clashes with a door or window nearby, use the **Offset** property to slide it along the wall length.
- **Validation**: Ensure your walls are properly joined in an "L" or "T" shape before running the script. If the script disappears immediately after selection, the connection may not be valid (e.g., the walls might just be touching end-to-end).

## FAQ
- **Q: Why did the script disappear immediately after I clicked the wall?**
  **A**: The script likely did not find a valid T or L connection. Ensure one wall runs fully into the side of the other, rather than just touching end-to-end.
- **Q: Can I use this to connect two walls that don't touch yet?**
  **A**: No. The walls must already be drawn and intersecting in the model for the script to detect the connection point.
- **Q: Does this script work on Shop Drawings?**
  **A**: No, this is a Model Space scripting tool for generating 3D model geometry.