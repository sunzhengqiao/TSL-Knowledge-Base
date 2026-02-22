# HSB_W-Lifting

## Overview

**HSB_W-Lifting** is an automated lifting point placement and machining script for timber wall and roof elements. It analyzes each element's geometry, weight, and center of gravity, then intelligently positions lifting rope attachment points on suitable vertical studs. The script applies precision tooling operations—drill holes, side cuts, or reinforcement components—to prepare elements for crane lifting during transportation and erection.

**Core Capabilities:**
- **Intelligent Rope Count Selection**: Automatically selects 1, 2, or 4 lifting ropes based on element length, weight, and custom thresholds
- **Center of Gravity Calculation**: Positions lifting points relative to the element's actual center of gravity (accounting for openings and mass distribution) rather than geometric center
- **Flexible Tooling Options**: Six tooling modes including dual-sided drilling, single-sided drilling, side notching, and reinforced single-side configurations
- **Adaptive Stud Detection**: Finds the optimal vertical stud at each calculated lifting location, handling grouped studs, angled top plates, and complex framing
- **Reinforcement Systems**: Optional reinforcement plates (sheets) or battens to strengthen drilled areas
- **Manual Override**: Draggable grip points allow precise repositioning after automatic placement

**Key Features:**
- Processes multiple elements in a single operation (master-satellite pattern)
- Filters beams by code and label with wildcard support
- Excludes jack studs if configured
- Handles both top plate and bottom plate lifting configurations
- Supports symmetric and asymmetric drill patterns through element thickness
- Creates visual symbols for coordination drawings and DXA export
- Prevents duplicate instances per identifier on the same element

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| **Model Space** | ✓ Yes | **Primary working environment.** All geometry, drilling operations, reinforcement components, and visual symbols are generated in Model Space. This is the only supported environment for this script. |
| **Paper Space** | ✗ No | Not applicable. This script operates exclusively on 3D element geometry. |
| **Shop Drawing** | ✗ No | Not applicable. While the script prepares elements for manufacturing, it is not a shop drawing generation tool. The visual symbols it creates are informational only. |

**Workflow Context:**
- **Typical Use Case**: Production planning stage, after wall/roof framing is complete but before manufacturing begins
- **Relationship to Other Scripts**: May be used in conjunction with `hsbCenterOfGravity` (called internally), `HSB_W-SplitPlatesExtraOptions` (for complex plate arrangements), and shop drawing scripts
- **Export Compatibility**: Lifting symbols are flagged for DXA output (`showInDxa(true)`)

## Prerequisites

### Required Entities

| Requirement | Details |
|-------------|---------|
| **Element Type** | One or more hsbCAD Wall Elements (`ElementWall`, `ElementWallSF`) or Roof Elements. Each element must be a valid, constructed element with a defined coordinate system. |
| **Minimum Framing** | At least one vertical stud in zone E0 that has a T-connection with a top plate (or bottom plate, depending on chosen side). The stud must be parallel to the element Y-axis (height direction). |
| **Stud Requirements** | Studs must exceed the "Minimal Stud Length" threshold (default 0 mm). They must pass beam code and label filters if configured. Jack studs can be excluded via property setting. |
| **Top/Bottom Plates** | At least one horizontal member of type `_kSFTopPlate`, `_kTopPlate`, `_kSFAngledTPLeft`, `_kSFAngledTPRight`, `_kDakFrontEdge`, or `_kSFBottomPlate` must exist and connect to vertical studs. |

### System Dependencies

| Dependency | Purpose |
|------------|---------|
| **hsbCenterOfGravity.mcr** | Called via `TslInst().callMapIO()` to compute element weight and center of gravity. This script must exist in the TSL library path. If missing, the script will use the element's geometric center as a fallback but cannot apply weight-based rope count rules. |
| **TslUtilities.dll** | (Not used by this script, but mentioned for context in related scripts.) |

### Operational Constraints

- **Unique Identifier Rule**: Each element can have only **one instance** of HSB_W-Lifting per identifier string. If you insert the script twice with the same identifier on the same element, the older instance is automatically erased and replaced.
- **Zone Restriction**: Only beams in zone E0 (primary structural zone) are considered for lifting point placement. Beams in other zones are ignored.
- **Beam Code Filter Syntax**: Supports exact matches (`BRACE`), prefix wildcards (`*BRACE`), suffix wildcards (`BRACE*`), and contains wildcards (`*BRACE*`). Multiple filters are separated by semicolons (`;`).

## Usage Steps

### Step 1: Launch the Script

**Method A: TSL Insert Command**
```
Command: TSLINSERT
Select script: HSB_W-Lifting.mcr
```

**Method B: hsbCAD Toolbar/Ribbon**
- Navigate to the Wall Framing or Erection tools section
- Click the Lifting Points icon (if configured in your workspace)

**Method C: Command Line Shortcut**
If a command alias is configured (e.g., `WLIFT`), type it directly at the AutoCAD command prompt.

### Step 2: Configure Initial Properties (Optional)

On first insertion (when no execute key is pre-set via batch operation), a properties dialog may appear. This step is **optional**—all settings can be adjusted later via the Properties Palette.

**Recommended Initial Settings:**
- **Tooling**: Choose the machining mode that matches your production workflow (default: "Drill stud and topplate")
- **Filter beams with beamcode**: Enter any beam codes to exclude (e.g., temporary bracing members)
- **Four ropes on walls longer than**: Adjust if your crane capacity differs from the default 7800 mm threshold

**Skipping the Dialog:**
If you press ESC or Cancel, the script will proceed with default values. You can modify them after insertion.

### Step 3: Select Wall or Roof Elements

```
Command Line Prompt: Select a set of elements
User Action:
  1. Click on one or more Wall or Roof elements in the drawing
  2. Press Enter to confirm the selection
```

**Selection Tips:**
- Use standard AutoCAD selection methods (individual picks, window, crossing, fence)
- You can select elements of different lengths and heights in a single operation
- The script processes each element independently, so different elements can have different rope counts (1, 2, or 4) based on their individual dimensions

**What Happens Behind the Scenes:**
1. The master instance (the one you inserted) reads its current property values
2. For each selected element, it creates a **satellite instance** of HSB_W-Lifting
3. Property values are transferred from master to satellites via catalog propagation (`setCatalogFromPropValues`, `setPropValuesFromCatalog`)
4. The master instance erases itself—only the satellite instances remain attached to elements

**Duplicate Handling:**
Before creating a satellite instance on an element, the script checks for existing instances with the same script name and identifier. Any matching older instances are erased automatically. This ensures only one active lifting configuration per identifier per element.

### Step 4: Review Automatic Placement

After insertion completes, the script executes its full calculation cycle on each element:

**4.1 Center of Gravity Calculation**
- Calls `hsbCenterOfGravity` via MapIO, passing all beams and openings in the element
- Receives back: weight (kg or lbs), center point (`ptCen`)
- This center point becomes the reference for all lifting point positions

**4.2 Rope Count Determination**
The script applies a three-tier logic:
```
IF element_length < 1200 mm THEN
    rope_count = 1
ELSE IF element_length >= 7800 mm OR element_weight > weight_threshold THEN
    rope_count = 4
ELSE
    rope_count = 2
END IF

IF "Double lifting" = Yes THEN
    rope_count = 4  (override)
END IF
```

**4.3 Lifting Point Positioning**
For each rope, a target position is calculated relative to the center of gravity:
- **1 Rope**: Positioned at the center of gravity
- **2 Ropes**: Each rope offset by `ratio2Ropes × distance_to_edge` (default: 0.525 × distance)
- **4 Ropes**: Inner pair at `ratio4Ropes1 × distance` (default: 0.25), outer pair at `ratio4Ropes2 × distance` (default: 0.75)

**4.4 Stud Selection**
At each target position, the script:
1. Filters all zone E0 beams by code, label, and jack exclusion rules
2. Identifies beams parallel to element Y-axis (vertical studs)
3. Verifies each stud has a T-connection with a top plate or bottom plate
4. Finds the stud closest to the target position
5. If multiple adjacent studs intersect the drill body, groups them and centers the lifting point on the group

**4.5 Tooling Application**
Based on the selected "Tooling" mode, the script applies cuts or drills to studs and/or top plates. See the "Tooling Modes in Detail" section below for specifics.

**4.6 Reinforcement Creation**
If "Stud drill reinforcement" is enabled (and tooling mode supports it), sheet entities (reinforcement plates) are created alongside the drilling studs. If "Drill stud and topplate one side" is selected, timber battens are created instead.

**4.7 Visual Symbol Generation**
Two types of symbols are drawn:
- **Rope Symbols**: Polyline outlines at each lifting grip point (visible in 3D elevation views)
- **Indicator Symbol**: Arrow-like symbol at the element origin (visible in both elevation and plan views)

### Step 5: Fine-Tune with Grip Points

Each lifting point is represented by a **draggable grip point** in the AutoCAD drawing.

**To Adjust Lifting Positions:**
1. Select the TSL instance (click on the visual lifting symbol or use the element's TSL list)
2. Hover over a grip point—it will highlight
3. Click and drag the grip point along the element length
4. Release the mouse—the script recalculates and snaps the grip to the nearest suitable stud

**Grip Point Behavior:**
- Grips can be moved freely along the element X-axis (length direction)
- The script automatically finds the closest valid stud at the new position
- If you drag a grip past the center of gravity, the script may swap the grip's position with its paired grip (for 2-rope or 4-rope configurations) to maintain left/right ordering
- **Custom Side Mode**: When "Side" is set to "Custom," dragging a grip above the element center line assigns it to the top plate; dragging below assigns it to the bottom plate

**Resetting Positions:**
If you've manually adjusted grips and want to restore the automatic calculation:
1. Right-click on the TSL instance
2. Select "Reset positions" from the context menu
3. All grips snap back to their original calculated locations

### Step 6: Adjust Properties as Needed

Open the **Properties Palette** (AutoCAD command: `PROPERTIES` or `Ctrl+1`) to modify any parameter.

**Common Adjustments:**
- **Drill Diameter**: Change if your lifting hardware requires a different hole size
- **Horizontal/Vertical Offset**: Adjust drill positions to avoid beam end cuts or other tooling
- **Rope Count Thresholds**: Modify "Four ropes on walls longer than" to match your crane capacity
- **Reinforcement Plate Dimensions**: Increase plate size for heavier elements or thinner studs
- **Display Settings**: Change color or symbol size for better visibility in coordination drawings

**Real-Time Recalculation:**
The script recalculates automatically when any property changes. You'll see drills, cuts, and reinforcement update immediately in the drawing.

## Properties Panel Parameters

### General Section

#### (Identifier)
- **Type**: String (Text)
- **Default**: `Pos 1`
- **Description**: Unique identifier for this script instance on the element. Only one instance of HSB_W-Lifting per identifier is allowed per element. If you need multiple lifting configurations on the same element (e.g., different drill sizes for production vs. erection), use different identifier values such as "Pos 1" and "Pos 2".
- **Business Logic**: During insertion, the script checks all existing TSL instances on the target element. Any instance with the same script name (`HSB_W-Lifting.mcr`) and the same identifier string is erased before the new instance is created. This prevents duplicate or conflicting lifting configurations.
- **Typical Usage**:
  - Production elements: "Pos 1"
  - Erection-specific lifting: "Erection"
  - Custom rigging: "Crane A", "Crane B"

---

### Tooling Section

#### Tooling
- **Type**: Dropdown (Enumeration)
- **Options**:
  1. `Drill stud and topplate` (Index 0)
  2. `Drill stud` (Index 1)
  3. `Side cuts in topplate` (Index 2)
  4. `No drills` (Index 3)
  5. `Drill stud and topplate one side` (Index 4)
  6. `Drill topplate one side` (Index 5)
- **Default**: `Drill stud and topplate`
- **Description**: Selects the type of machining operation applied at each lifting point. Each mode has distinct behavior—see "Tooling Modes in Detail" section below for complete descriptions.
- **Business Logic**: This property controls multiple code branches:
  - Index 0, 1, 4, 5: Applies drill operations to studs and/or top plates
  - Index 2: Applies `BeamCut` operations (rectangular notches) instead of drills
  - Index 3: Skips all machining, generates only visual symbols
  - Index 4, 5: Enables batten reinforcement logic and single-side drilling
- **Dependencies**: Affects which other properties are visible/applicable (e.g., "Batten Symmetry" only appears when index 4 or 5 is selected)

#### Side
- **Type**: Dropdown (Enumeration)
- **Options**:
  1. `Top plate` (Index 0)
  2. `Bottom plate` (Index 1)
  3. `Both` (Index 2)
  4. `Custom` (Index 3)
- **Default**: `Top plate`
- **Description**: Determines which plate(s) receive tooling operations. This setting controls whether lifting points are placed on the top edge, bottom edge, or both edges of the wall element.
- **Business Logic**:
  - **Top plate** (`iside == 0`): Tooling is applied only to studs connected to top plates. `nFacSide = 1` (positive Y direction).
  - **Bottom plate** (`iside == 1`): Tooling is applied only to studs connected to bottom plates. `nFacSide = -1` (negative Y direction). The list of acceptable beam types is switched to `_kSFBottomPlate`.
  - **Both** (`nToolSide == 2`): The tooling loop runs twice, once for top plates and once for bottom plates.
  - **Custom** (`nToolSide == 3`): Each grip point independently stores its side preference in the Map (`"Fac" + i`). Dragging a grip above the element center assigns it to the top plate (`Fac = 1`); dragging below assigns it to the bottom plate (`Fac = -1`).
- **Typical Usage**:
  - Standard wall elements: "Top plate"
  - Floor elements lifted from below: "Bottom plate"
  - Elements lifted from both top and bottom during erection: "Both"
  - Unusual geometries requiring mixed configurations: "Custom"

#### Filter beams with beamcode
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Semicolon-separated list of beam codes to **exclude** from lifting point placement. Beams matching any filter pattern are skipped during stud selection.
- **Wildcard Support**:
  - Exact match: `BRACE` (excludes beams with code exactly "BRACE")
  - Prefix wildcard: `*BRACE` (excludes codes ending with "BRACE", e.g., "TEMP_BRACE")
  - Suffix wildcard: `BRACE*` (excludes codes starting with "BRACE", e.g., "BRACE_01")
  - Contains wildcard: `*BRACE*` (excludes codes containing "BRACE" anywhere)
- **Processing Logic**:
  ```c
  String sFBC = sFilterBC + ";";
  sFBC.makeUpper();  // Case-insensitive matching
  String arSFBC[] = tokenize by ";";

  For each beam:
      String sBmCode = bm.beamCode().token(0).makeUpper();
      IF arSFBC.find(sBmCode) != -1 THEN
          exclude beam
      ELSE IF wildcard pattern matches THEN
          exclude beam
  ```
- **Example**: `TEMP*;*BRACE*;HEADER` excludes all codes starting with "TEMP", all codes containing "BRACE", and the exact code "HEADER".

#### Filter beams with label
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Semicolon-separated list of beam labels to exclude from consideration. Beams with matching labels are skipped during stud selection.
- **Processing Logic**: Similar to beam code filtering, but operates on the beam's `label()` property instead of `beamCode()`. Wildcards are **not supported** for label filtering—only exact matches.
- **Example**: `TEMP;NOGOOD;DELETE` excludes any beam labeled "TEMP", "NOGOOD", or "DELETE".

#### Exclude jacks
- **Type**: Dropdown (Yes/No)
- **Options**: `Yes`, `No`
- **Default**: `No`
- **Description**: When set to **Yes**, jack studs (studs above and below window/door openings) are excluded from lifting point candidate selection.
- **Business Logic**:
  ```c
  if (excludeJacks && (bm.type() == _kSFJackOverOpening || bm.type() == _kSFJackUnderOpening))
      continue;  // Skip this beam
  ```
- **Why Exclude Jacks?**: Jack studs are often shorter and may be load-bearing elements critical to opening support. Drilling them for lifting can weaken the opening frame. Exclude them to force lifting points onto full-height king studs instead.

---

### Drill Subsection

#### Centerpoint for drills
- **Type**: Dropdown (Enumeration)
- **Options**:
  1. `Element` (Index 0)
  2. `Beam by code` (Index 1)
- **Default**: `Element`
- **Description**: Reference entity for centering drill holes in the element Z direction (through-wall thickness direction).
- **Business Logic**:
  - **Element**: Drills are centered on the element coordinate system origin. The frame center is calculated as `ptEl - vzEl * 0.5 * el.zone(0).dH()`.
  - **Beam by code**: Drills are centered on a specific beam identified by its beam code. The beam's center point (`beamCenter = beamToCheck.ptCenSolid()`) becomes the reference. The lifting grip point is projected onto this center in the Z direction.
- **Use Case**: For walls with offset framing or double studs, you may want drills centered on the inner stud layer rather than the element center. Enter the inner stud's beam code in the next property.

#### Beamcode to center drills
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: When "Centerpoint for drills" is set to "Beam by code," enter the **exact beam code** of the reference beam here. The script will search all beams in the element and use the first match.
- **Validation**: If this field is empty when "Beam by code" is selected, the script displays a message: "Give beamcode to place the lifting holes" and halts processing.
- **Example**: If your inner stud layer is coded "STUD_IN", enter "STUD_IN" here.

#### Offset from center point
- **Type**: Length (Double)
- **Default**: `0 mm`
- **Unit Conversion**: `U(0)`
- **Description**: Shifts the drill position in the element Z direction relative to the chosen center reference. Only applied when "Offset symmetric or asymmetric" is set to **Symmetric**.
- **Business Logic**:
  ```c
  if (dOffsetFromFrameCenter != U(0) && isSemetric == true && elementCenterPoint)
      _PtG[i] += vzEl * vzEl.dotProduct((frameCenter + vzEl * dOffsetFromFrameCenter) - _PtG[i]);
  ```
  Both left and right drills are shifted by the same amount in the positive or negative Z direction.
- **Use Case**: Offset drills toward the exterior or interior face of the wall to avoid clashing with sheathing, siding, or other applied layers.

#### Offset symmetric or asymmetric
- **Type**: Dropdown (Enumeration)
- **Options**:
  1. `Symmetric` (Index 0)
  2. `Asymmetric` (Index 1)
- **Default**: `Symmetric`
- **Description**: Controls whether the two drill holes (left and right of stud center) are aligned or staggered through the element thickness.
- **Business Logic**:
  - **Symmetric** (`isSemetric = true`): Both drills use the same Z offset. They align vertically through the wall thickness.
  - **Asymmetric** (`isSemetric = false`): The left drill is shifted in one Z direction, the right drill in the opposite direction, creating a staggered pattern. This is implemented by applying `±vzEl * U(dOffsetFromFrameCenter)` with opposite signs to the left and right drill points.
- **Why Use Asymmetric?**: Staggered holes reduce stress concentration in the stud and can prevent splitting when the lifting load is applied.

#### Horizontal offset drill
- **Type**: Length (Double)
- **Default**: `80 mm`
- **Unit Conversion**: `U(80)`
- **Description**: Distance from the stud center to each drill hole along the element X direction (along the wall length). Two holes are placed symmetrically at `±dOffsetHor` from the stud center.
- **Business Logic**:
  ```c
  Drill drillStud(_PtG[i] - vyEl * dOffsetVert - vxEl * dOffsetHor,
                  _PtG[i] - vyEl * dOffsetVert + vxEl * dOffsetHor,
                  0.5 * dDiam);
  ```
  This creates a horizontal pair of drill holes centered on the lifting grip point.
- **Constraints**: The offset must be small enough to fit within the stud width. Excessive values may cause drills to miss the stud entirely.

#### Vertical offset drill
- **Type**: Length (Double)
- **Default**: `80 mm`
- **Unit Conversion**: `U(80)`
- **Description**: Distance from the top of the stud down to the drill hole center in the element Y direction (height direction).
- **Business Logic**: The lifting grip point is initially positioned at the top of the stud (where it meets the top plate). The drill center is then offset downward by this amount to provide clearance from the beam end and the plate connection.
- **Why Offset Downward?**: Drilling too close to the beam end can cause splitting. A 80 mm offset provides a safe margin while keeping the drill in the upper portion of the stud for easy access during rigging.

#### Diameter drill
- **Type**: Length (Double)
- **Default**: `16 mm`
- **Unit Conversion**: `U(16)`
- **Description**: Diameter of the drill holes placed through studs and/or top plates.
- **Business Logic**:
  ```c
  Drill drillStud(..., ..., 0.5 * dDiam);  // Radius passed to Drill constructor
  ```
- **Hardware Compatibility**: Match this to your lifting eye bolt or shackle pin diameter. Common sizes: 16 mm (5/8"), 20 mm (3/4"), 25 mm (1").

---

### Side Cuts Subsection

#### Width side cut
- **Type**: Length (Double)
- **Default**: `100 mm`
- **Unit Conversion**: `U(100)`
- **Description**: Width of the rectangular side notch cut into the front and back faces of the top plate at each lifting point. Only used when "Tooling" is set to "Side cuts in topplate."
- **Business Logic**:
  ```c
  BeamCut bcFront(ptFront, vzEl, bmTP.vecX(), vyBmTP,
                  2 * dTSideCut,      // Depth
                  dWSideCut,          // Width
                  2 * bmTP.dD(vyBmTP), // Height
                  1, 0, 0);
  bmTP.addTool(bcFront);
  ```
  A matching cut is applied to the back face.
- **Use Case**: Side cuts create a notch for a lifting strap or cable to nestle into, preventing lateral movement during the lift.

#### Depth side cut
- **Type**: Length (Double)
- **Default**: `6 mm`
- **Unit Conversion**: `U(6)`
- **Description**: Depth of the side notch measured inward from each face of the top plate.
- **Constraints**: Depth must be less than half the top plate thickness to avoid cutting completely through the plate.

---

### Reinforcement Plate Section

#### Stud drill reinforcement
- **Type**: Dropdown (Yes/No)
- **Options**: `Yes`, `No`
- **Default**: `No`
- **Description**: When set to **Yes**, reinforcement plates (sheet entities) are created alongside the studs at each drill location. These plates strengthen the stud around the drilled area.
- **Availability**: Not available when Tooling is set to "Drill stud and topplate one side" (index 4). That mode uses battens instead.
- **Business Logic**:
  ```c
  int nAddReinforcementplate = propPlaceReinforcementPlate == arSYesNo[0] ? true : false;

  if (nAddReinforcementplate && nToolType != 4 && studsToDrill.length() > 0 && iside < 1) {
      // Create reinforcement plates
  }
  ```
- **Why Reinforce?**: Drilling large holes (>20 mm) in thin studs (38×89 mm or 2×4) can reduce stud capacity by 30-40%. Reinforcement plates restore structural integrity.

#### Width of plate
- **Type**: Length (Double)
- **Default**: `0 mm`
- **Unit Conversion**: `U(0)`
- **Description**: Width of each reinforcement plate in the element X direction. A value of **0** triggers automatic sizing—the plate width is set to the stud width.
- **Business Logic**:
  ```c
  double leftPlateWidth = dWidthPlate > U(0) ? dWidthPlate : studsToDrill[0].dD(vzEl);
  ```
- **Typical Values**: 0 (auto), 50 mm, 75 mm, 100 mm

#### Height of plate
- **Type**: Length (Double)
- **Default**: `200 mm`
- **Unit Conversion**: `U(200)`
- **Description**: Height of the reinforcement plate measured along the element Y direction (height). A value of **0** triggers automatic sizing—the plate height is set to twice the vertical drill offset.
- **Business Logic**:
  ```c
  double plateHeight = dHeightPlate > U(0) ? dHeightPlate : dOffsetHor * 2;
  ```
- **Why 200 mm?**: This is approximately 4× the drill diameter for a 16 mm hole, providing adequate bearing area above and below the hole.

#### Thickness of plate
- **Type**: Length (Double)
- **Default**: `12 mm`
- **Unit Conversion**: `U(12)`
- **Description**: Thickness of the reinforcement plate material.
- **Material Options**: Common choices are 12 mm plywood, 12 mm OSB, or 3 mm steel plate.

#### Offset plate vertical
- **Type**: Length (Double)
- **Default**: `0 mm`
- **Unit Conversion**: `U(0)`
- **Description**: Vertical offset of the reinforcement plate center from the lifting grip point in the element Y direction.
- **Business Logic**: The plate reference point is calculated as:
  ```c
  Point3d center = _PtG[i] + dPlateOffsetHorizontal * vzEl - vyEl * dPlateOffset;
  ```
- **Use Case**: If the plate needs to be centered on the drill rather than the lifting grip, adjust this offset.

#### Offset plate horizontal
- **Type**: Length (Double)
- **Default**: `0 mm`
- **Unit Conversion**: `U(0)`
- **Description**: Horizontal offset of the reinforcement plate in the element Z direction (through-wall thickness).
- **Use Case**: Shift plates toward the interior or exterior face to avoid clashing with other components.

#### Angle plate
- **Type**: Angle (Double)
- **Default**: `0°`
- **Format**: `_kAngle` (displayed in degrees or radians based on AutoCAD units)
- **Description**: Rotation angle applied to the bottom cut of the reinforcement plate. Used to create angled or tapered plate edges.
- **Business Logic**:
  ```c
  Vector3d cutVectorLeft = -vyEl.rotateBy(dPlateAngle * sign, vzEl);
  Cut leftCut(cutPointLeft, cutVectorLeft);
  reinforcementLeft.addTool(leftCut);
  ```
  The cut angle rotates around the Z-axis.
- **Use Case**: Match the plate to angled or chamfered stud ends, or create decorative plate profiles.

#### Material of plate
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Material assignment for the reinforcement plates (e.g., "Plywood", "OSB", "Steel").
- **Business Logic**:
  ```c
  reinforcementLeft.setMaterial(sMaterialPlate);
  ```
- **BOM Impact**: This value appears in bill of materials and material schedules.

#### Grade of plate
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Grade designation for the reinforcement plate material (e.g., "Grade A", "Structural 1", "S235JR").
- **Example**: For plywood, use "Structural 1" or "AB". For steel, use "S235JR" or "A36".

#### Name of plate
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Name assigned to the reinforcement plates in the bill of materials.
- **Example**: "Lifting Plate", "Reinforcement PLY12", "Stud Doubler"

#### Beamcode of plate
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Beam code assigned to the reinforcement plates for identification and scheduling.
- **Example**: "PLATE_LIFT", "REINF_01"

#### Color of plate
- **Type**: Integer
- **Default**: `1`
- **Range**: 1–255 (AutoCAD color index)
- **Description**: Display color index for the reinforcement plates in the drawing.
- **Common Values**: 1 (red), 2 (yellow), 3 (green), 5 (blue), 7 (white/black)

#### Zone of plate
- **Type**: Integer
- **Default**: `0`
- **Range**: 0–10
- **Description**: Zone index within the element where the reinforcement plates are assigned.
- **Business Logic**:
  ```c
  reinforcementLeft.assignToElementGroup(el, true, sZonePlate, 'Z');
  ```
  The plates are assigned to zone layer 'Z' (general zone) within the specified zone index.

---

### Reinforcement Batten Section

*These properties are relevant **only** when "Tooling" is set to "Drill stud and topplate one side" (index 4). In this mode, a timber batten is placed on the opposite side of the stud from where the drill is applied, providing reinforcement.*

#### Batten Symmetry
- **Type**: Dropdown (No/Yes)
- **Options**: `No`, `Yes`
- **Default**: `Yes`
- **Description**: Controls whether battens are placed symmetrically (same side logic on both ends of the element) or asymmetrically (opposite sides at each end).
- **Business Logic**:
  - **Yes** (`iSymAsym = 1`): Both left and right lifting points use the same batten placement logic. If the left point has a batten on the inside, the right point also has a batten on the inside.
  - **No** (`iSymAsym = 0`): Left and right lifting points use mirrored batten placement. If the left point has a batten on the inside, the right point has a batten on the outside.
- **Context Menu Trigger**: This property is also controlled by the right-click menu item "Set Symmetric Batten / Set Asymmetric Batten".

#### Batten Side
- **Type**: Dropdown (Outside/Inside)
- **Options**: `Outside`, `Inside`
- **Default**: `Outside`
- **Description**: Determines which face of the wall the batten is placed on: **Outside** (exterior face) or **Inside** (interior face).
- **Business Logic**:
  ```c
  int bFlip = _Map.getInt("flip");
  if (bFlip == 0) sBattenInOut = sInOut[0];  // Outside
  if (bFlip == 1) sBattenInOut = sInOut[1];  // Inside
  ```
- **Context Menu Trigger**: This property is also controlled by the right-click menu item "Flip Side (inside/outside)".

#### Batten Length
- **Type**: Length (Double)
- **Default**: `300 mm`
- **Unit Conversion**: `U(300)`
- **Description**: Length of the reinforcement batten measured along the element height direction (Y-axis).
- **Minimum Value**: 50 mm (enforced by script)
- **Business Logic**:
  ```c
  if (dBattenLength < U(50)) dBattenLength.set(U(50));
  double dBeamLength = dBattenLength;
  ```
- **Typical Values**: 300 mm, 400 mm, 500 mm

#### Beamcode of Batten
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Beam code assigned to the batten for identification and scheduling.
- **Business Logic**:
  ```c
  if (sBattenBeamcode != "") beamReinforcementLeft.setBeamCode(sBattenBeamcode);
  ```
  If empty, a default code `";;;;;;;;;;;;"` is assigned (semicolons represent empty beam code fields).
- **Example**: "BATTEN_LIFT", "REINF_BATT"

#### Material of Batten
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Material assignment for the batten (e.g., "Spruce", "LVL", "Douglas Fir").
- **Fallback**: If empty, the script copies the material from the adjacent stud (`arBmStud[i].name("material")`).

#### Grade of Batten
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Grade designation for the batten material (e.g., "Grade 2", "2.1E").

#### Name of Batten
- **Type**: String (Text)
- **Default**: *(empty)*
- **Description**: Name assigned to the battens in the bill of materials.
- **Example**: "Lifting Batten", "Reinforcement 35×72"

**Property Update Events (HSB-20733):**
When any of the batten properties (Beamcode, Material, Grade, Name) are modified via the Properties Palette, the script detects the change and updates existing batten entities immediately:
```c
if (sBattenPropertyEvents.find(_kNameLastChangedProp) > -1) {
    Entity entLeft = _Map.getEntity("beamReinforcementLeft");
    Beam bmBattenLeft = (Beam)entLeft;
    if (bmBattenLeft.bIsValid()) {
        bmBattenLeft.setBeamCode(sBattenBeamcode);
        bmBattenLeft.setMaterial(sBattenMaterial);
        bmBattenLeft.setGrade(sBattenGrade);
        bmBattenLeft.setName(sBattenName);
    }
}
```

---

### Ruleset Section

#### Four ropes on walls longer than
- **Type**: Length (Double)
- **Default**: `7800 mm`
- **Unit Conversion**: `U(7800)`
- **Description**: Wall element length threshold above which four lifting ropes are used instead of two.
- **Business Logic**:
  ```c
  double dWallLength = vxEl.dotProduct(ptMax - ptMin);
  int bUseFourRopes = (dWallLength >= dWallLengthToSwitchToFourRopes) || (weight > weightToSwitchToFourRopes);
  ```
- **Crane Capacity Guidance**: 7800 mm (7.8 m) is a typical threshold for standard mobile cranes. Longer elements require wider rope spacing to prevent excessive bending moment.

#### One rope on walls shorter than
- **Type**: Length (Double)
- **Default**: `1200 mm`
- **Unit Conversion**: `U(1200)`
- **Description**: Wall element length threshold below which only one lifting rope is used.
- **Business Logic**:
  ```c
  int bUseOneRope = dWallLength < dWallLengthToSwitchToOneRope;
  ```
- **Why One Rope?**: Short elements (<1.2 m) are light and compact enough to be safely lifted from a single central point, simplifying rigging.

#### Four ropes on walls heavier than
- **Type**: Number (Double, no unit conversion)
- **Default**: `999999`
- **Format**: `_kNoUnit` (displayed as a pure number)
- **Description**: Element weight threshold above which four lifting ropes are used regardless of length. The weight value is in drawing units (kg if metric, lbs if imperial) and is compared directly without unit conversion.
- **Business Logic**:
  ```c
  double weight = mapIO.getDouble("Weight");  // From hsbCenterOfGravity
  int bUseFourRopes = (dWallLength >= dWallLengthToSwitchToFourRopes) || (weight > weightToSwitchToFourRopes);
  ```
- **Practical Use**: Set this to your crane's maximum two-point lift capacity. For example, if your crane can safely lift 2000 kg with two ropes, set this to 2000. Elements heavier than this will automatically use four ropes for load distribution.

#### Double lifting
- **Type**: Dropdown (Yes/No)
- **Options**: `Yes`, `No`
- **Default**: `No`
- **Description**: When set to **Yes**, forces the use of four lifting ropes regardless of element length or weight. The inner pair of ropes is offset by one stud spacing from the outer pair.
- **Business Logic**:
  ```c
  if (bDoubleLifting) {
      bUseFourRopes = true;
      ptLeft01 = centre - vxEl * ratio2Ropes * offsetFromCentre;
      ptLeft02 = ptLeft01 + vxEl * dStudSpacing;  // Offset by stud spacing
      ptRight01 = centre + vxEl * ratio2Ropes * offsetFromCentre;
      ptRight02 = ptRight01 - vxEl * dStudSpacing;
  }
  ```
- **Use Case**: When the standard four-rope spread pattern (using offset ratios) does not align well with your stud layout, "Double lifting" provides an alternative four-rope pattern based on stud spacing instead of element proportions.

#### Minimal Stud Length
- **Type**: Length (Double)
- **Default**: `0 mm`
- **Unit Conversion**: `U(0)`
- **Description**: Only studs longer than this value (measured as solid length, `bm.solidLength()`) are considered as lifting point candidates. Shorter studs are filtered out.
- **Business Logic**:
  ```c
  if (abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps) {
      if (bm.solidLength() > minimalStudLength) {
          arBmVertical.append(bm);
      } else {
          arBm.removeAt(arBm.find(bm));
      }
  }
  ```
- **Why Filter Short Studs?**: Short studs (e.g., cripple studs above headers) may not provide sufficient embedment for drilling or adequate structural capacity for lifting loads.

#### Offset ratio from center for 2 ropes
- **Type**: Number (Double, ratio)
- **Default**: `0.525`
- **Range**: 0.0 to 1.0 (enforced by script)
- **Description**: A value between 0 and 1 that defines how far from the center of gravity each rope is positioned when using 2 ropes. The ratio is multiplied by the distance from the center to the nearest element edge.
- **Example**: If the distance from center to edge is 2400 mm and the ratio is 0.525, each rope is positioned at `2400 × 0.525 = 1260 mm` from the center.
- **Business Logic**:
  ```c
  if (ratio2Ropes < 0 || ratio2Ropes > 1) ratio2Ropes.set(0.525);  // Force default if invalid

  Point3d ptLeft = centre - vxEl * ratio2Ropes * offsetFromCentre;
  Point3d ptRight = centre + vxEl * ratio2Ropes * offsetFromCentre;
  ```
- **Crane Physics**: A ratio of 0.5 places ropes exactly halfway between center and edge, which is optimal for uniform load distribution but may not align with stud positions. A ratio of 0.525 provides a slight outward bias to accommodate real-world stud layouts.

#### Offset ratio first rope from center for 4 ropes
- **Type**: Number (Double, ratio)
- **Default**: `0.25`
- **Range**: 0.0 to 1.0
- **Description**: Offset ratio for the **inner pair** of ropes when 4 ropes are used. This ratio defines the position of the first (closest to center) rope on each side.
- **Example**: With a center-to-edge distance of 2400 mm and ratio 0.25, the inner ropes are at `2400 × 0.25 = 600 mm` from the center.

#### Offset ratio second rope from center for 4 ropes
- **Type**: Number (Double, ratio)
- **Default**: `0.75`
- **Range**: 0.0 to 1.0
- **Description**: Offset ratio for the **outer pair** of ropes when 4 ropes are used. This ratio defines the position of the second (furthest from center) rope on each side.
- **Example**: With a center-to-edge distance of 2400 mm and ratio 0.75, the outer ropes are at `2400 × 0.75 = 1800 mm` from the center.
- **Typical 4-Rope Pattern**:
  - Inner left rope: center - 600 mm
  - Outer left rope: center - 1800 mm
  - Outer right rope: center + 1800 mm
  - Inner right rope: center + 600 mm

---

### Style Section

#### Layer
- **Type**: Dropdown (Enumeration)
- **Options**: `I-Layer`, `D-Layer`, `T-Layer`, `Z-Layer`
- **Default**: `I-Layer`
- **Description**: Assigns the lifting display graphics (visual symbols) to a specific element layer within the chosen zone.
- **Business Logic**:
  ```c
  if (sLayer == arSLayer[0])
      dpLifting.elemZone(el, nZnIndex, 'I');  // Installation layer
  else if (sLayer == arSLayer[1])
      dpLifting.elemZone(el, nZnIndex, 'D');  // Design layer
  else if (sLayer == arSLayer[2])
      dpLifting.elemZone(el, nZnIndex, 'T');  // Transport layer
  else if (sLayer == arSLayer[3])
      dpLifting.elemZone(el, nZnIndex, 'Z');  // Zone layer
  ```
- **Use Case**:
  - **I-Layer** (Installation): For erection/installation drawings
  - **D-Layer** (Design): For design documentation
  - **T-Layer** (Transport): For shipping and logistics drawings
  - **Z-Layer** (Zone): For general shop drawings

#### Zone index
- **Type**: Integer
- **Default**: `0`
- **Range**: 0–10 (valid zone indices)
- **Description**: Zone index for assigning the display graphics within the element. The zone index is adjusted if greater than 5:
  ```c
  int nZnIndex = nZoneIndex;
  if (nZnIndex > 5)
      nZnIndex = 5 - nZnIndex;  // Wrap around to negative zone indices
  ```

---

### Visualisation Section

#### Color
- **Type**: Integer
- **Default**: `3`
- **Range**: 1–255 (AutoCAD color index)
- **Description**: AutoCAD color index for the lifting rope symbols displayed in the drawing (polyline outlines at each grip point and the indicator symbol at the element origin).
- **Common Colors**: 1 (red), 2 (yellow), 3 (green), 4 (cyan), 5 (blue), 6 (magenta), 7 (white/black)

#### Symbol size
- **Type**: Length (Double)
- **Default**: `30 mm`
- **Unit Conversion**: `U(30)`
- **Description**: Size of the lifting indicator symbol drawn at the element origin point. Controls both the 3D elevation view and plan view symbols.
- **Symbol Geometry**:
  - **Elevation View** (3D):
    ```c
    Point3d ptSymbol01 = ptEl - vyEl * 2 * dSymbolSize;
    Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
    Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;
    // Draws an arrow pointing downward
    ```
  - **Plan View** (Z-direction):
    ```c
    Point3d ptSymbol01 = ptEl + vzEl * 2 * dSymbolSize;
    Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
    Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
    // Draws an arrow pointing forward
    ```

---

## Tooling Modes in Detail

The "Tooling" property selects one of six distinct operational modes. Each mode has unique behavior, applicable parameters, and use cases.

### Mode 0: Drill stud and topplate

**Description**: Creates drill holes through both the vertical studs and the horizontal top plate(s) at each lifting point.

**Operations:**
1. **Stud Drilling**:
   - Two horizontal holes drilled through each stud at `±dOffsetHor` from the stud center
   - Drill center positioned `dOffsetVert` below the top of the stud
   - Diameter: `dDiam`
   - If multiple adjacent studs intersect the drill body, the drill is centered on the group and resized to span all studs
2. **Top Plate Drilling**:
   - For each top plate beam that intersects the lifting point:
     - Two vertical holes drilled at `±dOffsetHor` horizontally from the stud center
     - Drill direction adjusted to be perpendicular to the top plate surface (handles angled top plates on gable walls)
     - Diameter: `dDiam`
     - Symmetric/Asymmetric offset logic applied in Z direction if configured

**Applicable Parameters:**
- All "Drill" subsection parameters
- "Reinforcement Plate" section (if "Stud drill reinforcement" = Yes)
- "Side" property controls which plate(s) are drilled (top, bottom, or both)

**Use Case**: Standard production workflow for walls with conventional lifting hardware (eye bolts, shackles). The through-holes in both stud and plate provide maximum connection strength.

**Code Reference:**
```c
if (nToolType == 0) {
    // Drill studs
    Drill drillStud(_PtG[i] - vyEl * dOffsetVert - vxEl * dOffsetHor,
                    _PtG[i] - vyEl * dOffsetVert + vxEl * dOffsetHor,
                    0.5 * dDiam);
    bmVertical.addTool(drillStud);

    // Drill top plates
    for (bmNotVertical : arBmNotVertical) {
        Drill drillAdjustedLeft(...);
        Drill drillAdjustedRight(...);
        bmNotVertical.addTool(drillAdjustedLeft);
        bmNotVertical.addTool(drillAdjustedRight);
    }
}
```

**CNC Considerations**: Stud drills are flagged with `excludeMachineForCNC(_kRandek)` to prevent export to Randek CNC machines, as these holes are typically drilled manually on-site or in the laydown yard.

---

### Mode 1: Drill stud

**Description**: Creates drill holes only through the vertical studs, not the top plates. The top plates remain undrilled.

**Operations:**
1. **Stud Drilling**: Identical to Mode 0 (two horizontal holes per stud)
2. **Top Plate**: No operations applied

**Applicable Parameters:**
- All "Drill" subsection parameters (except top plate drilling logic is skipped)
- "Reinforcement Plate" section (if enabled)
- "Side" property (determines which studs are targeted based on top/bottom plate connections)

**Use Case**:
- Walls where lifting straps or cables wrap around the top plate rather than threading through it
- Situations where drilling the top plate would weaken critical connections (e.g., pre-engineered trusses or headers)
- Temporary lifting configurations that will be removed before the top plate is finalized

**Code Reference:**
```c
if (nToolType == 1) {
    // Drill studs only
    Drill drillStud(...);
    bmVertical.addTool(drillStud);
    // Top plate drilling loop is skipped
}
```

---

### Mode 2: Side cuts in topplate

**Description**: Creates rectangular notches (side cuts) on the front and back faces of the top plate at each lifting point. No drilling operations are applied to studs or plates.

**Operations:**
1. **Find Top Plate**: At each lifting grip point, the script identifies the top plate beam using a half-line intersection test
2. **Create Front Cut**:
   - Position: `ptRope + vzEl * (0.5 * bmTP.dD(vzEl) - dTSideCut)`
   - Direction: `vzEl` (outward from element)
   - Dimensions: Width `dWSideCut`, Depth `2 * dTSideCut`, Height `2 * bmTP.dD(vyBmTP)`
3. **Create Back Cut**:
   - Position: `ptRope - vzEl * (0.5 * bmTP.dD(vzEl) - dTSideCut)`
   - Direction: `-vzEl` (outward from element)
   - Same dimensions as front cut

**Applicable Parameters:**
- "Width side cut"
- "Depth side cut"
- "Side" property (determines top plate vs. bottom plate)
- "Reinforcement Plate" section is **not applicable** (no stud drilling occurs)

**Visual Output**: Instead of rope drill symbols, the script draws a rectangular polyline outline at each lifting point showing the intended strap placement area.

**Use Case**:
- Lifting systems using wide straps (50 mm+) that benefit from lateral retention
- Elements with decorative or structural top plates where through-drilling is unacceptable
- Temporary erection configurations

**Code Reference:**
```c
if (nToolType == 2) {
    Beam bmTP = arBmTop[tp];
    Point3d ptRope = bmTP.ptCen() + bmTP.vecX() * bmTP.vecX().dotProduct(_PtG[i] - bmTP.ptCen());

    BeamCut bcFront(ptFront, vzEl, bmTP.vecX(), vyBmTP,
                    2 * dTSideCut, dWSideCut, 2 * bmTP.dD(vyBmTP), 1, 0, 0);
    bmTP.addTool(bcFront);

    BeamCut bcBack(ptBack, -vzEl, bmTP.vecX(), vyBmTP,
                   2 * dTSideCut, dWSideCut, 2 * bmTP.dD(vyBmTP), 1, 0, 0);
    bmTP.addTool(bcBack);
}
```

---

### Mode 3: No drills

**Description**: Generates only visual symbols at the calculated lifting points. No machining operations (drills, cuts) are applied to any beams.

**Operations:**
- Lifting grip points are calculated and positioned on suitable studs
- Visual rope symbols are drawn at each grip point
- Indicator symbols are drawn at the element origin
- No tools are added to any beams

**Applicable Parameters:**
- "Ruleset" section (controls rope count and positioning)
- "Visualisation" section (controls symbol appearance)
- "Side" property (affects grip point positioning)
- All "Tooling" subsection parameters are **ignored**

**Use Case**:
- Conceptual design phase to visualize lifting strategies without committing to machining operations
- Coordination drawings for crane operators
- Temporary markings for field crews to drill manually
- Elements that will be lifted using external hardware (e.g., clamps, vacuum lifters) rather than drilled connections

**Code Reference:**
```c
if (nToolType == 3) {
    // Skip all tooling operations
    // Draw visual symbols only
}
```

---

### Mode 4: Drill stud and topplate one side

**Description**: Drills holes through studs and top plates on **one side only** (left or right), and places a timber batten reinforcement on the **opposite side**. This creates an asymmetric lifting configuration.

**Operations:**
1. **Determine Drilling Side**:
   - Compare each grip point position to the element start/end outline points
   - Apply "Batten Symmetry" and "Batten Side" logic to decide left vs. right drilling
   - The `bFlip` and `iSymAsym` flags control side selection
2. **Drill Stud** (one side only):
   - Single drill on the selected side at `-vxEl * dOffsetHor` or `+vxEl * dOffsetHor`
   - Vertical position: `dOffsetVert` below top of stud
3. **Drill Top Plate** (one side only):
   - Single drill through the top plate on the same side as the stud drill
   - Drill direction adjusted to be perpendicular to plate surface
4. **Create Batten Reinforcement** (opposite side):
   - Timber beam entity (not sheet) created on the side opposite to drilling
   - Dimensions: Length `dBattenLength`, Width 72 mm, Thickness 35 mm (hardcoded)
   - Position: Aligned with stud face, centered on lifting grip point
   - Material/Grade/Beamcode copied from adjacent stud (or overridden by batten properties)

**Applicable Parameters:**
- All "Drill" subsection parameters (but only one drill per lifting point)
- Entire "Reinforcement Batten" section
- "Side" property
- "Reinforcement Plate" section is **not applicable** (battens are used instead)

**Right-Click Menu Extensions**:
- "Flip Side (inside/outside)": Toggles which side is drilled vs. which side gets the batten
- "Set Symmetric Batten / Set Asymmetric Batten": Controls batten placement logic across multiple lifting points

**Use Case**:
- Wall systems where one face must remain undrilled (e.g., pre-finished exterior face)
- Elements with asymmetric loading or handling requirements
- Situations where visual appearance on one side is critical
- Specialty lifting hardware that requires reinforcement on one face only

**Code Reference:**
```c
if (nToolType == 4) {
    int bFlip = _Map.getInt("flip");
    int iSymAsym = _Map.getInt("iSymAsym");

    // Determine left vs. right drilling
    int iLeft = (calculate based on grip position, symmetry, flip state);

    if (iLeft) {
        // Drill on left side
        Drill drillLeft(...);
        bmNotVertical.addTool(drillLeft);

        // Create batten on right side
        Beam beamReinforcementRight;
        beamReinforcementRight.dbCreate(...);
    } else {
        // Drill on right side
        Drill drillRight(...);
        bmNotVertical.addTool(drillRight);

        // Create batten on left side
        Beam beamReinforcementLeft;
        beamReinforcementLeft.dbCreate(...);
    }
}
```

**Batten Lifecycle Management**:
Battens are tracked in the Map under keys `"beamReinforcementLeft"` and `"beamReinforcementRight"`. When batten properties are changed via the Properties Palette, the script updates the existing batten entities in place (version 1.45, HSB-20733):
```c
if (sBattenPropertyEvents.find(_kNameLastChangedProp) > -1) {
    Entity entLeft = _Map.getEntity("beamReinforcementLeft");
    Beam bmBattenLeft = (Beam)entLeft;
    bmBattenLeft.setBeamCode(sBattenBeamcode);
    bmBattenLeft.setMaterial(sBattenMaterial);
    // etc.
}
```

---

### Mode 5: Drill topplate one side

**Description**: Similar to Mode 4, but drills **only the top plate** on one side, not the stud. No batten reinforcement is created.

**Operations:**
1. **Determine Drilling Side**: Same logic as Mode 4
2. **Drill Top Plate** (one side only):
   - Single drill through the top plate on the selected side
   - Drill direction perpendicular to plate surface
   - No stud drilling
3. **Visual Symbols**: Custom polyline outline indicating single-side configuration

**Applicable Parameters:**
- "Drill" subsection (diameter, offsets)
- "Reinforcement Batten" section parameters are visible but **not used** (no battens created)
- "Side" property

**Use Case**:
- Lightweight elements where stud drilling is unnecessary
- Situations where lifting hardware attaches to the top plate only (e.g., plate-mounted anchors)
- Temporary erection configurations

**Code Reference:**
```c
if (nToolType == 5) {
    // Same side-selection logic as Mode 4
    if (iLeft) {
        Drill drillLeft(...);
        bmNotVertical.addTool(drillLeft);
    } else {
        Drill drillRight(...);
        bmNotVertical.addTool(drillRight);
    }
    // No batten creation
}
```

---

## Right-Click Menu (Context Menu)

Right-click on the TSL instance in the drawing to access these commands. The available menu items depend on the current "Tooling" mode.

### Reset positions

**Availability**: Always available

**Action**: Resets all lifting grip points (`_PtG[]`) back to their automatically calculated positions based on current property values.

**When to Use**:
- After manually dragging grip points and wanting to restore the default layout
- After modifying "Rope Count Thresholds" or "Offset Ratios" to reapply the new calculation logic
- If grip points have become misaligned due to element geometry changes

**Business Logic**:
```c
if (_kExecuteKey == arSTrigger[0] || _bOnElementConstructed) {
    _PtG.setLength(0);  // Clears all grip points
}
// Grip points are recalculated on next script execution
```

**Effect**: The script erases all existing grip points and recalculates their positions from scratch. Any manual adjustments are discarded.

---

### Delete

**Availability**: Always available

**Action**: Removes this lifting script instance and all associated entities (reinforcement plates, battens, drills) from the element.

**When to Use**:
- Removing lifting configuration from an element
- Changing to a different lifting strategy
- Cleanup before exporting the model

**Business Logic**:
```c
if (_kExecuteKey == T("|Delete|")) {
    eraseInstance();
    return;
}
```

**Effect**:
1. All entities in the `"EntitiesToErase[]"` map (reinforcement plates, battens) are erased via `ent.dbErase()`
2. The TSL instance itself is erased via `eraseInstance()`
3. All drill and cut operations applied to beams remain (they are not automatically removed)

**Important**: Drilling operations applied to beams are **not undone** when the script is deleted. If you need to remove drills, you must manually reset the affected beams or use the element's "Reset Tooling" function.

---

### Flip Side (inside/outside)

**Availability**: Only when "Tooling" is set to "Drill stud and topplate one side" (Mode 4)

**Action**: Toggles which side of the wall the drill is applied to, and consequently moves the reinforcement batten to the opposite side.

**Label**: The menu item label dynamically changes to show the current state:
- "Flip Side (inside)" when current side is Outside
- "Flip Side (outside)" when current side is Inside

**When to Use**:
- Switching drilling side after initial placement
- Coordinating with other lifting scripts or hardware on the same element
- Accommodating changes in erection sequence or crane approach

**Business Logic**:
```c
int bFlip = _Map.getInt("flip");
String sTriggerFlipSide = T("|Flip Side (inside)|");
if (bFlip) sTriggerFlipSide = T("|Flip Side (outside)|");

if (_kExecuteKey == sTriggerFlipSide || _kExecuteKey == "TslDoubleClick") {
    bFlip = !bFlip;
    _Map.setInt("flip", bFlip);

    if (!bFlip) sBattenInOut.set(sInOut[0]);  // Outside
    else sBattenInOut.set(sInOut[1]);         // Inside

    setExecutionLoops(2);
    return;
}
```

**Effect**:
1. The `flip` flag is toggled in the Map
2. The "Batten Side" property is updated to match (Outside ↔ Inside)
3. The script recalculates, moving drills to the opposite side and battens accordingly
4. Two execution loops are triggered to ensure clean updates

**Also Triggered By**: Double-clicking the TSL instance (`_kExecuteKey == "TslDoubleClick"`)

---

### Set Symmetric Batten / Set Asymmetric Batten

**Availability**: Only when "Tooling" is set to "Drill stud and topplate one side" (Mode 4)

**Action**: Toggles between symmetric and asymmetric batten placement logic.

**Label**: The menu item label dynamically changes to show the opposite of the current state:
- "Set Asymmetric Batten" when current mode is Symmetric
- "Set Symmetric Batten" when current mode is Asymmetric

**When to Use**:
- Balancing lifting loads on irregular or asymmetric elements
- Coordinating with rigging equipment configurations
- Matching existing batten patterns on adjacent elements

**Business Logic**:
```c
int iSymAsym = _Map.getInt("iSymAsym");  // 1 = Symmetric, 0 = Asymmetric
String sTriggerSymAsymSide = T("|Set Symmetric Batten|");
if (iSymAsym) sTriggerSymAsymSide = T("|Set Asymmetric Batten|");

if (_kExecuteKey == sTriggerSymAsymSide) {
    iSymAsym = !iSymAsym;
    _Map.setInt("iSymAsym", iSymAsym);

    if (iSymAsym) sBattenSymmetry.set(sNoYes[1]);  // Yes
    else sBattenSymmetry.set(sNoYes[0]);           // No

    setExecutionLoops(2);
    return;
}
```

**Effect**:
1. The `iSymAsym` flag is toggled in the Map
2. The "Batten Symmetry" property is updated to match (Yes ↔ No)
3. The script recalculates batten positions:
   - **Symmetric** (iSymAsym = 1): Both left and right lifting points use the same batten side logic
   - **Asymmetric** (iSymAsym = 0): Left and right lifting points mirror each other

**Also Controlled By**: Changing the "Batten Symmetry" property directly in the Properties Palette triggers the same logic via `_kNameLastChangedProp == sBattenSymmetryName`

---

## Settings Files

**This script does not use external XML settings files.** All configuration is managed through the Properties Palette parameters described above.

### Internal Dependencies

The script does rely on one internal dependency:

**hsbCenterOfGravity.mcr**
- **Purpose**: Calculates the element's center of gravity and total weight
- **Call Method**: `TslInst().callMapIO("hsbCenterOfGravity", mapIO)`
- **Input**: Map containing all beams and openings in the element
  ```c
  Map mapIO;
  Map mapEntities;
  for (GenBeam arGBm[e]) {
      mapEntities.appendEntity("Entity", arGBm[e]);
  }
  for (Opening openings[o]) {
      mapEntities.appendEntity("Entity", openings[o]);
  }
  mapIO.setMap("Entity[]", mapEntities);
  ```
- **Output**: Map containing:
  - `"ptCen"` (Point3d): Center of gravity point
  - `"Weight"` (Double): Total element weight in drawing units (kg or lbs)

**Fallback Behavior**: If `hsbCenterOfGravity` is unavailable or fails, the script uses the geometric center of the element's bounding box as a fallback. Weight-based rope count rules will not function without a valid weight value.

---

## Tips and Best Practices

### Automatic Rope Count Selection

The script uses a three-tier system for rope count determination:

| Element Characteristic | Rope Count | Logic |
|------------------------|------------|-------|
| Length < 1200 mm | **1 rope** | Short, lightweight elements |
| 1200 mm ≤ Length < 7800 mm AND Weight ≤ Threshold | **2 ropes** | Standard wall panels |
| Length ≥ 7800 mm OR Weight > Threshold | **4 ropes** | Long or heavy elements |
| "Double lifting" = Yes | **4 ropes** (forced) | Manual override |

**Adjustment Strategy**:
1. **Match Crane Capacity**: Set "Four ropes on walls longer than" to match your crane's maximum reach for two-point lifts
2. **Match Rigging Capacity**: Set "Four ropes on walls heavier than" to match your rigging hardware's safe working load
3. **Account for Dynamic Loads**: Factor in a safety margin (typically 1.5× static load) for crane acceleration and wind

**Example**: If your crane can safely lift 3000 kg with two ropes, set the weight threshold to `3000 / 1.5 = 2000 kg` to account for dynamic loads.

---

### Center of Gravity Positioning

Lifting points are calculated relative to the element's **center of gravity**, not its geometric center. This is critical for balanced lifting.

**Why This Matters**:
- Large window/door openings shift the center of gravity toward the solid portions of the wall
- Concentrated header beams add weight to the top of the element
- Multi-layer walls (e.g., double stud walls) have non-uniform mass distribution

**Visualization**:
The center of gravity point is stored in `_Pt0` and can be visualized in the drawing by selecting the TSL instance and observing the base grip point.

**Manual Override**:
While the script calculates the center of gravity automatically, you can manually adjust individual lifting points by dragging their grip points. This is useful for:
- Avoiding obstructions (e.g., electrical boxes, plumbing penetrations)
- Aligning with existing rigging hardware locations
- Compensating for unusual element geometries

---

### Offset Ratios

The offset ratio parameters control how ropes are distributed along the element. Understanding these ratios is key to achieving optimal load distribution.

**Ratio Behavior**:
- `ratio = 0.0`: Rope positioned at the center of gravity (no offset)
- `ratio = 0.5`: Rope positioned halfway between center and edge
- `ratio = 1.0`: Rope positioned at the element edge (maximum spread)

**Default Values Explained**:
- **2-Rope Ratio = 0.525**: Slightly outward from the midpoint, balancing uniform load distribution with stud alignment flexibility. This ratio typically positions ropes within ±10% of the ideal lifting point for most rectangular elements.
- **4-Rope Inner Ratio = 0.25**: Positions inner ropes at 1/4 of the half-span, providing good load distribution while maintaining adequate spacing from the center
- **4-Rope Outer Ratio = 0.75**: Positions outer ropes at 3/4 of the half-span, near but not at the element edges, providing maximum stability without risking edge failure

**Custom Ratio Strategy**:
For long, slender elements (length > 4× height), increase the 2-rope ratio toward 0.6 to reduce bending moment. For short, deep elements (length < 2× height), decrease the ratio toward 0.4 to keep ropes closer to the center.

**Invalid Ratios**:
If you enter a ratio outside the 0–1 range, the script automatically resets it to the default:
```c
if (ratio2Ropes < 0 || ratio2Ropes > 1) ratio2Ropes.set(0.525);
```

---

### Beam Code Filtering with Wildcards

The beam code filter is a powerful tool for excluding specific framing members from lifting point consideration.

**Wildcard Patterns**:

| Pattern | Example | Matches |
|---------|---------|---------|
| Exact match | `BRACE` | Only beams with code exactly "BRACE" |
| Prefix wildcard | `*BRACE` | "TEMP_BRACE", "DIAG_BRACE", "X_BRACE" |
| Suffix wildcard | `BRACE*` | "BRACE_01", "BRACE_TEMP", "BRACE_X" |
| Contains wildcard | `*BRACE*` | Any code containing "BRACE" anywhere |

**Multiple Filters**:
Separate multiple patterns with semicolons:
```
TEMP*;*BRACE*;HEADER;NOGOOD
```
This excludes:
- All codes starting with "TEMP"
- All codes containing "BRACE"
- Exact code "HEADER"
- Exact code "NOGOOD"

**Case Sensitivity**:
Filtering is **case-insensitive**. The script converts all beam codes and filter patterns to uppercase before comparison:
```c
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String sBmCode = bm.beamCode().token(0).makeUpper();
```

**Common Use Cases**:
- **Exclude temporary bracing**: `TEMP*;BRACE*;*TEMP*`
- **Exclude headers and lintels**: `HEADER;HDR*;LINTEL*`
- **Exclude specific stud types**: `JACK*;CRIPPLE*;*SHORT*`

---

### Reinforcement Plates for Heavy Walls

Enable "Stud drill reinforcement" when:
- Drill diameter > 30% of stud width (e.g., 20 mm drill in 38 mm stud)
- Element weight > 2000 kg (causes high tensile stress at hole locations)
- Stud species/grade is low strength (e.g., Grade 2 vs. Grade 1)
- Multiple drill holes are clustered in the same stud
- Element will be lifted frequently or stored long-term on lifting hardware

**Plate Sizing Guidelines**:

| Drill Diameter | Recommended Plate Dimensions | Material |
|----------------|------------------------------|----------|
| 16 mm | 50 mm W × 200 mm H × 12 mm T | Plywood "Structural 1" |
| 20 mm | 75 mm W × 250 mm H × 12 mm T | Plywood or OSB |
| 25 mm | 100 mm W × 300 mm H × 12 mm T | Plywood or 3 mm steel |
| 30 mm+ | 125 mm W × 400 mm H × 12 mm T | Steel plate required |

**Plate Placement Logic**:
The script automatically creates plates on both sides of the stud group:
1. Detects all studs intersecting the drill body
2. Calculates the combined profile of these studs (union of envelope bodies)
3. Finds the edge normal vectors facing outward from the stud group center
4. Places one plate on each side (left and right), aligned with the outward-facing edge

**Automatic vs. Manual Sizing**:
- **Width = 0**: Auto-sizes to stud width
- **Height = 0**: Auto-sizes to `2 × dOffsetHor` (twice the horizontal drill offset)
- **Non-zero values**: Uses specified dimensions exactly

---

### Custom Side Mode

Setting "Side" to "Custom" unlocks per-grip-point side control. This is useful for elements with:
- Mixed top plate and bottom plate lifting requirements
- Asymmetric framing (e.g., one side is taller than the other)
- Complex erection sequences requiring different lifting configurations at each end

**How to Use**:
1. Set "Side" = "Custom" in the Properties Palette
2. Select the TSL instance to reveal grip points
3. For each grip point:
   - Drag **above** the element center line → assigns to top plate
   - Drag **below** the element center line → assigns to bottom plate
4. The script stores each grip's side preference in the Map under `"Fac" + i`

**Visual Feedback**:
When you release the grip after dragging, the script recalculates immediately. Watch the tooling operations update to confirm the side assignment.

**Resetting Custom Sides**:
Use "Reset positions" from the right-click menu to clear all custom side assignments and restore automatic top/bottom logic based on the "Side" property.

---

### Double Lifting

The "Double lifting" option provides an alternative four-rope pattern based on **stud spacing** rather than offset ratios.

**Standard 4-Rope Pattern** (Double lifting = No):
```
[Edge]---[Outer Left]------[Inner Left]--[Center]--[Inner Right]------[Outer Right]---[Edge]
         ← ratio4Ropes2 →   ← ratio4Ropes1 →      ← ratio4Ropes1 →   ← ratio4Ropes2 →
```

**Double Lifting 4-Rope Pattern** (Double lifting = Yes):
```
[Edge]---------------[Left Outer]--[Left Inner]--[Center]--[Right Inner]--[Right Outer]---------------[Edge]
                     ← ratio2Ropes →  ← stud spacing →    ← stud spacing →  ← ratio2Ropes →
```

**When to Use**:
- The standard four-rope pattern (ratios 0.25 and 0.75) does not align well with your stud layout
- You have a specific stud spacing (e.g., 400 mm o.c.) and want ropes to align with that spacing
- You need four ropes but want them more concentrated toward the center

**Stud Spacing Detection**:
For stick-framed wall elements (`ElementWallSF`), the script reads the stud spacing from the element properties:
```c
ElementWallSF elSF = (ElementWallSF) el;
if (elSF.bIsValid())
    dStudSpacing = elSF.spacingBeam();
```
For other element types, `dStudSpacing` remains 0 and the inner rope offset defaults to one stud spacing from the outer rope.

---

### One Instance Per Identifier

The identifier property prevents duplicate or conflicting lifting configurations on the same element.

**Duplicate Prevention Logic**:
During insertion, before creating a satellite instance on an element, the script checks all existing TSL instances:
```c
TslInst arTsl[] = selectedElement.tslInst();
for (int j = 0; j < arTsl.length(); j++) {
    TslInst tsl = arTsl[j];
    if (tsl.scriptName() == "HSB_W-Lifting.mcr" && tsl.propString(10) == tslIdentifier) {
        tsl.dbErase();  // Erase the old instance
    }
}
```

**Multiple Lifting Configurations**:
If you need different lifting setups on the same element, use different identifier values:
- **Identifier "Pos 1"**: Production lifting (16 mm drills, reinforcement plates)
- **Identifier "Erection"**: Field lifting (20 mm drills, no reinforcement)
- **Identifier "Crane A"**: Primary crane rigging (2 ropes)
- **Identifier "Crane B"**: Secondary crane rigging (4 ropes)

**BOM Separation**:
Different identifiers appear as separate line items in the bill of materials, allowing you to track and cost different lifting configurations independently.

---

### Angled Top Plates

The script automatically detects and adapts to angled top plates (e.g., on gable walls or shed roofs).

**Detection Method**:
For each top plate beam, the script calculates the drill direction perpendicular to the plate surface:
```c
Vector3d vyBmTP = vzEl.crossProduct(bmTP.vecX());
vyBmTP.normalize();
Vector3d vxDrill = bmNotVertical.vecD(-vyEl);
```

**Drill Adjustment**:
Instead of drilling vertically, the script adjusts the drill axis to be perpendicular to the angled plate:
```c
Drill drillAdjustedLeft(ptDrillLeft - vxDrill * dOffsetVert,
                        ptDrillLeft + vxDrill * dOffsetVert,
                        0.5 * dDiam);
```

**Visual Result**:
In the 3D drawing, you'll see drill centerlines that are perpendicular to the angled top plate surface rather than strictly vertical. This ensures the drill does not exit the side of the plate.

**Validation**:
If the plate is rotated around its own X-axis (twist rotation), the script halts and displays an error:
```c
if (abs(abs(vyBmTP.dotProduct(bmTP.vecD(vyBmTP))) - 1) > dEps) {
    reportMessage(TN("|Topplate is rotated over its own x axis|!"));
    return;
}
```

---

### Drills from Outside to Inside

As of version 1.47 (February 2025), drill directions are oriented **from the outside face to the inside face** of the wall. This matches standard construction practice and ensures:
- Drill entry is on the exterior face (easier to access during rigging)
- Exit burrs and tear-out occur on the interior face (less visible)
- CNC machines receive the correct drilling direction for multi-axis operations

**Implementation**:
The drill direction vector is calculated based on the element's outward-facing normal:
```c
Vector3d vxDrill = bmNotVertical.vecD(-vyEl);  // Direction perpendicular to wall face, pointing inward
Drill drillAdjustedLeft(ptDrillLeft - vxDrill * dOffsetVert,  // Start point (outside)
                        ptDrillLeft + vxDrill * dOffsetVert,  // End point (inside)
                        0.5 * dDiam);
```

**Visual Confirmation**:
Use the `.vis()` debugging method to visualize drill directions in the drawing:
```c
vxDrill.vis(bmNotVertical.ptCen());  // Draws a vector arrow showing drill direction
```

---

## Technical Notes

### Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | Object type (`#Type O`) |
| **Beams Required** | 0 (`#NumBeamsReq 0`) |
| **Grip Points** | Variable (1, 2, or 4 depending on rope count) |
| **DXA Output** | Enabled (`#DxaOut 1`) |
| **Implicit Insert** | Yes (`#ImplInsert 1`) |
| **File State** | 1 (production ready) |
| **Major Version** | 1 |
| **Minor Version** | 49 |
| **Keywords** | `lifting` |
| **Last Updated** | December 19, 2025 (version 1.49) |

**Implicit Insert Behavior**:
`#ImplInsert 1` means the script can be inserted without pre-selecting beams or points. The insertion prompt directly asks for elements.

---

### Insertion Pattern: Master-Satellite

The script uses a **master-satellite distribution pattern** to apply lifting to multiple elements efficiently.

**Step-by-Step Process**:

1. **User Inserts Master Instance**:
   - User runs `TSLINSERT` and selects HSB_W-Lifting.mcr
   - Master instance is created in Model Space
   - Properties dialog appears (optional)

2. **User Selects Elements**:
   - Prompt: "Select a set of elements"
   - User clicks multiple wall/roof elements and presses Enter

3. **Master Reads Current Properties**:
   ```c
   setCatalogFromPropValues("MasterToSatellite");
   ```
   This saves all current property values to a catalog named "MasterToSatellite"

4. **Master Creates Satellites**:
   ```c
   for (int e = 0; e < _Element.length(); e++) {
       Element selectedElement = _Element[e];

       // Erase any existing instances with same identifier
       TslInst arTsl[] = selectedElement.tslInst();
       for (int j = 0; j < arTsl.length(); j++) {
           if (arTsl[j].scriptName() == strScriptName && arTsl[j].propString(10) == tslIdentifier) {
               arTsl[j].dbErase();
           }
       }

       // Create new satellite instance
       TslInst tsl;
       tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints,
                    lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
   }
   ```

5. **Satellites Read Properties from Catalog**:
   ```c
   if (_Map.hasInt("MasterToSatellite")) {
       int bMasterToSatellite = _Map.getInt("MasterToSatellite");
       if (bMasterToSatellite) {
           _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
           _Map.removeAt("MasterToSatellite", TRUE);
       }
   }
   ```

6. **Master Erases Itself**:
   ```c
   eraseInstance();
   return;
   ```

**Result**: Each selected element has one satellite instance with identical property values, but each operates independently.

**Advantages of This Pattern**:
- Consistent properties across multiple elements (one configuration for all)
- Independent operation after insertion (modifying one element's lifting doesn't affect others)
- Clean database (no orphaned master instance)

---

### Center of Gravity Integration

The script integrates with `hsbCenterOfGravity.mcr` for accurate mass-based calculations.

**Input Data Preparation**:
```c
Map mapIO;
Map mapEntities;

// Collect all beams
GenBeam arGBm[] = el.genBeam();
for (int e = 0; e < arGBm.length(); e++) {
    mapEntities.appendEntity("Entity", arGBm[e]);
}

// Collect all openings
Opening openings[] = el.opening();
for (int o = 0; o < openings.length(); o++) {
    mapEntities.appendEntity("Entity", openings[o]);
}

mapIO.setMap("Entity[]", mapEntities);
```

**MapIO Call**:
```c
TslInst().callMapIO("hsbCenterOfGravity", mapIO);
```

**Output Data Extraction**:
```c
if (mapIO.hasPoint3d("ptCen"))
    _Pt0 = mapIO.getPoint3d("ptCen");  // Center of gravity point

double weight = mapIO.getDouble("Weight");  // Total weight (kg or lbs)
```

**Fallback Behavior**:
If `hsbCenterOfGravity` is unavailable or returns invalid data, the script uses the element's geometric center:
```c
LineSeg lnSeg = el.segmentMinMax();
_Pt0 = lnSeg.ptMid();  // Midpoint of element bounding box
```

**Weight-Based Logic**:
The weight value is used in rope count determination:
```c
int bUseFourRopes = (dWallLength >= dWallLengthToSwitchToFourRopes) || (weight > weightToSwitchToFourRopes);
```

---

### Stud Selection Algorithm

The stud selection algorithm is a multi-stage filter and distance optimization process.

**Stage 1: Beam Filtering**
```c
Beam arBm[0];  // Filtered beam list

for (Beam bm : arBmAll) {
    // Filter by zone
    if (bm.myZoneIndex() != 0) continue;

    // Filter by jack exclusion
    if (excludeJacks && (bm.type() == _kSFJackOverOpening || bm.type() == _kSFJackUnderOpening))
        continue;

    // Filter by beam code
    String sBmCode = bm.beamCode().token(0).makeUpper();
    if (arSFBC.find(sBmCode) != -1 || wildcard_match(sBmCode, arSFBC))
        continue;

    // Filter by label
    if (arSFilterLabel.find(bm.label()) != -1)
        continue;

    // Filter by minimum length
    if (abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps) {  // Vertical beam
        if (bm.solidLength() > minimalStudLength) {
            arBmVertical.append(bm);
        }
    }
}
```

**Stage 2: Vertical Beam Identification**
```c
for (Beam bm : arBm) {
    if (abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps) {  // Parallel to element Y-axis
        arBmVertical.append(bm);
    } else {
        arBmNotVertical.append(bm);  // Horizontal beams (top/bottom plates)
    }
}
```

**Stage 3: T-Connection Validation**
```c
for (Beam bm : arBmVertical) {
    Beam arBmTConnection[] = bm.filterBeamsCapsuleIntersect(arBm);
    int bHasTConnectionWithTopPlate = FALSE;

    for (Beam bmTP : arBmTConnection) {
        if (arNTypeTopPlate.find(bmTP.type()) != -1) {
            bHasTConnectionWithTopPlate = TRUE;
            break;
        }
    }

    if (!bHasTConnectionWithTopPlate)
        continue;  // Stud doesn't connect to a top plate → exclude
}
```

**Stage 4: Distance Optimization**
For each target lifting point position, find the closest stud:
```c
double dMinLeft;
Beam bmMinLeft;
int bMinSet = FALSE;

for (Beam bm : arBm) {
    double dDistLeft = abs(vxEl.dotProduct(bm.ptCen() - _PtG[0]));

    if (!bMinSet) {
        bMinSet = TRUE;
        dMinLeft = dDistLeft;
        bmMinLeft = bm;
    } else {
        if (dMinLeft - dDistLeft > dEps) {
            dMinLeft = dDistLeft;
            bmMinLeft = bm;
        }
    }
}

arBmStud.append(bmMinLeft);
```

**Stage 5: Multiple Stud Handling**
If multiple adjacent studs intersect the drill body, center the lifting point on the group:
```c
for (Beam bm : arBm) {
    if (bdDrillStud.hasIntersection(bm.envelopeBody())) {
        arPtStudCen.append(bm.ptCen());
    }
}

if (arPtStudCen.length() > 1) {
    Point3d ptGroupCenter = sum(arPtStudCen) / arPtStudCen.length();
    _PtG[i] += vxEl * vxEl.dotProduct(ptGroupCenter - _PtG[i]);

    // Resize drill to span all studs
    drillStud = Drill(_PtG[i] - vyEl * dOffsetVert - vxEl * dOffsetHor,
                      _PtG[i] - vyEl * dOffsetVert + vxEl * dOffsetHor,
                      0.5 * dDiam);
}
```

---

### Execution Loops

The script uses `setExecutionLoops(2)` in several code paths to ensure proper entity lifecycle management.

**Why Two Loops?**
When tooling operations are applied to bottom plates, the first execution loop applies the tools, but the entities are not immediately updated in the drawing database. A second execution loop is required to:
1. Erase old tooling entities
2. Recalculate and apply new tooling
3. Update the display

**Code Locations**:
```c
// After side cut creation
setExecutionLoops(2);  // Line 716

// After flipping batten side
if (_kExecuteKey == sTriggerFlipSide || _kExecuteKey == "TslDoubleClick") {
    setExecutionLoops(2);  // Line 1180
}

// After toggling batten symmetry
if (_kExecuteKey == sTriggerSymAsymSide) {
    setExecutionLoops(2);  // Line 1199
}

// After changing batten properties
if (_kNameLastChangedProp == sBattenSymmetryName) {
    setExecutionLoops(2);  // Line 1209
}
```

**User Impact**:
When you modify certain properties or trigger context menu items, you may notice a brief delay as the script executes twice. This is normal and ensures all entities are properly updated.

---

### Entity Lifecycle Management

All reinforcement plates and battens created by the script are **temporary entities** managed through a Map-based tracking system.

**Creation and Tracking**:
```c
Map entitiesToEraseMap = Map();

// Create reinforcement plate
Sheet reinforcementLeft;
reinforcementLeft.dbCreate(...);
entitiesToEraseMap.appendEntity("Entity", reinforcementLeft);

// Store in persistent Map
_Map.setMap("EntitiesToErase[]", entitiesToEraseMap);
```

**Erasure on Recalculation**:
```c
Map entitiesToEraseMap = _Map.getMap("EntitiesToErase[]");
if (entitiesToEraseMap.length() > 0) {
    for (int index = 0; index < entitiesToEraseMap.length(); index++) {
        Entity ent = entitiesToEraseMap.getEntity(index);
        ent.dbErase();
    }
}
```

**Why This Pattern?**
- Reinforcement components are **not permanent** like beams or studs
- They are **configuration-dependent** (dimensions, positions change with properties)
- The script must **regenerate them** on every property change or grip point adjustment
- Tracking in a Map ensures clean erasure without orphaned entities

**Special Case: Battens**
Battens (created in Mode 4) are also tracked individually by side:
```c
_Map.setEntity("beamReinforcementLeft", beamReinforcementLeft);
_Map.setEntity("beamReinforcementRight", beamReinforcementRight);
```
This allows property update events to modify existing batten entities without recreating them:
```c
Entity entLeft = _Map.getEntity("beamReinforcementLeft");
Beam bmBattenLeft = (Beam)entLeft;
bmBattenLeft.setBeamCode(sBattenBeamcode);
bmBattenLeft.setMaterial(sBattenMaterial);
```

---

### Element Group Assignment

The script assigns itself to element group **E0** using the 'E' zone type:
```c
assignToElementGroup(el, TRUE, 0, 'E');
```

**Parameters**:
- `el`: Target element
- `TRUE`: Assign (not unassign)
- `0`: Zone index 0
- `'E'`: Zone type 'E' (structural element zone)

**Why Zone E0?**
This is the primary structural zone containing the main framing members (studs, plates). Assigning the lifting script to E0 ensures:
- The script is associated with the correct structural layer
- It recalculates when E0 beams are modified
- It is included in structural exports and schedules

---

### DXA Output

The lifting symbols are flagged for DXA (data exchange) output:
```c
Display dpLifting(3);
dpLifting.showInDxa(true);
```

**Purpose**:
DXA output allows the lifting symbols to be exported to:
- Shop drawing layouts
- CNC programming systems
- Coordination drawings for crane operators
- PDF exports for field crews

**What Gets Exported**:
- Rope outline polylines at each grip point
- Indicator symbols at the element origin
- Grip point positions (as reference points)

**What Does NOT Get Exported**:
- Drill operations (these are part of the beam entities, not the TSL display)
- Reinforcement plates (these are independent sheet entities)

---

### CNC Exclusion

Drill operations applied to studs are flagged to **exclude Randek CNC machines**:
```c
drillStud.excludeMachineForCNC(_kRandek);
bmVertical.addTool(drillStud);
```

**Why Exclude Randek?**
Lifting holes are typically **not drilled on the CNC machine** because:
1. CNC programming occurs before the lifting configuration is finalized
2. Lifting holes may be drilled manually on-site or in the laydown yard
3. Field crews may need to adjust hole positions based on actual rigging hardware
4. CNC machines are optimized for production cuts (notches, pockets, mortises), not large-diameter lifting holes

**Other CNC Platforms**:
The exclusion applies specifically to Randek machines (`_kRandek`). If your workflow uses other CNC platforms (e.g., Hundegger, Weinmann), you may need to modify this flag or add additional exclusions.

**Removing the Exclusion**:
If you *do* want lifting holes to export to Randek, comment out or remove this line in the source code:
```c
// drillStud.excludeMachineForCNC(_kRandek);  // Allow Randek export
```

---

### Visualization System

The script uses a **dual-context display system** to show lifting symbols in both elevation and plan views.

**Elevation View Symbols** (3D):
```c
Display dpVisualisation(nColor);
dpVisualisation.addHideDirection(_ZW);   // Hide when viewing from +Z (top view)
dpVisualisation.addHideDirection(-_ZW);  // Hide when viewing from -Z (bottom view)

// Draw arrow symbol pointing down element Y-axis
Point3d ptSymbol01 = ptEl - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(ptEl);
plSymbol01.addVertex(ptSymbol01);

PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);
```

**Plan View Symbols** (2D):
```c
Display dpVisualisationPlan(nColor);
dpVisualisationPlan.addViewDirection(_ZW);   // Show only in +Z view (top view)
dpVisualisationPlan.addViewDirection(-_ZW);  // Show in -Z view (bottom view)

// Draw arrow symbol pointing forward along element Z-axis
Point3d ptSymbol01 = ptEl + vzEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;

PLine plSymbol01(vyEl);
plSymbol01.addVertex(ptEl);
plSymbol01.addVertex(ptSymbol01);

PLine plSymbol02(vyEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisationPlan.draw(plSymbol01);
dpVisualisationPlan.draw(plSymbol02);
```

**Rope Outline Symbols**:
At each lifting grip point, a polyline outline is drawn showing the drill pattern:
```c
PLine pl(vzEl);  // Normal direction for elevation view
Point3d pt01 = _PtG[i] + vyEl * dOffsetVert - vxEl * dOffsetHor;
Point3d pt02 = _PtG[i] - vyEl * (dOffsetVert - dOffsetHor) - vxEl * dOffsetHor;
Point3d pt03 = _PtG[i] - vyEl * (dOffsetVert - dOffsetHor) + vxEl * dOffsetHor;
Point3d pt04 = _PtG[i] + vyEl * dOffsetVert + vxEl * dOffsetHor;

pl.addVertex(pt01);
pl.addVertex(pt02);
pl.addVertex(pt03, 1);  // Bulge = 1 (arc vertex)
pl.addVertex(pt04);
pl.close(1);  // Close with arc

dpLifting.draw(pl);
```

**View Direction Control**:
- `addHideDirection()`: Hides symbols when viewing from the specified direction
- `addViewDirection()`: Shows symbols **only** when viewing from the specified direction

This ensures elevation symbols don't clutter plan views, and vice versa.

---

### Version History Highlights

**1.49 (December 19, 2025)**
- Corrected lifting positions around center of gravity
- Made offset ratios user-adjustable via properties panel
- Improved ratio validation (force defaults if invalid)

**1.48 (June 5, 2025)**
- Fixed bug when no studs to drill are found (HSB-24138)

**1.47 (February 13, 2025)**
- Adjusted drill direction to be from outside to inside of wall

**1.46 (April 10, 2024)**
- Fixed asymmetric drill offset issue in element Z direction

**1.45 (February 9, 2024)**
- Added batten property controls (beamcode, material, grade, name) (HSB-20733)

**1.44 (January 17, 2024)**
- Added label filter support

**1.43 (January 17, 2024)**
- Added option for single-side top plate drilling

**1.37 (January 27, 2022)**
- Added "Side" property with Top/Bottom/Both/Custom options (HSB-9178)

**1.32 (June 4, 2021)**
- Removed body intersection check for performance optimization

**1.29-1.30 (November 2020)**
- Added "Drill stud and topplate one side" tooling mode (HSB-8824)
- Added batten symmetry and side properties
- Added batten length property

**1.13 (March 13, 2018)**
- Implemented four-rope logic for heavy elements

**1.07 (January 17, 2017)**
- Added support for roof elements

**1.00 (November 2, 2012)**
- Initial pilot version

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: "Topplate cannot be found!" error

**Cause**: The script cannot locate a suitable top plate beam at the calculated lifting point.

**Solutions**:
1. **Verify top plate exists**: Check that the element has beams of type `_kSFTopPlate`, `_kTopPlate`, `_kSFAngledTPLeft`, `_kSFAngledTPRight`, or `_kDakFrontEdge` (or `_kSFBottomPlate` if "Side" = Bottom plate)
2. **Check beam zone**: Top plates must be in zone E0. Select the top plate and verify `myZoneIndex() == 0`
3. **Adjust grip points**: Manually drag the lifting grip point to a location where a top plate beam exists
4. **Review beam filters**: If you've entered beam codes in "Filter beams with beamcode," ensure the top plate's beam code is not being excluded
5. **Check element geometry**: For unusual element shapes, the lifting point may fall outside the framing area. Use "Reset positions" to recalculate

#### Issue: "Give beamcode to place the lifting holes" error

**Cause**: "Centerpoint for drills" is set to "Beam by code," but "Beamcode to center drills" is empty.

**Solutions**:
1. **Enter beam code**: In the Properties Palette, enter the exact beam code of the reference beam in "Beamcode to center drills"
2. **Switch to Element mode**: Change "Centerpoint for drills" to "Element" if you don't need beam-specific centering
3. **Verify beam code exists**: Ensure at least one beam in the element has the specified beam code. Use the beam properties dialog to check.

#### Issue: Reinforcement plates are not created

**Cause**: Multiple possible causes depending on tooling mode and configuration.

**Solutions**:
1. **Check tooling mode**: Reinforcement plates are only created when "Tooling" is set to "Drill stud and topplate" (mode 0) or "Drill stud" (mode 1). Mode 4 ("Drill stud and topplate one side") uses battens instead.
2. **Enable reinforcement**: Verify "Stud drill reinforcement" is set to "Yes"
3. **Check side setting**: Plates are only created when `iside < 1` in the code. If "Side" is set to "Bottom plate" only, plates may not be generated. Try "Top plate" or "Both".
4. **Verify studs to drill**: If no studs are found at the drilling location, no plates are created. Check that suitable studs exist and are not filtered out.

#### Issue: Battens are placed on the wrong side

**Cause**: "Batten Side" property or flip state is not configured correctly.

**Solutions**:
1. **Use Flip trigger**: Right-click the TSL instance and select "Flip Side (inside/outside)" to toggle the drilling side
2. **Adjust Batten Side property**: In the Properties Palette, change "Batten Side" from "Outside" to "Inside" (or vice versa)
3. **Check symmetry setting**: If "Batten Symmetry" is "No" (asymmetric), the left and right sides use different logic. Change to "Yes" for consistent behavior.

#### Issue: Four ropes are used when only two are expected

**Cause**: Element length or weight exceeds the configured thresholds.

**Solutions**:
1. **Check length**: Measure the element length. If >= 7800 mm, the script defaults to four ropes. Increase "Four ropes on walls longer than" to a higher value.
2. **Check weight**: Verify the element weight by calling `hsbCenterOfGravity` manually. If weight exceeds "Four ropes on walls heavier than," the script uses four ropes. Increase the weight threshold.
3. **Disable Double lifting**: If "Double lifting" is set to "Yes," four ropes are forced. Change to "No".

#### Issue: Lifting points are not aligning with studs

**Cause**: Stud spacing does not match the calculated lifting positions.

**Solutions**:
1. **Adjust offset ratios**: Modify "Offset ratio from center for 2 ropes" or the 4-rope ratios to better align with your stud layout. Experiment with values between 0.4 and 0.6.
2. **Use Double lifting**: If you have a regular stud spacing, enable "Double lifting" to use a stud-spacing-based pattern instead of ratio-based positioning.
3. **Manual adjustment**: Drag individual grip points to align with specific studs. The script will snap to the nearest suitable stud.
4. **Review stud filters**: Check "Filter beams with beamcode" and "Filter beams with label" to ensure suitable studs are not being excluded.

#### Issue: Drills are not exported to CNC

**Cause**: Drills are flagged with `excludeMachineForCNC(_kRandek)`.

**Solutions**:
1. **Intentional behavior**: By design, lifting holes are excluded from Randek CNC export because they are typically drilled manually. This is not a bug.
2. **Modify source code**: If you need CNC export, open the script source and comment out the line:
   ```c
   // drillStud.excludeMachineForCNC(_kRandek);
   ```
3. **Alternative approach**: Create a separate drilling script specifically for CNC export that does not include the exclusion flag.

#### Issue: "Topplate is rotated over its own x axis!" error

**Cause**: The top plate beam has a twist rotation (rotated around its own longitudinal axis), which prevents the script from calculating a perpendicular drill direction.

**Solutions**:
1. **Correct plate rotation**: Select the top plate beam and verify its rotation properties. Use hsbCAD's beam editing tools to remove any twist rotation.
2. **Check element construction**: This error often indicates a modeling issue. Rebuild the top plate using standard wall framing tools rather than custom beam placement.
3. **Consult element type**: Some specialized element types (e.g., curved walls, faceted roofs) may produce twisted plates. Consider using a different lifting strategy for these elements.

---

## Related Scripts

- **hsbCenterOfGravity.mcr**: Calculates element center of gravity and weight (called internally)
- **HSB_W-SplitPlatesExtraOptions.mcr**: Advanced top/bottom plate splitting and manipulation
- **hsbT-Marking.mcr**: Creates marking tags and labels for elements
- **hsbInstallationPoint.mcr**: Defines installation reference points for erection sequencing
- **ErectionSequence.mcr**: Manages element erection order and crane logistics
- **hsbLifter.mcr**: Alternative lifting tool for CLT panels (cross-laminated timber)
- **hsbCLT-Lift.mcr**: CLT-specific lifting point generation with vacuum lifter support

---

## Frequently Asked Questions

**Q: Can I use this script for CLT panel lifting?**
A: While the script can technically be applied to any Element entity, it is optimized for stick-framed walls. For CLT panels, consider using `hsbCLT-Lift.mcr` or `hsbLifter.mcr`, which support vacuum lifter configurations and panel-specific reinforcement patterns.

**Q: How do I remove lifting drills after erection?**
A: Drilling operations are applied directly to beam entities and are **not automatically removed** when you delete the HSB_W-Lifting instance. To remove drills:
1. Select each drilled beam
2. Use the beam's "Reset Tooling" function to clear all applied operations
3. Alternatively, use the element's "Reset All Tooling" command to clear all beams at once

**Q: Can I create multiple lifting configurations with different drill sizes?**
A: Yes. Insert the script multiple times with **different identifier values**. For example:
- Identifier "Production": 16 mm drills for permanent hardware
- Identifier "Erection": 20 mm drills for temporary rigging
Each identifier creates an independent lifting configuration.

**Q: Why are my grip points not visible?**
A: Grip points are only visible when the TSL instance is **selected**. Click on the lifting symbol or select the instance from the element's TSL list. If still not visible, check that your AutoCAD grip display settings are enabled (`GRIPS` system variable = 1).

**Q: Can I use this script for horizontal elements (floor joists, roof rafters)?**
A: The script is designed for **wall and roof elements**, which have a defined top plate and vertical studs. For horizontal framing systems (floor joists, rafter systems), the stud detection logic may not work correctly. Consider using element-specific lifting scripts or custom rigging strategies.

**Q: How do I export lifting points to my crane operator's coordination software?**
A: The lifting symbols are flagged for DXA output. Export your drawing using the hsbCAD "Export DXA" command, which will include:
- Lifting grip point coordinates
- Visual symbols (polylines)
- Element reference data
Most crane coordination software can import DXA or DXF files with point entities.

**Q: Can I apply custom reinforcement plates instead of the script's standard plates?**
A: Yes. Disable "Stud drill reinforcement" in the script, then manually create your custom plate entities (sheets or beams) at the lifting locations. Assign them to the same element using `assignToElementGroup()` to ensure they move with the element.

**Q: Why does the script use ratios instead of absolute distances for rope positioning?**
A: Ratios (0.0 to 1.0) are **scale-independent** and work correctly for elements of any length. Absolute distances would require manual adjustment for each element size. For example, a ratio of 0.525 works equally well for a 2-meter wall and a 10-meter wall, automatically scaling the rope position to the element's actual dimensions.

---

## Support and Documentation

For additional information, consult:
- **hsbCAD User Manual**: Chapter on "Element Lifting and Erection"
- **TSL Scripting Guide**: Reference documentation for TSL language and API
- **hsbCAD Community Forum**: User-contributed tips and workflows
- **Technical Support**: Contact your hsbCAD reseller for script customization or troubleshooting assistance

---

*This documentation was generated for HSB_W-Lifting.mcr version 1.49 (December 19, 2025). For the most current version and updates, check the hsbCAD TSL library or your software provider.*
