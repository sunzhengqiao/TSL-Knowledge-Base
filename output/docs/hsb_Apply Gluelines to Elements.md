# hsb_Apply Gluelines to Elements

## Overview
This script automatically calculates and generates glue lines on timber construction elements (such as walls or floors) based on the interference between structural beams and sheeting materials. It allows for complex zoning and tooling assignments to facilitate CNC manufacturing and shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the 3D model to calculate geometric interference between beams and sheets. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Calculates 3D model data only. |

## Prerequisites
- **Required Entities**: A parent Element (Wall, Floor, Roof, or generic Element) containing both GenBeams (studs/joists) and Sheets (sheathing).
- **Minimum Beam Count**: 1 (The parent element must contain structural members).
- **Required Settings**: None specific (uses standard hsbCAD entities).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse and select `hsb_Apply Gluelines to Elements.mcr`.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the Wall, Floor, Roof, or Element group in the model you wish to process.
```

### Step 3: Configuration and Calculation
1.  Once selected, the script anchors to the element and calculates the interference.
2.  Use the **Properties Palette** (Ctrl+1) to adjust settings if the initial result needs refinement (e.g., changing minimum line length or adjusting zones).
3.  The script updates automatically when properties are changed or the model geometry is modified.

## Properties Panel Parameters

### Global Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Merge sheeting to glue? (sJoinSheet) | Yes/No | No | If 'Yes', treats adjacent sheets as one continuous shape, allowing glue lines to cross sheet joints. |
| Minimum length of glue line (dMinimumGlueLineLength) | Number | 0 | Filters out glue lines shorter than this value (in mm) to reduce manufacturing noise. |
| Dim Layout (sDimLayout) | String | (Empty) | Specifies the dimension style for annotations (if used). |
| Display Representation (sDispRep) | String | (Empty) | Filters visibility of glue lines to specific display representations (e.g., Plan, Model). |

### Zone Settings (Repeated for Zones 1 through 10)
The script uses 10 independent logical zones to define different gluing areas or machine instructions.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nail Y/N (nNailYN) | Yes/No | No | Master switch for the zone. Set to 'Yes' to enable glue line calculation for this zone. |
| RefZ (nRefZ) | Index | 0 | Maps this logical zone to a specific geometric zone defined in the parent element (e.g., Zone 0 = Main Area, Zone 1 = Left Gable). |
| Tooling Index (nToolingIndex) | Integer | 1 | Assigns a specific manufacturing ID or Glue Gun number to the lines in this zone. |
| DistEdge (dDistEdge) | Number | 20 | The offset distance (in mm) from the beam or sheet edge where the glue line starts and ends. |
| Material Zone (strMaterialZone) | String | (Empty) | Filters glue generation to only occur on sheets matching this material name (e.g., "OSB"). Leave empty to use all sheets. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-run the interference calculation based on current geometry and properties. |
| Delete | Removes the script and all generated glue lines from the element. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the geometry of the selected Element and the properties set in the palette. No external XML or INI files are required.

## Tips
- **Truss Support**: If your element contains Trusses (Version 1.5+), the script will automatically include the internal beams of the truss in the gluing calculation.
- **Continuous Lines**: If you want glue lines to run seamlessly across multiple sheets (e.g., for a long wall), set `Merge sheeting to glue?` to **Yes**.
- **Material Specificity**: To glue only specific layers (e.g., glue the OSB but not the Plywood), enter "OSB" in the `Material Zone` parameter for the desired zone number.
- **Troubleshooting Missing Lines**: If you expect glue lines but don't see them, check the `Minimum length of glue line` setting. Small overlaps might be filtered out if this value is too high.

## FAQ
- **Q: Why are glue lines not appearing on my gable ends?**
  A: Check the `RefZ` setting for your active zones. The script only applies glue to beams that belong to the geometric zone index specified in `RefZ`. Ensure your parent element has zones defined at the gables and that your script zone matches that index.
- **Q: Can I assign different glue guns to different parts of the wall?**
  A: Yes. Use Zone 1 for the main wall with `Tooling Index` 1, and enable Zone 2 for a specific area (like a gable) with `Tooling Index` 2, ensuring the `RefZ` for Zone 2 points to the gable geometry zone.
- **Q: Does this work with curved walls?**
  A: The script calculates interference based on geometry. As long as the sheets and beams overlap correctly in 3D space, the glue lines will be generated.