# sd_GenBeamContour.mcr

## Overview
This script automates the dimensioning of timber beams in shop drawings. It detects beam contours, drill holes, and cut-outs to generate precise dimension requests based on your configured styles and standards.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Can be inserted manually onto a beam. |
| Paper Space | Yes | Supported via the Shopdrawing engine. |
| Shop Drawing | Yes | Primarily designed to run within the Shopdrawing context. |

## Prerequisites
- **Required Entities**: 1 GenBeam (General Beam).
- **Minimum Beam Count**: 1.
- **Required Settings Files**: `mapIO_GetArcPLine.mcr` (Must be available in the hsbCAD search paths).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_GenBeamContour.mcr`

### Step 2: Select Beam
```
Command Line: Select GenBeam:
Action: Click on the timber beam you wish to dimension.
```

### Step 3: Set Reference Point
```
Command Line: Give reference point:
Action: Click in the drawing to set the insertion point for the script instance.
```

### Step 4: Configure Properties
```
Action: Select the script instance and press `Ctrl+1` to open the Properties Palette.
Adjust dimensioning settings (e.g., drill chain content, angles, arc smoothing) as required.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| ChainContentDrill | dropdown | 0 (Chain Dim) | Defines how drill holes are dimensioned. Options include: Chain Dimension, Chain + Diameter, Diameter Only, Diameter at Reference Point, or Individual Diameters (requires specific stereotypes). |
| DiameterUnit | text | DWG Unit | Sets the unit of measurement for drill diameter text (e.g., mm, in). |
| AddExtremes | Int (0/1) | 0 (No) | If set to Yes (1), adds an overall dimension line spanning the total length of the beam. |
| AddAngles | dropdown | 0 (Add) | Controls angular dimensions for cuts. Options: Add angles; Add angles but suppress nearby duplicates; Do not show angles. |
| SegmentToArcLength | Number | 5.0 | Smoothing tolerance for curved geometry (in mm). Segments shorter than this are treated as arcs. Increase this if curved dimensions look jagged. |
| ExtrProfDimMode | dropdown | 0 (Low Detail) | Sets the detail level for extrusion profiles (like I-Joists). Options: Low Detail (major points only), High Detail (all vertices), Do not show. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the dimension requests to reflect changes in beam geometry or script properties. |

## Settings Files
- **Filename**: `mapIO_GetArcPLine.mcr`
- **Location**: hsbCAD System or Company Search Path
- **Purpose**: Provides geometry processing functions required to detect and calculate arcs within the beam contour.

## Tips
- **Stereotypes for Drills**: If you select "Individual Diameter at Reference Point" for the drill chain content, ensure your Drawing Style contains specific stereotypes for each drill size (e.g., `Drill14`, `Drill20`) or verify that a default `Drill` stereotype exists as a fallback.
- **Smoothing Curves**: If you see many small, jagged dimension lines on a curved beam, increase the `SegmentToArcLength` value (e.g., from 5.0 to 10.0) to help the script recognize the smooth curve.
- **Automatic Execution**: While you can insert this script manually, it is most effective when linked to a Shopdrawing Style, where it runs automatically for every beam in the layout.

## FAQ
- **Q: Why are my drill dimensions not appearing or showing the wrong style?**
  **A:** Check the `ChainContentDrill` property. If using "Individual Diameter at Reference Point," you likely need to create specific dimension stereotypes in your Drawing Style (e.g., `Drill14`) for the script to find and use.
- **Q: The script is dimensioning every tiny facet of my curved beam as a straight line.**
  **A:** Your `SegmentToArcLength` value is too low. Increase it in the Properties Palette to force the script to interpret short segments as part of a larger arc.
- **Q: I changed the beam size, but the dimensions didn't update.**
  **A:** Select the script instance, right-click, and choose **Recalculate** to force it to process the new geometry.