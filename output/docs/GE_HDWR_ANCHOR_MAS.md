# GE_HDWR_ANCHOR_MAS.mcr

## Overview
This script automates the placement of MAS anchor straps, which are metal connectors used to secure wall bottom plates to the foundation. It intelligently handles the wall framing state by displaying a placeholder marker when the wall is unframed and automatically generating the full 3D steel strap geometry once the wall is framed.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Wall Elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: A Wall Element (`ElementWall`) must exist in the model.
- **Minimum Beam Count**: 0 (The script functions on both unframed and framed walls).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_ANCHOR_MAS.mcr` from the file dialog.

### Step 2: Select Host Wall
```
Command Line: Select element
Action: Click on the Wall Element in the model where you want to install anchors.
```

### Step 3: Define Anchor Locations
```
Command Line: Select a set of points along wall (points will get proper high automatically. Wall side will be the closer to selected points)
Action: Click points along the length of the wall to specify where each anchor should be placed.
Note: You can select multiple points in a sequence. The script automatically calculates the vertical height and determines the side of the wall based on where you click.
```

### Step 4: Finish Selection
```
Command Line: (Press Enter or Escape)
Action: Press Enter or right-click to finish placing anchors.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element | Entity | *Selected Wall* | The Wall Element to which the anchor is attached. |
| Pt0 | Point | *Click Location* | The insertion point of the anchor along the wall. This can be grip-edited. |
| Side | Option | *Calculated* | Determines if the strap is applied to the Left or Right side of the wall (calculated from input point). |
| Embed Length | Double | 9" | The vertical length of the strap embedded into the concrete foundation. |
| Embed Width | Double | 2.75" | The width of the embedded strap portion. |
| Strap Length | Double | 10" | The vertical height of the strap wrapping up the side of the bottom plate. |

## Right-Click Menu Options
*No custom context menu items are defined for this script.* Standard TSL recalculation options apply.

## Settings Files
None. This script operates on internal geometric calculations and standard entity properties.

## Tips
- **Unframed Walls**: If you run this script on an empty wall (no beams/studs), you will see a small cross symbol at the bottom. Do not delete this; it is a placeholder indicating the anchor position.
- **Auto-Generation**: Once you frame the wall (e.g., using a framing macro), the script will detect the beams and replace the cross with the full 3D metal strap wrapping the bottom plates.
- **Collision Prevention**: If you place an anchor too close to another one (less than 2 inches), the script will automatically delete the new instance to prevent overlapping hardware.
- **Adjusting Position**: You can select the anchor instance and use the grip point to slide it along the wall length after insertion.

## FAQ
- **Q: I only see a small cross at the bottom of my wall. Where is the hardware?**
  - A: The wall is currently unframed. The cross reserves the position. Once the wall is framed with bottom plates, the script will automatically generate the 3D steel strap.
- **Q: I tried to place an anchor, but it disappeared immediately.**
  - A: The anchor was likely placed within 2 inches of an existing MAS anchor. The script automatically erases overlapping instances.
- **Q: Can I use this on a beam?**
  - A: No, this script is designed specifically for Wall Elements. Selecting a beam will cause the script to fail or exit silently.