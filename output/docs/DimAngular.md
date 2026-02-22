# DimAngular

## Overview

**DimAngular** is a specialized dimensioning tool that automatically creates angular dimensions for measuring angles between timber elements, sheets, and geometric entities in hsbCAD. It intelligently detects vertex angles and edge segments from building geometry and displays them as parametric CAD dimensions.

**Script Type:** O-Type (Object) - Standalone dimension entity
**Version:** 2.7 (15.11.2023)
**Primary Use:** Automated angle measurement for shop drawings, layout plans, and fabrication documentation

## Key Features

- **Intelligent Angle Detection**: Automatically identifies all vertex angles and arc segments from element geometry
- **Multiple Reference Modes**: Works with GenBeams, Elements, MultiPages, Sections, and Shop Drawing viewports
- **Dual Snap Modes**: Vertex mode (dimensions at corner points) or Segment mode (dimensions along edges)
- **Complementary Angles**: Toggle between adjacent angles and full 360° complementary angles
- **Arc Length Dimensions**: Supports dimensioning of circular arc segments
- **Viewport Support**: Fully functional in Model Space, Paper Space viewports, and MultiPage layouts
- **Interactive Placement**: Visual jig system for selecting which angles to dimension
- **Painter Filtering**: Filter which entities get dimensioned based on painter definitions

## Compatible Environments

| Environment | Support Level | Notes |
|-------------|---------------|-------|
| **Model Space** | Full | Primary 3D modeling environment |
| **Paper Space** | Full | Supports viewport-local and setup instances |
| **MultiPage** | Full | Automatically attaches to MultiPage views |
| **Section Views** | Full | Dimensions sections with clip volume support |
| **Shop Drawing Viewports** | Full | Block space generation for fabrication drawings |

## Supported Entity Types

The script can dimension angles from the following entities:

| Entity Type | Description | Application |
|-------------|-------------|-------------|
| **GenBeam** | Individual timber members | Beam-to-beam connections, frame corners |
| **Element** | Complete wall/floor/roof assemblies | Element outlines, wall corners |
| **EntPLine** | Polyline entities | Custom geometry, layout lines |
| **MetalPartCollectionEnt** | Hardware collections | Connector plate angles |
| **MultiPage** | Drawing sheets | Shop drawing generation |
| **Section2d** | Section views | Cross-section dimensions |
| **ShopDrawView** | Shop drawing viewports | Fabrication drawing automation |
| **ChildPanel** | Panel assemblies | CLT/SIP panel corners |

## Installation and Usage Workflow

### Step 1: Launch the Script

**Command:** `TSLINSERT`

1. Type `TSLINSERT` in the AutoCAD command line
2. Browse and select `DimAngular.mcr`
3. Press Enter to begin

**Alternative Command Shortcut:**
```
^C^C(defun c:DIMANG() (hsb_ScriptInsert "DimAngular")) DIMANG
```

### Step 2: Select Reference Entity

The script will prompt: **"Select reference (genbeams, elements, multipages, sections or shopdraw viewports)"**

**Selection Options:**
- Click on a GenBeam to dimension all angles in that beam's profile
- Click on an Element to dimension all corners of the wall/floor/roof
- Click on a MultiPage to attach dimensions to a specific shop drawing view
- Click on a Section to dimension the section outline

### Step 3: Interactive Angle Selection (Model Space)

After selecting the reference entity, a **visual jig** displays all detected angles:

**Visual Feedback:**
- **Light blue wedges**: Available angles to dimension
- **Yellow highlight**: Currently selected angle (follows cursor)
- **White outline**: Confirms the selected angle

**User Prompts:**
```
Pick location or [All/SelectSide/Inner/Outer/SMallest/Largest]
```

**Options:**
- **Pick location**: Click near the desired angle to create a single dimension
- **All**: Automatically creates dimensions for all detected angles
- **SelectSide**: Interactive mode - choose inner or outer angle by cursor position
- **Inner**: Forces inner (acute) angles only
- **Outer**: Forces outer (obtuse) angles only
- **Smallest**: Automatically selects the smallest angle at each vertex
- **Largest**: Automatically selects the largest angle at each vertex

**Interactive Controls:**
- Move cursor near any angle to preview it
- Click to create dimension at that location
- Press ESC to cancel insertion
- Continue picking to create multiple dimensions in one session

### Step 4: Paper Space Viewport Placement

When inserting in **Paper Space**, the workflow differs:

**Viewport Selection:**
1. The script prompts: **"Select a viewport"**
2. Click on the desired viewport boundary

**Setup Location Selection:**
The script displays two zones:
- **Inside viewport (yellow highlight)**: Creates a local instance attached to that specific viewport
- **Outside viewport but inside layout (blue highlight)**: Creates a setup instance for element-level dimensioning

**Prompt:**
```
Pick point outside paperspace for element setup
A point inside the viewport specifies a local instance
```

**Decision Guide:**
- Click **inside viewport**: Dimension appears only in that viewport (tied to specific view)
- Click **outside layout boundary**: Dimension becomes a reusable setup for all viewports showing the same element

### Step 5: MultiPage Workflow

When selecting a **MultiPage** entity:

**Viewport Selection (if multiple views exist):**
1. Script displays all viewport boundaries in the MultiPage
2. **Yellow highlight**: Currently selected viewport (follows cursor)
3. Click to choose which view should display the dimension

**Isometric View Exclusion:**
- The script automatically skips isometric/3D views
- Only orthogonal views (plan, elevation, section) are available for dimensioning

**Automatic Regeneration:**
- Dimensions automatically update when the MultiPage regenerates
- Maintains relative position to the MultiPage origin

## Properties Panel Parameters

Access these parameters via the **AutoCAD Properties Palette** (OPM) after insertion.

### Behaviour Category

| Parameter | Type | Options | Default | Description |
|-----------|------|---------|---------|-------------|
| **Angle Mode** | Selection | Adjacent Angles / Full Complementary Angle | Adjacent Angles | **Adjacent Angles**: Measures the actual angle between two segments (0°-180°). **Full Complementary Angle**: Measures the full 360° complement (useful for reflex angles) |
| **Snap Mode** | Selection | Vertex / Segment | Vertex | **Vertex**: Dimension snaps to corner points/vertices. **Segment**: Dimension snaps to edge segments (measures angle between edge and reference axis) |
| **Suppress 90°** | Yes/No | Yes / No | Yes | When enabled, right angles (90° ± tolerance) are automatically hidden. Useful for cleaning up rectangular frame dimensions |
| **Filter** | Selection | Default / [Painter Names] | Default | Filters which entities are dimensioned based on painter definitions. If a painter collection named "Dimension" exists, only those painters are shown |

**Angle Mode Details:**

- **Adjacent Angles Mode**:
  - Measures the angle between two intersecting segments
  - Range: 0° to 180°
  - Automatically detects multiple adjacent angles at each vertex
  - Example: At a 4-way intersection, creates 4 separate dimensions

- **Full Complementary Angle Mode**:
  - Measures the full rotation angle
  - Range: 0° to 360°
  - Useful for reflex angles or when you need the "long way around"
  - Example: A 45° angle becomes 315° in complementary mode

**Snap Mode Details:**

- **Vertex Mode** (Default):
  - Dimensions snap to geometric vertices (corner points)
  - Best for: Building corners, beam-to-beam connections
  - The dimension center point (`_Pt0`) locks to the vertex location

- **Segment Mode**:
  - Dimensions snap to edge segments
  - Measures angle between the edge tangent and a reference axis (typically element X or Y)
  - Best for: Wall alignments, panel edge angles
  - The dimension center point (`_Pt0`) can slide along the edge

**Filter Application:**

The Filter parameter uses hsbCAD's **Painter Definition** system to selectively dimension entities:

1. **Default**: No filtering - all entities are dimensioned
2. **Custom Painter**: Only entities matching the selected painter are dimensioned

**Example Use Case:**
```
Painter Collection: "Dimension"
  ├─ Dimension\Studs
  ├─ Dimension\Plates
  └─ Dimension\Blocking
```
Setting Filter = "Studs" will only dimension angles involving studs, ignoring plates and blocking.

### Display Category

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Text** | String | (empty) | Any format string | Customizes dimension text content. Use `<>` or leave empty for default angle value. Supports format variables for advanced customization |
| **Dimstyle** | Selection | (first available) | All dimstyles in drawing | The CAD dimension style controlling fonts, arrowheads, and precision. Must be defined in the current drawing template |
| **Text Height** | Length | 0 | 0+ | Height of dimension text in drawing units. **0 = byDimstyle** (uses the dimension style's text height setting) |
| **Global Scale Factor** | Number | 1.0 | >0 | Uniformly scales the entire dimension (text, arrows, extension lines). Essential for adjusting dimensions in viewports with different scales |
| **Color** | Integer | -1 | -1 to 255 | Dimension color override. **-1 = byDimstyle**. Note: Dimstyle must use "byBlock" color for this to work |
| **Leader Linetype** | Selection | Disabled | Disabled / [LineTypes] | Linetype for optional leader lines. Usually left disabled unless custom leader is needed |

**Text Formatting:**

The **Text** parameter supports advanced formatting with format variables:

**Basic Syntax:**
- `<>` or empty: Display angle value with dimstyle precision (e.g., "45.5°")
- `@(Angle:RL0)`: Show angle without decimals (e.g., "45°")
- `@(Angle:RL2)`: Show angle with 2 decimals (e.g., "45.50°")
- `Custom @(Angle:RL1)°`: Mix custom text with angle value (e.g., "Custom 45.5°")

**Format Variable Reference:**
| Format Code | Output | Example |
|-------------|--------|---------|
| `@(Angle:RL0)` | Rounded to integer | 45° |
| `@(Angle:RL1)` | 1 decimal place | 45.5° |
| `@(Angle:RL2)` | 2 decimal places | 45.50° |

**Arc Length Dimensions:**
- Arc length dimensions are only created if the Text parameter contains format arguments
- Required for version 2.7+
- Special symbol: The arc length symbol `Ո` is automatically added when dimensioning arcs

**Dimstyle Requirements:**

The script uses standard AutoCAD Dimension Styles. Ensure your drawing contains properly configured dimstyles:

**Essential Dimstyle Settings:**
- **Text Height**: Default text size (used when "Text Height" property = 0)
- **Arrow Size**: Proportional to text height
- **Extension Line Offset**: Gap from geometry to extension line start
- **Color Settings**: Must be set to "byBlock" for color override to work

**Global Scale Factor Application:**

Use this parameter to adjust dimension appearance in viewports:

**Example Scenarios:**
| Viewport Scale | Drawing Scale | Recommended Factor | Result |
|----------------|---------------|-------------------|--------|
| 1:50 | 1:1 | 0.02 | Dimensions appear correctly sized at 1:50 |
| 1:100 | 1:1 | 0.01 | Dimensions appear correctly sized at 1:100 |
| 1:1 (ModelSpace) | 1:1 | 1.0 | Standard size |

**Formula:** `Global Scale Factor = 1 / Viewport Scale`

## Right-Click Context Menu

Right-click on an inserted dimension to access these commands:

| Menu Item | Shortcut | Description |
|-----------|----------|-------------|
| **Set Text Location** / **Text Location byDimstyle** | - | **Toggle** between custom text placement and default dimension style placement. When set to "Set Text Location", you can drag the text to any position. When set to "byDimstyle", text follows the dimension style's automatic placement rules |
| **Adjacent Angles** / **Full Complementary Angle** | Double-click | **Toggle** the dimension mode. Switches between measuring the specific angle between segments (Adjacent) and the full 360° complement (Complementary). Double-clicking the dimension is a quick shortcut for this toggle |
| **Add Similar** | - | Prompts you to pick a new location. Inserts a new dimension instance with identical settings (same dimstyle, text height, filter, etc.) at the selected point. Useful for quickly adding multiple similar dimensions |
| **Regenerate Shopdrawing** | - | (MultiPage mode only) Forces regeneration of the current shop drawing page. Use this if underlying geometry has changed and dimensions haven't updated automatically |
| **Pick Viewport Setup Location** | - | (Viewport setup mode only) Allows interactive repositioning of the viewport setup location. Opens a jig to pick a new position outside the paperspace boundary |

**Context Menu Behavior:**

**Set Text Location Toggle:**
- **Default State**: "Text Location byDimstyle" (automatic positioning)
- **After Toggle**: "Set Text Location" (manual drag enabled)
- **Usage**: Enable manual mode to position text away from crowded areas

**Angle Mode Toggle:**
- **Fastest Method**: Double-click the dimension
- **Alternative**: Right-click → Select toggle option
- **Visual Feedback**: Dimension immediately recalculates to show complementary angle

**Add Similar Workflow:**
1. Right-click dimension → "Add Similar"
2. Command line prompts: "Select new location"
3. Click near any other angle in the same view
4. New dimension appears with identical properties
5. Repeat or press ESC to finish

## Grip Points

The dimension provides interactive grip points for dynamic adjustment:

| Grip Point | Location | Function | Behavior |
|------------|----------|----------|----------|
| **_Pt0** | Dimension center/vertex | Reposition entire dimension | **Vertex Mode**: Locks to nearest vertex. **Segment Mode**: Slides along edge segment. Drag to snap to different angles |
| **_PtG[0]** | Dimension arc location | Adjust arc radius | Drag radially to increase/decrease the dimension arc radius. Drag tangentially to rotate the arc position while maintaining radius |

**Grip Editing Workflow:**

**Repositioning Dimension (_Pt0 Grip):**
1. Hover over dimension until grips appear
2. Click the **center grip** (small blue square at dimension vertex)
3. Drag to a new vertex or segment location
4. Release to snap to the nearest detected angle

**Adjusting Arc Radius (_PtG Grip):**
1. Click the **arc grip** (blue square on the dimension arc)
2. Drag **outward** to increase radius (moves dimension arc away from vertex)
3. Drag **inward** to decrease radius (brings dimension arc closer to vertex)
4. The dimension text follows the arc automatically

**Grip Snapping Behavior:**
- **Vertex Mode**: _Pt0 snaps to exact vertex points (5-10mm tolerance)
- **Segment Mode**: _Pt0 snaps to nearest point on edge segments
- **Arc Radius**: No snapping - free drag for precise positioning

## Advanced Features

### Viewport Setup Mode (Paper Space)

When working in Paper Space, DimAngular supports two distinct operation modes:

**Local Viewport Instance:**
- Created by clicking **inside** the viewport boundary
- Dimension is attached to that specific viewport
- Only visible in that viewport's view
- Uses viewport's scale factor automatically
- Best for: Viewport-specific annotations

**Setup Instance:**
- Created by clicking **outside** the layout boundary (left margin)
- Acts as a "template" for element-level dimensioning
- Displays a preview graphic showing filter settings
- Automatically generates local instances in viewports as needed
- Best for: Standardized dimension sets across multiple viewports

**Setup Instance Preview:**

The setup instance displays:
```
DimAngular
Filter: [Painter Name or Zone] (entity count)
```

This preview box appears in the left margin and updates as you change filter settings.

**Setup Location Adjustment:**
- Right-click setup instance → "Pick Viewport Setup Location"
- Interactive jig shows valid placement zones
- Repositions the setup preview without affecting generated dimensions

### Segment Mode Detailed Operation

In **Segment Mode**, the dimension behavior changes significantly:

**Angle Calculation:**
1. Script identifies the edge segment closest to `_Pt0`
2. Calculates tangent vector at that point
3. Measures angle between tangent and reference axis (typically Element X or Y axis)

**Reference Axis Selection:**
- If entity is part of an Element: Uses Element's X-axis
- If no Element parent: Uses global X-axis (_XW)
- If tangent is parallel to X-axis: Switches to Y-axis reference

**Arc Segment Detection:**
Segment mode can also dimension **circular arc segments**:
- Reconstructs arc geometry from polyline segments
- Calculates arc center, radius, and tangent vectors
- Displays arc length dimension if format argument is provided

**Arc Length Format Requirement (Version 2.7+):**
To display arc length dimensions, the **Text** property must include format content:
- Empty text = No arc length dimensions
- Any format string (e.g., `@(Angle:RL1)`) = Arc length enabled

### MultiPage Integration

DimAngular is fully integrated with hsbCAD's MultiPage system for automated shop drawing generation:

**Attachment Workflow:**
1. Script attaches to MultiPage via `setDependencyOnEntity()`
2. Stores view direction in Map: `ModelView = vecZM`
3. Maintains relative position via: `vecOrg = _Pt0 - PageOrigin`
4. Automatically updates when MultiPage regenerates

**View Direction Matching:**
- Script queries all MultiPage views
- Matches stored `ModelView` vector with current view direction
- Only displays in views with matching (codirectional) view vectors
- Skips isometric views (non-orthogonal projections)

**Coordinate System Handling:**
- **Model-to-Paper Transform**: `ms2ps = MultiPageView.modelToView()`
- **Paper-to-Model Transform**: `ps2ms = ms2ps.invert()`
- All geometry is transformed before angle detection
- Z-coordinate locked to MultiPage origin Z

**MultiPage Regeneration:**
Right-click dimension → "Regenerate Shopdrawing" triggers:
1. `page.regenerate()` call
2. Re-reads all entities from MultiPage show set
3. Recalculates all angles and positions
4. Redraws dimension with updated geometry

### Section View Support

DimAngular works with Section2d entities and clip volumes:

**Section Workflow:**
1. Select Section2d entity during insertion
2. Script retrieves clip volume: `clipVolume = section.clipVolume()`
3. Collects entities within clip volume: `clipVolume.entitiesInClipVolume(true)`
4. Applies model-to-section transform: `ms2ps = section.modelToSection()`
5. Dimensions are created in section view coordinate system

**Clip Volume Validation:**
- Script verifies clip volume validity
- If invalid: Dimension instance is erased with error message
- If valid: Dependencies are set on both Section and ClipVolume

**Section Coordinate System:**
- Origin: Section coordinate system origin
- X/Y/Z: World axes (_XW, _YW, _ZW)
- View direction: Calculated from paper-to-model transform

### Shop Drawing Viewport (Block Space)

DimAngular supports automated generation in shop drawing viewports:

**Block Space Detection:**
The script automatically detects block space when:
1. No GenBeams or MultiPages exist in the drawing
2. ShopDrawView entities are present
3. User is working in model space (not layout tab)

**Shop Drawing Generation Workflow:**

**Phase 1: Setup (Block Space)**
1. User selects ShopDrawView
2. Script stores UID and settings in Map
3. Creates preview graphic showing dimension zone
4. No actual dimension geometry is drawn yet

**Phase 2: Generation (_bOnGenerateShopDrawing)**
1. Shop drawing regeneration triggers
2. Script checks if dimension was already created (via UID flag)
3. If not created: Generates model space instance with:
   - View direction: `vecAllowedView` (from ViewData)
   - Transformation: `ms2ps` from ViewData coordinate system
   - All current property settings
4. Flags instance as created to prevent duplicates on next regeneration

**Preview Graphics:**
- Displays house-shaped contour in viewport
- Shows script name and filter settings
- Updates in real-time as you adjust parameters

**ViewData Integration:**
- Script reads: `ViewData().convertFromSubMap(_Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets)`
- Finds matching viewport: `ViewData().findDataForViewport(viewDatas, sdv)`
- Retrieves defining entities: `viewData.showSetDefineEntities()`

### Painter Definition Filtering

The **Filter** parameter leverages hsbCAD's Painter system for selective dimensioning:

**Painter Collection Structure:**

hsbCAD searches for a painter collection named **"Dimension"**:
```
PainterDefinition Hierarchy:
└─ Dimension\
   ├─ Dimension\Studs
   ├─ Dimension\Plates
   ├─ Dimension\Blocking
   ├─ Dimension\Headers
   └─ Dimension\Sill
```

**Filter Dropdown Population:**
- If "Dimension\" collection exists: Shows only sub-painters ("Studs", "Plates", etc.)
- If no "Dimension\" collection: Shows all painters in drawing (full path)

**Filtering Logic:**

**Element Filtering:**
If the selected entity is a single Element and a painter is selected:
1. Script extracts all GenBeams from the Element
2. Applies painter filter: `PainterDefinition.filterAcceptedEntities(genbeams)`
3. Only dimensiones angles from beams matching the painter

**GenBeam Filtering:**
For individual GenBeam selections:
1. Directly applies painter filter to the selected set
2. Removes non-matching entities before angle detection

**Collection Entity Handling:**
MetalPartCollectionEnt entities are always included in the filter result, even if the painter rejects them.

**Viewport Zone Filtering:**
In HSB viewports (tied to Elements), the Filter also works with zone indices:
- `nActiveZoneIndex = viewport.activeZoneIndex()`
- If activeZone = 999: Include all zones
- Otherwise: Only include GenBeams where `beam.myZoneIndex() == activeZoneIndex`

### Angle Suppression

The **Suppress 90°** parameter automatically hides right angles to reduce clutter:

**Suppression Criteria:**
An angle is suppressed if any of the following conditions are true:
1. Vectors are perpendicular: `vecX1.isPerpendicularTo(vecX2)`
2. Vectors are parallel: `vecX1.isParallelTo(vecX2)` (180°)
3. Angle = 90° ± tolerance: `abs(dAngle - 90) < dEps`
4. Angle = 180° ± tolerance: `abs(dAngle - 180) < dEps`
5. Angle = 270° ± tolerance: `abs(dAngle - 270) < dEps`

**Tolerance:**
`dEps = U(0.1)` (0.1mm in metric, ~0.004" in imperial)

**Use Cases:**
- **Enabled (Default)**: Rectangular frames only show non-right angles
- **Disabled**: All angles are displayed, including 90° corners

**Version 2.3 Enhancement:**
Accepts tolerances when ignoring 90° or multiples (HSB-17977)

### Arc Reconstruction (Version 2.4+)

DimAngular can detect and dimension **circular arc segments** in polyline geometry:

**Reconstruction Process:**
1. `pl.reconstructArcs(dEps, 70)` - Attempts to convert line segments back to arcs
   - Tolerance: `dEps = U(0.1)`
   - Angle threshold: 70° (minimum arc angle)
2. Detects arc segments by midpoint deviation:
   ```
   ptMid = (ptStart + ptEnd) / 2
   bIsArc = (pl.closestPointTo(ptMid) - ptMid).length() > dEps
   ```
3. Calculates arc center from circular segment geometry:
   ```
   radius = (4 * h² + s²) / (8 * h)
   where: h = height of segment, s = chord length
   ```

**Arc Dimension Output:**
- Displays arc symbol: `Ո` (if enabled)
- Measures angle subtended by arc
- Extension lines tangent to arc endpoints
- Text positioned along arc radius

**Format Requirement:**
Arc length dimensions only appear if the **Text** parameter contains a format string.

### Dimension Request System (Hsb_DimensionInfo)

DimAngular supports **dimension requests** from other TSL scripts:

**Request Structure:**
Other scripts can request angular dimensions by adding to their SubMapX:
```
Key: "Hsb_DimensionInfo"
SubMap: "DimRequest[]"
  ├─ Map[0]:
  │  ├─ Point3d "ptCenter"    (dimension vertex)
  │  ├─ Point3d "ptXLine1"    (first direction point)
  │  ├─ Point3d "ptXLine2"    (second direction point)
  │  ├─ Vector3d "AllowedView" (view direction constraint)
  │  └─ PlaneProfile "shape"  (dimension shape/bounds)
  ├─ Map[1]: ...
```

**Request Processing:**
1. Script scans all entities for `subMapXKeys().findNoCase("Hsb_DimensionInfo")`
2. Reads request maps from attached tools
3. Validates required fields (ptCenter, ptXLine1, ptXLine2)
4. Checks view direction: `AllowedView.isParallelTo(vecZ)`
5. Adds valid requests to dimension detection set

**View Direction Constraint:**
Dimensions are only created in views where:
```
AllowedView.isParallelTo(currentViewDirection)
```
This prevents dimensions from appearing in irrelevant views.

**Use Cases:**
- Hardware tools requesting connection angle dimensions
- Automated dimension placement from element analysis
- Batch dimension generation from BOM data

## Geometry Detection Algorithm

### Vertex Angle Detection

**Algorithm Steps:**
1. Extract all rings from PlaneProfile: `rings = ppShape.allRings()`
2. Reconstruct arcs: `pl.reconstructArcs(dEps, 70)`
3. Simplify polyline: `pl.simplify()`
4. Get vertex points: `pts = pl.vertexPoints(true)`
5. Loop through each vertex with surrounding points:
   ```
   pt1 = pts[p]      (previous vertex)
   ptCen = pts[a]    (current vertex - dimension center)
   pt2 = pts[b]      (next vertex)
   ```
6. Calculate direction vectors:
   ```
   vecX1 = (pt1 - ptCen).normalize()
   vecX2 = (pt2 - ptCen).normalize()
   ```
7. Determine inner/outer side:
   ```
   vecN = -(vecX1 + vecX2).normalize()
   if (ppShape.pointInProfile(ptCen + vecN * dEps) == _kPointInProfile)
       vecN *= -1
   ```
8. Apply suppression filter (90° check)
9. Store valid angles: `ptsCen[], ptsX1[], ptsX2[], vecsN[]`

**Wedge Generation for Visual Jig:**
For each detected angle, the script creates visual wedges:
1. Create small circle: `circle.createCircle(ptCen, vecZ, radius)`
2. Intersect with direction planes to get arc endpoints
3. Build inner wedge (toward shape interior)
4. Build outer wedge (away from shape interior)
5. Used for interactive jig highlighting during insertion

### Arc Segment Detection

**Arc Identification:**
1. Check midpoint deviation:
   ```
   ptMid = (pt1 + pt2) / 2
   bIsArc = (pl.closestPointTo(ptMid) - ptMid).length() > dEps
   ```
2. Skip if first segment is arc (to avoid double-counting)

**Geometric Calculation:**
From circular segment geometry:
```
Given: ptStart, ptEnd, ptMidArc (actual midpoint on arc)
Find: center, radius

1. Calculate chord midpoint:
   ptMidChord = (ptStart + ptEnd) / 2

2. Calculate segment height (sagitta):
   h = |ptMidArc - ptMidChord|

3. Calculate chord length:
   s = |ptEnd - ptStart|

4. Calculate radius (from circular segment formula):
   radius = (4h² + s²) / (8h)

5. Calculate center direction:
   vecCenter = (ptMidChord - ptMidArc).normalize()

6. Determine inside/outside:
   if (pointInProfile(ptMidArc + vecY * dEps) == _kPointInProfile)
       vecY *= -1

7. Calculate center position:
   ptCenter = ptMidArc + vecCenter * radius
```

**Arc Storage:**
- Stored separately in `plArcSegs[]` array
- Flagged with `bIsArcs[i] = true`
- Special handling in dimension drawing (arc length symbol)

### Segment Mode Closest Point

**Algorithm:**
1. Get all rings and filter by painter
2. Combine into single polyline: `plThis = combined rings`
3. Find closest point on polyline:
   ```
   ptClosest = plThis.closestPointTo(_Pt0)
   ```
4. Check if on arc segment:
   - Calculate midpoint of adjacent vertices
   - If `plThis.isOn(midpoint)` = true: Linear segment
   - If `plThis.isOn(midpoint)` = false: Arc segment
5. For arc segments:
   - Find matching entry in `plArcSegs[]`
   - Extract arc center and endpoints
   - Calculate tangent vectors
6. For linear segments:
   - Calculate tangent: `vecX1 = plThis.getTangentAtPoint(ptClosest)`
   - Calculate reference axis: `vecX2 = element.vecX()` (or _XW if no element)
   - Ensure vecX2 points outside shape

**Perpendicular Reference:**
If `vecX1.isParallelTo(vecX2)`:
- Switch to perpendicular axis: `vecX2 = element.vecY()`
- Ensures non-zero angle

### Adjacent Angle Collection (Version 2.0+)

In **Adjacent Angles** mode, the script generates multiple angle options at each vertex:

**Collected Variations:**
1. **Primary angle**: Inner angle (acute or obtuse)
2. **Opposite angle**: 360° - primary angle
3. **Neighboring angles**: Angles to adjacent coordinate axes

**Generation Logic:**
```
For each vertex with vecX1 and vecX2:

1. Outer/Inner determination:
   bOuterIsMin = vecArcOut.dotProduct(vecX1 + vecX2) > 0

2. If outer is smaller:
   a) Add outer angle: _Pt0 + vecX1, _Pt0 + vecX2, _Pt0 + vecArcOut
   b) Add opposite: _Pt0 - vecX1, _Pt0 - vecX2, _Pt0 - vecArcOut

3. If inner is smaller:
   a) Add inner angle: _Pt0 + vecX1, _Pt0 + vecX2, _Pt0 - vecArcOut
   b) Add outer: _Pt0 - vecX1, _Pt0 - vecX2, _Pt0 + vecArcOut

4. Add neighboring angles (if vecX1 or vecX2 parallel to coordinate axes):
   - Angle to +X axis
   - Angle to -X axis
   - Angle to +Y axis
   - Angle to -Y axis

5. Add perpendicular angles:
   a) _Pt0 + vecX1, _Pt0 - vecX2, _Pt0 + (vecX1 - vecX2)
   b) _Pt0 - vecX1, _Pt0 + vecX2, _Pt0 - (vecX1 - vecX2)
```

**Arc Snapping:**
All variations are stored as polyline arcs in `plSnapArcs[]` and sorted by length (shortest first). During grip editing, the script finds the closest arc to the grip position and snaps to that angle.

## Dimension Text Location

### Automatic Placement (Default)

When **"Text Location byDimstyle"** is active:
- Text follows the dimension style's automatic rules
- Typically positioned at arc midpoint
- Adjusts based on available space

### Manual Placement

After selecting **"Set Text Location"** from right-click menu:

**Activation:**
1. Right-click dimension
2. Select "Set Text Location"
3. Property flag: `_Map.setInt(kAddTextLocation, true)`

**Jig Workflow:**
1. Script prompts: "Pick text location"
2. Visual preview shows dimension with text at cursor position
3. Yellow highlighted preview follows cursor
4. Click to confirm location
5. Text offset stored in Map: `vecTextLocation = ptPicked - ptCenter`

**Persistent Storage:**
- Text offset stored in instance Map
- Survives dimension regeneration
- Recalculated when dimension arc radius changes

**Reverting to Automatic:**
1. Right-click dimension
2. Select "Text Location byDimstyle"
3. Stored offset is cleared
4. Text returns to dimstyle automatic placement

## Error Handling and Validation

### Invalid Selection Handling

**Version 2.6+ Change (HSB-19785):**
Default warning "invalid selection" is **disabled** to reduce noise during automated batch operations.

**Validation Checks:**
1. **Empty shape**: `ppShape.area() < pow(dEps, 2)`
   - Action: Erase instance and return
   - No error message (silent fail)

2. **No entities found**:
   - If painter filter returns empty set
   - Prompt: "No entities found in selection set"
   - If user just changed painter: Offer to keep instance without filter

3. **Invalid clip volume** (Section mode):
   - Action: Erase instance with no message

4. **Multiple insertion attempts**:
   - `insertCycleCount() > 1` → Erase instance
   - Prevents infinite loops

### Viewport Validation (Version 2.2 - HSB-16830)

**Insert Location Validation:**
When inserting in Paper Space, the script validates the insertion point:

**Valid Zones:**
1. **Inside viewport**: Creates local instance
2. **Outside paperspace boundary**: Creates setup instance
3. **Invalid**: Anywhere else

**Validation Logic:**
```
if (ppViewport.pointInProfile(pt) == _kPointOutsideProfile &&
    ppLayout.pointInProfile(pt) == _kPointInProfile)
{
    // Valid setup location
    // Find nearest layout edge
    pts = ppLayout.intersectPoints(Plane(pt, vecY))
    pts = Line(pt, vecX).orderPoints(pts)
    // Position at edge + offset
    pt = nearestEdge + vecDir * 20 * textHeight * scale
}
```

**Automatic Repositioning:**
If insertion point is in an invalid zone, the script automatically moves it to the nearest valid edge.

### Isometric View Exclusion (Version 2.5 - HSB-18965)

**Bugfix**: Insert on MultiPages containing isometric views

**Detection:**
```
For each MultiPageView:
    ps2ms = view.modelToView().invert()

    if (!ps2ms.vecX().isParallelTo(_ZW) &&
        !ps2ms.vecY().isParallelTo(_ZW) &&
        !ps2ms.vecZ().isParallelTo(_ZW))
    {
        // This is an isometric view - skip it
        views.removeAt(i)
    }
```

**Orthogonal Check:**
A view is considered orthogonal (valid) if **at least one** of its coordinate axes is parallel to the world Z-axis.

## Performance Considerations

### Body Extraction Optimization

**Envelope vs Real Body:**
```
For GenBeams in MetalPartCollectionEnt:
    if (beam.vecX/Y/Z is coplanar with view):
        body = beam.envelopeBody(true, true)  // Fast approximation
    else:
        // Skip - not coplanar to view
```

**Envelope Benefits:**
- Faster calculation than `realBody()`
- Sufficient accuracy for 2D projections
- Recommended for complex assemblies

### Shape Simplification

**Simplification Steps:**
1. `pl.reconstructArcs(dEps, 70)` - Merges colinear segments into arcs
2. `pl.simplify()` - Removes redundant vertices
3. `ppShape.shrink(dEps)` - Cleans up micro-geometry
4. `ppShape.simplify()` - Simplifies profile complexity

**Impact:**
- Reduces vertex count by 20-50% in typical geometry
- Speeds up angle detection loop
- Improves interactive jig responsiveness

### Dependency Management

**Entity Dependencies:**
The script sets dependencies on:
1. Reference entities: `setDependencyOnEntity(ent)`
2. MultiPage: `setDependencyOnEntity(page)`
3. Section + ClipVolume: Both
4. ShopDrawView: `setDependencyOnEntity(sdv)`

**Regeneration Triggers:**
Dimension automatically recalculates when:
- Referenced entity is modified
- MultiPage regenerates
- Section view updates
- Element is recalculated

**Group Assignment:**
- Dimension assigned to group 'D' (Dimension group)
- Follows entity group if single element parent
- Assigned to element group for element-based dimensions

## Coordinate System Transformations

### Model Space to Paper Space

**Transform Chain:**
```
1. Model Space (3D):
   - Element coordinates
   - GenBeam coordSys
   - Original geometry

2. View Transform (ms2ps):
   - Viewport: ms2ps = viewport.coordSys()
   - MultiPage: ms2ps = multiPageView.modelToView()
   - Section: ms2ps = section.modelToSection()

3. Paper Space (2D):
   - Flattened to viewport plane
   - All geometry transformed
   - Dimensions drawn in this space
```

**Inverse Transform (ps2ms):**
Used to calculate view direction in model space:
```
vecZM = _ZW
vecZM.transformBy(ps2ms)
vecZM.normalize()
```

### Z-Coordinate Locking

**MultiPage Z-Lock:**
```
Point3d ptOrg = page.coordSys().ptOrg()
_Pt0.setZ(ptOrg.Z())
for (all _PtG grips):
    _PtG[g].setZ(ptOrg.Z())
```

**Purpose:**
- Prevents dimension from drifting in Z
- Maintains precise alignment with MultiPage
- Ensures dimension regenerates at correct elevation

### Relative Position Storage

**MultiPage Offset:**
```
vecOrg = _Pt0 - pageOrigin
_Map.setVector3d("vecOrg", vecOrg)
```

**Restoration:**
```
if (_Map.hasVector3d("vecOrg") && !_bOnDbCreated)
    _Pt0 = pageOrigin + _Map.getVector3d("vecOrg")
```

**Benefits:**
- Dimension maintains relative position to MultiPage
- Survives MultiPage moves/rotations
- Automatically adjusts when MultiPage is repositioned

## Settings Files

**No External XML Settings Required**

DimAngular does **not** require external XML configuration files. All settings are:

1. **Stored in Instance Map**: Property values, offsets, view directions
2. **Retrieved from Drawing**: DimStyles, LineTypes, Painters
3. **User-Adjustable**: Via Properties Palette (OPM)

**Required Drawing Resources:**
- **DimStyles**: At least one dimension style must exist in the drawing
- **LineTypes**: Standard linetypes for optional leader lines
- **Painters** (optional): For entity filtering

## Typical Workflows

### Workflow 1: Single Beam Corner Dimension

**Scenario:** Dimension a single corner angle on a timber beam

1. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`

2. **Select Beam:**
   - Prompt: "Select reference..."
   - Click on the beam

3. **Visual Jig:**
   - All corner angles highlight as light blue wedges
   - Move cursor near desired angle (turns yellow)
   - Click to confirm

4. **Adjust:**
   - Open Properties Palette (Ctrl+1)
   - Set "Suppress 90°" = Yes (if beam is rectangular)
   - Verify only non-right angles remain

5. **Finalize:**
   - Drag _PtG grip to adjust arc radius
   - Right-click → "Set Text Location" if needed
   - Done

**Result:** Clean angular dimension at selected corner

---

### Workflow 2: Complete Wall Element Dimensioning

**Scenario:** Dimension all corners of a wall assembly for shop drawings

1. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`

2. **Select Element:**
   - Prompt: "Select reference..."
   - Click on the wall Element entity

3. **Batch Creation:**
   - Prompt: "Pick location or [All/...]"
   - Type: **All** and press Enter

4. **Automatic Generation:**
   - Script creates dimensions at every detected corner
   - Suppresses 90° angles (default)
   - All dimensions use current property settings

5. **Post-Process:**
   - Select all created dimensions (window selection)
   - Properties Palette → Set Global Scale Factor = 0.02 (for 1:50 scale)
   - Verify text height is readable

**Result:** Complete angle dimensioning in one operation

---

### Workflow 3: MultiPage Shop Drawing

**Scenario:** Add angular dimensions to a MultiPage layout for fabrication

1. **Prepare MultiPage:**
   - Ensure MultiPage contains orthogonal views (plan, elevations)
   - Verify show set includes the elements to dimension

2. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`

3. **Select MultiPage:**
   - Prompt: "Select reference..."
   - Click on the MultiPage entity

4. **Select View:**
   - If multiple viewports exist, jig displays all views
   - Click inside desired viewport (e.g., front elevation)

5. **Interactive Placement:**
   - Visual jig shows all angles in that view
   - Click on specific angles or type "All"

6. **Verify Attachment:**
   - Check Properties Palette: Entity should show dependencies on MultiPage
   - Dimension Z should match MultiPage Z

7. **Test Regeneration:**
   - Modify underlying geometry
   - Right-click dimension → "Regenerate Shopdrawing"
   - Verify dimension updates correctly

**Result:** Parametric dimensions that update with MultiPage regeneration

---

### Workflow 4: Paper Space Viewport Setup

**Scenario:** Create reusable dimension template for multiple viewports

1. **Open Paper Space Layout:**
   - Switch to layout tab containing viewports

2. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`

3. **Select Viewport:**
   - Prompt: "Select a viewport"
   - Click on viewport boundary

4. **Setup Location:**
   - Jig shows viewport (yellow) and layout boundary (blue)
   - Click **outside layout** (left margin) for setup mode
   - Script positions setup box automatically

5. **Configure Filter:**
   - Properties Palette → Filter = "Studs" (example)
   - Setup box updates to show: "Filter: Studs (24)"

6. **Test in Viewports:**
   - Setup automatically generates local instances
   - Each viewport showing the element gets dimensions
   - All use the same filter and settings

7. **Adjust Setup:**
   - Right-click setup box → "Pick Viewport Setup Location"
   - Reposition to better margin location if needed

**Result:** Centralized dimension control for multiple viewports

---

### Workflow 5: Segment Mode Edge Angle

**Scenario:** Dimension angle between wall edge and reference axis

1. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`

2. **Select Element:**
   - Click on wall Element

3. **Switch to Segment Mode:**
   - Properties Palette → Snap Mode = **Segment**

4. **Position on Edge:**
   - Drag _Pt0 grip to slide along wall edge
   - Position where you want the dimension

5. **Verify Reference:**
   - Dimension shows angle between edge tangent and element X-axis
   - Check if orientation makes sense

6. **Adjust if Needed:**
   - If angle references wrong axis, rotation element coordinate system
   - Or document which axis is being referenced

**Result:** Edge-to-axis angular dimension

---

### Workflow 6: Arc Length Dimension

**Scenario:** Dimension a curved edge with arc length notation

1. **Verify Geometry:**
   - Entity must have actual arc segments (not approximated polylines)

2. **Insert Script:**
   - Command: `TSLINSERT` → Select `DimAngular.mcr`
   - Select entity with arc

3. **Enable Arc Length:**
   - Properties Palette → Text = `@(Angle:RL1)` (any format string enables it)
   - Leave empty to skip arc length dimensions

4. **Interactive Selection:**
   - Visual jig highlights arc segments
   - Arc segments glow with gradient effect
   - Click on desired arc

5. **Verify Output:**
   - Dimension shows arc symbol: `Ո`
   - Arc length value (if format includes it)
   - Angle subtended by arc

**Result:** Professional arc length dimension

## Tips and Best Practices

### Dimensioning Strategy

**Tip 1: Use "All" for Initial Placement**
- Start with "All" option to auto-generate all dimensions
- Then delete unwanted dimensions
- Faster than individually clicking each angle

**Tip 2: Set Suppress 90° = Yes for Rectangular Frames**
- Eliminates clutter from right angles
- Only shows critical non-square corners
- Can always toggle off if you need all angles

**Tip 3: Painter Filtering for Complex Assemblies**
- Create a "Dimension\Critical" painter
- Apply to only key structural members
- Filter dramatically reduces dimension count

**Tip 4: Global Scale Factor Formula**
```
Scale Factor = 1 / Viewport Scale

Examples:
1:50 scale → 0.02
1:100 scale → 0.01
1:25 scale → 0.04
```

### Text Customization

**Tip 5: Format Precision**
- Rough carpentry: `@(Angle:RL0)` (integer degrees)
- Finish work: `@(Angle:RL1)` (one decimal)
- Precision joinery: `@(Angle:RL2)` (two decimals)

**Tip 6: Custom Labels**
```
Example formats:
"Angle: @(Angle:RL1)°"        → "Angle: 45.5°"
"@(Angle:RL0)° TYP"           → "45° TYP"
"@(Angle:RL1)° (VERIFY)"      → "45.5° (VERIFY)"
```

### Grip Editing

**Tip 7: Quick Vertex Snapping**
- In Vertex Mode, drag _Pt0 grip near different vertices
- Snaps to nearest vertex automatically (5-10mm tolerance)
- Fastest way to move dimension to different corner

**Tip 8: Arc Radius Adjustment**
- Drag _PtG grip radially (toward/away from vertex)
- Larger radius = dimension further from geometry (clearer in crowded areas)
- Smaller radius = dimension closer to vertex (compact layouts)

**Tip 9: Arc Ring Avoidance**
- Avoid placing _PtG grip inside the "arc ring" zone
- Arc ring = ±0.5 * textHeight around the dimension arc
- Dimension may reset grip if placed in this zone

### MultiPage Workflows

**Tip 10: View Direction Storage**
- Dimension stores view direction on creation
- Only displays in views matching that direction
- To show in multiple views: Create separate dimensions for each view

**Tip 11: Regeneration Trigger**
- If dimensions don't update after geometry change:
  - Right-click dimension → "Regenerate Shopdrawing"
  - Or modify any dimension property to force recalc

**Tip 12: Relative Positioning**
- Dimensions maintain offset relative to MultiPage origin
- Moving MultiPage moves all attached dimensions
- No need to manually reposition after MultiPage moves

### Viewport Setup Best Practices

**Tip 13: Setup Instance Location**
- Place setup boxes in consistent location (e.g., left margin)
- Easier to find and manage
- Clearly separated from viewport content

**Tip 14: Painter-Based Setup**
- Use different setup instances for different painters
- Example: One for "Studs", one for "Plates", one for "Headers"
- Each generates its own filtered dimension set

**Tip 15: Zone Filtering (HSB Viewports)**
- Set viewport activeZone to isolate floors/zones
- Setup instance respects zone filtering
- Dimensions only appear for elements in active zone

### Performance Optimization

**Tip 16: Simplify Geometry First**
- Run `pl.simplify()` on complex profiles before dimensioning
- Reduces vertex count and speeds up angle detection
- Particularly important for imported DWG geometry

**Tip 17: Use Envelope Bodies for Collections**
- For MetalPartCollectionEnt, envelope is 10x faster than real body
- Accuracy loss is negligible for 2D projections
- Recommended for assemblies with >50 components

**Tip 18: Batch Operations**
- When creating many dimensions, use "All" mode once
- Faster than multiple individual insertions
- Reduces regeneration overhead

### Troubleshooting

**Tip 19: Missing Dimensions**
- Check Filter setting - may be excluding entities
- Verify Suppress 90° if expecting right angles
- Ensure entity is in the show set (MultiPage) or clip volume (Section)

**Tip 20: Wrong View Display**
- Check stored ModelView vector in Map
- Regenerate MultiPage to refresh view matching
- For sections, verify clip volume is valid

**Tip 21: Dimension Not Updating**
- Verify dependency is set: Check entity properties
- Manually trigger: Right-click → "Regenerate Shopdrawing"
- Check if dimension is in block space (different update rules)

## Common Issues and Solutions

### Issue 1: Dimension Text Too Small/Large in Viewport

**Symptom:** Text appears incorrect size when viewport scale changes

**Solution:**
```
1. Select dimension
2. Properties Palette:
   - Global Scale Factor = 1 / Viewport Scale

Example:
Viewport Scale = 1:50
Global Scale Factor = 0.02 (calculated as 1/50)
```

**Prevention:**
- Set Global Scale Factor immediately after viewport creation
- Create catalog entries for common scales
- Use dimension setup instances to standardize

---

### Issue 2: Dimensions Disappear After MultiPage Regeneration

**Symptom:** Dimensions vanish when MultiPage regenerates

**Cause:** View direction mismatch or dependency not set

**Solution:**
```
1. Check dimension still exists (may be out of view)
2. Verify dependency:
   - Select dimension → Properties
   - Check "Dependencies" section
   - Should list MultiPage entity
3. If missing:
   - Delete dimension
   - Re-insert and reselect MultiPage
4. Right-click → "Regenerate Shopdrawing"
```

**Prevention:**
- Always select MultiPage directly (not GenBeams within it)
- Verify dependency immediately after insertion

---

### Issue 3: Right Angles Not Suppressed

**Symptom:** 90° angles still appear even with "Suppress 90° = Yes"

**Cause:** Angle is not exactly 90° (within tolerance)

**Solution:**
```
1. Check actual angle value (select dimension → Properties)
2. If angle is 89.9° or 90.1°:
   - Geometry has precision issue
   - Adjust tolerance in script (advanced)
   OR
3. Manually delete unwanted dimensions
4. Or hide via layer control
```

**Version Note:**
Version 2.3+ accepts tolerances when suppressing (HSB-17977), so minor deviations should work.

---

### Issue 4: Arc Length Dimensions Not Appearing

**Symptom:** Arc segments don't show arc length notation

**Cause:** Text property is empty (Version 2.7+ requirement)

**Solution:**
```
1. Select dimension
2. Properties Palette → Text field
3. Enter any format string, e.g.:
   - @(Angle:RL1)
   - <> (default)
   - Any custom text
4. Dimension recalculates with arc symbol
```

**Background:**
HSB-20640: Arc length dimensions only created if format argument is given

---

### Issue 5: Painter Filter Returns No Entities

**Symptom:** Message "does not return any entity and the dimension will be purged"

**Cause:** Selected painter doesn't match any entities in the selection

**Solution:**
```
Prompt appears: "Do you want to keep the instance with no filter instead? [No/Yes]"

Option 1: Type "Yes"
- Keeps dimension without filter
- Dimensions all entities

Option 2: Type "No"
- Deletes dimension
- Choose different painter or entity
```

**Prevention:**
- Verify painter is applied to target entities before dimensioning
- Use "Default" filter for unfiltered dimensioning
- Check painter collection name ("Dimension\" vs full path)

---

### Issue 6: Dimension Doesn't Update After Entity Modification

**Symptom:** Edit GenBeam, but dimension doesn't recalculate

**Cause:** Dependency may be broken or dimension cached

**Solution:**
```
1. Force regeneration:
   - Right-click dimension → "Regenerate Shopdrawing" (if MultiPage)
   - Or modify any dimension property (forces recalc)

2. If still doesn't update:
   - Check dependency: Properties → Dependencies
   - If missing: Delete and re-create dimension

3. For Setup Instances:
   - Regenerate from setup box
   - Local instances should update automatically
```

---

### Issue 7: Grip Won't Snap to Vertex

**Symptom:** Dragging _Pt0 grip doesn't snap to vertices

**Cause:** Snap Mode is set to "Segment" instead of "Vertex"

**Solution:**
```
1. Properties Palette → Snap Mode = Vertex
2. Try dragging again
3. Should snap to nearest vertex within tolerance
```

**Note:**
In Segment mode, grip slides along edges rather than snapping to vertices.

---

### Issue 8: Complementary Angle Shows Wrong Value

**Symptom:** Double-click doesn't toggle correctly or shows unexpected angle

**Cause:** Multiple angle options exist; script may be selecting different one

**Solution:**
```
1. Right-click → Toggle mode manually
2. Check if angle makes sense geometrically
3. If still wrong:
   - Delete dimension
   - Re-insert with different placement location
   - Script will detect different angle option
```

**Understanding:**
At each vertex, multiple angle variations are calculated (adjacent, opposite, perpendicular). The script selects based on grip position.

---

### Issue 9: Setup Instance Not Generating in Viewports

**Symptom:** Setup box exists, but no dimensions appear in viewports

**Cause:** Filter or zone settings exclude entities in viewport

**Solution:**
```
1. Check setup box text:
   "Filter: [Name] (entity count)"

2. If entity count = 0:
   - Filter is excluding everything
   - Change filter or adjust painter definitions

3. For HSB viewports:
   - Check viewport activeZone setting
   - Setup respects zone filtering
   - Set zone = 999 (All Zones) for testing
```

---

### Issue 10: Isometric View Shows Dimensions (Unwanted)

**Symptom:** Dimensions appear in 3D isometric views where they're not needed

**Cause:** View direction matching may be too broad

**Solution:**
```
Fixed in Version 2.5 (HSB-18965)
- Isometric views are automatically excluded
- Only orthogonal views show dimensions

If problem persists:
1. Verify version is 2.5+
2. Regenerate MultiPage
3. Delete and recreate dimension if needed
```

## FAQ

### General Questions

**Q: What's the difference between Vertex Mode and Segment Mode?**

**A:**
- **Vertex Mode**: Dimensions snap to corner points. Measures the angle between two edges meeting at that vertex. Best for: Building corners, beam connections, frame joints.
- **Segment Mode**: Dimensions snap to edge segments. Measures the angle between the edge tangent and a reference axis (Element X or Y). Best for: Wall orientations, edge alignments, slope angles.

---

**Q: Can I dimension angles less than 1° or greater than 180°?**

**A:**
- **Less than 1°**: Yes, but visibility depends on arc radius and text size. Very small angles may have overlapping extension lines.
- **Greater than 180°**: Use **Full Complementary Angle** mode. This toggles to show the reflex angle (the "long way around"). Double-click the dimension to switch modes quickly.

---

**Q: How do I measure the larger angle instead of the smaller acute angle?**

**A:**
Right-click the dimension and select **"Full Complementary Angle"**, or simply **double-click** the dimension. This toggles between:
- **Adjacent Angles**: Shows the direct angle between segments (typically 0°-180°)
- **Full Complementary Angle**: Shows the 360° complement

---

**Q: Can I use this script in a 2D layout view?**

**A:**
Yes, fully supported. The script works in:
- **Paper Space viewports**: Select viewport during insertion
- **MultiPage layouts**: Select MultiPage entity
- **Model Space**: Standard 3D environment

For Paper Space, you can create either **local instances** (inside viewport) or **setup instances** (outside layout boundary).

---

**Q: Why does my dimension text look different from my standard dimensions?**

**A:**
Check the **Dimstyle** property in the Properties Palette. It must match a valid Dimension Style defined in your AutoCAD template. Common causes:
- Dimstyle name mismatch (case-sensitive)
- Dimstyle not defined in current drawing
- Text height override in dimension (set Text Height = 0 for byDimstyle)

---

**Q: How do I hide 90-degree angles?**

**A:**
Properties Palette → **Suppress 90° = Yes**. This hides all right angles (and multiples: 180°, 270°) automatically. Version 2.3+ accepts small tolerances (±0.1mm), so angles like 89.9° or 90.1° are also suppressed.

---

**Q: How do I filter which beams get dimensioned?**

**A:**
Use the **Filter** property:
1. Create a painter collection named **"Dimension"** in hsbCAD
2. Add sub-painters (e.g., "Dimension\Studs", "Dimension\Plates")
3. Apply painters to the beams you want to dimension
4. Properties Palette → Filter = Select the sub-painter name

Only entities matching the painter will be dimensioned.

---

**Q: Can I dimension angles in section views?**

**A:**
Yes. Select a **Section2d** entity during insertion. The script automatically:
- Retrieves the clip volume
- Collects entities within the clip volume
- Applies model-to-section transformation
- Creates dimensions in the section view coordinate system

Ensure the section's clip volume is valid, or the dimension will erase itself.

---

**Q: What does "Arc Length Symbol" mean?**

**A:**
The arc length symbol `Ո` appears when dimensioning **circular arc segments**. To enable arc length dimensions:
- Properties Palette → **Text** = Enter any format string (e.g., `@(Angle:RL1)`)
- Empty text = No arc length dimensions (Version 2.7+ requirement)

The script automatically detects arc segments using midpoint deviation tests and reconstructs the arc geometry.

---

**Q: How do I create dimensions for all angles at once?**

**A:**
During the insertion jig, when prompted:
```
Pick location or [All/SelectSide/Inner/Outer/SMallest/Largest]
```
Type **"All"** and press Enter. The script creates dimensions at every detected angle automatically. Use this for batch operations, then delete unwanted dimensions manually.

---

**Q: Can I dimension hardware connector angles?**

**A:**
Yes. Select a **MetalPartCollectionEnt** during insertion. The script extracts all beams and sheets from the collection and dimensions their angles. If the collection contains entities not coplanar with the view direction, they are automatically skipped.

---

**Q: Why don't my dimensions update when I move the MultiPage?**

**A:**
This is expected behavior. Dimensions maintain their **relative position** to the MultiPage origin, so they move with the MultiPage automatically. If you need to manually reposition:
1. Right-click dimension
2. Drag the _Pt0 grip
3. Or adjust via Properties Palette

The relative offset is stored in the Map as `vecOrg`.

---

**Q: What's the purpose of the "Add Similar" command?**

**A:**
**"Add Similar"** clones all current dimension settings and lets you quickly create a new dimension at a different location. Workflow:
1. Set up first dimension (dimstyle, text height, filter, etc.)
2. Right-click → "Add Similar"
3. Click on a different angle
4. New dimension inherits all settings from the first one

This is much faster than repeatedly inserting and configuring dimensions.

---

**Q: Can I dimension angles in multiple zones at once?**

**A:**
In HSB viewports (Element-based), the **activeZoneIndex** controls which zones are dimensioned:
- **activeZoneIndex = 999**: Dimensions all zones
- **activeZoneIndex = specific number**: Dimensions only that zone
- Filter property can further refine by painter

Set zone via viewport properties, then insert dimension.

---

**Q: How do I dimension the angle between a wall and a reference axis?**

**A:**
Use **Segment Mode**:
1. Properties Palette → Snap Mode = **Segment**
2. Select the wall Element
3. Dimension measures angle between wall edge tangent and Element X-axis
4. If tangent is parallel to X-axis, automatically switches to Y-axis

This is useful for wall orientations and property line setbacks.

---

**Q: What happens if I delete the entity the dimension references?**

**A:**
The dimension becomes invalid and will be erased on next regeneration (if dependencies are enforced). To prevent orphaned dimensions:
- Always delete dimensions before deleting referenced entities
- Or use the dependency system to auto-clean (dimension deletes when entity deletes)

---

**Q: Can I dimension angles in block space (shop drawings)?**

**A:**
Yes, fully supported. Workflow:
1. Work in block space with ShopDrawView entities
2. Insert DimAngular, select ShopDrawView
3. Configure settings (creates setup instance)
4. When shop drawing regenerates via `_bOnGenerateShopDrawing`, dimensions are automatically generated in model space
5. Dimensions track with shop drawing regeneration

This is automated dimension generation for fabrication drawings.

---

### Advanced Questions

**Q: How does the script detect arc segments vs straight segments?**

**A:**
**Midpoint Deviation Test:**
```
1. Calculate chord midpoint: ptMid = (pt1 + pt2) / 2
2. Find closest point on polyline: ptClosest = pl.closestPointTo(ptMid)
3. If distance(ptMid, ptClosest) > tolerance:
   → Arc segment
   Else:
   → Straight segment
```
If detected as arc, the script calculates radius using the circular segment formula.

---

**Q: What is the "Adjacent Angles" mode collecting?**

**A:**
**Adjacent Angles Mode** (Version 2.0+) collects multiple angle variations at each vertex:
1. **Primary angle**: Inner angle (toward shape interior)
2. **Opposite angle**: Outer angle (away from shape interior)
3. **Neighboring angles**: Angles to adjacent coordinate axes (if vecX1 or vecX2 is parallel to element axes)
4. **Perpendicular angles**: Additional orthogonal combinations

During grip editing, the script snaps to the closest matching angle arc. This allows you to select different angle options by simply moving the grip.

---

**Q: How does the dimension request system work?**

**A:**
Other TSL scripts can **request** angular dimensions by adding to their SubMapX:
```
Key: "Hsb_DimensionInfo"
SubMap: "DimRequest[]"
  Map[i]:
    - Point3d "ptCenter"
    - Point3d "ptXLine1"
    - Point3d "ptXLine2"
    - Vector3d "AllowedView"
    - PlaneProfile "shape"
```
DimAngular scans all attached tools for these requests and creates dimensions matching the view direction constraint.

**Use Case:** Hardware tools automatically request connection angle dimensions.

---

**Q: What's the performance impact of dimensioning large assemblies?**

**A:**
**Typical Performance:**
- 10-20 beams: Instant (<0.1s)
- 50-100 beams: Fast (<0.5s)
- 200+ beams: Moderate (1-3s)

**Optimization Tips:**
- Use painter filtering to reduce entity count
- Use envelope bodies instead of real bodies for collections
- Simplify polyline geometry before dimensioning
- In viewports, set specific zone index instead of "All Zones"

---

**Q: Can I programmatically control dimension creation via LISP/scripts?**

**A:**
Yes. **Command Format:**
```
(hsb_ScriptInsert "DimAngular")
```

**Catalog-Based Insertion:**
```
(defun c:DIMANG50()
  (hsb_ScriptInsertWithCatalog "DimAngular" "Scale_1:50")
)
```
This loads predefined settings from a catalog entry (requires catalog creation first).

---

**Q: How are viewport scale factors calculated?**

**A:**
```
Viewport Scale = Paper Units / Model Units

Example:
1:50 scale means 1mm on paper = 50mm in model
Viewport Scale = 1/50 = 0.02

Global Scale Factor should be set to 0.02 to compensate
```
The script retrieves this via `viewport.dScale()` and automatically applies it to:
- Text height: `textHeight * dScale`
- Dimension scale: `dDimScale * dScale`
- Grip offsets: `offset * dScale`

---

**Q: What coordinate systems are used internally?**

**A:**
**World Coordinate System (WCS):**
- `_XW`, `_YW`, `_ZW`: World axes
- Used for Paper Space and layout calculations

**User Coordinate System (UCS):**
- `_XU`, `_YU`, `_ZU`: Current UCS axes
- Used for Model Space and entity creation

**Local Coordinate Systems:**
- `cs = ppShape.coordSys()`: Shape's local system
- `cs = element.coordSys()`: Element's local system
- Used for angle calculations and transformations

**Transform Matrices:**
- `ms2ps`: Model Space to Paper Space
- `ps2ms`: Inverse (Paper to Model)

---

**Q: How does Z-locking work in MultiPage mode?**

**A:**
```
On every recalculation:
1. Get MultiPage origin Z:
   ptOrg = page.coordSys().ptOrg()

2. Lock dimension Z:
   _Pt0.setZ(ptOrg.Z())

3. Lock all grips Z:
   for (all _PtG):
       _PtG[g].setZ(ptOrg.Z())
```
This prevents dimension drift in the Z-axis and ensures alignment with the MultiPage plane.

---

**Q: Can I use this with imported DWG geometry?**

**A:**
Yes, but with limitations:
- Imported polylines work if they're valid AutoCAD polylines
- Convert imported lines/arcs to hsbCAD entities first
- Use `pl.simplify()` to clean up imported geometry
- Arc reconstruction may fail on heavily approximated curves

**Best Practice:**
Convert imported geometry to hsbCAD GenBeams or Elements for best results.

---

## Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| **2.7** | 15.11.2023 | **HSB-20640**: Arc length dimensions only created if format argument is provided |
| **2.6** | 08.08.2023 | **HSB-19785**: Default warning "invalid selection" disabled for cleaner batch operations |
| **2.5** | 12.05.2023 | **HSB-18965**: Bugfix - Insert on MultiPages containing isometric views now works correctly |
| **2.4** | 03.03.2023 | **HSB-18196**: Arc reconstruction added for improved curve detection |
| **2.3** | 15.02.2023 | **HSB-17977**: Accepting tolerances when ignoring 90° or multiples (89.9° now suppresses) |
| **2.2** | 31.01.2023 | **HSB-16830**: Insert location on paperspace viewports validated - prevents invalid placements |
| **2.1** | 12.01.2023 | **HSB-17107**: Supports angular dim requests based on submapX hsb_DimensionInfo |
| **2.0** | 11.11.2022 | **HSB-16932**: Additional adjacent angle added, offset viewport placement fixed |
| **1.8** | 28.10.2022 | **HSB-16291**: Section support added, viewport filters added |
| **1.7** | 21.10.2022 | **HSB-16291**: MultiPage and auto-generation through blockspace definition supported |
| **1.5** | 15.10.2022 | **HSB-16507**: Filtering by painter and element support added |
| **1.0** | 19.08.2022 | **HSB-16246**: Initial version |

## Related Scripts

| Script | Relationship | Use Case |
|--------|--------------|----------|
| **Dimline** | Linear dimensioning | Combine with DimAngular for complete dimensioning |
| **DimRadial** | Radial/diameter dimensions | Use for circular elements |
| **hsbViewDimension** | Viewport dimensioning | Alternative viewport approach |
| **MultipageController** | Shop drawing manager | Parent script for MultiPage workflows |
| **Section2d** | Section view creation | Create sections before dimensioning |

## Technical Notes

**Script Classification:**
- **Category:** Base/Core
- **Type:** O-Type (Object script)
- **Dependencies:** None (standalone)
- **DxaOut:** Enabled (exports to DXA format)
- **ImplInsert:** Enabled (supports insertion via other scripts)

**Memory Footprint:**
- Small (typical instance: ~5-10 KB)
- Map data: Variable based on number of stored angles
- Minimal performance impact even with 100+ instances

**Compatibility:**
- hsbCAD Version: 26+ (for dimension request support)
- AutoCAD Version: 2018+ recommended
- BricsCAD: Compatible with equivalent versions

---

**Document Version:** 2.0
**Last Updated:** 2026-02-21
**Script Version Documented:** 2.7 (15.11.2023)
