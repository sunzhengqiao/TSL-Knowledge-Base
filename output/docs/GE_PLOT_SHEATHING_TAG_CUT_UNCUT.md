# GE_PLOT_SHEATHING_TAG_CUT_UNCUT.mcr

## Overview
This script automatically identifies and visually tags sheathing panels on your 2D shop drawings (Layouts). It draws diagonal markers to distinguish between full sheets (marked with an 'X') and cut/ripped sheets (marked with a single diagonal line).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for Layout views. |
| Paper Space | Yes | Must be run on a Layout tab containing a viewport. |
| Shop Drawing | Yes | Designed for production drawings. |

## Prerequisites
- **Required Entities**: A valid hsbCAD Viewport linked to an Element containing sheathing sheets.
- **Minimum Beam Count**: 0 (Operates on sheet/geometry data within the Element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_SHEATHING_TAG_CUT_UNCUT.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame in the Paper Space layout that displays the model you wish to tag.
```

### Step 3: Configure Properties
After selecting the viewport, the Properties Palette will display the script settings. Adjust the sheathing dimensions or color if necessary.
*   *Note: The script will automatically process and draw the tags once the viewport is selected and properties are confirmed.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheathing length | number | 96" | The standard length of a full, uncut sheet. Sheets matching this size are marked with an 'X'. |
| Sheathing width | number | 48" | The standard width of a full, uncut sheet. Sheets matching this size are marked with an 'X'. |
| Draw Sheathing Perimeter | dropdown | No | If set to 'Yes', draws the outline of the sheathing sheet in addition to the diagonal markers. |
| Color | dropdown | Dark Brown (32) | Sets the color of the diagonal markers and perimeter lines. |

## Right-Click Menu Options
*This script does not add custom items to the right-click context menu. Standard recalculation applies when modifying properties.*

## Settings Files
No external settings files are required for this script.

## Tips
- **Check Your Dimensions**: Ensure the `Sheathing length` and `Sheathing width` match your actual material stock (e.g., 48x96 or 48x120). If these are incorrect, full sheets might be marked as cut.
- **Corner Logic**: The script checks the number of vertices. A sheet that is mostly full size but has a single notch (creating 5 vertices) will be treated as a "Cut" piece and marked with a single line.
- **Color Coding**: Choose a color (like Dark Brown or Magenta) that stands out against your wall framing lines to make the tags easy to read on the shop floor.

## FAQ
- **Q: Why is a full sheet marked with a single line instead of an 'X'?**
  - A: This usually happens if the sheet dimensions in the properties do not exactly match the model geometry, or if the sheet has more than 4 corners (e.g., it is notched or dog-eared). Check the `Sheathing length` and `width` properties.
- **Q: How do I remove the tags?**
  - A: Select the script anchor point (usually where you clicked to insert the script) and delete it. All generated lines and tags will disappear.
- **Q: Can I change the tags after I have placed them?**
  - A: Yes. Select the script instance, open the Properties palette, change the dimensions or color, and the tags will update automatically.