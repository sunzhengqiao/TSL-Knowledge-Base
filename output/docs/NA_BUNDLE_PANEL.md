# NA_BUNDLE_PANEL.mcr

## Overview
Generates a 2D production representation of wall panels within a stacking layout (such as a truck load or storage bundle). It visualizes panel placement, calculates necessary gaps for logistics, and tags elements with specific location data for production management.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 2D geometry in Model Space to represent the bundle layout. |
| Paper Space | No | Not supported for Paper Space usage. |
| Shop Drawing | No | This is a production/logistics script, not a detailing script. |

## Prerequisites
- **Required Entities**: Wall or Roof Elements must exist in the drawing.
- **Minimum Beam Count**: 1 (At least one element must be selected).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_BUNDLE_PANEL.mcr` from the list.

### Step 2: Select Wall Elements
```
Command Line: Select a set of Wall elements
Action: Click on the Wall or Roof elements in the model that you want to include in the bundle representation. Press Enter to confirm selection.
```

### Step 3: Set Reference Point
```
Command Line: Select a reference point to display Wall
Action: Click in the Model Space to define where the 2D bundle representation of the selected panels should be drawn.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | Text | _DimStyles | Specifies the text style used for the panel labels and dimensions (e.g., "_DimStyles"). |
| Location(Bundle,Row,Position) | Text | X-999-999-999 | The logistics identifier defining the specific Bundle, Row, and Position for this panel (e.g., TRK1-1-2). |
| Show Panel Sizes | Dropdown | Yes | If "Yes", displays the panel dimensions (Length x Height) next to the element number. |
| Link to real panel | Dropdown | No | If "Yes", draws a leader line connecting the 2D bundle representation to the actual 3D location of the panel in the model. |
| Flip me | Dropdown | No | If "Yes", indicates the panel is rotated 180 degrees (face down) in the stack. This swaps dimension display order (Height x Length) and updates rotation data. |
| Additional Gap Left | Number | 0.0 | Adds extra spacing (in current units) to the left side of the panel in the bundle, typically used for lifting straps or protection. |
| Additional Gap Right | Number | 0.0 | Adds extra spacing (in current units) to the right side of the panel in the bundle. |
| Forced Color | Dropdown | -1 | Overrides the color of the panel representation. -1 uses the layer color; other numbers force a specific AutoCAD color index. |
| Color Group | Number | -1 | A read-only tag used to group panels (e.g., by Truck ID) for data extraction or filtering. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reset colors in this file | Clears all cached color mappings related to wall heights and floor lengths from the current project database. |

## Settings Files
None. This script does not rely on external XML settings files.

## Tips
- **Visualizing Orientation**: Use the **Flip me** property to indicate if a panel is stacked face-down. The script will visually indicate this flip and update production data accordingly.
- **Logistics Tagging**: The **Location** string is critical for production lists. Ensure this matches your shipping documentation or truck loading plan.
- **Verification**: Set **Link to real panel** to "Yes" initially to verify that your 2D bundle layout correctly corresponds to the 3D model locations.

## FAQ
- **Q: Can I use this script to generate production drawings for individual walls?**
  - A: No, this script is specifically designed for creating bundle/truck loading layouts, not individual wall shop drawings.
- **Q: Why are my dimensions showing as Height x Length instead of Length x Height?**
  - A: Check the **Flip me** property. If it is set to "Yes", the script assumes the panel is rotated and swaps the dimension order to reflect the viewed face.