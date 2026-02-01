# HSB_E-Markerlines

## Overview
This script automatically draws layout or machining marker lines on structural elements (Walls, Floors, or Roofs). It calculates where filtered beams (such as studs or rafters) intersect a specific construction layer (Zone) and draws lines to mark those positions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model. |
| Paper Space | No | Not intended for 2D layouts. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: An Element (Wall, Floor, or Roof) containing GenBeams.
- **Minimum Beam Count**: 1 beam in the target zone to mark.
- **Required Settings**: The script `HSB_G-FilterGenBeams.mcr` must be loaded in the drawing to use the filtering features.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_E-Markerlines.mcr`.

### Step 2: Configure Properties
1. Upon insertion, a dialog box appears displaying the script properties.
2. Adjust settings such as the **Element Type** (Roof/Floor/Wall) and **Direction** (Vertical/Horizontal).
3. Click **OK** to confirm.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall, Floor, or Roof elements you wish to process. Press Enter to finish selection.
```
The script will attach to the elements and generate the marker lines immediately.

## Properties Panel Parameters

### Selection Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Apply tooling to element type(s)** | dropdown | Roof | Limits the script to specific element types (e.g., only Roof, or both Roof and Floor). |
| **Filter beams with beamcode** | text | (Empty) | Enter beam codes to EXCLUDE. Separate multiple codes with a semicolon (;). |
| **Exclude modules** | dropdown | \|No\| | If set to \|Yes\|, beams belonging to a module (sub-assembly) are ignored. |
| **Filter definition beams** | dropdown | (Empty) | Select a predefined filter from `HSB_G-FilterGenBeams` to filter beams by size or name. |
| **Genbeam Painter** | dropdown | \|Genbeam Painter\| | Select a "Painter" definition to visually filter beams by color or selection set. |

### Tooling Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length markerline** | number | 300 | The length of the mark drawn on the timber (in mm). |
| **Offset markerline** | number | 0 | Moves the start point of the mark along the beam axis (in mm). |
| **Apply tooling to** | dropdown | Zone 1 | The specific construction layer (Zone) where the marks will be drawn. |
| **Direction** | dropdown | \|Vertical\| | Filters beams based on alignment. \|Vertical\| marks beams parallel to the element's Y-axis (studs). \|Horizontal\| marks beams parallel to the X-axis (plates). |
| **Toolindex** | number | 10 | The operation number assigned to these marks for CNC/Data export. |

## Right-Click Menu Options
*Note: This script relies primarily on the Properties Palette for modifications. Standard context menu options apply.*

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties palette to edit the script parameters and update the geometry. |
| Erase | Removes the script and all generated marker lines from the element. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Location**: TSL Catalog path
- **Purpose**: Provides advanced beam filtering logic (length, width, name) used by the "Filter definition beams" property.

## Tips
- **Avoid Clutter**: Use the "Filter beams with beamcode" to exclude blocking or short cripple studs that do not need layout lines.
- **Shift Marks**: If your beams have machining (like tenons) at the ends, use "Offset markerline" to shift the mark inward so it doesn't overlap the machining.
- **Zone Selection**: Ensure "Apply tooling to" matches a Zone that actually exists in your element construction (e.g., if marking studs on a bottom plate, select the Zone corresponding to that plate).

## FAQ
- **Q: Why did the script fail to insert?**
  - A: Ensure that `HSB_G-FilterGenBeams.mcr` is loaded in the drawing. The marker script depends on it for filtering beams.
- **Q: The lines appeared on the wrong beams (e.g., on plates instead of studs).**
  - A: Check the **Direction** property. Switch between \|Vertical\| and \|Horizontal\| to change which beams are marked.
- **Q: No lines appeared on my element.**
  - A: Check the **Apply tooling to element type(s)**. If you selected a Wall but the property is set to "Roof", the script will skip that element.
- **Q: Can I move the lines after they are created?**
  - A: The lines are generated automatically. To move them, change the "Offset markerline" property in the Properties palette.