# hsb_CleanupStudInDynamicConnection.mcr

## Overview
Automatically adjusts studs and plates in a primary wall ("Male" wall) to create space for cladding materials on a connecting wall ("Female" wall), ensuring clean structural intersections at corners without manual editing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model context. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D output directly. |

## Prerequisites
- **Required Entities:** `ElementWallSF` (Standard hsbCAD Wall elements).
- **Minimum Beam Count:** 0 (Logic checks for beams automatically).
- **Required Settings:** None required for execution.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_CleanupStudInDynamicConnection.mcr`

### Step 2: Select Walls
```
Command Line: 
Select a set of elements
```
**Action:** Click on the wall elements you wish to process (the "Male" walls). Press **Enter** to confirm selection.

**Note:** The script will attach itself to the selected walls, process connections, and then automatically erase itself once complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Male Wall Code | text | A;B;C; | Determines which walls are modified. Only walls with a Code listed here will be processed. Separate codes with semicolons. |
| Female Wall Code | text | A;B;C; | Determines which connected walls are checked for obstructions. Only intersecting walls with a Code listed here are considered. |
| Sheet Material | text | Plasterboard | The name of the material found in the Female wall's zones that defines the interference depth (e.g., "Plasterboard", "OSB"). |
| Extra Gap | number | 0 | Additional clearance distance added to the material thickness to ensure a gap exists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on OPM (Properties Palette) inputs.

## Tips
- **Semicolon Separators:** When entering multiple wall codes or materials (e.g., "INT;EXT;"), ensure you separate them with a semicolon and end with a semicolon if required by your configuration standards.
- **Verification:** After running, visually inspect corners to ensure the studs have moved or been cut correctly to accommodate the sheet material thickness.
- **Recalculation:** Since the script deletes itself after processing (`_bOnElementConstructed`), re-running the command on the same walls may be necessary if you change the wall geometry significantly after the initial run.

## FAQ
- **Q: Why didn't my wall change after running the script?**
  **A:** Check the **Male Wall Code** property. The Code assigned to your wall element (in the General properties) must match one of the codes in this list for the script to activate.
- **Q: How do I account for different thicknesses of drywall?**
  **A:** Ensure the **Sheet Material** property matches the exact name of the material used in the Element Zones of the intersecting wall. The script calculates the depth based on the zone thickness.
- **Q: Can I use this on curved walls?**
  **A:** This script is primarily designed for straight wall intersections. Results on curved walls may vary depending on the intersection geometry.