# _hsbReport.mcr

## Overview
Generates dynamic construction reports, cut lists, and bill of materials (BOM) tables directly in the CAD drawing. It uses predefined report definitions from the `hsbExcel` module to display data related to beams, elements, or master panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Can generate reports for the entire model or selection sets. |
| Paper Space | Yes | Can output reports onto drawing sheets. |
| Shop Drawing | Yes | Can be used within single drawing views or Element Layouts (ELO). |

## Prerequisites
- **Required Entities**: GenBeams, Elements, or MasterPanels to generate data from.
- **Minimum Beam Count**: 0 (Reports can be empty).
- **Required Settings**:
  - `hsbExcel.dll`: Required for accessing report logic.
  - Report Definitions: Pre-configured XML templates created with the hsbExcel Report Designer.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `_hsbReport.mcr` from the list.

### Step 2: Select Report Definition
A dialog box appears titled "Report Name".
- **Action**: Select the desired report template (e.g., "Element Overview", "Cut List", "Hardware List") from the dropdown list.
- **Note**: The list is populated from your company's hsbExcel configuration.

### Step 3: Select Sub Report
A second dialog box appears titled "Sub Report".
- **Action**: Select a specific section or subset of the main report (e.g., "Top Plates", "Studs") if applicable.
- **Note**: Options vary depending on the Report Name selected in the previous step.

### Step 4: Place the Table
```
Command Line: Pick insertion point:
Action: Click in the drawing (Model or Paper Space) to place the top-left or bottom-left corner of the table.
```
The table is automatically generated based on the entities in the current scope.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Report Name | dropdown | (Empty) | Selects the master report template. Changing this resets the Sub Report options. |
| Sub Report | dropdown | (Empty) | Selects the specific data subset or section within the chosen report. |
| Text Height | number | 2.5 | Sets the height of the text in the table (in millimeters). |
| Alignment | dropdown | Horizontal | Sets the table orientation. Options: Horizontal or Vertical. |
| Direction | dropdown | Bottom | Determines growth direction from the insertion point. Options: Bottom (grows up) or Top (grows down). |
| Column Widths | text | 50 | Defines the width for each column (comma-separated, e.g., "20,50,100"). |
| Decimals | text | 2 | Sets the number of decimal places for numerical values. |
| Header Overrides | text | (Empty) | Renames column headers manually using text (e.g., "Length|Qty|Mark"). |
| Description | text | (Empty) | A user-defined label to identify this specific report instance. |
| Color | number | 7 | AutoCAD color index for the main table lines and text. |
| Color Child Entities | number | 7 | AutoCAD color index for sub-rows or child items. |
| Dimstyle | dropdown | _Standard | Specifies the AutoCAD dimension style to use for text font properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change Report Definition | Opens the dialog to select a different Report Name or Sub Report. Useful for switching the table type without re-inserting. |
| Toggle visible items | Hides or shows specific rows in the report. |
| Set first column as subheader | Groups rows based on the value in the first column. Repeating values in the first column are hidden to create a grouped view. |
| Disable first column as subheader | Removes the grouping effect, showing all values in the first column. |
| Add Entities | Adds selected Beams, Elements, or MasterPanels to the data calculation scope. |
| Remove Entities | Removes selected entities from the report calculation. |
| Sort | Opens options to sort the report data by a specific column. |
| Swap Columns | Swaps the position of two selected columns in the table layout. |

## Settings Files
- **Filename**: `hsbExcel.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbExcel`
- **Purpose**: Contains the engine that processes report definitions and extracts data from the model.

- **Filename**: Report Definitions (XML)
- **Location**: `_kPathHsbCompany` (or configured Company path)
- **Purpose**: Stores the layout, column logic, and filtering rules for specific reports (created by an administrator).

## Tips
- **Quick Formatting**: Use `sHeaderOverrides` to rename column headers directly in the Properties Palette without needing to edit the XML definition file.
- **Grouping**: For long lists of studs or similar items, use the "Set first column as subheader" context menu option to group them visually.
- **Fit to Frame**: If a column is too narrow, the script automatically truncates text with "..." (ellipsis). Adjust the `Column Widths` property (string format like "30,60,40") to fit your content.

## FAQ
- **Q: Why did the report table disappear immediately after inserting?**
  - **A**: This usually happens in Shop Drawing mode if the data source contains invalid characters (such as the '@' symbol). Check the properties of the elements or referenced data for invalid characters.
- **Q: How do I change the text font?**
  - **A**: The script uses the selected `Dimstyle`. Change the `Dimstyle` property in the palette to one that uses your desired font.
- **Q: Can I export this data to Excel?**
  - **A**: This specific script draws the table as CAD entities (Text and Polylines). To export raw data, you would typically use the "Export to Excel" functions within the hsbExcel toolbar, rather than this drawing script.