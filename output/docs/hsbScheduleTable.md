# hsbScheduleTable.mcr

## Overview
This script generates a customizable schedule table (such as a BOM, cut list, or hardware list) directly in your CAD drawing. It uses Excel-based report definitions to format data derived from selected timber elements, hardware, or other entities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Standard placement for project-wide schedules. |
| Paper Space | Yes | Can be placed on layout sheets. |
| Shop Drawing | Yes | Supports automatic generation on shop drawings; will delete itself if no content is found. |

## Prerequisites
- **Required Entities**: You must manually select GenBeams, Elements, or other entities to populate the table.
- **Minimum Beam Count**: 0 (Empty tables are allowed during creation, though they may auto-delete in Shop Drawings).
- **Required Settings**:
    - Excel Report Definitions located in your Company folder.
    - `hsbExcel.dll` and `TslUtilities.dll` must be installed.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbScheduleTable.mcr`
Click in the drawing (Model or Paper Space) to set the insertion point (`_Pt0`).

### Step 2: Select a Report Definition
**Action:** Double-click the new table instance OR Right-click and select **|Select Report|**.
A dialog appears listing available report definitions from your Company folder. Select the template that matches the data you want to show (e.g., "Timber List", "Hardware List").

### Step 3: Add Entities to the Table
**Action:** Right-click and select **|Add Entities|**.
The command line will prompt:
```
Select entities:
```
Select the beams, walls, or elements in your model that you want to include in the schedule. Press Enter to confirm. The table will update immediately with the new data.

### Step 4: Adjust Table Layout
**Action:** Click and drag the blue grips on the table.
- **Horizontal Drag**: Adjusts column widths.
- **Vertical Drag**: Adjusts text height.
- **Free Drag**: Scales both text and width proportionally.

## Properties Panel Parameters
This script primarily utilizes the Right-Click Context Menu and interactive Grips for configuration. Standard Properties Panel inputs are not used for the main configuration.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **|Add Entities|** | Opens a selection prompt to append new elements to the current schedule. |
| **|Remove Entities|** | Opens a selection prompt to remove specific elements from the current schedule. |
| **|Select Report|** | Opens a dialog to switch the table template (e.g., from a BOM to a Cut List). |
| **|Update Report Definition|** | Reloads the report configuration from the Company folder (useful if Excel templates were edited externally). |
| **|Export Settings|** | Saves the current table configuration (column widths, text height, etc.) to an XML file. |
| **|Import Settings|** | Loads a previously saved configuration from an XML file. |

## Settings Files
- **Filename**: `Excel Report Definitions` (varies by Company)
- **Location**: Company Folder (retrieved automatically)
- **Purpose**: Defines the columns, sorting, and data sources for the table.

- **Filename**: `[UserDefined].xml`
- **Location`: User-defined path (during Export)
- **Purpose`: Stores custom visual settings (text height, column widths) to reuse in other drawings.

## Tips
- **Quick Template Change**: Simply double-click the table to swap the report definition without going through the context menu.
- **Shop Drawing Safety**: If a schedule table placed on a Shop Drawing finds fewer than 2 rows of data (effectively empty), it will automatically delete itself to keep drawings clean.
- **Overwrite Warning**: When exporting settings, if the file name already exists, the command line will ask `|Are you sure to overwrite existing settings?|`. Type `Yes` to confirm.
- **Grip Editing**: Use the grips to fit the table perfectly into your drawing title block.

## FAQ
- **Q: My table is blank after inserting it.**
  - A: The table starts empty. You must Right-click -> **|Add Entities|** and select the parts from your model to generate data.

- **Q: Can I use this for hardware only?**
  - A: Yes. Select a Report Definition designed for hardware/metal parts during the **|Select Report|** step.

- **Q: Why did my table disappear from the layout?**
  - A: In Shop Drawing mode, if the script detects no valid content (rows < 2), it erases the instance automatically. Check if your referenced elements exist in that specific view or section.