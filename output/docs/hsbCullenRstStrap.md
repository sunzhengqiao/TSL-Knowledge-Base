# hsbCullenRstStrap

## Overview
This script generates 3D geometry, labels, and hardware data for Cullen brand restraint straps (twist straps). It is used to connect two perpendicular timber beams or automatically distribute straps between a beam and a wall structure.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D bodies and hardware components. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Model detailing script only. |

## Prerequisites
- **Required Entities**: 
  - **Mode 0**: Two `GenBeams` (perpendicular to each other).
  - **Mode 101**: One `Beam` and one `ElementWall`.
- **Minimum Beam Count**: 2 (for standard connection) or 1 (for wall distribution mode).
- **Required Settings**: None specific (internal lookup tables used for strap types).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsbCullenRstStrap.mcr`.

### Step 2: Select Entities
**Standard Connection (Mode 0):**
```
Command Line: Select GenBeams
Action: Select two perpendicular GenBeams in the 3D model or Project Tree.
```

**Wall Distribution (Mode 101):**
1.  Select the script instance.
2.  Open the Properties Palette (Ctrl+1).
3.  Change the **Mode** property to `101`.
4.  Assign the main `Beam` and the `ElementWall` to the script instance in the tree or property links.
5.  The script will automatically calculate intersections with wall studs and create individual straps.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | String | TFPC | The Cullen product code (e.g., TFPC, TFPC 1000). Changing this updates the strap length and BOM description. |
| dWidthStrap | Double | 30 mm | The physical width of the metal strap. |
| dTextHeight | Double | 50 mm | The height of the text label displayed in the model. |
| Mode | Integer | 0 | **0**: Connects two GenBeams. **101**: Distributes straps between a Beam and a Wall (Generator Mode). |
| iVdir | Integer | 1 | Determines which face of the **first** beam the strap connects to (valid range: -1 to 4). |
| iVdir1 | Integer | 1 | Determines which face of the **second** beam the strap connects to (valid range: -1 to 4). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script geometry if changes were made to connected beams or properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal logic for strap dimensions based on the `sType` string. No external XML files are required.

## Tips
- **Flipping Orientation**: If the strap attaches to the wrong side of the beam, change the `iVdir` or `iVdir1` values in the Properties Palette.
- **Changing Sizes**: Simply type the new Cullen product code (e.g., "TFPC 1200") into the `sType` field to update the length and BOM data instantly.
- **Wall Joists**: Use **Mode 101** when you have a series of joists running into a wall. It will automatically detect the studs in the wall and place the straps for you, then remove itself.

## FAQ
- **Q: Why does the script say "2 genbeams needed"?**
  **A:** Ensure you are in **Mode 0** and have assigned exactly two GenBeams to the script instance.
- **Q: Why does the script disappear after I assign a wall and beam?**
  **A:** This happens in **Mode 101**. The script acts as a "generator"—it creates the individual strap instances at the stud locations and then deletes itself, leaving only the new straps behind.
- **Q: How do I change the strap length?**
  **A:** Edit the `sType` property to the desired manufacturer code (e.g., change "TFPC" to "TFPC 1000").