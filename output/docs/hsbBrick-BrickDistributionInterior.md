# hsbBrick-BrickDistributionInterior

## Overview

The **hsbBrick-BrickDistributionInterior** script calculates and generates optimal brick distribution layouts for interior walls in hsbCAD. It automatically determines brick placement with proper mortar joint widths, handles wall intersections (T-connections and X-connections), and creates hardware components for material takeoffs.

This script is designed specifically for interior walls and works in conjunction with `hsbBrick-CourseDistribution`, which provides the vertical brick course layout and brick family specifications. For walls divided by T-intersections, the script automatically creates separate distribution zones for each segment.

**Script Type:** O-Type (Object)
**Version:** 2.18
**Environment:** Model Space only

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment for 3D wall geometry |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites

### Required Elements

- **Interior Wall Elements:** One or more `ElementWall` entities that are NOT marked as exterior (exposed)
- **Course Distribution TSL:** A valid `hsbBrick-CourseDistribution` instance that defines:
  - Brick family (dimensions, color, name)
  - Course joint height
  - Building reference point
  - Min/max butt joint constraints

### Minimum Beam Count

0 (This script operates on Wall elements, not beams)

### Dependencies

- `hsbBrick-CourseDistribution` - Master distribution providing brick specifications (required)
- `hsbBrick-3dBricks` - Child script for generating 3D brick geometry (optional)

## Usage

### Step 1: Launch Script

Command: `TSLINSERT` and select `hsbBrick-BrickDistributionInterior.mcr`

Or use the catalog entry if a predefined configuration exists.

### Step 2: Configure Properties

If inserting manually without a catalog entry, a dialog appears:
```
Action: Set the desired Minimum and Maximum mortar joint widths.
Click OK to confirm.
```

### Step 3: Select Interior Wall

```
Prompt: |Select element(s)|
Action: Click on the interior wall(s) where you want to calculate brick distribution.
```

Note: Exterior (exposed) walls are rejected with the message "Exterior walls not allowed."

### Step 4: Select Course Distribution

```
Prompt: |Select course distribution|
Action: Click on the existing 'hsbBrick-CourseDistribution' TSL instance.
```

The script validates that the selected instance contains valid brick data (`hsbBrickData` subMap).

### After Insertion

- The brick distribution displays visually on the wall with color coding
- Grip points appear at each row start for manual horizontal adjustment
- Hardware components are created automatically for BOM export
- If the wall has T-intersections, multiple distribution instances are created for each segment

## Parameters

### Mortar Butt Joint (Category)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Minimum** | PropDouble | 9 mm | Minimum allowed butt joint width between bricks |
| **Maximum** | PropDouble | 15 mm | Maximum allowed butt joint width between bricks |
| **calculated** | PropDouble | 0 mm | Read-only. Displays the actual optimized butt joint width |

The script calculates an optimal butt joint within the min/max range to achieve the best fit for the wall length. The optimization considers:
- Full bricks (100% length)
- Half bricks (50%)
- Quarter bricks (25%)
- Three-quarter bricks (75%)

### Brick Dimensions (from Course Distribution)

These values are read from the linked `hsbBrick-CourseDistribution`:

| Value | Source | Description |
|-------|--------|-------------|
| Length | Family.Length | Standard brick length (e.g., 188 mm) |
| Width | Family.Width | Brick width/depth (e.g., 88 mm) |
| Height | Family.Height | Brick height (e.g., 48 mm) |
| Color | Family.Color | Display color index |
| Name | Family.Name | Brick family name for hardware |

## Context Menu Options

Right-click on the distribution instance to access these commands:

| Menu Item | Description |
|-----------|-------------|
| **Generate 3d bricks** | Creates 3D solid geometry for all regular bricks using `hsbBrick-3dBricks` |
| **Generate 3d of special bricks** | Creates 3D solids only for non-standard bricks (cut corners, partial bricks) |
| **Delete 3d bricks** | Removes all regular 3D brick instances while preserving the distribution |
| **Delete 3d of special bricks** | Removes only the special/cut 3D brick instances |
| **AddPLine** | Debug feature: Appends a polyline for distribution profile visualization |

## Tips and Best Practices

### Wall Preparation

1. **Use continuous walls:** The algorithm works best with single continuous walls per facade. Avoid breaking walls into multiple segments along their length.

2. **Ensure perpendicular intersections:** Connected walls should be perpendicular (90 degrees) for proper corner calculations.

3. **Zone alignment:** Make sure the wall zone number matches the course distribution zone for consistent positioning.

### Understanding Corner Types

The script automatically detects and handles three connection types:

| Type | Detection | Behavior |
|------|-----------|----------|
| **Female** | 2 points on connecting wall, 1 point on this wall | Starts/ends with full brick |
| **Male** | 0-1 points on connecting wall, 2 points on this wall | Starts/ends with mortar joint, modified first brick |
| **End** | No connection | Standard half-brick offset pattern |

### Adjusting Brick Layout

- **Grip points:** Each course row has a movable grip point at its starting position
- **Moving grip points:** Drag horizontally to shift the brick pattern for that row
- Automatic recalculation occurs when grip points are modified
- Grip point movement is constrained to multiples of the brick module (Length + Joint)

### Hardware Components

Each brick creates a `HardWrComp` with:
- **ArticleNumber:** Brick family name
- **Group:** Wall element group name
- **Notes:** Wall number for identification
- **Position:** X, Y, Z coordinates relative to building reference point
- **Dimensions:** DScaleX (length), DScaleY (width), DScaleZ (height)
- **Rotation:** Angle based on wall orientation (0, 90, 180, or 270 degrees)
- **Description:** Brick type indicator (0=regular, 1=special rectangular, 2=special non-rectangular)

### Special Bricks

Non-rectangular or non-standard bricks are identified with additional information:
- **Stability indicator:** Bricks with base-to-length ratio > 60% are marked "stable"
- **Position number (PosNum):** Links to existing 3D brick instances for tracking
- **Visual differentiation:** Special bricks display in color 4

### T-Intersection Handling

When a wall is intersected by perpendicular "T" walls:
- The wall is automatically divided into separate distribution areas
- Each segment between intersections gets its own TSL instance
- Special bricks are generated at intersection joints
- Distribution patterns maintain proper staggering across segments

### X-Intersection Handling

For walls that cross each other (X-intersection):
- The longer wall is treated as "female" (continuous pattern)
- The shorter wall is treated as "male" (interrupted at crossing)
- Appropriate mortar joints are added at the intersection zone

### Performance

- Large walls with many courses require more calculation time
- Delete 3D bricks when visualization is not needed to improve drawing performance
- The script maintains dependencies between adjacent distributions for proper update sequencing

## FAQ

**Q: I get an error "Invalid tsl instance has no brick data."**

A: Ensure you selected a valid `hsbBrick-CourseDistribution` instance. That instance must contain brick family data in its `hsbBrickData` subMap.

**Q: Why is the calculated joint showing 0?**

A: This typically means:
- The wall segment is too short for even one brick
- The min/max joint constraints are too restrictive for the wall length
- The distribution has not finished calculating (wait for recalc)

**Q: How do I remove 3D bricks without losing calculation data?**

A: Use the right-click menu "Delete 3d bricks" or "Delete 3d of special bricks". This removes visual geometry but preserves the script instance and hardware component list.

**Q: Why does the script reject my wall with "Exterior walls not allowed"?**

A: This script is specifically for interior walls. For exterior (exposed) walls, use the exterior brick distribution script (`hsbBrick-Facade` or similar).

**Q: The distribution does not update when I move the wall.**

A: The script should recalculate automatically. If not:
1. First recalculate the parent `hsbBrick-CourseDistribution`
2. Then recalculate this distribution instance
3. Check that wall element dependencies are properly set

## Related Scripts

- `hsbBrick-CourseDistribution` - Master vertical course distribution (required parent)
- `hsbBrick-3dBricks` - 3D brick geometry generation (child)
- `hsbBrick-Facade` - Exterior wall brick distribution
