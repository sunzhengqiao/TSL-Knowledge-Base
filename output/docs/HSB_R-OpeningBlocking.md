# HSB_R-OpeningBlocking

## Overview
Automatically generates blocking timber (noggins/stiffeners) between roof rafters and the top/bottom trimmer beams of roof openings. This script helps stabilize roof structures around dormers or skylights by adding structural connections based on specific geometric rules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model where Elements and Openings exist. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required entities**: Roof Elements (Element) containing valid Roof Openings (`OpeningRoof`) and GenBeams (rafters/trimmers).
- **Minimum beam count**: 1 (though typically requires multiple beams forming a roof structure).
- **Required settings**: The catalog or script `HSB_G-FilterGenBeams` must be available and configured to define which beams are treated as rafters versus trimmers.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD Toolpalette)
Action: Browse and select `HSB_R-OpeningBlocking.mcr`.

### Step 2: Select Elements
```
Command Line: Select one or more elements
Action: Click on the roof element(s) that contain the openings where you want to add blocking.
```

### Step 3: Configure Parameters
Action: After insertion, select the generated instance (or the Element) and press `Ctrl+1` to open the Properties Palette. Adjust the blocking length or filters as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filters** | | | |
| Filter openings with description | Text | "" | Enter a description text (e.g., "Dormer") to only generate blocking for openings matching this name. |
| Filter definition female beams | Dropdown | <Empty> | Select a filter preset from `HSB_G-FilterGenBeams` to identify which beams are trimmers (horizontal) and rafters (vertical). |
| **Blocking** | | | |
| Length | Number | 300 | The length of the blocking timber extending from the trimmer towards the rafter (in mm). |
| Reference side | Dropdown | Outside | Determines if the blocking geometry is calculated from the "Outside" or "Inside" face of the roof element. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the blocking geometry based on changes to the roof, openings, or properties. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams`
- **Purpose**: This script/catalog provides the logic to filter beams. Ensure the desired filter (e.g., specific beam names or layers) is defined there so the "Filter definition female beams" dropdown has valid options.

## Tips
- **Beam Recognition**: If blocking appears in the wrong place or not at all, check the **Filter definition female beams** setting. The script relies on correctly identifying which beams are horizontal (trimmers) and which are vertical (rafters).
- **Positioning**: If the blocking is generated inside the roof sheathing instead of flush with the structural rafters, toggle the **Reference side** between "Outside" and "Inside".
- **Multiple Elements**: You can select several roof elements during insertion to apply blocking to all of them simultaneously.

## FAQ
- **Q: Why is no blocking generated even though I have openings?**
  - A: Check the **Filter openings with description** field. If it is not empty, only openings matching that text exactly will be processed. Also, ensure the `HSB_G-FilterGenBeams` filter is correctly identifying the beams surrounding the opening.
- **Q: The blocking length is too short/long.**
  - A: Change the **Length** property in the Properties Palette. The value is in millimeters.
- **Q: Can I use this for wall openings?**
  - A: No, this script is specifically designed for Roof Openings (`OpeningRoof` entities) and their associated geometry.