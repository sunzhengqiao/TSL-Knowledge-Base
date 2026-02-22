# hsbViewDimension

Creates dimension lines on views (Viewports, Sections, and Shop Drawing Views) to dimension beams, sheets, panels, openings, elements, or TSL entities.

---

## Overview

The `hsbViewDimension` script is a powerful dimensioning tool for Paper Space views in hsbCAD. It automatically generates dimension lines based on selected entities within a viewport, section, or shop drawing view. The script supports multiple entity types, various point modes for dimension placement, and includes collision detection to prevent overlapping dimension lines.

**Script Type:** O-Type (Object)
**Version:** 3.5
**Keywords:** Section, Viewport, Shopdrawing, Dimension

---

## Environment

| Aspect | Details |
|--------|---------|
| Space | Paper Space (Viewports, Sections) or Model Space (Shop Drawing Views) |
| Attachment | Viewport, Section2d, or ShopDrawView entity |
| Recalculation | Automatic when linked view or element changes |
| Layer Assignment | Automatically assigned to layer "0" in viewport mode |

---

## Prerequisites

Before using this script, ensure:

1. You have a **Viewport** in Paper Space linked to an hsbCAD Element, OR
2. You have a **Section2d** with a valid Clip Volume in Model Space, OR
3. You have a **Shop Drawing View** in the drawing

The script requires one of these view entities to function properly.

---

## Usage

### Basic Workflow

1. **Insert the Script**
   - Run the insertion command
   - A properties dialog appears for configuration

2. **Select View Entity**
   - For Paper Space: Select a viewport
   - For Model Space: Select a Section2d
   - For Shop Drawings: The script auto-detects ShopDrawViews

3. **Pick Insertion Point**
   - Click where you want the dimension line to appear
   - For "byUser" reference: Pick an additional reference point

4. **Configure Properties**
   - Set the entity Type to dimension
   - Choose alignment (horizontal/vertical, local/global)
   - Select dimension style and display mode

### Supported View Types

| View Type | Description |
|-----------|-------------|
| Viewport | Standard Paper Space viewport linked to an Element |
| Section2d | 2D section with clip volume |
| ShopDrawView | Shop drawing viewport (auto-detected) |

---

## Parameters

### Content Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | String (dropdown) | Beam | Entity type to dimension. Options: Beam, Opening, TSL, Panel, Sheet, Element, Zone -5 to Zone +5, or Painter Definitions |
| **Stereotype** | String | (empty) | Filter dimension requests by TSL names or stereotypes. Semicolon-separated list. Use "Wirechase" for panel/SIP wirechase dimensions |
| **Point Mode** | String (dropdown) | Automatic | Which points to use: Automatic, First Point, Mid Point, Last Point, First + Last, Extremes, or Merged variants |
| **Format** | String | @(Type) | Description text at dimension line. Supports format expressions like @(Name) |

### Reference Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Reference** | String (dropdown) | byElement | Reference for dimension origin: Disabled, byElement, byUser, Zone -5 to +5, or Painter Definitions |
| **Reference Point Mode** | String (dropdown) | Automatic | Which reference points to use: Automatic, First Point, Mid Point, Last Point, First + Last, Extremes |

### Style Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Alignment** | String (dropdown) | Horizontal Local | Dimension line orientation: Horizontal Local, Horizontal Global, Vertical Local, Vertical Global |
| **Delta/Chain Mode** | String (dropdown) | parallel / perpendicular | How to display delta and chain dimensions. Combinations of parallel, perpendicular, or none |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | String (dropdown) | (system styles) | AutoCAD dimension style to apply |
| **Sequence** | Integer | 0 | Collision avoidance priority. -1 = disabled, 0 = automatic |

---

## Context Menu Commands

Access these commands via right-click on the dimension instance:

| Command | Description |
|---------|-------------|
| **Add Entities** | Select additional entities to include (ACA Viewport mode) |
| **Remove Entities** | Remove entities from dimension set (ACA Viewport mode) |
| **Set Reference Point** | Pick a custom reference point for dimensions |
| **Add Points** | Add extra dimension points manually |
| **Remove Points** | Remove dimension points from the set |
| **Set Location** | Interactively reposition local dimension lines with visual jig preview |
| **Reset locations of current element** | Reset custom locations for current element |
| **Reset locations of all elements** | Reset all custom dimension line locations |
| **Automatic/Fixed Global Location** | Toggle between automatic and fixed positioning |
| **Swap Delta/Chain** | Swap the position of delta and chain dimensions |

---

## Point Mode Reference

| Mode | Behavior |
|------|----------|
| **Automatic** | Uses first and last points automatically |
| **First Point** | Only the first (start) point of each entity |
| **Mid Point** | Only the center point of each entity |
| **Last Point** | Only the last (end) point of each entity |
| **First + Last** | Both start and end points |
| **Extremes** | Overall extremes (first of first, last of last) |
| **First Point (Merged)** | Combines neighboring entities, uses first point of merged group |
| **Last Point (Merged)** | Combines neighboring entities, uses last point of merged group |
| **First + Last (Merged)** | Combines neighboring entities, uses both endpoints of merged group |

---

## Tips and Best Practices

### Collision Avoidance

- The **Sequence** parameter controls which dimension lines take priority when avoiding collisions
- Lower sequence numbers have higher priority
- Set to -1 to disable collision detection (dimension lines may overlap)
- Set to 0 for automatic sequence assignment
- The script attempts up to 40 placement positions to find a collision-free location

### Using Painter Definitions

- Create Painter Definitions to filter specific beams, sheets, or panels
- Select the Painter Definition in the Type or Reference dropdown
- Painter Definitions allow complex filtering rules beyond simple zone-based selection
- Supported painter types: Beam, Sheet, Panel, TslInstance

### Multi-Element Drawings

- For MultiElements, the script automatically finds single element references in the same drawing
- Opening dimensions work across multi-element boundaries
- Element transformations are properly handled for accurate positioning

### Wirechase Dimensions

- Add "Wirechase" to the Stereotype field to include wirechase segment dimensions
- Works with Panels (Sip) and Element types
- Wirechase segments are automatically detected from panel geometry

### Custom Dimension Points

- Use "Add Points" to include specific locations
- Use "Remove Points" to exclude unwanted dimension points
- Custom points persist across recalculations
- Points are stored relative to world origin for stability

### Local vs Global Alignment

- **Local**: Each entity gets its own dimension line at its location
- **Global**: All entities share a single dimension line at the insertion point
- Global dimensions include automatic offset tracking to maintain relative position when elements move

### Performance Considerations

- For large elements with many beams, consider using Zone-based filtering
- Painter Definitions can improve performance by pre-filtering entities
- The script includes performance optimizations for opening dimensions (v2.7+)
- Envelope bodies are used where possible for faster calculation

### Section Dimensions

- When attached to a Section2d, the script automatically creates the instance per section
- Clip volume is validated before processing
- Extension line start points are projected to the bounding contour

---

## Technical Notes

- The script stores custom locations in `_Map` under `CustomLocation[]`
- Protection areas are published via `subMapX` with key "ViewProtect"
- TSL-based dimension requests use the `Hsb_DimensionInfo` subMapX key
- Dimension style scaling is automatically adjusted based on viewport scale
- The script uses jig functionality for interactive location setting
- Supports both dark and light AutoCAD backgrounds with appropriate colors

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.5 | Oct 2021 | Bugfix for openings of multi elements |
| 3.4 | Oct 2021 | Performance improvements for byZone and opening type |
| 3.3 | Sep 2021 | Tolerance fixes for combined clip body |
| 3.2 | Jun 2021 | Accept empty custom dimrequests for invalidation support |
| 3.1 | Jun 2021 | New merged point modes for packed genbeams |
| 3.0 | Jun 2021 | Added Reference Point Mode property |
| 2.9 | Jun 2021 | Multi-element transformation and TSL-based point mode support |
| 2.8 | Jun 2021 | Performance enhancements |
| 2.7 | Jun 2021 | Performance enhanced for opening dimensions |
| 2.6 | May 2021 | Dummies considered when painter definition is used |
| 2.5 | Apr 2021 | Multi-element single references support |
| 2.4 | Feb 2021 | Improved collection of section entities |
| 2.3 | Feb 2021 | Multi-element openings, local dimline custom locations, extension line projection |
| 2.0 | Feb 2021 | Wirechase dimensions, TSL tooling support |
| 1.9 | Feb 2021 | Sequence property for collision avoidance |
| 1.8 | Jun 2020 | New "Extremes" point mode and Element type |
| 1.6 | Jun 2020 | Painter definition support, sheets/panels, individual local alignment placement |

---

## See Also

- hsbViewTag - For adding labels and tags to views
- ShopDrawView - Shop drawing viewport management
- Section2d - 2D section creation and management
- PainterDefinition - For custom entity filtering
