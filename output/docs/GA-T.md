# GA-T - Generic Angle Bracket T-Connection System

## Overview

**GA-T** (Generic Angle Bracket for T-Connections) is a comprehensive parametric hardware placement tool for creating T-type connections between timber beams and truss entities in hsbCAD. It provides multi-manufacturer support, automatic positioning, intelligent geometry validation, and complete hardware tracking for fabrication documentation.

**Primary Use Case:** Connecting perpendicular timber members where one beam (male) meets the side of another beam (female) at a 90-degree angle, typical in floor-to-wall, roof-to-wall, and beam-to-beam framing connections.

---

## Key Features

### Multi-Manufacturer Hardware Catalog System
- Supports major hardware vendors: **Simpson Strong-Tie**, **Würth**, **Cullen**, and custom manufacturers
- XML-based product catalogs with complete specifications
- Family-based organization (e.g., AB, ABR, E5 series)
- Product dimension parameters (A, B, C, t) with hole patterns
- Fastener type definitions (nails, screws, anchors)

### Intelligent Placement & Validation
- Automatic geometric fit validation at insertion
- Attempts mirrored and rotated positions if initial placement fails
- Validates full surface contact between bracket and both beams
- Real-time collision detection with existing GA-T instances
- "Not possible" visual feedback for invalid configurations

### Manufacturing Integration
- Optional pocket milling for flush mounting (male, female, or both beams)
- Configurable milling tolerance
- House-type beamcuts with relief settings
- Automatic hardware component tracking for BOM

### Batch Operations
- Painter Definition filtering for male and female beam selection
- Multiple connection placement in single operation
- Automatic group assignment from parent elements

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) - Parametric entity |
| **Required Input** | 0 beams (uses entity selection workflow) |
| **Version** | 2.24 (May 2023) |
| **Environment** | Model Space only |
| **Supported Entities** | GenBeam, Truss entities |
| **Connection Type** | T-connection (perpendicular planes) |

---

## Prerequisites

### 1. Catalog Files
The script requires XML catalog files in one of these search paths (priority order):

**Company Path (Highest Priority):**
```
[CompanyPath]\TSL\Settings\GenericAngle_[ManufacturerName].xml
```

**Installation Path:**
```
[InstallPath]\Content\General\TSL\Settings\GenericAngle_[ManufacturerName].xml
```

**Note:** If a company XML is found for a manufacturer, the installation XML for that manufacturer is **not loaded**. This allows company-specific overrides without modifying installation files.

### 2. Supported Manufacturers
Available manufacturers depend on installed catalog files. Standard catalogs include:
- **Simpson Strong-Tie DACH** (`GenericAngle_Simpson-StrongTie.xml`)
- **Würth DACH** (`GenericAngle_Wuerth.xml`)
- **Cullen UK** (`GenericAngle_Cullen.xml`)

### 3. Connection Geometry Requirements
- **Male Beam:** The beam receiving the bracket on its side face
- **Female Beam:** The beam the bracket attaches to (typically the supporting beam)
- **Angle:** Must be perpendicular (90°) - the script validates plane perpendicularity
- **Intersection:** Beams must intersect or be close enough for the bracket to span both

---

## User Interface Elements

### Properties Panel (OPM) Parameters

#### **General Category**

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| **Manufacturer** | Dropdown | Simpson-StrongTie, Würth, Cullen, etc. | Selects hardware vendor catalog |
| **Family** | Dropdown | Varies (e.g., AB, ABR, E5) | Product family/series within manufacturer |
| **Product** | Dropdown | Varies (e.g., AB70, AB90, AB105) | Specific product model and size |
| **Nail** | Dropdown | Varies (e.g., "Comb nail CNA4,0xl") | Fastener type (nail, screw, anchor) |

**Notes:**
- Family list populates after selecting Manufacturer
- Product list populates after selecting Family
- Nail list shows compatible fasteners for selected Family
- All selections are catalog-driven from XML files

#### **Positioning Category**

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Side horizontal** | Dropdown | left | left, right, both | Bracket placement side relative to male beam |
| **Offset** | Distance | 0 | Auto-constrained | Offset along beam axis from connection center |

**Side horizontal behavior:**
- **left:** Places bracket on the left side when viewed along male beam axis
- **right:** Places bracket on the right side
- **both:** Places two brackets (mirrored on both sides) - doubles hardware quantity

**Offset constraints:**
- The script automatically calculates allowable offset range based on beam intersection geometry
- If user-specified offset exceeds valid range, it's automatically clamped to the maximum/minimum
- Valid range ensures the bracket fully contacts both male and female beams

#### **Milling Category**

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Milling Type** | Dropdown | none | none, male, female, both | Creates pocket milling for flush bracket mounting |
| **Tolerance** | Distance | 0 | Any positive value | Additional clearance around bracket outline |

**Milling behavior:**
- **none:** Bracket sits on beam surface (default)
- **male:** Pockets into male beam by (t + Tolerance)
- **female:** Pockets into female beam by (t + Tolerance)
- **both:** Pockets into both beams by (t + Tolerance) each

**Use cases for milling:**
- When cladding/sheathing must sit flush with beam surface
- When bracket must be concealed within framing depth
- When additional fire protection requires recessing hardware

The milling creates **House-type beamcuts** with `_kReliefSmall` rounding for realistic toolpath representation.

#### **Painter Category**

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Male beam** | Dropdown | Disabled | Available Painter Definitions | Filter for male beam selection |
| **Female beam** | Dropdown | Disabled | Available Painter Definitions | Filter for female beam selection |

**Painter Definition workflow:**
1. Set Painter criteria before insertion (e.g., filter by material, size, layer)
2. During selection, only beams matching the Painter Definition are highlighted
3. Prompt text changes to indicate filtering is active
4. Useful for batch placement on standardized framing layouts

#### **Alignment Category**

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Z Axis Align** | Dropdown | Z | Z, -Z, Y, -Y | Controls bracket vertical orientation |

**Note:** This parameter is typically hidden (read-only). It's used internally for advanced orientation control in special cases (e.g., inverted connections, rotated assemblies).

---

### Context Menu (Right-Click)

| Menu Item | Action | Shortcut |
|-----------|--------|----------|
| **flip Y axis** | Mirrors the bracket to the opposite side of the connection | Double-click |
| **swap legs** | Swaps the long (B) and short (A) legs of asymmetric brackets | N/A |

**flip Y axis:**
- Toggles between left and right placement
- Equivalent to changing "Side horizontal" parameter
- Double-clicking the bracket executes this command automatically

**swap legs:**
- Only useful for asymmetric brackets (where A ≠ B)
- Reverses which leg attaches to male vs. female beam
- Example: AB105 has A=70mm, B=105mm - swapping changes which beam receives the longer leg

---

### Command Line Prompts

#### **Manufacturer Selection (if not pre-selected via OPM key)**
```
Dialog: Select Manufacturer from dropdown
```
- Shows all manufacturers with valid XML catalogs found in search paths
- Selection populates Family dropdown

#### **Family Selection**
```
Dialog: Select Family from dropdown
```
- Shows product families available for selected manufacturer
- Selection populates Product and Nail dropdowns

#### **Product and Fastener Selection**
```
Dialog: Select Product and Nail type
```
- Product: Specific size variant (e.g., AB70, AB90, AB120)
- Nail: Compatible fastener type for this family

#### **Male Beam Selection**
```
Select male beams or trusses:
```
If Painter Definition is active:
```
Select male beams/trusses to be filtered out by the painter selection:
```
- Click beam(s) that will receive the bracket on their side face
- Multiple selection allowed
- Press Enter or right-click to confirm

#### **Female Beam Selection**
```
Select female beams or trusses:
```
If Painter Definition is active:
```
Select female beams/trusses to be filtered out by the painter selection:
```
- Click beam(s) the bracket will attach to (support beams)
- Multiple selection allowed
- Press Enter or right-click to confirm

---

## Step-by-Step Usage Guide

### Method 1: Basic Insertion (Interactive Dialog)

**Step 1: Launch Script**
```
Command: TSLINSERT
Select: GA-T.mcr
```
Or use custom command:
```
Command: (defun c:GA_T() (hsb_ScriptInsert "GA-T")) GA_T
```

**Step 2: Select Hardware**
- **Manufacturer dropdown:** Choose "Simpson-StrongTie" (or available manufacturer)
- **Family dropdown:** Select product family (e.g., "AB" - Angle bracket without rib)
- **Product dropdown:** Select size (e.g., "AB90" - 90x90x55mm)
- **Nail dropdown:** Select fastener (e.g., "Comb nail CNA4,0xl")
- Click OK

**Step 3: Configure Positioning (Optional)**
- **Side horizontal:** "left" (default) or "right" or "both"
- **Offset:** 0 (adjustable after placement)
- **Milling Type:** "none" (unless flush mounting required)
- Click OK to proceed to insertion

**Step 4: Select Male Beams**
- Command prompt: `Select male beams or trusses:`
- Click the beam(s) receiving the bracket on the side
- Press Enter to confirm

**Step 5: Select Female Beams**
- Command prompt: `Select female beams or trusses:`
- Click the supporting beam(s)
- Press Enter to confirm

**Step 6: Automatic Placement**
The script now:
1. Calculates the intersection plane between male and female beams
2. Validates perpendicularity (must be 90° ± tolerance)
3. Checks if bracket geometry fits at the connection
4. If initial position fails, tries mirrored position
5. If mirrored fails, tries rotated Y/Z orientation
6. If all attempts fail, erases the instance and shows message

**Result:**
- **Success:** Bracket appears at connection with visual geometry
- **Failure:** Script erases itself (you'll see no bracket)

---

### Method 2: Pre-configured Insertion (OPM Key)

You can bypass the dialog by specifying manufacturer in the command:

```
Command: (defun c:GA_T_SIMPSON() (hsb_ScriptInsert "GA-T" "Simpson-StrongTie")) GA_T_SIMPSON
```

This pre-selects "Simpson-StrongTie" manufacturer, skipping the first dialog step.

**Advanced: Full OPM Key Specification**
You can specify Manufacturer?Family?Product in the OPM key (separated by `?`):
```
(hsb_ScriptInsert "GA-T" "Simpson-StrongTie?AB?AB90")
```
This pre-populates all three parameters (Manufacturer, Family, Product).

---

### Method 3: Batch Placement with Painter Definitions

**Use Case:** Place brackets on all floor joist-to-wall connections in a building

**Step 1: Set Up Painter Definitions**
Before launching GA-T:
1. Create Painter Definition "FloorJoists" (e.g., Layer="Floor", Material="Timber")
2. Create Painter Definition "ExteriorWalls" (e.g., Layer="Walls", Type="Stud Wall")

**Step 2: Launch GA-T and Configure Hardware**
- Select Manufacturer, Family, Product, Nail as in Method 1

**Step 3: Set Painter Filters**
- **Male beam:** Select "FloorJoists"
- **Female beam:** Select "ExteriorWalls"

**Step 4: Select Entities**
- When prompted to select male beams, window-select entire building
- Only joists matching "FloorJoists" definition will be included
- When prompted to select female beams, window-select entire building
- Only walls matching "ExteriorWalls" definition will be included

**Step 5: Review Results**
- GA-T instances created at all valid joist-to-wall intersections
- Invalid intersections (non-perpendicular, no contact) are automatically skipped

---

## Geometry Calculation Logic

### Connection Type Detection

The script supports two primary connection scenarios:

#### **Scenario 1: Standard T-Connection (Beams Intersecting)**
```
     Female Beam
         |
         |
=========|=========  Male Beam
         |
      Bracket
```
- Male beam axis is perpendicular to female beam side face
- Bracket placed at the intersection plane
- Most common use case

#### **Scenario 2: Crossing Beams (On Top of Each Other)**
```
  ==========  Male Beam (top)
  ----------  Female Beam (bottom)
      ||
   Bracket (connects layers)
```
- Male and female beams stacked vertically
- Bracket spans the gap between layers
- Used in floor systems, multi-layer assemblies

### Geometric Validation Checks

The script performs these validations before placement:

**1. Perpendicularity Check**
```c
if (abs(vecY0.dotProduct(_vecZ1)) > dEps)
{
    // Not perpendicular - reject or try rotation
}
```
- Male beam side plane must be perpendicular to female beam side plane
- Tolerance: 0.1mm (dEps)
- If failed, script tries rotating Y0/Z0 axes

**2. Full Contact Validation**
```c
PlaneProfile ppIntersect = ppFemaleCut.intersectWith(ppMaleCut);
if (ppSubtract.area() > dEps)
{
    // Bracket extends beyond beam surfaces - reject
}
```
- Bracket must fully contact both male and female beams
- Partial overlap is rejected
- Ensures structural validity

**3. Offset Range Calculation**
```c
double dOffsetMax = ptMax.dotProduct(vecDir) - _Pt0.dotProduct(vecDir) - .5 * dC;
double dOffsetMin = ptMin.dotProduct(vecDir) - _Pt0.dotProduct(vecDir) + .5 * dC;
```
- Calculates allowable offset range based on beam intersection extents
- User-specified offset is clamped to [dOffsetMin, dOffsetMax]
- Ensures bracket stays within beam boundaries

### Automatic Retry Logic

If initial placement fails, the script attempts these fallback strategies:

**Attempt 1: Mirrored Position**
- Flips bracket to opposite side (left ↔ right)
- Controlled by `yAxisMultiplyer` flag

**Attempt 2: Rotated Y/Z Orientation**
- Swaps Y0 and Z0 axes (for beams oriented differently)
- Sets `iRotateYZ = 1` flag
- Triggers re-execution via `setExecutionLoops(2)`

**Attempt 3: Aligned Mode**
- Final attempt with `iAlign = 1` flag
- Uses strict alignment along _X1 axis

**If all attempts fail:**
```c
reportMessage("\n" + scriptName() + " " + T("|Part can not be fitted|"));
eraseInstance();
```
The instance is deleted and user sees command line message.

---

## Catalog File Structure

### XML Schema Overview

The catalog XML follows this hierarchical structure:

```xml
<Hsb_Map>
  <unit ut="L" uv="millimeter"/>

  <lst nm="Manufacturer">
    <key nm="Simpson-StrongTie"/>
    <str nm="Material" vl="Galvanized Steel"/>
    <str nm="URL" vl="https://www.strongtie.de/"/>

    <lst nm="Family[]">
      <lst nm="Family">
        <key nm="AB"/>
        <str nm="Name" vl="AB"/>
        <str nm="FamilyDescription" vl="Angle bracket without rib"/>
        <str nm="url" vl="https://www.strongtie.de/products/ab"/>

        <lst nm="Nail[]">
          <lst nm="Nail">
            <str nm="Name" vl="Comb nail CNA4,0xl"/>
          </lst>
          <lst nm="Nail">
            <str nm="Name" vl="Screw CSA5,0xl"/>
          </lst>
        </lst>

        <lst nm="Product[]">
          <lst nm="Product">
            <key nm="AB70"/>
            <dbl nm="A" ut="L" vl="70"/>
            <dbl nm="B" ut="L" vl="70"/>
            <dbl nm="C" ut="L" vl="55"/>
            <dbl nm="t" ut="L" vl="2"/>
            <str nm="url" vl="https://www.strongtie.de/products/ab/ab70"/>

            <lst nm="DiamType[]">
              <lst nm="DiamType">
                <dbl nm="Diameter" ut="L" vl="5"/>
                <int nm="Number" vl="11"/>
              </lst>
              <lst nm="DiamType">
                <dbl nm="Diameter" ut="L" vl="4"/>
                <int nm="Number" vl="6"/>
              </lst>
            </lst>
          </lst>

          <lst nm="Product">
            <key nm="AB90"/>
            <dbl nm="A" ut="L" vl="90"/>
            <dbl nm="B" ut="L" vl="90"/>
            <dbl nm="C" ut="L" vl="55"/>
            <dbl nm="t" ut="L" vl="2"/>

            <lst nm="DiamType[]">
              <lst nm="DiamType">
                <dbl nm="Diameter" ut="L" vl="5"/>
                <int nm="Number" vl="15"/>
              </lst>
            </lst>
          </lst>
        </lst>

        <lst nm="Milling">
          <str nm="Milling" vl="none"/>
          <dbl nm="Tolerance" ut="L" vl="0"/>
        </lst>
      </lst>

      <lst nm="Family">
        <key nm="ABR"/>
        <str nm="Name" vl="ABR"/>
        <str nm="FamilyDescription" vl="Angle bracket with rib"/>
        <!-- Additional family definition -->
      </lst>
    </lst>
  </lst>
</Hsb_Map>
```

### Key XML Elements

#### **Manufacturer Level**
```xml
<lst nm="Manufacturer">
  <key nm="Simpson-StrongTie"/>  <!-- Manufacturer identifier -->
  <str nm="Material" vl="Galvanized Steel"/>  <!-- Material specification -->
  <str nm="URL" vl="https://..."/>  <!-- Company website -->
</lst>
```

#### **Family Level**
```xml
<lst nm="Family">
  <key nm="AB"/>  <!-- Family identifier (used as internal key) -->
  <str nm="Name" vl="AB"/>  <!-- Display name -->
  <str nm="FamilyDescription" vl="Angle bracket without rib"/>  <!-- Description for BOM -->
  <str nm="url" vl="https://..."/>  <!-- Family documentation URL -->
</lst>
```

#### **Product Level**
```xml
<lst nm="Product">
  <key nm="AB70"/>  <!-- Product identifier (article number) -->
  <dbl nm="A" ut="L" vl="70"/>  <!-- Leg height (male beam side) -->
  <dbl nm="B" ut="L" vl="70"/>  <!-- Leg width (female beam side) -->
  <dbl nm="C" ut="L" vl="55"/>  <!-- Bracket depth -->
  <dbl nm="t" ut="L" vl="2"/>   <!-- Material thickness -->
  <str nm="url" vl="https://..."/>  <!-- Product datasheet URL -->
</lst>
```

**Product Dimension Parameters:**

| Parameter | Description | Geometry |
|-----------|-------------|----------|
| **A** | Height of leg on male beam | Vertical extent along beam axis |
| **B** | Width of leg on female beam | Horizontal extent perpendicular to male |
| **C** | Bracket depth/length | Thickness of connection |
| **t** | Plate thickness | Sheet metal gauge |

#### **Fastener Hole Pattern (DiamType)**
```xml
<lst nm="DiamType[]">
  <lst nm="DiamType">
    <dbl nm="Diameter" ut="L" vl="5"/>  <!-- Hole diameter (mm) -->
    <int nm="Number" vl="11"/>  <!-- Number of holes of this diameter -->
  </lst>
</lst>
```

**Purpose:**
- Defines hole patterns for fastener quantity calculation
- Can have multiple diameter types per product (e.g., 5mm and 4mm holes)
- Used to calculate total fastener quantity: `Sum(Number) × iNrParts`

#### **Nail/Fastener Definition**
```xml
<lst nm="Nail[]">
  <lst nm="Nail">
    <str nm="Name" vl="Comb nail CNA4,0xl"/>  <!-- Fastener article number -->
  </lst>
  <lst nm="Nail">
    <str nm="Name" vl="Screw CSA5,0xl"/>
  </lst>
</lst>
```

**Notes:**
- Multiple fastener types can be defined per family
- User selects one type from dropdown
- Fastener quantity calculated from hole count in selected product

---

## Hardware Component Tracking

The script generates **HardWrComp** (Hardware Component) entries for BOM and fabrication:

### Component 1: The Bracket Itself

```c
HardWrComp hwc(sProduct, 1 * iNrParts);
hwc.setManufacturer(sManufacturerHwc);  // "Simpson-StrongTie"
hwc.setModel(sFamilyHwc);  // "AB" (Family written in Model field)
hwc.setDescription(mapFamily.getString("FamilyDescription"));  // "Angle bracket without rib"
hwc.setMaterial(sMaterial);  // "Galvanized Steel"
hwc.setCategory(T("|Connector|"));
hwc.setRepType(_kRTTsl);  // Marks as TSL-generated hardware
hwc.setDScaleX(dB);  // Female leg width
hwc.setDScaleY(dA);  // Male leg height
hwc.setDScaleZ(dC);  // Bracket depth
```

**Quantity Calculation:**
- `iNrParts = 1` for "left" or "right" side
- `iNrParts = 2` for "both" sides

**Article Number:**
- Set to `sProduct` (e.g., "AB90")

### Component 2: Fasteners

For each diameter type defined in the product:

```c
HardWrComp hwc(sNail, iNumber * iNrParts);
hwc.setRepType(_kRTTsl);
hwc.setDScaleY(dDiameter);  // Fastener diameter (e.g., 5mm)
```

**Quantity Calculation:**
- `iNumber` = hole count from DiamType (e.g., 11 holes)
- `iNrParts` = 1 or 2 (depending on "Side horizontal")
- Total = 11 × 1 = 11 nails (for single bracket)
- Total = 11 × 2 = 22 nails (for both sides)

**Example Output:**
For AB90 bracket on both sides:
- 2× AB90 bracket (article "AB90")
- 30× Comb nail CNA4,0xl (15 holes × 2 brackets)

### Group Assignment

The hardware components inherit the group from the connected element:

```c
Element elHW = _Entity[0].element();
if (elHW.bIsValid())
{
    sHWGroupName = elHW.elementGroup().name();
    assignToElementGroup(elHW, true, z, 'I');
}
```

This ensures:
- Brackets associated with "Wall-01" are grouped with Wall-01
- BOM reports can be filtered by element/group
- hsbShare tracking links hardware to specific assemblies

---

## Collision Detection

The script checks for overlaps with other GA-T instances:

```c
Body bdOther = t.map().getBody("body");
if (bdOther.hasIntersection(bd))
{
    setDependencyOnEntity(t);  // Track dependency
    Display dp(1);
    String sTextError = T("|Collision!!!|");
    dp.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
    return;  // Stop display with collision warning
}
```

**Behavior:**
1. Collects all GA-T instances in the drawing
2. Gets the 3D body geometry from each instance's Map
3. Tests for intersection with current bracket body
4. If collision found:
   - Adds dependency link to colliding instance
   - Displays "Collision!!!" text at insertion point in red (color 1)
   - Returns without displaying the bracket geometry

**Visual Feedback:**
- Normal display: Color 252 (gray)
- Collision: Red text "Collision!!!" at insertion point

**Resolution:**
- Adjust **Offset** parameter to move along beam axis
- Change **Side horizontal** to opposite side
- Delete one of the conflicting brackets
- Modify beam positions to eliminate overlap

---

## Milling Operations

When Milling Type is enabled, the script creates **House** beamcuts:

### Male Beam Milling (Milling Type = "male" or "both")

```c
House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
    dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1);
hs0.setRoundType(_kReliefSmall);
bm0.addTool(hs0);
```

**Geometry:**
- **Location:** `ptPart` (bracket attachment point)
- **Direction:** `vecMale` (along male beam axis)
- **Up vector:** `vecDir` (vertical along connection)
- **Normal:** `-vecFemale` (into male beam surface)
- **Dimensions:**
  - Length: `dA + (dT + dTolerance)` (bracket leg A + thickness + clearance)
  - Width: `dC` (bracket depth)
  - Depth: `dT + dTolerance` (pocket depth)

**Bracket Displacement:**
```c
bd0.transformBy(-vecFemale * (dT + dTolerance));
bd1.transformBy(-vecFemale * (dT + dTolerance));
```
The bracket geometry is moved into the pocket by the milling depth.

### Female Beam Milling (Milling Type = "female" or "both")

```c
House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
    dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1);
hs1.setRoundType(_kReliefSmall);
bm1.addTool(hs1);
```

**Geometry:**
- Similar to male milling, but:
  - Direction: `vecFemale` (along female beam axis)
  - Normal: `-vecMale` (into female beam surface)
  - Length: `dB + (dT + dTolerance)` (bracket leg B dimension)

### Both Beams Milling (Milling Type = "both")

Creates two separate House operations:
1. Male beam pocket
2. Female beam pocket

**Bracket Displacement:**
```c
bd0.transformBy(-vecFemale * (dT + dTolerance));
bd1.transformBy(-vecFemale * (dT + dTolerance));
bd0.transformBy(-vecMale * (dT + dTolerance));
bd1.transformBy(-vecMale * (dT + dTolerance));
```
The bracket is moved into both pockets (compound displacement).

### Relief Type Setting

```c
hs0.setRoundType(_kReliefSmall);
```

This applies small-radius corner rounding to the House beamcut, simulating realistic CNC router toolpath rather than sharp internal corners.

---

## Practical Usage Examples

### Example 1: Floor Joist to Rim Beam Connection

**Scenario:** Attach 2×10 floor joists to a double 2×10 rim beam at exterior wall

**Setup:**
- Male beams: Floor joists (multiple, spaced 16" O.C.)
- Female beam: Rim beam
- Hardware: Simpson AB90 angle brackets
- Fasteners: 10d common nails

**Steps:**
1. Launch GA-T
2. Select:
   - Manufacturer: "Simpson-StrongTie"
   - Family: "AB"
   - Product: "AB90" (90×90×55mm suits 2×10 joists)
   - Nail: "10d common nail"
3. Set Positioning:
   - Side horizontal: "left" (or "right" depending on layout)
   - Offset: 0
4. Select all floor joists as male beams (window select)
5. Select rim beam as female beam
6. Review placement - brackets appear at each joist-to-rim intersection

**Result:** One AB90 bracket per joist, 15 nails per bracket

### Example 2: Flush-Mounted Hanger for Ceiling Joists

**Scenario:** Ceiling joists must sit flush with finish surface - bracket needs to be recessed

**Setup:**
- Male beams: Ceiling joists (2×6)
- Female beam: Support beam (6×12 GLB)
- Hardware: Würth angle bracket with flush mounting
- Milling: Pocket into male beam to hide bracket

**Steps:**
1. Launch GA-T
2. Select:
   - Manufacturer: "Wuerth"
   - Family: (appropriate flush-mount series)
   - Product: (size matching joist)
   - Nail: (as specified)
3. Set Milling:
   - Milling Type: "male" (pocket into ceiling joist)
   - Tolerance: 1mm (clearance for installation)
4. Select ceiling joists as male beams
5. Select GLB beam as female beam

**Result:** Brackets recessed into joist bottom, flush with ceiling plane

### Example 3: Both-Sides Truss Connection

**Scenario:** Heavy roof truss needs brackets on both sides for wind uplift resistance

**Setup:**
- Male beam: Roof truss (double 2×4 top chord)
- Female beam: Wall top plate (double 2×6)
- Hardware: Simpson ABR105 (reinforced with rib)
- Placement: Both sides

**Steps:**
1. Launch GA-T
2. Select:
   - Manufacturer: "Simpson-StrongTie"
   - Family: "ABR" (angle bracket WITH rib for higher load capacity)
   - Product: "ABR105"
   - Nail: "16d sinker"
3. Set Positioning:
   - Side horizontal: "both" ← Key setting
4. Select truss as male beam
5. Select wall top plate as female beam

**Result:** Two ABR105 brackets (mirrored on left and right), doubled fastener quantity

### Example 4: Batch Placement with Painter Filtering

**Scenario:** Attach 200 floor joists to perimeter rim beam in multi-unit building

**Setup:**
- Painter Definition "FloorJoists_2x10" (filter by size and layer)
- Painter Definition "RimBeam" (filter by layer)

**Steps:**
1. Create Painter Definitions before launching GA-T:
   - "FloorJoists_2x10": Layer="Floor", Width=38mm, Height=235mm
   - "RimBeam": Layer="Structure", Type="Beam"
2. Launch GA-T
3. Select hardware (as in Example 1)
4. Set Painter filters:
   - Male beam: "FloorJoists_2x10"
   - Female beam: "RimBeam"
5. Select entities:
   - Window-select entire building for male beams
   - Window-select entire building for female beams
6. Script processes all valid intersections automatically

**Result:** 200 GA-T instances created in seconds, only at valid joist-rim intersections

---

## Troubleshooting Guide

### Problem: Script disappears immediately after insertion

**Cause:** Geometric validation failed - bracket cannot fit at selected position

**Possible Reasons:**
1. **Non-perpendicular connection**
   - Male and female beam planes are not at 90° angle
   - Check beam orientations with UCS alignment

2. **Bracket too large**
   - Selected product exceeds available space at intersection
   - Try smaller product size (e.g., AB70 instead of AB120)

3. **Insufficient beam overlap**
   - Beams don't intersect deeply enough for bracket to contact both
   - Extend beams or adjust positions

4. **Beam geometry issues**
   - Truss entity with complex profile
   - Solid body has voids or irregularities

**Solution:**
- Try different bracket size (smaller A and B dimensions)
- Verify beam perpendicularity (should be exactly 90°)
- Check beam intersection depth (must be > bracket C dimension)
- Review command line for specific error messages

---

### Problem: "not possible" text displays at connection

**Cause:** User changed properties to invalid configuration after successful insertion

**Reasons:**
1. **Changed product to larger size**
   - New bracket geometry doesn't fit existing connection

2. **Changed offset beyond valid range**
   - Offset moved bracket outside beam boundaries

3. **Changed side horizontal**
   - Mirrored position may not have valid geometry

**Solution:**
- Revert to previous product size
- Reset offset to 0
- Use "flip Y axis" context menu instead of changing property
- Delete and re-insert with correct parameters

---

### Problem: "Collision!!!" text appears

**Cause:** Bracket overlaps with another GA-T instance

**Reasons:**
1. **Multiple brackets on same connection**
   - Two GA-T instances placed at same location

2. **Offset overlap**
   - Adjacent connections with offset values causing brackets to touch

3. **Both-sides placement conflict**
   - One bracket set to "both", overlaps with separate single-side bracket

**Solution:**
- Adjust **Offset** parameter on one or both brackets to separate them
- Change **Side horizontal** to opposite side
- Delete redundant bracket
- Review connection design - may need different bracket spacing strategy

---

### Problem: Catalog/manufacturer not available in dropdown

**Cause:** XML catalog file not found in search paths

**Solutions:**
1. **Check file existence:**
   ```
   [CompanyPath]\TSL\Settings\GenericAngle_[ManufacturerName].xml
   [InstallPath]\Content\General\TSL\Settings\GenericAngle_[ManufacturerName].xml
   ```

2. **Verify XML filename format:**
   - Must start with `GenericAngle_`
   - Example: `GenericAngle_Simpson-StrongTie.xml`

3. **Check XML validity:**
   - Open in text editor or XML viewer
   - Verify `<Hsb_Map>` root element
   - Check for `<lst nm="Manufacturer">` node

4. **Create Settings folder if missing:**
   - Company path: `[CompanyPath]\TSL\Settings\`
   - Installation path: `[InstallPath]\Content\General\TSL\Settings\`

---

### Problem: Version conflict warning appears

**Message:**
```
A different Version of the settings has been found for GA-T
Current Version: 5  [DWG path]
Other Version: 6  [Install path]
```

**Cause:** XML catalog version in drawing differs from installation version

**Impact:**
- Informational only - does not prevent operation
- May indicate newer products available in updated catalog

**Solution:**
1. **Update company catalog:**
   - Copy newer XML from `[InstallPath]\Content\General\TSL\Settings\` to `[CompanyPath]\TSL\Settings\`

2. **Accept current version:**
   - No action needed if current catalog contains all required products

3. **Standardize version:**
   - Ensure all project team members use same catalog version
   - Distribute company XML to synchronized repositories

---

### Problem: Wrong fastener quantity in BOM

**Cause:** DiamType hole count mismatch in XML catalog

**Diagnosis:**
1. Check selected product in XML:
   ```xml
   <lst nm="DiamType[]">
     <lst nm="DiamType">
       <int nm="Number" vl="15"/>  <!-- Should match bracket hole count -->
     </lst>
   </lst>
   ```

2. Verify in Properties:
   - Hardware Component quantity = `Number × iNrParts`
   - For "both" sides: `Number × 2`

**Solution:**
- Correct the `Number` value in XML catalog to match actual bracket hole pattern
- Reload MapObject by deleting and reinserting GA-T instance
- Contact catalog maintainer if using installation catalog

---

### Problem: Bracket orientation incorrect

**Symptoms:**
- Bracket facing wrong direction
- Long leg on wrong beam
- Upside-down appearance

**Solutions:**

**Issue: Left/right reversed**
- **Action:** Right-click → "flip Y axis" (or double-click bracket)
- **Alternative:** Change "Side horizontal" property

**Issue: Long/short legs swapped**
- **Action:** Right-click → "swap legs"
- **Explanation:** For asymmetric brackets (A ≠ B), this reverses leg assignment

**Issue: Vertical orientation wrong**
- **Action:** Change "Z Axis Align" property (if not hidden)
- **Options:** Z, -Z, Y, -Y
- **Use case:** Inverted trusses, rotated assemblies

**Issue: Complete re-orientation needed**
- **Action:** Delete instance and re-insert
- **Check:** Verify UCS is correct before insertion
- **Note:** Script calculates orientation from beam local coordinate systems

---

### Problem: Milling pocket not appearing on beam

**Cause:** Milling Type set but beamcut not applied

**Diagnosis:**
1. **Check beam type:**
   - Milling only works on `GenBeam` entities
   - Truss entities may not support all beamcut types

2. **Check Milling Type parameter:**
   - Must be "male", "female", or "both" (not "none")

3. **Verify tolerance:**
   - Tolerance value should be ≥ 0
   - Negative tolerance may cause calculation errors

**Solution:**
- Ensure connected entities are GenBeam (not Truss or other types)
- Set Milling Type to appropriate value
- Set Tolerance ≥ 0 (typically 0-2mm)
- Recalculate instance (select → right-click → Recalc)

---

### Problem: Painter Definition not filtering beams

**Symptoms:**
- All beams selectable despite Painter filter
- Prompt doesn't change to indicate filtering

**Diagnosis:**
1. **Check Painter Definition exists:**
   - Open Painter Definition manager
   - Verify definition name matches dropdown selection

2. **Check definition criteria:**
   - Layer, color, material, size filters
   - Verify beams actually match criteria

3. **Check parameter setting:**
   - Must select Painter name from dropdown (not "Disabled")

**Solution:**
- Create or edit Painter Definition with correct criteria
- Ensure beams have properties matching filter (layer, color, etc.)
- Select Painter Definition before beam selection step
- Test Painter Definition with manual selection first

---

## XML Catalog Customization

### Creating a Custom Manufacturer Catalog

**Step 1: Copy Template**
```
Copy: [InstallPath]\Content\General\TSL\Settings\GenericAngle_Simpson-StrongTie.xml
To:   [CompanyPath]\TSL\Settings\GenericAngle_[YourManufacturer].xml
```

**Step 2: Edit Manufacturer Node**
```xml
<lst nm="Manufacturer">
  <key nm="YourManufacturer"/>  <!-- Change this -->
  <str nm="Material" vl="Stainless Steel"/>  <!-- Change material -->
  <str nm="URL" vl="https://yourcompany.com/"/>  <!-- Your URL -->
</lst>
```

**Step 3: Add Product Family**
```xml
<lst nm="Family">
  <key nm="CUSTOM-AB"/>  <!-- Your family code -->
  <str nm="Name" vl="CUSTOM-AB"/>
  <str nm="FamilyDescription" vl="Custom angle bracket series"/>
  <str nm="url" vl="https://yourcompany.com/products/custom-ab"/>

  <lst nm="Nail[]">
    <lst nm="Nail">
      <str nm="Name" vl="#10 Wood Screw"/>
    </lst>
  </lst>

  <lst nm="Product[]">
    <!-- Add products here -->
  </lst>
</lst>
```

**Step 4: Add Products**
```xml
<lst nm="Product">
  <key nm="CUSTOM-AB-100"/>  <!-- Article number -->
  <dbl nm="A" ut="L" vl="100"/>  <!-- Male leg height (mm) -->
  <dbl nm="B" ut="L" vl="100"/>  <!-- Female leg width (mm) -->
  <dbl nm="C" ut="L" vl="60"/>   <!-- Bracket depth (mm) -->
  <dbl nm="t" ut="L" vl="3"/>    <!-- Plate thickness (mm) -->
  <str nm="url" vl="https://yourcompany.com/products/custom-ab/custom-ab-100"/>

  <lst nm="DiamType[]">
    <lst nm="DiamType">
      <dbl nm="Diameter" ut="L" vl="5.5"/>  <!-- Hole diameter -->
      <int nm="Number" vl="12"/>  <!-- Total holes -->
    </lst>
  </lst>
</lst>
```

**Step 5: Save and Test**
1. Save XML file to `[CompanyPath]\TSL\Settings\`
2. Launch AutoCAD/hsbCAD
3. Insert GA-T → "YourManufacturer" should appear in dropdown
4. Select product and test placement

---

### Adding Products to Existing Manufacturer

If you have a company override of an existing manufacturer:

**Step 1: Locate Company XML**
```
[CompanyPath]\TSL\Settings\GenericAngle_Simpson-StrongTie.xml
```

**Step 2: Find Product Family**
```xml
<lst nm="Family">
  <key nm="AB"/>  <!-- Your target family -->
  <lst nm="Product[]">
    <!-- Existing products -->

    <!-- Add new product here -->
    <lst nm="Product">
      <key nm="AB135"/>
      <dbl nm="A" ut="L" vl="135"/>
      <dbl nm="B" ut="L" vl="90"/>
      <dbl nm="C" ut="L" vl="55"/>
      <dbl nm="t" ut="L" vl="2.5"/>
      <lst nm="DiamType[]">
        <lst nm="DiamType">
          <dbl nm="Diameter" ut="L" vl="5"/>
          <int nm="Number" vl="18"/>
        </lst>
      </lst>
    </lst>

  </lst>
</lst>
```

**Step 3: Update Version Number**
```xml
<lst nm="GeneralMapObject">
  <int nm="Version" vl="7"/>  <!-- Increment this -->
</lst>
```

**Step 4: Reload MapObject**
1. Open drawing
2. Command: `MAPOBJECTEDIT`
3. Find "hsbTSL" → "GenericAngle"
4. Delete MapObject
5. Re-insert GA-T instance (reads fresh XML)

---

### Testing Custom Catalog

**Basic Validation:**
1. XML syntax valid (opens in browser without error)
2. Manufacturer appears in GA-T dropdown
3. Family populates after selecting manufacturer
4. Products appear in product dropdown
5. Bracket geometry displays correctly

**Geometry Validation:**
1. Insert bracket on test connection
2. Verify dimensions:
   - A leg extends correct distance along male beam
   - B leg extends correct distance along female beam
   - C depth matches catalog specification
   - t thickness matches plate gauge

**Hardware Validation:**
1. Insert GA-T instance
2. Command: `HSB_ELEMENTBOM`
3. Check hardware components:
   - Bracket article number correct
   - Fastener quantity = DiamType Number × iNrParts
   - Manufacturer and Model fields populated

**Milling Validation (if milling enabled in catalog):**
1. Set Milling Type = "male"
2. Verify House beamcut appears on male beam
3. Check pocket depth = t + Tolerance
4. Verify bracket recessed into pocket

---

## Related Scripts and Workflows

### Related Hardware Placement Scripts

| Script | Purpose | Relationship to GA-T |
|--------|---------|----------------------|
| **GA.mcr** | Generic Angle Bracket (general) | Parent/generic version without T-specific logic |
| **GCS.mcr** | Generic Connection System | Broader connector system, may use GA-T internally |
| **CC.mcr** | Corner Connector | Similar catalog-driven approach for corner connections |
| **GenericHanger.mcr** | Beam hanger system | Similar XML structure, different geometry |
| **Simpson StrongTie *.mcr** | Brand-specific hangers | Pre-configured alternatives to generic system |

### Workflow Integration

#### **Design Phase:**
1. Create framing layout (walls, floors, roofs)
2. Use GA-T for standard T-connections
3. Use specialized scripts for corner/ridge connections

#### **Detailing Phase:**
1. GA-T generates hardware components
2. Run `HSB_G-BillOfMaterial` for hardware BOM
3. Export to hsbShare for fabrication

#### **Shop Drawing Phase:**
1. GA-T instances visible in shop drawings
2. Hardware lists include GA-T components
3. Milling operations export to CNC

---

## Advanced Techniques

### Technique 1: OPM Key Automation

Create toolbar buttons for frequently-used brackets:

```lisp
; Simpson AB90 with 10d nails
(defun c:AB90()
  (hsb_ScriptInsert "GA-T" "Simpson-StrongTie?AB?AB90")
)

; Simpson ABR105 for heavy connections
(defun c:ABR105()
  (hsb_ScriptInsert "GA-T" "Simpson-StrongTie?ABR?ABR105")
)
```

**Benefit:** One-click insertion with pre-configured hardware

### Technique 2: Catalog-Based Insertion

Create catalog files for project-specific brackets:

**File:** `[CompanyPath]\TSL\Catalog\GA-T_Project123.xml`

```xml
<catalog>
  <entry name="FloorJoist_Standard">
    <prop index="0" value="Simpson-StrongTie"/>
    <prop index="1" value="AB"/>
    <prop index="2" value="AB90"/>
    <prop index="3" value="10d common"/>
    <prop index="4" value="left"/>
  </entry>
</catalog>
```

**Usage:**
```
Command: (hsb_ScriptInsert "GA-T" "FloorJoist_Standard")
```

**Benefit:** Standardized hardware across project, ensures consistency

### Technique 3: Scripted Batch Placement

Use LISP to place brackets at all connections:

```lisp
(defun c:PlaceAllJoistBrackets()
  (setq joists (selectBeamsByLayer "Floor_Joists"))
  (setq rim (selectBeamsByLayer "Rim_Beam"))

  (foreach joist joists
    (progn
      (command "_TSLINSERT" "GA-T" "Simpson-StrongTie?AB?AB90")
      (command "_SELECT" joist "")
      (command "_SELECT" rim "")
    )
  )
)
```

**Benefit:** Automated placement for large projects

### Technique 4: Dynamic Offset Calculation

Adjust offset based on beam spacing:

```c
// In custom wrapper script
double spacing = 400.0; // mm
double offset = spacing / 2.0;

Map props;
props.setDouble("dOffset", offset);
TslInst tsl;
tsl.dbCreate("GA-T", ...);
tsl.setPropValuesFromMap(props);
```

**Benefit:** Consistent bracket spacing based on framing grid

---

## Performance Considerations

### Large Projects (1000+ Connections)

**Issue:** Inserting GA-T instances one-by-one is slow

**Solutions:**
1. **Use Painter Definitions** for filtered batch selection
2. **Pre-configure OPM keys** to skip dialog steps
3. **Disable automatic recalc** during insertion:
   ```
   Command: TSLAUTOUPDATE
   Set to: 0 (manual recalc only)
   ```
4. **Insert in batches** by zone/area rather than entire building

**Recalc Strategy:**
- Insert all GA-T instances first (quick)
- Recalc all at once: `TSLRECALCALL`
- Benefit: Geometry calculated in single pass

---

### Collision Detection Overhead

**Issue:** Collision checking scales with number of GA-T instances

**Impact:**
- 10 instances: negligible
- 100 instances: ~1 second per insertion
- 1000 instances: may become noticeable

**Optimization:**
- Group GA-T instances by zone/floor
- Use separate drawings for different building sections
- Collision detection only searches Model Space (not Xrefs)

---

### MapObject Caching

The script caches XML catalogs as MapObjects for performance:

**First insertion:**
1. Reads XML from disk
2. Creates MapObject in drawing dictionary
3. Future insertions read from MapObject (fast)

**Updating catalogs:**
- Deleting MapObject forces re-read from XML
- Use `MAPOBJECTEDIT` to manage cached data

---

## Version History Summary

| Version | Date | Key Changes |
|---------|------|-------------|
| **2.24** | May 2023 | Catches invalid manufacturer definition |
| **2.23** | Oct 2022 | Company XML priority over installation XML |
| **2.22** | Oct 2022 | Family written to Model field, FamilyDescription to Description |
| **2.21** | Sep 2022 | New XML structure similar to GenericHanger |
| **2.19** | Jan 2022 | Group assignment added |
| **2.18** | Dec 2021 | Display published for hsbMake and hsbShare |
| **2.14** | Sep 2021 | Changed from Type T to Type O, supports Truss entities |
| **2.12** | Dec 2020 | Painter Definition support |
| **2.6** | Sep 2020 | XML version conflict checking |
| **2.1** | Mar 2020 | Collision detection, default dialog values |
| **2.0** | Mar 2020 | Full coverage validation, auto-retry mirrored/rotated positions |

---

## Frequently Asked Questions

### Q: What's the difference between GA.mcr and GA-T.mcr?

**A:** GA.mcr is a general-purpose angle bracket tool, while GA-T.mcr is specialized for **T-connections** (perpendicular beams). GA-T has more advanced geometric validation for this specific connection type, including automatic retry logic and offset range calculation.

---

### Q: Can I use GA-T for connections that aren't exactly 90 degrees?

**A:** No. GA-T strictly requires perpendicular planes (tolerance ≈ 0.1mm). For angled connections, use:
- Specialized angle bracket scripts for common angles (45°, 60°, etc.)
- Generic hardware placement tools
- Custom TSL for non-standard geometry

---

### Q: How do I add my own manufacturer to the system?

**A:** Create an XML file named `GenericAngle_[YourManufacturer].xml` following the catalog structure (see **XML Catalog Customization** section). Place it in `[CompanyPath]\TSL\Settings\`. The manufacturer will appear in the dropdown on next insertion.

---

### Q: Why does the offset parameter sometimes change on its own?

**A:** GA-T automatically clamps offset to valid range based on beam geometry. If you enter 500mm but the maximum valid offset is 300mm, it will auto-correct to 300mm. This ensures the bracket stays within beam boundaries and maintains full contact.

---

### Q: Can I use GA-T with steel beams or other materials?

**A:** Technically yes (it works with any GenBeam entity), but GA-T is designed for **timber-to-timber connections** with standard hardware catalogs. For steel, consider:
- Steel-specific connection scripts
- Welded connection details (different workflow)
- Bolt pattern generators

The hardware catalogs are timber-specific (nails, screws), so steel fasteners would require custom catalog entries.

---

### Q: What happens if I change the manufacturer after insertion?

**A:** The script recalculates with the new manufacturer's catalog. However:
- Product families may differ between manufacturers
- Existing product selection may become invalid
- You may see "not possible" if new hardware doesn't fit same geometry
- Hardware components in BOM are regenerated

**Best practice:** Select correct manufacturer before insertion, or delete and re-insert if major changes needed.

---

### Q: How are hardware components tracked in hsbShare?

**A:** GA-T sets `RepType = _kRTTsl` on hardware components, marking them as TSL-generated. This allows:
- Automatic removal when instance is deleted
- Regeneration when instance recalculates
- Linking to parent element/group
- Export to fabrication systems

The hardware appears in hsbShare BOM with:
- Article Number = Product (e.g., "AB90")
- Manufacturer = Catalog manufacturer
- Model = Family (e.g., "AB")
- Quantity = calculated from hole patterns

---

### Q: Can I customize the milling relief type?

**A:** Currently, the relief is hardcoded to `_kReliefSmall`. To change:
1. Modify the TSL source code (requires programming knowledge)
2. Create a custom wrapper script that modifies the beamcut
3. Request enhancement from hsbCAD development

For most timber framing, `_kReliefSmall` is appropriate (simulates 6-10mm router radius).

---

### Q: Why do I see a version conflict message?

**A:** The XML catalog in your drawing dictionary has a different version number than the installation XML. This is informational only - it means:
- A newer/older catalog version exists in installation folder
- Products may have been added/removed in new version
- No functional impact unless specific products are missing

To resolve: Copy the desired XML to company path and delete the MapObject to force re-read.

---

### Q: Can GA-T place multiple brackets at a single connection?

**A:** Not directly in one instance. For multiple brackets:
- Use "Side horizontal = both" for left+right brackets (same product)
- Insert separate GA-T instances with different offsets
- Note: Collision detection will warn if they overlap - adjust offsets to separate

---

### Q: What's the maximum number of GA-T instances per drawing?

**A:** No hard limit. Performance considerations:
- **< 100 instances:** No issues
- **100-500 instances:** Collision detection adds ~1 second per insertion
- **500+ instances:** Consider disabling auto-recalc during insertion

The collision detection searches all GA-T instances, so large quantities increase search time.

---

### Q: How do I export GA-T hardware to Excel/CSV?

**A:** Use hsbCAD BOM export:
1. Command: `HSB_G-BillOfMaterial`
2. Select GA-T instances (or entire element)
3. Export format: Excel, CSV, or XML
4. Hardware components appear with:
   - Article Number (Product)
   - Manufacturer
   - Quantity (calculated from iNrParts)
   - Linked element/group

Fasteners are separate line items with calculated quantities.

---

## Summary

GA-T is a production-ready, catalog-driven hardware placement system for timber T-connections. Key strengths:

✓ **Multi-manufacturer flexibility** via XML catalogs
✓ **Intelligent geometric validation** with auto-retry
✓ **Manufacturing integration** (milling, CNC, BOM)
✓ **Batch operations** via Painter Definitions
✓ **Collision detection** for quality control
✓ **Hardware tracking** for fabrication workflow

**Best suited for:**
- Stick-frame construction (floor, wall, roof)
- Standard T-connections (joist-to-beam, truss-to-wall)
- Production environments with catalog-based hardware standardization
- Projects requiring BOM accuracy and CNC integration

**Not suited for:**
- Non-perpendicular connections (use specialized scripts)
- Custom one-off hardware (requires catalog entry)
- Non-timber materials (catalog is timber-centric)

For questions or custom catalog development, consult your hsbCAD support team or refer to the XML catalog examples in `[InstallPath]\Content\General\TSL\Settings\`.

---

**Document Version:** 2.0
**Script Version:** GA-T v2.24
**Last Updated:** 2026-02-20
**Target Audience:** CAD Operators, Timber Framers, Production Managers
