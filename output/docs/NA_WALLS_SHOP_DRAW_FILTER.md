# NA_WALLS_SHOP_DRAW_FILTER

## Overview
This script is a utility tool that filters a selection of wall group TSL instances. It validates each selected group and retains only those that contain valid wall geometry data, ensuring empty or uncalculated groups are excluded from downstream processes.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where wall group TSL instances are located. |
| Paper Space | No | Not supported for Paper Space layouts. |
| Shop Drawing | No | This is a utility script that processes shop drawing data but is run in the Model environment. |

## Prerequisites
- **Required Entities:** Wall group TSL instances (TslInst) must exist in the drawing.
- **Minimum Beam Count:** 0
- **Required Settings:** The selected wall groups must have internal map data (`mpElementShop`) populated with wall geometry (`walls` array) to be retained.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `NA_WALLS_SHOP_DRAW_FILTER.mcr`
1.  Type `TSLINSERT` in the command line and press Enter.
2.  In the file dialog, locate and select `NA_WALLS_SHOP_DRAW_FILTER.mcr`.

### Step 2: Select Wall Groups
```
Command Line: Select wall group tsls
Action: Click on the wall group TSL instances you wish to validate/filter, then press Enter.
```
*Note: The script will automatically check the selected groups and remove any that do not contain valid shop drawing data.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script does not expose editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A (Script relies on internal entity map data).

## Tips
- **Automatic Cleanup:** The script instance will automatically erase itself from the drawing immediately after execution. This is normal behavior.
- **Selection Logic:** Use this script before running an export or CAM generation process to ensure you do not process empty wall shells.
- **Visual Feedback:** The script runs silently. If the selection set becomes empty, it means none of the selected groups contained valid wall data.

## FAQ
- **Q: Why did the script icon disappear immediately after I selected the walls?**
  - A: The script is designed to run only once per insertion. It performs the filter, updates the internal selection list, and then automatically erases the script instance from the drawing.
- **Q: How do I know if a wall was filtered out?**
  - A: The script does not provide a visual warning for specific items. However, if you are running this as part of a larger workflow, the subsequent steps will only process the valid walls that passed the filter.
- **Q: Can I run this on individual beams?**
  - A: No, this script is designed specifically to filter "Wall Group" TSL instances, not individual timber beams.