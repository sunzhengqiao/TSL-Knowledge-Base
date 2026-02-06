# hsbBrick-BrickDistributionInterior.mcr

## Overview
Calculates the optimal brick layout for interior walls, determining cut lengths, quantities, and vertical mortar joint widths to fit specific wall segments. It ensures that mortar joints remain within specified architectural tolerances at corners and intersections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall geometry. |
| Paper Space | No | Not applicable for drawings. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities:**
  - An `ElementWall` representing the interior wall.
  - An existing TSL instance named `hsbBrick-CourseDistribution` that contains brick data (specifically a subMap named `hsbBrickData`).
- **Minimum Beam Count:** 0 (This script relies on Wall elements, not beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBrick-BrickDistributionInterior.mcr`

### Step 2: Configure Properties (If Required)
If inserting manually (without a predefined catalog entry), a dialog may appear.
```
Action: Set the desired Minimum and Maximum mortar joint widths.
Click OK to confirm.
```

### Step 3: Select Wall
```
Command Line: |Select element(s)|
Action: Click on the interior wall(s) where you want to calculate brick distribution.
```

### Step 4: Select Course Distribution
```
Command Line: |Select course distribution|
Action: Click on the existing 'hsbBrick-CourseDistribution' TSL instance that defines the brick course data.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Minimum** | Number | 9 mm | The minimum permissible width of the vertical mortar joint (head joint) between bricks. |
| **Maximum** | Number | 15 mm | The maximum permissible width of the vertical mortar joint. |
| **calculated** | Number | 0 mm | (Read-Only) The actual mathematically derived joint width that fits the current wall segment within the min/max limits. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **AddPLine** | Appends a Polyline to the script entities to visualize the calculated distribution profiles (useful for debugging). |
| **Generate 3d bricks** | Creates 3D representations for all bricks in the distribution in the model. |
| **Generate 3d of special bricks** | Creates 3D representations only for special (cut) bricks. |
| **Delete 3d bricks** | Removes all generated 3D brick instances from the model. |
| **Delete 3d of special bricks** | Removes only the 3D special brick instances from the model. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script relies on dynamic data from the selected `hsbBrick-CourseDistribution` instance rather than external settings files.

## Tips
- **Visualizing Results:** After calculation, right-click the script instance and select **"Generate 3d bricks"** to see a visual representation of the wall in the 3D model.
- **Optimization:** If the calculated joint size (`calculated`) hits the minimum or maximum limit, consider adjusting your wall dimensions or the Min/Max properties to get a more standard joint size.
- **Updates:** If you modify the wall geometry (e.g., lengthen the wall) or change the parent Course Distribution, the script will automatically recalculate.

## FAQ
- **Q: I get an error "Invalid tsl instance has no brick data."**
  - **A:** Ensure you selected a valid `hsbBrick-CourseDistribution` instance in Step 4. That instance must contain the necessary brick data (hsbBrickData) for this script to function.
- **Q: Why are my calculated joints 0?**
  - **A:** This usually means the wall is too short or the brick dimensions from the parent script do not fit the geometry within the allowed Min/Max joint tolerances. Check your constraints.
- **Q: How do I remove the 3D bricks without deleting my calculation?**
  - **A:** Use the right-click menu option **"Delete 3d bricks"**. This removes the visual geometry but keeps the script instance and the hardware list (BOM) data intact.