# Excel2CadModel.mcr

## Overview
This script imports structural and architectural components (Beams, Sheets, Panels, and Blocks) defined in an Excel spreadsheet directly into the hsbCAD 3D model. It is used to convert schedules or cut lists from external estimators into CAD geometry without manual modeling.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates Beam, Sheet, Panel, and BlockRef entities in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **External Tool**: `hsbExcelToMap.exe` or `hsbExcelToMap.dll` must be present in the hsbCAD Utilities folder.
- **Source Data**: A valid Excel file (`.xlsx` or `.xls`) containing the data to be imported.
- **Worksheet Names**: The Excel file must contain worksheets named specifically `Beam`, `Sheet`, `Panel`, or `BlockRef` corresponding to the entities you wish to create.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Excel2CadModel.mcr`

### Step 2: Select Excel File
```
Command Line: Script triggers external utility...
Action: A file selection dialog (provided by the hsbExcelToMap utility) will open.
```
1. Navigate to the location of your Excel file.
2. Select the file and click **Open**.

### Step 3: Generate Model
```
Command Line: Processing data...
Action: The script reads the rows in the Excel file and automatically generates the corresponding 3D entities (Beams, Sheets, etc.) in the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Path | text | (Empty) | Stores the file path of the Excel file used in the last import. This acts as a memory aid, so the file dialog opens in the correct folder the next time you run the script. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No specific custom context menu actions are active for this script. |

## Settings Files
- **Filename**: N/A (This script does not use internal XML settings files).
- **Location**: N/A
- **Purpose**: The script relies entirely on the external Excel file for configuration and data inputs.

## Tips
- **Excel Formatting**: Ensure your worksheet names match exactly what the utility expects (e.g., `Beam`, `Sheet`, `Panel`, `BlockRef`). Incorrect naming usually results in no data being imported.
- **Block References**: If importing `BlockRef` entities, ensure the DWG files referenced in your Excel exist in the AutoCAD support path or the specified full path; otherwise, the blocks will fail to insert.
- **Path Memory**: If you frequently import from the same folder, check the "Path" property in the Properties Palette after the first run to verify the script remembered the location.

## FAQ
- **Q: I clicked to insert the script, but no dialog appeared.**
  A: This script relies on the external `hsbExcelToMap.exe`. Ensure this file exists in your `hsbCAD` Utilities folder. Also, check if the dialog window is hidden behind other AutoCAD windows.
- **Q: The script ran, but no geometry appeared.**
  A: Check your Excel file. It must contain one of the specific worksheet names (`Beam`, `Sheet`, etc.) to generate geometry. Empty worksheets or wrong names will result in no output.