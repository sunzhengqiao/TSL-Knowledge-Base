# GL_PLOT_CUT_LIST.mcr

## Overview
Generates a visual cut list (timber list) in Model Space that itemizes all beams within a selected Element, grouping them by type and quantity while displaying dimensions and labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates geometry (lines and text) directly in the model. |
| Paper Space | No | Not designed for Paper Space viewports. |
| Shop Drawing | No | This is a Model Space generation script, though used for shop floor documentation. |

## Prerequisites
- **Required Entities**: An existing Element (Wall or Panel) containing beams.
- **Minimum Beam Count**: 0.
- **Required Settings**: None strictly required, though an existing AutoCAD DimStyle is recommended for text formatting.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse the file dialog and select `GL_PLOT_CUT_LIST.mcr`.

### Step 2: Select Element
Command Line: `Select Element:`
Action: Click on the Wall or Panel element you wish to generate the cut list for.

### Step 3: Insert Table
Command Line: `Insert point:`
Action: Click in the Model Space where you want the top-left (or alignment point) of the table to appear.

### Step 4: Configure (Optional)
Action: Select the newly inserted table script. Open the **Properties Palette** (Ctrl+1) to adjust headers, column widths, or beam label settings as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| strDimStyle | String | _DimStyles | The Dimension Style used to control text font and height appearance. |
| propHeader | String | Timber List | The title text displayed at the top of the list. |
| nColorIndex | Integer | 7 | The AutoCAD color index for the header text. |
| dTH | Double | 0 | Text height in mm. If set to 0, the height is taken from the DimStyle. |
| **Layout** | | | |
| strDirection | String | Horizontal | Orientation of the table: "Horizontal" or "Vertical". |
| strJustify | String | Top | Vertical alignment: "Top" or "Bottom" relative to the insertion point. |
| nMaxRow | Integer | 16 | Maximum number of rows displayed before a new page/table is created. |
| **Content** | | | |
| strTranslateId | String | Yes | If "Yes", converts beam codes (e.g., '30') to readable names (e.g., 'Stud'). |
| vtpIgnor | String | No | If "Yes", excludes Very Top Plates (DTP) from the list. |
| dmm | Double | 1 | Multiplier for dimension values (e.g., set to 25.4 to convert mm to inches). |
| stAddGradeToSize | String | Yes | If "Yes", appends the material grade (e.g., C24) to the size description. |
| intText | Integer | 2 | Algorithm for placing labels near beams (1-4) to avoid overlaps. |
| **Column Widths (d1-d14)** | Double | Various | Sets the width (in mm) for each column in the table. |
| **Beam Names (Aliases)** | String | Mapped | User-defined names for beam types (BP=Bottom Plate, TP=Top Plate, etc.). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the table and labels based on current wall geometry or property changes. |
| Erase | Removes the script and all generated geometry from the drawing. |

## Settings Files
- **Filename**: None specific.
- **Location**: N/A
- **Purpose**: This script relies on internal mapping and standard AutoCAD DimStyles rather than external XML settings files.

## Tips
- **Adjusting Layout**: If the table is too wide, change `strDirection` to "Vertical" to stack columns downwards.
- **Unit Conversion**: If you need imperial lengths but draw in metric, change the `dmm` parameter to `25.4` (or vice versa) to convert the displayed values without changing the model.
- **Label Overlap**: If labels on the drawing overlap with other elements, try changing the `intText` value (1 through 4) to shift their position logic.
- **Custom Names**: You can rename standard parts by editing the alias properties (e.g., change `Stud` to `Vertical Stud`) directly in the Properties palette.

## FAQ
- **Q: Why do I see numbers like "30" instead of "Stud" in the Timber Name column?**
  **A:** The `strTranslateId` property is likely set to "No". Change it to "Yes" to use readable names.
- **Q: The text size is incorrect, how do I fix it?**
  **A:** Check `dTH`. If it is 0, the script uses the text height defined in your `strDimStyle`. Change `dTH` to a specific value (e.g., 2.5) to override the style.
- **Q: Can I exclude specific plates from the count?**
  **A:** Yes. Set `vtpIgnor` to "Yes" to exclude Very Top Plates. You can also filter other types by manipulating the Beam Name aliases or column widths, though excluding DTP is the built-in toggle.