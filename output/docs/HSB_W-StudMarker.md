# HSB_W-StudMarker.mcr

## Overview
This script automates the creation of nailing lines (markers) on specific zones of timber elements (walls, floors, or roofs). It is used to visualize assembly or nailing zones on vertical studs within an element based on configurable properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates satellite instances on 3D Elements in the model. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Not designed for Shop Drawing generation. |

## Prerequisites
- **Required entities**: At least one timber Element (Wall, Floor, or Roof).
- **Minimum beam count**: 0 (Script processes existing beams; no new beams are created).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select HSB_W-StudMarker.mcr
```

### Step 2: Configure Properties
```
Action: A property dialog appears. Adjust settings like Element Type, Zone, or Mark Size if necessary.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Wall, Floor, or Roof elements in the drawing and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply tooling to element type(s) | dropdown | \|Roof\| | Filters which element types receive markers. Options include Roof, Floor, Wall, or combinations thereof. |
| Only mark beams with beamcode | text | | Optional filter to mark only beams with a specific Beam Code (e.g., "Stud"). Leave empty to mark all vertical beams. |
| Length markerline | number | 300 | The length of the nailing line drawn on the beam (in millimeters). |
| Apply tooling to | dropdown | Zone 1 | Selects the specific Material Zone (1-10) on which the markers are drawn. |
| Toolindex | number | 10 | The numeric identifier assigned to the marker for production or reporting purposes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. Use standard AutoCAD properties to edit. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Vertical Detection**: The script automatically detects and marks only vertical beams (studs) within the element. Horizontal plates and headers are ignored.
- **Beam Code Filtering**: Use the "Only mark beams with beamcode" property to exclude specific members, such as trimmer studs or jack studs, from the marking pattern.
- **Zone Management**: Use different "Apply tooling to" zones to represent different assembly steps (e.g., Zone 1 for sheathing nailing, Zone 2 for drywall) without conflicts.
- **Updates**: If you modify the element geometry (e.g., stretch a wall), the markers will automatically update their position to remain correct.

## FAQ
- **Q: I ran the script, but no lines appeared.**
- **A:** Check the "Apply tooling to element type(s)" property. If you selected a Wall but the property is set to "Roof", the script will filter it out. Also, ensure the element contains vertical beams.
- **Q: How do I remove the markers?**
- **A:** Select the element, open the Properties palette, select the TSL instance entry, and press Delete. Alternatively, erase the specific satellite instance in the model.