# hsbTileStart

Guided workflow assistant for roof tile layout and data export in hsbCAD.

## Overview

hsbTileStart is a workflow orchestration script that guides users through the complete roofscaping process. It coordinates multiple tile-related TSL scripts to apply roof tile data to roof planes and export tile quantities to Excel. The script manages the entire tile layout workflow from initial tile selection through edge definition, vertical adjustment, and optional verge/ridge tile creation.

## Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Version | 1.6 |
| Space | Model Space |
| Beams Required | 0 |

## Prerequisites

- One or more roof planes (ERoofPlane) must exist in the drawing
- An Exporter Group must be defined in `groups.xml` (script will exit with error message if none found)
- Related tile catalogs should be configured:
  - `_hsbTileGrid` catalog for tile grid settings
  - `hsbTileHipRidge` catalog for ridge/hip tile settings

## Usage

### Starting the Script

1. Launch the script via `TSLINSERT` command and select `hsbTileStart.mcr`
2. When prompted, choose one of the following options:
   - Press **Enter** to attach roof tile data to selected roof planes
   - Type **D** to open the settings dialog
   - Type **E** to export tile data to Excel

### Standard Workflow

The script guides you through a multi-step process:

**Step 1: Add Roof Tile Data**
- Select one or more roof planes when prompted
- The Roof Tile Family Selector dialog opens automatically
- Choose the appropriate tile type and configuration

**Step 2: Define Edges**
- Edges without data are highlighted in the drawing (green lines)
- Labels reading "Add edgeData" indicate edges needing definition
- Use the edge definition tools to specify edge types (eave, verge, ridge, hip)

**Step 3: Adjust Vertical Tiling**
- Once the tile grid is created, review the vertical tile spacing
- Make any necessary adjustments to optimize tile courses
- Double-click the on-screen text "Adjust vertical tiling and double click" to proceed

**Step 4: Automatic Tile Creation**
- If enabled, verge tiles are created along gable edges
- If enabled, ridge/hip tiles are created along roof intersections
- Standard and half tile quantities are calculated automatically
- The hsbTileStart instance erases itself upon completion

### Export Mode

To export tile quantities:
1. Press **E** when prompted (or launch with EXPORT key from ribbon)
2. Select the roof planes to include
3. Choose the Exporter Group
4. The script compiles quantities and exports to Excel using the roofscaping report template

## Parameters

### Settings Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create verge tiles | Selection | After adjusting tile grid | When to create verge (gable edge) tiles |
| Create ridge tiles | Selection | After adjusting tile grid | When to create ridge/hip tiles |
| Use TileGrid catalog | Selection | (first available) | Catalog for tile grid configuration |
| Use TileHipRidge catalog | Selection | (first available) | Catalog for ridge and hip tile settings |

**Verge/Ridge Options:**
- No - Do not create these tiles
- After adjusting tile grid - Create after vertical adjustment step

### Export Category

| Parameter | Type | Description |
|-----------|------|-------------|
| Exporter Group | Selection | Export template to use for tile quantity report |

## Menu Options

The script responds to keyboard input during insertion:

| Key | Action |
|-----|--------|
| Enter | Start standard tile attachment workflow |
| D | Open settings dialog for configuration |
| E | Switch to export mode for tile quantities |

### Double-Click Action

| Action | Description |
|--------|-------------|
| TslDoubleClick | Triggered by double-clicking the text "Adjust vertical tiling and double click". This finalizes the tile layout, creates ridge/verge details (if enabled), and calculates hardware quantities. |

## Settings Files

| Filename | Location | Purpose |
|----------|----------|---------|
| groups.xml | `[Company Path]\Export\catalogue\` | Company-specific exporter groups |
| groups.xml | `[Install Path]\Content\General\hsbCompany\Export\catalogue\` | Default roofscaping report template |

## Related Scripts

This script orchestrates the following tile-related scripts:

| Script | Purpose |
|--------|---------|
| `_hsbTileGrid` | Creates and manages the tile grid layout |
| `hsbTileHipRidge` | Handles ridge and hip tile placement |
| `hsbTileVerge` | Manages verge (gable edge) tile placement |
| `hsbTileLath` | Handles tile lath/batten placement (added separately) |

## Tips

- **Workflow Interruption**: If you cancel during the workflow, previously attached tile data may need to be manually cleaned. Re-running the script on the same roof planes will automatically remove old tile data before applying new settings.

- **Edge Definition Required**: All roof plane edges must have edge data defined before the tile grid can be created. Undefined edges appear as green highlighted lines with "Add edgeData" labels.

- **Special Tiles**: After the guided workflow completes, add any special tiles (ventilation tiles, snow guards, etc.) and additional lath manually to the roof plane.

- **Tile Quantities**: Standard and half tile counts are automatically calculated by summing quantities from the tile grid and subtracting tiles replaced by verge, ridge, and hip components. Final quantities are attached as hardware components to the `_hsbTileGrid-Vertical` instance.

- **Multiple Roof Planes**: You can select multiple roof planes at once. The script processes all selected planes with the same tile family and settings, making it efficient for complex roof designs.

- **Catalog Selection**: If you have multiple tile configurations saved as catalogs, use the dialog (D) option to select specific catalogs before starting the workflow.

- **Export Only**: If you only need a material list and do not want to generate 3D tile geometry, type `E` at the initial command prompt.

## FAQ

**Q: Why did my script instance disappear after double-clicking?**
A: This is normal behavior. Once the script generates the final Tile Grid and details, the hsbTileStart instance erases itself, leaving the generated tile elements behind.

**Q: What happens if I see an error about "Exporter Group"?**
A: The script cannot find `groups.xml`. Please check with your CAD Manager to ensure the Export catalogue is correctly configured in your hsbCAD environment.

**Q: Can I generate the roof tiling without the ridge and verge tiles?**
A: Yes. Set the "Create ridge tiles" and "Create verge tiles" properties to "No" in the Properties palette before double-clicking to finalize.

**Q: No roofplanes found error - what should I do?**
A: Ensure you have created roof planes using the hsbCAD roof tools before running this script. The script requires at least one ERoofPlane entity to proceed.
