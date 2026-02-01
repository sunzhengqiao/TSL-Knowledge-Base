# HSB_D-Aligned.mcr

## Overview
This script creates aligned dimension lines in both Model Space and Paper Space. It allows for flexible measurement methods (perpendicular or parallel) and can display individual segment lengths or continuous totals, with options for linking dimensions to 3D objects.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Standard dimensioning in the 3D model. |
| Paper Space | Yes | Press `<ENTER>` at the start to select a Viewport for scaled dimensions. |
| Shop Drawing | Yes | Ideal for annotating layouts and construction details. |

## Prerequisites
- **Required entities**: None specific (script prompts for point selection).
- **Minimum beam count**: 0.
- **Required settings**: Dimension Styles (must be available in the drawing catalog).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Aligned.mcr`

### Step 2: Select Mode (Model vs Paper Space)
```
Command Line: Select first dimension point or <ENTER> for PaperSpace
Action: 
- Pick a point in Model Space to start dimensioning.
- OR press <ENTER> to place dimensions in a Layout/Viewport.
```

### Step 3: Select Viewport (If Paper Space)
```
Command Line: Select a Viewport
Action: Click on the border of the viewport where you want the dimension to appear.
```

### Step 4: Select First Point
```
Command Line: Select first dimension point
Action: Click the starting location for your measurement (snap to an object endpoint if desired).
```

### Step 5: Select Additional Points
```
Command Line: Select next point
Action: Click subsequent points to define the segments of the dimension. 
Note: You can select multiple points. Press Enter or Right-click to finish selecting points.
```

### Step 6: Position Dimension Line
```
Command Line: Select a position for the dimension line
Action: Click to define where the main dimension line runs through.
```

### Step 7: Set Direction
```
Command Line: Select a position for the direction
Action: Click a point to define the rotation/orientation of the dimension text and line.
```

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | number | 1 | Sets the color index (1-255) of the dimension lines and text. |
| Layer | text | 0 | Specifies the CAD layer for the dimension (ignored in Paper Space, uses current layer). |
| Assign to group | dropdown | [Empty] | Assigns the dimension to a specific project group (e.g., Floor 1). |
| Link to objects | dropdown | Yes | If 'Yes', dimensions update automatically if the snapped objects move. |
| Show in display representation | dropdown | [Empty] | Filters visibility based on the selected display representation (e.g., Model, Layout). |

### Dimension
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown | [Drawing Default] | Selects the visual style (arrows, text size) from defined styles. |
| Dimension method | dropdown | [Drawing Default] | Determines how distances are calculated (e.g., Delta perpendicular, Continuous parallel, etc.). |

### Text
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text override delta | text | [Empty] | Custom text to replace the individual segment measurements. |
| Text override continuous | text | [Empty] | Custom text to replace the total cumulative measurement. |
| Description | text | [Empty] | Adds an additional text label near the dimension line. |
| Side description | dropdown | Left | Places the description text on the 'Left' or 'Right' side of the dimension line. |
| Offset description | number | 100 | Distance between the dimension line and the description text (in mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add points** | Prompts you to select new points to append to the existing dimension chain. |
| **Remove points** | Prompts you to select points on the dimension to delete them. (Note: This sets 'Link to objects' to 'No'). |
| **Set direction** | Allows you to re-pick the point that defines the angle/rotation of the dimension line. |
| **Set reference point** | Allows you to pick a new point to act as the start (0.00) of the dimension. |

## Settings Files
- **Dimension Styles**: Referenced from the `_DimStyles` list in the current drawing.
- **Location**: Defined within your hsbCAD project or drawing template.

## Tips
- **Moving the Dimension Line**: You can drag the dimension line using the grip point at the origin without moving the measurement points (the extension lines will adjust automatically).
- **Automatic Updates**: Keep "Link to objects" set to "Yes" to ensure dimensions update when you modify your timber structure.
- **Paper Space Scaling**: When using the script in Paper Space, ensure you select the correct Viewport so the script calculates the correct scale factor for the text.

## FAQ
- **Q: Can I change the dimension from individual segments to a total length after inserting?**
  - A: Yes, select the dimension, open the Properties Palette, and change the "Dimension method" (e.g., to "Continuous perpendicular").
- **Q: Why did my dimension disappear immediately after insertion?**
  - A: The script requires at least two points to create a dimension. If you selected fewer than two points, the instance is erased automatically.
- **Q: What happens if I move a beam I snapped to?**
  - A: If "Link to objects" was "Yes" during insertion, the dimension point will move with the beam. If you manually edited points via the context menu, the link might be broken.