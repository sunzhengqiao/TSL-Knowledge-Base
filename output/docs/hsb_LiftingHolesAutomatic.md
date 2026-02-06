# hsb_LiftingHolesAutomatic.mcr

## Overview
Automatically calculates and marks the optimal locations for lifting holes on a wall element based on its physical center of gravity. This ensures balanced lifting during transport by accounting for material densities, wall openings, and dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run on 3D wall elements in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: An existing Wall Element (`ElementWallSF`) containing structural beams (studs, top/bottom plates).
- **Minimum Beam Count**: 0 (Script checks existing beams).
- **Required Settings**: `Materials.xml` must exist in your `hsbCompany\Abbund` folder to provide material density for weight calculations.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_LiftingHolesAutomatic.mcr` from the catalog.

### Step 2: Configure Parameters
```
Action: A Dynamic Dialog appears (or check the Properties Palette).
Action: Adjust lifting settings (Distances, Offsets, Color) as needed for your lifting gear.
Action: Click OK to confirm.
```

### Step 3: Select Wall Elements
```
Command Line: \nSelect a set of elements
Action: Click on the wall elements you wish to process.
Action: Press Enter to complete the selection.
```
*Note: The script will attach to the selected elements and automatically calculate the hole positions.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distance between straps | Number | 1200 mm | The distance between the two lifting points on a single lifting set (e.g., width of a spreader bar). |
| Min Distance from edge of the wall | Number | 600 mm | The mandatory safety distance between the lifting hole and the nearest left or right edge of the wall. |
| Centers lifting beam hooks | Number | 600 mm | The module/spacing unit used to determine how far apart the lifting sets are placed from the center of gravity. |
| Color | Number | 4 | The CAD color index used to draw the lifting hole markers on the wall. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific custom context menu items. Use the Properties Palette to modify parameters. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `hsbCompany\Abbund` (Company folder)
- **Purpose**: Provides material density data (e.g., for wood, concrete) used to calculate the wall's physical weight and center of gravity.

## Tips
- **Automatic Updates**: If you modify the wall geometry (add/remove beams or openings) or change the wall dimensions, the script will automatically recalculate the hole positions to maintain balance.
- **Edge Safety**: The script ensures holes are never placed closer than the "Min Distance from edge," potentially switching from a 4-hole pattern to a 2-hole pattern if the wall is too short.
- **Visualizing Points**: If the calculated vertical projection misses a top plate (e.g., due to a large opening), the script automatically finds the geometrically closest top plate to ensure the marker is still drawn on valid timber.
- **Verification**: Always verify that the generated markers align with your specific crane and lifting gear configuration before machining.

## FAQ
- Q: Why did the script fail or show an error about a table?
- A: Ensure `Materials.xml` is present in your `hsbCompany\Abbund` folder. Without density data, the center of gravity cannot be calculated accurately.
- Q: Why are there 4 holes on one wall and only 2 on another?
- A: The pattern is determined by the wall length and the "Centers lifting beam hooks" parameter. Longer walls or specific spacing settings trigger the 4-hole (outrigger) pattern for better stability.
- Q: Can I move the markers manually?
- A: No. The markers are calculated based on physics. To move them, you must adjust the parameters in the Properties Palette or modify the wall structure itself, which shifts the center of gravity.