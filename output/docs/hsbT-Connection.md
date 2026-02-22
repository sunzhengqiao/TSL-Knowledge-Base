# hsbT-Connection

## Overview

**Deprecation Notice:** As of version 2.21 (January 2025), this script has been officially superseded by `T-Connection.mcr`. While `hsbT-Connection` remains functional for backward compatibility with existing drawings, all new projects should use `T-Connection.mcr` instead. This legacy script will continue to receive critical bug fixes but no new features.

`hsbT-Connection` creates parametric T-shaped joints between male beams (vertical studs or posts) and female beams (horizontal plates, headers, or rim boards) in timber frame structures. The script automatically calculates and applies:

1. **Male beam trimming** - A dynamic cut that extends the male beam end to the exact contact depth within the female beam
2. **Female beam notching** - A precision BeamCut cavity carved into the female beam face to receive the male beam cross-section
3. **Automatic recalculation** - The connection geometry updates instantly whenever linked beams are moved, rotated, or resized

The script supports three selection workflows: individual beam-by-beam connections, automatic multi-beam processing, and element-level batch operations with sophisticated filtering rules.

---

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object/Entity Script) |
| **Version** | 2.22 (March 4, 2025) |
| **Required Beams** | 0 (dynamically links to selected beams) |
| **Model Space** | Yes |
| **Paper Space** | No |
| **Execution Loops** | 2-3 (dynamic based on geometry state) |
| **Sequence Number** | 50 (when placed on Element) |

---

## Usage Environment

### Space Compatibility

| Space Type | Supported | Notes |
|------------|-----------|-------|
| Model Space | ✓ Yes | Primary environment - operates on 3D beam geometry |
| Paper Space | ✗ No | This script has no shop drawing or layout output |

### Prerequisites

**Mandatory Requirements:**
- At least one male beam (stud, post, or vertical member) must exist in the drawing
- At least one female beam (plate, header, rim board, or horizontal member) must exist
- Male and female beam axes must **not be parallel** (script validates T-intersection geometry)
- Both beams must be valid hsbCAD GenBeam entities (not dummy beams)

**Optional for Enhanced Functionality:**
- Beams should be assigned to an hsbCAD Element to enable Element selection mode
- BeamCode/Format metadata should be populated if using advanced filtering
- Color-coding or beam type assignments enable filter-based batch operations

---

## How to Use

### Workflow A: Single Connection (Beam-by-Beam Mode)

**Use Case:** Placing a precise connection between one male beam and one or more female beams.

**Step 1: Launch the Script**
```
Command: TSLINSERT
[Browse to and select hsbT-Connection.mcr]
```
Or use your office alias command if configured (e.g., `TSLCONTENT`).

**Step 2: Configure Properties**

The property dialog opens automatically. Key settings for a basic connection:
- **(A) Depth/Distance**: Enter positive value (e.g., 50 mm) for the male beam to penetrate into the female beam
- **(B) Gap**: Enter 0 for tight fit, or small positive value (e.g., 1-2 mm) for tolerance
- **Rotated Beam**: Set to "No" for standard perpendicular connections
- Leave all filters empty for unrestricted selection

Click **OK** to proceed.

**Step 3: Select Male Beam**

Prompt: **"Select male beam(s) or element(s)"**
- Click the vertical stud or post
- Press Enter to confirm

**Step 4: Select Female Beam**

Prompt: **"Select female beam(s) -- Enter = Automatic"**
- Click the plate or header beam
- For multiple female beams, click each one
- Press Enter to confirm

**Step 5: Verify Result**

The script creates:
- A stretch cut on the male beam end, extending it to the specified depth
- A rectangular notch in the female beam face matching the male beam cross-section
- Visual indicator lines at the connection point (color 150)

The connection is now parametric - move either beam and the connection recalculates automatically.

---

### Workflow B: Automatic Multi-Beam Mode

**Use Case:** Connecting multiple studs to a common plate in one operation.

**Step 1: Launch and Configure**

Same as Workflow A. Consider setting filter rules (see Filter System section below).

**Step 2: Window-Select Multiple Beams**

Prompt: **"Select male beam(s) or element(s)"**
- Window-select a region containing both studs (male) and plates (female)
- The script will detect all beams in the selection

**Step 3: Automatic Female Detection**

Prompt: **"Select female beam(s) -- Enter = Automatic"**
- Press **Enter** without selecting anything
- The script automatically analyzes all selected beams and creates connections where valid T-intersections are detected

**Step 4: Review Results**

The script creates one connection instance for each valid male-female pair found. Console messages report the number of connections created and any beams excluded by filters.

---

### Workflow C: Element Mode (Production Batch Processing)

**Use Case:** Automatically connecting all studs in a wall panel to top and bottom plates, with filtering to skip headers and boundary members.

**Step 1: Launch and Configure Filters**

Open the property dialog and configure:
- **(A) Depth/Distance**: 50 mm (standard lap depth)
- **(B) Gap**: 1 mm (machining tolerance)
- **(C) Max. Stud Length**: 0 (or specify maximum stud length to exclude king studs or posts)
- **(D) Element Rule**: "Exclude bottom, top and angled plate" (prevents notching continuous plates)
- **(E) byColor/Beamtype (Male)**: "Stud" (only connect members typed as studs)
- **(G) byColor/Beamtype (Female)**: "Plate" (only connect to plate members)

Click **OK**.

**Step 2: Select Element**

Prompt: **"Select male beam(s) or element(s)"**
- Click an hsbCAD Element (wall panel, floor assembly, etc.)

**Step 3: Exclude Beams (Optional)**

Prompt: **"Select beam(s) to be excluded -- Enter = none"**
- Click any headers, blocking, or specialty members to skip
- Or press Enter to process all beams

**Step 4: Script Processing**

The script:
1. Collects all beams in the element
2. Removes any excluded beams from the candidate list
3. Applies all active filters (Element Rule, Max Length, Color, Width, BeamCode)
4. Identifies all valid male-female T-intersection pairs
5. Creates a separate connection instance for each pair
6. Assigns each instance to the element's tool sublayer with sequence number 50

Console output shows the number of connections created and any beams excluded.

---

## Properties Panel (OPM Parameters)

All properties are visible in the AutoCAD Properties Palette after the connection is placed. Changes take effect on the next automatic recalculation.

### Geometry Category

| Property | Type | Default | Range | Description |
|----------|------|---------|-------|-------------|
| **(A) Depth/Distance** | PropDouble | 0.0 mm | -∞ to +∞ | **Positive value**: Male beam penetrates this distance into the female beam (lap depth). A notch of this depth is cut into the female beam face. **Negative value**: Male beam stops short of the female beam face by this distance (gap connection). The male beam is still trimmed, but no notch is cut in the female beam. **Zero**: Flush butt contact - male beam trimmed to female face, no notch cut. |
| **(B) Gap** | PropDouble | 0.0 mm | 0 to +∞ | Lateral clearance added to the notch profile in the female beam. The notch is enlarged by this amount on all sides around the male beam cross-section. Useful for manufacturing tolerances, sealant grooves, or airspace gaps. Does not affect male beam trimming. |
| **Rotated Beam** | PropString | "No" | No / Yes | **No**: The notch cut in the female beam is always perpendicular to the female beam axis, regardless of male beam rotation. Standard for conventional framing. **Yes**: The notch cut follows the actual rotated angle of the male beam. Required for diagonal braces, skewed studs, or angled connections. |

**Technical Notes:**
- The male beam receives a `Cut` tool at its end face, positioned at `_Pt0 + vecZ * dDistance`
- The female beam receives a `BeamCut` tool with dimensions `(dX * 2, dY, dZ * 2)` where `dX` is the male beam width, `dY` is the male beam depth (adjusted by Gap), and `dZ` is the Depth value
- The BeamCut is automatically stretched by ±20 mm if its profile extends beyond the female beam face boundary (handles sloped or rotated joints)

### Filter Category

| Property | Type | Default | Range | Description |
|----------|------|---------|-------|-------------|
| **(C) Max. Stud Length** | PropDouble | 0.0 mm | 0 to +∞ | Maximum allowed solid length of a male beam. Male beams with `solidLength() - dDistance >= dMaxLength` are excluded from the connection set. Enter 0 to disable the length filter. Useful for excluding tall king studs or posts in walls where only standard studs should connect. |
| **(D) Element Rule** | PropString | "Disabled" | 3 options | Controls element-level batch processing behavior. Options: <br>**"Disabled"**: All detected male-female T-intersections receive connections (no exclusions). <br>**"Exclude bottom, top and angled plate"**: Horizontal plates at the element top and bottom boundaries are excluded, as are any angled top plates. Only intermediate connections are created. Most common for platform-frame walls. <br>**"Only studs against top plate"**: Creates connections exclusively between vertical studs (parallel to element Y-axis) and the topmost horizontal plate. All other intersections are skipped. |

**Element Rule Implementation Detail:**
- Rule 1 ("Exclude bottom, top and angled plate"): The script identifies the extreme horizontal beams (lowest and highest in element Y direction), extracts their face profiles, and excludes any female beam whose profile intersects these boundary zones. Angled top plates (beam type 54/55) are also explicitly excluded.
- Rule 2 ("Only studs against top plate"): Only male beams with `vecX.isParallelTo(element.vecY())` are considered, and only if they intersect the female beam at the topmost Y position.

### Filter Male Beams Category

These filters determine which beams are eligible to act as **male beams** (the stud or post that receives the trim cut).

| Property | Type | Default | Syntax | Description |
|----------|------|---------|--------|-------------|
| **(E) byColor/Beamtype** | PropString | (empty) | `1;3;-2;Stud;-Plate` | Filter by AutoCAD color number or hsbCAD beam type name. Separate multiple entries with semicolons. <br>**Positive color number** (e.g., `1;3`): Include only male beams with color 1 or 3. <br>**Negative color number** (e.g., `-2`): Exclude male beams with color 2. <br>**Beam type name** (e.g., `Stud`): Include only beams of type "Stud". <br>**Negative beam type** (e.g., `-Plate`): Exclude beams of type "Plate". <br>If any negative value is present, all positive include values are disabled and the filter becomes exclusion-only. |
| **(F) byWidth** | PropString | (empty) | `45;-63;90` | Filter by beam width (cross-section dimension in element Z direction). <br>**Positive value** (e.g., `45;90`): Include only male beams exactly 45 or 90 mm wide. <br>**Negative value** (e.g., `-63`): Exclude male beams 63 mm wide. <br>Any negative entry switches the filter to exclusion mode. |
| **byBeamCode/byFormat** | PropString | (empty) | `@(Width,230);BSH` | Filter by BeamCode string or Format expression. <br>**BeamCode exact match**: Enter full beamcode string (e.g., `;BSH;;;;;;;;C24;;Ständer;`) - only one beamcode at a time. <br>**Format token match**: Use `@(BeamCode:T1)` to reference the first token of the beamcode. For beamcode `;BSH;;;;;;;;C24;;Ständer;`, token T1 is "BSH". <br>**Format attribute match**: Use `@(Width,230);@(Height,240)` to match specific attribute values. Separate format-value pairs with semicolons. |

**Filter Processing Order:**
1. Color/Beamtype filter applied first
2. Width filter applied to remaining candidates
3. BeamCode/Format filter applied last
4. Results are male beam candidates for connection pairing

### Filter Female Beams Category

Identical syntax and logic to male filters, applied to **female beams** (the plate or header that receives the notch).

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **(G) byColor/Beamtype** | PropString | (empty) | Same syntax as male color/beamtype filter, applied to female beam candidates. |
| **(H) byWidth** | PropString | (empty) | Same syntax as male width filter, applied to female beam candidates. |
| **byBeamCode/byFormat (Female)** | PropString | (empty) | Same syntax as male BeamCode/Format filter, applied to female beam candidates. |

---

## User Interface Elements

### Insertion Prompts

The script provides context-sensitive prompts based on the current selection mode:

**Prompt 1 (Male Selection):**
```
Select male beam(s) or element(s):
```
- Accepts: Individual GenBeam entities, multiple beams via window selection, or complete Element entities
- Special handling: If Element is selected, script switches to Element mode

**Prompt 2 (Female Selection / Exclusion):**

**If Beam Mode:**
```
Select female beam(s), <Enter> = Automatic:
```
- Accepts: Individual GenBeam entities
- **Enter without selection**: Treats all previously selected beams as both male and female candidates (automatic intersection detection)

**If Element Mode:**
```
Select beam(s) to be excluded, <Enter> = none:
```
- Accepts: Individual GenBeam entities within the selected element
- Excluded beams are removed from both male and female candidate lists

### Property Dialog

Opens automatically on first insertion (`_bOnInsert`). Shows all parameters organized in five collapsible categories:
1. **Geometry** (3 parameters)
2. **Filter** (2 parameters)
3. **Filter Male Beams** (3 parameters)
4. **Filter Female Beams** (3 parameters)

The dialog can also be invoked later by editing catalog entries (script supports catalog-based property presets).

### Context Menu (Right-Click)

When you right-click an existing `hsbT-Connection` instance:

| Menu Item | Key | Action |
|-----------|-----|--------|
| **Reset + Erase** | (Double-click also works) | Removes the dynamic stretch cut from the male beam, applies a static cut at the original contact plane, and erases the connection instance. This permanently bakes the male beam trim but leaves the female beam notch intact. |

**Implementation Note:** The "Reset + Erase" trigger (`_kExecuteKey == sTriggerReset`) applies a static `Cut` tool at `_Pt0` with normal vector `vecZ`, then calls `eraseInstance()`.

---

## Connection Geometry Detail

### Coordinate System Calculation

The script establishes a local coordinate system for each connection:

```
Origin (_Pt0): Intersection of male beam axis with female beam contact face
                (adjusted by -0.5 * dD(vecZ) of female beam)

vecZ: Points from male beam toward female beam interior
      Calculated as bm1.vecD(bm0.vecX()), flipped if dotProduct < 0

vecX: Perpendicular to both beam axes
      Calculated as bm1.vecD(bm1.vecX().crossProduct(vecZ))
      If Rotated Beam = Yes: reoriented to bm0.vecD(vecX)

vecY: Derived as vecX.crossProduct(-vecZ)
```

This coordinate system is used for all cutting tools and visual indicators.

### Male Beam Trimming (Stretch Cut)

**Purpose:** Extend the male beam end to the exact contact depth within the female beam.

**Implementation:**
1. Calculate intersection plane at `_Pt0 + vecZ * dDistance`
2. Trace four corner lines of male beam cross-section to find maximum extent point `ptIntersectMax`
3. Apply `Cut(ptIntersectMax, vecZ)` with auto-commit flag = 1
4. This cut is **dynamic** - recalculates when either beam moves

**Special Case (HSB-18893):** The cutting plane normal uses `vecZ` (parallel to contact plane) rather than `vecXcut` to ensure proper `envelopeBody()` calculation for skewed connections.

### Female Beam Notching (BeamCut)

**Purpose:** Carve a cavity in the female beam face to receive the male beam cross-section.

**Implementation (only when dDistance > 0):**
1. Calculate intersection body: `bdMale.intersectWith(bdFemale)`
2. Project intersection to shadow profile on contact plane
3. Shrink profile by `-dGap` (expands outward)
4. Extract extents in `vecX` and `vecY` directions to get notch dimensions `(dX, dY)`
5. Create `BeamCut(ptRef, vecX, vecY, vecZ, dX*2, dY, dDistance*2, 0, 0, 0)`
6. Check for profile overflow: If profile extends beyond female beam face, stretch BeamCut by ±20 mm
7. Apply to all female beams via `bc.addMeToGenBeamsIntersect(bmFemales)`

**Rotated Beam Adjustment:** If `iRotatedBeam == true`, `dX` is recalculated as `bdTool.lengthInDirection(vecX)` instead of `bdFemale.lengthInDirection(vecX)`.

### Redundant Male BeamCut (HSB-15478 Deprecated)

Older versions of the script applied an additional BeamCut to the male beam end. This is now suppressed unless it demonstrably removes material (tested by profile intersection). The purpose was unclear and often redundant with the stretch cut.

---

## Filter System Explained

### Color/Beamtype Filter Logic

**Include Mode (default):**
- If only positive values are entered (e.g., `1;3;Stud`), the filter **includes only** beams matching those colors or types
- Any beam not matching is excluded

**Exclude Mode (triggered by any negative value):**
- If any negative value is present (e.g., `-2`), the filter **excludes only** beams matching the absolute values
- All positive include values are automatically purged
- Any beam not explicitly excluded is included

**Mixed Entries:**
```
Example: "1;3;-2;Stud;-Plate"
Processing:
1. Parse colors: 1, 3, -2
2. Parse beam types: Stud, -Plate
3. Detect negative entry (-2 or -Plate) -> switch to Exclude Mode
4. Purge positive colors: 1, 3 removed
5. Keep absolute values: exclude color 2 and type "Plate"
Result: All beams EXCEPT color 2 and type "Plate" are included
```

**Implementation Code Path:**
```c
// Tokenize filter string by ";"
// For each token:
//   - Try parse as integer -> color number
//   - If parse fails -> beam type name
// If any negative found: set bIsExcludeFilter = true
// If bIsExcludeFilter: purge all positive values, keep abs(negative)
```

### Width Filter Logic

Identical to color filter logic, but compares `bm.solidWidth()` or `bm.solidHeight()` (whichever aligns with element Z-axis) against filter values.

**Orientation Detection:**
```c
Vector3d vecZ = el.bIsValid() ? el.vecZ() : bm.vecZ();
double dD = bm.vecZ().isParallelTo(vecZ) ? bm.solidWidth() : bm.solidHeight();
```

This ensures the filter always uses the width dimension (cross-section perpendicular to length), regardless of beam rotation.

### BeamCode/Format Filter Logic

**Format-Value Pair Mode:**
```
Syntax: @(Width,230);@(Height,240)
Processing:
- Tokenize by ";"
- Iterate tokens:
  - If token starts with "@": format expression (e.g., @(Width,230))
  - Next token is the expected value
  - Format-value pairs stored in parallel arrays
- For each beam: call bm.formatObject(format) and compare to value
- Exclude beam if any format-value pair does not match
```

**BeamCode Exact Match Mode:**
```
Syntax: ;BSH;;;;;;;;C24;;Ständer;
Processing:
- If no "@" tokens found: treat entire string as beamcode
- Compare beam.beamCode() == filter string
- Exclude beam if not exact match
```

**Token Reference Mode:**
```
Syntax: @(BeamCode:T1);BSH
Processing:
- @(BeamCode:T1) is a format expression that extracts token 1 from beamcode
- Next token "BSH" is the expected value
- For beamcode ";BSH;;;;;;;;C24;;Ständer;", token T1 = "BSH"
- Exclude beam if token does not match
```

**Important:** You cannot mix format-value pairs and beamcode exact matching in a single filter string. If any `@` token is found, the script enters format-value mode and ignores non-paired entries.

---

## Selection Mode Workflow Detail

### Mode 0: Single Connection (Beam-by-Beam)

**Triggered when:** `_Beam.length() >= 2` and no Element selected

**Behavior:**
- The script operates on `_Beam[0]` (male) and `_Beam[1]` (female)
- If `_Beam.length() > 2` and additional beams have `vecX.isParallelTo(_Beam[1].vecX())`, they are added to the `bmFemales` array
- One connection instance is created linking directly to these beam objects
- All filter properties (Rule, Max Length, Color, Width, BeamCode) are set to **read-only** in this mode (filters apply only in multi-beam/element modes)

**Dependency Tracking:**
- Male and female beams are added to `_Entity` array via `setDependencyOnEntity()`
- Connection recalculates automatically when either dependency beam changes

### Mode 1: Element Mode

**Triggered when:** `_Element.length() > 0` on insertion

**Behavior:**
1. Extract `Element el = _Element[0]`
2. Collect all beams: `Beam beams[] = el.beam()`
3. Remove any beams in `panhand()` state (skip incomplete beams)
4. **Wait State Check (HSB-18801):** If no valid beams remain, enter wait loop:
   - `setExecutionLoops(2)` to keep script alive
   - Draw script name as text at element origin
   - Exit and recalculate when beams become available
5. Remove excluded beams from Map: `_Map.getEntityArray("excludes", ...)`
6. Set `bmMales = beams` and `bmFemales = beams` (all beams are candidates)
7. Apply all active filters (see Filter Processing Flow below)
8. Identify male-female pairs (see Pair Detection Algorithm below)
9. For each valid pair: clone the script instance via `tslNew.dbCreate()`
10. Assign each instance to element tool sublayer: `assignToElementGroup(el, true, 0, 'E')`
11. Set sequence number: `_ThisInst.setSequenceNumber(50)`
12. Erase the original insertion instance: `eraseInstance()`

**Script Cloning Parameters:**
```c
tslNew.dbCreate(
    scriptName(),      // "hsbT-Connection"
    vecXTsl, vecYTsl,  // Dummy orientation (overridden by beam linking)
    gbsTsl,            // GenBeam array: [male, female1, female2, ...]
    entsTsl,           // Empty (no additional entities)
    ptsTsl,            // Empty (insertion point calculated from beams)
    nProps,            // Integer properties (none)
    dProps,            // [dDistance, dGap, 0] (Max Length not copied)
    sProps,            // [sRule, filters...] (all filter strings)
    _kModelSpace,      // Target space
    mapTsl             // Empty Map
);
```

### Mode 2: Multi-Beam Set Mode

**Triggered when:** Map contains "males" and "females" EntityArrays, but not a single male-female pair

**Behavior:**
- Extract male and female candidates from Map: `_Map.getEntityArray("males", ...)` and `_Map.getEntityArray("females", ...)`
- Apply all active filters (same as Mode 1)
- Identify male-female pairs (same as Mode 1)
- Clone script instances for each pair (same as Mode 1)
- Erase original insertion instance

**Difference from Mode 1:** No element assignment, no sequence number, no wait state logic. Simple batch processing of beam arrays.

---

## Filter Processing Flow

When operating in Element mode (Mode 1) or Multi-Beam mode (Mode 2), filters are applied in this order:

### Step 1: Max Length Filter
```c
if (dMaxLength > 0) {
    for each male beam:
        if (beam.solidLength() - dDistance >= dMaxLength) {
            exclude male beam
            report exclusion message
        }
}
```

### Step 2: Male Color/Beamtype Filter
```c
Parse sColorFilter -> nColorFilters[], nBeamTypeFilters[]
if (bIsExcludeFilter) {
    for each male beam:
        if (color in nColorFilters) exclude
} else if (nColorFilters.length() > 0) {
    for each male beam:
        if (color NOT in nColorFilters) exclude
}
// Same logic for beam type filters
```

### Step 3: Male Width Filter
```c
Parse sWidthFilter -> dWidthFilters[]
Determine beam orientation to identify width dimension
if (bIsExcludeWidthFilter) {
    for each male beam:
        if (width in dWidthFilters) exclude
} else if (dWidthFilters.length() > 0) {
    for each male beam:
        if (width NOT in dWidthFilters) exclude
}
```

### Step 4: Male BeamCode/Format Filter
```c
Parse sBeamCodeFormat -> sFormats[], sValues[], sBeamcodes[]
for each male beam:
    for each format-value pair:
        if (beam.formatObject(format) != value) {
            exclude male beam
            break
        }
    for each beamcode:
        if (beam.beamCode() != beamcode) {
            exclude male beam
            break
        }
```

### Step 5: Female Color/Beamtype Filter
Same as Step 2, applied to `bmFemales[]`

### Step 6: Female Width Filter
Same as Step 3, applied to `bmFemales[]`

### Step 7: Female BeamCode/Format Filter
Same as Step 4, applied to `bmFemales[]`

### Step 8: Element Rule Filtering

**Rule 0 (Disabled):** No additional filtering

**Rule 1 (Exclude bottom, top and angled plate):**
```c
if (el.bIsValid() && nRule == 1) {
    // Identify extreme horizontal beams
    Beam bmHorizontals[] = el.vecY().filterBeamsPerpendicularSort(beams)

    // Extract boundary plate profiles
    PlaneProfile pp(el.coordSys())
    Point3d ptRefBot = lowest horizontal beam bottom face
    Point3d ptRefTop = highest horizontal beam top face

    for each horizontal beam:
        if (beam is at ptRefBot and no vertical stud below) OR
           (beam is at ptRefTop and no vertical stud above):
            pp.unionWith(beam contact face profile)

    // Exclude female beams intersecting boundary profiles
    for each female beam in bmFemales[]:
        PlaneProfile ppFemale = female beam contact face profile
        ppFemale.intersectWith(pp)
        if (intersection area > 1 mm²):
            exclude female beam

    // HSB-23612: Baufritz-specific exclusions
    if (bBaufritz && nRule == 1):
        if (female beam type is "rechter Stab", "Linker Stab", or "Schwelle"):
            exclude female beam
}
```

**Rule 2 (Only studs against top plate):**
```c
if (nRule == 2) {
    for each male beam:
        if (!male.vecX().isParallelTo(element.vecY())):
            exclude male beam  // Not vertical
        else if (male.vecX().dotProduct(element.vecY()) < 0):
            flip vecX to point upward
}
// Female beams are not filtered in Rule 2 - only topmost connection is created via directional detection
```

---

## Pair Detection Algorithm

After filtering, the script identifies which male-female beam pairs should receive connection instances:

### Step 1: Capsule Intersection Filter
```c
for each male beam in bmMales[]:
    Beam beamsCaps[] = male.filterBeamsCapsuleIntersect(bmFemales)
    // Returns female beams whose bounding capsule intersects male beam capsule
```

### Step 2: T-Connection Validation
```c
for each capsule-intersecting female beam:
    if (!male.hasTConnection(female, dDistance, true)):
        exclude female beam  // No valid T-intersection geometry
```

The `hasTConnection()` method performs precise solid-body intersection tests to confirm a T-shaped joint exists.

### Step 3: Rule-Based Exclusions

Applied per Rule 1 and Rule 2 logic described above.

### Step 4: Directional Pairing (HSB-11195)

For each male beam, the script tests **both ends** of the male beam axis:

```c
for x = 0 to 1:  // 0 = positive vecX direction, 1 = negative vecX direction
    vecDir = (x == 0) ? vecXM : -vecXM

    for each remaining female beam:
        // Find intersection of male axis with female contact plane
        Line(male center, vecDir).hasIntersection(
            Plane(female center, female.vecD(vecDir)), pt
        )

        if (intersection found AND vecDir.dotProduct(pt - male center) > 0):
            append female beam to gbsTsl[] for this direction

    if (gbsTsl.length() > 1):  // At least male + one female
        create connection instance with gbsTsl[]
```

This logic supports:
- One male connecting to multiple females on the same side
- One male connecting to females on both ends (creates two instances)
- Skewed connections where male beam meets two non-parallel females

### Step 5: Duplicate Prevention (HSB-16469)

```c
Beam bmMalesCreated[], bmFemalesCreated[]

for each potential connection (male0, female1):
    if (male0 was previously used as female AND
        female1 was previously used as male):
        skip this pair  // Prevents mirrored duplicate
    else:
        create connection
        bmMalesCreated.append(male0)
        bmFemalesCreated.append(female1)
```

This prevents the script from creating both `male A → female B` and `male B → female A` connections when beams intersect bidirectionally.

---

## Recalculation Behavior

### Automatic Recalculation Triggers

The connection recalculates whenever:
- Either linked beam (male or female) is moved, rotated, or resized
- Any property value is changed in the OPM panel
- The parent element recalculates (in Element mode)
- User manually invokes recalculation via `TSLRECALC` or context menu

### Execution Loop Control

The script uses dynamic execution loops to ensure proper geometry resolution:

```c
if (_bOnDbCreated) setExecutionLoops(2);  // Initial state
if (_kExecutionLoopCount == 0) setExecutionLoops(2);  // After first pass
else if (_kExecutionLoopCount == 1) setExecutionLoops(3);  // After second pass
```

**Loop 0:** Calculate connection geometry, apply male cut
**Loop 1:** Recalculate after male beam updates, apply female BeamCut
**Loop 2:** Final pass to ensure all tool operations are committed

### Wait State (HSB-18801)

If placed on an element with no valid beams:
```c
if (beams.length() < 1 || beamsNotPanhand.length() < 1) {
    setExecutionLoops(2);  // Keep script alive
    Display dp(0);
    dp.textHeight(U(50));
    dp.draw(scriptName(), el.segmentMinMax().ptMid(), vecX, vecY, 0, 0);
    return;  // Exit and wait for next recalc
}
```

The script displays its name at the element center and waits. When beams become available (e.g., after element construction completes), the next recalculation proceeds normally.

---

## Visual Indicators

The script draws minimal visual feedback to show the connection geometry:

### Contact Point Indicator (Depth > 0)
```c
Display dp(150);  // Color 150 (magenta)
dp.draw(PLine(ptRef, ptRef + vecZ * dDistance));  // Depth vector
dp.color(3);
dp.draw(PLine(ptRef - 0.5*vecY*dY, ptRef + 0.5*vecY*dY));  // Y extent
dp.color(1);
dp.draw(PLine(ptRef - 0.5*vecX*dX, ptRef + 0.5*vecX*dX));  // X extent
```

**Result:** A small crosshair at the connection point showing the notch dimensions and depth vector.

### Flush Contact Indicator (Depth = 0)
```c
double d = (bm0.dH() > bm0.dW()) ? bm0.dW() : bm0.dH();
d *= 0.8;
PLine pl.createCircle(pt, vecZ, d/2);
dp.draw(pl);  // Circle at contact face
if (abs(dDistance) > dEps) {
    dp.draw(PLine(pt, pt + vecZ * dDistance));  // Gap vector
    pl.transformBy(vecZ * dDistance);
    dp.draw(pl);  // Second circle at gap distance
}
```

**Result:** A circle (or two circles connected by a line if gap exists) showing the contact/gap geometry.

### Debug Visualization

When debug mode is active (`bDebug = true`), additional visualizations appear:
- Male beam envelope: Color 3 (green)
- Female beam envelope: Color 4 (cyan)
- BeamCut cutting body: Color 3 (green)
- Deprecated male BeamCut: Color 2 (yellow)
- Connection points: Color 5, 6, 8

Debug mode is enabled by adding `DEBUGTSL` or the script name to the `projectSpecial()` string.

---

## Special Cases and Edge Handling

### Rotated Beam Connections (HSB-12395)

When `sRotatedBeam == "Yes"`:
```c
vecX = bm0.vecD(vecX);  // Reorient to male beam's rotation
vecY = vecX.crossProduct(-vecZ);  // Recalculate perpendicular
dX = bdTool.lengthInDirection(vecX);  // Measure actual male beam width in this direction
```

This ensures the BeamCut notch follows the skewed male beam profile rather than cutting perpendicular to the female beam.

**Use Cases:**
- Diagonal bracing in shear walls
- Angled studs in sloped walls
- Skewed framing at wall intersections

### Multi-Female Connections (HSB-11195)

A single male beam can connect to multiple female beams simultaneously:
```c
gbsTsl[] = [male, female1, female2, ...]
```

The script applies the BeamCut to all female beams in the array via `bc.addMeToGenBeamsIntersect(bmFemales)`.

**Use Cases:**
- Wall corner where a stud meets two perpendicular plates
- Floor rim board junction where a joist meets both rim and ledger

### BeamCut Stretching (HSB-12394)

If the calculated notch profile extends beyond the female beam face boundary:
```c
PlaneProfile ppFemale = bdFemale.shadowProfile(Plane(ptRef, vecX));
Point3d ptLeftTop = notch profile top-left corner
Point3d ptRightTop = notch profile top-right corner

if (ppFemale.pointInProfile(ptLeftTop) == _kPointOutsideProfile):
    bc = BeamCut(ptRef - vecY*U(20), vecX, vecY, vecZ, dX*2, dY+U(40), dZ*2, 0, 0, 0)
    // Stretch 20 mm to the left, widen by 40 mm total

if (ppFemale.pointInProfile(ptRightTop) == _kPointOutsideProfile):
    bc = BeamCut(ptRef + vecY*U(20), vecX, vecY, vecZ, dX*2, dY+U(40), dZ*2, 0, 0, 0)
    // Stretch 20 mm to the right, widen by 40 mm total
```

This automatic adjustment prevents incomplete cuts at sloped or rotated joints.

### Tolerance Removal (HSB-16850)

Older versions used a tolerance parameter (`dEps`) for line-plane intersection tests. This was removed to prevent small gaps accumulating in complex geometry:
```c
// Old code:
ptIntersect = ln.intersect(pnStretch, dEps);

// New code (v2.18+):
int nIntersect = ln.hasIntersection(pnStretch, ptIntersect);
if (!nIntersect) {
    reportMessage("\n" + scriptName() + " " + T("|Unexpected|"));
    eraseInstance();
    return;
}
```

### Plane Adjustment for Skewed Connections (HSB-18893)

The male beam stretch cut now uses a plane parallel to the female contact face rather than perpendicular to the male beam axis:
```c
// Old code:
Cut cutStretch(ptIntersectMax, vecXcut);  // Perpendicular to male beam

// New code (v2.19+):
Cut cutStretch(ptIntersectMax, vecZ);  // Parallel to female contact face
```

This ensures the `envelopeBody(true, true)` calculation produces valid geometry for skewed connections.

---

## Console Output Messages

### Connection Creation Messages

**Filter Exclusions:**
```
hsbT-Connection: 12/5 male/female beams excluded due to filtering
Male Color Filter 2
Female Color Filter 1;3
```

**Max Length Exclusions:**
```
hsbT-Connection: S-01 Stud, Length 2800 excluded from selection set, (C) Max. Stud Length=2400
```

**Element Rule Exclusions:**
```
hsbT-Connection: P-01 Top Plate excluded from selection set.
```

### Error Messages

**Invalid Beam Selection:**
```
hsbT-Connection: invalid selection set.
```
(Male and female beam axes are parallel - no T-intersection possible)

**Unexpected Geometry Error (HSB-16850):**
```
hsbT-Connection: Unexpected
```
(Line-plane intersection failed - typically indicates corrupted beam geometry)

### Debug Messages (bDebug = true)

**Beam Appending:**
```
hsbT-Connection appending beam <handle> in direction of <vector>
```

**Map Property Trace:**
```
Map: <Map contents>
```

---

## Common Use Cases

### Use Case 1: Standard Platform Frame Wall

**Scenario:** Wall panel with vertical studs at 16" O.C., bottom plate, top plate, and window headers.

**Configuration:**
- (A) Depth: 50 mm
- (B) Gap: 0 mm
- (D) Element Rule: "Exclude bottom, top and angled plate"
- (E) byColor/Beamtype (Male): "Stud"
- (G) byColor/Beamtype (Female): "Plate"

**Result:** Connections created only between studs and intermediate blocking/headers. Bottom and top plates remain unnotched (continuous members).

### Use Case 2: Balloon Frame Wall

**Scenario:** Balloon frame where studs run full height from sill to top plate, no mid-height plates.

**Configuration:**
- (A) Depth: 38 mm (one stud width)
- (D) Element Rule: "Only studs against top plate"
- All other filters empty

**Result:** Each stud connects only to the topmost plate. No connections at sill or mid-height.

### Use Case 3: Diagonal Bracing

**Scenario:** Shear wall with 45-degree diagonal braces connecting corner studs to mid-height blocking.

**Configuration:**
- (A) Depth: 38 mm
- (B) Gap: 2 mm (clearance for compression fit)
- Rotated Beam: "Yes"
- Select beams individually (Workflow A)

**Result:** Angled notch cuts in blocking members that follow the 45-degree brace orientation.

### Use Case 4: Floor Joist to Rim Board

**Scenario:** Floor assembly with I-joists at 19.2" O.C. connecting to rim board and ledger.

**Configuration:**
- (A) Depth: 0 mm (flush butt, no notch - joist hangers will be added separately)
- (D) Element Rule: "Disabled"
- (F) byWidth (Male): "89" (I-joist flange width)
- (H) byWidth (Female): "38;286" (rim board and ledger widths)

**Result:** Each I-joist receives a trim cut at the rim/ledger face. No notches cut (depth = 0). Ready for hanger hardware placement.

### Use Case 5: Mixed-Width Studs

**Scenario:** Wall with 38 mm studs at openings and 89 mm king studs/posts at corners.

**Configuration:**
- (A) Depth: 50 mm
- (C) Max. Stud Length: 0 mm
- (F) byWidth (Male): "38" (exclude king studs)
- (D) Element Rule: "Exclude bottom, top and angled plate"

**Result:** Only 38 mm studs receive connections. King studs are skipped by width filter.

---

## Integration with Other Scripts

### Hardware Connector Scripts

After `hsbT-Connection` creates the structural joint, hardware connectors can be added:
- **Simpson StrongTie** scripts: Add framing anchors, ties, or holdowns at connection points
- **BMF** / **Rothoblaas** scripts: Add hidden fasteners or angle brackets
- **Generic Angle Bracket (GA)** scripts: Add custom steel plates

The connection geometry provides stable reference points for hardware placement.

### Shop Drawing Scripts

Shop drawing scripts (sd_*) can reference the connection instances to:
- Dimension notch depths and clearances
- Annotate connection types
- Generate cut lists with notch specifications

### Manufacturing Scripts

CNC export scripts read the BeamCut tools applied by `hsbT-Connection`:
- **Drill Distribution**: Add fastener holes around notch perimeter
- **hsbCNC**: Export notch geometry to CNC machine control files
- **Nail-SheetOnBeam**: Add nailing patterns at connection zones

---

## Troubleshooting

### Problem: No Connections Created

**Possible Causes:**
1. **Parallel beams:** Male and female beam axes are parallel. The script requires non-parallel beams for T-intersection geometry.
   - **Solution:** Verify beam orientations. T-connections only work when beams meet at an angle.

2. **No capsule intersection:** Beams do not physically overlap in 3D space.
   - **Solution:** Check beam positions. Use `envelopeBody().vis()` to visualize beam solids and confirm intersection.

3. **Filter too restrictive:** All candidate beams excluded by color/width/beamcode filters.
   - **Solution:** Temporarily clear all filter fields and retry. Review console messages for exclusion counts.

4. **Element Rule excluding all pairs:** Rule 1 or Rule 2 filters out all valid connections.
   - **Solution:** Set Element Rule to "Disabled" and retry. Check if boundary plates are interfering.

### Problem: Wrong Beams Connected

**Possible Cause:** Filters not configured correctly.

**Solution:**
1. Review filter strings for syntax errors (missing semicolons, extra spaces)
2. Verify beam metadata (BeamCode, beam type names) matches filter values
3. Enable debug mode (`bDebug = true`) to visualize which beams are processed

### Problem: Notch Cut Missing or Incomplete

**Possible Causes:**
1. **Depth = 0:** No notch is cut when depth is zero (flush butt connection).
   - **Solution:** Set (A) Depth to positive value (e.g., 50 mm).

2. **BeamCut falls outside female beam face:** Profile overflow not detected correctly.
   - **Solution:** Script should auto-stretch by 20 mm. If not, check female beam geometry for validity.

3. **Rotated beam mismatch:** Notch orientation incorrect for skewed connection.
   - **Solution:** Set Rotated Beam = "Yes" for angled connections.

### Problem: Male Beam Not Trimmed

**Possible Cause:** Stretch cut failed due to geometry error (HSB-16850).

**Solution:**
1. Check console for "Unexpected" error message
2. Verify male beam is a valid GenBeam (not dummy beam)
3. Inspect male beam geometry for corruption (use `AUDIT` command)

### Problem: Connection Does Not Recalculate

**Possible Cause:** Dependency link broken or beam handles invalidated.

**Solution:**
1. Delete connection instance and recreate
2. Verify beams are still valid entities (not erased/purged)
3. Check if beams were moved via block edit (which breaks dependencies)

### Problem: Duplicate Connections Created

**Possible Cause:** Duplicate prevention logic bypassed by re-running script on same beams.

**Solution:**
1. Use `TSLRECALC` to update existing instances rather than re-inserting
2. If duplicates exist, manually delete unwanted instances
3. Ensure Element Rule is configured to prevent overlapping connections

---

## Performance Considerations

### Large Element Processing

When processing walls with 100+ studs:
- Filtering overhead: Each filter pass iterates all beams (~O(n))
- Capsule intersection: `filterBeamsCapsuleIntersect()` is optimized but still ~O(n*m)
- Instance cloning: Creating 100 connection instances takes 2-5 seconds

**Optimization Tips:**
1. Use restrictive filters to reduce candidate set size
2. Process smaller elements in batches rather than one large assembly
3. Enable Element Rule to skip boundary conditions automatically

### Recalculation Performance

Each connection instance recalculates independently:
- Single connection recalc: ~10-50 ms (geometry calculation + tool application)
- 100 connections: ~1-5 seconds total
- Execution loops (2-3 passes): Multiply by loop count

**Optimization Tips:**
1. Use `setExecutionLoops(2)` for simple connections (no skewed geometry)
2. Avoid unnecessary property changes (triggers full recalc)
3. Disable debug mode in production (debug visualization adds overhead)

### Memory Usage

Each connection instance stores:
- Property values: ~200 bytes
- Dependency links: ~50 bytes per linked beam
- Tool geometry: ~500 bytes (Cut + BeamCut)

**Total per instance:** ~1 KB
**100 connections:** ~100 KB (negligible)

---

## Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| **2.22** | 2025-03-04 | HSB-23612: Baufritz-specific beam exclusions in Rule 1 |
| **2.21** | 2025-01-07 | HSB-22182: Deprecated in favor of T-Connection.mcr |
| **2.20** | 2023-05-12 | HSB-18801: Wait state for elements with no valid beams |
| **2.19** | 2023-05-05 | HSB-18893: Plane adjustment for skewed connections (envelopeBody fix) |
| **2.18** | 2022-10-27 | HSB-16850: Tolerance removal from line-plane intersection |
| **2.17** | 2022-09-26 | HSB-16469: Duplicate prevention for bidirectional connections |
| **2.16** | 2022-09-01 | HSB-15478: BeamCut applied only when it removes material |
| **2.15** | 2022-07-26 | HSB-11195: Deprecated redundant male beam end BeamCut |
| **2.14** | 2021-10-28 | HSB-13421: Improved BeamCode/Format filter description |
| **2.13** | 2021-10-22 | HSB-13421: Added BeamCode/Format filter documentation |
| **2.12** | 2021-10-18 | HSB-13421: BeamCode/Format filter implementation |
| **2.11** | 2021-07-12 | HSB-12395: Rotated Beam property added |
| **2.10** | 2021-07-12 | HSB-12394: BeamCut stretching for overflow profiles |
| **2.9** | 2021-03-15 | HSB-11195: Support for 1 male + 2 skewed females |
| **2.8** | 2019-10-10 | HSB-5610: Sequence number 50 for element instances |

Full version history is documented in the `#BeginDescription` header block (lines 2-52).

---

## Limitations and Known Issues

### Limitations

1. **No CLT/Mass Timber Support:** The script is designed for stick-frame beams. For CLT panel connections, use `hsbCLT-*` scripts.

2. **No Multi-Material Handling:** All beams must be wood. Steel or concrete members may produce unexpected geometry.

3. **No Compound Angle Connections:** The script handles single-plane skew (Rotated Beam setting) but not compound angles (rotation in multiple planes).

4. **No Hardware Integration:** The script creates structural cuts only. Fastener placement (bolts, nails, screws) requires separate hardware scripts.

5. **No Strength Calculation:** The script does not validate structural capacity. Engineering analysis is the user's responsibility.

### Known Issues

1. **HSB-16850 False Positives:** In rare cases with heavily skewed geometry, the line-plane intersection test may fail even though valid geometry exists. Workaround: Slightly adjust beam positions to eliminate edge cases.

2. **Element Wait State Overhead:** If many elements are in wait state simultaneously (large project with incremental element construction), recalculation performance may degrade. Workaround: Build elements completely before placing connections.

3. **Filter Syntax Sensitivity:** BeamCode filter strings must exactly match beamcode format including semicolons and spacing. Extra spaces cause filter failures. Workaround: Use Format expressions `@(...)` instead of full beamcode strings.

4. **Rotated Beam + Gap Interaction:** When Rotated Beam = Yes and Gap > 0, the gap is applied perpendicular to the female beam rather than perpendicular to the skewed male beam. This may produce asymmetric clearance. Workaround: Manually adjust BeamCut after placement if precise gap control is required.

---

## Related Scripts

### Recommended Replacement

- **T-Connection.mcr** - Active replacement for this script. New projects should use T-Connection.mcr for future compatibility and feature updates.

### Similar Connection Scripts

- **hsbCLT-T-Connector** - T-connections for CLT panels (different geometry model)
- **hsbT-Marking** - Adds visual markers and annotations to T-connections
- **hsbBeamCornerConnection** - Mitered corner joints (not T-shaped)
- **Offsetted_Parallel_Housing** - Offset housing joints for parallel beams

### Hardware Scripts for T-Connections

- **Simpson StrongTie Anchor** - Framing anchors at T-joint locations
- **BMF Balkenschuh** - Joist hangers at T-joints
- **Rothoblaas WHT** - Hidden fasteners for flush connections
- **Generic Angle Bracket (GA)** - Custom steel plates at connection points

### Element-Level Framing Scripts

- **HSB_W-Blocking** - Add blocking between studs (often used with T-Connection)
- **HSB_E-SquaredMill** - Square-cut beam ends for tight joints
- **hsbNailing** - Add nailing patterns around connection zones

---

## Technical Support Notes

### Debug Mode Activation

To enable detailed debug output and visualization:
1. Open drawing properties
2. Set `projectSpecial()` to include "DEBUGTSL" or "hsbT-Connection"
3. Recalculate connection instances
4. Beam envelopes, cutting planes, and intermediate geometry will display

### Console Message Interpretation

**Normal Operation:**
- No messages = all connections created successfully
- Exclusion count messages = filters are working as designed

**Warning Indicators:**
- "excluded from selection set" = filters or rules preventing connection
- Large exclusion counts = review filter configuration

**Error Indicators:**
- "invalid selection set" = beams do not meet geometric requirements
- "Unexpected" = geometry calculation failure - check beam validity

### Manual Override

To manually adjust a connection after placement:
1. Select connection instance in drawing
2. Open Properties Palette (OPM)
3. Modify (A) Depth, (B) Gap, or Rotated Beam
4. Connection recalculates automatically

To permanently bake and remove dynamic link:
1. Right-click connection instance
2. Choose "Reset + Erase"
3. Male beam cut is converted to static Cut tool
4. Female beam BeamCut remains applied
5. Instance is deleted

---

## Conclusion

`hsbT-Connection` is a mature, battle-tested script for automated T-joint creation in timber frame structures. While officially deprecated in favor of `T-Connection.mcr`, it remains fully functional and widely used in existing projects.

**Key Strengths:**
- Comprehensive filter system for batch processing
- Supports complex geometries (skewed connections, multi-female pairs)
- Parametric/dynamic - updates automatically when beams move
- Element-aware - integrates with hsbCAD workflow

**Key Limitations:**
- Deprecated (no new features)
- Stick-frame only (not for CLT/mass timber)
- No built-in hardware placement

**Best Practices:**
- Use Element mode for production efficiency
- Configure Element Rule to avoid notching continuous plates
- Set Rotated Beam = Yes for diagonal bracing
- Review console messages to verify filter behavior
- Migrate to T-Connection.mcr for new projects

For questions or issues not addressed in this guide, consult the hsbCAD support team or reference the successor script `T-Connection.mcr` documentation.
