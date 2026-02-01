# GE_TRUSS_CHANGE_COLOR.mcr

## Overview
This utility script allows you to batch-update the display color of all beams within selected trusses. It provides a quick method to switch the visual appearance of trusses between a standard timber color and a steel color (typically grey) for presentation or drafting purposes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported in Layouts. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities**: At least one valid hsbCAD Truss entity must exist in the drawing.
- **Minimum Beam Count**: 1 (via Truss selection).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` in the AutoCAD command line. Browse to the location of `GE_TRUSS_CHANGE_COLOR.mcr`, select the file, and click **Open**.

### Step 2: Select Trusses
```
Command Line: Select truss(es)
Action: Click on the truss entities you wish to modify. You can select multiple trusses.
```
Press **Enter** to confirm your selection.

### Step 3: Select New Color
After selecting the trusses, the AutoCAD Properties Palette (OPM) will appear automatically.
1. Locate the parameter labeled **New color**.
2. Click the dropdown menu.
3. Select either `|Beam|` (standard timber color) or `|Steel|` (grey color).

### Step 4: Apply Changes
Close the Properties Palette or simply click elsewhere in the drawing. The script will process the selection, update the colors in the truss definition, and automatically remove itself from the drawing.

### Step 5: Recalculate
**Important:** To see the color changes visually in the Model Space and views, you must manually recalculate the trusses.
- Type `HSB_RECALC` in the command line and press Enter.
- Select the modified trusses and press Enter.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New color | Dropdown | \|Beam\| | Select the display color for the beams inside the selected trusses. Options are \|Beam\| (ACI 32 - typically timber color) or \|Steel\| (ACI 254 - typically grey). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Updates**: The script modifies the underlying definition of the truss, but the screen display will not update until you run `HSB_RECALC` on the selected trusses.
- **Batch Processing**: You can select as many trusses as needed in a single run to ensure consistency across a project.
- **Color Codes**: This script maps the selection to specific AutoCAD Color Index (ACI) values: 32 for `|Beam|` and 254 for `|Steel||`.

## FAQ
- **Q: Why didn't the trusses change color immediately after running the script?**
  A: The script updates the definition data but does not force a graphical refresh. You must run `HSB_RECALC` on the modified trusses to update the display.
- **Q: Can I use this on individual beams that are not part of a truss?**
  A: No, this script is designed specifically for hsbCAD Truss entities and will not function on standard GenBeams or single elements.
- **Q: What happens if I select non-truss objects?**
  A: The script will ignore them and only process valid Truss entities found in your selection.