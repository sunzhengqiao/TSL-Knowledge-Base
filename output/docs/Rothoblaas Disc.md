# Rothoblaas Disc.mcr

## Overview
This script generates a concealed timber-to-timber connection using Rothoblaas DISC hardware, including the top plate, pipe, and countersunk bolt. It automatically creates the necessary tooling (drills and countersinks) in both the male and female beams based on the selected article size.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D detailing and connection generation. |
| Paper Space | No | Not applicable for drawing views. |
| Shop Drawing | No | Not applicable for 2D layouts. |

## Prerequisites
- **Required Entities**: At least 2 Timber Beams (`GenBeam`).
- **Minimum Beam Count**: 2 (One Male, One Female).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `Rothoblaas Disc.mcr` from the list.
Alternatively, double-click the script if it is loaded in a catalog palette.

### Step 2: Select Male Beams
```
Command Line: Select male beam(s)
Action: Click the beam(s) where the main Disc plate (the side with the pipe) will be mounted. Press Enter to confirm selection.
```

### Step 3: Select Female Beams
```
Command Line: Select female beam(s)
Action: Click the intersecting beam(s) where the connecting bolt and washer will be inserted. Press Enter to confirm.
```

### Step 4: Configuration (If not using a Catalog preset)
```
Dialog: Rothoblaas Disc Properties
Action: 
1. Select the Article type (e.g., DISC55) from the dropdown.
2. Adjust offsets or tooling depths if necessary.
3. Click OK to generate the connection.
```
*Note: If you use an Execution Key from a catalog, this dialog may be skipped.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| A - Article | Dropdown | DISC55 | Selects the model of the Rothoblaas DISC connector. Options: DISC55, DISC80, DISC120. |
| B - Additional mill depth | Number | 0.0 | Defines how deep the plate sits relative to the surface. Negative values push it further into the beam. |
| C - Oversize mill | Number | 1.0 | Adds extra diameter (tolerance) to the main hole in the male beam (mm). |
| D - Offset Lateral | Number | 0.0 | Moves the connector sideways along the beam width (Y-axis) in mm. |
| E - Offset Vertical | Number | 0.0 | Moves the connector up/down along the beam height (Z-axis) in mm. |
| F - Tools in female beam | Dropdown | Yes | Toggles tooling and hardware for the female beam. Select "No" to only machine the male side. |
| G - Extra depth sink hole | Number | 0.0 | Increases the depth of the countersink for the washer in the female beam (mm). |
| H - Oversize sink hole | Number | 4.0 | Adds extra diameter (tolerance) to the washer countersink in the female beam (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are added by this script. Use the Properties Palette (OPM) to modify parameters. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal dimension tables and does not require external XML settings files.

## Tips
- **Batch Processing**: You can select multiple Male beams and multiple Female beams in steps 2 and 3. The script will automatically generate connections for every valid intersection found.
- **Intersection Check**: The beams must physically intersect. If the connector does not appear, check if the beams are actually touching in the 3D model.
- **Depth Safety**: If you set the "Additional mill depth" too negative (trying to recess the plate deeper than its thickness), the script will automatically correct the value to prevent geometry errors.

## FAQ
- **Q: Why didn't the connector appear on my selected beams?**
- **A**: The script silently skips beam pairs that are parallel or do not intersect within their length. Ensure your beams cross each other.
  
- **Q: Can I use this to connect a beam to a column?**
- **A**: Yes, as long as the entities are standard `GenBeam` elements and they intersect, the angle does not matter.

- **Q: How do I stop the script from drilling the female side?**
- **A**: Select the instance in the model, open the Properties palette (Ctrl+1), and change "F - Tools in female beam" to "No".