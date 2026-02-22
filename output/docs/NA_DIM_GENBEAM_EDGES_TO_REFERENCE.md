# NA_DIM_GENBEAM_EDGES_TO_REFERENCE

## Overview

**NA_DIM_GENBEAM_EDGES_TO_REFERENCE** is a shop drawing dimensioning script that measures distances between genbeam (timber member) edges and a reference outline within a viewport. It is designed for automated dimension placement in paper space, targeting wall, floor, and roof element shop drawings.

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Version | 0.17 |
| Required Beams | 0 |
| Implicit Insert | Yes |
| Language Support | English (en-US), French (fr-CA) |

## Purpose

This script solves the common shop drawing task of showing how far individual beam or sheet edges sit from a reference group of beams/sheets. For example, you can dimension the gap between each stud edge in Zone 1 and the overall sheathing outline in Zone 0. The script handles horizontal, vertical, and angled edges independently, with separate display and offset controls for each direction.

## Prerequisites

- A Paper Space layout with at least one viewport containing a valid hsbCAD wall, floor, or roof element.
- The element must contain genbeams organized into zones.
- A dimension style (default: "NA Shopdrawing") must exist in the drawing.

## Insertion Workflow

1. Run the script. You are prompted to select an element viewport.
2. A properties dialog opens with all dimension settings pre-filled with defaults.
3. Adjust the settings as needed and confirm. The script creates dimension lines automatically.
4. The script attaches to the viewport and recalculates whenever beams move or the element changes.

Only one insertion cycle is permitted; attempting to insert again on the same instance erases it.

## User Properties (OPM Dialog)

Settings are organized into three categories and presented in a dialog on insertion or when using the "Edit dimension properties" context menu action.

### Category: Beams/Sheets to Dimension

These settings select which genbeams will receive dimension lines from their edges.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Element zone | Int (dropdown) | Zone 1 | Zone containing the beams to dimension. Range: -5 to 5. Positive zones are at the front of walls or top of floors/roofs; negative zones are at the back/bottom. Zone 0 is inside the element container. |
| Include filter | String (dropdown) | None | Painter Definition of type GenBeam used as an inclusion filter. Only beams matching this definition are dimensioned. "None" includes all beams in the zone. |
| Exclude filter | String (dropdown) | None | Painter Definition of type GenBeam used as an exclusion filter. Beams matching this definition are removed from the dimension set. Applied after the include filter. |

### Category: Beams/Sheets to Reference

These settings select which genbeams form the reference outline that dimension lines measure to.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Element zone | Int (dropdown) | Zone 0 | Zone containing the reference beams/sheets. Same zone numbering as above. |
| Include filter | String (dropdown) | None | Inclusion Painter Definition filter for reference beams. |
| Exclude filter | String (dropdown) | None | Exclusion Painter Definition filter for reference beams. |

### Category: Dimension Style and Positioning

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Dimension style | String (dropdown) | NA Shopdrawing | AutoCAD dimension style applied to all created dimensions. Lists all styles in the drawing. |
| Text height | Double | 0 | Override for dimension text height in paper space units. When 0, uses the height from the dimension style. |
| Text side | String (dropdown) | Away from dimensioned points | Controls whether dimension text sits on the side facing away from or towards the dimensioned beam edges. |
| Dimension the gaps only | String (dropdown) | No | When "Yes", only dimensions that cross through a gap (not through reference material) are drawn. Useful for showing clearances. |
| Display horizontal dims | String (dropdown) | Yes | Show/hide dimensions on edges parallel to the layout X-axis. |
| Horizontal dims offset | Double | 5/32" (4 mm) | Paper space offset that moves horizontal dimension text away from the measured points. |
| Horizontal dims text orientation | String (dropdown) | Parallel | Text alignment relative to the horizontal dimension line: Parallel or Perpendicular. |
| Display vertical dims | String (dropdown) | Yes | Show/hide dimensions on edges parallel to the layout Y-axis. |
| Vertical dims offset | Double | 5/32" (4 mm) | Paper space offset for vertical dimension text. |
| Vertical dims text orientation | String (dropdown) | Perpendicular | Text alignment for vertical dimensions. |
| Display angled dims | String (dropdown) | Yes | Show/hide dimensions on edges that are neither horizontal nor vertical. |
| Angled dims offset | Double | 5/32" (4 mm) | Paper space offset for angled dimension text. |
| Angled dims text orientation | String (dropdown) | Perpendicular | Text alignment for angled dimensions. |

## Context Menu Actions

Right-click the script instance to access these actions:

| Action | Description |
|--------|-------------|
| Edit dimension properties | Re-opens the full properties dialog to change settings. |
| Add properties override for current element | Creates an element-specific settings override, so this element uses different dimension properties than the default. |
| Remove properties override for current element | Deletes the per-element override and reverts to the shared default settings. |
| Reset grip points for current element | Restores all dimension grip points to their default (edge midpoint) positions. |

## Grip Point Interaction

Each dimension line has a movable grip point located on the corresponding genbeam edge. Dragging a grip point along an edge repositions that single dimension line, allowing you to avoid text overlaps or place the dimension at a more readable location.

- Grip points snap to the genbeam outline when moved.
- Grip positions persist across recalculations.
- Use "Reset grip points" from the context menu to restore all grips to edge midpoints.

## How Dimensions Are Calculated

1. **Outline extraction**: For each genbeam to dimension, the script extracts the 2D outline visible in the viewport by projecting the beam body onto a contact plane facing the viewer.
2. **Reference outline**: All reference-zone genbeam outlines are unioned into a single combined reference profile, smoothed to remove tiny gaps.
3. **Edge-to-reference measurement**: For each edge of each dimensioned genbeam outline, the script casts a line perpendicular to that edge towards the reference outline. If the line reaches the reference without crossing another dimensioned genbeam, a dimension is created.
4. **Gap-only mode**: When enabled, only measurements that cross exactly one reference outline boundary (indicating a gap) are kept.
5. **Text collision avoidance**: When two dimension texts would overlap, one is shifted to the opposite side of its dimension line.

## Per-Element Overrides

The script stores a single set of default dimension properties. If certain elements need different settings (for example, a wall with non-standard zone assignments), use "Add properties override for current element" from the context menu. This creates an independent copy of settings tied to that specific element handle. The override is indicated by a message in the command line when the script recalculates.

## Tips

- **Zone selection**: Positive zones (1-5) are at the front/top of the element container; negative zones (-1 to -5) are at the back/bottom. Zone 0 is inside the container. Choose the zone that matches where your studs or sheets actually sit.
- **Filter combinations**: When both include and exclude filters are set, the include filter runs first, then the exclude filter removes unwanted beams from the result.
- **Offset values**: The default offset (5/32" or 4 mm) works well at common shop drawing scales. Increase it if dimensions overlap beam outlines at your viewport scale.
- **Gaps only**: Enable "Dimension the gaps only" when you want to annotate clearances between framing members and sheathing edges rather than full edge-to-reference distances.
- **Metric vs. Imperial**: The script auto-detects the drawing unit system and applies correct default offsets. No manual unit configuration is needed.

## Troubleshooting

| Symptom | Likely Cause | Solution |
|---------|-------------|----------|
| No dimensions appear | Zone selection does not match actual element structure | Verify zone assignments in the element; try Zone 0 or another zone value |
| Some edges are not dimensioned | Include/exclude filters are too restrictive, or edges are hidden behind other genbeams | Set filters to "None" and check that "Display horizontal/vertical/angled dims" are all set to "Yes" |
| Dimension text overlaps beam outlines | Offset value too small for the current viewport scale | Increase the offset value for the relevant direction (horizontal, vertical, or angled) |
| "No valid viewport" error and instance erased | Script was not placed on a viewport, or the viewport lost its element link | Re-insert the script and select a valid element viewport |
| Dimensions show incorrect values | Unit mismatch between script and drawing template | Ensure the drawing template units match the intended measurement system |
| Override warning in command line | A per-element override exists for this element | This is informational. Remove the override via context menu if not intended |

## Version History

| Version | Date | Change |
|---------|------|--------|
| 0.17 | 2023-10-17 | Corrected genbeamOutline function |
| 0.16 | 2023-10-10 | Fixed negative zones selection bug |
| 0.15 | 2023-10-05 | Zone filter fix |
| 0.14 | 2023-09-25 | Draw script name on debug |
