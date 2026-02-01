# Hilti-Decke.mcr

## Overview
Automates the generation of drilling and sawing operations for Hilti fasteners (or wood dowels) in timber floor elements. It calculates positions based on adjacent wall geometry or imported engineering data (`.dxx`) and generates the necessary CNC tooling.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D model elements (Floors/Walls). |
| Paper Space | No | Not designed for 2D drawings or viewports. |
| Shop Drawing | No | Does not generate dimensions or annotations for drawings directly. |

## Prerequisites
- **Required Entities**:
  - A Floor Element (Element or GenBeam).
  - (Optional) A Wall Element to use as a positional reference.
- **Minimum Beam Count**: 0.
- **Required Settings Files**:
  - `HiltiExport.dxx` (Located in the parent folder of the current drawing). This file contains engineering data for fastener positions.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select 'Hilti-Decke.mcr' from the script catalog/dialog.
```

### Step 2: Select Floor Element
```
Command Line: Select Element:
Action: Click on the timber floor element you wish to process.
```

### Step 3: Select Reference Wall
```
Command Line: Select Reference Wall or [All/None]:
Action:
- Click a specific wall to align drills to it.
- Type 'All' to use all walls touching the floor.
- Press Enter to use only imported data (or if no wall is needed).
```

### Step 4: Automatic Processing
The script will automatically import data from `HiltiExport.dxx` (if available and newer), calculate intersection points based on the wall, and generate the tools.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DiameterTop1 | Number | Derived | Sets the bore diameter for Top fasteners (Type 1). |
| DepthTop1 | Number | Derived | Sets the drill depth for Top fasteners. |
| DiameterBottom | Number | Derived | Sets the bore diameter for Bottom fasteners. |
| DepthBottom | Number | Derived | Sets the drill depth for Bottom fasteners. |
| DiameterManual | Number | 12.0 | Diameter used for manually added drill points. |
| DepthManual | Number | 50.0 | Depth used for manually added drill points. |
| ZoneTop | Integer | 1 | CNC Zone assignment for Top side (Positive value). |
| ZoneBottom | Integer | -1 | CNC Zone assignment for Bottom side (Negative value). |
| Wandreferenz | Entity | None | The wall element used to calculate drill positions. Can be set to 'All'. |
| ProjectSpecial | String | (Auto) | Logic flag. If 'baufritz' is detected, switches logic to wood dowels (Holzdolle) and removes saw cuts. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Manual Drill | Prompts you to click a point on the floor to add an extra drill using Manual Diameter/Depth settings. |
| Delete Manual Drill | Prompts you to select an existing drill to remove it from the manual list. |
| Delete all manual drills | Removes all user-added manual drills at once. |
| Recalculate | Updates the tooling based on current wall positions or updated import files. |

## Settings Files
- **Filename**: `HiltiExport.dxx`
- **Location**: Parent folder of the current `.dwg` file.
- **Purpose**: Contains engineering data (Point positions and attributes) imported from external structural calculation software. The script automatically checks this file on insertion to update the internal MapObject.

## Tips
- **Reference Walls**: If you select 'All' for the reference wall, the script will generate drill points everywhere a wall touches the floor contour.
- **Baufritz Projects**: The script automatically detects if the project special string is 'baufritz'. In this mode, saw cuts are replaced with wood dowel drills.
- **Moving Elements**: If you move the floor or the reference wall, use the `Recalculate` option (or grip-edit the floor) to snap the drill holes to the new positions.
- **Data Updates**: To update fastener positions from engineering, replace the `HiltiExport.dxx` file and recalculate the script instance.

## FAQ
- **Q: Why are my drill holes not appearing?**
  - **A**: Check if the calculated points fall within the floor contour (tolerance is 5mm). If using a Reference Wall, ensure the wall actually overlaps or touches the floor correctly in the XY plane. Also, verify the `HiltiExport.dxx` exists if you are relying on import data.
- **Q: What happens if I delete the wall I used as a reference?**
  - **A**: The script will default to 'All' walls or lose the specific reference. It is recommended to re-select a valid wall in the Properties Palette (Wandreferenz) if the original is deleted.
- **Q: Can I mix imported data and wall references?**
  - **A**: Yes. The script combines points found in the `HiltiExport.dxx` file with points calculated from the selected Reference Wall.