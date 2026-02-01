# bomLinkSettings.mcr

## Overview
Assigns a specific BOMLink project configuration to the current CAD model. This script acts as a bridge between the drawing and the external Bill of Materials system, ensuring data export follows the correct manufacturing or reporting standards.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the model to configure project data. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not for detailing views. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - `hsbSoft.BomLink.Tsl.dll` must be installed and accessible.
  - At least one BOMLink project must be defined in the external configuration/catalog.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `bomLinkSettings.mcr` from the list.

### Step 2: Automatic Configuration Check
The script will automatically check for available BOMLink projects.
- **Scenario A (Single Project)**: If only one project exists and no settings are currently applied, the script will automatically select it and finish. You may not see a dialog.
- **Scenario B (Multiple Projects)**: If multiple projects exist, or if settings are already applied, the Properties Palette will display the options.

### Step 3: Select Project
```
Properties Palette:
1. Locate the 'Project' dropdown.
2. Select the desired BOMLink project name.
OR
Select '<|Remove bomLink Settings|>' to clear current data.
```
*Note: Upon selection, the script updates the project data and immediately erases itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Project | dropdown | First available project | Selects the active BOMLink project configuration. Options are populated dynamically from the DLL. Includes an option to remove settings. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script erases itself immediately after running. There is no persistent element to right-click. To modify settings, re-insert the script. |

## Settings Files
- **Filename**: `hsbSoft.BomLink.Tsl.dll`
- **Location**: hsbCAD Application Directory / Plugins folder
- **Purpose**: Provides the list of available BOMLink projects and the specific configuration variables for each project.

## Tips
- **Disappearing Act**: It is normal for the script instance to disappear from the drawing immediately after you select a project. It has successfully saved the settings to the project's internal memory; you do not need to keep a visible element in the model.
- **Re-running**: To change the project later, simply run `TSLINSERT` and select this script again. It will overwrite the existing settings with your new selection.
- **Error Handling**: If you see a message stating "Could not find any project definitions," check that your BOMLink software is correctly installed and configured before running this script.

## FAQ
- **Q: Why did the script delete itself after I ran it?**
  A: This is a configuration utility script. Its sole purpose is to write data to the project map. Once the data is written, the physical script instance is no longer needed and is removed automatically.
- **Q: How do I know which project is currently active?**
  A: You can re-insert the script. The dropdown will default to the currently active project defined in the drawing's settings. Alternatively, check your BOMLink export settings.
- **Q: What happens if I select "<|Remove bomLink Settings|>"?**
  A: The script will clear all BOMLink configuration data from the current drawing, effectively unlinking it from the external BOM system.