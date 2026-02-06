# Simpson-Strong-Tie-GERW.mcr

## Overview
This script automates the placement of Simpson Strong-Tie Gerber connectors (GERW series) between selected timber beams. It detects valid connections, splits beams if necessary to accommodate the connection, and generates the appropriate 3D geometry and hardware data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beam entities. |
| Paper Space | No | Not designed for 2D detailing views. |
| Shop Drawing | No | Logic is strictly for model generation. |

## Prerequisites
- **Required entities**: Timber Beams (Element or GenBeam).
- **Minimum beam count**: At least 1 beam (though connections require pairs, the script handles selection of multiple beams to find valid pairs).
- **Required settings**: hsbCAD environment with timber beams loaded.

## Usage Steps

### Step 1: Launch Script
Execute the script using the `TSLINSERT` command in AutoCAD and select `Simpson-Strong-Tie-GERW.mcr` from the list.

### Step 2: Select Beams
```
Command Line: Select beam(s)
Action: Click to select the beams where you want to place Gerber connections. You can select multiple beams at once.
```

### Step 3: Configure Connection
After selection, the script will analyze the geometry.
- If the beams form valid intersections/end-points, connectors will be placed automatically.
- If the beams do not naturally meet connection criteria, you may be prompted to click a point to split the beam plane to facilitate placement.
- Adjust parameters in the **Properties Palette** if the automatic settings are not suitable.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | Automatic | Selects the specific connector model (GERW90 to GERW420). "Automatic" picks the best fit based on geometry. |
| Gap | number | 10 | Defines the gap distance for the connection. (Automatic mode uses a recommended 20mm gap). |
| Nailing Pattern | dropdown | - | Choose between "Full Nailing" or "Part Nailing". |
| Nail type | dropdown | - | Select the nail specification (e.g., CNA4,0x40). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Z-(-Z) | Mirrors the connector geometry across the ZC plane (toggles the orientation). |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on internal catalog data for connector dimensions rather than external XML settings files.

## Tips
- **Automatic Mode**: Use the "Automatic" type setting to let the script select the correct connector size based on the beam geometry. It calculates a recommended gap of 20mm.
- **Quick Swap**: You can double-click the generated connector instance to trigger the "Swap Z-(-Z)" command to flip its orientation quickly.
- **Batch Processing**: You can select a large group of beams; the script will iterate through them and create a connection instance for every valid pair found.

## FAQ
- **Q: Why did the script ask me to click a point?**
  **A**: The beams you selected may not have a valid intersection for the connector. The script allows you to define a split point on the beam to create a valid surface for placing the Gerber connection.
  
- **Q: Can I change the connector size after insertion?**
  **A**: Yes. Select the generated TSL instance and change the "Type" property in the Properties Palette to any specific GERW model (e.g., GERW200).