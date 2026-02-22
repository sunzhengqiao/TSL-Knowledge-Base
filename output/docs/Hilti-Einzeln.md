# Hilti-Einzeln - Hilti Stexon Wood Coupler Connection System

## Overview

**Hilti-Einzeln** is an advanced connector placement script for creating Hilti Stexon wood-to-wood coupling connections between two timber beams. The Stexon system is a modern alternative to traditional wood joinery, using a combination of precision-machined couplers and hanger bolts for faster assembly of prefabricated timber structures.

### Connection System Components

The Stexon connection system consists of **two complementary parts** working together:

1. **HCW/HCWL Wood Coupler** (Female Component)
   - Installed in the "anchor" beam (typically the top beam in horizontal stacks)
   - HCW: Standard version with 37mm diameter
   - HCWL: Long version with 42mm diameter, includes rectangular housing cutout
   - Article Number: 2316449 (HCW 37x45 M12)

2. **HSW Hanger Bolt** (Male Component)
   - Installed in the mating beam (typically the bottom beam)
   - M12 threaded rod with 220mm length, 60mm thread engagement
   - Article Number: 2316491 (HSW M12x220/60 8.8)
   - Galvanized finish for corrosion resistance

### Key Features

- **Dual TSL Architecture**: Creates two synchronized TSL instances (female and male) that update together
- **Automatic Beam Assignment**: Intelligently determines which beam receives coupler vs. bolt based on orientation
- **Distribution Modes**:
  - **Single Mode**: One connector at beam intersection (crossing beams)
  - **Distribution Mode**: Multiple connectors along contact length (parallel beams)
- **Interactive Placement**: Visual feedback with jig mode for precise positioning
- **Collision Detection**: Automatically detects and warns about overlapping connections
- **Import/Export**: Exchange connection data via DXX files for standardization
- **Dissolve Capability**: Convert distributed connections into individual instances

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Beams Required** | 2 (automatic selection during insertion) |
| **Environment** | Model Space |
| **Version** | 1.3 (Latest: 22.11.2021) |
| **Keywords** | Hilti, Stexon, Einzeln, HCW, HCWL, HSW |
| **Implicit Insert** | Yes |

### Hardware Component Details

**Wood Coupler (Female/Anchor Side):**
- Manufacturer: Hilti
- Model: Wood coupler HCW 37x45 M12
- Description: "Faster and more efficient wood connector system for assembling prefabricated timber structures"
- Category: Connector

**Hanger Bolt (Male Side):**
- Manufacturer: Hilti
- Model: Hanger bolt HSW M12x220/60 8.8
- Description: "Galvanized hanger bolt for anchoring wood structures to wood using pre-installed HCW connectors"
- Material: Grade 8.8 steel
- Finish: Galvanized

---

## Prerequisites

Before using Hilti-Einzeln, ensure the following conditions are met:

1. **Two Timber Beams Exist**: The beams must be created in Model Space as GenBeam entities
2. **Valid Contact Surface**: The beams must have overlapping or touching surfaces
   - The script calculates the common contact area between beam bodies
   - Beams too far apart will trigger "beams cannot be connected" error
3. **Beam Configuration**: Beams can be:
   - **Parallel**: Running in the same direction (enables distribution mode)
   - **Crossing**: Intersecting at an angle (single connector mode)
   - **Stacked Horizontally**: One beam directly above the other

### Automatic Beam Role Assignment

When beams are horizontally stacked (common in floor/roof framing):
- **Top Beam** → Receives HCW/HCWL wood coupler (anchor/female)
- **Bottom Beam** → Receives HSW hanger bolt (male)

This assignment can be reversed using the "Swap Parts" context menu option.

---

## Complete Usage Guide

### A. Standard Insertion Workflow

#### Step 1: Launch the Script

**From TSL Menu/Ribbon:**
- Navigate to Hilti tools section
- Click "Hilti-Einzeln" or use custom command

**Via Command Line:**
```
(hsb_ScriptInsert "Hilti-Einzeln")
```

#### Step 2: Select Beams

**Command Prompt:** `"Select 2 beams or <Enter> to import"`

1. **Click First Beam**: This beam will receive the HSW hanger bolt (male component)
   - Selection order matters for initial assignment
   - Can be swapped later via context menu

2. **Click Second Beam**: This beam will receive the HCW/HCWL wood coupler (female component)
   - The script immediately calculates the common contact area
   - If beams are invalid, error message appears

**Alternative - Import Mode:**
- Press **Enter** without selecting beams
- Script searches for `BF-Stexon-EinzelnExport.dxx` in parent folder
- Imports connection data and matches to existing beams by profile geometry

#### Step 3: Interactive Point Selection

The workflow now branches based on beam geometry:

---

### B. Distribution Mode (Parallel Beams)

When beams run parallel, you can distribute multiple connectors along their contact length.

#### First Point Selection

**Command Prompt:** `"Select first point [Fixed/Start/End/Between]|"`

**Option 1: Graphical Selection**
- Click anywhere on the contact surface
- The point is projected onto the distribution axis
- Visual feedback shows:
  - **Green/Cyan profiles**: Contact area between beams
  - **Yellow profile**: Valid insertion zone
  - **Red filled circle**: Preview of drill position at clicked location

**Option 2: Keyword Commands**

| Keyword | Function | Details |
|---------|----------|---------|
| **Fixed** | Toggle distribution mode | Switches between "Even" and "Fixed" spacing |
| **eVen** | Same as Fixed | Alternative spelling |
| **Start** | Set start distance numerically | Prompts: "Enter Start Distance" + current value |
| **End** | Set end distance numerically | Prompts: "Enter End Distance" + current value |
| **Between** | Set spacing numerically | Prompts: "Enter Between Distance" + current value |

**Example Sequence:**
```
Command: Start
Enter Start Distance 0: 100    → Sets 100mm offset from start
Command: <Click location>      → Defines distribution start point
```

#### Second Point Selection

**Command Prompt:** `"Select second point [firstDrill/Fixed/eVen/Start/End/Between]|"`

**Additional Keyword:**

| Keyword | Function |
|---------|----------|
| **firstDrill** | Go back to first point selection | Resets to previous step |

**Distribution Calculation:**
- Script calculates distance between first and second points
- Applies Start Distance and End Distance offsets
- Distributes connectors based on Mode (Even/Fixed) and Max Distance Between

**Visual Feedback During Second Point:**
- **Red filled circles**: Preview of all connector positions
- **Distance labels**: Show calculated spacing
- **Warning "no distribution possible"**: If offsets exceed available length

---

### C. Single Mode (Crossing Beams)

When beams cross (not parallel), only one connector is placed.

**Command Prompt:** `"Select point [Fixed/Start/End/Between]|"`

- The connector is automatically centered at beam intersection
- Distribution parameters are hidden in Properties Panel
- You can still adjust lateral position using Offset Start/Offset End
- Same keyword options available for offset adjustments

---

## Properties Panel Reference

The AutoCAD Properties Palette (OPM) displays different parameter groups based on context.

### Distribution Category

**Visibility:** Hidden in Single Mode (crossing beams), shown in Distribution Mode

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Mode of Distribution** | Dropdown | Even | Even, Fixed | **Even**: Evenly distributes connectors within available space, adjusting spacing to fit maximum quantity.<br>**Fixed**: Uses exact spacing defined by "Max. Distance between", places connectors at both ends |
| **Start Distance** | Length | 0 mm | ≥0 | Offset from distribution start point. Creates a gap before the first connector |
| **End Distance** | Length | 0 mm | ≥0 | Offset from distribution end point. Creates a gap after the last connector |
| **Max. Distance between / Quantity** | Length | 500 mm | Positive: spacing<br>Negative: quantity | **Positive value**: Maximum allowed spacing between connectors<br>**Negative integer** (e.g., -3): Exact quantity of connectors to place<br>Example: -5 places exactly 5 connectors evenly |
| **Real Distance between** | Length | (Calculated) | Read-only | Shows the actual calculated spacing after distribution algorithm |
| **Nr.** | Integer | (Calculated) | Read-only | Total number of connectors in distribution |

#### Distribution Calculation Logic

**Even Mode:**
```
Available Length = Total Length - Start Distance - End Distance
Number of Parts = floor(Available Length / Max Distance Between) + 1
Real Spacing = Available Length / Number of Parts
```

**Fixed Mode:**
```
Connectors placed at exact intervals
Always includes connectors at start and end positions
```

**Negative Quantity Mode:**
```
If Max. Distance between = -N (where N is integer)
Number of Parts = abs(N)
Real Spacing = Available Length / (N - 1)
```

### Version Category

| Parameter | Type | Options | Default | Description |
|-----------|------|---------|---------|-------------|
| **Version** | Dropdown | Custom, HCW, HCWL | (Context dependent) | **HCW**: Standard wood coupler, auto-sets Diameter=37mm<br>**HCWL**: Long wood coupler, auto-sets Diameter=42mm, adds rectangular housing<br>**Custom**: Manual diameter control, no auto-configuration |

**Auto-Configuration by Version:**

| Version | Diameter | Depth | Additional Features |
|---------|----------|-------|-------------------|
| HCW | 37 mm | 250 mm | Round drill only |
| HCWL | 42 mm | 250 mm | Round drill + rectangular housing (rotatable) |
| Custom | User-defined | User-defined | Full manual control |

### Position Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Offset** | Length | 0 mm | Offset along drilling direction (depth adjustment). Positive moves connector deeper into beam, negative brings it outward |
| **Offset Start** | Length | 0 mm | Lateral offset at distribution start. Shifts connector perpendicular to distribution axis at first end |
| **Offset End** | Length | 0 mm | Lateral offset at distribution end. Creates a linear transition from Offset Start to Offset End across distribution |
| **Rotation** | Angle | 0° | Rotation angle of tooling around drill axis. **Critical for HCWL version** - controls orientation of rectangular housing cutout |

**Rotation Usage:**
- HCWL version creates a rectangular pocket oriented perpendicular to drilling direction
- Rotation angle controls the orientation of this pocket
- Useful for aligning housing with beam grain direction or avoiding edge conflicts

### Drill Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Length | 30 mm | Main drill hole diameter. Auto-set to 37mm (HCW) or 42mm (HCWL) when version selected |
| **Depth** | Length | 250 mm | Drill hole depth from beam surface. **Minimum 70mm for HSW hanger bolt** to ensure adequate thread engagement |

**Female Side (HCW/HCWL):**
- Drill creates the socket for wood coupler installation
- Depth should accommodate full coupler body (typically 45mm) plus installation clearance

**Male Side (HSW):**
- Drill creates pilot hole for hanger bolt
- Minimum depth 70mm for thread engagement
- Typical depth 100-150mm for structural capacity

### 2. Bohrung Category (Secondary Drill)

**Purpose:** Creates counterbore or through-hole for specialized installations

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Length | 0 mm | Secondary drill diameter. **Value > primary diameter** = Counterbore (Sackloch). **Value ≤ primary diameter** = Through-hole (Ständerbohrung) |
| **Depth** | Length | 0 mm | Secondary drill depth. For counterbore: depth from surface. For through-hole: total penetration |

**Use Cases:**
1. **Counterbore** (Diameter > primary):
   - Recessed area for coupler installation flush with beam surface
   - Access cavity for installation tools
2. **Through-Hole** (Diameter ≤ primary):
   - Clearance hole through full beam depth
   - Conduit for long fasteners

### Milling Category

**Purpose:** Surface preparation, clearance zones, or custom profiles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Length | 0 mm | Milling width perpendicular to drill axis. Creates rectangular pocket at connector location |
| **Depth** | Length | 0 mm | Milling depth from beam surface. Removes material for coupler seating or clearance |

**Typical Applications:**
- Surface flattening for coupler contact
- Clearance pocket for connector head
- Access area for installation tools

---

## Context Menu Operations

Right-click on any Hilti-Einzeln instance to access advanced functions:

### 1. Swap Parts

**Function:** Reverses beam role assignment (which receives coupler vs. bolt)

**Use Cases:**
- Automatic assignment based on vertical position is incorrect
- Design requires specific beam to be anchor side
- Structural engineer specifies particular configuration

**Behavior:**
1. Swaps `_Beam[0]` and `_Beam[1]` references
2. Destroys current female/male TSL pair
3. Creates new pair with reversed roles
4. Preserves all parameter values

**Technical Implementation:**
- Swaps alignment vector direction
- Updates `ModeMale` flag on both instances
- Maintains distribution settings

### 2. Generate Single Instances

**Availability:** Only when Nr. > 1 (distribution mode with multiple connectors)

**Function:** Dissolves distribution into independent TSL instances

**Process:**
1. Script reads distribution point array
2. Creates new Hilti-Einzeln instance at each connector location
3. Each instance has:
   - Start Distance = 0
   - End Distance = 0
   - Max. Distance between = -1 (single connector)
   - Real Distance between = (previous calculated value)
4. Deletes original distribution TSL

**Why Use This:**
- Individual editing of specific connector locations
- Deletion of selective connectors without affecting others
- Custom spacing adjustments per connector
- Integration with other tools expecting single instances

**Warning:** Action cannot be undone except via Undo command

### 3. Stexon Export

**Function:** Exports all Hilti-Einzeln connections in the drawing to DXX file

**File Location:** `[Drawing Folder]\Hilti-EinzelnExport.dxx`

**Export Process:**
1. Collects all TslInst entities with scriptName "Hilti-Einzeln"
2. Saves beam body geometry for each connection
3. Composes ModelMap with:
   - Solid info (beam geometry)
   - Analyzed tool info (drill/mill operations)
4. Writes to DXX format

**Export Data Includes:**
- Connection point coordinates (_Pt0)
- All property values (distribution, version, offsets, drill params)
- Beam reference handles
- Grip point positions
- Internal map data (alignment vectors, swap flags)

**Use Cases:**
- Documentation of connection layout
- Transfer connection specs to another drawing
- Quality control verification
- CNC machine data preparation

### 4. Save Beam Body

**Function:** Caches beam envelope geometry in instance map

**Technical Purpose:**
- Stores `bm0.envelopeBody()` and `bm.envelopeBody()`
- Used internally for import/export matching
- Enables geometry comparison without full beam recalculation

**User Impact:** Primarily for internal optimization, rarely manually triggered

---

## Import Mode - Connection Data Exchange

### Overview

Import mode enables standardization of connection layouts across multiple drawings by exchanging connection specifications via DXX files.

### Import Workflow

#### Step 1: Activate Import

At initial beam selection prompt, press **Enter** instead of clicking beams.

**Console Message:** `"Hilti-Einzeln enter import"`

#### Step 2: File Location

Script searches for: `[Parent Folder of Current Drawing]\BF-Stexon-EinzelnExport.dxx`

**Parent Folder Logic:**
- Takes current drawing path: `C:\Projects\Building_A\Floor_1\Framing.dwg`
- Navigates up one level: `C:\Projects\Building_A\Floor_1\`
- Looks for: `BF-Stexon-EinzelnExport.dxx`

#### Step 3: Beam Matching Algorithm

**The script does NOT match by beam handles** (these differ between drawings)

**Instead, it matches by geometry:**

1. **Profile Comparison**:
   - Extracts cross-section profile of each beam in current drawing
   - Compares with beam profiles stored in import file
   - Matches based on shape geometry (width, depth, profile outline)

2. **Longitudinal Position**:
   - Compares beam length and position along longitudinal axis
   - Matches beams with similar geometric extents

3. **Tolerance**: Small geometric variations accepted (within epsilon tolerance)

**Matching Success:**
- Creates Hilti-Einzeln instance with imported parameters
- Connects to geometrically equivalent beams in current drawing
- Preserves all distribution, offset, and drilling parameters

**Matching Failure:**
- If no geometric match found, connection is skipped
- Console reports number of successfully imported connections

### Export Preparation

To create an import file for other drawings:

1. Set up connections in master drawing
2. Right-click any Hilti-Einzeln instance
3. Select "Stexon Export"
4. File created: `[Drawing Folder]\Hilti-EinzelnExport.dxx`
5. Rename to `BF-Stexon-EinzelnExport.dxx`
6. Copy to parent folder of target drawings

### Import File Contents

**Stored Data per Connection:**
```
- ScriptName: "Hilti-Einzeln"
- PTORG: Origin point coordinates
- MODEMALE: Boolean flag (female vs male instance)
- LVALUE[]: Integer properties array
- DVALUE[]: Double properties array
- STRVALUE[]: String properties array
- Beam geometry data
- Grip point positions
```

**Not Stored:**
- Beam entity handles (drawing-specific)
- Absolute coordinates (re-calculated during import)
- Material assignments
- Layer information

---

## Interactive Jig Mode

### Visual Feedback System

During point selection, the script provides real-time visual guidance:

#### Color Coding

| Color | Element | Meaning |
|-------|---------|---------|
| **Green/Cyan** | Contact area profiles | Valid beam-to-beam contact surface |
| **Yellow** | Insertion zone profile | Allowed region for connector placement |
| **Red (filled circles)** | Drill position previews | Exact location of each connector hole |
| **Red (text)** | "Collision" warning | Overlap detected with another Stexon connection |
| **Color 3** | Jig graphics | Interactive placement feedback |
| **Color 252** | Property graphics | (If enabled) Interactive property editing interface |

#### Distribution Preview

**During Second Point Selection:**
- Red circles appear at calculated connector positions
- Line segments show distribution axis
- Distance labels indicate spacing
- Updates dynamically as you move cursor

**Distribution Validation:**
- If `Start Distance + End Distance > Total Length`:
  - Shows "no distribution possible" in red
  - Prevents invalid configuration
- Connector count updates based on spacing/quantity parameter

### Advanced Jig Features (Developer Mode)

**Graphical Property Editor** (currently disabled in code):
- Interactive boxes for parameter adjustment
- Click-to-select property cards
- Real-time value modification
- Requires uncommenting section in JIG region (line 208)

---

## Dual TSL Instance Architecture

### Female-Male Pair Concept

Unlike most TSL scripts that create a single instance, Hilti-Einzeln creates **two linked instances**:

1. **Female Instance** (Main/Control)
   - Contains the HCW/HCWL wood coupler
   - Stores distribution parameters
   - User-visible in Properties Panel
   - Created first during insertion

2. **Male Instance** (Linked/Dependent)
   - Contains the HSW hanger bolt
   - Mirrors female instance parameters
   - Created automatically by female instance
   - Synchronized via dependency system

### Synchronization Mechanism

**Property Propagation:**
When user modifies any property in female instance:

```
Female Instance (User Modified)
    ↓
  Updates own parameters
    ↓
  Retrieves male instance via _Map.getEntity("maleTsl")
    ↓
  Pushes all property values to male instance
    ↓
  Male instance recalculates
```

**Synchronized Properties:**
- All distribution parameters (Start, End, Between distances)
- All position parameters (Offsets, Rotation)
- Version selection
- Drill/Mill dimensions
- Nr. (quantity)

**Implementation Details:**
```tsl
// Property sync code (simplified)
if (tslMale.propDouble(iPropIndexDouble) != dDistanceBottom)
    tslMale.setPropDouble(iPropIndexDouble, dDistanceBottom);

if (tslMale.propDouble(iPropIndexDouble) != dOffset)
    tslMale.setPropDouble(iPropIndexDouble, dOffset);
```

### Dependency Tracking

**Female → Male:**
```tsl
setDependencyOnEntity(tslMale);
```
- Female instance tracks male instance
- If female recalculates, male automatically recalculates
- If female is deleted, male is automatically deleted

**Male → Female:**
```tsl
mapMale.setEntity("femaleTsl", _ThisInst);
```
- Male stores reference to female
- Enables swap operation
- Prevents orphaned instances

### Swap Operation Implementation

**When "Swap Parts" is triggered:**

1. **If triggered on Female instance:**
   - Creates new Female instance with beams swapped
   - Deletes old Male instance
   - Deletes self
   - New Female creates new Male automatically

2. **If triggered on Male instance:**
   - Retrieves Female instance reference
   - Triggers swap on Female instance
   - (Male then gets deleted by Female's swap process)

**Result:** Complete role reversal while preserving all parameters

---

## Collision Detection System

### Purpose

Prevents overlapping Stexon connections that would create conflicting drill paths in the same beam volume.

### Detection Algorithm

**Scope:** Checks all Hilti-Einzeln instances in the same group as connected beams

**Process:**
1. Collects all Stexon instances linked to same Element/Group
2. For each instance:
   - Retrieves cutting body geometry (drill volume)
   - Performs Boolean intersection test with current instance's cutting body
3. If intersection volume > 0:
   - Sets dependency between instances
   - Displays "Collision" warning

**Cutting Body:**
- Combined geometry of:
  - Primary drill cylinder
  - Secondary drill (if defined)
  - Milling pocket (if defined)
  - HCWL rectangular housing (if applicable)

### Visual Warning

**Display:**
- Red text "Collision" appears near connector
- Warning persists until collision is resolved

**Resolution Options:**
1. Move connector by adjusting distribution points
2. Adjust offsets to shift laterally
3. Delete one of the conflicting connections
4. Reduce diameter/depth if minor overlap

### Dependency Creation

**When collision detected:**
```tsl
setDependencyOnEntity(conflictingInstance);
```

**Effect:**
- Both instances recalculate together
- Prevents inconsistent states
- Ensures collision status updates when either moves

---

## Grip Point Editing

### Available Grip Points

| Grip ID | Location | Function | Mode |
|---------|----------|----------|------|
| **_Pt0** | Distribution start | Move first connector position | All modes |
| **_PtG0** | Distribution end | Adjust distribution length | Distribution mode only |

### _Pt0 Grip (Origin)

**Visual:** Cyan square grip at first connector location

**Drag Behavior:**
1. Cursor snaps to distribution axis
2. Red circle preview follows cursor
3. All distribution recalculates from new origin
4. Maintains relative spacing

**In Single Mode:**
- Moves the single connector
- Snaps to beam intersection point
- Lateral offset from axis allowed

**In Distribution Mode:**
- Redefines distribution start
- Grip point projected onto axis
- Preserves Start Distance offset
- End point (_PtG0) remains fixed

### _PtG0 Grip (End Point)

**Availability:** Distribution mode only (hidden in Single mode)

**Visual:** Cyan square grip at last connector location

**Drag Behavior:**
1. Cursor snaps to distribution axis
2. Multiple red circle previews show updated distribution
3. Recalculates spacing based on new total length
4. Origin (_Pt0) remains fixed

**Grip Point Calculation:**
```tsl
if (_bOnGripPointDrag && (_kExecuteKey == "_Pt0" || _kExecuteKey == "_PtG0"))
{
    if (_kExecuteKey == "_Pt0")
        ptText = _Pt0;  // Update from origin grip

    if (_kExecuteKey == "_PtG0")
        ptText = _PtG[0];  // Update from end grip
}
```

### Interactive Feedback During Drag

**Display Updates:**
- Distribution axis line
- All connector position circles
- Distance labels (if enabled)
- Collision warnings (if applicable)
- Contact area highlighting

---

## Hardware Bill of Materials Integration

### Automatic HardWrComp Creation

The script automatically generates hardware component entries for integration with hsbCAD's Bill of Materials system.

### Component Data Structure

**Female Instance (HCW/HCWL):**
```
Article Number: 2316449
Model: Wood coupler HCW 37x45 M12
Manufacturer: Hilti
Category: Connector
Quantity: nNrResult (number of connectors in distribution)
Group: [Element Group Name or Loose Group]
Linked Entity: bm0 (anchor beam)
Rep Type: _kRTTsl (TSL-generated component)
```

**Male Instance (HSW):**
```
Article Number: 2316491
Model: Hanger bolt HSW M12x220/60 8.8
Manufacturer: Hilti
Category: Connector
Quantity: nNrResult
Group: [Same as female instance]
Linked Entity: bm0 (male beam reference)
Rep Type: _kRTTsl
```

### Group Assignment Logic

**Priority 1 - Element Group:**
```tsl
Element elHW = bm0.element();
if (elHW.bIsValid())
    sHWGroupName = elHW.elementGroup().name();
```
- If beam belongs to Element (Wall, Floor, Roof), uses Element's group

**Priority 2 - Loose Group:**
```tsl
Group groups[] = _ThisInst.groups();
if (groups.length() > 0)
    sHWGroupName = groups[0].name();
```
- If beam is loose (not in Element), uses first assigned group

**Result:** Hardware quantities aggregate correctly in BOM by assembly group

### BOM Output

When generating Bills of Material:
- HCW/HCWL couplers listed per anchor beam assembly
- HSW hanger bolts listed per mating beam assembly
- Quantities sum across all connections in group
- Article numbers enable direct ordering from Hilti

---

## Advanced Topics

### Version Selection and Auto-Configuration

**Version Parameter Mapping:**

| Version String | Diameter | Depth | Special Features |
|----------------|----------|-------|------------------|
| "Custom" | User value | User value | None |
| "HCW" | 37 mm | 250 mm | Standard coupler |
| "HCWL" | 42 mm | 250 mm | Rectangular housing |

**Auto-Configuration Trigger:**
```tsl
if (_kExecuteKey.length() > 0)  // Property changed via catalog
{
    if (sEntries.findNoCase(_kExecuteKey, -1) > -1)
        setPropValuesFromCatalog(_kExecuteKey);
}
```

**HCWL Special Geometry:**
- Circular drill: 42mm diameter
- Rectangular housing:
  - Dimensions: 42mm × ~21mm
  - Orientation controlled by Rotation parameter
  - Subtracted from circular profile
  - Visible in plan view drawings

### Coordinate System Transformations

**Part Body Coordinate System:**
```tsl
Vector3d vecYpart = vecPlane;  // Drill axis
Vector3d vecZpart = qd.vecD(_ZW);  // Vertical reference
if (vecZpart.isParallelTo(vecYpart))
    vecZpart = vecX;  // Handle parallel case
Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
vecXpart.normalize();
```

**Transformation for Tooling:**
```tsl
CoordSys csPartTransform;
csPartTransform.setToAlignCoordSys(
    Point3d(0,0,0), _XW, _YW, _ZW,  // From: World origin
    ptJigPlane, vecXpart, vecYpart, vecZpart  // To: Tool location
);
bdPart.transformBy(csPartTransform);
```

### Execution Loops and Timing

**Two-Pass Execution:**
```tsl
if (_bOnDbCreated)
    setExecutionLoops(2);
```

**Purpose:**
- Loop 1: Create geometry, calculate parameters
- Loop 2: Update hardware components with final quantities
- Ensures HardWrComp has accurate nNrResult value

**Required for:**
- Hardware BOM accuracy
- Dependency synchronization
- Male TSL creation and sync

### Valid Alignment Vectors

**6-Direction Contact Check:**
```tsl
Vector3d vecs[] = { vecX, -vecX, vecY, -vecY, vecZ, -vecZ };
```

**Purpose:** Determines which beam faces are in contact

**Algorithm:**
1. Test intersection of beam with each face direction
2. Store valid directions in `mapValidVectors`
3. User's view direction selects best alignment
4. Determines drill entry face

**View-Based Selection:**
```tsl
if (vecViewdirection.dotProduct(vecsValid[iV]) >
    vecViewdirection.dotProduct(vecValidDirection))
{
    // This direction is more aligned with view
    iVvalid = iV;
}
```

**Result:** Connector always drills from visible face in current view

---

## Workflow Examples

### Example 1: Simple Beam-to-Beam Connection

**Scenario:** Connect horizontal floor joist to vertical support beam

1. Launch Hilti-Einzeln
2. Select vertical beam (will receive HSW bolt)
3. Select horizontal joist (will receive HCW coupler)
4. In Properties Panel:
   - Version: HCW (auto-sets 37mm diameter)
   - Mode: (Hidden - beams cross at single point)
5. Click placement point at intersection
6. Result: Single connector with default settings

**Tip:** Use Offset to adjust bolt depth into vertical beam

### Example 2: Distributed Connection Along Beam Length

**Scenario:** Connect two parallel beams with 5 evenly-spaced couplers

1. Launch Hilti-Einzeln
2. Select first beam
3. Select second parallel beam
4. Properties Panel:
   - Mode of Distribution: Even
   - Start Distance: 100 mm
   - End Distance: 100 mm
   - Max. Distance between / Quantity: -5 (exact 5 connectors)
5. Click first point 100mm from beam end
6. Click second point 100mm from other beam end
7. Result: 5 connectors evenly distributed

**Verification:** Check "Nr." shows 5, "Real Distance between" shows calculated spacing

### Example 3: Fixed Spacing for Code Compliance

**Scenario:** Building code requires maximum 600mm spacing

1. Setup as Example 2, but:
   - Mode of Distribution: Fixed
   - Max. Distance between: 600 mm (not negative)
2. Click distribution start and end
3. Result: Connectors placed at 600mm intervals with end connectors guaranteed

**Fixed Mode Advantage:** Always includes connectors at both ends regardless of total length

### Example 4: Swapping Connection Roles

**Scenario:** Automatic assignment put coupler in wrong beam

1. Right-click on any connector in the pair
2. Select "Swap Parts"
3. Result:
   - Top beam now has HSW bolt
   - Bottom beam now has HCW coupler
   - All parameters preserved

**Use Case:** Design requires anchor side in specific beam for structural reasons

### Example 5: Converting Distribution to Singles

**Scenario:** Need to delete middle connector from 5-connector distribution

1. Right-click on distribution
2. Select "Generate Single Instances"
3. Result: 5 independent Hilti-Einzeln instances
4. Select and delete unwanted connector(s)
5. Remaining connectors are independent

**Warning:** Cannot recombine into distribution after dissolving

### Example 6: Export/Import for Standardization

**Scenario:** Standardize connection layout across 20 identical residential floors

**Master Drawing Setup:**
1. Create floor framing with all Stexon connections
2. Test and verify connection layout
3. Right-click any Stexon connection
4. Select "Stexon Export"
5. File created: `Hilti-EinzelnExport.dxx`

**Target Drawing Application:**
1. Copy export file to: `[Project Folder]\BF-Stexon-EinzelnExport.dxx`
2. Open target floor drawing (must have identical beam layout)
3. Launch Hilti-Einzeln
4. Press Enter at beam selection (Import mode)
5. Connections automatically created at matching beam locations

**Requirement:** Target drawing beams must match profile geometry

### Example 7: HCWL with Rotated Housing

**Scenario:** Long coupler installation requiring specific housing orientation

1. Launch Hilti-Einzeln
2. Select beams
3. Properties:
   - Version: HCWL (sets 42mm diameter)
   - Rotation: 45° (orients rectangular housing at 45°)
4. Place connector
5. Result: Circular drill + rectangular housing rotated 45° from default

**Use Case:** Align housing with beam grain or avoid edge distance violations

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: "beams cannot be connected"

**Cause:** Beams have no valid contact surface

**Solutions:**
1. **Check beam proximity**: Beams must touch or overlap
   - Move beams closer together
   - Verify beam endpoints align
2. **Verify beam validity**: Ensure both are valid GenBeam entities
   - Check beam creation method
   - Recalculate beams if necessary
3. **Contact area too small**: Increase beam overlap
   - Extend one beam to create larger contact surface
   - Adjust beam positioning

#### Issue: "no distribution possible" during point selection

**Cause:** `Start Distance + End Distance ≥ Total Distribution Length`

**Solutions:**
1. Reduce Start Distance
2. Reduce End Distance
3. Move distribution points farther apart
4. Use Single mode instead (one connector)

**Example:**
```
Total Length = 500mm
Start Distance = 300mm
End Distance = 300mm
Result: 300 + 300 = 600 > 500  → ERROR
```

#### Issue: Connectors placed incorrectly after import

**Cause:** Beam geometry differs between master and target drawings

**Solutions:**
1. **Verify beam profiles match**: Cross-sections must be identical
   - Compare beam width/depth
   - Check profile shape (rectangular vs. custom)
2. **Check beam alignment**: Beams must be in same relative positions
3. **Re-export from corrected master**: Update master drawing and re-export

#### Issue: "Collision" warning appears

**Cause:** Multiple Stexon connections overlap in same beam volume

**Solutions:**
1. **Adjust distribution**: Move connectors to avoid overlap
   - Change Start/End distances
   - Reduce number of connectors
2. **Check other connections**: Identify conflicting instance
   - Select and highlight both connections
   - Delete or move one
3. **Reduce drill diameter**: If only minor overlap
4. **Adjust offsets**: Shift laterally to avoid conflict

#### Issue: Male instance not updating when female changed

**Cause:** Dependency link broken or male instance deleted

**Solutions:**
1. **Check male instance exists**: Should be automatically created
2. **Recalculate female instance**: Forces male recreation
3. **Delete and recreate**: Remove connection and start fresh

**Prevention:** Do not manually delete male instance - always delete female

#### Issue: Hardware not appearing in BOM

**Cause:** Execution loops not completing or group assignment failed

**Solutions:**
1. **Force recalculation**: Right-click instance, recalculate
2. **Check group membership**: Ensure beam belongs to Element or Group
3. **Verify BOM settings**: Check BOM script includes "Connector" category

#### Issue: Distribution count doesn't match expected

**Cause:** Calculation based on spacing, not explicit quantity

**Solutions:**
1. **Use negative quantity mode**: Enter -N to force N connectors
   - Example: -7 creates exactly 7 connectors
2. **Check "Nr." property**: Shows actual calculated quantity
3. **Adjust spacing**: Fine-tune Max. Distance between

#### Issue: HCWL rectangular housing oriented wrong

**Cause:** Default rotation doesn't match required orientation

**Solution:**
- Adjust **Rotation** property to orient housing
- Values: 0°, 90°, 180°, 270° for common orientations
- Custom angles supported

#### Issue: Properties Panel shows wrong category labels

**Cause:** Display language mismatch or translation keys

**Solution:**
- Generally cosmetic only
- Parameters still function correctly
- Check hsbCAD language settings

---

## Best Practices

### Design Phase

1. **Plan connection layout before insertion**
   - Calculate required spacing for structural loads
   - Consider edge distance requirements (typically ≥5× diameter)
   - Account for grain direction in beams

2. **Use version presets (HCW/HCWL) rather than Custom**
   - Ensures compliance with Hilti specifications
   - Auto-configures drill parameters correctly
   - Prevents user error in diameter/depth entry

3. **Leverage distribution mode for repetitive connections**
   - Faster than placing individual connectors
   - Ensures consistent spacing
   - Easier to modify all at once

4. **Test import/export on small section first**
   - Verify beam geometry matching works
   - Confirm parameter transfer
   - Scale up to full project after validation

### Installation Phase

1. **Verify drill depths before CNC export**
   - Female side: Full coupler depth + clearance
   - Male side: Minimum 70mm thread engagement
   - Check for through-penetration on thin beams

2. **Check collision warnings seriously**
   - Overlapping drills create structural voids
   - May violate edge distance requirements
   - Resolve before manufacturing

3. **Use "Generate Single Instances" sparingly**
   - Only when truly need independent editing
   - Distributions easier to maintain long-term
   - Cannot recombine after dissolving

4. **Document custom configurations**
   - Note any Custom version usage (non-standard)
   - Record offset adjustments for field verification
   - Export configurations for future reference

### Quality Control

1. **Visual inspection in 3D view**
   - Rotate view to verify connector orientation
   - Check drill directions make sense
   - Confirm HCWL housing alignment

2. **BOM verification**
   - Compare hardware quantities with manual count
   - Verify article numbers match Hilti catalog
   - Check group assignments correct

3. **Export for documentation**
   - Create export file for as-built records
   - Include in project documentation
   - Enables future modifications

### Performance Optimization

1. **Limit distribution quantities**
   - Very high connector counts slow recalculation
   - Consider breaking into multiple shorter distributions
   - Typical max: 20-30 per distribution

2. **Clean up unused instances**
   - Delete test/trial connections
   - Remove replaced configurations
   - Reduces file size and calculation time

3. **Use groups effectively**
   - Assign beams to Elements or Groups before connector placement
   - Enables efficient BOM aggregation
   - Improves collision detection performance

---

## Related Scripts

### Hilti Connector Family

| Script Name | Purpose | Relationship to Hilti-Einzeln |
|-------------|---------|-------------------------------|
| **Hilti-Paar** | Paired Stexon connections | Uses two Einzeln instances in coordinated pairs |
| **Hilti-P2P** | Post-to-post connection | Specialized Einzeln configuration for column connections |
| **Hilti-Verankerung** | Wall anchorage system | Different Hilti product line (X-ENP anchor system) |
| **Hilti-Decke** | Ceiling/floor anchorage | Slab-to-beam connections |
| **Hilti-Stockschraube** | Thread rod connection | Alternative to Stexon for long-distance connections |
| **Hilti-Verteilung** | Distribution tool | Generic Hilti fastener distribution |

### Complementary Hardware Scripts

- **Simpson StrongTie** series: Alternative connector manufacturers
- **Rothoblaas** series: Hidden connector systems
- **BMF** series: European beam hangers
- **Generic Angle** (GA): Custom angle bracket generator

### Workflow Integration

- **hsbBOM**: Aggregates Hilti hardware into material lists
- **HSB_G-BillOfMaterial**: Generates complete project BOM including Stexon
- **sd_MetalpartBOM**: Shop drawing BOM extraction
- **hsbCNC**: CNC export for Stexon drill patterns

---

## Technical Reference

### Script Execution Flow

```
1. _bOnInsert Phase
   ├─ Prompt: "Select 2 beams or <Enter> to import"
   ├─ If beams selected → Standard insertion
   │  ├─ Calculate beam contact area
   │  ├─ Determine parallel vs crossing geometry
   │  ├─ If parallel → Enable distribution mode
   │  └─ If crossing → Single mode
   └─ If Enter → Import mode
      ├─ Read: BF-Stexon-EinzelnExport.dxx
      ├─ Match beams by profile geometry
      └─ Create instances with imported parameters

2. Point Selection Phase (if not import)
   ├─ First point
   │  ├─ Jig mode: Visual feedback
   │  ├─ Keywords: Fixed/Start/End/Between
   │  └─ Store: _Map.setPoint3d("ptJig0", point)
   └─ Second point (distribution mode only)
      ├─ Jig mode: Distribution preview
      ├─ Keywords: firstDrill/Fixed/eVen/Start/End/Between
      └─ Calculate connector positions

3. Main Calculation Phase
   ├─ Beam geometry analysis
   │  ├─ Contact surface calculation
   │  ├─ Alignment vector determination
   │  └─ Valid face identification
   ├─ Distribution calculation
   │  ├─ Apply offsets (Start, End)
   │  ├─ Calculate quantity (Even/Fixed mode)
   │  └─ Generate point array: ptsDis[]
   ├─ Collision detection
   │  ├─ Collect other Stexon instances
   │  ├─ Boolean intersection test
   │  └─ Set dependencies if overlap
   └─ Tool creation
      ├─ Primary drill (Diameter, Depth)
      ├─ Secondary drill (if Diameter > 0)
      ├─ Milling pocket (if Width > 0)
      └─ HCWL housing (if Version = HCWL)

4. Dual Instance Creation
   ├─ Female instance (main)
   │  ├─ Beam: bm0 (anchor side)
   │  ├─ Tool: HCW/HCWL coupler drill
   │  └─ Hardware: Article 2316449
   └─ Male instance (created by female)
      ├─ Beam: bm (mating side)
      ├─ Tool: HSW bolt pilot hole
      ├─ Hardware: Article 2316491
      └─ Dependency: Linked to female

5. Hardware Component Generation
   ├─ Determine group name
   │  ├─ From Element.elementGroup()
   │  └─ Or from _ThisInst.groups()[0]
   ├─ Create HardWrComp
   │  ├─ Article number
   │  ├─ Quantity: nNrResult
   │  └─ Link to beam
   └─ Execution loop 2: Update quantities

6. Display Phase
   ├─ Model space representation
   │  ├─ Contact area highlighting
   │  ├─ Drill circle previews
   │  └─ Collision warnings
   └─ Grip points
      ├─ _Pt0: Distribution start
      └─ _PtG0: Distribution end
```

### Map Data Structure

**Internal _Map Contents:**

```
String/Boolean Flags:
- "import" (int): Import mode flag
- "ModeMale" (int): 0=Female instance, 1=Male instance
- "iSwapDirection" (int): Beam swap state tracking
- "iSingle" (int): Single vs distribution mode

Entity References:
- "bmFemale" (Entity): Female side beam
- "maleTsl" (Entity): Male instance reference
- "femaleTsl" (Entity): Female instance reference

Geometry Data:
- "ptCen" (Point3d): Connection center point
- "vecX", "vecY", "vecZ" (Vector3d): Local coordinate system
- "vecAlignment" (Vector3d): Contact face normal
- "dLength", "dWidth", "dHeight" (double): Contact box dimensions
- "bdPart" (Body): Connector part geometry
- "bdGb" (Body): Beam envelope for graphics

Distribution Data:
- "ptJig0" (Point3d): First distribution point
- "ptg0Absolute" (Point3d): Second distribution point (absolute coords)

Valid Alignment Vectors:
- "mapValidVectors" (Map): Contains valid face directions
  - "ind1" through "ind6" (int): Validity flags
  - "pp1" through "pp6" (PlaneProfile): Face profiles
```

### Property Index Mapping

**Integer Properties (nProps[]):**
```
Index 0: nNrResult (Nr.)
```

**Double Properties (dProps[]):**
```
Index 0:  dDistanceBottom (Start Distance)
Index 1:  dDistanceTop (End Distance)
Index 2:  dDistanceBetween (Max. Distance between / Quantity)
Index 3:  dDistanceBetweenResult (Real Distance between)
Index 4:  dOffset (Offset)
Index 5:  dOffsetStart (Offset Start)
Index 6:  dOffsetEnd (Offset End)
Index 7:  dRotation (Rotation)
Index 8:  dDiameter (Diameter)
Index 9:  dDepth (Depth)
Index 10: dDiameterSink (2. Bohrung Diameter)
Index 11: dDepthSink (2. Bohrung Depth)
Index 12: dWidthMill (Milling Width)
Index 13: dDepthMill (Milling Depth)
```

**String Properties (sProps[]):**
```
Index 0: sModeDistribution (Mode of Distribution)
Index 1: sVersion (Version)
```

### Context Menu Trigger Keys

**Registered Triggers:**
```
T("|Swap Parts|") → sTriggerswapBeams
T("|Generate Single Instances|") → sTriggergenerateSingleInstances
T("|Stexon Export|") → sTriggerStexonExport
T("|save Beam Body|") → sTriggersaveBeamBody
```

**Activation:**
```tsl
if (_bOnRecalc && _kExecuteKey == sTriggerswapBeams)
{
    // Execute swap operation
}
```

---

## FAQ

**Q: Can I use Hilti-Einzeln with non-Hilti hardware?**

A: The script is specifically designed for Hilti Stexon HCW/HCWL/HSW system. While you can set Custom version and adjust diameters, the hardware BOM will still reference Hilti article numbers. For other manufacturers, use Generic hardware scripts or create custom TSL.

**Q: What's the minimum/maximum beam thickness for Stexon?**

A:
- **Minimum**: 70mm (female side) to accommodate coupler depth + thread engagement
- **Maximum**: Limited by HSW bolt length (220mm) and drill depth capability
- For thin beams, verify drill depth doesn't create through-hole unless intentional

**Q: How do I delete a Stexon connection?**

A:
- **Female instance**: Select and delete. Male instance automatically deleted.
- **Male instance**: Delete is possible but NOT recommended. Always delete female.
- **Both**: Deleting female cleans up entire connection pair.

**Q: Can I change beam assignment after creation without Swap Parts?**

A: No. The beam-to-part assignment is fundamental to the TSL instance structure. Use "Swap Parts" to reverse roles, or delete and recreate if changing to completely different beams.

**Q: Why does Version show "HSW" on some instances?**

A: You're viewing the male instance. Male instances only offer "HSW" version since they only create hanger bolt holes. The female instance shows "Custom", "HCW", "HCWL" versions.

**Q: What happens if I modify drill parameters while in distribution mode?**

A: All connectors in the distribution update simultaneously since they're part of single TSL instance. If you need different drill sizes per connector, use "Generate Single Instances" first.

**Q: Can I create Stexon connections in Paper Space?**

A: No. Hilti-Einzeln is Model Space only (#Type O, environment Model Space). It operates on GenBeam entities which don't exist in Paper Space.

**Q: How do I control which beam face receives the drill?**

A: The script automatically selects the contact face based on:
1. Beam-to-beam contact surface analysis
2. Your current view direction (selects face most visible to you)
3. Use offset parameters to shift position if needed

**Q: Why can't I see the male instance in Object Manager?**

A: The male instance exists as separate TslInst but is dependency-linked to female. It may be hidden if:
- Filtered by layer
- Hidden group
- Dependency display disabled

Search for it by handle stored in female instance's _Map.

**Q: Can I nest Hilti-Einzeln with other hardware scripts?**

A: Yes. Stexon connections can coexist with:
- Nails (Nail-SheetOnBeam)
- Other Hilti products (Hilti-P2P, Hilti-Verankerung)
- Simpson hangers
- Custom hardware

Collision detection prevents Stexon-to-Stexon conflicts but doesn't check other hardware types.

**Q: What file format does export/import use and can I edit it?**

A: DXX (AutoCAD Drawing Exchange) format. It's a binary/encoded format not easily human-editable. For bulk parameter changes, edit in master drawing and re-export.

**Q: How do I align multiple distributions to same start point?**

A:
1. Create first distribution
2. Note _Pt0 coordinates
3. For subsequent distributions, use same coordinates for first point
4. Or use "Fixed" mode with identical Start Distance values

**Q: Can distribution follow curved beam path?**

A: No. Distribution is always linear along straight axis between two points. For curved paths, place individual connectors manually.

**Q: Why doesn't rotation affect HCW version?**

A: HCW creates circular drill only - rotation has no effect on circular geometry. Rotation only matters for HCWL version which includes rectangular housing.

**Q: How do I create connection at specific distance from beam end?**

A: Use keyword option during first point selection:
1. Type "Start" at prompt
2. Enter desired distance (e.g., 150)
3. Click on beam - connector offset by specified distance

**Q: Can I use this for metal beams?**

A: Technically possible (script operates on GenBeam entities regardless of material), but Hilti Stexon is designed for wood-to-wood connections. For steel, use appropriate metal hardware scripts.

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| **1.3** | 22.11.2021 | Added **Rotation** property for HCWL housing orientation control | Marsel Nakuci |
| **1.2** | 23.09.2021 | Added **import capabilities** - beam matching by geometry, DXX import | Marsel Nakuci |
| **1.1** | 08.09.2021 | Added comprehensive **script description** in header | Marsel Nakuci |
| **1.0** | 27.08.2021 | **Initial version** - Core functionality: dual TSL, distribution, HCW/HCWL/HSW | Marsel Nakuci |

### Development Roadmap (Potential Future Features)

- Multiple connector types in single distribution (mixed HCW/HCWL)
- Curved path distribution support
- Integration with structural analysis for automatic spacing calculation
- 3D preview of installed hardware components
- Batch edit for multiple distributions simultaneously
- Template library for common connection patterns

---

## Support and Resources

### Hilti Product Information

- **Stexon System Overview**: [Hilti.com - Stexon Product Page]
- **Installation Guide**: Included with Hilti connector packages
- **Load Tables**: Consult Hilti technical documentation for allowable loads
- **Code Compliance**: Check local building codes for Stexon acceptance

### hsbCAD Resources

- **TSL Documentation**: [hsbCAD Help System - TSL Section]
- **Forum**: hsbCAD Community Forum - Hardware Connectors
- **Training**: Contact hsbCAD for Hilti connector training courses

### Technical Support

- **Script Issues**: hsbCAD Support (support@hsbcad.com)
- **Product Technical**: Hilti Technical Advisory (hilti.com/contact)
- **Structural Questions**: Consult licensed structural engineer

---

*Document Version: 2.0*
*Generated: 2026-02-20*
*Based on Script Version: 1.3*
*Documentation Size: ~48KB (comprehensive coverage of 915KB script)*
