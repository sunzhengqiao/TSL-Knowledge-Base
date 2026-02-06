# hsb_ShowSideDetails.mcr

## Overview
This script automatically generates a grid of 2D detail drawings for beams with complex cuts or non-rectangular profiles. It is designed to create detailed cross-section views in Paper Space or Shopdraw Multipage layouts, complete with dimensions and position numbers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Details are generated in Paper Space or Shopdraw layouts. |
| Paper Space | Yes | Requires selecting a Viewport linked to an Element. |
| Shop Drawing | Yes | Requires selecting a Shopdraw View entity. |

## Prerequisites
- **Required Entities**: A Viewport (Paper Space) or ShopdrawView (Shopdraw Space) that is linked to a valid hsb Element containing GenBeams.
- **Minimum Beam Count**: 0 (If no beams match the filter, nothing is drawn).
- **Required Settings**: Access to the `HSB_G-FilterGenBeams` catalog entry to utilize beam filtering.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_ShowSideDetails.mcr` from the list.

### Step 2: Configure Properties (Optional)
The Properties palette will appear upon insertion.
- Set **Drawing space** (`sSpace`) to either "Paper Space" or "Shopdraw multipage".
- Select a **Filter definition** if you only want to detail specific types of beams.
- Adjust **Layout** parameters (Columns, Offsets) as needed.
- Press **Enter** or click **Close** to confirm.

### Step 3: Pick Insertion Point
```
Command Line: Pick a point where details will be generated
Action: Click anywhere in the drawing to set the origin (top-left corner) of the detail grid.
```

### Step 4: Select Source View
Depending on your selection in Step 2, one of the following prompts will appear:

**If Paper Space is selected:**
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport containing the element you wish to detail.
```

**If Shopdraw Multipage is selected:**
```
Command Line: Select the view entity from which the module is taken
Action: Click on the Shopdraw view entity.
```

The script will now generate the details. It filters beams, analyzes their geometry, and draws only the non-rectangular profiles arranged in a grid.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | Paper Space | Sets the environment to retrieve the element from (Paper Space or Shopdraw). |
| Filter definition for genbeams to display | dropdown | | Select a filter from `HSB_G-FilterGenBeams` to choose which beams to detail. |
| Display mode chain | dropdown | Parallel | Sets the orientation of dimension lines (Parallel, Perpendicular, or None). |
| Dimstyle | dropdown | Current Dimstyle | Selects the CAD dimension style (arrows, text size, etc.). |
| Text offset | number | 5 mm | Distance between the detail geometry and the Position Number label. |
| Offset for dimension lines | number | 5 mm | Gap between the geometry and standard dimension lines. |
| Offset for angled dimension lines | number | 5 mm | Gap between the geometry and dimension lines for angled cuts. |
| Detail scale | number | 0.25 | Scale factor for the details (e.g., 0.25 = 1/4 size). |
| Offset horizontal | number | 30 mm | Horizontal spacing between columns in the grid. |
| Offset vertical | number | 30 mm | Vertical spacing between rows in the grid. |
| Number of Columns | number | 5 | Number of details per row before wrapping to the next line. |
| Color detail | number | 32 | CAD color index for the detail outline polylines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the details based on changes to the source beams or properties. |
| Move Origin | Displays a grip point at the insertion point. Click and drag to move the entire grid to a new location. |
| Properties | Opens the Properties palette to adjust filters, layout, and dimension settings. |

## Settings Files
- **Catalog**: `HSB_G-FilterGenBeams`
- **Purpose**: Stores predefined filter rules to limit which beams are detailed (e.g., "Only beams with tenons" or "Wall beams only").

## Tips
- **Filtering is Key**: Use the **Filter definition** to avoid cluttering your drawing with details for simple, rectangular beams.
- **Adjusting Layout**: If details overlap, increase the **Offset horizontal** or **Offset vertical** values in the properties.
- **Scaling**: If details are too small or large to read, change the **Detail scale**. A lower value (e.g., 0.1) fits more details on a page.
- **Moving the Grid**: You can quickly reposition the entire drawing by using the "Move Origin" grip option from the right-click menu instead of erasing and re-inserting.

## FAQ
- **Q: I ran the script, but nothing was drawn. Why?**
- **A:** This usually means the beams in the selected element are perfectly rectangular (standard cuts only) or none of them passed the filter. Try selecting an empty filter to show all beams, or verify the selected Viewport contains complex geometry.

- **Q: Can I change the number of columns after inserting?**
- **A:** Yes. Select the script, open Properties, and change "Number of Columns". The grid will automatically rearrange when you recalculate.

- **Q: What does "Display mode chain" do?**
- **A:** It controls how dimensions align on angled cuts. "Parallel" places the dimension text along the cut angle, while "Perpendicular" forces it to align horizontally or vertically relative to the page.