# hsbFillet.mcr

## Overview
This script creates decorative or functional fillets (rounded edges) on timber beams. It allows you to apply a fillet around the entire beam circumference or along a specific user-defined path on the beam surface.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script explicitly runs in Model Space. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a modeling/scripting tool, not a detailing tool. |

## Prerequisites
- **Required Entities:** At least one GenBeam (Timber Beam) must exist in the drawing.
- **Minimum Beam Count:** 1.
- **Required Settings:** None specific to external files.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbFillet.mcr` from the file dialog.

### Step 2: Configure Insertion Mode
A dialog will appear upon insertion (if no command key is preset). You can adjust the **Insertion Mode**, **Alignment**, and **Depth** here or later in the Properties Panel. Click OK to proceed.

### Step 3: Select Beam(s)
```
Command Line: Select beam(s)
Action: Click on one or multiple beams in the model.
```
*Note: If in "Path" mode, only the first beam selected will be processed. If in "Circumference" mode, all selected beams will be processed.*

### Step 4: Define Path (Path Mode Only)
*If you selected **Circumference** mode, the script finishes automatically after selection. If you selected **Path** mode, proceed to the following prompts:*

```
Command Line: Select first point on beam
Action: Click a point on the beam surface where the fillet should start.
```

```
Command Line: Select next point on same ring
Action: Click the end point on the same cross-sectional ring (contour) to define the length of the fillet.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Insertion Mode | dropdown | Circumference | Determines if the fillet is applied around the whole beam or along a specific path. Options: `Circumference`, `Path`. |
| (B) Alignment | dropdown | Reference Side | Sets the side of the beam to apply the fillet relative to the reference face. Options: `Reference Side`, `Opposite Side`, `Both Sides`. |
| (C) Depth | number | 4 | The distance the fillet cuts into the material from the edge (in mm). |
| ToolIndex | number | 1 | The identifier for the CNC tool to be used for this operation. |
| Radius | number | 80 | The physical radius of the milling cutter used to calculate the fillet curvature (in mm). |

## Right-Click Menu Options
*None specific to this script were detected in the analysis.*

## Settings Files
*No external settings files (XML) are required for this script.*

## Tips
- **Bulk Processing:** Use the **Circumference** mode if you need to round the edges of many beams at once. You can select multiple beams during the insertion prompt.
- **Path Selection:** When using **Path** mode, ensure your two points are on the same "ring" (cross-section) for the best results. The script calculates the geometry based on the beam's reference system.
- **CNC Data:** Ensure the **ToolIndex** matches your actual machine library to ensure the correct tool is selected during manufacturing.
- **Visualizing Depth:** The **Depth** parameter controls how "sharp" or "deep" the roundover is. Larger values create a more aggressive cut.

## FAQ
- **Q: I selected multiple beams, but only the first one got a fillet. Why?**
  **A:** You are likely using **Path** mode. In Path mode, the script only processes the single beam you are interacting with to define the start and end points. Switch to **Circumference** mode to process multiple beams simultaneously.
- **Q: How do I round the bottom edge only?**
  **A:** Set the **Alignment** property to `Reference Side` or `Opposite Side` depending on how your beam is constructed and which side you need. Use `Both Sides` to round symmetrical edges.
- **Q: What does the Radius property actually do?**
  **A:** It simulates the size of the cutter. A larger radius creates a gentler, shallower curve, while a smaller radius creates a tighter, more pronounced roundover.