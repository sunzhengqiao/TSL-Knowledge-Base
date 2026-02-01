# Assign Milling to Openings (Slave).mcr

## Overview
Automatically assigns CNC milling operations (contours) to wall panel surfaces based on element openings (windows/doors) and the overall panel profile. It allows for precise control of tool paths, depths, and offsets for manufacturing preparation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto an Element in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script focuses on 3D/CAM data, not drawing annotations. |

## Prerequisites
- **Required entities**: An Element (e.g., Wall Panel) containing Openings and Sheets.
- **Minimum beam count**: 0 (Requires an Element, not standalone beams).
- **Required settings**: None (Uses OPM properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Assign Milling to Openings (Slave).mcr`

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the desired Wall Element in the model to attach the script.
```
*Note: Upon selection, the script instance is created. Configuration is done via the Properties Palette.*

### Step 3: Configure Parameters
```
Action: With the script instance selected, press [Ctrl + 1] to open the Properties Palette.
Action: Adjust the Milling Mode, Zone, Offsets, and Locations as required.
Action: The script automatically recalculates when parameters are changed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling mode | dropdown | \|Opening\| | Determines if milling follows the opening outline or where sheets intersect the opening. |
| Zone | number | 5 | The construction layer index to apply milling to (e.g., -5 to 5). |
| Tooling index | number | 1 | The CNC tool number to assign to these milling operations. |
| Side | dropdown | Left | The side of the material from which the milling is approached. |
| Turning direction | dropdown | Against course | The direction the tool travels around the profile (Climb vs Conventional). |
| Overshoot | dropdown | No | Extends the tool path beyond start/end points to avoid dwell marks. |
| Vacuum | dropdown | Yes | Enables vacuum hold-down flags for the CNC machine. |
| Milling Depth | number | U(9/16) | The depth of the cut (Z-axis). |
| Offset milling around opening | number | U(0) | Clearance gap added around the opening profile. |
| Offset milling panel top | number | U(0) | Shifts the milling path at the top edge of the panel. |
| Offset milling panel sides | number | U(0) | Shifts the milling path at the vertical sides of the panel. |
| Milling on top | dropdown | Yes | Enables or disables milling on the top horizontal edge. |
| Milling on top-left | dropdown | Yes | Enables or disables milling on the top-left corner. |
| Milling on left | dropdown | Yes | Enables or disables milling on the left vertical edge. |
| Milling on bottom-left | dropdown | Yes | Enables or disables milling on the bottom-left corner. |
| Milling on bottom | dropdown | Yes | Enables or disables milling on the bottom horizontal edge. |
| Milling on bottom-right | dropdown | Yes | Enables or disables milling on the bottom-right corner. |
| Milling on right | dropdown | Yes | Enables or disables milling on the right vertical edge. |
| Milling on top-right | dropdown | Yes | Enables or disables milling on the top-right corner. |
| Offset from hole edge | number | U(0) | Specific offset used when Mode is "Opening where sheets intersect". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: *None*
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Zone Selection**: Ensure the `Zone` parameter matches the actual layer (e.g., sheathing or structural) you wish to machine. If the zone is empty, no milling will be generated.
- **Openings with Sills**: If you select the simple "Opening" mode, the script automatically detects if a Sill beam is present and adjusts the bottom cut of the milling accordingly (creating a C-shape around the sill).
- **Partial Perimeter**: You can mill only specific sides of the panel by setting the "Milling on [Location]" properties to "No". This is useful for panels that are pre-cut on certain edges.
- **Sheet Intersection**: Use the "Opening where sheets intersect" mode if your wall has complex sheeting layouts (like staggered studs) and you only want to mill where the sheet material actually exists in the opening.

## FAQ
- **Q: Why don't I see any milling paths generated?**
  **A:** Check if the `Zone` selected actually contains sheets in your element. Also, ensure the `Milling on [Location]` options are not set to "No".
- **Q: How do I add a clearance gap for window foam tape?**
  **A:** Set the `Offset milling around opening` parameter to the desired width of the gap (e.g., 5mm or 1/4").
- **Q: Can I change the CNC tool after creating the script?**
  **A:** Yes, simply select the script instance and change the `Tooling index` in the Properties Palette. The update is immediate.