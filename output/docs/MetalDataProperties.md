# MetalDataProperties

## Overview
This script allows you to assign structural attributes (Material, Execution Class, Mounting) and fabrication information to metal connectors. It automatically calculates weight and volume based on the part's geometry and the specified material density.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where metal parts are located. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model-level data tool, not a detailing script. |

## Prerequisites
- **Required Entities**: Metal Part Collections (e.g., custom plates or brackets) must exist in the model.
- **Minimum Beam Count**: 0 (This script works on Metal Parts, not Timber Beams).
- **Required Settings Files**: `MetalDataProperties.xml` (Must be located in the Company or Install `...\TSL\Settings` folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `MetalDataProperties.mcr` from the list.

### Step 2: Select Parts or Define Style
```
Command Line: Select metalparts, <Enter> to specify by style
```
**Action:** You have two options:
- **Entity Mode**: Click to select specific metal parts in the model, then press **Enter**.
- **Style Mode**: Press **Enter** immediately without selecting anything. This allows you to update all parts of a specific style at once.

### Step 3: Configure Properties
1. With the script object selected, open the **Properties Palette** (press `Ctrl+1`).
2. Modify the parameters as needed (see Parameters section below).
3. The script will automatically update the selected entities or the entire style definition and report the changes to the command line.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | dropdown | From XML | Defines the material grade (e.g., S355, Stainless Steel). Changing this updates the density used for weight calculation. |
| Execution Class | dropdown | From XML | Defines the EN 1090 Execution Class (e.g., EXC2) for production standards. |
| Mounting | dropdown | From XML | Defines where the part is installed (e.g., Factory, On Site). Useful for logistics planning. |
| Information | text | (Empty) | Free-text field for additional notes, surface treatments, or special instructions. |
| Style | dropdown | (Active only in Style Mode) | Selects the Metal Part Style to update globally. Only visible if you pressed Enter during insertion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific context menu items. All interactions are handled via the Properties Palette. |

## Settings Files
- **Filename**: `MetalDataProperties.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Defines available Materials (with specific densities), Execution Classes, and Mounting types. If this file is missing, the script will display an error and abort.

## Tips
- **Bulk Updates**: To update hundreds of identical brackets at once, use the **Style Mode** (press Enter at the prompt) instead of selecting individual items.
- **Mixed Selections**: If you select multiple parts that already have different settings (e.g., half are S235 and half are S355), the dropdown will display `<Varies>`. Selecting a new value from the list will overwrite all selected parts with that new value.
- **Weight Calculation**: The script calculates weight based on the volume of the 3D body. It excludes fasteners (screws/bolts) from this calculation to ensure accurate raw material weight.

## FAQ
- **Q: Why does the "Style" property disappear when I select parts?**
  A: The "Style" property is only available when you run the script in **Style Mode** (no entities selected). If you select specific entities, the script switches to **Entity Mode**, and the style property is hidden to prevent unintended global changes.
  
- **Q: I see an error about missing material definitions. What do I do?**
  A: The script cannot find `MetalDataProperties.xml` in your standard settings folders. Contact your CAD Manager to ensure this file is deployed to the correct network or local location.

- **Q: Does this change the physical shape of the metal part?**
  A: No. This script only updates data attributes (Material, Grade, Weight, etc.) attached to the part. It does not modify the geometry.