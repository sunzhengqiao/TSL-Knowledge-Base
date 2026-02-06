# SectionGridDisplay.mcr

## Overview
This script automatically annotates 2D Section views with Grid coordinates. It detects where Grid lines intersect the Section clipping volume and generates a leader line, a circle, and the coordinate text (e.g., A, 1, B) at those specific points.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Section2d and Grid entities within the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | Labels are drawn in Model Space relative to the section geometry. |

## Prerequisites
- **Required Entities**: At least one `Section2d` entity and one `Grid` entity must exist in the drawing.
- **Minimum Beams**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` in the AutoCAD command line and select `SectionGridDisplay.mcr` from the list.

### Step 2: Select Sections
```
Command Line: Select Sections
Action: Click on one or more Section2d entities in your model that you wish to annotate. Press Enter to confirm selection.
```

### Step 3: Select Grid
```
Command Line: Select Grid
Action: Click on the single Grid entity that contains the lines (A, B, 1, 2, etc.) you want to display on the sections.
```

### Step 4: Automatic Generation
The script will automatically attach itself to the selected sections and calculate the intersection points. Labels will appear immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | `_DimStyles` | Selects the text style definition (font) to be used for the labels. |
| Text Height | number | 0 | Sets a specific text height. If set to 0, the height defined in the selected Dimstyle is used. |
| Label Color | number | 3 | The color of the coordinate text (e.g., "1", "A"). Uses standard AutoCAD Color Index (0-255). |
| Line Color | number | 8 | The color of the leader line and the circle surrounding the text. Uses standard AutoCAD Color Index (0-255). |
| Label Scale | number | 1.3 | A multiplier that adjusts the size of both the text and the circle simultaneously. |
| Label Offset | number | ~300mm (12") | The distance from the intersection point on the section to the center of the label bubble. Use this to push labels away from cluttered areas. |

## Right-Click Menu Options
This script does not add specific custom items to the right-click context menu. Changes are made via the Properties Panel.

## Settings Files
None.

## Tips
- **Adjusting Size**: If the labels are too small or too large, try changing the `Label Scale` first. This preserves the ratio between the text and the circle.
- **Moving Sections**: If you move a Section or modify the Grid lines, the script will automatically detect the change and update the label positions.
- **Visibility**: To change the font used, select a different `Dimstyle` from the dropdown. Ensure that Dimstyle exists in your CAD drawing template.

## FAQ
- **Q: Why did my labels disappear after I moved the Section?**
- A: The script dynamically calculates intersections based on the Section's position. If the move resulted in no intersection between the Grid and the Section clipping volume, the labels will hide until the geometry overlaps again.

- **Q: How do I make the text bigger without changing the circle size?**
- A: Set `Text Height` to a specific value (e.g., 100mm) and set `Label Scale` to 1.0. Then adjust the circle size logic if needed (currently, the circle is tied to the text height logic).

- **Q: Can I label multiple sections with one grid at once?**
- A: Yes. During the "Select Sections" prompt, you can window-select or click multiple Section2d entities before pressing Enter.