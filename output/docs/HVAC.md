# HVAC.mcr

## Overview
This script converts structural beams into HVAC ductwork elements. It automatically assigns dimensions, airflow direction, and visual styles (3D model or 2D schematic) to a connected system of beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D GenBeam entities. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Used for modeling and detailing in the design phase. |

## Prerequisites
- **Required Entities**: Structural Beams (`GenBeam`) must exist in the model.
- **Minimum Beam Count**: 1 (the script will trace connections to find related beams).
- **Required Settings**: `HVAC.xml` (located in the company or install folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HVAC.mcr`.

### Step 2: Select Base Beam
```
Command Line: Select beam:
Action: Click on the structural beam that represents the start of your ductwork system.
```

### Step 3: Configure Properties
Action: Once inserted, select the script instance (or the beam it is attached to) and open the **Properties Palette** (Ctrl+1). Adjust dimensions and flow settings as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| bDrawAsLinework | Boolean | false | If **true**, displays ducts as 2D centerlines (plan view). If **false**, displays full 3D solids. |
| nColor | Integer | varies | Sets the AutoCAD color index (1-255) for the ductwork to differentiate systems (e.g., hot vs. cold air). |
| dDiameter | Double | 0 | Sets the diameter for **round** ducts. Entering a value > 0 forces a round profile. |
| dWidth | Double | 0 | Sets the width for **rectangular** ducts. (Used with dHeight). |
| dHeight | Double | 0 | Sets the height for **rectangular** ducts. (Used with dWidth). |
| bFlipFlow | Boolean | false | Reverses the calculated airflow direction by 180 degrees. |
| sFamily | String | *From XML* | Selects the catalog entry defining default properties for the ductwork. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **3D Ductwork** | Switches the visualization to solid 3D mode (Sets `bDrawAsLinework` to false). |
| **Linework** | Switches the visualization to 2D schematic centerlines (Sets `bDrawAsLinework` to true). |
| **Erase** | Removes the HVAC assignment from the beams and deletes the script instance. |

## Settings Files
- **Filename**: `HVAC.xml`
- **Location**: `<company>\tsl\settings`
- **Purpose**: Defines available catalog entries, default dimensions, and naming conventions for HVAC components.

## Tips
- **Profile Switching**: To switch between round and rectangular ducts, simply input a value into `dDiameter` (for round) OR `dWidth`/`dHeight` (for rectangular). The other values will be automatically ignored/overridden.
- **Flow Detection**: The script automatically detects flow direction based on beam connectivity. If the arrow points the wrong way, use the `bFlipFlow` property rather than rotating the beam manually.
- **Splitting Systems**: If you break a connection in the ductwork chain, the script automatically purges the reference to the disconnected section, keeping your data clean.
- **Performance**: For large models, use the **Linework** mode to simplify the visual display while retaining the data for BOM export.

## FAQ
- **Q: Why did my beams disappear from the 3D view?**
- **A**: Check the `bDrawAsLinework` property in the Properties Palette. If it is `true`, the beams are hidden and replaced by 2D lines. Change it to `false` or use the Right-Click menu **3D Ductwork** option.

- **Q: How do I export duct dimensions to my BOM?**
- **A**: The script automatically generates a hardware component attached to the instance containing total length and dimension data. Ensure your export template includes hardware components.

- **Q: Can I mix round and rectangular ducts in one system?**
- **A**: This script applies uniform properties to the connected stream. If you need mixed profiles, insert separate script instances for the different sections.