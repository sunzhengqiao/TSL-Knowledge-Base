# hsbBeamCornerConnection.mcr

## Overview
This script automates the creation of structural corner connections between two perpendicular joists. It handles mitering, material clearance, and optionally creates mortise/tenon joints and drill holes for a connecting vertical post.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D beam modifications. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script modifies the 3D model, not drawings. |

## Prerequisites
- **Required Entities**: Two or three `GenBeam` entities (Joists).
- **Minimum Beam Count**: 2 Joists. If a post connection is required, 3 Beams (2 Joists + 1 Post).
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBeamCornerConnection.mcr`

### Step 2: Configure Properties (Optional)
If not inserting from a pre-configured catalog entry, a Properties Dialog will appear.
- Adjust dimensions for **Drill Diameter**, **Number of Drills**, or **Mortise Depth** as needed.
- Click **OK** to confirm.

### Step 3: Select Male Joist
```
Command Line: Select Male Joist
Action: Click on the first beam (Joist 0). This beam will typically host the tenon or primary cut side.
```

### Step 4: Select Female Joist
```
Command Line: Select Female Joist
Action: Click on the second beam (Joist 1). This beam must be perpendicular to the first beam.
```

### Step 5: Select Post (Optional)
```
Command Line: Select Post (optional)
Action: Click on a vertical post that intersects the joists, or press ENTER to skip.
Note: If selected, the post must be perpendicular to both joists to generate mortise and drill holes.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dAngleWidth | Number | 50 mm | Defines the width parameter used for angular geometry calculations at the corner. |
| dDrillDia | Number | 22 mm | Diameter of the drill holes (dowels/bolts) passing through the beams and post. |
| dDrillHeight | Number | 26 mm | Vertical reference height for the center of the first drill hole. |
| nNr | Integer | 1 | The number of drill holes to generate vertically. |
| dDistance | Number | 25 mm | The center-to-center spacing between multiple drill holes. |
| dToljoist | Number | 4 mm | Expansion gap allowed between the two intersecting joists to ensure fit. |
| dTolMortise | Number | 4 mm | Expansion gap for the mortise and tenon joint (play allowance). |
| dMortiseOffX | Number | 95 mm | Longitudinal offset of the mortise pocket from the reference point. |
| dMortiseOffY | Number | 70 mm | Lateral offset of the mortise pocket from the beam centerline. |
| dMortiseWidth | Number | 64 mm | The width of the mortise pocket. |
| dMortiseDepth | Number | 99 mm | The depth (penetration) of the mortise pocket. |
| dMortiseHeight | Number | 70 mm | The vertical height of the mortise pocket. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Swaps the roles of Joist 0 and Joist 1. Use this if the cuts are applied to the wrong side of the beams. |
| Add Post | Prompts you to select a post to add to an existing connection. Validates if the new post is perpendicular to the joists. |

## Settings Files
None required for this script.

## Tips
- **Perpendicularity**: Ensure your joists are exactly perpendicular (90 degrees). If the post connection fails, check the angles of the selected beams.
- **Multi-Drill Setup**: To create a vertical array of bolts, set **nNr** to greater than 1 and adjust **dDistance** to set the spacing.
- **Modifying Geometry**: You can change drill sizes or gaps after insertion via the AutoCAD Properties Palette (Ctrl+1).

## FAQ
- **Q: Why didn't the script create holes in my post?**
  A: The script validates the geometry. Ensure the post is perpendicular to both joists. If the beams are not perfectly square, the post logic will be skipped.
- **Q: How do I reverse the direction of the cut?**
  A: Select the script instance, right-click, and choose **Flip Side**.
- **Q: Can I add the post later?**
  A: Yes. Right-click the script instance and select **Add Post**, then click the desired beam.