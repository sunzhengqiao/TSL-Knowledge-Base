# DimRadial - Radial and Diametric Dimension Tool

## Overview

**DimRadial** is a comprehensive dimensioning tool for annotating curved geometry in hsbCAD timber construction projects. It automatically detects and dimensions arcs, circles, drill holes, and mortise corner radii on timber beams, panels, CLT elements, and assemblies. The script intelligently creates radial dimensions (R-prefix), diametric dimensions (Ø-symbol), or arc length dimensions depending on the geometry and mode selected.

**Key Capabilities:**
- **Multi-Environment Support**: Works in Model Space, Paper Space viewports, Multipages, Sections, and Shop Drawing viewports
- **Intelligent Arc Detection**: Automatically finds arcs from beam contours, openings, drill holes, and mortise corner radii
- **Automated Shop Drawing Integration**: Can be configured once in block space and automatically generates dimensions during shop drawing batch production
- **Interactive Placement**: Visual jig system shows all detected arcs with live preview during placement
- **Format Customization**: Supports format variables for radius, diameter, arc length, and coordinates

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object, parametric entity) |
| **Version** | 3.4 (December 2, 2024) |
| **Author** | Thorsten Huck |
| **Required Beams** | 0 |
| **Workspace** | Model Space and Paper Space |
| **Settings File** | DimRadial.xml |
| **Dependencies** | TslUtilities.dll (Dialog services) |

## Version History

### Recent Updates
- **3.4** (Dec 2024): Support for metalparts in XRef drawings (HSB-23092)
- **3.3** (Feb 2024): Improved mortise corner radius detection (HSB-21240)
- **3.2** (Feb 2024): Added curved beam style support, enhanced arc recognition for segmented contours
- **3.1** (Feb 2024): Suppressed perpendicular drills, added leader line support
- **2.8** (Feb 2024): Arc length dimension mode added
- **2.7** (Jan 2024): Complete revision with new tool definition system via context menu

### Key Historical Features
- **2.4** (May 2023): Painter filtering support in block space mode
- **2.3** (Apr 2023): Assembly definition support, scale-to-fit pages
- **1.9** (Mar 2023): Caching system for performance during grip dragging
- **1.0** (Nov 2022): Initial release

## Prerequisites

### Required Entities
The script requires at least one of the following reference entities:
- **Timber Elements**: GenBeam, Element (wall/floor/roof)
- **Specialty Entities**: Multipage, Section2d, ShopDrawView
- **Container Entities**: MetalPartCollectionEnt, TrussEntity, CollectionEntity
- **Geometry**: Closed polylines (EntPLine)

### Drawing Setup
- **DimStyle Required**: At least one AutoCAD dimension style must exist in the drawing
- **Curved Geometry**: The referenced entities must contain arcs, circles, or curved tooling operations
- **Unit Settings**: Works in both Millimeter and Inch drawing units via U() function

### Supported Arc Sources
The script detects arcs from:
1. **Beam Contours**: Outer profile curved edges
2. **Openings**: Window/door openings with curved corners
3. **Drills**: Circular drill holes (perpendicular, rotated, tilted, beveled)
4. **Mortise Corner Radii**: Rounded corners of rectangular mortises
5. **Curved Beam Styles**: Arched or curved beam profile edges

## Installation & Insertion

### Command Line Insertion
```lisp
; Standard insertion via TSLINSERT
^C^C(defun c:DIMRAD() (hsb_ScriptInsert "DimRadial")) DIMRAD

; Regenerate shop drawings with updated dimensions
^C^C(defun c:DIMRADUPD() (hsb_RecalcTslWithKey (_TM "|Regenerate Shopdrawing|") (_TM "|Select Tool|"))) DIMRADUPD
```

### Catalog-Based Insertion
If DimRadial.xml contains named configurations, you can insert pre-configured instances:
```lisp
; Insert with specific catalog entry
(hsb_ScriptInsert "DimRadial" "MyConfiguration")
```

## Parameter Reference

### Behaviour Parameters

#### Dimension Mode
**Type**: Dropdown String
**Default**: Automatic
**Options**: Radial | Diametric | Arc Measure | Automatic

**Description**: Controls how curved geometry is dimensioned.

| Mode | Symbol | Applied To | Example Output |
|------|--------|------------|----------------|
| **Radial** | R | Arcs and circles | R50 |
| **Diametric** | Ø | Arcs and circles | Ø100 |
| **Arc Measure** | ᴖ | Open arcs only | ᴖ157 (arc length) |
| **Automatic** | R/Ø | Circles→Ø, Arcs→R | Intelligent choice |

**Usage Notes**:
- **Automatic Mode**: Chooses Diametric for full circles (360°) and Radial for partial arcs
- **Arc Measure**: Only available for open arcs; shows arc length with angular dimension style
- **Shop Drawing Preference**: Use Automatic mode for general-purpose dimensioning to match drafting conventions

---

#### Filter (Painter)
**Type**: Dropdown String
**Default**: <Default>
**Available**: All painters in "Dimension" folder (or all painters if folder doesn't exist)

**Description**: Restricts which beams/entities contribute to dimensioning by applying a PainterDefinition filter. Only entities matching the selected painter's rules (layer, material, size, etc.) will be considered.

**Painter Collection Behavior**:
- If a painter collection folder named **"Dimension\\"** exists, only painters inside that folder are listed by default
- Use the **"Painter Management"** context menu to change folder restriction behavior
- Selecting **<Default>** disables painter filtering (all entities considered)

**Use Cases**:
- **Zone-Based Dimensioning**: Create painters for "Zone A", "Zone B" to dimension only specific wall zones
- **Material-Specific**: Filter to dimension only studs (not plates) by creating a painter with width/height rules
- **Layer Filtering**: Dimension only entities on specific CAD layers

---

#### Tool Set
**Type**: String (semicolon-separated)
**Default**: All
**Editable Via**: "Define Tool Sets" context menu

**Description**: Specifies which types of geometry sources contribute arcs for dimensioning.

**Available Tool Types**:

| Category | Tool Type | Description |
|----------|-----------|-------------|
| **Shape** | Contour | Outer beam profile arcs |
| | Opening | Window/door opening arcs |
| | Curved | Curved beam style contours |
| **Drills** | Drill, perpendicular | Standard perpendicular holes |
| | Drill, rotated | Angled drills (rotation only) |
| | Drill, tilted | Drills with tilt angle |
| | Drill, head side | Drills at beam ends |
| | Drill, 5-Axis | Complex multi-angle drills |
| **Mortises** | Mortise, perpendicular | Standard mortise corner radii |
| | Mortise, rotated | Angled mortise corners |
| | Mortise, tilted | Tilted mortise corners |
| | Mortise, 5-Axis | Complex mortise corners |
| | Mortise, beam end (various) | Beam end connection mortises |

**How to Configure**:
1. Right-click the dimension instance → **"Define Tool Sets"**
2. A multi-selection dialog shows all detected tool types with count in parentheses: `Drill, perpendicular (8)`
3. Select/deselect tool types to include
4. The selection is stored as semicolon-separated string (e.g., `"_kContour;_kADPerpendicular"`)

**Common Configurations**:
- **Drills Only**: Deselect Contour and Opening → dimensions only drill holes
- **Contour Only**: Select only Contour → dimensions beam profile arcs, ignores tooling
- **Mortise Corners**: Select mortise types → dimensions only rounded mortise corners

**Performance Tip**: When drawings contain hundreds of drill holes, restricting tool sets speeds up dimension placement by reducing arc detection calculations.

---

#### TSL / Stereotype
**Type**: String (semicolon-separated)
**Default**: Empty (all sources)
**Editable Via**: "Define TSL/Parent Tool Sets" context menu

**Description**: Filters arcs by the TSL script name or parent entity type that created them. This is a more specific filter than Tool Set—it targets individual scripts.

**Example Filtering**:
- **By TSL Script**: Enter `"FreeDrill;DrillDistribution"` to dimension only arcs created by those specific drill scripts
- **By Entity Type**: Enter `"ACAD_DRILL"` to dimension only native AutoCAD drill entities (if supported)
- **Combined**: `"FreeDrill;ACAD_MORTISE;hsbCLT-Drill"` for multi-source filtering

**Use Cases**:
- **Exclude Auto-Generated Holes**: If a beam has both manual drills (important) and automatically distributed connection drills (clutter), dimension only the manual ones
- **Hardware-Specific**: Dimension only Simpson StrongTie connector holes by filtering for `"Simpson StrongTie*"` scripts
- **CNC vs. Field Work**: Separate dimensions for CNC-drilled holes vs. field-installed holes

**How to Configure**:
1. Right-click → **"Define TSL/Parent Tool Sets"**
2. Multi-selection dialog lists all TSL scripts and supported entity tools found in the drawing
3. Select scripts/tools to include
4. Selection stored as semicolon-separated list

---

#### Distribution
**Type**: Dropdown String
**Default**: <Default> (behaves as "One by Radius")
**Options**: <Default> | All | One by Source | One by Radius
**Availability**: Visible only in block space setup mode or when ShopDrawView is selected

**Description**: Controls how multiple identical arcs are dimensioned in automated shop drawing generation.

| Mode | Behavior | Use Case |
|------|----------|----------|
| **<Default>** | Same as "One by Radius" | Standard behavior |
| **All** | Dimensions every detected arc | Verification drawings, detailed CNC sheets |
| **One by Source** | One dimension per source entity | One dim per beam even if beam has 5 identical holes |
| **One by Radius** | One dimension per unique radius value | Avoids redundant dimensions (recommended) |

**Example Scenario**:
- A wall has 50 studs, each with 2 identical Ø20mm holes
- **All**: Creates 100 dimensions (cluttered)
- **One by Source**: Creates 50 dimensions (one per stud)
- **One by Radius**: Creates 1 dimension labeled "Ø20" (clean, readable)

**Shop Drawing Workflow**:
1. In block space, place DimRadial setup instance on ShopDrawView
2. Set Distribution to "One by Radius"
3. During "Regenerate Shopdrawing", script automatically creates one dimension per unique hole size
4. Result: Clean shop drawings without dimension clutter

---

#### Face
**Type**: Dropdown String
**Default**: Viewing Side
**Options**: Viewing Side | Opposite Viewing Side | Any Viewing Side

**Description**: Determines which face of a beam is analyzed for arcs when the beam has tooling on multiple faces.

| Option | Behavior |
|--------|----------|
| **Viewing Side** | Analyzes the face oriented toward the current view direction |
| **Opposite Viewing Side** | Analyzes the back face (away from view) |
| **Any Viewing Side** | Considers arcs on both front and back faces |

**Technical Details**:
- The script calculates the beam's normal vector (vecZM) in the current view's coordinate system
- For standard orthogonal views (top/front/side), this automatically selects the correct face
- For beveled or tilted beams, the face is determined by the beam's depth vector (vecD)

**Use Cases**:
- **Standard Views**: Use "Viewing Side" (default)
- **Through Holes**: Use "Any Viewing Side" to dimension through-holes visible from either direction
- **Back-Side Mortises**: Use "Opposite Viewing Side" for dimensioning connections on the hidden face

---

### Display Parameters

#### Text
**Type**: String with format variables
**Default**: `<>`
**Examples**: `<>` | `R@(Radius:RL0)` | `Ø@(Diameter:RL1) @(Depth:RL0) deep`

**Description**: Defines the content and format of the dimension text annotation.

**Special Values**:
- **`<>`**: Uses the dimension text defined by the DimStyle, including automatic unit scaling
- **Empty string**: Shows the raw radius or diameter value without prefix
- **Format variables**: Insert dynamic values using `@(VariableName:Format)` syntax

**Available Format Variables**:

| Variable | Unit | Description | Example Output |
|----------|------|-------------|----------------|
| `@(Radius:RL0)` | Length | Radius value, 0 decimals | `50` |
| `@(Radius:RL1)` | Length | Radius value, 1 decimal | `50.5` |
| `@(Diameter:RL0)` | Length | Diameter value | `100` |
| `@(Diameter:RL1)` | Length | Diameter with precision | `100.0` |
| `@(ArcLength:RL1)` | Length | Arc length (for Arc Measure mode) | `157.1` |
| `@(CoordX:RL0)` | Length | X-coordinate of arc center | `1200` |
| `@(CoordY:RL0)` | Length | Y-coordinate of arc center | `800` |
| `@(Depth:RL0)` | Length | Drill depth (from tool metadata) | `65` |
| `@(Angle:RL0)` | Angle | Drill angle (from tool metadata) | `45` |
| `@(Bevel:RL0)` | Angle | Drill bevel angle | `30` |
| `@(Twist:RL0)` | Angle | Mortise twist angle | `15` |

**Format Codes**:
- **R**: Real number
- **L**: Length unit (respects drawing units)
- **0,1,2**: Decimal places

**Custom Text Examples**:
```
Text Property              →  Output Example
─────────────────────────────────────────────────
<>                         →  R50 (DimStyle default)
R@(Radius:RL0)             →  R50
Ø@(Diameter:RL1)           →  Ø100.0
Ø@(Diameter:RL0) DRILL     →  Ø20 DRILL
@(Radius:RL1)x@(Depth:RL0) →  10.0x65
HOLE Ø@(Diameter:RL0)mm    →  HOLE Ø20mm
```

**Tool Metadata Integration**:
- When dimensioning drill holes, the script automatically retrieves Depth, Angle, Bevel from the AnalysedDrill
- When dimensioning mortises, Twist and other mortise-specific data becomes available
- Format variables return empty if the underlying tool doesn't provide that data

**Arc Length Mode**:
- If Text contains `@(ArcLength`, the dimension automatically switches to Arc Measure mode
- The script prepends the arc length symbol: `ᴖ@(ArcLength:RL0)`
- Only works for open arcs (not full circles)

---

#### Dimstyle
**Type**: Dropdown String
**Default**: First available dimension style
**Available**: Filtered list of dimension styles appropriate for the selected mode

**Description**: Selects the AutoCAD dimension style used for rendering the dimension annotation.

**Automatic Filtering**:
The script filters the _DimStyles array to show only styles compatible with the current Dimension Mode:

| Dimension Mode | DimStyle Filter | AutoCAD Style Type |
|----------------|-----------------|-------------------|
| Radial | `$3` suffix or no suffix | Radial dimension styles |
| Diametric | `$4` suffix or no suffix | Diametric dimension styles |
| Arc Measure | `$2` suffix or no suffix | Angular dimension styles |

**DimStyle Override Syntax**:
- AutoCAD dimension style families use suffixes: `MyStyle$3` = radial override of `MyStyle`
- The script displays the clean name in the UI (`MyStyle`) but applies the correct override internally
- If you select a non-overridden style, the script uses the base style for all dimension types

**Customization Requirements**:
For the **Color** property to work, the DimStyle must use:
- Dimension line color: **ByBlock**
- Extension line color: **ByBlock**
- Text color: **ByBlock**

**Shop Drawing Standards**:
- Create a dedicated DimStyle family for shop drawings (e.g., `ShopDim`, `ShopDim$3`, `ShopDim$4`)
- Configure arrow sizes, text height, and precision to match your company standards
- Export the configuration via "Export Settings" to share across projects

---

#### Text Height
**Type**: Double (Length)
**Default**: 0 (use DimStyle)
**Unit**: Millimeters or Inches (drawing units)

**Description**: Overrides the dimension text height defined in the DimStyle. A value of 0 means "use DimStyle setting" (recommended).

**When to Override**:
- **Mixed-Scale Drawings**: When one DimStyle is used across multiple viewports with different scales
- **Temporary Emphasis**: Making specific dimensions larger for clarity
- **Plot Scale Adjustment**: Fine-tuning text size for specific plot scales

**Calculation Notes**:
- The text height is applied in paper space units (after viewport scaling)
- If Text Height = 3mm and viewport scale = 1:50, the text appears 3mm tall on the printed sheet
- The script uses this value for leader grip calculations and arc measure dimension positioning

**Best Practice**: Leave at 0 and control text height through DimStyle settings for consistency across all dimensions.

---

#### Graphical Scale Factor
**Type**: Double (No Unit)
**Default**: 25
**Range**: >0 (typically 1-100)

**Description**: Scales graphical elements of the dimension such as arrowheads, tick marks, and dashes. Does not affect text or measurement values.

**Effect on Dimension Components**:
- **Arrowheads**: Size multiplied by this factor
- **Tick Marks**: Height/width scaled
- **Dashes**: Gap and length scaled
- **Text**: NOT affected (use Text Height instead)
- **Measurement Value**: NOT affected (always accurate)

**Scale Factor Examples**:
```
Factor = 10  →  Small arrows, tight spacing (dense drawings)
Factor = 25  →  Standard size (default)
Factor = 50  →  Large arrows, wide spacing (presentation drawings)
Factor = 100 →  Very large graphical elements (poster prints)
```

**Use Cases**:
- **1:100 Shop Drawings**: Use factor 25-30 for readable dimensions
- **1:10 Detail Views**: Use factor 50-75 for prominent dimensions
- **Presentation Drawings**: Use factor 75-100 for visual clarity
- **CNC Manufacturing Sheets**: Use factor 15-20 to minimize visual clutter

**Viewport Scale Interaction**:
- This factor is **additional** to viewport scaling
- If viewport scale = 1:50 and Graphical Scale Factor = 25, the effective arrow size is scaled by both
- For consistency, set a standard factor and adjust per-viewport if needed

---

#### Leader Length
**Type**: Double (Length)
**Default**: 0 (no leader)
**Unit**: Millimeters or Inches (drawing units)
**Visibility**: Hidden (use Leader grip instead)

**Description**: Sets the length of a leader line from the arc to the dimension text. When 0, the dimension text is placed directly on or near the arc. This property is primarily controlled via the interactive **Leader Grip** and is hidden in the Properties panel by default (visible only in debug mode).

**Leader Line Behavior**:
- **Length = 0**: No leader, text positioned on arc
- **Length > 0**: Leader line drawn from arc to offset text position
- **Length = textHeight**: Minimum threshold; leader automatically deactivates if grip dragged closer

**Interactive Control (Recommended Method)**:
1. After placing dimension, locate the **Leader Grip** (colored circle at text location)
2. **Drag grip away from arc**: Automatically creates leader and updates this property
3. **Drag grip close to arc** (within textHeight distance): Leader deactivates, property set to 0
4. Grip color indicates state:
   - **Gray (252)**: Leader inactive (length ≤ textHeight)
   - **Blue (150)**: Leader active (length > textHeight)

**Automatic Leader Deactivation**:
When dimensioning arc measure (angular) dimensions, the script intelligently deactivates the leader if:
- The leader would intersect the arc
- The text fits within the arc without leader
- The leader would create visual confusion

**Use Cases**:
- **Crowded Dimensions**: Offset dimension text from arc to avoid overlapping annotations
- **Angled Placement**: Position text outside the beam profile for clarity
- **Callout Style**: Create callout-style dimensions pointing to specific features

**Technical Notes**:
- Leader length is stored in paper space units (after viewport scaling)
- Leader direction is always radial (along the line from arc center to picked point)
- Leader style (solid line, arrow, etc.) is controlled by the DimStyle, not this property

---

#### Unit Scale
**Type**: Double (No Unit)
**Default**: 1
**Range**: >0 (typically 1, 25.4, or 0.0394)
**Read-Only**: Yes, when Text property contains `<>`

**Description**: Multiplies the displayed dimension value by this factor to convert between unit systems or apply custom scaling. **Important**: This property is read-only when Text = `<>` because DimStyle handles unit scaling automatically in that mode.

**Unit Conversion Examples**:

| Drawing Units | Display As | Unit Scale | Example Output |
|---------------|------------|------------|----------------|
| Millimeters | Millimeters | 1 | R50 (if radius = 50mm) |
| Millimeters | Inches | 0.0394 | R1.97 (if radius = 50mm) |
| Inches | Millimeters | 25.4 | R1270 (if radius = 50in) |
| Inches | Inches | 1 | R50 (if radius = 50in) |

**Custom Scaling Examples**:
```
Radius in drawing = 50mm

Unit Scale = 1     →  Output: R50 or Ø100
Unit Scale = 0.001 →  Output: R0.05 (display in meters)
Unit Scale = 10    →  Output: R500 (display in centimeters×10)
```

**Behavior with Text Formats**:

| Text Property | Unit Scale | Behavior |
|---------------|------------|----------|
| `<>` | Any value | **Ignored**; DimStyle controls scaling (read-only) |
| Empty | 1 | Raw value: `50` |
| Empty | 25.4 | Scaled value: `1270` |
| `R@(Radius:RL1)` | 1 | Custom format: `R50.0` |
| `R@(Radius:RL1)` | 0.0394 | Custom format with scaling: `R1.97` |
| `Ø@(Diameter:RL0)` | 25.4 | Custom format: `Ø1270` |

**Symbol Insertion with Unit Scale**:
When Unit Scale ≠ 1 and using custom text formats:
- Radial mode: Script automatically prepends `R` if format is empty
- Diametric mode: Script automatically prepends `Ø` if format is empty
- This ensures dimension symbols appear even when not using DimStyle default

**Best Practices**:
- **Recommended**: Use `Text = <>` and configure unit conversion in DimStyle (simpler, more reliable)
- **Advanced Users**: Use Unit Scale with custom Text formats for specialized output
- **Verification**: Always check a few dimensions after changing Unit Scale to ensure correct values

**Technical Note**: The Unit Scale factor is applied during the `drawDim()` function, after format variable evaluation. The dimension value is multiplied, then converted to string and prepended with R or Ø as appropriate.

---

#### Color
**Type**: Integer
**Default**: -1 (by layer)
**Range**: -1 (by layer), 0-255 (ACI colors), or TrueColor values

**Description**: Overrides the dimension annotation color. **Critical Requirement**: For this property to take effect, the DimStyle must have its color settings set to **ByBlock**.

**DimStyle Requirements**:
To enable color override, configure your DimStyle with:
- **Dimension Line Color**: ByBlock
- **Extension Line Color**: ByBlock
- **Text Color**: ByBlock
- **Arrowhead Color**: ByBlock (inherits from dimension line)

**Color Value Reference**:

| Value | Meaning | Typical Use |
|-------|---------|-------------|
| -1 | ByLayer | Standard (dimensions inherit layer color) |
| 0 | ByBlock | Inherit from parent block/entity |
| 1 | Red | Errors, critical dimensions |
| 2 | Yellow | Warnings, important dimensions |
| 3 | Green | Approved, verified dimensions |
| 4 | Cyan | Reference dimensions |
| 5 | Blue | Standard dimensions |
| 6 | Magenta | Special features |
| 7 | White/Black | Default (auto-switches based on background) |
| 8-255 | Other ACI | Full AutoCAD Color Index |

**Use Cases**:
- **Color-Coded by Type**: Use Red for critical structural dimensions, Blue for reference
- **Status Indication**: Green for verified/approved dimensions, Yellow for "needs checking"
- **Layer Independence**: Force dimension color regardless of layer assignment
- **Print Consistency**: Ensure dimensions always print in a specific color

**Troubleshooting**:
If changing the Color property has no effect:
1. Open the DimStyle manager (DIMSTYLE command)
2. Modify the dimension style used by this dimension
3. In the **Lines** and **Text** tabs, change all color settings from specific colors to **ByBlock**
4. Save the DimStyle
5. Recalculate the DimRadial instance

**Layer vs. Color Property**:
- If Color = -1 (ByLayer), dimension color matches the layer it's placed on
- If Color = specific value, dimension ignores layer color (useful for multi-layer shop drawings)

---

## Usage Instructions

### Method 1: Interactive Placement (Model Space)

This is the primary workflow for placing individual dimensions on beams in Model Space.

#### Step 1: Insert and Configure
1. **Launch Script**: Run `TSLINSERT` or custom command, type `DimRadial`
2. **Properties Dialog Appears**: Configure initial settings:
   - **Dimension Mode**: Choose Radial, Diametric, Arc Measure, or Automatic (recommended)
   - **Filter**: Select a painter if you want to restrict to specific beam types
   - **Text**: Leave as `<>` for standard dimensioning, or use format variables for custom output
   - **Dimstyle**: Pick appropriate dimension style
3. **Click OK** to proceed to entity selection

#### Step 2: Select Reference Entities
**Prompt**: _"Select reference (genbeams, elements, collections, polylines or other hsb entities)"_

**Selection Options**:
- **Individual Beams**: Click single GenBeam entities
- **Elements**: Select entire wall/floor/roof Element (all beams in element analyzed)
- **Collections**: Select MetalPartCollectionEnt, TrussEntity, or CollectionEntity
- **Polylines**: Select closed polyline curves (useful for custom shapes)
- **Multiple Selection**: Hold Shift and click multiple entities, or use window selection

**Special Entity Types**:
- **Multipage**: If Multipage entities exist, they appear in the prompt. Selecting a Multipage triggers viewport selection (Step 2b)
- **Section**: Selecting a Section2d automatically uses the section's clip volume to filter beams
- **ShopDrawView**: Selecting a shop drawing viewport enters block space setup mode (see Method 3)

#### Step 2b: Multipage Viewport Selection (if Multipage selected)
If you selected a Multipage in Step 2:
1. **Visual Jig Activates**: All viewport boundaries appear highlighted
2. **Prompt**: _"Select viewport"_
3. **Click inside the desired viewport**: The script records which projection direction (top/front/side/iso) to use
4. **Snap Mode**: All snaps are temporarily disabled during this selection to ensure you click the viewport area, not geometry

**Why This Matters**: Multipages can show the same beam from different angles (top view, front view). The script needs to know which view direction to use for face detection and arc projection.

#### Step 3: Pick Dimension Location (Visual Jig)
**Interactive Jig Activates**: The screen shows:
- **All detected arcs** highlighted in light blue (semi-transparent)
- **Closest arc to cursor** highlighted in **yellow**
- **Live dimension preview** following your cursor

**Jig Controls**:
- **Move Mouse**: Hover over different arcs; yellow highlight jumps to nearest arc
- **Left Click**: Place dimension on the currently highlighted arc
- **Type Keywords at Command Line** (while jig is active):
  - **R**: Switch to Radial mode
  - **D**: Switch to Diametric mode
  - **M**: Switch to Arc Measure mode
  - **A**: Switch to Automatic mode
- **Right Click or ESC**: Exit jig and finish placement

**Multiple Placement**:
- After first click, the jig continues running
- Click additional arcs to place more dimensions
- Each click creates an independent DimRadial instance
- The insertion jig instance itself is erased after you exit; only placed dimensions remain

**What Arcs Are Detected**:
The jig shows arcs from (depending on Tool Set configuration):
- Beam contour curves
- Opening arcs (doors/windows)
- Drill hole circles
- Mortise corner radii
- Curved beam style contours

#### Step 4: Adjust Position and Leader (Grips)
After placement, select the dimension to activate grips:

**Location Grip** (Yellow Circle at Arc):
- **Drag along arc**: Moves dimension around the same arc
- **Drag to different arc**: Automatically snaps to nearest different arc, updates dimension
- **Use Case**: Reposition dimension to avoid overlapping with other annotations

**Leader Grip** (Colored Circle at Text):
- **Drag away from arc**: Creates leader line, offsets text, grip turns blue
- **Drag close to arc** (within textHeight): Deactivates leader, grip turns gray
- **Direction**: Leader is always radial (along center-to-arc line)
- **Use Case**: Move dimension text outside crowded areas

**Arc Length Grip** (Only in Arc Measure Mode):
- **Appears**: Only when dimensioning open arcs in Arc Measure mode
- **Drag around arc**: Repositions angular dimension text along the arc
- **Use Case**: Fine-tune text placement for arc length dimensions

#### Step 5: Modify Properties (Optional)
Select the dimension and open Properties panel (Ctrl+1) to adjust:
- Change Dimension Mode (switch between Radial/Diametric/Arc Measure)
- Modify Text format (add custom labels or format variables)
- Change Dimstyle
- Adjust Text Height or Graphical Scale Factor
- Filter by painter or tool sets via context menu

---

### Method 2: Paper Space Viewport Placement

This workflow is for placing dimensions in Paper Space layouts when working with hsbCAD viewports.

#### Step 1: Insert in Paper Space
1. **Switch to Layout Tab**: Click a Paper Space layout tab
2. **Ensure in Paper Space**: Status bar should show "Paper" (not "Model")
3. **Insert DimRadial**: Run `TSLINSERT`, type `DimRadial`
4. **Properties Dialog**: Configure dimension mode, text, dimstyle

#### Step 2: Select hsbCAD Viewport
**Prompt**: _"Select a viewport"_

**Selection**:
- **Click the viewport border** of an hsbCAD viewport (viewport created via Element.createViewport() or similar)
- The script reads the viewport's linked Element

**Two Scenarios**:

**Scenario A: hsbCAD Viewport (Element-Linked)**
- The viewport has an associated Element (wall, floor, roof)
- **Automatic Beam Collection**: All GenBeams in the Element are automatically analyzed
- **No Further Selection Needed**: Script proceeds directly to Step 3
- **Active Zone Filtering**: If the viewport has an active zone index, only beams in that zone are considered (unless painter filtering is used)

**Scenario B: Standard AutoCAD Viewport (No Element)**
- The viewport is a plain AutoCAD viewport, not linked to an hsbCAD Element
- **Switch to Model Space**: The script automatically switches into Model Space through the viewport
- **Entity Selection**: You are prompted to select GenBeams, Elements, or other entities (same as Method 1, Step 2)
- **Switch Back to Paper Space**: After selection, script switches back to Paper Space

#### Step 3: Pick Dimension Location
- **Visual Jig**: Same as Method 1, Step 3
- **Arcs Projected**: Arcs are detected from ModelSpace geometry, then projected onto Paper Space plane using viewport transformation
- **Scaling Applied**: Dimensions appear at the correct scale for the viewport (viewport scale × dimension settings)

#### Step 4: Adjust with Grips
Same grip behavior as Method 1, Step 4

**Special Considerations**:
- **Viewport Scale**: Dimensions automatically scale to match viewport scale
- **View Direction**: Arc face detection uses the viewport's view direction (vecZM calculated from viewport transformation)
- **Multizone Elements**: If the Element has multiple zones and viewport activeZoneIndex = 999 (all zones), all zones are dimensioned unless painter filter is applied

---

### Method 3: Block Space Setup for Automated Shop Drawings

This is the **power user workflow** for batch shop drawing production. You configure dimensioning rules once, and the script automatically generates dimensions for all shop drawing views.

#### Step 1: Insert onto ShopDrawView in Model Space
1. **Ensure in Model Space**: Active layout must be Model tab
2. **Insert DimRadial**: Run `TSLINSERT`, type `DimRadial`
3. **Properties Dialog**:
   - **Distribution**: Change from <Default> to **One by Radius** (recommended for clean shop drawings)
   - **Tool Set**: Click "Set to ReadWrite" if needed, then use context menu later to define
   - **TSL/Stereotype**: Configure if you want to filter specific scripts
   - Configure other properties as desired
4. **Entity Selection Prompt**: _"Select reference (Shopdraw Viewport, Multipage, Section, or other hsb entities)"_

#### Step 2: Select ShopDrawView
- **Click a ShopDrawView entity** in Model Space (these are created by shop drawing generation scripts)
- **Prompt**: _"Pick location for setup graphics"_
- **Click a point**: This becomes the _Pt0 origin for the block space setup instance
- **Visual Feedback**: A schematic preview appears showing:
  - The setup instance symbol at _Pt0
  - Guide lines connecting _Pt0 to each associated ShopDrawView
  - The configuration is visible but dimensions are **not yet generated**

#### Step 3: Configure Tool Sets (Context Menu)
1. **Right-click the setup instance** → **"Define Tool Sets"**
2. **Multi-Selection Dialog**: Lists all tool types with detected count:
   ```
   [✓] Contour (15)
   [✓] Opening (3)
   [✓] Drill, perpendicular (42)
   [ ] Drill, rotated (8)
   [✓] Mortise, perpendicular (6)
   ```
3. **Select/Deselect** tool types to include
4. **Click OK**

**Typical Shop Drawing Configuration**:
- **Structural Shop Drawings**: Select Contour + Opening (shape only, no tooling)
- **CNC Manufacturing Sheets**: Select all Drill types + Mortise types (tooling only)
- **Verification Drawings**: Select All (complete documentation)

#### Step 4: Configure TSL/Stereotype Filter (Optional)
If you want to dimension only arcs created by specific scripts:
1. **Right-click** → **"Define TSL/Parent Tool Sets"**
2. **Multi-Selection Dialog**: Lists all TSL scripts found in the drawing
3. **Select specific scripts**: e.g., `FreeDrill`, `DrillDistribution`, `hsbCLT-Drill`
4. **Click OK**

#### Step 5: Add/Remove Viewports (Multi-Viewport Support)
A single block space setup can serve multiple ShopDrawViews:

**To Add Viewports**:
1. **Right-click** → **"Add Viewport"**
2. **Prompt**: _"Select additional Shop Drawing Viewports"_
3. **Click additional ShopDrawView entities**
4. Guide lines update to show all connected viewports

**To Remove Viewports** (only available if more than one viewport assigned):
1. **Right-click** → **"Remove Viewport"**
2. **Prompt**: _"Select Shop Drawing Viewports to disassociate"_
3. **Click viewports to remove**

#### Step 6: Export Settings (Share Configuration Across Project)
To save the configuration for reuse:
1. **Right-click** → **"Export Settings"**
2. **Confirmation Prompt**: If DimRadial.xml already exists, confirm overwrite
3. **File Written**: Settings exported to `[Company TSL Path]\Settings\DimRadial.xml`
4. **Share**: Other team members can use "Import Settings" to adopt the same configuration

**What Gets Exported**:
- Tool Set selections
- TSL/Stereotype filter strings
- Distribution mode
- Default dimension mode, text format, dimstyle
- Painter management mode
- Global settings (group assignment)

#### Step 7: Regenerate Shop Drawings (Automatic Dimension Generation)
When shop drawings are regenerated (via shop drawing batch scripts or manual regeneration):
1. **Regeneration Trigger**: User runs shop drawing regeneration command
2. **DimRadial Activates**: Each block space setup instance activates
3. **Arc Detection**: Script analyzes all beams in each ShopDrawView based on configuration
4. **Dimension Creation**: Individual DimRadial instances automatically created for each arc (or one per radius/source, depending on Distribution setting)
5. **Result**: Fully dimensioned shop drawings without manual placement

**Distribution Modes in Action**:

**Example: Wall with 20 studs, each stud has 2x Ø20mm holes and 1x Ø25mm hole**

| Distribution Mode | Dimensions Created | Rationale |
|-------------------|-------------------|-----------|
| **All** | 60 dimensions | Every hole dimensioned (cluttered) |
| **One by Source** | 20 dimensions | One per stud (still cluttered) |
| **One by Radius** | 2 dimensions | One for Ø20, one for Ø25 (clean) |

**Viewport-Specific Setup**:
- You can create multiple block space setups with different configurations
- Example: Setup A for front view (contour only), Setup B for detail view (all drills)
- Each setup targets different ShopDrawViews

---

### Method 4: Multipage Integration

When working with Multipage layouts (multi-view shop drawing sheets):

#### Multipage-Specific Behavior
1. **Insertion**: When you select a Multipage as the reference entity
2. **View Selection Jig**: A visual jig highlights all viewport boundaries on the Multipage
3. **Click Inside Viewport**: Select which view (top/front/side/iso) to dimension
4. **View Direction Stored**: The script stores `vecModelView` in `_Map` to remember which projection to use
5. **Automatic Repositioning**: If you move the Multipage, the dimension instance automatically moves with it (grips stay at correct location)

#### Multipage Movement Handling
The script includes special logic to handle Multipage movement:
```c
// Keep Grips at location when moving the multipage
ptOrg = page.coordSys().ptOrg();
Vector3d vecOrg = ptOrg-_Pt0;
if (!vecOrg.bIsZeroLength() && !bDrag && !_bOnInsert)
{
    _Pt0.transformBy(vecOrg);
    for (int g=0;g<_Grip.length();g++)
    {
        Point3d pt = _Grip[g].ptLoc();
        pt.transformBy(vecOrg);
        _Grip[g].setPtLoc(pt);
    }
    setExecutionLoops(2);
    return;
}
```
**Result**: Dimensions stay correctly positioned relative to the Multipage views even when the Multipage is moved.

---

### Method 5: Section Integration

When dimensioning Section2d views:

#### Section-Specific Workflow
1. **Insert DimRadial**: Standard insertion
2. **Select Section2d Entity**: Choose a Section
3. **Automatic ClipVolume**: The script automatically uses the Section's ClipVolume to filter beams
4. **View Transformation**: Dimensions projected using `section.modelToSection()` coordinate transformation
5. **Face Detection**: Arcs detected on the face aligned with the section view direction

#### Technical Details
```c
section = (Section2d) e;
if (section.bIsValid())
{
    ms2ps = section.modelToSection();
    ps2ms = ms2ps; ps2ms.invert();
    vecZM = _ZW;
    vecZM.transformBy(ps2ms); vecZM.normalize();

    clipVolume = section.clipVolume();
    showSet = clipVolume.entitiesInClipVolume(true);
}
```
**Result**: Only entities within the section's clip volume are analyzed, and arcs are projected onto the section plane.

---

## Advanced Features

### Arc Detection Algorithm

The script uses sophisticated arc detection to find dimensionable geometry:

#### Phase 1: Drill Hole Detection
```c
AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);

// Filter valid drills
for (int j2=drills.length()-1; j2>=0 ; j2--)
{
    AnalysedDrill a= drills[j2];
    Vector3d vecSide = a.vecSide();
    Vector3d vecFree = a.vecFree();
    int bThrough = a.bThrough();

    // Remove if perpendicular to view (would appear as line, not circle)
    int isPerpendicularTo = vecSide.isPerpendicularTo(vecZMThis);

    // Remove if on wrong face and not through-hole
    if (isPerpendicularTo || (nFaceMode<2 && vecFace.dotProduct(vecSide)<0 && !bThrough))
    {
        drills.removeAt(j2);
    }
}
```
**Logic**:
- Filters out drills whose axis is perpendicular to view (would appear as edge, not circle)
- Respects Face setting: shows only drills on selected face, unless through-hole
- Creates PLine circles at drill start point with radius from AnalysedDrill

#### Phase 2: Mortise Corner Radius Detection
```c
AnalysedMortise mortises[] = AnalysedMortise().filterToolsOfToolType(tools);

for (int j2 = 0; j2 < mortises.length(); j2++)
{
    AnalysedMortise& a= mortises[j2];
    double radius = a.dCornerRadius();

    if (radius < dEps) { continue; } // Skip if no corner radius

    Quader q = a.quader();
    CoordSys cst = a.coordSys();

    double dx = q.dD(vecXT)*.5;
    double dy = q.dD(vecYT)*.5;

    // Rectangular mortise: 4 corner arcs
    if (dx>radius && dy>radius)
    {
        Point3d pts[4]; // Calculate 4 corner positions
        // Create arc at each corner with angle tan(-22.5)
    }
    // Slot mortise: 2 end arcs
    else
    {
        // Create 2 arcs at slot ends with angle tan(-45)
    }
}
```
**Logic**:
- Analyzes mortise Quader dimensions
- Differentiates between rectangular mortises (4 corners) and slot mortises (2 ends)
- Creates arc segments at corner positions with appropriate bulge values

#### Phase 3: Contour and Opening Arc Reconstruction
```c
int convertRing(PLine& pl, String subType, Map& mapIO, Entity parent, PLine plLocks[])
{
    // Try to reconstruct segmented contours into arcs
    PLine plTmp = pl;
    plTmp.reconstructArcs(dEps, 75);

    if (plTmp.length() / pl.length() > .8) // Successful reconstruction
        pl = plTmp;

    // Try to convert entire ring into a circle
    int bIsCircle = convertToCircle(pl, _ptCen, _radius);
    if (bIsCircle)
    {
        // Create full circle, store in mapIO
        return 1;
    }

    // Loop through vertices to find arc segments
    for (int p = 0; p < pts.length(); p++)
    {
        Point3d pt1 = pts[p];
        Point3d pt2 = pts[p+1];
        Point3d ptm = (pt1 + pt2) * .5; // Chord midpoint

        double d12 = (pt1 - pt2).length();
        int bIsArc = d12>U(1) && (pl.closestPointTo(ptm) - ptm).length() > dEps;

        if (bIsArc)
        {
            // Reconstruct arc from two endpoints + midpoint
            // Calculate radius from circular segment formula
            double h = vecCen.length(); // Height of segment
            double s = (pt2 - pt1).length(); // Chord length
            double radius = (4*pow(h,2) + pow(s,2)) / (8*h);

            // Create arc, check deviation from original
            double deviation = (ptDev - ptmx).length();
            if (deviation > .5*shortestSeg) { continue; } // Reject poor fit

            // Store arc in mapIO
        }
    }
}
```
**Algorithm Steps**:
1. **Reconstruct Arcs**: Use PLine.reconstructArcs() to convert line-approximated curves back to true arcs
2. **Circle Detection**: Test if entire ring is a circle (within tolerance, allowing up to 3 vertices to fail)
3. **Arc Segment Extraction**: Loop through vertex pairs, detect arc segments using chord/midpoint geometry
4. **Circular Segment Formula**: Calculate radius from height and chord length
5. **Deviation Check**: Reject reconstructed arcs if they deviate >50% of shortest segment from original contour
6. **Lock System**: Prevent duplicate detection (plLocks array ensures tool arcs don't get re-detected as contour arcs)

**Curved Beam Style Support**:
```c
if (bm.bIsValid() && bm.vecY().isParallelTo(vecZMThis))
{
    String curvedStyle = bm.curvedStyle();
    CurvedStyle cStyle(curvedStyle);
    if (curvedStyle!=_kStraight && cStyle.bIsValid())
    {
        PLine plBase = cStyle.baseCurve();
        PLine plTop = cStyle.topCurve();
        // Transform to current coordinate system
        // Create contour from base + top curves
        ppShape.joinRing(plBase, _kAdd);
    }
}
```
**Special Handling**: For beams with curved styles (arched beams), the script extracts the curved profile directly from the CurvedStyle definition rather than relying on contour extraction.

---

### Caching System for Performance

To improve performance during grip dragging, the script implements a caching mechanism:

#### Cache Storage
```c
// Buffer data to speed up dragging
if (!bDrag)
{
    _Map.setMap("Arcs", mapArcs);
    _Map.setPoint3dArray("ptFaces", ptFaces);
    _Map.setInt("numContour", numContour);
    _Map.setInt("numOpening", numOpening);
}
```
**Stored Data**:
- **mapArcs**: Complete map of all detected arcs with metadata (center, radius, source entity, subtype)
- **ptFaces**: Array of face center points for all analyzed beams
- **numContour**: Count of contour arcs detected
- **numOpening**: Count of opening arcs detected

#### Cache Usage
```c
Map mapArcs;
if (_Map.hasMap("Arcs"))
    mapArcs = _Map.getMap("Arcs");
```
**Performance Benefit**: When dragging grips, arc detection is skipped and cached data is reused, providing smooth interactive feedback.

**Cache Invalidation**: Cache is rebuilt when:
- Properties change (Dimension Mode, Tool Set, etc.)
- Referenced entities change (beam moved, tool added/removed)
- Grip drag ends (bOnDragEnd = true triggers recalculation)

---

### Format Variable System

The script implements a powerful format variable system for custom dimension text:

#### Format Variable Evaluation
```c
// Text
Entity entFormat = entDefine;
if (tent.bIsValid())
    entFormat = tent;

sFormat.setDefinesFormatting(entFormat, mapAdd);
String text = entFormat.formatObject(format, mapAdd);
text = text.trimLeft().trimRight();
```

**Process**:
1. **Entity Selection**: Use the tool entity (drill/mortise) if available, otherwise use the defining entity (Element/Multipage)
2. **Metadata Population**: mapAdd contains available format variables (Radius, Diameter, Depth, Angle, etc.)
3. **Format Evaluation**: Call `formatObject()` to replace `@(Variable:Format)` with actual values
4. **Cleanup**: Trim whitespace

#### Available Metadata Sources

**From Arc Geometry**:
```c
Map mapAdd;
mapAdd.setDouble("Radius", dRadius, _kLength);
mapAdd.setDouble("Diameter", 2*dRadius, _kLength);
mapAdd.setDouble("ArcLength", arc.length(), _kLength);
```

**From Tool Metadata** (if arc is from a drill or mortise):
```c
if (mapTool.length()>0)
{
    mapParams.setDouble("Radius", mapTool.getDouble("Radius"), _kLength);
    mapParams.setDouble("Depth", mapTool.getDouble("Depth"), _kLength);
    mapParams.setDouble("Angle", mapTool.getDouble("Angle"), _kAngle);
    mapParams.setDouble("Bevel", mapTool.getDouble("Bevel"), _kAngle);
    mapParams.setDouble("Twist", mapTool.getDouble("Twist"), _kAngle);
}
```

**Result**: Format variables like `@(Depth:RL0)` work only when the arc is from a drill (which has depth metadata), returning empty otherwise.

#### Arc Length Auto-Detection
```c
if (!bGetArcLength && !isClosed && (sMode == tAutomatic || sMode==tArcMeasure) && tent.bIsKindOf(GenBeam()))
{
    format.trimLeft().trimRight();
    if (format.length() < 1)
        format = "@(ArcLength:RL1)";

    if (format.find("@(ArcLength", 0, false) >- 1)
        format = kArcLengthSymbol + "@(ArcLength:RL0) " + format;

    bGetArcLength = true;
}
```
**Logic**: If format contains `@(ArcLength`, the dimension automatically switches to Arc Measure mode and prepends the arc length symbol (ᴖ).

---

### Grip System

The script implements three grip types with intelligent behavior:

#### Location Grip (Yellow Circle)
```c
if (!bDrag && nGripLoc<0)
{
    Grip gp;
    gp.setPtLoc(ptLoc);
    gp.setName(kGripLoc);
    gp.setColor(40); // Yellow
    gp.setShapeType(_kGSTCircle);
    gp.setIsRelativeToEcs(false);
    gp.setVecX(vecX); gp.setVecY(vecY);
    gp.addHideDirection(vecX); // Hide when viewing from X
    gp.addHideDirection(-vecX);
    gp.addHideDirection(vecY);
    gp.addHideDirection(-vecY);
    gp.setToolTip(T("|Moves location of the dimension|"));
    _Grip.append(gp);
}
```
**Behavior**:
- **Drag Along Arc**: Moves dimension around same arc
- **Drag to Different Arc**: Snaps to nearest arc, updates dimension
- **Arc Switching Logic**: Detects `CurrentIndex` change, resets leader length to 0

#### Leader Grip (Color-Changing Circle)
```c
if (bOnDragEnd && indexOfMovedGrip == nGripLeader)
{
    Grip& gp = _Grip[nGripLeader];
    double d = (gp.ptLoc() - ptLoc).length();

    if (d > textHeight)
    {
        ptLeader = gp.ptLoc();
        dLeaderLength.set(d);
        gp.setColor(150); // Blue (active)
    }
    else
    {
        dLeaderLength.set(0);
        ptLeader = ptLoc + vecArc * textHeight;
        gp.setPtLoc(ptLeader);
        gp.setColor(252); // Gray (inactive)
    }
}
```
**Behavior**:
- **Color Indicates State**: Gray (252) = inactive, Blue (150) = active
- **Threshold**: textHeight distance; closer = deactivate, farther = activate
- **Leader Direction**: Always radial (along ptCen → ptLoc line)
- **Arc Length Interaction**: For arc measure dimensions, script checks if leader would intersect arc and auto-deactivates if needed

#### Arc Length Grip (Arc Measure Mode Only)
```c
if (!bDrag && nGripArcLength<0 && bGetArcLength)
{
    Grip gp;
    Point3d pt = _Map.hasPoint3d("ptArc") ? _Map.getPoint3d("ptArc") : ptLoc + vecArc * textHeight;
    gp.setPtLoc(pt);
    gp.setName(kGripArcLength);
    gp.setColor(150);
    gp.setShapeType(_kGSTCircle);
    // ... hide directions ...
    _Grip.append(gp);
}

// Auto-remove if mode changes
if (!bDrag && !bGetArcLength && nGripArcLength>-1)
{
    _Grip.removeAt(nGripArcLength);
    setExecutionLoops(2);
    return;
}
```
**Behavior**:
- **Appears**: Only when dimensioning open arcs in Arc Measure mode
- **Purpose**: Allows fine-tuning angular dimension text position along arc
- **Auto-Remove**: Grip automatically removed if user switches to Radial/Diametric mode

#### Grip Persistence During Multipage Movement
```c
Vector3d vecOrg = ptOrg - _Pt0;
if (!vecOrg.bIsZeroLength() && !bDrag && !_bOnInsert)
{
    _Pt0.transformBy(vecOrg);
    for (int g=0;g<_Grip.length();g++)
    {
        Point3d pt = _Grip[g].ptLoc();
        pt.transformBy(vecOrg);
        _Grip[g].setPtLoc(pt);
    }
    setExecutionLoops(2);
    return;
}
```
**Logic**: When a Multipage or Element moves, the script detects the offset and transforms all grips accordingly, maintaining their relative positions.

---

### Settings File System

#### XML File Structure
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <map nm="GeneralMapObject">
    <int nm="Version" vl="3"/>
  </map>
  <map nm="GlobalSettings">
    <int nm="GroupAssignment" vl="0"/>
  </map>
  <int nm="PainterManagementMode" vl="0"/>
  <lst nm="Configuration[]">
    <lst nm="MyConfiguration">
      <str nm="DimMode" vl="Automatic"/>
      <str nm="Text" vl="<>"/>
      <str nm="Dimstyle" vl="Standard"/>
      <str nm="ToolSet" vl="All"/>
      <str nm="Distribution" vl="One by Radius"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

#### File Locations (Priority Order)
1. **Company Path**: `%hsbCAD%\Company\TSL\Settings\DimRadial.xml`
2. **Installation Path**: `%hsbCAD%\Content\General\TSL\Settings\DimRadial.xml`

#### MapObject Persistence
```c
MapObject mo(sDictionary, sFileName);
if (mo.bIsValid())
{
    mapSetting = mo.map();
    setDependencyOnDictObject(mo);
}
else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())
{
    String sFile = findFile(sFullPath);
    if (sFile.length() < 1) sFile = findFile(sPathGeneral + sFileName + ".xml");
    if (sFile.length() > 0)
    {
        mapSetting.readFromXmlFile(sFile);
        mo.dbCreate(mapSetting);
    }
}
```
**Logic**:
- **First Insertion**: Reads XML from disk, creates MapObject in drawing dictionary
- **Subsequent Uses**: Reads from MapObject (faster, no file I/O)
- **Dependency**: Script registers dependency on MapObject for automatic recalculation

#### Version Validation
```c
if (_bOnDbCreated)
{
    int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
    Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);
    int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");

    if (sFile.length()>0 && nVersion != nVersionInstall)
        reportNotice(TN("|A different Version of the settings has been found for|") + scriptName() +
                     TN("|Current Version| ") + nVersion + " " + TN("|Other Version| ") + nVersionInstall);
}
```
**Behavior**: On first insertion, if drawing's cached settings version differs from installation XML version, a notification is displayed to the command line (not blocking).

---

### Painter Management System

#### Three Painter Modes

**Mode 0: Default (Folder Restriction)**
```c
nPainterManagementMode = 0
sPainterCollection = "Dimension\\"

for (int i=0; i<sAllPainters.length(); i++)
{
    int bAdd = sAllPainters[i].find(sPainterCollection, 0, false) == 0;
    if (bAdd) sPainters.append(name);
}
```
**Behavior**: Only painters inside "Dimension\\" folder are listed. Promotes organization.

**Mode 1: Instance Override (All Painters for This Dimension)**
```c
nPainterManagementMode = 1
_Map.setInt(kPainterManagementMode, nPainterManagementMode);
```
**Behavior**: This specific dimension instance can use any painter, but other instances still respect folder restriction. Stored in instance `_Map` (not global settings).

**Mode 2: Global Override (All Painters for Any Dimension)**
```c
nPainterManagementMode = 2
mapSetting.setInt(kPainterManagementMode, nPainterManagementMode);
mo.setMap(mapSetting);
```
**Behavior**: All DimRadial instances in the drawing can use any painter. Stored in MapObject (global).

#### Configuration via Context Menu
```c
String sTriggerPainterManagement = T("|Painter Management|");
addRecalcTrigger(_kContext, sTriggerPainterManagement);

if (_bOnRecalc && _kExecuteKey == sTriggerPainterManagement)
{
    Map mapIn, mapItems;
    String sPMOptions[] = {
        T("|Only Painter Definitions inside folder|"),
        T("|All Painter Definitions for this dimension|"),
        T("|All Painter Definitions for any dimension|")
    };

    // Show radio button dialog
    Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);
    nPainterManagementMode = sPMOptions.findNoCase(value, -1);

    // Store in appropriate location
    if (nPainterManagementMode == 1)
        _Map.setInt(kPainterManagementMode, nPainterManagementMode);
    else
    {
        mapSetting.setInt(kPainterManagementMode, nPainterManagementMode);
        mo.setMap(mapSetting);
    }
}
```

---

## Context Menu Commands

### Define Tool Sets
**Function**: Opens multi-selection dialog to configure which tool types contribute arcs

**Dialog Content**:
- Lists all detected tool types with count in parentheses: `Drill, perpendicular (15)`
- Checkbox list allows multiple selections
- Selected items stored as semicolon-separated string in `sToolSet` property

**Use Cases**:
- Dimension only drill holes → deselect Contour and Opening
- Dimension only beam shape → select only Contour
- Exclude specific drill types → deselect unwanted drill categories

### Define TSL/Parent Tool Sets
**Function**: Opens multi-selection dialog to filter arcs by creating TSL script or entity type

**Dialog Content**:
- Lists all TSL script names found in the drawing
- Lists all supported entity tool types (e.g., ACAD_DRILL, MetalPart)
- Includes tooltip descriptions for each entry
- Selected items stored in `sStereotype` property

**Use Cases**:
- Dimension only manual drills → select "FreeDrill" script
- Exclude auto-generated holes → deselect "DrillDistribution"
- Hardware-specific → select only connector-related scripts

### Painter Management
**Function**: Configures painter folder restriction behavior

**Options**:
1. **Only Painter Definitions inside folder**: Default mode, uses "Dimension\\" folder
2. **All Painter Definitions for this dimension**: Instance-level override
3. **All Painter Definitions for any dimension**: Global override

**Tooltips**:
- Mode 0: "A folder with certain painter definitions will be created. (Dimension\) Any painter outside of the folder will be ignored."
- Mode 1: "This dimension will allow any painter definition."
- Mode 2: "Any painter definition will be accepted."

### Import Settings
**Function**: Reads DimRadial.xml from company or installation path and applies to drawing

**Behavior**:
```c
mapSetting.readFromXmlFile(sFullPath);
if (mapSetting.length() > 0)
{
    if (mo.bIsValid()) mo.setMap(mapSetting);
    else mo.dbCreate(mapSetting);
    reportMessage(TN("|Settings successfully imported from| ") + sFullPath);
}
```
**Result**: MapObject updated with imported settings, all DimRadial instances use new configuration

### Export Settings
**Function**: Writes current MapObject settings to DimRadial.xml file

**Confirmation**:
```c
if (findFile(sFullPath).length() > 0)
{
    String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [N/Y]");
    bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
}
```
**Behavior**:
- Prompts for confirmation if file exists
- Creates Settings folder if missing: `makeFolder(sPath + "\\" + sFolder)`
- Writes XML file
- Reports success or failure

### Add Viewport *(Block Space Mode Only)*
**Function**: Associates additional ShopDrawViews with this block space setup

**Prompt**: _"Select additional Shop Drawing Viewports"_

**Behavior**:
- User clicks additional ShopDrawView entities
- Script stores references and updates visual guide lines
- During shop drawing regeneration, all associated viewports receive dimensions

### Remove Viewport *(Block Space Mode Only, Multiple Viewports)*
**Function**: Disassociates ShopDrawViews from this block space setup

**Availability**: Only available when more than one viewport is assigned

**Prompt**: _"Select Shop Drawing Viewports to disassociate"_

**Behavior**:
- User clicks viewports to remove
- Script removes references and updates visual display

---

## Visual Jig System

### Jig 1: Viewport Selection (Multipage)
**Trigger**: When Multipage is selected as reference entity and has multiple views

**Purpose**: Visual selection of which Multipage viewport to dimension

**Display**:
```c
PlaneProfile pps[0];
for (int i=0; i<_Map.length(); i++)
    if (_Map.hasPlaneProfile(i))
        pps.append(_Map.getPlaneProfile(i));

Display dp(-1);
drawArcs(pps, ptJig, dp);
```
**Visual Elements**:
- All viewport boundaries highlighted as PlaneProfiles
- Closest viewport to cursor highlighted in yellow
- Other viewports in light blue

**Input**: Click inside desired viewport

**Result**: Script records view direction (vecModelView) for arc projection

### Jig 2: Arc Selection and Placement
**Trigger**: During dimension placement (kJigInsert)

**Purpose**: Visual selection of which arc to dimension with live preview

**Display**:
```c
PLine arcs[0]; // All detected arcs
PlaneProfile pps[] = createArcProfiles(arcs, pn);

Display dp(-1);
drawArcs(pps, ptJig, dp); // Highlights arcs

int cur = findClosestArc(arcs, ptJig, vecZ);
if (cur >- 1)
{
    PLine arc = arcs[cur];
    Point3d ptLoc = arc.closestPointTo(ptJig);
    Point3d ptCen = ptCens[cur];

    drawDim(ptLoc, ptCen, arc, mapParams); // Live dimension preview
}
```

**Visual Elements**:
- **All arcs**: Light blue filled shapes (transparency 50)
- **Closest arc**: Yellow filled shape (transparency 0)
- **Dimension preview**: Full dimension annotation following cursor

**Interaction**:
- **Move cursor**: Closest arc updates in real-time
- **Type keyword** at command line:
  - `R` → Switch to Radial mode
  - `D` → Switch to Diametric mode
  - `M` → Switch to Arc Measure mode
  - `A` → Switch to Automatic mode
- **Click**: Place dimension on highlighted arc, jig continues
- **ESC or Right Click**: Exit jig, erase setup instance, keep placed dimensions

**Performance Optimization**: Arc detection runs once before jig starts, cached in mapArcs for fast jig response

---

## Shop Drawing Automation

### Block Space Setup Mode

#### Detection Logic
```c
int bIsBlockSpaceSetup = false;

ShopDrawView sdv = (ShopDrawView)e;
if (sdv.bIsValid())
{
    bHasSDV = true;
    sdvs.append(sdv);

    if (_bOnInsert)
    {
        _Pt0 = getPoint(T("|Pick location for setup graphics|"));
        return;
    }
}
```
**Behavior**:
- When user selects ShopDrawView and clicks location point, script stores _Pt0 and returns
- On subsequent recalculations, script enters block space preview mode

#### Setup Graphics Display
```c
if (bIsBlockSpaceSetup || bHasSDV)
{
    // Draw schematic preview
    Display dp(grey);
    dp.draw(scriptName(), _Pt0, _XU, _YU, 1, 0);

    // Draw guide lines to viewports
    for (int i=0; i<sdvs.length(); i++)
    {
        Point3d ptSDV = sdvs[i].coordSys().ptOrg();
        PLine guide(_Pt0, ptSDV);
        dp.color(blue);
        dp.draw(guide);
    }

    return; // Don't generate actual dimensions in setup mode
}
```
**Display**:
- Script name label at _Pt0
- Blue guide lines connecting _Pt0 to each associated ShopDrawView origin
- No actual dimension annotations (preview only)

### Regeneration Trigger

#### Shop Drawing Batch Processing
During shop drawing regeneration (via command `hsb_RecalcTslWithKey`):

```c
// Trigger: |Regenerate Shopdrawing|
// Script key: _kExecuteKey

// Script automatically:
// 1. Detects all arcs in each ShopDrawView based on Tool Set filter
// 2. Applies Distribution rules (All, One by Source, One by Radius)
// 3. Creates individual DimRadial instances for selected arcs
// 4. Positions dimensions automatically
```

#### Distribution Implementation

**All Mode**:
```c
// Every detected arc gets a dimension
for (int i=0; i<mapArcs.length(); i++)
{
    Map m = mapArcs.getMap(i);
    TslInst dim; dim.dbCreate("DimRadial");
    // Configure and place dimension
}
```

**One by Source Mode**:
```c
String processedSources[0];
for (int i=0; i<mapArcs.length(); i++)
{
    Map m = mapArcs.getMap(i);
    Entity source = m.getEntity("tent");
    String uid = source.handle();

    if (processedSources.find(uid) >- 1) continue; // Skip if already dimensioned
    processedSources.append(uid);

    // Create dimension for first arc from this source
}
```

**One by Radius Mode** (Default):
```c
double processedRadii[0];
for (int i=0; i<mapArcs.length(); i++)
{
    Map m = mapArcs.getMap(i);
    double radius = m.getDouble("radius");

    if (processedRadii.find(radius) >- 1) continue; // Skip if radius already dimensioned
    processedRadii.append(radius);

    // Create dimension for first occurrence of this radius
}
```

---

## Tips and Best Practices

### Performance Optimization
- **Large Assemblies**: Use painter filtering to limit analysis to specific beam types
- **Complex Contours**: If arc detection is slow, use "Define Tool Sets" to exclude Contour and focus on tooling only
- **Grip Dragging**: The caching system ensures smooth dragging, but recalculation occurs on drag end
- **Shop Drawings**: Use "One by Radius" distribution to minimize dimension instance count (faster regeneration)

### Dimension Clarity
- **Leader Usage**: Drag Leader Grip when dimension text overlaps with other annotations
- **Tool Set Filtering**: For CNC sheets, dimension only drills and mortises (exclude contour)
- **Text Customization**: Use `@(Radius:RL0) @(Depth:RL0)` format for "50x65" style annotations
- **Color Coding**: Use Color property to distinguish dimension types (e.g., Blue for reference, Red for critical)

### Project Standardization
1. **Create Company DimRadial.xml**: Configure once with standard settings
2. **Define Standard Painters**: Create "Dimension\\Studs", "Dimension\\Plates" etc. in painter definitions
3. **Configure DimStyle Family**: Create ShopDim, ShopDim$3, ShopDim$4 with company standards
4. **Export Settings**: Use "Export Settings" to save to company path
5. **Team Adoption**: Colleagues use "Import Settings" to adopt standards

### Block Space Workflow
- **Separate Setups for Different Views**: Create multiple block space setups with different Tool Set configurations for different shop drawing types
- **Test Before Batch**: Place a few manual dimensions first to verify Dimstyle and format settings
- **Distribution Choice**: Use "One by Radius" for clean shop drawings, "All" only for verification/debugging

### Painter Filtering Strategy
- **Zone-Based**: Create painters for "Wall Zone A", "Wall Zone B" to control which wall sections get dimensioned
- **Material-Based**: Create painter for "2x6 Studs" to dimension only studs, ignoring plates and blocking
- **Size-Based**: Use painter with width/height filters to dimension only specific hole sizes

### Troubleshooting Arc Detection
- **Missing Arcs**: Check Face setting (try "Any Viewing Side")
- **Too Many Arcs**: Use "Define Tool Sets" to restrict sources
- **Duplicate Dimensions**: Ensure no tool set overlap (e.g., don't select both "Drill, perpendicular" and "All")
- **Segmented Contours**: The reconstructArcs() algorithm handles most cases, but very tight arcs (radius < 1mm) may be missed

---

## Common Workflows

### Workflow 1: Dimension All Drill Holes on a Wall
1. Insert DimRadial
2. Set Dimension Mode = Automatic
3. Select the wall Element
4. Right-click → "Define Tool Sets"
5. Deselect Contour and Opening
6. Select all Drill types
7. Click OK
8. Pick location on first drill hole
9. Continue clicking other holes (or ESC to exit after first)

### Workflow 2: Create Shop Drawing with Consistent Dimensioning
1. In Model Space, create ShopDrawViews for all walls
2. Insert DimRadial → select first ShopDrawView
3. Click location for setup graphics
4. Right-click → "Define Tool Sets" → select desired tools
5. Set Distribution = "One by Radius"
6. Set Text format = `@(Radius:RL0)` (or desired format)
7. Right-click → "Add Viewport" → select remaining ShopDrawViews
8. Right-click → "Export Settings" (saves configuration)
9. Run shop drawing regeneration command → dimensions auto-generate

### Workflow 3: Dimension Mortise Corner Radii
1. Insert DimRadial
2. Set Dimension Mode = Radial
3. Set Text = `R@(Radius:RL1) Corner`
4. Select beam with mortises
5. Right-click → "Define Tool Sets"
6. Deselect all except Mortise types
7. Click OK
8. Pick location on mortise corner arc

### Workflow 4: Multi-View Dimension on Multipage
1. Insert DimRadial
2. Select Multipage entity
3. Visual jig shows all viewports → click inside desired viewport (e.g., front view)
4. Arc selection jig activates → click arcs to dimension
5. Move Multipage → dimensions automatically reposition

---

## Technical Notes

### Coordinate System Transformations
- **Model Space → Paper Space**: Uses viewport's `ms2ps` CoordSys or Multipage's `modelToView()` transformation
- **Section**: Uses `section.modelToSection()` transformation
- **Face Projection**: Arc centers projected using `Line(ptStart, vecZ).hasIntersection(Plane(ptOrg, vecZ), ptStart)`

### Precision and Tolerance
- **dEps**: U(.1) = 0.1mm tolerance for arc detection
- **Circle Detection**: Allows up to 3 vertices to fail distance-to-center test
- **Deviation Check**: Arc reconstruction rejected if deviation > 50% of shortest segment
- **Perpendicularity**: Accepts slight tolerance (dotProduct < 0.01 for perpendicular check)

### Dependencies
- **TslUtilities.dll**: Required for all dialog services (SelectFromList, SelectOption, GetText, etc.)
- **MapObject**: Persistent storage in drawing dictionary for settings caching
- **PainterDefinition**: Optional dependency for entity filtering

### Script Performance
- **Arc Detection**: O(n×m) where n = number of beams, m = average tools per beam
- **Caching**: Reduces recalculation during grip dragging to O(1) for arc lookup
- **Shop Drawing Generation**: O(k×n×m) where k = number of setup instances

### Known Limitations
- **XRef Support**: Metalparts from XRef drawings supported as of v3.4, but general XRef beam support may be limited
- **Curved Style Requirement**: Curved beam styles must be properly defined in CurvedStyle object
- **Segmented Arc Limit**: Very tight radius arcs (< 1mm) on coarsely segmented contours may not be detected
- **Through-Hole Detection**: Relies on comparing drill depth to beam depth (tolerance = dEps)

---

## Related Scripts

### Dimensioning Tools
- **Dimline**: Linear dimensions for beam lengths, offsets, and spacing
- **DrillPatternDimension**: Specialized dimensioning for drill patterns and distributions
- **hsbViewDimension**: Viewport-based automatic dimensioning system
- **hsbFloorPlanDimension**: Floor plan layout dimensioning

### Shop Drawing Tools
- **MultipageController**: Parent script for multi-view shop drawing generation
- **MultipageAnchor**: Anchor points for Multipage layout
- **NA_WALL_SHOP_DRAWING**: North American wall shop drawing automation
- **sd_ABeamcutDE**: German shop drawing automation (beamcut)
- **sd_TslDimRequest**: Dimension request system for shop drawings

### Tooling Scripts (Arc Sources)
- **FreeDrill**: Manual drill placement (creates AnalysedDrill arcs)
- **DrillDistribution**: Automatic drill distribution (creates multiple arcs)
- **hsbCLT-Drill**: CLT panel drill placement
- **AnalysedMortise**: Mortise operations (creates corner radius arcs)
- **hsbCLT-Opening**: CLT panel openings (creates opening arcs)

### Configuration Tools
- **PainterDefinition**: Entity filtering system
- **hsb_Painter**: Painter management utilities
- **CurvedStyle**: Curved beam profile definition

---

## Appendix: Format Variable Reference

### Complete Format Code Reference

| Code | Meaning | Example Input | Example Output |
|------|---------|---------------|----------------|
| R | Real number | 50.123 | 50.123 |
| RL | Real with length unit | 50.123mm | 50.123 |
| RL0 | Real, length, 0 decimals | 50.789mm | 51 |
| RL1 | Real, length, 1 decimal | 50.123mm | 50.1 |
| RL2 | Real, length, 2 decimals | 50.123mm | 50.12 |
| RN | Real, no unit | 45.678° | 45.678 |
| RN0 | Real, no unit, 0 decimals | 45.678° | 46 |
| I | Integer | 5.7 | 5 |

### Variable Availability by Source

| Variable | Drill | Mortise | Contour | Opening | Notes |
|----------|-------|---------|---------|---------|-------|
| Radius | ✓ | ✓ | ✓ | ✓ | Always available |
| Diameter | ✓ | ✓ | ✓ | ✓ | Always available (2×Radius) |
| ArcLength | ✓ | ✓ | ✓ | ✓ | Open arcs only |
| CoordX | ✓ | ✓ | ✓ | ✓ | Arc center X-coordinate |
| CoordY | ✓ | ✓ | ✓ | ✓ | Arc center Y-coordinate |
| Depth | ✓ | ✓ | - | - | Tool depth/penetration |
| Angle | ✓ | ✓ | - | - | Tool rotation angle |
| Bevel | ✓ | ✓ | - | - | Tool bevel angle |
| Twist | - | ✓ | - | - | Mortise twist (beam end connections) |

### Example Format Combinations

```
Format String                          Output Example              Use Case
─────────────────────────────────────────────────────────────────────────────────────
<>                                   → R50                        Standard DimStyle
R@(Radius:RL0)                       → R50                        Explicit radius
Ø@(Diameter:RL1)                     → Ø100.0                     Diameter with precision
Ø@(Diameter:RL0) DRILL               → Ø20 DRILL                  Labeled hole
@(Radius:RL0)x@(Depth:RL0)           → 10x65                      Radius × depth notation
HOLE Ø@(Diameter:RL0)mm DEEP @(Depth:RL0)mm → HOLE Ø20mm DEEP 65mm     Full description
R@(Radius:RL1) @ @(CoordX:RL0),@(CoordY:RL0) → R50.5 @ 1200,800    Radius with coordinates
@(ArcLength:RL1)                     → 157.1                      Arc length only (auto-adds ᴖ)
ᴖ@(ArcLength:RL0)mm                  → ᴖ157mm                     Arc length with unit label
```

---

## Version: 3.4 | Author: Thorsten Huck | Last Updated: December 2, 2024
