# NA_DIM_GENBEAM_EDGES_TO_REFERENCE.mcr

## Overview
This script automates the dimensioning of General Beam (GenBeam) edges within a Paper Space viewport. It calculates dimensions relative to reference outlines and allows interactive adjustment via grip points directly in the drawing layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Layouts. |
| Paper Space | Yes | This is the primary environment. |
| Shop Drawing | Yes | Works specifically with viewports linked to 3D Elements. |

## Prerequisites
- **Required Entities**: A Paper Space Layout containing a Viewport linked to a valid 3D Element (containing GenBeams).
- **Minimum Beam Count**: 0 (but at least one GenBeam must exist in the element to be dimensioned).
- **Required Settings**: The script requires configuration via a Property Map ('UserSelectedValues') accessible through the context menu after insertion.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_DIM_GENBEAM_EDGES_TO_REFERENCE.mcr`

### Step 2: Select Viewport
```
Command Line: Select element viewport
Action: Click on the viewport in the current layout that displays the 3D element you wish to dimension.
```

### Step 3: Configure Properties (If First Run)
```
Action: Since no configuration exists initially, right-click the new script instance and select "Edit dimension properties".
```
*Note: You must select which GenBeams to dimension and set offsets here for dimensions to appear.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | Standard OPM properties are not used for this script. All configuration is handled via the Right-Click Context Menu. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Edit dimension properties** | Opens a configuration dialog to select which GenBeams to dimension, set text styles, and define offset distances. Updates the global settings map. |
| **Add properties override for current element** | Saves the current configuration specifically for the Element handle currently linked to the script. This allows different elements to have different dimension settings in the same drawing. |
| **Remove properties override for current element** | Deletes the element-specific settings, causing the script to revert to the global default settings for this element. |
| **Reset grip points for current element** | Clears the saved positions of dimension grips, allowing you to re-snap them to default edges. |

## Settings Files
- **Internal Map**: `UserSelectedValues` (Global) and `UserSelectedValues~<ElementHandle>` (Overrides).
- **Location**: Stored within the drawing data.
- **Purpose**: Saves user preferences for which beams to dimension, layer styles, and specific grip point locations.

## Tips
- **Grip Point Editing**: After dimensions are drawn, you can click and drag the blue grip points. The script will automatically snap the dimension to the nearest edge of the associated GenBeam.
- **Element Specifics**: Use the "Add properties override" option if you have one detail view that requires larger dimension text or different offsets than the rest of your drawing.
- **Viewport Linking**: Ensure the viewport you select during insertion is actually looking at a 3D hsbCAD Element. If the script vanishes immediately, it usually means the viewport content was invalid.

## FAQ
- **Q: The script erased itself immediately after insertion.**
  - **A:** This usually means you selected a viewport that does not contain a valid 3D Element, or the Element is empty. Ensure the viewport is correctly linked to a model with GenBeams.

- **Q: The script inserted, but I don't see any dimensions.**
  - **A:** By default, the script does not know which beams to dimension. Right-click the script instance, choose "Edit dimension properties", and select the GenBeams you wish to include in the "Genbeams to dimension" list.

- **Q: Can I use this in Model Space?**
  - **A:** No, this script is explicitly designed for Paper Space (Layouts) to dimension 2D projections of 3D elements.