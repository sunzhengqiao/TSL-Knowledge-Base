# hsb_Kreuzkamm.mcr

## Overview
This script creates a specialized connection (Cross Ridge) between two intersecting structural beams. It calculates the intersection volume and applies cuts to both beams, allowing for configurable gaps to ensure proper fitment or clearance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported in 2D layouts. |
| Shop Drawing | No | Not for shop drawing generation. |

## Prerequisites
- **Required Entities:** 2 Structural Beams (GenBeam).
- **Minimum Beam Count:** 2
- **Required Settings:** None specific to company standards.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Kreuzkamm.mcr` from the catalog list.

### Step 2: Select First Beam
```
Command Line: Select first Beam
Action: Click on the first beam you want to connect.
```

### Step 3: Select Second Beam
```
Command Line: Select second Beam
Action: Click on the second intersecting beam.
```

### Step 4: Automatic Processing
Once both beams are selected, the script automatically validates the geometry. If valid, it applies the cuts to create the connection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap in depth | Number | 0 | Defines the gap distance along the depth (thickness) of the beam connection. |
| Gap in width | Number | 0 | Defines the gap distance at the side of the connection. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the context menu. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Valid Intersection:** The beams must intersect in a way that creates a quadrilateral (4-sided) profile. If the beams only touch at a corner or are skewed such that the intersection is triangular, the script will fail.
- **Adjusting Gaps:** You can modify the gaps instantly after insertion. Select the script instance in the model, open the Properties Palette (Ctrl+1), and change the "Gap in depth" or "Gap in width" values. The cuts will update automatically.

## FAQ
- **Q: I received the error "invalid connection". What does this mean?**
  **A:** This means the script could not calculate a valid 4-point intersection profile between the two beams. Ensure the beams are crossing clearly and are not parallel or just touching at an edge.
- **Q: Can I use this on beams that do not touch?**
  **A:** No, the beams must physically intersect in 3D space for the script to calculate the cut geometry.