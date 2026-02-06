# Simpson StrongTie HTT-Zuganker.mcr

## Overview
Inserts a Simpson Strong-Tie HTT (Heavy Tension Tie) timber connector onto a selected beam. It generates the 3D hardware model and applies the necessary tooling/milling to the timber element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto a GenBeam. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities:** GenBeam (Timber beam).
- **Minimum beam count:** 1.
- **Required settings files:** `FixtureDefinition.xml` (Must exist in Company or Install TSL Settings folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Simpson StrongTie HTT-Zuganker.mcr`

### Step 2: Select Beam
```
Command Line: Select 1 or more beams
Action: Click on the timber beam(s) in the Model Space where you want to install the HTT anchor and press Enter.
```

### Step 3: Configure Parameters
```
Action: After insertion, select the script instance and open the Properties palette (Ctrl+1). Adjust parameters like Type, Depth, or Gap as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | HTT5 | Select the connector model: HTT5 (smaller) or HTT22 (larger). |
| Depth | number | 0 | Milling depth into the timber (mm). Enter 0 for surface-mounted, or a value > 0 to recess the connector into the wood. |
| Gap | number | 0 | Offset distance (mm) from the reference point, useful for creating space for facade layers or tolerances. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit Fixing | Opens a dialog to modify fixture definitions (Article No., Manufacturer, Dimensions). |
| Delete Fixing | Opens a dialog to remove a specific fixture definition from the list. |
| Add Fixture to [Script Name] | Opens a dialog to link an existing fixture definition to this script instance. |
| Export Settings | Saves the current fixture configuration to the `FixtureDefinition.xml` file on disk. |

## Settings Files
- **Filename**: `FixtureDefinition.xml`
- **Location**: `...\TSL\Settings\` (Company or Install folder).
- **Purpose**: Stores the configuration data for fixtures, including geometry references, manufacturer details, and models. If missing, the script may fall back to defaults or fail.

## Tips
- **Recessing the Anchor**: Set the **Depth** property to the thickness of the steel plate (approx. 2-3mm) to allow the strap to sit flush with or below the timber surface if required by the design.
- **Facade Clearance**: Use the **Gap** parameter to push the connector away from the beam if you need to account for exterior insulation or plaster layers.
- **Double Anchors**: The script automatically detects if a partner anchor is installed on the opposite side of the beam and adjusts accordingly.
- **Project Compatibility**: The script filters beams based on project specials (e.g., BAUFRITZ). Ensure you are selecting the correct beam elements for your specific project configuration.

## FAQ
- Q: I see an error or nothing happens when I select the beam.
- A: Ensure `FixtureDefinition.xml` exists in your settings folder. If the file is missing, the script cannot load fixture definitions.
- Q: How do I switch between the HTT5 and HTT22 models?
- A: Select the script instance, open the Properties palette, and change the **Type** dropdown from HTT5 to HTT22.
- Q: What happens when I click "Export Settings"?
- A: The script will ask "Are you sure to overwrite existing settings?". Type **Yes** to save your current configuration to the XML file, making it available for other instances or users.