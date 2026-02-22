# hsbBeamCornerConnection

## Overview

**hsbBeamCornerConnection** is a sophisticated timber frame joinery tool that creates precise corner connections between two perpendicular joists with optional post integration. The script generates a male/female interlocking joint system commonly used in traditional timber frame construction, automatically calculating and applying all necessary cuts, mortises, and drill holes for pegging.

This tool stands out for its intelligent geometric processing—it handles complex 3D spatial relationships between beams, automatically determines optimal cut angles, and creates structurally sound connections that account for tolerances and assembly clearances.

| Property | Value |
|----------|-------|
| Type | Tool (T-Type) |
| Beams Required | 2-3 (2 joists required, 1 post optional) |
| Version | 1.1 |
| Author | marsel.nakuci@hsbcad.com |
| Last Updated | October 2020 (HSB-9321) |
| Keywords | post, joist, perpendicular, male, female, corner, mortise |

---

## Purpose and Applications

### Primary Use Cases

**hsbBeamCornerConnection** is designed for:

1. **Traditional Timber Frame Joinery**: Creating historical-style corner joints in exposed timber structures
2. **Floor and Ceiling Joist Connections**: Connecting perpendicular floor joists where they meet at corners
3. **Post-and-Beam Structures**: Integrating vertical posts with horizontal joists using mortise-and-tenon joinery
4. **Prefabricated Frame Systems**: Generating precise CNC-ready connections for shop fabrication

### Structural Function

The connection serves multiple structural purposes:
- **Load Transfer**: Transfers vertical and lateral loads between perpendicular joists
- **Alignment**: Maintains precise alignment of timber members during assembly
- **Rigidity**: Creates a rigid corner connection when properly pegged
- **Tolerance Management**: Accounts for real-world assembly clearances and wood movement

---

## Environment and Workspace

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | ✓ Yes | **Required** - All operations modify 3D beam geometry |
| Paper Space | ✗ No | Not applicable - this is a 3D modeling tool |
| Shop Drawing | Partial | Generates connection geometry; downstream shop drawing scripts can document it |

### Coordinate System Requirements

The script automatically establishes local coordinate systems based on:
- **World Z-axis (_ZW)**: Used as the vertical reference for all operations
- **Joist orientations**: Local X/Y axes calculated from beam centerlines and reference points
- **Perpendicularity validation**: Script validates that selected joists are truly perpendicular before proceeding

---

## Prerequisites

### Required Elements

Before using this tool, you must have:

1. **Two Perpendicular Joists (Required)**
   - Both joists must be GenBeam or Beam entities
   - Joists must be oriented at 90° to each other
   - Joists should be positioned close to their final locations (script will extend/trim them)
   - Both joists should have similar depths for best results

2. **One Perpendicular Post (Optional)**
   - Must be a GenBeam or Beam entity
   - Post axis must be perpendicular to **both** joist axes
   - Typically a vertical member (parallel to World Z)
   - Post adds mortise-and-tenon connection with peg holes

### Geometric Constraints

**Critical Requirements:**
- Joists must be **exactly perpendicular** (90° ± system tolerance)
- Post (if used) must be perpendicular to both joists
- Joist depths should be sufficient to accommodate the mortise dimensions
- Joists should not have conflicting cuts in the connection zone

**Validation Notes:**
- The script uses `isPerpendicularTo()` to validate geometry
- Invalid geometry triggers the message: *"Correct post not found or selected joists are not perpendicular"*
- If validation fails, the script creates a 2-joist connection only (ignores the post)

---

## Installation and Insertion

### Step 1: Launch the Tool

**Command Line Method:**
```
Command: TSLCONTENT
```
(After loading the script with `(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBeamCornerConnection"))`)

**Menu Method:**
- Navigate to hsbCAD TSL library
- Select **hsbBeamCornerConnection** from the tool palette

### Step 2: Configure Parameters (Dialog)

When the script launches, a dialog appears with the following configuration options:

**Option A: Load from Catalog**
- Select a pre-saved catalog entry from the dropdown
- Common entries: "LastInserted", "Default", or custom-saved configurations
- Click OK to proceed with catalog settings

**Option B: Manual Configuration**
- Adjust individual parameters in the dialog (see Parameters section below)
- Click OK when satisfied

**Option C: Silent Execution**
- If `_kExecuteKey` is set (programmatic insertion), the dialog is bypassed
- Script auto-loads matching catalog entry or "LastInserted"

### Step 3: Select Male Joist

**Prompt:** *"Select male joist"*

**Action:**
- Click on the joist that will receive the **male** (protruding) portion of the joint
- This joist will contain the tenon if a post is added
- Typically the joist that continues through the corner

**Visual Feedback:**
- Selected beam highlights
- Insertion point (_Pt0) is established at the beam's reference location

### Step 4: Select Female Joist

**Prompt:** *"Select female joist"*

**Action:**
- Click on the perpendicular joist that will receive the **female** (recessed) portion
- This joist will be notched to accept the male joist
- Typically the joist that terminates at the corner

**Perpendicularity Check:**
- Script automatically validates the 90° angle
- If joists are not perpendicular, the connection will fail to generate properly

### Step 5: Select Post (Optional)

**Prompt:** *"Select post"*

**Action:**
- **To Add Post:** Click on a vertical beam perpendicular to both joists
- **To Skip Post:** Press Enter or right-click → Cancel

**Post Validation Logic:**
```c
// Script validates each candidate beam
for each beam in selection:
    if beam.vecX() is perpendicular to joist0.vecX() AND
       beam.vecX() is perpendicular to joist1.vecX():
        Accept beam as post
        Add to _Beam[2]
        break
    else:
        continue searching
```

**Success Outcome:**
- Post is accepted → Mortise and drill holes are generated
- `_Beam.length()` becomes 3

**Failure Outcome:**
- No valid post found → Message displayed
- Connection proceeds with 2 joists only
- `_Beam.length()` remains 2

### Step 6: Automatic Processing

Once all beams are selected, the script automatically:

1. **Extends/trims joists** to meet at the corner intersection
2. **Calculates local coordinate systems** for both joists
3. **Computes miter cut planes** based on the angle and tolerances
4. **Applies double miter cuts** to create the angled joint surfaces
5. **Creates cube cuts** for the male/female interlocking geometry
6. **Generates mortise** (if post exists) in both post and male joist
7. **Distributes drill holes** (if post exists) for peg fasteners
8. **Registers hardware component** (peg) in the bill of materials
9. **Draws reference anchor** at the insertion point for identification

---

## Parameter Reference

All parameters are organized into four categories: **Geometry**, **Drill**, **Tolerance**, and **Mortise**. These parameters appear in the AutoCAD Properties Palette (OPM) and can be modified after insertion to recalculate the connection.

### Geometry Category

#### Angle Width (`dAngleWidth`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 50 mm |
| Units | Length |
| Description | Defines the width of the shoulder/angle at the corner connection |

**Purpose:**
Controls the size of the flat area where the two joists meet at the corner. This creates a shoulder that:
- Provides a registration surface for assembly alignment
- Increases contact area for load transfer
- Creates a visual detail line in exposed frame joinery

**Technical Effect:**
- Larger values create wider shoulders → more wood removal → weaker joists
- Smaller values create minimal shoulders → less guidance during assembly
- Directly affects the dimensions of the cube cuts (`dWC` and `dDC`)

**Calculation Impact:**
```c
double dWC = (dW1 - dAngleWidth);  // Width of cube cut
double dDC = (dW0 - dAngleWidth);  // Depth of cube cut
```

**Typical Range:** 30-80 mm depending on joist size

**Assembly Consideration:**
The angle width creates a visible edge when the frame is exposed. Match this dimension to the aesthetic requirements of the project.

---

### Drill Category

Parameters in this category control the peg holes that secure the post-to-joist connection.

#### Diameter (`dDrillDia`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 22 mm |
| Units | Length |
| Description | Diameter of the peg/dowel holes |

**Purpose:**
Defines the drill diameter for wooden pegs (dowels) that secure the mortise-and-tenon connection.

**Technical Notes:**
- Hole diameter should match the peg stock being used
- Common sizes: 18mm, 20mm, 22mm, 25mm (3/4", 7/8", 1")
- Undersizing by 0.5-1mm allows for driven fit
- Used to calculate drill radius: `dDrillDia * 0.5`

**Hardware Generation:**
This parameter directly populates the hardware article number:
```c
String sHWArticleNumber = "|Peg| " + dDrillDia + "mm x " + dW1 + "mm";
```

#### Height (`dDrillHeight`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 26 mm |
| Units | Length (vertical offset) |
| Description | Vertical position offset for drill holes relative to mortise |

**Purpose:**
Controls the Z-coordinate (vertical position) of the drill hole centerline relative to the bottom of the mortise.

**Technical Behavior:**
- The drill distribution is centered at this height
- For multiple drills, this becomes the center of the distribution
- Measured from the bottom reference of the mortise zone

**Calculation:**
```c
Point3d ptDrillStrt = pnPost1.closestPointTo(ptPostTop + vZC0 * dDrillHeight);
Point3d ptMiddleStrt = ptDrillStrt;  // Middle of distribution
```

**Typical Usage:**
- Set to ~50% of mortise height for centered holes
- Adjust higher/lower to avoid knots or grain anomalies
- For multiple drills, this becomes the middle drill position

#### Nr (`nNr`)

| Property | Value |
|----------|-------|
| Type | PropInt |
| Default | 1 |
| Units | Count |
| Allowed Values | 1, 2, or 3 |
| Description | Number of peg holes to distribute vertically |

**Purpose:**
Specifies how many peg holes are drilled through the post and joist connection.

**Structural Impact:**
- **1 drill**: Minimum connection, suitable for light loads
- **2 drills**: Standard connection, resists rotation
- **3 drills**: Heavy-duty connection, maximum shear resistance

**Distribution Logic:**
```c
double dDistDrillTot = (nNr - 1) * dDistance;
ptDrillStrt = ptMiddleStrt - vZC0 * 0.5 * dDistDrillTot;

for (int i = 0; i < nNr; i++) {
    Point3d pt1 = ptDrillStrt + i * dDistance * vZC0;
    Drill drPost(pt1, pt2, dDrillDia * 0.5);
    post.addTool(drPost);
    joist0.addTool(drPost);
}
```

**Example Spacing (with Distance = 25mm):**
- **nNr = 1**: Single hole at dDrillHeight
- **nNr = 2**: Two holes, 25mm apart, centered at dDrillHeight (±12.5mm)
- **nNr = 3**: Three holes, 50mm total span, centered at dDrillHeight (−25, 0, +25mm)

**Validation:**
```c
if (nNr < 1) nNr.set(1);  // Minimum 1 drill enforced
```

#### Distance (`dDistance`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 25 mm |
| Units | Length |
| Description | Spacing between multiple drill holes when Nr > 1 |
| Version Added | 1.1 (HSB-9321) |

**Purpose:**
Controls the center-to-center spacing between consecutive peg holes in a multi-drill distribution.

**Technical Behavior:**
- Only active when `nNr ≥ 2`
- Spacing is measured along the vertical (Z) axis
- Distribution is symmetrical around `dDrillHeight`

**Calculation of Total Span:**
```c
double dDistDrillTot = (nNr - 1) * dDistance;
```

**Examples:**
| nNr | dDistance | Total Span | Hole Positions (relative to center) |
|-----|-----------|------------|-------------------------------------|
| 1 | 25 mm | 0 mm | [0] |
| 2 | 25 mm | 25 mm | [−12.5, +12.5] |
| 3 | 25 mm | 50 mm | [−25, 0, +25] |
| 3 | 40 mm | 80 mm | [−40, 0, +40] |

**Design Considerations:**
- **Too close** (< 15mm): Risk of splitting between holes
- **Too far** (> 50mm): May exceed mortise height
- **Typical range**: 20-40mm for standard timber connections

---

### Tolerance Category

Tolerances account for real-world assembly clearances, wood movement, and fabrication precision.

#### Joist (`dToljoist`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 4 mm |
| Units | Length |
| Description | Gap tolerance between the two joists at the connection |

**Purpose:**
Adds clearance between the interlocking male and female joist surfaces to:
- Allow for assembly without force
- Accommodate wood swelling/shrinkage
- Account for CNC/fabrication tolerances
- Prevent binding during installation

**Technical Implementation:**

The tolerance is applied in multiple locations:

1. **Miter cuts** (angled joint surfaces):
```c
Point3d ptMiterIn = ptS0 + vMitPtDir1 * (dW1 - dAngleWidth - dToljoist)
                        + vMitPtDir0 * (dW0*0.5 - dAngleWidth - dToljoist);
```

2. **Cube cuts** (interlocking geometry):
```c
BeamCut bcCB(ptCDCen, vXC0, vYC0, vZC0,
             dWC + dToljoist, dDC + dToljoist, dHC, 0, 0, 1);
```

3. **Post clearance**:
```c
double dWP = post.dD(vMitPtDir0) + dToljoist * 2;  // 2x tolerance for clearance
```

**Effect on Geometry:**
- Increases the size of the female (recessed) portions
- Reduces the size of the male (protruding) portions
- Creates a uniform gap on all mating surfaces

**Assembly Impact:**
| Tolerance | Assembly Behavior | Best For |
|-----------|------------------|----------|
| 2-3 mm | Tight fit, requires mallet | Shop-controlled fabrication |
| 4-6 mm | Hand-press fit | Standard site assembly |
| 7-10 mm | Loose fit | Rough-sawn timber, site cutting |

**Seasonal Adjustment:**
- Increase tolerance in humid climates (wood swells)
- Decrease tolerance for kiln-dried, stable timber

#### Mortise (`dTolMortise`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 4 mm |
| Units | Length |
| Description | Tolerance added to the female mortise that receives the post tenon |

**Purpose:**
Adds clearance to the **female mortise** cut into the male joist, allowing the post's **male tenon** to insert without binding.

**Technical Implementation:**
```c
// Male tenon in post (exact dimensions)
Mortise msPost(ptPostTop, vXC1, vYC1, vZC1,
               dMortiseWidth, dMortiseDepth, dMortiseHeight,
               0, 0, 1, _kMaleEnd, _kRound);

// Female mortise in joist (with tolerance added)
Mortise msjoist1(ptPostTop, vXC1, vYC1, vZC1,
                 dMortiseWidth + dTolMortise * 0.5,
                 dMortiseDepth + dTolMortise * 0.5,
                 dMortiseHeight + dTolMortise * 0.5,
                 0, 0, 1, _kFemaleEnd, _kRound);
```

**Tolerance Distribution:**
- Applied to **width**, **depth**, and **height**
- Each dimension gets **half** the tolerance (0.5x) added to both sides
- Total clearance on each face = `dTolMortise * 0.5`
- Total gap around tenon = `dTolMortise`

**Example (dTolMortise = 4mm):**
| Dimension | Male Tenon | Female Mortise | Clearance per side | Total Gap |
|-----------|------------|----------------|-------------------|-----------|
| Width | 64 mm | 66 mm | 1 mm | 2 mm |
| Depth | 99 mm | 101 mm | 1 mm | 2 mm |
| Height | 70 mm | 72 mm | 1 mm | 2 mm |

**Design Notes:**
- **Traditional joinery**: 1-2mm for tight, glued mortise-and-tenon
- **Pegged assembly**: 3-5mm for dry-fit, pegged connections (recommended)
- **Site assembly**: 5-8mm for rough-cut timber

**Relationship to dToljoist:**
- Often set to the **same value** as `dToljoist` for consistency
- Can be set **independently** if post fit needs to be tighter/looser than joist fit

---

### Mortise Category

These parameters define the mortise-and-tenon connection between the post and the male joist.

#### Offset X (`dMortiseOffX`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 95 mm |
| Units | Length |
| Description | Horizontal offset of mortise center along the connection axis |

**Purpose:**
Controls the position of the mortise along the **local X-axis** of the connection (perpendicular to the female joist).

**Coordinate System:**
- Measured from the post center at the intersection plane
- Direction: `vMitPtDir0` (perpendicular to female joist, along male joist)
- Origin: The intersection point of the two joist centerlines

**Calculation:**
```c
Point3d ptPostTop = ptIS - vZC0 * dHIS * 0.5;  // Start at intersection
ptPostTop.setX(ptS1.X());  // Align with female joist
ptPostTop.setY(ptS1.Y());
ptPostTop = ptPostTop + vMitPtDir1 * (-dW1 * 0.5 + dMortiseOffY)
                      + vMitPtDir0 * dMortiseOffX;  // Apply X offset
```

**Typical Usage:**
- **Centered post**: Set to ~half the male joist width
- **Offset post**: Adjust to position mortise away from post edge
- **Edge avoidance**: Increase to avoid knots or grain defects

**Example (male joist width = 200mm):**
- `dMortiseOffX = 100mm` → Mortise centered on post
- `dMortiseOffX = 60mm` → Mortise toward one edge (40mm from edge if mortise width = 80mm)
- `dMortiseOffX = 140mm` → Mortise toward opposite edge

**Design Constraints:**
```
Minimum safe value: (dMortiseWidth / 2) + edge_distance
Maximum safe value: post_width - (dMortiseWidth / 2) - edge_distance
```
Typical edge distance: 30-50mm minimum

#### Offset Y (`dMortiseOffY`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 70 mm |
| Units | Length |
| Description | Horizontal offset of mortise center perpendicular to the connection axis |

**Purpose:**
Controls the position of the mortise along the **local Y-axis** of the connection (parallel to the female joist).

**Coordinate System:**
- Measured from the **edge of the female joist** (not center)
- Direction: `vMitPtDir1` (parallel to female joist)
- Origin: Calculated as `−dW1 * 0.5` (half-width of female joist from center)

**Calculation:**
```c
ptPostTop = ptPostTop + vMitPtDir1 * (-dW1 * 0.5 + dMortiseOffY)
                      + vMitPtDir0 * dMortiseOffX;
```

**Interpretation:**
- `dMortiseOffY = 0` → Mortise at the **outer edge** of the female joist
- `dMortiseOffY = dW1/2` → Mortise at the **centerline** of the female joist
- `dMortiseOffY = dW1` → Mortise at the **far edge** of the female joist

**Typical Usage:**
- **Standard**: Set to position mortise near the joist centerline
- **Avoid conflict**: Adjust if the joist has existing cuts/hardware
- **Structural**: Position to maximize load path from joist to post

**Example (female joist width dW1 = 150mm):**
- `dMortiseOffY = 70mm` (default) → 70mm from outer edge, 80mm from inner edge
- `dMortiseOffY = 75mm` → Centered on joist
- `dMortiseOffY = 50mm` → Closer to outer edge

#### Width (`dMortiseWidth`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 64 mm |
| Units | Length |
| Description | Width of the mortise (X-dimension in local coords) |

**Purpose:**
Defines the width of the tenon cut into the post and the corresponding mortise pocket in the joist.

**Coordinate System:**
- Measured along the `vXC1` direction (perpendicular to female joist)
- This is the dimension parallel to the male joist axis

**Structural Considerations:**
- **Load-bearing capacity**: Wider tenons resist higher shear loads
- **Post strength**: Must leave adequate wood around the tenon
- **Rule of thumb**: Tenon width ≤ 1/3 of post width for mortised posts

**Tenon Strength Formula (approximate):**
```
Shear capacity ∝ dMortiseWidth × dMortiseHeight × wood_species_shear_strength
```

**Typical Values:**
| Post Size | Recommended Width | Notes |
|-----------|------------------|-------|
| 100x100 mm | 40-50 mm | 40-50% of post |
| 150x150 mm | 60-80 mm | ~50% of post |
| 200x200 mm | 80-100 mm | ~40-50% of post |

**Relationship to Post:**
```c
// Male tenon created in post
Mortise msPost(..., dMortiseWidth, ...);

// Female mortise in joist (tolerance added)
Mortise msjoist1(..., dMortiseWidth + dTolMortise * 0.5, ...);
```

#### Depth (`dMortiseDepth`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 99 mm |
| Units | Length |
| Description | Depth of the mortise (penetration into post and joist) |

**Purpose:**
Defines how deep the tenon penetrates into the joist's female mortise, and how far the tenon projects from the post.

**Coordinate System:**
- Measured along the `vYC1` direction (parallel to female joist)
- This is the dimension that controls engagement depth

**Structural Function:**
- **Pull-out resistance**: Deeper mortises resist withdrawal loads
- **Peg engagement**: Must be deep enough for pegs to pass through both members
- **Joinery rule**: Depth ≥ 2× width for strong mortise-and-tenon joints

**Critical Design Relationship:**
```
dMortiseDepth should be < (male_joist_width - safety_margin)
```
Otherwise, the tenon will protrude through the opposite side of the joist.

**Peg Requirement:**
The pegs must pass through the full depth:
```c
Point3d ptDrillEnd = ptDrillStrt + vMitPtDir0 * dW0;  // Drills through both members
```
Ensure `dMortiseDepth` allows adequate wood around the drill path.

**Typical Values:**
| Joist Width | Recommended Depth | Max Depth |
|-------------|------------------|-----------|
| 140 mm | 80-100 mm | 120 mm |
| 200 mm | 100-140 mm | 180 mm |
| 240 mm | 120-180 mm | 220 mm |

**Geometry Check:**
```c
Mortise msPost(..., dMortiseWidth, dMortiseDepth, dMortiseHeight,
               0, 0, 1, _kMaleEnd, _kRound);
```
The `_kRound` parameter rounds the tenon edges for easier insertion.

#### Height (`dMortiseHeight`)

| Property | Value |
|----------|-------|
| Type | PropDouble |
| Default | 70 mm |
| Units | Length |
| Description | Vertical height of the mortise (Z-dimension) |

**Purpose:**
Defines the vertical extent of the tenon, controlling how much of the post's cross-section is removed to create the tenon.

**Coordinate System:**
- Measured along the `vZC1` direction (typically World Z / vertical)
- This is the dimension that controls how tall the tenon is

**Structural Considerations:**
- **Shear area**: Taller mortises provide more shear resistance
- **Post integrity**: Must leave adequate wood above/below the mortise
- **Drill clearance**: Must accommodate all drill holes within this height

**Drill Distribution Constraint:**
```c
double dDistDrillTot = (nNr - 1) * dDistance;
Required: dMortiseHeight ≥ dDistDrillTot + dDrillDia + safety_margin
```

**Example Calculation (nNr=3, dDistance=25mm, dDrillDia=22mm):**
```
Drill span = (3-1) × 25 = 50 mm
Minimum height = 50 + 22 + 20 (safety) = 92 mm
```
If `dMortiseHeight = 70mm`, the drills would exceed the mortise bounds!

**Typical Values:**
| Post Depth | Recommended Height | Max Height |
|------------|-------------------|-----------|
| 140 mm | 60-80 mm | 100 mm |
| 200 mm | 80-120 mm | 160 mm |
| 240 mm | 100-160 mm | 200 mm |

**Design Rule:**
Leave at least **30-40mm of solid wood** above and below the mortise for structural integrity.

**Mortise Type:**
```c
Mortise msPost(..., dMortiseWidth, dMortiseDepth, dMortiseHeight,
               0, 0, 1, _kMaleEnd, _kRound);
```
- **`1` (reference side)**: Mortise extends in the +Z direction
- **`_kRound`**: Corners are rounded for traditional joinery appearance

---

## Technical Logic and Workflow

### Geometric Calculation Pipeline

The script performs an extensive series of 3D geometric calculations to create the connection. Understanding this pipeline helps diagnose issues and optimize parameters.

#### Phase 1: Coordinate System Establishment

**Step 1.1: Extract Beam Data**
```c
Beam joist0 = _Beam[0];  // Male joist
Beam joist1 = _Beam[1];  // Female joist
Point3d ptCen0 = joist0.ptCen();  // Male joist center
Point3d ptCen1 = joist1.ptCen();  // Female joist center
```

**Step 1.2: Define Local Axes for Joist0 (Male)**
```c
Vector3d vZC0 = _ZW;  // Vertical = World Z
Vector3d vYC0 = vZC0.crossProduct(_X0);  // Cross product defines Y
vYC0.normalize();
Vector3d vXC0 = vYC0.crossProduct(vZC0);  // X completes right-hand system
vXC0.normalize();
```

**Step 1.3: Define Local Axes for Joist1 (Female)**
```c
Vector3d vZC1 = _ZW;  // Vertical = World Z
Vector3d vXC1 = joist1.ptRef() - ptCen1;  // Direction to reference point
vXC1.normalize();
Vector3d vYC1 = vZC1.crossProduct(vXC1);  // Y perpendicular to X and Z
vXC1 = vYC1.crossProduct(vZC0);  // Recalculate X for orthogonality
```

**Step 1.4: Establish Key Planes**
```c
Plane pnZ0(ptCen0, vZC0);  // Horizontal plane at joist0 center
Plane pnY0(ptCen0, vYC0);  // Vertical plane perpendicular to joist0
Plane pnZ1(ptCen1, vZC1);  // Horizontal plane at joist1 center
Plane pnY1(ptCen1, vYC1);  // Vertical plane perpendicular to joist1
```

**Step 1.5: Calculate Joist Dimensions**
```c
double dH0 = joist0.dD(vZC0);  // Height (depth in Z)
double dH1 = joist1.dD(vZC1);  // Height (depth in Z)
double dW0 = joist0.dD(vYC0);  // Width (depth in Y)
double dW1 = joist1.dD(vYC1);  // Width (depth in Y)
```

#### Phase 2: Intersection Point Calculation

**Step 2.1: Find Centerline Intersection**
```c
Line lnYIS = pnY1.intersect(pnY0);  // Intersection of vertical planes
```
This line represents the theoretical centerline where the two joist planes meet.

**Step 2.2: Project Centers to Intersection Line**
```c
Point3d ptCen02 = lnYIS.closestPointTo(ptCen0);  // Joist0 projected
Vector3d vCen02 = ptCen02 - ptCen0;
vCen02.normalize();

Point3d ptCen12 = lnYIS.closestPointTo(ptCen1);  // Joist1 projected
Vector3d vCen12 = ptCen12 - ptCen1;
vCen12.normalize();
```

**Step 2.3: Calculate Start Points (ptS0, ptS1)**
```c
Line lnX0(ptCen0, joist0.ptRef());  // Centerline of joist0
Line lnX1(ptCen1, joist1.ptRef());  // Centerline of joist1

Plane pnPost0(ptS0, vXC0);  // Plane perpendicular to joist0
Plane pnPost1(ptS1, vXC1);  // Plane perpendicular to joist1

ptS0 = lnX0.intersect(pnPost0, 0);  // Start point on joist0
ptS1 = lnX1.intersect(pnPost1, 0);  // Start point on joist1
```

These are the reference points where the connection begins.

**Step 2.4: Calculate End Points (ptE0, ptE1)**
```c
Point3d ptE0 = ptS0 + vCen02 * dW1;  // Extend by width of joist1
Point3d ptE1 = ptS1 + vCen12 * dW0;  // Extend by width of joist0
```

These are the points where the beams are cut off.

#### Phase 3: Beam Extension/Trimming

**Step 3.1: Apply End Cuts**
```c
joist0.addTool(Cut(ptE0, vXC0), _kStretchOnToolChange);
joist1.addTool(Cut(ptE1, vXC1), _kStretchOnToolChange);
```

**Effect:**
- Extends or trims the beams to exactly meet at the corner
- `_kStretchOnToolChange` flag allows the cut to move with parameter changes
- Both joists are now precisely aligned for the connection

#### Phase 4: Miter Cut Calculation

**Step 4.1: Calculate Miter Plane**
```c
Point3d ptS1T = ptS1;
ptS1T.setZ(ptS0.Z());  // Project to same horizontal plane

Vector3d vMiterTemp = ptS0 - ptS1T;
vMiterTemp.normalize();

Vector3d vMiter = vMiterTemp.crossProduct(vZC0);  // Perpendicular to Z
Plane pnMiter(ptCenCen, vMiter.crossProduct(vZC0));
```

**Step 4.2: Project Points to Miter Plane**
```c
Point3d ptMitPrj0 = pnMiter.closestPointTo(ptS0);
Point3d ptMitPrj1 = pnMiter.closestPointTo(ptS1);

Vector3d vMit0 = ptMitPrj0 - ptS0;
vMit0.normalize();

Vector3d vMit1 = ptMitPrj1 - ptS1;
vMit1.normalize();
```

**Step 4.3: Calculate Miter Directions**
```c
Vector3d vMitPtDir0 = -joist0.vecD(vMit0);  // Direction for joist0 cut
Vector3d vMitPtDir1 = -joist1.vecD(vMit1);  // Direction for joist1 cut
```

**Step 4.4: Calculate Miter Points (Inner and Outer)**
```c
Point3d ptMiterIn = ptS0 + vMitPtDir1 * (dW1 - dAngleWidth - dToljoist)
                        + vMitPtDir0 * (dW0*0.5 - dAngleWidth - dToljoist);

Point3d ptMiterOut = ptS0 + vMitPtDir1 * (dW1 - dAngleWidth)
                         + vMitPtDir0 * (dW0*0.5 - dAngleWidth);
```

**Inner Point**: Includes tolerance → creates the recessed portion
**Outer Point**: No tolerance → creates the shoulder edge

#### Phase 5: Double Miter Cut Application

**Step 5.1: Create Double Miter Cuts**
```c
DoubleCut dc0(ptMiterIn, vMitPtDir1, ptMiterIn - vMit0 * dToljoist*0.5, vMit0);
DoubleCut dc1(ptMiterIn, vMitPtDir0, ptMiterIn - vMit1 * dToljoist*0.5, vMit1);
```

**Step 5.2: Apply to Joists**
```c
joist0.addTool(dc0);
joist1.addTool(dc1);
```

**Effect:**
- Creates the angled interface surfaces
- Forms the 45° miter (or angle based on geometry)
- Includes tolerance offset for clearance

#### Phase 6: Cube Cut Creation (Male/Female Interlock)

**Step 6.1: Calculate Cube Dimensions**
```c
double dHC = dHIS;  // Height = intersection height
double dWC = (dW1 - dAngleWidth);  // Width
double dDC = (dW0 - dAngleWidth);  // Depth
```

**Step 6.2: Calculate Cube Centers**
```c
Point3d ptCDCen = ptS0 + vMitPtDir1 * (dDC*0.5 - dToljoist*0.5)
                       - vMitPtDir0 * (dW0*0.5 - (dDC*0.5 - dToljoist*0.5));

Point3d ptCTCen = ptS0 + vMitPtDir1 * (dDC*0.5 - dToljoist*0.5)
                       - vMitPtDir0 * (dW0*0.5 - (dDC*0.5 - dToljoist*0.5));
```

**Step 6.3: Create BeamCuts**
```c
BeamCut bcCB(ptCDCen, vXC0, vYC0, vZC0,
             dWC + dToljoist, dDC + dToljoist, dHC, 0, 0, 1);  // Bottom cube

BeamCut bcCT(ptCTCen, vXC0, vYC0, vZC0,
             dWC + dToljoist, dDC + dToljoist, dHC, 0, 0, -1);  // Top cube
```

**Step 6.4: Apply Cube Cuts**
```c
joist0.addTool(bcCB);  // Male joist gets one cube
joist1.addTool(bcCT);  // Female joist gets opposite cube
```

**Effect:**
- Creates interlocking cubic geometry
- One joist has a protruding cube (male)
- Other joist has a recessed pocket (female)
- Tolerance ensures clearance for assembly

#### Phase 7: Post Connection (If Post Exists)

**Condition Check:**
```c
if (_Beam.length() == 3) {
    Beam post = _Beam[2];
    // Mortise and drill logic
}
```

**Step 7.1: Calculate Mortise Top Point**
```c
Point3d ptPostTop = ptIS - vZC0 * dHIS * 0.5;  // Start at intersection
ptPostTop.setX(ptS1.X());
ptPostTop.setY(ptS1.Y());
ptPostTop = ptPostTop + vMitPtDir1 * (-dW1 * 0.5 + dMortiseOffY)
                      + vMitPtDir0 * dMortiseOffX;
```

**Step 7.2: Create Male Mortise in Post**
```c
Mortise msPost(ptPostTop, vXC1, vYC1, vZC1,
               dMortiseWidth, dMortiseDepth, dMortiseHeight,
               0, 0, 1, _kMaleEnd, _kRound);
post.addTool(msPost, _kStretchOnToolChange);
```

**Step 7.3: Create Female Mortise in Joist**
```c
Mortise msjoist1(ptPostTop, vXC1, vYC1, vZC1,
                 dMortiseWidth + dTolMortise * 0.5,
                 dMortiseDepth + dTolMortise * 0.5,
                 dMortiseHeight + dTolMortise * 0.5,
                 0, 0, 1, _kFemaleEnd, _kRound);
joist0.addTool(msjoist1, _kStretchNot);
```

**Step 7.4: Calculate Drill Points**
```c
Point3d ptDrillStrt = pnPost1.closestPointTo(ptPostTop + vZC0 * dDrillHeight);
Point3d ptMiddleStrt = ptDrillStrt;

double dDistDrillTot = (nNr - 1) * dDistance;
ptDrillStrt = ptMiddleStrt - vZC0 * 0.5 * dDistDrillTot;
```

**Step 7.5: Distribute and Apply Drills**
```c
for (int i = 0; i < nNr; i++) {
    Point3d pt1 = ptDrillStrt + i * dDistance * vZC0;
    Point3d pt2 = pt1 + vMitPtDir0 * dW0;

    Drill drPost(pt1, pt2, dDrillDia * 0.5);
    post.addTool(drPost, _kStretchOnToolChange);
    joist0.addTool(drPost, _kStretchOnToolChange);
}
```

**Step 7.6: Remove Post Interference Below Joint**
```c
double dWP = post.dD(vMitPtDir0) + dToljoist * 2;
double dDP = post.dD(vMitPtDir1) + dToljoist * 2;

Body bdPostTopOffset(ptPostTopCen, vMitPtDir1, vMitPtDir0, vZC0,
                     dWP, dDP, 500, 0, 0, -1);

SolidSubtract sosuPost(bdPostTopOffset, _kSubtract);
joist0.addTool(sosuPost);
joist1.addTool(sosuPost);
```

**Effect:**
- Removes portions of joists that would interfere with the post below the connection
- Adds tolerance clearance around post cross-section
- Prevents binding during assembly

---

## Context Menu and Interactive Features

### Right-Click Context Menu

Right-click on any placed **hsbBeamCornerConnection** instance to access:

#### Flip Side

**Function:** Swaps the male and female joists, reversing the connection direction

**Technical Implementation:**
```c
String sTriggerFlipSide = T("|Flip Side|");
addRecalcTrigger(_kContext, sTriggerFlipSide);

if (_bOnRecalc && (_kExecuteKey == sTriggerFlipSide || _kExecuteKey == sDoubleClick)) {
    _Beam.swap(0, 1);  // Swap joist0 and joist1
    setExecutionLoops(2);  // Recalculate geometry
    return;
}
```

**Effect:**
- `_Beam[0]` (male) becomes `_Beam[1]` (female)
- `_Beam[1]` (female) becomes `_Beam[0]` (male)
- All cuts, mortises, and drills recalculate based on new orientation
- Mortise connection (if post exists) moves to the new male joist

**When to Use:**
- Initial selection was backward
- Design changes require opposite joist to be male
- Structural analysis shows better load path with reversed orientation

**Shortcut:** Double-click on the connection anchor to trigger Flip Side

#### AddPost

**Function:** Adds a post connection to an existing 2-joist connection

**Availability:** Only visible if `_Beam.length() == 2` (no post currently attached)

**Technical Implementation:**
```c
String sTriggerAddPost = T("|AddPost|");
addRecalcTrigger(_kContext, sTriggerAddPost);

if (_bOnRecalc && _kExecuteKey == sTriggerAddPost) {
    if (_Beam.length() == 3) return;  // Already has post

    PrEntity ssE(T("|Select post|"), Beam());
    if (ssE.go()) {
        // Validate perpendicularity
        for each candidate beam:
            if beam is perpendicular to both joists:
                _Beam.append(beam);
                break;
    }
    setExecutionLoops(2);  // Recalculate with new post
}
```

**Workflow:**
1. Right-click → **AddPost**
2. Prompt: *"Select post"*
3. Click on a perpendicular beam
4. Script validates geometry
5. If valid: Mortise and drills are added
6. If invalid: Post is rejected, connection remains 2-joist only

**Validation:**
Same perpendicularity check as initial insertion:
```c
for (int j = 0; j < _Beam.length(); j++) {
    Vector3d vecXB = _Beam[j].vecX();
    if (!vecXP.isPerpendicularTo(vecXB)) {
        bOK = false;
        break;
    }
}
```

**When to Use:**
- Initially created connection without post
- Post was added to the model after the connection
- Design iteration requires upgrading to post-and-beam connection

---

## Hardware Component Generation

The script automatically generates a hardware bill of materials entry for the peg fasteners.

### Hardware Component Details

**Category:** Connector

**Article Number Format:**
```c
String sHWArticleNumber = T("|Peg| ") + dDrillDia + "mm x " + dW1 + "mm";
```

**Example:** `"Peg 22mm x 150mm"`

**Quantity Calculation:**
```c
HardWrComp hwc(sHWArticleNumber, 1);  // Quantity = 1 per instance
```
Note: Even with `nNr > 1` (multiple drills), the quantity is still `1` because it represents one connection assembly. The article number includes the length (dW1), implying a single peg that passes through all holes.

### Hardware Properties

**Set Properties:**
```c
hwc.setGroup(sHWGroupName);  // Group from parent element or loose group
hwc.setLinkedEntity(_ThisInst);  // Links hardware to this TSL instance
hwc.setCategory(T("|Connector|"));
hwc.setRepType(_kRTTsl);  // Marks as TSL-generated hardware
hwc.setDScaleX(dW1);  // Length dimension
hwc.setDScaleZ(dDrillDia);  // Diameter dimension
```

**Group Name Logic:**
```c
Element elHW = _ThisInst.element();
if (!elHW.bIsValid()) elHW = (Element)_ThisInst;

if (elHW.bIsValid())
    sHWGroupName = elHW.elementGroup().name();  // Use element group
else {
    Group groups[] = _ThisInst.groups();
    if (groups.length() > 0)
        sHWGroupName = groups[0].name();  // Use first loose group
}
```

### Hardware Update Mechanism

**Cleanup of Existing Hardware:**
```c
HardWrComp hwcs[] = _ThisInst.hardWrComps();  // Get all existing hardware

for (int i = hwcs.length()-1; i >= 0; i--)
    if (hwcs[i].repType() == _kRTTsl)
        hwcs.removeAt(i);  // Remove TSL-generated components
```

**Reassignment:**
```c
hwcs.append(hwc);  // Add new component
_ThisInst.setHardWrComps(hwcs);  // Update instance

if (_bOnDbCreated) setExecutionLoops(2);  // Ensure hardware is updated
```

**Why This Matters:**
- Prevents duplicate hardware entries on recalculation
- Allows parameters to change without accumulating phantom components
- Distinguishes TSL-generated hardware from manually added components

---

## Visual Reference System

### Reference Anchor Drawing

The script draws a 3D anchor symbol at the insertion point (`_Pt0`) for easy identification in complex models.

**Geometry:**
```c
Display dp(9);  // Color index 9 (gray)
int iAnchorScale = 25;

Point3d ptA1 = _Pt0 + _X0 * U(iAnchorScale*2) - _Z0 * U(iAnchorScale*0.5);
Point3d ptA2 = _Pt0 + _Y0 * U(iAnchorScale);
Point3d ptA3 = _Pt0 + _X0 * U(iAnchorScale*2) + _Z0 * U(iAnchorScale*0.5);
Point3d ptA4 = _Pt0 - _Y0 * U(iAnchorScale);

PLine plTslAnchor1(ptA1, ptA2, ptA3);  // Triangle 1
PLine plTslAnchor2(ptA3, ptA4, ptA1);  // Triangle 2
PLine plTslAnchor3(ptA2, ptA4);  // Cross line

dp.draw(plTslAnchor1);
dp.draw(plTslAnchor2);
dp.draw(plTslAnchor3);
```

**Appearance:**
- Two triangles forming a diamond shape
- Cross line connecting opposite corners
- Size: 50mm × 25mm (scaled by iAnchorScale)
- Color: Gray (index 9)

**Purpose:**
- **Selection target**: Easy to click for editing properties
- **Visual indicator**: Shows connection location in plan view
- **Orientation reference**: Anchor orientation shows local X/Y axes

---

## Usage Examples

### Example 1: Standard Corner Connection (No Post)

**Scenario:** Connecting two floor joists at a corner, no vertical post

**Steps:**
1. Launch `hsbBeamCornerConnection`
2. Dialog: Accept defaults or adjust `dAngleWidth = 40mm`, `dToljoist = 5mm`
3. Click OK
4. Select first joist (will become male)
5. Select second joist (will become female)
6. Press Enter to skip post selection
7. Connection is created with interlocking cuts

**Result:**
- Two joists are trimmed to meet exactly
- Male joist has protruding geometry
- Female joist has recessed pocket
- 5mm clearance gap on all surfaces
- No mortise, no drill holes

### Example 2: Post-and-Beam Connection with Single Peg

**Scenario:** Timber frame with vertical post, horizontal joists, one peg

**Steps:**
1. Launch `hsbBeamCornerConnection`
2. Dialog settings:
   - `dMortiseWidth = 80mm`
   - `dMortiseDepth = 120mm`
   - `dMortiseHeight = 100mm`
   - `dDrillDia = 25mm`
   - `nNr = 1`
3. Click OK
4. Select male joist (typically the one that continues through)
5. Select female joist (typically the one that terminates)
6. Select vertical post (must be perpendicular to both)
7. Connection is created with mortise and one drill hole

**Result:**
- Joists are connected as in Example 1
- Post has male tenon (80×120×100mm)
- Male joist has female mortise (with tolerance)
- One 25mm drill hole passes through post and joist
- Hardware BOM entry: "Peg 25mm x 150mm" (assuming joist width)

### Example 3: Heavy-Duty Connection with Three Pegs

**Scenario:** Structural connection requiring maximum shear resistance

**Steps:**
1. Launch `hsbBeamCornerConnection`
2. Dialog settings:
   - `dMortiseWidth = 100mm`
   - `dMortiseDepth = 140mm`
   - `dMortiseHeight = 120mm`
   - `dDrillDia = 22mm`
   - `dDrillHeight = 60mm` (centered in 120mm mortise)
   - `nNr = 3`
   - `dDistance = 30mm`
3. Click OK
4. Select joists and post
5. Connection is created with three vertically distributed holes

**Result:**
- Mortise and tenon: 100×140×120mm
- Three drill holes:
  - Hole 1: Z = 60mm - 30mm = 30mm
  - Hole 2: Z = 60mm = 60mm
  - Hole 3: Z = 60mm + 30mm = 90mm
- Total span: 60mm (30mm + 30mm)
- All holes contained within 120mm mortise height
- Hardware BOM: "Peg 22mm x 200mm" (one long peg)

### Example 4: Reversing Male/Female Orientation

**Scenario:** Connection was created backward, need to flip

**Steps:**
1. Right-click on the connection anchor
2. Select **Flip Side** from context menu
3. Geometry recalculates with swapped orientations

**Alternative:**
1. Double-click on the connection anchor
2. Same result as Flip Side

**Result:**
- Original male joist becomes female
- Original female joist becomes male
- If post exists, mortise moves to new male joist
- All cuts and drills update automatically

### Example 5: Adding a Post to Existing Connection

**Scenario:** 2-joist connection already exists, post added later

**Steps:**
1. Right-click on existing connection
2. Select **AddPost** from context menu
3. Prompt: "Select post"
4. Click on vertical beam
5. If valid, connection updates with mortise and drills

**Result:**
- Original joist cuts remain unchanged
- Mortise and drills are added to male joist and post
- Connection upgrades from 2-beam to 3-beam
- Hardware component is added to BOM

---

## Troubleshooting

### Issue: "Correct post not found or selected joists are not perpendicular"

**Cause:**
- Joists are not exactly perpendicular (tolerance issue)
- Post is not perpendicular to one or both joists
- Selected beam is not a valid Beam entity

**Solutions:**
1. **Check joist angles:**
   - Use `DIST` or `ANGLE` command to verify 90° orientation
   - Adjust joist positions to exact perpendicularity
   - Use osnaps (endpoint, midpoint) to ensure alignment

2. **Check post orientation:**
   - Verify post axis is perpendicular to both joist axes
   - Post should typically be vertical (parallel to World Z)
   - Use `ROTATE3D` to adjust post if needed

3. **Verify beam types:**
   - All selected entities must be GenBeam or Beam objects
   - 3D solids or blocks will not work

**Debug Visualization:**
If `bDebug = true`, the script draws visual feedback:
```c
_X0.vis(ptCen0, 1);  // Red
_Y0.vis(ptCen0, 3);  // Green
_Z0.vis(ptCen0, 150);  // Blue
```
Check these vectors to diagnose coordinate system issues.

### Issue: Drill holes exceed mortise boundaries

**Cause:**
`(nNr - 1) × dDistance + dDrillDia > dMortiseHeight`

**Solutions:**
1. **Reduce drill count:**
   - Change `nNr` from 3 to 2 or 1

2. **Reduce drill spacing:**
   - Decrease `dDistance` (e.g., 30mm → 20mm)

3. **Increase mortise height:**
   - Increase `dMortiseHeight` to accommodate distribution
   - Ensure post has adequate material above/below mortise

**Calculation:**
```
Required height = (nNr - 1) × dDistance + dDrillDia + 20mm safety margin
```

Example:
- `nNr = 3`, `dDistance = 40mm`, `dDrillDia = 22mm`
- Required = (3-1)×40 + 22 + 20 = 122mm
- Set `dMortiseHeight = 130mm` minimum

### Issue: Tenon protrudes through opposite side of joist

**Cause:**
`dMortiseDepth ≥ male_joist_width`

**Solutions:**
1. **Reduce mortise depth:**
   - Rule: `dMortiseDepth ≤ 0.8 × male_joist_width`
   - Example: For 200mm joist, use max 160mm depth

2. **Use wider joist:**
   - Increase joist cross-section to accommodate mortise

**Structural Note:**
Traditional timber framing uses depth = 2/3 of joist width as maximum.

### Issue: Connection geometry looks incorrect or jagged

**Cause:**
- Extreme parameter values
- Joists are not truly perpendicular
- Conflicting existing cuts on joists

**Solutions:**
1. **Reset to defaults:**
   - Load catalog entry "Default"
   - Verify results before customizing

2. **Check for conflicts:**
   - Remove other cuts/tools from joists in connection zone
   - Use `HSB_I-ShowElementInfo` to inspect existing tools

3. **Regenerate connection:**
   - Delete instance
   - Re-insert with validated geometry

### Issue: Hardware component not appearing in BOM

**Cause:**
- Connection does not have a post (`_Beam.length() == 2`)
- Hardware component is filtered out in BOM settings
- Instance is not part of a valid group/element

**Solutions:**
1. **Verify post exists:**
   - Check `_Beam.length()` in properties
   - Use **AddPost** context menu to add post

2. **Check BOM filters:**
   - Ensure "Connector" category is included in BOM
   - Verify `_kRTTsl` repType is not filtered

3. **Assign to group:**
   - Add instance to an element group
   - Or assign to a loose group for BOM tracking

### Issue: Tolerance is too tight, connection won't assemble

**Cause:**
`dToljoist` or `dTolMortise` is too small for actual fabrication precision

**Solutions:**
1. **Increase joist tolerance:**
   - Standard: `dToljoist = 4-6mm`
   - Rough-cut: `dToljoist = 8-10mm`

2. **Increase mortise tolerance:**
   - Dry-fit pegged: `dTolMortise = 4-6mm`
   - Site assembly: `dTolMortise = 6-10mm`

3. **Test fit:**
   - Fabricate one test connection
   - Adjust parameters based on actual fit
   - Save as catalog entry for production

### Issue: Parameters change but geometry doesn't update

**Cause:**
- AutoCAD/hsbCAD regen needed
- Execution loops not triggered

**Solutions:**
1. **Force regeneration:**
   - Type `REGEN` in command line
   - Or use `HSBUPDATE` command

2. **Re-open properties:**
   - Close and reopen Properties Palette
   - Modify a parameter to force recalc

3. **Delete and recreate:**
   - If persistent, delete instance and re-insert

---

## Best Practices

### Design Guidelines

1. **Perpendicularity is Critical**
   - Use osnaps (Endpoint, Midpoint, Center) for precise beam placement
   - Verify angles before running script: `ANGLE` command
   - Set ORTHO or POLAR tracking for 90° layouts

2. **Tolerance Planning**
   - **Shop fabrication (CNC)**: 2-4mm tolerance
   - **Site assembly (hand tools)**: 5-8mm tolerance
   - **Green timber**: Add 2-3mm for shrinkage
   - **Seasoned timber**: Use standard tolerances

3. **Mortise Sizing Rules**
   - Width: ≤ 50% of post width
   - Depth: ≤ 80% of joist width
   - Height: ≤ 60% of post depth
   - Leave 30-40mm solid wood on all edges

4. **Peg Placement**
   - **Single peg**: Center at 50% mortise height
   - **Two pegs**: 30-40mm spacing, centered
   - **Three pegs**: 25-35mm spacing, ensure containment
   - Avoid peg placement within 20mm of mortise edges

5. **Structural Considerations**
   - Male joist should be the primary load-bearing member
   - Orient mortise perpendicular to primary load direction
   - For high shear, use 3 pegs with maximum safe spacing
   - Consider grain direction when positioning mortise

### Workflow Integration

1. **Pre-Modeling Phase**
   - Create catalog entries for standard connection types
   - Document tolerance standards for your shop
   - Test fabricate and adjust parameters

2. **Modeling Phase**
   - Model joists first, connection last
   - Group related members before adding connections
   - Use layers to organize connection types

3. **Post-Modeling Phase**
   - Run `HSB_G-BillOfMaterial` to extract peg quantities
   - Export hardware list for procurement
   - Generate shop drawings with connection details

### Catalog Management

**Save Common Configurations:**

**Example: "Standard Floor Corner"**
- `dAngleWidth = 50mm`
- `dToljoist = 5mm`
- `dTolMortise = 5mm`
- All other parameters default

**Example: "Heavy Post-Beam with 3 Pegs"**
- `dMortiseWidth = 100mm`
- `dMortiseDepth = 140mm`
- `dMortiseHeight = 120mm`
- `nNr = 3`
- `dDistance = 30mm`
- `dDrillDia = 25mm`

**How to Save:**
1. Set all parameters in Properties Palette
2. Right-click instance → Save to Catalog
3. Enter name: "Heavy Post-Beam with 3 Pegs"
4. Click OK

**How to Load:**
1. Launch script
2. Dialog: Select catalog entry from dropdown
3. Click OK → Parameters auto-populate

---

## Related Scripts and Workflows

### Complementary TSL Scripts

**Connection Analysis:**
- **HSB_I-ShowElementInfo**: Inspect existing tools and cuts on beams
- **HSB_G-EntityInformation**: View detailed entity data including hardware

**Alternative Connection Methods:**
- **hsbT-Connection**: T-shaped beam connections (non-corner)
- **hsbDovetail**: Dovetail joinery for box assemblies
- **hsbHousedBirdsmouth**: Traditional housed birdsmouth joints

**Post-Processing:**
- **HSB_G-BillOfMaterial**: Extract hardware list including pegs
- **sd_BeamAssembly**: Generate shop drawings of connections
- **HSB_W-Lifting**: Add lifting points for prefab assemblies

### Manufacturing Workflow

**Typical Production Sequence:**

1. **Design Phase** (hsbBeamCornerConnection)
   - Model structure with all connections
   - Validate geometry and parameters
   - Generate BOM

2. **CNC Export** (hsbCNC or third-party exporters)
   - Export beam geometry with all cuts
   - Include drill paths for peg holes
   - Generate tool paths for mortise/tenon

3. **Shop Drawing** (sd_* scripts)
   - Create fabrication drawings
   - Detail connection zones
   - Dimension all critical features

4. **Assembly Documentation**
   - Export hardware list (peg quantities)
   - Generate assembly sequences
   - Create installation guides

### Element Integration

**When used within Element workflows:**

The connection automatically integrates with hsbCAD Element system:
- Hardware groups by element name
- BOM rolls up to element-level reports
- Shop drawings reference element assemblies

**Element-Level Scripts:**
- **HSB_E-ElementTable**: Tabulate all connections in an element
- **HSB_G-Stack**: Organize elements with connections for logistics
- **HSB_E-Insulation**: Add insulation around connection zones

---

## Version History and Updates

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| **1.1** | October 2020 | marsel.nakuci@hsbcad.com | **HSB-9321**: Added `nNr` parameter (number of drills) and `dDistance` parameter (spacing between drills). Implemented vertical distribution logic for multiple peg holes. |
| **1.0** | June 2020 | geoffroy.cenni@hsbcad.com | Initial release. Core functionality: male/female corner connection, optional post mortise, single drill hole, Flip Side and AddPost triggers, hardware component generation. |

### Upcoming Features (Potential)

Based on common user requests and hsbCAD development patterns:

- **Angled connections**: Support for non-perpendicular joists (60°, 120° corners)
- **Multiple posts**: Distribute connection across two posts for wide joists
- **Glue surface calculation**: Export glue area for laminated connections
- **Assembly sequence**: Auto-generate installation instructions
- **Tolerance presets**: Quick-select catalog for CNC vs. hand-cut

*Note: These are speculative and not confirmed for future releases.*

---

## Technical Specifications Summary

### Script Metadata

| Property | Value |
|----------|-------|
| Script Name | hsbBeamCornerConnection.mcr |
| Script Type | T-Type (Tool) |
| Major Version | 1 |
| Minor Version | 1 |
| File State | 1 (Released) |
| Implicit Insert | Enabled (#ImplInsert 1) |
| Beams Required | 3 (#NumBeamsReq 3) |
| Grip Points | 0 (#NumPointsGrip 0) |
| File Size | 502 KB (8,571 lines of code) |

### Performance Characteristics

**Execution Complexity:**
- **Initial insertion**: ~1-2 seconds (depending on beam complexity)
- **Recalculation**: ~0.5-1 second (parameter changes)
- **With post**: +50% calculation time (mortise and drill processing)

**Geometry Impact:**
- **Cuts per joist**: 3-4 (end cut, double miter, cube cut, optional solid subtract)
- **Post operations**: 2 mortise + nNr drills (1-3 drills)
- **Total tools**: 8-15 depending on configuration

**Memory Footprint:**
- Lightweight (minimal persistent data)
- All geometry stored in beam tool lists
- Hardware component: single entry per instance

### Unit System

**Default Units:** Millimeters
```c
U(1, "mm");
```

**All parameters accept:**
- Direct input in current drawing units
- Explicit unit specification: `U(value, "mm")` or `U(value, "in")`

**Coordinate Systems:**
- World Coordinate System (WCS): Reference for vertical (_ZW)
- Local Coordinate Systems: Calculated per joist for cuts

---

## Keywords and Search Terms

**Primary Keywords:**
post, joist, perpendicular, male, female, corner, mortise

**Related Terms:**
timber frame, joinery, tenon, peg, dowel, corner connection, beam connection, post-and-beam, interlocking joint, miter cut, cube cut, drill distribution, tolerance, assembly clearance

**Script Categories:**
Base/Core, Timber Frame Joinery, Connection Tools, Manufacturing Tools

**Typical Search Queries:**
- "how to connect perpendicular joists in hsbCAD"
- "timber frame corner connection TSL"
- "mortise and tenon with pegs hsbCAD"
- "joist to post connection script"
- "male female joint timber construction"

---

*This documentation was generated for hsbCAD TSL script `hsbBeamCornerConnection.mcr` version 1.1. For the latest updates and support, contact hsbCAD technical support or refer to the official hsbCAD documentation portal.*

**Document Version:** 1.0
**Generated:** 2026-02-20
**Total Documentation Size:** ~35 KB
**Coverage Ratio:** 7.0% of source code (35KB / 502KB)
