# bauBIT-Exporter.mcr

## Overview
This script prepares and exports manufacturing data from hsbCAD models to the bauBIT production system. It processes selected panels to extract geometry and machining details, then triggers the generation of the external production file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in 3D Model Space. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**: Elements, MasterPanels, or Sips present in the model.
- **Minimum Beam Count**: None (you can select all objects in the model).
- **Required Settings**: A valid "Exporter Group" for bauBIT must be defined in your hsbCAD ModelMap configuration before running the script.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `bauBIT-Exporter.mcr` from the file list.

### Step 2: Select Exporter Group
**Note**: This step only appears if multiple Exporter Groups are defined in your configuration.
- **Dialog**: A properties dialog will appear.
- **Action**: Select the specific Exporter Group configuration you wish to use from the dropdown list.
- **Error Handling**: If no Exporter Groups are found, a notice will appear stating "Please define an Exporter Group first and try again." You must configure this in the ModelMap to proceed.

### Step 3: Select Entities
```
Command Line: Select object(s) <Enter> to select all:
```
- **Action**: Click on the specific panels or elements you want to include in the export, OR press **Enter** to automatically select all valid entities in the current Model Space.

### Step 4: Execute
- The script will automatically analyze the selected geometry, compile the machining data, and run the export process. The script instance will erase itself from the drawing once finished.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Exporter Group | Dropdown | (Dynamic List) | Selects the specific export configuration (defined in hsbCAD ModelMap) that determines how data is formatted for the bauBIT system. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu items are defined for this script. |

## Settings Files
- **Configuration**: ModelMap Exporter Group
- **Location**: Defined within hsbCAD Project/ModelMap settings
- **Purpose**: Contains the logic for mapping hsbCAD geometry attributes to the bauBIT file format requirements.

## Tips
- Use the **Enter** key when prompted for selection to process the entire project quickly without manually picking individual walls.
- The script automatically filters out unsupported beam types, so you do not need to worry about selecting invalid geometry.
- Ensure your work is saved before running the export, as the process writes external data files.

## FAQ
- **Q: Why does the script show a notice saying "Please define an Exporter Group first"?**
  **A**: The script relies on a pre-configured definition in the hsbCAD ModelMap to know what to export. This needs to be set up by your CAD Manager or system administrator.

- **Q: Can I export just a single wall instead of the whole house?**
  **A**: Yes. When the command line asks you to select objects, simply click on the specific wall (MasterPanel or Element) you wish to export instead of pressing Enter.

- **Q: What happens if I select a mix of panels and beams?**
  **A**: The script will intelligently filter the selection, processing the supported panels and ignoring unsupported entities automatically.