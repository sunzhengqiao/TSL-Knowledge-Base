# mapIO_GetArcPLine.mcr

## Overview
This script converts jagged, segmented polylines into smooth geometry by replacing short linear segments with true arcs. While primarily used as a utility function by other scripts (mapIO), it can be manually inserted to optimize roof curves or wall plates created from point clouds or digitized data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on generic Entity geometry (EntPLine). |
| Paper Space | No | Not designed for Paper Space layout. |
| Shop Drawing | No | Not a Shop Drawing script. |

## Prerequisites
- **Required Entities**: A Polyline (PLine) with straight segments.
- **Minimum Beam Count**: 0 (This script works on 2D geometry, not beams).
- **Required Settings**: None.
- **Installation**: Must be saved in the `<hsbCompany>\TSL` path to function correctly when called by other scripts.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `mapIO_GetArcPLine.mcr` from the file dialog.

### Step 2: Configure Properties
```
Command Line: [None / Properties Palette opens]
Action: Adjust the "max Segment Length" in the Properties Palette if necessary, then close the palette or click in the drawing area to proceed.
```

### Step 3: Select Polyline
```
Command Line: Select Entity:
Action: Click on the polyline you wish to process.
```

### Step 4: Select Reference Point
```
Command Line: Select Point:
Action: Click a point in the drawing to define the insertion reference (this is used for script positioning/updates).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| max Segment Length | Number | 5.0 (mm) | The threshold length to determine if a segment is part of a potential arc. Segments shorter than this are checked to see if they form a curve; longer segments are treated as straight lines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Straight Segments Only**: The script will fail if the input polyline already contains bulges (curved segments). Explode or simplify existing curves before using this script.
- **Vertex Count**: The polyline must have more than 4 vertices for the arc detection logic to process. Simple shapes (rectangles) will be ignored.
- **Sensitivity**: If arcs are not being detected where you expect, increase the `max Segment Length`. If straight lines are being incorrectly turned into curves, decrease it.
- **Script Path**: Ensure the file is saved in `<hsbCompany>\TSL` so that other scripts can find and use it as a utility function.

## FAQ
- **Q: Why did the script fail to convert my polyline?**
  **A:** Check if your polyline contains existing bulges (curved segments). This script only accepts polylines composed entirely of straight line segments.
- **Q: The script ran, but the geometry didn't change.**
  **A:** Ensure your polyline has more than 4 vertices. Additionally, check the `max Segment Length` setting; your segments might be too long to be considered candidates for arc conversion.
- **Q: How does this script differ from standard PEDIT?**
  **A:** This script is specifically designed for hsbCAD data flow (mapIO). It not only creates the geometry but also generates a data map of the detected arcs (centers, chords) which other scripts can use for dimensioning or processing.