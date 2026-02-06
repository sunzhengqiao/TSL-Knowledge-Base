# hsbTileVerge.mcr

## Overview
This script calculates, visualizes, and generates hardware items for verge tiles (gable end tiles) on a specific roof plane. It automatically handles complex configurations like half-tiles and ridge connections based on the assigned roof tile style.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to an ERoofPlane in the model. |
| Paper Space | No | Not designed for Paper Space or viewports. |
| Shop Drawing | No | This is a model generation script, not a detailing tool. |

## Prerequisites
- **Required Entities**: An existing `ERoofPlane` (Roof Plane) in the drawing.
- **Minimum Beam Count**: 0 (This script attaches to planes/elements, not beams).
- **Required Settings**:
  - A valid Roof Tile Style must be assigned to the Roof Plane.
  - The `hsbTileGrid` script must already be attached and executed on the Roof Plane to generate the necessary tile export data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `_TSLINSERT`)
Action: Browse the file list and select `hsbTileVerge.mcr`.

### Step 2: Select Roof Plane
```
Command Line: Select roofplane
Action: Click on the desired Roof Plane entity in the drawing that you wish to generate verge tiles for.
```

### Step 3: Automatic Execution
Action: The script automatically attaches to the roof plane, calculates the verge geometry, and generates the tile representations and hardware list.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| ncVerge | Integer | 112 (Blue) | Determines the display color of the standard verge tiles in the 3D model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu options are provided by this script. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on data maps (`Hsb_RoofTile`, `Hsb_TileExportData`) generated directly on the Roof Plane entity by the hsbTileGrid script, rather than external XML settings files.

## Tips
- **Run Order**: Always ensure `hsbTileGrid` is run before this script. If the verge tiles do not appear, check if `hsbTileGrid` is successfully generating tiles on the main roof area.
- **Half-Tiles**: The script automatically calculates and inserts half-tiles if the geometry requires them, and it prevents overlap with special tiles (like vents or windows).
- **Ridge Connections**: If the verge meets a ridge, the script will identify the correct connector hardware automatically.
- **Overlaps**: If you see a warning "Vergetiles overlap", try adjusting your roof tile style settings (tile width/overlap) or modify the roof geometry slightly.

## FAQ
- **Q: Why did the script disappear immediately after I selected the roof plane?**
  - **A:** This usually happens if the Roof Plane does not have a valid Tile Style assigned, or if `hsbTileGrid` has not been run yet (missing export data). It may also happen if the script is already attached to that roof plane.
- **Q: Can I use this on multiple roof planes at once?**
  - **A:** Yes, you can select multiple roof planes during the `Select roofplane` prompt, and the script will attach an instance to each one.
- **Q: Do I need to count the tiles manually for reports?**
  - **A:** No, the script generates hardware list items (HardWrComp) automatically, which will appear in your material lists and reports.