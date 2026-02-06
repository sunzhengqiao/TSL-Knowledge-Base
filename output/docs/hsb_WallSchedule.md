# hsb_WallSchedule.mcr

## Overview
Generates a customizable 2D schedule table in ModelSpace that lists properties (dimensions, areas, shapes) of selected wall elements. It includes functionality to export the schedule data directly to Microsoft Excel.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The schedule is placed at a user-selected coordinate in Model Space. |
| Paper Space | No | Not supported for Paper Space layout. |
| Shop Drawing | No | This script does not generate Shop Drawing entities. |

## Prerequisites
- **Required Entities**: `Element` (Wall) or `GenBeam` entities must be present in the model.
- **Minimum Beam Count**: 0 (Script handles empty selection by drawing a placeholder).
- **Required Settings**:
  - `hsb_WallPanelSchedule.dll` (Required for processing element data).
  - `hsb_WriteExcelTable.dll` (Required for Excel export functionality).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_WallSchedule.mcr` from the file dialog.

### Step 2: Configure Properties
1.  Upon insertion, the Properties Palette (OPM) will display, allowing you to configure the schedule appearance (Title, Dimension Style, Colors, etc.).
2.  You may adjust these now or modify them later after insertion.

### Step 3: Define Insertion Point
```
Command Line: Pick insertion point for the table
Action: Click in the Model Space to set the top-left corner of the schedule.
```

### Step 4: Select Wall Elements
```
Command Line: Select Elements
Action: Select the Wall Elements or GenBeams you wish to include in the schedule and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Dimstyle| | dropdown | _DimStyles | Determines the text style (font, height) used for the schedule table. Column widths are calculated based on this style. |
| |Title:| | text | \|Wall Schedule\| | The main title text displayed at the top of the table. |
| |String Type Align| | dropdown | \|Left\| | Horizontal alignment for text-based data (e.g., Marks). Options: Left, Right, Center. |
| |Double Type Align| | dropdown | \|Left\| | Horizontal alignment for numerical data (e.g., Lengths). Options: Left, Right, Center. |
| |Int Type Align| | dropdown | \|Left\| | Horizontal alignment for integer data (e.g., Quantities). Options: Left, Right, Center. |
| |Pline Type Align| | dropdown | \|Left\| | Horizontal alignment for graphical profiles (wall shapes). Options: Left, Right, Center. |
| |Scale Factor| | number | 0 | Shrinkage/inset value for graphical profiles (mm). Use this to reduce the size of wall outlines so they don't touch cell borders. |
| |Grid Color| | number | 8 | AutoCAD Color Index (ACI) for the table grid lines. |
| |Text Color| | number | 254 | AutoCAD Color Index (ACI) for the text inside the table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Export to Microsoft Excel | Exports the current schedule data to an Excel file named `WallSchedule.xlsx` in the project folder. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML settings files; it relies on DLL dependencies (`hsb_WallPanelSchedule.dll` and `hsb_WriteExcelTable.dll`) for functionality.

## Tips
- **Adjusting Text Size**: To change the text size of the schedule, change the `|Dimstyle|` property to a style with a different text height. The table will automatically resize.
- **Fitting Wall Shapes**: If the graphical elevation of the wall touches the grid lines, increase the `|Scale Factor|` value to shrink the graphic inside the cell.
- **Visual Updates**: You can modify any property in the Properties Palette after insertion, and the table will automatically redraw to reflect the changes.

## FAQ
- **Q: What happens if I select no elements?**
  **A:** The script will draw a simple placeholder box containing only the Title. You must delete this instance and re-run the script if you need to populate the table, or check if valid elements were selected.
- **Q: Why did the script disappear after I selected elements?**
  **A:** This typically occurs if the script detects a duplicate instance cycle or if the processing logic found no valid data. Ensure you are selecting valid hsbCAD Elements.
- **Q: Where is the Excel file saved?**
  **A:** It is saved in the current project folder with the filename `WallSchedule.xlsx`.