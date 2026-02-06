# hsbTileSingle.mcr

## Overview
This script calculates the precise layout, geometry, and quantity of roof tiles or slates based on roof plane geometry and lath positions. It provides 3D visualization of the covering layer and generates material counts for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D bodies and 2D geometry on the roof plane. |
| Paper Space | No | Not designed for paper space detailing. |
| Shop Drawing | No | This is a modeling/scripting tool, not a shop drawing generator. |

## Prerequisites
- **Required Entities**:
  - `ERoofPlane` (Roof Plane entity defining the boundary and slope).
  - `GenBeam` (Beams representing the laths/battens).
  - `ElementRoof` (Optional, used to auto-detect laths).
- **Minimum beam count**: 0 (Script will prompt if laths are missing).
- **Required settings**: A valid `DimStyle` must exist in the drawing for dimension labels.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbTileSingle.mcr` from the file list and click **Open**.
*Result: The configuration dialog appears automatically on first insertion.*

### Step 2: Configure Initial Properties
Dialog: Configuration Dialog
Action: Set visual preferences (Display mode), Group name, and Extensions. Click **OK**.
*Note: You can also change these later in the Properties Palette.*

### Step 3: Assign Roof Plane
Command Line: (Right-click on the script instance in the model)
Menu: Select `Assign roofplane`
Action: Click on the desired `ERoofPlane` entity in your model.
*Result: The script establishes the primary work surface and coordinate system.*

### Step 4: Append Laths
Command Line: (Right-click on the script instance)
Menu: Select `Append roof laths`
Prompt: `Select a set of laths`
Action: Select the `GenBeam` entities that represent the laths and press **Enter**.
*Result: The script calculates tile spacing based on these laths.*

### Step 5: (Optional) Append Roof Elements
Command Line: (Right-click on the script instance)
Menu: Select `Append roof elements`
Action: Select an `ElementRoof` entity.
*Result: The script scans the element for internal laths automatically.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sDisplay | dropdown | Tile grid + visible width | Controls what is visualized: Grid lines, Visible Width, or both. |
| sGroup | text | *Empty* | Assigns the script instance to a specific catalog group in the project tree. |
| dHipValleyExt | number | 30 | Extension distance (mm) beyond the roof edge (hips/valleys) to ensure coverage. |
| dDeltaL | number | 0 | Left offset (mm). Shifts the tile grid start position horizontally. |
| dDeltaR | number | 0 | Right offset (mm). Shifts the tile grid end position horizontally. |
| sDimStyle | string | _DimStyles | Specifies the dimension style used for labeling tile widths. |
| nColor | number | 252 | CAD Color Index for the generated tile lines and text. |
| sAutoUpdate | enum | Yes | If "Yes", the script recalculates automatically when geometry changes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Assign roofplane | Links the script to a specific Roof Plane to define the boundary and slope. |
| Append roof laths | Allows manual selection of lath beams to define the tile layout. |
| Append roof elements | Attaches a roof element, automatically scanning it for laths. |

## Settings Files
- **Filename**: N/A (Uses Drawing Settings)
- **Location**: Current DWG
- **Purpose**: The script relies on the DimStyles defined within the current AutoCAD/hsbCAD drawing rather than an external XML file.

## Tips
- **Adjusting Alignment**: If the tile grid does not align perfectly with your roof edges (e.g., at the gable), adjust the `dDeltaL` or `dDeltaR` properties slightly rather than moving the laths.
- **Performance**: In large models, setting `sDisplay` to "Tile grid" (lines only) instead of "Tile grid + visible width" can improve regen performance.
- **Troubleshooting**: If you see a warning box on the roof, ensure you have selected valid laths. The script cannot calculate tiles without them.

## FAQ
- **Q: Why do I see a warning box on my roof?**
  **A**: The script could not find any laths (`GenBeam` entities) attached to it. Use the "Append roof laths" or "Append roof elements" right-click option to assign them.

- **Q: How do I change the tile width or height?**
  **A**: This specific script relies on the positions of the laths to determine layout. To change the tile exposure, adjust the spacing of your lath beams.

- **Q: The dimensions are too small to read.**
  **A**: Change the `sDimStyle` property to a dimension style with larger text settings defined in your drawing.