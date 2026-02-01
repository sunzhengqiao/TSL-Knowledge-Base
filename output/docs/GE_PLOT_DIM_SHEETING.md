# GE_PLOT_DIM_SHEETING.mcr

## Overview
Automates the creation of layout dimension lines for wall elements (studs, plates, sheeting) in Paper Space shop drawings, derived from Model Space geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for layouts. |
| Paper Space | Yes | The script must be inserted into a layout tab. |
| Shop Drawing | Yes | Intended for detailing 2D wall layouts. |

## Prerequisites
- **Required entities:** An AutoCAD Layout containing a Viewport with an hsbCAD Element (Wall) visible inside it.
- **Minimum beam count:** 0
- **Required settings files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_DIM_SHEETING.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click on the viewport in your layout that displays the wall you wish to dimension.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension line. Choose 'Horizontal' (parallel to wall) or 'Vertical' (perpendicular to wall). |
| Side of beams/sheets | dropdown | Left | Determines which side of the structural members to measure from (Left, Center, Right, or Left and right). |
| Zones to use | dropdown | Use zone index | Selects whether to dimension the entire wall structure ('All') or a specific construction layer ('Use zone index'). |
| Zone index | dropdown | 5 | Specifies the layer number to dimension (e.g., 0 for framing, other numbers for sheeting layers) when 'Zones to use' is set to 'Use zone index'. |
| Delta text direction | dropdown | None | Controls the rotation of the text for individual segment measurements (None, Parallel, or Perpendicular to the dimension line). |
| Cumm text direction | dropdown | Parallel | Controls the rotation of the text for cumulative (total) measurements (None, Parallel, or Perpendicular). |
| DimStyle | dropdown | | The AutoCAD Dimension Style to apply to the generated dimension line. |
| Offset from Wall | number | 304.8 | The distance in mm from the wall origin/reference edge to the dimension line. |
| ID's to show 214;120;114... | text | | A list of specific hsbCAD entity IDs to dimension. If filled, this overrides other zone settings. Separate IDs with semi-colons. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None available | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Specific Beam Dimensioning:** If you only need to dimension specific studs or plates, use the **ID's to show** property. Enter the IDs separated by semi-colons (e.g., `101;105;110`), and the script will ignore other settings to dimension just those items plus the wall boundaries.
- **Switching Targets:** To switch between dimensioning framing members and sheathing layers, change **Zones to use** to "Use zone index" and set **Zone index** to `0` (for framing) or the relevant number for your sheathing layer (e.g., `5`).
- **Viewport Scale:** The script calculates dimensions based on the viewport scale. Ensure your viewport scale is set correctly before inserting the script.

## FAQ
- **Q: My dimension line disappeared after I changed the Zone index.**
  A: Make sure the selected Zone index actually contains entities (beams or sheets) in your model. If the zone is empty, no dimensions will be generated.
- **Q: How do I rotate the text to be readable?**
  A: Adjust the **Delta text direction** or **Cumm text direction** properties to "Parallel" or "Perpendicular" depending on your desired orientation relative to the wall.
- **Q: Can I dimension both the left and right sides of the studs at once?**
  A: Yes. Set the **Side of beams/sheets** property to "Left and right".