# sdUK_SIPDimensions

Automatic dimensioning script for SIP (Structural Insulated Panel) components in shop drawings. This script generates comprehensive dimension requests for contours, drills, openings, beam cuts, and angular measurements on SIP panels.

## Overview

The sdUK_SIPDimensions script automatically creates dimensioning for SIP panels in shop drawing layouts. It analyzes the panel geometry and generates dimension requests for:

- **Contour dimensions** - Shape and edge measurements at vertices
- **Drill dimensions** - Location and diameter of all drill holes with configurable display modes
- **Opening dimensions** - Positions of window/door cutouts in SIPs and Sheets
- **Extreme dimensions** - Overall length and width measurements
- **Angular dimensions** - Non-90-degree angles in the contour with proximity filtering
- **Beam cut dimensions** - Housing and dado cut locations
- **Radial dimensions** - Arc radius measurements for curved contours

The script works with the hsbCAD shop drawing engine to automatically place dimensions according to your layout definition settings.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Partial | Script attaches to beams in Model Space but does not generate visible geometry there |
| Paper Space | Yes | Dimensions are generated when the shop drawing layout is processed |
| Shop Drawing | Yes | Primary environment; executed by the shop drawing engine |

- **Script Type**: E-Type (Entity-based)
- **Required Beams**: 1 (operates on a single GenBeam, SIP, or Sheet)
- **DXA Output**: Yes (exports dimension data)

## Prerequisites

1. **Required Script**: The script requires `mapIO_GetArcPLine.mcr` to be available in the drawing or TSL search paths. This helper script converts segmented polylines to arcs for proper radial dimensioning.

2. **Layout Definition**: Configure appropriate stereotypes in your layout definition for:
   - `Contour` - Contour edge dimensions
   - `Extremes` - Overall dimension lines
   - `Drill` / `OppositeDrill` - Hole location dimensions
   - `Beamcut` - Housing and dado cut dimensions
   - `Opening` - Window/door opening dimensions

3. **Multipage Style**: Add this script to the ruleset of a multipage style that processes SIP panels.

## Usage

### Automatic Execution (Recommended)

1. Configure your multipage style to include this script in its ruleset
2. Generate shop drawings using the shop drawing engine
3. The script automatically processes each SIP panel and creates dimension requests
4. Dimensions appear according to your layout definition settings

### Manual Insertion

1. Command: `TSLINSERT` and select `sdUK_SIPDimensions.mcr`
2. When prompted "Select GenBeam", click on the SIP panel or timber beam
3. When prompted "Select point near tool", click to define the dimension reference location
4. The script generates dimension requests for all views

### Editing Settings

1. Select an existing instance of the script
2. Access Properties through right-click menu or Properties Palette
3. The MapIO dialog displays all configurable parameters
4. Modify settings and click OK to apply changes

## Parameters

### Drill Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Chain Content (Drill) | Dropdown | Chain Dimension | Controls how drill dimensions are displayed |
| Diameter Units | Dropdown | DWG Unit | Unit for diameter/radius values (DWG Unit, m, cm, mm, in, ft) |
| use Stereotype 'OppositeDrill' | Yes/No | No | Drills on the back face use "OppositeDrill" stereotype |
| draw Drills as Circles | String | (empty) | Color codes for drawing drill circles |

**Chain Content Options:**
- **Chain Dimension** - Position only, with radial dimension for diameter
- **Chain Dimension with Diameter** - Position plus diameter text on center point
- **Diameter only** - Shows diameter text without chain positions
- **Diameter at Reference Point** - Shows diameter at reference with quantity prefix
- **Individual Diameter at Drill Point** - Creates individual stereotypes per diameter size
- **Suppress Drill Dimensions** - Hides all drill-related dimensions

### Contour Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Additional Dimline Extremes | Yes/No | No | Adds extra dimension line for overall extreme points |
| Add Contour Angles | Dropdown | Add | Controls angular dimensions for non-90-degree corners |
| Angular Dimension Offset | Double | 25 mm | Distance offset for angular dimension placement |
| Segment to Arc Length | Double | 5 mm | Maximum segment length convertible to arc for radial dimensioning |
| Extrusion Profile Dimensioning | Dropdown | Low Detail | Detail level for extrusion-based beam profiles |

**Add Contour Angles Options:**
- **Add** - Shows all non-90-degree angles
- **Add and suppress same angle near by** - Filters duplicate angles on adjacent vertices
- **Do not show** - Hides all angular dimensions

**Extrusion Profile Dimensioning Options:**
- **Low Detail** - Uses boxed (rectangular) shape for dimensions
- **High Detail** - Uses full extrusion profile contour
- **Do not show** - Suppresses profile dimensions

### Stereotype Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Stereotype Contour Dimensioning | String | Contour | Stereotype for contour dimensions |
| Stereotype Extreme Dimensioning | String | Extremes | Stereotype for overall dimensions |
| Stereotype Beamcut Dimensioning | String | Beamcut | Stereotype for housing/dado dimensions |
| Stereotype Opening Dimensioning | String | Opening | Stereotype for opening dimensions |

Enter `---` in any stereotype field to suppress that dimension type.

## Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties Palette (OPM) for parameter configuration |
| Recalculate | Forces the script to re-run when beam geometry has changed |

Settings are accessed through the MapIO dialog when the script is selected, presenting all parameters organized into logical groups.

## Tips

### Optimizing Dimension Output

- **Suppress unnecessary dimensions**: Enter `---` in stereotype fields to hide specific dimension types
- **Control drill display**: Use "Suppress Drill Dimensions" option if drills are dimensioned elsewhere
- **Manage clutter**: Enable "Add and suppress same angle near by" to reduce redundant angular dimensions at closely spaced vertices

### Working with Multiple Drill Sizes

- When multiple drill diameters exist, the script automatically switches from "Diameter at Reference Point" to "Diameter only" mode
- A message appears in the command line when this automatic switch occurs
- Use "Individual Diameter at Drill Point" for clearest identification - creates unique stereotypes like "Drill20", "Drill25" based on diameter in mm

### Drawing Drill Circles

The "draw Drills as Circles" parameter accepts special formatting:
- `*;*` - Draw circles using component/zone colors (front; back)
- `1;2` - Draw front-side drills in color 1, back-side in color 2
- `*` - Single color for viewing side only using component color
- Complete (through) drills are drawn in the main view color

### Arc Detection

The script automatically detects curved edges approximated with straight segments:
- Segments shorter than "Segment to Arc Length" may be combined into arcs
- For polylines with many even-length segments (like rounded extrusions), the threshold auto-adjusts
- A message appears when segment length is automatically adjusted
- Radial dimensions are added for all detected arcs

### View-Specific Behavior

The script processes three view directions:
- **Front View** (Y-axis normal): Full contour, drill, and extreme dimensioning
- **Top View** (Z-axis normal): Includes opening dimensions for SIPs and Sheets
- **Side View** (X-axis normal): Contour and extreme dimensions, extrusion profile handling

Dimension requests include view restrictions, ensuring dimensions only appear in appropriate viewports.

### Stereotype Configuration

Configure stereotypes in your layout definition to control:
- Dimension style (text height, arrow type, precision)
- Layer assignment and visibility
- Color and linetype appearance
- Offset distance from geometry

Each stereotype can be independently styled, allowing distinct appearances for contour vs. drill vs. opening dimensions.

### Performance Considerations

- The script uses envelope bodies (`envelopeBody()`) for better performance
- Complex SIP panels with many openings may take longer to process
- Ensure `mapIO_GetArcPLine.mcr` is accessible to avoid arc detection errors

## FAQ

**Q: Why don't I see dimensions immediately after inserting the script?**

A: This is a shop drawing script. Dimensions are generated when you create or update the shop drawing layout (Paper Space), not directly in Model Space.

**Q: My drill holes are not dimensioning.**

A: Check the "Chain Content (Drill)" property. If set to "Suppress Drill Dimensions", no drill annotations are created. Also verify the "Drill" stereotype exists in your layout definition.

**Q: How do I change the unit for hole sizes only?**

A: Use the "Diameter Units" property. This allows displaying hole diameters in a different unit (e.g., inches) than the rest of the drawing.

**Q: Why do some angular dimensions not appear?**

A: Angular dimensions are only shown for acute angles (less than 90 degrees). 90-degree and obtuse angles are suppressed. Also, points that fall on drill circle edges are excluded from angular dimensioning.

**Q: The script reports "No GenBeam found" and erases itself.**

A: Ensure you have selected a valid SIP panel, Sheet, or Beam entity. The script requires at least one GenBeam to operate.

**Q: How do I flip which side dimensions appear on?**

A: Move the reference point (`_Pt0`) to the opposite side of the beam using the grip point. This changes the dimension placement side in the layout.
