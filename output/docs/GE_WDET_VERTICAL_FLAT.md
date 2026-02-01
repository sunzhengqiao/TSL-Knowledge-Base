# GE_WDET_VERTICAL_FLAT.mcr

## Overview
This script generates a vertical column of flat blocking (solid bridging) between two adjacent studs in a wall element. It is typically used for fireblocking, ladder backing for drywall, or structural stiffening.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates geometry in the 3D model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Does not generate 2D annotations. |

## Prerequisites
- **Required Entities**: A Wall Element (ElementWallSF) containing at least two vertical studs.
- **Minimum Beam Count**: 2 (The studs that will bound the blocking).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_VERTICAL_FLAT.mcr`

### Step 2: Select Wall Element
```
Command Line: Select an element
Action: Click on the wall element where you want to add blocking.
```

### Step 3: Select Insertion Point
```
Command Line: Select an insertion point
Action: Click between the two studs where the blocking should be placed.
```
*Note: The script will automatically detect the two closest studs to the left and right of your click.*

### Step 4: Configure Properties
After insertion, the "Properties" dialog will appear automatically. You can adjust the offset, spacing, and material settings here. These can also be changed later via the AutoCAD Properties Palette before regenerating.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Start Offset** | Number | 600 (24") | Distance from the bottom plate to the centerline of the first row. Set to 0 to sit flush on the bottom plate. |
| **End Offset** | Number | 0 (0") | Distance from the top plate downwards. Set to 0 to sit flush with the top plate. |
| **Spacing** | Number | 600 (24") | The vertical gap (empty space) between consecutive blocking pieces. |
| **Blocking Length** | Number | 200 (8") | The vertical height (depth) of each individual blocking piece. |
| **Material** | Text | SPF | The material species code (e.g., SPF, HemFir). |
| **Grade** | Text | #2 | The structural grade of the lumber. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the entity context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Flush Placement**: To create a solid stack of blocking from the bottom plate upwards, set **Start Offset** to `0` and **Spacing** to `0`.
- **Gap Validation**: The script checks the gap between studs. If the gap does not match a standard lumber width (approx. 2.5" to 11.25"), the script will fail and display an error.
- **Self-Deleting**: This script is a "Generator". Once the blocking beams are created in the model, the script instance deletes itself. The resulting blocking is standard geometry that can be edited manually.
- **Unit Independence**: Input values are interpreted based on your current hsbCAD/AutoCAD unit settings (mm or inches).

## FAQ
- **Q: Why did I get an error "Cannot position... because [dist] is not a standard size"?**
  - A: The distance between the two studs you selected does not correspond to a standard lumber width. Check your wall framing settings or ensure you clicked between two standard studs.
- **Q: Can I edit the blocking after I insert it?**
  - A: Yes. The script creates actual Beam objects. You can manually stretch, move, or delete them just like any other beam in the model. However, since the script instance deletes itself after running, you cannot use the script parameters to update them later.
- **Q: What does "Start Offset" = 0 actually do?**
  - A: It places the bottom of the first blocking piece exactly on top of the bottom plate. If Start Offset is greater than 0, it measures to the *centerline* of the blocking piece.