# hsb_IntegrateAllBeams2

## Overview
This script automatically generates T-connections (mortises and pockets) between two groups of beams (Male and Female) within a selected structural element. It utilizes the `hsbT-Connection` sub-script to machine the intersections, using Painter Definitions to identify which beams act as the entering member (Male) and which act as the receiving member (Female).

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements and GenBeams. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Not designed for 2D detailing. |

## Prerequisites
- **Required Entities**: A structural `Element` containing multiple beams (e.g., a floor assembly with joists and rim beams).
- **Minimum Beams**: At least two beams intersecting perpendicularly (one Male, one Female).
- **Required Settings**: Pre-configured **Painter Definitions** must exist in your hsbCAD environment to filter the Male and Female beams (e.g., a painter named "Joists" for Male beams and "Rim" for Female beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_IntegrateAllBeams2.mcr`.

### Step 2: Configure Properties (Dialog)
Upon launching, a dialog appears (unless run via a catalog preset).
- **Action**: Set the preferred **Depth** and **Gap** for the connections.
- **Action**: Select the **Painter Definitions** for "Male beams" and "Female beam".
- **Action**: Click OK to confirm.

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the structural Element(s) in the drawing that contain the beams you wish to connect.
```
- The script will process the element, filter the beams based on your Painter settings, and create or update the T-connections at all valid intersections.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | Number | 0 mm | The depth of the milling cut into the Female beam to accommodate the Male beam. |
| Gap | Number | 0 mm | The clearance allowance between the Male beam and the Female beam pocket. |
| Male beams | Dropdown | <Disabled> | Selects the Painter Definition used to identify the entering beams (e.g., joists). |
| Female beam | Dropdown | <Disabled> | Selects the Painter Definition used to identify the receiving beams (e.g., rim beams). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the machining based on changes to beam positions or property settings (Depth, Gap, Painters). |
| Save to Catalog | Saves the current configuration (Depth, Gap, and Painter selections) to a catalog file for future use. |

## Settings Files
- **Filename**: User-defined (e.g., `MyTConnectionSettings.cat`)
- **Location**: hsbCAD Catalog folder (Company or Install path).
- **Purpose**: Stores specific configurations for Depth, Gap, and Painter Definitions, allowing you to apply consistent settings across different projects using the "Execute" function.

## Tips
- **Painter Naming**: Ensure your beams in the model are assigned to the correct Painter Definitions before running this script. If the dropdown shows `<Disabled>`, the script will not create any connections.
- **Smart Updates**: If you run the script again on an existing instance, it will update existing connections (changing depth/gap) rather than creating duplicates, provided the beam pairs remain the same.
- **Perpendicular Logic**: The script specifically looks for perpendicular intersections (Up, Down, Left, Right) relative to the element's coordinate system.

## FAQ
- **Q: I ran the script, but no machining appeared.**
- **A: Check the "Male beams" and "Female beam" properties in the OPM. If they are set to `<Disabled>` or if the selected Painters do not match any beams in your element, no connections will be generated.
- **Q: Can I adjust the depth after inserting?**
- **A: Yes. Select the script instance in the model, change the "Depth" value in the Properties Palette, and right-click to "Recalculate".
- **Q: Does this work on curved beams?**
- **A: This script is designed primarily for orthogonal intersections (standard floor/roof joist layouts). Complex curved intersections may not be detected correctly.