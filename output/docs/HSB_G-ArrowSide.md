# HSB_G-ArrowSide.mcr

## Overview
This script generates a directional arrow and label in Paper Space to indicate the vertical orientation (Z-axis/height) of a wall element shown within a layout viewport. It is used in shop drawings to clarify the erection direction or "up" side of a wall.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for layouts. |
| Paper Space | Yes | The script must be inserted on a Layout tab. |
| Shop Drawing | Yes | Designed for detailing production. |

## Prerequisites
- **Required Entities**: A viewport on a Layout tab displaying a Wall element (`ElementWallSF`).
- **Minimum Beam Count**: 0.
- **Required Settings**: None (uses standard hsbCAD properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-ArrowSide.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border or inside the viewport that displays the wall you want to annotate.
```

### Step 3: Place Label
```
Command Line: Select a point
Action: Click in Paper Space to position the text label and the anchor point for the arrow.
```

## Properties Panel Parameters

### Arrow Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset | Number | 0 | Moves the arrow start point vertically (mm). Positive moves it up, negative moves it down. |
| Arrow size | Number | 150 | Sets the length/size of the arrow graphic (mm). |
| Arrow color | Integer | 3 | Sets the AutoCAD color index for the arrow line. |

### Name and Description
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Default name color | Integer | -1 | Color of the label text when no filters are applied. (-1 = ByLayer). |
| Filter other element color | Integer | 30 | Color of the label when this specific wall is *not* the active filter. |
| Filter this element color | Integer | 1 | Color of the label when this specific wall *is* the active filter. |
| Dimension style name | String | _DimStyles | Specifies the text style used for the label. |
| Extra description | String | (Empty) | Additional text appended to the end of the label. |

### Script Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Disable the tsl | Dropdown | Yes | If "Yes", the arrow is hidden, and the label shows "(Disabled)". If "No", the arrow is drawn. |
| Show viewport outline | Dropdown | Yes | If "Yes", draws a rectangle indicating the boundary of the selected viewport (useful for debugging). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Highlights this wall instance (using "Filter this element color") and dims all other instances (using "Filter other element color"). Useful for focusing on specific walls in a busy drawing. |
| Remove filter for this element | Removes this wall from the highlight filter, restoring its default color. |
| Remove filter for all elements | Clears all filters, resetting all script instances in the drawing to their default colors. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Disabling the Arrow**: If you only need the tag/name without the directional arrow graphic, set **Disable the tsl** to "Yes" in the properties palette.
- **Visibility Filters**: Use the **Filter this element** right-click option when you have multiple wall arrows on a layout. It allows you to highlight one specific wall while graying out the others for better clarity.
- **Troubleshooting**: If the arrow does not appear, ensure the viewport you selected actually contains a valid Wall element (not a floor or beam) and that **Disable the tsl** is set to "No".

## FAQ
- **Q: Why does my arrow appear red or green?**
  A: The arrow color is controlled by the **Arrow color** property. Check the Properties Palette (OPM) to change it to your preferred AutoCAD color index.
- **Q: Can I move the label after inserting it?**
  A: Yes, select the script instance and use the standard AutoCAD grip points to drag the label and arrow anchor to a new location.
- **Q: What happens if I delete the viewport?**
  A: The script instance will lose its reference to the wall. The label may remain, but the arrow will no longer generate correctly. You should delete the script instance if the viewport is removed.