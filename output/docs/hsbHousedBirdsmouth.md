# hsbHousedBirdsmouth

## Overview
Creates a housed birdsmouth joint between rafters (male beams) and purlins (female beams). It generates vertical and horizontal seats with configurable gaps and includes an option to trim the rafter end.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry modification and beam cuts. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Two intersecting `GenBeams` (one rafter, one purlin).
- **Minimum beam count**: 2 beams that intersect physically.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbHousedBirdsmouth.mcr` from the file dialog.

### Step 2: Select Rafters (Male Beams)
```
Command Line: Select roofplane or beams
Action: Select the rafters (male beams). You can also select a RoofPlane to extract all rafters automatically.
```

### Step 3: Select Purlins (Female Beams)
```
Command Line: Select female beams as purlin
Action: Select the purlins (female beams) that intersect the rafters.
```

### Step 4: Configure Properties
After selection, the **Properties Palette** opens. Adjust dimensions and gaps as needed. The script automatically generates a joint instance for every valid intersection found.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Vertical Depth (A) | Number | 20 mm | Defines the depth of the vertical seat cut into the top of the purlin. Resets to 0 if beams are not vertically perpendicular. |
| Horizontal Depth (B) | Number | 20 mm | Defines the depth of the horizontal notch cut into the side face of the purlin. Resets to 0 if beams are not at 90° in plan view. |
| Offset Horizontal Cut (C) | Number | 5 mm | Vertical distance from the bottom of the birdsmouth tail up to the horizontal cut line. |
| Side (D) | Number | 0.5 mm | Defines the gap for the housing at the sides of the purlin to allow for easier assembly. |
| Bottom (E) | Number | 0 mm | Defines the gap at the bottom of the side housing cut. |
| Cut male beam | Dropdown | No | If "Yes", adds a vertical saw cut to the rafter end at the opposite side of the female beam. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Processing**: To save time, select a RoofPlane in Step 2 instead of picking individual rafters.
- **Perpendicular Requirements**: Ensure rafters and purlins are perpendicular (90°) in the plan view to enable the "Horizontal Depth (B)" side housing.
- **Vertical Alignment**: If the "Vertical Depth (A)" is forcing itself to 0, check that the rafter and purlin are correctly aligned vertically.
- **Global Angle**: The script will delete itself if the beams are nearly horizontal (0°) or vertical (90°) relative to the World XY plane. Ensure beams are angled between 1° and 89°.

## FAQ
- Q: Why is the "Horizontal Depth (B)" zero even though I entered a value?
- A: The script automatically sets this to 0 if the rafters and purlins are not exactly perpendicular in the plan view.
- Q: What happens if the script disappears immediately after insertion?
- A: This usually means the beam intersection angle is outside the valid range (1° - 89° relative to the ground) or the beams are no longer intersecting. Check your geometry and try again.