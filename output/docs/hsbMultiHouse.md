# hsbMultiHouse.mcr

## Overview
Automates the creation of housed timber joinery (T-connections) where intersecting male beams are tenoned or cut to fit into a recess in female beams or wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in 3D model space to create and modify beams. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Male beams (to be tenoned) and Female beams or a Wall Element (to receive the pocket).
- **Minimum Beam Count**: 2 (at least one male and one female).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbMultiHouse.mcr` from the file dialog.

### Step 2: Select Male Beams
```
Command Line: Select male beam(s)
Action: Click on the beams that will be cut or tenoned (the intersecting beams).
```
*Note: You can select multiple beams.*

### Step 3: Select Female Entity
```
Command Line: Select intersecting wall or female beam(s)
Action: Click on the main beam, log wall element, or collection of beams that form the receiving side of the connection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Depth** | Number | 50 mm | Defines the depth of the tenon on the male beam and the pocket in the female beam. Can be adjusted using the grip point in the model. |
| **Relief** | Dropdown | not rounded | Sets the corner style of the joinery. Options include: not rounded, round, relief (chamfer), rounded with small diameter, relief with small diameter, rounded. |
| **Depth (Gap)** | Number | 0 mm | Clearance distance between the end of the male tenon and the bottom of the female pocket. |
| **Width (Gap)** | Number | 0 mm | Lateral clearance between the sides of the tenon and the walls of the pocket. |
| **Left (Offset)** | Number | 0 mm | Shifts the tool position to the left (negative Y-axis). |
| **Top (Offset)** | Number | 0 mm | Shifts the tool position upwards (positive Z-axis). |
| **Right (Offset)** | Number | 0 mm | Shifts the tool position to the right (positive Y-axis). |
| **Bottom (Offset)** | Number | 0 mm | Shifts the tool position downwards (negative Z-axis). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Recalculate) | Updates the joinery based on property changes or beam movements. |

## Settings Files
None required. The script uses internal parameters and manual property inputs.

## Tips
- **Adjusting Depth Quickly**: After insertion, select the script instance in the model. You will see a grip point (usually at the intersection face). Drag this grip to visually adjust the `Depth` property.
- **Simple Cut vs. Full Housing**: If you set **Relief** to "not rounded", **Gap Width** to 0, and ensure all **Offsets** are 0, the script will switch to a "Simple Cut" mode for the male beams instead of creating a full tenon.
- **Assembly Tolerances**: Use the **Gap Width** and **Gap (Depth)** properties to create play in the connection, ensuring parts fit together easily on site.

## FAQ
- **Q: Why is my male beam cut off flat instead of having a tenon?**
  **A:** This happens if **Relief** is set to "not rounded", **Gap Width** is 0, and all **Offsets** are 0. Change the Relief to "Round" or "Relief" to enable the full tenon geometry.

- **Q: Can I use this on log walls?**
  **A:** Yes, you can select a wall element as the "female" component during the second prompt.

- **Q: What happens if I delete a beam used by the script?**
  **A:** The script detects that its reference is missing, displays an error ("no male beams detected" or "No female beams found"), and erases itself to prevent errors.