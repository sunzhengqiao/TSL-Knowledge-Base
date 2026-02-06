# hsb_Wall to Wall Connection

## Overview
Automates the generation of structural framing connections (studs and backers) at the intersection of two timber walls. It handles both Corner (L) and T-junctions, creating appropriate nailing surfaces and structural blocking.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting 3D wall elements. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | This is a model generation script, not a drawing generator. |

## Prerequisites
- **Required Entities**: Two existing `ElementWall` objects that physically touch or overlap.
- **Minimum Count**: 2 Walls must be selected.
- **Required Settings**: None required (uses internal defaults and OPM properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsb_Wall to Wall Connection.mcr` from the file dialog.

### Step 2: Select Walls
```
Command Line: Select 2 Walls Connected
Action: Click on the two walls that form the intersection (Corner or T-junction).
```

### Step 3: Configure Connection (Optional)
Action: Press `Esc` to finish the command. Select the newly created connection symbol (3D Cross) and open the **Properties Palette** (Ctrl+1) to adjust the connection type or stud sizes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | Dropdown | L Backer | Select the connection configuration: L Backer, L Backer Reverse, U Shape, or Multiple Studs. |
| **Studs Qty** | Integer | 1 | Number of studs to generate (Only valid when Type is set to 'Multiple Studs'). Range: 1-20. |
| **Backer Height** | Number | 89 | Vertical height (depth) of the backing/nailing beam (in mm). |
| **Backer Width** | Number | 38 | Thickness of the backing/nailing beam (in mm). |
| **Center Stud on L** | Yes/No | No | If Yes, centers the primary stud on the corner axis (for L connections). |
| **Double Stud** | Yes/No | No | Adds a second reinforcing stud adjacent to the primary connection stud (for L Backer types). |
| **Create Module** | Yes/No | No | If Yes, groups the generated beams into a module linked to this instance. |
| **Module Color** | Index | 2 | CAD Color index for the generated beams when 'Create Module' is Yes. |
| **Stud Name** | String | STUD | Entity name assigned to generated studs for CAM/CNC export. |
| **Backer Name** | String | BACKER | Entity name assigned to generated backers for CAM/CNC export. |
| **Display Color** | Index | 12 | Color of the 3D cross symbol representing the connection. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Reapply Wall Connection** | Forces a full regeneration of the connection. Useful if the wall geometry has moved or changed but the connection did not update automatically. |

## Settings Files
None required. This script relies entirely on Properties Palette inputs and geometric analysis of the selected walls.

## Tips
- **Selection Validity**: Ensure the two wall outlines physically touch or overlap in the model. If the script deletes itself immediately, it likely could not detect a valid intersection between the two selected outlines.
- **T vs L Connections**: The script automatically detects if the intersection is a Corner (L) or a T-Junction based on the wall geometry. You do not need to select a specific type for the geometry, only the framing style (e.g., U-Shape vs L-Backer).
- **Utility Chases**: Use the "Multiple Studs" type to create a block of studs, which can serve as a chase for plumbing or electrical runs, or for heavy load transfer points.
- **Module Management**: Enable "Create Module" if you want to delete or move the entire connection assembly easily by selecting the connection symbol.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  A: The script performs a validation check. If the outlines of the two walls do not match or touch correctly, the script displays an error and deletes itself. Check that your walls are properly joined.
- **Q: How do I change a corner from a single stud to a U-shape?**
  A: Select the connection symbol in the model, open the Properties Palette (Ctrl+1), and change the "Type" property to "U Shape". The connection will update automatically.
- **Q: Can I use this for walls that are not 90 degrees?**
  A: Yes, the script calculates intersections based on wall geometry, so angled walls are supported provided they overlap correctly.