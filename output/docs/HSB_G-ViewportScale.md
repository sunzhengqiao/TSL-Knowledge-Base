# HSB_G-ViewportScale.mcr

## Overview
This script automatically annotates drawing layouts by placing a text label that displays the precise scale of a selected viewport (e.g., "1:50"). It is designed for use in Paper Space to clearly mark view scales on shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for Layout tabs only. |
| Paper Space | Yes | Used to annotate viewports on drawing sheets. |
| Shop Drawing | Yes | Ideal for detailing views where scale indication is required. |

## Prerequisites
- **Required Entities:** A viewport must exist in the current Layout tab.
- **Minimum beam count:** 0
- **Required settings:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-ViewportScale.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the viewport you wish to label.
```

### Step 3: Place Label
```
Command Line: Select position for scale
Action: Click anywhere in the Paper Space layout where you want the scale text to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Style | Text | | A visual separator label in the properties list (does not affect drawing output). |
| Precision | Number | 1 | The number of decimal places to display for the scale (e.g., 1 displays "1:50", 2 displays "1:50.00"). |
| Dimension style | Dropdown | _DimStyles | The text style (font, height) used for the scale annotation. Select from available dimension styles in the drawing. |
| Color | Number | 1 | The color of the text (AutoCAD Color Index 1-255). |
| Alignment | Dropdown | 90 | The rotation angle of the text. Options: `90` (Vertical), `0` (Horizontal), `-90` (Inverted Vertical). |
| Prefix | Text | | Custom text added before the scale value (e.g., type "SCALE " to output "SCALE 1:10"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Text Orientation:** Use the **Alignment** property to rotate text so it reads correctly relative to your drawing borders or view.
- **Text Appearance:** To change the font or height of the label, modify the selected **Dimension style** within AutoCAD's standard style manager, or select a different style in the properties panel.
- **Custom Prefix:** Use the **Prefix** field to add context, such as "DETAIL 1:10" or "SECTION 1:20", by typing "DETAIL " before inserting the script.

## FAQ
- **Q: Can I use this script in Model Space?**
  A: No, this script specifically requires a Viewport entity, which only exists in Paper Space (Layouts).
- **Q: Why does my text appear too small or large?**
  A: The text size is controlled by the **Dimension style** selected. Change the `sDimStyle` property to a style with the appropriate text height, or modify the text height in the Dimension Style Manager.
- **Q: How do I display the scale as '1 : 5.0'?**
  A: Set the **Precision** property to `1` (or higher) to show decimal places.