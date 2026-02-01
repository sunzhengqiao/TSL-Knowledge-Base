# hsb_Apply Naillines to Elements

## Overview
This script automatically calculates structural nailing patterns (spacing and quantities) for Wall Elements and applies them to specific sheathing zones. It generates hardware lists for production and updates Element property sets with nailing schedules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in the Model Space and linked to a Wall Element. |
| Paper Space | No | Not designed for use in Layouts or Shop Drawings. |
| Shop Drawing | No | Does not process 2D drawing views. |

## Prerequisites
- **Required Entities:** A Wall Element (ElementWall) must exist in the model.
- **Minimum Beam Count:** 0 (Calculations are based on Element composition, not individual beams).
- **Required Settings:**
  - The Property Set definition `hsbElementNailing` must exist in your catalog.
  - Nailing hardware definitions (e.g., DuoFast, NKT) must be available in the database.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Apply Naillines to Elements.mcr`

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the Wall Element you wish to apply nailing calculations to.
```

### Step 3: Set Insertion Point
```
Command Line: Insertion point:
Action: Click in the Model Space to place the script instance. This location determines where the visual text label (if enabled) will appear.
```

## Properties Panel Parameters

Once inserted, select the script instance to view and edit the following parameters in the AutoCAD Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone 1 Settings** | | | |
| nNailYN1 | Boolean | FALSE | Enable or disable nailing calculations for Zone 1. |
| nZones1 | Integer | 0 | The index of the material layer (0-based) this zone applies to (e.g., 0 for outer sheathing). |
| dSpacingEdge1 | Double | 150 | On-center spacing (mm) for nails along the perimeter edges of the sheet. |
| dSpacingCenter1 | Double | 300 | On-center spacing (mm) for nails in the intermediate (field) area of the sheet. |
| strNailType1 | String | Other Nail Type | Select the hardware catalog entry (nail/screw) to be used for Zone 1. |
| sFilterZone1 | String | | Filter rule to exclude specific beams (e.g., trimmers) from the calculation. |
| nShowNailingDescriptionZone1 | Boolean | FALSE | Show the specific spacing schedule (e.g., "150 / 300") as text in the model. |
| **Framing Settings** | | | |
| strNailTypeFrame | String | Other Nail Type | Select the hardware used for framing connections (studs to plates). |
| **Visual Settings** | | | |
| sNailYNCNC | Boolean | FALSE | Toggle CNC visibility. If FALSE, generic "Nailing" text may appear if detailed descriptions are hidden. |

*Note: The script supports multiple zones (1-10) following the pattern above.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-run the nail quantity calculations based on the current Element geometry and property settings. |

## Settings Files
- **Property Set**: `hsbElementNailing`
- **Purpose**: This script reads and writes to this property set attached to the Element. It stores values like `Zone1_Perimeter_Nailing` and `Zone1_Intermediate_Nailing` which are used for labeling and export.

## Tips
- **Zone Indexing**: If your calculated nail quantities are zero, check if `nZones1` matches the actual material layer index of your wall. Usually, `0` is the outer layer and `1` is the inner layer.
- **Visual Feedback**: Enable `nShowNailingDescriptionZone1` to verify the spacing (e.g., "150 / 300") directly on the drawing before exporting to production.
- **Hardware Lists**: The script automatically generates `SHEETNAILING` and `FRAMENAILING` entries in the Element's hardware list for BOMs.

## FAQ
- **Q: Why is the nailing text not appearing in my model?**
  A: Check the `nShowNailingDescriptionZone1` property. If it is FALSE, the text is hidden. Also check `sNailYNCNC`; if set to TRUE, text may be suppressed for CNC purposes.

- **Q: The nail count seems incorrect.**
  A: Use the "Recalculate" option in the right-click menu. If the wall geometry changed recently, the script needs an update trigger. Also verify your `sFilterZone1` is not excluding the studs you expect to be nailed.

- **Q: Can I use this for roof elements?**
  A: This script is designed for `ElementWall`. While it may technically run on other element types, the calculations are optimized for wall sheathing patterns.