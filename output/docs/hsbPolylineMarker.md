# hsbPolylineMarker.mcr

## Overview
Projects a selected 2D polyline onto specific timber elements (GenBeams) to create precise marking lines. These marks indicate locations for cuts, openings, or hardware placement during fabrication.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D drawings. |

## Prerequisites
- **Required Entities**: At least one Polyline (EntPLine) and one or more GenBeams.
- **Minimum Beam Count**: 1
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPolylineMarker.mcr` from the file dialog.

### Step 2: Select Marking Polylines
```
Command Line: Select marking polylines
Action: Select one or more 2D Polylines that define the shape you want to transfer to the beams. Press Enter when finished.
```
*Note: If you do not select a valid polyline, the script will report an error and exit.*

### Step 3: Select Target GenBeams
```
Command Line: Select genbeams to be marked
Action: Click on the structural timber beams (GenBeams) that intersect with or align to the selected polylines. Press Enter to confirm.
```
*Note: The script will automatically filter out invalid selections (like dummy beams).*

### Step 4: Automatic Processing
The script will now automatically generate a specific marker instance for every valid combination of Polyline and Beam. If the geometry does not intersect or the resulting mark is too small, instances may be deleted automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | This script does not expose editable properties in the Properties Palette. All interaction is handled via the Context Menu or Double-Click. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the projection direction. If the mark is on the "front" face, this moves it to the "back" face (or vice versa) relative to the polyline's vector. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Flipping the Mark**: If the marking line appears on the wrong face of the beam, simply double-click the script instance or select "Flip Side" from the right-click menu.
- **Intersection is Key**: Ensure your polyline physically intersects the volume of the beam in 3D space. If there is no common volume, the script will report "No common marking area found" and delete the instance.
- **Minimum Length**: The script ignores marking lines shorter than 10mm to prevent clutter in the model.
- **Dynamic Updates**: If you move the polyline or stretch the beam geometry, the marking lines will automatically update to match the new intersection.

## FAQ
- **Q: Why did the script instance disappear immediately after creation?**
  **A**: This usually means the projection failed. Check that the polyline and the beam actually overlap in 3D space. Alternatively, the resulting intersection line might have been shorter than 10mm.
- **Q: Can I use one polyline to mark multiple beams at once?**
  **A**: Yes. You can select multiple GenBeams during the insertion step. The script will loop through them and create a separate marker for each beam that intersects the polyline.
- **Q: What happens if I delete the source polyline?**
  **A**: The script instance will detect that the source geometry is missing, report "Invalid selection set," and erase itself automatically.