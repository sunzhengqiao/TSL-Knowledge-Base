# HSB_E-NailClusters.mcr

## Overview
This script automatically calculates and generates nail clusters to attach sheathing or panels (like OSB or Plywood) to structural timber elements based on intersecting material zones. It handles complex distribution rules, edge constraints, and "no nail" exclusion zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements and GenBeams. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for drawing generation. |

## Prerequisites
- **Required Entities**: `Element` (e.g., a wall or roof panel containing the sheathing material) and `GenBeams` (the underlying structural studs or rafters).
- **Minimum Beam Count**: N/A (Depends on the construction).
- **Required Settings**:
  - Elements must have defined material zones (Material Maps) to identify the sheathing layer.
  - Optional: Catalog entries in `HSB_G-FilterGenBeams` to filter specific beam types.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse the file list and select `HSB_E-NailClusters.mcr`.

### Step 2: Configuration & Selection
```
Dialog: Properties Palette (OPM)
Action: Set initial filters, nail spacing, and offsets if desired before insertion.
```
```
Command Line: Select elements
Action: Click on the Element(s) (e.g., Wall Panels) that you want to apply the nailing pattern to.
```

## Properties Panel Parameters

### Objects to nail
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter sheets with label** | Text | "" | Filters which elements are processed based on their label property. Leave empty to process all selected elements. |
| **Zone to nail on** | Dropdown | 1 | Specifies the material zone of the element acting as the "sheet" (e.g., Zone 1 is often the outer sheathing layer). |
| **Filter definition for genbeams to nail** | Dropdown | "" | Filters the structural beams that are considered "nailable". Select a catalog entry from `HSB_G-FilterGenBeams`. |
| **Filter definition for genbeams to nail on** | Dropdown | "" | Filters the reference beams defining the surface. Select a catalog entry from `HSB_G-FilterGenBeams`. |
| **Tsl identifier** | Text | Pos 1 | Unique ID for this script instance. Change this (e.g., to "Pos 2") to allow multiple different nailing patterns on the same element. |

### Nail settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Vertical excentric offset** | Number | 0 mm | Moves the entire nail cluster up or down from the calculated center. |
| **Horizontal excentric offset** | Number | 0 mm | Moves the entire nail cluster left or right from the calculated center. |
| **Vertical offset** | Number | 12 mm | Distance from the center to place the nail (used if *Number of nails* is 2). |
| **Horizontal offset** | Number | 9 mm | Distance from the center to place the nail (used if *Number of nails* is 2). |
| **Minimum distance to sheet edge** | Number | 5 mm | Safety margin from the edge of the sheet. Nails closer than this distance will not be placed (unless fallbacks are triggered). |
| **Number of nails** | Number | 1 | Quantity of nails per cluster location (1 or 2). |
| **Minimum distance for nail distribution** | Number | 0 mm | Minimum length of intersection required to switch to distributed nailing (nails spaced along a line). |
| **Distributed nail spacing** | Number | 50 mm | Spacing between nails when distributed nailing is active. |
| **Tool index** | Number | 1 | Identifier for the nail gun/tool to be used in production/CNC files. |

### Calculation Logic
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Add nailing to extremes** | Yes/No | No | If enabled, forces nails to the extreme corners of the valid area if standard placement fails edge checks. |
| **Take center of bounding box** | Yes/No | No | Uses the bounding box center instead of the profile centroid for the calculation origin. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add no nail areas** | Prompts you to select points inside the current nail area. These points become exclusion zones (shown with hatching) where no nails will be generated. Useful for avoiding obstructions or openings. |
| **Remove no nail areas** | Prompts you to select points inside existing no-nail zones to remove the exclusion and allow nailing there again. |
| **Delete** | Removes the script instance and all associated nail clusters from the element. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: hsbCAD Company or Installation directory (Catalogs).
- **Purpose**: Defines filter logic to categorize beams (e.g., distinguishing structural studs from blocking or trimmers) to control where nails are applied.

## Tips
- **Multiple Patterns**: Use the **Tsl identifier** to apply different nailing patterns to the same wall. For example, use "Pos 1" for standard field nailing and "Pos 2" for edge nailing with tighter spacing.
- **Filtering**: If nails appear on blocking or trimmers unintentionally, use the **Filter definition for genbeams to nail** to restrict nailing to only specific structural members (like "Studs").
- **Visualizing Exclusions**: After using "Add no nail areas," the script draws hatched circles to visualize where nails are excluded.
- **Edge Failures**: If nails are missing near the edges of a sheet, try reducing the **Minimum distance to sheet edge** or enabling **Add nailing to extremes**.

## FAQ
- **Q: Why are no nails showing up?**
  - **A**: Check that the **Zone to nail on** matches the actual material zone of your sheathing. Ensure the element intersects with GenBeams physically. Verify that your filters aren't excluding all beams.
- **Q: How do I nail two different sheets on one wall differently?**
  - **A**: Run the script twice. Set the **Filter sheets with label** to match the sheet labels (e.g., "ExtWall" vs "IntWall") and give them different **Tsl identifier** values.
- **Q: Nails are too close to the edge of the board.**
  - **A**: Increase the **Minimum distance to sheet edge** value. If nails disappear, the script determined there was no valid space; try enabling **Add nailing to extremes**.