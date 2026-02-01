# GE_OPENING_SHOW_TAG_MS

## Overview
This script creates customizable annotation tags in Model Space for wall openings. It displays information such as the Style Name or Description, with optional graphical elements like leader lines, bounding boxes, and opening outlines.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed specifically for Model Space usage. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for use within hsbCAD Shop Drawings. |

## Prerequisites
- **Required Entities**: Wall Openings (OpeningSF) belonging to Wall Elements (ElementWall).
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the script location and select `GE_OPENING_SHOW_TAG_MS.mcr`.

### Step 2: Select Openings
```
Command Line: Select openings
Action: Click on the wall openings (windows or doors) you wish to tag. Press Enter to confirm selection.
```

### Step 3: Configure Initial Settings (Optional)
Action: A properties dialog may appear automatically upon insertion. You can configure the tag color, offset, and visibility settings here, or change them later in the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tag color | number | 1 | Sets the AutoCAD color index (1-255) for the text label. |
| Dimstyle | dropdown | - | Selects the dimension style to determine text font and height. |
| Offset from wall outline | number | 10 | Distance (in mm) the tag is placed away from the wall face. |
| Show opening outline | dropdown | Yes | If "Yes", draws a polyline representing the exact shape of the opening on the wall. |
| Exclude non load bearing walls | dropdown | Yes | If "Yes", tags are **NOT** created on non-load-bearing walls. If "No", tags are created on all selected walls. |
| Display line pointing to opening | dropdown | Yes | If "Yes", draws a leader line connecting the tag to the center of the opening. |
| Display PLine | dropdown | Yes | If "Yes", draws a rectangular border box around the text. |
| PLine color | number | 6 | Sets the AutoCAD color index for the rectangle border. |
| Show in display representation | text | - | Specifies the Display Representation (e.g., 'Reflected') where the tag is visible. Leave empty for standard Model Space visibility. |
| Tag orientation | dropdown | Horizontal | Sets the text alignment. "Horizontal" aligns with World X/Y. "Free to rotate and relocate" aligns with the wall and allows manual grip editing. |
| Visible on top view only | dropdown | No | If "Yes", the tag is hidden in 3D views, elevations, and sections, only visible in Top/Plan views. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not require external settings files.

## Tips
- **Text Content Priority**: The script displays text based on this priority:
    1. Custom Description (if available).
    2. SF Description (if available).
    3. Style Name.
    4. "No stylename or description available" (if none of the above exist).
- **Adjusting Text Size**: Change the `Dimstyle` property to a different style defined in your CAD template to globally change text size and font.
- **Manual Relocation**: If you need to move a tag manually, set the `Tag orientation` property to "Free to rotate and relocate". You can then use the grip points to drag the tag to a new position.
- **Performance**: Use the "Exclude non load bearing walls" and "Visible on top view only" options to keep your 3D model views clean and uncluttered.

## FAQ
- **Q: Why did the tag disappear after I changed a wall property?**
  A: The script updates automatically. If you changed the wall to "Non-load-bearing" and the property "Exclude non load bearing walls" is set to "Yes", the tag will remove itself.
- **Q: Can I use this in my Section/Elevation views?**
  A: By default, yes. However, if you want to hide these tags in sections to reduce clutter, set the "Visible on top view only" property to "Yes".
- **Q: The text is too small to read.**
  A: Select the tag and change the `Dimstyle` property to a dimension style that uses a larger text height.