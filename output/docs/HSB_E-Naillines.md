# HSB_E-Naillines

## Overview
Automatically generates nailing patterns (NailLines) on timber frame elements (walls, floors, or roofs) to attach sheathing or boarding. It calculates tooling paths based on structural beams, sheeting zones, and specific spacing requirements for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for layout drawings. |
| Shop Drawing | No | This script generates 3D tooling data, not 2D annotations. |

## Prerequisites
- **Required Entities**: 
  - Elements (Wall, Floor, or Roof).
  - Sheets/Sheathing material assigned to a specific Zone within the element.
  - Structural Beams or GenBeams within the element.
- **Minimum Beams**: 0 (Script runs on elements; if no beams match filters, no nails are generated).
- **Required Settings Files**: 
  - `HSB_G-FilterGenBeams` (Optional, used for beam filtering).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_E-Naillines.mcr`.

### Step 2: Configure Properties
1. The Properties Palette (OPM) will appear upon insertion.
2. Set your desired parameters (see **Properties Panel Parameters** below).
3. Click OK or close the palette to proceed.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall, Floor, or Roof elements you want to process. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically calculate and insert nail lines into the selected elements based on the configuration. The script instance will then remove itself, leaving only the generated tooling.

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply tooling to element type(s) | dropdown | | Choose which element types to process (Roof, Floor, Wall, or combinations). |
| Apply nailing to | dropdown | Zone 2 | Select the material layer (Zone) to apply the nailing to (e.g., external sheathing). |
| Filter definition genbeams | dropdown | | Select a predefined filter to target specific beams (e.g., only studs). |

### Filters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beams with beamcode | text | | Enter a beam code to filter (supports wildcards like `R*`). |
| Filter beams and sheets with label | text | | Only process beams/sheets matching this specific label. |

### Tooling
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Toolindex | number | 10 | The ID of the nail gun/fastener to be used in production. |
| Perimeter nail spacing | number | 100 | Spacing between nails along the outer edges of the sheet (mm). |
| Intermediate nail spacing | number | 200 | Spacing between nails in the interior/field of the sheet (mm). |
| Minimum distance to t-connection | number | 10 | Clearance from T-connections (intersections) before placing a nail (mm). |
| Minimum allowed length of nail line | number | 150 | Shorter nail lines than this value will be deleted (mm). |
| Apply nailing per sheet | dropdown | Yes | If Yes, nails stop at sheet joints. If No, nails may run continuously across joints. |
| Minimum distance to sheet edge | number | 0 | Required distance from a sheet joint before placing a nail (mm). |
| Apply naillines in area smaller then minimum distance | dropdown | No | If Yes, allows nails even if they violate the edge distance rule. |
| Apply intermediate naillines | dropdown | Yes | If No, only perimeter nails are generated; field nailing is skipped. |

## Right-Click Menu Options
No custom right-click menu options are available for this script.

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.xml` (or similar catalog name)
- **Location**: Company or Install path (Catalogs)
- **Purpose**: Stores predefined filter sets to select specific groups of beams (e.g., "StudsOnly", "Rafters").

## Tips
- **Sheeting Zones**: Ensure your elements actually have material assigned to the Zone selected in "Apply nailing to" (e.g., Zone 2). If the zone is empty, no nails will be generated.
- **Edge Handling**: If you need nailing right up to the edge of a sheet, set "Minimum distance to sheet edge" to 0.
- **Performance**: When processing large projects, use the "Filter definition genbeams" or "Filter beams with beamcode" to limit the calculation to structural members only, avoiding unnecessary calculations on trimmers or blocking.
- **Regeneration**: Since this script erases itself after running, you must delete the generated nail lines and run the script again to change the pattern.

## FAQ
- **Q: Why did the script run but no nails appeared?**
  - A: Check the "Apply tooling to element type(s)" setting. If you selected "Wall" but clicked a "Floor" element, nothing will happen. Also, verify that the selected Zone (e.g., Zone 2) actually contains sheets in that element.
- **Q: Can I nail through multiple sheets at once?**
  - A: No, this script targets a specific Zone. You must run the script separately for each Zone you want to nail.
- **Q: What happens if I change a beam's position after running the script?**
  - A: The nail lines will not automatically update because the script instance deletes itself after generation. You must delete the old nail lines and re-run the script.