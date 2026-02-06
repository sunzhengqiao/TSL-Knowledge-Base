# hsb_IntegrateStudsOnPlates.mcr

## Overview
This script automates the creation of joinery between studs and plates. It generates matching notches (or birdsmouths on angled plates) to integrate studs into the top and bottom plates for better structural stability and air tightness.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where elements are located. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script modifies the 3D model geometry directly. |

## Prerequisites
- **Required Entities**: Elements (walls/panels) containing Top Plates, Bottom Plates, and Studs.
- **Minimum Beam Count**: At least 2 beams per element (1 Plate and 1 Stud).
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or access via the hsbCAD Menu).
Action: Browse to and select `hsb_IntegrateStudsOnPlates.mcr`.

### Step 2: Configure Properties
Action: Before selecting elements, the Properties Palette will appear.
*   Locate the **Depth inside Plate** (`dDepth1`) parameter.
*   Enter the desired depth for the notch (e.g., 10mm).
*   *Note: This setting is ignored for angled top plates (which use a birdsmouth instead).*

### Step 3: Select Elements
```
Command Line: Please select Elements
Action: Click on the Wall/Panel Elements you wish to process and press Enter.
```
Action: The script will process the selection, add the cuts to the studs and plates, and then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth inside Plate | Number | 10 mm | Defines how deep the stud sits inside the plate. The stud end is cut back by this amount, and a matching notch is cut into the plate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script cleans up automatically after running; no right-click context menu is available. |

## Settings Files
- None.

## Tips
- **Angled Top Plates**: The script automatically detects if a top plate is angled. It applies a birdsmouth cut instead of a standard notch, and the "Depth inside Plate" setting is ignored (set to 0 offset).
- **Beam Filtering**: The script intelligently filters out horizontal beams (like noggings or blocking) and only processes vertical studs intersecting the plates.
- **Undo Function**: Since the script deletes itself after execution, use the AutoCAD `Undo` command if you need to change the notch depth and run the script again.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  - A: This is a "generator" script. It performs its job (adding the cut tools) and removes itself to keep your drawing clean. The cuts remain on the beams.
  
- **Q: Can I use this to create birdsmouths for rafters?**
  - A: No, this script is specifically designed for wall framing (Studs integrated into Top/Bottom Plates). It filters specifically for vertical beams.

- **Q: The stud didn't get cut. Why?**
  - A: Ensure the stud is actually intersecting the plate volume. The script uses a 10mm geometric tolerance to find connections. Also, ensure the stud is vertical; horizontal beams are skipped automatically.