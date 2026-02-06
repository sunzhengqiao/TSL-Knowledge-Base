# hsb_Spandrel_Marking

## Overview
This script automatically generates layout marks on the sill plates (bottom plates) of stick frame walls. It calculates and marks the exact landing positions of angled studs (spandrel or gable studs) to assist in manufacturing and assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: `ElementWall` (Stick Frame Wall).
- **Minimum Requirements**: The wall must contain angled/sloped beams (gable condition) and horizontal sill plates (bottom plates).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_Spandrel_Marking.mcr` from the list.
3. Alternatively, run the script via a custom toolbar button or catalog key if configured.

### Step 2: Select Wall Element
```
Command Line: Select element(s)
Action: Click on the Stick Frame Wall that requires spandrel marking.
```
*Note: You can select multiple walls if needed.*

### Step 3: Configuration (Optional)
- If a default Catalog Key is not assigned, a properties dialog may appear.
- Adjust the **Offset for mark** if the default position is not suitable.
- Click **OK** or **Insert** to confirm.

### Step 4: Generation
- The script analyzes the wall geometry to identify angled studs and sill plates.
- It projects the intersection points onto the plates and draws "Mark" entities.
- The script instance will erase itself after generating the marks to keep the drawing clean.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset for mark | Number | 5.0 mm | Defines the distance from the calculated intersection point where the mark is placed on the plate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu options. Standard properties can be edited via the Properties Palette. |

## Settings Files
- **Filename**: *None*
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Adjusting Marks**: If you need to shift the marks after insertion, select the generated marks in the model and adjust the **Offset for mark** property in the Properties Palette (OPM).
- **Wall Geometry**: Ensure your wall has a continuous bottom plate. If the script cannot find a valid sill plate or angled beams, it will delete itself silently.
- **Complex Walls**: For complex geometries, the script attempts a fallback method by looking for Studs with HSB ID 26 to determine mark positions.

## FAQ
- **Q: The script disappeared immediately after I ran it. Did it fail?**
  - A: Not necessarily. If the wall has no angled studs (e.g., it is a rectangular wall with a flat top) or if no sill plates were detected, the script erases itself automatically as there is nothing to mark.
- **Q: Can I move the marks manually?**
  - A: The marks are generated as static tools. While they can be moved using standard CAD commands, it is recommended to adjust the **Offset for mark** parameter to maintain associativity with the wall logic.
- **Q: How do I update the marks if I change the wall shape?**
  - A: Modify the wall geometry (e.g., change the roof pitch) using standard hsbCAD tools. The script instance (if it still exists) or a re-run of the script will update the positions based on the new geometry.