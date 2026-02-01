# HSB_E-RunElementTsls

## Overview
This is a batch processing script that runs multiple TSL scripts on selected Elements based on a recipe defined in an external XML file. It allows you to apply complex sets of manufacturing details (like labels, wall connections, and sheathing) to an entire Element (wall/floor) in a single operation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Elements within the model. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not designed for detailing views. |

## Prerequisites
- **Required Entities**: Element (Wall or Floor).
- **Minimum Beam Count**: N/A (Elements are selected, not individual beams).
- **Required Settings Files**:
    - `RunElementTslsConfigurations.xml` (Created automatically if missing).
    - `HSB_G-FilterEntities` TSL must be loaded in the drawing for filtering logic to work.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-RunElementTsls.mcr` from the list.

### Step 2: Select Configuration Set
```
Command Line: |Select element(s)|
Properties Panel/Dialog: Select a "Configuration set" (e.g., 'RoofFinish', 'WallStandard').
Action: Choose the recipe you want to apply to the element from the dropdown list in the Properties Palette or the pop-up dialog.
```

### Step 3: Select Elements
```
Command Line: |Select element(s)|
Action: Click on the Element(s) (Walls/Floors) in the drawing you wish to process and press Enter.
```

### Step 4: Execution
The script will automatically process the selected elements, spawning the necessary sub-scripts defined in your configuration. The script instance will then erase itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration set | dropdown | (First entry in XML) | The name of the configuration set (recipe) to execute. Each set contains a list of specific construction scripts and the filtering logic required to apply them. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Execute Key (Catalog Name) | Runs the configuration set matching a specific catalog name passed via an external key (often used in automated workflows). |

## Settings Files
- **Filename**: `RunElementTslsConfigurations.xml`
- **Location**: `_kPathHsbCompany\Tsl\Settings\` (Your company folder)
- **Purpose**: Stores configuration sets (Maps) containing mappings of TSL scripts to elements, including which filters and catalogs to use.

## Tips
- **Transient Script**: This script deletes itself automatically after running. To change settings, you must re-insert the script; you cannot double-click it later to edit.
- **Missing File**: If the XML file is missing, the script will attempt to create a default folder structure and an "Example" XML file for you to configure.
- **Filter Errors**: If you see a warning about "Beams could not be filtered," ensure the `HSB_G-FilterEntities` TSL is loaded in your drawing.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is a "transient" script designed to perform a batch task and then remove itself to keep the drawing clean. To apply different settings, simply run the script again.
- **Q: What happens if my configuration file is missing?**
  - A: The script will try to generate a default "Example" configuration XML in your company settings folder. You can edit this file to define your own recipes.
- **Q: I got an error "Beams could not be filtered".**
  - A: Ensure the TSL named `HSB_G-FilterEntities` is loaded in your drawing. This script relies on it to select the correct beams within the Element.