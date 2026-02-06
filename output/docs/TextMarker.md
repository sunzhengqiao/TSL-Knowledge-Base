# TextMarker.mcr

## Overview
This script automates the application of text labels (production codes, element numbers) onto specific faces of timber beams or wall elements. It is used to mark assembly numbers or project data directly on the 3D model for fabrication or on-site identification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to add tools to beams. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Modifies the 3D entity, not the 2D layout. |

## Prerequisites
- **Required Entities:** GenBeams (timber beams) or Elements (walls/roofs).
- **Minimum Beam count:** 0 (Depends on selection; script applies to selected entities).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TextMarker.mcr`

### Step 2: Configure Properties
Upon launching, the Properties Palette (OPM) will display.
- Adjust settings like **Text Height**, **Format**, and **Orientation** as needed before proceeding.

### Step 3: Select Entities
```
Command Line: Select elements or individual genbeams
Action: Click on a Wall/Element or select specific GenBeams in the drawing.
```

### Step 4: [Optional] Pick Insertion Point
*This step only appears if you selected exactly one GenBeam in Step 3.*
```
Command Line: Select point (optional)
Action: Click on the specific location on the beam where you want the text center to be placed. 
Note: If skipped, the text is placed automatically based on Alignment settings.
```

### Step 5: Processing
The script will create the text markers on the selected beams based on your Filter and Orientation settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | Text | `@(ElementNumber)_@(ProjectName)_@(ProjectComment)` | The text content to be stamped. Use tokens like `@(ElementNumber)` to pull data from the database. |
| Text Height | Number | `60` | The physical height of the text characters in millimeters. |
| Text Orientation | Dropdown | `Outside` | Determines which face the text is applied to. **Options:** Outside, XZ-Plane, XY-Plane, YZ-Plane, Negative variants. *Note: 'Outside' requires the beam to be part of a wall element.* |
| Alignment | Dropdown | `Top-Left` | The justification point relative to the insertion point (e.g., Top-Left, Center-Center, Bottom-Right). |
| Angle | Number | `0` | Rotation angle of the text in degrees. |
| Filter | Dropdown | `Frame` | Filters which beams within a selected Element are marked. **Options:** Disabled, Frame, X-Parallel, Y-Parallel, Non Orthogonal. *Example: Select 'Frame' to mark only top/bottom plates, leaving studs unmarked.* |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to modify text content, size, or filter. |
| Delete | Removes the script instance and the associated text markers. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the Properties Palette for configuration; no external settings files are required.

## Tips
- **Marking Walls:** When selecting a whole Element (Wall), use the **Filter** property to avoid marking every single stud. Selecting "Frame" will typically mark only the perimeter plates.
- **"Outside" Orientation:** If you select "Outside" for orientation but the text disappears, ensure the beam is part of a Wall Element (Zone 0). If marking loose beams, switch to a geometric plane (e.g., XZ-Plane).
- **Dynamic Text:** You can combine tokens in the **Format** field, such as `Pos: @(ElementNumber) - L: @(Length)`, to create detailed labels.
- **Grip Points:** If you insert the script on a single beam and pick a point, you can later select the script instance and drag the grip point to move the text to a different location.

## FAQ
- **Q: Why did my text not appear on some beams?**
- **A:** Check your **Filter** setting. If set to "Frame" or "X-Parallel," beams that do not match this description will be skipped. Also, ensure the **Text Orientation** is valid (e.g., "Outside" won't work on interior studs without a clear exterior face).

- **Q: Can I use this for individual loose beams?**
- **A:** Yes, but change the **Text Orientation** from "Outside" to a specific plane (like "XZ-Plane" or "XY-Plane"), as "Outside" relies on the wall element's geometry.

- **Q: How do I display the Project Name on the beam?**
- **A:** In the **Format** property, type `@(ProjectName)`. You can mix this with text, e.g., `Project: @(ProjectName)`.