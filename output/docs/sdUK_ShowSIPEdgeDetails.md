# sdUK_ShowSIPEdgeDetails

**Version:** 1.5
**Category:** SIP / Shop Drawing
**Author:** Chirag Sawjani (hsbSOFT)

## Summary

Generates detailed edge profile cross-sections for Structural Insulated Panel (SIP) walls in shop drawings. This script extracts, analyzes, and displays edge geometry including bevel angles, recess depths, layer composition, and precise dimensions for each edge of a SIP panel. Specifically designed for UK SIP fabrication workflows.

## Overview

The `sdUK_ShowSIPEdgeDetails` script is a specialized shop drawing tool that automatically produces comprehensive edge detail drawings for SIP panels. It works by slicing through the panel at the center of each edge, extracting the cross-sectional profile, and arranging these details in an organized grid layout with full dimensional information.

### What It Does

1. **Edge Slicing**: Creates perpendicular cross-section slices at the midpoint of each SIP edge
2. **Layer Visualization**: Displays all component layers (OSB skins, insulation core, etc.) in the edge profile
3. **Geometric Analysis**: Calculates bevel angles for angled edges relative to the panel normal
4. **Recess Detection**: Identifies and dimensions any recess depths in the edge
5. **Auto-Dimensioning**: Adds horizontal and vertical dimensions to each edge detail
6. **Grid Layout**: Organizes multiple edge details in a configurable column/row layout

### Key Features

- Supports both Model Space and Shop Drawing Multipage environments
- Automatic coordinate transformation between model and paper space
- Intelligent edge detection with multi-ring profile handling
- Configurable dimension styles and colors
- Customizable grid layout with row/column control
- Handles beveled, chamfered, and angled edges
- Works with complex SIP panel geometries

## Environment

| Attribute | Value |
|-----------|-------|
| **Script Type** | O (Object) |
| **TSL Type** | Shop Drawing Tool |
| **Environment** | Paper Space / Model Space |
| **Beams Required** | 0 |
| **Points Required** | 0 |
| **Major Version** | 1 |
| **Minor Version** | 5 |

### Execution Context

**Model Space Mode:**
- Operates directly on SIP panel entities in the 3D model
- Allows selection of multiple SIP panels
- Displays results at specified insertion point

**Shop Drawing Multipage Mode:**
- Works with existing ShopDrawView entities
- Automatically extracts SIP panels from the selected view
- Handles coordinate system transformations between model and paper space
- Maintains association with source view data

## Prerequisites

Before running this script, ensure:

1. **SIP Panels Exist**: One or more valid SIP panel entities must be present in the drawing
2. **SIP Style Defined**: Panels must have a properly configured SipStyle with component layers
3. **Dimension Style**: A suitable dimension style should be configured for the drawing units
4. **Shop Drawing Setup** (for multipage mode): Valid ShopDrawView entities with ViewData stored in the script's Map

### Required Data Structures

The script relies on:
- **SIP Entity**: Complete SIP panel geometry with real body and envelope body
- **SipStyle**: Component layer definitions (OSB skins, foam core, etc.)
- **SipEdge Array**: Edge geometry including start/end points, midpoints, normals, and recess data
- **ViewData** (multipage mode): Coordinate system transformation data linking model to paper space

## Parameters (OPM Properties)

The following parameters are accessible in the AutoCAD Properties Palette when the script instance is selected:

### Core Settings

| Parameter | Type | Index | Default | Description |
|-----------|------|-------|---------|-------------|
| **Drawing space** | PropString (Dropdown) | 0 | "Model" | Select drawing environment: "Model" for direct model selection, "shopdraw multipage" for shop drawing views |
| **Dimstyle** | PropString (Dropdown) | 1 | (Current) | Dimension style from _DimStyles list - controls all dimension appearance, text height, arrow size, and units |

### Appearance

| Parameter | Type | Index | Default | Description |
|-----------|------|-------|---------|-------------|
| **Detail Color** | PropInt | 0 | 1 (Red) | Color index (0-255) for edge profile outlines and dimension lines |
| **Text Color** | PropInt | 1 | 0 (ByBlock) | Color index (0-255) for edge labels (E1, E2...), bevel angle text, and recess depth text |

### Layout Control

| Parameter | Type | Index | Default | Description |
|-----------|------|-------|---------|-------------|
| **Maximum Number of Rows** | PropInt | 2 | 5 | Maximum edge details per column before creating new column - controls vertical stacking |
| **Dimensions offset** | PropDouble | 0 | 50 mm | Distance from edge profile to dimension lines - larger values push dimensions further from geometry |
| **Extra offset between details** | PropDouble | 1 | 200 mm | Additional vertical spacing between consecutive edge details in same column |

### Parameter Validation

- Color values are validated: if < 0 or > 255, automatically reset to default (0 or 1)
- All double values use unit conversion: `U()` function ensures compatibility with mm/inch templates

## Usage Workflow

### Step 1: Launch Script

Execute `sdUK_ShowSIPEdgeDetails` from the TSL menu, toolbar, or command line.

### Step 2: Configure Settings Dialog

A settings dialog appears with all OPM parameters. Configure:

1. **Drawing space**: Choose "Model" or "shopdraw multipage"
2. **Dimstyle**: Select appropriate dimension style for your sheet scale
3. **Detail Color**: Set color for edge geometry (typically 1=Red or 7=White)
4. **Text Color**: Set color for text labels (typically 0=ByBlock or 7=White)
5. **Maximum Number of Rows**: Set based on available vertical space (5-8 typical)
6. **Dimensions offset**: Adjust if dimensions overlap geometry (50-100 mm typical)
7. **Extra offset between details**: Increase for clearer separation (200-400 mm typical)

### Step 3: Pick Insertion Point

Command prompt:
```
Pick a point for edge details
```

Click in the drawing to specify the origin for the edge detail grid. The grid will expand:
- **Downward** (negative Y direction): Edge details stack vertically
- **Rightward** (positive X direction): New columns form when max rows reached

**Planning Tip**: Allow approximately:
- **Vertical space**: (Max Rows × 400mm) + additional clearance
- **Horizontal space**: (Number of edges / Max Rows) × (Panel depth + 400mm)

### Step 4: Select SIP Elements

Prompts depend on the **Drawing space** setting:

#### Model Space Mode

Command prompt:
```
Please select Elements
```

**Selection Process:**
1. Select one or more SIP panel entities using standard AutoCAD selection
2. Window selection, crossing selection, or individual picks are all supported
3. Script validates each entity is a valid `Sip` type
4. All selected panels are stored in `_Entity` array

**Multi-Panel Behavior**: If multiple panels selected, their edges are processed sequentially. Edge numbering continues across panels (E1-E4 from Panel 1, E5-E8 from Panel 2, etc.).

#### Shop Drawing Multipage Mode

Command prompt:
```
Select the view entity from which the module is taken
```

**Selection Process:**
1. Select the ShopDrawView entity (viewport border/frame)
2. Script extracts ViewData from the script's internal `_Map` storage
3. Coordinate system transformation (`ms2ps`, `ps2ms`) is established
4. SIP panels associated with that view are automatically retrieved
5. Only one view can be selected per script instance

**Troubleshooting**: If "no viewData found" message appears, the selected viewport lacks associated ViewData - regenerate the shop drawing or select a different view.

### Step 5: Review Generated Output

The script automatically generates a grid of edge details. For each edge:

#### Edge Detail Display Components

**1. Edge Identifier (Top)**
```
E1    E2    E3    E4
```
Sequential numbering based on `sipEdges` array order.

**2. Cross-Sectional Profile**
- **Outer envelope**: Shows panel boundary (shrunk by 10mm for clarity after v1.5 bugfix)
- **Component layers**: Individual material layers (OSB, foam, etc.) shown separately
- **Slice orientation**: Perpendicular to edge direction, looking along the edge vector

**3. Bevel Angle Text**
```
Bevel Angle: 45.00
```
- Calculated as angle between edge normal vector and panel Z-axis
- Always normalized to 0-90 degree range (acute angle)
- Formula: `90 - abs(vecNormal.angleTo(-vz))`
- Critical for CNC machining setup

**4. Recess Depth Text**
```
Recess Depth: 12.50
```
- Extracted from `SipEdge.dRecessDepth()` property
- Displayed in current drawing units with 2 decimal precision
- Zero values shown as "0.00"

**5. Horizontal Dimensions (Top)**
- Dimension line runs parallel to panel depth (Z-axis direction)
- Offset distance: `dDimOffset` parameter above the edge profile
- Shows thickness measurements across the panel depth
- All vertex points projected onto horizontal reference line

**6. Vertical Dimensions (Side)**
- Dimension line runs perpendicular to panel depth
- Positioned based on edge normal direction (left or right side)
- Shows height/offset measurements along the edge profile
- Excludes first point (base reference) to avoid redundant zero dimension
- Only drawn if 2+ significant points exist

### Step 6: Verify Output Quality

**Visual Checks:**

1. **Edge Count**: Verify edge detail count matches expected panel edge count
2. **Bevel Angles**: Check angles match design intent (typically 90.00° for square edges)
3. **Layer Visibility**: Confirm all component layers (skins, core) are visible in profiles
4. **Dimension Accuracy**: Spot-check dimensions against known panel specifications
5. **Layout Spacing**: Ensure details are clearly separated without overlap

**Common Adjustments:**

- **Dimensions too crowded**: Increase "Dimensions offset" (e.g., 50 → 100 mm)
- **Details overlapping**: Increase "Extra offset between details" (e.g., 200 → 350 mm)
- **Too many columns**: Increase "Maximum Number of Rows" (e.g., 5 → 8)
- **Text unreadable**: Change Dimstyle to one with larger text height
- **Wrong colors**: Adjust "Detail Color" and "Text Color" to match drawing standards

## Technical Details

### Edge Slicing Algorithm

The script employs a sophisticated slicing methodology:

#### 1. Edge Midpoint Calculation
```c
Point3d ptStart = edge.ptStart();
Point3d ptEnd = edge.ptEnd();
Point3d ptMid = edge.ptMid();
Vector3d vecVertex = ptEnd - ptStart;
vecVertex.normalize();
```

#### 2. Slice Plane Creation
```c
Plane plSlice(ptMid, vecVertex);
```
Slice plane is perpendicular to the edge, passing through its midpoint.

#### 3. Profile Extraction

**Envelope Slice:**
```c
PlaneProfile ppSliceEnvelope = bdSipEnvelope.getSlice(plSlice);
ppSliceEnvelope.shrink(U(-10)); // Expand slightly
```

**Real Body Slice:**
```c
PlaneProfile ppSlice = bdSipReal.getSlice(plSlice);
```

**Component Layer Slices:**
```c
for (int b = 0; b < bdComponents.length(); b++) {
    Body bd = bdComponents[b];
    PlaneProfile pp = bd.getSlice(plSlice);
    pp.shrink(dEps * 0.01); // Shrink to avoid overlap
    ppSliceComponents.joinRing(pl[p], false);
}
```

#### 4. Multi-Ring Resolution

For complex geometries where slicing produces multiple rings:

```c
if (ppTemp.pointInProfile(ptMid) == _kPointInProfile) {
    ppSliceEnvelope = ppTemp;
    // Find corresponding real body slice in this ring
    ppSliceComponents.intersectWith(ppSliceCurr);
}
```

Only the ring containing the edge midpoint is retained.

### Bevel Angle Calculation

The script calculates bevel angles relative to the panel normal:

```c
Vector3d vecRef = vz.crossProduct(vecN);
double dBevelAngle = abs(-vz.angleTo(vecN));
double dBevelAngleQ1;

if (dBevelAngle > 90 && dBevelAngle <= 180) {
    dBevelAngleQ1 = 90 - abs(dBevelAngle - 180);
} else {
    dBevelAngleQ1 = 90 - abs(dBevelAngle);
}
```

**Result**: Always returns acute angle (0-90°) for machining reference.

**Edge Cases:**
- 90.00° = perpendicular edge (standard)
- 45.00° = 45-degree chamfer
- 0.00° = edge parallel to panel face (unusual)

### Coordinate System Transformations

#### Model Space to Paper Space

When operating in shop drawing mode:

```c
ShopDrawView sv = (ShopDrawView)_Entity[0];
ViewData arViewData[] = ViewData().convertFromSubMap(_Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
int nIndFound = ViewData().findDataForViewport(arViewData, sv);
ViewData vwData = arViewData[nIndFound];

ms2ps = vwData.coordSys();
ps2ms = ms2ps;
ps2ms.invert();
```

All geometry extracted from model space is transformed to paper space coordinates before display.

#### Detail Placement Transformation

```c
CoordSys csTrans();
csTrans.setToAlignCoordSys(
    ptProjectedExtreme, -vz, vecLengthPP, -vz.crossProduct(vecLengthPP),  // Source CS
    ptNewOrigin, _XW, _YW, _ZW                                              // Target CS
);

dimHorizontal.transformBy(csTrans);
dimVertical.transformBy(csTrans);
ppSliceComponents.transformBy(csTrans);
```

Maps edge profile from SIP local coordinate system to paper space grid position.

### Grid Layout Algorithm

```c
int nColumns = ceil((e) / nMaxRows);

if (nRowCount + 1 > nMaxRows) {
    nRowCount = 0;
    dNewDetailVertOffset = 0;
}

Point3d ptNewOrigin = _Pt0
    - U(100) * _YW
    - dNewDetailVertOffset * _YW
    + dNewDetailHorizOffset * nColumns * _XW;
```

**Layout Logic:**
- `nRowCount`: Current row in column (0 to nMaxRows-1)
- `nColumns`: Current column index (0, 1, 2...)
- `dNewDetailVertOffset`: Cumulative vertical offset in current column
- `dNewDetailHorizOffset`: Horizontal spacing between columns

**Grid Direction:**
- Primary direction: **Downward** (-Y), stacking edge details vertically
- Secondary direction: **Rightward** (+X), creating new columns

### Dimension Placement

#### Horizontal Dimension

```c
Point3d ptSliceVertices[] = ppSliceEnvelope.getGripVertexPoints();
Line lnHorizontal(ptExtremeStart, -vz);
Point3d ptSliceProjected[] = lnHorizontal.projectPoints(ptSliceVertices);
Point3d ptDimsHorizontal[] = lnHorizontal.orderPoints(ptSliceProjected);

DimLine dlHorizontal(ptExtremeStart + (dDimOffset * vecLengthPP), -vz, vecLengthPP);
Dim dimHorizontal(dlHorizontal, ptDimsHorizontal, "<>", "<>", _kDimDelta, _kDimNone);
```

**Process:**
1. Get all vertex points from envelope profile
2. Project points onto horizontal reference line
3. Order points along the line
4. Create dimension line offset by `dDimOffset` in `vecLengthPP` direction
5. Generate delta dimensions (distances between consecutive points)

#### Vertical Dimension

```c
Line lnVertical;
if (vecN.dotProduct(-vz) < 0) {
    lnVertical = Line(ptExtremeStart - ((0.5 * dSipDepth) * -vz), vecLengthPP);
} else {
    lnVertical = Line(ptExtremeStart + ((0.5 * dSipDepth) * -vz), vecLengthPP);
}

Point3d ptSliceProjectedVertical[] = lnVertical.projectPoints(ptSliceVerticesEnvelope);
Point3d ptDimsVertical[] = lnVertical.orderPoints(ptSliceProjectedVertical);
ptDimsVertical.removeAt(0); // Remove base reference point

if (ptDimsVertical.length() > 1) {
    DimLine dlVertical;
    if (vecN.dotProduct(-vz) < 0) {
        dlVertical = DimLine(ptExtremeStart - ((0.5 * dSipDepth) * -vz) - (dDimOffset * -vz), vecLengthPP, vz);
    } else {
        dlVertical = DimLine(ptExtremeStart + ((0.5 * dSipDepth) * -vz) + (dDimOffset * -vz), -vecLengthPP, -vz);
    }
    Dim dimVertical(dlVertical, ptDimsVertical, "<>", "<>", _kDimDelta, _kDimNone);
}
```

**Direction Logic:**
- If edge normal points downward (`vecN.dotProduct(-vz) < 0`): Place dimension on left side
- If edge normal points upward: Place dimension on right side
- Ensures dimensions don't overlap with edge profile

### Text Placement

```c
String sEdgeDetail = "E" + (e + 1);
String sBevelAngleText = "Bevel Angle: " + sBevelAngle;
String sRecessDepthText = "Recess Depth: " + sRecessDepth;

// Vertical offsets (stacking text above edge detail)
double dVertDetailOffset = dOffsetDistance + dp.textHeightForStyle("E", sDimLayout) + U(10);
double dVertBevelOffset = dVertDetailOffset + dp.textHeightForStyle("R", sDimLayout) + U(10);
double dVertRecessOffset = dVertBevelOffset + dp.textHeightForStyle("R", sDimLayout) + U(20);

// Horizontal centering
double dHorizDetailOffset = 0.5 * dp.textLengthForStyle(sEdgeDetail, sDimLayout);
double dHorizBevelOffset = 0.5 * dp.textLengthForStyle(sBevelAngleText, sDimLayout);

// Draw text
dp.color(nTextColor);
dp.draw(sEdgeDetail, ptNewOrigin - (dVertDetailOffset * _YW) - (dHorizDetailOffset * _XW), _XW, _YW, 1, -1);
dp.draw(sBevelAngleText, ptNewOrigin - (dVertBevelOffset * _YW) - (dHorizBevelOffset * _XW), _XW, _YW, 1, -1);
dp.draw(sRecessDepthText, ptNewOrigin - (dVertRecessOffset * _YW) - (dHorizBevelOffset * _XW), _XW, _YW, 1, -1);
```

**Text Layout (Top to Bottom):**
1. Edge identifier (E1, E2, etc.) - centered
2. Bevel angle - centered
3. Recess depth - centered
4. Edge profile and dimensions
5. Next edge detail...

## Dialog Interface

The script uses a settings dialog via `showDialog()` method, which presents all OPM parameters for user configuration before insertion.

**Dialog Fields:**
- Drawing space dropdown (Model / shopdraw multipage)
- Dimstyle dropdown (populated from `_DimStyles` list)
- Detail Color integer input (0-255)
- Text Color integer input (0-255)
- Maximum Number of Rows integer input
- Dimensions offset double input (with units)
- Extra offset between details double input (with units)

**Workflow Integration:**
1. User launches script
2. Dialog appears automatically (due to `_bOnInsert` check)
3. User configures settings
4. Dialog closes, prompts for insertion point
5. Selection prompts follow
6. Script executes with configured parameters

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| **1.0** | 13.07.2012 | Initial release | Chirag Sawjani |
| **1.1** | 07.08.2014 | Made angle output consistent with other panel CNC output | Chirag Sawjani |
| **1.2** | 11.06.2015 | Altered vectors to suit new coordsys, valid from hsbCAD 19.1.104 | Chirag Sawjani |
| **1.3** | (date unknown) | Unreleased version | - |
| **1.4** | 03.08.2021 | HSB-12767: Bugfix for dimension lines | Thorsten Huck |
| **1.5** | 05.08.2021 | HSB-12767: Bugfix for outlines (envelope shrink/expand logic) | Thorsten Huck |

**Critical Version Note**: v1.2+ requires hsbCAD 19.1.104 or later due to coordinate system changes in the SIP entity definition.

## Tips and Best Practices

### Layout Optimization

**For Portrait Sheets (A1, A0 vertical):**
- Set `Maximum Number of Rows = 8-10` to maximize vertical space usage
- Reduce `Extra offset between details = 150-200 mm` for tighter spacing
- Expect 1-2 columns for typical 4-8 edge panels

**For Landscape Sheets (A1, A0 horizontal):**
- Set `Maximum Number of Rows = 4-6` to create more columns
- Increase `Extra offset between details = 250-350 mm` for clarity
- Better for panels with many edges (8-12+)

**For A3/A4 Sheets:**
- Set `Maximum Number of Rows = 3-4`
- Reduce `Dimensions offset = 30-40 mm` to save space
- May require multiple script instances for panels with many edges

### Color Standards

**Recommended Color Schemes:**

**Dark Background Drawings:**
- Detail Color: 7 (White) or 8 (Gray) for geometry
- Text Color: 7 (White) for text

**Light Background Drawings:**
- Detail Color: 1 (Red) or 0 (ByBlock) for geometry
- Text Color: 0 (ByBlock) or 1 (Red) for text

**CTB Plot Styles:**
- Detail Color: Match layer color conventions
- Text Color: 0 (ByBlock) to inherit layer properties

### Dimension Style Configuration

**Essential Dimstyle Settings:**

1. **Text Height**: Set appropriate for sheet scale
   - A0/A1: 3.5-5.0 mm
   - A3/A4: 2.5-3.5 mm

2. **Arrow Size**: 1/4 to 1/3 of text height

3. **Precision**: 2 decimal places for mm, 1/16" or 1/8" for imperial

4. **Units**: Match drawing template (mm or inches)

5. **Text Placement**: Horizontal, above dimension line

### Edge Numbering and Documentation

**Cross-Reference Best Practices:**

1. **Create Edge Index**: Document which edge number (E1, E2...) corresponds to which panel face (North, South, etc.)

2. **Consistent Numbering**: SIP edge order follows geometric traversal - document the start point

3. **Assembly Drawings**: Reference edge numbers on main assembly views with leader arrows

4. **CNC Programs**: Use edge numbers in CNC program documentation for correlation

### Multi-Panel Workflows

**When selecting multiple panels in Model Space:**

1. **Sequential Numbering**: Edges numbered continuously across panels (Panel1: E1-E4, Panel2: E5-E8, etc.)

2. **Grouping Strategy**: Run script separately for each panel type to maintain clear documentation

3. **Panel Identification**: Add text annotations to identify which edges belong to which panel

4. **Sheet Organization**: Consider one script instance per sheet to avoid overcrowding

### Quality Control

**Pre-Insertion Checks:**

- [ ] SIP panels have correct component layers defined in SipStyle
- [ ] Panel geometry is finalized (no pending design changes)
- [ ] Dimension style is configured and tested
- [ ] Sufficient empty space available for edge detail grid
- [ ] Drawing units match template (mm or inches)

**Post-Insertion Verification:**

- [ ] Edge count matches expected number
- [ ] Bevel angles are correct (90° for standard edges)
- [ ] All component layers visible in cross-sections
- [ ] Dimensions are readable and correctly placed
- [ ] No overlapping details or dimensions
- [ ] Text is properly centered and aligned
- [ ] Recess depths match design specifications

### Troubleshooting Common Issues

**Issue: "No viewData found" error in shop drawing mode**

**Cause**: Selected ShopDrawView lacks associated ViewData in script Map

**Solution:**
1. Regenerate shop drawing using parent multipage controller
2. Ensure ViewData is properly stored during shop drawing generation
3. Check that `_kOnGenerateShopDrawing + "\\" + _kViewDataSets` Map path exists
4. Try selecting different view entity

**Issue: Dimensions appear too small or too large**

**Cause**: Dimension style text height incompatible with sheet scale

**Solution:**
1. Select different Dimstyle with appropriate text height
2. Modify current Dimstyle: Set text height = 3.5-5.0mm for typical scales
3. Check drawing units (mm vs. inches) match Dimstyle units

**Issue: Edge details overlap each other**

**Cause**: Insufficient vertical spacing between details

**Solution:**
1. Increase `Extra offset between details` (try 300-500 mm)
2. Reduce `Maximum Number of Rows` to create more columns
3. Move insertion point to provide more space
4. Consider running script multiple times for different edge groups

**Issue: Some edges missing from output**

**Cause**: Edge slicing algorithm failed for certain edge geometries

**Solution:**
1. Check SIP panel geometry for degenerate edges (zero length)
2. Verify SipStyle component layers have valid bodies
3. Simplify panel geometry if overly complex
4. Check for envelope body creation failures
5. Review debug mode output if available

**Issue: Bevel angles showing unexpected values**

**Cause**: Edge normal vector calculation affected by panel orientation

**Solution:**
1. Verify panel coordinate system is correctly aligned
2. Check edge.vecNormal() returns expected direction
3. For chamfered edges, verify angle complements to 90° are correct
4. Script normalizes to 0-90° range - verify interpretation matches machining requirements

**Issue: Component layers not visible in edge profiles**

**Cause**: Layer slicing or intersection logic failure

**Solution:**
1. Verify SipStyle defines all component layer bodies
2. Check component body validity: `bdComponents[i].bIsValid()`
3. Increase shrink tolerance if layers too thin: `pp.shrink(dEps * 0.01)`
4. Review component layer material thicknesses

**Issue: Vertical dimensions not appearing**

**Cause**: Insufficient significant points or dimension suppression logic

**Solution:**
1. Check `ptDimsVertical.length() > 1` condition
2. Verify edge profile has height variations
3. Review first point removal logic: `ptDimsVertical.removeAt(0)`
4. Check if all points project to same location

**Issue: Grid layout starting in wrong location**

**Cause**: Insertion point or column offset calculation error

**Solution:**
1. Verify insertion point was picked correctly
2. Check `_Pt0` value in debug mode
3. Review column offset calculation: `dNewDetailHorizOffset * nColumns`
4. Ensure world coordinate system (_XW, _YW) is correctly oriented

### Performance Considerations

**Large Panel Count:**
- Expect processing time: ~2-5 seconds per edge
- Panel with 8 edges: ~15-40 seconds total
- Multiple panels: Linear scaling

**Complex Layer Structures:**
- More component layers = longer processing time
- Minimize unnecessary layers in SipStyle for production efficiency

**Debug Mode:**
- When `bDebug = true`, extensive visualization slows execution
- Disable debug mode for production use

### Integration with Other Scripts

**Upstream Dependencies:**
- **SIP Panel Modeling**: Panels must be created with standard SIP modeling tools
- **Shop Drawing Generation**: Multipage mode requires ShopDrawView entities from parent scripts
- **SipStyle Configuration**: Component layers must be defined in project SipStyle library

**Downstream Usage:**
- **CNC Programming**: Bevel angles and recess depths feed into machining programs
- **Assembly Instructions**: Edge details cross-referenced in installation documents
- **Quality Control**: Edge profiles used for dimensional verification

**Related Scripts:**
- `sdUK_ShowSIPList`: Generates SIP panel schedules and material lists
- `sdUK_SIPDimensions`: Adds overall panel dimensions to shop drawings
- `sdUK_ShowEdgeDirections`: Displays edge orientation arrows (directional indicators)
- `SIP-MPM` (Multipage Manager): Parent script for shop drawing coordination

## Internationalization

The script uses TSL translation keys for all user-facing strings:

```c
String sModel = T("|Model|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sEdgeDetail = "E" + (e + 1);  // Edge numbering not translated
String sBevelAngleText = "Bevel Angle: " + sBevelAngle;  // Hardcoded English
String sRecessDepthText = "Recess Depth: " + sRecessDepth;  // Hardcoded English
```

**Translation Coverage:**
- Parameter labels: Fully translatable via `T("|key|")` system
- Command prompts: Fully translatable
- Output text (Bevel Angle, Recess Depth): Hardcoded in English

**Note for Non-English Users**: Edge detail text (bevel angle, recess depth labels) will always display in English in current version. Parameter names and prompts will display in configured language.

## Advanced Customization

### Modifying Edge Numbering

To change edge numbering format from "E1, E2..." to custom format:

Locate line ~504:
```c
String sEdgeDetail = "E" + (e + 1);
```

Examples:
- Panel-specific: `"P" + nPanelID + "-E" + (e + 1)` → "P1-E1, P1-E2..."
- Directional: Use edge.vecNormal() to determine "N", "S", "E", "W"
- Zero-padded: `"E" + formatInt(e + 1, 2)` → "E01, E02..."

### Adjusting Slice Position

To slice at different edge positions (not just midpoint):

Locate line ~250:
```c
Point3d ptMid = edge.ptMid();
```

Replace with:
- Quarter point: `Point3d ptMid = ptStart + 0.25 * (ptEnd - ptStart);`
- Start point: `Point3d ptMid = edge.ptStart();`
- End point: `Point3d ptMid = edge.ptEnd();`

### Filtering Edges

To display only specific edges (e.g., vertical edges only):

Add filter after line ~231:
```c
SipEdge sipEdges[] = sipCurr.sipEdges();

// Filter example: Only process edges with bevel angles
SipEdge filteredEdges[0];
for (int e = 0; e < sipEdges.length(); e++) {
    double dAngle = abs(-vz.angleTo(sipEdges[e].vecNormal()));
    if (abs(90 - dAngle) > 0.5) { // Skip perpendicular edges
        filteredEdges.append(sipEdges[e]);
    }
}
sipEdges = filteredEdges;
```

### Custom Dimension Formats

To change dimension text format (e.g., fractional inches):

Modify line ~448:
```c
Dim dimHorizontal(dlHorizontal, ptDimsHorizontal, "<>", "<>", _kDimDelta, _kDimNone);
```

Replace `"<>"` with custom format:
- Fractional: `"<>\""`  (adds inch marks)
- Custom prefix: `"T:<>"`  (adds "T:" before dimension)
- Tolerance: `"<>%%p"` (adds plus/minus tolerance)

## FAQ

**Q: Can I use this script on standard timber beams or wall panels?**

A: No. This script is specifically designed for SIP (Structural Insulated Panel) entities. It relies on `SipEdge`, `SipStyle`, and SIP component layer structures that don't exist in GenBeam or Element entities. For timber beam details, use `sd_BeamAssembly` or similar shop drawing scripts.

**Q: Why are my bevel angles always showing 90.00?**

A: A bevel angle of 90.00° indicates a perpendicular edge (standard square edge with no chamfer or bevel). This is correct for most SIP panels. Only chamfered or angled edges will show different values (e.g., 45.00° for 45-degree chamfer).

**Q: How do I change the units from millimeters to inches?**

A: Units are controlled by:
1. Drawing template units (set via `UNITS` command in AutoCAD)
2. The script's `U(1, "mm")` declaration (line 61) - this is just for internal calculations
3. Dimension style unit settings

Change your drawing units and dimension style to Imperial, and the script will automatically display in inches.

**Q: Can I display edge details for multiple panels in one script instance?**

A: Yes, in Model Space mode. Select multiple SIP panels during the selection prompt, and all edges from all panels will be processed sequentially. However, edge numbering will be continuous across panels (E1-E8 for Panel 1, E9-E16 for Panel 2, etc.). Consider using separate script instances per panel for clearer documentation.

**Q: The script is very slow - how can I speed it up?**

A: Processing time is primarily driven by:
- Number of edges: Linear scaling (~2-5 sec per edge)
- Component layer count: More layers = more slicing operations
- Debug mode: Disable debug visualizations for production

To optimize:
1. Simplify SipStyle to minimum necessary layers
2. Ensure `bDebug = false` (line 65)
3. Use `envelopeBody()` instead of `realBody()` where possible (already optimized in this script)

**Q: Why do some edges show vertical dimensions and others don't?**

A: Vertical dimensions are only created when `ptDimsVertical.length() > 1` (line 470). This means:
- Edge profile must have at least 2 significant height points after removing the base reference
- Flat edges with no height variation won't get vertical dimensions
- Very thin layers might project to same point, suppressing dimensions

**Q: How do I change which side the vertical dimensions appear on?**

A: Vertical dimension placement is automatic, based on edge normal direction:
```c
if (vecN.dotProduct(-vz) < 0) {
    // Left side placement
} else {
    // Right side placement
}
```

To force one side, modify the condition (lines 455-462, 474-483). However, this may cause dimensions to overlap edge geometry for certain edge orientations.

**Q: Can I export edge details to DXF for use in other CAD systems?**

A: Yes, but with considerations:
1. The script creates native AutoCAD entities (dimensions, polylines, text)
2. Export the entire drawing or selection set to DXF
3. PlaneProfile entities export as polylines
4. Dimensions export as DIMENSION entities (may need exploding in target system)
5. Text exports as TEXT entities

Alternative: Use AutoCAD's WBLOCK command to isolate edge details to separate DWG file, then export.

**Q: The edge details appear in the wrong location in my shop drawing**

A: For Shop Drawing Multipage mode:
1. Verify you selected the correct ShopDrawView entity
2. Check that ViewData exists for that viewport (`_Map` must contain valid data)
3. Ensure coordinate system transformation is correct (ms2ps mapping)
4. Try regenerating the shop drawing with the parent multipage controller

If using Model Space mode, verify the insertion point `_Pt0` is in the correct location.

**Q: How do I update edge details if the SIP panel geometry changes?**

A: The script instance is **not dynamically linked** to the source SIP panel. Changes to panel geometry require:
1. Delete existing edge detail script instance
2. Re-run the script
3. Select updated SIP panel
4. Details will regenerate with new geometry

Consider implementing dynamic update by monitoring SIP entity handles and recalculating on geometry change events (requires custom modification).

**Q: Can I change the grid layout to horizontal stacking (left-to-right) instead of vertical?**

A: Yes, requires code modification. Swap the primary and secondary direction logic:

Current (vertical primary):
```c
Point3d ptNewOrigin = _Pt0 - U(100) * _YW - dNewDetailVertOffset * _YW + dNewDetailHorizOffset * nColumns * _XW;
```

Change to (horizontal primary):
```c
Point3d ptNewOrigin = _Pt0 + U(100) * _XW + dNewDetailHorizOffset * nColumns * _XW - dNewDetailVertOffset * _YW;
```

Also swap row/column increment logic around line 495-501.

**Q: What's the difference between "Detail Color" and "Text Color"?**

A:
- **Detail Color**: Applied to edge profile geometry (polylines) and dimension lines/arrows/text
- **Text Color**: Applied ONLY to the three text labels (edge ID, bevel angle, recess depth)

This separation allows, for example:
- Detail Color = 1 (Red) for dimensions
- Text Color = 7 (White) for labels
Creating visual distinction between geometric information and metadata.

**Q: The recess depth shows 0.00 but my panel has a recess**

A: Verify:
1. SipEdge entity has `dRecessDepth()` property correctly set
2. Recess was modeled using SIP edge editing tools, not manual geometry modification
3. SIP panel was regenerated after recess addition
4. Check actual property value: `sipEdges[e].dRecessDepth()` in debug mode

If recess exists geometrically but property is zero, the SIP entity may need recreation from scratch.

## See Also

### Related SIP Scripts

- **sdUK_SIPDimensions**: Add overall panel outline dimensions to shop drawings
- **sdUK_ShowSIPList**: Generate material and component schedules for SIP panels
- **sdUK_ShowSIPEdgeDirections**: Display edge direction arrows for assembly orientation
- **SIP-MPM** (Multipage Manager): Coordinate multi-sheet shop drawing generation

### Related Shop Drawing Scripts

- **sd_MetalPartBOM**: Bill of materials for metal hardware
- **sd_BeamAssembly**: Beam assembly drawings with component details
- **sd_TslDimRequest**: Custom dimension request tool for shop drawings

### Related SIP Modeling Tools

- **hsb_SIP-CoverStrips**: Add cover strips to SIP panel edges
- **hsb_SIP-Insert**: Insert openings and penetrations in SIP panels
- **SipEdgeEditor**: Manual SIP edge geometry and property editing

### Documentation Resources

- **hsbCAD SIP Module Manual**: Complete SIP modeling workflow guide
- **Shop Drawing Best Practices**: Standards for fabrication documentation
- **TSL Scripting Reference** (`CLAUDE.md`): TSL language syntax and API reference

---

**Document Version:** 2.0
**Last Updated:** 2026-02-21
**Script Version Documented:** 1.5 (2021-08-05)
**Compatibility:** hsbCAD 19.1.104+
