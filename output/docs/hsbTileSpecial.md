# hsbTileSpecial.mcr

## Overview
This script allows you to place special roof tiles, such as snow guards, vents, or ridge tiles, onto a selected roof plane. It automatically handles adjacent half-tile geometry and updates the Bill of Materials (BOM) to ensure accurate material counts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates within the 3D model environment. |
| Paper Space | No | Not supported in 2D layout views. |
| Shop Drawing | No | Not intended for generating shop drawings. |

## Prerequisites
- **Required Entities**: An existing Roof Plane (`ERoofPlane`) in the model.
- **Minimum Beam Count**: 0 (This script works on Roof Planes, not beams).
- **Required Settings**:
  - A valid Roof Tile Style must be assigned to the selected Roof Plane.
  - `RoofTilingManager.dll` must be accessible (located in `_kPathHsbInstall\Utilities\RoofTiles\`).
  - The tile database must contain definitions for special tiles matching the roof plane's Manufacturer and Family.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTileSpecial.mcr` from the file list.

### Step 2: Select Roof Plane
```
Command Line: Select Roof Plane
Action: Click on the desired Roof Plane in the model.
```
*Note: The script will verify if the plane has a valid Roof Tile Style assigned. If the style is missing, the script will report an error and exit.*

### Step 3: Select Special Tile Type
```
Dialog: Standard Dialog
Action: Choose the specific tile model (e.g., "Snow Guard", "Vent") from the dropdown list.
```
*Note: The list is automatically filtered to show only tiles compatible with the Manufacturer and Tile Family of the selected roof plane.*

### Step 4: Specify Insertion Point
```
Command Line: Select point
Action: Click on the roof surface to place the selected special tile.
```
*Note: The tile will align to the roof plane's coordinate system and tile grid.*

### Step 5: Continue or Finish
```
Command Line: Select point
Action: 
- To place another tile of the same type: Click a new location.
- To finish: Press **Esc** or **Right-click** to cancel the command.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Special Tile | Dropdown | First available tile | Selects the model of the special tile to place. Changing this selection updates the geometry, dimensions, and Article Number in the BOM. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific custom items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: `RoofTilingManager.dll`
- **Location**: `_kPathHsbInstall\Utilities\RoofTiles\`
- **Purpose**: Provides the database connection and definitions for special tiles, including Name, Article Number, Dimensions, and Tile Type.

## Tips
- **Automatic Half-Tiles**: The script automatically detects if a special tile overlaps a boundary that requires a half-tile. It generates the necessary half-tile geometry automatically.
- **Adjusting Position**: You can drag the special tile using its insertion point grip after placement. If you drag it into a zone that requires a half-tile, the geometry will update automatically.
- **Catalog Integration**: If you execute this script from a Catalog Entry, it skips the dialog step and uses the properties saved in the catalog, allowing for faster placement.

## FAQ
- **Q: The script deleted itself immediately after I selected the roof plane. Why?**
  **A:** This typically means the script could not find valid "Special Tile" definitions in the database for the specific Manufacturer and Family assigned to your roof plane. Check your Roof Tile Style settings and ensure special tiles are defined in the catalog.
- **Q: Does this script remove the standard roof tiles underneath?**
  **A:** Yes, logically. It publishes a "TilesToSubtract" map which informs the main roof tiling calculation (e.g., `hsbTileGrid`) to exclude standard tiles at this location, preventing double-counting in the BOM.