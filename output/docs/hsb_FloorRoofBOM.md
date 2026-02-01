# hsb_FloorRoofBOM.mcr

## Overview
Generates a detailed Bill of Materials (BOM) table in Paper Space. It lists timber members (categorized by type like studs, plates, and lintels) and sheathing materials, including dimensions, lengths, grades, and quantities, based on a selected 3D model element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script generates 2D output on layout sheets. |
| Paper Space | Yes | The table is inserted directly onto the layout. |
| Shop Drawing | No | This is a general drafting utility. |

## Prerequisites
- **Required Entities:** A viewport linked to a valid hsbCAD Element (Floor or Roof).
- **Minimum beam count:** 0
- **Required settings files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FloorRoofBOM.mcr`

### Step 2: Define Insertion Point
```
Command Line: Pick the Insertion Point
Action: Click anywhere in the Paper Space layout to define the top-left corner of the BOM table.
```

### Step 3: Select Source Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of a viewport that displays the 3D element (Floor/Roof) you wish to analyze.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | (Current Dim Style) | Select the text style to be used for the table content. Changing this automatically adjusts column widths to fit the text. |
| Color | number | 3 | Sets the AutoCAD Color Index for the table text and lines (e.g., 3 is Green). |
| Materials to exclude from the BOM | text | (Empty) | Enter material names to omit from the sheathing list. Separate multiple materials with a semicolon (e.g., `OSB;GYPBOARD`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not use custom right-click menu options. Modify parameters via the Properties Palette to trigger updates. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No external settings files are used.

## Tips
- **Filtering Materials:** If you want to list structural timber but exclude temporary sheathing (like bracing), add the material name of the sheathing to the "Materials to exclude" property.
- **Table Sizing:** If the text looks cramped or too spread out, change the **Dim Style** property to a style with larger or smaller text height. The table will automatically resize.
- **Sorting:** Timbers are automatically sorted by length and height within their specific categories (e.g., all Studs are grouped together and sorted).

## FAQ
- **Q: Why did the table not appear after I selected the viewport?**
  - **A:** Ensure the selected viewport is linked to a valid hsbCAD Element. If the viewport shows a standard AutoCAD drawing or an empty element, the script will not generate data.
- **Q: How do I remove a specific type of board from the bottom of the list?**
  - **A:** Select the generated BOM, open the Properties Palette, find "Materials to exclude from the BOM", and type the name of the material exactly as it appears in your model.
- **Q: Can I change the text color?**
  - **A:** Yes. Select the BOM table and change the "Color" property in the Properties Palette to any valid AutoCAD color index number.