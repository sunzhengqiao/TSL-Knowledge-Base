# hsb_BattensAroundOpenings.mcr

## Overview
This script automatically generates timber framing battens (noggings/furring strips) around the perimeter of wall openings (windows and doors). It is used to create fixing points for linings, claddings, or reveal finishes based on user-defined dimensions and wall zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Not applicable for shop drawing views. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWall`) containing Openings (Windows or Doors).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsb_BattensAroundOpenings.mcr`.
3.  Press **Enter**.

### Step 2: Configure Properties (Optional)
*Before selecting elements, you can adjust the settings in the AutoCAD Properties Palette (Ctrl+1) if the script is selected, or rely on the defaults.*

### Step 3: Select Wall Elements
1.  **Command Line Prompt**: `Select a set of elements`
2.  **Action**: Click on the Wall elements in the Model Space that contain the openings you wish to frame.
3.  Press **Enter** to confirm selection.

### Step 4: Generation
The script will automatically calculate the opening geometries, generate the battens, place them in the specified zone, and then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply Battens Around Doors | dropdown | No | Determines whether to generate battens around Door openings. |
| Corners Cleanup | dropdown | Extend Vertical | Defines corner overlap strategy. If "Extend Vertical", vertical battens are longer to overlap horizontal ones. |
| Batten Width | number | 38 mm | The cross-sectional width of the batten (visible on elevation). |
| Batten Height | number | 20 mm | The thickness/depth of the batten (perpendicular to the wall face). |
| Zone to assign the Battens | dropdown | 1 | The construction layer (Zone) in the wall where battens are placed. |
| Name | text | Battens | The entity name assigned to the generated beams. |
| Material | text | [Empty] | The timber material code (e.g., C24). |
| Grade | text | [Empty] | The timber strength grade. |
| Label | text | Batten | Short label for drawings or CAM identifiers. |
| Sublabel | text | [Empty] | Secondary label for grouping. |
| Sublabel2 | text | [Empty] | Tertiary label. |
| Information | text | [Empty] | Free text field for notes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script runs once and erases itself. There are no recalculation triggers available via right-click menu after insertion. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Zone Assignment**: Ensure the "Zone to assign the Battens" corresponds to the correct layer in your wall setup (e.g., internal lining vs. external structure). If battens appear on the wrong side of the wall, change the Zone index.
- **Corner Cleanup**: Use the "Corners Cleanup" option to avoid butt joints at corners. Overlapping the battens (lapping) provides a better fixing surface for plasterboard or cladding.
- **Door Handling**: By default, doors are excluded. If you need battens on the reveal of a door frame, ensure "Apply Battens Around Doors" is set to **Yes**.
- **Post-Creation Editing**: Since the script instance is deleted after running, the generated beams are standard AutoCAD/hsbCAD entities. You can manually move or stretch them using grips if minor adjustments are needed.

## FAQ
- **Q: Why didn't the script create battens around my door?**
  **A:** Check the "Apply Battens Around Doors" property. It defaults to "No" to avoid interference with door frames. Change this to "Yes" and run the script again.
  
- **Q: Can I modify the batten size after running the script?**
  **A:** You cannot change the settings via the script because it deletes itself upon completion. However, you can select the generated beams and use the AutoCAD Properties palette to manually change their Width or Height, or delete them and re-run the script with new settings.

- **Q: The battens are being generated in the middle of the wall, not on the face.**
  **A:** The "Zone to assign the Battens" determines the position. Change this index (e.g., from 1 to 2, or check your wall definition mappings) to shift the battens to the correct surface layer.