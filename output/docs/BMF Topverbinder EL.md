# BMF Topverbinder EL

## Overview
Generates a variable BMF steel top-connector plate to join two beams in T- or L-configurations. It supports various connection styles (recessed, visible, or wall elements) and handles automatic milling and drilling.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Does not generate 2D layouts directly. |

## Prerequisites
- **Required Entities**: 2 GenBeams (or 1 GenBeam + 1 Element beam).
- **Minimum Beam Count**: 2.
- **Required Settings**: None (uses internal catalog/part numbers).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Select `BMF Topverbinder EL.mcr` from the file dialog.

### Step 2: Select First Beam
```
Command Line: Select first beam
Action: Click on the main beam (e.g., the wall plate or primary bearer) in the 3D model.
```

### Step 3: Select Second Beam
```
Command Line: Select second beam
Action: Click on the secondary beam (e.g., the joist or rafter) intersecting the first beam.
```
*Note: If the second beam belongs to a wall Element, the script will automatically detect this and adjust settings.*

### Step 4: Configure Connection
After selection, the Properties Palette will open automatically. Select the appropriate BMF size and connection type to generate the geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| BMF Topverbinder EL | dropdown | 30/BMF-Nr:348030 | Selects the connector size (plate width). Options range from 30mm to 100mm. |
| Connection Type | dropdown | Milled in female beam | Defines how the plate interacts with the timber (e.g., recessed milled slots, visible gap, or element connections). |
| HW Type | text | Screw | Fastener category (e.g., Screw, Bolt). |
| HW Description | text | ABC Spax | Description of the hardware for reports. |
| HW Model | text | | Specific model name/number. |
| HW Material | text | Aluminium | Material of the connector/hardware. |
| HW Notes | text | | Additional notes for production lists. |
| HW Length | number | 70 | Length of the fasteners (mm). |
| HW Diameter | number | 5 | Diameter of the fasteners (mm). |
| Offset V | number | 0 | Vertical adjustment of the connection height. |
| Offset H | number | 0 | Horizontal adjustment along the main beam axis. |
| Add Width | number | 2 | Tolerance added to the milling slot width (mm). |
| Add Depth | number | 5 | Extra length added to the milling slot (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the connector geometry if beams have moved or properties have changed. |
| Properties | Opens the Properties Palette to edit parameters. |
| Delete | Removes the script and associated machining/tools. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal logic and hard-coded BMF part numbers; no external XML settings file is required.

## Tips
- **L-Bearing Logic**: If the two beams selected are not in the same vertical plane (non-coplanar), the script automatically forces the "Connection Type" to **L-bearing** to ensure the steel plate fits correctly.
- **Element Integration**: If you select a secondary beam that is part of a wall Element, the script defaults the Connection Type to **Element**, which applies cuts to the element sheets/outline.
- **Steel Plate Visuals**: If "Steel" is chosen as the connection type, check the preview. A red warning line will appear if the distance to the lower edge of the beam is too small (< 40mm).

## FAQ
- **Q: Why did my Connection Type change to "L-bearing" automatically?**
  A: The script detected that the two beams are not perfectly aligned in the same plane. It switches to L-bearing mode to handle the vertical offset between the beams.
- **Q: What happens if I select a beam inside a wall element?**
  A: The script detects the Element membership and automatically switches to "Element" mode, ensuring the steel plate and cuts are compatible with the wall structure.
- **Q: How do I adjust the fit of the plate in the beam?**
  A: Use the `Add Width` and `Add Depth` properties to increase the size of the milled slot (House) if the timber is swelling or for easier assembly.