# hsbCLT-X-Fix-Connector.mcr

## Overview
This script generates X-Fix shear connectors (types C70 or C90) between two collinear CLT/Sip panels. It automatically creates the necessary X-shaped routing, chamfers, and assigns hardware data for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D model manipulation of CLT walls. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: `Sip` (CLT Panels).
- **Minimum Beam Count**: 1 (if splitting) or 2 (if connecting existing).
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsbCLT-X-Fix-Connector.mcr` from the catalog.

### Step 2: Select Panels
The script behaves differently depending on how many panels you select before or during the command:

**Scenario A: Connect two existing panels (Standard Mode)**
1. Select **2** Sip panels that are aligned edge-to-edge.
2. Launch the script.
3. The connectors will be automatically generated along the joint.

**Scenario B: Split and Connect (Split Mode)**
1. Select **1** Sip panel.
2. Launch the script.
3. **Command Line:** `Specify start point of split axis:`
   - Action: Click a point on the panel to define where the split begins.
4. **Command Line:** `Specify end point of split axis:`
   - Action: Click a second point to define the split line.
   - Result: The panel is split into two, and connectors are applied to the new joint.

**Scenario C: Wall Mode**
1. Launch the script without selecting any elements.
2. **Command Line:** `Select Element (Wall):`
   - Action: Click a wall element.
3. **Command Line:** `Specify point on element:`
   - Action: Click a point to define the split location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | Dropdown | X-fix C70 | Selects the connector model (C70 or C90). This determines the routing depth (70mm or 90mm). |
| dOffset1 | Number | 200 | Margin (mm) from the start of the joint edge to the center of the first connector. |
| dOffset2 | Number | 200 | Margin (mm) from the end of the joint edge to the center of the last connector. |
| dInterdist | Number | 1000 | Center-to-center spacing (mm) between connectors. Minimum is 110mm. |
| sAlignment | Dropdown | Reference Side | Determines which face of the panel the connector references. Switching this may flip the routing between the two panels. |
| dChamferRef | Number | 0 | Size (mm) of the 45-degree chamfer on the top/bottom edge of the Reference side panel. |
| dChamferOpp | Number | 0 | Size (mm) of the 45-degree chamfer on the top/bottom edge of the Opposite side panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the connector geometry based on current property values. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal presets (LastInserted) and does not require an external XML settings file.

## Tips
- **Grip Edit**: Drag the grip point (_Pt0) along the wall edge to shift the starting position of the connector distribution.
- **Toggle Alignment**: Double-click the script instance to quickly toggle the alignment between "Reference Side" and "Opposite Side".
- **Short Joints**: If the joint length is too short for the defined offsets and spacing, the script will automatically force a single connector at the midpoint.

## FAQ
- **Q: The script failed when I tried to split a panel. Why?**
  - A: The split line might result in a geometry that cannot be processed, or it was outside the panel bounds. The script will delete itself if the split operation fails.
- **Q: Why did my spacing change to 1000mm automatically?**
  - A: The `dInterdist` value must be greater than 110mm to fit the tool geometry. If you entered a lower value, the script resets it to the default 1000mm.
- **Q: How do I switch the connector to the other panel?**
  - A: Use the `sAlignment` property in the palette or simply double-click the script in the model to toggle the reference side.