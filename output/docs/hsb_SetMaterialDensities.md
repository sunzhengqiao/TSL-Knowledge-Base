# hsb_SetMaterialDensities.mcr

## Overview
This utility script manages the material density settings used for weight calculations in hsbCAD. It ensures a default configuration file exists and launches a dialog interface allowing you to view and edit the density values (kg/m³) for various materials such as timber, steel, and sheet goods.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary execution environment. |
| Paper Space | No | Not supported in Paper Space. |
| Shop Drawing | No | This is a configuration utility, not a drawing generator. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings Files:** 
    - `Materials.xml` (Auto-generated in the company folder if missing).
    - `hsbMaterialDensityTable.dll` (or the legacy `hsbMaterialTable.dll`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetMaterialDensities.mcr`
```
Command Line: (Click insertion point)
Action: Click anywhere in the Model Space to activate the script.
```

### Step 2: Edit Material Densities
```
Action: The Material Density Table dialog will appear automatically.
1. Review the list of Materials (e.g., STEEL, CLS, LVL, MDF, OSB).
2. Edit the Density value (in kg/m³) for any material as required.
3. Save or Close the dialog to apply changes.
```
*Note: The script will erase itself automatically once the dialog is closed.*

## Properties Panel Parameters
This script does not expose persistent parameters in the Properties Palette (OPM). Configuration is handled entirely through the external dialog launched upon execution.

| Concept | Type | Description |
|-----------|------|-------------|
| Material | String | The name of the material (e.g., CLS, LVL). This must match the material names assigned to your beams/sheets in the model. |
| Density | Number (Double) | The physical density of the material in kg/m³. Used to calculate the weight of elements. |

## Right-Click Menu Options
None. This script runs immediately upon insertion and erases itself, so no context menu options are available.

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `<Company Folder>\Abbund\Materials.xml`
- **Purpose**: Stores the mapping between Material Names and their corresponding Density values. If this file is missing when the script runs, it will be automatically created with default values (e.g., STEEL: 1000, CLS: 550, LVL: 600).

## Tips
- **Default Values:** If you run this script for the first time, check the generated defaults to ensure they match your local timber specifications.
- **Weight Calculations:** Use this script if your element weight reports seem incorrect; the issue is likely due to incorrect density values in this XML file.
- **Legacy Support:** The script automatically searches for the modern DLL (`hsbMaterialDensityTable.dll`) first, but will fall back to a legacy version if the newer one is not found.

## FAQ
- **Q: Why does the script disappear after I run it?**
  - A: This is a "utility" script designed to perform a setup task and then clean up after itself. The settings are saved in the XML file, not in the drawing entity.
- **Q: I see an error "No Valid dll or path not found". What do I do?**
  - A: Ensure your hsbCAD installation is intact and that `hsbMaterialDensityTable.dll` exists in your hsbCAD Utilities or General folder.
- **Q: How do I add a new material type?**
  - A: You can typically add new rows or edit the XML directly, though the provided dialog is the safest way to manage existing entries. Ensure the Name matches exactly what is used in your hsbCAD catalog.