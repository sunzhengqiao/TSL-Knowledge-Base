# hsbSetStudSection.mcr

## Overview
This script allows you to batch modify the cross-section (width and height) of specific studs within a selected wall using Painter filter rules. It automatically adjusts adjacent studs to prevent overlapping when increasing widths and ensures the modified beams stay aligned to the selected wall face.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D wall geometry in Model Space. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing/drawing generation script. |

## Prerequisites
- **Required Entities:** At least one `ElementWall` entity.
- **Minimum Beam Count:** 0 (The script waits for the wall to generate beams if they do not exist yet).
- **Required Settings:** `PainterDefinition` rules must exist in your project to populate the Filter Rule list.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSetStudSection.mcr`

### Step 2: Configure Properties
```
Dialog Box: Set Stud Section
Action: Configure the modification parameters before selecting the wall.
```
1. **Filter rule**: Select a Painter rule (e.g., "Cripples", "King Studs") to identify which beams to change. If the list is empty, you need to create Painter rules first.
2. **Change height**: Enter the new height (depth) for the selected beams (e.g., `45` to `220`). Set to `0` to ignore height changes.
3. **Change width**: Enter the new width (thickness) for the selected beams (e.g., `0` to `0`). Set to `0` to ignore width changes.
4. **Select Side**: Choose whether the beams should align to the "Icon side" or "Opposite side" of the wall when dimensions change.

### Step 3: Select Wall
```
Command Line: Select element(s)
Action: Click on the ElementWall(s) you wish to process and press Enter.
```
The script will attach to the wall, process the beams, and then automatically erase itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Select Side | dropdown | \|Icon side\| | Determines which face of the wall the modified beams should align to when height or width changes. |
| Change width | number | 0 | The new width (thickness) of the beams. If > 0, the script increases the width and pushes neighboring studs away to avoid collisions. |
| Change height | number | 0 | The new height (depth) of the beams. If > 0, the beam is resized and shifted to maintain alignment with the selected side. |
| Filter rule | dropdown | [Empty] | Selects the specific group of beams to modify based on hsbCAD Painter rules. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is a "fire-and-forget" tool. It erases itself immediately after execution. No context menu options are available after insertion. |

## Settings Files
- **System Resource**: `PainterDefinition`
- **Location**: Internal hsbCAD Painter System / Project Data
- **Purpose**: Provides the list of filter rules (e.g., "Studs", "Posts") used in the "Filter rule" dropdown to select specific beams within the wall.

## Tips
- **Automatic Spacing**: When you increase the **Change width**, the script automatically calculates the overlap and translates adjacent parallel studs to maintain equal spacing. You do not need to manually move neighbors.
- **Alignment Logic**: Use the **Select Side** property to control which side of the beam remains fixed. For example, selecting "Icon side" usually keeps the exterior face of the stud fixed while extending it inward.
- **Fire-and-Forget**: Once you select the wall, the script instance deletes itself. If you need to undo changes, use the standard AutoCAD `UNDO` command immediately.
- **Validation**: If the script runs but nothing happens, ensure the wall has generated beams (not just an outline) and that a valid **Filter rule** is selected that actually matches beams in that wall.

## FAQ
- **Q: The "Filter rule" dropdown is empty. What do I do?**
  A: This script relies on hsbCAD Painter rules. You must define Painter rules in your project (e.g., naming specific layers or entity types) before they will appear in this list.
- **Q: Can I use this to change a single specific stud?**
  A: This tool is designed for batch modifications based on rules (Painter). To change a single beam, it is often easier to select the beam and modify its properties directly in the AutoCAD Properties Palette.
- **Q: I changed the width, but beams are overlapping.**
  A: Ensure you are selecting the correct **ElementWall** and that the beams are recognized as parallel "Verticals" or "Horizontals" by the script logic. The spacing logic applies to beams along the same axis.