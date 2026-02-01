# HSB-ChangeSheetingInRoom.mcr

## Overview
Automatically identifies sheathing on walls facing a specific interior point (e.g., a bathroom or kitchen) and changes the material to 'Green Gypsum' (water-resistant board) with a green color indication.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements in the model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | This is a model modification tool, not a drawing generation script. |

## Prerequisites
- **Required Entities**: Walls (`ElementWallSF`) containing Sheeting (`Sheet` entities).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-ChangeSheetingInRoom.mcr`

### Step 2: Define Room Interior
```
Command Line: |Select a position in the room|
Action: Click a point inside the room volume (e.g., the center of a bathroom).
```
*Note: This point determines which side of the wall is considered "interior". The script will only modify sheets facing this point.*

### Step 3: Select Walls
```
Command Line: |Select walls to apply sheeting|
Action: Select the wall elements that enclose the room. Press Enter to confirm selection.
```
*Note: The script will process the selected walls and automatically erase itself from the drawing upon completion.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs as a one-time command and erases itself. There are no persistent properties to edit via the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are available as the script instance is removed immediately after execution. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Point Placement**: Ensure the point selected in Step 2 is clearly inside the room. If the point is placed outside the wall or in an adjacent room, the script may modify the exterior sheathing or the wrong side of the wall.
- **Material Name**: The script explicitly sets the material name to "Green Gypsum". Ensure your material catalogs or templates support this name if you intend to run reports or schedules based on material type.
- **Visibility**: The script instance disappears from the drawing immediately after running. This is normal behavior; it does not mean the script failed.

## FAQ
- **Q: What happens if I select no walls?**
  - A: The script will detect an empty selection and terminate immediately without making any changes.
- **Q: Can I undo the changes?**
  - A: Yes, you can use the standard AutoCAD `UNDO` command to revert the material changes if you made a mistake.
- **Q: Why is the script object gone after I run it?**
  - A: This is a utility script designed to perform a task and then clean up after itself. It does not remain in the model as an editable object.
- **Q: Does this work on curved walls?**
  - A: The script relies on vector calculations and body intersections; ensure the wall geometry is clean for best results.