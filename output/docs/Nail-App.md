# Nail-App.mcr (Nailing Application Tool)

## Overview
Applies automated nailing lines to timber wall, floor, or roof elements based on predefined rule configurations. This tool streamlines the nailing process by automatically generating nail patterns on sheets attached to beams within selected elements, using settings stored in a configuration file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**: One or more `Element` objects (walls, floors, or roofs) with attached sheets.
- **Required Settings**: `Nail-Configuration.xml` must exist and contain at least one valid configuration.
- **Supporting Scripts**: Uses `Nail-SheetOnBeam` and `Nail-SheetOnSheet` TSL scripts internally. These must be available in your TSL folder.
- **Configuration Setup**: Before using Nail-App, you must create at least one nailing configuration using the supporting scripts (`Nail-SheetOnBeam` or `Nail-SheetOnSheet`). Insert one of these tools, adjust its properties, then use the context menu command to store the rule configuration.

## Usage Steps

### Step 1: Prepare Configuration (First Time Only)
Before using Nail-App, ensure a nailing configuration exists:
1. Insert `Nail-SheetOnBeam` or `Nail-SheetOnSheet` on an element.
2. Adjust properties and preferences as needed.
3. Use the appropriate context command to store the rule configuration.
4. The configuration is saved to `Nail-Configuration.xml`.

### Step 2: Launch Script
Command: `TSLINSERT` then select `Nail-App.mcr` from the list, or use the command:
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Nail-App")) TSLCONTENT
```

### Step 3: Select Configuration (If Multiple Exist)
```
Dialog: Select Configuration
Action: If multiple configurations are stored, a dialog appears. Select the desired configuration name from the list.
```
*Note: If only one configuration exists, this step is skipped automatically.*

### Step 4: Select Elements
```
Command Line: Select elements
Action: Click on one or more Element objects (walls, floors, roofs) to apply the nailing configuration. Press Enter when selection is complete.
```

### Step 5: Automatic Processing
The script will:
1. Remove any existing nail lines from the selected elements.
2. Remove any existing nailing TSL instances (Nail-SheetOnBeam, Nail-SheetOnSheet) from the elements.
3. Create new nailing patterns based on all rules defined in the selected configuration.
4. Self-delete after completion (the Nail-App instance is temporary).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration | String | (First available) | Selects which nailing configuration to apply. Each configuration contains one or more rules that define nail patterns, spacing, and placement for sheets on beams or sheets on sheets. |

## Settings Files
- **Filename**: `Nail-Configuration.xml`
- **Location (Company)**: `hsbCompany\TSL\Settings\Nail-Configuration.xml`
- **Location (Default)**: `hsbInstall\Content\General\TSL\Settings\Nail-Configuration.xml`
- **Purpose**: Stores named nailing configurations. Each configuration contains multiple rules that reference specific nailing scripts and their property values.
- **Management**: Use `hsbTslSettingsIO` or the XML-Settings ribbon command to import/export configurations between drawings and templates.

## Configuration Structure
Each configuration in the XML file contains:
- **Configuration Name**: User-defined identifier (e.g., "Standard Wall Nailing", "Floor Panels").
- **Rule[]**: Array of rules, each specifying:
  - **scriptName**: The nailing TSL to use (e.g., `Nail-SheetOnBeam`, `Nail-SheetOnSheet`).
  - **PropertyMap**: The property values (PropInt, PropDouble, PropString) to pass to the nailing script.

## Tips
- **Batch Processing**: Select multiple elements at once to apply the same nailing configuration across an entire floor level or building section.
- **Configuration Reuse**: Once a configuration is saved, it persists in the drawing and can be applied to new elements without reconfiguration.
- **Version Control**: The script validates configuration versions on instantiation. If a newer version of the settings file exists, you will receive a notification.
- **Clean Application**: The tool automatically removes existing nail lines and nailing TSLs before applying new ones, ensuring no duplicate patterns.

## FAQ
- **Q: I get "No configurations found" and the tool deletes itself.**
  **A:** You have not created any nailing configurations yet. Insert `Nail-SheetOnBeam` or `Nail-SheetOnSheet`, configure it, and use the context menu to store the rule as a configuration.

- **Q: My elements have no sheets attached, nothing happens.**
  **A:** Nail-App skips elements without sheets. Ensure your elements have sheeting (OSB, plywood, etc.) applied before running this tool.

- **Q: Can I have multiple rules in one configuration?**
  **A:** Yes. Each configuration can contain multiple rules. For example, you might have one rule for exterior sheathing and another for interior drywall, both applied in a single pass.

- **Q: How do I edit an existing configuration?**
  **A:** Modify the `Nail-Configuration.xml` file directly, or re-insert the source nailing script, adjust its settings, and overwrite the existing configuration by saving with the same name.

- **Q: Where are the settings stored?**
  **A:** Configurations are stored both in the XML file and as a MapObject in the drawing dictionary. The drawing-embedded version takes priority, but the XML file serves as the source for new drawings.

## Version History
| Version | Date | Description |
|---------|------|-------------|
| 1.5 | 23.12.2021 | Plugin mode supported |
| 1.4 | 21.09.2021 | Bugfix: erasing TSLs on insert |
| 1.3 | 05.03.2021 | Existing nail lines and nailing TSLs within the rule set are removed prior to creation |
| 1.2 | 28.10.2020 | Preview image updated |
| 1.1 | 19.10.2020 | Bugfix |
| 1.0 | 13.10.2020 | Initial release |

## Keywords
Nailing, Nail, Element, CNC
