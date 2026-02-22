# DrillDistribution

## Overview

**DrillDistribution** is a comprehensive TSL tool designed to create intelligent drill hole distributions on timber elements based on various geometric references including beam intersections, polylines, grip points, or circular patterns. This tool represents one of the most sophisticated manufacturing preparation utilities in hsbCAD, combining automated distribution logic with extensive customization options for complex fabrication scenarios.

The tool excels at creating parametric drill patterns that automatically update when associated elements change, making it ideal for production workflows where design modifications are frequent. It supports advanced machining features including countersinks, cone drills, slotted holes, and fastener assembly integration with automatic length calculation based on material stacks.

**Version:** 5.10 (October 2025)
**Authors:** Thorsten Huck, Marsel Nakuci
**Category:** Manufacturing/Drilling

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Environment** | Model Space |
| **Required Beams** | 0 (selection-based) |
| **File State** | 1 (Active) |
| **DXA Output** | Enabled |
| **Keywords** | Drill, Distribution, Beam, Sheet, Panel, CLT |
| **Major Version** | 5 |
| **Minor Version** | 10 |

### Supported Geometry Types

- **GenBeam** (all types): Beams, Posts, Studs, Joists
- **Sheet**: OSB, Plywood, Gypsum panels
- **Panel**: CLT panels, SIP panels
- **Element**: Complete walls, floors, roofs
- **Definition Sources**: Polylines, Circles, Grip Points, Beam Intersections

---

## Core Capabilities

### 1. Distribution Strategies

The tool offers multiple intelligent distribution strategies, each optimized for specific use cases:

#### Default Strategy
- Manual path definition through point selection or polyline references
- Maximum flexibility for custom drill patterns
- Supports all distribution modes (Fixed, Even, Vertex, Circles)
- Best for: One-off custom patterns, facade details, irregular spacing

#### Beam Axis Strategy
- Distributes drills along the longitudinal axis of selected beams
- Automatically detects beam orientation and length
- Supports multi-row distributions with custom offsets
- Best for: Lap joints, reinforcement plates, beam-to-beam connections

#### Crossing Beams Strategy
- Places drills at intersection points where beams cross
- Calculates exact 3D intersection geometry
- Filters intersections based on angle and proximity tolerance
- Best for: Cross-bracing connections, grid structures, truss node connections

#### Element Perpendicular Facing Strategy
- Distributes drills perpendicular to element face directions
- Supports facade contour patterns and contact perimeter distributions
- Automatically adjusts to element coordinate systems
- Best for: Facade connections, shear wall fastening, panel-to-structure anchoring

### 2. Distribution Modes

Each strategy supports multiple distribution calculation methods:

**Fixed Spacing Mode**
- Constant interdistance between drill holes
- User specifies exact spacing dimension
- Distribution starts from path start point with optional offset
- Terminates when path end is reached

**Even Spacing Mode**
- Distributes specified quantity of drills evenly along path
- Automatically calculates optimal spacing
- Ensures equal distribution regardless of path length
- Useful when drill count is more critical than spacing

**Vertex Points Mode**
- Places drill at every vertex of the defining polyline
- Ignores interdistance parameter
- Perfect for matching existing geometry points
- Supports complex non-uniform patterns

**Circles Mode**
- Uses circle entities to define drill locations and diameters
- Each circle center becomes a drill location
- Circle diameter overrides the global diameter setting
- Ideal for importing drill patterns from external sources

### 3. Advanced Tooling Features

#### Sinkhole Configuration
- **Cylindrical Sinkholes**: Flat-bottom countersinks with specified diameter and depth
- **Conical Sinkholes**: Angled countersinks defined by cone angle (automatically calculates depth)
- **Dual-Sided Sinkholes**: Independent sinkhole configurations for entry and exit faces
- **Relative Depth Mode**: Maintains constant depth differential when main drill depth changes
- **Diameter Locking**: Prevents accidental sinkhole diameter changes in production environments

#### Slotted Holes
- Creates elongated holes with rounded ends
- Independent control of slot length and width
- Exports as Mortise tool when cone angle is not specified
- Supports beveled and rotated orientations
- Tool index assignment for CNC programming

#### Drill Orientation Control
- **Bevel**: Angle relative to selected face (-90° to +90°)
- **Rotation**: Perpendicular twist of drill axis (-90° to +90°)
- **Face Selection**: Bottom face or top face entry
- **Justification**: Left, Center, or Right relative to path polyline
- **Justification Offset**: Additional perpendicular offset from justified position

### 4. Fastener Assembly Integration

The tool seamlessly integrates with hsbCAD's FastenerAssembly system:

**Automatic Features:**
- Creates FastenerAssembly entities at each drill location
- Calculates stack length by analyzing material layers at drill axis
- Filters compatible fastener styles by diameter
- Suggests appropriate fastener lengths based on penetration depth
- Applies offset transformations (X, Y, Z) for eccentric fastener placement

**Manual Overrides:**
- Force specific fastener length (overrides automatic calculation)
- Filter fastener styles by diameter relationship (equal, smaller, larger)
- Assign custom article numbers from manufacturer catalogs
- Apply thread length specifications for partially threaded fasteners

### 5. Obstacle Avoidance

Intelligent drill placement exclusion system:

- Add any entity as an "obstacle" (beams, openings, existing drills)
- Distribution algorithm automatically skips drill locations that would intersect obstacles
- Visual preview shows rejected drill locations
- Tool instance is automatically erased if all drill locations are invalidated by obstacles
- Useful for avoiding window/door openings, electrical boxes, structural features

---

## Prerequisites

### Essential Requirements

1. **Geometry Targets**
   - At least one GenBeam, Sheet, Panel, or Element to receive drills
   - Target geometry must have valid solid representation (envelope or real body)

2. **Path Definition** (Strategy-dependent)
   - **Default**: Polylines, grip points, or manual point selection
   - **Beam Axis**: Reference beams with valid axis geometry
   - **Crossing Beams**: Two sets of beams with actual 3D intersections
   - **Element Facing**: Complete Element entities (walls, floors, roofs)

3. **Coordinate System**
   - Drawing units must be defined (mm or inches)
   - UCS should be aligned with primary construction plane for predictable results

### Optional Enhancements

4. **Tool Definitions**
   - Pre-configured drill presets stored in `TSL\Settings\DrillDistribution.xml`
   - Company-specific or project-specific standardized drill patterns
   - Import via right-click menu > Import Settings

5. **Fastener Library**
   - FastenerAssemblyDef entries for automatic fastener assignment
   - Manufacturer catalogs (Simpson, Rothoblaas, Hilti, etc.)
   - Article number databases for length selection

6. **Painter Definitions**
   - Custom selection filters in folder `TSL\DrillDistribution\`
   - Painter types: GenBeam subsets for Reference and Contact filters
   - Enables rapid selection in complex assemblies

---

## Properties Reference

### Selection Category

Controls which geometry the tool operates on and distribution strategy.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Strategy** | PropString(9) | Default | Default, Beam Axis, Crossing Beams, Element Perpendicular Facing | Defines the overall distribution calculation method. Controls which secondary properties are shown/hidden. |
| **Reference Filter** | PropString(7) | (auto) | Painter definitions in TSL\DrillDistribution\ | Specifies object filter for main reference selection using Painter system. Restricts selection to specific GenBeam types. |
| **Contact Filter** | PropString(8) | (auto) | Painter definitions | Specifies object filter for secondary contact references. Used in Crossing Beams and dual-selection strategies. |

**Business Logic:**
- Strategy property controls visibility of other category properties (e.g., Beam Axis shows Row properties but hides Sheet Offsets)
- Filters are only active during insertion phase or when debug mode enabled
- Filter selections persist across script executions for workflow efficiency

---

### Tool Category

Manages reusable tool definition presets and sinkhole behavior modes.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Tool Definition** | PropString(4) | Default | Custom presets from settings file | Selects a predefined configuration that overrides all drill/sink/distribution properties. Hidden if no custom presets exist. |
| **Mode** | PropString(5) | Default | Default, Relative Depth, Relative Depth + Sink Diameter Locked | Controls relationship between sinkhole and main drill depth. Relative modes maintain constant depth differential during recalculation. |

**Business Logic:**
- Tool definitions store complete parameter sets (diameter, depth, sink, distribution, alignment)
- "Relative Depth" mode: if main depth changes from 50mm to 60mm, sink depth automatically adjusts by +10mm
- "Diameter Locked" prevents accidental changes to critical sink dimensions in production templates
- Tool presets support MapX export key/value pairs for integration with CNC post-processors

---

### Drill Category

Core drilling parameters for the main hole geometry.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Diameter** | PropDouble(0) | U(12) mm | > 0 | Main drill hole diameter. Controls fastener style filtering when Fastener category is enabled. |
| **Depth** | PropDouble(1) | U(0) mm | ≥ 0 | Drill penetration depth. **0 = complete through-hole** (automatic depth calculation based on material thickness). |

**Business Logic:**
- Diameter change triggers fastener style list refresh (shows compatible fastener diameters)
- Depth = 0 is special: tool calculates maximum penetration by intersecting drill axis with genbeam envelope body
- For beveled drills with depth = 0, exit point is calculated by ray-casting through solid geometry
- Slotted holes use Diameter for the rounded end radius (actual slot width/length set in Slotted Hole category)

---

### Fastener Category

Integrates drill distribution with fastener assembly management system.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Fastener Style** | PropString(6) | Disabled | FastenerAssemblyDef names + filter options | Selects fastener definition to create FastenerAssembly entities at each drill location. Dropdown shows diameter-compatible styles only. |
| **Length** | PropDouble(16) | 0 (auto) | 0 or enumerated lengths from catalog | Fastener length. **0 = automatic calculation** based on material stack at drill axis. Manual override available for specific article numbers. |
| **Offset X** | PropDouble(13) | U(0) mm | Any | Fastener position offset in X direction relative to drill axis coordinate system. |
| **Offset Y** | PropDouble(14) | U(0) mm | Any | Fastener position offset in Y direction. Useful for eccentric fastener placement relative to drill location. |
| **Offset Z** | PropDouble(15) | U(0) mm | Any | Fastener position offset in Z direction (along drill axis). Negative values move fastener toward drill entry point. |

**Filter Options Embedded in Dropdown:**
- `<Show styles = Diameter>`: Exact diameter match only
- `<Show styles <= Diameter>`: Diameter equal or smaller (common for clearance holes)
- `<Show styles >= Diameter>`: Diameter equal or larger (less common, for pilot holes)
- `<Show all styles>`: Disable diameter filtering entirely

**Business Logic:**
- Style dropdown dynamically updates when Diameter changes
- Length = 0 triggers automatic stack analysis: tool ray-casts drill axis through all intersecting genbeams and sums material thicknesses
- Sinkhole depths are considered in automatic length calculation (reduces penetration depth)
- Simple fasteners only (woodscrews, bolts) - complex assemblies (washer+nut) excluded from this tool
- Fastener coordinate system inherits drill orientation (bevel + rotation)
- Offsets apply in local coordinate system of each drill location

---

### Sinkhole/ConeDrill Category

Configuration for entry-side countersink or cone drill operations.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Diameter Sink** | PropDouble(2) | U(0) mm | ≥ 0 | Sinkhole diameter. **0 = no sinkhole**. Must be larger than main drill diameter for functional countersink. |
| **Depth Sink** | PropDouble(3) | U(0) mm | ≥ 0 | Sinkhole depth from drill entry face. For conical sinks with Cone Angle > 0, this is cone tip depth. |
| **Cone Angle** | PropDouble(7) | U(0)° | 0-180° | Cone drill included angle. **0 = cylindrical sinkhole**. Common values: 90° (standard countersink), 82° (ISO flat head screw). |

**Calculation Logic:**
- Cylindrical sinkhole (Cone Angle = 0): Simple cylinder of Diameter Sink × Depth Sink
- Conical sinkhole (Cone Angle > 0): Cone geometry calculated from angle and diameter
  - Cone depth = (Diameter Sink - Diameter) / (2 × tan(Cone Angle/2))
  - Depth Sink specifies distance from face to cone tip apex
- If Diameter Sink = 0 but Depth Sink > 0: warning, no sink created (both must be > 0)
- Relative Depth mode: Depth Sink maintains constant offset from Depth when main drill depth changes

---

### Sinkhole/ConeDrill Opposite Side Category

Independent countersink configuration for drill exit face (opposite side).

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Diameter Sink Opposite Side** | PropDouble(10) | U(0) mm | ≥ 0 | Opposite face sinkhole diameter. Completely independent from entry-side sink. |
| **Depth Sink Opposite Side** | PropDouble(11) | U(0) mm | ≥ 0 | Opposite face sinkhole depth measured from exit face inward. |
| **Cone Angle Opposite Side** | PropDouble(12) | U(0)° | 0-180° | Opposite face cone angle. Allows different countersink geometry on exit side (e.g., burr prevention chamfer). |

**Use Cases:**
- **Burr Prevention**: Small exit chamfer (Diameter Sink Opposite = Diameter + 2mm, Depth = 1mm)
- **Through-Bolt Washers**: Larger exit countersink for washer clearance
- **Dual Fastener Heads**: Scenarios where fasteners are installed from both sides
- **Aesthetic Finishing**: Matching countersinks on visible surfaces

**Business Logic:**
- Completely independent calculation from entry-side sink
- Only created for through-holes (Depth = 0) or when Depth is sufficient to reach opposite face
- For beveled drills, "opposite side" is determined by drill axis direction (exit point calculation)

---

### Distribution Category

Controls how drill holes are spaced and distributed along the defined path.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Mode** | PropString(0) | Fixed | Fixed, Even, Vertex Points, Circles | Distribution calculation method. Fixed=constant spacing, Even=constant quantity, Vertex=at polyline vertices, Circles=from circle entities. |
| **Interdistance** | PropDouble(4) | U(1000) mm | > 0 | Distance between drill centers in Fixed mode. Ignored in Vertex and Circles modes. In Even mode, determines quantity indirectly. |
| **Rows** | PropInt(0) | 1 | ≥ 1 | Number of parallel distribution rows. Creates offset copies of the primary path. Hidden when using Contact Filter strategies. |
| **Row Offsets** | PropString(1) | "" | Semicolon-separated values | Custom offset distances for each row perpendicular to path. Format: "50;100;50" for 4 rows with custom spacing. Empty = equal spacing based on Rows. |
| **Column Offsets** | PropString(2) | "" | Semicolon-separated values | Custom offset distances for each column along path direction. Adds extra drill locations between regular distribution points. |
| **Distribution Offset** | PropDouble(23) | U(0) mm | Any | Initial offset distance from path start point before first drill. Positive values shift distribution away from start. |
| **Quantity** | PropInt(1) | (calculated) | Read-only | Displays total calculated number of drill holes. Updates automatically based on other parameters and obstacle exclusions. |

**Mode-Specific Behavior:**

**Fixed Mode:**
- Starts at Distribution Offset distance from path start
- Places drills at Interdistance spacing
- Last drill may be closer than Interdistance to path end (no padding)
- Quantity = floor((PathLength - Distribution Offset) / Interdistance) + 1

**Even Mode:**
- Distributes drills with equal spacing
- First drill at Distribution Offset, last drill at (PathLength - Distribution Offset)
- Calculated spacing = (PathLength - 2×Distribution Offset) / (Quantity - 1)
- Quantity derived from Interdistance as initial estimate, user can override

**Vertex Points Mode:**
- Ignores Interdistance completely (property hidden in UI)
- Places one drill at each polyline vertex
- Distribution Offset shifts entire pattern along path
- Quantity = number of polyline vertices

**Circles Mode:**
- Each selected circle becomes a drill location
- Circle center = drill position
- Circle diameter overrides global Diameter property (per-location sizing)
- Interdistance and Rows properties ignored

**Row/Column Offsets Syntax:**
- Format: "value1;value2;value3"
- Row Offsets: perpendicular to path direction (e.g., "50;100;50" creates 4 rows at 0mm, 50mm, 150mm, 200mm from path)
- Column Offsets: parallel to path direction, inserted between regular interdistance spacing
- Empty string = equal automatic spacing based on Rows parameter
- If fewer offset values than Rows, remaining rows use last specified offset repeatedly

---

### Contour Offsets Category

Defines edge exclusion zones for drill distribution, preventing drills too close to material edges.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Offset Top** | PropDouble(17) | U(0) mm | ≥ 0 | Inward offset from top edge of element. Defined in element's local coordinate system (typically vertical edge for walls). |
| **Offset Bottom** | PropDouble(18) | U(0) mm | ≥ 0 | Inward offset from bottom edge. Prevents drills near bottom plates or foundation connections. |
| **Offset Left** | PropDouble(19) | U(0) mm | ≥ 0 | Inward offset from left edge (looking at face from front). |
| **Offset Right** | PropDouble(20) | U(0) mm | ≥ 0 | Inward offset from right edge. |
| **Edge** | PropDouble(21) | U(0) mm | ≥ 0 | Offset applied to entire perimeter of contact contour. Used in Crossing Beams strategy to maintain edge distance from beam outlines. |
| **Beam End** | PropDouble(22) | U(0) mm | ≥ 0 | Offset from both ends of contacting beam's longitudinal axis. Prevents drills too close to beam start/end cuts. |

**Coordinate System Context:**
- Top/Bottom/Left/Right refer to the **parent element's coordinate system** (not WCS)
- For walls: Top = header, Bottom = sole plate, Left/Right = end studs
- For CLT panels: Defined by panel insertion orientation
- 45° chamfered edges are assigned to Top or Bottom category based on dominant direction

**Strategy-Specific Visibility:**
- **Sheet Perimeter / Element strategies**: Show Top/Bottom/Left/Right (for rectangular panel edges)
- **Beam Axis / Crossing Beams strategies**: Show Edge and Beam End (for linear beam geometry)
- **Default strategy**: All hidden (user defines path explicitly via polylines)

**Business Logic:**
- Offsets create exclusion polygon by shrinking contour inward
- Drills outside exclusion boundary are rejected
- If all drill locations are invalidated, tool instance is automatically erased
- Offset values compound: Top + Left creates corner exclusion zone
- For circular beam profiles, Edge creates circular exclusion boundary

---

### Alignment Category

Controls drill axis orientation relative to the target face and path direction.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Face** | PropString(3) | Bottom Face | Bottom Face, Top Face | Determines which face of the genbeam receives the drill entry point. Bottom Face = normal direction, Top Face = opposite normal. |
| **Bevel** | PropDouble(5) | U(0)° | -90° to +90° | Drill axis angle relative to selected face normal. 0° = perpendicular, positive angles tilt in +X direction of local coordinate system. |
| **Rotation** | PropDouble(6) | U(0)° | -90° to +90° | Drill axis rotation perpendicular to path segment. Twists drill direction around path tangent vector. |
| **Justification** | PropString(10) | Center | Left of PLine, Center, Right of PLine | Position of drill axis relative to path polyline. Left/Right determined by path direction and face normal cross product. |
| **Justification Offset** | PropDouble(24) | U(0) mm | Any | Additional perpendicular offset from justified position. Positive values move away from justified baseline. |

**Geometric Interpretation:**

**Face Selection:**
- Tool determines "bottom" and "top" faces by analyzing genbeam envelope body
- For beams: Bottom = -Z face, Top = +Z face (in beam's local coordinate system)
- For sheets: Faces are identified by planeprofile normal direction
- Double-click or right-click "Flip Side" toggles between faces

**Bevel Angle:**
- Local coordinate system: X = path tangent, Y = inward normal, Z = face normal
- Positive bevel rotates around local Y axis toward +X (downstream direction)
- Example: Bevel = 45° creates diagonal drill at 45° angle in direction of path
- Clamped to ±90° range (values outside auto-adjust to within range)

**Rotation Angle:**
- Applied after bevel transformation
- Rotates drill axis around path tangent vector
- Example: Rotation = 30° with Bevel = 0° creates drill perpendicular to face but twisted 30°
- Useful for compound angle mortises and tenons

**Justification:**
- "Center": Drill axis intersects path polyline
- "Left of PLine": Drill offset perpendicular to path in -Y direction (local CS)
- "Right of PLine": Drill offset perpendicular to path in +Y direction
- Justification Offset adds additional distance: e.g., "Center" + Offset 25mm moves drill 25mm from centerline

**Combined Transformations:**
- Order of operations: (1) Face normal, (2) Bevel, (3) Rotation, (4) Justification + Offset
- Complex angles displayed during insertion jig: "45°/30°" = Bevel/Rotation
- Invalid bevel (resulting perpendicular to face) shows red "X" error indicator during jig

---

### Slotted Hole Category

Converts circular drills into elongated slotted holes with rounded ends.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Slot Length** | PropDouble(8) | U(0) mm | ≥ 0 | Length of slotted hole along primary slot axis. **0 = use Diameter** (creates circular hole). Must be ≥ Diameter for functional slot. |
| **Slot Width** | PropDouble(9) | U(0) mm | ≥ 0 | Width of slotted hole perpendicular to slot axis. **0 = use Diameter** (creates circular hole). Typically equals Diameter for standard slots. |
| **Tool Index** | PropInt(2) | 1 | ≥ 1 | CNC tool index for freeprofile tool export. Links slot geometry to specific router bit or end mill in machine program. |

**Geometry Creation:**
- Slot = rectangle with semicircular ends (stadium shape)
- Length measured center-to-center of end radii
- Width = diameter of end semicircles
- Minimum functional slot: Length > Diameter, Width = Diameter

**Slot Axis Orientation:**
- Primary slot axis aligned with path tangent direction (parallel to distribution path)
- For multi-row distributions, each row's slots remain parallel to primary path
- Bevel and Rotation transformations apply to slot normal (perpendicular to slot plane)

**Export Behavior:**
- Slot Length > 0 AND Cone Angle = 0: Export as **Mortise** tool (rectangular pocket)
- Slot Length > 0 AND Cone Angle > 0: Export as **ConeMortise** (beveled slot)
- Tool Index allows multiple slot types in single distribution (change index per grip point)

**Use Cases:**
- **Allowance for Movement**: Thermal expansion, moisture shrinkage (Length > Diameter for linear play)
- **Adjustment Slots**: Installation tolerance compensation (typical: Length = Diameter + 20mm)
- **Hanging Hardware**: Slotted hole allows vertical adjustment of connection position
- **CNC Routing**: Tool Index links to specific router bit diameter in G-code post-processor

---

## Step-by-Step Usage Guide

### Scenario 1: Basic Drill Distribution on Beam Axis

**Goal:** Create evenly-spaced drill holes along a beam for a reinforcement plate connection.

**Steps:**

1. **Launch DrillDistribution**
   - Type command or select from TSL menu
   - Properties dialog appears

2. **Configure Properties**
   - **Strategy**: Beam Axis
   - **Diameter**: 12mm
   - **Depth**: 0 (through-hole)
   - **Distribution Mode**: Fixed
   - **Interdistance**: 100mm
   - **Offset Edge**: 50mm (avoid drilling too close to beam perimeter)
   - **Offset Beam End**: 100mm (avoid drilling near end cuts)
   - Click OK

3. **Select Beams**
   - Prompt: "Select primary genbeams"
   - Select the beam(s) requiring drills
   - Press Enter

4. **Select Face**
   - Visual preview highlights available faces
   - Click on the desired drilling face (typically bottom or side face)
   - Drill pattern appears immediately

5. **Verify and Adjust**
   - Check Quantity property (read-only) to confirm drill count
   - If needed, adjust Interdistance or Offset parameters via Properties palette
   - Script automatically recalculates

**Result:** Parametric drill distribution that updates if beam is moved or resized.

---

### Scenario 2: Crossing Beams Strategy for Truss Node Connections

**Goal:** Place drill holes at all intersection points where diagonal braces cross chord members.

**Steps:**

1. **Launch and Configure**
   - **Strategy**: Crossing Beams
   - **Diameter**: 16mm
   - **Depth**: 0
   - **Distribution Mode**: Fixed (mode ignored in this strategy - drills placed at intersections only)
   - **Offset Edge**: 25mm (maintain edge distance from beam perimeters)
   - Click OK

2. **Select Primary Beams** (Chord Members)
   - Prompt: "Select primary genbeams"
   - Select top and bottom chord beams
   - Press Enter

3. **Select Secondary Beams** (Diagonals)
   - Prompt: "Select secondary genbeams"
   - Select diagonal bracing members
   - Press Enter

4. **Select Face**
   - Click on face where drills should be applied
   - Tool calculates 3D intersection geometry between primary and secondary beams
   - Drills appear at each valid intersection point

5. **Filter Intersections** (Optional)
   - If too many intersections detected, use **Reference Filter** and **Contact Filter**
   - Create Painter definitions to select only specific beam types
   - Re-run tool with filters active

**Result:** Drills automatically positioned at structural connection points, updating if beam layout changes.

---

### Scenario 3: Custom Path with Grip Points

**Goal:** Create drill pattern following a curved or irregular path on a CLT panel.

**Steps:**

1. **Initial Setup**
   - **Strategy**: Default
   - **Diameter**: 10mm
   - **Depth**: 50mm (partial depth)
   - **Distribution Mode**: Fixed
   - **Interdistance**: 150mm
   - Click OK

2. **Select Panel**
   - Select the CLT panel
   - Press Enter

3. **Skip Polyline Selection**
   - Prompt: "Select polylines" (optional)
   - Press Enter without selecting (triggers grip point mode)

4. **Define Path with Clicks**
   - Click first point on panel face
   - Click second point
   - Click third point, etc.
   - Press Enter when path is complete

5. **Select Drilling Face**
   - Click on desired face
   - Initial drill distribution appears along clicked points

6. **Convert to Editable Grips**
   - Right-click on tool instance
   - Select **Convert To Grip Points**
   - Grip points appear at each path vertex (colored circles)

7. **Adjust Path**
   - Drag any grip point to modify path shape
   - Drill distribution automatically recalculates in real-time
   - Add more points by inserting vertices in polyline (advanced)

8. **Fine-Tune Distribution**
   - Adjust **Interdistance** property to change spacing
   - Change **Distribution Mode** to Vertex Points to place one drill at each grip
   - Add **Rows** property with **Row Offsets** for multi-line patterns

**Result:** Fully customizable drill path with visual editing capability.

---

### Scenario 4: Fastener Assembly Integration

**Goal:** Create drill pattern with automatic fastener assignment for material list generation.

**Steps:**

1. **Ensure Fastener Library Exists**
   - Verify FastenerAssemblyDef entries exist in drawing (e.g., "WoodScrew_5x60")
   - If not, import fastener catalog first

2. **Configure Drill with Fastener**
   - Launch DrillDistribution
   - **Diameter**: 5mm (matches woodscrew pilot hole)
   - **Depth**: 0 (through-hole)
   - **Fastener Style**: Click dropdown
     - Select `<Show styles <= Diameter>` to see compatible fasteners
     - Select desired fastener (e.g., "WoodScrew_5x60")
   - **Fastener Length**: Leave at 0 for automatic calculation
   - **Offset Z**: -5mm (recess fastener head slightly below surface)

3. **Complete Distribution Setup**
   - Configure distribution parameters as needed
   - Select beams and face as normal

4. **Verify Fastener Creation**
   - After drill distribution appears, check for FastenerAssembly entities
   - Each drill location should have associated fastener symbol
   - Fastener length automatically calculated based on material stack thickness

5. **Review Automatic Length**
   - Tool ray-casts through material stack at each drill location
   - Sums thicknesses of all intersected genbeams
   - Selects closest available fastener length from catalog ≥ calculated depth
   - Check properties of individual FastenerAssembly to verify length

6. **Generate Material List**
   - Use hsbCAD BOM tools to extract fastener quantities
   - Fasteners grouped by definition and length
   - Export to Excel or production system

**Result:** Drill pattern with complete fastener specification for procurement and installation.

---

### Scenario 5: Slotted Holes for Thermal Movement

**Goal:** Create slotted holes allowing 20mm linear movement for expansion joints.

**Steps:**

1. **Configure Slot Parameters**
   - **Diameter**: 16mm (for M16 bolt clearance)
   - **Slot Length**: 36mm (16mm diameter + 20mm movement allowance)
   - **Slot Width**: 0 (defaults to Diameter = 16mm)
   - **Depth**: 0 (through-hole)

2. **Set Slot Orientation**
   - **Rotation**: 0° (slot aligned with path direction for longitudinal movement)
   - OR Rotation: 90° (slot perpendicular to path for transverse movement)

3. **Complete Distribution**
   - Configure distribution mode and spacing
   - Select geometry and face as normal

4. **Verify Slot Geometry**
   - Slots appear as elongated holes with rounded ends
   - Length measured center-to-center of semicircular ends
   - Visual display shows slot contour in preview

5. **Export to CNC** (if applicable)
   - **Tool Index**: Set to match CNC router bit index (e.g., 1 for 16mm end mill)
   - Export drawing with DrillDistribution tools
   - Slots export as Mortise operations in G-code

**Result:** Slotted holes allowing controlled linear movement in specified direction.

---

### Scenario 6: Dual-Sided Sinkholes for Aesthetic Finishing

**Goal:** Create through-hole with countersinks on both faces for flush bolt heads and nut washers.

**Steps:**

1. **Configure Main Drill**
   - **Diameter**: 14mm (for M12 bolt clearance)
   - **Depth**: 0 (through-hole required for opposite side sink)

2. **Entry Side Countersink** (Bolt Head)
   - **Diameter Sink**: 28mm (covers bolt head and washer)
   - **Depth Sink**: 10mm (flush mount depth)
   - **Cone Angle**: 0° (cylindrical recess)

3. **Exit Side Countersink** (Nut/Washer)
   - **Diameter Sink Opposite Side**: 24mm (nut and washer clearance)
   - **Depth Sink Opposite Side**: 8mm
   - **Cone Angle Opposite Side**: 0°

4. **Complete Distribution**
   - Set distribution parameters
   - Select beam and drilling face
   - Tool creates through-hole with sinkholes on both faces

5. **Verify in 3D View**
   - Rotate view to see both faces
   - Entry face shows 28mm countersink
   - Exit face shows 24mm countersink
   - Main 14mm hole penetrates full thickness

**Result:** Professional finish with flush-mounted fasteners on both sides of connection.

---

### Scenario 7: Using Tool Definitions for Standardization

**Goal:** Save a complex drill configuration as a reusable preset for future projects.

**Steps:**

1. **Configure Complete Drill Setup**
   - Set all parameters for standard connection detail:
     - Diameter: 12mm
     - Depth: 0
     - Diameter Sink: 24mm
     - Depth Sink: 6mm
     - Distribution Mode: Fixed
     - Interdistance: 100mm
     - Offset Edge: 50mm
     - Fastener Style: WoodScrew_6x80

2. **Create Tool Definition**
   - Right-click on DrillDistribution instance (or in properties while inserting)
   - Select **Add/Edit Tool Definition**
   - Enter name: "Standard_Plate_Connection_12mm"
   - Click OK

3. **Export Settings to File** (for team sharing)
   - Right-click > **Export Settings**
   - Save to: `[Company]\TSL\Settings\DrillDistribution.xml`
   - File now available to all users with access to company folder

4. **Use Tool Definition in Future**
   - Launch DrillDistribution
   - **Tool Definition** dropdown now shows "Standard_Plate_Connection_12mm"
   - Select preset - all parameters automatically loaded
   - Only need to select geometry and face

5. **Override Individual Parameters** (optional)
   - Even with Tool Definition active, can override specific properties
   - Example: Change Interdistance from 100mm to 120mm for specific case
   - Other parameters remain as defined in preset

**Result:** Standardized drill configurations ensuring consistency across projects and team members.

---

## Context Menu Reference

### Root Level Commands

Accessible by right-clicking on the DrillDistribution tool instance:

| Command | Function | When Available |
|---------|----------|----------------|
| **Flip Side** | Switch drilling direction to opposite face of genbeam. Also triggered by double-clicking the tool instance. | Always |
| **Revert Direction** | Reverse the order of drill distribution along path (first becomes last). Useful when distribution starts from wrong end. | Path-based modes |
| **Add Genbeams** | Add additional genbeams to receive the same drill pattern. Useful for applying identical pattern to multiple parallel beams. | Always |
| **Remove Genbeams** | Remove selected genbeams from the distribution set. Drills on removed beams disappear. | Always |
| **Add Polylines** | Add polyline entities to define additional drill path segments. Extends or modifies existing path. | Default strategy |
| **Convert To Polyline** | Convert grip-based path into permanent polyline entities in the drawing. Makes path independent of script instance. | Grip point mode |
| **Convert To Grip Points** | Convert polyline-based path into editable grip points. Enables visual drag-and-drop path editing. | Polyline mode |
| **Convert To Single Tools** | Explode distribution into individual Drill tool instances. Each drill becomes independent entity. Breaks parametric link. | Always |
| **Add Circles** | Add circle entities for Circles distribution mode. Each circle center becomes drill location with circle diameter. | Circles mode |
| **Remove Circles** | Remove circles from distribution calculation. Reduces drill count. | Circles mode |
| **Add Obstacle** | Add entities (beams, openings, polylines) that prevent drill placement. Distribution skips locations intersecting obstacles. | Always |
| **Remove Obstacles** | Remove obstacle entities from exclusion set. Previously blocked drill locations may reappear. | Always |

---

### Settings Submenu Commands

Accessible via right-click > Settings (or similar nested menu):

| Command | Function | When Available |
|---------|----------|----------------|
| **Add/Edit Tool Definition** | Create new tool preset or modify existing preset. Opens dialog to enter preset name and stores all current property values. | Always |
| **Erase Tool Definition** | Delete the currently selected tool preset from the library. Cannot be undone (unless settings file is backed up). | Tool Definition active |
| **Display Settings** | Configure visualization options: Color (index color), Transparency (0-100), Style (Path/Contour/Axis combinations). | Always |
| **Import Settings** | Load tool definitions and display settings from XML file. Prompts for file location. Merges with existing settings. | Always |
| **Export Settings** | Save current tool definitions and display settings to XML file. Creates shareable configuration file for team/company standards. | Always |

---

## Settings File Structure

### File Locations

The tool searches for settings files in this priority order:

1. **Company Path** (highest priority):
   `[Company]\TSL\Settings\DrillDistribution.xml`

2. **Installation Path** (fallback):
   `[Install]\Content\General\TSL\Settings\DrillDistribution.xml`

Company settings override installation defaults, allowing project-specific or company-specific standards without modifying core installation files.

### XML Structure

Settings file uses hsbCAD's `<Hsb_Map>` format:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- Tool Definition Array -->
  <lst nm="ToolDefinitions">
    <lst nm="Standard_Plate_Connection_12mm">
      <dbl nm="Diameter" ut="L" vl="12.0"/>
      <dbl nm="Depth" ut="L" vl="0.0"/>
      <dbl nm="SinkDiameter" ut="L" vl="24.0"/>
      <dbl nm="SinkDepth" ut="L" vl="6.0"/>
      <dbl nm="Interdistance" ut="L" vl="100.0"/>
      <str nm="DistributionMode" vl="Fixed"/>
      <dbl nm="OffsetEdge" ut="L" vl="50.0"/>
      <str nm="FastenerStyle" vl="WoodScrew_6x80"/>
      <!-- Additional properties... -->
    </lst>
    <lst nm="Another_Preset">
      <!-- Property values... -->
    </lst>
  </lst>

  <!-- Display Settings -->
  <lst nm="DisplaySettings">
    <int nm="Color" vl="160"/>
    <int nm="Transparency" vl="50"/>
    <str nm="Style" vl="Tool Contour+Tool Axis"/>
  </lst>

  <!-- Dimension Format for Shop Drawings -->
  <lst nm="ShopDrawingSettings">
    <str nm="Format" vl="@(Quantity-2)x @(Diameter)"/>
    <str nm="Stereotype" vl="DrillDimension"/>
  </lst>

  <!-- Unit Definition -->
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Managing Settings

**Import Workflow:**
1. Receive XML file from colleague or download from company repository
2. Right-click DrillDistribution instance > Import Settings
3. Browse to XML file location
4. Tool definitions merge into current drawing
5. New presets appear in Tool Definition dropdown

**Export Workflow:**
1. Configure one or more tool definitions (Add/Edit Tool Definition)
2. Optionally set Display Settings to company standard
3. Right-click > Export Settings
4. Save to shared location: company network, project folder, or email to team
5. Recipients import to synchronize standards

**Version Control:**
- Settings files can be version-controlled (Git, SVN)
- Include XML files in project templates for automatic preset availability
- Consider separate files for different project types (residential, commercial, heavy timber)

---

## Advanced Techniques

### Multi-Row Distributions with Custom Offsets

**Scenario:** Create staggered bolt pattern for heavy timber connection (3 rows, custom spacing).

**Configuration:**
```
Rows: 3
Row Offsets: "40;80;40"
Distribution Mode: Fixed
Interdistance: 150mm
```

**Result:**
- Row 1: 0mm from path (on path centerline)
- Row 2: 40mm offset perpendicular to path
- Row 3: 120mm offset (40 + 80)
- Row 4: 160mm offset (40 + 80 + 40)

Creates asymmetric row spacing to avoid splitting grain along beam neutral axis.

---

### Obstacle-Based Exclusion for Window Openings

**Scenario:** Drill shear wall but avoid window openings automatically.

**Steps:**
1. Create drill distribution on wall element (Element Perpendicular Facing strategy)
2. Right-click > Add Obstacle
3. Select window opening beams (header, sill, jambs)
4. Drills automatically excluded from window area
5. If opening moves, drill pattern updates automatically

**Benefit:** No manual path editing required around complex opening geometry.

---

### Combining Strategies: Beam Axis + Contact Filter

**Scenario:** Drill only where specific beam types cross (e.g., studs crossing top plates).

**Setup:**
1. Create two Painter definitions:
   - "StudsOnly": Filters beams with width = 38mm or 40mm
   - "PlatesOnly": Filters beams with depth ≤ 40mm AND width ≥ 90mm
2. DrillDistribution configuration:
   - Strategy: Crossing Beams
   - Reference Filter: PlatesOnly
   - Contact Filter: StudsOnly

**Result:** Drills appear only at stud-to-plate intersections, ignoring all other beam crossings.

---

### Slotted Holes with Rotation for Diagonal Movement

**Scenario:** Allow diagonal thermal movement at 45° angle.

**Configuration:**
```
Slot Length: 30mm
Slot Width: 0 (= Diameter)
Rotation: 45°
```

**Result:** Slotted holes elongated at 45° to path direction, permitting movement along diagonal axis.

---

### Relative Depth Mode for Production Efficiency

**Scenario:** Template drill pattern where sink depth always stays 5mm less than total depth.

**Setup:**
1. Create tool definition:
   - Depth: 50mm
   - Sink Depth: 45mm (5mm less)
   - Mode: Relative Depth
2. When Depth changes to 60mm, Sink Depth automatically becomes 55mm
3. When Depth = 0 (through-hole), Sink Depth becomes (calculated_depth - 5mm)

**Benefit:** Maintains constant material thickness between sink bottom and drill bottom, preventing breakthrough.

---

## Troubleshooting

### Problem: No drills appear after face selection

**Possible Causes:**
1. **All drill locations excluded by offsets**
   - Check Contour Offsets properties (Top, Bottom, Left, Right, Edge, Beam End)
   - Reduce offset values or increase path length

2. **Interdistance larger than path length**
   - Fixed mode: First drill at Distribution Offset, next drill at Offset + Interdistance
   - If Interdistance > (PathLength - Distribution Offset), only one drill appears or none
   - Solution: Reduce Interdistance or increase Distribution Offset to negative value (starts before path origin)

3. **All locations intersect obstacles**
   - Right-click > Remove Obstacles to clear exclusion set
   - Or reposition obstacles

4. **Polyline/path has zero length**
   - In grip point mode with only 1 point clicked: no path exists
   - Add second point to create valid path segment

5. **Strategy filter mismatch**
   - Reference Filter or Contact Filter excludes all selected geometry
   - Change filters to less restrictive Painter definitions or set to Disabled

---

### Problem: Drill quantity is less than expected

**Diagnosis:**
1. Check read-only **Quantity** property to see actual count
2. Causes for reduced quantity:
   - **Obstacle exclusions**: Drills intersecting obstacles are removed
   - **Contour offsets**: Edge distance requirements exclude drills near boundaries
   - **Path length calculation**: Fixed mode terminates when path end reached
   - **Vertex mode**: Quantity = polyline vertex count (may be fewer than expected)

**Solutions:**
- Reduce Offset parameters to allow drills closer to edges
- Remove obstacles (right-click > Remove Obstacles)
- Extend path length (adjust grip points or polylines)
- Switch to Even mode and specify exact quantity desired

---

### Problem: Drills appear on wrong face

**Solution:**
- Double-click tool instance (fastest method)
- OR right-click > Flip Side
- Tool recalculates with opposite face normal direction

---

### Problem: Fastener style dropdown is empty

**Causes:**
1. **No FastenerAssemblyDef entries in drawing**
   - Import fastener catalog (Hilti, Simpson, etc.)
   - Or create custom FastenerAssemblyDef entries

2. **Diameter filter too restrictive**
   - Current Diameter = 12mm but all fastener catalogs have 10mm or 14mm styles
   - Select filter option: `<Show all styles>` to see complete list
   - Or adjust Diameter to match available fastener sizes

3. **Only complex assemblies available (filtered out)**
   - Tool shows only simple fasteners (woodscrews, bolts)
   - Multi-component assemblies (bolt+washer+nut) excluded
   - Solution: Create simple FastenerAssemblyDef for required fastener type

---

### Problem: Slotted holes export as circular drills

**Cause:**
- Slot Length = 0 OR Slot Width = 0 (both default to Diameter, creating circular hole)

**Solution:**
- Set Slot Length > Diameter (e.g., Diameter 12mm, Slot Length 30mm)
- Slot Width can remain 0 (uses Diameter automatically)

---

### Problem: Opposite side sinkhole doesn't appear

**Causes:**
1. **Main drill not through-hole**
   - Depth > 0 with insufficient value to reach opposite face
   - Solution: Set Depth = 0 for guaranteed through-hole

2. **Opposite sink parameters = 0**
   - Both Diameter Sink Opposite Side AND Depth Sink Opposite Side must be > 0
   - Solution: Set both parameters

3. **Beveled drill doesn't reach opposite face**
   - Large Bevel angle with Depth = 0 may exit side face instead of opposite bottom face
   - Solution: Check drill axis direction, adjust Bevel or use Face = Top Face

---

### Problem: Tool instance disappears after recalculation

**Cause:**
- All drill locations invalidated by obstacles or offset exclusions
- Tool automatically erases itself when Quantity = 0

**Solution:**
1. Undo (Ctrl+Z) to restore tool instance
2. Adjust parameters:
   - Reduce Contour Offsets
   - Remove Obstacles
   - Increase path length
   - Change distribution parameters
3. If tool was configured correctly, save as Tool Definition before it erases

---

### Problem: Grip points don't appear for editing

**Cause:**
- Tool is in polyline mode (path defined by selected polyline entities, not grips)

**Solution:**
- Right-click > Convert To Grip Points
- Grip circles appear at path vertices
- Drag grips to modify path shape

---

### Problem: Bevel preview shows red "X" during insertion

**Cause:**
- Selected bevel angle results in drill axis perpendicular to selected face (invalid geometry)
- Occurs when bevel = ±90° or when rotation causes perpendicular alignment

**Solution:**
- Adjust bevel angle to within valid range (avoid exact ±90°)
- Check rotation value (combined bevel + rotation may create perpendicular condition)
- Select different face or different point on face

---

## Integration with Other hsbCAD Tools

### Shop Drawing Dimension Requests

DrillDistribution automatically publishes dimension request data for shop drawing tools:

**Published Data:**
- Drill quantity (formatted per settings: "@(Quantity-2)x @(Diameter)")
- Diameter value
- Angular dimensions (Bevel, Rotation, Cone Angle) via map-based requests
- Slot dimensions (Length, Width) for slotted holes

**Integration with Dimline:**
- Use **Dimline** tool to create dimensions pointing to DrillDistribution instances
- Dimension text automatically populates from published data
- Format customizable via **Dimension > Format** property (access via DialogMode 2)

**Stereotypes:**
- Assign dimension stereotype via **Dimension > Stereotype** property
- Links to MultiPageStyle stereotype overrides for consistent formatting
- Useful for differentiating drill callouts from standard dimensions on shop drawings

---

### FastenerAssembly and Material Lists

**Workflow:**
1. DrillDistribution creates FastenerAssembly entities at each drill location
2. FastenerAssembly entities link to FastenerAssemblyDef (manufacturer catalog)
3. hsbCAD BOM tools extract fastener data:
   - HSB_G-BillOfMaterial
   - hsbBOM
   - Element-specific BOM commands

**Automatic Calculations:**
- Fastener length = stack thickness (sum of all intersected genbeam thicknesses)
- Article number selection based on closest available catalog length
- Quantity aggregation by definition + length combination

**Material List Output:**
- Grouped by fastener type and length
- Export to Excel, CSV, or ERP integration
- Includes installation locations (element references, coordinates)

---

### CNC Export (via MapX)

For CNC machine programming, DrillDistribution supports MapX-based tool export:

**Configuration:**
1. Tool Definition dialog (DialogMode 1) includes:
   - **Export MapX Key**: Name for CNC exporter to recognize (e.g., "DrillTool_Type")
   - **Export MapX Value**: Value for classification (e.g., "Dowel_12mm")

2. CNC exporter definition (separate system) reads MapX data and translates to G-code

**Slotted Hole Export:**
- Slot Length > 0 without Cone Angle: Exports as **Mortise** operation
- Slot Length > 0 with Cone Angle > 0: Exports as **ConeMortise**
- Tool Index property links to CNC tool library (router bit number)

**Export Formats:**
- BTL (Hundegger, Weinmann)
- WUP (Weinmann)
- Custom XML formats

---

### Element-Based Workflows

**Element Perpendicular Facing Strategy:**
- Operates on complete Element entities (walls, floors, roofs)
- Automatically distributes drills on element perimeter or facing surfaces
- Updates when element is recalculated (stud spacing changes, opening moved, etc.)

**Integration:**
- Drill pattern remains associated with parent element
- Element BOM includes drill count and fastener quantities
- Shop drawing extraction pulls element-level drill data

---

## Related Tools

### Direct Alternatives

| Tool | Relationship | When to Use Instead |
|------|--------------|---------------------|
| **Drill** | Single drill placement | Only need one or two drills, not a pattern |
| **FreeDrill** | Manual drill positioning | Completely irregular pattern with no geometric logic |
| **DrillPatternDimension** | Drill pattern with integrated dimensions | Primarily focused on shop drawing callouts |

### Complementary Tools

| Tool | Complementary Function |
|------|------------------------|
| **Dimline** | Create dimensions referencing DrillDistribution data |
| **FastenerAssembly** | Manage individual fastener entities created by drill distribution |
| **FastenerEditor** | Edit fastener properties in batch |
| **Slot** | Create single slotted hole (DrillDistribution creates slot distributions) |
| **ConeDrill** | Create single cone drill (DrillDistribution creates cone distributions) |
| **hsbBOM** | Extract drill and fastener quantities for material lists |

---

## Performance Considerations

### Large Distributions (>100 drills)

**Symptoms:**
- Slow recalculation when adjusting properties
- Display refresh lag in complex 3D views

**Optimizations:**
1. **Use Envelope Bodies**: Tool automatically uses `envelopeBody()` instead of `realBody()` for performance
2. **Disable Fastener Assembly**: If fasteners not needed for current phase, set Fastener Style = Disabled
3. **Simplify Display Style**: Use "Distribution Path" only instead of "Tool Contour + Tool Axis"
4. **Work in 2D Views**: Disable 3D visualization during parameter adjustment

---

### Complex Geometry Intersections

**Scenarios:**
- Crossing Beams strategy with 50+ beams × 50+ beams = 2500 potential intersections
- Element Perpendicular Facing on facade with complex panel geometry

**Optimizations:**
1. **Use Painter Filters**: Restrict selection to specific beam types only
2. **Apply Offset Exclusions**: Reduce calculation overhead by excluding edge zones early
3. **Split Distributions**: Create multiple DrillDistribution instances for subsets rather than one massive distribution

---

## Version History

| Version | Date | Key Changes | Issue ID |
|---------|------|-------------|----------|
| 5.10 | Oct 2025 | Added Justification and Justification Offset properties | HSB-24699 |
| 5.9 | Oct 2025 | Fixed Face property behavior on Element entities | HSB-24652 |
| 5.8 | Sep 2025 | Fixed Crossing Beams strategy for arbitrary 2-beam scenarios | HSB-24615 |
| 5.7 | Jun 2025 | New Strategy property for specific distribution types | HSB-24152 |
| 5.6 | May 2025 | Improved fastener length override functionality | HSB-24088 |
| 5.5 | May 2025 | Added facade contour and contact pattern properties/strategies | HSB-24068 |
| 5.4 | May 2025 | Conversion to grips improved, show all fasteners enhanced | HSB-23919 |
| 5.3 | May 2025 | FastenerAssembly creation improved, grip assignment fixed | HSB-23919 |
| 5.2 | Mar 2025 | FastenerAssembly entities created when fastener style selected | HSB-23671 |
| 5.1 | Feb 2025 | New properties for fastenerAssembly specification | HSB-23551 |
| 5.0 | Apr 2024 | Bugfix for extreme plane detection with beveled drills | HSB-21873 |
| 4.9 | Mar 2024 | Tooling improved for beveled, slotted, and sunken tools | HSB-19347 |
| 4.4 | Feb 2024 | Opposite drill and cone added (dual-sided sinkholes) | HSB-21152 |
| 4.0 | Nov 2023 | Depth grips, single drill insertion, Convert To Single Tools | HSB-20691 |
| 3.9 | Nov 2023 | New Circles distribution mode | HSB-20581 |
| 3.7 | Aug 2023 | Row extension grips, interdistance grip specification | HSB-19798 |
| 3.4 | Mar 2023 | Obstacle add/remove commands, readonly Quantity property | HSB-18357 |
| 3.2 | Feb 2023 | Export/Import Settings commands | HSB-18133 |
| 3.0 | Feb 2023 | Dimension requests for slotted holes | HSB-17797 |
| 2.9 | Feb 2023 | Tool definition property and commands | HSB-17740 |
| 2.5 | Dec 2022 | Slotted hole support | HSB-17390 |
| 2.2 | Dec 2022 | Vertex distribution mode added | HSB-17266 |
| 2.0 | Nov 2022 | Basic cone drill support (requires hsbDesign 25+) | HSB-16439 |
| 1.4 | Jul 2022 | Sinkholes considered in fastener creation | HSB-16118 |
| 1.0 | Apr 2022 | Initial version for any GenBeam type | HSB-14989 |

---

## Frequently Asked Questions

### Q: Can I distribute drills on curved surfaces?

**A:** Yes, if the curved surface is a genbeam (beam with curved axis or curved sheet). Use Default strategy with a polyline following the curve, or convert to grip points and position grips along the curve path. The tool projects drill locations onto the actual genbeam surface geometry.

---

### Q: How do I create a staggered pattern (alternating rows)?

**A:** Use Column Offsets in combination with Rows:
1. Set **Rows**: 2
2. Set **Row Offsets**: "50" (creates 2 rows, 50mm apart)
3. Set **Column Offsets**: "75" (shifts every other drill by 75mm along path)

Result: Alternating brick-like pattern.

---

### Q: The automatic fastener length is too long/short. How do I override?

**A:**
1. **Manual Override**: Set **Fastener Length** to specific value instead of 0 (auto)
2. **Adjust Depth**: If main drill Depth affects stack calculation incorrectly, adjust Depth property
3. **Check Sinkhole Depth**: Sink depth is subtracted from penetration depth for fastener length calculation
4. **Verify Stack**: Tool may be detecting unexpected genbeams in ray-cast path (check for overlapping geometry)

---

### Q: Can I use this tool for dowel holes (precise diameter tolerance)?

**A:** Yes, but be aware:
- Tool creates geometric drill representations (for visualization and CNC export)
- Actual machining tolerance depends on CNC machine and tool library
- For dowel holes, set:
  - **Diameter**: Exact dowel diameter (e.g., 12.00mm for 12mm dowels)
  - **Depth**: Dowel length + 2mm (clearance)
  - **Tool Index**: CNC drill bit index matching dowel diameter exactly
- Verify CNC post-processor translates diameter accurately

---

### Q: How do I distribute drills only at specific beam intersections (not all)?

**A:** Use Crossing Beams strategy with Painter filters:
1. Create Painter definition filtering specific beam types (e.g., only beams with name containing "BRACE")
2. Set **Reference Filter** to first beam type
3. Set **Contact Filter** to second beam type
4. Only intersections between these filtered types receive drills

Alternatively, use Obstacle command to exclude specific intersection zones.

---

### Q: Can the tool create drills at angles other than perpendicular to the face?

**A:** Yes, use **Bevel** and **Rotation** properties:
- **Bevel**: Tilts drill axis in path direction (e.g., Bevel = 15° for angled dowel)
- **Rotation**: Twists drill axis perpendicular to path (e.g., Rotation = 10° for compound angle mortise)
- Both angles combine for complex 3D drill orientations
- Preview during insertion shows "Bevel°/Rotation°" text at first drill location

---

### Q: What happens if I delete a beam that the drill path references?

**A:**
- **Polyline mode**: Drill pattern is independent (polylines remain even if beam deleted)
- **Grip point mode**: Grips are independent (pattern remains)
- **Beam Axis / Crossing Beams strategy**: Drills depend on beam geometry
  - If reference beam deleted, tool may become invalid and erase itself
  - If contact beam deleted, distribution recalculates without that beam's intersections
- **Best practice**: Convert to Polyline or Grip Points before deleting reference geometry

---

### Q: How do I export drill data to Excel for a cut list?

**A:** DrillDistribution doesn't export directly, but integrates with hsbCAD BOM tools:
1. Run **HSB_G-BillOfMaterial** or **hsbBOM**
2. Select "Include Tools" option
3. Drill tools appear in BOM list with quantities
4. Export BOM to Excel (built-in hsbCAD functionality)
5. Filter Excel rows for "Drill" or "DrillDistribution" to isolate drill data

If fasteners assigned, BOM includes fastener quantities automatically.

---

### Q: Can I dimension the drill pattern for shop drawings?

**A:** Yes, use **Dimline** tool or **DrillPatternDimension**:
1. Create shop drawing layout (Paper Space or Model Space viewport)
2. Insert **Dimline** tool
3. Select DrillDistribution instance as dimension target
4. Dimline reads published dimension request data:
   - Quantity
   - Diameter
   - Interdistance (if applicable)
5. Dimension text automatically formats per **Dimension > Format** property

For more advanced drill pattern dimensioning, use **DrillPatternDimension** tool designed specifically for drill distributions.

---

### Q: The tool creates too many fasteners and slows down my drawing. What can I do?

**A:**
1. **Disable Fastener Assignment**: Set **Fastener Style** = Disabled until final stage
2. **Use Tool Definitions Without Fasteners**: Create preset with fasteners disabled for design phase
3. **Freeze FastenerAssembly Layer**: Prevents display refresh overhead
4. **Enable Fasteners Only on Final Elements**: Use fasteners on production-ready elements only
5. **Split Large Distributions**: Create multiple smaller DrillDistribution instances instead of one massive distribution

---

## Best Practices Summary

### Design Phase
1. ✅ Use **Default strategy** with grip points for maximum flexibility during design iteration
2. ✅ Set **Fastener Style = Disabled** to avoid performance overhead
3. ✅ Use **Display Style = Distribution Path** for fast visual feedback
4. ✅ Save frequently-used configurations as **Tool Definitions** early in project

### Production Phase
1. ✅ Switch to **Beam Axis** or **Crossing Beams** strategies for automated placement
2. ✅ Enable **Fastener Style** for accurate material lists
3. ✅ Apply **Contour Offsets** matching shop standards (edge distance requirements)
4. ✅ Use **Obstacles** to automatically avoid openings and services
5. ✅ Convert critical distributions to **Polyline mode** to prevent accidental changes

### Quality Control
1. ✅ Always check **Quantity** property to verify expected drill count
2. ✅ Review **Fastener Length** in properties (or inspect individual FastenerAssembly entities)
3. ✅ Verify **Bevel and Rotation** angles for angled connections (use 3D view)
4. ✅ Test CNC export with sample element before full production
5. ✅ Validate **Sinkhole depths** don't breakthrough opposite face (for partial-depth drills)

### Team Collaboration
1. ✅ **Export Settings** to company shared folder for standardization
2. ✅ Establish naming conventions for **Tool Definitions** (e.g., "Proj_Detail_Diameter")
3. ✅ Document **Painter definitions** used in Reference/Contact filters
4. ✅ Include DrillDistribution.xml in project templates
5. ✅ Train team on **Strategy selection** for different scenarios (cheat sheet in documentation)

---

**End of DrillDistribution User Guide**

*For technical support or feature requests, contact hsbCAD support or submit issue via internal ticketing system.*