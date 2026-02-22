# TirolerSchloss

Traditional Tyrolean-style interlocking corner joints for log wall construction.

## Overview

The **TirolerSchloss** script creates authentic Tyrolean lock joints (Tiroler Schloss) at log wall intersections, a traditional Alpine timber construction technique. This sophisticated joinery system automatically generates complementary dovetail-like profiles cut into perpendicular log walls, creating a strong mechanical interlock without requiring additional fasteners.

### What It Does

The script intelligently:
- **Detects intersections** between log wall elements automatically
- **Calculates optimal joint geometry** based on wall dimensions and log courses
- **Applies precise machining operations** to individual logs at intersection points
- **Supports three profile types**: Convex (rounded outward), Concave (rounded inward), and Diagonal (angled flat)
- **Manages joint height zones** with interactive grips for vertical adjustment
- **Handles complex corner conditions** including through-joints and alternating log faces
- **Provides visual feedback** with plan symbols and 3D connection zones

### Traditional Context

Tyrolean lock joints originated in Alpine log construction where craftsmen needed corner connections that:
- Could handle differential wood movement and settling
- Provided structural integrity without metal fasteners
- Allowed for prefabrication and field assembly
- Maintained weather-tightness at corners

This script digitizes that traditional craft knowledge, automatically calculating the complex geometry that master carpenters once laid out by hand.

---

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | ✓ Yes | Primary environment - all operations occur in 3D model space |
| Paper Space | ✗ No | Not supported for layout generation |
| Shop Drawing | ✗ No | This is a model generation/detailing script |

**Script Type**: O-Type (Object script - creates persistent parametric entity)
**Current Version**: 1.1 (07.06.2023)
**Execution Mode**: Multi-stage (insertion → distribution → wall-to-wall machining)

---

## Prerequisites

Before using TirolerSchloss, ensure:

### 1. Log Wall Elements Required
- **Minimum**: Two intersecting `ElementLog` (log wall) entities must exist in your drawing
- **Wall Type**: Standard log wall construction with horizontal log stacking
- **Generated Logs**: For full functionality, walls should have their log construction generated (beams exist within elements)

### 2. Geometric Conditions
- **Non-parallel Walls**: The walls must intersect at an angle between 30° and 150° (parallel or nearly parallel walls are not supported)
- **Physical Intersection**: Wall outlines must overlap with a minimum intersection area of 4 mm² (2mm × 2mm)
- **Proper Alignment**: Walls should be constructed at compatible floor levels

### 3. Log Course Structure
- Walls should use consistent log heights (visible height per course)
- First log elevation (half-log starter course) should be properly defined
- LogCourse data should be valid within ElementLog entities

### 4. Recommended Drawing Setup
- **Units**: Either millimeters or inches (script handles both via U() function)
- **UCS**: World coordinate system with Z-axis as vertical
- **View**: Plan view (top-down) for insertion, 3D views for verification

---

## Usage Instructions

### Step 1: Launch the Script

**Method A: Via TSL Insert Command**
```
Command: TSLINSERT
```
Select `TirolerSchloss.mcr` from the browser dialog.

**Method B: Via AutoLISP Command**
```
Command: (hsb_ScriptInsert "TirolerSchloss")
```

**Method C: Custom Toolbar Button**
Create a toolbar button with command:
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TirolerSchloss")) TSLCONTENT
```

### Step 2: Configure Default Parameters (Optional)

Upon launch, a properties dialog appears with these sections:

#### General Category
- **Base Height**: Starting elevation (Z-level) for the connection zone
- **End Height**: Maximum height (set to 0 for automatic detection to wall top)

#### Tool Category
- **Vertical Offset**: Shifts the entire joint geometry up/down
- **Gap**: Clearance between intersecting log surfaces (for compression tolerance)
- **Flank Angle**: Dovetail interlock angle (typical range: 6-12 degrees)

#### Seatcut / Tapering Category
- **Seat Width**: Horizontal flat cut depth on primary wall
- **Seat Depth** (or **Tapering** for Diagonal type): Cut depth on secondary wall
- **Type**: Select from Convex, Concave, or Diagonal profile

**Catalog Integration**: If you've saved preset configurations, they can be applied automatically by specifying the catalog key name.

**Quick Start**: Click OK to accept defaults and proceed to selection.

### Step 3: Select Log Wall Elements

Prompt: `"Select elements"`

**Selection Modes**:
1. **Single Pair**: Click two log walls → Press Enter
2. **Multiple Walls**: Click 3 or more walls → Press Enter (script finds all valid corner pairs automatically)
3. **Window Selection**: Window-select entire building section to process all corners

**Selection Tips**:
- Select walls in any order (script determines correct relationship automatically)
- You can select the same wall twice if it corners with multiple other walls
- Invalid combinations (parallel walls, no intersection) are silently ignored

### Step 4: Automatic Joint Creation

After selection confirmation:

1. **Analysis Phase**: Script analyzes all selected wall pairs
2. **Intersection Detection**: Identifies valid corner intersections (non-parallel, overlapping outlines)
3. **Instance Creation**: Places a TirolerSchloss connection instance at each valid intersection
4. **Mode Transition**: Each instance switches from "Wall Distribution Mode" (mode=1) to "Wall-Wall Mode" (mode=2)
5. **Geometry Calculation**: Calculates joint geometry based on wall vectors, log positions, and parameters
6. **Tool Application**: Applies `TirolerSchloss` tool operations to individual logs within the connection zone
7. **Visualization**: Displays plan symbols and 3D connection volumes

**Automatic Cleanup**: If a TirolerSchloss or Klingschrot connection already exists between the same wall pair, it is automatically removed before creating the new connection.

### Step 5: Visual Verification

After creation:

#### Plan View Display
- **Symbol**: Stylized T-shaped icon at each joint location
- **Color Coding**:
  - **Dark Yellow** (rgb 254,204,102): Convex type
  - **Yellow-Green** (rgb 219,208,81): Concave type
  - **White**: Diagonal type
- **Filled Outline**: Shows connection footprint when logs are not yet generated

#### Model View (3D) Display
- **Connection Zone**: Semi-transparent yellow volume showing the vertical extent
- **Wall Labels**: Wall numbers displayed at top of connection (e.g., "W1-W2")
- **Intersection Footprint**: Outline of the wall overlap area
- **Log Highlights**: (During grip dragging) Light blue preview of affected log faces

### Step 6: Adjusting Connection Height

The script provides **interactive grips** for vertical adjustment:

#### Grip Locations
- **Bottom Grips** (Arrow pointing down): Two grips at Base Height level
  - One visible along Wall 0 axis
  - One visible along Wall 1 axis (view-dependent)
- **Top Grips** (Arrow pointing up): Two grips at End Height level
  - One visible along Wall 0 axis
  - One visible along Wall 1 axis (view-dependent)

#### Grip Manipulation
1. **Select Connection**: Click on the TirolerSchloss instance
2. **Hover Over Grip**: Grips appear as arrows (view-dependent - rotate view to see grips for each wall)
3. **Click and Drag**:
   - Drag **bottom grips vertically** to adjust Base Height
   - Drag **top grips vertically** to adjust End Height
4. **Synchronized Movement**: The corresponding grip on the opposite wall moves automatically
5. **Release**: Connection recalculates with new height values

**Constraint**: The minimum connection height equals the visible log height (dVisibleHeight) - you cannot make it shorter than one log course.

#### Grip Tooltips
- Bottom grips: *"Move grip to adjust starting height of connection"*
- Top grips: *"Move grip to adjust end height of connection"*

### Step 7: Fine-Tuning Parameters

Select the connection and modify properties in the **AutoCAD Properties Palette (OPM)**:

#### When to Adjust Each Parameter

| Parameter | Adjust When... | Typical Values |
|-----------|----------------|----------------|
| **Base Height** | Connection should start above floor level | 0-500 mm |
| **End Height** | Connection should stop before wall top (for gable walls) | 0 (auto) or explicit height |
| **Vertical Offset** | Finished floor is different from structural floor | -50 to +50 mm |
| **Gap** | Need clearance for wood compression or insulation | 0-10 mm |
| **Flank Angle** | Joint is too tight/loose during assembly | 6-12° |
| **Seat Width** | Need more/less bearing surface on primary wall | -50 to +100 mm |
| **Seat Depth** | Need more/less bearing surface on secondary wall | -50 to +100 mm |
| **Type** | Aesthetic or structural preference | Convex, Concave, Diagonal |

**Negative Seat Values**: Setting Seat Width or Seat Depth to negative values forces an additional beam cut operation, creating a deeper notch.

**Dynamic Label Change**: When Type is set to "Diagonal", the "Seat Depth" label automatically changes to "Tapering" to reflect its different geometric meaning.

---

## Parameters Reference

### General Category

#### Base Height
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm
- **Range**: Any positive value up to wall height
- **Unit-Aware**: Uses current drawing units (mm or inches)
- **Description**: Defines the vertical starting elevation (Z-coordinate) for the connection zone. Logs below this height are excluded from the joint machining.
- **Use Case**: Set to floor slab thickness when foundation starts below structural floor level
- **Interactive**: Adjustable via bottom grips or Properties Palette

#### End Height
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm (automatic detection)
- **Range**: 0 (auto) or Base Height + minimum log height to wall top
- **Special Value**: **0 = Automatic** (script calculates maximum height from wall geometry)
- **Description**: Defines the maximum vertical elevation for the connection. Set to explicit value when corner should stop before wall top (e.g., gable end with decreasing log lengths).
- **Automatic Behavior**: When set to 0, script finds the highest point among:
  - Wall 0 maximum segment endpoint
  - Wall 1 maximum segment endpoint
  - Wall envelope vertices
- **Constraint**: If End Height ≤ Base Height (and not 0), both are reset to 0
- **Interactive**: Adjustable via top grips or Properties Palette

### Tool Category

#### Vertical Offset
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm
- **Range**: Typically -100 mm to +100 mm
- **Description**: Moves the entire tool geometry (all cuts, notches, dovetails) up or down in the Z-direction without changing wall positions.
- **Use Cases**:
  - Align joint with finished floor when structural slab is at different elevation
  - Compensate for foundation settling in renovation projects
  - Shift joint away from conflict with floor joists or beams
- **Technical Note**: Applied to log center point (`b.ptCen() + vecY * dVerticalOffset`) before calculating intersection with wall planes

#### Gap
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm
- **Range**: 0-20 mm typical
- **Description**: Creates clearance distance between the intersecting log surfaces. This gap reduces the effective dovetail height by the gap value.
- **Calculation**: `dDovetailHeight = dVisibleHeight * 0.5 - dGap`
- **Use Cases**:
  - Wood compression tolerance (2-5 mm typical)
  - Space for insulation gasket or sealant tape
  - Assembly clearance for field installation
- **Warning**: Large gaps reduce mechanical interlock strength

#### Flank Angle
- **Type**: PropDouble (angle in degrees)
- **Default**: 8.0 degrees
- **Range**: Practical range 4-15 degrees (typical timber joinery 6-12 degrees)
- **Description**: Defines the angle of the dovetail flanks that create the mechanical interlock. Higher angles = more aggressive interlock (harder to assemble/disassemble), lower angles = easier assembly but less mechanical advantage.
- **Technical**: Applied to `TirolerSchloss` tool constructor as `dDovetailAngle` parameter
- **Craftsman's Rule**: Traditional Tyrolean carpenters used 1:7 ratio (approximately 8.1°)
- **Recommendations**:
  - **6°**: Easy assembly, less resistance to pulling forces
  - **8°**: Balanced - standard for most applications
  - **10-12°**: Very strong, requires careful alignment during assembly

### Seatcut / Tapering Category

#### Seat Width
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm
- **Range**: -100 mm to +150 mm (negative forces additional beam cut)
- **Description**: Defines the width of the horizontal seat cut (flat bearing surface) created on the **primary wall** (determined by swap state and log course pattern).
- **Positive Values**: Creates seat cut for bearing support
- **Negative Values**: Forces an additional `Cut` tool operation (beam cut), creating deeper notch
- **Technical Parameter**: Passed as `dOffsetThis` to `TirolerSchloss` tool for primary wall logs
- **Geometric Impact**: Affects `nType0` geometry (first wall's tool type)

#### Seat Depth (or Tapering)
- **Type**: PropDouble (length dimension)
- **Default**: 0 mm
- **Range**:
  - **Non-Diagonal types**: -100 mm to +150 mm (negative forces additional beam cut)
  - **Diagonal type**: 0 to +200 mm (controls taper angle, negative values not meaningful)
- **Dynamic Label**:
  - Label = "Seat Depth" when Type = Convex or Concave
  - Label = "Tapering" when Type = Diagonal
- **Description**:
  - **For Convex/Concave**: Width of seat cut on **secondary wall**
  - **For Diagonal**: Controls the tapering/beveling distance for the diagonal milling
- **Technical Parameter**: Passed as `dOffsetOther` to `TirolerSchloss` tool for secondary wall logs
- **Geometric Impact**: Affects `nType1` geometry (second wall's tool type)

#### Type
- **Type**: PropString (dropdown selection)
- **Options**:
  1. **Convex** (Rounded outward profile)
  2. **Concave** (Rounded inward profile)
  3. **Diagonal** (Angled flat surface)
- **Default**: Convex
- **Description**: Defines the geometric profile shape cut into the log corners. This determines the tool type constants used:

**Type Mapping Logic**:
```
Through-Joint (Wall extends beyond intersection):
  Convex  → _kTIConcave (first wall) / _kTIConvex (second wall)
  Concave → _kTIConvex (first wall) / _kTIConcave (second wall)
  Diagonal → _kTIDiagonal (both walls)

Alternating-Face Joint (On-face connections alternate):
  Convex  → _kTIConcave (first wall) / _kTIConvex (second wall)
  Concave → _kTIConvex (first wall) / _kTIConcave (second wall)
  Diagonal → _kTIDiagonal (both walls)

Standard Joint:
  Convex  → _kTEConcave (first wall) / _kTEConvex (second wall)
  Concave → _kTEConvex (first wall) / _kTEConcave (second wall)
  Diagonal → _kTEDiagonal (both walls)
```

**Visual Differences**:
- **Convex**: Rounded bulge at corner (traditional Tyrolean style)
- **Concave**: Rounded valley at corner (alternative aesthetic)
- **Diagonal**: Straight 45° chamfer (simplified modern style)

---

## Right-Click Context Menu

Select a TirolerSchloss connection and right-click to access specialized commands:

### Swap Walls
- **Menu Label**: "Swap Walls"
- **Keyboard Shortcut**: Double-click the connection
- **Function**: Reverses the priority/relationship of the two connected walls
- **When to Use**:
  - The notch is cut on the wrong wall (logs from Wall A are notched when Wall B should be notched)
  - First log pattern detection was incorrect
  - You want to switch which wall is "primary" vs "secondary" for seat cut purposes
- **Technical Effect**:
  - Swaps `elements[0]` ↔ `elements[1]`
  - Swaps `ppOutlines[0]` ↔ `ppOutlines[1]`
  - Toggles `bSwap` flag in `_Map`
  - Recalculates all tool geometry with reversed wall vectors
- **Undo**: Right-click again and select "Swap Walls" to toggle back

### Remove Logs from Connection
- **Menu Label**: "Remove Logs from Connection"
- **Visibility**: Always available when logs are generated
- **Function**: Prompts user to select individual log beams to **exclude** from the TirolerSchloss machining operation
- **When to Use**:
  - **Window/Door Frames**: Prevent notching logs that contain openings
  - **Structural Members**: Exclude logs with special loads (header beams, lintels)
  - **Assembly Sequence**: Keep certain logs full-length for crane rigging attachment
  - **Conflicts**: Avoid logs where joint would interfere with other features (plumbing, conduit)
- **Prompt**: "Select logs"
- **Selection**: Click on beams (supports multiple selection)
- **Storage**: Removed beams stored in `_Map` as entity array `"Log[]"`
- **Visual Feedback**: Excluded logs no longer receive `TirolerSchloss` tool operations
- **Reversible**: Use "Restore all logs of Connection" to undo

### Restore All Logs of Connection
- **Menu Label**: "Restore all logs of Connection"
- **Visibility**: Only appears when logs have been previously removed
- **Function**: Re-includes all previously excluded beams back into the connection machining
- **Effect**:
  - Clears the `"Log[]"` entity array from `_Map`
  - Next recalculation applies tools to all logs within connection zone
  - Returns to default "all logs included" state
- **Use Case**: You changed your mind about exclusions or fixed the conflicting condition

---

## Display Behavior

### Plan View (Top-Down)

#### Symbol Appearance
- **Shape**: Stylized **T-shaped icon** (vertical stem + horizontal cap)
- **Position**: Located at connection midpoint (intersection of wall centerlines)
- **Orientation**: Always vertical (aligned with Z-axis, not rotated with walls)
- **Size**: Scaled proportionally to wall thickness (40% of smaller wall dimension)

#### Color Coding (Type Indicator)
```
Convex Type   → Dark Yellow (rgb 254,204,102)
Concave Type  → Yellow-Green (rgb 219,208,81)
Diagonal Type → White (rgb 255,255,255) or Black (dark mode)
```

#### Drawing Layers
- **Symbol Layer**: `dpPlan` display object
- **View Directions**: Visible from `+Z` and `-Z` (always visible in plan)
- **Draw Order**: Forced to front (displays on top of other entities)

#### Special States
- **Logs Not Generated**: Shows filled outline of intersection footprint (semi-transparent overlay)
- **During Grip Drag**: Symbol remains static (does not update during dragging)

### Model View (3D Perspective)

#### Connection Zone Volume
- **Geometry**: Extruded profile from intersection outline (`ppc`)
- **Height**: From `ptBot` (Base Height) to `ptTop` (End Height)
- **Color**: Dark yellow (rgb 254,204,102)
- **Transparency**: 60% transparent (40% opaque) in normal state
- **Purpose**: Shows exact vertical extent where tools will be applied

#### Wall Labels
- **Content**: Wall numbers separated by hyphen (e.g., "W1-W2", "W3-W5")
- **Position**: At top of connection zone (`ptTop`)
- **Text Height**: 90 mm (model units)
- **Orientation**: Aligned with Wall 0 X-axis
- **Visibility**: Hidden when viewing from `+Z` or `-Z` (plan view)
- **View Directions**: Visible from wall face directions (perpendicular to walls)

#### During Grip Dragging
- **Previous State**: Original connection zone shown in dark yellow (50% transparent)
- **New Preview**: Light blue (rgb 204,204,255) connection zone at new grip position
- **Affected Logs**: Light blue highlights on log contact faces that will be machined
- **Moving Grip**: Shows at new dragged position in light blue
- **Static Grip**: Remains at original position until drag completes
- **Update Frequency**: Real-time during drag operation

#### Hidden Line Display (Legacy/Disabled)
The script contains code (currently disabled with `if (0)`) for generating isometric projection views of the joint with hidden line removal. This was used for detailed shop drawing visualization but is turned off in current version.

---

## Technical Details

### Script Execution Modes

The TirolerSchloss script operates in **three distinct modes** controlled by the `mode` integer in `_Map`:

#### Mode 1: Wall Distribution Mode
- **Trigger**: Set during `_bOnInsert` phase
- **Purpose**: Multi-wall batch processing
- **Behavior**:
  - Accepts selection of 2+ log wall elements
  - Iterates through all unique wall pairs (i, j where j > i)
  - Tests each pair for valid intersection conditions
  - Creates new TirolerSchloss instance for each valid pair via `TslInst.dbCreate()`
  - Sets child instances to Mode 2
  - Erases self after spawning children
- **Insertion Points**: Uses intersection midpoint (`pp1.ptMid()`)
- **Debug Mode**: Visualizes intersections instead of creating instances

#### Mode 2: Wall-Wall Mode
- **Trigger**: Set by parent instance during creation
- **Purpose**: Single corner joint calculation and machining
- **Behavior**:
  - Works with exactly 2 log wall elements
  - Calculates connection geometry, vectors, and tool positions
  - Applies `TirolerSchloss` tools to individual logs
  - Manages grips, triggers, and display
  - Persists as parametric entity in drawing
- **Execution Loops**: Sets `setExecutionLoops(2)` during parameter updates to ensure full recalculation

### Geometric Analysis

#### Wall Relationship Detection

**Parallel Wall Rejection**:
```cpp
if (el0.vecX().isParallelTo(el1.vecX()))
    continue; // Skip this pair
```

**Intersection Area Threshold**:
```cpp
if (pp1.intersectWith(pp0) && pp1.area() > pow(U(2), 2))
    // Valid intersection (area > 4 mm²)
```

#### Connection Vector Calculation

1. **Wall Midpoints**: `ptm0`, `ptm1` from PlaneProfile centroids
2. **Connection Direction Vectors**:
   ```cpp
   vecXC0 = vecX0 (corrected to point toward intersection)
   vecXC1 = vecX1 (corrected to point toward intersection)
   vecXCM = (vecXC0 + vecXC1).normalized() // Bisector vector
   ```
3. **Wall Endpoints**:
   ```cpp
   ptEnd0 = ptm0 + vecXC0 * 0.5 * pp0.dX()
   ptEnd1 = ptm1 + vecXC1 * 0.5 * pp1.dX()
   ```

#### Through-Joint Detection

Determines if wall extends completely through the intersection:
```cpp
bIsThrough0 = vecXC0.dotProduct(ptEnd0 - ptm) > 1.5 * dZ1
bIsThrough1 = vecXC1.dotProduct(ptEnd1 - ptm) > 1.5 * dZ0
```
Where `dZ0`, `dZ1` are wall thicknesses (beam widths).

**Through-joint** means one wall's end extends more than 1.5× the other wall's thickness past the intersection point.

#### Alternating Face Detection

```cpp
bOnFace0 = vecXC0.dotProduct(vecZ1) > 0
bOnFace1 = vecXC1.dotProduct(vecZ0) > 0
bHasAlternatingFaces = (bOnFace0 != bOnFace1)
```

This determines if logs connect on alternating faces (one on top surface, one on side surface) vs both on same orientation.

### Tool Application Logic

#### Per Log Course Iteration

For each log course in Wall 0:
1. Get course vertical range: `dYMin` to `dYMax`
2. Create course-height body by extruding wall outline
3. Intersect with connection zone body (`bdx`)
4. Filter logs from both walls that intersect this body
5. Apply tools to filtered logs

#### Dovetail Height Calculation

```cpp
dDovetailHeight = dVisibleHeight * 0.5 - dGap
```

For logs **above** the connection zone top:
```cpp
if (vecY.dotProduct(pt - ptsZ.last()) > dEps)
    doveTailHeight *= 3  // Triple height for overflow logs
```

This creates tapered connection at wall top.

#### Tool Constructor Call

```cpp
TirolerSchloss ts(
    pt,                // Tool origin point
    vecXC0,            // Primary wall direction
    vecXC1,            // Secondary wall direction
    dZ0,               // Primary wall thickness
    dZ1,               // Secondary wall thickness
    dOffsetThis,       // Seat width
    dOffsetOther,      // Seat depth
    doveTailHeight,    // Dovetail height
    dDovetailAngle,    // Flank angle
    dExtraLength,      // Extension length
    nType0             // Tool type constant
);
b.addTool(ts);  // Apply to beam
```

Logs from Wall 1 receive swapped parameters (vecXC1, vecXC0, dZ1, dZ0, dOffsetOther, dOffsetThis, nType1).

### Grip System

#### Grip Array Structure
```
_Grip[0]: Bottom grip, visible along Wall 0 axis (hidden when viewing from Wall 1 face)
_Grip[1]: Bottom grip, visible along Wall 1 axis (hidden when viewing from Wall 0 face)
_Grip[2]: Top grip, visible along Wall 0 axis
_Grip[3]: Top grip, visible along Wall 1 axis
```

#### Grip Creation Logic
```cpp
Grip grip(ptBot);
grip.setShapeType(_kGSTArrow);
grip.setColor(4);  // Cyan
grip.addHideDirection(vecY);   // Hidden from vertical views
grip.addHideDirection(-vecY);

// Bottom grips point downward
grip.setVecX(-vecY);
grip.setVecY(-vecX0);  // or -vecX1 for second grip
```

#### Grip Update Cycle
1. User drags grip → Fires `_kExecuteKey = "_Grip"` recalc trigger
2. Script detects moved grip via `Grip().indexOfMovedGrip(_Grip)`
3. Calculates new height based on grip position projection onto vertical line
4. Updates corresponding `PropDouble` (dBaseHeight or dEndHeight)
5. Updates corresponding paired grip (syncs both wall-oriented grips)
6. Sets `setExecutionLoops(2)` to trigger full recalculation
7. Recalc applies new tools with updated height range

### Connection Removal Logic

When creating a new connection, script checks for existing conflicting connections:

```cpp
String sLogConnectionScripts[] = { "Tirolerschloss", "Klingschrot" };
TslInst tsls[] = el0.tslInstAttached();
for (TslInst& t : tsls) {
    if (t != _ThisInst &&
        sLogConnectionScripts.findNoCase(t.scriptName(), -1) > -1 &&
        t.entity().find(el1) > -1) {
        t.dbErase();  // Remove conflicting connection
    }
}
```

This prevents duplicate connections and automatically replaces Klingschrot joints when applying TirolerSchloss.

---

## Workflow Integration

### Typical Project Workflow

1. **Model Log Walls**
   - Create ElementLog entities using hsbCAD wall tools
   - Define wall paths, heights, log dimensions
   - Set log course parameters (first log height, visible height)

2. **Generate Log Construction** (Optional but Recommended)
   - Trigger log generation to create individual Beam entities
   - Verify log courses are properly distributed
   - Check for conflicts at openings

3. **Apply TirolerSchloss Connections**
   - Launch script, select all corner walls in building
   - Script auto-creates connections at all valid intersections
   - Review plan view for connection symbol placement

4. **Adjust Parameters**
   - Select individual connections
   - Modify Type, Flank Angle, Seat dimensions via Properties Palette
   - Use grips to adjust vertical extent per connection

5. **Handle Special Cases**
   - Use "Remove Logs from Connection" for logs with openings/headers
   - Use "Swap Walls" if primary/secondary wall assignment is incorrect
   - Adjust Vertical Offset for floor level alignment

6. **Generate Construction**
   - Regenerate log beams to apply tools
   - Verify machining operations appear on logs
   - Check for tool conflicts or overlaps

7. **Shop Drawings**
   - TirolerSchloss tools appear in beam detail drawings
   - Machining dimensions exported to production data
   - Assembly sequence considers joint locations

### Integration with Other Scripts

**Automatic Replacement**:
- **Klingschrot**: Automatically removed when TirolerSchloss applied to same corner
- Script detects existing `Klingschrot` instances via `sLogConnectionScripts` array

**Compatible Scripts** (Non-Conflicting):
- **Wall framing tools**: Can coexist with log wall joinery
- **Opening tools**: Work together (use "Remove Logs" to exclude opening headers)
- **Machining tools**: Drill, Cut operations on same logs are compatible
- **Layout tools**: Connection symbols appear in layout views

**Potential Conflicts**:
- **Other log corner joints**: Only one joint type per corner (Klingschrot, TirolerSchloss, etc.)
- **Manual beam cuts**: Hand-placed cuts at same location may overlap with joint tools
- **Floor framing**: Beams at same elevation may interfere (use Vertical Offset to shift)

---

## Advanced Techniques

### 1. Variable Height Connections for Gable Walls

When working with gable end walls where log lengths decrease with height:

```
Strategy: Use explicit End Height values
1. Measure the height where gable taper begins (e.g., 2400 mm)
2. Set End Height = 2400 mm for that connection
3. Connection stops before taper, avoiding logs of inconsistent length
4. For upper gable portion, consider not using corner joints or use different type
```

### 2. Multi-Story Connections

For buildings with multiple floors:

```
Approach: Create separate connection instances per floor
1. Ground Floor: Base Height = 0, End Height = 3000 mm (floor 1 ceiling)
2. Second Floor: Base Height = 3000 mm, End Height = 6000 mm
3. Adjust Vertical Offset per floor if floor structures vary in thickness
4. Different joint types per floor are possible (e.g., Convex ground, Diagonal upper)
```

### 3. Prefabrication Assembly Sequence

When planning shop fabrication:

```
Technique: Selective log exclusion for crane rigging
1. Identify logs that need attachment points for lifting
2. Use "Remove Logs from Connection" on corner logs designated for rigging
3. Those logs remain full-length for hardware attachment
4. Field-cut the notch after assembly (or use mechanical fasteners)
```

### 4. Handling Acute Angles (< 60°)

For walls meeting at sharp angles:

```
Challenge: Dovetail geometry becomes distorted at acute angles
Workaround Options:
a) Increase Seat Width/Depth to create more bearing surface
b) Reduce Flank Angle to 4-6° for easier geometry
c) Switch to Diagonal type (simpler 45° chamfer)
d) Consider post-and-beam connection instead of log-to-log
```

### 5. Thermal Break Integration

For energy-efficient log construction:

```
Method: Use Gap parameter for insulation
1. Set Gap = 10-15 mm
2. Dovetail height reduces proportionally, maintaining interlock
3. During assembly, insert closed-cell foam tape into gap
4. Provides thermal break at corner (traditional weak point)
5. Compression of foam fills gap, maintains weather seal
```

### 6. Mixed Wall Thickness Corners

When corner walls have different thicknesses (e.g., 200mm exterior, 150mm interior):

```
Automatic Handling: Script adapts to thickness difference
1. Script uses dZ0, dZ1 (wall thicknesses) independently
2. Tool geometry calculates correct offset for each wall
3. Verify Seat Width/Depth are appropriate for thinner wall
4. Check that through-joint detection is correct (may need Swap Walls)
```

### 7. Catalog Presets for Repetitive Projects

If you build multiple similar log structures:

```
Workflow:
1. Configure ideal parameters for one connection
2. Right-click → "Save as Catalog Entry" (via TslInst catalog system)
3. Name preset (e.g., "200mm_Convex_8deg")
4. Future insertions: Specify catalog key via _kExecuteKey
5. Script applies preset parameters automatically, skipping dialog
```

---

## Troubleshooting

### Issue: "Could not detect connection type between elements W1/W2"

**Cause**: Walls do not have valid intersection geometry.

**Diagnosis**:
- Check if walls are parallel or nearly parallel (use `vecX0.isParallelTo(vecX1)` test)
- Verify wall outlines actually overlap in plan view
- Ensure intersection area > 4 mm²

**Solutions**:
1. Rotate one wall slightly if truly parallel
2. Extend wall paths to ensure overlap
3. Verify walls are at same elevation (Z-base)
4. Check that PlaneProfile outlines are valid (not null)

### Issue: No logs receive machining tools

**Symptom**: Connection displays symbol and zone, but logs are not notched.

**Diagnosis**:
- Walls have valid intersection, but beams not generated
- Beams exist but outside connection height range
- All beams were manually excluded via "Remove Logs"

**Solutions**:
1. Generate log construction on both walls (trigger element regeneration)
2. Adjust Base Height and End Height to encompass log courses
3. Use "Restore all logs of Connection" if logs were excluded
4. Check that LogCourse data is valid (`el.logCourses().length() > 0`)

### Issue: Tools appear on wrong wall's logs

**Symptom**: Wall A logs are notched, but Wall B logs should be notched instead.

**Cause**: Primary/secondary wall determination was incorrect (based on first log height comparison).

**Solution**:
- Right-click connection → "Swap Walls"
- Or double-click the connection
- Walls swap roles, tools recalculate

### Issue: Grips not visible in 3D view

**Symptom**: Connection selected, but no grips appear.

**Diagnosis**: Grips are view-direction dependent (hidden when viewing from certain angles).

**Solutions**:
1. Rotate view perpendicular to one of the walls
2. Each grip is hidden when viewing **from** its wall face direction
3. Bottom grips hidden from +Y and -Y (vertical views)
4. Try orthogonal views: Front, Back, Left, Right

### Issue: Connection zone too short (only one log course)

**Symptom**: Only bottom course receives tools.

**Diagnosis**: End Height set too low, or automatic detection failed.

**Solutions**:
1. Check End Height value in Properties (should be 0 for auto, or large value like 3000)
2. If value is small (e.g., 300), set to 0 for automatic detection
3. Use top grips to drag connection zone upward
4. Verify that `ptsZ` array detection found correct wall extremes

### Issue: "Seat Depth" parameter label not changing to "Tapering"

**Symptom**: Type is Diagonal, but label still shows "Seat Depth".

**Cause**: Property label is dynamically set on recalc, may not update immediately in dialog.

**Solution**:
- Close and reopen Properties Palette
- Label updates during script execution, not interactively
- Functionality is correct even if label doesn't update in dialog

### Issue: Negative seat values not creating additional cuts

**Symptom**: Set Seat Width = -50, but no extra beam cut appears.

**Diagnosis**: Negative seat values force additional cuts only for **non-through joints** (Convex/Concave types, not Through or Diagonal).

**Verification**:
```cpp
// Additional cuts only applied in non-through conditions:
if (!bIsThrough0)
    bd0.addTool(Cut(...), 0);
```

**Solutions**:
1. Verify joint is not Through-type (check `bIsThrough0`, `bIsThrough1` flags)
2. For Through-joints, negative seat values may not apply additional cuts
3. Use Diagonal type with positive Tapering value instead

### Issue: Joints too tight during assembly

**Symptom**: Logs won't slide together; joint binds.

**Cause**: Flank Angle too aggressive, or no assembly clearance.

**Solutions**:
1. Reduce Flank Angle from 8° to 6° (gentler taper)
2. Increase Gap to 2-3 mm (provides clearance)
3. Check for manufacturing tolerance issues (CNC accuracy)
4. Consider adding assembly taper to log ends (separate machining)

### Issue: Joints too loose (logs rattle)

**Symptom**: Assembled logs have play at joint.

**Cause**: Flank Angle too shallow, or Gap too large.

**Solutions**:
1. Increase Flank Angle from 8° to 10-12° (more aggressive)
2. Reduce or eliminate Gap (set to 0)
3. Verify CNC machining tolerances (may be cutting oversize)
4. Check wood moisture content (swelling/shrinking affects fit)

---

## Tips and Best Practices

### Design Phase

1. **Plan Corners Early**: Consider corner joint type during wall layout. TirolerSchloss works best at right angles (90°) or moderate angles (60-120°).

2. **Consistent Log Heights**: Use uniform visible log heights across all walls. Variable heights complicate connection zone calculation.

3. **Half-Log Starter Course**: Properly define the first log height (`dFirstLog`). Script uses this to determine wall priority.

4. **Opening Coordination**: Place window/door openings away from corners. If corner conflicts occur, plan to exclude those logs.

### Parameter Selection

5. **Start with Defaults**: For initial pass, use default parameters (Type=Convex, Flank=8°, Seats=0). Adjust after reviewing results.

6. **Flank Angle by Species**:
   - **Softwoods (Pine, Spruce)**: 6-8° (softer wood compresses, gentler angle)
   - **Hardwoods (Oak, Ash)**: 8-10° (harder wood resists compression)

7. **Gap for Moisture**: If logs will be installed with >18% moisture content, add 3-5mm Gap to allow for shrinkage.

8. **Seat Dimensions**: Match seat width to expected bearing loads. Larger seats for heavy roofs, smaller for decorative log walls.

### Batch Processing

9. **Select All Walls at Once**: Instead of placing connections one-by-one, window-select entire building. Script finds all corners automatically.

10. **Review in Plan View First**: After batch creation, orbit to plan view and verify all expected corners have symbols.

11. **Standardize Before Adjusting**: If most connections need same parameter change, modify one, save as catalog preset, delete all, reapply with preset.

### Assembly Planning

12. **Assembly Sequence Awareness**: Use "Remove Logs from Connection" strategically to allow certain logs to be placed last (for crane access, MEP coordination).

13. **Document Exceptions**: Maintain list of excluded logs (which beams were removed from which connections) for shop floor reference.

14. **Test Assembly**: For critical projects, consider 3D printing or physical mockup of corner joint before full production.

### Quality Control

15. **Visual Inspection**: After regenerating logs, use 3D section views to inspect joint geometry. Look for overlapping tools or incomplete cuts.

16. **Measure Tool Depths**: Verify that dovetail height is appropriate for log thickness (typically 0.3-0.5× log height).

17. **Check All Corners**: Don't assume symmetrical building has symmetrical joints. Different wall thicknesses or log patterns may produce different geometries.

### Performance

18. **Disable Hidden Line Display**: The script has isometric projection code disabled (`if (0)`) - leave it disabled for performance.

19. **Limit Execution Loops**: Script uses `setExecutionLoops(2)` during updates. Don't manually increase this - trust the script's calculation.

20. **Batch Edits**: If changing same parameter on many connections, use Properties Palette with multiple selection (select all connections → change value once).

---

## Examples

### Example 1: Standard Right-Angle Corner

**Scenario**: Two 200mm thick log walls meeting at 90°, standard 150mm log height.

**Parameters**:
```
Base Height:      0 mm (start at foundation)
End Height:       0 mm (auto-detect to wall top)
Vertical Offset:  0 mm (no adjustment needed)
Gap:              0 mm (dry assembly)
Flank Angle:      8° (standard)
Seat Width:       0 mm (no seat cut)
Seat Depth:       0 mm (no seat cut)
Type:             Convex (traditional Tyrolean)
```

**Result**: Clean dovetail interlock from foundation to wall top, rounded convex profile at exterior corner.

---

### Example 2: Gable End with Height Limit

**Scenario**: East wall (full height 3000mm) meets south gable wall (decreases above 2400mm).

**Parameters**:
```
Base Height:      0 mm
End Height:       2400 mm (explicit - stop before gable taper)
Vertical Offset:  0 mm
Gap:              0 mm
Flank Angle:      8°
Seat Width:       0 mm
Seat Depth:       0 mm
Type:             Convex
```

**Result**: Connection stops at 2400mm. Logs above this height (in gable taper zone) are not notched, allowing variable-length logs.

---

### Example 3: Floor Level Alignment

**Scenario**: Structural floor slab is 150mm thick. Logs start at elevation 0, but finished floor is at +150mm.

**Parameters**:
```
Base Height:      0 mm (log base)
End Height:       0 mm (auto)
Vertical Offset:  +150 mm (shift joint up to finished floor)
Gap:              0 mm
Flank Angle:      8°
Seat Width:       0 mm
Seat Depth:       0 mm
Type:             Convex
```

**Result**: First notch appears at finished floor level (+150mm), not at foundation. Visually cleaner corner above floor.

---

### Example 4: Thermal Break Integration

**Scenario**: Energy-efficient log home in cold climate. Need insulation at corner joint.

**Parameters**:
```
Base Height:      0 mm
End Height:       0 mm
Vertical Offset:  0 mm
Gap:              15 mm (space for closed-cell foam tape)
Flank Angle:      6° (reduced for easier assembly with insulation)
Seat Width:       0 mm
Seat Depth:       0 mm
Type:             Concave (inward profile - less exterior exposure)
```

**Assembly**: Insert 15mm thick × 50mm wide foam tape into gap during log stacking. Compression of foam fills gap, provides thermal break.

**Result**: Insulated corner joint with reduced thermal bridging.

---

### Example 5: Mixed Wall Thickness

**Scenario**: 200mm exterior wall meets 150mm interior wall.

**Parameters**:
```
Base Height:      0 mm
End Height:       0 mm
Vertical Offset:  0 mm
Gap:              0 mm
Flank Angle:      8°
Seat Width:       30 mm (primary wall - adds bearing support)
Seat Depth:       20 mm (secondary wall - proportional)
Type:             Convex
```

**Process**:
1. Script auto-detects wall thicknesses (dZ0=200, dZ1=150)
2. May need to use "Swap Walls" to ensure thicker wall is primary
3. Seat cuts provide additional bearing surface on both walls
4. Through-joint detection handles asymmetry

**Result**: Stable joint despite thickness difference.

---

### Example 6: Diagonal Modern Aesthetic

**Scenario**: Contemporary log home with simplified joinery for CNC efficiency.

**Parameters**:
```
Base Height:      0 mm
End Height:       0 mm
Vertical Offset:  0 mm
Gap:              0 mm
Flank Angle:      8° (still used internally)
Seat Width:       0 mm
Seat Depth/Tapering: 50 mm (controls diagonal taper distance)
Type:             Diagonal
```

**Result**: Simple 45° chamfer at corner instead of rounded dovetail. Faster CNC machining, modern clean appearance.

---

## Related Scripts

### Direct Alternatives

**Klingschrot**
- **Relationship**: Alternative log corner joint type from Klingschrot tradition
- **Difference**: Different geometric profile and machining approach
- **Conflict**: Automatically removed when TirolerSchloss is applied to same corner
- **Use Case**: Choose one or the other based on structural requirements or regional tradition

### Complementary Tools

**ElementLog Creation Tools**
- **Purpose**: Create the log wall elements that TirolerSchloss connects
- **Workflow**: Run before TirolerSchloss
- **Integration**: TirolerSchloss reads ElementLog geometry directly

**Log Generation Tools**
- **Purpose**: Populate ElementLog with individual Beam entities (logs)
- **Workflow**: Can run before or after TirolerSchloss (script adapts)
- **Integration**: TirolerSchloss applies tools to generated beams

**Opening/Window Tools**
- **Purpose**: Create door and window openings in log walls
- **Conflict Potential**: Openings near corners may conflict with joint
- **Solution**: Use "Remove Logs from Connection" to exclude header/sill logs

**Machining Tools** (Drill, Cut, Mortise, etc.)
- **Purpose**: Additional fabrication operations on logs
- **Compatibility**: Fully compatible - multiple tools can exist on same beam
- **Integration**: TirolerSchloss tools combine with other tools in fabrication output

### Workflow Scripts

**Shop Drawing Scripts**
- **Purpose**: Generate fabrication drawings with dimensions
- **Integration**: TirolerSchloss tool geometry appears in beam detail drawings
- **Data Flow**: Tool parameters exported to CNC/production systems

**Assembly Sequence Tools**
- **Purpose**: Plan log stacking order
- **Consideration**: Joint locations affect lifting points and assembly sequence
- **Integration**: Assembly scripts can query TirolerSchloss instances to plan sequence

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| **1.1** | 07.06.2023 | • Plan display unified across view modes<br>• Connection replacement now detects and removes Klingschrot joints<br>• HSB-17520 | Thorsten Huck |
| **1.0** | 25.05.2023 | • Initial release of Tyrolean lock connection script<br>• Supports Convex, Concave, Diagonal types<br>• Interactive grip system for height adjustment<br>• Automatic wall pair detection and batch processing<br>• HSB-17520 | Thorsten Huck |

---

## Technical Specifications

### File Information
- **Filename**: `TirolerSchloss.mcr`
- **Script Type**: O-Type (Object)
- **Version**: 8 (TSL format version)
- **File State**: 1 (Production)
- **DXA Output**: Enabled (1)
- **Implementation Insert**: Enabled (1)

### System Requirements
- **hsbCAD Version**: Compatible with v8 format
- **AutoCAD Platform**: Requires ACIS solid modeling
- **Element Types**: Requires ElementLog support
- **Tool System**: Requires TirolerSchloss tool class

### Performance Characteristics
- **Execution Loops**: 2 (set during parameter updates)
- **Grip Count**: 4 (2 bottom, 2 top)
- **Display Objects**: 3 (dpPlan, dpModel, dpText)
- **Recalc Triggers**: 4 (Grip drag, Swap, Remove logs, Restore logs)

### Data Storage
- **Map Keys**:
  - `"mode"` (int): Execution mode (1=distribution, 2=wall-wall)
  - `"swap"` (int): Wall swap state (0=default, 1=swapped)
  - `"Log[]"` (entity array): Excluded beams
  - `"ptsZ"` (Point3d array): Previous grip positions

### Geometric Constraints
- **Minimum Intersection Area**: 4 mm² (U(2)²)
- **Minimum Connection Height**: dVisibleHeight (one log course)
- **Epsilon Tolerance**: 0.1 mm (dEps)
- **Maximum Wall Angle Deviation**: Not parallel (tested via `isParallelTo()`)

---

## Summary

**TirolerSchloss** brings traditional Alpine log joinery into modern parametric CAD. By automating the complex geometric calculations required for Tyrolean lock joints, it enables:

- **Accurate Fabrication**: CNC-ready machining operations on every affected log
- **Design Flexibility**: Three profile types, adjustable parameters, interactive editing
- **Batch Efficiency**: Process entire building corners in single operation
- **Assembly Planning**: Selective log exclusion for rigging and MEP coordination
- **Quality Control**: Visual feedback in plan and 3D views

Whether you're building traditional log homes or modern timber structures, this script provides the precision and flexibility needed for world-class corner joinery.

---

*Documentation generated for TirolerSchloss.mcr v1.1 (07.06.2023)*
*Script Size: 194 KB | Documentation Size: ~30 KB*
*TSL Knowledge Base Project - hsbCAD Timber Construction System*
