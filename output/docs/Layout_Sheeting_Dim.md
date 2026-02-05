# Layout Sheathing Dim

## Overview
This script automatically generates sheathing layout dimensions in Paper Space. It calculates and displays precise Delta (individual) and Cumulative (total) dimensions for the selected element (wall or floor) based on the viewport orientation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script reads geometry from Model Space but is inserted in Layouts. |
| Paper Space | Yes | Dimensions are drawn directly in the Layout. |
| Shop Drawing | Yes | Designed for production drawings and layouts. |

## Prerequisites
- **Required Entities**: A Layout tab containing a Viewport with a valid hsbCAD Element (Wall or Floor).
- **Minimum Beam Count**: 0 (Dims are based on Element/Sheets).
- **Required Settings**: Project must have valid `_DimStyles` configured for dimension appearance.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` in AutoCAD.
1. Select `Layout_Sheeting_Dim.mcr` from the file list.
2. Click **Open**.

### Step 2: Select Viewport
The command line will prompt:
```
Select a viewport.
```
**Action**: Click on the viewport border in the Paper Space layout that displays the element you wish to dimension.

### Step 3: Configure Properties (Optional)
Upon insertion, the Properties dialog may appear (or open the Properties Palette via Ctrl+1).
1. Set the **Element Zone** (`nZn`) if you are dimensioning a specific layer (e.g., inner sheathing vs outer sheathing).
2. Adjust offsets and dimension styles as needed.
3. The script will automatically generate the dimensions in Paper Space.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Distance dimension line to element** | Number | 300 mm | Sets the gap between the element geometry and the dimension line. |
| **Distance text** | Number | 100 mm | Sets the gap between the dimension line and the text label. |
| **Side of delta dimensioning** | Dropdown | Above | Determines if individual dimensions are stacked Above or Below cumulative lines. |
| **Side of dimensioning text** | Dropdown | Left | Aligns the dimension text to the Left or Right of the dimension line. |
| **Start dimensioning** | Dropdown | Left | Sets which side of the element is treated as the zero point (Left or Right). |
| **Dimension style** | Dropdown | Delta perpendicular | Selects the type of dimensioning: <br>- *Delta*: Spacing of individual sheets.<br>- *Cumulative*: Total running length.<br>- *Both*: Displays both types.<br>Can be Parallel or Perpendicular to the element. |
| **Dimension layout** | Dropdown | *Project Dependent* | Selects the visual style (arrowheads, text size, etc.) from the project's `_DimStyles` list. |
| **nZn (Zone)** | Number | 1 | Specifies the Element Material Zone index to calculate dimensions for. |
| **nDimColor (Color)** | Number | 1 | Sets the CAD Color Index for the dimension lines and text. |
| **sIgnoreOpenings** | Dropdown | No | If set to **Yes**, openings (windows/doors) are ignored, and dimensions run across the full bounding box. |
| **sFilterByLabel** | Text | | Filters sheets to be dimensioned by their label name (semicolon-separated list). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Updates the dimensions to reflect changes in the Model Space geometry or updates to the script properties. |

## Settings Files
- **Filename**: `_DimStyles` (Project specific)
- **Location**: Defined in your hsbCAD Project/Catalog settings.
- **Purpose**: Provides standard drafting styles (text height, arrow style, tick marks) used by the `sDimLayout` parameter.

## Tips
- **Orthogonal View**: Ensure your Viewport is rotated such that the element is perfectly horizontal or vertical on the screen. The script will display an error "Vectors not aligned" if the view is rotated (e.g., to 45 degrees).
- **Ignoring Openings**: Use the **sIgnoreOpenings** property set to "Yes" if you want the overall length of the sheathing run without dimensioning around every window or door cut-out.
- **Visual Clutter**: If dimension lines overlap with other details, increase the **Distance dimension line to element** property via the Properties Palette.
- **Material Label**: The script automatically places a text label with the material name of the zone at the start of the dimension line.

## FAQ
- **Q: Why does the script show "Error! Vectors not aligned"?**
  A: The element in your Viewport is not square to the screen. Use the DVIEW command or rotate the UCS/View within the viewport so the wall/floor is straight up/down or left/right.
- **Q: Why are no dimensions appearing?**
  A: Ensure the Viewport you selected actually contains an hsbCAD Element. Also, check if the Zone (`nZn`) you selected actually contains sheathing/sheets.
- **Q: How do I change the dimension arrows or text size?**
  A: Change the **Dimension layout** property to select a different predefined style from your project standards, or modify the `_DimStyles` settings in your catalog.