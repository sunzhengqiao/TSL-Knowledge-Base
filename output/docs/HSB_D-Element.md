# HSB_D-Element

## Overview

HSB_D-Element is a comprehensive dimensioning TSL script that places dimension lines around hsbCAD elements (walls, roofs, floors) in Paper Space or ShopDrawing Multipage views. It provides extensive options for controlling what gets dimensioned, how dimensions are positioned, styled, and referenced.

This script is designed for creating production-ready shop drawings and technical documentation where precise dimensioning of timber construction elements is required.

**Version:** 5.7
**Last Updated:** 30/10/2024
**Author:** Various (Robert Pol, Marsel Nakuci, AS, AJ, YB, DR, RP)

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Space | Paper Space / ShopDrawing Multipage |
| Target | Element views (walls, roofs, floors) |

---

## Prerequisites

Before using this script, ensure:

1. You have an hsbCAD element (wall, roof, or floor) created in Model Space
2. A viewport displaying the element is set up in Paper Space, OR a ShopDrawing Multipage view is configured
3. The viewport/view must have valid hsbCAD data attached

---

## Step-by-Step Usage Guide

### Inserting the Dimension Script

1. **Switch to Paper Space** or open your ShopDrawing layout
2. **Run the HSB_D-Element script** from your TSL menu or command line (TSLINSERT)
3. **Select the Drawing Space** in the dialog:
   - Choose "Paper space" for standard layouts
   - Choose "Shopdraw multipage" for multi-page shop drawings
4. **Click to specify the location** where the dimension script name will appear
5. **Select the viewport** (for Paper Space) or **view entity** (for ShopDrawing)
6. **Configure properties** in the Properties Panel as needed

### Configuring Dimension Parameters

After insertion, select the dimension object and use the Properties Panel (OPM) to configure:

1. **Set the Dimension Object** - What to dimension (Element, Zone, TSL, Beams, etc.)
2. **Configure Positioning** - Where the dimension line appears
3. **Set the Style** - How dimensions are displayed
4. **Define References** - What reference point to use for measurements
5. **Apply Filters** - Exclude specific beams or components

---

## Properties Panel Parameters

### Selected Space Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Selected drawing space | Dropdown | Auto-detected | Shows whether Paper Space or ShopDraw Multipage (read-only after insertion) |

### Filter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter type | Dropdown | Exclude | How to apply filters |
| Section tsl name | Dropdown | - | Link to a section TSL for filtering visibility |
| Filter beams with beamcode | Text | Empty | Exclude beams matching these beamcodes (semicolon-separated, wildcards supported) |
| Filter beams and sheets with label | Text | Empty | Exclude by label (wildcards: *text*, text*, *text) |
| Filter beams and sheets with material | Text | Empty | Exclude by material name |
| Filter beams and sheets with hsbID | Text | Empty | Exclude by hsbID |
| Filter modules | Dropdown | --- | Filter module types (All modules, Opening modules, etc.) |
| Filter zones | Text | Empty | Exclude specific zone indexes (semicolon-separated) |

### Dimension Object Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension object (DO) | Dropdown | Element | What to dimension |

**Available Dimension Objects:**
- **Element** - Overall element dimensions
- **Zone** - Specific zone within element
- **TSL** - TSL instance positions
- **Perimeter** - Perimeter outline
- **Beam with beamcode** - Beams matching specific codes
- **Beams and sheets with label/name** - By label
- **Supporting beams** - Support members
- **Rafters/studs** - Framing members
- **Beams with beamcode within range** - Beams in a distance range
- **Beams of type** - By beam type
- **Beams with ID** - By hsbID
- **Grid** - Grid intersections
- **Connecting walls** - Adjacent wall connections
- **Panels** - Panel components
- **Tools** - Tool positions (drills, cuts)
- **Trusses** - Truss components

### DO - Zone Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index | Int | 0 | Zone to dimension (0-5, or 6-10 for negative zones) |
| Ignore single points for sheets | Yes/No | No | Skip isolated sheet points |
| Only use sheet joints | Yes/No | No | Dimension only where sheets meet |
| Only use extremes of zone | Yes/No | No | Dimension only zone boundaries |
| Combine touching beams and sheets | Yes/No | No | Merge adjacent members |
| Tolerance for combining beams and sheets | Double | 0.1 | Distance tolerance for merging |
| Dimension beams at the element edge | Yes/No | Yes | Include edge beams |
| Use real body of beam | Yes/No | No | Use actual geometry vs envelope body |

### DO - TSL Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| TSL name | Dropdown | All | Which TSL scripts to dimension |
| Dimension origin point of tsl | Yes/No | Yes | Include TSL origin |
| Dimension grip points of tsl | Yes/No | Yes | Include TSL grip points |
| Dimension tsls in zones | Text | Empty | Limit to specific zones |
| Dimension tsls with sub types | Text | Empty | Filter by TSL subtype |

### DO - Perimeter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index perimeter | Int | 0 | Zone for perimeter calculation |
| Additional zone indexes | Text | Empty | Extra zones (semicolon-separated) |
| Perimeter calculated from | Dropdown | Use entities from zone | Source for perimeter |
| Perimeter dimension mode | Dropdown | Outline vertices | Calculation method (Convex hull, Outline vertices, Extremes) |
| With openings | Yes/No | Yes | Include opening outlines |
| Perimeter range | Double | 0 | Limit distance range |

### DO - Beam with beamcodes Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcodes | Text | Empty | Beamcodes to dimension (semicolon-separated) |

### DO - Beam with labels or names Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Labels or names | Text | Empty | Labels to dimension |
| Include non perpendicular to dimension line | Yes/No | No | Include angled beams |

### DO - Rafters/studs Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension rafters/studs at the element edge | Yes/No | No | Include edge rafters |
| Only take rafters/studs from the specified zone | Yes/No | No | Limit to selected zone |
| Combine touching rafters | Yes/No | Yes | Merge adjacent rafters |
| Dimension rafters on the inside of the frame | Yes/No | No | Measure from inside |

### DO - Beams with beamcodes within range Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Range | Double | 0 | Distance range to search |
| Only dimension points in range | Yes/No | Yes | Limit to range only |

### DO - Beam of type Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam type | Dropdown | - | Select beam type from list |

### DO - Beam with hsb Id Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hsb Id's | Text | Empty | hsbIDs to dimension (semicolon-separated) |

### DO - Panels Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Component index | Text | -1 | Panel component (-1 = all, semicolon-separated list) |
| Component face | Dropdown | Internal and external face | Which faces to dimension |
| Take component extremes | Yes/No | Yes | Use extreme points |
| Take all component extremes | Yes/No | No | Include all extreme points |
| Panel range | Double | 0 | Limit distance range |

### DO - Tools Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool type | Dropdown | Drill | Type of tool to dimension (Drill, Beamcut) |
| Only with drill diameter | Double | 0 | Filter by drill size (0 = all) |
| Minimum beam cut depth | Double | 0 | Minimum cut depth |

### Miscellaneous Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Special - Customer specific | Text | Empty | Special processing flags |

### Positioning Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset from | Dropdown | Element | Reference for offset calculation |
| Offset in paperspace units | Yes/No | No | Use PS units for offset |
| Offset dimension line | Double | 300 | Distance from element |
| Offset description | Double | 100 | Distance for text label |
| Position | Dropdown | Vertical Left | Dimension line placement |
| Minimum points required | Int | 2 | Minimum dimension points needed |
| Merge points closer to each other than | Double | 0.01 | Merge tolerance |

**Position Options:**
- Vertical Left
- Vertical Right
- Horizontal Bottom
- Horizontal Top
- Automatic Vertical
- Automatic Horizontal

### Style Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side of delta dimension | Dropdown | Above | Delta text position (Above, Below, At element side, At the other side) |
| Read direction | Dropdown | Top-left | Text orientation (Top-left, Bottom-right) |
| Side of description | Dropdown | Left | Description placement (Left, Right, None) |
| Start dimension | Dropdown | Left | Starting point (Left, Right, Automatic) |
| Dimension method | Dropdown | Delta perpendicular | Dimension style |
| Dimension side | Dropdown | Left | Which side of objects (Left, Center, Right, Left & Right, Automatic Left, Automatic Right) |
| Dimension style | Dropdown | (Drawing styles) | AutoCAD dimension style |
| Use viewport scale as dimension scale | Yes/No | Yes | Match viewport scale |
| Color | Int | 1 | Dimension color |
| Place extension lines | Dropdown | To side of element | Extension line mode |
| Overrule description | Text | Empty | Custom description text |

**Dimension Methods:**
- Delta perpendicular
- Delta parallel
- Cumulative perpendicular
- Cumulative parallel
- Both perpendicular
- Both parallel
- Delta parallel, Cumulative perpendicular
- Delta perpendicular, Cumulative parallel

### Reference Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reference object | Dropdown | Element | Reference for measurements |
| Frame as extra reference | Dropdown | No extra reference | Add frame as reference (Inside frame, Outside frame) |
| Reference zone | Int | 0 | Zone for reference |
| Reference beamcode | Text | Empty | Beamcode for reference |
| Use real body of reference beam | Yes/No | No | Use actual geometry |
| Number of grid points to dimension | Int | 1 | Grid points count |
| Offset Grid Reference | Double | 0 | Grid reference offset |
| Use points outside Reference boundary | Yes/No | Yes | Include external points |
| Reference perimeter calculated from | Dropdown | Use entities from zone | Reference perimeter source |
| Component index reference | Text | -1 | Panel component for reference |
| Component face reference | Dropdown | Internal and external face | Reference face |
| Reference side | Dropdown | Left | Reference measurement side (Left, Center, Right, Left & Right) |
| Reference seperated | Yes/No | No | Show separate reference dimension |
| Extra offset seperated reference | Double | -25 | Offset for separated reference |
| Signed reference | Yes/No | No | Show +/- signs |
| Text positive reference left | Text | Empty | Label for positive left |
| Text negative reference left | Text | Empty | Label for negative left |
| Text positive reference right | Text | Empty | Label for positive right |
| Text negative reference right | Text | Empty | Label for negative right |
| Reference text type | Dropdown | No text | Reference label type (No text, Text with dim, Text at line) |
| Y-Offset reference text | Double | 0 | Vertical offset for text |

**Reference Objects:**
- Element
- Zone
- No reference
- Rafters
- Beamcode
- Beamcode in range
- Grid
- Half grid
- Element outline
- Wall icon
- Perimeter
- Panel

### Name and Description Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Default name color | Int | -1 | Script name color |
| Filter other element color | Int | 30 | Color when filter excludes element |
| Filter this element color | Int | 1 | Color when filter includes element |
| Dimension style name | Dropdown | (Drawing styles) | Style for name text |
| Extra description | Text | Empty | Additional description |
| Disable the tsl | Yes/No | No | Temporarily disable dimension |
| Show viewport outline | Yes/No | No | Debug: show VP boundary |

---

## Right-Click Menu Options

Right-click on the dimension object to access these context menu commands:

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Add current element to filter list (dimensions hidden) |
| Remove filter for this element | Remove current element from filter |
| Remove filter for all elements | Clear all element filters |

---

## Settings Files

This script does not use external XML settings files. All configuration is stored in the script's Map data and OPM properties.

---

## Tips

### Performance Optimization
- Use "Envelope body" (Use real body = No) instead of "Real body" when precise cuts are not needed for faster calculations
- Filter out unnecessary beams/zones to reduce calculation time
- Set appropriate "Merge points closer to each other than" value to avoid dimension clutter

### Wildcard Filtering
Use wildcards in filter fields:
- `*text*` - Contains "text"
- `text*` - Starts with "text"
- `*text` - Ends with "text"

### Automatic Positioning
- Use "Automatic Vertical" or "Automatic Horizontal" position to let the script determine optimal placement based on the element's reference position property (reads from hsbInformation or hsbExtendedElementData property sets)

### Working with Sections
- Link to a section TSL (HSB-Section) to dimension only visible beams in that section view
- Set "Section tsl name" to the section script you want to follow

### Special Codes
The "Special - Customer specific" field supports special functionality:
- `ElementOutline` - Use element outline for reference extremes
- `IF` - Include inside frame as extra dimension points
- `Face` - Dimension beam faces for beamcode dimensioning
- `BC-Back` - Dimension back side of beamcodes
- `Extremes` - Dimension extremes of supporting beams
- `ZONE` - Add zone as extra dimension object
- `STKR` - Add dimension from STKR beam to first tile lath
- `InsideOpening` / `InsideOpening2` - Dimension inside openings
- `ExtraBeamCodes` - Add extra beamcodes to dimension
- `HSB-TILELATH-01` - Add delta dims of tile laths
- Multiple specials can be combined with semicolons

### Dimensioning Multiple Zones
To add dimensions to multiple zones, insert multiple instances of HSB_D-Element, each configured for a different zone, or use "Additional zone indexes" for perimeter dimensioning.

### Both-Side Dimensioning
Set "Dimension side" to "Left & Right" to dimension both sides of objects, or insert two dimension instances with opposite positions.

---

## Frequently Asked Questions

### Q: Why are my dimensions not showing?
**A:** Check these common causes:
1. "Minimum points required" is set higher than available points
2. Filters are excluding all beams
3. The TSL is disabled (check "Disable the tsl" property)
4. Element filter is active (check right-click menu)
5. Viewport has no valid hsbCAD element attached
6. Wrong drawing space selected (Paper Space vs ShopDraw)

### Q: How do I dimension only specific beams?
**A:** Use one of these approaches:
1. Set "Dimension object" to "Beam with beamcode" and enter the beamcodes
2. Use "Filter beams with beamcode" to exclude unwanted beams
3. Set "Dimension object" to "Beams of type" for type-based selection
4. Set "Dimension object" to "Beams with ID" and enter hsbIDs

### Q: Why are dimension values different from expected?
**A:** Check:
1. "Use real body of beam" setting - envelope body includes profile without cuts
2. "Dimension side" setting - left/center/right affects measurement point
3. Reference object settings - incorrect reference shifts all values
4. "Offset from" setting - Element vs Dimension objects

### Q: Can I dimension both sides of an element?
**A:** Yes, set "Dimension side" to "Left & Right" or insert two dimension instances with opposite positions.

### Q: How do I match the dimension style to my company standards?
**A:** Use the "Dimension style" dropdown to select from available AutoCAD dimension styles in your drawing template.

### Q: Why does "Automatic" positioning not work as expected?
**A:** Automatic positioning reads the element's type code (e.g., "BL" for Bottom-Left). Ensure your element has the correct subtype/code set, or check the "hsbInformation" or "hsbExtendedElementData" property sets for "DimensionReferencePosition" or "hsbDimensionOrigin".

### Q: Can I use this script in Model Space?
**A:** No. This script is designed explicitly for Paper Space (Shop Drawings) and ShopDraw Multipage views. It uses the viewport scale to calculate correct sizing and will not function correctly without a layout context.

### Q: How do I show grid reference dimensions?
**A:** Set "Reference object" to "Grid" or "Half grid", and set "Number of grid points to dimension" to the desired count. The element must have grid data attached.

---

## Related Scripts

- **HSB-Section (PS)** - Section views that can be linked for filtered dimensioning
- **MultipageController** - For shop drawing multipage workflows
- **HSB_D-Beam** - For individual beam dimensioning

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 5.7 | 30/10/2024 | Added grid reference offset |
| 5.6 | 07/12/2022 | Fixed orientation of description |
| 5.5 | 10/08/2021 | Added option to use real body in zone 0 |
| 5.4 | 18/06/2021 | Added option to dimension only points within range |
| 5.0 | 14/11/2019 | Added categories and multiple component indexes |
| 4.0 | 13/05/2015 | Major update with panel dimensioning |
| 3.0 | 25/11/2011 | Reorganized properties, added automatic mode |
| 2.0 | 03/04/2008 | Added conditional visibility |
| 1.0 | 03/03/2004 | First revision |
