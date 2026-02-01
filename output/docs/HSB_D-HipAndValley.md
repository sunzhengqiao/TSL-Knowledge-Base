# HSB_D-HipAndValley.mcr

## Overview
Automates the dimensioning of hip and valley rafter intersections in 2D shop drawings. It calculates the precise offsets and positions of perpendicular (jack) rafters relative to the main angled beam based on your current viewport view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for detailing. |
| Paper Space | Yes | Script requires a selected Viewport to calculate dimensions. |
| Shop Drawing | Yes | Specifically designed for creating production layout drawings. |

## Prerequisites
- **Required Entities**: `GenBeam` (Rafters/Hips), `Element` (Building sections).
- **Minimum Beam Count**: At least 1 main Hip/Valley beam and 1 intersecting rafter.
- **Required Settings**: A valid Viewport must be present in the Paper Space layout.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-HipAndValley.mcr`

### Step 2: Select Viewport
```
Command Line: |Select a viewport|
Action: Click inside the viewport border where you want the dimensions to appear.
```

### Step 3: Select Position
```
Command Line: |Select a position|
Action: Click a location in the drawing to place the script instance (usually near the hip/valley to be dimensioned).
```

### Step 4: Configure Properties
After placement, select the script instance and open the **Properties Palette** (Ctrl+1). Select the **Name element section** corresponding to the roof area you wish to dimension.

## Properties Panel Parameters

### Selection Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name element section | dropdown | (empty) | Select the specific Element/Section name to dimension. |
| Filter definition for GenBeams | dropdown | (empty) | Apply a custom filter preset from `HSB_G-FilterGenBeams.mcr`. |
| Filter beams with beamcode | text | KEG-01;HRL-01 | Semicolon-separated list of Beam Codes to include (e.g., Rafters, Hips). |
| Filter beams and sheets with label or material | text | (empty) | Further filter elements by material name or label. |
| Filter zones | text | 1;7 | Restrict dimensioning to specific model zones (e.g., "1;2"). |
| Combine touching beams | dropdown | No | If **Yes**, rafters touching end-to-end are dimensioned as one continuous length. |

### Dimensioning Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcode angled beams | text | KK-01 | The Beam Code identifying the main Hip or Valley rafter (reference line). |
| Beamcode blocking | text | KS-HKS | The Beam Code for blocking/stiffeners to exclude from dimensioning. |
| Include BC | text | (empty) | Additional Beam Codes to force-include in the dimensioning. |
| Side of rafters | dropdown | Shortest side | Determines if dimension ticks are on the shortest or longest side of the rafter profile. |
| Side of angled beam | dropdown | Inside | Reference point for dimensions: Inside face, Outside face, or Extremes. |
| Side element | dropdown | Outside | Reference side of the roof element for projecting dimensions. |
| DimStyle | dropdown | Standard | The AutoCAD dimension style to use for the generated lines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Isolates the beams belonging to the current element section by graying out others. |
| Remove filter | Restores visibility of all beams in the view. |
| Recalculate | Refreshes the dimensions based on current property settings or model changes. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: hsbCAD TSL folder (Company or Install path)
- **Purpose**: Provides the list of available filter definitions used in the "Filter definition for GenBeams" property.

## Tips
- **View Orientation**: Ensure the viewport selected in Step 2 shows the roof from the correct direction (e.g., Plan view or perpendicular elevation) to get accurate intersection points.
- **Beam Codes**: If dimensions are missing, verify that the `Beamcode angled beams` matches your actual Hip/Valley beam codes in the model.
- **Combined Dimensions**: Use **Combine touching beams** set to **Yes** to avoid cluttering the drawing with small dimension segments for continuous rafters.
- **Filtering**: Use the right-click "Filter this element" option to quickly check if the script is identifying the correct set of beams before generating dimensions.

## FAQ
- **Q: I ran the script, but no dimensions appeared.**
  - **A**: Check the following:
    1. Did you select a valid Viewport during insertion?
    2. Does the "Name element section" property match an existing TSL instance name in the drawing?
    3. Do the "Filter beams with beamcode" settings actually match the codes in your model?
- **Q: The dimensions are on the wrong side of the beam.**
  - **A**: Change the "Side of angled beam" property (e.g., switch from **Inside** to **Outside**).
- **Q: The dimension line is too close/far from the beams.**
  - **A**: Adjust the "Offset dimline..." properties (not listed in table but available in the full property list) to move the dimension line away from the geometry.
- **Q: Some rafters are missing from the dimension.**
  - **A**: Check if "Beamcode blocking" is excluding a rafter by mistake, or if the "Filter zones" is restricting the area.