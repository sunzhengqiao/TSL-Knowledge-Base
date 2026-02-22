# hsbNailing

## Overview

**hsbNailing** is a comprehensive, catalog-driven nailing automation system for hsbCAD elements. It automatically generates nail line patterns on walls, floors, roofs, and multi-elements by analyzing the element's geometry, zones, materials, and framing members. The script supports four distinct nailing modes—**Nail on Laths**, **Nail on Sheeting**, **Nail on Studs**, and **Nail on Stud Grid**—each producing correctly positioned nail lines according to industry standards and user-defined parameters.

Once the computed nail positions are satisfactory, the user can release them as permanent **NailLine** entities for CNC manufacturing output. The system uses a sophisticated catalog-based matching system that automatically applies the correct nailing configurations based on element properties such as zone, material, wall code, exposure, and load-bearing status.

## Usage Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Space | Model Space |
| Required Beams | 0 |
| Implicit Insert | Yes |
| Script Version | 5.3 (October 2022) |
| Keywords | Element; Nailing, CNC; Nail |

## Prerequisites

### Essential Requirements

1. **hsbCAD Elements**: One or more Elements (walls, floors, roofs, or multi-elements) must exist in the model.

2. **Catalog Configuration**: Before first use, you must configure catalog entries. The script uses sub-type catalog entries named:
   - `hsbNailing-Lath` - For nailing on laths/battens
   - `hsbNailing-Sheet` - For nailing on sheet panels
   - `hsbNailing-Stud` - For nailing on studs/framing members
   - `hsbNailing-StudGrid` - For nailing on stud grids with spacing optimization

3. **Element Structure**: Elements must have:
   - Properly assigned **zones** with beams/sheets placed in the correct zone indices
   - Correct **material assignments** for automatic catalog matching
   - Valid **zone geometry** (zone height > 0)

### Optional Configuration

- **XML Settings File** (`hsbNailing.xml`) can be placed in `<Company Path>\TSL\Settings\` to define:
  - Material-based beam name filters (exclusive name lists)
  - Sheet-to-beam conversion behavior control

## Core Concepts

### Catalog-Driven Workflow

The script operates on a **catalog-based matching system**:

1. **Catalog entries** store complete nailing configurations (spacing, offsets, materials, filters)
2. During insertion, the script **automatically matches** catalog entries against element properties
3. Matching entries are instantiated as **sub-instances** on the element
4. Each sub-instance calculates and displays nail positions
5. User reviews and **releases** nail lines when satisfied

### Four Nailing Modes

| Mode | Name | Application | Zone Relationship |
|------|------|-------------|-------------------|
| 2 | Nail on Laths | Nails battens/laths to framing | Laths in nailing zone, framing in contact zone |
| 3 | Nail on Sheeting | Nails sheet panels to framing | Sheets in nailing zone, framing in contact zone |
| 4 | Nail on Studs | Nails sheeting centered on studs | Sheets in nailing zone, studs in contact zone |
| 5 | Nail on Stud Grid | Grid-optimized nailing on studs | Same as mode 4 with X-grid filtering |

### Zone System

The script operates across **element zones** (indexed -5 to 5, excluding 0):
- **Nailing Zone** (Tooling Zone): Contains the material to be nailed (sheets, laths)
- **Contact Zone**: Contains the supporting structure (framing beams, studs)
- **Zone indices** determine which layer of the element assembly is targeted

## Usage Steps

### Step 1: First-Time Setup (Creating Catalog Entries)

**Important**: You must create at least one catalog entry before applying nailing to elements.

1. Run `TSLINSERT` command and select `hsbNailing.mcr`
2. At the prompt "Select Element(s) <Enter> for setup", **press Enter** without selecting anything
3. A dialog appears with four nailing type options:
   - Nail on laths
   - Nail on sheeting
   - Nail on studs
   - Nail on grid studs
4. **Select the nailing type** you want to configure
5. **(Optional)** Select a GenBeam to automatically derive:
   - Tooling zone index
   - Material name
6. **(Optional)** Select a second GenBeam to derive contact zone material
7. The **Properties dialog** appears showing all parameters for the selected type
8. **Configure parameters** (spacing, offsets, materials, filters - see Parameter Reference below)
9. Click **OK** to save

The system automatically generates a catalog entry name encoding the configuration (e.g., "Z1 OSB MDF_Wall_Exterior").

**Repeat** this process for each combination of zone, material, and filter criteria you need.

### Step 2: Applying Nailing to Elements

Once catalog entries exist:

1. Run `TSLINSERT` and select `hsbNailing.mcr`
2. **Select one or more Elements** (walls, floors, roofs)
3. Press Enter

**What happens automatically:**
1. The script **erases** any previously attached hsbNailing instances and existing NailLine entities from selected elements
2. It collects all catalog entries across all four nailing types
3. For each element, it tests every catalog entry against:
   - Wall code (if specified in filter)
   - Element type (Wall/Floor/Roof/Multielement)
   - Exposed property (Interior/Exterior)
   - Load-bearing property
   - Material match in the specified zone
4. **Matching catalog entries** are instantiated as sub-instances on the element
5. Nail positions are calculated and displayed as colored temporary markers

### Step 3: Review Nail Positions

After automatic instantiation, the script computes nail line segments based on:

- **Intersection geometry**: Where sheeting/lath profiles contact framing member faces
- **Edge offsets**: User-defined spacing from edges
- **Spacing parameters**: Maximum distance between nails
- **Merge parameters**: Combining colinear nail lines across gaps
- **Sawline protection zones**: Automatic exclusion around saw cuts (≈2× zone height on each side)
- **No-nail zones**: Areas defined by other attached TSL scripts via `NoNailProfile` in their `subMapX`

The computed positions appear as colored markers corresponding to the **Nailing tool index**.

### Step 4: Release Nail Lines (Finalizing)

When satisfied with the nail positions:

**Method 1**: Right-click the script instance → Select **"Release Naillines"**

**Method 2**: Double-click the script instance

**Result**:
- All temporary nail markers convert to permanent **NailLine** database entities
- NailLine entities are attached to the element for CNC output
- The script instance is **automatically deleted**

**Warning**: This action is permanent (use AutoCAD Undo to revert if needed).

## Parameter Reference

Parameters are organized by category and vary by nailing mode. The script uses `setOPMKey()` to display mode-specific parameter sets.

### Common Parameters (All Modes)

#### Nailing Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone** | PropInt | Dropdown (-5 to 5) | The element zone index where the target beams/sheets to be nailed reside. Determines which layer of the element assembly receives nailing. |
| **Nailing tool index** | PropInt | 1 | The color/tool index assigned to the generated nail lines. Used to distinguish different nailing specifications for manufacturing. Corresponds to AutoCAD color index. |
| **Maximum nailing spacing** | PropDouble | 50 mm | The maximum distance between individual nails along a nail line. Controls nail density. Smaller values = more nails. |
| **Combine Nail Lines** | PropDouble | 0 mm | Merge tolerance for colinear nail lines across multiple sheets. If > 0, nail lines separated by less than this gap will be combined into continuous lines. Reduces fragmentation. |

#### Tooling Zone Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Material** | PropString | (empty) | Filters beams/sheets in the nailing zone by material name. Use semicolons to separate multiple entries (e.g., "OSB;Plywood"). Empty = all materials included. Case-insensitive comparison. |
| **Exclude Color** | PropInt | 0 | Excludes beams/sheets of this color index from the nailing zone. Set to 0 to disable color filtering. Useful for excluding temporary or special-purpose entities. |

#### Contact Zone Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Material (Contact)** | PropString | (empty) | Filters beams in the contact zone (framing members) by material name. Separate multiple entries with semicolons. Empty = all contact materials accepted. |
| **Exclude Color (Contact)** | PropInt | 0 | Excludes beams of this color index from the contact zone. Set to 0 to disable. |

#### Filter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Element Filter** | PropString | (empty) | Defines filter criteria for which elements the nailing applies to. Accepts:<br>• **Wall codes** (1-2 character codes, e.g., "A;B;C")<br>• **Element type names** ("Wall", "Floor", "Roof", "Multielement")<br>Separate multiple entries with semicolons. Case-insensitive. Numeric characters in codes are not allowed. |
| **Exposed** | PropString | Disabled | Filters wall elements by their exposed property:<br>• **Disabled**: No filtering<br>• **Interior**: Only interior walls<br>• **Exterior**: Only exterior walls |
| **Load Bearing Walls** | PropString | Disabled | Filters wall elements by load-bearing property:<br>• **Disabled**: No filtering<br>• **Not Load Bearing**: Only non-load-bearing walls<br>• **Load Bearing**: Only load-bearing walls |

### Mode 2: Nail on Laths (Additional Parameters)

This mode is for nailing laths/battens to underlying framing members.

#### Nailing Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Distance from sheeting edge** | PropDouble | 20 mm | The offset distance from the edge of the sheeting/lath zone inward. Creates an edge margin to prevent nails too close to sheet edges. |
| **Distance end beams** | PropDouble | 20 mm | The offset distance from the ends of beams or laths, preventing nails too close to beam ends where splitting might occur. |
| **Distance from beam edge** | PropDouble | 5 mm | The minimum side offset to the framing beam edge. Ensures nails land within the beam width. |

#### Nailing on Loose Sheeting Edges Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Max. Offset Vertical Nailline** | PropDouble | 50 mm | Maximum offset a vertical nail line may have relative to the corresponding sheeting edge. If exceeded, an additional vertical nail line is created on the underlying zone to support unsupported (loose) edges. |
| **Distance from sheeting edge (loose Edge)** | PropDouble | 50 mm | The edge offset for nail lines along loose (unsupported) sheeting edges. Typically larger than standard edge offset to account for edge conditions. |

**Logic**: Mode 2 creates nail lines centered on the intersection of lath profiles with framing member contact faces, with special handling for vertical edges that don't align with framing.

### Mode 3: Nail on Sheeting (Additional Parameters)

This mode nails sheet panels to framing, including both edge nailing and intermediate (field) nailing.

#### Nailing Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Offset Sheeting Edge** | PropDouble | 20 mm | The edge offset from the sheeting zone boundary. Applied to all edges when edge offset parameters are equal. |
| **Edge Offset Bottom** | PropDouble | 20 mm | The offset from edges pointing downward (bottom of sheets). Allows different edge treatment for bottom plate connections. |
| **Edge Offset Top** | PropDouble | 20 mm | The offset from edges pointing upward (top of sheets). Allows different edge treatment for top plate connections. |
| **Distribution Type** | PropString | Horizontal even | The orientation and distribution method for intermediate nail lines within a sheet panel:<br>• **Horizontal even**: Evenly distributed horizontal lines<br>• **Vertical even**: Evenly distributed vertical lines<br>• **Horizontal fixed**: Fixed spacing horizontal lines (uses Module value)<br>• **Vertical fixed**: Fixed spacing vertical lines (uses Module value) |
| **Module** | PropDouble | 410 mm | The maximum spacing for intermediate nail lines within the sheet interior. For "even" modes, this is the maximum spacing; for "fixed" modes, this is the exact interval. Common values: 410 mm (16" centers), 305 mm (12" centers). |

#### Contact Zone Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Combine Nail Lines (Contact)** | PropDouble | 0 mm | Merge tolerance for the contact zone profile. Allows combining profiles of adjacent framing members to create continuous nailing across multiple studs. |
| **Distance from sheeting edge (Contact)** | PropDouble | 5 mm | Edge offset applied to the contact zone profile. Controls how far from the contacting sheet edges nailing begins on the framing side. |

**Logic**: Mode 3 uses sheet envelope bodies (for performance), detects openings, and creates both perimeter and field nailing patterns. It supports complex edge offset configurations for different edge orientations.

### Mode 4: Nail on Studs (Additional Parameters)

This mode creates nail lines centered on stud contact faces, similar to mode 2 but optimized for stud framing.

#### Distribution Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Distance from sheeting edge** | PropDouble | 20 mm | The offset from the sheet edge toward the interior. |
| **Distance end beams** | PropDouble | 20 mm | The offset from the end of framing beams. Prevents nails too close to beam ends. |
| **Distance from beam edge** | PropDouble | 5 mm | The minimum side offset to the beam edge. Ensures nails land on the beam face. |

#### Nailing on Loose Sheeting Edges Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Max. Offset Vertical Nailline** | PropDouble | 50 mm | Maximum offset for loose-edge detection (same behavior as mode 2). |
| **Distance from sheeting edge (loose Edge)** | PropDouble | 50 mm | Edge offset for loose sheeting edge nail lines. |

### Mode 5: Nail on Stud Grid (Additional Parameters)

This mode optimizes nailing by filtering nail lines to align with a defined grid, reducing unnecessary nails between grid positions.

#### Distribution Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Distance from sheeting edge** | PropDouble | 20 mm | The offset from the sheet edge. |
| **Distance end beams** | PropDouble | 20 mm | The offset from the end of framing beams. |
| **Distance from beam edge** | PropDouble | 5 mm | The minimum side offset to the beam edge. |
| **X-Grid** | PropDouble | 0 mm | **Critical Parameter**: Defines a grid spacing in the X-direction. Redundant nail lines between grid positions are suppressed, reducing nailing to only grid-aligned stud locations. Set to 0 to disable grid filtering.<br><br>**Common values**:<br>• 625 mm (for 625 mm stud spacing)<br>• 416 mm (for 416 mm stud spacing)<br>• 610 mm (24" centers)<br><br>**Effect**: Vertical nail lines not aligned with the grid are removed, optimizing nail usage for standard framing layouts. |

**Special Feature**: In projects configured for "LUX" mode, studs wider than 160 mm automatically receive **two parallel nail lines** instead of one, with a 40 mm edge offset for better load distribution.

## Right-Click Context Menu

| Menu Item | Availability | Description |
|-----------|--------------|-------------|
| **Release Naillines** | All modes | Converts all computed temporary nail markers into permanent NailLine database entities on the element. After release, the script instance is automatically erased. This is the standard workflow to finalize nailing. **Warning**: This action deletes the script instance. |
| **Subtract Polyline** | Sheet mode only (Mode 3) | Allows the user to select a polyline in the drawing. The area enclosed by the polyline is subtracted from the nailable region, creating a custom exclusion zone. Useful for avoiding nailing near special features, penetrations, or openings not automatically detected. The polyline is assigned to the element and tracked as a dependency. |
| **Change Mode** | Debug mode only | Available only when the debug controller is active (via `hsbTSLDebugController`). Allows switching between nailing modes (2=Lath, 3=Sheet, 4=Stud, 5=Grid) without reinserting the script. For development/testing only. |

## Settings and Configuration

### XML Settings File

**Purpose**: Override default behavior for specific materials and modes.

**Location**: `<Company Path>\TSL\Settings\hsbNailing.xml`

**Persistence**: The file is read once during first insertion and cached as a MapObject (`hsbTSL/hsbNailing`) in the drawing database for performance. Changes to the XML require:
- Reopening the drawing, OR
- Reinserting the script, OR
- Using the debug recalc trigger

### XML Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
    <lst nm="Mode[]">
        <lst nm="StudGrid">
            <lst nm="Material[]">
                <lst nm="XPS">
                    <lst nm="ExclusiveName[]">
                        <str nm="ExclusiveName" vl="Schwelle-Hauseingang"/>
                        <!-- Add more exclusive names as needed -->
                        <!-- <str nm="ExclusiveName" vl="Another-Name"/> -->
                    </lst>
                </lst>
            </lst>
            <int nm="ConvertSheet" vl="1"/>
        </lst>
        <lst nm="Lath">
            <int nm="ConvertSheet" vl="1"/>
        </lst>
    </lst>
    <unit ut="L" uv="millimeter"/>
    <unit ut="A" uv="radian"/>
</Hsb_Map>
```

### XML Settings Reference

| Setting Path | Type | Default | Description |
|--------------|------|---------|-------------|
| `Mode[]\<ModeName>\Material[]\<MaterialName>\ExclusiveName[]` | String list | (none) | **Exclusive name filter**: When specified for a material, only beams whose **name property** exactly matches one of the listed exclusive names will receive nailing. All other beams in the zone are ignored, even if material matches.<br><br>**Use case**: You have multiple beam types with the same material (e.g., "SPF") but want to nail only specific beam names like "Schwelle-Hauseingang" (entry threshold). |
| `Mode[]\<ModeName>\ConvertSheet` | Integer (0/1) | 1 (enabled) | **Sheet conversion control**: In modes where beams might represent laths/battens:<br>• **1** (default): Beams in contact zone matching contact material are automatically converted to sheets for proper profile detection<br>• **0**: Disable conversion, treat beams as beams<br><br>**Technical**: Conversion creates a Sheet entity from the beam's shadow profile perpendicular to zone direction, preserving material and color. The original beam is deleted. |

**Mode Names**: "Lath", "Sheet", "Stud", "StudGrid" (case-sensitive)

**Material Names**: Must match material names in the model (case-insensitive comparison in code)

### Catalog System Details

The catalog system provides persistent storage and automatic matching:

**Catalog Namespaces**:
- `hsbNailing-Lath`
- `hsbNailing-Sheet`
- `hsbNailing-Stud`
- `hsbNailing-StudGrid`

**Catalog Entry Naming**:
- Automatically generated from configuration: `"Z<zone> <material> <contact_material>_<filter>_<exposure>_<loadbearing>"`
- Example: `"Z1 OSB SPF_Wall_Exterior_Load Bearing"`

**Special Catalog Entries** (excluded from automatic insertion):
- `_Default` - Ignored during batch application
- `_LastInserted` - Ignored during batch application

**Matching Algorithm**:
1. Test wall code (if element is wall and codes specified)
2. Test element type (Wall/Floor/Roof/Multielement)
3. Test exposure property (Interior/Exterior)
4. Test load-bearing property
5. Test material in specified zone
6. All tests must pass for catalog entry to apply

## Advanced Features

### Automatic Sawline Avoidance

**What it does**: The script automatically detects element saws and creates exclusion zones where nailing is prohibited.

**Detection method**:
- Queries `ModelMap` for `SAWLINE` and `ELEMENTSAW` tools
- Collects sawline paths from element geometry
- Stores in `_Map` for recalculation efficiency

**Exclusion zone calculation**:
- Extends ≈2× zone height on each side of the saw path
- Offsets perpendicular to saw direction by `dYSaw` (14 mm)
- Creates rectangular exclusion profiles

**Trigger**: Runs during `_bOnDbCreated`, `_bOnElementConstructed`, or `_bOnRecalc`

### No-Nail Zone Integration

**Purpose**: Respect exclusion zones defined by other TSL scripts on the same element.

**Mechanism**:
1. Queries all attached TslInst on the element
2. Reads `subMapX("NoNailProfile[]")` from each
3. Looks for PlaneProfile entries keyed as `"Zone" + nZone`
4. Unions all found profiles into `ppNoNail`
5. Subtracts from nailable area

**Use case**: Other hardware scripts (hangers, anchors) define regions where nailing would interfere with fasteners.

### Sheet-to-Beam Conversion (Mode 2)

**When it happens**:
- Mode 2 (Nail on Laths) only
- Beam in contact zone matches contact material
- `ConvertSheet` setting = 1 (default)
- Zone index = ±1

**Process**:
1. Extract shadow profile of beam perpendicular to zone direction
2. Separate contour rings from opening rings
3. Create Sheet entity with same material and color
4. Assign to same element groups
5. Delete original beam
6. Use sheet in nailing calculations

**Why**: Laths/battens are often modeled as beams but need sheet-like profile treatment for nailing calculations.

### Double Nail Lines on Wide Studs (Mode 5)

**Condition**: Project configured for "LUX" special mode AND stud width ≥ 160 mm

**Behavior**: Instead of one centered nail line, two parallel lines are created:
- Offset 40 mm from each edge of the stud face
- Better load distribution for engineered lumber

**Detection**: Checks project settings for LUX mode flag (implementation detail in version 1.9+)

### Colinear Segment Merging

**Purpose**: Reduce fragmentation of nail lines across multiple sheets.

**Algorithm**:
1. After nail segment calculation, collect all segments
2. Test each segment against others for:
   - Colinearity (parallel and on same line)
   - Gap distance < `Combine Nail Lines` parameter
3. Merge qualifying segments into continuous lines
4. Remove duplicates (same midpoint and direction)

**Minimum length**: Segments shorter than 50 mm are automatically discarded.

### Profile Boolean Operations

The script makes extensive use of `PlaneProfile` operations:

**Common operations**:
- `unionWith()` - Combine overlapping regions (frame members, sheets)
- `intersectWith()` - Find nailable overlap (sheet ∩ framing)
- `joinRing(_kSubtract)` - Remove exclusions (openings, sawlines, no-nail zones)
- `shrink()` - Edge offset application
- `shadowProfile()` - Extract 2D profile from 3D body

**Performance optimization**:
- Mode 3 uses `envelopeBody()` for sheets (faster than `realBody()`)
- Framing members use `realBody()` for accurate contact detection

### Dependency Tracking

**Entity dependencies**:
```c
setDependencyOnEntity(el);  // Element geometry changes trigger recalc
setDependencyOnDictObject(mo);  // Settings changes trigger recalc
```

**Recalculation triggers**:
- Element geometry modification
- Zone height/offset changes
- Attached tool changes (saws, other TSLs)
- Settings file update (via MapObject)

**Element group assignment**:
```c
assignToElementGroup(el, true, nZone, 'E');  // 'E' = element type
```

## Workflow Examples

### Example 1: Basic Wall Sheathing Nailing

**Scenario**: Nail OSB sheathing on exterior of stud wall.

**Steps**:
1. **Setup** (first time only):
   - Insert hsbNailing, press Enter
   - Select "Nail on sheeting"
   - (Optional) Click an OSB sheet to get zone/material
   - (Optional) Click a stud to get contact material
   - Set parameters:
     - Zone: -1 (exterior zone)
     - Material: OSB
     - Material (Contact): SPF
     - Offset Sheeting Edge: 10 mm
     - Maximum nailing spacing: 150 mm
     - Element Filter: Wall;Exterior
   - Click OK (catalog entry created)

2. **Application**:
   - Insert hsbNailing
   - Select all exterior walls
   - Press Enter
   - Review nail pattern (perimeter + field nailing)

3. **Release**:
   - Right-click instance → "Release Naillines"
   - NailLine entities created for CNC

### Example 2: Roof Lath Nailing with Grid Optimization

**Scenario**: Nail roof laths to rafters with 625 mm rafter spacing.

**Steps**:
1. **Setup**:
   - Insert hsbNailing, press Enter
   - Select "Nail on grid studs"
   - Select a lath to get zone 1, material "Battens"
   - Select a rafter to get contact material "SPF"
   - Set parameters:
     - Zone: 1
     - X-Grid: 625 mm
     - Distance from sheeting edge: 15 mm
     - Maximum nailing spacing: 100 mm
     - Element Filter: Roof
   - Click OK

2. **Application**:
   - Insert hsbNailing
   - Select roof elements
   - Press Enter
   - Nail lines appear only at 625 mm grid positions

3. **Release**: Right-click → Release Naillines

### Example 3: Multi-Configuration Wall

**Scenario**: Different nailing for interior vs exterior face of same wall element.

**Steps**:
1. **Create two catalog entries**:
   - Entry 1: Zone -1 (exterior), Material: OSB, Filter: Exterior
   - Entry 2: Zone 1 (interior), Material: Gypsum, Filter: Interior

2. **Apply**:
   - Insert hsbNailing once
   - Select wall
   - Both configurations apply simultaneously (one instance per zone)

## Tips and Best Practices

### General Usage

1. **Catalog organization**: Create a naming convention for catalog entries that reflects your workflow (e.g., prefix with project type or building code).

2. **Batch processing**: Select multiple elements at once during insertion. The script efficiently matches and applies correct configurations to each element.

3. **Always review before releasing**: Once released, the script instance is deleted. Use AutoCAD's Undo command if you need to make changes.

4. **Zone planning**: Plan your element zone structure before creating catalog entries. Changing zone assignments later requires recreating catalog entries.

5. **Material naming**: Use consistent material names across your model. The script performs case-insensitive comparison, but exact spelling must match.

### Performance Optimization

6. **Limit catalog entries**: More catalog entries = longer insertion time. Delete unused entries using standard catalog management.

7. **Merge parameters**: Use "Combine Nail Lines" to reduce nail line fragmentation, especially for large sheet assemblies.

8. **Grid optimization**: For repetitive framing (studs, joists), use mode 5 with X-Grid to minimize nail line calculations.

### Quality Assurance

9. **Visual inspection**: Different nailing tool indices use different colors. Use this to verify different nailing zones visually.

10. **Sawline verification**: After element modifications involving saws, verify that nail lines respect new sawline positions.

11. **No-nail zones**: When using hardware connectors, verify that their no-nail definitions are properly integrated.

### Troubleshooting

12. **No nails appearing**: Check:
    - Zone index is correct (contains sheets/laths)
    - Material filter matches actual materials
    - Element filter matches element type/code
    - Exclude color not set to sheet color
    - Zone height > 0

13. **Incomplete nailing**: Check:
    - Edge offsets not too large for small members
    - Merge parameters not causing unwanted combinations
    - Contact zone properly defined with framing

14. **Catalog not applying**: Verify:
    - Element type matches (Wall/Floor/Roof)
    - Exposure property matches filter
    - Load-bearing property matches filter
    - Wall code matches (if specified)

### Advanced Techniques

15. **Custom exclusions** (Mode 3): Use "Subtract Polyline" context menu to define complex no-nail zones not automatically detected.

16. **Mixed materials**: Use semicolon-separated material lists to apply same nailing to multiple materials (e.g., "OSB;Plywood;MDF").

17. **Loose edge handling** (Mode 2): Adjust "Max. Offset Vertical Nailline" to control when additional nailing is added for unsupported sheet edges.

18. **XML customization**: Use ExclusiveName settings to nail only specific beam types without creating separate catalog entries.

### CNC Integration

19. **Tool index strategy**: Coordinate nailing tool indices with your CNC machine tool library. Different indices can trigger different nail types/lengths.

20. **Spacing for production**: Consider actual nail guns and production speed when setting spacing parameters. Too-tight spacing slows production.

21. **Release timing**: Release nail lines only when element geometry is final. NailLine entities don't recalculate with element changes.

## Technical Notes

### Script Architecture

- **Main script**: `hsbNailing.mcr` - Acts as orchestrator during insertion
- **Sub-instances**: Mode-specific instances (hsbNailing-Lath, hsbNailing-Sheet, hsbNailing-Stud, hsbNailing-StudGrid)
- **Execution model**: Main script creates sub-instances on elements; each sub-instance calculates independently

### Mode Enumeration

- Mode 0: Setup (catalog entry creation)
- Mode 1: Insert (batch application to elements)
- Mode 2: Nail on Laths
- Mode 3: Nail on Sheeting
- Mode 4: Nail on Studs
- Mode 5: Nail on Stud Grid

### Constants and Tolerances

```c
double dEps = U(0.1);  // General geometric tolerance
double dYSaw = U(14);  // Sawline perpendicular offset
double dXFactorSaw = 2;  // Sawline parallel offset factor (2× zone height)
```

### Minimum Thresholds

- **Minimum nail line length**: 50 mm (shorter segments discarded)
- **Minimum profile area**: `dEps²` (profiles below this considered invalid)
- **Merge tolerance**: `dEps * 5` (5× geometric tolerance)

### Coordinate Systems

- **Element CS**: `el.coordSys()` - Element origin, X (length), Y (width), Z (height)
- **Zone CS**: `el.zone(n).ptOrg()` - Zone-specific origin with zone offset
- **Profile CS**: `PlaneProfile(CoordSys(...))` - 2D profiles in zone plane

### Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| 5.3 | Oct 2022 | Bugfix: beam sheet converting when material not defined |
| 5.0 | Oct 2020 | X-Grid tolerance increased for better grid alignment |
| 4.0 | Jul 2019 | Grid studs mode considers no-nail and saw protection before segment creation |
| 3.8 | Jul 2019 | ConvertSheet parameter added to settings |
| 3.0 | Mar 2018 | Integration with no-nail definitions from other TSLs |
| 2.1 | Jan 2017 | Auto-erase existing naillines on reinsertion |
| 1.9 | Nov 2016 | Double nail lines on wide studs (≥160mm) |
| 1.6 | Jun 2016 | Cascading filter tests (wall code, type, exposure, load bearing) |
| 1.2 | Jun 2016 | "Nail on grid studs" mode released |
| 1.0 | Apr 2016 | Initial release |

### Dependencies

**Required entities**:
- Element (Wall/Floor/Roof/Multi)
- GenBeam/Sheet/Beam in specified zones

**Optional entities**:
- SawLine/ElementSaw (for automatic exclusion)
- Other TslInst with NoNailProfile (for coordination)
- EntPLine (for custom exclusions in mode 3)

**External resources**:
- MapObject: `hsbTSL/hsbNailing` (settings cache)
- XML file: `hsbNailing.xml` (optional configuration)
- DLL: `TslUtilities.dll` (for dialogs - not used in this script)

### Database Operations

**Created entities**:
- NailLine entities (when released)
- Sheet entities (when beams converted in mode 2)
- Sub-TslInst instances (one per matched catalog entry per element)

**Deleted entities**:
- Previous NailLine entities (on reinsertion)
- Previous hsbNailing instances (on reinsertion)
- Converted beams (when sheet conversion enabled)
- Main TslInst (on release)

### Performance Characteristics

**Calculation time factors**:
- Number of sheets/laths in zone
- Number of framing members in contact zone
- Complexity of sheet profiles (openings)
- Number of catalog entries to test
- Profile boolean operation complexity

**Optimization strategies**:
- Mode 3 uses `envelopeBody()` instead of `realBody()` for sheets
- Profile shrink/grow operations for merging (faster than multiple unions)
- Cached sawline data (stored in `_Map`, not recalculated each time)
- MapObject persistence for settings (read once per drawing)

## Related Scripts

### Complementary Scripts

- **hsbCLT-Drill**: For CLT panel drilling (can define no-nail zones)
- **hsbMetalPart**: Hardware connectors that may define no-nail profiles
- **HSB_E-NailClusters**: Advanced nail pattern generation
- **Nail-SheetOnBeam**: Simplified nail-on-beam scripting
- **Nail-SheetOnSheet**: Sheet-to-sheet nailing

### Workflow Integration

**Upstream** (create these first):
- `hsbCreateElement` or element creation scripts
- `hsbBlocking`, `hsbPolylineBeamDistribution` (framing)
- `hsbSheetDistribution` (sheathing)

**Downstream** (use nailing output):
- CNC export scripts (use NailLine entities)
- `hsbBOM` (bill of materials - counts nail lines)
- Shop drawing scripts (visualize nailing)

### Alternative Approaches

- **Manual NailLine creation**: Use hsbCAD's native NailLine tools for custom patterns
- **Nail-App**: Application-specific nailing for specific hardware
- **Element-embedded nailing**: Some element definition scripts include automatic nailing

## Frequently Asked Questions

**Q: Why don't any nails appear after insertion?**

A: Most common causes:
1. No catalog entries exist - you must create at least one (insert, press Enter, configure)
2. Material filter doesn't match actual materials in model
3. Zone index is wrong or zone is empty
4. Element filter excludes the selected elements
5. Exclude Color is set to the same color as your sheets

**Q: Can I nail multiple materials with one catalog entry?**

A: Yes. Use semicolons to separate material names in the Material field: "OSB;Plywood;MDF"

**Q: How do I change nailing after it's been released?**

A: You can't modify released NailLine entities directly. You must:
1. Delete the NailLine entities
2. Re-insert hsbNailing on the element
3. Adjust parameters if needed
4. Release again

Or use AutoCAD Undo immediately after release.

**Q: What's the difference between "Nail on Studs" (mode 4) and "Nail on Stud Grid" (mode 5)?**

A: Mode 4 nails every stud detected. Mode 5 adds X-Grid filtering - only studs aligned with the grid spacing receive nails, reducing unnecessary nails between grid positions.

**Q: Can I have different nailing on interior vs exterior faces of the same wall?**

A: Yes. Create separate catalog entries for each zone (e.g., zone -1 for exterior, zone 1 for interior). Both will apply automatically when you insert the script on the wall.

**Q: Why are some nail lines missing near saw cuts?**

A: This is intentional. The script automatically creates exclusion zones around element saws (≈2× zone height on each side) to prevent nails in areas that will be cut away.

**Q: How do I nail only specific beam names (not all beams of a material)?**

A: Use the XML settings file with ExclusiveName entries:
```xml
<lst nm="Material[]">
    <lst nm="SPF">
        <lst nm="ExclusiveName[]">
            <str nm="ExclusiveName" vl="Specific-Beam-Name"/>
        </lst>
    </lst>
</lst>
```

**Q: Can other scripts prevent nailing in certain areas?**

A: Yes. Any TSL script can define NoNailProfile entries in its subMapX. hsbNailing automatically respects these exclusions.

**Q: What happens if I modify the element after releasing nail lines?**

A: Released NailLine entities are independent database entities - they do NOT recalculate. You must delete them and re-apply hsbNailing to update positions.

**Q: How do I create nail lines for custom patterns not supported by the four modes?**

A: Use Mode 3 (Nail on Sheeting) with the "Subtract Polyline" context menu to exclude unwanted areas, or use hsbCAD's manual NailLine creation tools.

## Summary

hsbNailing is a sophisticated, catalog-driven automation system that eliminates manual nail line creation. Its strength lies in:

✓ **Automatic matching** - Apply configurations to hundreds of elements with one insertion
✓ **Four specialized modes** - Optimized algorithms for different construction types
✓ **Intelligent exclusions** - Respects saws, openings, and coordination with other scripts
✓ **Flexible filtering** - Zone, material, element type, exposure, load-bearing all configurable
✓ **CNC-ready output** - Permanent NailLine entities for manufacturing

The catalog-based workflow requires initial setup but provides long-term efficiency for repetitive projects.

---

**Script**: hsbNailing.mcr
**Version**: 5.3 (October 2022)
**Author**: Thorsten Huck (hsbCAD)
**Documentation**: Generated for TSL Knowledge Base
