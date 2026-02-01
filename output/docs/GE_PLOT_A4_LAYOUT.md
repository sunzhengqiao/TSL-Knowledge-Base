# GE_PLOT_A4_LAYOUT.mcr

## Overview
This script automates the generation of 2D A4 layout drawings for selected construction elements. It processes 3D model geometry to create dimensioned outlines, including sheets, openings, and specialized components, within Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Selection Only | Used to select the source Element/GenBeam. |
| Paper Space | Yes | Primary output location; transforms Model coordinates to Paper Space. |
| Shop Drawing | Yes | Supports "Shopdraw multipage" mode via properties. |

## Prerequisites
- **Required Entities**: A valid Construction Element (Wall/Panel) or GenBeam must exist in the model.
- **Minimum Beam Count**: 0 (Script handles elements with variable beam counts).
- **Required Settings**: Valid Dimension Styles must be defined in the drawing or hsbCAD settings (`_DimStyles`).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `GE_PLOT_A4_LAYOUT.mcr`.

### Step 2: Select Construction Element
```
Command Line: Select Element/GenBeam:
Action: Click on the desired wall, panel, or beam in the Model Space that you wish to plot.
```

### Step 3: Configure Layout (Optional)
1.  Select the script entity in the drawing (if not already selected).
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust settings such as Drawing Space, Dimension Styles, and Visibility toggles. The drawing will update automatically.

### Step 4: View Results
1.  Switch to the **Paper Space** tab (Layout).
2.  The generated layout, dimensions, and annotations will be displayed based on your configuration.

## Properties Panel Parameters

| Parameter | Type | Options/Value | Description |
|-----------|------|---------------|-------------|
| Drawing Space | Dropdown | Paper Space, Shopdraw Multipage | Determines the target environment for the generated drawing. |
| Dimension Styles | String/List | User Defined | Specifies the dimension style to use for linear and running dimensions. |
| Show Angle Plates | Integer (Toggle) | 0 (No), 1 (Yes) | Toggles the visibility and dimensioning of angle plates. |
| Angle Plate Dim Mode | Integer (Toggle) | 0 (Line), 1 (Text) | If 0, draws dimension lines for angle plates. If 1, draws length text labels. |
| Show Sheets | Integer (Toggle) | 0 (No), 1 (Yes) | Toggles the rendering of sheet outlines. |
| Show Diagonals | Integer (Toggle) | 0 (No), 1 (Yes) | Toggles the rendering of diagonal bracing lines. |
| Show Openings | Integer (Toggle) | 0 (No), 1 (Yes) | Toggles the rendering and dimensioning of wall openings. |
| Layout Offsets | Number | Variable | Adjusts the distance of the projection or layout lines from the element origin. |
| Filter Beam Code | String | Variable | Filters beams based on specific codes to include/exclude them from the plot. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the geometry and redraws the layout based on current model changes. |
| Recalculate | Forces a refresh of the script logic (e.g., if filters changed). |
| Properties | Opens the Properties Palette for quick parameter adjustment. |

## Settings Files
- **Filename**: N/A (Internal CAD Settings)
- **Location**: hsbCAD Install Directory / AutoCAD Support Paths
- **Purpose**: The script relies on standard Dimension Styles (`_DimStyles`) configured within your hsbCAD or AutoCAD environment to ensure text height and arrow styles match your company standards.

## Tips
- **Dimension Styles**: Ensure your chosen Dimension Style is set to "Annotative" or scaled correctly for Paper Space (1:1) to avoid text size issues.
- **Filtering**: Use the "Filter Beam Code" property to temporarily hide structural members (like studs) to create a clean "Outline Only" plot for shipping labels.
- **Angle Plates**: If angle plate dimensions are cluttering the drawing, set "Angle Plate Dim Mode" to `1` (Text) to replace lines with simple length labels.

## FAQ
- **Q: Why is my drawing empty?**
  **A**: Check the "Drawing Space" property. If you are in a standard Layout tab, ensure it is set to "Paper Space". Also, verify that the selected element actually contains geometry (beams/sheets).
- **Q: The dimensions are too small to read.**
  **A**: Check the assigned Dimension Style in the Properties Palette. You may need to create a specific style scaled for A4 paper plots.
- **Q: Can I plot multiple elements on one sheet?**
  **A**: This script generates a layout based on a single element insertion. To plot multiple elements, insert the script on different elements and manually align them in the Layout, or use the "Shopdraw multipage" mode if supported by your workflow.