# hsb_RedistributeSheeting.mcr

## Overview
This script automatically regenerates vertical sheathing sheets on selected wall elements. It removes existing sheets in the specified zones and calculates new layouts based on the current frame geometry, openings, and minimum width constraints to prevent narrow offcuts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Requires Element entities with vertical sheeting zones defined. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Not designed for manufacturing views. |

## Prerequisites
- **Required Entities**: Element (Wall) entities.
- **Minimum Beam Count**: None.
- **Required Settings**: The Element's Zone Distribution must be set to **"Vertical Sheets"** for the specific zones you wish to process.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_RedistributeSheeting.mcr`.

### Step 2: Configure Properties
```
Dialog: Properties Palette
Action: Set the desired zones, minimum widths, and materials to ignore.
```
*Note: A dialog may appear automatically. If not, check your AutoCAD Properties Palette.*

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements you want to resheet and press Enter.
```

### Step 4: Processing
The script will automatically erase the old sheets and generate the new ones. The script instance removes itself from the drawing once finished.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zones to Redistribute the Sheets | Text | `1;2` | Specify which construction layers (zones) to update. Separate multiple zones with a semicolon (e.g., `1;2;3`). |
| Enter a minimum width of sheeting for horizontal distribution | Number | `100` | The smallest allowable width for a sheet strip. If the remaining space is smaller than this, the script will merge it into the previous sheet to prevent narrow slivers. |
| Enter a minimum width of sheeting for vertical distribution | Number | `0` | The smallest allowable height for a sheet strip. Prevents tiny top or bottom cuts. Set to 0 to disable. |
| Materials to ignore | Text | | List of sheet materials to preserve during redistribution. Separate materials with a semicolon (e.g., `Plywood;OSB`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom context menu items. Use standard Relink or Recalculate commands if supported by your environment configuration. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Check Zone Distribution**: If the script runs but no sheets appear, ensure the Element's Zone Properties are set to "Vertical Sheets" for the zones you selected in `psZones`.
- **Preserve Custom Work**: Use the `Materials to ignore` property to protect specific sheets you have manually placed or modified so they are not deleted during the process.
- **Avoiding Scraps**: If you are seeing very narrow strips of sheathing at the ends of walls or around openings, increase the `Enter a minimum width of sheeting for horizontal distribution` value.

## FAQ
- **Q: Why did the script run but not change anything?**
  - A: Check that the Element's Zone Distribution setting is actually set to "Vertical Sheets". The script ignores zones with other distribution types (like Manual).
- **Q: Can I redistribute both external sheathing and internal linings at the same time?**
  - A: Yes. List the zone numbers in the `Zones to Redistribute the Sheets` property (e.g., `1;4`).
- **Q: What happens if a wall is too short for a full sheet?**
  - A: The script handles this by checking the `Enter a minimum width of sheeting for vertical distribution` setting. If the remaining height is too small, it adjusts the cut or places a shorter sheet.