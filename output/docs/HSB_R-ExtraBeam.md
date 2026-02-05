# HSB_R-ExtraBeam

## Overview
This script automates the generation of "extra beams" (studs) within a timber construction element. It identifies a specific placeholder beam, calculates intersections with rafters, and generates new studs at those intersection points, automatically removing the original placeholder.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements and Beams. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | This is a generation script for Model Space only. |

## Prerequisites
- **Required Entities**: An Element containing Beams.
- **Configuration**: The Element must contain beams with the specific "Extra Beam" code (default: KLO-01) acting as placeholders.
- **Geometry**: The Element must contain Rafters that intersect the longitudinal axis of the placeholder beams.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse to the script location and select `HSB_R-ExtraBeam.mcr`.

### Step 2: Configure Properties
**Action**: Before selecting geometry, check the Properties Palette (OPM) or the initial dialog.
- Set the **Beamcode extra beam** to match the placeholder beams in your model.
- Set the **Width extra beam** to the desired width for the new studs.
- Review the **Filter beams** list to ensure rafters are not excluded.

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Element(s) (Walls/Roofs) containing the placeholder beams and rafters.
```
**Action**: Press **Enter** to confirm selection.

### Step 4: Processing
**Action**: The script will:
1. Identify the placeholder beams and rafters.
2. Generate the new studs at intersections.
3. Delete the original placeholder beams.
4. Delete the script instance from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extra beam | Separator | - | Visual separator for the Extra beam section. |
| Beamcode extra beam | Text | KLO-01 | The beam code of the placeholder beam to be replaced by the new studs. |
| Width extra beam | Number | 45 | The width (thickness) for the newly generated studs. |
| Filter beams | Separator | - | Visual separator for the Filter section. |
| Filter beams with beamcode | Text | ZKRB-03;ZKRB-04;... | A semicolon-separated list of beam codes to ignore during processing (typically other structural members). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent context menu options. It runs once and erases itself upon completion. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties and Entity data; external settings files are not used.

## Tips
- **Check Intersection**: Ensure the placeholder beam overlaps with the rafters along the Element's Y-axis. If they do not visually overlap in length, no studs will be generated.
- **Profile Source**: The cross-sectional shape (height/profile) of the new studs is taken from the placeholder beam. Only the width is overridden by the script property.
- **Cleanup**: The script automatically deletes the "placeholder" beams. If you need to keep them, do not run this script or duplicate them beforehand.
- **Post-Processing**: Since the script instance deletes itself after running, use standard AutoCAD/hsbCAD grips and properties to manually tweak the generated studs if necessary.

## FAQ
- **Q: I ran the script, but no beams appeared.**
  A: Ensure the "Beamcode extra beam" property exactly matches the code of the placeholder beams in your model. Also, verify that the Rafters are not included in the "Filter beams" list.
- **Q: Can I undo the changes?**
  A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script to revert the generation and restore the placeholder beams.
- **Q: Where did the script instance go?**
  A: This is a "run-once" script. It automatically erases itself from the element after generating the geometry to keep the drawing clean.