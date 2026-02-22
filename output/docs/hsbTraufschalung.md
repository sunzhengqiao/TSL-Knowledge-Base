# hsbTraufschalung

## Overview

The **hsbTraufschalung** tool automates the placement of exposed rafter eave boards (Traufschalung) along a roof plane in hsbCAD. These are the visible boards running along the lower edge (eave) of a roof slope, typically seen from outside the building. Instead of manually calculating spacing, trimming to roof boundaries, and fitting around hip and valley members, this tool handles the entire distribution automatically.

The tool analyses one or more roof planes and distributes a series of boards at regular intervals from the eave edge up to a user-defined end point. It detects rafters, hip rafters, and valley rafters, trimming each board precisely at intersections. Boards extending beyond the roof outline are clipped to fit. If rafters have a plumb cut at the eave, the tool compensates for this offset automatically.

Once placed, the instance remains dynamic: changing properties such as board width or extrusion profile triggers automatic regeneration of all boards. Both simple rectangular cross-sections and custom extrusion profiles from the company catalog are supported.

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O (Object -- persistent, recalculating entity) |
| Beams Required | 0 (no pre-selection needed) |
| Intended Space | Model Space |
| Shop Drawing | Not applicable |
| Unit System | Millimeters (internal) |
| Version | 1.3 |

## Prerequisites

Before inserting this tool, the following elements should exist in the drawing:

- **Roof plane (ERoofPlane)** -- at least one roof plane must be present and selectable. This is the primary geometric input.
- **Rafters (Beams)** -- rafters belonging to the roof plane should be modelled. The tool uses them to cut notches where boards intersect rafters and to detect plumb cuts at the eave.
- **mapIO_LayerAssignment** -- the helper script `mapIO_LayerAssignment.mcr` must exist in the company or installation TSL folder. It handles layer and group assignment of the generated boards. If missing, a warning appears in the command line and boards may be placed on the default layer.
- **Closed polyline (optional)** -- required when covering multiple roof planes. Defines the distribution boundary. Also useful for excluding areas such as dormers.

## How to Use

1. **Start the command** -- type `TSLINSERT` at the command line or use the hsbCAD toolbar to select `hsbTraufschalung`.

2. **Set initial properties** -- a properties dialog appears immediately. Set the board width, height, profile, material, and name. The **Gable Wall Overlapping** value is only available at this insertion stage and controls how far eave boards extend past gable end walls. This value cannot be changed from the Properties Palette after insertion.

3. **Select the roof plane** -- the command line prompts: *Select Roofplane*. Click on one or more roof slopes where eave boards should be placed. Multiple roof planes can be selected using a selection set.

4. **Select a boundary polyline (optional)** -- the command line prompts: *Select pline(s)*. If you have a closed polyline defining the distribution boundary, click it. This step is mandatory when multiple roof planes are selected. Press Enter to skip when working with a single roof plane.

5. **Pick the distribution end point (single-plane only)** -- if no polyline was selected, the command line prompts: *Point near end of distribution*. Click a point on or near the roof plane close to where the board rows should end (for example, near the ridge line or wall plate).

6. **Inspect the result** -- the tool creates individual timber members (Beams) for each eave board. Each board is trimmed to the roof outline and notched around intersecting rafters, hip rafters, and valley rafters.

7. **Adjust as needed** -- select the script instance (the coloured outline marker, not individual boards) and open the Properties Palette to modify parameters. Changes regenerate the boards automatically.

### Multiple Roof Plane Workflow

When multiple roof planes are selected with a boundary polyline, the tool creates a separate script instance for each roof plane, all sharing the same boundary. This is useful for L-shaped or complex roof forms where the eave runs continuously across multiple slopes.

## Properties Panel (OPM Parameters)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Extrusion profile | Dropdown | (catalog list) | Select a profile shape from the company extrusion catalog. When a non-rectangular profile is selected, the Height property becomes read-only and is taken from the profile dimensions. Select the rectangular option to use manually entered Width and Height values. |
| visible Width | Number (mm) | 121 | The centre-to-centre spacing between boards, which also equals the visible face width of each board. Changing this recalculates the number of boards and regenerates the entire distribution. |
| Height | Number (mm) | 21 | Board thickness perpendicular to the roof surface. Read-only when a non-rectangular extrusion profile is active. |
| Additional Width | Number (mm) | 0 | Extra width added to each board, for example to account for a lap or tongue hidden behind the adjacent board. |
| Material | Text | (empty) | Timber material code assigned to all boards (e.g. C24, Douglas Fir). Appears in the bill of materials. |
| Grade | Text | (empty) | Timber grade designation assigned to all boards. |
| Name | Text | Exposed Rafter Eaves | Element name used in bills of materials and reports. |
| Label | Text | (empty) | Short code printed on boards in fabrication lists. |
| Sublabel | Text | (empty) | Secondary classification label for sorting or filtering. |
| Color | Integer | 65 | AutoCAD Color Index (ACI) number for the script marker display. Does not affect board colours. |
| Dimstyle | Dropdown | (drawing default) | Dimension style applied if dimension annotations are generated from this element. |
| Group, Layername or Zone Character | Text | Exposed Rafter Eaves | Controls layer or project group assignment for generated boards. Accepts: an existing group path (e.g. `House\Roof\Eaves`), a standalone layer name, or a single zone character (C, I, J, T, or Z). When a zone character is entered and the linked element belongs to a group, boards are placed on the corresponding group sub-layer. |

### Insertion-Only Property

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Gable Wall Overlapping | Number (mm) | 30 | How far each board row extends past the gable end wall. Only configurable during the initial insertion dialog. To change later, re-insert the script or use Generate Beams after manually editing the stored map value. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Generate Beams | Deletes all existing eave boards and creates a new distribution based on current property values. Use this after roof geometry changes or if boards appear misaligned. |
| Delete Beams | Removes all generated boards but keeps the script instance in the drawing. The instance can regenerate boards later using Generate Beams. |
| Toggle Direct Editing | Switches grip-point editing on or off. When enabled, grip points appear on the boundary contour, allowing you to drag edges interactively to fine-tune the coverage area. When disabled, grips are hidden and the contour is driven by properties and the linked roof plane. |

## Automatic Regeneration Triggers

The board distribution regenerates automatically when any of the following changes:

- The insertion point (`_Pt0`) is moved
- The **Extrusion profile** is changed
- The **Height** value is modified
- The **visible Width** value is modified
- Any grip point is dragged (in Direct Editing mode)
- The script is first created in the drawing

Other property changes (Material, Name, Color, Label, etc.) update beam attributes without rebuilding geometry.

## Tips and Notes

- **Plumb cut compensation** -- if rafters have a plumb (vertical) cut at the eave, the tool detects this and shifts the board distribution starting position so the first board sits flush against the cut face rather than the rafter axis.

- **Hip and valley trimming** -- the tool automatically detects hip rafters and valley rafters and cuts each board precisely along the hip or valley line. For valley rafters, a ParHouse (saddle cut) is applied so boards from adjacent slopes meet cleanly. Rafters must be fully modelled and associated with the roof plane before inserting.

- **Board count calculation** -- the number of boards is determined by dividing the total distribution depth (from the eave edge to the selected end point) by the visible Width. The eave zone receives an even number of full-width boards. Boards that do not intersect the active roof area are suppressed.

- **Direct editing contour** -- when Toggle Direct Editing is active, a filled cyan highlight appears on the boundary contour edges. Drag the midpoint grips of each contour edge to adjust where board rows start and stop. The adjusted contour persists through recalculations. To reset to the automatic contour, use Generate Beams.

- **Beam types excluded from notching** -- valley rafters, top plates, mid plates, and ridges are excluded from the rafter collection used for beam-cut notching. Hip rafters are collected separately for hip-line cuts.

- **Layer assignment** -- the tool calls `mapIO_LayerAssignment` to assign each board to the correct project layer. If this helper script is missing, a warning message appears in the command line. Ensure the script is present in `<hsbCompany>\tsl\` or in the drawing.

- **Roof outline clipping** -- after all boards are generated, the tool checks each board against every edge segment of the roof plane envelope. Any board portion protruding past a roof edge receives a static cut to trim it flush with that edge.
