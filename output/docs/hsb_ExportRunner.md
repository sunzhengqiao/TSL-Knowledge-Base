# hsb_ExportRunner.mcr

## Overview
This utility script automates the export of timber construction data (geometry, machining, and BIM information) to external formats such as BTL, PXML, or IFC. It uses specific configurations defined in the ModelMap to filter and format the data for manufacturing or architectural coordination.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space to access the project geometry. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a model export utility, not a drawing generator. |

## Prerequisites
- **Required Entities**: At least one valid entity (Element, Beam, Sheet, Panel, or Group) must be present, depending on the selection mode chosen.
- **Configuration**: A valid "Exporter Group" must be configured in the hsbCAD ModelMap.
- **Required Space**: Model Space.

## Usage Steps

### Step 1: Launch Script
Execute the script using the command line or menu:
```
Command: TSLINSERT
Select File: hsb_ExportRunner.mcr
```

### Step 2: Configure Properties
Upon insertion, the Properties Palette will appear. Set the following parameters before proceeding:

1.  **Entity Selection Mode**: Choose what to export (e.g., Project, Current floor level, Elements, Panels).
2.  **Exporter Group**: Select the target configuration (e.g., BTL, IFC) from the dropdown list.
3.  **Allow XRef Selection**: Set to "Yes" if you want to include data from externally referenced files (XRefs), especially for Panels.

### Step 3: Execute Selection
Close the Properties Palette (or click OK) to trigger the export logic.

- **If "Project" or "Current floor level" is selected**: The script immediately processes the data without further prompts.
- **If "Elements", "Beams", "Sheets", or "Panels" is selected**: The following command line prompt appears:
  ```
  Command Line: Select [entities] to export
  Action: Click to select the desired objects in the drawing, then press Enter.
  ```

### Step 4: Completion
The script runs the export and automatically removes itself from the drawing. Check the destination folder specified in your Exporter Group configuration for the output file.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Entity Selection Mode | dropdown | Project | Defines the scope of the export. Options include Project, Current floor level, Elements, Entities, Beams, Sheets, Panels, or specific Floor Groups. |
| Exporter Group | dropdown | <First available> | Selects the configuration set (from ModelMap) that dictates the output format (e.g., BTL, PXML, IFC) and data mapping. |
| Allow XRef Selection | dropdown | No | If set to "Yes", the script scans for and includes data from XRefed drawings (specifically for Panels/SIPs). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script executes immediately upon insertion and does not remain in the drawing for right-click context menu interactions. |

## Settings Files
- **Source**: hsbCAD ModelMap Configuration
- **Location**: Defined in your hsbCAD environment (Company or Install path)
- **Purpose**: Provides the "Exporter Group" definitions that control file formats, naming conventions, and attribute mappings used during the export.

## Tips
- **Quick Export**: Use the "Project" or "Current floor level" mode to export large amounts of data without manually selecting individual beams or walls.
- **XRef Handling**: If your project uses modular components modeled in separate files (XRefs), ensure "Allow XRef Selection" is set to "Yes" to capture the complete geometry of those panels.
- **Troubleshooting**: If the export fails, verify that the chosen "Exporter Group" is correctly configured in the ModelMap and that you have write permissions to the export folder.

## FAQ
- **Q: The script disappeared after I ran it. Is that normal?**
  **A:** Yes. This is a "runner" script. It performs the task and then deletes itself (`eraseInstance`) automatically to keep your drawing clean.
- **Q: Why did I get an error "Call of the exporter has failed"?**
  **A:** This usually means the "Exporter Group" selected in the properties does not exist in your ModelMap, or the output path is invalid/read-only. Check your ModelMap settings.
- **Q: Can I export specific walls from different floors at once?**
  **A:** Yes. Set the "Entity Selection Mode" to "Elements" or "Beams". When prompted, manually select the specific items from various floors, then press Enter.