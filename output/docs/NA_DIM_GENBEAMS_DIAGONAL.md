# NA_DIM_GENBEAMS_DIAGONAL

## Overview

| Property | Value |
|----------|-------|
| Script Name | NA_DIM_GENBEAMS_DIAGONAL |
| Type | Object (O) |
| Version | 0.1 |
| Category | Shop Drawing / Dimensioning |
| Purpose | Creates diagonal dimension lines for GenBeams (general beams) in shop drawing viewports |

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | No |
| Paper Space | Yes |
| Shop Drawing | Yes |
| Element Viewport | Required |

## Description

This script creates diagonal dimension annotations for beams and sheets in element viewport shop drawings. It can be used as a standalone dimensioning tool or linked to a parent `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE` TSL to inherit dimension line direction and starting point.

The script calculates diagonal dimensions by:
1. Extracting beam/sheet outlines at the specified zone
2. Joining outlines into a unified profile
3. Finding extreme edges based on sorting direction
4. Creating a diagonal dimension line between identified points

## Usage Workflow

1. **Insert the TSL**: Run the script in a Paper Space viewport
2. **Select Viewport** (Option A): Click to select an element viewport containing beams to dimension
3. **Or Link to Parent TSL** (Option B): Select an existing `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE` instance to inherit its dimension direction
4. **Configure Properties**: Use the Properties Panel (OPM) to adjust dimension options, beam filtering, and styling
5. **Position via Grip Point**: Drag the dimension line grip point to adjust positioning if needed

## Properties Panel Parameters

### Dimension Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sort edges in direction | Selection | Longest side of bounding box | Direction used to identify extreme edges for diagonal calculation. Options: Vertical, Horizontal, Longest side of bounding box, Shortest side of bounding box, From viewport side TSL |
| Diagonal to dimension | Selection | Longest diagonal | Which diagonal to measure. Options: Shortest diagonal, Longest diagonal |

### Beams/Sheets to Dimension

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element zone | Selection | Zone 0 | Zone containing beams/sheets to dimension. Zone 0 = inside element container. Zones 1-5 = front/top of container, Zones -1 to -5 = back/bottom of container |
| Include filter | Selection | None | Painter definition (GenBeam type) to include specific beams. Applies as addition filter |
| Exclude filter | Selection | None | Painter definition (GenBeam type) to exclude specific beams. Applies as subtraction filter after include filter |

### Dimension Style and Positioning

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension line offset | Double | 0 | Offset distance from dimensioned points in paper space units. Set >0 to move dimension line away from measured object |
| Project points to dimension line | Selection | No | If Yes, projects dimensioned points onto dimension line. If No, draws extension lines from points to dimension line |
| Dimension style | Selection | NA Shopdrawing | AutoCAD dimension style to apply |
| Text height | Double | 0 | Override dimension text height in paper space units. Set >0 to override style default |
| Text side | Selection | Above dimension line | Position of dimension text relative to dimension line. Options: Above dimension line, Below dimension line |
| Text orientation | Selection | Parallel | Text orientation relative to dimension line. Options: Parallel, Perpendicular |

## Context Menu Options

| Option | Description |
|--------|-------------|
| Edit dimension properties | Opens the properties dialog to modify dimension settings |
| Add properties override for current element | Creates element-specific property overrides |
| Remove properties override for current element | Removes element-specific property overrides |
| Reset grip points for current element | Resets manually adjusted grip point positions |

## How It Works

### Edge Sorting Logic

The script determines which edges to use for diagonal calculation based on the "Sort edges in direction" setting:

- **Vertical/Horizontal**: Uses layout Y or X axis in model space
- **Longest/Shortest side of bounding box**: Automatically detects bounding box orientation
- **From viewport side TSL**: Inherits direction from linked parent TSL (requires prior selection of `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE`)

### Beam Filtering

1. First, beams are collected from the specified element zone
2. If Include filter is set, only beams matching the Painter Definition are kept
3. If Exclude filter is set, matching beams are removed from the result

### Outline Processing

- Individual beam outlines are extracted by projecting to the viewport plane
- Outlines are joined into a single profile with smoothing
- Extreme edges are identified based on sorting direction
- Diagonal is calculated between first and last edge endpoints

## Tips and Best Practices

1. **Link to Parent TSL**: For consistent dimensioning across multiple viewports, link this script to `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE` to inherit dimension direction

2. **Zone Selection**: Use Zone 0 for main element beams. Use positive zones (1-5) for beams at the front/top and negative zones (-1 to -5) for beams at the back/bottom of the element container

3. **Filtering Strategy**: Use Include filter to dimension only specific beam types (e.g., studs only), then use Exclude filter to remove unwanted members (e.g., headers or sills)

4. **Text Positioning**: For diagonal dimensions, "Above dimension line" typically provides better readability when the dimension line slopes upward left-to-right

5. **Grip Point Adjustment**: After initial placement, use grip points to fine-tune the dimension line position without changing properties

6. **Element Overrides**: When the same viewport is used for multiple elements, create element-specific overrides to customize dimension settings per element

## Related Scripts

- **NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE**: Parent script that can provide dimension direction reference
- **NA_DIM_GENBEAM_EDGES_TO_REFERENCE**: For reference-based dimensioning
- **NA_DIM_GENBEAMS_REFERENCED_TO_GENBEAM_STACK**: For stacked beam dimensioning

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 0.16 | 2023-10-03 | Added option to pack dimensioned beams/sheets to reduce the amount of points to dimension |
| 0.15 | 2023-09-26 | Corrected closest edge point detection |
| 0.14 | 2023-09-25 | Fixed bug with middle point |

## Language Support

This script supports the following languages:
- English (en-US)
- French Canadian (fr-CA)
