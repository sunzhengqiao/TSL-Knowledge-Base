# hsbTileVerge.mcr

## Overview

This script calculates, visualizes, and generates hardware items for verge tiles (gable end tiles) on a specific roof plane. It automatically handles complex configurations like half-tiles and ridge connections based on the assigned roof tile style.

The script is part of the hsbCAD roof tiling system and works in conjunction with **hsbTileGrid** (which must be attached first) to provide complete roof tile coverage.

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Version | 2.7 |
| Requires Beams | No |
| Requires hsbTileGrid | Yes |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to an ERoofPlane in the model |
| Paper Space | No | Not designed for Paper Space or viewports |
| Shop Drawing | No | This is a model generation script, not a detailing tool |

## Prerequisites

Before using hsbTileVerge, ensure:

1. **Roof Plane Exists**: You have a valid roof plane (ERoofPlane) in your drawing.
2. **Tile Style Assigned**: The roof plane has a valid roof tile style/family assigned.
3. **hsbTileGrid Attached**: The hsbTileGrid script must already be attached and executed on the roof plane to generate tile export data.
4. **Vertical Tiling in Range**: The vertical tile distribution must be within valid parameters.

## Usage Steps

### Step 1: Launch Script

Command: `TSLINSERT` (or `_TSLINSERT`)

Action: Browse the file list and select `hsbTileVerge.mcr`.

### Step 2: Select Roof Plane

```
Command Line: Select roofplane
Action: Click on the desired Roof Plane entity in the drawing that you wish to generate verge tiles for.
```

You can select multiple roof planes during this prompt. The script creates one instance per roof plane.

### Step 3: Automatic Execution

The script automatically:
- Attaches to each selected roof plane
- Calculates verge geometry for all verge edges (left, right, and openings)
- Generates tile visual representations
- Creates hardware list entries for bill of materials

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| ncVerge | Integer | 112 (Blue) | Determines the display color of the standard verge tiles in the 3D model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Change verge** | Enable interactive mode to adjust verge tile positions using grip points. |
| **Reset verge** | (Appears when in edit mode) Disable grip point editing and reset to automatic calculation. |
| **Fill up with half tiles** | Allow the script to automatically add half tiles to complete staggered distributions. |
| **Don't fill up with half tiles** | Prevent half tiles from being added, using only full verge tiles. |

## Output and Hardware

### Hardware Components

The script automatically generates hardware components for bill of materials export:

| Hardware Property | Value |
|-------------------|-------|
| Category | Rooftiles |
| Manufacturer | From tile family manufacturer data |
| Model | Family name |
| Name | Tile name from definition |
| Material | Surface + Colour from tile characteristics |
| Notes | Roof number |
| Article Number | From tile definition |
| Dimensions | Length x Width from tile data |
| Angle A | Roof pitch in degrees |

### Data Export

The script stores verge edge data in the roof plane's SubMapX under `hsb_TileExportData`:

- `VergeEdgeData`: Parent TSL reference and verge top positions for coordination
- `ppPositioning`: Plane profile showing areas available for special tile positioning
- `ppHalfs`: Plane profile of half tiles (when used)
- `TilesToSubtract`: Count of full tiles to subtract from hsbTileGrid totals

## Tips

1. **Run Order**: Always ensure `hsbTileGrid` is run before this script. If verge tiles do not appear, check if `hsbTileGrid` is successfully generating tiles on the main roof area.

2. **Half-Tiles**: The script automatically calculates and inserts half-tiles if the geometry requires them, and it prevents overlap with special tiles (like vents or windows).

3. **Ridge Connections**: If the verge meets a ridge, the script will identify the correct connector hardware automatically.

4. **Overlaps**: If you see a warning "Vergetiles overlap", try adjusting your roof tile style settings (tile width/overlap) or modify the roof geometry slightly.

5. **One Instance Per Roof**: The script prevents duplicate instances on the same roof plane. If an instance already exists, the new one is erased with a notification message.

6. **Opening Edges**: Verge tiles are also calculated for roof openings (dormers, skylights) that create left or right edges within the roof plane.

7. **Unit Safety**: The script uses `U()` for all dimensions, ensuring correct behavior in both metric and imperial drawings.

## FAQ

**Q: Why did the script disappear immediately after I selected the roof plane?**

A: This usually happens if:
- The Roof Plane does not have a valid Tile Style assigned
- hsbTileGrid has not been run yet (missing export data)
- No verge tiles in the tile family match the distribution range
- The script is already attached to that roof plane

**Q: Can I use this on multiple roof planes at once?**

A: Yes, you can select multiple roof planes during the "Select roofplane" prompt, and the script will attach an instance to each one.

**Q: Do I need to count the tiles manually for reports?**

A: No, the script generates hardware list items (HardWrComp) automatically, which will appear in your material lists and reports.

## Related Scripts

- **hsbTileGrid**: Must be attached first to provide vertical tile distribution
- **hsbTileSpecial**: Handles special tiles (vents, skylights) - checked for conflicts with half-tiles
- **hsbTileRidge**: Provides ridge connection data that affects top verge tile placement
- **hsbTileEave**: Manages eave tile placement

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 2.7 | Jul 2023 | HSB-19266: Use ridge connection tile map to detect last verge |
| 2.6 | Nov 2022 | HSB-16994: Bugfix first verge tile not shown; Added half tile functionality |
| 2.5 | Nov 2022 | HSB-16994: Test to avoid error message |
| 2.4 | Jul 2019 | HSB-12044: Bugfix amount of verge tiles when distribution is not done from lowest eave |
| 2.3 | Jul 2019 | Bugfix for drawing in meter |
| 2.2 | May 2019 | Added surface to the colour |
| 2.1 | Apr 2019 | Adjust quantity of tiles |
| 2.0 | Apr 2019 | Elementary changes in behavior; Initial version for release V22 |
| 1.3 | Oct 2018 | Inbox-694: Add pitch and roof number |
| 1.2 | Jul 2018 | RS-142: Eave verge tile added |
| 1.1 | Jul 2018 | RS-126: Tile export supported as hardware for verge tiles |
| 1.0 | Jun 2018 | Initial version |