# instaConduit

## Overview

The **instaConduit** script creates intelligent conduit routing paths for MEP (Mechanical, Electrical, Plumbing) installations within timber construction elements. It enables routing of electrical conduits, pipes, HVAC ducts, or other services between installation cells (instaCell) or combinations (instaCombination) within walls, floors, and roof elements.

This script is part of the **Insta Suite**, a comprehensive MEP integration system for hsbCAD, working in conjunction with:
- **instaCombination** - Defines overall installation zones
- **instaCell** - Defines individual installation points/nodes

The conduit automatically generates appropriate machining operations (drills, slots, routed paths) through beams and panels based on conduit geometry and routing strategy.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for 3D conduit routing and machining |
| Paper Space | No | |
| Shop Drawing | No | |

**Script Type**: O-Type (Object)
**Required Beams**: 0 (connects to existing elements or genbeam sets)
**Version**: 4.2
**Author**: Thorsten Huck

## Prerequisites

Before using instaConduit, you must have:

1. **Base Structure** - One of the following:
   - An **Element** (wall, floor, or roof) in your model
   - A set of **GenBeams** (standalone timber members)

2. **Installation Framework** (Recommended):
   - At least one **instaCombination** placed on the element (defines routing zone)
   - Optionally, **instaCell** instances within combinations (defines specific connection nodes)

3. **Compatible Structures**:
   - Stick-frame walls and floors
   - Roof elements
   - Log walls (with special handling for log courses)
   - SIP (Structural Insulated Panel) walls
   - CLT panels

## Core Concepts

### Connection Modes

The script supports multiple connection modes automatically determined by what you select:

| Mode | Description | Connection Type |
|------|-------------|----------------|
| **Cell-to-Cell** | Direct connection between two instaCell instances | Straight or angled path |
| **Cell-to-Combination** | Connection from cell to combination boundary | Path terminates at zone edge |
| **Combination-to-Combination** | Connection between two combinations | Zone-to-zone routing |
| **Free Path** | Manual multi-vertex routing not constrained by cells | Polygonal path |
| **Standalone** | Direct routing through genbeams without combinations | Simple beam penetration |
| **Straight-to-Edge** | Direct path to element edge | Edge termination |

### Routing Strategies

**Strategies** are named presets containing conduit configuration including diameter, splitting behavior, gaps, tagging, and hardware assignments. They enable:
- Consistent conduit specifications across projects
- Quick switching between different MEP system types (electrical/plumbing/HVAC)
- Team standardization through XML import/export
- Hardware catalog integration

### Tooling Behavior

The script generates different machining operations based on conduit geometry:

| Conduit Type | Generated Tool | Use Case |
|--------------|----------------|----------|
| Round (Depth=0) | Drill | Standard cylindrical conduit/pipe |
| Rectangular (Depth>0) | BeamCut/Slot | Rectangular ductwork or large openings |
| Custom Profile | Routed Profile | Complex cross-sections from polylines |
| Edge Exit | Drill or Pocket | Panel penetrations at conduit endpoints |
| Segmented | Multiple drills with gaps | Split routing through multiple beams |

## Usage Instructions

### Basic Workflow

#### 1. Launch the Script

```
Command: TSLINSERT
Select: instaConduit.mcr
```

Or use the TSL palette/ribbon if configured.

#### 2. Select Parent Entity

Click on one of:
- **instaCombination** - Routes within combination zone (recommended)
- **Element** - Routes within element structure
- **GenBeam** - Routes through standalone beam set

The script highlights available snap points and displays a preview jig.

#### 3. Define First Connection Point

Options for first point:
- **Cell Node** - Click triangle indicator to snap to instaCell
- **Combination Center** - Click center of combination zone
- **Combination Edge** - Click edge/boundary of combination
- **Free Point** - Click anywhere within element for manual placement
- **Log Course** - For log walls, snap to course lines

The preview shows the conduit direction and available snap targets.

#### 4. Define Second Connection Point

Similar options as first point. The conduit preview updates showing:
- Path geometry (straight, angled, or curved)
- Machining locations (drills through beams)
- Edge tools (exit holes through panels)

#### 5. Add Intermediate Vertices (Optional)

For complex routing:
- After selecting second point, continue clicking to add vertices
- Creates polygonal routing path
- Each vertex becomes an editable grip point
- Use **Radius Contour** property to round sharp corners

#### 6. Adjust Properties

Open Properties Palette (Ctrl+1) and modify:
- **Diameter/Width** - Conduit size
- **Strategy** - Select named preset
- **Face** - Reference/Opposite side placement
- **Zone** - Target zone in multi-layer elements
- **Offsets** - Fine-tune positioning

The conduit recalculates automatically.

### Advanced Insertion Modes

#### Standalone Mode (No Combinations)

When instaCombination is not present:

1. Select an **Element** or set of **GenBeams**
2. Click start point directly on structure
3. Click end point to define path
4. Conduit creates penetrations through all intersecting members

Use cases:
- Simple beam drilling
- Temporary conduits during design
- Elements without MEP framework

#### Rule-Based Insertion

The script supports insertion via TSL rules:
- Can be triggered programmatically by other scripts
- Supports predefined placement parameters
- Useful for repetitive MEP patterns

#### Log Wall Vertical Routing

Special behavior for log construction:

1. Select two **instaCell** instances on different vertical courses
2. Script detects log wall structure
3. Generates **segmented drills** at each course intersection
4. Maintains structural integrity by respecting log course spacing

Configuration:
- **Split** = Yes (in strategy settings)
- **Gap Genbeam** = Gap distance at each log course

## Properties Reference

All parameters are accessible through the Properties Palette (OPM).

### Strategy

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Strategy** | String | \<Default\> | List of saved strategies | Selects predefined configuration preset containing diameter, gaps, splitting, transparency, tagging, and hardware settings |

The Strategy dropdown populates from saved presets. Use right-click menu to add/edit/delete strategies.

### Geometry

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Diameter/Width** | Length | 30 mm | > 0 | For round conduit (Depth=0): diameter of tube. For rectangular (Depth>0): width dimension |
| **Depth** | Length | 0 mm | ≥ 0 | Height dimension for rectangular cross-section. 0 = round/cylindrical conduit |
| **Radius Contour** | Length | 0 mm | ≥ 0 | Corner radius for polygonal routing paths. 0 = sharp corners. Larger values create smoother curves at vertices. Not relevant for straight drilled conduits |

**Cross-Section Behavior:**
- `Depth = 0` → Round conduit (drill tools)
- `Depth > 0` → Rectangular conduit (slot/beamcut tools)
- `Depth = Diameter` → Square cross-section

### Edge Tool

Controls the tool created where conduit exits through panels/sheathing:

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Diameter/Width** | Length | 30 mm | > 0 | Diameter of edge tool (if round) or width (if rectangular) |
| **Height** | Length | 0 mm | ≥ 0 | Height of pocket tool extending into panel edge. 0 = drill (full penetration) |
| **Depth** | Length | 0 mm | ≥ 0 | Depth dimension for rectangular edge tool. 0 = round |
| **Radius** | Length | 0 mm | ≥ 0 | Corner radius for rectangular edge tool |
| **Offset** | Length | 0 mm | Any | Offset distance along conduit direction from conduit center to edge tool center |

**Use Cases:**
- Standard penetration: Diameter=30, Height=0 (simple drill)
- Recessed outlet box: Diameter=80, Height=50 (pocket for electrical box)
- Rectangular vent: Diameter=150, Depth=80, Height=40 (recessed rectangular opening)

### Alignment

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Face** | String | byCombination | byCombination, Reference Side, Opposite Side | Determines which face of element the conduit routes through. "byCombination" = matches parent combination face orientation |
| **Anchor** | String | Default | Default, Cells, Combination | Filters which snap targets are available during grip editing. Default = both cells and combinations visible |
| **Zone** | Integer | 0 | Available zones | Target zone for multi-zone elements (e.g., zone 1, -1, 2). Only visible when element has multiple zones. Controls which layer receives conduit tooling |
| **Z-Axis-Offset** | Length | 0 mm | Any | Perpendicular offset from conduit centerline (offset in thickness direction) |
| **Lateral Offset Start** | Length | 0 mm | Any | Side offset at conduit starting point (offset parallel to element face) |
| **Lateral Offset End** | Length | 0 mm | Any | Side offset at conduit ending point (offset parallel to element face) |

**Zone Behavior:**
- Positive zones (1, 2, 3...) = Outside layers
- Negative zones (-1, -2, -3...) = Inside layers
- Zone 0 = Center/default layer
- Face parameter becomes read-only when Zone ≠ 0

**Offset Scenarios:**
```
Z-Axis-Offset = 20mm → Shifts conduit 20mm perpendicular to wall face
Lateral Offset Start = 50mm → Start point moves 50mm sideways
Lateral Offset End = -30mm → End point moves 30mm opposite direction
```

### Element Tools

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Tool Index** | Integer | 1 | -1 to 99 | Machining layer index for element-level tools (ElemDrill/ElemNotch). -1 = no element tools created. Different indices allow grouping tools for different manufacturing stages |

**Visibility:** Only shown when working with Element entities (walls/floors/roofs) and when element supports ElemTool operations.

**Use Cases:**
- Index 1 = Primary MEP rough-in
- Index 2 = Secondary service routing
- Index -1 = Disable element tools, use only beam tools

## Right-Click Context Menu

### Path Manipulation

| Command | Availability | Description |
|---------|--------------|-------------|
| **Flip Direction** | Straight-to-edge conduits | Reverses the conduit direction vector, moving the endpoint to opposite side of combination |
| **Flip Face** | All modes | Toggles conduit to opposite face of element. Also triggered by double-clicking the conduit |
| **Reset Path** | Free path mode | Resets polygonal conduit path to direct straight connection between endpoints, removing all intermediate vertices |
| **Connect to Center** | Cell connections to combinations | Snaps endpoint from cell node to center of connected combination |
| **Add Vertex** | Non-drilled conduits | Inserts new vertex point along conduit path, converting straight path to polygonal routing |
| **Delete Vertex** | Free path mode | Removes selected vertex from multi-vertex path |
| **Extend to Edges** | Standalone conduits | Extends conduit endpoints to element boundary edges |

**Workflow Examples:**

```
Flip Direction:
- Conduit routes from cell to right edge of combination
- Execute "Flip Direction"
- Conduit now routes to left edge of combination

Add Vertex:
- Straight conduit between two cells
- Execute "Add Vertex"
- Command prompts "Add point"
- Click location for new vertex
- Conduit becomes polygonal path with 3 points
```

### Strategy Management

| Command | Description |
|---------|-------------|
| **Add Strategy** | Creates new named strategy. Opens dialog to configure Split, Gaps, Profile, Tagging, Transparency settings |
| **Edit Strategy** | Modifies existing strategy parameters. Select from dropdown of saved strategies |
| **Delete Strategy** | Permanently removes saved strategy from settings |
| **Set Strategy Hardware** | Opens hardware component dialog to assign parts (pipes, cables, fittings) to current strategy |

**Strategy Workflow:**

1. **Create Base Conduit** - Place conduit with default settings
2. **Add Strategy** - Right-click → "Add Strategy"
   - Name: "Electrical 20mm"
   - Diameter: 20mm
   - Split: Yes
   - Gap Genbeam: 5mm
   - Tag Mode: byPath
   - Plan View Transparency: 80
3. **Set Hardware** - Right-click → "Set Strategy Hardware"
   - Add Article: "Corrugated Conduit M20"
   - Manufacturer: "Brand X"
4. **Apply to Others** - Other conduits can now select "Electrical 20mm" from Strategy dropdown

### Tool Visibility

| Command | Description |
|---------|-------------|
| **Hide Tools** | Hides element tooling graphics (drills/slots remain functional but invisible) |
| **Show Tools** | Shows element tooling graphics |

Useful for:
- Reducing visual clutter in complex models
- Focusing on structural timber while keeping MEP functional
- Presentation views

### Settings Import/Export

| Command | Description |
|---------|-------------|
| **Import Settings** | Loads strategy configurations from external XML file. Merges with existing strategies |
| **Export Settings** | Saves all current strategies to XML file for sharing across projects or team members |

**File Location:**
```
Company: [CompanyPath]\TSL\Settings\instaConduit_Settings.xml
Installation: [InstallPath]\Content\General\TSL\Settings\instaConduit_Settings.xml
```

**Use Cases:**
- Standardize MEP configurations across office
- Transfer settings between projects
- Backup custom strategy library
- Share with subcontractors

### Utility Commands

| Command | Description |
|---------|-------------|
| **Show all Commands for UI Creation** | Displays complete list of available commands in report dialog. Used to create custom ribbon buttons or toolbar shortcuts |

## Strategy Settings Dialog

Accessed via **Add Strategy** or **Edit Strategy** commands.

### General Category

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| **Name** | String | New Strategy | Unique identifier for strategy. Cannot use "\<Default\>" as name |
| **Profile** | String | Disabled | Custom cross-section shape: Disabled = use Diameter/Depth parameters, Select Shape = pick polyline from drawing, Current Profile = use previously selected profile |

**Profile Workflow:**

1. **Draw Profile** - Create closed polyline(s) in model space
   - Outer polyline = conduit boundary
   - Inner polylines = openings/voids (e.g., corrugated profile)
2. **Add Strategy** - Select "Select Shape" from Profile dropdown
3. **Select Polylines** - Pick all polylines defining profile
4. **Result** - Conduit extrudes custom profile along path

**Profile Rules:**
- Largest polyline = outer boundary
- Smaller polylines = subtractive openings
- All polylines projected to conduit path plane
- Profile saved with strategy for reuse

### Segments Category

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| **Split** | Yes/No | No | Enable segmented conduit that splits at beam intersections creating gaps |
| **Gap Genbeam** | Length | 0 mm | Gap distance when conduit segments at beam intersections. Only active if Split = Yes |
| **Gap Combination** | Length | 0 mm | Gap distance when connecting to combination boundaries |

**Split Behavior:**

```
Split = No:
[===CONDUIT===] (continuous through beams)

Split = Yes, Gap = 5mm:
[==SEGMENT==] [5mm gap] [==SEGMENT==] [5mm gap] [==SEGMENT==]
              ^Beam1              ^Beam2
```

Use cases:
- Flexible conduit requiring beam clearance
- Assembly/installation space
- Thermal expansion gaps
- Log wall course separation

### Tagging Category

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| **Tag Mode** | String | Disabled | Disabled = no labels, bySegment = label each segment individually, byPath = single label for entire conduit |
| **Format** | String | @(ArticleNumber) | Tag text format using property placeholders. Example: "@(ArticleNumber)\PL:@(ScaleX:RL0)" shows article number and length |
| **Dimstyle** | String | (first available) | AutoCAD dimension style for tag annotations |
| **Text Height** | Length | 50 mm | Height of tag text labels |

**Format Placeholders:**

| Placeholder | Output | Example |
|-------------|--------|---------|
| @(ArticleNumber) | Hardware article number | "COND-M20-25" |
| @(ScaleX:RL0) | Conduit length rounded to 0 decimals | "2450" |
| @(ScaleY:R2) | Conduit width/diameter with 2 decimals | "20.00" |
| @(ScaleZ:R2) | Conduit depth/height with 2 decimals | "30.00" |
| @(Name) | Hardware component name | "Corrugated Conduit" |
| @(Manufacturer) | Hardware manufacturer | "Brand X" |

**Tag Examples:**

```
Format: "@(ArticleNumber)" → Tag shows: "ELEC-20MM"
Format: "@(Name)\PL:@(ScaleX:RL0)mm" → Tag shows: "Electrical Conduit\PL:2450mm"
Format: "@(ScaleY:R0)x@(ScaleZ:R0)" → Tag shows: "20x30"
```

### Plan View / Element View Categories

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| **Transparency** | Integer | 80 | Transparency percentage for conduit display (0=opaque, 100=invisible). Plan View = horizontal projections, Element View = shop drawings |

**Transparency Use:**
- 0-20% = Solid, highly visible (final presentation)
- 40-60% = Semi-transparent (coordination)
- 80-90% = Mostly transparent (reduce clutter while maintaining reference)
- 100% = Invisible

## Grip Points and Interactive Editing

The conduit provides dynamic grip points for real-time editing:

### Primary Grips

| Grip | Name | Location | Function |
|------|------|----------|----------|
| **Start Grip** | _PtG0 | First endpoint | Drag to relocate conduit start. Snaps to cells, combinations, log courses |
| **End Grip** | _PtG1 | Second endpoint | Drag to relocate conduit end. Snaps to available anchor points |

### Vertex Grips

- **Intermediate Grips** - One grip per vertex in polygonal paths
- **Drag Behavior** - Vertex moves, adjacent segments update automatically
- **Snap Targets** - Vertices snap to cells, combination centers/edges, log courses

### Grip Editing Workflow

1. **Select Conduit** - Click on conduit to display grips
2. **Hover Over Grip** - Grip highlights, showing available snap points (triangles for cells, rectangles for combinations)
3. **Drag Grip** - Move to new location
4. **Snap** - Grip magnetically snaps to nearby anchor points
5. **Release** - Conduit recalculates path and all tooling

**Snapping Priority:**
1. instaCell nodes (if Anchor = Default or Cells)
2. instaCombination centers (if Anchor = Default or Combination)
3. instaCombination edges
4. Log course lines (in log walls)
5. Free point (if no snap target nearby)

### Double-Click Behavior

Double-clicking the conduit executes **Flip Face** command, instantly toggling to opposite side of element.

## Tooling Generated

The script creates different tool types based on geometry and element structure:

### Beam Tools

| Tool Type | Condition | Generated When |
|-----------|-----------|----------------|
| **Drill** | Round conduit (Depth=0) | Conduit intersects GenBeam |
| **BeamCut Slot** | Rectangular conduit (Depth>0) | Conduit intersects GenBeam |
| **Routed Profile** | Custom profile defined | Conduit intersects GenBeam |
| **Segmented Drills** | Split=Yes | Conduit crosses multiple beams |

**Beam Tool Properties:**
- Diameter/Width from conduit properties
- Direction = conduit path vector
- Depth = full beam penetration
- Gap spacing at beam centers (if Split=Yes)

### Element Tools

| Tool Type | Condition | Generated When |
|-----------|-----------|----------------|
| **ElemDrill** | Round conduit, Element type = StickFrame/Roof | Tool Index ≠ -1 |
| **ElemNotch** | Rectangular conduit, Element type = StickFrame/Roof | Tool Index ≠ -1 |

**Element Tool Assignment:**
- Respects Zone parameter for multi-layer walls
- Uses Tool Index for manufacturing layer grouping
- Applied to element-level machining (affects multiple beams)

### Edge Tools (Panel Penetrations)

| Tool Type | Condition | Generated When |
|-----------|-----------|----------------|
| **Drill** | Edge Height = 0 | Conduit exits through panel (OSB, Gypsum, etc.) |
| **Pocket** | Edge Height > 0 | Recessed opening required at panel surface |

**Edge Tool Positioning:**
- Automatically placed at panel intersections
- Diameter/Depth from Edge Tool properties
- Offset parameter shifts tool along conduit direction
- Typical for electrical outlet boxes, vent terminations

### Log Wall Special Handling

For log construction:

1. **Detects Log Courses** - Identifies horizontal log separations
2. **Segments Conduit** - Splits routing at each course
3. **Creates Course Drills** - Individual drill per log
4. **Maintains Alignment** - Vertical alignment maintained across courses

Configuration:
```
Strategy Settings:
- Split: Yes
- Gap Genbeam: 10mm (gap between logs)

Result:
[Drill Log 1] -10mm gap- [Drill Log 2] -10mm gap- [Drill Log 3]
```

## Hardware Components

Hardware components represent the physical MEP items installed in conduits.

### Hardware Assignment Workflow

1. **Select Conduit** - Click conduit instance
2. **Right-Click** - Select "Set Strategy Hardware"
3. **Hardware Dialog Opens** - Standard hsbCAD hardware component dialog
4. **Add Components**:
   - Click "Add"
   - Article Number: "COND-M20-25"
   - Name: "Corrugated Electrical Conduit"
   - Description: "M20 flexible corrugated conduit"
   - Manufacturer: "Brand X"
   - Model: "FlexiGuard M20"
   - Material: "Polypropylene"
   - Category: "Conduit"
5. **OK** - Hardware saved to strategy

### Hardware Properties

| Property | Description | Example |
|----------|-------------|---------|
| Article Number | SKU/part number | "COND-M20-25" |
| Name | Component name | "Corrugated Conduit" |
| Description | Detailed description | "Flexible conduit M20 25m roll" |
| Manufacturer | Brand/supplier | "Brand X" |
| Model | Model designation | "FlexiGuard M20" |
| Material | Material composition | "Polypropylene" |
| Category | Component category | "Conduit" (default) |

### Hardware Scaling

The script automatically populates hardware dimensions:
- **ScaleX** = Conduit length (calculated from path)
- **ScaleY** = Diameter/Width
- **ScaleZ** = Depth/Height

These appear in hardware BOM and can be referenced in tag formats using `@(ScaleX)`, `@(ScaleY)`, `@(ScaleZ)`.

### Multiple Hardware Components

A single conduit can carry multiple components:
- Main conduit tube
- Interior cables/wires
- Pull strings
- Support clips

Each component tracked separately in BOM with shared geometry.

## Settings Files

### Storage Locations

Settings stored in XML format at two locations:

**Company Settings** (User-customizable):
```
[CompanyPath]\TSL\Settings\instaConduit_Settings.xml
```

**Installation Settings** (Software defaults):
```
[InstallPath]\Content\General\TSL\Settings\instaConduit_Settings.xml
```

**Priority:** Company settings override installation settings.

### Settings Content

The XML file contains:
- **Strategy[]** - Array of all saved strategies
  - Name, Profile, Split, Gaps
  - Tagging settings (Mode, Format, DimStyle, TextHeight)
  - Transparency settings (PlanView, ElementView)
  - Hardware[] - Components assigned to strategy
- **Default Strategy** - Fallback when no strategy selected

### Import/Export Workflow

**Export:**
1. Configure strategies in project
2. Right-click conduit → "Export Settings"
3. Confirm overwrite if file exists
4. XML file saved to company path

**Import:**
1. Receive XML file from colleague/another project
2. Copy to company settings path
3. Right-click conduit → "Import Settings"
4. Strategies merge with existing settings

**Use Cases:**
- Office standardization - Share company MEP standards
- Project templates - Include MEP configurations in starter files
- Vendor catalogs - Import hardware libraries
- Backup - Save custom configurations

## Advanced Techniques

### Multi-Zone Element Routing

For walls with multiple layers (e.g., exterior cladding + structure + interior finish):

**Scenario:** Route electrical in interior zone, plumbing in exterior zone

1. **Set Zone for Electrical**:
   - Select electrical conduit
   - Zone = -1 (interior)
   - Face = "Opposite Side" (auto-set)
   - Conduit routes through interior layer only

2. **Set Zone for Plumbing**:
   - Select plumbing conduit
   - Zone = 1 (exterior)
   - Face = "Reference Side" (auto-set)
   - Conduit routes through exterior layer only

**Result:** Each service isolated to appropriate building layer.

### Complex Free Path Routing

For routing around obstacles:

1. **Initial Placement** - Place conduit between two cells
2. **Add First Vertex** - Right-click → "Add Vertex" → Click obstacle bypass point
3. **Add Second Vertex** - Right-click → "Add Vertex" → Click return point
4. **Adjust Radius** - Set "Radius Contour" = 50mm for smooth curves
5. **Fine-Tune** - Drag vertex grips to perfect path

**Path Behavior:**
- Radius = 0: Sharp 90° corners
- Radius = 20mm: Gentle curves (small conduits)
- Radius = 100mm: Wide sweeping curves (large ducts)

### Rectangular Duct Routing

For HVAC ductwork:

1. **Geometry Settings**:
   - Diameter/Width = 300mm
   - Depth = 150mm
   - Radius Contour = 0 (sharp corners acceptable for sheet metal)

2. **Edge Tool**:
   - Diameter/Width = 320mm (20mm clearance)
   - Depth = 170mm
   - Height = 50mm (recessed into panel)

3. **Strategy**:
   - Name = "HVAC 300x150"
   - Split = No (continuous duct)
   - Plan View Transparency = 60 (visible but not dominant)

**Result:** Sheet metal duct with proper clearances and panel pockets.

### Standalone Beam Drilling

For simple penetrations without MEP framework:

1. **Select GenBeams** - Select set of beams to penetrate
2. **Insert Conduit** - Script enters standalone mode
3. **Click Start** - First beam penetration point
4. **Click End** - Exit point on opposite side
5. **Adjust Diameter** - Properties palette → Diameter = required size

**Use Cases:**
- Temporary routing during design
- Single service penetrations
- Retrofit installations
- Simple beam boring

### Log Wall Vertical MEP Routing

For running services vertically through log courses:

1. **Place Vertical Cells**:
   - instaCell at floor level (course 1)
   - instaCell at ceiling level (course 8)

2. **Connect with Conduit**:
   - Click first cell (bottom)
   - Click second cell (top)
   - Script detects log wall, creates segmented path

3. **Configure Gaps**:
   - Strategy → Split = Yes
   - Gap Genbeam = 15mm (log settlement gap)

**Result:** Vertical conduit segments through each log with settlement gaps.

### Custom Profile Conduits

For non-standard cross-sections:

**Scenario:** Corrugated drainage pipe with annular ribs

1. **Draw Profile**:
   - Create closed polyline showing outer corrugation
   - Create inner polyline for hollow core
   - Place in model space

2. **Create Strategy**:
   - Name = "Drainage Corrugated 110mm"
   - Profile = "Select Shape"
   - Select both polylines
   - Larger = outer, smaller = inner void

3. **Apply to Conduit**:
   - Select conduit
   - Strategy = "Drainage Corrugated 110mm"

**Result:** Conduit extrudes realistic corrugated profile along path.

## Troubleshooting

### Conduit Not Snapping to Cells

**Symptoms:** Grip won't snap to cell triangle markers

**Solutions:**
1. Check **Anchor** property = "Default" or "Cells" (not "Combination")
2. Verify cells are on same face as conduit (check Face property)
3. Ensure cells are part of same combination/element
4. Check if cells are valid (not erased or corrupted)

### Drilling Not Generated

**Symptoms:** Conduit placed but no drill tools created

**Solutions:**
1. Verify conduit actually intersects beams (check 3D view)
2. Ensure Depth = 0 for drill tools (Depth>0 creates slots)
3. Check Tool Index ≠ -1 (if using element tools)
4. Verify beams are GenBeam entities, not simple lines
5. Recalculate: Select conduit → Right-click → Properties → Change any value

### Strategy Not Saving

**Symptoms:** Created strategy disappears after closing drawing

**Solutions:**
1. Verify company path is writable (check Windows permissions)
2. Use "Export Settings" to manually save XML
3. Check if MapObject "hsbTSL" exists (use `hsb_MapObjectList` command)
4. Ensure strategy name is unique (no duplicate names)

### Conduit on Wrong Face

**Symptoms:** Conduit appears on opposite side of wall

**Solutions:**
1. **Quick Fix:** Double-click conduit (executes Flip Face)
2. **Property Fix:** Face = "Reference Side" or "Opposite Side"
3. **Combination Fix:** If "byCombination", verify combination face direction
4. **Zone Fix:** Check Zone sign (positive=outside, negative=inside)

### Path Not Following Vertices

**Symptoms:** Polygonal path ignores added vertices

**Solutions:**
1. Check **Connection Type** in _Map (should be 5 for free path)
2. Verify **Radius Contour** not too large (reduces to straight line)
3. Use "Reset Path" then re-add vertices
4. Ensure vertices not coincident (minimum 1mm separation)

### Edge Tools Missing

**Symptoms:** Conduit penetrates panel but no edge tool created

**Solutions:**
1. Check **Edge Tool** → **Diameter/Width** > 0
2. Verify conduit actually intersects panel (not just beams)
3. Ensure panel is Sheet or Element entity
4. Check if conduit endpoints are inside element (not at edges)
5. Adjust **Offset** parameter to position tool correctly

### Transparency Not Working

**Symptoms:** Conduit remains opaque despite high transparency setting

**Solutions:**
1. Verify transparency set in **active view type** (Plan vs Element)
2. Check AutoCAD TRANSPARENCY system variable enabled
3. Regenerate drawing (`REGEN` command)
4. Ensure graphics driver supports transparency
5. Try different transparency value (some values may not render)

### Segmented Gaps Incorrect

**Symptoms:** Gaps at beam intersections wrong size or missing

**Solutions:**
1. Strategy → **Split** = Yes
2. Check **Gap Genbeam** value matches desired gap
3. Verify beams are parallel to each other (angled beams may calculate differently)
4. Recalculate conduit after changing gap value
5. For log walls, ensure log courses detected (check course lines visible)

## Tips and Best Practices

### Planning and Organization

1. **Design MEP Zones First**
   - Place instaCombination and instaCell scripts before routing conduits
   - Establish clear zones for different MEP systems (electrical, plumbing, HVAC)
   - Use consistent zone assignments across project

2. **Use Strategies for Consistency**
   - Create named strategies for each MEP system type
   - Include diameter, gap settings, and hardware in strategy
   - Share strategies across team via XML export
   - Document strategy naming conventions

3. **Layer Management**
   - Assign conduits to appropriate AutoCAD layers
   - Use layer naming: MEP_ELECTRICAL, MEP_PLUMBING, MEP_HVAC
   - Control visibility by layer for different drawing views
   - Freeze MEP layers when not needed

### Placement Techniques

4. **Snap to Centers for Flexibility**
   - When connecting to combinations, snap to centers rather than edges
   - Allows combination resizing without breaking conduits
   - Use "Connect to Center" command to convert edge connections

5. **Consider Manufacturing**
   - Set Tool Index to match production workflow stages
   - Index 1 = rough-in drilling, Index 2 = final boring
   - Coordinate with CNC export settings
   - Check drill depths don't exceed tooling capacity

6. **Zone-Aware Placement**
   - In multi-layer walls, explicitly set Zone parameter
   - Positive zones (1,2) = exterior layers
   - Negative zones (-1,-2) = interior layers
   - Prevents accidental routing through wrong layer

### Geometry Configuration

7. **Rounded Corners for Flexibility**
   - For flexible conduit/cable routing, set Radius Contour = 50-100mm
   - Prevents sharp bends that damage cables
   - Matches minimum bend radius requirements
   - Improves cable pulling ease

8. **Edge Tool Sizing**
   - Set edge tool diameter 10-20mm larger than conduit for clearance
   - For outlet boxes, use Height parameter to create recessed pocket
   - Offset parameter positions box relative to conduit centerline
   - Test fit with actual hardware dimensions

9. **Custom Profiles for Realism**
   - Use custom profiles for corrugated conduit, cable trays, complex ducts
   - Save profile polylines on dedicated layer for reuse
   - Include profile in strategy for one-click application
   - Verify profile orientation matches conduit path direction

### Workflow Optimization

10. **Grip Editing vs Properties**
    - Use grip editing for quick position changes
    - Use Properties palette for precise dimensional control
    - Double-click for fast face flipping
    - Combine methods: grip to rough position, properties to fine-tune

11. **Transparency for Clarity**
    - Set high transparency (80-90%) during structural design phase
    - Reduce transparency (40-60%) during MEP coordination
    - Use 0% transparency for final MEP shop drawings
    - Different transparency for plan vs element views

12. **Hide Tools When Not Needed**
    - Right-click → "Hide Tools" to reduce visual clutter
    - Tools remain functional even when hidden
    - Show tools only for manufacturing review
    - Improves performance in complex models

### Coordination

13. **Log Wall Considerations**
    - Always enable Split for log wall conduits
    - Set Gap Genbeam to match log settlement gap (typically 15-25mm)
    - Snap to course lines for proper vertical alignment
    - Account for log compression over time

14. **SIP Wall Integration**
    - For SIP panels, conduits typically route between panel joints
    - Avoid penetrating SIP foam core if possible
    - Use edge tools for panel face transitions
    - Coordinate with SIP manufacturer requirements

15. **Hardware BOM Integration**
    - Assign hardware to strategies, not individual conduits
    - Use Article Numbers that match procurement system
    - Include length formula in tag format: @(ScaleX:RL0)
    - Export BOM using HSB_G-BillOfMaterial script

### Quality Control

16. **Verify Tooling Generation**
    - After placement, zoom to beam intersections and verify drills created
    - Check drill diameters match conduit specifications
    - Ensure edge tools present at panel exits
    - Recalculate if tools missing (select, change property, change back)

17. **Check Clearances**
    - Verify minimum spacing between parallel conduits
    - Ensure adequate clearance from structural members
    - Check clearance to adjacent elements (windows, doors)
    - Account for insulation thickness in walls

18. **Validate Zones**
    - In multi-zone walls, verify conduit in correct layer
    - Check Face parameter matches design intent
    - Ensure tooling doesn't penetrate unintended layers
    - Review in section view for accuracy

### Documentation

19. **Tagging Strategy**
    - Use byPath tagging for simple conduits (one label)
    - Use bySegment for segmented conduits needing individual lengths
    - Format tags for clarity: "@(Name) @(ScaleY:R0)mm L=@(ScaleX:RL0)mm"
    - Set text height appropriate for drawing scale

20. **Settings Backup**
    - Regularly export settings to XML
    - Store XML in version control with project files
    - Document custom strategies in project specifications
    - Share settings during team coordination meetings

## Related Scripts

### Insta Suite (MEP System)

| Script | Purpose | Relationship |
|--------|---------|--------------|
| **instaCombination** | Defines MEP installation zones within elements | Parent container for conduits and cells |
| **instaCell** | Defines specific connection nodes for conduits | Provides snap points for conduit endpoints |

**Typical Suite Usage:**
1. Place instaCombination to define MEP zone
2. Place instaCell instances at device locations
3. Route instaConduit between cells

### Drilling and Cutting

| Script | Purpose | Use Case |
|--------|---------|----------|
| **hsbDrill** | Basic drilling operations | Manual drill placement, non-conduit holes |
| **DrillDistribution** | Array drilling patterns | Repetitive drill patterns |
| **hsbSlot** | Slot/groove operations | Rectangular slots, cable trays |
| **FreeDrill** | Free-form drilling | Complex drill angles |

### Element Operations

| Script | Purpose | Use Case |
|--------|---------|----------|
| **HSB_E-Insulation** | Insulation layer placement | Coordinate with conduit Zone parameter |
| **HSB_E-NailClusters** | Nailing patterns | Avoid nail interference with conduits |
| **hsbElementInsulation** | Advanced insulation | Multi-layer insulation coordination |

### Documentation

| Script | Purpose | Use Case |
|--------|---------|----------|
| **HSB_G-BillOfMaterial** | Generate BOM | Export conduit hardware to material list |
| **hsbViewTag** | View tagging | Annotate conduit in shop drawings |
| **HSB_D-Element** | Element display settings | Control conduit visibility in drawings |

### Shop Drawing

| Script | Purpose | Use Case |
|--------|---------|----------|
| **sd_ABeamcutDE** | Beam cut shop drawings | Show conduit penetrations |
| **sd_DrillDE** | Drill shop drawings | Detail conduit drilling |
| **HSB_G-EntityInformation** | Entity info extraction | Query conduit properties |

## Frequently Asked Questions

### General

**Q: What's the difference between instaConduit and hsbDrill?**

A: **instaConduit** creates intelligent MEP routing paths that automatically generate appropriate tooling (drills, slots, profiles) based on geometry and connect to the Insta Suite MEP framework. **hsbDrill** creates simple standalone drill operations without path routing or MEP integration.

**Q: Can I use instaConduit without instaCombination and instaCell?**

A: Yes, the script supports **standalone mode** where you select GenBeams or Elements directly and click start/end points. However, you lose the benefits of MEP zone organization, snapping, and intelligent routing.

**Q: How do I change conduit diameter after placement?**

A: Select the conduit, open Properties palette (Ctrl+1), change **Diameter/Width** value. Alternatively, select a different **Strategy** with desired diameter. The conduit and all tooling recalculate automatically.

**Q: Why isn't my conduit snapping to cell center?**

A: Ensure **Anchor** property is set to "Default" or "Cells" (not "Combination"). Also verify the cell is on the same face as your conduit (check **Face** property matches cell's combination face).

### Geometry and Routing

**Q: How do I create a rectangular conduit?**

A: Set **Depth** parameter > 0. Example: Diameter/Width = 150mm, Depth = 80mm creates a 150x80mm rectangular cross-section. The script automatically generates slot/beamcut tools instead of drills.

**Q: Can I route a conduit around obstacles?**

A: Yes, use **free path mode**:
1. Place conduit between two points
2. Right-click → "Add Vertex"
3. Click location to bypass obstacle
4. Repeat to add more vertices
5. Adjust **Radius Contour** to smooth corners

**Q: How do I make smooth curves instead of sharp corners?**

A: Set **Radius Contour** property to desired curve radius (e.g., 50mm for gentle curves). 0mm = sharp 90° corners. Larger values = smoother curves.

**Q: What's the maximum number of vertices for a free path?**

A: No hard limit, but practical maximum is 10-15 vertices for performance. Complex paths with many vertices may slow recalculation.

### Tools and Machining

**Q: Why are no drill tools being created?**

A: Check these common issues:
1. Conduit doesn't actually intersect beams (check 3D view)
2. Depth > 0 (creates slots instead of drills)
3. Tool Index = -1 (disables element tools)
4. Conduit type incompatible with structure (try recalculating)

**Q: How do I control which manufacturing stage receives the tooling?**

A: Use **Tool Index** parameter. Example: Index 1 = rough-in drilling, Index 2 = final boring, Index -1 = no element tools. Different indices can be exported separately for CNC programming.

**Q: What's the difference between beam tools and element tools?**

A: **Beam tools** are applied to individual GenBeam entities. **Element tools** (ElemDrill, ElemNotch) are applied at the element level and affect multiple beams simultaneously. Element tools only work with StickFrame and Roof elements.

**Q: How do I create edge penetrations with recessed boxes?**

A: Use **Edge Tool** parameters:
- **Diameter/Width** = box outer dimension
- **Height** = recess depth into panel (e.g., 50mm)
- **Depth** > 0 for rectangular box
- **Offset** = shift box position along conduit

### Strategies and Settings

**Q: Where are my strategies saved?**

A: Strategies stored in XML at:
- `[CompanyPath]\TSL\Settings\instaConduit_Settings.xml` (user settings)
- `[InstallPath]\Content\General\TSL\Settings\instaConduit_Settings.xml` (defaults)

Company settings override installation settings.

**Q: How do I share strategies with my team?**

A:
1. Configure strategies in your project
2. Right-click conduit → "Export Settings"
3. Share the XML file with team members
4. Team members: Right-click → "Import Settings"

**Q: Can I have different strategies for different trades?**

A: Yes, recommended practice:
- "Electrical 20mm" - small diameter, no split, electrical hardware
- "Plumbing 50mm" - larger diameter, split=yes for flexibility
- "HVAC 300x150" - rectangular, large dimensions, duct hardware

**Q: What happens if I delete a strategy that's being used?**

A: Conduits using deleted strategy revert to "\<Default\>" strategy. Existing conduit geometry preserved, but loses strategy-specific settings (gaps, tagging, hardware).

### Zones and Multi-Layer Elements

**Q: What are zones and when do I need them?**

A: **Zones** are layers in multi-layer walls (e.g., exterior cladding + structure + interior finish). Use zones when:
- Wall has multiple distinct layers (check Element properties)
- Need to route electrical in interior layer, plumbing in exterior layer
- Want precise control over which layer receives conduit tooling

Zone 0 = default/center, positive (1,2,3) = exterior, negative (-1,-2,-3) = interior.

**Q: Why is the Face parameter grayed out?**

A: When **Zone** ≠ 0, Face parameter auto-sets based on zone sign and becomes read-only. Positive zones force "Reference Side", negative zones force "Opposite Side".

**Q: Can a single conduit span multiple zones?**

A: No, each conduit instance operates in one zone. For multi-zone routing, place separate conduit instances per zone and connect them at zone boundaries.

### Hardware and BOM

**Q: How do I add hardware components to conduits?**

A:
1. Select conduit
2. Right-click → "Set Strategy Hardware"
3. Click "Add" in dialog
4. Fill in Article Number, Name, Manufacturer, etc.
5. Click OK

Hardware saves to current strategy, applies to all conduits using that strategy.

**Q: Can one conduit have multiple hardware components?**

A: Yes, add multiple entries in hardware dialog. Example:
- Component 1: Conduit tube
- Component 2: Pull wire inside conduit
- Component 3: Support clips

All components share same geometry (length, diameter).

**Q: How do I export conduit hardware to BOM?**

A: Use **HSB_G-BillOfMaterial** script:
1. Run script
2. Select conduits (or entire element)
3. BOM generates showing all hardware components with quantities
4. Export to Excel/PDF

**Q: What do ScaleX, ScaleY, ScaleZ represent?**

A:
- **ScaleX** = Conduit length (calculated from path)
- **ScaleY** = Diameter/Width
- **ScaleZ** = Depth/Height

Use in tag formats: `@(ScaleX:RL0)` shows length rounded to 0 decimals.

### Performance and Troubleshooting

**Q: My conduit takes a long time to recalculate. How do I speed it up?**

A:
1. Reduce **Radius Contour** (large radii require more calculations)
2. Simplify path (fewer vertices)
3. Disable **Split** if not needed
4. Hide tools when not editing (`Hide Tools` command)
5. Reduce transparency settings (transparency rendering is expensive)

**Q: Conduit appears on wrong side of wall after double-clicking. How do I fix?**

A: Double-clicking executes **Flip Face**. To restore:
- Double-click again (flips back), OR
- Properties → **Face** → select correct side, OR
- Right-click → "Flip Face"

**Q: I deleted a cell and now conduit won't recalculate. How do I fix?**

A: Conduit maintains dependency on deleted cell. Solutions:
1. **Undo** cell deletion (if possible)
2. **Reconnect**: Drag grip to new cell
3. **Delete and Recreate**: Erase conduit, place new one

**Q: Custom profile conduit shows wrong orientation. How do I rotate the profile?**

A: Profile orientation determined by:
1. First polyline's coordinate system
2. Conduit path direction vector
3. Element face normal

To fix:
1. Rotate profile polyline in model before selecting
2. Ensure polyline Z-axis matches desired orientation
3. Recreate strategy with corrected profile

## Advanced Workflows

### Creating a Complete MEP System

**Scenario:** Design electrical system for timber-frame wall

**Step-by-Step:**

1. **Define Installation Zone**
   - Place **instaCombination** on wall element
   - Set zone boundaries (typically 100mm from top/bottom plates)
   - Align to interior face

2. **Place Outlet Locations**
   - Insert **instaCell** at each outlet position (300mm, 600mm, 900mm heights)
   - Set cell orientation to match outlet mounting

3. **Create Strategies**
   - **Strategy "Electrical 20mm"**:
     - Diameter: 20mm
     - Split: No (continuous conduit)
     - Transparency Plan: 80%
     - Tag Mode: byPath
     - Format: "@(ArticleNumber) L:@(ScaleX:RL0)mm"

   - **Strategy "Electrical 32mm Main"**:
     - Diameter: 32mm
     - Split: No
     - Transparency Plan: 60% (more visible)
     - Hardware: "Main feeder cable 6mm²"

4. **Route Branch Conduits** (20mm)
   - Connect each outlet cell to main distribution cell
   - Strategy: "Electrical 20mm"
   - Verify snapping to cell centers

5. **Route Main Feeder** (32mm)
   - Connect distribution cell to panel location
   - Strategy: "Electrical 32mm Main"
   - Add vertices to route around structural members

6. **Add Edge Tools**
   - Each conduit at outlet location:
     - Edge Diameter: 70mm (outlet box)
     - Edge Height: 45mm (recessed box depth)

7. **Assign Hardware**
   - Right-click branch conduit → "Set Strategy Hardware"
   - Add: "Corrugated conduit M20"
   - Add: "Cable 3x1.5mm²"

8. **Verify and Document**
   - Check all drill tools generated
   - Verify clearances from structural fasteners
   - Add tags (byPath mode)
   - Export BOM

### Log Wall Vertical Service Core

**Scenario:** Route plumbing vertically through log wall courses

**Workflow:**

1. **Identify Course Structure**
   - Log wall with 8 courses
   - Course height: 200mm
   - Settlement gaps: 20mm

2. **Place Vertical Cells**
   - **instaCell** at floor (course 1, height 0)
   - **instaCell** at ceiling (course 8, height 1600mm)
   - Align cells vertically (same X,Y coordinates)

3. **Create Log Wall Strategy**
   - Name: "Plumbing Vertical 50mm"
   - Diameter: 50mm
   - Split: **Yes**
   - Gap Genbeam: 20mm (settlement gap)
   - Gap Combination: 0mm

4. **Route Conduit**
   - Click floor cell
   - Click ceiling cell
   - Script detects log wall, creates segmented path

5. **Verify Segmentation**
   - 8 individual drill segments (one per course)
   - 20mm gaps between segments
   - All drills aligned vertically

6. **Configure Edge Tools**
   - Bottom exit (floor):
     - Diameter: 70mm (floor penetration sleeve)
     - Height: 100mm (pocket into floor)
   - Top exit (ceiling):
     - Diameter: 60mm (standard pipe collar)
     - Height: 0mm (drill through)

7. **Add Hardware**
   - Main: "PVC drain pipe 50mm"
   - Accessory: "Pipe sleeve 50mm"
   - Accessory: "Fire collar 50mm" (at ceiling)

**Result:** Vertical plumbing chase with proper settlement gaps, aligned through all courses.

### HVAC Rectangular Duct Distribution

**Scenario:** Route rectangular HVAC ductwork across ceiling joists

**Implementation:**

1. **Place Distribution Points**
   - **instaCombination** spanning ceiling element
   - **instaCell** at each HVAC register location
   - **instaCell** at mechanical unit

2. **Create HVAC Strategy**
   - Name: "HVAC Main 400x200"
   - Diameter/Width: 400mm
   - Depth: 200mm
   - Radius Contour: 150mm (smooth duct bends)
   - Split: No
   - Plan View Transparency: 50%

3. **Route Main Trunk**
   - Connect mechanical unit cell to center distribution cell
   - Add vertices to navigate around structural members
   - Verify rectangular slots generated at joist intersections

4. **Route Branches**
   - Create "HVAC Branch 250x150" strategy (smaller)
   - Connect distribution cell to each register cell
   - Use free path routing for complex runs

5. **Configure Edge Tools**
   - At register penetrations:
     - Diameter/Width: 300mm (register boot opening)
     - Depth: 200mm
     - Height: 80mm (recessed boot pocket)
     - Radius: 20mm (rounded corners)

6. **Verify Clearances**
   - Minimum 50mm from electrical conduits
   - Adequate slope for condensate drainage (if required)
   - Clearance for duct insulation thickness

7. **Tag for Fabrication**
   - Tag Mode: bySegment
   - Format: "@(ScaleY:R0)x@(ScaleZ:R0) L:@(ScaleX:RL0)"
   - Shows: "400x200 L:2450" (dimensions and length per segment)

8. **Export Shop Drawings**
   - Use shop drawing scripts to detail duct penetrations
   - Include drill/slot dimensions for fabrication
   - Export BOM with duct lengths and fittings

**Result:** Complete HVAC distribution system with accurate fabrication data.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.2 | 2022-09-06 | Centered anchoring of combination supported, new property to toggle available anchor nodes |
| 4.1 | 2022-09-06 | New command to list all available commands for UI creation |
| 4.0 | 2022-08-04 | Snapping to center of combinations improved |
| 3.9 | 2022-07-29 | Snapping accepts also center of combination |
| 3.8 | 2022-07-26 | Segmented drills fixed when based on strategy and not connected to sides |
| 3.7 | 2022-03-18 | Bugfix default strategy, drill support for straight-to-edge grip mode |
| 3.6 | 2022-01-21 | Bugfix support drill tools in floor elements |
| 3.5 | 2021-12-15 | Hardware supports strategies with multiple components |
| 3.4 | 2021-12-15 | Bugfixes flip direction, jig on loose conduits |
| 3.3 | 2021-12-10 | Bugfix selection loose genbeams |
| 3.2 | 2021-12-06 | Multiple hardware entries, standard hardware dialog support |
| 3.1 | 2021-12-01 | New settings to control genbeam and combination offsets, solids not facetted |
| 3.0 | 2021-11-29 | Extended strategy system |
| 2.9 | 2021-11-24 | New Strategy property, commands for add/edit/delete strategy, import/export settings |
| 2.8 | 2021-09-30 | Element tools for stickframe and roof elements, new tooling options, Tool Index property |
| 2.7 | 2021-09-17 | Jigging with top or bottom edge direction improved |
| 2.6 | 2021-09-16 | Conduit supports rule-based insertion |
| 2.5 | 2021-08-20 | Standalone insertion mode, command to extend segmented instances |
| 2.4 | 2021-07-20 | New properties for lateral offset of start and end points |
| 2.3 | 2021-07-20 | Additional group assignment supported |
| 2.2 | 2021-07-19 | Conduit drills for log walls with vertical cells |
| 2.1 | 2021-06-28 | Polygonal conduits for log walls |
| 2.0 | 2021-06-25 | Polygonal conduits for stick-frame walls |
| 1.9 | 2021-04-22 | Zone property for multi-zone element support |
| 1.8 | 2021-03-31 | Debug graphics removed |
| 1.7 | 2021-03-30 | Sharp edges if radius=0, Add/Remove vertex commands |
| 1.6 | 2021-03-29 | Radius Contour property for polygonal paths |
| 1.5 | 2021-03-19 | Enhanced free path and preview jigs |
| 1.4 | 2021-03-17 | Optional free path added |
| 1.3 | 2021-03-16 | Angled conduits start and end at cell center |
| 1.2 | 2021-03-15 | Element support added |
| 1.1 | 2021-03-02 | Properties to specify edge tool |
| 1.0 | 2021-02-17 | Initial release |

## Technical Notes

### Script Classification
- **Category**: MEP (Mechanical, Electrical, Plumbing)
- **Primary Function**: MEP routing and penetration tooling
- **Complexity**: Advanced (multi-mode operation, strategy system)

### Dependencies
- **Required**: instaCombination (for zone-based routing)
- **Optional**: instaCell (for node-based routing)
- **Compatible**: All hsbCAD timber construction elements

### Performance Characteristics
- **Recalculation Speed**: Fast for simple paths, moderate for complex multi-vertex paths
- **Model Impact**: Low (tooling embedded in beams/elements)
- **Memory Usage**: Low per instance, scales linearly with conduit count

### MapObject Storage
- **MapObject Name**: "hsbTSL"
- **MapObject Key**: "instaConduit_Settings"
- **Persistence**: Per-drawing and global (via XML)

### Coordinate Systems
- **Insertion Point (_Pt0)**: Average of grip points
- **Path Direction**: Defined by first grip to second grip vector
- **Face Normal**: Perpendicular to element face (vecZ)
- **Lateral Direction**: Cross product of path and face normal

### Color Coding (Debug Mode)
When debug enabled, script uses color-coded visualization:
- Blue (rgb 69,84,185): Primary path
- Green (rgb 19,155,72): Valid snap targets
- Orange (rgb 242,103,34): Active grip
- Red (rgb 205,32,39): Invalid/error state

---

**Document Size:** ~30KB
**Coverage:** Comprehensive user guide covering all features, workflows, and troubleshooting
**Target Audience:** Non-programmer CAD operators and timber structure designers
**Last Updated:** 2026-02-20
