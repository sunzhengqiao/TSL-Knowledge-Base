# hsbBrick-3dBricks

## Overview

**hsbBrick-3dBricks** is a child script in the hsbCAD brick modeling system that generates individual 3D brick bodies. This script is **not intended for direct user insertion**; instead, it is automatically called by the parent distribution scripts (`hsbBrick-BrickDistributionExterior` or `hsbBrick-BrickDistributionInterior`) to create the visual representation of each brick in a wall's brick pattern.

The script receives brick position, type, and profile data from its parent scripts and creates a 3D solid body representing the brick geometry. Each brick instance maintains dependencies on its parent scripts and automatically updates or deletes when parent scripts change.

## Environment

| Attribute | Value |
|-----------|-------|
| Type | O-Type (Object) |
| Environment | Model Space |
| Version | 1.4 |
| Beams Required | 0 |
| Keywords | micasa, automatic, brick, generation, special, shop, drawing |

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates 3D solid bodies assigned to element groups |
| Paper Space | No | Not designed for 2D layout or sheet generation |
| Shop Drawing | No | Not a shop drawing generation script |

## Prerequisites

This script requires the following parent scripts to be present and valid:

1. **hsbBrick-BrickDistributionExterior** or **hsbBrick-BrickDistributionInterior** - The main brick distribution controller that creates instances of this script
2. **hsbBrick-CourseDistribution** - The course layout controller
3. **Wall Element** - A valid Element must be associated with the parent scripts

**Required Map Data from Parent Scripts:**
- `planeProfile` - The brick's profile shape (PlaneProfile)
- `width` - The brick depth/thickness for extrusion
- `dOffsetX`, `dOffsetY`, `dOffsetZ` - Position coordinates
- `sBrickTypeMap` - Brick type identifier (Regular/Special)

**Important**: If either parent script is deleted or becomes invalid, this brick instance will automatically delete itself.

## Usage

### Automatic Insertion (Recommended)

This script is designed to work as part of the brick modeling suite:

1. Apply `hsbBrick-BrickDistributionExterior` or `hsbBrick-BrickDistributionInterior` to a wall element
2. The parent script automatically creates `hsbBrick-3dBricks` instances for each brick in the pattern
3. Each brick instance maintains a dependency on its parent scripts

### Manual Insertion (Not Recommended)

**Command:** `TSLINSERT` followed by selecting `hsbBrick-3dBricks.mcr`

Manual insertion is rarely required and will only function if the prerequisite parent scripts are already present on the element. If parent scripts are missing, the instance will erase itself automatically.

### Behavior

- The script receives brick geometry (profile) and position data via the internal Map system
- It creates a 3D extruded body from the brick profile in the negative Z direction of the wall
- The brick is automatically assigned to the wall element's group with code 'E'
- If the parent distribution script is modified or recalculated, all brick instances update accordingly
- Moving or resizing the parent wall element automatically updates the position and orientation of all bricks

## Parameters

All parameters in this script are **read-only** because the values are controlled by the parent distribution scripts. Users cannot directly modify individual brick properties.

### Position Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| X | PropDouble | (from parent) | X-axis position offset of the brick relative to the wall element's origin |
| Y | PropDouble | (from parent) | Y-axis position offset of the brick (depth/face alignment) |
| Z | PropDouble | (from parent) | Z-axis elevation of the brick relative to the wall element's base |

### Brick Type Category

| Parameter | Type | Values | Description |
|-----------|------|--------|-------------|
| BrickType | PropString | Regular, Special | Indicates whether this is a standard brick or a special/cut brick |

## Menu

This script does not provide custom right-click context menu options. To modify brick properties or distribution patterns, use the parent script's interface:

- **hsbBrick-BrickDistributionExterior** - For exterior brick patterns
- **hsbBrick-BrickDistributionInterior** - For interior brick patterns

## Tips

1. **Parent-Child Relationship**: Do not attempt to insert this script manually. Always use the parent distribution scripts to generate brick patterns.

2. **Automatic Cleanup**: If you delete a parent distribution script, all associated 3D brick instances will be automatically removed from the drawing.

3. **Read-Only Properties**: The position and type properties shown in the Properties Palette are informational only. To change brick layout, modify the parent distribution script settings.

4. **Element Association**: Each brick is automatically assigned to the wall element's group, ensuring proper organization in the model.

5. **Profile Limitations**: The script expects a single closed profile per brick. Complex profiles with multiple rings (such as bricks with holes) are not supported and will cause the instance to be deleted with a warning message.

6. **Debugging**: If you need to troubleshoot brick generation, enable debug mode via `hsbTSLDebugController` to see detailed messages in the command line.

7. **Display Color**: Bricks are displayed in color index 4 (cyan) by default. This is for visualization purposes only.

8. **Catalog Support**: When inserted with an execute key, the script can load default properties from a matching catalog entry.

## FAQ

**Q: Why can I not change the Brick Type to "Special"?**

A: The properties are read-only and populated by the parent distribution script. You must configure the logic or map data in the parent script to designate specific bricks as "Special".

**Q: I get an error "more than one ring in brick plane profile". What does this mean?**

A: The profile shape generated by the parent script is too complex (it has multiple loops/holes). This script requires a single, simple ring profile. Check the input geometry or profile settings in the Brick Distribution script.

**Q: The 3D bricks disappeared from my model. What happened?**

A: Check that the `hsbBrick-BrickDistributionExterior`/`hsbBrick-BrickDistributionInterior` and `hsbBrick-CourseDistribution` scripts are still present on the element. This script automatically deletes itself if its parent scripts are removed.

**Q: Can I manually position individual bricks?**

A: No. Individual brick positions are calculated by the parent distribution scripts. Adjust the distribution settings in the parent scripts to change the overall layout pattern.
