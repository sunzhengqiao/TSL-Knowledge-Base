# GE_PLOT_CUT_LIST.mcr

## Overview
Generates a formatted cut list (timber take-off) table in Paper Space and places part labels on the elevation view of a selected wall or panel. It identifies parts by name, dimensions, and quantity while providing customizable labeling for production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Partial | Labels are placed relative to the model geometry. |
| Paper Space | Yes | The cut list table is drawn here. An active viewport is required. |
| Shop Drawing | Yes | Designed for creating production details and schedules. |

## Prerequisites
- **Required Entities**: An existing Element (Wall or Panel) in the drawing.
- **Minimum Beam Count**: 0 (Works on empty elements, though output will be empty).
- **Required Settings**: A Paper Space Layout tab with an active Viewport displaying the target element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select the script from the hsbCAD menu)
Action: Select `GE_PLOT_CUT_LIST.mcr` from the file dialog.

### Step 2: Select Element
**Note**: If the script is executed via the Element context menu (Right-click on Wall), this step is skipped.
```
Command Line: Select Element:
Action: Click on the Wall or Panel in the drawing or Project Manager to generate the list for.
```

### Step 3: Specify Insertion Point
```
Command Line: Insertion point:
Action: Click in the Paper Space layout where you want the top-left (or corner based on justification) of the table to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General Settings** |
| `strDimStyle` | String | "" | AutoCAD Dimension Style used to determine text font and default height. |
| `propHeader` | String | "Timber List" | The title text displayed at the top of the table. |
| `nColorIndex` | Integer | 7 | Color Index (ACI) for the header text (7 is usually White/Black). |
| `dTH` | Double | 0 | Text height in Paper Space. If 0, uses height from `strDimStyle`. |
| **Table Layout** |
| `strDirection` | String | "Horizontal" | Orientation of the table: "Horizontal" or "Vertical". |
| `strJustify` | String | "Top" | Vertical growth direction: "Top" (grows down) or "Bottom" (grows up). |
| `nMaxRow` | Integer | 16 | Maximum number of rows to display in a single table instance. |
| `d1` through `d14` | Double | Varied | Width of individual columns (e.g., Timber Name, Size, Label, Qty, Dimensions). |
| **Content & Filtering** |
| `strTranslateId` | String | "Yes" | If "Yes", converts internal codes (e.g., 114) to readable names (e.g., Stud). If "No", shows raw numbers. |
| `vtpIgnor` | String | "No" | If "Yes", excludes "Very Top Plate" (VTP) entities from the list. |
| `stAddGradeToSize` | String | "Yes" | If "Yes", appends material grade (e.g., C24) to the size string. |
| `dmm` | Double | 1.0 | Multiplier for dimensions. Set to 0.001 to convert mm to meters in the list. |
| **Name Mappings** |
| `All` / `Stud` / `TP` / `BP` etc. | String | Various | Custom names for timber types. Allows renaming "Stud" to "Vertical Stud" etc. |
| **Labeling** |
| `intText` | Integer | 2 | Algorithm mode for placing labels to avoid overlap (1, 2, 3, or 4). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Regenerates the table and labels based on current geometry and property settings. |
| Properties | Opens the Properties palette to edit script parameters. |
| Erase | Removes the script and the generated table/labels from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configuration is handled via Properties.

## Tips
- **Avoiding Label Overlap**: If labels on the elevation view overlap, try changing the `intText` property to a different value (1, 2, 3, or 4). This changes the search pattern for empty space.
- **Unit Conversion**: If your project requires metric dimensions (meters) but the model is in millimeters, set `dmm` to `0.001` to scale the values in the table automatically.
- **Table Sizing**: If the table looks squashed, increase the values of `d1` through `d14` corresponding to the columns that are too narrow.
- **Text Height**: For precise control over text size, set a specific value for `dTH` (e.g., 2.5 mm) rather than relying on the Dimension Style.

## FAQ
- **Q: Why does my table show numbers like "114" instead of "Stud"?**
  - A: Check the `strTranslateId` property. Ensure it is set to "Yes". If it is already "Yes", check the `Stud` property to ensure the mapping text hasn't been deleted.
- **Q: The text in my table is tiny or huge.**
  - A: Check `dTH`. If it is 0, the script uses the text height from the `strDimStyle` DimStyle. Either set `dTH` to your desired paper space height (e.g., 2.5) or change the text height in the AutoCAD DimStyle.
- **Q: Why is the table not appearing?**
  - A: Ensure you are on a Paper Space Layout tab and that you have an active Viewport. The script needs to transform coordinates from Model Space to Paper Space.
- **Q: How do I exclude the top plates from the count?**
  - A: Set the `vtpIgnor` property to "Yes".