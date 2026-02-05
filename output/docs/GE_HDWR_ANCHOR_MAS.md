# GE_HDWR_ANCHOR_MAS.mcr

## Overview
This script inserts Masonry Anchor Straps (MAS) designed to wrap the bottom plate of timber walls and embed into the foundation. It automatically manages the geometry based on the wall's framing status and ensures minimum spacing between anchors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D bodies and markers in the model. |
| Paper Space | No | Not designed for layout views or paper space. |
| Shop Drawing | No | Does not generate shop drawing details. |

## Prerequisites
- **Required entities**: An `ElementWall` must exist in the model.
- **Minimum beam count**: 0 (The script works on both unframed outlines and framed walls).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_ANCHOR_MAS.mcr`

### Step 2: Select Wall
```
Command Line: Select element
Action: Click on the wall element where you want to install the anchors.
```

### Step 3: Define Anchor Locations
```
Command Line: Select a set of points along wall (points will get proper high automatically. Wall side will be the closer to selected points)
Action: Click along the length of the wall to place anchors. You can click multiple points to insert multiple anchors at once. Press Enter or right-click to finish.
```
*Note: The script will calculate the height and wall side automatically based on your clicks.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose user-editable properties in the Properties Palette. Geometry is controlled by the wall and insertion point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No specific context menu options are added by this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Unframed Walls**: If you place the anchor on a wall that has not been framed yet (no beams generated), the script will display a small 'X' marker. Once the wall is framed, the 'X' will automatically update to the full 3D metal strap geometry.
- **Automatic Spacing**: The script enforces a minimum distance of 2 inches between anchors. If you place a new anchor too close to an existing one, the new anchor will automatically delete itself.
- **Grip Editing**: You can move an anchor after insertion by selecting it and using the grip point (`_Pt0`) to slide it along the wall. The height and orientation update automatically.
- **Wall Side Selection**: The anchor is applied to the side of the wall closest to where you clicked during the point selection phase.

## FAQ
- **Q: Why do I see a cross 'X' instead of the metal strap?**
  **A:** This indicates the wall is currently "unframed" (no beams detected). Generate the wall framing, and the symbol will change to the correct 3D hardware shape.
- **Q: I clicked to place an anchor, but it disappeared immediately. Why?**
  **A:** You likely tried to place the anchor within 2 inches of an existing anchor. The script automatically deletes instances that violate the minimum spacing rule. Try placing it further away.
- **Q: Can I use this on walls that are already framed?**
  **A:** Yes. If the wall is already framed, the script will immediately generate the 3D wrapping strap geometry instead of the placeholder marker.
- **Q: How do I change the size of the strap?**
  **A:** The dimensions (e.g., embedded length, wrap height) are currently hardcoded into the script logic. You must contact your system administrator to modify the script if different dimensions are required.

---