# HSB_D-Insulation

## Overview
This script automatically dimensions the gaps between structural members (e.g., studs or rafters) in Paper Space to represent insulation widths. It supports adding allowances for compression and filtering specific members to ensure accurate dimensioning for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates exclusively in Paper Space. |
| Paper Space | Yes | Requires a Viewport linked to a model Element. |
| Shop Drawing | No | Designed for Layout/Production drawings. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space linked to a valid model Element (Wall or Roof).
- **Minimum Beam Count**: N/A (depends on the structure inside the Element).
- **Required Settings**: The script `HSB_G-FilterGenBeams.mcr` must be loaded in the drawing to filter beams correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Insulation.mcr` from the catalog.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport that displays the element (wall/roof) you wish to dimension.
```

### Step 3: Pick Script Position
```
Command Line: Give a point
Action: Click in Paper Space to place the script label. This label identifies the script instance and displays its status.
```

### Step 4: Configure Properties
The Properties Palette (Ctrl+1) will open automatically. Adjust the Filters, Dimensions, and Style settings as needed. The drawing will update automatically when values are changed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| genBeamFilterDefinition | Script | (Empty) | Select a predefined filter (e.g., `HSB_G-FilterGenBeams`) to control which structural members define the insulation boundaries. |
| sFilterBC | String | (Empty) | Beam Codes to exclude (semicolon-separated). Beams matching these codes are ignored (e.g., `ST;RW`). |
| sFilterLabel | String | (Empty) | Labels to exclude (semicolon-separated). Entities with these labels are ignored. |
| sFilterMaterial | String | (Empty) | Materials to exclude (semicolon-separated). Beams made of these materials are ignored. |
| dAddExtraSize | Number | 5 | Fixed allowance (tolerance) added to the measured width (in mm). Use this for insulation compression. |
| dMinimumSize | Number | 5 | Minimum gap width to dimension. Gaps smaller than this (in mm) are ignored. |
| sUsePSUnits | Yes/No | No | If **Yes**, offsets are calculated in Paper Space units (1:1). If **No**, they use Model Space units (scaled by Viewport). |
| dDimLineOffset | Number | 300 | Distance from the insulation edge to the dimension line. |
| dTextOffset | Number | 100 | Distance the dimension text is shifted from the dimension line. |
| sPosition | Selection | Horizontal bottom | Places dimensions at the **Horizontal bottom** or **Horizontal top** of the element envelope. |
| sDeltaOnTop | Yes/No | No | Toggles the dimension tick/text orientation (e.g., forcing value above the line). |
| sDimStyle | Selection | 1 | Selects the CAD Dimension Style to use (controls arrows, font, etc.). |
| sDimMethod | Selection | Delta perpendicular | Sets measurement orientation: **Delta perpendicular** (orthogonal) or **Delta parallel** (projected). |
| sDescription | String | (Empty) | Custom text annotation placed alongside the dimensions. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Adds the current element to an exclusion list. Dimensions are hidden, and the script label turns Red. |
| Remove filter for this element | Removes the current element from the exclusion list, re-enabling dimensions. |
| Remove filter for all elements | Clears the exclusion list entirely, re-enabling dimensions for all instances of this script. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: hsbCAD installation directory or Company Standards folder.
- **Purpose**: This external script provides the logic to determine which beams (studs/rafters) form the boundaries for the insulation voids. It must be loaded for the main script to function.

## Tips
- **Compression Allowance**: If your insulation requires friction fit, increase `dAddExtraSize` (e.g., 10mm) so the dimension reflects the cut width slightly larger than the gap.
- **Clean Drawings**: Use `sFilterBC` to exclude trimmers or cripple studs so you only dimension the main bays.
- **Plotting Scale**: If you want the distance between the wall and the dimension line to look consistent on paper regardless of the Viewport scale, set `sUsePSUnits` to **Yes**.

## FAQ
- **Q: I ran the script, but no dimensions appeared.**
  **A**: Check the command line for the warning "GenBeams could not be filtered!". Ensure `HSB_G-FilterGenBeams.mcr` is loaded in your drawing. Also, check if `dMinimumSize` is set too high for the gaps in your wall.
- **Q: The script instance disappeared after I selected the viewport.**
  **A**: This usually happens if the selected Viewport is not linked to a valid Element or if the external filter script failed to load. Check the Entity Properties of the viewport.
- **Q: The dimension text is huge or tiny.**
  **A**: Check the `sDimStyle` setting to ensure it uses a style intended for your current scale. If using `sUsePSUnits`=No, the offset scales with the viewport zoom.