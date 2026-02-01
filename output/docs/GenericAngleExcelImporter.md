# GenericAngleExcelImporter.mcr

## Overview
This utility script imports Angle Bracket hardware data from a specific Excel file format into the hsbCAD database. It allows you to update hardware catalogs for the current drawing session and permanently update your company's standard configuration files.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the model space to import data. |
| Paper Space | No | Not applicable for this data import tool. |
| Shop Drawing | No | This script is for model data management only. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - `GA.xml` (General Settings file).
  - `hsbExcelToMap` component (DLL/EXE).
  - A valid Excel file (`.xlsx`) containing the hardware data with specific headers (Manufacturer, Family, Article).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `GenericAngleExcelImporter.mcr` from the file browser.

### Step 2: Select Excel File
1.  A standard Windows File Dialog will appear automatically.
2.  Navigate to the folder containing your hardware Excel file.
3.  Select the file and click **Open**.

### Step 3: Configure Import Settings
1.  The script will pause. Select the script instance in the drawing (if not already selected).
2.  Open the **Properties Palette** (press `Ctrl+1`).
3.  **Sheet Import**: Select a specific worksheet from the dropdown or choose "All Sheets" to import data from every tab in the Excel file.
4.  **Import Mode**: Choose the scope of the import:
    -   `|Drawing|`: Imports data only for the current session (temporary).
    -   `|Drawing + Company XML|`: Imports data for the current session AND updates the company XML files on the hard drive (permanent).

### Step 4: Execute Import
1.  Right-click anywhere in the drawing area.
2.  Select **Recalculate** from the context menu.
3.  The script will process the data. A message will appear in the command line (e.g., "X articles imported").
4.  The script instance will automatically erase itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheet Import | Dropdown | All Sheets | Select which Excel worksheet to process. Options are populated based on the file selected in Step 2. |
| Import Mode | Dropdown | \|Drawing\| | Determines if the update is temporary (current session only) or permanent (updates Company XML files). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Executes the import process using the currently selected properties. |

## Settings Files
- **Filename**: `GA.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores the list of available manufacturers and script version information.

## Tips
- **Excel Format**: Ensure your Excel file contains the required headers: "Manufacturer", "Family", and "Article". If these are missing, the script will report an error.
- **Updating Standards**: Use the `|Drawing + Company XML|` mode only when you are sure the data is correct and ready to be shared with all users in your company.
- **Re-running**: The script remembers the last used file path. To run it again on a different file, simply insert the script and select the new file when the dialog appears.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is normal behavior. The script is designed as a transient utility; it erases itself from the drawing after successfully importing the data to keep your drawing clean.
- **Q: Can I import data from multiple Excel files at once?**
  - A: No, you must run the script separately for each Excel file.
- **Q: What happens if I choose "|Drawing|" mode?**
  - A: The hardware data will be available in your current drawing session, but if you close the drawing or start a new one without updating the XML, the new data will not appear. Other users will not see the changes.