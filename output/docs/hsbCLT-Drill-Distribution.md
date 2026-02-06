# hsbCLT-Drill-Distribution

## Overview
This script automates the creation and distribution of drills and sinkholes on CLT panels (Sip elements). It allows users to generate hole patterns based on intersections with structural beams or manually defined paths, with advanced options for spacing, alignment, and shop drawing dimensioning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported, but it can configure stereotypes for use in shop drawings. |

## Prerequisites
- **Required Entities**: At least one CLT Panel (Sip). Optionally, GenBeams or Polylines for automatic intersection.
- **Minimum Beam Count**: N/A (Depends on whether using intersection mode or manual definition).
- **Required Settings**: `TslUtilities.dll` must be loaded in the hsbCAD environment.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Drill-Distribution.mcr`

### Step 2: Select Panel
```
Command Line: Select Sip (Panel)
Action: Click on the CLT panel where you want to add holes.
```

### Step 3: Define Drill Path
```
Action: You will be prompted to select secondary objects (GenBeams or Polylines) that intersect the panel to define the drill line.
OR
Action: If no secondary objects are selected, you can manually draw points/polylines on the face of the panel to define the path.
```

### Step 4: Configure Properties
```
Action: Use the Properties Palette (OPM) to adjust hole diameters, depths, distribution modes (Fixed/Even), and alignment angles.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drill** | | | |
| Diameter | Number | 12.0 | Defines the diameter of the drill. |
| Depth | Number | 0.0 | Defines the depth of the drill (0 = complete through). |
| **Sinkhole** | | | |
| Diameter | Number | 63.0 | Defines the diameter of the sinkhole. |
| Depth | Number | 0.0 | Defines the depth of the sinkhole. |
| **Distribution** | | | |
| Mode | Dropdown | Fixed | Defines the distribution mode (Fixed or Even). |
| Interdistance | Number | 1000.0 | Defines the spacing between drills (or quantity in specific modes). |
| Rows | Number | 1 | Defines the number of rows for the drill pattern. |
| Row Offsets | Text | | Specify row offsets, separated by semicolons (e.g., '200;150;200'). |
| Column Offsets | Text | | Specify column offsets, separated by semicolons (e.g., '200;150;200'). |
| **Alignment** | | | |
| Face | Dropdown | Reference Face | Defines the working face (Reference Face or Top Face). |
| Bevel | Number | 0.0 | Defines the angle of the drill axis relative to the face (-90° to 90°). |
| Rotation | Number | 0.0 | Defines the rotation of the drill axis perpendicular to the segment (-90° to 90°). |
| **Dimension** | | | |
| Format | Text | @(Quantity-2)x @(|Diameter|) | Defines the dimension string format. |
| Stereotype | Dropdown | \<Disabled\> | Defines the dimension stereotype (select from MultiPageStyle entries). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Edit In Place** | Erases the script instance and allows manual editing of the underlying elements. Can also be triggered by Double Click. |
| **Add Panels** | Prompts you to select additional CLT panels (Sip) to include in the drill distribution. |
| **Add secondary objects** | Prompts you to select GenBeams or Polylines to calculate new intersection points for drills. |
| **Remove genbeams** | Prompts you to select specific GenBeams to remove from the calculation. |
| **Convert To Polyline** | Converts the calculated drill path into physical polylines and disconnects them from the script logic. |
| **Convert To Grip Points** | Replaces the current logic-based definition with a new instance defined by grip points at the current vertices. |
| **Revert Direction** | Toggles the direction of the drill calculation vector (flips the operation side). |
| **Configure Shopdrawing** | Opens a dynamic dialog to configure Dimension Format and Stereotype settings. |

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: hsbCAD Install path
- **Purpose**: Provides functionality for dynamic dialogs and utilities used by the script.

## Tips
- **Staggered Patterns**: Use the "Row Offsets" and "Column Offsets" parameters to create complex staggered drilling patterns (e.g., for nail plates).
- **Fixed vs. Even**: Use "Fixed" mode to set a specific gap between holes. Use "Even" mode to distribute a calculated number of holes equally across the length.
- **Angled Drilling**: You can drill at an angle by adjusting the "Bevel" and "Rotation" properties under Alignment, which is useful for connections.
- **Freezing Geometry**: If you want to stop the holes from updating automatically when beams move, use the "Convert To Polyline" option.

## FAQ
- **Q: What does Depth 0 mean?**
  **A**: A depth of 0.0 means the drill (or sinkhole) will go completely through the panel thickness.
- **Q: Can I use this on curved walls?**
  **A**: The script works on Sip (CLT) elements. Ensure the panels are coplanar; the script may skip panels that are not parallel to the reference face.
- **Q: How do I add holes to multiple panels at once?**
  **A**: After inserting the script on one panel, use the "Add Panels" right-click menu option to select additional panels to process.