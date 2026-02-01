# GenericHangerExcelImporter.mcr

## Overview
Imports manufacturer hanger data (dimensions, heights, fixtures) from Excel spreadsheets into the hsbCAD database. This script automates the creation of hanger libraries so that physical hangers can be applied to beams using the Generic Hanger tool.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is a utility script that updates the database and runs in the model environment. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required entities:** None.
- **Minimum beam count:** 0.
- **Required settings files:**
  - `GenericHanger.xml` (Must be located in `_kPathHsbCompany\TSL\Settings` or the Install path).
  - `hsbExcelToMap.dll` or `hsbExcelToMap.exe` (External .NET tool used to parse Excel files).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLCONTENT`)
Action: Select `GenericHangerExcelImporter.mcr` from the file browser and click **Open**.

### Step 2: Select Excel File
```
Dialog: Select xlsx file
Action: Navigate to the manufacturer's Excel file and select it.
```
*Note: This dialog is provided by the external hsbExcelToMap tool. The script will automatically parse the file to find valid worksheets containing the required headers (Manufacturer, Family, Article).*

### Step 3: Complete Import
Action: Once the file is selected, the script automatically imports the data into the current project's dictionary (MapObjects).
*Note: The script instance will automatically erase itself from the drawing after the import is complete to keep the drawing clean.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Path | text | (empty) | Stores the directory path of the last used Excel file. |
| Sheet Import | dropdown | <All Sheets> | Specifies which worksheet tab to import. Options are populated dynamically after the file is scanned. |
| Import Mode | dropdown | Drawing | Determines where the data is saved.<br>**Drawing**: Saves hangers only for the current project.<br>**Drawing + Company XML**: Saves to the project AND exports an XML file to the Company Standards folder (`_kPathHsbCompany\TSL\Settings`) for use in all projects. |

## Right-Click Menu Options
*No specific context menu items are defined for this script.*

## Settings Files
- **Filename:** `GenericHanger.xml`
- **Location:** `_kPathHsbCompany\TSL\Settings` or Install folder.
- **Purpose:** Stores default manufacturer configurations and version information. It is updated automatically if a new manufacturer is detected during import.

- **Filename:** `[ManufacturerName].xml` (e.g., `Simpson.xml`)
- **Location:** `_kPathHsbCompany\TSL\Settings`
- **Purpose:** If "Import Mode" is set to "Drawing + Company XML", this file is created/updated to export the imported hanger definitions as a company-wide standard.

## Tips
- **Excel Format:** Ensure your Excel file contains the required header columns (e.g., Manufacturer, Family, Article, Dimensions A-P). If these are missing, the script will report "Could not find any data."
- **Company Standards:** To make imported hangers available to all projects, change the **Import Mode** to "Drawing + Company XML". *Note: You may need to modify this property immediately upon insertion before the script finishes processing, depending on your specific setup.*
- **Updating Data:** You can run this script multiple times. If a hanger with the same Article number already exists, it will be overwritten with the new data from Excel.
- **Verification:** After running the script, use the Generic Hanger tool to place a hanger and verify that the new products appear in the selection list.

## FAQ
- **Q: The script disappeared immediately after I selected the file. Is that normal?**
  - A: Yes. This is a "fire-and-forget" utility script. It updates the database and erases itself from the drawing to prevent clutter.
  
- **Q: I got an error "Could not find any data". What does this mean?**
  - A: The script could not find the required column headers (like "Manufacturer" or "Article") in the selected Excel sheet. Check that the Excel file format matches the required template.

- **Q: How do I import fixtures or hardware along with the hangers?**
  - A: The script supports fixtures if they are defined in the Excel data (e.g., in a specific "Fixture" sheet). Ensure the fixture references in the main hanger sheet match the keys defined in the fixture list.