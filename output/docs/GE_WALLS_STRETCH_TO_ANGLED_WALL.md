# GE_WALLS_STRETCH_TO_ANGLED_WALL

## Overview
This utility script automatically stretches selected walls to intersect perfectly with a target wall. It is designed to update wall geometry during layout changes and automatically triggers the creation of angled connection details where the walls meet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D ElementWall entities. |
| Paper Space | No | Not designed for 2D drawings or views. |
| Shop Drawing | No | Not designed for manufacturing views. |

## Prerequisites
- **Required Entities**: At least two `ElementWall` entities (one to stretch, one to stretch to).
- **Minimum Beam Count**: 0 (Script operates on Walls, not beams).
- **Required Settings**: The dependent script `GE_WDET_SEARCH_ANGLED_CONNECTIONS` must be available in the TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALLS_STRETCH_TO_ANGLED_WALL.mcr`

### Step 2: Select Walls to Stretch
```
Command Line: |Select wall(s) to stretch|
Action: Click on one or multiple walls in the model that need to be lengthened or shortened to meet the target wall. Press Enter to confirm selection.
```

### Step 3: Select Target Wall
```
Command Line: |Select wall to stretch to|
Action: Click on the single wall that defines the boundary plane. The selected walls from Step 2 will be stretched to intersect this wall.
```

### Step 4: Automatic Execution
The script will automatically:
1. Calculate the intersection points.
2. Stretch the wall geometry.
3. Generate connection details (if the angle is not 90°).
4. Erase itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not have persistent properties. It executes immediately and erases itself. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No right-click menu options are available as the script instance is removed immediately after execution. |

## Settings Files
- **Dependency**: `GE_WDET_SEARCH_ANGLED_CONNECTIONS.mcr`
- **Location**: TSL Search Path
- **Purpose**: This script relies on the dependent script to handle the geometric logic for creating the joinery/mitering details between the modified walls.

## Tips
- **Parallel Walls**: If you select a source wall that is parallel to the target wall, the script will report "|Walls are paralell|" and skip that specific wall.
- **Perpendicular Walls**: The script stretches walls that meet at 90 degrees but will **not** generate angled connection details for them (assuming a standard butt joint).
- **Openings**: The script logic ensures that wall openings (windows/doors) are not moved during the stretching operation; they retain their relative position.
- **Undo**: If the result is not as expected, use the standard AutoCAD `U` (Undo) command to revert the changes.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This is a "fire-and-forget" utility script. It performs the geometric modification once and then deletes itself to prevent cluttering your project with unused script instances.

- **Q: Can I use this on timber beams?**
  **A:** No, this script is specifically designed for `ElementWall` entities.

- **Q: What happens if the target wall is not straight?**
  **A:** The script calculates the intersection based on the target wall's coordinate system (Plane). It attempts to stretch the source wall to the closest intersection plane of the target wall.