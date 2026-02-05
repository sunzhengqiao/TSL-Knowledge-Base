# Nail-SheetOnBeam.mcr

## Overview
This script automates the generation of nail patterns (naillines) on structural timber and sheet materials. It allows users to apply predefined sheathing schedules (e.g., for OSB or Plywood) to wall panels or roof elements and manage a library of these nailing rules via configuration files.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D geometry and machining. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: `GenBeam` or `Sheet` elements.
- **Minimum Beam Count**: 0 (You can select a single sheet or multiple beams).
- **Required Settings**:
  - `Nail-Configuration.xml` (Must exist in `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`).
  - hsbcad version 23 or higher (for PainterDefinitions support).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Nail-SheetOnBeam.mcr`

### Step 2: Select Elements
```
Command Line: Select Beams or Sheets
Action: Click on the timber beams or sheet material you want to apply nailing to, then press Enter.
```

### Step 3: Configuration
The script will attempt to apply the default nailing rule.
- **If using a preset**: Ensure the desired Configuration and Rule Name are selected in the Properties Palette before inserting.
- **If manual**: Adjust geometric properties (offsets, spacing) in the Properties Palette after insertion.

### Step 4: (Optional) Save Settings
If you have manually adjusted the nailing pattern and wish to reuse it:
1. Right-click the script instance.
2. Select **Save as rule**.
3. Enter the Configuration name and Rule Name in the dialog that appears.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Nailing Set** | Text | "Configuration" | Enter the name for a new group of nailing rules (e.g., "Standard Sheathing"). |
| **Remove Set** | Dropdown | *Dynamic* | Select an existing group of nailing rules to permanently delete it. |
| **Configuration** | Dropdown | *Dynamic* | Select a specific group (category) to save a new rule into or delete an existing rule from. |
| **Rule Name** | Text | "Rule Name" | Enter a unique name for a specific nailing pattern (e.g., "Nail 150/300") when saving a new rule. |
| **Rule Name (Delete)** | Dropdown | *Dynamic* | Select a specific nailing pattern preset to delete from the currently selected Configuration. |

*Note: Standard geometric parameters (Offsets, Spacings) are also available in the Properties Palette but are intended to be managed via the "Save as rule" workflow.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Edit in Place** | Activates the script for modification. Can also be triggered by double-clicking the instance. |
| **Add new Configuration** | Opens a dialog to create a new group/container for organizing nailing rules. |
| **Remove Configuration** | Opens a dialog to delete an existing group and all its rules from the settings file. |
| **Save as rule** | Opens a dialog to save the current instance's settings (spacing, offsets) as a reusable preset. |
| **Delete rule (ConfigurationName)** | Opens a dialog filtered to a specific configuration to allow deletion of a specific nailing preset. |
| **Show Rule Definitions** | Prints a text report of all configurations and their parameters to the report console. |

## Settings Files
- **Filename**: `Nail-Configuration.xml`
- **Location**: Searches in `Company\TSL\Settings` or `Install\Content\General\TSL\Settings`.
- **Purpose**: Stores all defined nailing configurations (PainterDefinitions) and rule parameters.

## Tips
- **Purge Empty Instances**: The script automatically deletes itself if no valid nail lines are generated during the calculation.
- **Overwriting**: If you try to save a rule with a name that already exists, look at the command line. You will be prompted: `Overwrite existing rule? [No/Yes]`. Type `Y` and Enter to confirm.
- **Rule Management**: Use the dynamic menu item **Delete rule (ConfigurationName)** to quickly access the specific configuration you are working with without scrolling through the master list.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  A: The script automatically erases itself if it does not generate any nail lines. Check that your selected elements have valid surfaces and that the PainterDefinitions are active.
- **Q: Where are my nail rules stored?**
  A: They are stored in the `Nail-Configuration.xml` file. If you move the project to a new PC, you may need to copy this XML file to retain your custom rules.
- **Q: How do I change the nailing pattern on a single sheet without changing the rule?**
  A: Double-click the instance (Edit in Place), change the parameters in the Properties Palette, and ensure you do not use the "Save as rule" option, or save it under a new name.