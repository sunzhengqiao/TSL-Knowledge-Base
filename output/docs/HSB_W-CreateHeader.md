# HSB_W-CreateHeader

## Overview
This script automates the creation of structural headers above wall openings (such as windows or doors). It generates the header beams and simultaneously adjusts the adjacent vertical studs to create correctly sized jack studs and king studs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model on an existing Element. |
| Paper Space | No | This script does not function in Layouts/Shop Drawings. |
| Shop Drawing | No | This script is for model generation only. |

## Prerequisites
- **Required Entities**: An existing `Element` (Wall) containing a `TopPlate` and at least one `OpeningSF` (Opening entity).
- **Minimum Beam Count**: The wall must contain a top plate and at least one vertical stud on each side of the opening.
- **Required Settings**: None (defaults to Element standard sizes if dimensions are set to 0).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-CreateHeader.mcr`

### Step 2: Select Openings
```
Command Line: Select openings
Action: Click on the OpeningSF entities (the rectangle defining the window/door rough opening) you wish to frame. You can select multiple openings. Press Enter to confirm.
```

*(Note: Once selected, the script will automatically calculate the geometry, generate the headers, and cut/resize the surrounding studs.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of headers | Integer | 2 | Sets the number of header plies (stacked beams) to create across the opening width. |
| Header width | Number | 0 | Sets the thickness (depth) of the header timber. Use 0 to apply the Element's default beam width. |
| Header height | Number | 0 | Sets the vertical height of the header timber. Use 0 to apply the Element's default beam height. |
| Number of supporting beams on the left-hand side | Integer | 2 | Sets the number of jack studs (short vertical supports) to generate or modify on the left side of the opening. |
| Number of supporting beams on the right-hand side | Integer | 2 | Sets the number of jack studs (short vertical supports) to generate or modify on the right side of the opening. |
| Supporting beams width | Number | 0 | Sets the thickness of the jack stud material. Use 0 to apply the Element's default beam width. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Standard AutoCAD/hsbCAD options apply. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Zero Values**: If you leave `Header width`, `Header height`, or `Supporting beams width` set to `0`, the script will automatically use the default material dimensions defined in your Element properties.
- **Stacking Headers**: If you increase "Number of headers" above 2, the additional headers will be stacked behind the front header based on the "Header width" dimension.
- **Auto-Fill Studs**: If the script detects that there are not enough existing studs next to the opening to satisfy the count requested in "Number of supporting beams," it will automatically copy the outermost stud and move it inward to fill the gap.
- **Multi-Selection**: You can frame multiple openings at once by window selecting or picking several `OpeningSF` entities during the command prompt.

## FAQ
- **Q: Why are my studs not being cut at the top?**
  **A:** Ensure that the `Header height` parameter is set correctly. The studs are cut to match the bottom of the header. If the header height is 0 (default), ensure your Element has a valid default height defined.
- **Q: How do I create a "King-Jack-King" setup (2 studs on each side)?**
  **A:** Set both "Number of supporting beams on the left-hand side" and "Number of supporting beams on the right-hand side" to 1. The script will resize the inner stud to be a Jack Stud and leave the outer one as a full-height King Stud.
- **Q: Can I use this on openings that aren't aligned with the wall top plate?**
  **A:** The script searches for beams above the opening module. If the opening is rotated or placed such that no valid TopPlate is found directly above it, the script may fail to generate headers.