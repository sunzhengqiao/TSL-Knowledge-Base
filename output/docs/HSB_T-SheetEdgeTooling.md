# HSB_T-SheetEdgeTooling

## Overview
This script allows you to assign specific CNC edge tooling (RoundingTool) to a structural plate or sheet by selecting points along the desired edges. It is used during detailing to define which sides of a panel require edge profiling for manufacturing export.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D Model Space. |
| Paper Space | No | Not supported in Layouts/Shop Drawings. |
| Shop Drawing | No | Not applicable for Shop Drawing contexts. |

## Prerequisites
- **Required Entities**: A single structural **Sheet** (plate/panel) entity must exist in the model.
- **Minimum Beam Count**: 0 (This script targets Sheets, not beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Run the `TSLINSERT` command in AutoCAD and select `HSB_T-SheetEdgeTooling.mcr` from the list.

### Step 2: Select Target Sheet
```
Command Line: [Implicit Prompt]
Action: Click on the structural Sheet or Plate entity you wish to apply tooling to.
```

### Step 3: Define Edges
```
Command Line: Select point
Action: Click on the edge of the sheet where the CNC tooling should start/end.
```
*   Repeat this step for every edge segment that requires the 'RoundingTool'.
*   The script will project your clicks onto the nearest edge.

### Step 4: Finish Selection
```
Command Line: [Press Enter or Esc]
Action: Press Enter or right-click to finish selecting points.
```
The script will automatically calculate the geometry and apply the CNC instructions to the selected edges.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose editable parameters in the Properties Palette. All configuration is done via command line input and context menus. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add linesegment** | Prompts you to select a new point on the sheet. Adds a new tooling segment (RoundingTool) to the nearest edge. |
| **Remove lineSegment** | Prompts you to select an existing point. Removes the tooling segment associated with that point. |
| **Delete** | Removes the script instance and erases all associated CNC tooling data from the sheet. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently of external settings files.

## Tips
- **Openings are Ignored**: If you select a point on an inner hole or opening of the sheet, the script will skip it. Only points on the outer boundary profile will generate tooling.
- **Automatic Updates**: If you modify the geometry of the sheet (e.g., resize or move it) after inserting the script, the tooling will automatically update to stay attached to the correct edges.
- **Duplicate Prevention**: The script automatically detects if it is already attached to a sheet and will prevent duplicate instances.

## FAQ
- **Q: Can I use this to round the edges of an inner hole (cutout)?**
  - A: No, this script is currently designed to only process and apply tooling to the outer boundary profile of the sheet. Points selected on openings will be ignored.
- **Q: What happens if I delete the sheet the script is attached to?**
  - A: The script will automatically detect that the sheet is missing and erase itself to keep the project clean.
- **Q: How do I fix it if I selected the wrong edge?**
  - A: Right-click the script instance, select **Remove lineSegment**, and click the point corresponding to the incorrect edge. You can then use **Add linesegment** to select the correct one.