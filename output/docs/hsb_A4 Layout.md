# hsb_A4 Layout.mcr

## Overview
This script automates the creation of 2D production drawings for timber wall panels directly in Paper Space. It generates detailed vertical stud lists, horizontal running dimensions, and weight labels, transforming 3D model data into a clean layout suitable for A4 plotting or shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script generates output in Paper Space. |
| Paper Space | Yes | Primary mode. Requires a Layout tab with an active viewport of the wall. |
| Shop Drawing | Yes | Can be used within the hsbCAD Multipage generation workflow. |

## Prerequisites
- **Required Entities**: A single Wall Element (Element).
- **Required Context**: You must be on an AutoCAD Layout tab (Paper Space) with a viewport displaying the element.
- **Required Settings**: Valid AutoCAD Dimension Styles must exist in the drawing to be selected in the properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD Script Menu)
Action: Browse and select `hsb_A4 Layout.mcr`.

### Step 2: Select Wall Element
```
Command Line: Select Element:
Action: Click on the desired Wall Element in Model Space or through the viewport.
```

### Step 3: Set Origin Point
```
Command Line: Insertion point:
Action: Click in Paper Space to define the bottom-left origin for the dimension list and layout.
```
*Note: This point determines where the text lists start relative to your drawing border.*

### Step 4: Adjust Output
Action: Select the inserted script object and open the **Properties Palette** (Ctrl+1). Adjust the "Drawing space", "Show Left Dimension List", or offsets to fit your title block.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drawing space** | dropdown | \|paper space\| | Sets the output environment. Choose "\|paper space\|" for manual insertion or "\|shopdraw multipage\|" for automated batch generation. |
| **Show Left Dimension List** | dropdown | None | Controls the vertical list of stud positions. Options: Start, End, Center, or None. |
| **List Spacing** | number | U(5, 0.2) | The vertical height between lines of text in the dimension list (mm/inches). |
| **X Offset for List** | number | U(300, 12) | Horizontal distance from the script origin to the start of the text list. |
| **Y Offset for List** | number | U(0, 0) | Vertical shift for the start of the text list. Use this to align lists with title blocks. |
| **Number of Items per column** | integer | 20 | How many studs are listed before the text wraps to a new column. |
| **Dim Style** | dropdown | *Varies* | Select the AutoCAD Dimension Style to use for general layout dimensions (e.g., overall height). |
| **Dim Style Studs Only** | dropdown | *Varies* | Select the AutoCAD Dimension Style specifically for the stud running dimensions. |
| **Timber density (kg/m3)** | number | 450 | Material density used to calculate the total weight displayed on the drawing. |
| **Dimensions Include Headbinder** | dropdown | No | If "Yes", dimensions include the length of blocking/headbinder pieces. |
| **Show Bottom Dimension** | dropdown | None | Displays horizontal running dimensions along the bottom plate (Start, End, Center, None). |
| **Bottom Dimension From** | dropdown | Left Side | Sets the zero-point for bottom dimensions (Left Side or Right Side). |
| **Show as** | dropdown | Line and Text | Selects visual style: "Line and Text" (simple list), "Dimension Line - Running" (chain dims), or "Dimension Line - Delta". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalc** | Updates the drawing to reflect changes in the 3D model or property changes. |
| **Move** | Relocates the origin point of the script, moving all associated dimensions and text. |
| **Properties** | Opens the Properties Palette to adjust layout parameters. |

## Settings Files
- **DimStyles**: AutoCAD Dimension Styles
- **Location**: Current Drawing (.dwg)
- **Purpose**: Defines text height, arrow style, and precision for generated dimensions. Ensure desired styles exist in the template before running the script.

## Tips
- **Text Overlap**: If the vertical list overlaps with the wall drawing, increase the **X Offset for List** or switch to the Shopdraw Multipage mode if available.
- **Long Lists**: If your wall is very tall, decrease the **Number of Items per column** to create multiple narrow columns rather than one very tall column.
- **Dimension Clarity**: Use different DimStyles for "Dim Style" (Main dims) and "Dim Style Studs Only" (Running dims) to make main dimensions bold and stud dimensions smaller/lighter.
- **Viewports**: Ensure the viewport scale is correct before inserting. The script calculates Paper Space coordinates based on the current view transformation.

## FAQ
- **Q: I inserted the script but nothing appears.**
  **A:** Check the Properties Palette. If both "Show Left Dimension List" and "Show Bottom Dimension" are set to "None", the script will generate no visible output. Set one of them to "Start" or "End".

- **Q: The dimensions are pointing to empty space.**
  **A:** The script calculates positions based on the Model Space geometry. Ensure you selected the correct Wall Element and that the script origin point in Paper Space aligns roughly with the projection of the wall.

- **Q: The weight displayed is incorrect.**
  **A:** Verify the **Timber density** property matches your actual material (e.g., change from 450 to 500 for denser timber).

- **Q: Can I use this script in Model Space?**
  **A:** No, this script is designed specifically to annotate drawings in Paper Space (Layouts). Ensure you are on a Layout tab when inserting.