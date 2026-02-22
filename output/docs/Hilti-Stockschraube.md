# Hilti-Stockschraube

## Overview

The **Hilti-Stockschraube** script is a specialized hardware installation tool for creating Hilti Stexon hanger bolt (HSW type) drill operations in timber construction projects. This script automates the placement of drill holes for M12x220/60 8.8 galvanized hanger bolts used with the Hilti HCW connector system.

**Primary Application:** Connecting timber joists to wall top plates or other timber-to-timber structural connections where pre-installed HCW connectors are used.

**Key Features:**
- Automatic placement at element-joist intersections
- Interactive point-based placement with visual feedback
- Edge distance validation with visual warnings
- Baufritz project-specific configurations
- Export capability for Hilti manufacturing software integration
- Dynamic parameter validation with boundary enforcement

---

## Script Classification

| Property | Value |
|----------|-------|
| **Category** | Hardware/Hilti |
| **Script Type** | O (Object-based TSL) |
| **Version** | 1.7 (October 8, 2024) |
| **Author** | Marsel Nakuci, Thorsten Huck |
| **Beams Required** | 0 (dynamically associated during insertion) |
| **Model Space** | Yes (Primary execution environment) |
| **Paper Space** | No |
| **Shop Drawing** | No |
| **DXA Export** | Supported (#DxaOut 1) |
| **Keywords** | Hilti, Stexon, HSW |

---

## Environment & Prerequisites

### Execution Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | ✓ Yes | Primary execution space for drill placement and BOM entries |
| **Paper Space** | ✗ No | Not supported |
| **Shop Drawing** | ✗ No | Not supported |

**Unit System:** Millimeters (mm) - All dimensions automatically converted via `U()` function

### Prerequisites

Before using this script, ensure the following conditions are met:

#### 1. Beam Information Requirements

**Standard Projects:**
- Target beams (joists) MUST contain the keyword **"Hilti"** in their beam information field
- Beams without this keyword will be automatically filtered out during selection

**Baufritz Projects:**
- When Project Special is set to **"BAUFRITZ"**, beams with **"Stexon"** in their information field are also accepted
- This provides flexibility for Baufritz-specific workflows

**How to Set Beam Information:**
1. Select the beam in AutoCAD
2. Open Properties (Ctrl+1)
3. Locate the "Information" field (beam-specific property)
4. Enter "Hilti" or "Stexon" (for Baufritz) in the information field

#### 2. Element Requirements

**Wall Elements:**
- Elements should be properly defined with correct coordinate system orientation
- Top plates must be identifiable within the element structure
- The script only places on **top plates**, not bottom plates

**Element Orientation:**
- Element vecY should point upward (toward the top of the wall)
- Element vecX should align with the wall's length direction
- Element vecZ should align with the wall's thickness direction

#### 3. Project Configuration

**Baufritz Projects:**
- Set the project special to **"BAUFRITZ"** to enable:
  - Acceptance of "Stexon" beam information
  - Additional "Ausführung" property for tool version selection
  - Modified edge distance rules (no minimum distance from beam start/end)

**How to Set Project Special:**
- Use hsbCAD project settings to define project special
- The script automatically detects and converts to uppercase for comparison

#### 4. Joist Requirements

**Orientation:**
- Joists must be **horizontal** (perpendicular to World Z-axis)
- Sloped or vertical beams will be rejected during placement

**Element Association:**
- If a joist is part of an element, it MUST have "Hilti" (or "Stexon" for Baufritz) information
- Standalone joists (not in elements) have more flexible requirements

---

## Usage Instructions

### Basic Workflow

The Hilti-Stockschraube script supports three distinct placement modes, automatically selected based on your entity selection pattern:

1. **Parallel Mode:** One element + one parallel joist + interactive point selection
2. **Intersection Mode:** Elements + perpendicular joists = automatic placement at intersections
3. **Point Mode:** Joists only + interactive point clicking

### Step-by-Step Guide

#### Step 1: Launch the Script

**Command Sequence:**
```
Command: TSLINSERT
Select TSL file: Hilti-Stockschraube.mcr
```

**Alternative Methods:**
- Use hsbCAD script browser to locate and insert
- Assign to a toolbar button for quick access
- Use keyboard shortcut if configured

#### Step 2: Select Elements (Optional)

**Prompt:** `"Select element(s), <Enter> to pick points"`

**Options:**

**A. Select One or More Wall Elements:**
- Click on wall elements where you want to place stexons
- Only `ElementWallSF` (stick-frame wall elements) are accepted
- Press Enter when selection is complete

**B. Skip Element Selection:**
- Press Enter immediately to proceed without element selection
- Use this when placing on standalone joists or when you want manual point selection

**Selection Tips:**
- Use selection window to capture multiple elements
- Elements help the script determine optimal placement locations
- For automatic intersection detection, always select elements first

#### Step 3: Select Joists

**Prompt (with elements):** `"Select intersecting joist(s), <Enter> to pick points"`

**Prompt (without elements):** `"Select joist(s)"`

**Selection Process:**
1. Click on each joist beam where you want to place hanger bolts
2. Only joists with valid information ("Hilti" or "Stexon") are accepted
3. Press Enter when all desired joists are selected

**Automatic Filtering:**
- The script automatically removes joists that:
  - Lack "Hilti" or "Stexon" information (when element-associated)
  - Are not horizontal (perpendicular to World Z)
  - Don't meet geometric requirements

**Visual Feedback:**
- Rejected joists are silently removed from selection
- No error message unless ALL joists are invalid

#### Step 4: Place Instances (Mode-Dependent)

The script behavior now depends on which placement mode was triggered:

---

### Placement Mode 1: Parallel Element and Joist

**When Activated:** Exactly one element AND exactly one joist are selected, AND they are parallel to each other

**Behavior:**

1. **Profile Intersection Calculation:**
   - Script calculates the intersection of the wall frame outline and joist envelope
   - Creates a rectangular snap area based on wall extents
   - Displays the valid placement area visually

2. **Interactive Point Selection:**
   - **Prompt:** `"Select point"`
   - Click anywhere within the highlighted intersection area
   - Points are automatically snapped to the centerline of the joist
   - Script validates each point and creates an instance if valid

3. **Parameter Constraints:**
   - **X-Axis Offset:** Locked to 0 (read-only) - cannot be changed
   - **Y-Axis Offset:** Automatically validated against beam boundaries
   - If offset exceeds limits, script clamps to maximum allowable value

4. **Validation Rules:**
   - Point must fall within intersection profile
   - Minimum 40mm from joist edges (Y-direction)
   - Minimum distance from beam start/end (200mm standard, 0mm for Baufritz)

5. **Exit Condition:**
   - Press Enter or Escape to stop placing instances
   - Each valid click creates a new Stexon instance

**Typical Use Case:**
- Placing multiple stexons along a single joist that runs parallel to a wall
- Evenly spaced stexon placement along joist length
- Controlled spacing for specific load requirements

---

### Placement Mode 2: Element and Intersecting Joists

**When Activated:** One or more elements AND one or more joists are selected, AND joists are perpendicular to elements

**Behavior:**

1. **Automatic Intersection Detection:**
   - For each element, script loops through all selected joists
   - Calculates intersection points where joist crosses element frame
   - Finds the average intersection point if multiple intersections exist

2. **Automatic Placement:**
   - Creates Stexon instance at each valid intersection automatically
   - No manual point clicking required
   - All valid intersections are processed in one operation

3. **Offset Calculation:**
   - For **exterior walls** (Element.exposed() = true):
     - Script attempts to offset 75mm from wall origin (element vecZ direction)
     - Only applies offset if resulting point remains within intersection profile
   - For **interior walls:**
     - Places at geometric center of intersection

4. **Parameter Adjustment:**
   - **X-Axis Offset:** Available for user adjustment after placement
   - **Y-Axis Offset:** Available for user adjustment after placement
   - Both offsets validated against beam boundaries in real-time

5. **Validation Rules:**
   - Intersection profile must have area > 0.01 mm²
   - Only top plates accepted (script checks beam position relative to element)
   - Joist must be horizontal (perpendicular to World Z)
   - Final position must remain within shrunken boundary (40mm edge clearance)

**Typical Use Case:**
- Batch placement of stexons at all joist-to-wall intersections
- Multi-floor projects with repetitive joist layouts
- Quick setup of standard connection patterns

**Example Scenario:**
```
Selected: 5 wall elements, 20 joists
Result: Up to 100 stexon instances created automatically (5 × 20 potential intersections)
Actual instances: Only valid intersections (where joist crosses element frame)
```

---

### Placement Mode 3: Joists with Point Selection

**When Activated:**
- Only joists are selected (no elements), OR
- Elements and joists selected but no valid intersections found, OR
- User pressed Enter at element selection prompt

**Behavior:**

1. **Optional Element-Based Joist Collection:**
   - If elements were selected but no valid joists found, script searches element beams
   - Automatically collects beams with "Hilti" or "Stexon" information
   - Only horizontal beams (perpendicular to World Z) are collected

2. **Interactive Point Selection:**
   - **Prompt:** `"Select point"`
   - Click anywhere on or near the selected joists
   - Script tests each joist's shadow profile to validate click location

3. **Point Validation:**
   - For each click, script loops through all selected joists
   - Tests if click falls within beam's envelope shadow profile
   - Creates instance on FIRST valid joist found
   - Reports error if point doesn't fall within ANY joist profile

4. **Automatic Relocation:**
   - Point is snapped to the top face of the joist (midpoint of depth direction)
   - For **exterior walls:**
     - Script offsets 75mm from wall origin if element is associated
   - For **interior walls or standalone joists:**
     - Places at joist centerline

5. **Offset Application:**
   - After initial placement, Y-offset is applied
   - Script validates offset doesn't exceed beam boundaries
   - Automatically clamps offset to maximum allowable value

6. **Exit Condition:**
   - Press Enter or Escape to stop point selection
   - Each valid click creates one instance

**Error Messages:**
- `"location not valid for any of the selected beams"` - Click outside all joist profiles
- `"can only be placed on top plates"` - Attempted placement on bottom plate

**Typical Use Case:**
- Custom placement on standalone joists
- Non-standard spacing requirements
- Joists not part of wall elements
- Manual override of automatic intersection placement

---

## Properties Panel Parameters

After placement, select any Hilti-Stockschraube instance and adjust parameters via the AutoCAD Properties Palette (OPM).

### Offset Category

All offset parameters are measured from the original insertion point (_Pt0) and are subject to automatic boundary validation.

#### X-Axis Offset

| Property | Value |
|----------|-------|
| **Parameter Name** | `dOffsetX` |
| **Display Name** | "X-Axis Offset" |
| **Type** | PropDouble (floating-point distance) |
| **Default Value** | 0 mm |
| **Unit** | Length (mm or current drawing units) |
| **Range** | Dynamically calculated based on beam geometry |
| **Read-Only** | Yes (in Parallel Mode), No (in other modes) |

**Description:**
- Offset distance along the beam's X-axis (length direction)
- Positive values move toward beam end
- Negative values move toward beam start

**Behavior by Mode:**
- **Parallel Mode:** Locked to 0 (cannot be changed)
- **Intersection Mode:** Adjustable, validated against beam start/end boundaries
- **Point Mode:** Adjustable, validated against beam start/end boundaries

**Automatic Clamping:**
- If user enters value exceeding maximum allowable distance, script displays message:
  - `"X-Axis Offset maximal zulässig: [value]"`
  - Automatically clamps to maximum safe value

**Boundary Calculation:**
- **Standard Projects:** Minimum 200mm from beam start and end
- **Baufritz Projects:** No minimum distance (0mm allowed at beam ends)

**Example:**
```
Beam length: 3000mm
Standard: X-Offset range = -1400mm to +1400mm (200mm edge clearance each side)
Baufritz: X-Offset range = -1500mm to +1500mm (0mm edge clearance)
```

---

#### Y-Axis Offset

| Property | Value |
|----------|-------|
| **Parameter Name** | `dOffsetY` |
| **Display Name** | "Y-Axis Offset" |
| **Type** | PropDouble (floating-point distance) |
| **Default Value** | 0 mm |
| **Unit** | Length (mm or current drawing units) |
| **Range** | Dynamically calculated based on beam width |
| **Read-Only** | No |

**Description:**
- Offset distance perpendicular to the beam's longitudinal axis
- Direction depends on element/beam orientation
- Automatically limited to maintain minimum edge distances

**Behavior by Mode:**
- **All Modes:** Adjustable with automatic boundary validation
- Script continuously validates Y-offset against beam profile boundaries
- Automatic clamping if user exceeds allowable range

**Automatic Clamping:**
- If offset exceeds beam boundaries, script displays message:
  - `"Y-Axis Offset maximal zulässig: [value]"`
  - Automatically clamps to maximum safe value
  - Prevents placement outside beam profile

**Boundary Calculation:**
- **Minimum Edge Clearance:** 40mm from beam edges (perpendicular to length)
- **Maximum Offset:** Beam width / 2 - 40mm
- Script creates shrunken boundary profile for validation

**Example:**
```
Beam width: 140mm
Beam depth: 45mm
Y-Offset range: ±30mm (140/2 - 40mm = 30mm maximum from centerline)
```

**Visual Feedback:**
- When offset is adjusted, instance immediately relocates
- If offset causes edge distance warning (< 25mm), instance turns red

---

### Baufritz-Specific Parameters

These parameters appear ONLY when the project special is set to **"BAUFRITZ"**. They provide additional control over drill specifications for Baufritz-specific manufacturing requirements.

#### Ausführung (Version/Execution Type)

| Property | Value |
|----------|-------|
| **Parameter Name** | `sVersion` |
| **Display Name** | "Ausführung" |
| **Type** | PropString (dropdown selection) |
| **Default Value** | "Holzdolle" (first option) |
| **Options** | "Holzdolle", "Setzschraube" |
| **Visibility** | Baufritz projects only |

**Description:**
- Selects the tool version/execution type with different drill specifications
- Directly affects drill radius and drill depth
- Allows different fastener types within same project

**Option Details:**

##### Option 1: Holzdolle (Wood Dowel)

**Drill Specifications:**
- **Drill Radius:** 15.0 mm (30mm diameter)
- **Drill Depth:** 30 mm
- **Use Case:** Large diameter, shallow hole for wood dowel connections
- **Typical Application:** Special Baufritz connection detail requiring larger hole

**Geometric Impact:**
- Larger radius affects visual display (circle size)
- Shallower depth reduces interference with lower beams
- May require different edge clearances due to larger diameter

##### Option 2: Setzschraube (Set Screw)

**Drill Specifications:**
- **Drill Radius:** 5.0 mm (10mm diameter)
- **Drill Depth:** 70 mm
- **Use Case:** Smaller diameter, medium depth for set screw installation
- **Typical Application:** Alternative fastener for Baufritz connections

**Geometric Impact:**
- Smaller radius than standard Hilti (which uses 4.5mm)
- Half the depth of standard Hilti (which uses 140mm)
- Allows closer spacing due to reduced diameter

##### Standard (Non-Baufritz) Specifications

For comparison, standard Hilti specifications (when Baufritz is NOT active):
- **Drill Radius:** 4.5 mm (9mm diameter)
- **Drill Depth:** 140 mm
- **Hardware:** Hilti HSW M12x220/60 8.8 hanger bolt

**Version Selection Impact:**

| Aspect | Holzdolle | Setzschraube | Standard Hilti |
|--------|-----------|--------------|----------------|
| Drill Diameter | 30mm | 10mm | 9mm |
| Drill Depth | 30mm | 70mm | 140mm |
| Visual Circle | Largest | Medium | Smallest |
| Edge Distance | More critical | Standard | Standard |
| Depth Interference | Minimal | Moderate | Maximum |

**When to Use Each Version:**

**Holzdolle:**
- Special connection details requiring large dowels
- Shallow penetration needed (thin joists or multi-layer assemblies)
- Custom Baufritz connection schedules

**Setzschraube:**
- Alternative to standard Hilti for specific load requirements
- When 70mm depth is sufficient
- Slightly larger diameter needed than standard

**Implementation Note:**
```c
// Code snippet from script (lines 109-119):
if(sVersion=="Setzschraube")
{
    dDepth=U(70);
    dRadius=U(5);
}

if(sVersion=="Holzdolle")
{
    dDepth=U(30);
    dRadius=U(15);
}
```

**Hardware Component Impact:**
- Regardless of version selected, hardware component remains "Hilti HSW M12x220/60"
- Version selection affects geometry only, not BOM entry
- For accurate BOMs, Baufritz projects may need custom hardware mapping

---

## Right-Click Context Menu

Access these commands by right-clicking on any placed Hilti-Stockschraube instance in the drawing.

### Edge Distance Check Toggle

The script provides two complementary context menu commands to control edge distance validation:

#### Command: "Randabstand prüfen" (Check Edge Distance)

**When Available:** After edge distance checking has been disabled

**Function:**
- **Enables** edge distance validation
- Activates red color warning for instances within 25mm of beam edge
- Enforces safety margins for structural integrity

**Effect on Instance:**
- If instance is currently within 25mm of edge, display changes to **Color 1 (Red)**
- Offset parameters become constrained to prevent edge violations
- Automatic clamping enforced during parameter adjustments

**When to Use:**
- After temporarily disabling checks for manual placement
- When returning to standard safety protocols
- Before final drawing verification

#### Command: "Randabstand nicht prüfen" (Don't Check Edge Distance)

**When Available:** When edge distance checking is currently active (default state)

**Function:**
- **Disables** edge distance validation
- Allows manual override of safety margins
- Instance color changes from red to normal (green/magenta) if previously flagged

**Effect on Instance:**
- Red warning color removed (if present)
- Offset parameters can be adjusted beyond normal safety limits
- User assumes responsibility for edge distance adequacy

**Warning:**
- Disabling edge distance checks may result in:
  - Structural weakness near beam edges
  - Splitting during installation
  - Reduced load capacity
  - Fastener pullout

**When to Use:**
- Special engineering approval for close edge placement
- Connection detail requires placement near edge
- Temporary override during design exploration (re-enable before finalization)

**Technical Implementation:**
```c
// Script stores state in instance Map
int bAllow50 = _Map.getInt("Allow50");
// Toggle command flips boolean
bAllow50 = bAllow50 ? false : true;
_Map.setInt("Allow50", bAllow50);
```

**Visual Indicator:**
- **Edge checking ON:** Instances within 25mm of edge display in **Red (Color 1)**
- **Edge checking OFF:** All instances display in normal color (green/magenta based on drill direction)

---

### Hilti Export

#### Command: "Hilti Export"

**Alternative Activation:**
- **Double-click** any Hilti-Stockschraube instance
- Executes same export function as context menu command

**Function:**
- Collects ALL Hilti stexon instances in the current drawing
- Exports production data to DXX file for Hilti manufacturing software integration

**Scope:**
- Searches entire drawing (all model space groups)
- Collects instances of:
  - `Hilti-Stockschraube` (this script)
  - `Hilti-Verankerung` (anchoring script)
- Ignores paper space instances

**Export Data Included:**

1. **Solid Geometry Information:**
   - 3D body geometry of associated beams
   - Element envelope bodies
   - Accurate spatial positioning

2. **Analyzed Tool Information:**
   - Drill center point (3D coordinates)
   - Drill direction vector
   - Drill radius (diameter ÷ 2)
   - Drill depth
   - Associated beam handle/reference

3. **Hardware Data:**
   - Manufacturer: Hilti
   - Article Number: 2316491
   - Model: HSW M12x220/60 8.8
   - Quantity per instance

**Export File Details:**

| Property | Value |
|----------|-------|
| **File Name** | `HiltiExport.dxx` |
| **File Location** | Parent folder of current DWG |
| **File Format** | DXX (hsbCAD model map exchange format) |
| **Overwrite Behavior** | Yes (overwrites existing file) |

**File Path Logic:**
```
Current DWG: C:\Projects\Building_A\Floor_1\Walls.dwg
Export File: C:\Projects\Building_A\Floor_1\HiltiExport.dxx

Current DWG: C:\Users\john\Desktop\test.dwg
Export File: C:\Users\john\Desktop\HiltiExport.dxx
```

**Export Process:**

1. **Collection Phase:**
   - Script collects all groups in model space
   - Filters for TslInst entities
   - Checks script name against allowed names (case-insensitive)
   - Builds array of valid Hilti stexon instances

2. **Composition Phase:**
   - Creates ModelMap object
   - Sets composition flags:
     - `addSolidInfo(TRUE)` - includes 3D geometry
     - `addAnalysedToolInfo(TRUE)` - includes drill tool data
   - Composes complete model map from collected instances

3. **Write Phase:**
   - Determines parent folder path
   - Writes ModelMap to `HiltiExport.dxx`
   - Reports success (in debug mode)

**Debug Message (when enabled):**
```
Hilti-Stockschraube [count] exported to [full_path]\HiltiExport.dxx
```

**Downstream Usage:**
- Import DXX file into Hilti software (e.g., Profis Engineering, HIT-Planning)
- Use for CNC drilling machine programming
- Generate fastener purchase orders with exact quantities
- Quality control verification (compare designed vs. installed positions)

**Execution Behavior:**
- Export triggers script recalculation (setExecutionLoops(2))
- Ensures all instances update before export
- Returns control to user after export completes

**Error Handling:**
- No error message if export fails (silent failure)
- Check parent folder write permissions if export doesn't complete
- Ensure parent folder exists (script doesn't create folders)

---

## Visual Indicators & Display

The script uses intelligent color coding to communicate instance status and orientation at a glance.

### Color Scheme

#### Color 3 (Green) - Normal Upward Orientation

**When Displayed:**
- Drill direction points **upward** (positive Z direction)
- Instance is NOT within 25mm of beam edge
- Edge distance checking is enabled OR disabled but edge distance is acceptable

**Meaning:**
- Safe placement
- Drill will penetrate from bottom of joist upward
- Typical for joists sitting on top plates
- No geometric warnings

**Visual Appearance:**
- Filled circle in **green/cyan** color
- Circle radius matches drill radius
- Clean, unobstructed appearance

#### Color 6 (Magenta) - Normal Downward Orientation

**When Displayed:**
- Drill direction points **downward** (negative Z direction)
- Instance is NOT within 25mm of beam edge
- Edge distance checking is enabled OR disabled but edge distance is acceptable

**Meaning:**
- Safe placement
- Drill will penetrate from top of joist downward
- Less common orientation (special connection details)
- No geometric warnings

**Visual Appearance:**
- Filled circle in **magenta/purple** color
- Circle radius matches drill radius
- Clean, unobstructed appearance

**Drill Direction Logic:**
```c
// Color selection (line 682)
Display dp(vecFree.dotProduct(_ZW)>0?3:6);
// Color 3 if drill direction has positive Z component
// Color 6 if drill direction has negative Z component
```

#### Color 1 (Red) - Edge Distance Warning

**When Displayed:**
- Instance placement is within **25mm** of beam edge
- Edge distance checking is **enabled**
- Overrides normal green/magenta color

**Meaning:**
- **Warning:** Placement may compromise structural integrity
- Risk of wood splitting during installation
- Reduced fastener pull-out capacity
- Requires review by engineer or manual override

**Visual Appearance:**
- Filled circle in **bright red** color
- Circle radius matches drill radius
- High visibility warning state

**How to Resolve:**

**Option 1: Adjust Offset Parameters**
- Select instance
- Modify **Y-Axis Offset** to move away from edge
- Instance returns to green/magenta when edge distance exceeds 25mm

**Option 2: Disable Edge Checking (Manual Override)**
- Right-click instance
- Select "Randabstand nicht prüfen"
- Instance changes to normal color (green/magenta)
- User assumes responsibility for edge distance adequacy

**Edge Distance Calculation:**
```c
// Script tests distance to profile edge segments (lines 576-589)
LineSeg segs[] = ppX.splitSegments(LineSeg(_Pt0 - vecZ * U(10e3), _Pt0 + vecZ* U(10e3)), true);
for (int i=0;i<segs.length();i++)
{
    if (abs(vecZ.dotProduct(_Pt0-segs[i].ptStart()))<U(25)) bIs50 = true;
    else if (abs(vecZ.dotProduct(_Pt0-segs[i].ptEnd()))<U(25)) bIs50 = true;
}
```

**Structural Significance:**
- 25mm threshold based on general fastener edge distance requirements
- Actual minimum may vary by:
  - Wood species (density, grain orientation)
  - Fastener diameter (larger holes need more edge distance)
  - Load conditions (tension vs. compression)
  - Code requirements (check local building codes)

---

### Geometric Display Elements

#### Drill Location Circle

**Appearance:**
- **Shape:** Filled circle (solid color, no outline)
- **Radius:** Equal to drill radius (4.5mm standard, varies by version)
- **Opacity:** 60% transparency (allows underlaying beams to show through)
- **Location:** Exact drill center point in 3D space

**Purpose:**
- Visual representation of drill hole size
- Quick verification of drill positioning
- Comparison of spacing between multiple stexons

**Display Code:**
```c
PLine pl(vecFree);
pl.createCircle(_Pt0, vecFree, dRadius);
dp.draw(PlaneProfile(pl), _kDrawFilled, 60);
```

**Size Variations by Configuration:**

| Configuration | Drill Radius | Visual Circle Diameter |
|---------------|--------------|------------------------|
| Standard Hilti | 4.5mm | 9mm |
| Baufritz Setzschraube | 5.0mm | 10mm |
| Baufritz Holzdolle | 15.0mm | 30mm |

#### Drill Direction Vector (Debug Mode)

**Appearance:**
- **Shape:** 3D arrow/vector
- **Color:** Typically color 1 (red)
- **Start Point:** Drill center (_Pt0)
- **Direction:** Points along drill axis (vecFree)
- **Length:** Short vector for visualization

**When Visible:**
- Only when debug mode is active
- Not visible in normal operation

**Purpose:**
- Verify drill direction during development/troubleshooting
- Confirm vecFree calculation correctness

**Display Code:**
```c
vecFree.vis(_Pt0,1);  // Line 709 - Debug visualization
```

---

### Profile Visualization (During Placement)

During interactive placement, the script temporarily displays geometric profiles to guide user input.

#### Intersection Profile (Blue - Color 2)

**When Displayed:**
- During Parallel Mode point selection
- During Intersection Mode automatic placement (brief flash)

**Appearance:**
- Shadow profile of beam-element intersection
- Color 2 (typically yellow or blue depending on CAD settings)
- Filled or outlined based on display settings

**Purpose:**
- Shows valid placement area
- Guides user clicks to acceptable locations
- Visual feedback for intersection calculation

**Display Code:**
```c
ppX.vis(2);  // Line 445 - Intersection profile visualization
```

#### Shrunken Boundary Profile

**When Displayed:**
- During all placement modes (briefly)
- Shows valid placement area accounting for edge clearances

**Appearance:**
- Smaller profile than actual beam envelope
- Accounts for 40mm edge clearance (perpendicular to length)
- Accounts for 200mm or 0mm end clearance (along length)

**Colors Used:**
- Color 1 (red) - Outer boundary
- Color 4 (cyan) - Inner (shrunken) boundary

**Purpose:**
- Validates user-specified offsets
- Prevents placement too close to edges
- Visual confirmation of safety margins

**Display Code:**
```c
ppStexon.vis(2);       // Line 635 - Original profile
ppStexonShrink.vis(4); // Line 636 - Shrunken boundary
```

---

## Hardware Component Integration

Every Hilti-Stockschraube instance automatically generates a hardware component entry in the project Bill of Materials (BOM). This ensures accurate quantity takeoffs and purchasing.

### Automatic Hardware Component

When a Stexon instance is created or updated, the script automatically generates:

#### Component Specifications

| Property | Value | Notes |
|----------|-------|-------|
| **Manufacturer** | Hilti | Fixed value, cannot be changed |
| **Article Number** | 2316491 | Hilti product SKU |
| **Model** | Hanger bolt HSW M12x220/60 8.8 | Full product designation |
| **Category** | Connector | BOM categorization |
| **Description** | Galvanized hanger bolt for anchoring wood structures to wood using pre-installed HCW connectors | Full product description |
| **Quantity** | 1 | Per instance |
| **Rep Type** | _kRTTsl | TSL-generated (distinguishes from manual entries) |

#### Component Details Breakdown

**Article Number: 2316491**
- Hilti internal product code
- Use for direct ordering from Hilti
- Cross-reference with Hilti catalog for pricing

**Model: HSW M12x220/60 8.8**
- **HSW** = Hanger bolt Stexon Wood
- **M12** = Thread diameter 12mm (metric coarse thread)
- **220** = Total length 220mm
- **60** = Thread length 60mm
- **8.8** = Steel grade (8.8 tensile strength class per ISO 898-1)

**Material: Galvanized**
- Zinc-plated carbon steel
- Corrosion protection for interior applications
- For exterior applications, verify with Hilti for appropriate coating

**Compatible Connector: HCW**
- Hilti Concealed Wood connector system
- Pre-installed in joist before placement
- Stexon threads into HCW connector body

### BOM Integration

#### Element Group Assignment

**When Instance is Associated with Element:**
- Component assigned to element's ElementGroup
- Rolls up into element-level BOM
- Appears in wall schedule with wall quantities

**Code Implementation:**
```c
Element elHW =el.element();
if (elHW.bIsValid()) sHWGroupName=elHW.elementGroup().name();
```

#### Loose Group Assignment

**When Instance is NOT Associated with Element:**
- Component assigned to first group containing the instance
- Appears in general hardware schedule
- Can be manually reassigned to different group

**Code Implementation:**
```c
Group groups[] = _ThisInst.groups();
if (groups.length()>0) sHWGroupName=groups[0].name();
```

### Linked Entity

**Element Association:**
- If instance placed via element selection, component linked to element
- Enables filtering BOM by element
- Deleting element also removes associated hardware

**Code Implementation:**
```c
hwc.setLinkedEntity(el);
```

### Component Lifecycle

#### Creation

**When Created:**
- Every time script executes (including on recalc)
- During initial insertion
- When instance parameters change
- On drawing open/regen

**Creation Process:**
1. Script collects existing hardware components: `_ThisInst.hardWrComps()`
2. Removes any TSL-generated components (RepType = _kRTTsl)
3. Creates new component with current specifications
4. Appends to component array
5. Updates instance: `_ThisInst.setHardWrComps(hwcs)`

**Why Delete and Recreate:**
- Ensures component always matches current parameters
- Prevents duplicate entries
- Allows version changes to update BOM automatically (for Baufritz)

#### Update Trigger

**Automatic Update:**
```c
if (_bOnDbCreated) setExecutionLoops(2);
```
- Script executes twice on first creation
- First pass: creates geometry
- Second pass: finalizes hardware component
- Ensures BOM is synchronized immediately

#### Component Removal

**When Removed:**
- Instance deleted from drawing
- Instance erased during validation failure
- Manual removal via hardware component editor

**Automatic Cleanup:**
- Script removes old TSL-generated components before creating new ones
- Prevents orphaned BOM entries
- Maintains BOM accuracy

### BOM Report Integration

**How to Extract Hardware Data:**

1. **hsbCAD BOM Report:**
   - Use `HSB_G-BillOfMaterial` script
   - Select elements or entire project
   - Hardware components automatically included
   - Group by manufacturer, article number, or element

2. **Export to Excel:**
   - BOM data can be exported to Excel
   - Filter/sort by manufacturer "Hilti"
   - Sum quantities across all elements
   - Generate purchase orders

3. **Custom Reports:**
   - Access via `HardWrComp` API
   - Query by category "Connector"
   - Filter by article number for specific fasteners

### BOM Accuracy Considerations

**Quantity = 1 per Instance:**
- Each Stexon instance represents ONE physical hanger bolt
- Total project quantity = count of Hilti-Stockschraube instances
- No automatic multipliers or adjustments

**Baufritz Version Caveat:**
- Regardless of "Ausführung" selection (Holzdolle, Setzschraube), BOM entry remains "HSW M12x220/60"
- For accurate Baufritz BOMs, manual adjustment may be needed:
  - Either: Change article number in hardware component editor
  - Or: Use custom BOM script to map version to different article numbers

**Coordination with HCW Connectors:**
- Each Hilti-Stockschraube requires one pre-installed HCW connector
- HCW connectors NOT automatically added to BOM by this script
- Use separate script or manual BOM entry for HCW connectors
- Ensure HCW quantity = Stexon quantity

---

## Placement Modes - Detailed Analysis

This section provides in-depth technical analysis of each placement mode's geometric calculations and validation logic.

### Mode 1: Parallel Element and Joist (Detailed)

#### Activation Logic

```c
int bIsParallel = _Element.length() == 1 && joists.length() == 1 &&
                  _Element[0].vecX().isParallelTo(joists[0].vecX());
```

**Precise Conditions:**
1. Exactly **one** element selected (not zero, not two or more)
2. Exactly **one** joist selected (not zero, not two or more)
3. Element's X-axis **parallel** to joist's X-axis (within tolerance defined by `.isParallelTo()`)

**Parallelism Test:**
- Uses TSL built-in `Vector3d.isParallelTo()` method
- Typically considers vectors parallel if angle < 1° (tolerance may vary by hsbCAD version)
- Includes both same direction and opposite direction (180° is also parallel)

#### Geometric Calculation Process

**Step 1: Extract Element Geometry**
```c
Point3d ptOrg = el.ptOrg();      // Element origin
Vector3d vecX = el.vecX();       // Length direction
Vector3d vecY = el.vecY();       // Height direction (upward)
Vector3d vecZ = el.vecZ();       // Thickness direction
LineSeg seg = el.segmentMinMax(); // Element extents
```

**Step 2: Calculate Element Extents**
```c
double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
```
- `dX` = Element length along wall
- `dY` = Element height (not used directly, derived from beam width)

**Step 3: Build Frame Outline**
```c
PLine pl;
pl.createRectangle(LineSeg(ptOrg, ptOrg+vecX*dX-vecZ*el.dBeamWidth()), vecX, - vecZ);
```
- Creates rectangular polyline representing wall frame
- Start corner: `ptOrg`
- End corner: `ptOrg + vecX*dX - vecZ*el.dBeamWidth()`
- Rectangle oriented in vecX and -vecZ directions
- Represents wall footprint projected on horizontal plane

**Step 4: Create Intersection Profile**
```c
PlaneProfile pp(pl);
Beam& bm= joists[0];
pp.intersectWith(bm.envelopeBody().shadowProfile(Plane(_PtW, _ZW)));
```
- Converts frame outline to `PlaneProfile`
- Projects joist envelope onto horizontal plane (shadow profile)
- Intersects wall frame with joist shadow
- Result: area where joist overlaps wall frame

**Step 5: Validate Intersection**
```c
if (pp.area()>pow(dEps,2))
```
- Checks if intersection area > 0.01 mm² (essentially > 0)
- If no intersection, mode fails silently
- User never prompted for points if no valid intersection

#### Interactive Point Selection Loop

```c
while(1)
{
    PrPoint ssP(TN("|Select point|"));
    if (ssP.go()==_kOk)
    {
        Point3d pt = ssP.value();
        // Validation and instance creation
    }
    else
        break;  // User pressed Enter or Escape
}
```

**Point Validation:**
```c
if (pp.pointInProfile(pt)==_kPointInProfile)
{
    ptsTsl[0]=pt;
    tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl,
                    nProps, dProps, sProps,_kModelSpace, mapTsl);
    bOk = tslNew.bIsValid();
}
```

**Validation Result Messages:**
- **Success:** New instance created silently
- **Failure:** `"location invalid"` displayed in command line

#### Parameter Constraints

**X-Offset Locking:**
```c
dOffsetX.setReadOnly(true);
dOffsetX.set(0);
```
- Once mode detected, X-offset property becomes read-only
- Value forced to 0 and locked
- User cannot change X-offset even if they try
- Prevents movement along joist length (only perpendicular movement allowed)

**Y-Offset Validation:**
```c
PlaneProfile ppStexonShrink(ppStexon.coordSys());
{
    LineSeg segStexon = ppStexon.extentInDir(bmStexon.vecX());
    double dX = abs(bmStexon.vecX().dotProduct(segStexon.ptStart()-segStexon.ptEnd()));
    double dY = abs(bmStexon.vecY().dotProduct(segStexon.ptStart()-segStexon.ptEnd()));
    PLine plShrink;
    plShrink.createRectangle(LineSeg(segStexon.ptMid()-bmStexon.vecX()*
    (.5*dX-dDistanceEdge)-bmStexon.vecY()*(.5*dY-U(40)),segStexon.ptMid()+bmStexon.vecX()*
    (.5*dX-dDistanceEdge)+bmStexon.vecY()*(.5*dY-U(40))),bmStexon.vecX(),bmStexon.vecY());
    ppStexonShrink.joinRing(plShrink, _kAdd);
}
```

**Shrink Calculation Breakdown:**
- `dX` = Joist length
- `dY` = Joist width (perpendicular to length)
- Shrink X by: `dDistanceEdge` on each side (200mm standard, 0mm Baufritz)
- Shrink Y by: 40mm on each side

**Safe Rectangle:**
```
Original joist profile: dX × dY
Shrunken profile: (dX - 2*dDistanceEdge) × (dY - 80mm)
```

**Automatic Clamping:**
```c
Point3d ptTest = _Pt0 + vecZ * dOffsetY;
if (ppStexon.pointInProfile(ptTest)==_kPointOutsideProfile)
{
    ptTest = ppStexon.closestPointTo(ptTest);
    double dOffsetYNew = vecZ.dotProduct(ptTest-_Pt0);
    reportMessage("\n" + scriptName() + " " + sOffsetYName + " maximal zulässig: " + dOffsetYNew);
    dOffsetY.set(dOffsetYNew);
}
_Pt0 = ptTest;
```

**Clamping Process:**
1. Calculate desired position: `_Pt0 + vecZ * dOffsetY`
2. Test if inside shrunken profile
3. If outside, project to closest point on profile boundary
4. Calculate new maximum offset
5. Display message with maximum allowable value
6. Force parameter to maximum safe value
7. Update _Pt0 to clamped position

**Why X-Offset is Locked:**
- In parallel mode, joist runs along wall length
- User already specifies exact X-position by clicking on snap line
- Allowing X-offset would create ambiguity (click location vs. offset parameter)
- Locking X-offset ensures click position is authoritative

**Why Y-Offset is Adjustable:**
- Allows fine-tuning perpendicular to joist axis
- Useful for offsetting from wall centerline
- Accommodates asymmetric wall construction (e.g., studs not centered)

#### Snap Line Visualization (Conceptual)

Although not explicitly drawn, the script creates an internal snap line:
```c
segX.transformBy(vecZ*0);  // Project to horizontal plane
double dX = abs(vecX.dotProduct(segX.ptStart()-segX.ptEnd()))-2*dRadius;
PLine plSnap(segX.ptMid() - vecX * .5 * dX, segX.ptMid() + vecX * .5 * dX);
_Pt0 = plSnap.closestPointTo(_Pt0);
```

**Snap Line Properties:**
- **Start:** Center of intersection - ½(length - 2*radius)
- **End:** Center of intersection + ½(length - 2*radius)
- **Direction:** Along vecX (wall length)
- **Effect:** User clicks snap to this line automatically

**Why Subtract 2*radius:**
- Prevents drill circle from extending beyond intersection boundaries
- Ensures full drill diameter remains within valid area
- Accounts for circle rendering (radius extends from center)

---

### Mode 2: Element and Intersecting Joists (Detailed)

#### Activation Logic

```c
else if (bHasElements && joists.length()>0)
```

**Conditions:**
1. One or more elements selected (`_Element.length() > 0`)
2. One or more joists selected (`joists.length() > 0`)
3. NOT parallel mode (different from Mode 1)
4. Joists filtered to contain only those with "Hilti" or "Stexon" info

**Mode Purpose:**
- Batch processing of multiple intersections
- Automatic placement without manual point clicking
- Efficient for repetitive layouts (multiple joists crossing same wall)

#### Nested Loop Structure

```c
for (int e=0;e<_Element.length();e++)  // Outer loop: elements
{
    Element& el= _Element[e];
    // Extract element geometry...

    for (int i=0;i<joists.length();i++)  // Inner loop: joists
    {
        Beam& bm= joists[i];
        // Test intersection and create instance if valid
    }
}
```

**Iteration Logic:**
- Script tests **every possible combination** of elements and joists
- Maximum instances = elements.length() × joists.length()
- Actual instances = only valid geometric intersections
- Invalid combinations silently skipped (no error messages)

#### Geometric Intersection Calculation

**Step 1: Element Frame Outline (Same as Mode 1)**
```c
PLine pl;
pl.createRectangle(LineSeg(ptOrg, ptOrg+vecX*dX-vecZ*el.dBeamWidth()), vecX, - vecZ);
```

**Step 2: Joist Orientation Filter**
```c
Vector3d vecXB = bm.vecX();
if (!vecXB.isPerpendicularTo(_ZW))continue;  // Skip non-horizontal joists
```
- Only horizontal joists accepted (perpendicular to World Z)
- Sloped or vertical joists automatically rejected
- No error message for skipped joists

**Step 3: Joist Coordinate System**
```c
Vector3d vecZB = bm.vecD(vecY);        // Joist depth direction aligned with element Y
Vector3d vecYB = vecXB.crossProduct(-vecZB);  // Joist width direction
```
- `vecXB` = Joist length direction (already known)
- `vecZB` = Joist depth, oriented toward element Y direction
- `vecYB` = Joist width, perpendicular to both X and Z

**Step 4: Intersection Point Calculation**
```c
Point3d pts[] = pl.intersectPoints(Plane(bm.ptCen(), vecYB));
```
- Creates vertical plane through joist center, perpendicular to joist width
- Intersects wall frame outline with this plane
- Result: array of 0, 1, or 2 points where joist crosses wall

**Intersection Cases:**
- **0 points:** Joist doesn't cross wall (parallel or non-intersecting)
- **1 point:** Joist touches wall at edge (tangent)
- **2 points:** Joist crosses wall (typical case)

**Step 5: Average Intersection Point**
```c
if (pts.length()>1)
{
    Point3d pt;
    pt.setToAverage(pts);  // Geometric center of intersection points
    ptsTsl[0]=pt;
}
```
- Takes average of all intersection points
- For 2 points (typical), this is the midpoint
- Represents centerline of joist where it crosses wall frame

**Step 6: Instance Creation**
```c
gbsTsl.setLength(0);
gbsTsl.append(bm);      // Associate with joist

entsTsl.setLength(0);
entsTsl.append(el);     // Associate with element

tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl,
                nProps, dProps, sProps,_kModelSpace, mapTsl);
```

**No Validation:**
- Unlike Mode 1, no additional validation performed
- Assumption: if intersection points exist, placement is valid
- Detailed validation happens during instance recalculation

#### Automatic Offset for Exterior Walls

After initial placement, script attempts to optimize position for exterior walls:

```c
if (el.exposed())  // Element is exterior wall
{
    Point3d _pt = pt;
    _pt += vecZ * (vecZ.dotProduct(ptOrg - _pt) - U(75));  // Offset 75mm from wall origin
    if (ppX.pointInProfile(_pt)==_kPointInProfile)
        pt = _pt;
}
```

**Offset Calculation:**
1. Start with intersection center point `pt`
2. Calculate distance from point to wall origin along vecZ direction: `vecZ.dotProduct(ptOrg - _pt)`
3. Subtract 75mm: `- U(75)`
4. Move point along vecZ by this adjusted distance
5. Test if new point still within intersection profile
6. If valid, use new point; if invalid, keep original center point

**Purpose of 75mm Offset:**
- Standard offset for exterior walls (may represent sheathing thickness + gap)
- Moves stexon toward exterior face of wall
- Accounts for typical wall assembly layers
- Only applied if resulting position remains valid

**Why Only Exterior Walls:**
- Interior walls typically symmetric (stexon at center is optimal)
- Exterior walls have sheathing, vapor barrier, etc. on one side
- Offset ensures stexon doesn't interfere with exterior layers

#### Perpendicularity Requirement

**Why Joists Must Be Horizontal:**
```c
if (!vecXB.isPerpendicularTo(_ZW))continue;
```
- Stexon designed for vertical drilling into horizontal joists
- Sloped joists would create angled drill holes
- Hilti HSW hanger bolt designed for vertical load transfer
- Angled installations reduce load capacity and complicate installation

---

### Mode 3: Joists with Point Selection (Detailed)

#### Activation Logic

```c
else if(bHasElements || joists.length()>0)
```

**Conditions:**
- **Either:** Elements selected but no joists yet
- **Or:** Joists selected (with or without elements)
- **Not:** Parallel mode (Mode 1)
- **Not:** Valid intersection mode (Mode 2)

**This is the "catch-all" mode for:**
- Manual point placement on selected joists
- Custom layouts that don't fit automatic intersection patterns
- Standalone joists not part of wall elements

#### Optional Element-Based Joist Collection

If elements were selected but joist selection is empty, script attempts to collect joists from elements:

```c
if (bHasElements)
{
    for (int e=0;e<_Element.length();e++)
    {
        Element& el= _Element[e];
        Beam beams[] = el.beam();
        for (int i=0;i<beams.length();i++)
        {
            Beam& bm= beams[i];
            Vector3d vecXB = bm.vecX();
            if (!vecXB.isPerpendicularTo(_ZW))continue;  // Must be horizontal

            if (bm.information().find("Hilti",0, false)>-1)
                joists.append(bm);
            else if(nBaufritz && bm.information().find("Stexon",0, false)>-1)
                joists.append(bm);
        }
    }
}
```

**Collection Process:**
1. Loop through all selected elements
2. Get all beams in each element: `el.beam()`
3. Filter for horizontal beams: `vecXB.isPerpendicularTo(_ZW)`
4. Filter for beams with "Hilti" information
5. For Baufritz: also accept beams with "Stexon" information
6. Append to joists array

**Debug Message:**
```c
reportMessage("\n"+ scriptName() + " mode 2 has found " + joists.length() + " in " + _Element.length());
```
- Only displayed if debug mode active
- Shows how many joists were collected from elements

#### Interactive Point Selection Loop

```c
while(1)
{
    PrPoint ssP(TN("|Select point|"));
    if (ssP.go()==_kOk && joists.length()>0)
    {
        Point3d pt = ssP.value();
        // Validate against all joists and create instance if valid
    }
    else
        break;
}
```

**Loop Mechanics:**
- Infinite loop: `while(1)`
- Continues until user presses Enter or Escape
- Each valid click creates one instance
- Invalid clicks generate error message but loop continues

#### Point Validation Logic

For each clicked point, script loops through ALL selected joists to find first valid match:

```c
int bOk;
for (int i=0;i<joists.length();i++)
{
    Beam& bm= joists[i];
    PlaneProfile pp = bm.envelopeBody().shadowProfile(Plane(_PtW, _ZW));
    if (pp.pointInProfile(pt)==_kPointInProfile)
    {
        ptsTsl[0]=pt;
        gbsTsl.setLength(0);
        gbsTsl.append(bm);
        tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl,
                        nProps, dProps, sProps,_kModelSpace, mapTsl);
        bOk = tslNew.bIsValid();
    }
}
```

**Validation Process:**
1. **Shadow Profile Creation:** Project joist envelope onto horizontal plane
2. **Point-in-Profile Test:** Check if clicked point falls within shadow profile
3. **Instance Creation:** If valid, create instance associated with joist
4. **First Match Wins:** Script stops checking remaining joists after first valid match
5. **Success Flag:** Set `bOk = true` if instance created

**Error Message:**
```c
if (!bOk)
    reportMessage("\n" + scriptName() + ": " +T("|location not valid for any of the selected beams|"));
```
- Only displayed if point doesn't fall within ANY joist profile
- User can immediately click again (loop continues)

#### Automatic Point Relocation

After initial validation, script relocates point to joist top face:

**For Standalone Joists (No Element Association):**
```c
_Pt0=Line(bm.ptCenSolid()+vecFree*.5*bm.dD(vecFree),bm.vecX()).closestPointTo(_Pt0);
```

**Relocation Logic:**
1. Create line along joist top face:
   - Start: `bm.ptCenSolid() + vecFree*.5*bm.dD(vecFree)` (top face center)
   - Direction: `bm.vecX()` (along joist length)
2. Find closest point on this line to user's click: `closestPointTo(_Pt0)`
3. Update _Pt0 to this projected point

**Effect:**
- Even if user clicks slightly off-center, instance snaps to joist top face centerline
- Ensures consistent placement along joist length

**For Element-Associated Joists with Exterior Walls:**
```c
if (el.bIsValid() && el.exposed())
{
    Vector3d vecY=el.vecY();
    Vector3d vecZ=el.vecZ();
    Point3d ptOrg=el.ptOrg();

    LineSeg seg=el.segmentMinMax();
    vecFree=vecY;
    if (vecY.dotProduct(seg.ptMid()-bm.ptCenSolid())>0)
        vecFree *= -1;

    _Pt0=Line(bm.ptCenSolid()+vecFree*.5*bm.dD(vecFree),bm.vecX()).closestPointTo(_Pt0);
    _Pt0+=vecZ*(vecZ.dotProduct(ptOrg-_Pt0)-U(75));
}
```

**Additional Processing:**
1. Determine if joist is top plate or bottom plate (vecFree calculation)
2. Snap to joist top face (same as standalone case)
3. Apply 75mm offset from wall origin along vecZ direction
4. Final position accounts for both joist location and wall offset

#### Y-Offset Validation with Shrunken Boundary

After relocation, Y-offset is applied and validated:

```c
Vector3d vecSide=el.vecZ();
PlaneProfile ppStexon=bmStexon.envelopeBody().shadowProfile(Plane(_Pt0,_ZW));

PlaneProfile ppStexonShrink(ppStexon.coordSys());
{
    LineSeg segStexon=ppStexon.extentInDir(bmStexon.vecX());
    double dX=abs(bmStexon.vecX().dotProduct(segStexon.ptStart()-segStexon.ptEnd()));
    double dY=abs(bmStexon.vecY().dotProduct(segStexon.ptStart()-segStexon.ptEnd()));
    PLine plShrink;
    plShrink.createRectangle(LineSeg(segStexon.ptMid()-bmStexon.vecX()*
    (.5*dX-dDistanceEdge)-bmStexon.vecY()*(.5*dY-U(40)),segStexon.ptMid()+bmStexon.vecX()*
    (.5*dX-dDistanceEdge)+bmStexon.vecY()*(.5*dY-U(40))),bmStexon.vecX(),bmStexon.vecY());
    ppStexonShrink.joinRing(plShrink, _kAdd);
}
ppStexon=ppStexonShrink;

Point3d ptTest=_Pt0+vecSide*dOffsetY;
if (ppStexon.pointInProfile(ptTest)==_kPointOutsideProfile)
{
    ptTest=ppStexon.closestPointTo(ptTest);
    double dOffsetYNew=vecSide.dotProduct(ptTest-_Pt0);
    reportMessage("\n" + scriptName() + " " + sOffsetYName + " maximal zulässig: " + dOffsetYNew);
    dOffsetY.set(dOffsetYNew);
}
_Pt0 = ptTest;
```

**Validation Process:**
1. Create shadow profile of joist on horizontal plane
2. Calculate joist extents (length dX, width dY)
3. Create shrunken rectangle:
   - X-direction: shrink by dDistanceEdge on each side (200mm or 0mm)
   - Y-direction: shrink by 40mm on each side
4. Test if `_Pt0 + vecSide*dOffsetY` falls within shrunken profile
5. If outside, project to closest point on boundary
6. Calculate maximum allowable offset
7. Display message and clamp offset parameter
8. Update _Pt0 to clamped position

**Profile Visualization (Debug):**
```c
ppStexon.vis(2);       // Original joist profile (color 2)
ppStexonShrink.vis(4); // Shrunken boundary (color 4)
```
- Temporarily displays profiles during placement
- Helps troubleshoot validation issues

---

## Post-Placement Behavior & Recalculation

After initial insertion, each Hilti-Stockschraube instance remains "intelligent" - it recalculates geometry when parameters change or when referenced beams/elements move.

### Instance References

Every instance maintains references to associated entities:

**Beam Reference:**
```c
Beam bm;
if (_Beam.length()>0)
    bm = _Beam[0];
```
- `_Beam[0]` = Primary joist where stexon is placed
- Automatically updated if joist moves or is modified
- Instance becomes invalid if beam is deleted

**Element Reference:**
```c
ElementWallSF el;
if (_Element.length()>0)
    el = (ElementWallSF)_Element[0];
```
- `_Element[0]` = Wall element containing top plate
- Used for coordinate system and group assignment
- Optional (instance can exist without element)

**Reference Validation:**
```c
if ((!bm.bIsValid() && !el.bIsValid()) || !bm.vecX().isPerpendicularTo(_ZW))
{
    reportMessage(TN("|Invalid references|"));
    eraseInstance();
    return;
}
```
- At least one reference (beam OR element) must be valid
- Beam (if present) must remain horizontal
- Invalid references cause instance self-deletion

### Mode Detection on Recalculation

Each time script executes (parameter change, beam move, drawing regen), it re-detects which mode to use:

**Wall Intersect Mode:**
```c
if (el.bIsValid() && bm.bIsValid())
```
- Element AND beam both valid
- Most common during interactive use
- Uses most complex geometry calculations

**Joist + Location Mode:**
```c
else if (bm.bIsValid())
```
- Only beam valid (no element)
- Standalone joist placement
- Simpler geometry

**Error Mode:**
```c
else
{
    reportMessage("\n" + scriptName() + ": " +T("|unexpeced error|"));
    eraseInstance();
    return;
}
```
- Neither beam nor element valid
- Should never occur (caught by earlier validation)
- Defensive error handling

### Drill Direction Calculation

**vecFree** is the drill direction vector (always points toward top of joist):

**Wall Intersect Mode:**
```c
vecFree = vecY;  // Element Y-direction (upward)
if (vecY.dotProduct(seg.ptMid()-ptCen)>0)
{
    // Joist center is BELOW element midline - error condition
    reportMessage("\n" + scriptName() + ": " +T("|can only be placed on top plates.|"));
    eraseInstance();
    return;
}
```

**Validation Logic:**
- If joist center is above element midline: vecFree = +vecY (upward) ✓
- If joist center is below element midline: Error - must be bottom plate ✗

**Why Only Top Plates:**
- Stexon connects joist to wall from below
- Drill penetrates upward through joist into top plate
- Bottom plate connections would require different fastener type

**Joist + Location Mode:**
```c
if (el.bIsValid() && el.exposed())
{
    LineSeg seg=el.segmentMinMax();
    vecFree=vecY;
    if (vecY.dotProduct(seg.ptMid()-bm.ptCenSolid())>0)
        vecFree *= -1;
}
```
- Determines whether joist is top plate or bottom plate
- Sets vecFree to point from joist toward plate
- Flips direction if joist is below element midline

### Coordinate System Update

After vecFree is determined:
```c
_ZU = vecFree;
_YU = _XU.crossProduct(-_ZU);
```
- Updates instance coordinate system
- _ZU (instance Z) now points along drill direction
- _YU (instance Y) perpendicular to both _XU and _ZU
- Maintains right-handed coordinate system

**Purpose:**
- Orients instance display geometry
- Aligns drill visualization with actual drill direction
- Ensures proper 3D representation

### Parameter Change Handling

When user changes offset parameters via Properties Palette:

**Offset Application:**
```c
_Pt0 = ptTest;  // Base position from geometric calculation
```
- Script recalculates base position (_Pt0) from referenced geometry
- Then applies offsets to final position
- Display and drill update automatically

**Boundary Validation:**
- Every parameter change triggers full recalculation
- Offset values validated against current beam geometry
- Automatic clamping if offsets exceed safe boundaries
- User sees updated position immediately in drawing

### Element Group Assignment

**When Element is Valid:**
```c
if (el.bIsValid())
{
    assignToElementGroup(el, true, 0, 'E');
    dp.elemZone(el, 0, 'T');
}
```
- Instance assigned to element's ElementGroup
- `true` parameter: create group if doesn't exist
- `0`: subgroup index (main element group)
- `'E'`: element type flag
- Display zone set to element, zone 0, type 'T' (tool)

**When Only Beam is Valid:**
```c
else if (bmStexon.bIsValid())
    assignToGroups(bmStexon);
```
- Instance assigned to same groups as beam
- Inherits beam's group memberships
- Allows filtering/selection by beam groups

**Group Assignment Impact:**
- Controls BOM aggregation
- Enables selection by element/group
- Affects hardware component grouping
- Determines drawing organization

---

## Drill Operation Details

Each Hilti-Stockschraube instance creates a drill tool operation that modifies the associated joist beam.

### Drill Creation

```c
if (bmStexon.bIsValid())
{
    Drill drill(_Pt0, _Pt0 - vecFree *dDepth, dRadius);
    bmStexon.addTool(drill);
}
```

### Drill Parameters

**Start Point:** `_Pt0`
- Exact center point of drill hole
- Calculated from geometric intersection + offsets
- Updated when parameters change

**End Point:** `_Pt0 - vecFree * dDepth`
- vecFree points upward (toward top of joist)
- Drill direction is OPPOSITE of vecFree (downward into joist)
- Depth measured from start point

**Radius:** `dRadius`
- 4.5mm (standard Hilti)
- 5.0mm (Baufritz Setzschraube)
- 15.0mm (Baufritz Holzdolle)

### Drill Depth by Configuration

| Configuration | Depth | Purpose |
|---------------|-------|---------|
| Standard Hilti | 140mm | Full depth for HSW M12x220 hanger bolt |
| Baufritz Setzschraube | 70mm | Half depth for set screw application |
| Baufritz Holzdolle | 30mm | Shallow hole for wood dowel |

### Tool Application

**Method:** `bmStexon.addTool(drill)`
- Applies drill operation to beam's tool stack
- Drill subtracts material from beam solid body
- Multiple tools can be applied to same beam
- Tools applied in sequence (order matters)

**Tool Persistence:**
- Drill remains associated with beam
- If instance deleted, drill may remain (depending on beam tool cleanup)
- To remove drill, delete instance and recalculate beam

### Beam Modification

**Visual Impact:**
- Beam's 3D solid shows hole at drill location
- Hole visible in 3D views and sectional views
- Affects beam's realBody() and envelopeBody()

**Structural Impact:**
- Drill reduces beam cross-section at hole location
- Engineering software may analyze reduced capacity
- CNC export includes drill coordinates for manufacturing

---

## Validation Rules & Constraints

The script enforces multiple validation rules to ensure safe and buildable placements.

### 1. Beam Information Validation

**Standard Projects:**
```c
if (joist.information().find("Hilti",0, false)<0 && joist.element().bIsValid())
    joists.removeAt(i);  // Remove from selection
```

**Baufritz Projects:**
```c
if(nBaufritz && joist.information().find("Stexon",0, false)>-1)
    continue;  // Keep in selection
```

**Validation Timing:**
- During insertion (user selection phase)
- Filters joists before prompting for points

**Error Handling:**
- Silent filtering (no error message)
- Invalid joists simply removed from selection array

**How to Fix:**
- Select joist beam
- Open Properties
- Add "Hilti" to Information field
- Re-run script

### 2. Orientation Validation

**Horizontal Requirement:**
```c
if (!vecXB.isPerpendicularTo(_ZW))continue;
```

**Test:**
- Joist X-axis must be perpendicular to World Z-axis
- Allows horizontal joists at any compass direction
- Rejects sloped or vertical beams

**Typical Failure Cases:**
- Roof rafters (sloped)
- Vertical posts
- Stair stringers

**Workaround:**
- None - script fundamentally requires horizontal joists
- Use different fastener script for sloped members

### 3. Plate Position Validation

**Top Plate Check:**
```c
if (vecY.dotProduct(seg.ptMid()-ptCen)>0)
{
    reportMessage("\n" + scriptName() + ": " +T("|can only be placed on top plates.|"));
    eraseInstance();
    return;
}
```

**Validation Logic:**
- Calculates vector from joist center to element midline
- Projects onto element Y-axis (upward direction)
- If projection is positive: joist is BELOW element midline (bottom plate) ✗
- If projection is negative or zero: joist is ABOVE element midline (top plate) ✓

**Why This Matters:**
- Hilti stexon designed for upward drilling
- Connects from below joist into top plate
- Reverse direction (bottom plate) would be structural incorrect

**Typical Scenario:**
```
Wall element:
  Top plate: Y = +1400mm (valid for stexon)
  Studs: Y = 0 to 1400mm
  Bottom plate: Y = 0mm (invalid for stexon)

Joist at Y = 1400mm: Valid (top plate connection)
Joist at Y = 0mm: Invalid (bottom plate connection)
```

### 4. Edge Distance Validation

**Minimum Distance from Beam Start/End:**

**Standard Projects:**
```c
double dDistanceEdge=U(200);
```
- 200mm minimum from beam start
- 200mm minimum from beam end
- Total restricted zone: 400mm per beam

**Baufritz Projects:**
```c
if(nBaufritz)dDistanceEdge=U(0);
```
- 0mm minimum (no restriction)
- Allows placement at beam ends
- User assumes responsibility for edge distance

**Validation Implementation:**
```c
plShrink.createRectangle(LineSeg(segStexon.ptMid()-bmStexon.vecX()*
    (.5*dX-dDistanceEdge)-bmStexon.vecY()*(.5*dY-U(40)),
    segStexon.ptMid()+bmStexon.vecX()*
    (.5*dX-dDistanceEdge)+bmStexon.vecY()*(.5*dY-U(40))),
    bmStexon.vecX(),bmStexon.vecY());
```

**Shrink Calculation:**
- Original length: dX
- Shrunken length: dX - 2*dDistanceEdge
- Example (3000mm beam, 200mm edge distance):
  - Original: 3000mm
  - Shrunken: 2600mm (3000 - 400)
  - Valid zone: 200mm to 2800mm from beam start

**Minimum Distance from Beam Edges (Perpendicular):**
```c
(.5*dY-U(40))  // 40mm edge clearance
```
- Always 40mm regardless of project special
- Applied to both sides (perpendicular to beam length)
- Prevents splitting from fastener too close to edge

**Example (140mm wide beam):**
- Original width: 140mm
- Shrunken width: 60mm (140 - 80)
- Valid zone: 40mm to 100mm from beam edge
- Center placement: 70mm from each edge ✓

### 5. Edge Distance Warning (25mm)

**Separate from Hard Limits:**
```c
if (abs(vecZ.dotProduct(_Pt0-segs[i].ptStart()))<U(25)) bIs50 = true;
else if (abs(vecZ.dotProduct(_Pt0-segs[i].ptEnd()))<U(25)) bIs50 = true;
```

**What This Checks:**
- Distance from instance center to profile edge segments
- Tests distance to segment start and end points
- 25mm threshold for visual warning

**Not the Same as 40mm Validation:**
- 40mm = Hard limit enforced by boundary shrinking
- 25mm = Visual warning (red color) that can be overridden

**Typical Scenario:**
```
Beam width: 140mm
Shrunken boundary: 40mm edge clearance
Instance at 35mm from edge:
  - Validation: PASS (35mm > 40mm is FALSE, but validation uses shrunken profile which is already offset by 40mm)
  - Warning: TRIGGER (35mm > 25mm is TRUE)
  - Result: Instance created but displays in RED
```

**User Options When Red Warning Appears:**
1. Adjust Y-offset to move away from edge
2. Right-click and disable edge checking (manual override)
3. Accept red warning and proceed (if edge distance is adequate for your application)

### 6. Profile Boundary Validation

**Intersection Profile Test:**
```c
if (pp.area()>pow(dEps,2))  // Area > 0.01 mm²
```

**What This Validates:**
- Meaningful intersection between wall and joist
- Prevents degenerate cases (tangent touch, no overlap)
- Ensures sufficient placement area

**Point-in-Profile Test:**
```c
if (pp.pointInProfile(pt)==_kPointInProfile)
```

**What This Validates:**
- User-clicked point falls within valid intersection area
- Prevents placement outside beam/element boundaries
- Ensures drill location is geometrically valid

**Profile Types:**
- `_kPointInProfile` = Inside profile
- `_kPointOnProfile` = On profile boundary (also acceptable in some cases)
- `_kPointOutsideProfile` = Outside profile (invalid)

### 7. Offset Range Validation

**Dynamic Calculation:**
- Offset limits calculated from current beam geometry
- Validated every time parameter changes
- Automatic clamping to maximum safe value

**X-Offset Range (when adjustable):**
```
Maximum = (beam length / 2) - dDistanceEdge
Minimum = -(beam length / 2) + dDistanceEdge

Example (3000mm beam, 200mm edge):
  Max: +1300mm
  Min: -1300mm
  Range: 2600mm
```

**Y-Offset Range:**
```
Maximum = (beam width / 2) - 40mm
Minimum = -(beam width / 2) + 40mm

Example (140mm beam):
  Max: +30mm
  Min: -30mm
  Range: 60mm
```

**Automatic Clamping Messages:**
```
"X-Axis Offset maximal zulässig: 1300"
"Y-Axis Offset maximal zulässig: 30"
```
- Displayed when user exceeds limits
- Parameter automatically set to maximum allowable
- Instance relocates to clamped position

---

## Export Functionality

### DXX File Export

The Hilti Export function creates a comprehensive data file for manufacturing integration.

**Trigger Methods:**
1. Right-click instance → "Hilti Export"
2. Double-click any Hilti stexon instance

**Export Scope:**
- **Drawing-wide:** Collects ALL instances in model space
- **Multi-script:** Includes both Hilti-Stockschraube and Hilti-Verankerung
- **Selective:** Only includes instances matching specific script names

**Collection Logic:**
```c
String sExportNames[] ={ "Hilti-Verankerung", scriptName()};
Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
Entity stexons[0];
for (int i=0;i<ents.length();i++)
{
    TslInst tsl= (TslInst)ents[i];
    if (tsl.bIsValid())
    {
        String s1 = tsl.scriptName(); s1.makeLower();
        for (int j=0;j<sExportNames.length();j++)
        {
            String s2 = sExportNames[j]; s2.makeLower();
            if (s1==s2)
            {
                stexons.append(tsl);
                break;
            }
        }
    }
}
```

**Collection Process:**
1. Collect all TslInst entities in model space groups
2. Loop through each instance
3. Get script name and convert to lowercase
4. Compare against allowed export names (case-insensitive)
5. Append to export array if match found

**Exported Scripts:**
- `Hilti-Stockschraube` (this script)
- `Hilti-Verankerung` (anchoring system)

**Not Exported:**
- Other TSL scripts (even if Hilti-related)
- Paper space instances
- Invalid/erased instances

### ModelMap Composition

**Composition Settings:**
```c
ModelMapComposeSettings mmFlags;
mmFlags.addSolidInfo(TRUE);          // Include 3D geometry
mmFlags.addAnalysedToolInfo(TRUE);   // Include drill data
```

**What Gets Exported:**

**1. Solid Information:**
- 3D ACIS solid bodies of associated beams
- Element envelope geometry
- Spatial positioning (global coordinates)
- Body transformations

**2. Analyzed Tool Information:**
- Drill center point (X, Y, Z)
- Drill direction vector
- Drill radius
- Drill depth
- Tool type (Drill)
- Associated beam handle

**3. Hardware Data:**
- Manufacturer: Hilti
- Article number: 2316491
- Model designation: HSW M12x220/60 8.8
- Quantity per instance
- Element group assignment

**ModelMap Creation:**
```c
ModelMap mm;
mm.setEntities(stexons);        // Set entities to export
mm.dbComposeMap(mmFlags);       // Compose with flags
```

### File Path Determination

**Parent Folder Logic:**
```c
String sPath = _kPathDwg;  // Current drawing path
for (int i=sPath.length()-1; i>=0 ; i--)
{
    int n = sPath.find("\\",i);
    if (n>-1)
    {
        sPath = sPath.left(n);  // Truncate to parent folder
        break;
    }
}
String sFileName = sPath + "\\HiltiExport.dxx";
```

**Path Calculation:**
1. Start with current drawing path: `_kPathDwg`
2. Search backwards for last backslash: `\`
3. Truncate path at last backslash
4. Result: parent folder of DWG file
5. Append filename: `HiltiExport.dxx`

**Example Paths:**

```
Drawing: C:\Projects\Building_A\Floor_1\Walls.dwg
Export:  C:\Projects\Building_A\Floor_1\HiltiExport.dxx

Drawing: D:\Users\John\Desktop\TestProject\Model.dwg
Export:  D:\Users\John\Desktop\TestProject\HiltiExport.dxx

Drawing: \\Server\Share\Projects\2024\House_123\Framing.dwg
Export:  \\Server\Share\Projects\2024\House_123\HiltiExport.dxx
```

**Overwrite Behavior:**
- Always overwrites existing `HiltiExport.dxx`
- No warning or confirmation prompt
- Previous export data is lost

### File Writing

```c
mm.writeToDxxFile(sFileName);
```

**DXX Format:**
- hsbCAD proprietary ModelMap exchange format
- Binary or XML-based (version dependent)
- Contains complete 3D geometry and metadata
- Compatible with Hilti downstream software

**Debug Confirmation:**
```c
if(bDebug)reportMessage("\n"+ scriptName() + " " + stexons.length() + " exported to " + sFileName);
```

**Example Message:**
```
Hilti-Stockschraube 47 exported to C:\Projects\Building_A\Floor_1\HiltiExport.dxx
```

### Recalculation Trigger

```c
setExecutionLoops(2);
return;
```

**Purpose:**
- Ensures all instances update before export
- First loop: collect instances
- Second loop: finalize geometry
- Guarantees export data accuracy

### Downstream Integration

**Hilti Software Integration:**
- Import DXX into Hilti Profis Engineering
- Import into Hilti HIT-Planning software
- Use for CNC drilling machine programming

**Data Usage:**
- Exact 3D coordinates for each drill
- Drill specifications (diameter, depth, direction)
- Hardware quantities for ordering
- Quality control verification

**Typical Workflow:**
1. Complete design in hsbCAD
2. Run Hilti Export (double-click any instance)
3. Import HiltiExport.dxx into Hilti software
4. Generate CNC drilling programs
5. Export hardware purchase order
6. Verify installation against design coordinates

---

## Error Messages & Troubleshooting

### Common Error Messages

#### "Invalid references"

**When Displayed:**
```c
if ((!bm.bIsValid() && !el.bIsValid()) || !bm.vecX().isPerpendicularTo(_ZW))
{
    reportMessage(TN("|Invalid references|"));
    eraseInstance();
    return;
}
```

**Causes:**
1. Both beam and element references are invalid (deleted or corrupted)
2. Beam exists but is not horizontal (sloped or vertical)

**How to Fix:**
- **Cause 1:** Re-insert script with valid beam selection
- **Cause 2:** Ensure joists are horizontal (perpendicular to World Z-axis)

**Why It Happens:**
- Beam deleted after instance creation
- Element deleted after instance creation
- Beam rotated from horizontal to sloped orientation
- Drawing corruption or reference loss

#### "location not valid for any of the selected beams"

**When Displayed:**
```c
if (!bOk)
    reportMessage("\n" + scriptName() + ": " +T("|location not valid for any of the selected beams|"));
```

**Context:** During Mode 3 point selection

**Causes:**
- Clicked point outside all selected joist profiles
- Clicked on floor/wall instead of joist
- Clicked near joist but outside envelope shadow

**How to Fix:**
- Click closer to joist centerline
- Zoom in for more accurate clicking
- Verify joist selection is correct

**Visual Aid:**
- Joist shadow profiles briefly displayed during placement
- Click within visible profile boundaries

#### "can only be placed on top plates"

**When Displayed:**
```c
if (vecY.dotProduct(seg.ptMid()-ptCen)>0)
{
    reportMessage("\n" + scriptName() + ": " +T("|can only be placed on top plates.|"));
    eraseInstance();
    return;
}
```

**Causes:**
- Selected joist is identified as bottom plate
- Joist positioned below element midline
- Inverted element coordinate system

**How to Fix:**
- Select joist from TOP of wall frame instead
- Verify element orientation (vecY should point upward)
- Check that joist is actually top plate member

**Technical Explanation:**
- Script calculates vector from joist center to element midpoint
- If projection onto vecY is positive: joist is BELOW midpoint (bottom plate)
- Stexon only works for top plate connections (drill upward from below)

#### "Invalid selection"

**When Displayed:**
```c
else
    reportMessage("\n" + scriptName() + ": " +T("|Invalid selection.|"));
```

**Context:** End of insertion logic

**Causes:**
- No elements AND no joists selected
- All selected joists filtered out (lacking "Hilti" info)
- User pressed Enter at both selection prompts

**How to Fix:**
- Select at least one element OR one joist
- Ensure joists contain "Hilti" in Information field
- Re-run script with valid selection

#### "location invalid"

**When Displayed:**
```c
if (!bOk)
    reportMessage("\n" + scriptName() + ": " +T("|location invalid|"));
```

**Context:** Mode 1 (parallel) point selection

**Causes:**
- Clicked point outside intersection profile
- No overlap between wall frame and joist
- Point fell in gap between parallel beams

**How to Fix:**
- Click within highlighted intersection area
- Verify wall and joist actually overlap
- Zoom in to see exact intersection boundaries

#### "invalid location"

**When Displayed:**
```c
reportMessage("\n" + scriptName() + ": " +T("|invalid location|"));
eraseInstance();
return;
```

**Context:** Mode 2 (intersection) automatic placement

**Causes:**
- No intersection points found between wall and joist
- Intersection calculation failed geometrically
- Perpendicular test failed

**How to Fix:**
- Verify joist actually crosses wall element
- Check element and joist are properly formed (valid solids)
- Ensure joist is perpendicular to wall (not parallel)

#### "unexpeced error"

**When Displayed:**
```c
else
{
    reportMessage("\n" + scriptName() + ": " +T("|unexpeced error|"));
    eraseInstance();
    return;
}
```

**Context:** Should never occur (defensive programming)

**Causes:**
- Logic path that should be impossible to reach
- Indicates potential script bug or edge case

**How to Fix:**
- Report to hsbCAD support with drawing file
- Enable debug mode to see detailed execution path
- Check for drawing corruption

### Validation Warnings (Not Errors)

#### Edge Distance Messages

**X-Offset Maximum:**
```c
reportMessage("\n" + scriptName() + " " + sOffsetXName + " maximal zulässig: " + dOffsetXNew);
```

**Y-Offset Maximum:**
```c
reportMessage("\n" + scriptName() + " " + sOffsetYName + " maximal zulässig: " + dOffsetYNew);
```

**Not Errors - Just Information:**
- Script automatically clamps offset to safe value
- Instance remains valid
- User informed of maximum allowable offset

**Example Messages:**
```
Hilti-Stockschraube X-Axis Offset maximal zulässig: 1300
Hilti-Stockschraube Y-Axis Offset maximal zulässig: 30
```

### Troubleshooting Strategies

#### Problem: Instances Turn Red

**Diagnosis:**
- Red color = edge distance warning (< 25mm from edge)
- Not an error, but structural warning

**Solutions:**
1. **Adjust Y-Offset:** Move instance away from edge until green/magenta
2. **Disable Edge Check:** Right-click → "Randabstand nicht prüfen"
3. **Accept Warning:** Proceed if engineer approves close edge placement

**Verification:**
- Measure actual distance from instance center to beam edge
- Confirm adequate for fastener specification
- Check local building code requirements

#### Problem: Instance Disappears After Placement

**Diagnosis:**
- Script validated geometry and deleted itself (`eraseInstance()`)
- Silent failure indicates validation rule violation

**Common Causes:**
1. **Top Plate Check Failed:** Joist identified as bottom plate
2. **Invalid References:** Beam or element became invalid
3. **Profile Validation Failed:** No valid intersection area

**Debugging Steps:**
1. Enable debug mode (create hsbTSLDebugController MapObject with script name)
2. Watch command line for debug messages
3. Check which validation rule triggered deletion
4. Fix underlying geometry issue

#### Problem: Can't Place Instance at Desired Location

**Diagnosis:**
- Point validation rejects click location
- Offset validation clamps to different position

**Common Causes:**
1. **Outside Profile:** Click point not within beam shadow
2. **Edge Distance:** Desired location violates 40mm edge clearance
3. **Shrunken Boundary:** Valid area smaller than beam outline

**Solutions:**
1. **Visual Guide:** Watch for profile visualization during placement
2. **Zoom In:** More precise clicking
3. **Adjust Beam Size:** Use wider/longer joists for more placement area
4. **Baufritz Mode:** Set project special to "BAUFRITZ" to eliminate end distance restriction

#### Problem: Export File Not Created

**Diagnosis:**
- `HiltiExport.dxx` not appearing in parent folder
- Silent failure (no error message)

**Common Causes:**
1. **No Write Permission:** Parent folder is read-only or network restricted
2. **Path Invalid:** Parent folder doesn't exist
3. **File Locked:** Existing HiltiExport.dxx open in another program
4. **No Instances:** Zero Hilti stexons found in drawing

**Solutions:**
1. **Check Permissions:** Ensure write access to parent folder
2. **Close Other Programs:** Close Hilti software that might have file open
3. **Verify Instances:** Ensure at least one Hilti-Stockschraube or Hilti-Verankerung exists
4. **Manual Path:** Save to different location if parent folder inaccessible

**Verification:**
```
Expected location: [DWG folder]\HiltiExport.dxx
If not there, check: file size, modification time, accessibility
```

---

## Tips & Best Practices

### Design Workflow

**1. Mark Joists First**
- Before running script, add "Hilti" to joist Information field
- Select multiple joists → Properties → Information → "Hilti"
- Saves time during selection filtering

**2. Use Batch Placement for Repetitive Layouts**
- Select entire wall element
- Select all joists that cross wall
- Script automatically places at all intersections
- Faster than individual point placement

**3. Parallel Mode for Precise Spacing**
- When single joist runs along wall, use parallel mode
- Allows exact control of spacing along joist length
- Ideal for equally-spaced stexon patterns

**4. Check Edge Warnings Immediately**
- Red instances indicate edge distance < 25mm
- Review before finalizing design
- Either adjust offset or confirm with engineer

**5. Export Before Finalizing Drawing**
- Run Hilti Export early in design process
- Verify all instances export correctly
- Catch placement issues before manufacturing

### BOM Accuracy

**6. Coordinate HCW Connector Quantities**
- Each stexon requires one HCW connector pre-installed in joist
- Use separate script or manual BOM entry for HCW connectors
- Verify Stexon count = HCW count

**7. Baufritz Projects: Manual BOM Review**
- "Ausführung" parameter changes drill specs but not BOM entry
- Manually update hardware components if using Holzdolle or Setzschraube
- Use custom BOM script to map version to article numbers

**8. Element Group Assignment**
- Ensure elements have correct ElementGroup names before placement
- Hardware components inherit element group
- Enables filtering BOM by wall, floor, or roof

### Geometric Optimization

**9. Exterior Wall Offset**
- Script automatically applies 75mm offset for exterior walls
- Verify offset direction matches wall assembly (toward exterior face)
- Adjust if wall assembly is non-standard (thick sheathing, etc.)

**10. Verify Joist Orientation**
- Only horizontal joists accepted
- Check World Z-axis alignment before selection
- Sloped joists require different fastener type

**11. Use Element-Based Selection for Consistency**
- Selecting entire element ensures all joists processed
- Reduces risk of missing joists
- Maintains consistent connection pattern

### Troubleshooting Prevention

**12. Enable Debug Mode for Complex Placements**
- Create MapObject with script name in hsbTSLDebugController
- Watch command line for detailed execution messages
- Helps diagnose unexpected behavior

**13. Save Before Batch Operations**
- Save drawing before placing many instances
- Allows rollback if unexpected results
- Prevents loss of work

**14. Verify References After Moving Beams**
- If joists are moved/copied, instances recalculate automatically
- Check for red warnings or deleted instances
- Re-place instances if references lost

### Manufacturing Integration

**15. Consistent Export Location**
- Export always saves to parent folder of DWG
- Organize drawings so parent folder is manufacturing folder
- Simplifies file management for CNC programming

**16. Export Naming Convention**
- File always named `HiltiExport.dxx` (not customizable)
- If multiple drawings, export from each individually
- Rename exported files immediately if needed (before exporting next drawing)

**17. Verify Export Contents**
- After export, import into Hilti software to verify
- Check drill count matches instance count
- Confirm coordinates align with design intent

### Project Standards

**18. Establish Information Field Keywords**
- Standardize on "Hilti" for all projects
- Or use "Stexon" for Baufritz projects
- Document standard in project BIM execution plan

**19. Define Edge Distance Standards**
- Decide if 25mm warning threshold is appropriate
- Establish override approval process
- Train designers on when to disable edge checking

**20. BOM Component Standards**
- Verify article number 2316491 is correct for your region
- Update hardware component description if needed
- Coordinate with purchasing for correct Hilti product

---

## Related Scripts

### Hilti-Verankerung

**Purpose:** Wall anchoring system (complementary to Stockschraube)

**Relationship:**
- Both scripts export to same `HiltiExport.dxx` file
- Use together for complete Hilti connection system
- Verankerung: wall-to-foundation connections
- Stockschraube: joist-to-wall connections

**Typical Workflow:**
1. Place Hilti-Verankerung at foundation connections
2. Place Hilti-Stockschraube at joist-to-wall connections
3. Single export includes both instance types

### Simpson StrongTie Scripts

**Alternative Hardware System:**
- Simpson StrongTie hanger scripts serve similar purpose
- Different manufacturer and product specifications
- Choose based on project specifications or regional availability

**Simpson Scripts:**
- `Simpson StrongTie Anchor`
- `Simpson StrongTie BT` (beam tie)
- `SimpsonStrongTieEL` (end links)

**When to Use:**
- Project specifies Simpson hardware
- Hilti system not available in region
- Different load requirements

### Generic Hanger Scripts

**Purpose:** Vendor-neutral hanger bolt placement

**Scripts:**
- `GenericHanger` - Customizable hanger system
- `GenericHangerExcelImporter` - Import hanger specs from Excel

**When to Use:**
- Custom hardware not in standard catalogs
- Need flexibility in fastener specification
- Importing hardware data from spreadsheets

### Element-Based Connection Scripts

**Complementary Scripts:**
- `HSB_W-Blocking` - Wall blocking between studs
- `HSB_R-GutterForFlatRoof` - Roof connections
- `FLR_Chase` - Floor joist openings and blocking

**Workflow Integration:**
- Use together to complete wall/floor assembly
- Each script handles different connection type
- Coordinate BOM across all connection scripts

### Baufritz-Specific Scripts

**Related Scripts:**
- Other scripts may check `projectSpecial()=="BAUFRITZ"`
- Coordinate Baufritz-specific settings across scripts
- Document Baufritz standards for consistent behavior

---

## Version History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| **1.7** | 08.10.2024 | Marsel Nakuci | HSB-19775: Change TSL image (thumbnail update) |
| **1.6** | 08.04.2024 | Marsel Nakuci | HSB-21790: For Baufritz add extra property "Ausführung" dropdown (Holzdolle, Setzschraube options) |
| **1.5** | 15.03.2023 | Marsel Nakuci | HSB-18322: Don't apply minimum distance from start/end beam for "BAUFRITZ" (dDistanceEdge = 0 for Baufritz) |
| **1.4** | 23.01.2023 | Marsel Nakuci | HSB-16670: Drill depth and radius for Baufritz (Setzschraube 70mm/5mm, Holzdolle 30mm/15mm) |
| **1.3** | 28.09.2022 | Marsel Nakuci | HSB-16670: Support beams with info "Stexon" for projectSpecial=Baufritz |
| **1.2** | 14.09.2021 | Marsel Nakuci | HSB-12697: Section and minimal boundary check (40mm edge clearance, shrunken profile validation) |
| **1.1** | 08.09.2021 | Marsel Nakuci | HSB-12697: Add description (initial documentation) |
| **1.0** | 08.11.2018 | Thorsten Huck | Initial release |

### Older Version Notes (Thorsten Huck)

| Version | Date | Description |
|---------|------|-------------|
| **1.4** | 13.12.2018 | Color red for edge distance ≤ 25mm, can be suppressed via RMT (right-click menu) |
| **1.3** | 13.12.2018 | Selection method for individual beams only accepts 'Stexon' beams when element association exists |
| **1.2** | 13.12.2018 | Y-offset checks minimum edge distance |
| **1.1** | 08.11.2018 | Corrected AW placement |
| **1.0** | 08.11.2018 | Initial release |

### Evolution Summary

**2018-2021: Core Functionality (Thorsten Huck)**
- Initial implementation with element/joist intersection logic
- Edge distance validation and visual warnings (red color)
- Y-offset boundary checking
- Right-click menu for edge distance override

**2021-2023: Baufritz Integration (Marsel Nakuci)**
- Support for "Stexon" beam information (alongside "Hilti")
- Boundary validation refinements
- Drill specifications for different Baufritz versions
- Removal of end distance restriction for Baufritz projects

**2024: User Experience Enhancements (Marsel Nakuci)**
- "Ausführung" dropdown parameter for Baufritz version selection
- Thumbnail image update
- Improved user interface for version selection

### Future Considerations

**Potential Enhancements:**
- Support for additional Hilti fastener types (different HSW sizes)
- Automatic HCW connector BOM generation
- Integration with structural analysis software
- Enhanced visualization (3D preview of installed hardware)
- Batch parameter editing for multiple instances
- Template-based placement patterns

**Known Limitations:**
- Only horizontal joists supported (no sloped members)
- Single drill per instance (can't create multiple holes)
- Fixed hardware component (article 2316491) - no alternative products
- Export filename not customizable (always HiltiExport.dxx)

---

## Appendix: Technical Reference

### Script Header Information

```
#Version 8
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords Hilti,Stexon,HSW
```

### Constants and Global Variables

```c
U(1,"mm");                    // Unit system: millimeters
double dEps = U(.1);          // Geometric tolerance: 0.1mm
int bDebug = _bOnDebug;       // Debug mode flag
String sProjectSpecial = projectSpecial().makeUpper();
int nBaufritz = sProjectSpecial=="BAUFRITZ";
```

### Drill Specifications Table

| Configuration | Project | Version | Radius | Depth | Diameter |
|---------------|---------|---------|--------|-------|----------|
| Standard | Any | Default | 4.5mm | 140mm | 9mm |
| Baufritz | BAUFRITZ | Setzschraube | 5.0mm | 70mm | 10mm |
| Baufritz | BAUFRITZ | Holzdolle | 15.0mm | 30mm | 30mm |

### Edge Distance Rules Table

| Rule | Standard | Baufritz | Purpose |
|------|----------|----------|---------|
| **End Distance** | 200mm | 0mm | Minimum from beam start/end |
| **Edge Clearance** | 40mm | 40mm | Minimum from beam edges (perpendicular) |
| **Warning Threshold** | 25mm | 25mm | Visual warning (red color) |

### Color Coding Reference

| Color | Code | Meaning | Trigger Condition |
|-------|------|---------|-------------------|
| Green | 3 | Normal - Drill upward | `vecFree.dotProduct(_ZW) > 0` |
| Magenta | 6 | Normal - Drill downward | `vecFree.dotProduct(_ZW) ≤ 0` |
| Red | 1 | Warning - Edge distance | Distance to edge < 25mm AND edge checking enabled |

### Map Storage Keys

| Key | Type | Purpose |
|-----|------|---------|
| `"Allow50"` | int | Edge distance check override (0=check enabled, 1=check disabled) |

### Recalc Trigger Keys

| Trigger Key | Source | Action |
|-------------|--------|--------|
| `"Randabstand prüfen"` | Context menu | Enable edge distance checking |
| `"Randabstand nicht prüfen"` | Context menu | Disable edge distance checking |
| `"Hilti Export"` | Context menu | Export all Hilti stexons to DXX file |
| `"TslDoubleClick"` | Double-click | Same as Hilti Export |

### Hardware Component Properties

```c
Article Number: "2316491"
Manufacturer: "Hilti"
Model: "Hanger bolt HSW M12x220/60 8.8"
Description: "Galvanized hanger bolt for anchoring wood structures to wood using pre-installed HCW connectors"
Category: T("|Connector|")
RepType: _kRTTsl
Quantity: 1 (per instance)
```

### File References

**Settings Files:** None (script uses project special and beam information instead of XML)

**Export File:** `HiltiExport.dxx` (parent folder of current DWG)

**Dependencies:**
- hsbCAD core libraries
- AutoCAD ACIS solid modeling
- TSL runtime environment

---

*This documentation was generated for Hilti-Stockschraube v1.7 (October 8, 2024). For the most current version, check hsbCAD script repository.*

*Script File: `TSL\Hilti-Stockschraube.mcr` (8,950 lines, 514KB)*

*Documentation Completed: 2026-02-20*
