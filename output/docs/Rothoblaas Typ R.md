# Rothoblaas Typ R

## Overview
Generates 3D models and applies necessary machining (drilling, milling, cutting) for Rothoblaas Typ R adjustable post bases on selected timber beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D hardware geometry and modifies beams. |
| Paper Space | No | N/A |
| Shop Drawing | No | Generates shop drawing data (BOM) but runs in Model Space. |

## Prerequisites
- **Required Entities:** `GenBeam` (Structural Timber Beam)
- **Minimum Beam Count:** 1
- **Required Settings Files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas Typ R.mcr` from the list.

### Step 2: Select Base Family (If applicable)
- **If using a catalog preset:** The script skips this step and uses the preset type.
- **If manual insertion:** A dialog titled "Rothoblaas Typ R" appears. Select the desired Type (e.g., R10, R20) and click OK.

### Step 3: Select Beams or Point
```
Command Line: Select beam(s) or [Point]
Action: Click on the beam(s) you wish to equip with the post base.
```
*Note: You can type `P` or `Point` and press Enter to specify a custom insertion point on the beam (useful for sloped beams).*

### Step 4: Specify Point (If 'Point' selected in Step 3)
```
Command Line: Select point for base insertion
Action: Click on the beam where the base should be applied.
```

### Step 5: Insertion Complete
The script automatically generates the hardware geometry and applies the cuts, drills, and milling (if configured) to the beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| A - Type | dropdown | R10 | Selects the design variant: R10 (Flat top), R20 (Rod + Tube), R30 (Disc + Rod), R40 (Passing through). |
| B - Size | dropdown | 1 | Selects dimensions correlating to height adjustment range and plate size (1=Smallest, 3=Largest). |
| C - Mounting | dropdown | HBS+ evo | Selects the concrete anchor type (e.g., HBS+, Screw DISC, AB1, VINYLPRO, EPOPLUS). |
| D - Milled | dropdown | No | Set to "Yes" to recess (countersink) the top plate into the timber beam end. |
| E - Additional mill depth | number | 0 | Extra depth for the milling recess (in mm), added on top of the plate thickness. |
| F - Screw length bottom | number | 80 | Length of the bottom concrete anchor screw (in mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate post base | Rotates the base geometry by 90 degrees around the beam axis. (Also triggers on Double-Click). |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external XML settings files.

## Tips
- **Catalog Presets:** Create catalog entries with specific Types (e.g., R20, Size 2) to skip the initial dialog and insert directly.
- **Sloped Beams:** If inserting on a non-vertical beam, use the "Point" keyword at the command line to accurately project the base onto the beam face.
- **Milling Depth:** If the top plate is not sitting flush after setting "Milled" to "Yes", increase the "Additional mill depth" value.

## FAQ
- **Q: How do I make the top plate flush with the wood?**
- **A:** Select the script instance in the model, open the Properties palette, and set "D - Milled" to "Yes".
- **Q: Why is there a hole drilled through my beam?**
- **A:** Types R20, R30, and R40 require a through-drill for the internal threaded rod. Select Type R10 if you want a flat plate without a central through-hole.
- **Q: Can I change the anchor screw type after inserting?**
- **A:** Yes, select the instance and change the "C - Mounting" property in the Properties Palette.