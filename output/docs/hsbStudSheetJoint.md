# hsbStudSheetJoint.mcr

## Overview
This script automatically creates or adjusts backing studs (nailing backers) at the locations of sheathing joints within wall elements. It ensures that seams between plywood or OSB sheets are fully supported by structural timber, either by moving existing studs or adding new ones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates and modifies geometry directly in the 3D model. |
| Paper Space | No | This script does not generate 2D drawings or details. |
| Shop Drawing | No | This is a model generation tool. |

## Prerequisites
- **Required Entities**: Wall Elements with Sheathing (Sheeting) applied.
- **Minimum Beam Count**: 0 (The script can create new beams if none exist).
- **Required Settings**: 
  - Painter definitions containing the string 'hsbStudSheetJoint' must exist in your project catalogs.
  - Catalog entries for script parameters (if running via specific execute keys).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbStudSheetJoint.mcr` from the file dialog.

### Step 2: Configure Parameters
- **If executed manually**: A dialog may appear, or you must set properties in the Properties Palette before selection.
- **Set Zones**: Enter the index number of the material layer containing the sheathing (e.g., `0` or `0;1`).
- **Set Width/Profile**: Define the size or shape of the backing studs (leave Width as `0` to use an extrusion profile).
- **Select Painter**: Choose the Painter Definition that identifies your wall studs.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Wall Element(s) you wish to process. Press Enter to confirm.
```
*Note: The script will process the sheathing joints in the selected elements.*

### Step 4: Generation
The script runs automatically:
1. It detects sheet joints in the specified zones.
2. It attempts to place or move studs to align with these joints.
3. It stretches any horizontal beams connected to the moved studs.
4. The script instance deletes itself upon completion, leaving only the new geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 0 | Defines the thickness of the backing stud. Set to `0` to use the Extrusion Profile or existing stud width. |
| Zones | Text | "" | Defines the material layers (zones) to check for sheathing joints. Separate multiple zones with a semicolon (e.g., `0;1`). |
| Extrusion Profile | Dropdown | <Deactivated> | Selects a specific cross-sectional profile (e.g., I-Joist) for the studs. Only active if Width is `0`. |
| Studs | Dropdown/Painter | <Disabled> | Identifies which existing beams are considered "studs" that can be moved or modified. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script acts as a "one-time" command generator. Once executed, the script instance erases itself. Standard AutoCAD/hsbCAD edit options apply to the resulting beams. |

## Settings Files
- **Filename**: Catalog Entries (embedded in hsbCAD catalogs)
- **Location**: Project or hsbCAD Standard Catalogs
- **Purpose**: Stores default values for Width, Zones, and the Painter Definition filters used to identify studs.

## Tips
- **Zone Identification**: If the script does not create any studs, check the **Zones** parameter. Ensure the number matches the material layer index where your sheathing is applied in the element construct.
- **Collision Handling**: The script is smart enough to shift a stud slightly along the wall if the exact joint location is blocked by another component (like a door or window frame). It will try to find the nearest clear spot.
- **Existing Studs**: Use the **Studs** (Painter) parameter to tell the script which beams it is allowed to move. If set to `<Disabled>`, it may only add new studs without modifying the existing frame.
- **Profile Usage**: For complex wall setups, set **Width** to `0` and select an **Extrusion Profile** to match the exact timber type of your wall frame.

## FAQ
- **Q: Why did the script not add any studs?**
  - A: Check the **Zones** parameter. It likely does not match the layer index of the sheathing. Also, ensure the element actually has sheathing assigned to it.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script.
- **Q: What happens if a joint lines up exactly with a window opening?**
  - A: The script detects the collision. It will attempt to shift the stud position to the side to avoid the opening. If it cannot find a clear spot, no stud will be created for that specific joint.