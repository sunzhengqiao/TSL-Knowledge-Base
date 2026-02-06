# hsbSwapGenbeamProperties.mcr

## Overview
A utility tool to copy, move, or swap textual property data (such as Name, Material, or Grade) between different fields of selected GenBeams. It is useful for reorganizing beam data, for example, copying position numbers into the name field or renaming materials with a specific prefix.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on GenBeams in the 3D model. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Does not process entities on drawing sheets. |

## Prerequisites
- **Required entities**: GenBeams must exist in the drawing.
- **Minimum beam count**: 1 or more beams must be selected to execute the operation.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `hsbSwapGenbeamProperties.mcr`.

### Step 2: Configure Properties
**Action**: The Properties Palette (or a dialog box) will appear. Adjust the following settings before proceeding:

1.  **Source**: Select the property field you want to read data from (e.g., *Posnum*).
2.  **Target**: Select the property field you want to write data to (e.g., *Name*).
    *   *Note*: Ensure the Source and Target are different, or the script will error.
3.  **Prefix**: Enter any text string you want to add to the beginning of the source data (e.g., "REV-"). Leave empty if not needed.
4.  **Mode**: Select how the data is handled:
    *   *Overwrite*: Copies Source to Target. Source remains unchanged.
    *   *Overwrite and clear source*: Copies Source to Target, then deletes the data in the Source field.
    *   *Swap Values*: Exchanges the data between Source and Target.

### Step 3: Select GenBeams
**Command Line**: `Select genbeam(s)`
**Action**: Click on the beams you wish to modify in the model space. Press **Enter** or **Space** to confirm your selection.

### Step 4: Execution
**Action**: The script processes the selected beams and updates their properties. The script instance will automatically erase itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Source | Dropdown | Posnum | The property field to read data from (e.g., Posnum, Name, Material, Information, Label, Grade, Sublabel, Sublabel2). |
| Target | Dropdown | Name | The property field to write data to (e.g., Name, Material, Information, Label, Grade, Sublabel, Sublabel2). |
| Prefix | Text | (Empty) | A text string added to the start of the source data when writing to the target field (e.g., typing "OLD-" adds "OLD-" to the value). |
| Mode | Dropdown | Overwrite | Determines how the data transfer is handled. Options: "Overwrite", "Overwrite and clear source", or "Swap Values". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This is a command script that runs once and erases itself; it does not offer persistent right-click menu options. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Use Prefix for Versioning**: If you need to keep old data but mark it as obsolete, set the Target to the current field (e.g., Name), Source to Name, Prefix to "OLD-", and Mode to "Overwrite". Wait, this requires Source != Target. *Correction*: Use this logic when copying from one field to another, e.g., copy Name to Material with a prefix to preserve old names in the material slot.
- **Swapping Data**: The "Swap Values" mode is perfect if you accidentally filled the "Name" field with data that should be in the "Material" field and vice versa.
- **Avoiding Errors**: Always double-check that **Source** and **Target** are set to different properties. If they match, the script will display an error message and exit.

## FAQ
- **Q: What happens if I select 0 beams?**
  A: The script will start the selection prompt. If you confirm the selection without picking anything, the script will simply end without making changes.
- **Q: Why did the script abort immediately after opening?**
  A: You likely set the **Source** and **Target** properties to the same value. The script prevents writing a field to itself to avoid logic errors.
- **Q: Can I use this script on Wall elements or Panels?**
  A: No, this script is designed specifically for **GenBeams**. It will not recognize or process other entity types.