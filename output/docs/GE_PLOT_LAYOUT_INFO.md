# GE_PLOT_LAYOUT_INFO.mcr

## Overview
This script creates a parametric text label in Paper Space that displays specific properties (such as dimensions, weights, or project info) of a timber element visible within a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script must be run in a Paper Space layout. |
| Paper Space | Yes | The script creates text entities in Paper Space. |
| Shop Drawing | Yes | Used to annotate layout sheets with live model data. |

## Prerequisites
- **Required entities**: A Viewport in Paper Space that displays an hsbCAD Element (Wall/Floor/Roof).
- **Minimum beam count**: 0 (The script detects the whole element within the viewport).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_LAYOUT_INFO.mcr`

### Step 2: Configure Data Type
```
Dialog: Select Information Type
Action: Choose the data you wish to display (e.g., Element Height, Panel Weight, Project Name).
Action: Select the Dimension Style (pDimStyle) to control text appearance.
```

### Step 3: Select Insertion Point
```
Command Line: Pick insertion point:
Action: Click in the Paper Space layout where you want the label to appear.
```

### Step 4: Select Source Viewport
```
Command Line: Select viewport:
Action: Click the border of the viewport that contains the element you want to label.
```

### Step 5: Completion
The script automatically retrieves the data from the model and draws the text in Paper Space.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type of data | Dropdown | Information | Selects the specific property to display (e.g., Height, Weight, Project Name). |
| DimStyle | String | _DimStyles | Determines the text style, units, and font based on a CAD Dimension Style. |
| Text Heigth | Number | 0 | Sets the text height in Paper Space. Use 0 to adopt the height from the selected DimStyle. |
| Rotation | Number | 0 | Rotates the text label counter-clockwise (degrees). |
| Justification | Dropdown | Left | Aligns the text relative to the insertion point (Left or Right). |
| Index Group | Number | 0 | If Type is 'Element Group', defines which hierarchy level to display (0, 1, or 2). |
| First Stud location | Dropdown | Left | If Type is 'First Stud location', sets the reference face (Left, Center, Right). |
| Ignore Top Plate | Dropdown | No | If Yes, excludes top plates from Height and Diagonal calculations. |
| Multiply output by 25.4 | Dropdown | No | If Yes, converts dimensions from Millimeters to Inches. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the text content if the model geometry or properties have changed. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Imperial Units**: If your shop drawings are in Imperial units, set "Multiply output by 25.4" to "Yes" to automatically convert dimensions.
- **Clear Height**: To display the height of the timber frame excluding the top plate, set "Ignore Top Plate" to "Yes".
- **Grip Editing**: You can drag the text label to a new position using its grip point without re-running the script.
- **Updating Labels**: If you modify the 3D model, use the "Recalculate" option on the text label to update the value instantly.

## FAQ
- **Q: Why does my text display "None found"?**
  **A**: This usually occurs when calculating "First Stud location" but no stud is found further than 39mm from the start point, or if the selected Viewport does not contain a valid element.
- **Q: Can I change the text size after insertion?**
  **A**: Yes. Select the text, open the Properties Palette (Ctrl+1), and modify the "Text Heigth" parameter.
- **Q: How do I switch between displaying Weight and Length?**
  **A**: Select the label in the drawing, open the Properties Palette, and change the "Type of data" dropdown to the desired property.