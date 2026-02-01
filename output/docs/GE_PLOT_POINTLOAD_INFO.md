# GE_PLOT_POINTLOAD_INFO

## Overview
This script creates a 2D graphical annotation in Model Space to indicate point loads, reinforcement requirements (studs, straps), or hardware connections (hold-downs) at specific locations on walls or trusses. It is typically used during layout design to visually mark where engineering details are required.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly in the 3D model to create 2D layout annotations. |
| Paper Space | No | Not designed for Paper Space viewport insertion. |
| Shop Drawing | No | This is a layout/modeling tool, not a manufacturing output script. |

## Prerequisites
- **Required Entities**: An `ElementWall` or `TrussEntity` must exist in the model to attach the annotation to.
- **Minimum Beam Count**: 0 (Not applicable).
- **Required Settings**: The `_DimStyles` catalog must be available in the project to control text sizing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_POINTLOAD_INFO.mcr` from the file browser.

### Step 2: Specify Location
```
Command Line: [No prompt displayed]
Action: Click in the drawing to specify the insertion point for the annotation marker.
```

### Step 3: Select Structural Element
```
Command Line: |Select wall or truss|
Action: Click on the desired Wall or Truss entity that the point load or connection applies to.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beams | number | 0 | Number of studs required at this location (e.g., type "3" for "3 STUDS"). |
| Floor to floor straps | number | 0 | Quantity of floor-to-floor tension straps required. |
| Strap length | number | 0 | Physical length of the strap in millimeters (e.g., 1200). |
| Strap forced to CS16 | dropdown | |No| | Select "|Yes|" to force the designation to CS16 standard; otherwise, it defaults to MSTA. |
| Hold down | text | | Part code or description for hold-down hardware (e.g., "HD5A"). This is hidden if Floor to floor straps > 0. |
| Connection at truss | text | | Part code for metal connecting hardware at the truss (e.g., "H2.5A"). |
| Number of metal parts for connection at truss | number | 0 | Quantity of metal parts for the truss connection. |
| Dimstyle | dropdown | | Selects the dimension style to control text height and font for the annotation. |
| Color | number | 2 | Sets the AutoCAD color index for the annotation lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Filename**: None specific (Script relies on system catalogs).
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visibility**: If the annotation disappears after insertion, check the Properties palette. If "Beams", "Floor to floor straps", and "Hold down" are all set to 0 or empty, the script erases itself automatically.
- **Straps vs. Hold Downs**: The script prioritizes Strap information. If you enter a value for "Floor to floor straps", the "Hold down" field will be ignored in the display.
- **Text Sizing**: To adjust the size of the annotation box and text, change the "Dimstyle" property in the palette rather than manually scaling the object.
- **Grip Editing**: You can click the grip point on the annotation to move it relative to the wall or truss it is attached to.

## FAQ
- **Q: Why did the annotation disappear immediately after I selected the wall?**
  A: This happens if the default properties are all zero/empty and the script detects nothing to display. Select the object (or re-insert) and use the Properties Palette (Ctrl+1) to enter values for "Beams", "Straps", or "Hold down".
- **Q: Can I use this on a beam?**
  A: No, this script is designed specifically to attach to `ElementWall` or `TrussEntity` types.
- **Q: How do I display a specific strap code like CS16-1200?**
  A: Set "Floor to floor straps" to at least 1, set "Strap length" to 1200, and change "Strap forced to CS16" to "|Yes|".