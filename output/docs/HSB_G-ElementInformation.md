# HSB_G-ElementInformation

## Overview
This script generates a graphical overlay displaying the outline and element number of selected hsbCAD Elements. It allows users to visualize specific element information in designated display representations (e.g., floor plans) and prepares data for DXF export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space and creates visual references there. |
| Paper Space | No | This script does not function in Paper Space. |
| Shop Drawing | No | This script is not intended for Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: At least one existing hsbCAD Element (e.g., a wall or floor assembly).
- **Minimum Beam Count**: 0 (Attaches to Elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-ElementInformation.mcr`.

### Step 2: Configure Settings (If applicable)
- If you are running the script manually without a predefined catalog entry, a **Properties Dialog** will appear.
- Set the desired Display Representation, Colors, and Dimension Style.
- Click **OK** to confirm.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the hsbCAD Elements (walls/roofs) you want to annotate. Press Enter to confirm selection.
```
*The script will automatically attach the annotation to the selected elements.*

## Properties Panel Parameters

These parameters can be edited via the AutoCAD Properties Palette (Ctrl+1) after insertion.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show in display representation | dropdown | *Project Default* | Determines which view style (e.g., Model, Plan, Section) will display the outline and number. |
| Color element outline | number | 1 | Sets the color index (1-255) for the line drawn around the element's gross profile. |
| Dimension style element number | dropdown | 0 | Selects the text style (font, size) used for the element number label. |
| Color element number | number | 1 | Sets the color index (1-255) for the element number text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. Use standard Properties to modify. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **View Control**: Use the *Show in display representation* property to ensure annotations only appear in 2D plans while remaining hidden in 3D views to keep the model clean.
- **Automatic Updates**: If you modify the geometry of the parent Element (e.g., change its length or height), the outline and text position will update automatically.
- **DXF Export**: This script stores data in an internal map specifically for DXF output, ensuring that element outlines and numbers are correctly transferred to production software.

## FAQ
- **Q: Why did the text/outline disappear from my model?**
  - A: Check the *Show in display representation* property. It may be set to a display representation that is currently not active in your viewport.
- **Q: What happens if I delete the Element the script is attached to?**
  - A: The script instance will detect that the Element is invalid and automatically erase itself to prevent errors.