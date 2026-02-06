# Simpson-Strong-Tie-GERB.mcr

## Overview
Automatically inserts Simpson Strong-Tie Gerber Hangers (GERB series) to create suspended connections between two timber beams. It manages 3D visualization, applies necessary cuts to the timber, and generates material lists (BOM) for the connector and nails.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Beam or GenBeam.
- **Minimum beam count**: 2 (must be a valid pair of beams).
- **Required settings**: Catalog entries for the script name 'Simpson-Strong-Tie-GERB'.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Simpson-Strong-Tie-GERB.mcr`

### Step 2: Configure Properties (If applicable)
```
Action: If no specific execute key is preset, a dialog box appears.
Action: Select the Connector 'Type' (default is Automatic) and 'Nailing Pattern' in the dialog.
Action: Click OK to proceed.
```

### Step 3: Select Beams
```
Command Line: Select beam(s)
Action: Click on the two beams you wish to connect end-to-end.
Note: The beams must be parallel, aligned on the same axis, and have the same cross-section for the script to detect a valid pair.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | Automatic | Defines the model of the connector (e.g., GERB125, GERB150). 'Automatic' detects the correct size based on beam height. |
| Gap | number | 10 mm | Defines the clearance space between the end of the supported beam and the supporting beam. |
| Nailing Pattern | dropdown | Full Nailing | Defines the nail density. 'Full Nailing' uses maximum nails; 'Part Nailing' uses fewer nails. |
| Nail type | dropdown | CNA4,0x40 | Defines the specific screw product used to attach the hanger (e.g., CNA4,0x50). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap X-(-X) | Toggles the orientation of the connector 180 degrees along the beam axis (mirrors the hanger). This can also be triggered by Double-Clicking the connector. |

## Settings Files
- **Catalog Entries**: Required for 'Simpson-Strong-Tie-GERB'
- **Location**: Company or Install path
- **Purpose**: Provides default configurations and execute keys for the script.

## Tips
- **Automatic Detection**: Use the 'Automatic' Type setting to let the script select the correct hanger size based on your beam height (supports 125, 150, 160, 175, 180, 200, and 220 mm heights).
- **Beam Alignment**: Ensure the two beams are perfectly collinear and parallel; otherwise, the script will not create a connection.
- **Quick Flip**: Double-click the connector in the model to quickly flip its orientation instead of using the right-click menu.

## FAQ
- **Q: Why did the connector not appear after I selected the beams?**
  **A**: The script requires a pair of beams that are parallel, aligned, and have the same cross-section. If the beams are skewed or have different heights, the connection will not be generated.

- **Q: Can I adjust the space between the beams after insertion?**
  **A**: Yes. Select the connector, open the Properties palette (Ctrl+1), and change the 'Gap' value.

- **Q: What happens if my beam height doesn't match a standard GERB size?**
  **A**: If 'Type' is set to 'Automatic' and no match is found, the tool will report "Invalid geometry" and delete itself. You must manually select a specific 'Type' that fits your construction context.