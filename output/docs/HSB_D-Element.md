# HSB_D-Element.mcr

## Overview
This script automatically generates architectural and structural dimension lines for Elements (walls or floors) in Paper Space. It is primarily used to annotate the size, position, and layering of timber elements during the creation of Layouts or production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is attached to the Element in Model Space. |
| Paper Space | Yes (Output) | Dimensions are drawn in Paper Space using the active viewport scale. |
| Shop Drawing | Yes | Designed specifically for use in hsbCAD Shop Drawings and Layouts. |

## Prerequisites
- **Required Entities**: An Element (e.g., a Wall or Floor).
- **Minimum Beam Count**: 0.
- **Required Settings**: A valid Layout or Shop Drawing context with an active viewport (requires a `ms2ps` transformation matrix to function).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_D-Element.mcr` from the script list and click OK.

### Step 2: Select Element
Command Line: `Select Element:`
Action: Click on the Element (wall/floor) in the drawing that you wish to dimension.

### Step 3: Configure Dimensions
Action: With the script still selected or after insertion, open the **Properties Palette** (Ctrl+1). Adjust the parameters listed below to control the placement and appearance of the dimensions.

### Step 4: View Results
Action: Switch to your Layout (Paper Space) tab. The script will automatically draw the dimension lines based on the Element's geometry and your Property settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sObject** | enum | Element | Selects the part of the element to dimension. Options include the whole Element, a specific Material Zone, specific Beams, or a BeamCode. |
| **offsetFrom** | enum | Element | Determines where the dimension line starts measuring from. "Element" uses the overall bounding box; "ObjectPoints" uses the specific beams being dimensioned. |
| **nSideRef** | int | 0 | Sets where Reference Dimensions (distance from 0/Grid to element edge) are drawn. 0=None, 1=Left, 2=Right, 3=Both. |
| **nExtLines** | int | 0 | Defines the projection style of extension lines. 0=Perpendicular, 1=Projected to surface, 2=Straight. |
| **nRefTextType** | int | 0 | Controls how reference dimension text is formatted. 0=No text, 1=Inside line, 2=Separate text block. |
| **bRefSigned** | bool | false | If true, adds a '+' or '-' sign to reference dimensions to indicate direction from the origin. |
| **nReadDirection** | int | 0 | Controls text rotation (0 or 1) to ensure readability based on viewport orientation. |
| **bDeltaOnTop** | bool | false | If true, forces the measurement text to sit above the dimension line instead of inline. |
| **dOffsetText** | double | 0 | Horizontal distance (mm) between the dimension point and the description label. |
| **dyOffsetTextRef** | double | 0 | Vertical distance (mm) for separate reference text labels from the dimension line. |
| **nTextSide** | int | 0 | Placement of the main description text. -1=Left, 0=None, 1=Right. |
| **nMinRequiredDimPoints** | int | 2 | Minimum number of points required to draw the dimension. If calculated points are fewer, nothing is drawn. |

## Right-Click Menu Options
There are no specific custom right-click menu options for this script. All configuration is handled via the Properties Palette.

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette inputs and does not use external settings files.

## Tips
- **Dimensioning Layers**: To dimension only the structural timber layer of a wall, set `sObject` to `Zone` and select the corresponding material index.
- **Avoiding Overlaps**: If dimension text overlaps with geometry, increase `dOffsetText` or set `bDeltaOnTop` to `true` to move the text above the line.
- **Reference Dimensions**: Use `nSideRef` set to `3` (Both) to show the grid position relative to the zero point on both sides of the element, which is useful for structural checks.

## FAQ
- **Q: I inserted the script, but no dimensions appear in my layout.**
  - **A:** Check your `sObject` property. If set to a specific Zone or BeamCode that doesn't exist in the element, or if the geometry results in fewer points than `nMinRequiredDimPoints`, the script will exit silently. Try switching `sObject` to `Element`.
- **Q: The reference text is too far away from the dimension line.**
  - **A:** Adjust the `dyOffsetTextRef` property. This value controls the vertical gap for separate reference text blocks.
- **Q: Can I use this script in Model Space?**
  - **A:** No. This script is designed explicitly for Paper Space (Shop Drawings) and uses the viewport scale to calculate correct sizing. It will not function correctly in a pure Model Space view without a layout context.