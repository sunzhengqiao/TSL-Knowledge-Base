# hsbCenterOfGravity.mcr

## Overview
Calculates and annotates the Center of Gravity (COG) and total weight of timber beams, panels, or assemblies. It is primarily used for logistics planning and determining lifting points on construction elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Calculates based on the actual 3D geometry. |
| Paper Space | Yes | Automatically transforms coordinates for viewports. |
| Shop Drawing | Yes | Integrates with Shop Drawing Views (SDV) for production drawings. |

## Prerequisites
- **Required entities:** GenBeam, Element, or 3DSolid.
- **Minimum beam count:** 1 (The script must be attached to a single element to calculate its properties).
- **Required settings:**
  - `hsbMaterialTable.dll` (loaded by hsbCAD).
  - `materials.xml` (Must contain valid density values for the materials used in the element).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCenterOfGravity.mcr` from the list.

### Step 2: Select Element
```
Command Line: Select Element/Beam:
Action: Click on the timber wall, roof panel, or beam you wish to analyze.
```

### Step 3: Configure Insertion
```
Command Line: Specify insertion point or [Properties]:
Action: Click in the drawing to place the script reference.
```
*Note: The COG marker will automatically snap to the calculated center of gravity; the insertion point only determines the script's reference location.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sText | String | @(Weight) kg | The text label template displayed next to the COG. Use `@(Weight)` to insert the calculated value dynamically. |
| sDimStyle | String | mm-2 | The dimension style used to format the offset measurements (e.g., precision and units). |
| dTextHeight | Double | 2.5 | Height of the annotation text in drawing units (mm). |
| dThisSize | Double | 10.0 | Physical size of the COG symbol (circle or rhombus diameter). |
| bDrawCircle | Boolean | true | If true, draws a circular marker with crosshairs at the COG. |
| bDrawRhomb | Boolean | false | If true, draws a rhombus (diamond) marker at the COG. |
| bAddCoordinate | Boolean | false | If true, adds dimension lines showing the X and Y offset from the COG to the element edges. |
| nTransparency | Integer | 0 | Transparency level of the filled COG symbol (0 = Solid, 100 = Invisible). |
| nColor | Integer | 1 | Color of the COG symbol and text (1 = Red, based on AutoCAD Color Index). |
| bShowDependecies | Boolean | false | Debug mode. If true, draws lines connecting the COG to the center of all sub-components included in the calculation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the COG position and weight if the element geometry or material properties change. |
| Edit Properties | Opens the script properties in the palette to adjust text, size, or visual settings. |

## Settings Files
- **Filename**: `materials.xml`
- **Location**: `hsbCAD\Company` or `hsbCAD\General` folder.
- **Purpose**: Defines the density (kg/m³) for different wood grades. The script calculates weight based on the material assigned to the beam/element volume.

## Tips
- **Zero Weight?:** If the script calculates `0 kg`, check if the material assigned to the element has a density defined in the `materials.xml`.
- **Custom Labels:** You can customize the `sText` parameter to include element names, e.g., `Wall @(ElementName): @(Weight) kg`.
- **Visual Clarity:** In crowded shop drawings, enable `nTransparency` or change `nColor` to ensure the COG marker is visible but does not obscure critical joinery details.

## FAQ
- **Q: Can I use this script to calculate the weight of an entire house assembly?**
- **A:** This script is designed to calculate the COG of the specific element it is attached to (e.g., one wall panel). To calculate a full assembly, you would typically use a different aggregate tool or attach the script to a top-level assembly element.
- **Q: Why does the marker appear in the wrong place in a Layout viewport?**
- **A:** Ensure the viewport is active and the script is associated with the element visible in that view. The script attempts to transform coordinates automatically, but extreme rotations or non-standard UCS settings may require a manual Recalculate.
- **Q: What is the difference between Circle and Rhombus markers?**
- **A:** This is purely cosmetic. Use different markers to distinguish between different calculation methods or phases if required by your engineering standards.