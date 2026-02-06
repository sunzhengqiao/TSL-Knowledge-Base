# hsbKingPostTenon.mcr

## Overview
This script generates a traditional timber frame connection, cutting a tenon on a joist and a corresponding mortise in a post. It automatically applies drilling operations for wooden dowels (pegs) and handles intersecting joists at the same level with a tolerance cut.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to cut and drill beams. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D annotations directly. |

## Prerequisites
- **Required Entities**: Two GenBeam entities.
- **Minimum Beam Count**: 2 beams (one vertical Post and one horizontal Joist).
- **Required Settings**: None required; all dimensions are controlled via the Properties Palette.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbKingPostTenon.mcr`

### Step 2: Configure Properties
**Action**: The Properties Dialog appears on insertion.
- Adjust the dimensions for the Tenon, Shoulder, and Pen (dowel) settings as needed.
- Click **OK** to confirm.

### Step 3: Select Beams
```
Command Line: Select beams
Action: Click the joist and the post. You can select multiple beams if they share the same post.
```
- **Note**: The script automatically detects which beam is the post (vertical) and which is the joist (horizontal), regardless of the selection order.

### Step 4: Generation
The script automatically:
1. Cuts the shoulder and tenon cheeks on the joist.
2. Cuts the mortise slot in the post.
3. Drills hole(s) for the dowels through both beams.
4. Adds the wooden dowel (Peg) to the Bill of Materials (BOM).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Shoulder** | | | |
| Width | Number | 30 | The depth of the horizontal housing cut on the post face (mm). |
| **Pen** | | | |
| Diameter | Number | 22 | Diameter of the wooden dowel/peg hole (mm). |
| Height | Number | 90 | Vertical position of the dowel hole center from the bottom of the joist (mm). |
| Heart Offset | Number | 10 | Lateral offset of the hole from the beam centerline towards the face (mm). |
| Nr | Number | 1 | Number of dowel holes to drill (e.g., 1 or 2). |
| Distance | Number | 25 | Center-to-center spacing between multiple dowel holes (mm). |
| **Tenon** | | | |
| Height | Number | 180 | Vertical height of the tenon (mm). |
| Height Tolerance | Number | 2 | Vertical clearance added to the mortise slot in the post (mm). |
| Length | Number | 100 | Depth the tenon penetrates into the post (mm). |
| Length Tolerance | Number | 2 | Depth clearance added to the mortise slot (mm). |
| Width | Number | 60 | Width of the tenon (typically matching joist width) (mm). |
| Width Tolerance | Number | 2 | Lateral clearance added to the mortise slot width (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined in this script version. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configuration is stored in the script properties.

## Tips
- **Beam Orientation**: You do not need to select the post first. The script analyzes the geometry to assign the vertical beam as the post and the horizontal as the joist.
- **Multiple Joists**: You can select several joists and one post in a single operation; the script will propagate the connection to all selected pairs.
- **Intersecting Joists**: If another joist using this script intersects at the same height, the script will automatically cut the intersecting part with a 4mm tolerance to prevent physical clashes.

## FAQ
- **Q: What happens if my Tenon Height is larger than my Joist height?**
  **A:** The script automatically clamps the Tenon Height to the physical height of the joist to prevent invalid geometry.
- **Q: How do I place the peg off-center?**
  **A:** Use the **Pen > Heart Offset** property. A positive value moves the hole towards the face of the beam, which is common in traditional timber framing to draw the joint tight.
- **Q: Can I use two pegs?**
  **A:** Yes. Change the **Pen > Nr** property to `2` and adjust the **Pen > Distance** to set the spacing between the two holes.