# HSB_P-Pocket.mcr

## Overview
This script creates a pocket or recess in a wall element to accommodate a specific beam. It automatically calculates the cut dimensions based on the beam profile and applies user-defined side and bottom gaps for tolerance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** One GenBeam (the object to be pocketed) and one ElementWall (the host wall).
- **Minimum Beam Count:** 1
- **Required Settings:** None (uses defaults or Catalog presets).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_P-Pocket.mcr`

### Step 2: Select Configuration (Optional)
If no specific execute key is preset, a Catalog dialog may appear allowing you to load pre-defined configurations for the pocket.

### Step 3: Select the Beam
```
Command Line: Select the beam or panel to create a pocket for.
Action: Click on the GenBeam in the model that needs to be inserted into the wall.
```

### Step 4: Select the Wall
```
Command Line: Select a wall
Action: Click on the ElementWall where the pocket should be cut.
```
*Note: If you select a non-wall element, the script will warn you and prompt you to select again.*

### Step 5: Adjust Properties (Optional)
After insertion, select the script instance in the drawing to adjust gap settings via the Properties Palette if they were not set via the catalog.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap at the side | Number | 1 mm | Sets the horizontal clearance applied on each side of the pocket (Total width increase = 2 * Gap). |
| Gap at the bottom | Number | 1 mm | Sets the vertical clearance applied below the beam within the pocket. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific custom options to the right-click context menu. |

## Settings Files
- **Catalog**: `HSB_P-Pocket`
- **Purpose**: Stores pre-defined configurations for gap sizes and other parameters, allowing for quick standardization of pocket details.

## Tips
- **Dynamic Updates:** If you move, rotate, or resize the beam after creating the pocket, the wall cut will update automatically to match the new position and profile.
- **Tolerances:** Use the "Gap at the side" property to account for timber swelling or to ensure loose fits for on-site assembly.
- **Orientation:** The script automatically detects the beam's orientation relative to the wall to determine the correct cut direction (using Beam X, Y, or Z axes as needed).

## FAQ
- **Q: Why did the script disappear after I selected an element?**
  A: This usually happens if you selected an invalid element (e.g., another beam instead of a wall) or if no element was selected. The script erases itself to prevent errors. Simply run the command again and ensure you select an `ElementWall` for the second prompt.
- **Q: Can I use this on a beam instead of a wall?**
  A: No, this script is designed to cut pockets specifically into `ElementWall` entities. For beam-to-beam connections, a different TSL script should be used.