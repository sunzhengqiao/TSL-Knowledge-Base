# hsbWall2RoofFixing.mcr

## Overview
This script automates the calculation of nailing positions and generates CNC data for connecting stick frame walls to floor or ceiling elements. It supports various distribution modes (continuous or separate) and allows flexible configuration of nail directions and spacing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in 3D model environment to detect walls and floors. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a model/CNC generation script. |

## Prerequisites
- **Required Entities**: At least one Stick Frame Wall (`ElementWallSF`) and one Roof element (specifically a Floor or Ceiling).
- **Minimum Beam Count**: 0 (Operates on Elements).
- **Required Settings**: None specific (uses standard catalogs for nail indices).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbWall2RoofFixing.mcr` from the list.

### Step 2: Select Elements
```
Command Line: Select stick frame wall(s) and roof(s) elements
Action: Click on the Wall element and the Floor/Ceiling element, then press Enter.
```

### Step 3: Configure Properties
```
Action: The Properties Palette (OPM) opens automatically. Adjust parameters such as Nail Index, Distribution Mode, and Distances. 
Note: The script will automatically calculate nail positions and generate visual markers/CNC data once properties are applied.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nail Index | number | 0 | Selects the specific nail gun tooling index (nail type/size) from the CNC machine's configuration. |
| Direction | dropdown | Wall-Floor/Ceiling | Defines the shooting direction. Choose if the nail shoots from the Wall into the Floor, or vice versa. |
| Distribution Areas | dropdown | Continuous | Determines how openings (windows/doors) affect the pattern. "Continuous" spans the whole length; "Separately" treats solid wall sections individually. |
| Mode | dropdown | Even | Sets the calculation rule. "Even" adjusts spacing for uniformity; "Fixed" uses a strict user-defined distance. |
| Distance Bottom/Start | number | 0 | The edge distance (margin) from the start of the wall/segment to the center of the first nail. |
| Distance Top/End | number | 0 | The edge distance (margin) from the end of the wall/segment to the center of the last nail. |
| Max. Distance between | number | 10 | Target spacing between nails. In "Even" mode this is a maximum; in "Fixed" mode it is exact. |
| Distance between calculated | number | 0 | (Read-only) The exact distance calculated by the script in "Even" mode. |
| Nr. | number | 0 | (Read-only) The total number of nails generated. |
| Distace Stud | number | 0 | Defines an offset distance applied relative to the position of wall studs. |
| Distance Tooling | number | 0 | Defines an offset distance for the tooling machinery setup. |
| Type | dropdown | Floor | Defines the connection type, either "Floor" or "Ceiling". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Direction | Toggles the nailing direction between Wall-Floor/Ceiling and Floor/Ceiling-Wall. Also updates which element hosts the CNC data. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD catalogs for Nail Index definitions rather than a specific XML settings file.

## Tips
- **Element Attachment**: Instead of manual insertion, this TSL can be attached directly to a Wall Element in the catalog. When attached, it automatically detects adjacent floors without needing manual selection.
- **Visual Feedback**: The script draws circles and lines to indicate where nails will be placed.
- **Quick Swap**: You can double-click the script instance in the model to quickly trigger the "Swap Direction" function.

## FAQ
- **Q: What happens if I have a window in the wall?**
  - **A**: If the **Distribution Areas** property is set to "Separately", the script will calculate nail patterns for the wall sections on either side of the window individually. If set to "Continuous", it calculates based on the total length.
- **Q: How do I ensure my nails hit the studs?**
  - **A**: Use the **Distace Stud** property to apply an offset relative to the stud positions detected by the script.
- **Q: Can I use this for ceilings?**
  - **A**: Yes, ensure the **Type** property is set to "Ceiling" and that you select a Ceiling element (Roof element type) during insertion.