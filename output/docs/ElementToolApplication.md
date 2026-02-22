# ElementToolApplication

## Overview

ElementToolApplication automatically generates glue lines or nail lines along the contact surfaces between structural members in different zones of a timber element. It detects coplanar faces between an upper zone (Zone B) and a lower zone (Zone A), then places either gluing areas or nailing lines at those interfaces. The tool instance remains linked to the element and recalculates whenever the element geometry changes.

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing View | No |

## Prerequisites

- At least one hsbCAD Element (wall, floor, or roof) must exist in the drawing.
- The element must contain GenBeams or TrussEntities assigned to different zones.
- PainterDefinition objects for the relevant element zones must be available. The script auto-creates default zone painters for zones found in the drawing (typically -1, 0, and +1) if none exist under the `TSL\ElementToolApplication\` collection.
- Both the Upper Zone (Zone B) and Lower Zone (Zone A) must contain matching entities; if either zone yields no results, the instance erases itself automatically.

## How to Use

### Step 1: Launch

Type `TSLINSERT` at the AutoCAD command line and select `ElementToolApplication.mcr` from the script browser. Alternatively, use the registered command:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ElementToolApplication")) TSLCONTENT
```

### Step 2: Configure Tool Settings

On first placement a settings dialog appears. Configure the following parameters before confirming:

- **Type**: Choose between Glueing and Nailing. This controls which additional parameters are visible.
- **Width** (Glueing only): Width of the glue area rectangle perpendicular to the contact edge. Set to 0 to draw a simple line instead of a filled area.
- **Spacing** (Nailing only): Center-to-center distance between nail positions along each contact segment.
- **Tool Index**: Select 1, 2, or 3. Controls display color and the tool index written to SubMapX output.
- **Upper Zone**: Select a painter filter identifying the upper zone (Zone B) members. Only painters referencing a non-zero zone index are listed.
- **Merge Value**: When greater than zero, upper zone profiles on the same plane separated by gaps smaller than this value are merged into a single continuous area before contact detection.
- **Start/End Offset**: Shrinks the upper zone contact range by this distance at the start and end of each segment.
- **Lower Zone**: Select a painter filter identifying the lower zone (Zone A) members. By default only zone 0 painters are listed, but if the selected Upper Zone index is greater than 1, intermediate zone painters are also made available.
- **Start/End Offset Lower**: Trims the lower zone contact region at both ends.

### Step 3: Select Entities

After confirming the dialog, the script prompts for entity selection:

- **Prompt 1**: `Select elements, <Enter> to select individual genbeams and/or trusses`
  - Selecting whole elements creates one tool instance per element automatically.
  - Press Enter without selecting elements to advance to the second prompt.
- **Prompt 2** (if no elements were selected): `Select genbeams and/or trusses`
  - Select individual GenBeams or TrussEntities. The script groups them by their parent element and creates one tool instance per element group.

### Step 4: Automatic Processing

The original insertion instance is erased and one or more permanent instances are created, each linked to an element. On each calculation cycle the instances:

1. Identify which beams or trusses belong to Zone B and Zone A using the selected painter filters.
2. Compute the bottom face profiles of Zone B members and subtract any no-nail zones defined on the element.
3. Project Zone A member bodies onto the face plane to build shadow profiles, then find coplanar contact surfaces between the two sets.
4. Apply Start/End Offsets to trim the contact regions.
5. In Glueing mode: draw filled rectangular areas and write segment data to the instance SubMapX under the `Glue[]` key (start point, end point, tool index, zone, and rectangle shape).
6. In Nailing mode: create `ElemNail` objects on the element for each contact segment using the configured spacing and tool index.

### Step 5: Recalculation

The tool instance tracks the parent element via `setDependencyOnEntity`. Whenever the element is modified the instance recalculates and updates all glue or nail lines automatically.

## Properties Panel (OPM Parameters)

Parameters marked with an asterisk (*) control the visibility of other parameters.

### Tool Category

| Parameter | Type | Default | Range / Options | Description |
|-----------|------|---------|-----------------|-------------|
| Type * | String (Enum) | Glueing | Glueing, Nailing | Determines whether the tool generates glue areas or nail lines. Switching this value hides or shows Width and Spacing. |
| Width | Double | 5 mm | Any positive value | Width of the glue rectangle perpendicular to the contact edge. Only visible when Type is Glueing. Set to 0 for a simple line. |
| Spacing | Double | 200 mm | Any positive value | Center-to-center spacing between nail positions. Only visible when Type is Nailing. |
| Tool Index | Integer (Enum) | 1 | 1, 2, 3 | Index used for display color and organizing glue data in SubMapX. Also sets the color of created NailLine entities. |

### Zone B Category (Upper Zone)

| Parameter | Type | Default | Range / Options | Description |
|-----------|------|---------|-----------------|-------------|
| Upper Zone * | String (Enum) | First available | Painter names, non-zone-0 | Selects the painter filter that identifies upper zone (Zone B) members. Only painters from the `TSL\ElementToolApplication\` collection referencing a non-zero zone index are listed. |
| Merge Value | Double | 0 mm | 0 or positive | When greater than zero, adjacent upper zone profiles on the same plane are expanded by this amount, combined, then shrunk back. This bridges small construction gaps between members. |
| Start/End Offset | Double | 0 mm | 0 or positive | Trims the upper zone contact region by this distance at both ends of each segment. |

### Zone A Category (Lower Zone)

| Parameter | Type | Default | Range / Options | Description |
|-----------|------|---------|-----------------|-------------|
| Lower Zone * | String (Enum) | First available | Painter names, zone 0 (plus intermediate zones if Upper Zone index exceeds 1) | Selects the painter filter that identifies lower zone (Zone A) members. When the Upper Zone references zone index 2 or higher, painters for intermediate zones are also listed. |
| Start/End Offset Lower | Double | 0 mm | 0 or positive | Trims the lower zone contact region at both ends by this distance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Entities | Prompts to select additional GenBeams or TrussEntities belonging to the same element and adds them to the processing scope. |
| Remove Entities | Prompts to select GenBeams or TrussEntities and removes them from the scope. The tool recalculates using only the remaining members. |
| Create Naillines | Only available when Type is Nailing. Converts the computed nail segments into permanent NailLine database entities. The NailLine color is set to the Zone B index. The resulting NailLine entities are independent of the tool after creation. |

## Technical Notes

1. **Zone separation**: Members are filtered into Zone B (upper) and Zone A (lower) using PainterDefinition filters. The face normal of Zone B determines the direction in which contact is tested.
2. **Perpendicularity filter**: GenBeams whose local X-axis is not perpendicular to the element face plane are silently excluded. This prevents incorrectly oriented studs from being processed.
3. **Truss simplification**: For TrussEntities in Zone A, the body is reduced to a prismatic form derived from the shadow profile in the member's Y direction. This improves contact detection for complex truss geometries.
4. **Z-plane grouping**: Zone B bottom faces are grouped by their elevation along the element Z axis (rounded to 1 mm). Members at the same height level are processed together, enabling Merge Value logic across adjacent members.
5. **No-nail zones**: The element's no-nail profiles for both zones are subtracted from all upper zone contact areas before tool placement.
6. **Roof element beam width**: For roof elements imported from IFC where the beam width is not set, the script automatically determines and sets the beam width from the largest Zone A member when in Nailing mode.
7. **SubMapX output**: In Glueing mode, each segment's start point, end point, tool index, zone index, and PLine shape are written to `Glue[]` in the instance SubMapX. Downstream scripts or BOM tools can read this data.
8. **Catalog insertion**: The script supports silent insertion via catalog presets. When invoked with an execute key matching a stored catalog name, the dialog is skipped and values are loaded from the catalog.

## Tips and Notes

- If the script reports "Could not find any entities in zone" and erases itself, verify that your PainterDefinition filters correctly target members in those zones. Open the Painter Manager and review the filter expressions for the painters listed under Upper Zone and Lower Zone.
- The Merge Value is useful when sheathing boards have small construction gaps. Set it equal to the gap width (for example 3 mm) so the script treats adjacent boards as a continuous contact surface.
- The Start/End Offset parameters enforce minimum edge distances. Setting them equal to the required edge distance prevents nails or glue from being placed within that distance of a member end.
- When selecting individual GenBeams instead of whole elements, the script creates one tool instance per parent element. Members from different elements cannot be mixed in a single instance.
- After using Add Entities or Remove Entities from the context menu, the tool runs two execution loops to save the updated entity set before recalculating geometry.
- The Create Naillines action produces permanent NailLine entities independent of the tool. If the element changes after running Create Naillines, delete the outdated NailLines and run the action again.
- Tool Index values 1, 2, and 3 map to AutoCAD color indices and distinguish tool data in SubMapX when multiple instances exist on the same element.
- Version 1.1 (19.05.2025) added support for rotated truss coordinate systems. If a truss coordinate system is not aligned with the element plane, a warning is printed to the command line but processing continues with a fallback alignment.
