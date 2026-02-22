# mepItem

## Overview

The **mepItem** script represents MEP (Mechanical, Electrical, and Plumbing) objects imported from Revit MEP or IFC sources into hsbCAD. This script serves as the visualization and data container for imported MEP components such as ducts, pipes, conduits, fittings, and equipment.

**Important**: This script is not manually inserted by users. MEP items are automatically created when a Revit MEP model is imported into AutoCAD Architecture (ACA) using the Revit MEP Converter extension.

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Beams Required | 0 |
| Version | 1.11 |
| Working Space | Model Space |

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for 3D MEP visualization |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites

Before MEP items appear in your drawing:

1. **Revit MEP Converter Extension** - Must be enabled in hsbCAD
2. **Revit MEP Model or IFC File** - The source model containing MEP components
3. **Import Process** - The model must be imported through ACA with the converter active

The Revit MEP Converter extension handles the mapping of Revit MEP objects to this TSL script during import. The script relies on internal map data (`mepdata`, `CoordSys`) provided by the import process.

## Usage

### How MEP Items Are Created

MEP items are created automatically during the Revit model import process:

1. Enable the "Revit MEP Converter" extension in hsbCAD
2. Export your MEP design from Revit or prepare your IFC file
3. Import the model into AutoCAD Architecture
4. The converter maps MEP objects to mepItem instances automatically

### Working with MEP Items

Once imported, you can:

- **Select** MEP items in Model Space to view their properties
- **Adjust visualization** using the Properties Palette (Ctrl+1)
- **Coordinate** with timber structure elements for clash detection
- **Generate dimensions** based on connector points

## Parameters

The following parameters are available in the AutoCAD Properties Palette when an MEP item is selected:

### Detail Level

| Parameter | Type | Options | Default |
|-----------|------|---------|---------|
| Detail level | Dropdown | High detail, Medium detail, Low detail | High detail |

Controls how the MEP item is displayed:

- **High detail** - Displays the full 3D solid geometry as imported from Revit. Shows the actual shape of ducts, pipes, and fittings with all geometric complexity.
- **Medium detail** - Displays simplified geometry using circular tubes or rectangular boxes based on the centerline path. Useful for reducing display complexity in large models while maintaining spatial representation.
- **Low detail** - Displays only the centerline path of the MEP component as polylines. Best for performance when viewing many MEP items simultaneously.

### Visual Style Invalid Body

| Parameter | Type | Options | Default |
|-----------|------|---------|---------|
| Visual style invalid body | Dropdown | Wireframe, Shell, Solid | Solid |

Controls how the MEP item is displayed when the original 3D body cannot be properly reconstructed:

- **Wireframe** - Shows only edges (index 0)
- **Shell** - Shows hollow surfaces without solid fill (index 1)
- **Solid** - Shows filled surfaces (index 2)

This setting only applies when the imported geometry has issues and the script falls back to face-based display.

## Menu

This script does not define custom context menu options.

## Visualization Details

### Geometry Sources

The script attempts to display MEP geometry from multiple sources in order of preference:

1. **Direct ACIS Body** - The original solid geometry from Revit (`mepdata\SimpleBody`)
2. **IFC Body** - Geometry from IFC-format imports (`source\SimpleBody`)
3. **CSG Primitives** - Constructed from cylinders (`CsgCylinder`), boxes (`CsgQuader`), or BREP (`CsgBrep`) when available
4. **Face Loops** - Individual faces rendered according to visual style setting when solid reconstruction fails
5. **Solid Lines** - Centerline-based simplified geometry with radius or width/height information
6. **Text Fallback** - Displays "MEP" label at insertion point when no geometry is available

### Coordinate System

Each MEP item maintains its own local coordinate system as defined during import. The axes are visualized at the insertion point:
- **Red (Color 1)** - X direction
- **Green (Color 3)** - Y direction
- **Blue (Color 150)** - Z direction

### Dimension Requests

The script automatically generates dimension request data based on connector points from the imported MEP data. This enables:

- Coordination dimensions between MEP and structural elements
- Distance measurements between MEP connectors
- Integration with hsbCAD dimensioning tools

Dimension requests are stored using the Revit category as the stereotype name (e.g., "Ducts", "Pipes").

## Tips

1. **Performance Optimization** - If your model becomes sluggish after importing many MEP items, select them and change **Detail level** to "Medium detail" or "Low detail" to improve display speed and navigation.

2. **Troubleshooting Display Issues** - If an MEP item shows only "MEP" text instead of geometry, the import may have failed to capture the 3D body or centerline data. Try re-importing the Revit model.

3. **Visual Style for Problems** - Change **Visual style invalid body** to "Wireframe" to better understand geometry issues when items display incorrectly.

4. **Model Coordination** - Use medium detail level during timber-MEP coordination reviews. It provides sufficient visual information while maintaining good performance.

5. **Revit Categories** - The original Revit category (Ducts, Pipes, Conduits, etc.) is preserved and used for dimension naming via the `RevitId.Category` attribute.

6. **Manual Insertion Not Recommended** - While technically possible via `TSLINSERT`, manual insertion will not produce useful geometry because the script relies on map data generated during the import process.

## FAQ

**Q: Can I insert this script manually?**

No. Manual insertion will not produce useful geometry because the script relies on internal map data (`mepdata`, coordinate system information) that is only generated during the Revit MEP Converter import process.

**Q: Why do some ducts look like simple boxes instead of complex shapes?**

The **Detail level** may be set to "Medium detail," which intentionally simplifies geometry to rectangular tubes. Change the property to "High detail" to attempt to display the original geometry. If it remains simplified, the complex data may not have been available in the import.

**Q: What happens if the imported solid is invalid?**

The script attempts multiple fallback strategies: first CSG reconstruction from primitives, then face loops based on your **Visual style invalid body** setting. In the worst case, it displays a text label "MEP" at the insertion point.

**Q: How do I improve performance with many MEP items?**

Select multiple MEP items and set their **Detail level** property to "Low detail" (centerlines only) or "Medium detail" (simplified tubes). This significantly reduces rendering complexity.
