# HSB_T-SetGrainDirection.mcr

## Overview
This script automatically calculates and assigns the wood grain direction for sheet goods (panels) based on their alignment with structural elements or their own geometry. It ensures correct data for manufacturing exports (CNC) and can optionally physically flip sheets to match the element's view side.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on sheets in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Sheets (Panels). If aligning to elements, valid Element entities must be assigned to the sheets.
- **Required Settings**:
  - Property Set `hsbGeometryData` must be present in the drawing.
  - TSL script `HSB_G-FilterGenBeams` must be loaded if using the filter definition option.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-SetGrainDirection.mcr`

### Step 2: Configure Properties (Optional)
Before or after insertion, open the **Properties Palette (Ctrl+1)** to configure settings:
- Set **Filter definition sheets** to limit processing to specific groups (optional).
- Set **Align grain direction** to define how the grain is calculated (e.g., along the Element X-axis).
- Set **Set Z axis from Element** to `Yes` if you want the script to physically flip the sheet geometry to match the element's view side.

### Step 3: Select Sheets
```
Command Line: Select sheets
Action: Click on the sheets you wish to process and press Enter.
```
*Note: The script will automatically filter this selection based on the "Filter definition sheets" property if one is set.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition sheets | dropdown | "" | Select a predefined filter group. Use `HSB_G-FilterGenBeams` to create these filters. Leave empty to process manually selected sheets. |
| Align grain direction | dropdown | \|None\| | Defines the reference axis for the grain direction.<br>Options: \|None\|, \|Element\| X, \|Element\| Y, \|Sheet\| X, \|Sheet\| Y. |
| Set Z axis from Element | dropdown | \|No\| | If set to \|Yes\|, the script replaces the original sheet with a mirrored version if the sheet's view side opposes the element's view side. If \|No\|, it only sets a property flag. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific items to the entity right-click menu. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams`
- **Location**: TSL Catalog / drawing references.
- **Purpose**: This script provides the filter definitions used in the "Filter definition sheets" dropdown parameter.

## Tips
- **Element Assignment**: Ensure your sheets are correctly assigned to structural elements (beams/walls) if you choose to align grain direction based on "Element" axes. Unassigned sheets will be skipped.
- **Geometry Replacement**: When using "Set Z axis from Element" = Yes, the script physically creates a new sheet and erases the old one. This updates the GUID, which may affect references in external lists if they are not updated.
- **Exporters**: This script updates the `hsbGeometryData` property set and the `GrainDirection` map, which are commonly read by CNC exporters to orient panel textures or cuts correctly.

## FAQ
- **Q: I get an error "Sheets could not be filtered!"**
  A: Ensure the TSL script `HSB_G-FilterGenBeams` is loaded in your drawing. Alternatively, clear the "Filter definition sheets" property to process your manual selection.
- **Q: Why were some of my sheets skipped?**
  A: If "Align grain direction" is set to Element X or Y, sheets that are not assigned to a valid Element will be skipped.
- **Q: What happens if the grain direction is set to "None"?**
  A: The script will run geometric checks (like Z-axis flipping) but will not calculate or update the grain direction properties.