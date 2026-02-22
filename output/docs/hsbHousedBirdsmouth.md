# hsbHousedBirdsmouth

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbHousedBirdsmouth |
| **Type** | T (Tool) |
| **Version** | 1.2 |
| **Category** | Timber Framing / Roof Connections |
| **Structure Type** | Stick Frame Roofing |
| **Beams Required** | 2 (Male: Rafter, Female: Purlin) |
| **Author** | nils.gregor@hsbcad.com |
| **Last Updated** | 22 Feb 2021 |

## Description

The **hsbHousedBirdsmouth** tool creates traditional housed birdsmouth connections between rafters and purlins in timber roof framing. This is a specialized joint where the rafter (male beam) is notched to fit over and around the purlin (female beam), creating a secure bearing surface with improved lateral stability compared to standard birdsmouth connections.

### What is a Housed Birdsmouth?

A housed birdsmouth is an advanced timber framing joint consisting of:
- **Birdsmouth notch** in the rafter that sits on the purlin
- **Housing (recess)** machined into the purlin to receive the rafter
- **Side housing** for lateral stability (when beams are perpendicular in plan)
- **Top housing** for improved bearing and load transfer

This connection type is particularly suitable for:
- Purlin roof systems with inclined rafters
- CNC-manufactured timber frame structures
- High-quality timber joinery requiring precise load transfer
- Connections where traditional birdsmouth seats need enhanced stability

### Key Constraints

The script enforces geometric constraints to ensure manufacturability:
- **Angle requirement**: Beams must intersect at 1° to 89° (nearly perpendicular connections)
- **Perpendicularity for side housing**: Side housing only created when beams are perpendicular in plan view (top view)
- **Vertical alignment for top housing**: Top housing only created when beams are aligned in vertical plane
- **Intersection requirement**: Beams must physically intersect; the tool auto-deletes if connection is lost

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | ✓ Yes (Primary) |
| Paper Space | ✗ No |
| Shop Drawing | ✗ No |

## Typical Applications

### 1. Purlin Roof Systems
Create connections between:
- Inclined rafters and horizontal purlins
- Rafters and ridge beams
- Jack rafters and hip/valley purlins

### 2. Traditional Timber Frame
Enhance load transfer in:
- Post-and-beam roof structures
- Heavy timber purlin systems
- Exposed timber ceiling constructions

### 3. CNC Timber Manufacturing
Generate machine-ready connections:
- Precise housing cuts for CNC routers
- Consistent gap allowances for assembly
- Optimized nesting for 5-axis machining

---

## Usage Workflow

### Step 1: Launch the Tool

**Command**: `TSLCONTENT` or insert via hsbCAD TSL toolbar

Upon launching, a **configuration dialog** appears allowing you to:
- Select a saved catalog preset (for consistent settings across projects)
- Adjust default parameters before selecting beams
- Choose "Default" for standard 20mm housing depths

**Best Practice**: Create catalog entries for different roof pitches or timber species (e.g., "Softwood_30deg", "Hardwood_45deg")

---

### Step 2: Select Male Beams (Rafters)

The tool prompts: **"Select roofplane or beams"**

**Option A: Select Individual Rafters**
- Click on each rafter beam individually
- Hold Shift to select multiple beams
- The tool highlights valid selections in blue

**Option B: Select Entire Roofplane**
- Click on any roofplane entity (HSB_R-* element)
- All beams belonging to that roofplane are automatically included
- Faster for applying connections to all rafters in a roof section

**Automatic Filtering**:
- Dummy beams are automatically excluded
- Beams that are parallel to selected purlins are filtered out
- Only beams that intersect with purlins proceed to connection creation

---

### Step 3: Select Female Beams (Purlins)

The tool prompts: **"Select female beams as purlin"**

- Click on horizontal or near-horizontal support beams
- Multiple purlins can be selected simultaneously
- Typical selections: ridge purlins, mid-purlins, eave purlins

**What Happens Next**:
- The tool automatically calculates all valid intersections
- For each rafter-purlin intersection, a separate TSL instance is created
- Invalid combinations (parallel beams, no intersection) are silently skipped
- Progress is shown in the AutoCAD command line

---

### Step 4: Automatic Connection Generation

The tool performs:

1. **Intersection Detection**: Identifies all rafter-purlin crossings
2. **Angle Validation**: Checks if angle is within 1-89° range
3. **Geometry Analysis**: Determines if side/top housing can be created
4. **Tool Application**:
   - Birdsmouth cut applied to rafter
   - Housing cuts applied to purlin (top and/or side)
   - Optional end cut applied to rafter tail
5. **Symbol Drawing**: Visual indicator drawn at connection point

**Result**: Each connection becomes an independent TSL instance that:
- Updates automatically when beam positions change
- Maintains dependency tracking with both beams
- Self-deletes if beams are moved apart (connection lost)

---

## Properties Panel Parameters (OPM)

After insertion, adjust connection geometry via AutoCAD Properties Palette (OPM):

### General Category

#### Vertical Depth (A)
| Property | Value |
|----------|-------|
| **Parameter Name** | `dHouseDepthTop` |
| **Default Value** | 20 mm |
| **Unit Type** | Length (mm or inches based on template) |
| **Range** | 0 - (beam height limit) |

**Description**: Defines the depth of the housing cut at the **top surface** of the purlin. This creates a vertical recess that the rafter sits into.

**Purpose**:
- Improves vertical load transfer from rafter to purlin
- Prevents horizontal sliding of rafter
- Increases bearing surface area

**Typical Values**:
- **15-20mm**: Softwood construction (pine, spruce)
- **20-30mm**: Hardwood construction (oak, beech)
- **0mm**: Disable top housing if only lateral stability needed

**Relationship to Beam Sizes**:
- Should not exceed 30-40% of purlin height
- Larger depths provide more stability but reduce purlin capacity
- Consider structural engineer's recommendations

**Automatic Adjustment**:
- If beams are not aligned in the vertical plane, this value is **automatically set to 0** and a warning message is displayed
- This prevents manufacturing errors on CNC machines

---

#### Horizontal Depth (B)
| Property | Value |
|----------|-------|
| **Parameter Name** | `dHouseDepthSide` |
| **Default Value** | 20 mm |
| **Unit Type** | Length |
| **Range** | 0 - (beam width limit) |

**Description**: Defines the depth of the housing cut at the **side faces** of the purlin. This creates horizontal recesses on both sides of the purlin.

**Purpose**:
- Provides lateral restraint to prevent rafter from twisting
- Improves wind resistance
- Critical for rafters under asymmetric loads (wind uplift)

**Typical Values**:
- **15-20mm**: Standard lateral stability
- **25-30mm**: High wind zones or wide rafter spacing
- **0mm**: No side housing (birdsmouth only)

**Important Geometric Constraint**:
⚠️ **Side housing can ONLY be created when rafters are perpendicular to purlins in plan view (±0.1°)**

**Why This Constraint Exists**:
- CNC machines cut horizontally and vertically along beam axes
- Skewed connections would require 5-axis machining with complex tool paths
- Manufacturing complexity increases dramatically for non-perpendicular cuts

**Automatic Adjustment**:
- If horizontal angle ≠ 90°, this value is **automatically set to 0**
- Warning message: *"The housing at the side cannot be created for this connection. The value is set to 0"*

**Design Workaround for Skewed Rafters**:
- Use only top housing (vertical depth)
- Rely on mechanical fasteners for lateral restraint
- Consider alternative connection types (e.g., metal brackets)

---

#### Offset Horizontal Cut (C)
| Property | Value |
|----------|-------|
| **Parameter Name** | `dVertOffsetHouse` |
| **Default Value** | 5 mm |
| **Unit Type** | Length |
| **Range** | 0 - 50 mm |

**Description**: Defines the **horizontal offset distance** from the purlin edge where the horizontal bottom cut of the birdsmouth starts.

**Purpose**:
- Controls the length of the bearing seat
- Prevents sharp corners that could split under load
- Optimizes load distribution along the grain

**Typical Values**:
- **0mm**: Maximum bearing length (cut flush to purlin edge)
- **5-10mm**: Standard offset (recommended for most applications)
- **15-20mm**: Large offset for very steep roofs

**Effect on Connection**:
- **Smaller offset** = More bearing surface = Better load distribution
- **Larger offset** = Less stress concentration = Reduced splitting risk
- **Balance** is needed based on rafter pitch and load magnitude

**Visual Reference**:
```
Side view:
Rafter ──────╲
              ╲___  ← Horizontal cut starts here (offset C from purlin edge)
Purlin ═══════════════
         ↑─ C ─↑
```

**Version History Note**:
- Version 1.1 (28 Jan 2021) changed behavior: Previously controlled different geometry
- Current definition is more intuitive for users

---

### Gaps Category

Manufacturing tolerances for assembly clearance:

#### Side (D)
| Property | Value |
|----------|-------|
| **Parameter Name** | `dGapAtSide` |
| **Default Value** | 0.5 mm |
| **Unit Type** | Length |
| **Range** | 0 - 5 mm |

**Description**: Defines the **manufacturing gap** added to both sides of the housing cut in the purlin. This gap is applied symmetrically (0.5mm on each side = 1mm total clearance).

**Purpose**:
- Compensates for CNC machining tolerances (±0.2mm typical)
- Allows easy assembly in the field
- Prevents binding during dry-fit operations
- Accounts for wood moisture content changes

**Typical Values by Application**:

| Application | Gap Value | Rationale |
|-------------|-----------|-----------|
| CNC Precision Manufacturing | 0.3-0.5 mm | Tight fit, high precision machines |
| Standard Shop Manufacturing | 0.5-1.0 mm | Moderate fit, standard equipment |
| Field-Cut Timber | 1.0-2.0 mm | Loose fit, hand tools or portable saws |
| Green (Wet) Timber | 1.5-3.0 mm | Shrinkage allowance as wood dries |
| Engineered Lumber (LVL, GLT) | 0.2-0.4 mm | Dimensionally stable, minimal shrinkage |

**Gap Too Small**:
- Difficult assembly (hammering required)
- Risk of beam damage during installation
- Potential binding if wood swells

**Gap Too Large**:
- Reduced lateral stability
- Increased deflection under load
- Visible gaps in exposed joinery

**Best Practice**:
- Test fit with sample connections before full production
- Adjust based on actual equipment capabilities
- Document settings in catalog for repeatability

---

#### Bottom (E)
| Property | Value |
|----------|-------|
| **Parameter Name** | `dGapAtBottom` |
| **Default Value** | 0 mm |
| **Unit Type** | Length |
| **Range** | 0 - 5 mm |

**Description**: Defines the **vertical gap** at the bottom of the side housing cut. This creates a small clearance between the rafter and the bottom of the housing recess.

**Purpose**:
- Ensures rafter seats firmly on the top horizontal surface
- Prevents contact at the bottom of the housing that could reduce bearing efficiency
- Allows sawdust/debris clearance during assembly

**Typical Values**:
- **0mm**: Default (no gap) - rafter contacts full depth
- **0.5-1mm**: Small clearance for debris
- **2-3mm**: Larger gap to ensure top-surface bearing only

**When to Increase**:
- If side housing is deep (>25mm) and precise bottom contact is uncertain
- For rough-sawn timbers with dimensional variation
- To prioritize top-surface bearing over full-depth contact

**Structural Consideration**:
- Only matters if side housing is used (dHouseDepthSide > 0)
- Does not affect primary load path (vertical bearing on top surface)

---

### End Cut Category

#### Cut male beam
| Property | Value |
|----------|-------|
| **Parameter Name** | `sCutMaleBeam` |
| **Default Value** | No |
| **Options** | No / Yes |

**Description**: Controls whether an **end cut** is applied to the male beam (rafter) at the side **opposite** to the purlin connection.

**Purpose**:
- Creates a clean vertical end at the rafter tail
- Useful for rafters that extend beyond the purlin (eave overhangs)
- Defines the end of decorative exposed rafter tails

**Options**:

**"No" (Default)**:
- Rafter extends indefinitely beyond the purlin
- User must manually trim rafter later
- Suitable when rafter length is uncertain during design phase

**"Yes"**:
- Rafter is automatically cut at the outer face of the purlin
- Creates a flush end aligned with purlin edge
- Ideal for rafters that should terminate at the purlin

**Typical Use Cases**:

| Scenario | Setting | Reason |
|----------|---------|--------|
| Rafters at ridge purlin | Yes | Rafters meet at ridge, no overhang |
| Rafters at mid-purlin | No | Rafters continue to eave, overhang needed |
| Rafters at eave purlin | Yes | Clean end for fascia attachment |
| Hip/Valley rafters | No | Complex geometry, manual trimming preferred |

**Cut Behavior**:
- Cut plane is perpendicular to the purlin axis
- Cut is positioned at the outer face (+0.5 × purlin width from center)
- Cut is applied as a standard `Cut` tool (can be edited separately if needed)

**Version History**:
- Added in Version 1.2 (22 Feb 2021)
- Previously, all end cuts had to be created manually

---

## Connection Behavior & Intelligence

### Automatic Geometric Validation

The script performs sophisticated checks to ensure manufacturability:

#### 1. Angle Validation (1° - 89°)
**Check**: Measures the angle between rafter and the horizontal projection of the purlin.

**Valid Range**: 1° to 89°

**What Happens**:
- **Angle < 1°**: Beams are nearly parallel (error)
- **1° ≤ Angle ≤ 89°**: Valid connection created
- **Angle > 89°**: Beams are nearly perpendicular vertically (error)

**If Invalid**:
- Error message: *"Beams should be in an angle of 1°-89°. Tool will be deleted"*
- TSL instance is automatically erased
- No connection is created

**Why This Matters**:
- Shallow angles (<1°) create excessively long cuts that are impractical
- Near-vertical angles (>89°) are better served by different connection types
- This ensures the birdsmouth geometry is appropriate for the application

---

#### 2. Perpendicularity Check (Side Housing)
**Check**: Measures the horizontal angle (plan view) between rafter and purlin.

**Requirement**: Angle must be **90° ± 0.1°** for side housing

**Automatic Adjustment**:
```
IF horizontal_angle ≠ 90°:
    dHouseDepthSide = 0
    Display warning: "The housing at the side cannot be created..."
```

**Why This Constraint**:
- CNC machines cannot easily create skewed side housings
- 5-axis machining would be required (expensive, complex)
- Standard 3-axis routers can only cut perpendicular to beam axis

**Visual Example**:
```
Top View (Plan):

✓ VALID (90°)              ✗ INVALID (75°)
Rafter ║                   Rafter ╱
       ║                          ╱
Purlin ═══                 Purlin ═══
```

**Design Implication**:
- Hip/valley connections typically lose side housing
- Skewed connections rely on top housing + mechanical fasteners

---

#### 3. Vertical Alignment Check (Top Housing)
**Check**: Verifies that beams are aligned in the same vertical plane.

**Requirement**: Rafter must intersect purlin without lateral offset

**Automatic Adjustment**:
```
IF vertical_offset > 0.1mm:
    dHouseDepthTop = 0
    Display warning: "The housing at the top cannot be created..."
```

**When This Occurs**:
- Rafters offset to the side of the purlin (not centered)
- Connections at angles where beams don't perfectly align
- Layout errors where beams miss each other slightly

**Practical Effect**:
- If top housing is disabled, only birdsmouth seat remains
- Connection becomes a simple notched joint without housing
- Structural capacity may be reduced (review by engineer needed)

---

#### 4. Intersection Check (Dynamic Monitoring)
**Check**: Verifies that beams still physically intersect (overlap in 3D space).

**Behavior**:
- Checked **every time the model regenerates** (dynamic dependency)
- Uses oversized 3D bounding box detection (beam envelope + 0.1mm)

**If Connection Lost**:
- Error message: *"Lost connection. Instance deleted"*
- TSL instance automatically erases itself
- This prevents "orphaned" connections that reference non-intersecting beams

**When This Happens**:
- User moves a rafter away from the purlin
- Purlin is shortened and no longer reaches the rafter
- Beams are rotated to no longer intersect

**Dynamic Dependency System**:
- The tool registers dependencies on both beam lengths using `setDependencyOnBeamLength()`
- Any change to beam geometry triggers recalculation
- Self-cleaning mechanism prevents invalid connections from persisting

---

#### 5. Parallel Beam Filter
**Check**: During insertion, parallel beams are filtered from the selection.

**Logic**:
```
FOR each rafter:
    FOR each purlin:
        IF rafter.vecX() is parallel to purlin.vecX():
            SKIP this combination
```

**Result**:
- No connections attempted between parallel beams
- Prevents invalid geometry before creation
- Users are not notified (silent filtering for clean workflow)

---

### Cut Operations Generated

The tool applies multiple machining operations to both beams:

#### On the Male Beam (Rafter)

##### 1. Birdsmouth Main Cut
**Type**: `BeamCut` (complex 3D cut)

**Geometry**:
- **Position**: Calculated to wrap around the purlin
- **Direction**: Oriented along purlin axis
- **Size**: Oversized to prevent leftover material
  - Width: `(rafter_width + 0.5×purlin_width) / sin(angle)`
  - Height: 10,000mm (effectively infinite for complete removal)
  - Depth: 10,000mm (ensures full penetration)

**Purpose**:
- Creates the notch that fits over the purlin
- Removes material from the rafter to create bearing surface
- Geometry adapts to beam intersection angle

**Machining**:
- Typically executed as a plunge cut on CNC router
- May require multiple passes for deep cuts
- Cut is oversized to ensure complete material removal even at edges

---

##### 2. Horizontal Bottom Cut
**Type**: `Cut` (planar cut)

**Geometry**:
- **Position**: Bottom edge of rafter, offset by parameter (C)
- **Direction**: Horizontal (perpendicular to gravity)
- **Purpose**: Creates the flat bearing seat

**Calculation**:
```
Bottom_Cut_Point = Rafter_Bottom_Edge + Offset(C) along purlin face
Cut_Plane = Horizontal plane at this point
```

**Effect**:
- Defines the horizontal bearing surface
- Offset (C) controls the seat length
- This is the primary load-bearing surface

**Machining**:
- Simple horizontal cut on CNC
- Can also be executed with portable circular saw
- Critical for accurate load transfer

---

##### 3. Optional End Cut (if enabled)
**Type**: `Cut` (planar cut)

**Geometry**:
- **Position**: Outer face of purlin (+0.5 × purlin_width)
- **Direction**: Perpendicular to purlin axis
- **Applied**: Only if `sCutMaleBeam = "Yes"`

**Purpose**:
- Trims rafter to flush with purlin edge
- Creates clean end for aesthetic or structural reasons

**Stretch Mode**:
- Applied with `_kStretchOnInsert` flag
- If purlin length changes, cut position updates automatically

---

#### On the Female Beam (Purlin)

##### 1. Top Housing Cut (if dHouseDepthTop > 0)
**Type**: `BeamCut` (rectangular recess)

**Geometry**:
- **Position**: Top surface of purlin, offset by `dHouseDepthTop` from top
- **Width**: Rafter width + 2×`dGapAtSide` (clearance on both sides)
- **Length**: Calculated to span full width of intersection
- **Depth**: `dHouseDepthTop` + 500mm (oversized for complete removal)

**Calculation**:
```
Width = rafter_width + 2 × gap_at_side
Length = (purlin_width + 0.5×rafter_width + 0.1mm) / cos(horizontal_angle)
Depth = top_housing_depth + 500mm (overcut for safety)
```

**Purpose**:
- Creates vertical recess to receive rafter
- Increases bearing surface area
- Prevents horizontal sliding

**Machining**:
- Requires pocket milling on CNC
- Multiple passes at increasing depths
- Final depth critical for structural performance

---

##### 2. Side Housing Cut (if dHouseDepthSide > 0 AND perpendicular)
**Type**: `BeamCut` (rectangular recess on side face)

**Geometry**:
- **Position**: Side face of purlin, at the bottom cut location
- **Width**: Rafter width + 2×`dGapAtSide`
- **Height**: Purlin height
- **Depth**: `dHouseDepthSide` + 0.1mm (small overcut)

**Offset for Bottom Gap**:
- Position is lowered by `dGapAtBottom` to create clearance at bottom

**Purpose**:
- Creates lateral pockets on both sides of purlin
- Rafter sits into these pockets for twist resistance
- Critical for wind uplift and lateral loads

**Machining**:
- Side milling operation on CNC
- May require beam rotation for access
- Depth control critical for fit tolerance

**Calculation Detail**:
```
Side_Cut_Point = Bottom_Cut_Point - (dGapAtBottom × vertical)
Side_Cut_Point = Projected onto purlin side face
```

---

### Visual Feedback

#### Connection Symbol
**Type**: 2D polyline symbol

**Appearance**:
- Drawn at the connection point on purlin top surface
- Shows the outline of the housing profile
- Color: Layer-dependent (typically magenta or green for tools)

**Geometry**:
```
Start: Top outer corner of purlin
Line 1: Horizontal across purlin width
Line 2: Vertical down by dHouseDepthTop
Closed polyline (3 segments forming "L" shape)
```

**Purpose**:
- Visual indicator that connection exists
- Quick identification of housing depth in plan view
- Helps detect overlapping or missing connections

**Display Properties**:
- Drawn with `Display(-1)` (bylayer color)
- Visible in all viewports
- Does not print to shop drawings (tool layer)

---

## Practical Usage Tips

### 1. Beam Selection Order
**Recommended Sequence**: Rafters (male) first, then purlins (female)

**Why**:
- More intuitive workflow (top-down selection)
- Easier to visualize which beams will be notched
- Matches construction sequence (rafters rest on purlins)

**Alternative**: Selecting roofplane first automatically includes all rafters, saving time on complex roofs.

---

### 2. Gap Settings for Different Materials

| Material | Side Gap (D) | Bottom Gap (E) | Rationale |
|----------|--------------|----------------|-----------|
| **Sawn Softwood** | 1.0-1.5 mm | 0.5 mm | High shrinkage, dimensional variation |
| **Planed Softwood** | 0.5-1.0 mm | 0 mm | Moderate precision, some shrinkage |
| **Glulam (GLT)** | 0.3-0.5 mm | 0 mm | Dimensionally stable, precise manufacturing |
| **LVL** | 0.2-0.4 mm | 0 mm | Very stable, tight tolerances possible |
| **Hardwood (Dry)** | 0.3-0.6 mm | 0 mm | Stable but harder (tighter fit harder to assemble) |
| **Green Timber** | 2.0-3.0 mm | 1.0 mm | Significant shrinkage expected |

**Moisture Content Adjustment**:
- Add 0.1-0.2mm gap per 5% expected moisture reduction
- Example: 20% MC timber drying to 10% MC → add 0.2-0.4mm gap

---

### 3. Perpendicular Connections for Full Housing
**Best Practice**: Ensure rafters are **exactly perpendicular** to purlins in plan view to enable side housing.

**How to Check**:
1. Switch to Top view (plan view)
2. Use AutoCAD's `MEASUREGEOM` → `Angle` command
3. Verify angle = 90.0° (not 89.9° or 90.1°)

**If Slightly Off**:
- Adjust rafter or purlin rotation by 0.1-0.5°
- Re-insert the connection tool
- Verify side housing is now created

**When Perpendicularity is Impossible** (hip/valley roofs):
- Accept that side housing will be disabled
- Increase top housing depth for more stability
- Add mechanical fasteners (screws, bolts) for lateral restraint

---

### 4. Angle Constraints Troubleshooting
**Problem**: Tool deletes itself immediately after insertion.

**Likely Cause**: Beam intersection angle outside 1-89° range.

**Solution**:
1. Check roof pitch and purlin slope
2. Verify beams actually intersect (use 3D view)
3. For very shallow roofs (<5° pitch), consider alternative connections
4. For very steep roofs (>75° pitch), use different joint types (mortise-tenon)

**Common Scenarios**:
- **Flat roofs** (0-2° pitch): Angle too shallow → use standard beam-on-beam connections
- **Cathedral ceilings** (steep rafters on horizontal purlins): Usually valid (20-60° typical)
- **Curved roofs**: Angle varies along length → may need manual connections

---

### 5. Lost Connections and Dynamic Updates
**Behavior**: TSL instances automatically delete if beams move apart.

**Why This is Good**:
- Prevents invalid geometry from persisting
- Keeps model clean and accurate
- Forces user to fix design issues (beams that don't connect)

**When to Expect Auto-Deletion**:
- Shortening a purlin so it no longer reaches a rafter
- Moving a rafter to a different bay
- Rotating a roof section (changes intersections)

**How to Prevent Accidental Loss**:
- Use AutoCAD layers to freeze tool layers during major edits
- Work on copies of beams when experimenting
- Document connection settings in catalog before deleting/recreating

**Recovery**:
- Simply re-run the tool on the beams
- If settings were saved to catalog, reload them
- Connection recreates instantly

---

### 6. CNC Manufacturing Compatibility
**This tool generates CNC-ready geometry with these considerations**:

**Compatible Machines**:
- ✓ 3-axis CNC routers (standard equipment)
- ✓ 4-axis CNC (with beam rotation)
- ✓ 5-axis CNC (full capability, but not required)

**Limitations**:
- Side housing requires **perpendicular connections** (3-axis constraint)
- Top housing works at any angle (vertical pocket milling)
- Horizontal bottom cut is always CNC-compatible

**Export Workflow**:
1. Generate connections in hsbCAD
2. Export to BTL (Hundegger), BVDA, or DXF format
3. Post-process in CAM software
4. Verify tool paths in simulation
5. Run production on CNC

**Gap Recommendations for CNC**:
- **New machines** (±0.1mm accuracy): 0.3-0.5mm gap
- **Older machines** (±0.3mm accuracy): 0.8-1.2mm gap
- **Test parts first** to validate fit before production run

---

### 7. Catalog Usage for Efficiency
**Create Standard Presets** for different scenarios:

| Catalog Name | Vertical (A) | Horizontal (B) | Offset (C) | Side Gap (D) | End Cut | Use Case |
|--------------|--------------|----------------|------------|--------------|---------|----------|
| `Standard_Softwood` | 20mm | 20mm | 5mm | 1.0mm | No | General construction |
| `Hardwood_Tight` | 25mm | 25mm | 10mm | 0.5mm | No | Exposed joinery |
| `NoSideHousing` | 30mm | 0mm | 5mm | 0mm | No | Skewed connections |
| `Ridge_Connection` | 20mm | 20mm | 5mm | 0.8mm | Yes | Rafters at ridge |
| `GLT_Precision` | 20mm | 20mm | 5mm | 0.3mm | No | Glulam beams |

**How to Save to Catalog**:
1. Set desired property values in OPM
2. Right-click on the TSL instance
3. Select "Add to Catalog" from context menu
4. Enter a descriptive name
5. Catalog is saved to user profile for reuse

**How to Load from Catalog**:
- During insertion, dialog shows catalog list
- Select desired preset, click OK
- All parameters load automatically

---

### 8. Structural Considerations
⚠️ **This tool generates geometry only** — structural adequacy must be verified by a licensed engineer.

**Load Transfer Assumptions**:
- Primary load path: Vertical compression through horizontal bearing seat
- Secondary load path: Lateral stability through side housing
- Tensile loads: NOT addressed (add mechanical fasteners if needed)

**When to Add Fasteners**:
- Uplift loads (wind, seismic)
- Lateral loads exceeding friction resistance
- Code requirements for positive connection
- Redundancy in critical connections

**Housing Depth Limits** (structural rules of thumb):
- Top housing: ≤ 30-40% of purlin height
- Side housing: ≤ 30-40% of purlin width
- Exceeding these reduces purlin section properties significantly

**Consult Engineer For**:
- Unusual roof geometries or loads
- Span tables and allowable stresses
- Connection capacity verification
- Code compliance (IBC, Eurocode, etc.)

---

## Warning Messages Reference

| Message | Trigger Condition | User Action Required |
|---------|-------------------|----------------------|
| **"The housing at the side cannot be created for this connection. The value is set to 0"** | Beams are not perpendicular in plan view (horizontal angle ≠ 90°) | **Automatic adjustment**, no action needed. Side housing is disabled. If lateral stability is required, adjust beam layout to achieve perpendicularity, or add mechanical fasteners. |
| **"The housing at the top cannot be created for this connection. The value is set to 0"** | Beams are not aligned in the same vertical plane | **Automatic adjustment**, no action needed. Top housing is disabled. Verify beam layout; connection may have reduced capacity. Consider repositioning beams or using alternative connection type. |
| **"Beams should be in an angle of 1°-89°. Tool will be deleted"** | Beam intersection angle is outside the valid range (too shallow or too steep) | **Tool auto-deletes**. Check roof geometry: For very shallow roofs (<1°), use beam-on-beam connections. For very steep angles (>89°), use mortise-tenon or other joinery. |
| **"Beams are invalid. Instance deleted"** | One or both assigned beams have been deleted or are no longer valid entities | **Tool auto-deletes**. Restore deleted beams or re-insert connection on valid beams. Check for corrupt beam data. |
| **"Lost connection. Instance deleted"** | Beams no longer physically intersect (moved apart, shortened, or rotated) | **Tool auto-deletes**. Move beams back to intersecting position, then re-insert the connection tool. Use UNDO if beams were moved accidentally. |

### Message Type Classification

**Informational** (Yellow):
- Side housing disabled
- Top housing disabled
These are automatic adaptations; the connection still functions, just with reduced geometry.

**Error** (Red):
- Angle out of range
- Beams invalid
- Connection lost
These cause tool deletion; user must fix the underlying issue and re-insert.

---

## Related Scripts & Workflow Integration

### Complementary Connection Tools

| Script | Purpose | When to Use Instead |
|--------|---------|---------------------|
| `hsbBirdsmouth` | Standard birdsmouth (no housing) | Simpler connections, faster manufacturing, less precision required |
| `T-Connection` | General perpendicular beam connections | Non-roof applications, beams of equal height |
| `hsbBeamCornerConnection` | Corner joints | L-shaped or corner beam intersections |
| `HSB_R-*` family | Roof framing tools | Creating the rafters and purlins before connecting them |

### Typical Workflow Sequence

1. **Design Roof Framing** → `HSB_R-Roof`, `HSB_R-Purlin`
2. **Generate Beams** → Create individual rafters and purlins
3. **Apply Connections** → **hsbHousedBirdsmouth** (this tool)
4. **Add Fasteners** → `SimpleFastener`, `Nail-*`, hardware scripts
5. **Generate Shop Drawings** → `sd_*` family for fabrication drawings
6. **Export to CNC** → BTL/BVDA export for manufacturing

### Roof Framing Scripts Compatibility

**Works Well With**:
- `hsbBlocking` - Add blocking between rafters after connections
- `hsbSheetDistribution` - Apply roof sheathing over connected frame
- `FLR_*` series - If purlins are part of floor/ceiling system
- `HSB_E-*` series - Element-level operations on roof assemblies

**Potential Conflicts**:
- Avoid overlapping connections on same beam pair
- If using `hsbBeamcut` manually, may interfere with birdsmouth cuts
- Check for duplicate tools in OPM if unexpected geometry appears

---

## Advanced Topics

### Understanding the Dependency System

**The tool establishes dynamic dependencies**:
```c
setDependencyOnBeamLength(bm0);  // Rafter
setDependencyOnBeamLength(bm1);  // Purlin
```

**What This Means**:
- Any change to beam length triggers tool recalculation
- Beam position changes also trigger updates
- Beam deletion causes tool auto-deletion

**Benefits**:
- Model stays synchronized automatically
- No manual updates needed after beam edits
- Prevents orphaned connections

**Limitations**:
- Only tracks length and position, not cross-section changes
- If beam width/height changes, tool may need manual deletion and recreation
- Dependency tracking adds computational overhead (negligible for <1000 connections)

---

### Geometry Calculation Details

**For Advanced Users / Troubleshooting**:

#### Coordinate System Transformation
The tool establishes local coordinate systems for both beams:
- **vecXB0**: Rafter axis (along length)
- **vecYB0**: Rafter width direction (horizontal)
- **vecZB0**: Rafter height direction (vertical)

These are calculated dynamically based on beam orientation and world coordinates.

#### Intersection Point Calculation
```
1. Project rafter center onto world XY plane
2. Find intersection of this projection with purlin plane
3. Project this point back onto purlin axis
4. Result: ptBCCen (connection center point on purlin)
```

This ensures the connection is geometrically centered even when beams are at angles.

#### Housing Volume Calculation
Top housing volume is calculated to ensure it spans the full width of the rafter:
```
Length = (purlin_width + 0.5×rafter_width + epsilon) / cos(horizontal_angle)
```
The division by `cos(angle)` extends the cut length to account for skewed intersections.

---

### Debugging Connection Issues

**Problem**: Connection looks wrong in 3D

**Debugging Steps**:
1. **Check beam orientations**: Use `MEASUREGEOM` to verify vecX, vecY, vecZ
2. **Verify beam intersection**: Use 3D view, rotate to see overlap
3. **Inspect cut operations**: Select beam → OPM → expand "Tools" section → check cut parameters
4. **Review TSL properties**: Select connection instance → OPM → verify all parameters match intent
5. **Check for duplicate connections**: Same beam pair may have multiple instances

**Problem**: Side housing not created when it should be

**Cause**: Horizontal angle is 89.9° or 90.1°, not exactly 90.0°

**Fix**:
```
1. Measure actual angle in plan view
2. Rotate rafter or purlin by the small delta (e.g., 0.1°)
3. Delete old connection instance
4. Re-insert tool → side housing should now appear
```

**Problem**: Tool deletes immediately after insertion

**Cause 1**: Angle out of range (1-89°)
- Fix: Adjust roof pitch or use different connection type

**Cause 2**: Beams don't actually intersect
- Fix: Move beams closer or extend lengths until they overlap in 3D

**Cause 3**: Beams are parallel
- Fix: Rotate one beam to create non-zero angle

---

### Performance Considerations

**Model Size Impact**:
- Each connection = 1 TslInst + 3-5 tool operations
- For large roofs (>500 rafters), generation may take 30-60 seconds
- Recalculation happens every time model regenerates

**Optimization Tips**:
1. **Freeze tool layers** during major edits to prevent recalculation
2. **Use catalog presets** to avoid showing dialog repeatedly
3. **Batch insert** by selecting entire roofplane (faster than individual rafters)
4. **Clean up old instances** if beams are deleted (use `PURGE` command)

**When to Use**:
- ✓ High-quality timber frame projects
- ✓ CNC manufacturing workflows
- ✓ Exposed joinery where precision matters
- ✗ Quick design iterations (use simpler `hsbBirdsmouth` instead)
- ✗ Low-precision site-cut framing (overkill for hand tools)

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| **1.2** | 22 Feb 2021 | nils.gregor@hsbcad.com | ✓ Added `sCutMaleBeam` property for optional end cut<br>✓ Included thumbnail image in script<br>✓ Issue reference: HSB-10134 |
| **1.1** | 28 Jan 2021 | nils.gregor@hsbcad.com | ✓ Changed behavior of property (C) from different geometry to horizontal offset<br>✓ Renamed properties for clarity<br>✓ Improved user documentation strings<br>✓ Issue reference: HSB-10134 |
| **1.0** | 26 Jan 2021 | nils.gregor@hsbcad.com | ✓ Initial release<br>✓ Core birdsmouth with housing functionality<br>✓ Automatic angle validation<br>✓ Dynamic dependency tracking<br>✓ Issue reference: HSB-10134 |

### Upgrade Notes

**From 1.0 to 1.1**:
- Property (C) definition changed — review existing models
- Recalculation may produce slightly different geometry
- No action required for most users

**From 1.1 to 1.2**:
- New end cut option available
- Existing instances unaffected (default = "No")
- To enable end cut on existing connections: Edit property in OPM

---

## Frequently Asked Questions

### Q1: Can I use this on metal beams or concrete purlins?
**A**: No, this tool is designed for **timber-to-timber connections** only. The housing cuts assume wood machining with CNC routers. For hybrid connections (wood-to-steel), use metal bracket scripts (`GA-*`, `Simpson*`, `Hilti-*`).

---

### Q2: What happens if I change the purlin width after creating connections?
**A**: The connection should **recalculate automatically** due to dependency tracking. However, if the change is significant, you may want to:
1. Delete existing connections
2. Re-insert with updated beam geometry
3. Verify housing depths are still appropriate for new dimensions

---

### Q3: Can I manually edit the cuts generated by this tool?
**A**: Yes, but with caution:
1. Select the beam (not the TSL instance)
2. In OPM, expand "Tools" section
3. Find the cut operations (BeamCut, Cut)
4. Edit parameters directly

**Warning**: Manual edits are **overwritten** when the TSL recalculates. For permanent changes, adjust the TSL properties instead.

---

### Q4: Why is the birdsmouth cut oversized (10,000mm dimensions)?
**A**: This is a **safety mechanism** to ensure complete material removal:
- Oversized cuts prevent leftover material at beam edges
- Geometry is clipped by beam boundaries automatically
- Prevents manufacturing errors from incomplete cuts
- Standard practice in parametric joinery scripts

---

### Q5: Can I create connections at beam endpoints (not mid-span)?
**A**: Yes, as long as beams **physically intersect** at the endpoint:
- Ridge connections (rafters meet at peak)
- Eave connections (rafters on eave purlin)
- Corner intersections

The tool doesn't distinguish between mid-span and endpoint — only intersection is required.

---

### Q6: What if my rafters are on a curved roofline?
**A**: Each connection is **independent**, so:
- Curved roofs with varying angles work fine
- Each rafter-purlin pair is evaluated separately
- Some connections may fail angle validation if curvature is extreme
- Consider using the tool on straight sections only

---

### Q7: How do I export these connections to the CNC machine?
**A**: Standard hsbCAD export workflow:
1. Generate all connections
2. Use hsbCAD → Export → BTL (Hundegger format)
3. Or Export → BVDA (industry standard)
4. Or Export → DXF for custom CAM software
5. Post-process in your machine's CAM system
6. Verify tool paths before production

The tool cuts are automatically included in beam geometry for export.

---

### Q8: Can I use this for wall studs and plates?
**A**: **Not recommended**. This tool is optimized for **roof framing** (inclined rafters on horizontal purlins). For wall framing:
- Use `HSB_W-*` wall tools instead
- Standard stud-to-plate connections don't need housing
- Simpler nailing or screwing is typical for walls

---

### Q9: What's the difference between this and standard `hsbBirdsmouth`?
| Feature | hsbHousedBirdsmouth | hsbBirdsmouth |
|---------|---------------------|---------------|
| Housing cuts in purlin | ✓ Yes (top & side) | ✗ No |
| CNC precision required | ✓ Yes | ✗ No (can be hand-cut) |
| Lateral stability | ✓ High (side housing) | Moderate (friction only) |
| Manufacturing time | Longer (more cuts) | Faster (simple notch) |
| Complexity | High (5 parameters) | Low (2-3 parameters) |
| **Use Case** | High-end timber frame, CNC | Standard construction, hand tools |

**Choose hsbHousedBirdsmouth** for:
- Exposed timber work
- Engineered lumber (GLT, LVL)
- CNC manufacturing
- Projects requiring maximum precision

**Choose hsbBirdsmouth** for:
- Site-built construction
- Quick design iterations
- Cost-sensitive projects
- Hand-cut joinery

---

### Q10: Can I nest multiple connections on the same purlin?
**A**: Yes! This is the **typical use case**:
- One purlin can support 10-20 rafters
- Each connection is an independent TSL instance
- Spacing is determined by rafter layout

**Minimum Spacing**:
- Ensure housing cuts don't overlap (visual inspection in 3D)
- Typical rafter spacing: 400-600mm (16-24 inches)
- If rafters are too close, housing cuts may interfere

**Check for Overlaps**:
1. View purlin from side
2. Zoom in on connection areas
3. Verify housing pockets don't merge
4. If overlapping, increase rafter spacing or reduce housing depths

---

## Summary

The **hsbHousedBirdsmouth** tool is a sophisticated timber connection script that automates the creation of housed birdsmouth joints between rafters and purlins. It is ideal for CNC-manufactured timber frames where precision and stability are paramount.

**Key Strengths**:
- ✓ Automatic geometric validation (angles, perpendicularity, intersection)
- ✓ Dynamic dependency tracking (self-updates and self-deletes as needed)
- ✓ Dual housing (top + side) for maximum stability
- ✓ CNC-ready geometry with configurable tolerances
- ✓ Catalog support for standardized settings

**Key Limitations**:
- ✗ Requires perpendicular beams for side housing (3-axis CNC constraint)
- ✗ Angle range limited to 1-89° (very shallow or steep roofs not supported)
- ✗ Timber-only (not for metal or concrete hybrid connections)
- ✗ Manual fasteners still needed for uplift/lateral loads

**Best Practices Recap**:
1. Save settings to catalog for repeatability
2. Test gap settings with sample parts before production
3. Ensure beams are exactly perpendicular for full housing
4. Use roofplane selection for batch processing
5. Verify structural adequacy with a licensed engineer
6. Clean up lost connections if beams are moved during design

For standard construction, consider the simpler `hsbBirdsmouth` tool. For high-end timber framing with CNC manufacturing, **hsbHousedBirdsmouth** provides the precision and control needed for professional results.

---

**Document Version**: 2.0
**Last Updated**: 2026-02-21
**Script Version Documented**: 1.2 (22 Feb 2021)
**Status**: Complete Reference Guide
