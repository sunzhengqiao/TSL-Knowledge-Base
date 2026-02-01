# GE_WALL_NO_STUD_AREA_BLOCKING.mcr

## Overview
This script creates a defined "No Stud" zone within a wall, typically used for framing around chases, ductwork, or chimneys. It automatically removes or adjusts existing studs in the area, installs up to four horizontal blocking members, and optionally adds edge studs for structural support.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D wall geometry. |
| Paper Space | No | Not supported for drawing views. |
| Shop Drawing | No | Not a layout/shop drawing script. |

## Prerequisites
- **Required Entities**: A Wall or ElementWall must exist in the model.
- **Minimum Beam Count**: None required for insertion, but existing studs are needed for the automatic cleanup logic to function.
- **Required Settings**: None. The script uses internal properties for configuration.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_NO_STUD_AREA_BLOCKING.mcr`

### Step 2: Select Wall
```
Command Line: Select a wall to place no framing area
Action: Click on the desired Wall element in the 3D model.
```

### Step 3: Define Location
```
Command Line: Select the Mid-Point for the no framing area
Action: Click the point in the wall where the center of the opening/void should be located.
```

### Step 4: Define Blocking Side
```
Command Line: Select Point near Blocking Side
Action: Click a point on the side of the wall where the blocking timber should be placed (e.g., Front/Back or Left/Right). This determines the orientation and insertion side of the blocks.
```

### Step 5: Configure Properties
```
Action: The Properties Palette will display. Adjust the "No Stud Range Width", "Blocking" sizes, and "Elevations" as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **No Stud Range Width** | Number | 14.5 | The width of the zone where studs will be removed/avoided. Also defines the length of the blocking. |
| **Hatch pattern** | Dropdown | ESCHER | Visual pattern for the void area representation. |
| **Hatch Scale** | Number | 2.0 | Scale factor for the hatch pattern. |
| **Hatch Angle** | Integer | 0 | Rotation angle of the hatch pattern (0-360). |
| **Blocking 1** | Dropdown | Stud Size | Timber size for the 1st horizontal block (e.g., 2x4, 2x6). |
| **Blocking 2** | Dropdown | Stud Size | Timber size for the 2nd horizontal block. |
| **Blocking 3** | Dropdown | Stud Size | Timber size for the 3rd horizontal block. |
| **Blocking 4** | Dropdown | Stud Size | Timber size for the 4th horizontal block. |
| **Elev 1** | Number | 36 | Height from the bottom of the wall to place Blocking 1. |
| **Elev 2** | Number | 84 | Height from the bottom of the wall to place Blocking 2. |
| **Elev 3** | Number | (Varies) | Height from the bottom of the wall to place Blocking 3. |
| **Elev 4** | Number | (Varies) | Height from the bottom of the wall to place Blocking 4. |
| **Orient 1** | Dropdown | Upright | Orientation of Blocking 1 (Upright = on edge, Flat = laying flat). |
| **Orient 2** | Dropdown | Upright | Orientation of Blocking 2. |
| **Orient 3** | Dropdown | Upright | Orientation of Blocking 3. |
| **Orient 4** | Dropdown | Upright | Orientation of Blocking 4. |
| **Create Edge Stud** | Boolean | Yes | If Yes, places vertical studs at the left and right boundaries of the no-stud zone. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ReInsert Component | Re-runs the calculation logic. Use this after changing properties to move blocks, adjust the void size, or re-calculate stud deletion/movement. |

## Settings Files
None used.

## Tips
- **Hiding a Block**: If you do not need all 4 blocking levels, set the **Elevation** of the unwanted block to `0`. It will not be generated.
- **Stud Cleanup**: When you first run the script, it automatically deletes studs fully inside the zone and moves studs intersecting the edges to the boundary. If you manually move the script later, use the **ReInsert** context menu option to update the stud layout again.
- **Orientation**: Use the "Blocking Side" selection (Step 4) to control whether the blocking is applied to the interior or exterior face of the wall if the wall has thickness/material layers.

## FAQ
- **Q: Why did my script disappear after I selected the wall?**
  - **A:** The script performs validity checks. If the selected entity is not a valid Wall or if the script detects it is running in an invalid cycle, it will erase itself automatically to prevent errors.
- **Q: Can I change the size of the opening after inserting?**
  - **A:** Yes. Select the script instance, change the **No Stud Range Width** in the Properties Palette, and then right-click and select **ReInsert Component**.
- **Q: What happens to existing studs in the way?**
  - **A:** The script cuts the wall into three logical zones (Left, Center, Right). Studs in the Center are deleted. Studs in the Left/Right overlap zones are moved to the edge of the opening.