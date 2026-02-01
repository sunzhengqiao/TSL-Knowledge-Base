# GE_PLOT_DIMENSION_HEAD_BINDER

## Overview
This script automatically dimensions the top plates of wall panels in your Paper Space layouts. It creates a main dimension for the plate length and generates specific "delta" dimensions to highlight left and right overhangs relative to the panel outline.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates solely in Paper Space. |
| Paper Space | Yes | Must be run on a Layout tab containing a Viewport of a wall. |
| Shop Drawing | Yes | Designed specifically for wall panel layout drawings. |

## Prerequisites
- **Required Entities**: A Layout viewport displaying a Wall Element.
- **Minimum Beams**: The Wall Element must contain at least one Top Plate beam (assigned type `_kTopPlate`).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_DIMENSION_HEAD_BINDER.mcr` from the list.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border in Paper Space that displays the wall panel you wish to dimension.
```

### Step 3: Configure Properties (Optional)
After insertion, the script will immediately generate dimensions. To adjust the appearance or placement, select the script instance and modify the properties in the **Properties Palette** (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | (Current Dim Styles) | Selects the drafting standard (arrows, text size, and units) for the generated dimensions. |
| Offset | number | U(150, 6) | Sets the distance between the top plate surface and the primary dimension line. |

## Right-Click Menu Options
*(No custom right-click menu options are defined for this script. Standard hsbCAD context options apply.)*

## Settings Files
No external settings files are required for this script.

## Tips
- **Adjusting Offset**: If the dimension lines clash with other annotations, select the script in Paper Space and increase the **Offset** value in the Properties palette.
- **Small Overhangs**: The script automatically filters out very small overhangs. Any overhang less than 5mm will not be dimensioned to keep the drawing clean.
- **Updating**: If you modify the wall geometry in Model Space, return to the Paper Space layout. The dimensions will update automatically to reflect the new plate lengths.
- **Missing Dimensions**: If the script seems to disappear or produce no output, ensure the selected viewport is looking at a valid Wall Element that actually contains Top Plates.

## FAQ
- **Q: Why did the script disappear immediately after I selected a viewport?**
  A: This usually happens if the viewport is not displaying a valid Wall Element or the Element contains no Top Plate beams. Check your Model Space content.
- **Q: Can I change the dimension style after the script is inserted?**
  A: Yes. Select the script instance in Paper Space, open the Properties Palette, and choose a different style from the **Dim Style** dropdown list. The dimensions will update immediately.
- **Q: The Delta dimensions (overhangs) are missing. Why?**
  A: Delta dimensions only appear if the overhang is significant (greater than 5mm). If the top plate is flush or nearly flush with the panel outline, only the main length dimension will appear.