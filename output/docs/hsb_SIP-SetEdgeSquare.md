# hsb_SIP-SetEdgeSquare.mcr

## Overview
This script converts angled or rabbeted edges of Structural Insulated Panels (SIPs) into square (90-degree) edges. It simultaneously adjusts the width of intersecting lumber beams to ensure they fit perfectly against the new squared geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D model elements. |
| Paper Space | No | Not designed for layout views or 2D drawings. |
| Shop Drawing | No | Not designed for generating manufacturing views. |

## Prerequisites
- **Required Entities**: An existing hsbCAD **Element** containing both SIP panels and Lumber Beams.
- **Minimum Beam Count**: 0 (script processes existing beams found within the Element).
- **Required Settings**: None.
- **Placement**: Ensure lumber beams physically intersect the shadow profile (outline) of the SIP panels you wish to modify.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SIP-SetEdgeSquare.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: 
Select Element
Action: Click on the hsbCAD Element in the model that contains the SIP panels and beams you want to modify.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Enter the recess depth for edges | number | 50 | The distance (in mm) from the original outer edge to the new squared edge position. This value effectively sets how far back the square cut is made and adjusts the beam width accordingly. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Beam Intersection**: Verify that your lumber beams cross over the area where the SIP edge will be squared. If a beam does not intersect the SIP's shadow profile, the script will not resize it.
- **Depth Adjustment**: The "Recess depth" effectively cuts into the panel. Ensure this value does not exceed the thickness of the SIP or the beam width to avoid invalid geometry.

## FAQ
- **Q: Why did my beams not resize after running the script?**
  **A**: The beams must intersect the shadow profile (projection) of the SIP panel. If the beam is too short or placed away from the panel edge, the script cannot detect it.
- **Q: What unit of measurement is used for the recess depth?**
  **A**: The input value is interpreted in millimeters (mm).