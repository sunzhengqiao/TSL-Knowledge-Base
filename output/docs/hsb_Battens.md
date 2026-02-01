# hsb_Battens.mcr

## Overview
Generates structural timber battens (noggings/jack studs) around openings in wall elements. This script provides additional backing for sheathing or cladding where standard sheet layouts leave unsupported edges, specifically targeting vertical zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script manipulates 3D ElementWall entities. |
| Paper Space | No | Not intended for 2D drawing generation. |
| Shop Drawing | No | Operates in the 3D model environment. |

## Prerequisites
- **Required Entities**: An existing `ElementWall` containing openings.
- **Minimum Beam Count**: The wall must contain generated GenBeams (framing) before running this script.
- **Required Settings**: None (Script relies on internal wall zone distribution codes).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `hsb_Battens.mcr`.

### Step 2: Configure Properties (Optional)
*   If the script is run without a predefined configuration key, a properties dialog (or the AutoCAD Properties Palette) will appear.
*   Set options such as side gaps or whether to create extra battens above/below openings.

### Step 3: Select Wall Elements
```
Command Line: Select element(s)
Action: Click on the wall(s) you wish to process and press Enter.
```

### Step 4: Processing
*   The script automatically attaches to the selected walls.
*   It scans for wall zones marked as 'HSB-PL09' (Vertical Sheets).
*   It calculates geometry around openings and creates or merges the batten sheets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Create extra battens above opening** | Dropdown | Yes | If Yes, generates vertical battens in the top-left and top-right corners of the opening. |
| **Create extra battens below opening** | Dropdown | Yes | If Yes, generates vertical battens in the bottom-left and bottom-right corners of the opening. |
| **Side Gap** | Number | 0.0 mm | Sets the horizontal clearance distance between the opening jambs and the side battens. |
| **Zone index to exclude** | Integer | 0 | Identifies a specific wall layer index to skip (0 = process all layers). |
| **Top** (Vertical batten Gap) | Number | 0.0 mm | Defines a vertical cutout/gap at the top edge of the vertical battens. |
| **Bottom** (Vertical batten Gap) | Number | 0.0 mm | Defines a vertical cutout/gap at the bottom edge of the vertical battens. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Update** | Recalculates the batten geometry based on current wall properties or opening changes. |
| **Properties** | Opens the Properties Palette to edit parameters like gaps and exclusions. |
| **Erase** | Removes the script instance and the generated battens. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not require external settings files; it uses properties stored in the drawing.

## Tips
- **Framing First**: Ensure your wall has generated GenBeams (studs/plates) before running this script. If the script reports "No genbeams found," generate the wall framing first.
- **Reveal Liners**: Use the **Side Gap** property to create space for window or door reveal liners so the battens do not interfere with finish carpentry.
- **Floor Plate Clearances**: Use the **Top** and **Bottom** gap properties under the "Vertical batten Gap" category to cut the battens so they do not overlap with top or bottom plates.
- **Layer Control**: If you only want battens on the structural layer and not the insulation layer, check your Zone Index in the wall composition and set **Zone index to exclude** to match the insulation layer index.

## FAQ

**Q: Why did the script disappear immediately after I selected the wall?**
A: This usually happens if the wall has no generated framing ("No genbeams found") or if the selected element is not a valid `ElementWall`. Generate the wall framing and try again.

**Q: The script created battens, but they are too short/tall.**
A: Check the **Top** and **Bottom** properties in the "Vertical batten Gap" category. These values subtract length from the batten ends.

**Q: Can I run this on multiple walls at once?**
A: Yes. When prompted to "Select element(s)", you can select multiple walls, and the script will instance itself onto all of them.