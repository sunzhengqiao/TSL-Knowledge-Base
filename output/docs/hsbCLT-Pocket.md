# hsbCLT-Pocket.mcr

## Overview
This script creates configurable rectangular or rounded pockets (cavities) in CLT panels or beams. It includes a built-in library to manage CNC tool definitions, ensuring the correct diameter and tool index are assigned for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to a CLT panel or beam in the 3D model. |
| Paper Space | No | Not intended for direct layout in 2D views. |
| Shop Drawing | No | Generates 3D geometry and machining data only. |

## Prerequisites
- **Required Entities**: A GenBeam or Element (CLT Panel).
- **Minimum Beam Count**: 1
- **Required Settings**: `hsbCLT-Freeprofile.xml` (Tool library configuration file).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Pocket.mcr`

### Step 2: Select Element
```
Command Line: Select beam/element:
Action: Click on the CLT panel or beam where you want to insert the pocket.
```

### Step 3: Define Insertion Point
```
Command Line: Give insertion point:
Action: Click on the face of the selected element to place the pocket.
```

### Step 4: Configure Properties
After insertion, the script runs in "Geometry Mode". You can adjust dimensions and select tools immediately via the Properties Palette (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Tool | Dropdown | Selects the CNC tool from the library. This sets the corner radius and assigns the tool number for export. |
| Pocket Width | Number | The length of the pocket along the beam's X-axis. |
| Pocket Depth | Number | The length of the pocket along the beam's Y-axis. |
| Pocket Height | Number | The vertical depth of the cut into the material. |
| X-Offset | Number | Moves the pocket center relative to the insertion point along the X-axis. |
| Y-Offset | Number | Moves the pocket center relative to the insertion point along the Y-axis. |

*(Note: When managing tools via the Right-Click menu, additional properties for Diameter, Length, and Tool Index become available.)*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Edit Tool Definition | Opens a dialog to create new CNC tools or modify existing ones (Diameter, Length, Index, Name). |
| Remove Tool Definition | Deletes the selected tool from the project library. |
| Import Settings | Reloads the tool library from the `hsbCLT-Freeprofile.xml` file. |
| Export Settings | Saves the current tool library definitions to the XML file for sharing or backup. |
| Stretch Dimension | Activates grips to stretch the pocket width or depth interactively. |
| Extend Radius in Direction | Modifies the pocket contour to add a tangential radius extension. |

## Settings Files
- **Filename**: `hsbCLT-Freeprofile.xml`
- **Location**: Company Standard Folder or hsbCAD Installation Path.
- **Purpose**: Stores the persistent list of available CNC tools (Name, Diameter, Length, and Tool Index). If this file is missing, the script creates a default map object in the drawing.

## Tips
- **Large Pockets**: If the pocket width exceeds 1000mm, the script automatically generates it as a "FreeProfile" (extrusion body) to ensure compatibility with BTL/CNC export limits.
- **Tool Management**: Use the context menu to set up your tools once. They are saved in the drawing and can be reused without re-entering data.
- **Flipping Orientation**: Double-click on the script instance to toggle the reference face to the opposite side of the panel.

## FAQ
- **Q: I get an error "The tool could not be set as index is already used for another tool".**
  - A: Every tool in the library must have a unique Index number. Open the Tool Definition menu and assign a unique index (e.g., T1, T2) to the tool you are trying to save.
- **Q: Why did my pocket turn into a complex solid instead of a simple pocket?**
  - A: This likely happened because the width is very large (>=1000mm). The script does this automatically to prevent export errors.
- **Q: How do I change the corner radius of the pocket?**
  - A: The radius is determined by the "Tool" selected in the properties. To change the radius, either select a different tool or edit the tool's diameter via the "Add/Edit Tool Definition" menu.