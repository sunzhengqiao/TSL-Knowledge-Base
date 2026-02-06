# sd_DrillDE.mcr

## Overview
Generates detailed dimensions and annotations for drill holes on timber beams within shop drawings. It supports various display styles (European, Japanese) and offers extensive control over how hole diameter, depth, and location are dimensioned.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for shop drawings. |
| Paper Space | Yes | Executes within the Shopdrawing engine layout. |
| Shop Drawing | Yes | Primary usage context via rulesets. |

## Prerequisites
- **Required Entities**: A `GenBeam` (Timber Beam) with drilling operations applied.
- **Minimum Beam Count**: 1.
- **Required Settings**: Must be configured within a Shopdrawing Style (Ruleset) to run automatically.

## Usage Steps

This script is typically executed automatically by the hsbCAD Shopdrawing engine. However, it can be inserted manually for testing or configuration setup.

### Step 1: Launch Script (Manual Insert)
Command: `TSLINSERT` → Select `sd_DrillDE.mcr` from the list.

### Step 2: Select Beam
```
Command Line: Select beam:
Action: Click on the timber beam you wish to dimension.
```

### Step 3: Select Reference Point
```
Command Line: Give a point near the tool:
Action: Click a point close to the drill holes on the selected beam.
Action: The script will attach to the beam and wait for the Shopdrawing engine to calculate views.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| showIndividualAxisOffset | Int | 0 | Shows a specific dimension line for the drill axis offset. (0=Off, 1=On) |
| suppressDepth | Int | 0 | Hides the depth dimension for drills. Useful for through-holes. (0=Show, 1=Suppress) |
| showJapaneseSymbols | Int | 0 | Enables symbols specific to Japanese timber construction standards. (0=Off, 1=On) |
| JapaneseStyle | Int | 0 | Activates Japanese dimensioning rules (point selection based on orientation). (0=Off, 1=On) |
| showOffsetDrill | Int | 0 | Controls how hole location is displayed: <br>0 = Individual dimension line <br>1 = Near origin <br>2 = Collected at start/end <br>3 = Do not display |
| showDiameter | Int | 0 | Controls hole size display style: <br>0 = Diameter as appendix text <br>1 = Radius as appendix text <br>2 = Diameter as separate text <br>3 = Radius as separate text <br>4 = Radial dimension line <br>5 = Hide |
| showDiameterIfEqual | Int | 0 | Optimization for multiple identical holes. <br>0 = Show only once if equal <br>1 = Show on all holes |
| hideDrillInSection | Int | 0 | Toggles visibility of the hole in sectional views. (0=Show, 1=Hide) |
| ShowDrillAxisView | Int | 0 | Filters display based on viewing direction: <br>0 = Parallel view <br>1 = Perpendicular view <br>2 = Side view <br>3 = Top view <br>4 = Hide in all views |
| ShowInfoSeparate | Int | 0 | Separates diameter/depth info onto a different dimension line to avoid clutter. (0=Same line, 1=Separate) |
| ShowAllInOneLeft | Int | 0 | Aggregates all left-side offsets into one chain dimension. (0=No, 1=Yes) |
| ShowAllInOneRight | Int | 0 | Aggregates all right-side offsets into one chain dimension. (0=No, 1=Yes) |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script to apply changes made in the Properties Panel or updates based on modified beam geometry. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A.
- **Purpose**: This script relies on `MapIO` properties passed from the Shopdrawing Style configuration rather than external XML files.

## Tips
- **Clean Drawings**: Use the `showDiameterIfEqual` set to `0` when you have many holes of the same size. This labels the size only once, reducing drawing clutter.
- **View Specifics**: If dimensions are missing in a specific view (e.g., Top View), check the `ShowDrillAxisView` property. It might be set to only show in `Side View` or `Parallel View`.
- **Japanese Standards**: If working for a market requiring Japanese symbols, enable both `showJapaneseSymbols` and `JapaneseStyle` to ensure correct point selection and text representation.
- **Depth Clarity**: For blind holes (holes that don't go all the way through), keep `suppressDepth` set to `0` to ensure the depth is clearly visible. For through-holes, set it to `1` to remove redundant information.

## FAQ
- **Q: Why are my drill dimensions not appearing in the drawing?**
- **A:** Check the `ShowDrillAxisView` property. Ensure it is set to match the current view direction (e.g., set to `2` for Side View or `3` for Top View). If set to `4`, it will be hidden in all views.

- **Q: The diameter is only shown on the first hole, but I want it on all of them.**
- **A:** Change the `showDiameterIfEqual` property from `0` to `1`.

- **Q: I see the dimension lines, but no text for the size (Diameter/Radius).**
- **A:** Check the `showDiameter` property. If it is set to `5`, the size is hidden. Also, verify that `ShowInfoSeparate` hasn't moved the text to a layer that is frozen or off.

- **Q: The drill hole appears in the 3D model but is missing in the 2D cross-section.**
- **A:** Check the `hideDrillInSection` property. If it is set to `1`, the hole will be hidden in sectional views.