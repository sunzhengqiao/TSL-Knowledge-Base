# hsbSheetDistribution

## Overview
Automates the layout and generation of sheathing sheets or Structural Insulated Panels (SIPs) over Wall or Roof elements. The tool handles complex alignment, staggering, gaps, and splits based on structural beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates physical Sheet and Sip entities in the 3D model. |
| Paper Space | No | Does not generate 2D views or annotations directly. |
| Shop Drawing | No | This is a model generation tool, not a detailing script. |

## Prerequisites
- **Required Entities**: An existing `ElementWall` or `ElementRoof` in the model.
- **Minimum Beam Count**: None (though beams are used for constraints/splitting).
- **Required Settings**: PainterDefinitions within the `hsbSheetDistribution` collection must exist in the catalog to filter structural beams.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSheetDistribution.mcr` from the file dialog.

### Step 2: Select Target Element
```
Command Line: Select Element / Sheet / Sip (<Entity> for insert):
Action: Click on a Wall, Roof, or an existing Sheet/SIP entity in the model.
```
*Note: The selection behavior depends on the 'Modus' property setting (default is Element).*

### Step 3: Define Layout Origin
```
Command Line: Specify point (<Entity> for insert):
Action: Click a point in the model to set the origin of the sheet layout grid.
```
*This point determines where the first sheet starts based on the 'Alignment' property.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sModus | Enum | Element | Defines the distribution area: 'Element' (whole wall/roof), 'Sheet/SIP' (match selected boundary), or 'Reference Axis' (align to construction lines). |
| sAlignment | Enum | Left-Top | Sets the anchor point of the layout grid (e.g., Top-Left, Center-Center) relative to the selected point or bounding box. |
| dSheetLength | Number | 2500 | The length (long side) of the sheets/panels in millimeters. |
| dSheetWidth | Number | 1250 | The width (short side) of the sheets/panels in millimeters. |
| dSheetThickness | Number | 0 | Thickness of the sheet in millimeters. Set to 0 to automatically match the host element's thickness. |
| dGapX | Number | 0 | Clearance gap between sheets in the primary direction (Length). |
| dGapY | Number | 0 | Clearance gap between sheets in the secondary direction (Width). |
| dStaggeringOffset | Number | 0 | Offset distance for alternating rows/columns to create a staggered (brick bond) pattern. |
| sPainterBeam | String | BeamGridY | Name of the Painter Definition used to find structural beams. Beams found act as cut lines or constraints for the sheets. |
| nZone | Integer | 0 | Specifies which construction zone (floor level) to apply the sheets to. 0 usually applies to the whole element or default zone. |
| sSheetOnFirstLastBeamAxis | Boolean | No | If 'Yes', outer sheets align strictly with the axis of the outermost beams rather than their faces. |
| sSheetName | String | *Empty* | Name assigned to the generated sheet entities (visible in BIM data). |
| sSheetMaterial | String | *Empty* | Material name (e.g., OSB, Plywood) applied to the sheets for rendering and reports. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the sheet layout based on changes to the host element (e.g., moved windows) or modified properties. |
| Move | (Grip Action) Allows you to drag the layout origin point to shift the entire grid of sheets interactively. |

## Settings Files
- **PainterDefinitions**: `hsbSheetDistribution`
- **Location**: hsbCAD Catalog
- **Purpose**: Stores logic filters to identify which structural beams (studs/joists) should cut or interrupt the sheet layout.

## Tips
- **Quick Adjustments**: After insertion, select the generated script instance (blue dot/grip) and drag it to slide the entire sheet layout across the wall without recalculating.
- **Cutting Around Openings**: Ensure `sPainterBeam` is set correctly. If sheets are not splitting around studs, check if the beams match the selected Painter Definition.
- **Thickness Handling**: Leave `dSheetThickness` as `0` when sheathing a frame; the script will automatically grab the wall thickness, ensuring the sheets sit flush even if wall dimensions change.

## FAQ
- **Q: How do I create a brick pattern (staggered joints) for my sheathing?**
- **A:** Set the `dStaggeringOffset` property to a non-zero value (e.g., half the sheet width) and Recalculate. This will shift every other row.

- **Q: My sheets are disappearing or not showing up.**
- **A:** Check the `dSheetThickness`. If it is set to 0 but the host element has no valid thickness, or if the calculation area is too small, sheets may not generate. Also, verify you are not in "Debug" mode (visualization only).

- **Q: Can I change the sheet size after inserting?**
- **A:** Yes. Select the script instance, change `dSheetLength` or `dSheetWidth` in the Properties palette, and choose "Recalculate" from the right-click menu.