# hsbCLT-Lifter

## Overview
Automates the insertion, configuration, and machining of lifting hardware (anchors, straps, bolts) for CLT panels. It manages drill holes, cutouts, and generates production data exports for safe transport and assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for script execution. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: One (1) GenBeam (typically a CLT Wall or Floor panel).
- **Required Settings**: `hsbCLT-Lifter.xml` must be present in the `Company\Tsl\Settings` or `HsbInstall\Content\General\Tsl\Settings` folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbCLT-Lifter.mcr` from the file list.

### Step 2: Select CLT Panel
```
Command Line: Select GenBeam:
Action: Click on the CLT panel (GenBeam) you wish to add lifting hardware to.
```
*Note: The script will automatically determine the appropriate lifting device family based on whether the selected panel is a Wall or a Floor.*

### Step 3: Verify and Configure
Action: Once the script runs, check the 3D model for the inserted hardware and machining.
- If the hardware is not visible, check if your panel thickness matches the family requirements (see Tips).
- Use the **Grip Point** to adjust the position of the hardware on the panel.
- Use the **Right-Click Menu** to change the device family or configure export settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | *Configuration for this script is handled via the Right-Click Context Menu rather than the Properties Palette.* |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Tool Description Settings | Opens a dialog to configure the format string, Map Name, and Key Name used for tool description exports (e.g., for labels or CAM lists). |
| Configure Secondary Lifting Device | Opens a selection dialog to assign a secondary lifting device (e.g., a loose pin) that is automatically inserted along with the primary device. |
| Import Settings | Reloads configuration from the `hsbCLT-Lifter.xml` file. Useful for restoring standard settings. |
| Export Settings | Saves the current configuration (families, formats, etc.) to the `hsbCLT-Lifter.xml` file. You will be prompted to confirm if you wish to overwrite existing settings. |

## Settings Files
- **Filename**: `hsbCLT-Lifter.xml`
- **Location**: `Company\Tsl\Settings` or `HsbInstall\Content\General\Tsl\Settings`
- **Purpose**: Stores the catalog of available lifting device families, their machining parameters (drills, cutouts), thickness limits, and tool description formatting rules.

## Tips
- **Panel Thickness**: The script automatically filters lifting devices based on the thickness of the selected GenBeam. If a device does not appear, it may be because the panel is too thin or too thick for that specific family.
- **Moving Hardware**: Use the insertion point grip to drag the lifting hardware along the face of the panel. The machining (holes/cutouts) will update automatically.
- **Secondary Devices**: Use the "Configure Secondary Lifting Device" option if your workflow requires inserting a second piece of hardware (like a pin) whenever a primary anchor is placed.

## FAQ
- **Q: Why didn't any lifting hardware appear after I ran the script?**
  - A: Check if the `hsbCLT-Lifter.xml` file exists in your settings folder. Also, verify that your panel thickness matches the `MinThickness` and `MaxThickness` defined in the XML for the available families.

- **Q: How do I change the name format for the production export list?**
  - A: Right-click the script instance and select **Tool Description Settings**. Here you can define the format string (e.g., `%Family-%Number`) and the Map/Key names for the export.

- **Q: Can I use this for floor panels and wall panels?**
  - A: Yes. The script analyzes the selected GenBeam to determine if it is a Wall or Floor and selects the appropriate default lifting device based on the XML settings.