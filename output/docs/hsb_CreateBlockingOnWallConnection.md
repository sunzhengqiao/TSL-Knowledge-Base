# hsb_CreateBlockingOnWallConnection

## Overview
This script automatically generates timber blocking beams or horizontal sheet battens at T-junctions between walls. It creates these reinforcements at standard heights (600mm, 1200mm, and 1800mm) to provide structural backing for fixings, based on the wall types involved.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D Model Space on ElementWall entities. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: At least one `ElementWall` in the model.
- **Framing**: The selected wall must contain vertical studs (generated beams).
- **Wall Codes**: Connected walls must have a specific "Code" property assigned (e.g., NB, LB) to match the script's filter list.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse to the script location and select `hsb_CreateBlockingOnWallConnection.mcr`.

### Step 2: Select Primary Walls
```
Command Line: Select a set of elements
```
**Action**: Click on the primary wall(s) that intersect with other walls where you need blocking. Press **Enter** to confirm selection.
*Note: The script will analyze connections to walls meeting this primary wall.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| List of connecting wall codes | Text | NB;LB;PA | Defines which wall types require blocking. Enter the "Code" property of intersecting walls separated by semicolons (e.g., "NB;PA"). If the connected wall's code is not in this list, no blocking is created. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script runs immediately upon insertion and does not add persistent right-click menu options. |

## Settings Files
- **None**: This script does not use external settings files.

## Tips
- **Corner Detection**: The script automatically skips intersections that are too close to the ends of the wall (corners), focusing only on T-junctions.
- **Stud Collision**: If the intersection point falls exactly on an existing vertical stud, the script will shift the blocking to align with the edge of the stud automatically.
- **Material Logic**: The script checks the primary wall's construction. If it contains a vertical sheet distribution zone, it creates horizontal battens; otherwise, it creates solid timber blocking beams (Type: SFBlocking).
- **Re-running**: The script instance erases itself after generating the geometry. To update the blocking after wall changes, simply run the script again on the updated wall.

## FAQ
- **Q: Why did the script not create blocking at a specific intersection?**
  **A**: Check the "Code" property of the connected wall. It must exactly match one of the entries in the "List of connecting wall codes" parameter. Also, ensure the intersection is not a corner (end of wall).

- **Q: Can I change the heights where the blocking is placed?**
  **A**: The heights are fixed at 600mm, 1200mm, and 1800mm. To change these, you would need to manually move the generated elements in the model or edit the script source code.

- **Q: What happens if I move the wall after running the script?**
  **A**: The generated blocking/sheets are static entities and will not update automatically. You must delete the old blocking and run the script again on the new wall position.