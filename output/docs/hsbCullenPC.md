# hsbCullenPC.mcr

## Overview
Inserts a "Cullen Panel Closer" metal plate connector that bridges and connects two timber elements (beams, sheets, or panels). It automatically detects the connecting edge and generates the necessary hardware data for manufacturing exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in 3D model space to connect structural timber elements. |
| Paper Space | No | This script does not function in layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing tool for 2D drawings. |

## Prerequisites
- **Required Entities:** At least 2 `GenBeams` (beams, sheets, or panels) that share a common plane or intersect.
- **Minimum Beam Count:** 2.
- **Required Settings Files:** A block definition named `Panel Closer.dwg`.
  - *Note:* If this block is not found in the current drawing or the `hsbCompany\Block` folder, the script will generate a generic rectangular body based on parameter dimensions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCullenPC.mcr` from the catalog or file dialog.

### Step 2: Select Timber Elements
```
Command Line: Select genBeam(s)
Action: Click on the two timber elements (walls, panels, or beams) you wish to connect.
Note: You must select at least two elements for the script to proceed.
```

### Step 3: Select Location
```
Command Line: Select the Point
Action: Click in the 3D model near the joint or edge where you want the Panel Closer to be placed.
Note: The script will snap the connector to the closest valid edge intersection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pt0 | Point | Calculated | The insertion point of the connector on the joint edge. Can be dragged to reposition along the edge. |
| dLPart | Double | 180 mm | The longitudinal length of the metal plate. |
| dWPart | Double | 85 mm | The width of the metal plate. |
| dThicknessPart | Double | System Default | The thickness of the metal plate material. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| swap X-Y | Flips the orientation of the panel closer 180 degrees along its length vector. Useful if the connector is facing the wrong direction relative to the joint. |

## Settings Files
- **Filename**: `Panel Closer.dwg`
- **Location**: `hsbCompany\Block` folder or Current Drawing Blocks.
- **Purpose**: Provides the specific 3D geometry for the Cullen connector. If this file is missing, a generic rectangular box (Body) is drawn using the dimensions defined in the Properties Panel.

## Tips
- **Double-Click to Flip:** You can double-click the connector in the model to trigger the "swap X-Y" function instead of using the right-click menu.
- **Repositioning:** Use the grip point (Pt0) to slide the connector along the edge of the beam after insertion.
- **Automatic Detection:** Ensure the two selected beams physically touch or share a coplanar surface; otherwise, the script may fail to find a valid connection point.

## FAQ
- **Q: Why does my connector look like a simple box instead of a detailed metal plate?**
  **A:** The script could not find the `Panel Closer.dwg` block in your `hsbCompany\Block` folder or the current drawing. It is displaying the fallback generic body.
- **Q: The script reported "no common plane found".**
  **A:** The two beams you selected do not share a flat surface or are not aligned correctly for this type of connector. Check that the beams are touching or properly intersected.
- **Q: How do I change the size of the plate?**
  **A:** Select the connector, open the Properties Palette (Ctrl+1), and adjust the `dLPart` (Length) or `dWPart` (Width) values.