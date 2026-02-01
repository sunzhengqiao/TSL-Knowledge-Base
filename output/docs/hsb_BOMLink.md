# hsb_BOMLink.mcr

## Overview
This script serves as a utility tool to export timber construction model data from the drawing to an external Bill of Materials (BOM) or ERP system via the hsbSoft BOMLink interface. It facilitates the transfer of project data, such as material lists and production details, without creating physical geometry in the CAD model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on the 3D model entities. |
| Paper Space | No | This script does not process layouts or viewports. |
| Shop Drawing | No | This is for model data export, not detailing annotations. |

## Prerequisites
- **Required Entities:** Beams or Elements to export.
- **Minimum Beam Count:** 0 (Can run with no entities, though export may be empty).
- **Required Settings:**
  - `BOMLINKPROJECT` property must exist in the **Project Map** (HSB_PROJECTSETTINGS). The script will abort if this Project ID is missing.
  - External .NET dependency: `hsbSoft.BomLink.Tsl.dll` must be present in the hsbCAD installation path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_BOMLink.mcr`

### Step 2: Configure Export Options
Once inserted, the script instance is selected. Open the **Properties Palette** (Ctrl+1) to configure the export parameters:
1. **Entities to export:** Choose whether to export the whole model or select specific items.
2. **BOMLink Outputs:** Select the specific destination or report format (e.g., Material List) from the list.

### Step 3: Execute Export
*   **Scenario A (Select entities in drawing):** If you chose this option in the properties, the command line will prompt:
    ```
    Command Line: Select entities to be exported
    Action: Click the beams or elements you wish to include in the export, then press Enter.
    ```
*   **Scenario B (Select all entities in drawing):** The script is ready to run immediately.

### Step 4: Trigger Processing
Since this script is a utility, it often needs a trigger to communicate with the external system.
1. Right-click on the script instance in the drawing.
2. Select **Recalculate Results** from the context menu.
3. The script will gather the data, send it to the external BOM system, and then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Entities to export | Dropdown | Select all entities in drawing | Determines the scope. Choose to process the entire active model or manually select specific beams/elements. |
| BOMLink Outputs | Dropdown | (Dynamic) | Selects the specific report type or destination in the external system. Options are loaded dynamically from your BOMLink configuration. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate Results | Triggers the export process. Sends the collected data to the BOMLink module based on the current property settings. |

## Settings Files
- **Filename:** N/A (Relies on Project Settings)
- **Location:** Project Map (HSB_PROJECTSETTINGS)
- **Purpose:** The script looks for the string property `BOMLINKPROJECT` within your project settings to tag the export with the correct Job ID.

## Tips
- **Project ID:** Ensure `BOMLINKPROJECT` is correctly defined in your Project Settings before running this script; otherwise, it will fail silently or stop execution.
- **Single Use:** This script is designed to erase itself (`eraseInstance`) after successfully exporting data. You do not need to delete it manually.
- **External App:** If the "BOMLink Outputs" dropdown is empty, check with your system administrator to ensure `hsbSoft.BomLink.Tsl.dll` is correctly installed and configured.

## FAQ
- **Q: Why did the script disappear after I right-clicked it?**
- **A:** This is normal behavior. The script is designed as a "trigger" tool that erases itself from the drawing once it has successfully handed the data over to the external BOM system.

- **Q: I get an error or nothing happens when I click "Recalculate".**
- **A:** Check that the `BOMLINKPROJECT` property is filled in your Project Settings. This is a mandatory identifier for the export to work.