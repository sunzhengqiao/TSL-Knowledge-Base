# hsbGratleiste.mcr

## Overview
This script creates a continuous sliding dovetail joint (Gratleiste) that connects multiple timber beams. It automatically generates the matching dovetail machining grooves on the selected beams and creates a 3D visual representation of the connecting wooden strip.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script manipulates 3D geometry and beam entities. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | This is a connection/modeling script, not a drawing generator. |

## Prerequisites
- **Required Entities**: Beams (GenBeams) assigned to a single Element.
- **Minimum Beam Count**: 1 (Typically used with multiple beams to form a connection).
- **Required Settings**: None. The script relies on the Element's coordinate system for orientation.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbGratleiste.mcr` from the file list.

### Step 2: Select Beams
```
Command Line: Select Beams
Action: Select the timber beams you wish to connect with the dovetail strip and press Enter.
```
*Note: Ensure all selected beams belong to the same Element construction.*

### Step 3: Select Insertion Point
```
Command Line: Select Insertion Point
Action: Click in the drawing to define the start position of the strip.
```
*Note: While you define the horizontal (X/Y) location, the script automatically snaps the vertical height (Z) to the top surface of the highest selected beam.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dovetail Depth | Number | U(14) | Sets the depth of the groove cut into the beams and the thickness of the connecting strip (in mm). |
| Dovetail Width | Number | U(8.7) | Sets the width of the dovetail groove and the connecting strip (in mm). |
| Color | Number | 167 | Determines the display color of the visualized strip in the model (AutoCAD Color Index). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Standard AutoCAD/hsbCAD options (Move, Erase, Properties) apply. |

## Settings Files
- **Filename**: None used.

## Tips
- **Automatic Height Adjustment**: You do not need to calculate the exact Z-height for the insertion point. Simply click near the beams, and the script will project the point up to the top surface of the top-most beam.
- **Openings**: If your Element has openings (e.g., for windows or doors), the script will automatically detect them and cut (subtract) the visual strip body at those locations.
- **Material Thickness**: Ensure your `Dovetail Depth` is smaller than the thickness of your beams to avoid cutting completely through the material.
- **Long Connections**: For visualization performance, strips longer than 750mm are automatically segmented in the 3D view, but the machining remains continuous.

## FAQ
- **Q: Why did the script disappear after I selected beams?**
  - A: This happens if the selected beams are not assigned to a valid Element or if the script detected a duplication issue. Check that your beams are grouped in an Element.
- **Q: Can I change the size of the strip after inserting?**
  - A: Yes. Select the script instance, open the Properties palette (Ctrl+1), and modify the `Dovetail Depth` or `Dovetail Width`. The machining and visualization will update automatically.
- **Q: Does this work on curved beams?**
  - A: The script sorts beams based on their coordinate system. While it may work on slightly curved layouts, it is designed primarily for linear connections where beams share a consistent orientation.