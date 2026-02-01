# hsb_Beam Profile Output.mcr

## Overview
This script analyzes selected beams to identify unique, non-rectangular cross-section profiles. It generates a 2D visual report in Model Space displaying these profiles with dimensions and quantities, while simultaneously updating the material, grade, and label properties of the processed beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts into Model Space to generate the report graphics. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: GenBeams (Timber beams).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Execute the AutoCAD command `TSLINSERT` and select `hsb_Beam Profile Output.mcr` from the file dialog.

### Step 2: Set Report Location
```
Command Line: Select the point where is going to be located the report
Action: Click in the Model Space to define the top-left origin of the report.
```

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: Select the desired beams from the drawing and press Enter.
```
*Note: Once selected, the script processes the beams and generates the report graphics.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Report Layout** |
| Distance between Profiles | Number | 600 | Vertical spacing (mm) between rows of profile drawings. |
| Text Offset | Number | 300 | Distance (mm) between the profile center and its label text. |
| Columns | Number | 5 | Number of unique profiles displayed horizontally before wrapping to a new row. |
| Color | Number | 90 | AutoCAD Color Index (1-255) for the profile geometry and dimensions. |
| DimStyle | String | _DimStyles | The dimension style used for the report dimensions. |
| **Profile Analysis** |
| Tolerance | Number | 1 | Matching sensitivity (mm). Vertices within this distance are treated as identical. |
| Display Mode Chain | String | Parallel | Orientation of dimensions (`Parallel`, `Perpendicular`, or `None`). |
| Angle Text Height | Number | 20 | Text height (mm) for angle annotations. |
| Angle Offset | Number | 10 | Distance (mm) that angle text is offset from the corner vertex. |
| **Beam Properties** |
| New Material | String | Profiled Timber | Assigns this material name to all processed beams. |
| New Grade | String | C24 | Assigns this grade to all processed beams. |
| New Label prefix | String | PT | Prefix used to name profile groups (e.g., PT1, PT2). |
| **Filters** |
| Filter Message 1 | String | STEEL | Beams with this Grade are excluded from the report. |
| Filter Message 2 | String | - | Additional Grade filter for exclusion. |
| Filter Message 3 | String | ? | Additional Grade filter for exclusion. |
| Filter Message 4 | String | ? | Additional Grade filter for exclusion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select extra Beams** | Prompts you to select additional beams from the model. The script adds these to the existing set, re-calculates the unique profiles, updates quantities, and refreshes the report. |

## Settings Files
- None.

## Tips
- **Filtering Standard Beams**: This script automatically ignores standard rectangular beams (4 vertices with 90° corners) to focus only on complex or profiled items.
- **Grouping Logic**: If your report shows too many unique profiles that look identical, try increasing the **Tolerance** value. This helps group beams that have minor modeling discrepancies.
- **Excluding Non-Timber**: Use the **Filter Message** properties (e.g., set to "STEEL") to automatically ignore steel plates or connectors when selecting a large group of entities.

## FAQ
- **Q: Why did the script delete itself immediately?**
  - A: This happens if no beams were selected, or if all selected beams were filtered out (e.g., they matched the "STEEL" filter or were standard rectangles).
- **Q: Can I move the report after it is created?**
  - A: Yes, the report is standard AutoCAD geometry (lines and text). You can use standard AutoCAD Move commands to reposition it. Note that regenerating the script (via right-click menu) will redraw it at the original insertion point unless you move the script instance.
- **Q: The dimensions are cluttering the drawing.**
  - A: Change the **Display Mode Chain** property to `None` to suppress dimensions and show only the profile outlines.