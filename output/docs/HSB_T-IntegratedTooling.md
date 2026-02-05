# HSB_T-IntegratedTooling

## Overview
This script allows you to use one or more "male" beams to cut volumes (tooling) into one or more "female" beams. It is useful for creating complex intersections, housings, or notches where the geometry of the cut is defined by an existing beam, rather than by manual dimensioning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D GenBeam entities. |
| Paper Space | No | 3D geometry operations cannot be performed in Paper Space. |
| Shop Drawing | No | This is a model generation tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: At least two GenBeams (one "Female" target and one "Male" cutter).
- **Minimum Beam Count**: 2 (must physically intersect).
- **Required Scripts**: 
  - `HSB_T-SquareBeamCut.mcr` (Only required if you intend to use the **Convert to static tool** and **Make beamcut square** options simultaneously).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-IntegratedTooling.mcr`

### Step 2: Select Female Beams
```
Command Line: Select a set of female beam(s)
Action: Click on the beam(s) you want to cut into. Press Enter to confirm.
```

### Step 3: Select Male Beams
```
Command Line: Select a set of male beam(s)
Action: Click on the beam(s) that will define the shape of the cut. Press Enter to confirm.
```
*Note: The script will automatically verify if the selected male and female beams physically intersect. If they do not touch in 3D space, no tooling will be created for that specific pair.*

### Step 4: Configure Properties
After selection, the script creates the tooling instance. You can immediately adjust the cut dimensions and behavior using the **Properties Palette** (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Intersection at centerPoint or SolidCenterPoint | Dropdown | PtCenter | Determines where the intersection is calculated from. **PtCenter** uses the beam's reference line (axis). **PtCenterSolid** uses the physical center of the solid (useful for asymmetric beams like I-beams or profiles with offsets). |
| Additional width | Number | 0 | Expands or contracts the width of the cut. Use negative values to tighten the fit or positive values to add clearance. |
| Additional height | Number | 0 | Expands or contracts the height of the cut. |
| Justification point | Dropdown | Center | Determines the direction in which "Additional Width" and "Additional Height" are applied (e.g., Left, Right, Top, Center). |
| Offset in X direction | Number | 0 | Slides the cut along the length of the male beam. |
| Offset in Y direction | Number | 0 | Slides the cut perpendicular to the male beam's web. |
| Offset in Z direction | Number | 0 | Slides the cut vertically. |
| Negative front offset | Number | 0 | Shortens the cutting tool starting from the negative end of the male beam. |
| Positive front offset | Number | 0 | Shortens the cutting tool starting from the positive end of the male beam. |
| Modify section for CNC | Dropdown | No | If set to Yes, updates the beam's sectional properties to reflect the material removal for manufacturing/CAM output. |
| Convert to Dummy | Dropdown | No | If set to Yes, the male beam is hidden from the model (becomes a dummy) but the cut remains visible. |
| Convert to static tool | Dropdown | No | If set to Yes, the cut is permanently applied to the female beams and the link to the male beam is broken. The script instance deletes itself. |
| Make beamcut square | Dropdown | No | If set to Yes, forces the cut to be orthogonal (squared off) rather than following the exact profile of the male beam. (Requires `HSB_T-SquareBeamCut`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add beam | Prompts you to select additional female beams to add to the existing tooling operation. |
| Remove beam | Prompts you to select female beams to remove from the tooling operation, restoring their original geometry. |

## Settings Files
*No specific XML settings files are used by this script. However, ensure the dependency script `HSB_T-SquareBeamCut.mcr` is loaded in your drawing if you plan to use the squaring functionality.*

## Tips
- **Dynamic vs Static**: By default, the tool is "Dynamic." If you move the male beam, the cut on the female beam updates automatically. If you want to lock the cut in place and stop it from updating, set **Convert to static tool** to **Yes**.
- **Clearance Control**: Use the **Justification point** combined with **Additional width/height** to create specific overlaps. For example, set Justification to **Left** and Additional Width to **20mm** to extend the cut 20mm to the left only.
- **Asymmetric Profiles**: If you are cutting with an I-beam or a profile where the web is not centered, check if the cut aligns correctly with the **PtCenter** setting. If the cut looks offset, switch to **PtCenterSolid**.

## FAQ
- **Q: I selected my beams, but nothing happened. Why?**
  - A: The beams likely do not physically intersect in 3D space. The script requires a volumetric overlap to calculate the tool. Check that your beams are actually touching or crossing each other.
- **Q: What happens if I delete the male beam?**
  - A: In standard (Dynamic) mode, deleting the male beam will usually cause the script to error or remove the tooling. If you want to remove the male beam while keeping the hole, use the **Convert to static tool** option.
- **Q: The cut shape is weird/diagonal. How do I make it square?**
  - A: Set **Make beamcut square** to **Yes**. Ensure the script `HSB_T-SquareBeamCut` is loaded in your drawing, or this feature will fail.