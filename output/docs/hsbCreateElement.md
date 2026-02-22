# hsbCreateElement

## Overview

`hsbCreateElement` creates a new hsbCAD Element (of type `ElementRoof`) by selecting existing timber members, sheets, and panels from the drawing and grouping them into a structured element with automatic zone assignment. The script detects the geometric arrangement of the selected entities, determines a coordinate system and contour boundary, assigns each entity to the correct structural zone relative to a reference member, and registers the new element under a user-defined building and storey group hierarchy.

This is a **one-shot tool**: it erases itself from the drawing immediately after creating the element. There is no persistent script instance to select or modify afterward.

## Usage Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Beams Required | 0 |
| Space | Model Space only |
| Version | 2.5 |
| Keywords | Element, Beam, Sandwich, Panel |

## Prerequisites

- One or more hsbCAD entities must already exist in the drawing: `GenBeam` members (studs, plates, rafters), `Sheet` panels, `Sip` panels, or `CollectionEntity` objects such as trusses.
- The entities that will form the element must be modelled and positioned correctly in 3D space before running this script.
- A building group structure (Building / Storey) is created automatically if it does not yet exist, so no pre-existing group hierarchy is required.

## How to Use

### Step 1 -- Launch the Script

Type `TSLINSERT` at the AutoCAD command line and select `hsbCreateElement.mcr` from the script browser, or use the hsbCAD ribbon shortcut for element creation. A dialog may appear the first time, allowing you to review and set the OPM parameters before proceeding. If a catalog entry name is passed via the execute key, those stored settings are applied automatically.

### Step 2 -- Select Entities

The command line prompts:

```
Select entities, first selected specifies zone 0:
```

Use a window selection or click individual entities. All selected `GenBeam`, `Sheet`, `Sip`, and `CollectionEntity` (truss) objects will be included in the new element. The **first valid entity** in the selection set becomes the **defining (reference) entity** that establishes the element coordinate system and zone 0 boundaries.

- If the **Reference Plane** property is set to `byPanel`, the first `Sip` panel in the selection set is used as the reference instead.
- If no valid `GenBeam`, `Sip`, or `CollectionEntity` is found, the script enters a free-origin mode (see Step 3b).
- If the selection is empty, the script cancels and removes itself.

### Step 3a -- Adjust Contour and Datum (Interactive Jig)

After selection, hsbCAD displays a real-time jig preview showing:

- The proposed element boundary contour (cyan-highlighted shadow projection of all selected bodies).
- The element coordinate system axes (X = red, Y = green, Z = blue).
- A preview label showing the proposed element number.

The command line offers the following keyword options. Type the keyword or press Enter to accept the current state:

| Keyword | Action |
|---------|--------|
| `FlipSide` | Flips the Z and Y directions of the element, swapping which face is the reference face. |
| `Xrotate` | Rotates the coordinate system 90 degrees around the X axis. Resets any custom contour. |
| `Yrotate` | Rotates the coordinate system 90 degrees around the Y axis. Resets any custom contour. |
| `Zrotate` | Rotates the coordinate system 90 degrees around the Z axis. Preserves the custom contour. |
| `MainReference` | Re-pick the defining/reference entity from those already selected. |
| `BoundingShadow` | Replaces the contour with a rectangular bounding box encompassing the shadow of all entities. |
| `PurgeContour` | Resets to the auto-detected shadow contour. Prompts for a blow-up and shrink value to close small gaps between members. Enter 0 for no cleanup. |
| `drawRectangularContour` | Activates rectangle mode: your next click defines the opposite corner of a rectangular contour from the datum origin. |
| `DrawContour` | Lets you manually click a polygon contour point by point. Press Enter to close and accept the polygon. |
| `AddEntities` | Adds more entities to the selection without restarting the command. |
| `removeEntities` | Removes entities from the selection (the reference entity and at least two entities must remain). |
| `formatText` | Changes the element naming format expression on the fly before creation. |

Click a point (without a keyword) to reposition the datum origin of the element. Press Enter or right-click with no keyword to accept and create the element. Press Escape to cancel.

### Step 3b -- Free-Origin Mode (No Valid Reference Entity)

If no `GenBeam`, `Sip`, or `CollectionEntity` is found among the selected entities, the script enters free-origin mode:

1. You are prompted to pick a datum point.
2. The jig displays the current UCS axes and allows you to redefine them using the keywords `XAxis`, `YAxis`, or `ZAxis`, then clicking a direction point.
3. Press Enter to accept the coordinate system and create the element.

### Step 4 -- Element Creation and Zone Assignment

Once you confirm, the script:

1. Computes the element boundary contour in the chosen coordinate system. If the contour has multiple rings, they are merged by progressively expanding and contracting the profile.
2. Automatically numbers the new element using the format expression in the **Element Group** property (default `EL_@(Number:PL3;0)`), incrementing from the highest existing element number in the storey group.
3. Creates an `ElementRoof` entity and registers it under the group path `Building\Storey\ElementNumber`.
4. Assigns each selected entity to the correct zone:
   - **Zone 0**: Entities whose full thickness lies within the Z-extents of the reference entity.
   - **Zone +1, +2, ... +5**: Layers stacked above zone 0 on the positive Z face, assigned in order from the face outward.
   - **Zone -1, -2, ... -5**: Layers stacked below zone 0 on the negative Z face, assigned in order from the face outward.
   - Entities outside the +/-5 zone range are excluded.
5. Attaches any Plugin TSLs specified in the **Plugin TSLs** property.
6. If **Turn off new element** is set to `Yes`, the element group visibility is switched off immediately.
7. Erases the script instance from the drawing.

## Properties Panel (OPM Parameters)

### Grouping

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Building Group | String | `Building` | Top-level building group name. If the drawing is already filtered to an active group, the current building name is used. |
| Storey Group | String | `Building` | Storey (floor/level) sub-group name within the building. |
| Element Group | String | `EL_@(Number:PL3;0)` | Naming template for the new element. Supports hsbCAD format expressions such as `@(Label)` to inherit names from source entities, or plain text with auto-incrementing numbers. Example: `EL_@(Number:PL3;0)` produces `EL_001`, `EL_002`, etc. |

### Geometry

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| Reference Plane | String | `Default` | `Default`, `byPanel` | Controls which entity defines the reference plane. `Default` uses the first selected entity. `byPanel` uses the first SIP panel. |
| Contour Mode | String | `Default` | `Default`, `Bounding Shadow`, `Purge Contour` | Pre-selects the contour strategy at insertion. `Default` shows the interactive jig preview. `Bounding Shadow` creates a rectangular envelope and skips the jig. `Purge Contour` applies blow-up/shrink cleanup and skips the jig. |
| Blowup + Shrink Value | Double | 0 mm | Any positive value | When Purge Contour mode is active or the PurgeContour keyword is used, this value first expands and then contracts the contour, merging small gaps between members into one continuous outline. |

### Behaviour

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| Add Exclusively | String | `Yes` | `No`, `Yes` | When `Yes`, entities already belonging to another element group are moved exclusively to the new element. When `No`, the entity remains associated with both. |
| Turn off new element | String | `No` | `No`, `Yes` | When `Yes`, the element group visibility is switched off immediately after creation. |
| Plugin TSLs | String | _(empty)_ | Semicolon-separated list | TSL scripts to attach to the new element after creation. Each entry can reference a catalog entry using the `?` separator. Example: `hsbRoofData?Gable ; hsbBOM?Standard`. Only element-level TSLs that require no interactive input are supported. |

## Zone Assignment Logic

Understanding how zones are assigned helps when working with multi-layer wall or roof elements:

- **Zone 0** is the structural core layer, defined by the Z-extent of the reference entity. All entities whose geometry falls entirely within these Z-boundaries are placed in zone 0.
- Entities that touch the **positive Z face** of zone 0 are placed in zone +1, then +2, and so on up to +5, based on stacking order outward from the core.
- Entities that touch the **negative Z face** of zone 0 are placed in zone -1, then -2, down to -5.
- Within each zone pass, entities must touch the current face boundary. Entities within the zone thickness but not touching the face are collected in a second pass.
- Any entity that cannot be resolved to a zone within the +/-5 range is excluded from the element.
- An entity already assigned to another element is re-assigned if **Add Exclusively** is set to `Yes`.

## Element Numbering

The element number is derived from the format expression in the **Element Group** property:

1. The format expression is evaluated against the defining entity (e.g., reads a `Label` or `Number` property from the source beam or SIP).
2. Unresolved `@(...)` format tokens are stripped from the result.
3. If the resulting name contains a trailing number and is not yet used in the storey group, it is used directly.
4. Otherwise, a three-digit sequential suffix is appended (e.g., `EL_001`, `EL_002`), starting from the next available number.

## Coordinate System Defaults

The script applies intelligent defaults based on the orientation of the reference entity:

- **Floor/flat elements** (Z parallel to World Z): X is aligned to positive World X direction.
- **Wall elements** (Z perpendicular to World Z): X is reoriented so Y points upward (World Z).
- **Roof/inclined elements**: X is adjusted so its Z-component is positive (pointing upward in the model).
- **Trusses** (`CollectionEntity`): The truss coordinate system is remapped so the truss Y becomes the element Z and the truss -Z becomes the element Y.

These defaults can always be overridden interactively using the FlipSide and rotation keywords during the jig phase.

## Tips and Notes

- For wall elements, ensure that the bottom plate or the outermost sheathing panel is selected first if you want it to become zone 0, or set the **Reference Plane** property to `byPanel`.
- The `DrawContour` keyword is useful for L-shaped or irregular floor elements where the automatic shadow projection produces multiple disconnected regions.
- When using `Purge Contour` for elements with deliberate gaps, set the Blowup + Shrink Value slightly larger than the maximum gap width (e.g., 25 mm) to bridge all gaps.
- `CollectionEntity` objects such as roof trusses are supported as reference entities with automatic axis remapping.
- Plugin TSLs are created using `OnDbCreated` as the trigger event. Only scripts that are self-sufficient (no user prompts, no beam requirements) will work reliably.
- The **Turn off new element** option is especially practical in floor-by-floor workflows where you want to keep the viewport uncluttered.
- When **Contour Mode** is set to `Bounding Shadow` or `Purge Contour`, the jig preview phase is skipped entirely and the element is created immediately after entity selection.
- Catalog entries can store pre-configured combinations of all properties. This is the recommended approach for production workflows with standardized naming conventions.
- If the script detects that the defining entity has zero thickness in the Z direction, it reports an error message and cancels.
