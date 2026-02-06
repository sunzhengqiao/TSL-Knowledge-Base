# sd_MetalPartEntity.mcr

## Overview
This script automatically generates detailed shop drawing dimensions for metal connection plates and assemblies. It creates dimensions for overall extents, internal sub-assembly contours, and drill hole positions, including specific diameter annotations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is not intended for use in the 3D model. |
| Paper Space | Yes | Executed automatically by the Shop Drawing engine during drawing generation. |
| Shop Drawing | Yes | Designed specifically to run within the shop drawing generation process. |

## Prerequisites
- **Required Entities**: Metal Part Collection (`MetalPartCollectionEnt`).
- **Minimum Beam Count**: N/A (Script targets metal parts/plates).
- **Required Settings**: None. Must be appended to the ruleset of a Multipage Shop Drawing style.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_MetalPartEntity.mcr`
*(Note: This script is typically run automatically by the Shop Drawing engine. Manual insertion is primarily for testing.)*

### Step 2: Select Entity
```
Command Line: Select Entity:
Action: Click on the Metal Part Collection entity in the drawing that you wish to dimension.
```

### Step 3: Specify Insertion Point
```
Command Line: Specify Insertion Point:
Action: Click in the drawing to place the script entity.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Chain Content Drill | dropdown | Chain Dimension | Determines what information is displayed at drill hole positions. Options: Chain Dimension, Chain Dimension with Diameter, Diameter only, Diameter only at Start. |
| Diameter Unit | dropdown | DWG Unit | Sets the unit of measurement for displayed drill diameters (e.g., mm, inch). Options: DWG Unit, m, cm, mm, in, ft. |
| Offset Dimline Contour | number | 800 | The offset distance from the metal part edge to the dimension line for internal assembly contours. Set to 0 to hide this dimension. |
| Offset Dimline Extremes | number | 1400 | The offset distance from the metal part edge to the dimension line for overall maximum extents (width/height). Set to 0 to hide this dimension. |
| Offset Dimline Drills | number | 200 | The offset distance from the metal part edge to the dimension line for drill holes. Set to 0 to hide this dimension. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Controlling Dimension Visibility**: You can toggle specific dimension lines on or off by setting their respective "Offset" properties to `0`.
- **Dimension Layering**: To prevent dimension lines from overlapping, adjust the offset values. Generally, set "Offset Dimline Drills" smallest (closest to part) and "Offset Dimline Extremes" largest (farthest from part).
- **Multiple Drill Sizes**: If the metal part contains drill holes with different diameters, the script will automatically override the "Chain Content Drill" setting to "Chain Dimension" or "Diameter only" to prevent labeling errors.

## FAQ
- **Q: Why are my drill dimension labels not showing the diameters as configured?**
  **A:** If the metal part has multiple different drill diameters, the script automatically simplifies the labeling logic. Options like "Diameter only at Start" are incompatible with mixed diameters and will be ignored in favor of safer options.
- **Q: How do I hide the overall dimensions but keep the drill dimensions?**
  **A:** Change the property `Offset Dimline Extremes` to `0`. Ensure `Offset Dimline Drills` is set to a value greater than 0 (e.g., 200).