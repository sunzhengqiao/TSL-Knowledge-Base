# sdUK_SIPDimensions.mcr

## Overview
This script automates the creation of detailed dimension requests for Structural Insulated Panel (SIP) shop drawings. It generates linear dimensions, drill annotations, angle dimensions, and contour measurements based on specific layout stereotypes and user configurations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Partial | Script is attached to beams in Model Space but does not generate visible geometry there. |
| Paper Space | Yes | Dimensions are generated here when the Shopdrawing Layout is processed. |
| Shop Drawing | Yes | This is the primary environment; the script is executed by the Shopdrawing engine. |

## Prerequisites
- **Required entities**: One or more `GenBeam` entities (typically representing Structural Insulated Panels).
- **Minimum beam count**: 1.
- **Required settings files**: 
  - Dependency script `mapIO_GetArcPLine.mcr` must be available in the TSL search path.
  - **Layout Definition**: Must contain the Stereotypes: "Contour", "Extremes", "Beamcut", and "Opening" (or custom names matching the script properties).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `sdUK_SIPDimensions.mcr` from the list.

### Step 2: Select Element
```
Command Line: Select GenBeam
Action: Click on the timber beam or SIP element you wish to dimension.
```

### Step 3: Set Reference Point
```
Command Line: Select point near tool
Action: Click in the 3D model to define the side or location where the dimensioning logic should originate relative to the beam.
```
*(Note: After these steps, the script is attached to the element. Actual dimensions appear when the Shopdrawing is generated.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| ChainContentDrill | dropdown | Chain Dimension | Defines the text content for chain dimensions at drill points (e.g., position only, or position + diameter). |
| DiameterUnit | dropdown | DWG Unit | Sets the unit of measurement for drill diameter annotations (mm, in, etc.). |
| AddExtremes | dropdown | No | If "Yes", adds an overall dimension line showing the total length/height of the beam. |
| AddAngles | dropdown | Add | Controls the display of angular dimensions for non-orthogonal cuts. Options include suppressing duplicate nearby angles. |
| SegmentToArcLength | number | 5 mm | Maximum length for a straight segment to be treated as an arc (smoothing tolerance). |
| ExtrProfDimMode | dropdown | Low Detail | Level of detail for dimensioning the beam's cross-section (Low, High, or None). |
| StereotypeOppositeDrill | dropdown | No | If "Yes", applies a specific stereotype to drills located on the side of the beam opposite to the current view. |
| DrawDrillCircles | text | | Configuration string to force the drawing of 2D circles for drills instead of standard machining symbols. |
| StereotypeContour | text | Contour | Assigns a specific stereotype (style/layer) to dimensions measuring the outer contour. Use '---' to suppress. |
| StereotypeExtremes | text | Extremes | Assigns a specific stereotype to overall extreme dimensions. Use '---' to suppress. |
| StereotypeBeamcut | text | Beamcut | Assigns a specific stereotype to dimensions for machining features like housings. Use '---' to suppress. |
| StereotypeOpening | text | Opening | Assigns a specific stereotype to dimensions for internal openings. Use '---' to suppress. |
| DimAnglesOffset | number | 25 mm | The offset distance from the beam edge where angular dimension lines are placed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties Palette (OPM) to configure the dimensioning parameters listed above. |
| Recalculate | Manually forces the script to re-run (useful if the beam geometry changed but the shopdrawing hasn't been regenerated yet). |

## Settings Files
- **Filename**: `mapIO_GetArcPLine.mcr`
- **Location**: TSL Search Path (Company or Install folder)
- **Purpose**: Provides logic to read arc geometry from polylines, which is necessary for accurate dimensioning of curved contours.

## Tips
- **Stereotypes matter**: Ensure your Layout Definition contains Stereotypes (e.g., "Contour", "Opening") that exactly match the values in the script properties. If they do not match, dimensions will not be visible in the generated drawing.
- **Clutter Control**: If a drawing is too busy, set `AddExtremes` to "No" or use `StereotypeOpening` set to `---` to hide specific dimension types.
- **Flipping Dimensions**: You can use the grip on the script instance in the model to move the reference point (`_Pt0`) to the other side of the beam, which may flip the dimension side in the layout.

## FAQ
- **Q: Why don't I see dimensions immediately after inserting the script?**
  **A:** This is a Shopdrawing script. Dimensions are generated when you create or update the Shopdrawing Layout (Paper Space), not directly in the Model Space.
- **Q: My drill holes are not dimensioning.**
  **A:** Check the `ChainContentDrill` property. If it is set to "Suppress Drill Dimensions", no drill annotations will be created.
- **Q: How do I change the unit for hole sizes only?**
  **A:** Use the `DiameterUnit` property. This allows you to display hole diameters in a different unit (e.g., inches) than the rest of the drawing.