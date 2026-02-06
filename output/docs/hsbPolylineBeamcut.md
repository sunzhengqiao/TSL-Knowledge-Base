# hsbPolylineBeamcut

## Overview
This script creates a continuous slot, channel, or housing cut across one or multiple beams or panels based on a defined path. It is ideal for routing service trenches, milling decorative grooves, or creating complex linear connections along structural elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs exclusively in Model Space to modify 3D geometry. |
| Paper Space | No | Not intended for 2D drawings or views. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities**: GenBeam, GenPanel, or Sheet entities.
- **Minimum beam count**: At least 1 beam must be selected during insertion.
- **Required settings**: Dimension Styles (optional, used only if annotation is enabled).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbPolylineBeamcut.mcr` from the file dialog.

### Step 2: Select Beams
```
Command Line: Select genbeam(s)
Action: Click on the beam(s) or panel(s) you wish to cut. Press Enter to confirm selection.
```
*Note: The script will exit if no beams are selected.*

### Step 3: Define Cut Path
```
Command Line: Select polyline(s) (<Enter> to pick points)
Action: 
- Option A (Polyline): Select one or more existing polylines in the model to define the cut shape.
- Option B (Points): Press Enter to draw the path manually.
```

### Step 4: Define Points (If Option B selected)
```
Command Line: Pick start point
Action: Click the location where the cut should begin.
```
```
Command Line: Select next point
Action: Click subsequent points to define the path. A preview line will appear. Press Enter to finish the path.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Alignment** | dropdown | Reference Side | Sets which face of the beam is used as the reference (Reference Side vs Opposite Side). |
| **Side** | dropdown | Center | Positions the cut relative to the beam centerline (Left, Center, or Right). |
| **Depth** | number | 20 mm | The depth of the cut into the material. |
| **Width** | number | 30 mm | The width of the cut slot. |
| **Content** | dropdown | no Content | Controls whether dimensions (Width & Depth) are annotated on the beam. |
| **Dimstyle** | dropdown | Current | Selects the dimension style to use for annotations. |
| **Text Height** | number | 40 mm | Sets the height of the annotation text. |
| **Reference** | dropdown | Convert into Grippoints | Determines if the original polyline is kept or converted to draggable grip points. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add entities** | Allows you to select additional beams or panels to include in the existing cut operation. |
| **Remove entities** | Allows you to select specific beams or panels to remove from the cut operation. |
| **Flip Side** | Toggles the Alignment property and inverts the Left/Right positioning. This can also be triggered by double-clicking the script instance. |

## Settings Files
None specified. This script operates using standard OPM properties and does not require external XML setting files.

## Tips
- **Editing the Path**: If you set "Reference" to **Convert into Grippoints**, you can drag the blue grips in the model to adjust the cut shape. If set to **Keep Polyline**, simply use standard AutoCAD PEDIT commands on the polyline to update the cut.
- **Arcs**: If you select a polyline with curved (arc) segments, the script will automatically convert them into straight segments (chords).
- **Double-Click**: You can quickly flip the cut to the opposite side of the beam by double-clicking the script instance in the model.
- **Multiple Beams**: You can select multiple non-parallel beams during insertion; the script will project the cut path onto all selected elements.

## FAQ
- **Q: What happens if I delete the beams associated with this script?**
- **A:** The script detects that there are no beams to process and will automatically erase itself to prevent errors.
- **Q: Can I change the size of the cut after inserting it?**
- **A:** Yes, select the script instance and change the "Width" or "Depth" values in the Properties Palette. The 3D model will update immediately.
- **Q: Why did my arc disappear?**
- **A:** The script approximates arcs using straight lines. Ensure your polyline segment length is short enough if you need a smooth curve.