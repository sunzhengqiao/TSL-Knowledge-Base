# hsbTileSpecial

## Overview

**hsbTileSpecial** is a specialized tool for placing special roof tiles (such as snow guards, ventilation tiles, and accessory tiles) on a roof plane that already has a roof tile style assigned. The script automatically handles half-tile placement when needed, maintains proper tile distribution, and tracks hardware components for material takeoff.

Special tiles are inserted at specific positions within the existing tile grid and automatically adjust to the tile family configuration. The script supports staggered tile distributions and integrates with other roof tile scripts such as `hsbTileGrid`, `hsbTileVerge`, and `hsbTileHipRidge`.

**Version:** 3.4
**Type:** O-Type (Object)
**Script Category:** Roofing

---

## Environment

| Attribute | Value |
|-----------|-------|
| Space | Model Space |
| Script Type | O-Type (Object-based) |
| Beams Required | 0 |
| Associated Entity | ERoofPlane (Roof Plane) |

---

## Prerequisites

Before using this tool, ensure the following:

1. **Roof Plane with Tile Style**: The target roof plane must have a valid roof tile style assigned (via hsbCAD Roof Tile Manager)
2. **Tile Family Definition**: The assigned tile family must include special tile definitions in the database
3. **Horizontal Tile Grid**: For proper positioning, the `hsbTileGridHorizontal` script should be applied to the roof plane first
4. **RoofTilingManager.dll**: The script requires the hsbCAD roof tiling utilities located at `_kPathHsbInstall\Utilities\RoofTiles\`

---

## Usage

### Step-by-Step Workflow

1. **Start the Tool**: Launch the `hsbTileSpecial` command from the hsbCAD tools or use `TSLINSERT` and select `hsbTileSpecial.mcr`
2. **Select Roof Plane**: Click on the roof plane where you want to place special tiles
3. **Choose Special Tile Type**: A dialog appears with all available special tiles from the tile family (sorted alphabetically)
4. **Select Insertion Points**: Click on the roof plane to place special tiles at desired locations. The script places tiles at valid grid positions only
5. **Repeat or Finish**: Continue clicking to place additional tiles, or press Enter/Escape to finish

### Placement Rules

- Special tiles align to the existing tile grid (horizontal and vertical distribution)
- The script prevents placement at invalid locations (e.g., at verges where verge tiles exist)
- Half tiles are automatically added when a half-width special tile is placed in a full column, or vice versa
- Multiple special tiles in the same row can interact to fill gaps with standard tiles

---

## Parameters

### OPM Properties (Properties Palette)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Special Tile | Dropdown | First available tile | The model/name of the selected special tile from the tile family catalog. The available options are populated from the roof tile database based on the assigned tile style. Changing this selection updates the geometry, dimensions, and Article Number in the BOM |

The dropdown category is dynamically set to the tile family name (e.g., "Braas Rubin 13V", "Creaton Domino").

---

## Context Menu

Right-click on a placed special tile instance to access these options:

| Menu Item | Action |
|-----------|--------|
| **React on other Special tiles / Don't react on other Special tiles** | Toggle whether this tile interacts with adjacent special tiles in the same row to automatically fill gaps with standard tiles |
| **Add half tile / Don't add half tile** | Toggle automatic placement of half tiles next to the special tile when needed for proper grid alignment |

---

## Display

The script uses color-coded visualization:

| Color Code | Element |
|------------|---------|
| **12 (Cyan)** | Special tile outline (80% transparency) |
| **44 (Light Blue)** | Half tile outline (50% transparency) |
| **252 (Gray)** | Standard tile fill (between special tiles) |
| **7 (White)** | Tile name text label |
| **181 (Yellow/Green)** | Invalid location indicator |

When a tile is placed at an invalid location, the display shows "Invalid location" text with a distinctive color.

---

## Hardware Components

The script automatically creates hardware components for material takeoff:

### Special Tile Component
- **Article Number**: From tile database
- **Manufacturer**: From tile family definition
- **Model**: Tile family name
- **Name**: Special tile name
- **Material**: Surface + Color characteristics
- **Category**: "Rooftiles"
- **Dimensions**: Length, Width from database
- **Angle**: Roof pitch

### Half Tile Component (if applicable)
When half tiles are added, a separate hardware component is created with the half tile specifications.

The script also publishes a "TilesToSubtract" map which informs the main roof tiling calculation (e.g., `hsbTileGrid`) to exclude standard tiles at this location, preventing double-counting in the BOM.

---

## Dependencies

The script establishes dependencies with:

| Entity | Purpose |
|--------|---------|
| **ERoofPlane** | Parent roof plane - updates trigger recalculation |
| **hsbTileGridHorizontal** | Horizontal grid reference for positioning |
| **Other hsbTileSpecial instances** | Collision detection and gap filling |
| **hsbTileVerge** | Half tile coordination at verges |
| **hsbTileHipRidge** | Half tile coordination at ridges |

---

## Tips

1. **Tile Family Setup**: Ensure your tile family includes all required special tile types before using this tool. Special tiles are defined per manufacturer/family in the Roof Tile Manager

2. **Grid Alignment**: For best results, apply `hsbTileGridHorizontal` to the roof plane first. This ensures special tiles align correctly with the standard tile pattern

3. **Staggered Distribution**: The script respects the tile family's staggered distribution settings (bond pattern). Half tiles are automatically placed to maintain the correct pattern

4. **Moving Tiles**: You can drag special tiles to new positions after placement using the insertion point grip. The script validates the new location and reverts if invalid

5. **Row Interaction**: Enable "React on other Special tiles" (via context menu) when you have multiple special tiles in the same row and want automatic gap filling

6. **Quantity Tracking**: The script tracks tiles to subtract from the main grid count, ensuring accurate material quantities

7. **Invalid Positions**: If you see "Invalid location" displayed, the tile type doesn't match the column width (e.g., half tile in half column or full tile in half column for non-staggered families)

8. **Catalog Integration**: If you execute this script from a Catalog Entry, it skips the dialog step and uses the properties saved in the catalog, allowing for faster placement

---

## FAQ

**Q: The script deleted itself immediately after I selected the roof plane. Why?**
A: This typically means the script could not find valid "Special Tile" definitions in the database for the specific Manufacturer and Family assigned to your roof plane. Check your Roof Tile Style settings and ensure special tiles are defined in the catalog.

**Q: Does this script remove the standard roof tiles underneath?**
A: Yes, logically. It publishes a "TilesToSubtract" map which informs the main roof tiling calculation (e.g., `hsbTileGrid`) to exclude standard tiles at this location, preventing double-counting in the BOM.

**Q: What special tile types are supported?**
A: The script supports tile types with indices 0 (Standard), 7 (Half), and 15-22, 90 (various special types such as snow guards, vents, etc.). The available types depend on your tile family database.

---

## Related Scripts

- `hsbTileGrid` / `hsbTileGridHorizontal` - Horizontal tile distribution grid
- `hsbTileGridVertical` - Vertical tile distribution (batten layout)
- `hsbTileVerge` - Verge tile placement
- `hsbTileHipRidge` - Hip and ridge tile placement
- `hsbTileEave` - Eave tile placement

---

## Settings Files

| Filename | Location | Purpose |
|----------|----------|---------|
| RoofTilingManager.dll | `_kPathHsbInstall\Utilities\RoofTiles\` | Provides the database connection and definitions for special tiles, including Name, Article Number, Dimensions, and Tile Type |
