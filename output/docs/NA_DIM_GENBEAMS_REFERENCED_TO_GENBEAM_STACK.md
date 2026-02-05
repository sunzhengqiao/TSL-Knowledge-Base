# NA_DIM_GENBEAMS_REFERENCED_TO_GENBEAM_STACK.mcr

## Overview
Automates the creation of layout dimensions in Paper Space, specifically designed to measure the length or position of GenBeams relative to a "stack" or reference group of beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script runs in the layout environment. |
| Paper Space | Yes | Requires a Viewport to be selected. |
| Shop Drawing | Yes | Used for annotating production drawings. |

## Prerequisites
- **Required Entities**: A Paper Space Layout containing a Viewport linked to an Element with GenBeams.
- **Minimum Beam Count**: 1 GenBeam within the referenced Element.
- **Required Settings**: None (Settings are managed via the Properties Panel).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_DIM_GENBEAMS_REFERENCED_TO_GENBEAM_STACK.mcr`

### Step 2: Select Viewport
```
Command Line: Select element viewport
Action: Click inside the viewport on the layout that contains the element/assembly you wish to dimension.
```

### Step 3: Configuration (Optional)
- Select the script instance in Paper Space.
- Adjust settings in the Properties Palette (Ctrl+1) if the default appearance does not meet your standards.

### Step 4: Adjust Dimensions
- **Move Dimension Lines**: Click and drag the blue grips associated with the dimension lines to reposition them manually.
- **Modify Settings**: Right-click the script instance to access context menu options for overrides or resets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimensioned entities | dropdown | All dimensioned genbeams | Defines the scope: dimensions all beams, only those in the stack, or those touching the stack. |
| Stack selection | dropdown | All stacked genbeams | Determines the logic used to group beams to act as the reference baseline. |
| Tolerance | Number | 1.0 mm | Maximum distance for beams to be considered "touching" or "stacked." |
| Text offset | Number | 2.0 mm | Visual distance between the dimension text and the dimension line. |
| Arrow size | Number | 2.5 mm | Size of the arrowheads or tick marks at the ends of dimension lines. |
| Extension line offset | Number | 1.5 mm | Gap between the beam geometry and the start of the dimension extension line. |
| CurrentLanguage | String | en-US | Sets the language for script messages (e.g., en-US, fr-CA). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit dimension properties | Opens the configuration (Properties Panel) to modify visual parameters like offsets, text size, and tolerance. |
| Add properties override for current element | Saves the current settings specifically for this Element. Future changes to global defaults will not affect this element. |
| Remove properties override for current element | Deletes element-specific settings and reverts the script to the global default settings. |
| Reset grip points for current element | Clears manual adjustments to dimension line positions and recalculates them based on the default geometry. |

## Settings Files
- **Storage**: Internal Drawing Map
- **Location**: Stored within the current AutoCAD drawing (.dwg).
- **Purpose**: Retains user preferences for global use and element-specific overrides without requiring external XML files.

## Tips
- **Use Overrides for Unique Elements**: If one wall panel requires different dimensioning offsets than the rest of the project, use "Add properties override" to handle that specific panel without affecting others.
- **Fix Grouping Issues**: If beams that should be grouped together are not being dimensioned as a single stack, try increasing the **Tolerance** parameter slightly.
- **Reset After Updates**: If the model changes significantly and dimensions look disjointed, use "Reset grip points" to snap them back to the calculated optimal positions.

## FAQ
- **Q: The script disappeared immediately after I selected a viewport.**
  **A**: This usually happens if the selected viewport is not linked to a valid Element or contains no GenBeams. Ensure you select a viewport showing a valid 3D model.
- **Q: Can I dimension beams that are not touching each other?**
  **A**: Yes. Set the **Dimensioned entities** property to "All dimensioned genbeams" to ignore the stacking logic and dimension everything in the view.
- **Q: How do I change the arrow style?**
  **A**: Currently, this script controls arrow size via the properties panel. The arrow style itself is typically determined by your current CAD dimension style standard, but this script generates specific entities that may use the style active at insertion.