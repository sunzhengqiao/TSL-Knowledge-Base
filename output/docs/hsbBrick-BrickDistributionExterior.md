# hsbBrick-BrickDistributionExterior

## Overview

The **hsbBrick-BrickDistributionExterior** script calculates and generates horizontal brick distribution patterns for exterior walls. It works as part of a brick facade system, typically called by the parent script `hsbBrick-CourseDistribution`, which provides vertical (course) distribution and brick family data.

The script automatically:
- Divides the wall facade into distribution zones based on openings (windows, doors)
- Calculates optimal mortar joint widths within user-defined min/max limits
- Handles corner connections (male/female joints) between perpendicular walls
- Creates one TSL instance per distribution zone
- Generates hardware components (bill of materials) for each brick
- Optionally creates 3D brick geometry for visualization

**Script Type:** O-Type (Object)
**Version:** 2.14
**Keywords:** brick, distribution, joint, butt, micasa, mortar, exterior, wall

---

## Environment

| Property | Value |
|----------|-------|
| Workspace | Model Space |
| Coordinate System | Wall element coordinate system (zone-based) |
| Units | Millimeters (default), uses `U()` for unit conversion |
| Dependencies | Requires `hsbBrick-CourseDistribution` parent script |

---

## Prerequisites

Before using this script, ensure:

1. **Exterior Wall Elements** - One or more `ElementWall` entities must exist with the exterior (exposed) flag set
2. **Course Distribution** - The `hsbBrick-CourseDistribution` script must be placed first to define:
   - Brick family (dimensions, color, name)
   - Course joint height
   - Building reference point
   - Butt joint min/max defaults
3. **Wall Connections** - For proper corner handling, walls must be correctly connected using hsbCAD's wall connection tools

---

## Usage

### Insertion Workflow

1. Run the script command or insert from the TSL palette
2. When prompted, **Select element(s)** - pick the exterior wall element(s) for brick distribution
3. When prompted, **Select course distribution** - pick the `hsbBrick-CourseDistribution` TSL instance on the facade
4. The script automatically creates distribution zones based on wall geometry and openings

### How Distribution Zones Work

The facade is automatically divided into zones at:
- Wall start and end points
- Opening (window/door) edges
- Corner connections with perpendicular walls

Each zone receives its own TSL instance that manages the brick pattern for that section.

### Corner Connection Types

The script recognizes three corner connection types:

| Type | Description | Behavior |
|------|-------------|----------|
| **Female** | This wall receives the perpendicular wall | Bricks extend to corner, odd/even rows stagger |
| **Male** | This wall inserts into perpendicular wall | Starts with mortar gap, brick width offset |
| **End** | No perpendicular wall connection | Full bricks to wall edge |

---

## Parameters

### Mortar Butt Joint

These parameters control the horizontal (butt) joint width between bricks:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Minimum** | PropDouble | 9 mm | Minimum allowed butt joint width |
| **Maximum** | PropDouble | 15 mm | Maximum allowed butt joint width |
| **calculated** | PropDouble | (auto) | The calculated optimal joint width (read-only) |

The script optimizes the joint width between min and max values to achieve the best possible brick pattern with the least cutting.

### Brick Family Data (from Course Distribution)

The following properties are inherited from the parent `hsbBrick-CourseDistribution`:

| Property | Description |
|----------|-------------|
| Length | Brick length (e.g., 188 mm) |
| Width | Brick width/depth (e.g., 88 mm) |
| Height | Brick height (e.g., 48 mm) |
| Color | Display color index |
| Name | Brick family name for hardware lists |

---

## Context Menu Commands

Right-click the TSL instance to access these commands:

| Command | Description |
|---------|-------------|
| **Generate 3d Bricks** | Creates 3D solid geometry for all regular bricks using `hsbBrick-3dBricks` |
| **Generate 3d of special bricks** | Creates 3D geometry only for cut/shaped bricks at corners and openings |
| **Delete 3d bricks** | Removes all regular 3D brick geometry |
| **Delete 3d of special bricks** | Removes only special (non-rectangular) 3D brick geometry |

### 3D Brick Generation

When 3D bricks are generated:
- Regular bricks are displayed with standard visualization
- Special bricks (non-rectangular shapes at corners/openings) are highlighted in a different color
- Each brick includes position data relative to the building reference point
- Stability analysis is performed for special bricks (stable if bottom base > 60% of top)

---

## Hardware Output

The script generates hardware components for each brick with:

| Field | Content |
|-------|---------|
| Article Number | Brick family name |
| Category | "Brick" |
| Group | Element group name |
| Notes | Wall number |
| Description | Brick type (0=regular, 1=cut rectangular, 2=special) + stability + PosNum |
| Scale X/Y/Z | Actual brick dimensions (after cutting) |
| Offset X/Y/Z | Position relative to building reference point |
| Angle A | Wall rotation (0, 90, 180, or 270 degrees) |

---

## Tips

### Best Practices

1. **Start with Course Distribution** - Always place `hsbBrick-CourseDistribution` first to establish the brick parameters and reference point

2. **Use Consistent Joint Values** - Keep min/max butt joint values consistent across connected walls for uniform appearance

3. **Check Corner Connections** - Verify wall connections before running distribution; incorrect connections produce wrong brick patterns

4. **Multi-Story Facades** - The script supports stacked walls; elements are ordered bottom-to-top automatically

5. **Grip Point Adjustment** - For the first distribution zone, a grip point allows horizontal shifting of the entire pattern

### Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "This TSL to be used only for exterior walls" | Script applied to interior wall | Use on walls with exterior (exposed) flag |
| "Invalid brick sizes" | Zero or negative brick dimensions | Check brick family in Course Distribution |
| "No valid course distribution found" | Missing or invalid parent script | Ensure `hsbBrick-CourseDistribution` is placed and valid |
| Distribution deleted automatically | Zone too small after 4 attempts | Check wall geometry and opening positions |
| Bricks not connecting at corners | Wall connection not set | Use hsbCAD wall connection tools |

### Performance Considerations

- The script processes up to 10,000 rows and 10,000 bricks per row (safeguards against infinite loops)
- 3D brick generation is optional and on-demand to reduce model complexity
- Dependencies are set between adjacent distribution zones for automatic recalculation

### Related Scripts

| Script | Purpose |
|--------|---------|
| `hsbBrick-CourseDistribution` | Parent script for vertical distribution |
| `hsbBrick-3dBricks` | 3D brick geometry generator |
| `hsbBrick-BrickDistributionInterior` | Interior wall brick distribution (separate script) |
