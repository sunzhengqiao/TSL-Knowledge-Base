# hsb_MultiWallDraw.mcr

## Overview
This script generates a 2D schematic overview (layout) of multiple timber wall panels in Model Space. It takes walls that have been grouped together by a "Multiwall" number and stacks them visually in a list for checking and verification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates the schematic layout in the current Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Elements that contain a SubMap named `hsb_Multiwall`. (This means you must have previously run a configuration script to tag/group your walls).
- **Minimum Beam Count**: 0.
- **Required Settings**: A Dimension Style must exist in the drawing for labeling.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_MultiWallDraw.mcr` from the file dialog.

### Step 2: Pick Origin Point
```
Command Line: Pick a point
Action: Click anywhere in the Model Space to set the insertion point for the top of the wall list.
```

### Step 3: View Results
The script will automatically generate the wall overview at the selected location. The script instance itself will erase itself, leaving only the generated geometry and text.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset between panels | Number | 4000 mm | The vertical distance between successive multiwall groups in the generated list. Increase this if walls overlap. |
| Dimension Style | Dropdown | _DimStyles | The AutoCAD Dimension Style used to format the Element Number labels (font, arrows, etc.). |
| Text Height | Number | -1 | The height of the text labels. Set to -1 to use the Dimension Style's default height. |
| Text Color | Number | -1 | The color of the text labels. Set to -1 to use the Dimension Style's default color or ByLayer. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Refresh Multiwalls | Clears the current list and re-scans the model for Elements with 'hsb_Multiwall' data, then redraws the schematic. Use this if you have added or modified walls. |
| Delete Multiwalls | Removes the 'hsb_Multiwall' grouping data from all Elements in the model. This effectively ungroups the walls. |

## Settings Files
None. This script does not rely on external XML or settings files.

## Tips
- **Avoid Overlaps**: If your generated walls look cluttered or overlap each other vertically, increase the **Offset between panels** property in the Properties Palette.
- **Data Preparation**: Ensure you have run your multiwall configuration script *before* running this drawing script. If nothing appears, it means no walls have been tagged with the 'hsb_Multiwall' data yet.
- **Text Readability**: If the Element Numbers are too small to read, set **Text Height** to a specific value (e.g., 250 mm) instead of -1.

## FAQ
- **Q: I ran the script but nothing appeared.**
  A: This usually means the script could not find any Elements with the 'hsb_Multiwall' SubMap. Ensure your walls have been processed/assigned to a multiwall group by the prerequisite configuration script.
  
- **Q: How do I change the font of the Element Numbers?**
  A: Change the **Dimension Style** property to a style that uses your desired font, or ensure **Text Height** is set correctly.

- **Q: The script instance disappears after I pick a point. Is this normal?**
  A: Yes. This is a utility script. It runs once to generate the geometry and then removes itself from the drawing to keep the file size down. The resulting lines and text remain until you delete them.