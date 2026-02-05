# HSB_G-SetPlaneProfile.mcr

## Overview
This script automatically calculates and applies the exact outline (Netto profile) for a specific construction layer (zone) of a wall element. It derives the shape from the structural beams within that zone and subtracts any window or door openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Element entities. |
| Paper Space | No | Not designed for layouts or views. |
| Shop Drawing | No | Not designed for 2D drawing generation. |

## Prerequisites
- **Required Entities**: An Element (e.g., a timber wall).
- **Minimum Beam Count**: 0 (The script processes existing beams, but can run on an empty element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the folder containing `HSB_G-SetPlaneProfile.mcr`.
3. Select the file and click **Open**.

### Step 2: Select Zone
1. The **Properties Palette** will appear automatically.
2. Locate the **Zone** parameter.
3. Select the desired layer index:
   - **0-5**: Standard zones (outer layer to inner layer).
   - **6-10**: Extended/Negative zones (maps to -1 through -5).

### Step 3: Select Element
1. The command line will prompt: `Select one or more elements`
2. Click on the wall element(s) you wish to update.
3. Press **Enter** to confirm selection.

### Step 4: Processing
The script will calculate the profile, apply it to the element, and then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone to process** | Label | N/A | A visual header indicating the section below controls the layer settings. |
| **Zone** | Dropdown | 0 | Selects the construction layer to calculate. Options 0-5 correspond to standard zones. Options 6-10 correspond to negative zones (-1 to -5) for extended layer selection. |

## Right-Click Menu Options
This script does not add specific items to the element's right-click context menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Updating the Profile**: If you modify the beams or openings inside the wall, simply select the wall and run the **Update** (or Recalculate) command. The script will re-run and correct the profile shape based on the new geometry.
- **Negative Zones**: If you need to edit a layer on the "negative" side of the wall's coordinate system (often used for specific detailing layers), select index **6** (for -1), **7** (for -2), etc., from the Zone dropdown.
- **Gap Closing**: The script automatically "shrinks" and "expands" the calculated profile by 10mm to close tiny gaps between beams, ensuring a clean manufacturing contour.

## FAQ
- **Q: The script ran, but nothing happened.**
  - A: Ensure you selected a valid Element entity. If the selected zone contains no beams, the resulting profile may be empty or invisible.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD **Undo** command immediately after running the script.
- **Q: Does the script stay attached to the wall?**
  - A: No. This is a "run-once" script. It calculates the data, applies it to the element's properties, and deletes itself to prevent drawing clutter.