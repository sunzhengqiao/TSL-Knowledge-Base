# hsb_CreateSoleplate

## Overview
This script automates the generation of timber soleplates for wall elements. It handles geometry calculation for straight walls and T-junctions, applies wall code filters, and optionally inserts metalwork anchors and restraints based on user-defined parameters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D physical beams and metal parts. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: An existing Wall Element (`ElementWall`) must exist in the model.
- **Minimum Beam Count**: 0 (Script derives geometry from the Wall Element).
- **Required Settings Files**:
  - `hsb_Anchor` (script)
  - `hsb_Restraint` (script)
  - `hsb_SolePlate Material Table` (script/settings)
  - `hsb_SolePlateSplitAtDoors` (script)

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Navigate to the folder containing `hsb_CreateSoleplate.mcr` and select it.
3. Alternatively, assign the script to a toolbar button or menu for quick access.

### Step 2: Select Wall Element
```
Command Line: Select Element:
Action: Click on the Wall Element in the 3D model where you wish to generate soleplates.
```

### Step 3: Configure Parameters
```
Action: The script attaches to the element. Select the script instance (or the element) and open the Properties Palette (Ctrl+1).
Action: Adjust wall codes, dimensions, and metalwork settings as described below.
```

### Step 4: Recalculate
```
Action: Right-click on the script instance or the Wall Element.
Menu: Select "Recalculate" from the context menu.
Result: The script generates the beams and metal parts based on your settings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Code External Walls** | String | *Project Default* | The wall code identifier used to filter external walls for soleplate generation. |
| **Code Party Walls** | String | *Project Default* | The wall code identifier used to filter party walls. |
| **Width Soleplate** | Double | *e.g., 45mm* | The width (thickness) of the soleplate beam. |
| **Height Soleplate** | Double | *e.g., 100mm* | The height (depth) of the soleplate beam. |
| **Width Locating Plate** | Double | *e.g., 45mm* | The width of the locating plate (if applicable). |
| **Locating Plate Filter** | String | *Empty/All* | Comma-separated list of wall codes. If specified, locating plates are only generated for walls matching these codes. |
| **Min Length** | Double | *e.g., 50mm* | Minimum length of a soleplate segment. Segments shorter than this may be ignored or handled differently. |
| **Max Length** | Double | *e.g., 6000mm* | Maximum allowed length for a continuous soleplate segment. |
| **Anchor Centers** | Double | *e.g., 1200mm* | Spacing distance between anchor metal parts. |
| **Insert Anchors** | Boolean/Option | Yes/No | Toggles the insertion of the `hsb_Anchor` metal part. |
| **Restraint Scope** | Integer (0,1,2) | 0 (None) | Determines where restraints are placed: <br>0 = No Restraints<br>1 = External Walls Only<br>2 = All Walls |
| **Split at Doors** | Boolean/Option | No | If Yes, executes `hsb_SolePlateSplitAtDoors` to split soleplates at door openings. |
| **Material** | String | *Timber* | Material assignment for the generated beams. |
| **Layer** | String | *Soleplates* | The CAD layer on which generated beams are placed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Re-runs the script. Updates geometry, dimensions, and metal parts based on current Properties Palette settings or changes to the wall geometry. |
| **Erase** | Removes the script instance and typically deletes the generated geometry associated with it. |

## Settings Files
- **hsb_SolePlate Material Table**
  - **Purpose**: Generates a Bill of Materials (BOM) or schedule for the created soleplates.
- **hsb_Anchor**
  - **Purpose**: Defines the geometry and properties of the anchor metal parts inserted by the script.
- **hsb_Restraint**
  - **Purpose**: Defines the geometry and properties of the restraint metal parts.
- **hsb_SolePlateSplitAtDoors**
  - **Purpose**: A sub-script used to cut soleplate beams where door openings occur in the wall.

## Tips
- **Wall Codes**: Ensure your Wall Elements in the model have codes (e.g., "EXT", "PARTY") that exactly match the codes entered in the script properties, or no plates will be generated for those walls.
- **T-Junctions**: The script automatically calculates overlaps and intersections at wall T-junctions. Ensure your wall geometry is clean and joined correctly in the model before running.
- **Performance**: If running on large assemblies, consider turning off "Split at Doors" or metal part insertion initially to generate the basic timber structure faster.
- **Unit Independence**: The script handles internal unit conversions, but ensure you input dimensions in the project's current working units (usually mm for hsbCAD).

## FAQ
- **Q: Why are no soleplates appearing when I recalculate?**
  - **A**: Check the "Code External Walls" and "Code Party Walls" properties. If your wall codes in the model do not match these strings exactly, the script filters them out. Also, check that the wall length falls within the "Min Length" and "Max Length" range.

- **Q: Why are my anchors not showing up?**
  - **A**: Verify that "Insert Anchors" is enabled. Additionally, ensure the `hsb_Anchor.mcr` script exists in your TSL search path.

- **Q: Can I modify the plates after generation?**
  - **A**: Yes, you can use standard AutoCAD/hsbCAD editing commands (grips, properties) on the generated beams, but re-running the "Recalculate" command on the script will overwrite manual changes to match the script logic again.

- **Q: What does "Restraint Scope - External" do?**
  - **A**: It calculates the quantity of restraints based on the total length of walls identified as "External" and inserts metal parts only along those walls.