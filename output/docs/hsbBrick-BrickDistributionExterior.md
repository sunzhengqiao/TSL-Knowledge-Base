# hsbBrick-BrickDistributionExterior

## Overview
This script automatically calculates the optimal horizontal layout and distribution of bricks (masonry) for exterior wall segments. It ensures that vertical mortar joints remain within specified aesthetic tolerances and generates 3D brick visualizations.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a detailing/modeling script, not a drawing generator. |

## Prerequisites
- **Required Entities**: An existing `ElementWall` (timber frame wall) and a `Course Distribution` TSL instance already inserted in the drawing.
- **Minimum Beam Count**: 0.
- **Required Settings**: The parent "Course Distribution" TSL must contain valid brick dimensions within the `hsbBrickData` map (Family data) and a reference building point (`ptRefBuilding`).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `hsbBrick-BrickDistributionExterior.mcr`.

### Step 2: Select Element
```
Command Line: Select element(s)
Action: Click on the wall element(s) where you want to apply the brick distribution and press Enter.
```

### Step 3: Select Course Distribution
```
Command Line: Select course distribution
Action: Click on the existing TSL instance that defines the vertical courses (e.g., "Course Distribution" script).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum | Number | 9 mm | Defines the smallest allowable width for the vertical mortar joint (butt joint). If the wall length forces a joint smaller than this, the script adds another brick to increase the joint size. |
| Maximum | Number | 15 mm | Defines the largest allowable width for the vertical mortar joint. If the calculated joint exceeds this value, the script removes a brick to decrease the joint size. |
| calculated | Number | 0 mm | The resulting width of the mortar joint based on the final brick count (Read-only). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| AddPLine | Appends a PLine entity to the drawing for debugging visualization (Debug Mode only). |

## Settings Files
*Note: This script relies on data maps passed from the parent "Course Distribution" TSL instance rather than a standalone external XML settings file.*

## Tips
- **Aesthetic Control**: To achieve a specific look, adjust the **Minimum** and **Maximum** joint parameters. The script algorithm will automatically find the best number of bricks to fit within these bounds.
- **Dynamic Updates**: If you modify the wall length (e.g., moving a window or adjusting a corner), the script will automatically recalculate the brick layout to maintain the joint constraints.
- **Failed Insertion**: If the distribution region is extremely small and the script fails to find a valid layout after several attempts, it will automatically delete itself to prevent errors.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  **A:** The script may have determined the distribution region is too small to fit any bricks within the specified joint tolerances. It deletes itself after 3 failed calculation attempts (Version 2.14+).

- **Q: How do I change the size of the mortar joints?**
  **A:** Select the script instance in the model, open the Properties Palette (Ctrl+1), and modify the "Minimum" or "Maximum" values under the "Mortar Butt Joint" category.

- **Q: What does the "calculated" property show?**
  **A:** This shows the exact mathematical width of the vertical joint that will be used based on the number of bricks selected to fit your wall.