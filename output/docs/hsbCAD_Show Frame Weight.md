# hsbCAD_Show Frame Weight

## Overview
This script calculates the total weight of a timber frame element (including beams, sheets, and materials) based on material densities and dimensions. It displays the calculated weight as a text annotation in your Paper Space layout, useful for logistics and transport planning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for Layouts. |
| Paper Space | Yes | The script must be inserted into a Layout tab. |
| Shop Drawing | No | This is an annotation script, not a detailing tool. |

## Prerequisites
- **Required Entities:** A Viewport in Paper Space displaying a valid hsbCAD Element (Wall or Floor).
- **Minimum Beam Count:** 0 (Works with empty elements, though weight will be 0).
- **Required Settings:** None. However, for accurate sheet material weights, the script supports the external TSL `FrameUK_SetWallMaterials` if present.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line, select `hsbCAD_Show Frame Weight.mcr` from the list, or click the associated toolbar button.

### Step 2: Pick Insertion Point
```
Command Line: Pick a Point
Action: Click anywhere in the Paper Space layout where you want the weight label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border that displays the wall/floor element you wish to analyze.
```

### Step 4: Configure (Optional)
Upon first insertion, a properties dialog may appear asking you to confirm the dimension style and weight settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the text style used for the annotation (e.g., font size, font type). |
| Set Color | number | 1 (Red) | Sets the AutoCAD color index for the weight text (e.g., 1=Red, 2=Yellow, 7=White). |
| Weight for Standard Beams (Kg/m³) | number | 450 | The density used to calculate the weight of standard timber beams that are not specifically defined in the script's internal profile list. |
| Text Offset | number | 5 | The vertical spacing (in drawing units) between the lines of text in the label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the weight calculation. Use this if the model geometry changes or if material properties are updated in the source TSL. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Uses internal logic and standard hsbCAD Element data).

## Tips
- **Material Definitions:** The script recognizes specific engineered profiles and standard timbers. Ensure your material naming conventions match the script's internal list (e.g., "OSB", "PLYWOOD") or use the `FrameUK_SetWallMaterials` TSL for custom definitions.
- **Zone 0 vs. Others:** The script distinguishes between "Frame Weight" (calculated from Zone 0 beams) and "Total Weight" (which includes other zones and extras).
- **Window Weights:** If you want window weights included in the total, ensure your window catalog or TSL assigns a Property Set named `OpeningExtraData` containing a key called `Weight`.

## FAQ
- Q: The weight text is too small or the wrong font.
- A: Change the **Dimstyle** property in the Properties Palette to match a dimension style defined in your drawing with your desired text settings.

- Q: The calculated weight seems incorrect for my specific timber type.
- A: Update the **Weight for Standard Beams (Kg/m³)** property. The default is 450 (Spruce/Pine), but if you are using Hardwood or GLULAM, adjust this value accordingly.

- Q: Does this include the weight of nails/screws?
- A: No, this script calculates the weight of the raw timber and sheet materials only. It does not account for fasteners or hardware.

- Q: Why does the label say "Total weight includes openings"?
- A: The script detected Property Set data on windows/doors in the element containing weight information and has added it to the total.