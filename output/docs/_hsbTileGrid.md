# _hsbTileGrid.mcr

## Overview
This script calculates and visualizes the optimal layout grid for roof tiles on a selected roof plane. It handles horizontal and vertical distribution to ensure accurate coverage, batten positioning, and material take-off.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Not intended for shop drawing views. |

## Prerequisites
- **Required Entities**: A valid Roofplane (Element) with defined Eaves and Ridge edges.
- **Minimum Beam Count**: N/A (Single element selection).
- **Required Settings**: 
  - `RoofTilingManager.dll` must be installed in the hsbCAD path.
  - Tile definitions must exist in the database.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `_hsbTileGrid.mcr` from the file dialog.

### Step 2: Select Roofplane
```
Command Line: Select a roofplane
Action: Click on the desired Roofplane element in the 3D model.
```

### Step 3: Configure Tile Layout
Once the script attaches to the roofplane, it generates a default grid. To customize:
1. Select the inserted script instance.
2. Open the **Properties Palette** (Ctrl+1).
3. Change the `sFamilyName` to load specific tile dimensions.
4. Adjust `dOverhang` or `nMode` as needed.

### Step 4: Adjust Visualization
- **Double-click** the script instance to cycle through display modes (Show All → Dimensions Only → Grid Only).
- **Drag** the visible grip point (usually labeled `_PtG`) to move the reference point for dimensions.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFamilyName | String | "" | Select the specific tile manufacturer and model (e.g., "Braas Classic"). This determines the grid spacing. |
| nMode | Index | 1 | **1**: Horizontal distribution (across slope). <br> **2**: Vertical distribution (down slope). |
| dOverhang | Length | 0 | The distance the roof structure extends beyond the external wall. Offsets the grid start. |
| sDimStyle | String | "AR" | The dimension style name to be used for generated dimensions (Arrow style, text height, etc.). |
| nDisplayContent | Index | 0 | **0**: Show All (Grid + Dimensions). <br> **1**: Show Dimensions Only. <br> **2**: Show Grid Only. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Save defaults | Saves the current property configuration (Tile Family, Overhang, etc.) as the new default for future insertions. |

## Settings Files
- **Filename**: `RoofTilingManager.dll`
- **Location`: `_kPathHsbInstall` (hsbCAD installation directory)
- **Purpose**: Contains the database of tile families, including physical dimensions (Length/Width) and batten requirements used to calculate the grid.

## Tips
- **Toggle Views Quickly**: If the drawing becomes too cluttered, double-click the script to hide the grid lines and show only dimensions.
- **Check Orientation**: If your tiles are running the wrong way, change the `nMode` property between Horizontal (1) and Vertical (2).
- **Moving Dimensions**: Use the grip point to slide the dimension lines away from the roof edge for better visibility in crowded plans.

## FAQ
- Q: Why does the grid not appear after I change the tile family?
  A: Ensure the `nDisplayContent` is set to `0` (All) or `2` (Grid Only). Also verify that the `sFamilyName` exactly matches a name in the RoofTilingManager database.
- Q: How do I account for fascia boards?
  A: Use the `dOverhang` property to shift the start of the grid outward from the roof plane's theoretical edge.
- Q: What happens if I select an invalid element?
  A: The script will prompt you to "Select a roofplane" again. Ensure you select a valid planar Roof element with area.