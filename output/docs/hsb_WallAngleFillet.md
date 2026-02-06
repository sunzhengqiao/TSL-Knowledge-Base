# hsb_WallAngleFillet.mcr

## Overview
This script automatically generates corner fillet (wedge) timbers to fill the void between two perpendicular timber frame walls. It includes options to miter the top and bottom plates of the existing walls to accept the new corner pieces.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not intended for detailing views. |

## Prerequisites
- **Required Entities**: Two `ElementWall` entities that intersect at a corner (perpendicular).
- **Minimum Beam Count**: 0 (The script creates the new beams).
- **Required Settings**: `Materials.xml` must exist in your hsbCAD company directory (`_kPathHsbCompany\Abbund\`).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_WallAngleFillet.mcr` from the file dialog.

### Step 2: Select Walls
```
Command Line: Select 2 Elements
Action: Click on the first wall, then click on the second wall.
```
*Note: The two walls must be connected and form a corner (usually 90°). If they are parallel or not touching, the script will fail.*

### Step 3: Configure (Optional)
After selection, the script generates the corner pieces. You can immediately modify the settings using the Properties Palette (Ctrl+1) while the script instance is selected. Changes will trigger a regeneration of the timber.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Stretch Top and Bottom Plate | Dropdown | No | If **Yes**, the top and bottom plates of the existing walls are cut (mitered) to meet the corner. If **No**, the fillets are created full height between the plates. |
| Create a Full Solid Beam | Dropdown | No | If **Yes**, creates one single solid wedge. If **No**, creates two separate half-wedges (one attached to each wall). |
| Name | Text | Fillet | The name assigned to the generated beams for scheduling. |
| Material | Dropdown | Dynamic | The timber material to use (pulled from Materials.xml). |
| Grade | Text | (Empty) | Structural grade of the timber (e.g., C24). |
| Information | Text | (Empty) | Additional manufacturing notes. |
| Label | Text | (Empty) | Primary label text for the piece. |
| Sublabel | Text | (Empty) | Secondary label text. |
| Sublabel2 | Text | (Empty) | Tertiary label text. |
| Set Fillets as NO Nail | Dropdown | No | If **Yes**, appends "NO" to the beam code to indicate no nailing required. |
| Color | Number | 32 | The AutoCAD color index for the generated beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reapply Timbers | Deletes the currently generated corner beams and regenerates them based on the current property settings and wall geometry. Useful if the wall geometry has changed manually. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\Materials.xml`
- **Purpose**: Provides the list of available timber materials for the "Material" dropdown property. If this file is missing, the script will display an error and exit.

## Tips
- **Wall Connection**: Ensure the walls you select actually touch or intersect at their ends. The script validates for connected, non-parallel walls.
- **Mitering**: If you want a clean corner where the top and bottom plates meet at a 45-degree angle, set "Stretch Top and Bottom Plate" to **Yes**.
- **Solid vs Split**: Use the "Create a Full Solid Beam" option depending on your manufacturing preference. Two split beams are often easier to handle on site than one large wedge.

## FAQ
- **Q: Why did the script disappear immediately after I selected the walls?**
  **A:** The most common cause is a missing or empty `Materials.xml` file. Check that your Company settings path is correct and the file contains materials. Alternatively, the walls might not be connected or might be parallel.

- **Q: Can I use this on walls that are not at 90 degrees?**
  **A:** The script is designed for perpendicular intersections. It checks if walls are parallel; however, acute or obtuse angles may result in unexpected geometry.

- **Q: What happens if I change the wall height after running the script?**
  **A:** The script does not automatically update if the wall properties change. Select the script instance and right-click **Reapply Timbers** to update the fillets to the new wall height.