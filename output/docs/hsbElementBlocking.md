# hsbElementBlocking

## Overview

Distributes horizontal blocking beams (noggins/dwangs/firestops) within timber wall elements. The script automatically detects vertical studs, calculates available bays, and places blocking at user-defined elevations. It also handles splitting or stretching of intersecting vertical and diagonal members, and detects studs from adjacent connected walls.

**Script Type**: O-Type (Object)
**Category**: Base/Core -- Stick Frame wall framing
**Keywords**: Element, Blocking, Filler
**Version**: 2.4

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment. |
| Paper Space | No | -- |
| Shop Drawing | No | -- |

## Prerequisites

- At least one timber wall Element must exist in the model, or a set of coplanar beams forming a wall frame.
- The element should contain vertical studs (posts) and horizontal plates defining the frame bays.

## Insertion Methods

The script supports three insertion modes:

1. **Element-based**: Select one or more Elements directly. Blocking is distributed across the full element width.
2. **Element with boundary studs**: Select a single Element, then pick two studs to define a partial distribution range.
3. **Beam-based**: Press Enter at the element prompt, then select a group of coplanar beams. The script identifies the parent element from the selected beams.

## Usage Steps

### Step 1 -- Launch the Script

Type `TSLINSERT` in the command line or use the TSL Catalog browser. Select **hsbElementBlocking** and confirm.

### Step 2 -- Configure Properties

The properties dialog appears automatically. Set the desired blocking parameters (height, width, clearance spacing, material, etc.) and click OK.

### Step 3 -- Select Target Geometry

```
Prompt: "Select elements, <Enter> to select a set of beams of one element"
```

- **Click on Elements** to select one or more wall elements.
- **Press Enter** to switch to beam-based selection, then select individual beams.

If a single element is selected, an additional prompt appears:

```
Prompt: "Select 2 studs defining the distribution range, <Enter> to distribute over entire element"
```

- Pick two vertical studs to limit the blocking range, or press Enter for full-width distribution.

### Step 4 -- Result

The script creates blocking beams at each specified elevation. Intersecting vertical members are split or stretched to meet the blocking. The script then erases itself (it is a one-time insertion tool that creates permanent beam geometry).

## Properties Panel Parameters

### Geometry

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Double | 0 | Height of the blocking beam. Set to **0** to match the element zone height automatically. |
| Width | Double | 0 | Width (depth through the wall) of the blocking beam. Set to **0** to match the element zone width. |

### Beam Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | Text | *(empty)* | Material code for the blocking beams (e.g., C24). If left empty, inherits the element zone material. |
| Grade | Text | *(empty)* | Timber grade designation. |
| Name | Text | *(empty)* | Custom name label for the blocking beams. |
| Color | Integer | 4 (Cyan) | CAD display color index (0--255). |
| Nailing | Dropdown | Disabled | When **Enabled**, blocking is treated as a nailing strip. When **Disabled**, the beam code is set to suppress nailing. |

### Alignment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Bottom Clearance | Text | 25 | Vertical spacing from the bottom plate to each blocking row. Accepts multiple entries separated by semicolons. Supports two formats: absolute values (e.g., `400;800`) and fractions of the available height (e.g., `1/3;1/3;1/5`). |
| Post Filter | Text | *(empty)* | Criteria to identify posts/studs that should receive the blocking as an integrated tool (notch). Enter color indices or beamtype names separated by semicolons (e.g., `4;Post`). |
| Split Filter | Text | *(empty)* | Criteria to identify members (typically diagonal braces) that should be split by the blocking rather than notched. Enter color indices or beamtype names separated by semicolons. |
| Alignment | Dropdown | Icon Side | Horizontal alignment of the blocking relative to the wall thickness: **Icon Side**, **Center**, or **Opposite Side**. |
| Staggered Distribution | Dropdown | No | When **Yes**, alternates the vertical position of blocking in adjacent bays, creating a staggered pattern. |
| Justification | Dropdown | Bottom | When using fractional clearance values, determines whether the fraction is measured to the **Top**, **Middle**, or **Bottom** face of the blocking beam. |

### Tooling

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap | Double | 0 | Clearance gap between blocking and partially intersecting beams (mm). Set to a negative value to exclude partial intersection tooling entirely. When >= 0, the script creates `hsbBeamcutElement` tools for partial intersections. |

### Sequence

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence | Integer | 70 | Execution priority when used as an element TSL during `OnElementConstructed`. Lower values execute first. Supports negative values. |

## Clearance Syntax Details

The **Bottom Clearance** field is the primary control for blocking row placement. Each semicolon-separated entry defines one row of blocking measured upward from the bottom plate (or from the previous blocking row).

| Input | Meaning |
|-------|---------|
| `400` | One row of blocking at 400 mm above the bottom plate. |
| `400;400;300` | Three rows at 400, 800, and 1100 mm respectively. |
| `1/3;1/3;1/5` | Fractional placement relative to available inner height. Justification setting controls the reference face. |

## Child Scripts

This script creates instances of **hsbBeamcutElement** to handle partial beam intersections (when Gap >= 0). Users do not need to invoke this child script directly.

## Behavior Details

- **Adjacent wall detection**: For wall elements, the script automatically searches for studs in adjacent parallel walls within the same element group and includes them in the distribution logic.
- **Opening avoidance**: Blocking bodies are automatically subtracted around element openings.
- **Minimum length**: Blocking segments shorter than 50 mm are discarded. Split results shorter than 50 mm cause the split beam to be erased.
- **Beam type**: All created blocking beams are assigned the `SFBlocking` beam type.
- **Element TSL mode**: The script can be attached as an element-level TSL. It responds to `OnElementConstructed` and `OnElementDeleted` events, and supports `MapIO` for property dialog input during element creation.

## Tips

- Leave **Height** and **Width** at 0 to have blocking automatically adapt when the wall zone dimensions change.
- Use fractional clearance values (e.g., `1/2`) to place blocking at the midpoint of a bay regardless of its actual height.
- If diagonal braces need to pass through the blocking continuously, add their beam type or color to the **Split Filter**.
- If studs should receive a notch where blocking meets them, add their beam type or color to the **Post Filter**.
- Set **Staggered Distribution** to Yes for nailing strips so that joints do not align vertically across bays.
- The **Sequence** number controls execution order when multiple element TSLs run during construction generation. Adjust it to ensure blocking runs after studs are placed but before sheet distribution.

## Related Scripts

| Script | Relationship |
|--------|-------------|
| hsbBeamcutElement | Automatically created by this script to handle partial beam intersections. |
| hsbBlocking | Alternative blocking tool with different distribution logic. |
| hsbSheetDistribution | Typically runs after blocking to distribute sheathing panels. |
