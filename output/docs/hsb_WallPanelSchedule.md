# hsb_WallPanelSchedule.mcr

## Overview
This script generates a 2D schedule table in Model Space listing dimensions, area, weight, and descriptions of selected hsbCAD wall panels. It is typically used for creating production lists, bill of materials, or estimation reports directly in the CAD model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The table is generated as 2D geometry (Text and Polylines) at the user's selected location. |
| Paper Space | No | This script does not function in Layout viewports. |
| Shop Drawing | No | This is a reporting tool for the model, not an automated shop drawing detailer. |

## Prerequisites
- **Required Entities**: At least one hsbCAD Wall Element (`Element` or `ElementWall`) must exist in the model.
- **Minimum Beam Count**: N/A (Script operates on Elements, not individual beams).
- **Required Settings**: None. The script uses the current drawing's Dimension Styles for text formatting.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsb_WallPanelSchedule.mcr` from the file dialog or TSL Catalog.

### Step 2: Set Insertion Point
```
Command Line: Pick a Point
Action: Click in the Model Space to define the top-left corner of the schedule table.
```

### Step 3: Select Wall Elements
```
Command Line: Please select Elements
Action: Select one or more Wall Elements from the model and press Enter.
```
*Note: If no elements are selected, the script will exit and erase itself.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General Settings** |
| sTitle | String | Panel Schedule | The header text displayed at the top of the table. |
| sDimStyle | String | Current Standard | The dimension style used to determine text font and size. |
| nPropZone | Index | 0 | The material layer used to calculate Area. `0` uses the outer outline. `1-5` calculates area based on specific sheeting layers. |
| **Column Visibility** |
| sShowDescription | Yes/No | Yes | Shows the Element Code/Description column. |
| sShowHeight | Yes/No | Yes | Shows the Height column. |
| sShowLength | Yes/No | Yes | Shows the Length column. |
| sShowThickness | Yes/No | Yes | Shows the Thickness column (sum of all zones). |
| sShowWeight | Yes/No | Yes | Shows the Weight column (reads from Element MapX data). |
| sShowArea | Yes/No | Yes | Shows the Area column. |
| **Appearance** |
| nColor | Integer | 7 (White) | Color index for the main data text. |
| nTitleColor | Integer | 4 (Cyan) | Color index for the Table Title. |
| nHeaderColor | Integer | -1 (ByLayer) | Color index for the column header text. |
| nLineColor | Integer | -1 (ByLayer) | Color index for the table grid lines. |
| **Sorting** |
| sPrimarySortKey | Enum | Wall Number | The first criteria to sort the panel list (e.g., Wall, Length, Weight). |
| sSecondarySortKey | Enum | Wall Number | The criteria used if Primary values are identical. |
| sTertiarySortKey | Enum | Wall Number | The criteria used if Primary and Secondary values are identical. |
| sSortMode | Enum | Ascending | Determines if the list sorts Ascending or Descending. |

## Right-Click Menu Options
Standard AutoCAD/TSL context menus apply. To modify the table content or appearance, select the script instance and use the **Properties Palette**. Changes to properties automatically trigger a redraw of the table.

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Area Calculation**: Use `nPropZone = 0` to get the overall bounding box area of the wall. Use a specific zone index (e.g., `1`, `2`) to report the area of specific sheeting material layers (like OSB or Plasterboard).
- **Sorting**: To create a cutting list or packing list, set the Primary Sort Key to `Length` or `Area` to group similar-sized panels together.
- **Updating Data**: If wall dimensions change in the model, select the schedule and click the "Refresh" (Recalculate) button in the Properties palette or type `REGEN` to update the values.
- **Weight Data**: Ensure your Elements have been processed/updated so that MapX weight data is available; otherwise, the Weight column will show "0 Kg".

## FAQ
- **Q: Why does the Area column show 0?**
  A: Check the `nPropZone` property. If set to a specific zone (e.g., 1), ensure the wall actually has a material layer defined at that index. If set to 0, ensure the wall elements have valid geometry.
- **Q: Can I move the table after inserting it?**
  A: Yes. Select the table object and use standard AutoCAD Move commands (grips or `MOVE` command).
- **Q: Why is the text too small or huge?**
  A: The text size is controlled by the `sDimStyle` property. Change the Dimension Style to one with appropriate text height settings for your current scale.