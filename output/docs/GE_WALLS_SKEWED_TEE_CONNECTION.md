# GE_WALLS_SKEWED_TEE_CONNECTION.mcr

## Overview
This script automates the creation of structural reinforcement (such as blocking, studs, or ladders) and sheathing cuts for skewed (angled) T-connections between two timber walls. It handles non-90-degree intersections by generating custom geometry tailored to the specific angle of the walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in the 3D model where the walls exist. |
| Paper Space | No | Not intended for 2D drawings. |
| Shop Drawing | No | Does not generate 2D views directly. |

## Prerequisites
- **Required Entities**: Two `ElementWall` entities.
- **Configuration**: The two walls must physically touch or overlap.
- **Geometry**: The walls must form a skewed intersection (neither parallel nor perpendicular/90°).
- **Context**: Walls must be in Model Space.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `GE_WALLS_SKEWED_TEE_CONNECTION.mcr`.

### Step 2: Configure Initial Properties
**Dialog**: Properties Palette (OPM)
Action: Upon insertion, a dialog will appear (only once). You can set the connection type, material, and gaps here or modify them later in the Properties Palette.

### Step 3: Select Walls
```
Command Line: Select 2 angled elements
Action: Click on the two walls that form the skewed T-junction.
```

### Step 4: Validation
Action: The script checks if the walls are connected and if the angle is valid.
- **Note**: If the walls are perpendicular (90°), parallel, or not touching, the script will erase itself or display an error on the command line.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connection type | dropdown | Simple | Determines the reinforcement style: **Simple** (blocking), **Simple L**, **Ladder** (inserts sub-assembly), or **3 studs**. |
| Sheeting limits | number | 3.175 mm | The distance from the structural intersection where the wall sheathing is cut or stopped. |
| Beam color | number | 3 | The color index used to display the new structural elements in the model. |
| Lap VTP's | dropdown | No | If **Yes**, vertical timber/plate members overlap at the connection. If **No**, they butt against each other. |
| End gap (VTP) | number | 3.175 mm | Clearance distance at the ends of Vertical Timber/Plate members. |
| Side gap (VTP) | number | 3.175 mm | Clearance distance along the sides of Vertical Timber/Plate members. |
| End gap (BtmP, TP) | number | 0 | Clearance distance at the ends of Bottom and Top plates generated at the connection. |
| **All new beams info** | **Header** | | *Section for new beam attributes* |
| Name | text | SYP #2 2x4 | The commercial name or size (e.g., 2x4) of the lumber stock used for new elements. |
| Material | text | SYP | The material species designation (e.g., SPF, SYP). |
| Grade | text | #2 | The structural grade of the lumber (e.g., #2, SS). |
| Cut sheeting on female wall | dropdown | Yes | If **Yes**, automatically cuts the sheathing on the wall being intersected (female wall) to fit the connection. |

## Right-Click Menu Options
No custom context menu options are defined for this script. Use the standard AutoCAD Properties Palette to modify parameters.

## Settings Files
No external settings files are required for this script.

## Tips
- **Skewed Only**: This script is specifically designed for angles other than 90 degrees. Do not use it for standard orthogonal corners.
- **Ladder Option**: If you select **Ladder** as the connection type, the script automatically inserts a sub-instance of `GE_WDET_AUTOLADDER` to handle the detailing.
- **Visual Feedback**: If the script disappears immediately after selection, check the command line for errors. This usually means the walls were perpendicular or not physically touching.
- **Dynamic Updates**: After insertion, you can change the `Connection type` in the Properties Palette to instantly switch between blocking styles without re-inserting.

## FAQ
- **Q: Why did the script delete itself after I selected the walls?**
  **A**: The script performs strict validation. It likely detected that the walls were perpendicular (90°), parallel, or not forming a valid T-junction. Ensure the walls intersect at a skewed angle and are touching.
- **Q: Can I use this to connect walls that meet at a 45-degree angle?**
  **A**: Yes, this is the intended use case. It calculates geometry based on the exact skew angle.
- **Q: How do I prevent the script from cutting my sheathing?**
  **A**: Set the `Cut sheeting on female wall` property to **No** in the Properties Palette.