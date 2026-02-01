# hsb_ExcelImport.mcr

## Overview
Imports structural elements (beams and block references) from an external Excel file into the hsbCAD 3D model, automatically generating geometry based on spreadsheet coordinates and properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Geometry is created in 3D model space. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: None (this script creates new entities).
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - A valid Excel file (`.xlsx`) containing specific Sheet keys (e.g., "Beam", "BlockReference") and column headers (coordinates, dimensions).
  - The `hsbExcelToMap.exe` utility must be present in the hsbCAD installation directory (`...\Utilities\hsbExcelToMap\`).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_ExcelImport.mcr` from the available scripts list.

### Step 2: Specify Excel File
```
Dialog: hsbCAD Properties
Action: A dialog appears prompting for the file path.
```
1. In the **Last File Path** field, enter the full path to your Excel file (e.g., `C:\Projects\StructureData.xlsx`) or click the browse button ("...") to locate it.
2. Click **OK** to confirm.

### Step 3: Process Data
The script will automatically run the external utility to parse the Excel file and generate the beams and blocks in the model.

**Note**: Once processing is complete, the script instance will erase itself from the drawing. The resulting geometry will remain as standard hsbCAD entities.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Last File Path | Text | "" | The full file system path to the Excel file containing the import data. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not have custom context menu options. It erases itself after running. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Configuration is handled via the input Excel file format).

## Tips
- **Script Self-Deletion**: After the geometry is created, the script instance disappears. To modify the imported elements, you must manually edit the resulting beams/blocks or re-run the script to generate new ones.
- **Excel Formatting**: Ensure your Excel file uses the specific headers required by `hsbExcelToMap.exe`. Typically, this includes columns for Origin (X, Y, Z), Vectors, Dimensions (Width, Height, Length), and Material.
- **Coordinate System**: Verify that the coordinates in the Excel file match the current UCS/World coordinate system of your CAD model to ensure elements are placed in the correct location.

## FAQ
- **Q: Why did the script icon disappear immediately after I ran it?**
  A: This is normal behavior. The script is designed to generate geometry and then erase itself (`eraseInstance`). The beams and blocks you see are the final results.
- **Q: Nothing appeared in my model after running the script.**
  A: Check that the path in `Last File Path` is correct and that the Excel file contains data in sheets named exactly as expected (e.g., "Beam", "BlockReference"). Also, ensure `hsbExcelToMap.exe` is not blocked by your firewall or antivirus.
- **Q: Can I update the geometry by changing properties later?**
  A: No, because the script instance is removed. To update, you must run the script again with a new or updated Excel file.