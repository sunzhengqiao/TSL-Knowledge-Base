# hsbTslDim - Free Dimension Line Tool

## Overview

**hsbTslDim** is a versatile dimensioning script that creates free-form, associative dimension lines for various hsbCAD entities. It supports dimensioning of beams, sheets, roof planes, SIPs, polylines, TSL instances, and drills. The dimension line automatically updates when linked entities move or change, making it ideal for dynamic construction drawings.

**Script Type:** O-Type (Object)
**Version:** 4.3
**Beams Required:** 0

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment; dimensions visible in plan view by default |
| Paper Space | Yes | Enable "Show in Modelspace" for visibility in all views |
| Shop Drawing | Yes | Automatically included when dimensioning drills or TSL instances on beams |

## Prerequisites

- hsbCAD installed and configured
- At least one entity to dimension (beams, sheets, roof planes, SIPs, polylines, or TSL instances), or manual points
- A valid dimension style defined in the drawing (`_DimStyles` must be available)

## Usage

### Basic Insertion

1. Run the hsbTslDim script via `TSLINSERT` command
2. If no execution key is provided, a **Properties Dialog** appears for configuration
3. Select the **insertion point** for the dimension line origin
4. Select a **second point** to define the dimension direction
5. Optionally, select additional **dimension points** (press Enter to finish)
6. Optionally, select **entities** to dimension (beams, sheets, roof planes, SIPs, polylines, TSL instances)
7. If entities are selected, specify the **dimension side**:
   - 0 = Left
   - 1 = Right
   - 2 = Left and Right (default)
   - 3 = Center

### Execution Key Mode

When called with an execution key (e.g., via `hsb_scriptinsert "hsbTslDim" "MyExecutionStyle"`), the script bypasses the dialog and uses catalog settings for the specified style. This is useful for automation and batch processing.

## Parameters

### Display Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Display mode Delta** | Dropdown | Parallel | Display mode for individual delta dimensions: Parallel, Perpendicular, or None |
| **Display mode Chain** | Dropdown | Parallel | Display mode for cumulative chain dimensions: Parallel, Perpendicular, or None |
| **Mirror read direction** | Yes/No | No | Mirrors the text reading direction for opposite-side readability |
| **Delta on Top** | Yes/No | No | Places delta dimension text above the line instead of breaking it |
| **Description Alias** | String | (empty) | Custom label text at dimension origin (auto-wraps at 20 characters) |
| **Color** | Integer | 9 | Dimension line color index (0-255, -1 for ByLayer) |
| **Dimstyle** | Dropdown | (drawing styles) | AutoCAD dimension style to use |
| **Linear Scale Factor** | Double | 1.0 | Scale factor for dimension values (e.g., 0.001 to convert mm to m) |
| **Show in Modelspace** | Yes/No | No | Display dimension in all views (default is plan view only) |

### Entity and TSL Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **TSL Name** | String | (empty) | Filter TSL instances by name (separate multiple with `;`) |
| **additional dimpoints** | Dropdown | None | Include additional points: None, Drills, TSL's, or TSL's also from linked Element |
| **Mode** | Dropdown | Default | Special mode: Default or "Opening embraced by GenBeams" |

### Special Mode: Opening Embraced by GenBeams

When set to "Opening embraced by GenBeams", the script calculates and dimensions openings that are enclosed by multiple beams (such as window or door openings in a wall frame). Gaps up to 5mm are automatically closed when calculating the opening size.

## Context Menu (Right-Click Options)

Right-click on a placed hsbTslDim instance to access these commands:

| Menu Item | Description |
|-----------|-------------|
| **Add Points** | Add additional dimension points interactively |
| **Delete Points** | Remove dimension points (click near the point to delete) |
| **Set reference point** | Define a reference point for controlling dimension ordering |
| **Mirror Read Direction** | Toggle text reading direction |
| **Add entities** | Add any supported entity type to dimension |
| **Add beams** | Add beams to dimension |
| **Add sheets** | Add sheets to dimension |
| **Add roofplanes** | Add roof planes to dimension |
| **Add sips** | Add SIPs to dimension |
| **Add plines** | Add polylines to dimension |
| **Add Tsl's** | Add TSL instances to dimension |
| **Remove entities** | Remove entities from the dimension |
| **Edit points of entities** | Convert entity-based dimension points to manual grip points |

## Supported Entity Types

| Entity Type | Description |
|-------------|-------------|
| **Beam** | Timber members (dimensions along axis or perpendicular edges) |
| **Sheet** | Panel materials (OSB, gypsum, plywood, etc.) |
| **ERoofPlane** | Roof planes (uses envelope polyline) |
| **Sip** | Structural Insulated Panels |
| **EntPLine** | AutoCAD polylines |
| **TslInst** | TSL script instances (dimensions published reference points or polylines) |
| **3DSOLID** | AutoCAD 3D solids (dimensions extreme vertices) |
| **HSB_ESURFACEDRILL** | Surface drill tools (when "Drills" is selected) |

## Dimension Side Options

When dimensioning entities, specify which side(s) to dimension:

| Value | Option | Description |
|-------|--------|-------------|
| 0 | Left | Dimension the left edge only |
| 1 | Right | Dimension the right edge only |
| 2 | Left and Right | Dimension both edges (default) |
| 3 | Center | Dimension the center point |

## TSL Instance Dimensioning

TSL instances can be dimensioned in three ways (in priority order):

1. **Published Reference Point** - If the TSL publishes a `ptRef` point in its map, that point is used
2. **Published Polylines** - If the TSL publishes polylines in its `plines` map, those polylines are dimensioned
3. **Origin Point** - If no reference data is found, the TSL origin (`_Pt0`) is used

### Filtering TSL Names

Use the **TSL Name** parameter to filter which TSL types to dimension. Separate multiple names with semicolons:
```
OpeningWindow;OpeningDoor;OpeningVent
```

### Additional Dimpoints Options

| Option | Description |
|--------|-------------|
| None | Only dimension manually selected points and entities |
| Drills | Include drill locations from beams connected to selected entities |
| TSL's | Include TSL instances connected to selected beams |
| TSL's also from linked Element | Include TSL instances from both beams and their parent elements |

## Tips and Best Practices

1. **Use Entity Linking**: Dimension entities rather than manual points when possible - the dimension updates automatically when entities move or are modified.

2. **Reference Point**: Set a reference point via the context menu to control which end of the dimension line serves as the "zero" point for ordering.

3. **Scale Factor**: When dimensioning scaled views, the Linear Scale Factor adjusts dimension values automatically. If linked to a single TSL that contains a scale factor in its map, it is inherited automatically.

4. **Long Descriptions**: Description aliases longer than 20 characters automatically wrap to multiple lines at the nearest space character.

5. **Plan View Display**: By default, dimensions only appear when viewing perpendicular to the dimension plane. Enable "Show in Modelspace" to display in all 3D views.

6. **Drill Dimensioning**: Set "additional dimpoints" to "Drills" to automatically include drill locations from connected beams in shop drawings.

7. **Opening Mode**: Use "Opening embraced by GenBeams" mode when you need to dimension window or door openings defined by surrounding framing members.

8. **Static Dimensions**: Use "Edit points of entities" from the context menu to convert entity-based points to manual grip points. This freezes the dimension positions even if entities are moved or deleted.

9. **Group Assignment**: The dimension instance is automatically added to the same groups as selected entities, ensuring correct zone and layer assignment.

10. **Beams Along Axis**: When a beam is parallel to the dimension direction, the script dimensions the extreme vertices along that axis rather than using standard edge collection.

## FAQ

**Q: How do I display dimensions in meters instead of millimeters?**
A: Change the **Linear Scale Factor** property to `0.001`.

**Q: My dimension text is upside down or hard to read. How do I fix it?**
A: Set the **Mirror read direction** property to "Yes" to flip the text orientation.

**Q: Can I mix manual points and automatic entity dimensions?**
A: Yes. Select manual points first (Step 5), then select entities (Step 6). The script combines them into one dimension line.

**Q: How do I dimension only specific TSL types attached to beams?**
A: Enter the TSL script names in the **TSL Name** property (separated by `;`) and set **additional dimpoints** to "TSL's" or "TSL's also from linked Element".

**Q: The dimension disappeared after I rotated my view. Why?**
A: By default, dimensions only display in plan view. Enable **Show in Modelspace** to see them in all views.

**Q: How do I remove a single dimension point without deleting the entire dimension?**
A: Right-click on the dimension and select **Delete Points**, then click near the point you want to remove.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.3 | 18 Apr 2012 | Added support for `ptRef` map entry from external scripts |
| 4.2 | 12 Jan 2012 | Bugfix for dimension sides handling |
| 4.1 | 04 Apr 2011 | Added "Opening embraced by GenBeams" special mode |
| 4.0 | 22 Mar 2011 | Entity collection from submap `Entity[]` added |
| 3.9 | 29 Nov 2010 | Dialog shown only without execution key; any TSL can be dimensioned |
| 3.8 | 24 Sep 2009 | New option to display dimline in modelspace |
| 3.7 | 30 Jul 2009 | TSL and Drill dimensioning strictly separated |
| 3.6 | 29 May 2009 | TSL dimensioning enhanced with linked element support |
| 3.5 | 25 May 2009 | Translation improvements |
| 3.0 | 19 Sep 2008 | Description alias wraps at 20 characters |
