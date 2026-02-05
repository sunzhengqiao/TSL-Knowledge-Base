# Offsetted Parallel Housing

## Overview
This script creates a parallel housing (mortise) connection between intersecting timber beams. It calculates and applies cuts to "male" beams based on their intersection with "female" beams, with detailed controls for offsets, gaps, and tool geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates within the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: GenBeam or Element entities must exist in the drawing.
- **Minimum Beam Count**: 2 (At least one male beam and one female beam).
- **Required Settings**: None. The script uses internal logic to determine geometry based on user inputs.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Offsetted_Parallel_Housing.mcr`

### Step 2: Configure Parameters
Upon insertion, a configuration dialog appears allowing you to set default values for depth, offsets, and gaps before selecting beams.

### Step 3: Select Male Beams
```
Command Line: Select male beams
Action: Click on the beams that will be cut (the tenons). Press Enter when finished.
```

### Step 4: Select Female Beams
```
Command Line: Select female beams
Action: Click on the beams that define the intersection path (the mortises). Press Enter when finished.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| A - Extend mortise | dropdown | No | Extend mortise to the top edge of female beam. |
| B - Mortise shape | dropdown | Minimum | Shape of the mortise tool. <br> *Minimum: All four sides of the beam will be milled.* <br> *Normal: At the 'inner' side of the angled connection, the pocket will get a chamfered edge.* <br> *Maximum: The pocket will get maximum size, so that no air gap results (maximum two sides of the male beam will be milled).* |
| C - Round Type | dropdown | not rounded | Defines the rounding type of the mortise. (Shape 'Normal' is always 'not rounded'). |
| D - Mortise depth | number | 20mm | Defines the depth of the mortise. |
| E - Offset vertical | number | 30mm | Defines the vertical offset of the connection. |
| F - Offset right | number | 0mm | Defines the offset from the right side of the connection. |
| G - Offset left | number | 0mm | Defines the offset from the left side of the connection. |
| H - Gap in depth | number | 5mm | Defines the gap in depth of the mortise. |
| I - Gap right | number | 0mm | Defines the gap at the right side of the mortise. |
| J - Gap left | number | 0mm | Defines the gap at the left side of the mortise. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Mortise Extension | Toggles the direction of the mortise extension. |

## Settings Files
- No external settings files are required for this script.

## Tips
- Ensure the selected male and female beams are parallel and actually intersect within their lengths; the script automatically filters out incompatible pairs.
- Use the **Offsets** (E, F, G) to shift the housing center vertically or laterally if the intersection point does not represent the desired center of the joint.
- Use the **Gaps** (H, I, J) to create clearance for glue or easier assembly.

## FAQ
- **Q: Why didn't the script create a tool for one of the beams I selected?**
  **A:** The script checks geometric compatibility. If the beams are not parallel or do not physically intersect within their bounding boxes, the script will skip that pair.
- **Q: What is the difference between "Minimum" and "Maximum" mortise shape?**
  **A:** "Minimum" creates a tighter fit milling all four sides of the male beam. "Maximum" creates a larger pocket to prevent air gaps, usually resulting in only two sides of the male beam being milled.