# hsbTileHipRidge.mcr

## Overview
This script automates the calculation and Bill of Materials (BOM) generation for ridge and hip roof tiles. It places visual representations of the tiles in the model, handles specialized start/end caps, and accounts for roof intersections and offsets.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment. Select roof planes here. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: At least two `ERoofPlane` entities that intersect to form a ridge or hip line.
- **Minimum Beam Count**: 0 (This script operates on Roof Planes, not beams).
- **Required Settings**:
  - Roof Planes must have a valid **Roof Tile Style** assigned (containing `Hsb_RoofTile` and `RoofFamilyDefinition` submaps).
  - `RoofTilingManager.dll` must be available in the hsbCAD install path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTileHipRidge.mcr` from the list.

### Step 2: Select Roof Planes
```
Command Line: Select roofplane(s)
Action: Click on the roof planes that form the ridge or hip you wish to tile. You must select at least two intersecting planes. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Ridge/Hip Tile | dropdown | No Tile | Select the catalog tile for the main run. Select "ByRoofplane" to use the tile defined in the roof plane properties. |
| **Geometrie** | | | |
| Z-Offset ridge | number | 80 | The vertical height (Z-axis) to raise ridge tiles above the roof plane surface. |
| Z-Offset hip | number | 130 | The vertical height (Z-axis) to raise hip tiles above the roof plane surface. |
| Offset direction | dropdown | Parallel to edge | Defines how start/end offsets are measured. "Parallel to edge" measures along the ridge line; "Parallel to roofplane" projects onto the roof surface. |
| **Start Tile** | | | |
| Start Tile | dropdown | No Tile | Specifies the specialized tile (e.g., starter cap) to place at the beginning of the run. |
| Offset | number | 0 | The distance from the start of the roof geometry to where tiling actually begins. |
| **End Tile** | | | |
| End Tile | dropdown | No Tile | Specifies the specialized tile (e.g., end cap) to place at the end of the run. |
| Offset | number | 0 | The distance from the end of the roof geometry to where tiling actually ends. |
| **Replace tile** | | | |
| Replace Start/ End Tile | dropdown | Don´t replace | Enables custom end configurations. Select "Start Tile" or "End Tile" to override standard settings with the specific tiles below. |
| 1st Start/ End Tile | dropdown | No Tile | The primary replacement tile to use when the "Replace" option is active. |
| 2nd Start/ End Tile | dropdown | No Tile | An optional secondary replacement tile placed adjacent to the first replacement tile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Double Click | Recalculates the tile layout and BOM. Use this after changing roof geometry or modifying properties. |

## Settings Files
- **Filename**: `RoofTilingManager.dll`
- **Location**: `_kPathHsbInstall\Utilities\RoofTiles\`
- **Purpose**: Retrieves tile definitions (dimensions, article numbers, material) from the tile database catalog.

## Tips
- **Missing Data Error**: If the script disappears immediately after insertion, check that your Roof Planes have a valid "Roof Tile Style" assigned in their properties.
- **Visual Adjustments**: If the tiles look like they are floating or sinking into the roof, adjust the "Z-Offset ridge" or "Z-Offset hip" values.
- **Complex Ends**: If you need a specific arrangement of tiles at the ridge ends (e.g., for ventilation), use the "Replace Start/ End Tile" option combined with the "1st" and "2nd" tile fields to stack multiple custom pieces.
- **ByRoofplane**: Use the "ByRoofplane" setting for the main tile to ensure the script automatically updates if you change the global roof material assignment.

## FAQ
- **Q: Why does the script say "could not evaluate any tiles"?**
  **A**: This usually means the selected roof planes do not intersect to form a ridge or hip, or the calculated offsets are larger than the available length.
- **Q: What is the difference between "Parallel to edge" and "Parallel to roofplane" offset?**
  **A**: "Parallel to edge" measures the offset in a straight line along the ridge. "Parallel to roofplane" projects the measurement onto the sloped roof surface, which results in a longer horizontal distance for steep roofs.
- **Q: Can I use this for valley tiles?**
  **A**: No, this script is specifically designed for Ridges (the top peak) and Hips (the sloped intersection between roof sections).