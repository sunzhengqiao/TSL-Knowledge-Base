# hsbTileHipRidge

## Overview

The **hsbTileHipRidge** script creates hip and ridge tile instances along the junction lines of adjacent roof planes. It automatically calculates tile quantities, distributes ridge/hip tiles along the edge, and generates optional start and end tiles. The script also handles pent (shed) roof configurations and ridge-verge connection tiles.

This tool is essential for completing roof tile layouts by covering the intersections between roof planes with appropriate ridge or hip capping tiles.

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Environment | Model Space |
| Version | 2.7 |
| Requires Beams | No |

## Prerequisites

- At least two roof planes must be selected to create standard hip/ridge tiles
- Single roof plane supported only for pent/shed roof configurations with appropriate tile definitions
- Selected roof planes must have a valid roof tile style (family) assigned via the Roof Tiling Manager
- The tile family must include ridge/hip tile definitions in the database
- `RoofTilingManager.dll` must be available in the hsbCAD installation path

## Usage

### Basic Workflow

1. Run the script using `TSLINSERT` command and select `hsbTileHipRidge.mcr`
2. When prompted "Select roofplane(s)", click on two or more roof planes that share a hip or ridge edge
3. Press Enter to confirm the selection
4. The script displays a dialog for tile selection (if catalog entries are available)
5. Configure tile options in the Properties Palette as needed
6. The script automatically calculates and displays tiles along all shared edges

### Multi-Roof Selection

When selecting more than two roof planes, the script automatically:
- Identifies all hip and ridge edges between the selected planes
- Creates separate instances for each edge pair
- Prevents duplicate instances on the same roof plane pair

### Direction Control

For ridge lines (horizontal edges), use the right-click context menu option **Flip Direction** to reverse the tile layout direction if needed.

## Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Ridge/Hip Tile | Dropdown | ByRoofplane | Main tile type for the ridge/hip line. Options include "No Tile", "ByRoofplane" (uses roof plane definition), or specific tile from the family catalog |

### Start Tile Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Start Tile | Dropdown | No Tile | Special tile at the beginning of the ridge/hip line |
| Offset | Length | 0 mm | Distance to offset the start position of tiles from the edge beginning |

### End Tile Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| End Tile | Dropdown | No Tile | Special tile at the end of the ridge/hip line |
| Offset | Length | 0 mm | Distance to offset the end position of tiles from the edge end |

### Replace Tile Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Replace Start/End Tile | Dropdown | Don't replace | Option to replace start or end tiles with alternative tiles |
| 1st Start/End Tile | Dropdown | No Tile | First replacement tile when using replace option |
| 2nd Start/End Tile | Dropdown | No Tile | Second replacement tile (allows double tile at start/end) |

### Geometry Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset direction | Dropdown | Parallel to edge | Direction for Z-offset calculation: "Parallel to edge" or "Parallel to roofplane" |
| Z-Offset ridge | Length | 80 mm | Vertical offset above the roof surface for ridge tiles |
| Z-Offset hip | Length | 130 mm | Vertical offset above the roof surface for hip tiles |

## Context Menu

Right-click on the instance to access:

| Menu Option | Action |
|-------------|--------|
| Flip Direction | Reverses the tile layout direction (ridge lines only) |

## Settings Files

- **Filename**: `RoofTilingManager.dll`
- **Location**: `[Install Path]\Utilities\RoofTiles\`
- **Purpose**: Retrieves tile definitions (dimensions, article numbers, material) from the tile database catalog

## Output

The script generates:

1. **Visual Display**: Colored tile representations on the roof planes showing:
   - Ridge/hip tiles (color 134 for ridge, 154 for hip)
   - Start tiles (color 44)
   - End tiles (color 244)
   - Ridge connection tiles (color 62)

2. **Hardware Components**: Each tile type is registered as a hardware component with:
   - Article number from the tile database
   - Manufacturer and family information
   - Quantity count
   - Dimensions (length, width)
   - Linked to the roof plane group

3. **Export Data**: Offset values are exported to linked roof planes for use by the hsbTileLath script

## Tips

1. **Tile Selection**: Use "ByRoofplane" to automatically pick up ridge tile settings defined on the roof plane's tile style. Select a specific tile name to override this setting.

2. **Hip vs Ridge Detection**: The script automatically distinguishes between:
   - **Ridge**: Horizontal edge (perpendicular to world Z)
   - **Hip**: Sloped edge pointing toward the ridge

3. **Offset Tuning**: Adjust Z-Offset values to position tiles correctly above the roof covering. Hip tiles typically need larger offsets than ridge tiles due to the intersection angle.

4. **Verge Connections**: When adjacent verge tiles exist on the roof planes, the script can automatically create ridge-verge connector tiles to properly join the two systems.

5. **Quantity Calculation**: Tile quantities are computed based on the tile's horizontal spacing (minimum/maximum) from the database. The script distributes tiles evenly along the edge length.

6. **Staggered Distribution**: For roof families with staggered tile patterns, the script accounts for the half-tile offset when calculating connection tile positions.

7. **Hardware Export**: All tile quantities appear in the hardware list for material takeoffs and ordering. Tiles are categorized under "Rooftiles" and linked to the appropriate roof plane group.

8. **Complex Ends**: If you need a specific arrangement of tiles at the ridge ends (e.g., for ventilation), use the "Replace Start/End Tile" option combined with the "1st" and "2nd" tile fields to stack multiple custom pieces.

## FAQ

- **Q: Why does the script delete itself immediately after insertion?**
  **A**: This usually means the selected roof planes do not have a valid Roof Tile Style assigned. Check that your roof planes have the tile family data properly configured.

- **Q: What is the message "could not evaluate any tiles"?**
  **A**: This indicates the selected roof planes do not intersect to form a valid ridge or hip, or the calculated offsets are larger than the available edge length.

- **Q: What is the difference between "Parallel to edge" and "Parallel to roofplane" offset?**
  **A**: "Parallel to edge" measures the offset along the ridge/hip line itself. "Parallel to roofplane" projects the measurement onto the sloped roof surface, which results in different positioning for steep roofs.

- **Q: Can I use this for valley tiles?**
  **A**: No, this script is specifically designed for ridges (the top peak) and hips (the sloped intersection between roof sections). Valley tiles require a different approach.

- **Q: Why are hip end tiles automatically set to "No Tile"?**
  **A**: Hip lines typically run to a point where they meet other edges, so end tiles are generally not needed. The script automatically disables end tiles for hip configurations.
