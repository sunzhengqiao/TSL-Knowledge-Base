# HSB_E-CompoundToSingleCut

## Overview
Converts complex compound cuts (cuts angled in two directions) on timber beams into simplified single cuts (cut angled in only one direction). This is typically used to accommodate machinery limitations or specific manufacturing requirements.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D elements and beams. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Does not generate drawings or views. |

## Prerequisites
- **Required Entities**: You must have Elements (containing GenBeams) in your model.
- **Minimum Beam Count**: 0 (Script processes whatever is found in selected elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the script folder and select `HSB_E-CompoundToSingleCut.mcr`.

### Step 2: Configure Filters (Optional)
Before selecting elements, you can adjust the filters in the AutoCAD Properties Palette (OPM) if you only want to process specific beams.
1. Press `Ctrl+1` to open the Properties Palette if not already visible.
2. Set **Filter mode** to "Include" or "Exclude".
3. Enter **Filter beams with beamcode** (e.g., `POST;BEAM`) to target specific elements.

### Step 3: Select Elements
1. The command line will prompt: `|Select elements|`
2. Click on the Elements in the model that contain the beams you wish to process.
3. Press `Enter` to confirm selection.
4. The script will process the beams, modify the cuts, and automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter mode | dropdown | |Exclude| | Determines if the beam code filter excludes specific beams (ignores them) or includes only specific beams (processes only them). |
| Filter beams with beamcode | text | (empty) | Enter beam codes to filter, separated by semicolons (e.g., `RW1;RW2`). Leave empty to apply to all beams (depending on Filter mode). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Catalog entries (HSB_E-CompoundToSingleCut) | Allows you to load predefined property sets (catalogs) to instantly apply specific filter settings and process the element. |

## Settings Files
- None required.

## Tips
- **Targeting Specific Parts**: Use the "Filter beams with beamcode" property to run the script only on specific structural parts (e.g., only rafters) without affecting other beams in the same element.
- **Persistence**: This script modifies the beam geometry and then deletes itself. The cuts it creates remain as "static tools." If you want to revert the changes, you must remove the tools or update the beam from its original generator.
- **Manufacturing**: Use this script when your CNC machine or saw cannot handle compound angles (simultaneous tilt and rotation).

## FAQ
- **Q: Where did the script go after I ran it?**
  - **A**: This is a "fire and forget" script. It modifies the geometry and erases its own instance to keep the drawing clean.
- **Q: How do I undo the changes made by this script?**
  - **A**: You cannot simply "undo" the script execution once the session is over. You must manually delete the static cut tools from the beam or refresh/re-generate the beam from its parent element.
- **Q: Can I use this on a single beam?**
  - **A**: The script works at the **Element** level. If you need to process a single beam, ensure it is isolated in its own Element or use the Beam Code filter to single it out.