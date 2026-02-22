# hsbPolylineBeamDistribution

## Overview

**hsbPolylineBeamDistribution** creates a series of beams distributed between two polylines. This tool is particularly useful for generating twisted or sloped beam distributions where the two boundary polylines are not parallel or perpendicular to each other. Common applications include twisted roof structures, sloped ceilings, and complex framing layouts where beams must span between irregular boundaries.

The script automatically calculates beam positions based on your chosen distribution mode and creates beams that follow the geometry defined by the two boundary polylines, including automatic end cuts where beams meet the boundaries.

## Environment

| Property | Value |
|----------|-------|
| Type | O-Type (Object) |
| Space | Model Space |
| Beams Required | 0 |
| Version | 1.0 |

## Prerequisites

Before using this tool, you must have:

1. **Two polylines** in your drawing that define the distribution boundaries (e.g., top plate and bottom plate, or two edge lines of a sloped surface)
2. The polylines should represent the paths along which beam ends will be positioned
3. Polylines can include curves and arcs; the script handles complex geometry

## Usage

### Step-by-Step Workflow

1. **Start the Tool**
   - Launch `hsbPolylineBeamDistribution` from the TSL menu or command line

2. **Configure Parameters (Dialog)**
   - A dialog appears allowing you to set beam dimensions and distribution parameters
   - Alternatively, select a saved catalog entry for quick insertion

3. **Select First Polyline**
   - Prompt: "Select 2 polylines"
   - Click on the first boundary polyline

4. **Select Second Polyline**
   - Prompt: "Select second polyline"
   - Click on the second boundary polyline

5. **Define Beam Direction**
   - Click a base point (this becomes the origin point)
   - Prompt: "Select point in rafter direction"
   - Click a second point to define the rafter/beam direction vector

6. **Result**
   - Beams are automatically generated spanning between the two polylines
   - End cuts are applied where beams intersect the boundary polylines
   - The beam direction follows the vector you specified

### Visual Indicators

After insertion, the tool displays:
- The two boundary polylines (color 6 - magenta)
- Closing lines connecting polyline endpoints (colors 3 and 4)
- A direction arrow showing the beam orientation

## Parameters

### Beam Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Number | 60 mm | Cross-section width of each beam |
| **Height** | Number | 200 mm | Cross-section height of each beam |

### Distribution

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Interdistance** | Number | 500 mm | Spacing between beam centerlines |
| **Mode** | Dropdown | Even Distribution | Distribution calculation method |

### Distribution Modes Explained

| Mode | Behavior |
|------|----------|
| **Even Distribution** | Adjusts spacing to fit an even number of beams within the available span. The interdistance value serves as a target, but actual spacing may vary slightly to ensure uniform distribution across the entire area. |
| **Fixed Distribution** | Uses the exact interdistance value specified. The number of beams depends on the span length divided by this fixed spacing. May result in uneven spacing at boundaries. |

## Context Menu

This script supports catalog presets for quick insertion:

- Save commonly used configurations (beam sizes, distribution settings) as catalog entries
- When inserting with a command key, the script checks for matching catalog entries
- If found, it applies those saved settings automatically
- Otherwise, it falls back to the last inserted configuration

## Tips and Best Practices

### Polyline Preparation
- Ensure both polylines define clear boundaries for your beam distribution
- Polylines can include arcs and curves; the script calculates proper intersection points
- The script creates closing lines between polyline endpoints to define the complete boundary

### Direction Selection
- The direction you specify determines which way the beams span across the polylines
- Pick two points that clearly indicate the perpendicular direction to your beam runs
- The script projects this direction onto the XY plane (World Z) for calculations

### Distribution Planning
- For roofs with specific rafter spacing requirements, use **Fixed Distribution**
- For visual uniformity across variable spans, use **Even Distribution**
- Interdistance must be greater than 0; invalid values will delete the instance

### Dependency and Updates
- Generated beams are linked to the source polylines via dependency tracking
- Moving or editing the polylines triggers automatic recalculation
- Adjust Width, Height, or Interdistance in the Properties Palette to update all beams instantly

### Validation Messages

The script will delete itself and display a message if:
- Fewer than 2 valid polylines are selected
- The direction points are too close together or identical
- The interdistance is set to 0 or a negative value

### Working with Twisted Structures
- This tool excels at creating beams between non-parallel polylines
- Each beam is individually oriented based on its intersection points with both polylines
- Automatic end cuts are calculated where beams meet the boundary polylines
- The result is a smooth transition of beam angles across the distribution

## FAQ

**Q: What happens if I change the Width property?**
A: The script recalculates the layout. Since the beam width affects the available distribution space, increasing width may reduce the number of beams that fit.

**Q: Can I use this for curved boundaries?**
A: Yes. The script calculates intersections based on the polyline geometry, so curved or angled polylines result in beams with matching end cuts at the boundaries.

**Q: My beams disappeared after I changed a property.**
A: This typically occurs if the new settings result in zero beams fitting in the space, or if Interdistance is set to 0 or negative. Check your property values and ensure the boundary polylines remain valid.

**Q: How do I change the beam direction after insertion?**
A: Select the script instance and use the grip point to adjust the direction vector, or delete and re-insert with a new direction.
