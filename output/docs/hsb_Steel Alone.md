# hsb_Steel Alone.mcr

## Overview
This script generates a steel connection plate attached to the side of a timber beam. It automatically creates a void (cut) in the timber beam to accommodate the plate thickness and optionally adds bolt holes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Does not generate 2D shop drawing details directly. |

## Prerequisites
- **Required Entities**: At least one Timber Beam (GenBeam).
- **Minimum Beam Count**: 1
- **Required Settings/Dependencies**: The script requires `hsb-SubAssembly` to be loaded in the environment to function correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Steel Alone.mcr` from the file list.

### Step 2: Select Host Beam
```
Command Line: Select Male Beam
Action: Click on the timber beam you want to attach the steel plate to.
```

### Step 3: Define Plate Location
```
Command Line: Please select a point on the side of the beam where you need the Plate
Action: Click on the face of the selected beam where the steel plate should be positioned.
```

## Properties Panel Parameters

Once inserted, select the script instance in the drawing to view and edit these parameters in the Properties Palette (OPM).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Width | Number | 80 mm | The horizontal width of the steel plate. |
| Plate Height | Number | 150 mm | The vertical height of the steel plate. |
| Plate Thickness | Number | 15 mm | The depth of the plate (affects the size of the cut in the beam). |
| Location Top | Dropdown | Straight | Determines shape: **Straight** (single plate) or **L Shape** (wraps around the beam corner). |
| Holes per Side | Dropdown | 0 | Number of bolt holes to drill in the plate (0, 1, or 2). |
| Drill Top Offset | Number | 32 mm | Distance from the top edge of the plate to the center of the hole. |
| Drill Side Offset | Number | 32 mm | Distance from the side edge of the plate to the center of the hole. |
| Drill Diameter | Number | 16 mm | Diameter of the bolt holes. |
| Plate Model | Text | Plate | Name/Label assigned to the plate for lists or exports. |
| Color | Number | -1 | CAD Color index (-1 = ByLayer). |

## Right-Click Menu Options

This script does not add specific custom commands to the right-click context menu. All modifications should be made via the **Properties Palette**.

## Settings Files
- **Filename**: `hsb-SubAssembly` (Dependency)
- **Location**: hsbCAD Environment / TSL Folder
- **Purpose**: Ensures the generated steel plate is correctly grouped and associated with the host timber beam.

## Tips
- **L Shape Connections**: Select "L Shape" in the *Location Top* property if you need the plate to wrap around the top or side corner of the beam for greater surface area.
- **Modification**: You can adjust dimensions, hole counts, and offsets at any time by selecting the script instance and updating values in the Properties Palette. The geometry will regenerate automatically.
- **Deletion Warning**: If you erase (delete) this script instance from the drawing, the steel plate will be removed. However, the void (cut) in the host timber beam will remain. You may need to repair the timber beam geometry manually if you delete the script.

## FAQ
- **Q: Why is there a hole/cut in my timber beam?**
  - A: The script automatically generates a void in the host beam matching the *Plate Thickness* parameter. This represents the space occupied by the steel plate in the assembly.
- **Q: How do I add bolt holes after insertion?**
  - A: Select the script, open the Properties Palette, and change *Holes per Side* from **0** to **1** or **2**.
- **Q: Can I move the plate to a different side of the beam?**
  - A: It is usually easier to delete the script instance and re-run it, selecting the new point on the desired side, rather than trying to adjust coordinates manually.