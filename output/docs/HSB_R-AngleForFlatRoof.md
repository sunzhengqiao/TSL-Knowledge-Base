# HSB_R-AngleForFlatRoof.mcr

## Overview
This script generates tapered laths and tilted sheeting on flat roof elements to create drainage slopes (falls). It is typically used on flat roof constructions where a physical slope is required for water runoff by varying the height of laths and rotating the sheeting boards.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates physical GenBeam and Sheet geometry. |
| Paper Space | No | Not a layout or annotation script. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: At least one Roof Element (`ElementRoof`) must exist in the model.
- **Minimum Beam Count**: N/A (Script generates new laths, does not require existing beams).
- **Required Settings**: None (Uses internal defaults or OPM properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_R-AngleForFlatRoof.mcr`.

### Step 2: Select Roof Elements
```
Command Line: |Select a set of elements|
Action: Select the roof elements (ElementRoof) you wish to apply the lathing and sheeting to. Press Enter to confirm selection.
```

### Step 3: Define Start Point
```
Command Line: |Select start point for distribution|
Action: Click on the roof surface to define the starting point (usually the highest point) for the lath distribution and slope calculation.
```

### Step 4: Configure Properties (If Required)
Action: If no catalog settings are found, a Properties dialog may appear automatically. You can also adjust parameters later via the Properties Palette (OPM).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Lath distribution** | | | |
| Spacing | Number | `U(1250)/3` | The distance between the centerlines of the tapered laths. |
| Beam width | Number | `U(40)` | The width (thickness) of the tapered lath perpendicular to the slope direction. |
| Maximum beam height | Number | `U(220)` | The height of the lath at the start point. The laths slope down from this height. |
| Slope [%] | Number | `2` | The pitch or fall angle of the roof expressed as a percentage (e.g., 2%). |
| **Lath properties** | | | |
| Lath color | Number | `52` | The CAD display color index for the generated lath beams. |
| Lath name | String | `""` | The name or designation assigned to the lath entities. |
| Lath material | String | `""` | The material classification of the laths (e.g., C24). |
| Lath grade | String | `""` | The strength grade of the timber used for laths. |
| Lath information | String | `""` | Additional user-defined comments or details. |
| Lath label | String | `""` | The primary label (mark number) for the laths. |
| Lath sub label | String | `""` | Secondary label for grouping. |
| Lath sub label2 | String | `""` | Tertiary label for further classification. |
| Lath code | String | `""` | The beam code or production code associated with the laths. |
| **Sheeting** (Inferred) | | | |
| Sheet Width | Number | `U(1250)` | The width of the sheeting boards (perpendicular to the fall direction). |
| Sheet Length | Number | `U(1430)` | The length of the sheeting boards (along the fall direction). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Regenerates the laths and sheets based on current property values or geometry changes. |
| Erase | Removes the script instance and the generated laths/sheets from the model. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on OPM (Object Properties Model) settings rather than external XML files.

## Tips
- **Adjusting the Fall**: Modify the **Slope [%]** parameter in the Properties palette to increase or decrease the steepness of the drainage angle.
- **Moving the High Point**: Use the **Grip** on the start point symbol to move the origin of the lath grid. This shifts where the "highest" lath is located.
- **Performance**: The script automatically ignores sheet sizes smaller than 10mm to prevent geometry errors and maintain performance.
- **Editing**: If you modify the underlying roof geometry, the script will automatically update the laths and sheets to fit the new profile.

## FAQ
- **Q: Why are some sheets missing?**
  A: The script automatically filters out sheets that are smaller than 10mm in width or length to avoid invalid geometry.
- **Q: How do I change the material for production lists?**
  A: Update the **Lath material** property in the Properties Palette. This ensures correct data for BIM lists and CAM exports.
- **Q: The laths are sloping the wrong way.**
  A: You likely need to move the **Start Point** grip to the opposite side of the roof, or check the orientation of your input elements.