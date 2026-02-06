# hsbDACH_ConfigureDensities.mcr

## Overview
This script manages the material density database used by hsbCAD for weight and structural calculations. It automatically generates or repairs the `Materials.xml` configuration file and launches a .NET interface that allows you to add, edit, or delete material definitions and their densities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the Model Space. |
| Paper Space | No | Not supported in Paper Space layouts. |
| Shop Drawing | No | Not intended for use within shop drawing contexts. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings/Files:**
    - `hsbMaterialDensityTable.dll` (located in the `hsbCAD\Utilities` folder).
    - Write access to the Company folder (`_kPathHsbCompany\Abbund`) to create or modify the XML files.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDACH_ConfigureDensities.mcr`

### Step 2: Automatic Execution
**Action:** Upon insertion, the script runs automatically.
- If the `Materials.xml` file is missing in your Company folder, the script will generate it using built-in defaults (e.g., C24, GL24h, Steel, Concrete).
- If a legacy configuration file (`hsbGenBeamDensityConfig.xml`) exists, the script will migrate your old data into the new format.

### Step 3: Manage Materials
**Action:** A dialog window will appear displaying the current material table.
- Use this interface to **Add** new materials, **Edit** existing densities, or **Delete** entries.
- Changes are saved immediately to the `Materials.xml` file.

### Step 4: Completion
**Action:** Close the dialog window.
- The script will display a result message indicating success or reporting an error.
- The script instance will automatically erase itself from the drawing to keep your project clean.

## Properties Panel Parameters
This script does not expose any user-editable parameters in the Properties Palette (OPM). All configuration is handled via the external dialog window launched upon insertion.

## Right-Click Menu Options
There are no custom right-click menu options associated with this script.

## Settings Files
- **Filename:** `Materials.xml`
  - **Location:** `_kPathHsbCompany\Abbund\`
  - **Purpose:** Stores the list of material names and their corresponding densities (kg/m³). This file is used by other scripts to calculate element weights.

- **Filename:** `hsbGenBeamDensityConfig.xml`
  - **Location:** `_kPathHsbCompany\Abbund\`
  - **Purpose:** Legacy file used to import old density settings if `Materials.xml` is not found. Safe to delete after migration.

## Tips
- **Automatic Cleanup:** Do not be alarmed if the script entity disappears immediately after insertion; this is intended behavior to prevent drawing clutter.
- **Default Values:** The script comes pre-loaded with common timber grades (C24, GL24h, KVH) and structural materials (Steel, Concrete) so the file is usable immediately.
- **Unit Consistency:** Densities are stored in kg/m³. Ensure you enter values in this unit for correct weight calculations in BOMs and transport reports.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  - A: This is a utility script that performs a setup task and then self-destructs (`eraseInstance`). It does not represent a physical object in your building model.

- **Q: I received the error "No Valid dll or path not found". What does this mean?**
  - A: The script cannot locate the required interface DLL. Check your hsbCAD installation folder to ensure `hsbMaterialDensityTable.dll` exists in the `Utilities` subfolder. You may also need to check your user permissions for the Company folder.

- **Q: How do I share my material list with colleagues?**
  - A: Since the data is stored in `Materials.xml` in the shared Company folder, your changes are automatically available to anyone using the same company configuration path.