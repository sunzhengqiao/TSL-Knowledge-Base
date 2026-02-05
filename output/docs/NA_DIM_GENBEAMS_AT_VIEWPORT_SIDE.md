# NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE.mcr

## Overview
This script automates the creation of associative dimensions for General Beams within a Paper Space Viewport, transforming 3D model coordinates into 2D drawing dimensions. It is designed for creating production drawings (floor plans or elevations) where specific beams need to be dimensioned consistently relative to the viewport borders.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script operates specifically in Layouts (Paper Space). |
| Paper Space | Yes | The script calculates transformations from the Model Space view to Paper Space. |
| Shop Drawing | Yes | Useful for detailing floor plans and elevations. |

## Prerequisites
- **Required Entities**: A Viewport containing a valid hsbCAD Element with General Beams (GenBeams).
- **Minimum Beams**: At least 1 GenBeam must be present in the filtered view.
- **Required Settings**: None required, though GenBeam Painter Definitions are used to filter beams.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE.mcr`

### Step 2: Select Viewport
```
Command Line: Select viewport:
Action: Click on the border of the viewport in Paper Space that contains the element you wish to dimension.
```

### Step 3: Validation and Generation
- The script checks if the selected viewport contains a valid Element.
- It identifies the beams associated with the element and draws dimensions in Paper Space based on the default properties.
- If the viewport is invalid or contains no element, the script will report an error and erase itself.

### Step 4: Adjust Position (Optional)
- Click on the dimension to select it.
- Drag the **Grip Point** (usually a square handle on the dimension line) to move the dimension line to a preferred location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimensioned entities | dropdown | Dimensioned only | Selects the group of beams to measure. Options: <br>- *Dimensioned only*: Draws dimensions for main beams. <br>- *Referenced only*: Draws extension lines without dimensions. <br>- *Reference to self*: Creates a dimension chain referencing only selected beams. |
| Text height | number | 2.5 mm | Sets the height of the dimension text in Paper Space units. |
| Dimension style | string | Standard | Defines the CAD dimension style (controls arrowheads, font, color). |
| Dimension line direction | dropdown | X-axis | Sets the orientation of measurement. Options: *X-axis, Y-axis, Z-axis, Perpendicular to beam, Along beam*. |
| Position relative to beam | dropdown | Right | Defines the side of the beam where the dimension is placed (Left, Right, Top, Bottom). |
| Offset | number | 10 mm | Sets the distance between the beam and the dimension line. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add properties override for current element | Saves a unique set of dimension settings specifically for the current Element, allowing different layouts to have different dimension settings without changing the script defaults. |
| Remove properties override for current element | Deletes the saved unique settings for this Element and reverts to the script's default global properties. |
| Reset grip points for current element | Moves the dimension line back to its original calculated position, clearing any manual adjustments made via grip dragging. |

## Settings Files
No external XML settings files are required. The script utilizes internal global maps to store user overrides and grip positions.

## Tips
- **Grip Editing**: Use the grip point to quickly resolve clashes with other notes or dimensions in the drawing.
- **Element Overrides**: Use the "Add properties override" option if you have multiple drawings on one sheet that require different text heights or offset distances.
- **Filtering**: If dimensions are not appearing for specific beams, check your GenBeam Painter Definitions to ensure the beams are correctly categorized.

## FAQ
- **Q: The script erased itself immediately after I selected a viewport. Why?**
  A: This usually means the selected viewport did not contain a valid hsbCAD Element, or there were no GenBeams found in the view. Ensure the viewport is active and contains the desired model data.

- **Q: Can I dimension beams that are not part of the main element?**
  A: No, this script specifically targets beams associated with the Element found within the selected viewport.

- **Q: How do I change the arrow style of the dimensions?**
  A: Change the "Dimension style" property in the Properties Palette to a style defined in your CAD template that has your preferred arrowheads.