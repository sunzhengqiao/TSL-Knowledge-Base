# HSB_E-TimberPercentageArea.mcr

## Overview
This script calculates and visualizes the percentage of a specific planar area (defined by a polyline boundary) that is occupied by structural timber. It is useful for verifying solidity ratios, insulation coverage, or material density within a wall, floor, or roof element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script attaches to an Element and generates 3D/planar geometry. |
| Paper Space | No | Not designed for layout generation. |
| Shop Drawing | No | Not designed for manufacturing views. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: The element must contain beams to calculate a percentage.
- **Required Settings**:
  - A valid **Painter Definition** (to filter beams).
  - **Hatch Patterns** (if hatching is enabled).
  - **Dimension Styles** (for text display).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_E-TimberPercentageArea.mcr`.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the Wall, Floor, or Roof element you wish to analyze.
```

### Step 3: Define Analysis Zone
```
Command Line: Select Polylines (for profile):
Action: Select one or more closed polylines that represent the area boundary you want to analyze.
Note: Press Enter to confirm selection after picking the polylines.
```

### Step 4: Configure Properties
Action: The Properties Palette (OPM) will open. Adjust parameters like the Painter filter, visual layers, and depth of calculation as needed. The script will automatically update based on these changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sPainter** | String | \|Beam Painter Filter\| | Selects which beams are included in the calculation (e.g., only structural wood, excluding metal plates). |
| **sProfile** | String | \|PLINE\| | A unique name/ID for this specific analysis area. Used to store data in Element properties. |
| **dDepth** | Double | - U(1) | The distance from the element origin to slice the calculation plane. Use a negative value (e.g., -1) to automatically center the slice on the element thickness. |
| **sDimensionStyle** | String | _DimStyles | The visual style (font, size) used for the percentage text label. |
| **iColor** | Integer | -1 | The color index (ACI) for the boundary line and text. |
| **sTextLayer** | String | Information | The CAD layer on which the percentage text is generated. |
| **sBodyLayer** | String | Zone | The CAD layer on which the boundary profile (outline) is generated. |
| **sShowPlaneProfile** | Enum | \|No\| | Set to \|Yes\| to display the outline of every individual beam included in the calculation. |
| **sShowHatch** | Enum | \|No\| | Set to \|Yes\| to hatch the areas covered by timber. |
| **hatchPattern** | String | _HatchPatterns | The pattern name (e.g., SOLID, ANSI31) used for hatching. |
| **patternScale** | Double | U(1) | The scale factor for the hatch pattern. |
| **hatchColor** | Integer | -1 | The color index for the hatch pattern. |
| **hatchZone** | Integer | 0 | The hsbCAD display zone (0-8) for the hatch entities. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Reset Grips** | Discards any manual modifications made to the analysis zone shape (via dragging) and restores it to the original polyline shape defined during insertion. |

## Settings Files
This script references standard hsbCAD definitions by name. Ensure the following exist in your project:
- **Painter Definitions**: To categorize beams (e.g., "StructuralWood").
- **Hatch Patterns**: Standard AutoCAD/hsbCAD patterns for visual representation.
- **DimStyles**: Text styles for labeling.

## Tips
- **Auto-Center Depth**: If your wall or floor has varying thickness, set `dDepth` to a negative value (like `-1`). This ensures the calculation plane is automatically sliced through the center of the element geometry.
- **Filtering Beams**: Use the `sPainter` parameter to ignore non-structural components (like hardware or cladding) so your percentage reflects true timber coverage.
- **Interactive Updates**: After insertion, you can select the generated boundary and drag its **Grips** to reshape the analysis area. The percentage will recalculate automatically.
- **Visual Verification**: If the percentage seems low, turn on `sShowPlaneProfile` to visually verify which beams are actually being intersected by your calculation depth.

## FAQ
- **Q: Why does my percentage show 0%?**
  - A: Check your `dDepth`. If the calculation plane is above or below the element, it won't intersect any beams. Also, verify that your `sPainter` filter is actually matching the beams in the element.
- **Q: Can I analyze multiple separate areas in one element?**
  - A: Yes. Insert the script multiple times on the same element, providing a unique `sProfile` name for each instance (e.g., "Zone Left" and "Zone Right").
- **Q: How do I hide the hatch but keep the percentage text?**
  - A: Set `sShowHatch` to \|No\|. The text and boundary are controlled separately by the `sTextLayer` and `sBodyLayer` parameters.