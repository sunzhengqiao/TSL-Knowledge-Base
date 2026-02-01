# BatchShopdrawing.mcr

## Overview
Automates the batch layout and nesting of multiple shop drawings (MultiPages) onto master sheets or PlotViewports in Model Space. It optimizes paper usage by calculating efficient placement of drawings based on defined margins and boundary smoothing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely in Model Space to nest MultiPages and create PlotViewports. |
| Paper Space | No | The output prepares drawings for plotting, but processing happens in Model Space. |
| Shop Drawing | No | This is a utility script that acts *on* shop drawings (MultiPages), not within the SD environment itself. |

## Prerequisites
- **Required entities**: Existing `MultiPage` entities, `PlotViewports`, or valid `Element`/`GenBeam` collections in Model Space.
- **Minimum beam count**: 0 (Script operates on drawing entities/containers).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BatchShopdrawing.mcr`

### Step 2: Define Sheet Boundary
```
Command Line: Specify insertion point [or Rectangle]:
Action: Click a point in Model Space to define the corner of your sheet (A0, A1, etc.), or drag to define a custom rectangular area.
```

### Step 3: Select Entities
```
Command Line: Select entities:
Action: Select the MultiPages, Elements, or GenBeams you wish to nest onto the defined sheet and press Enter.
```

### Step 4: Processing
*   The script calculates the bounding profiles of the selected entities.
*   It attempts to nest them efficiently within the boundary.
*   Successfully nested items are grouped; items that do not fit are moved to a "Left Over" pile.

### Step 5: Completion
The script instance erases itself, leaving behind the new layout borders (`TslInst`) and `PlotViewport` entities.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| color | PropInt | 7 (White/Black) | Sets the AutoCAD Color Index (ACI) for the border polyline drawn around the nested drawings. |
| margin | PropDouble | 0 | Defines the clearance spacing (in mm) between nested drawings and the sheet edge. |
| smoothing | PropDouble | 0 | Defines the maximum edge length (in mm) to be ignored when calculating the bounding shape. Higher values result in more rectangular (simplified) boundaries for better nesting. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Update/Recalculate* | Triggers the nesting logic again to re-arrange drawings based on current property settings (e.g., if you changed the margin). |

## Settings Files
- **Filename**: None used.

## Tips
- **Smoothing**: If your drawings have complex, jagged edges (e.g., many small notches), increase the **smoothing** value. This simplifies the bounding box, allowing the script to pack items tighter without getting stuck on small geometric details.
- **Left Overs**: If some drawings are moved to a "Left Over" pile, increase the size of your sheet boundary (via grips) or increase the margin spacing and recalculate.
- **Grip Editing**: After creation, you can select the border instance and use the **blue grips** (added in v2.4) to visually adjust margins or the boundary size, which will automatically update the layout.
- **Xref Support**: Use the specific properties (if configured) to enable selection of Xref entities if your drawings are referenced.

## FAQ
- **Q: Why are some of my drawings not nested?**
  - A: They likely did not fit within the defined sheet boundary or margin constraints. Check for a cluster of "Left Over" drawings near your sheet. You can create a new sheet boundary for these leftovers.
- **Q: How do I change the spacing between drawings?**
  - A: Select the resulting border instance, open the Properties (Ctrl+1), and change the **margin** value. The script will automatically update the layout.
- **Q: What does the smoothing property do?**
  - A: It ignores small notches or edges smaller than the specified value. Use this to prevent the script from creating complex, interlocking shapes that are hard to nest, forcing them into simpler rectangular clusters.