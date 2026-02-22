# Sihga PICK Wall

## Overview

The **Sihga PICK Wall** script is a specialized lifting device placement tool for Stickframe wall elements in hsbCAD. It automates the engineering and installation planning of SIHGA PICK lifting hardware systems, ensuring that wall panels can be safely lifted and positioned during construction.

This tool performs sophisticated structural analysis by:
- Calculating the wall's center of gravity using all beams, sheets, and attached hardware
- Intelligently distributing 1, 2, or 4 lifting attachment points based on the wall geometry
- Validating lifting capacity against SIHGA PICK manufacturer load tables (8 different hardware size categories)
- Ensuring lifting angles remain within safe ranges (minimum 45° from vertical)
- Automatically drilling Ø50mm holes in top plates and creating CNC no-nail zones
- Providing real-time visual feedback with dimensioned lifting belt and chain geometry

### Key Benefits

- **Safety validation**: Prevents unsafe lifting configurations by cross-referencing element weight against manufacturer-certified load capacities
- **Automated geometry**: Eliminates manual calculation of belt lengths, spreader bar dimensions, and lifting angles
- **CNC-ready output**: Automatically creates drills and no-nail zones compatible with Weinmann production lines
- **Multi-configuration support**: Handles simple 1-point lifts through complex 4-point systems with spreader bars or hanger chains
- **Interactive adjustment**: Drag-and-drop grip points with automatic snapping to valid positions

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) - Attaches to wall elements |
| **TSL Version** | 1.4 (November 7, 2017) |
| **Author** | florian.wuermseer@hsbcad.com |
| **Beams Required** | 0 (element-based selection) |
| **Grip Points** | Variable (0 to 4 depending on configuration) |
| **CNC Output** | Enabled (`#DxaOut 1`) |
| **Multiple Insertion** | Supported (batch wall selection) |
| **Catalog Support** | Yes (parameter sets can be saved) |
| **Keywords** | Lifting Device, Center of Gravity |

## Usage Environment

| Environment | Supported | Usage Pattern |
|-------------|-----------|---------------|
| **Model Space** | ✓ Yes | Primary workspace - all calculations, geometry generation, and visual validation occur here |
| **Paper Space** | ✗ No | Not applicable - this is a manufacturing/erection tool |
| **Shop Drawing** | ✗ No | Drills are exported to CNC, but visualization is model-only |

## Prerequisites and Dependencies

### Required Elements

1. **Wall Elements**: At least one `ElementWallSF` (Stickframe Wall) must exist in the drawing
2. **Top Plate Beams**: Each wall must have horizontal plate beams (hsbId: "4", "3", or "5") at the top edge
3. **Minimum Plate Dimensions**:
   - Height ≥ 60mm
   - Width ≥ 80mm
   - If smaller, the script will abort with an error message

### Required Helper Scripts

| Script Name | Purpose | Failure Behavior |
|-------------|---------|------------------|
| `hsbCenterOfGravity` | Calculates the 3D center of gravity and total weight of the wall element (all beams, sheets, and hardware) | Script displays detailed error message and deletes itself if missing |

**Important**: Ensure `hsbCenterOfGravity.mcr` is either:
- Loaded into the current drawing, or
- Available in the standard TSL search path (Company or Install directories)

### Structural Requirements

- **Vertical studs**: Wall must contain vertical members to establish distribution boundaries
- **Top plate continuity**: The top plate beam must be continuous across the lifting zone (minimum 500mm margin from wall edges)
- **Plate beam alignment**: All lifting points are projected onto the top-most horizontal beam(s) detected by ray-casting from the calculated center of gravity

## Step-by-Step Usage

### Step 1: Launch the Script

**Method A: Catalog Entry (Silent Mode)**
```
Command: [TSL Insert Command]
Select catalog entry: "Sihga PICK Wall - [Configuration Name]"
```
If a pre-saved catalog entry name matches, parameters load automatically without dialog.

**Method B: Interactive Mode**
```
Command: [TSL Insert Command]
Script name: Sihga PICK Wall
```
Parameter dialog appears for configuration before wall selection.

### Step 2: Configure Lifting Parameters (Interactive Mode Only)

The configuration dialog presents all parameters organized by category:

**Distribution Settings**
- Quantity: Select lifting configuration (1, 2, 4, 4+Traverse, 4+Chains)
- Belt Length: Total sling length (affects maximum point spacing)
- Interdistance: Target spacing between lifting points
- Chain/Traverse Length: Hardware for 4-point configurations

**Tooling Options**
- Weinmann CNC Tools: Enable/disable no-nail zone generation

### Step 3: Select Wall Elements

```
Command prompt: Select wall(s)
```

**Selection Tips**:
- You can select multiple walls in a single operation
- Each wall receives its own independent lifting device instance
- The script processes walls sequentially after selection completes
- Invalid selections (non-wall elements) are ignored

**Example Output**:
```
3 Wall(s) selected
Processing Element #101...
Processing Element #102...
Processing Element #103...
```

### Step 4: Automatic Validation

After insertion, the script performs immediate validation:

1. **Center of Gravity Calculation**: Calls `hsbCenterOfGravity` to analyze the complete wall assembly
2. **Weight Check**: Retrieves total element weight (displayed in Properties Panel)
3. **Geometry Analysis**: Identifies top plate beams and vertical studs
4. **Distribution Area Calculation**: Determines valid placement zones (excluding end margins and stud boundaries)
5. **Lifting Angle Calculation**: Computes actual belt angles at each point
6. **Load Capacity Validation**: Cross-references weight and angle against SIHGA PICK load tables

### Step 5: Review Visual Feedback

**Normal Operation (Safe Configuration)**:
- Green/gray lifting belts drawn from attachment points to crane hook
- Blue traverse bars or hanger chains (4-point modes)
- Belt length labels: `"L=2000 mm"` or `"Continuous belt 1 L=2000 mm"`
- 3D visualization of SIHGA PICK hardware at each point

**Warning Conditions**:
- **Red warning text** appears at lifting points
- Labels change to: `"!!! Attention !!!"`
- Command line messages explain the specific issue:
  - `"The load is too heavy for [N] Lifting points"`
  - `"The lifting angle at this point is out of range"`
  - `"The lifting angle at this point (XX.X°) is too flat to carry the load!!!"`

### Step 6: Adjust Parameters if Needed

If warnings appear, modify parameters in the AutoCAD Properties Palette (OPM):

**Common Adjustments**:

| Problem | Solution |
|---------|----------|
| Load too heavy | Increase Quantity (e.g., 2 → 4 points) |
| Angle too shallow | Increase Belt Length or decrease Interdistance |
| Points outside wall | Script auto-corrects, but check command line for corrected values |
| Angle > 45° | Script auto-corrects Interdistance, verify new spacing |

**Auto-Correction Examples**:
```
Distance corrected to 1414.2 --> min. lifting belt angle = 45°
Interdistance adjusted to 2400 (wall geometry constraint)
```

### Step 7: Manual Grip Point Adjustment (Optional)

The script creates draggable grip points (`_PtG`) for each lifting attachment:

**How to Use Grips**:
1. Select the Sihga PICK Wall instance
2. Blue grip squares appear at each lifting point
3. Drag grip along the top plate
4. Script automatically snaps to valid positions:
   - Projects to top plate centerline
   - Keeps 250mm minimum from plate ends
   - Stays within outermost stud boundaries
   - Respects distribution area boundaries

**Recalculation**: Every grip move triggers full recalculation (geometry, angles, load validation).

### Step 8: Verify CNC Tooling (If Weinmann Tools Enabled)

When "Apply Weinmann Tools" = Yes:

**What Happens**:
- `ElemNoNail` zones created at each lifting point
- Zone width = Ø50mm (drill diameter)
- Zone length = Full plate beam width
- Applied to **both wall zones** (front and back faces)
- Prevents CNC nailers from placing fasteners through hardware slots

**Verification**:
- No visual confirmation in model space
- Check Element properties or run Weinmann export to verify no-nail data

## Properties Panel (OPM) Reference

### Distribution Category

#### (A) - Quantity
| Setting | Behavior | Use Case |
|---------|----------|----------|
| **1** | Single central lifting point at center of gravity | Small panels, narrow walls (<1000mm), temporary rigging |
| **2** | Two symmetric points along horizontal axis | Standard wall panels, most common configuration |
| **4** | Four points in rectangular pattern | Large, heavy walls, high load capacity needed |
| **4 + Traverse** | Four points connected via spreader bar | Prevents panel compression, maintains square geometry during lift |
| **4 + Hanger Chains** | Four points converging to single crane hook via chains | Single-hook crane, simplified rigging |

**Parameter Type**: String (dropdown selection)
**Default**: "2"
**Index**: 1 (second option in list)

**Internal Mapping**:
```
sQuants[] = {"1", "2", "4", "4 + Traverse", "4 + Hanger Chains"}
nQuants[] = {1, 2, 4, 4, 4}  // Actual point count
```

#### (B) - Lifting Belt Length

**Purpose**: Defines the total length of each lifting sling/belt from attachment point to crane hook.

**Parameter Type**: PropDouble (millimeters)
**Default**: 2000 mm
**Range**: Positive values, typically 1500-4000 mm

**How It Affects Distribution**:

For **2-point** configuration:
```
Maximum Interdistance = Belt Length × cos(45°) × 2
                     = 2000 × 0.707 × 2
                     = 2828 mm
```

For **4-point** configuration:
```
Maximum Interdistance = Belt Length × cos(45°)
                     = 2000 × 0.707
                     = 1414 mm
```

**Auto-Correction Logic**:
If the user enters an Interdistance that would produce a belt angle less than 45°, the script automatically reduces the Interdistance and prints:
```
Distance corrected to [value] --> min. lifting belt angle = 45°
```

**Practical Guidelines**:
- Shorter belts (1500-2000mm): Better for low-clearance sites, steeper angles
- Longer belts (2500-4000mm): Allow wider point spacing, shallower angles (but watch load limits)

#### (C) - Interdistance of Lifting Points

**Purpose**: Target horizontal spacing between adjacent lifting points measured along the wall's X-axis.

**Parameter Type**: PropDouble (millimeters)
**Default**: 1000 mm
**Range**: Positive values, script-enforced maximum based on:
1. Belt length geometric constraint (45° minimum angle)
2. Wall physical length (500mm end margins)
3. Outermost stud positions
4. Top plate beam span

**Multi-Layer Constraint System**:

```
Max Interdistance = MIN(
    Geometric_Limit,    // From belt length (45° angle)
    Wall_Length_Limit,  // Physical wall - 500mm margins
    Plate_Span_Limit    // Top plate end-to-end - 250mm margins
)
```

**Examples**:

| Configuration | Belt Length | Wall Length | Max Interdistance |
|---------------|-------------|-------------|-------------------|
| 2 points | 2000mm | 3000mm | 2000mm (wall limit) |
| 2 points | 2000mm | 4000mm | 2828mm (geometric) |
| 4 points | 2000mm | 3000mm | 1000mm (wall limit) |
| 4 points | 3000mm | 6000mm | 2121mm (geometric) |

**Auto-Correction Messages**:
```
Interdistance adjusted to [value] (wall geometry constraint)
Distance corrected to [value] --> min. lifting belt angle = 45°
```

#### (D) - Chain / Traverse Length

**Purpose**: Defines the length of the spreader bar (traverse) or hanger chains used in 4-point configurations.

**Parameter Type**: PropDouble (millimeters)
**Default**: 2000 mm
**Applies To**: "4 + Traverse" and "4 + Hanger Chains" modes only
**Ignored For**: 1, 2, and standard 4-point modes

**4 + Traverse Mode**:
- Horizontal spreader bar connects two belt apex points
- Total traverse length spans between the two belt convergence points
- Creates a rigid lifting frame preventing panel compression

**Geometry**:
```
Left Pair: Belts converge at point TL (left traverse end)
Right Pair: Belts converge at point TR (right traverse end)
Traverse: Horizontal bar from TL to TR with length = Chain/Traverse Length
```

**4 + Hanger Chains Mode**:
- All four belts meet at individual apex points (L and R)
- Hanger chains run from each apex to a single central crane hook
- Chain length determines vertical separation between belt apex and crane hook

**Geometry**:
```
Left Pair: Belts converge at apex L
Right Pair: Belts converge at apex R
Chain L: From apex L to crane hook (length = Chain/Traverse Length)
Chain R: From apex R to crane hook (length = Chain/Traverse Length)
Final: Both chains meet at single crane hook point
```

**How It Affects Load Angles**:
- Longer traverse/chains → Higher crane hook → Steeper belt angles → Better load capacity
- Shorter traverse/chains → Lower crane hook → Shallower belt angles → Reduced capacity

**Practical Guidelines**:
- Traverse mode: Match traverse length to wall width for balanced geometry
- Hanger chain mode: Use 1500-2500mm for standard crane hook heights
- Ensure crane hook height accommodates traverse/chain length + belt geometry

#### (E) - Apply Weinmann Tools

**Purpose**: Controls whether CNC no-nail zones are automatically created around lifting hardware.

**Parameter Type**: String (dropdown: "No" / "Yes")
**Default**: "No"
**Affects**: CNC output only, no visual change in model

**When "Yes"**:
1. Script creates `ElemNoNail` objects at each lifting point
2. Zone rectangle:
   - Width: Ø50mm (drill diameter)
   - Length: Full plate beam width (variable)
   - Depth: Through-thickness
3. Applied to **both wall zones** (Zone +1 and Zone -1)
4. Zones move with grip points if repositioned

**CNC Integration**:
- Weinmann multifunction bridge systems read no-nail data from hsbCAD export
- Nailing heads automatically skip these zones during production
- Prevents fasteners from interfering with SIHGA PICK hardware slots

**When to Enable**:
- ✓ Walls will be manufactured on Weinmann CNC lines
- ✓ Automated nailing process is used
- ✗ Manual nailing (operator will avoid hardware visually)
- ✗ Non-Weinmann production equipment

### Information Category (Read-Only)

#### Element Weight

**Display Format**: "[value] kg"
**Example**: "1247 kg"
**Source**: Calculated by `hsbCenterOfGravity` helper script
**Update Frequency**: Every recalculation cycle

**What's Included in Weight Calculation**:
- All beams (studs, plates, headers, blocking)
- All sheets (sheathing, gypsum, exterior cladding)
- All attached TSL instances (hardware, fasteners, other devices)
- Material density from hsbCAD material database

**Precision**: Rounded to nearest 1 kg

**Usage**: This value is cross-referenced against SIHGA PICK load tables to validate lifting safety. See "Load Capacity Validation" section for details.

## Load Capacity Validation System

### SIHGA PICK Load Cases (Hardware Size Selection)

The script automatically selects the correct SIHGA PICK hardware size based on top plate beam dimensions:

| Case | Min Height | Max Height | Min Width | Max Width | Load Capacity Range* |
|------|------------|------------|-----------|-----------|---------------------|
| 0 | 60mm | 79mm | 80mm | 99mm | 431-1012 kg (per device) |
| 1 | 60mm | 79mm | 100mm | 139mm | 924-1246 kg |
| 2 | 60mm | 79mm | 140mm | ∞ | 1370-1800 kg |
| 3 | 80mm | 99mm | 100mm | 139mm | 942-1320 kg |
| 4 | 80mm | 99mm | 140mm | ∞ | 1370-1800 kg |
| 5 | 100mm | ∞ | 80mm | 99mm | 956-1320 kg |
| 6 | 100mm | ∞ | 100mm | 119mm | 990-1654 kg |
| 7 | 100mm | ∞ | 120mm | ∞ | 990-1740 kg |

*Range: from 45° lifting angle (minimum capacity) to 0° vertical (maximum capacity)

**Selection Logic**:
```
if (plate_height >= 100mm) {
    if (plate_width >= 120mm) → Case 7
    else if (plate_width >= 100mm) → Case 6
    else if (plate_width >= 80mm) → Case 5
    else → ERROR (plate too small)
}
else if (plate_height >= 80mm) {
    if (plate_width >= 140mm) → Case 4
    else if (plate_width >= 100mm) → Case 3
    else if (plate_width >= 80mm) → Case 0
    else → ERROR
}
else if (plate_height >= 60mm) {
    if (plate_width >= 140mm) → Case 2
    else if (plate_width >= 100mm) → Case 1
    else if (plate_width >= 80mm) → Case 0
    else → ERROR
}
else → ERROR (plate too small)
```

### Load Tables (Angle-Dependent Capacity)

Each SIHGA PICK case has a load table defining maximum allowable weight per device at different lifting angles:

**Example: Case 2 (60-79mm height, ≥140mm width)**

| Angle from Vertical | Max Load per Device |
|---------------------|---------------------|
| 0° (vertical belt) | 1800 kg |
| 5° | 1752 kg |
| 10° | 1704 kg |
| 15° | 1657 kg |
| 20° | 1609 kg |
| 25° | 1561 kg |
| 30° | 1513 kg |
| 35° | 1466 kg |
| 40° | 1418 kg |
| 45° | 1370 kg |

**Total Configuration Capacity**:
```
Total_Max_Load = (Load_per_Device) × (Number_of_Points) / 2

Example: 4 points at 20° angle using Case 2
= 1609 kg × 4 / 2
= 3218 kg total capacity
```

### Warning Conditions

The script evaluates three failure modes:

#### Warning 1: Overload at Any Angle
**Condition**: Element weight exceeds maximum capacity even with vertical belts (0° angle)

**Message**:
```
The load is too heavy for [N] Lifting points
```

**Cause**: Too few lifting points or hardware case too small for element weight

**Solutions**:
- Increase Quantity (e.g., 2 → 4 points)
- Verify top plate dimensions (larger plate → higher case number → more capacity)
- Consider splitting wall into lighter sections

#### Warning 2: Angle Out of Range
**Condition**: Lifting angle exceeds 45° from vertical

**Message**:
```
The lifting angle at this point is out of range
```

**Cause**:
- Interdistance too large for the belt length
- Grip points manually moved too far apart

**Solutions**:
- Increase Belt Length
- Decrease Interdistance
- Script usually auto-corrects this before it occurs

#### Warning 3: Angle Too Shallow for Load
**Condition**: Element weight exceeds allowable load at the calculated lifting angle

**Message**:
```
The lifting angle at this point (XX.X°) is too flat to carry the load!!!
```

**Example**: Wall weighs 2500 kg, using 4 points (Case 2), actual angle is 35°
```
Max load at 35° = 1466 kg/device × 4 / 2 = 2932 kg
Element weight = 2500 kg → OK

But if angle increases to 40°:
Max load at 40° = 1418 kg/device × 4 / 2 = 2836 kg
Element weight = 2500 kg → Still OK

At 45°:
Max load at 45° = 1370 kg/device × 4 / 2 = 2740 kg
Element weight = 2500 kg → Still OK

At 50° (hypothetical):
Exceeds 45° limit → Out of range warning
```

**Solutions**:
- Increase Belt Length (steeper angle)
- Decrease Interdistance (steeper angle)
- Add more lifting points

### Visual Warning Indicators

When any warning condition is active:

**Model Space View**:
- Red text at each lifting point: `"!!! Attention !!!"`
- Red text at wall center of gravity: `"Attention, the load is out of range for this lifting situation"`
- All belt/chain labels replaced with warning message
- Display color changes to red (Color 1)

**Plan View (_ZW direction)**:
- Red warning text at each lifting point
- Visible when looking down from above

**Command Line**:
```
Element 101 - 'SIHGA Pick Wall' TSL  -->  Attention, the load is out of range for this lifting situation!!!
```

## Applied Tooling

### Drill Operations

**Specification**:
- **Diameter**: Ø50mm (constant, defined as `dDiamMain`)
- **Depth**: Through-thickness (infinite drill, full penetration)
- **Orientation**: Perpendicular to top plate face (along plate's local Y-axis)
- **Quantity**: 1 drill per lifting point
- **Applied To**: Top plate beam only (beams with hsbId "3", "4", or "5")

**Drill Location**:
```
Drill center = Lifting attachment point
Drill axis = Plate beam's depth direction (perpendicular to face)
Start point = 1000mm above top face (construction point)
End point = 1000mm below bottom face (construction point)
```

**CNC Export**:
- Drills are exported to CNC output files (`#DxaOut 1` flag enabled)
- Weinmann and other CNC systems recognize these as tool operations
- Drill appears in hsbCAD drill lists and shop drawings

**Purpose**: Creates the slot through which the SIHGA PICK device is inserted during wall assembly.

### No-Nail Zones (Optional)

**When Applied**: Only if "(E) - Apply Weinmann Tools" = "Yes"

**Specification**:
- **Type**: `ElemNoNail` (element-level no-nail zone)
- **Shape**: Rectangle
- **Dimensions**:
  - Width: Ø50mm (matches drill diameter)
  - Length: Full plate beam width (variable, measured along plate's local X-axis)
- **Quantity**: 2 zones per lifting point (one per wall face)
- **Zones**: Applied to both Zone +1 (front) and Zone -1 (back)

**Geometry Definition**:
```
Rectangle corners (local coordinates):
Top-left:     Point + plateX × (Ø50/2)
Top-right:    Point + plateX × (Ø50/2) - plateY × plate_width
Bottom-right: Point - plateX × (Ø50/2) - plateY × plate_width
Bottom-left:  Point - plateX × (Ø50/2)
```

**Purpose**:
- Prevents Weinmann CNC nailing heads from placing fasteners through the SIHGA PICK hardware slot
- Ensures hardware installation area remains clear of obstructions
- Reduces risk of fastener damage to lifting devices

**CNC Integration**:
- Exported to Weinmann BTL/hundegger formats
- Nailing machines read zone data and skip these areas
- No manual intervention required during production

## Geometry Calculation Details

### Center of Gravity Determination

**Process**:
1. Script calls `hsbCenterOfGravity.callMapIO()` with all wall components:
   - All beams (studs, plates, headers, blocking, etc.)
   - All sheets (sheathing, cladding, interior finish)
   - All TSL instances (hardware, fasteners, other devices)

2. Helper script returns:
   - `ptCen`: 3D point representing center of gravity
   - `Weight`: Total element mass in kg

3. Main script projects `ptCen` onto the wall's center plane (Z0 midpoint):
   ```
   pnCen = Plane at (wall origin - Z × beam_width/2)
   ptRef = ptCen projected onto pnCen
   ```

4. Lifting points are distributed symmetrically around `ptRef` along the wall's X-axis

**Why This Matters**:
- Center of gravity may not be at geometric center (due to openings, varying materials, attached hardware)
- Lifting from true CG ensures balanced lift, prevents tipping
- Script recalculates CG every time wall composition changes

### Distribution Area Calculation

The script defines a constrained zone where lifting points are permitted:

**Constraints Applied (in order)**:

1. **Top Plate Projection**:
   - All lifting points must project onto the top plate beam(s)
   - If multiple plate beams exist at the same height, the script unions their projected areas

2. **End Margins**:
   - 250mm minimum clearance from each end of the top plate beam
   - Prevents lifting points too close to plate joints or end grain

3. **Outermost Stud Boundaries**:
   - Lifting points must fall within the span of the first and last vertical studs
   - Prevents points outside the structural frame

4. **500mm Wall Edge Clearance**:
   - Additional 500mm margin from wall physical edges
   - Extra safety factor for end-of-wall stress concentration

5. **Center of Gravity Offset**:
   - If CG is eccentric (not at wall midpoint), the script adjusts maximum range to maintain symmetry
   - Ensures equal clearance on both sides of the CG

**Visual Representation**:
```
Wall elevation view:

|<--500mm-->|<---Usable Distribution Area--->|<--500mm-->|
|           |                                 |           |
|  Margin   | First Stud --- CG --- Last Stud |  Margin   |
|           |   |               |             |           |
|           |<-250mm->|   |<-250mm->|         |           |
|           |         |   |         |         |           |
            |   Plate Beam with margins        |
            |                                  |
```

**PlaneProfile Calculation**:
```
ppDist = Shadow profile of all top plate beams onto vertical plane
ppDist = ppDist - end margin rectangles (250mm each side)
ppDist = ppDist - stud boundary rectangles (outside first/last stud)
ppDist = Final usable area for lifting point placement
```

### Lifting Geometry Calculation

#### 1-Point Configuration

**Geometry**:
- Single point at projected center of gravity
- Belt extends vertically upward (assumed straight for simplicity)
- No angle calculation (assumed 0° for maximum capacity)

#### 2-Point Configuration

**Distribution**:
```
Left point:  ptRef - X × (Interdistance / 2)
Right point: ptRef + X × (Interdistance / 2)
```

**Belt Geometry**:
- Each belt runs from attachment point to common crane hook apex
- Apex height calculated using belt length as hypotenuse:
```
Horizontal offset = Interdistance / 2
Vertical height = sqrt(Belt_Length² - Offset²)
Crane hook = ptRef + Y × Vertical_height
```

**Lifting Angle**:
```
Angle = arctan(Horizontal_offset / Vertical_height)
      = arctan((Interdistance/2) / sqrt(Belt_Length² - (Interdistance/2)²))
```

#### 4-Point Configuration (Standard)

**Distribution**:
```
Front-Left:  ptRef - X × (Interdistance/2) - Z × (Interdistance/2)
Front-Right: ptRef + X × (Interdistance/2) - Z × (Interdistance/2)
Rear-Left:   ptRef - X × (Interdistance/2) + Z × (Interdistance/2)
Rear-Right:  ptRef + X × (Interdistance/2) + Z × (Interdistance/2)
```

**Belt Geometry**:
- Each pair (Front-Left + Front-Right, Rear-Left + Rear-Right) converges to its own apex
- Two apex points calculated
- Apex points may be connected (traverse) or converge to single crane hook (chains)

**Ellipse Calculation**:
The script uses an ellipse equation to determine valid crane hook positions:
```
For each belt pair with points at ±Interdistance/2:
    Ellipse semi-major axis = Belt_Length / 2
    Ellipse semi-minor axis = sqrt((Belt_Length/2)² - (Interdistance/4)²)

    Parametric form:
    x = (Belt_Length/2) × cos(t)
    y = (semi-minor axis) × sin(t)
```

The intersection of ellipses from both pairs defines the valid apex region.

#### 4 + Traverse Configuration

**Distribution**: Same as standard 4-point

**Geometry**:
```
Left pair apex:  Intersection of left ellipse with horizontal plane at calculated height
Right pair apex: Intersection of right ellipse with horizontal plane at calculated height
Traverse: Horizontal bar connecting left apex to right apex
Traverse length = User-specified "Chain / Traverse Length"
```

**Calculation**:
1. Find crane hook height that produces desired traverse length
2. Intersect ellipses with horizontal plane at that height
3. Verify resulting belt angles remain within limits
4. Draw traverse bar connecting the two apex points

#### 4 + Hanger Chains Configuration

**Distribution**: Same as standard 4-point

**Geometry**:
```
Left pair apex:  Calculated from ellipse intersection
Right pair apex: Calculated from ellipse intersection
Left chain: From left apex vertically/obliquely to crane hook
Right chain: From right apex vertically/obliquely to crane hook
Chain length = User-specified "Chain / Traverse Length"
Crane hook: Single point where both chains converge
```

**Iterative Calculation**:
```
Starting from estimated hook height:
    Repeat until convergence:
        1. Create circle of radius Chain_Length centered at current hook position
        2. Intersect circle with left belt ellipse → candidate left apex points
        3. Intersect circle with right belt ellipse → candidate right apex points
        4. If valid intersections found → success
        5. Else: Lower hook height by 100mm and retry

    Final apex = average of intersection points (for stability)
```

This ensures both chains have exactly the specified length while maintaining valid belt geometry.

### Auto-Correction Logic

The script applies multiple auto-correction mechanisms to maintain safe configurations:

#### Interdistance Correction

**Trigger 1: Belt Angle Constraint**
```
If actual belt angle would exceed 45°:
    Max_Interdistance = Belt_Length × cos(45°) × [factor]
    [factor] = 2 for 2-point, 1 for 4-point

    If user's Interdistance > Max_Interdistance:
        Interdistance ← Max_Interdistance
        Print: "Distance corrected to [value] --> min. lifting belt angle = 45°"
```

**Trigger 2: Wall Length Constraint**
```
Wall_usable_length = Wall_physical_length - 2 × 500mm (margins)
Center_offset = abs(CG_position - Wall_midpoint)
Max_Interdistance = (Wall_usable_length - 2 × Center_offset - 500mm) / 2

If user's Interdistance > Max_Interdistance:
    Interdistance ← Max_Interdistance
    Force recalculation
```

**Trigger 3: Distribution Area Constraint**
```
After calculating ppDist (valid distribution area):
    Max_Interdistance = 2 × max(distance from CG to area boundaries)

    If user's Interdistance > Max_Interdistance:
        Interdistance ← Max_Interdistance / (Point_count - 1)
        Force recalculation
```

#### Grip Point Snapping

When user drags a grip point:
```
1. Check if new position is inside ppDist (distribution area)
   If outside:
       Snap to closest point on ppDist boundary

2. Project point to wall center plane (pnCen)

3. Ray-cast upward (-Y direction) from projected point
   Intersect with top plate envelope (plEnv)
   If intersection found:
       Snap grip to intersection point (top of plate)

4. Recalculate all geometry, angles, and load validation
```

This ensures grip points always remain in structurally valid positions.

## Visual Output Elements

### 3D Model Space Display

**Lifting Belts** (Color 7 = white/gray, or Color 1 = red if warning):
- Polylines from each attachment point to crane hook apex
- Labeled with length: `"L=2000 mm"`
- For multi-belt systems: `"Continuous belt 1 L=2000 mm"` and `"Continuous belt 2 L=2000 mm"`

**Traverse Bar** (Color 5 = blue, or Color 1 = red if warning):
- Polyline connecting left and right apex points (4 + Traverse mode only)
- Labeled: `"Traverse  L=2000 mm"`

**Hanger Chains** (Color 5 = blue, or Color 1 = red if warning):
- Polylines from each apex to crane hook (4 + Hanger Chains mode only)
- Labeled: `"Hanger Chain  L=2000 mm"`

**SIHGA PICK Hardware Bodies** (Color 253 = light gray):
- 3D solid representation of the lifting device at each attachment point
- Composed of 4 stacked cylinders representing the hardware profile:
  - Base cylinder: Ø25mm × 68mm depth (embedded in plate)
  - Mid cylinder 1: Ø47mm × 26mm height (above plate)
  - Mid cylinder 2: Ø33mm × 19mm height
  - Top cylinder: Ø16mm × 37mm height (belt attachment)

**Warning Text** (Color 1 = red):
- At each lifting point if warnings active
- At wall center of gravity: `"!!! Attention !!!"`
- In plan view at each lifting point

### Plan View (_ZW Direction)

**Warning Text Only** (Color 1 = red):
- Appears when looking down from above
- Positioned at each lifting point
- Same messages as model space

**Purpose**: Quick visual check during top-down plan review for warning conditions.

## Common Usage Scenarios

### Scenario 1: Standard 2-Point Wall Lift

**Wall Specifications**:
- Length: 2400mm
- Height: 2700mm
- Weight: 450 kg
- Top plate: 89mm × 140mm (Case 1)

**Configuration**:
- Quantity: 2
- Belt Length: 2000mm
- Interdistance: 1000mm
- Weinmann Tools: Yes

**Expected Behavior**:
1. Script calculates CG (approximately wall center if uniform density)
2. Places two lifting points 500mm left and right of CG
3. Selects SIHGA PICK Case 1 (89mm × 140mm plate)
4. Calculates belt angle: arctan(500 / sqrt(2000² - 500²)) ≈ 14.5°
5. Retrieves max load at 14.5° ≈ 1174 kg/device (interpolated from table)
6. Total capacity: 1174 × 2 / 2 = 1174 kg (for 2 points, formula is different: simple sum)
7. Actual capacity for 2 points: 1174 × 2 = 2348 kg
8. Element weight 450 kg < 2348 kg → **SAFE, no warnings**
9. Applies Ø50mm drills at both points
10. Creates no-nail zones (Weinmann enabled)

**Visual Result**: Gray belts, labeled "L=2000 mm", no warning text.

### Scenario 2: Heavy Wall Requiring 4 Points

**Wall Specifications**:
- Length: 6000mm
- Height: 3000mm
- Weight: 2800 kg
- Top plate: 89mm × 140mm (Case 1)

**Configuration**:
- Quantity: 4
- Belt Length: 2500mm
- Interdistance: 1800mm
- Weinmann Tools: No

**Expected Behavior**:
1. Places four points in rectangular pattern (900mm from CG each direction)
2. Selects Case 1
3. Each belt: sqrt((900/2)² + (900/2)²) = 636mm horizontal, sqrt(2500² - 636²) ≈ 2419mm vertical
4. Belt angle: arctan(636 / 2419) ≈ 14.7°
5. Max load at ~15°: ≈ 1174 kg/device
6. Total capacity: 1174 × 4 / 2 = 2348 kg
7. Element weight 2800 kg > 2348 kg → **WARNING**

**Warning Message**:
```
The load is too heavy for 4 Lifting points
```

**Resolution**:
- Option 1: Increase top plate to 140mm+ width → Case 2 (1800 kg/device) → 3600 kg capacity → SAFE
- Option 2: Reduce wall weight (remove components, split into sections)
- Option 3: Use larger SIHGA PICK hardware (requires manual plate modification)

### Scenario 3: Long Wall with Traverse

**Wall Specifications**:
- Length: 10,000mm
- Height: 2700mm
- Weight: 1600 kg
- Top plate: 140mm × 140mm (Case 4)

**Configuration**:
- Quantity: 4 + Traverse
- Belt Length: 3000mm
- Interdistance: 2500mm
- Chain / Traverse Length: 4000mm
- Weinmann Tools: Yes

**Expected Behavior**:
1. Places four points (1250mm from CG in ±X, additional ±Z spacing)
2. Selects Case 4 (80-99mm height, ≥140mm width)
3. Calculates two belt pair apex points
4. Draws 4000mm traverse bar connecting apex points
5. Verifies belt angles for each pair
6. Checks load capacity against SIHGA PICK Case 4 tables
7. Applies 4 drills and 8 no-nail zones (2 per point)

**Purpose of Traverse**: Prevents wall from compressing horizontally during lift, maintains dimensional accuracy, distributes load evenly across all four points.

## Troubleshooting Guide

### Problem: Script Deletes Itself on Insertion

**Possible Causes**:

1. **No Wall Selected**
   - Error message: "no element"
   - Solution: Ensure you select a valid `ElementWallSF` during insertion prompt

2. **Wrong Element Type**
   - Error message: "no wall element"
   - Solution: Select only Stickframe Wall elements, not beams, panels, or other entities

3. **Missing hsbCenterOfGravity Script**
   - Error message:
     ```
     ******************** Sihga PICK Wall ********************
     The calculation of the point of gravity has failed.
     Please ensure that the TSL

     hsbCenterOfGravity

     is loaded into the dwg or is present in the standard
     tsl search path
     Tool will be deleted
     *************************************************************
     ```
   - Solution: Load `hsbCenterOfGravity.mcr` into the drawing or place it in a TSL search directory

4. **Top Plate Too Small**
   - Error message: "Top plate is too small for SIHGA PICK lifting system --> Tool will be deleted"
   - Solution: Ensure top plate beam is at least 60mm high and 80mm wide
   - Check plate beam dimensions in element properties

5. **Duplicate Instance**
   - Behavior: Script erases immediately without message
   - Cause: Another Sihga PICK Wall instance is already attached to this wall element
   - Solution: Delete existing instance first, or select a different wall

### Problem: Red Warning Text Appears

**Warning Type 1**: "The load is too heavy for [N] Lifting points"

**Solutions**:
1. Increase Quantity (e.g., 2 → 4, or 4 → 4+Traverse/Chains)
2. Reduce element weight:
   - Remove unnecessary sheets or hardware
   - Split wall into lighter segments
3. Verify top plate dimensions (larger = higher SIHGA case = more capacity)

**Warning Type 2**: "The lifting angle at this point is out of range"

**Solutions**:
1. Increase Belt Length (allows wider spacing at same angle)
2. Decrease Interdistance (steeper angle)
3. Check for manual grip point movement beyond limits

**Warning Type 3**: "The lifting angle at this point (XX.X°) is too flat to carry the load!!!"

**Solutions**:
1. Increase Belt Length (steeper angle, higher capacity)
2. Decrease Interdistance (steeper angle, higher capacity)
3. Move grip points closer to center (if manually positioned)
4. Add more lifting points (distribute load)

### Problem: Interdistance Keeps Auto-Correcting

**Behavior**: You enter 2000mm, script changes it to 1414mm or another value

**Causes**:

1. **Belt Length Constraint**
   - For 4-point: Max = Belt_Length × 0.707 (45° angle)
   - Example: 2000mm belt → max 1414mm interdistance
   - Solution: Increase belt length to 2830mm+ for 2000mm spacing

2. **Wall Length Constraint**
   - Wall too short for desired spacing
   - Example: 3000mm wall, CG at center, 500mm margins → max ~900mm interdistance for 4 points
   - Solution: Accept smaller spacing or use fewer points

3. **Top Plate Beam Length**
   - Plate beam shorter than wall physical length
   - 250mm margins enforced from plate ends
   - Solution: Extend top plate beam or reduce spacing

**Expected Behavior**: This is a safety feature, not a bug. The script ensures lifting angles never exceed 45° and points stay within structural boundaries.

### Problem: Grip Points Won't Move to Desired Location

**Behavior**: Drag grip, it snaps back to different position

**Causes**:

1. **Outside Distribution Area**
   - Grip moved beyond allowed zone (250mm plate margins, stud boundaries)
   - Script snaps to closest valid point inside `ppDist`
   - Solution: This is intentional; grip can only move within safe zones

2. **No Top Plate Below**
   - Grip moved to position with no plate beam underneath
   - Script ray-casts upward to find plate; if none found, snaps to nearest plate location
   - Solution: Ensure continuous top plate across desired lifting zones

**Note**: Grip snapping is a safety feature ensuring lifting points always attach to structural members.

### Problem: No Drills Appear in CNC Output

**Possible Causes**:

1. **CNC Export Filter**
   - Some CNC export modules filter by element selection or layer
   - Solution: Ensure wall element is selected/enabled in export dialog

2. **Drill Not Applied to Beam**
   - Check if `bmToolPlate.addTool(drMain)` succeeded
   - May fail if plate beam is invalid or locked
   - Solution: Verify plate beam is editable, not frozen or on locked layer

3. **Export Format Doesn't Support Drills**
   - Some legacy formats omit drill operations
   - Solution: Use BTL, hundegger, or Weinmann-specific export formats

**Verification**: Run `HSB_T-Drill` list command to see if drills are registered on the plate beam.

### Problem: No-Nail Zones Not Working

**Possible Causes**:

1. **Apply Weinmann Tools = No**
   - Zones only created when explicitly enabled
   - Solution: Set parameter to "Yes" in Properties Panel

2. **Weinmann Machine Doesn't Read hsbCAD No-Nail Data**
   - Older Weinmann software versions may not support `ElemNoNail`
   - Solution: Verify Weinmann software version and hsbCAD export plugin compatibility

3. **Zones Applied to Wrong Element Zones**
   - Script applies to Zone +1 and -1 (front/back)
   - If wall has custom zone configuration, zones may not align
   - Solution: Check wall zone definitions match standard Stickframe setup

**Verification**: Use hsbCAD Element Inspector to view attached `ElemNoNail` objects.

## Advanced Usage Tips

### Optimizing for Crane Logistics

**Single vs. Multi-Point Lifts**:
- **1-point**: Fastest rigging, but wall can rotate/swing. Use only for small, light panels (<500 kg, <2m).
- **2-point**: Industry standard, good balance of speed and stability. Most common for typical walls.
- **4-point**: Maximum stability, slower rigging. Required for heavy (>2000 kg) or tall (>3m) walls.

**Traverse vs. Hanger Chains**:
- **Traverse**: Rigid bar prevents horizontal compression. Better for long walls (>4m) where panel squaring is critical.
- **Hanger Chains**: Flexible, easier to rig on single-hook cranes. Better for sites with limited crane boom reach.

### Multi-Wall Batch Insertion

**Workflow**:
1. Launch script once
2. At "Select wall(s)" prompt, select 10, 20, or 50 walls
3. Script processes each wall sequentially
4. All walls get identical parameter settings from initial configuration

**Use Cases**:
- Production runs of identical wall panels
- Entire house framing with standardized top plates
- Quickly add lifting hardware to complete building model

**Note**: Parameters are global (same for all walls). For wall-specific settings, insert individually or adjust via Properties Panel after batch insertion.

### Catalog Entry Best Practices

**Creating Catalog Entries**:
1. Configure one Sihga PICK Wall instance with desired parameters
2. Right-click instance → "Add to Catalog"
3. Name entry descriptively: "4-Point Heavy Walls" or "2-Point Standard 2000mm Belts"
4. Save catalog

**Benefits**:
- Launch with `_kExecuteKey` matching catalog name → silent insertion (no dialog)
- Standardize lifting configurations across projects
- Faster workflow for repetitive tasks

**Recommended Catalog Entries**:
- "Standard 2-Point" (Belt 2000, Int 1000, Weinmann Yes)
- "Heavy 4-Point" (Belt 2500, Int 1500, Weinmann Yes)
- "Long Wall Traverse" (4+Traverse, Belt 3000, Chain 4000)

### Integration with Shop Drawings

While this script operates in Model Space only, the applied drills and no-nail zones flow downstream to shop drawings:

**Workflow**:
1. Design walls with Sihga PICK Wall instances in model
2. Run shop drawing scripts (e.g., `sd_WallShopDrawing`)
3. Drills appear as symbols on fabrication drawings
4. No-nail zones may appear as hatched areas (depending on shop drawing script configuration)

**CNC Integration**:
1. Export model to BTL, hundegger, or Weinmann format
2. Drills are included as machining operations
3. No-nail zones are included as restricted areas
4. CNC machine processes wall with automatic hardware clearances

**Quality Check**:
- Review shop drawings to verify drill positions
- Confirm drill symbols appear at expected locations
- Check for interference with other hardware (hangers, straps, etc.)

## Technical Notes

### Performance Considerations

**Recalculation Triggers**:
- Any OPM parameter change
- Grip point movement
- Wall geometry modification (beams, sheets added/removed)
- Manual refresh command

Each recalculation:
1. Calls `hsbCenterOfGravity` (expensive for complex walls)
2. Recalculates distribution area (shadow profiles of all plate beams)
3. Recalculates belt geometry (ellipse intersections for 4-point modes)
4. Validates load capacity (table lookups and interpolation)
5. Redraws all visual geometry

**Optimization**:
- Avoid excessive grip point dragging on heavy walls (>100 beams)
- Batch parameter changes if possible (set all params, then tab out to trigger single recalc)
- For very large walls (>200 components), consider using `envelopeBody()` instead of `realBody()` (already implemented in script)

### Coordinate System Details

**Wall Local Coordinate System**:
```
Origin (ptOrg): Bottom-left corner of wall
X-axis (vecX): Along wall length (left to right)
Y-axis (vecY): Perpendicular to wall face (outward from wall)
Z-axis (vecZ): Vertical (upward)
```

**Center Plane (pnCen)**:
```
Location: ptOrg - Z × (beam_width / 2)
Normal: vecZ (vertical)
Purpose: All lifting points are projected onto this plane to ensure consistent Z-coordinate
```

**Distribution Reference (ptRef)**:
```
= ptGrav projected onto pnCen
= The point on the center plane directly above/below the center of gravity
= Symmetric center for lifting point distribution
```

### Ellipse Geometry (4-Point Configurations)

For each belt pair (two points at distance `d` apart):
```
Constraint: Each belt has fixed length L
Geometry: Both belts meet at apex point (x, y) above the midpoint

For left belt:
    sqrt((x + d/2)² + y²) = L

For right belt:
    sqrt((x - d/2)² + y²) = L

Solving for locus of valid apex points:
    Ellipse with center at pair midpoint
    Semi-major axis a = L/2 (along x)
    Semi-minor axis b = sqrt((L/2)² - (d/4)²) (along y)

Parametric equation:
    x(t) = (L/2) × cos(t)
    y(t) = b × sin(t)
```

The script discretizes this ellipse at 10mm intervals to find intersections with other geometry (traverse planes, chain circles).

### Load Table Interpolation

Load capacity tables have 5° granularity (0°, 5°, 10°, ..., 45°).
For angles between table values (e.g., 17.3°), the script uses:

**Linear Interpolation**:
```
Given: Angle = 17.3°
Lower bound: 15° → Max load = 1657 kg
Upper bound: 20° → Max load = 1609 kg

Interpolated load = 1657 + (1609 - 1657) × (17.3 - 15) / (20 - 15)
                  = 1657 + (-48) × (2.3 / 5)
                  = 1657 - 22.08
                  = 1634.92 kg (rounded to 1635 kg)
```

**Boundary Detection**:
The script finds the correct 5° bracket using a loop:
```
for (k = 0; k < dBoundaryAngles.length(); k++) {
    if (actual_angle < dBoundaryAngles[k]) {
        bracket_index = k;
        break;
    }
}
```

Then retrieves `dMaxLoads[bracket_index]` from the selected case table.

## Related Tools and Workflows

**Prerequisite Tools**:
- `hsbCenterOfGravity`: Required dependency for weight and CG calculation

**Complementary Tools**:
- `HSB_E-Identification & Marking`: Add element numbers and markings to walls
- `HSB_W-Lifting`: Alternative lifting system (different hardware vendor)
- `hsbLayoutTag`: Create plan view tags showing lifting configuration
- `sd_WallShopDrawing`: Generate fabrication drawings including lifting hardware

**Downstream CNC/Export**:
- Weinmann BTL export
- hundegger BTL export
- Generic DXA export (drill coordinates)

**Typical Project Workflow**:
1. Design wall elements (studs, plates, sheathing)
2. Apply Sihga PICK Wall instances (this tool)
3. Review/adjust lifting configurations
4. Run `HSB_E-Identification` for element numbering
5. Generate shop drawings with `sd_WallShopDrawing`
6. Export to CNC with Weinmann/hundegger exporter
7. Manufacture walls with automated drilling and nailing (no-nail zones respected)
8. Erect walls using SIHGA PICK hardware per script-calculated geometry

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 30 Aug 2017 | florian.wuermseer | Initial release |
| 1.1 | 30 Aug 2017 | florian.wuermseer | Fixed distribution bug when wall length < distribution length |
| 1.2 | 08 Sep 2017 | florian.wuermseer | Added 4-point without traverse mode; belt lengths now displayed |
| 1.3 | 28 Sep 2017 | florian.wuermseer | Fixed lifting angle calculation for 4-point without traverse |
| 1.4 | 07 Nov 2017 | florian.wuermseer | Added 4-point with hanger chains configuration |

## Summary

The **Sihga PICK Wall** script is a comprehensive lifting engineering tool that bridges structural design and construction logistics. By automating center-of-gravity calculation, load validation, and CNC preparation, it ensures safe and efficient wall panel erection while maintaining compatibility with modern prefabrication workflows.

**Key Takeaways**:
- Always verify warning messages and adjust parameters until warnings clear
- Belt length and interdistance are interdependent (45° minimum angle constraint)
- Top plate dimensions determine hardware capacity (8 SIHGA cases)
- Grip points can be manually adjusted but auto-snap to safe positions
- CNC output (drills and no-nail zones) flows automatically to Weinmann production lines

For additional support, consult SIHGA manufacturer documentation for hardware specifications and load tables, or contact hsbCAD support for script-specific questions.
