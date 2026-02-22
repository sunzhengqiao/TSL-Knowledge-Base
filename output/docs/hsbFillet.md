# hsbFillet

## Overview

`hsbFillet` cuts a quarter-round chamfer (fillet) along the edge of a timber beam. The rounded profile is machined into the beam by applying a `SolidSubtract` body for 3D visualization and a `PropellerSurfaceTool` for CNC routing output.

Two operating modes are available:

- **Circumference mode** -- the fillet runs around the full perimeter of the beam cross-section on the selected face(s). Supports batch-processing multiple beams in one operation.
- **Path mode** -- the fillet runs along a user-defined segment of the beam perimeter, picked by two points on the beam surface.

The script calculates the exact arc geometry from the tool radius and requested depth, ensuring the fillet is tangent to both faces of the beam corner. Curved (glulam) beams are supported in both modes.

All tooling data is written to the beam via `addTool`, so the fillet appears in 3D, in fabrication drawings, and in CNC machine output automatically.

**Script version:** 1.3 (03 August 2020)
**Author:** david.delombaerde@hsbcad.com

---

## Usage Environment

| Environment | Supported | Notes |
|---|---|---|
| Model Space (3D) | Yes | All instances are created in Model Space. |
| Paper Space / Layout | No | This is a 3D machining tool. |
| Shop Drawing | No | Fillet data feeds into CNC output, not shop drawing layout. |

- **Script type:** O-Type (Object). `#NumBeamsReq 0` -- beams are selected interactively during insertion.
- **External settings files:** None required.

---

## Prerequisites

1. At least one timber beam (`GenBeam`) must exist in the drawing. If no beam is selected, the instance is removed silently.
2. In Path mode, the two pick points must lie on the same cross-sectional perimeter contour of the beam.
3. The requested Depth must be geometrically compatible with the Tool Radius. If the depth is too large, it is automatically clamped to the maximum valid value and a warning is displayed: `Depth of tool is not valid. Depth will be set to the maximum depth.`
4. For curved beams in Path mode, the beam must have a valid `CurvedStyle` defined.

---

## How to Use

### Step 1 -- Launch the tool

Type `hsbFillet` at the AutoCAD command prompt or activate it from the hsbCAD tool palette.

### Step 2 -- Set parameters in the dialog

A settings dialog opens automatically. Set:
- **Insertion Mode** -- Circumference (full perimeter) or Path (user-defined segment).
- **Alignment** -- which face of the beam receives the fillet.
- **Depth** -- material removal depth for the roundover.

If launched with a catalog key (silent mode), the dialog is skipped and catalog settings are applied directly.

### Step 3 -- Select beams

The command line prompts: **Select beam(s)**

Select one or more beams using standard AutoCAD selection methods.

- In **Circumference mode**, all selected beams are processed. One fillet instance is created per beam.
- In **Path mode**, only the first selected beam is processed.

### Step 4 -- Define the path segment (Path mode only)

Two additional prompts appear:

1. **Select first point on beam** -- Click a point on the beam surface. The script snaps it to the nearest cross-sectional contour.
2. **Select next point on same ring** -- Click a second point on the same perimeter contour.

After both points are picked, the script highlights one of the two possible paths between the points. Press Enter to accept, or type `S` (SwapDirection) to switch to the other direction around the perimeter.

### Step 5 -- Review and adjust in OPM

After insertion, select any fillet instance and open the Properties Palette (Ctrl+1) to modify parameters. Changes recalculate immediately.

---

## Properties Panel (OPM Parameters)

### General

| Property | Type | Default | Options / Range | Description |
|---|---|---|---|---|
| **(A) Insertion Mode** | String (dropdown) | Circumference | Circumference; Path | Full beam perimeter or user-defined segment. |
| **(B) Alignment** | String (dropdown) | Reference Side | Reference Side; Opposite Side; Both Sides | Which face receives the fillet. Both Sides applies fillet operations to both faces symmetrically. |
| **(C) Depth** | Double (length) | 4 mm | 0 to max determined by Tool Radius | Depth of material removed from the beam edge. Clamped automatically if exceeding the geometric maximum for the tool radius. |

### Tool Settings

| Property | Type | Default | Options / Range | Description |
|---|---|---|---|---|
| **ToolIndex** | Integer | 1 | Positive integer | CNC tool number passed to the `PropellerSurfaceTool`. Must match the tool slot in your CNC machine configuration. |
| **Radius** | Double (length) | 80 mm | Positive value | Physical radius of the milling cutter. Defines the arc geometry together with Depth. Larger radius produces a gentler curve. |

---

## Right-Click Menu Options

None. All parameter adjustments are made through the Properties Palette.

---

## Tips and Notes

- **Set Tool Radius first, then Depth.** The maximum achievable fillet depth is calculated from the tool radius. Setting a radius that matches your actual cutter ensures the depth range is correct.
- **Circumference mode is the efficient batch workflow.** Select any number of beams and one parametric fillet instance is created per beam in a single operation.
- **Path mode processes one beam at a time.** Even if multiple beams are selected, only the first is processed. Run the tool again for additional beams.
- **Alignment controls display color.** Color 3 (green) for Reference Side and Both Sides; color 4 (cyan) for Opposite Side.
- **Curved beams are fully supported.** The script detects curved style automatically and reconstructs the perimeter contour using arc (bulge) geometry, ensuring the fillet follows the true curved surface.
- **Automatic recalculation.** The fillet recalculates when the linked beam changes length or position (via `setDependencyOnBeamLength`).
- **Self-cleaning.** If the linked beam is deleted or the contour cannot be resolved, the fillet instance removes itself automatically.
- **Silent insertion via catalog key.** When launched with `_kExecuteKey` set to a valid catalog name, the dialog is skipped and settings are loaded from the catalog entry.
- **Units are drawing-independent.** All dimensional defaults use `U()` conversion, so the tool works in both metric and imperial drawing templates.
