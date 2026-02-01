# HSB_E-Insulation

## Overview
Automatically generates 3D geometry, 2D hatching, and Bill of Materials (BOM) data for insulation blocks within timber wall elements. It calculates dimensions based on the cavity formed by structural studs and applies manufacturing allowances (Brutto dimensions) for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for generating insulation geometry. |
| Paper Space | No | Not supported for direct insertion. |
| Shop Drawing | No | Geometry is generated in Model Space and visible in drawings. |

## Prerequisites
- **Required Entities**: An existing `Element` (e.g., a wall panel) must exist in the drawing.
- **Minimum Beam Count**: 0 (Insulation is based on Element geometry, not specific beams, though beams define the cavity).
- **Required Settings**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing to define which structural beams (studs) form the insulation boundaries.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-Insulation.mcr` from the list.

### Step 2: Configure Properties
**Dialog:** Script Properties
- If the script is not run via a pre-configured catalog, a properties dialog will appear automatically.
- **Action:** Set the insulation Material, Thickness, and Filter definition. Click OK to confirm.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the timber wall element(s) you wish to add insulation to.
```
- **Action:** Press Enter to finalize selection.

### Step 4: Processing
- The script automatically calculates the cavity based on the selected beams (via the Filter) and the element outline.
- It generates the 3D insulation body and assigns it to the specified Element Zone.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter definition for GenBeams** | String | (Empty) | Select the filter set (from `HSB_G-FilterGenBeams`) that identifies the studs defining the insulation cavity. |
| **Minimum distance between studs** | Number | 100.0 | Sets the minimum cavity width (mm). Gaps smaller than this will not receive insulation. |
| **Minimum volume** | Number | 7000000.0 | Sets the minimum volume (mm³). Small fragments below this size are ignored. |
| **Zone index** | Dropdown | 0 | Assigns the insulation to a specific construction layer (Zone) within the element. |
| **Element layer** | Dropdown | Zone | Sets the CAD layer (e.g., Zone, Info, Tooling) for the insulation entity. |
| **Material** | Text | Insulation | The material name used for BOM reports and weight calculations. |
| **Thickness** | Number | 250.0 | The depth/thickness of the insulation batt (mm). |
| **Start from top or bottom** | Dropdown | \|Top\| | Aligns the insulation vertically if it does not fill the full height. |
| **Brutto width** | Number | 570.0 | Manufacturing width (Netto width + compression allowance). Auto-calculated but editable. |
| **Netto width** | Number | 560.0 | The exact geometric width of the cavity. Usually read-only. |
| **Brutto length** | Number | 2520.0 | Manufacturing length (Netto length + cutting allowance). Auto-calculated. |
| **Netto length** | Number | 2500.0 | The exact geometric height of the cavity. Usually read-only. |
| **Color** | Number | 45 | The AutoCAD color index for the 3D body. |
| **Hatch pattern** | Dropdown | (Empty) | The visual hatch pattern used in section views. |
| **Scale hatch pattern** | Number | 30.0 | Scale factor for the hatch pattern. |
| **Angle hatch pattern** | Number | 45.0 | Rotation angle for the hatch pattern. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None specific* | This script relies on the standard Properties Palette for modifications. Select the insulation element and press `Ctrl+1` to edit parameters. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams`
- **Location**: Loaded in current Drawing/Catalog.
- **Purpose**: Defines which beams (e.g., "Studs", "Posts") are treated as boundaries for the insulation calculation.

## Tips
- **Brutto vs. Netto**: The script automatically calculates manufacturing sizes (Brutto) by adding allowances to the geometric sizes (Netto). For example, if the Netto length is ≤ 1200mm, it adds 10mm for cutting; if longer, it adds 20mm.
- **Filtering**: If insulation appears in the wrong locations (e.g., overlapping beams), check your `HSB_G-FilterGenBeams` settings to ensure only the correct boundary studs are selected.
- **Visualization**: Use the Hatch Pattern settings to clearly differentiate insulation types in your section views. Set the pattern to "SOLID" for a solid fill look.

## FAQ
- **Q: Why did no insulation generate in my wall?**
  **A:** Check the `Minimum distance between studs` and `Minimum volume` properties. If the gaps between your studs are too small, or the resulting volume is too low, the script will skip generation to avoid creating unusable fragments.
- **Q: How do I change the calculated width?**
  **A:** While the "Netto width" is calculated from the geometry, you can manually override the "Brutto width" in the properties panel if you require specific manufacturing dimensions.
- **Q: I see an error "GenBeams could not be filtered!".**
  **A:** Ensure the script `HSB_G-FilterGenBeams` is loaded into your drawing. The insulation script relies on it to identify the wall structure.