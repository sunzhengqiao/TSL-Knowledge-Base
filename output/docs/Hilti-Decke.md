# Hilti-Decke

**Hilti Floor-to-Wall Connections Using Stexon Wood Coupler System**

Automatically generates machining operations (drills, saw markings, no-nail zones) at floor-wall intersections based on Hilti wood coupler reference positions (HCW, HCW-P, HCWL, HSW, Holzdolle).

---

## Overview

The **Hilti-Decke** script establishes structural connections between timber floor elements and walls using the **Hilti Stexon wood coupler system**. It detects connection points from wall reference tools or imports them from Hilti export files (DXX format), then applies corresponding machining operations to floor beams.

### Key Capabilities

- **Dual-Direction Support**: Creates separate instances for top (ceiling-to-upper-wall) and bottom (floor-to-lower-wall) connections
- **Multiple Reference Types**: Supports HCW, HCW-P, HCWL, HSW, Holzdolle (Baufritz), and custom drill detection
- **Import Mode**: Reads Hilti export files (HiltiExport.dxx) for automated placement
- **Manual Drill Addition**: Interactive tool to add supplemental drill points (top connections only)
- **Automatic Recalculation**: Updates when walls or floor elements are modified

### Two TSL Instances per Connection

For each floor-wall combination, the script creates:

1. **Hilti-Decke-Oben** (Top): Connects the floor/ceiling to the wall above
   - Uses HCW, HCW-P, HCWL, or Holzdolle references
   - Applies element drills in sheet zones (1-5)
   - Supports manual drill supplementation

2. **Hilti-Decke-Unten** (Bottom): Connects the floor to the wall below
   - Uses HSW references
   - Applies beam drills and optional saw cross markings
   - Includes no-nail zones in sheeting

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Version | 1.14 (2024-12-03) |
| Environment | Model Space |
| Beams Required | 0 |
| Grip Points | 0 |
| Keywords | Hilti, Floor, Decke, HCW, HCWL, HSW |

---

## Prerequisites

### Required Elements

1. **Floor Elements**
   - Must be created as ElementRoof or ElementFloor
   - Should contain beams and optional sheeting
   - Sheeting required for saw cross markings (bottom connections)

2. **Wall Elements** (Method 1: Direct Selection)
   - Wall elements positioned adjacent to floor
   - Hilti reference tools already applied:
     - **Hilti-Stockschraube** (for bottom connections - HSW)
     - **Hilti-Verankerung** (for top connections - HCW, HCW-P, HCWL)

3. **Hilti Export File** (Method 2: Import Mode)
   - File name: `HiltiExport.dxx`
   - Location: Parent folder of current drawing
   - Contains wood coupler positions from Hilti software
   - Automatically cached in MapObject for performance

---

## Step-by-Step Usage Guide

### Method 1: Using Wall References (Interactive Selection)

This method requires walls with pre-applied Hilti reference tools.

1. **Launch the Script**
   - Insert from TSL palette or command line
   - The insertion dialog appears

2. **Configure Bottom Connection Settings**

   **Wandreferenz unten** (Wall Reference Bottom):
   - **Reference Bottom**: Select HSW, Custom, or All
     - `HSW`: Standard Hilti threaded rod connector (Ø9mm, 70mm depth)
     - `Custom`: Specify your own detection diameter/depth
     - `All`: Creates instances for both HSW and Custom (comprehensive detection)

   If **Custom** is selected:
   - **Diameter**: Detection diameter for wall drills (default: 10mm)
   - **Depth**: Detection depth for wall drills (default: 70mm, or 0 = all depths)

   **Bohrung unten** (Drill Bottom):
   - **Diameter**: Drill diameter in floor beam (default: 37mm)
   - **Depth**: Drill depth in floor beam (default: 70mm)

   **Sägekreuz unten** (Saw Cross Bottom):
   - **Zone**: Sheet zone for saw marking (-5 to -1, default: -1)
   - **Length**: Length of saw cross marking (default: 100mm, 0 = disabled)
   - **Depth**: Depth of saw cross marking (default: 5mm, 0 = disabled)

3. **Configure Top Connection Settings**

   **Wandreferenz oben** (Wall Reference Top):
   - **Reference Top**: Select HCW, HCW-P, HCWL, Custom, All, or Holzdolle
     - `HCW`: Standard wood coupler (Ø37mm, 70mm depth)
     - `HCW-P`: HCW variant (Ø37mm, 70mm depth)
     - `HCWL`: Large wood coupler (Ø42mm, 70mm depth)
     - `Holzdolle`: Baufritz wooden dowel (Ø30mm detection, Ø34mm drill, 35mm depth) - **only available for Baufritz projects**
     - `Custom`: Specify your own detection parameters
     - `All`: Creates instances for HCW, HCW-P, HCWL, Holzdolle (if Baufritz), and Custom

   If **Custom** is selected:
   - **Diameter**: Detection diameter for wall drills (default: 37mm)
   - **Depth**: Detection depth (default: 50mm, or 0 = all depths)

   **Bohrung 1 oben** (Drill 1 Top):
   - **Zone**: Sheet zone (1-5, default: 1)
   - **Diameter**: First drill diameter (default: 70mm, 0 = disabled)
   - **Depth**: First drill depth (default: 10mm, 0 = disabled)

   **Bohrung 2 oben** (Drill 2 Top):
   - **Zone**: Sheet zone (1-5, default: 1)
   - **Diameter**: Second drill diameter (default: 25mm, 0 = disabled)
   - **Depth**: Second drill depth (default: 10mm, 0 = disabled)

4. **Confirm Settings**
   - Click OK to proceed
   - If Custom or All is selected, a second dialog appears for fine-tuning

5. **Select Floor Element(s)**
   - Prompt: "Dachelement(e) wählen" (Select roof/floor element(s))
   - Click on floor or ceiling elements
   - Press Enter to confirm selection

6. **Select Wall Element(s)**
   - Prompt: "Select walls(s)" or "Select walls(s), <Enter> Hilti Import" (if import data available)
   - Click on wall elements to connect
   - Press Enter to finish selection

7. **Script Execution**
   - The script creates Hilti-Decke-Oben and Hilti-Decke-Unten instances
   - Machining operations are applied to floor beams
   - Visual indicators appear in model space
   - Statistics report displays in command line

---

### Method 2: Using Hilti Import (DXX File)

This method reads connection positions from a Hilti export file.

**Prerequisites:**
- File `HiltiExport.dxx` must exist in parent folder of current drawing
- File must contain Hilti-Stockschraube and/or Hilti-Verankerung references

**Steps:**

1. **Launch the Script**
   - The dialog shows "!! Import Stockschraube verfügbar" or "!! Import Verankerung verfügbar" if import data is detected

2. **Configure Settings**
   - Set reference types and drill parameters as in Method 1
   - The script will use these settings to filter imported data

3. **Select Floor Element(s)**
   - Click on floor elements
   - Press Enter to confirm

4. **Skip Wall Selection (Import Mode)**
   - When prompted "Select walls(s), <Enter> Hilti Import"
   - **Press Enter without selecting any walls**
   - This activates import mode

5. **Automatic Processing**
   - Script reads connection positions from HiltiExport.dxx
   - Filters positions based on selected reference types
   - Creates instances for both top and bottom connections
   - Applies machining to floor beams and loose beams within 100mm of floor profile

**Import Data Caching:**
- Import data is stored in MapObject "HiltiExport" in dictionary "Hilti"
- Cache is automatically refreshed when file modification date changes
- Use context menu "Import Model" to manually refresh

---

### Adding Manual Drills (Top Connections Only)

Manual drills allow you to mark additional drilling positions that are not automatically detected from wall references.

**Requirements:**
- Only available for **Hilti-Decke-Oben** (top connection) instances
- At least one automatic drill location must exist

**Steps:**

1. **Access Context Menu**
   - Right-click on an existing **Hilti-Decke-Oben** instance

2. **Select "Add Manual Drill"**
   - The command line prompts: "Select Drill point"

3. **Click Near Existing Drill Locations**
   - Click near an existing automatic drill position (marked with magenta circles)
   - The script snaps to the closest existing drill location
   - That location is marked as "manual" (displayed in blue instead of magenta)
   - **Note:** You cannot create entirely new positions; you can only mark existing automatic positions as manual

4. **Continue Adding or Finish**
   - Continue clicking to mark more positions (max 100 per session)
   - Press Enter to finish
   - If you try to mark the same location twice, you'll see: "Manual Drill exists"

5. **Apply Manual Drill Parameters**
   - After adding manual drill points, modify the instance properties in OPM:
     - **Manuelle Bohrung > Zone**: Sheet zone (1-5)
     - **Manuelle Bohrung > Diameter**: Drill diameter
     - **Manuelle Bohrung > Depth**: Drill depth
   - Set diameter and depth to non-zero values to activate manual drilling

**Visual Feedback:**
- Automatic drills: Magenta circles (color 6)
- Manual drills: Blue circles (color 5)

---

### Deleting Manual Drills

**Delete Individual Manual Drill:**

1. Right-click on **Hilti-Decke-Oben** instance
2. Select **"Delete Manual Drill"**
3. Click near the manual drill point you want to remove
4. Press Enter to finish or continue deleting more points
5. Message displays: "Manual drill deleted, remaining [count]"

**Delete All Manual Drills:**

1. Right-click on **Hilti-Decke-Oben** instance
2. Select **"Delete all manual drills"**
3. All manual drill points are removed immediately
4. Message displays: "All manual Drills deleted [count]"

**If No Manual Drills Exist:**
- Message displays: "no manual drill exist"

---

## Properties Panel Reference

The Properties Panel (OPM) shows different parameters depending on connection direction. The script uses **OPM Key** to switch between "Unten" (bottom) and "Oben" (top) property sets.

### Bottom Connection Instance (Hilti-Decke-Unten)

**OPM Key:** "Unten"

#### Referenz (Reference) Category

| Parameter | Type | Options/Default | Description |
|-----------|------|-----------------|-------------|
| Reference Bottom | String | HSW, Custom | Wall reference type for detection |
| Diameter | Double | 9 mm (HSW) | Detection diameter for wall drills (hidden if HSW selected) |
| Depth | Double | 70 mm | Detection depth for wall drills (hidden if HSW selected) |

**Behavior:**
- When `HSW` is selected: Diameter and Depth are hidden, automatically set to 9mm/70mm
- When `Custom` is selected: Diameter and Depth become editable

#### Bohrung (Drill) Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Diameter | Double | 38 mm | Drill diameter in floor beam for Stexon connector |
| Depth | Double | 70 mm | Drill depth in floor beam |

**Applied To:** Floor beam at detected connection point

#### Sägekreuz (Saw Cross) Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Integer | -1 | Sheet zone for saw marking (-5 to -1) |
| Length | Double | 0 mm | Length of saw cross marking (0 = disabled) |
| Depth | Double | 0 mm | Depth of saw cross marking (0 = disabled) |

**Applied To:** Bottom sheeting (if present at drill location)

**Special Case (Baufritz Projects):**
- Instead of saw cross, applies **ElemDrill** (zone index 105):
  - Diameter: 56mm
  - Depth: 12mm
  - Purpose: Bottom drilling operation for Baufritz construction method

---

### Top Connection Instance (Hilti-Decke-Oben)

**OPM Key:** "Oben"

#### Referenz oben (Reference Top) Category

| Parameter | Type | Options/Default | Description |
|-----------|------|-----------------|-------------|
| Reference Top | String | HCW, HCW-P, HCWL, Custom, Holzdolle* | Wall reference type for detection |
| Diameter | Double | Varies by type | Detection diameter for wall drills |
| Depth | Double | 70 mm | Detection depth for wall drills |

**Reference Type Defaults:**

| Type | Diameter | Depth | Notes |
|------|----------|-------|-------|
| HCW | 37 mm | 70 mm | Standard wood coupler |
| HCW-P | 37 mm | 70 mm | HCW variant |
| HCWL | 42 mm | 70 mm | Large wood coupler |
| Holzdolle* | 30 mm | 35 mm | Baufritz wooden dowel (detection parameters) |
| Custom | 37 mm (editable) | 50 mm (editable) | User-defined |

*Holzdolle option only available when project special = "Baufritz"

**Behavior:**
- Predefined types (HCW, HCW-P, HCWL, Holzdolle): Diameter and Depth fields are hidden
- Custom type: Diameter and Depth become editable

#### Bohrung 1 (Drill 1) Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Integer | 1 | Sheet zone for first drill (1 to 5) |
| Diameter | Double | 0 mm | First drill diameter (0 = disabled) |
| Depth | Double | 0 mm | First drill depth (0 = disabled) |

**Purpose:** Typically used for counterbore or larger diameter pilot hole

#### Bohrung 2 (Drill 2) Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Integer | 1 | Sheet zone for second drill (1 to 5) |
| Diameter | Double | 0 mm | Second drill diameter (0 = disabled) |
| Depth | Double | 0 mm | Second drill depth (0 = disabled) |

**Purpose:** Typically used for smaller through-hole or secondary operation

**Note:** Both drills can use different zones if needed (e.g., Drill 1 in zone 1, Drill 2 in zone 2)

#### Manuelle Bohrung (Manual Drill) Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Integer | 1 | Sheet zone for manual drills (1 to 5) |
| Diameter | Double | 0 mm | Manual drill diameter (0 = disabled) |
| Depth | Double | 0 mm | Manual drill depth (0 = disabled) |

**Usage:**
- Add manual drill locations via context menu first (see "Adding Manual Drills")
- Then set diameter and depth here to activate drilling at those locations

**Special Case (Holzdolle - Baufritz):**
When Holzdolle reference is selected:
- Drill 1: Automatically set to Diameter 34mm, Depth = floor zone 1 height + 4mm
- Drill 2: Disabled (Diameter and Depth set to 0)
- Additional beam drill: Ø15mm, 45mm depth, applied directly to beam

---

## Right-Click Menu Options

### For Top Connections (Hilti-Decke-Oben)

| Menu Item | Trigger Key | Description |
|-----------|-------------|-------------|
| **Add Manual Drill** | - | Interactively add manual drill points by clicking near existing automatic drill locations. Max 100 points per session. Manual drills are displayed in blue color. Press Enter to finish. |
| **Delete Manual Drill** | - | Remove individual manual drill points by clicking near them. Continue clicking to delete more, or press Enter to finish. |
| **Delete all manual drills** | - | Remove all manual drill points at once. Displays count of deleted points. |

### For Both Top and Bottom Connections (Import Mode)

| Menu Item | Trigger Key | Description |
|-----------|-------------|-------------|
| **Import Model** | - | Re-read the HiltiExport.dxx file to update connection data. Useful when export file has been modified externally. Triggers two recalculation loops. |

---

## Settings Files and Data Storage

### HiltiExport.dxx File

**Location:**
```
[Parent Folder of Current Drawing]\HiltiExport.dxx
```

**Format:** DXX (ModelMap XML export from Hilti software)

**Contents:**
- Project information (date, author, etc.)
- Wood coupler positions (3D points)
- Script references:
  - Hilti-Stockschraube (bottom connections)
  - Hilti-Verankerung (top connections)
- Property values for each connector type (diameter, depth, reference type)

**Caching Mechanism:**
1. First read: Script creates MapObject "HiltiExport" in dictionary "Hilti"
2. Dependency tracking: Uses `setDependencyOnDictObject()` for automatic updates
3. Date comparison: Checks file modification date vs. cached date
4. Auto-refresh: If file date differs, automatically re-reads and updates cache
5. Legacy cleanup: Removes old `_Map["HiltiImport"]` entries if found

**Example DXX Structure:**
```xml
<Hsb_Map>
  <lst nm="Model">
    <lst nm="Instance">
      <str nm="ScriptName" vl="Hilti-Stockschraube"/>
      <pt3 nm="ptOrg" x="0" y="0" z="0"/>
      <vec nm="vecXUcs" x="1" y="0" z="0"/>
      <vec nm="vecYUcs" x="0" y="1" z="0"/>
      <vec nm="vecZUcs" x="0" y="0" z="1"/>
      <lst nm="PropString[]">
        <lst nm="PropString">
          <str nm="strValue" vl="HSW"/>
        </lst>
      </lst>
    </lst>
  </lst>
  <str nm="ProjectInfo\\Date" vl="2024-12-03 14:30:00"/>
</Hsb_Map>
```

### Internal Data Storage

The script stores persistent data in the TSL instance's internal Map (`_Map`):

**During Wall Reference Mode:**

| Key | Type | Data | Purpose |
|-----|------|------|---------|
| `ptLocs` | Point3d[] | Array of detected drill locations | Preserved when wall reference is removed |
| `vecDir` | Vector3d | Connection direction vector (±Z) | Determines top vs. bottom orientation |
| `vecOrg` | Vector3d | Offset from world origin to _Pt0 | Recalculates insertion point after move |
| `manualDrills` | Point3d[] | Manual drill locations (top only) | User-added supplemental drill points |

**During Import Mode:**

| Key | Type | Data | Purpose |
|-----|------|------|---------|
| `Properties` | Map | Dialog property values | Transferred from insertion to instance |
| `vecDir` | Vector3d | Connection direction | Calculated from floor element orientation |

---

## Reference Type Specifications

### Standard Hilti Reference Types

| Type | Detection Diameter | Detection Depth | Application | Associated Script |
|------|-------------------|-----------------|-------------|-------------------|
| **HSW** | 9 mm | 70 mm | Bottom connections (threaded rod) | Hilti-Stockschraube |
| **HCW** | 37 mm | 70 mm | Top connections (standard wood coupler) | Hilti-Verankerung |
| **HCW-P** | 37 mm | 70 mm | Top connections (HCW variant) | Hilti-Verankerung |
| **HCWL** | 42 mm | 70 mm | Top connections (large wood coupler) | Hilti-Verankerung |
| **Holzdolle** | 30 mm | 35 mm | Top connections (Baufritz wooden dowel) | Hilti-Verankerung |

### "All" Option Behavior

When **"All"** is selected as the reference type, the script creates **multiple TSL instances** for comprehensive detection:

**Bottom Reference = "All":**
- Creates instance with Reference = HSW
- Creates instance with Reference = Custom
- **Total:** 2 instances per floor-wall combination

**Top Reference = "All":**
- Creates instance with Reference = HCW
- Creates instance with Reference = HCW-P
- Creates instance with Reference = HCWL
- Creates instance with Reference = Custom
- Creates instance with Reference = Holzdolle (if Baufritz project)
- **Total:** 4-5 instances per floor-wall combination

**Use Case:**
- Ensures all possible connection types are detected
- Useful when wall contains mixed Hilti hardware types
- Each instance filters for its specific reference type

**Warning:** Can create many instances. Review and delete unnecessary ones.

---

### Custom Reference Type

**Purpose:** Detect drills with non-standard diameters and depths

**Behavior:**
- When "Custom" is selected, the script **ignores standard reference tools** (HCW, HCW-P, HCWL, HSW, Holzdolle)
- Only detects drills matching the custom diameter (±0.1mm tolerance)
- Depth comparison: Direction must match; depth value is **not compared** (only direction)

**Use Case:**
- Working with non-standard Hilti products
- Custom anchor systems
- Project-specific fastener specifications

**Important:** If you select Custom, standard Hilti references (e.g., existing Hilti-Verankerung tools) will NOT be used for detection. This prevents unintended double-detection.

---

## Machining Operations Applied

### Bottom Connection Operations (Hilti-Decke-Unten)

| Operation | Condition | Location | Parameters | Description |
|-----------|-----------|----------|------------|-------------|
| **Beam Drill** | If `dDepthBottom > 0` and `dDiameterBottom > 0` | Floor beam at connection point | Diameter: `dDiameterBottom`<br>Depth: `dDepthBottom`<br>Direction: `-vecDir` (into beam) | Main drill for Stexon threaded rod |
| **Saw Cross** (Standard) | If `dLengthMarking > 0` and `dDepthMarking > 0` and sheeting present | Bottom sheeting (zone -1) | Length: `dLengthMarking`<br>Depth: `dDepthMarking`<br>Tool Index: 1<br>Two perpendicular cuts | Cross-shaped saw cuts marking no-nail zone |
| **ElemDrill** (Baufritz Only) | If Baufritz project and saw cross conditions met | Bottom sheeting (zone -1) | Diameter: 56mm<br>Depth: 12mm<br>Tool Index: 105<br>Vacuum: Yes | Replaces saw cross for Baufritz projects |
| **No-Nail Zone** | If saw cross or ElemDrill applied | Bottom sheeting | Rectangle: 60mm × 60mm centered at drill point | Marks area where nails must be avoided |

**Saw Cross Validation:**
- Only applied if drill point falls **inside sheeting profile** (`_kPointInProfile`)
- Saw cross profile is **clipped to sheeting boundary** using `intersectWith(ppSheet)`
- If sheeting area at location < 0.01mm², saw cross is skipped

**Visual Feedback:**
- Drill location: Green circle (color 3), Ø60mm
- Drill depth: Green line from surface to drill end point
- Error: Red ring (color 1) if drill falls outside beam boundary (with <5mm tolerance)

---

### Top Connection Operations (Hilti-Decke-Oben)

| Operation | Condition | Location | Parameters | Description |
|-----------|-----------|----------|------------|-------------|
| **ElemDrill 1** | If `dDiameterTop1 > 0` and `dDepthTop1 > 0` | Floor element zone `nZoneTop1` | Diameter: `dDiameterTop1 * 0.5` (radius)<br>Depth: `dDepthTop1`<br>Direction: `-vecDir`<br>Tool Index: 1 | First element drill (e.g., counterbore) |
| **ElemDrill 2** | If `dDiameterTop2 > 0` and `dDepthTop2 > 0` | Floor element zone `nZoneTop2` | Diameter: `dDiameterTop2 * 0.5` (radius)<br>Depth: `dDepthTop2`<br>Direction: `-vecDir`<br>Tool Index: 1 | Second element drill (e.g., through-hole) |
| **No-Nail Zone** | Always (if any drill applied) | Floor element zone `nZoneTop1` | Rectangle: 60mm × 60mm centered at drill point | Marks area where nails must be avoided |
| **Beam Drill (Holzdolle)** | If Baufritz project and Holzdolle reference | Floor beam at connection point | Diameter: 15mm<br>Depth: 45mm<br>Direction: `-vecDir` | Wooden dowel anchor for Baufritz |
| **Manual Drills** | If manual drill points exist and `dDiameterTopManual > 0` and `dDepthTopManual > 0` | Floor element zone `nZoneTopManual` | Diameter: `dDiameterTopManual * 0.5` (radius)<br>Depth: `dDepthTopManual`<br>Direction: `-vecDir`<br>Tool Index: 0 | User-added supplemental drill points |

**Drill Validation (HSB-16670):**
- Each drill position must fall **inside the beam boundary** with **5mm tolerance**
- Validation uses shadow profile of beam envelope projected onto drill plane
- Drill circle (Ø10mm test) must be fully contained within beam profile
- If validation fails: Error symbol displayed (red ring), drill is skipped

**Baufritz Holzdolle Special Handling:**
- ElemDrill 1: Diameter = 34mm (not halved for radius), Depth = floor zone 1 height + 4mm
- ElemDrill 2: Disabled (Diameter and Depth = 0)
- Beam Drill: Ø15mm, 45mm depth (instead of standard ElemDrill parameters)

**Visual Feedback:**
- Drill location: Magenta circle (color 6), Ø60mm
- Manual drills: Blue circle (color 5), Ø60mm
- Holzdolle (Baufritz): Blue circle (color 5)
- Error: Red ring (color 1) if drill validation fails

---

## Visual Display System

### Color Coding

| Color | Code | Meaning | Application |
|-------|------|---------|-------------|
| **Green** | 3 | Bottom connection indicators | Bottom drill locations, depth lines, saw cross markings |
| **Magenta** | 6 | Top connection indicators (automatic) | Top drill locations detected from wall references |
| **Blue** | 5 | Top connection indicators (manual) or Holzdolle | User-added manual drill points, Baufritz Holzdolle connections |
| **Red** | 1 | Error indicators | Drill positions that fall outside beam boundaries |
| **Yellow** | 2 | Debug visualization | Floor beams, valid drill positions (only visible when `bDebug = true`) |

### Symbol Legend

| Symbol | Description | Meaning |
|--------|-------------|---------|
| **Solid Circle (Ø60mm)** | Filled circle at connection point | Active drill point (automatic detection) |
| **Solid Blue Circle (Ø60mm)** | Blue filled circle | Manual drill point (user-added) or Holzdolle |
| **Red Ring** | Hollow circle with inner cutout | Error - drill position outside beam boundary (>5mm tolerance) |
| **Green Circle + Line** | Circle with depth line | Bottom connection drill with depth indicator |
| **Rectangle (60×60mm)** | Rectangular outline | No-nail zone marking |
| **Cross (± lines)** | Perpendicular lines | Saw cross marking (bottom connections, non-Baufritz) |

### Display Layers

**Bottom Connections (vecDir pointing down):**
- Display zone: Floor element zone 0, layer 'I' (interior)
- All graphics drawn in green (color 3)

**Top Connections (vecDir pointing up):**
- Display zone: Floor element zone 0, layer 'I' (interior)
- Automatic drills: Magenta (color 6)
- Manual drills: Blue (color 5)
- Holzdolle (Baufritz): Blue (color 5)
- Errors: Red (color 1)

**Debug Mode:**
- Floor beams: Yellow envelope bodies (color 2)
- Wall beam intersection tests: Colored envelope bodies with index numbers
- Valid drill positions: Yellow point markers

---

## Usage Tips and Best Practices

### 1. Verify Wall References First

**Why:** The script depends on existing Hilti reference tools to detect connection points.

**How:**
- Before running Hilti-Decke, apply **Hilti-Stockschraube** or **Hilti-Verankerung** to walls
- Check that reference tools are positioned correctly (perpendicular to floor)
- Verify drill diameters match your project specifications

**Benefit:** Ensures accurate automatic detection and reduces errors.

---

### 2. Use "All" Option Carefully

**Why:** Selecting "All" creates multiple instances for each reference type.

**Impact:**
- Bottom "All": Creates 2 instances (HSW + Custom)
- Top "All": Creates 4-5 instances (HCW + HCW-P + HCWL + Custom + Holzdolle)
- Total: Up to 6-7 instances per floor-wall connection

**When to Use:**
- Mixed hardware types on same wall
- Comprehensive detection for complex projects
- Verification and quality control

**After Use:**
- Review created instances
- Delete unnecessary instances manually
- Verify machining doesn't overlap

---

### 3. Check Error Symbols

**Red Ring Indicators:**
- Appear when drill position falls outside beam boundary (with 5mm tolerance)
- Common causes:
  - Wall reference misaligned with floor beams
  - Floor beam layout doesn't match wall framing
  - Wall moved after reference tools applied

**Resolution Steps:**
1. Identify red ring locations in model space
2. Check floor beam layout at those positions
3. Adjust floor layout if needed (add blocking, adjust beam spacing)
4. Or adjust wall reference positions
5. Script auto-recalculates after element modifications

---

### 4. Import File Updates

**Scenario:** You modified HiltiExport.dxx externally (e.g., updated in Hilti software)

**Manual Refresh:**
1. Right-click on any Hilti-Decke instance
2. Select **"Import Model"**
3. Script re-reads DXX file and updates all instances

**Automatic Refresh:**
- Script compares file modification date with cached date
- Auto-refreshes during insertion (`_bOnInsert`) or debug mode (`_bOnDebug`)
- No action needed if file date changes between sessions

**Dependency Tracking:**
- Script uses `setDependencyOnDictObject()` to monitor MapObject
- Changes to MapObject trigger automatic recalculation

---

### 5. Saw Cross Markings (Bottom Connections)

**Requirement:** Only applied where bottom sheeting exists at drill location

**Validation:**
- Script checks if drill point falls inside sheeting profile
- If sheeting profile is empty or drill is outside, saw cross is skipped
- Saw cross profile is automatically **clipped to sheeting boundary**

**Baufritz Exception:**
- Baufritz projects use **ElemDrill** (Ø56mm, 12mm depth) instead of saw cross
- Applied to same location (zone -1, bottom sheeting)
- Tool index 105, vacuum enabled

**Troubleshooting:**
- If saw cross doesn't appear: Check that sheeting exists in zone -1
- If saw cross is incomplete: Sheeting may have openings or cutouts at that location

---

### 6. Baufritz Mode (Special Handling)

**Activation:** Automatically enabled when `projectSpecial() == "Baufritz"`

**Special Behaviors:**

| Feature | Standard | Baufritz |
|---------|----------|----------|
| Top reference options | HCW, HCW-P, HCWL, Custom | **+ Holzdolle** |
| Holzdolle detection diameter | N/A | 30mm |
| Holzdolle drill parameters | N/A | Ø34mm, depth = zone 1 height + 4mm |
| Holzdolle beam drill | N/A | Ø15mm, 45mm depth |
| Bottom saw cross | ElemSaw (cross-shaped cuts) | **ElemDrill** (Ø56mm, 12mm, index 105) |
| Bottom no-nail zone | After saw cross | After ElemDrill |

**Holzdolle Workflow:**
1. Select "Holzdolle" as Reference Top
2. Detection diameter: 30mm, depth: 35mm
3. Applied drills:
   - ElemDrill 1: Ø34mm (full diameter, not radius), depth = zone 1 height + 4mm
   - Beam drill: Ø15mm, 45mm depth
4. Visual: Blue circles (color 5) instead of magenta

---

### 7. Duplicate Prevention (HSB-17936)

**Problem:** Re-inserting the script with same settings creates duplicate instances

**Solution (Automatic):**
- On `_bOnDbCreated`, script scans all existing Hilti-Decke instances on floor element
- Compares:
  - OPM name (Hilti-Decke-Oben or Hilti-Decke-Unten)
  - Entity references (_Entity[])
  - Reference type (PropString[0])
- If identical instance found: **Automatically deletes the old instance**
- New instance remains

**User Action:** None required. Script handles cleanup automatically.

---

### 8. Loose Beam Handling (Import Mode)

**Feature:** In import mode, script also checks loose beams (not part of floor element)

**Criteria:**
- Beam must be in same element group as floor (house group)
- Beam must be horizontal (not parallel to Z axis)
- Beam must intersect floor envelope profile (with 100mm tolerance in Z direction)

**Count Display:**
- Statistics report shows: "Deckenbalken [total] ([loose count] freie)"
- Example: "Deckenbalken 24 (3 freie)" = 24 total beams, 3 are loose

**Benefit:** Captures connections to rim joists, headers, or other structural members near floor

---

### 9. Zone Numbers Explained

**Zone Numbering Convention:**
- **Negative zones (-5 to -1):** Bottom sheeting layers (bottom of element)
  - Zone -1: Bottom-most sheet
  - Zone -5: Fifth sheet from bottom
- **Positive zones (1 to 5):** Top sheeting layers (top of element)
  - Zone 1: Top-most sheet
  - Zone 5: Fifth sheet from top

**Default Settings:**
- Bottom saw cross: Zone -1 (bottom-most sheet)
- Top drill 1: Zone 1 (top-most sheet)
- Top drill 2: Zone 1 (top-most sheet)
- Manual drills: Zone 1 (top-most sheet)

**When to Change:**
- Multi-layer sheeting (e.g., OSB + gypsum)
- Different drilling depths for different layers
- Specific manufacturing requirements

---

### 10. Custom Drill Diameters

**Use Case:** Non-standard Hilti products or custom anchor systems

**Steps:**
1. Select "Custom" as reference type
2. Set detection parameters:
   - **Diameter:** Drill diameter in wall reference tools (±0.1mm tolerance)
   - **Depth:** Set to 0 if you want to detect all depths, or specific depth value
3. Set tooling parameters:
   - **Drill Diameter:** Actual drill size in floor beam
   - **Drill Depth:** Actual drill depth in floor beam

**Important:** When Custom is selected, script ignores standard reference tools (HCW, HCW-P, HCWL, HSW, Holzdolle)

**Example:**
```
Detection: Ø12mm wall drills
Tooling: Ø45mm floor beam drill, 80mm depth
```

---

### 11. Manual Drill Workflow

**Scenario:** Automatic detection found 8 connections, but you need to add 2 more

**Steps:**
1. Add manual drill points (see "Adding Manual Drills")
2. Modify instance properties:
   - **Manuelle Bohrung > Diameter:** 25mm
   - **Manuelle Bohrung > Depth:** 50mm
   - **Manuelle Bohrung > Zone:** 1
3. Script applies ElemDrill at those locations
4. Visual feedback: Blue circles instead of magenta

**Limitation:** You can only mark existing automatic drill locations as manual. You cannot create entirely new positions.

---

## Statistics Display

When the script runs or recalculates (`_bOnDbCreated`, `_bOnRecalc`, `_bOnDebug`), it displays a comprehensive statistics report in the command line:

```
****************************************
Hilti-Decke oben
Element        101
Deckenbalken   18 (2 freie)
Einfügepunkte  12
Bohrungen oben 10

2 Einfügepunkte prüfen!
****************************************
```

### Report Fields

| Field | Description |
|-------|-------------|
| **Hilti-Decke [oben/unten]** | Connection direction (oben = top, unten = bottom) |
| **Element** | Floor element number |
| **Deckenbalken** | Total floor beams (including loose beams in import mode) |
| **Deckenbalken ([n] freie)** | Count of loose beams (not part of floor element) |
| **Einfügepunkte** | Total insertion points detected from wall references or import data |
| **Bohrungen oben** | Number of drills successfully applied (top connections) |
| **Bohrungen unten** | Number of drills successfully applied (bottom connections) |
| **Sägeschnitte unten** | Number of saw cross markings applied (bottom connections only) |
| **[n] Einfügepunkte prüfen!** | Warning: n insertion points could not be applied (fell outside beam boundaries) |

### Interpreting the Report

**Successful Execution:**
```
Einfügepunkte  12
Bohrungen oben 12
```
- All 12 detected points successfully received drills
- No warnings

**Errors Detected:**
```
Einfügepunkte  15
Bohrungen oben 13

2 Einfügepunkte prüfen!
```
- 15 points detected from wall references
- Only 13 drills applied
- **2 points fell outside beam boundaries** (check for red ring symbols in model)
- Action required: Adjust floor layout or wall references

---

## Data Published for Other TSLs

### MapX (Public Data)

The script publishes data in **SubMapX["Public_Data"]** for use by other scripts:

| Key | Type | Value | Purpose |
|-----|------|-------|---------|
| `nR` | Integer | Number of connection instances found | Other TSLs can query how many Hilti connections exist on this floor |

**Example Usage:**
```c
// Another TSL script reading Hilti-Decke data
TslInst hiltiDecke; // reference to Hilti-Decke instance
Map mapPublic = hiltiDecke.subMapX("Public_Data");
int nConnections = mapPublic.getInt("nR");
reportMessage("Hilti connections: " + nConnections);
```

---

### Dimension Requests (HSB-16519)

The script publishes **dimension requests** in `_Map["DimRequest[]"]` for integration with dimensioning TSLs:

**Request Structure:**
```c
Map mapRequestDim;
mapRequestDim.setString("DimRequestPoint", "DimRequestPoint");
mapRequestDim.setString("stereotype", "Hilti-Decke");
mapRequestDim.setInt("setIsChainDimReferencePoint", true);
mapRequestDim.setPoint3dArray("Node[]", ptDrillsTop); // or ptLocs for bottom
```

**Dimension Directions Published:**

For each connection, **4 dimension requests** are created (all 4 viewing directions):

| View Direction | Dim Line Direction | Perpendicular Direction |
|----------------|-------------------|-------------------------|
| +Z (top view) | +X (vecX) | +Y (vecY) |
| +Z (top view) | +Y (vecY) | -X (-vecX) |
| -Z (bottom view) | -X (-vecX) | -Y (-vecY) |
| -Z (bottom view) | +Y (vecY) | +X (vecX) |

**Purpose:**
- Automatic dimensioning TSLs can read these requests
- Creates chain dimensions to drill points
- Dimensions visible in shop drawing views
- Reference point: `_Pt0` (first drill location or floor origin)

**Accessing Dimension Requests:**
```c
// Dimensioning TSL reading Hilti-Decke requests
Map mapRequests = hiltiDeckeInst._Map.getMap("DimRequest[]");
for (int i = 0; i < mapRequests.length(); i++) {
    Map req = mapRequests.getMap(i);
    Point3d pts[] = req.getPoint3dArray("Node[]");
    Vector3d viewDir = req.getVector3d("AllowedView");
    // Create dimensions...
}
```

---

## Frequently Asked Questions

### Q: The script reports "no valid references found" - what should I do?

**A:** This occurs when the script cannot find any connection data. Check the following:

1. **Wall Reference Method:**
   - Are Hilti-Stockschraube (bottom) or Hilti-Verankerung (top) tools applied to walls?
   - Are the reference tools positioned perpendicular to the floor (direction matches `vecDir`)?
   - Are the drills within 10mm of the floor face plane?

2. **Import Method:**
   - Does `HiltiExport.dxx` exist in the parent folder of the drawing?
   - Does the DXX file contain Hilti-Stockschraube or Hilti-Verankerung instances?
   - Is the floor element within the DXX file's project boundary?

3. **Previous Execution:**
   - If the script was previously run with wall references, those points are stored in `_Map["ptLocs"]`
   - Check if `_Map` data was accidentally cleared

**Resolution:**
- Re-apply wall reference tools
- Verify DXX file exists and contains data
- Use debug mode (`bDebug = true`) to visualize detection process

---

### Q: Why are some drill locations marked with red circles?

**A:** Red ring symbols indicate **drill validation errors** (HSB-16670):

**Causes:**
1. **Drill falls outside beam boundary** (with 5mm tolerance)
2. **Insufficient overlap** between drill circle (Ø10mm test) and beam profile

**Common Scenarios:**
- Wall reference misaligned with floor beam spacing
- Floor beam doesn't extend far enough to wall
- Wall was moved after reference tools were applied
- Beam boundary calculation error (rare)

**Resolution:**
1. **Identify problem locations:** Look for red rings in model space
2. **Check beam layout:** Verify floor beams exist at those positions
3. **Adjust layout:**
   - Add blocking or nailers at wall-floor intersection
   - Adjust beam spacing to match wall framing
   - Move wall reference positions slightly
4. **Script auto-updates:** Modification to floor or wall triggers recalculation

**Note:** Top connections validate drill positions; bottom connections do not (they apply drills to first intersecting beam)

---

### Q: How do I update connections after modifying walls?

**A:** The script automatically recalculates when linked elements are modified:

**Automatic Recalculation Triggers:**
- Floor element modified (beams added/removed, moved, resized)
- Wall element modified (reference tools moved, wall rotated)
- Element groups reorganized
- Linked entities updated

**Manual Refresh (Import Mode):**
1. Right-click on Hilti-Decke instance
2. Select **"Import Model"**
3. Script re-reads HiltiExport.dxx and updates all instances
4. Triggers 2 recalculation loops

**No Action Needed:**
- Script uses dependency tracking via `setDependencyOnDictObject()`
- Automatic updates when MapObject "HiltiExport" changes
- File date comparison ensures latest data is used

---

### Q: Can I use custom drill diameters?

**A:** Yes, select "Custom" as the reference type:

**Setup:**
1. **During Insertion:**
   - Set Reference Bottom/Top = "Custom"
   - Second dialog appears for diameter/depth input

2. **Configure Detection Parameters:**
   - **Diameter:** Wall drill diameter to detect (±0.1mm tolerance)
   - **Depth:** Wall drill depth (0 = detect all depths)

3. **Configure Tooling Parameters:**
   - **Drill Diameter:** Actual drill size in floor beam
   - **Drill Depth:** Actual drill depth in floor beam

**Important Behavior:**
- When Custom is selected, script **ignores standard reference tools** (HCW, HCW-P, HCWL, HSW, Holzdolle)
- Only detects drills matching custom diameter (±0.1mm)
- Direction must match (`vecDir`), but depth is not compared

**Example Use Case:**
```
Wall reference: Ø12mm drills, 75mm deep
Custom detection: Diameter = 12mm, Depth = 0 (any depth)
Floor tooling: Diameter = 50mm, Depth = 85mm
```

---

### Q: What is the difference between Drill 1 and Drill 2 for top connections?

**A:** Top connections can require **two different drill operations** at each location:

**Typical Configuration:**

| Drill | Purpose | Typical Size | Example |
|-------|---------|--------------|---------|
| **Drill 1** | Counterbore or large pilot hole | Ø70mm, 10mm depth | Recess for washer/plate |
| **Drill 2** | Through-hole or smaller pilot | Ø25mm, 10mm depth | Fastener shaft clearance |

**Both drills:**
- Apply at the same X-Y location (same drill point)
- Can use different zones (e.g., Drill 1 in zone 1, Drill 2 in zone 2)
- Can have different diameters and depths
- Are independently enabled (set diameter/depth to 0 to disable)

**Advanced Use:**
- Multi-layer sheeting with different drilling requirements per layer
- Stepped drilling operations
- Combination counterbore + through-hole

**Example Setup:**
```
Drill 1:
  Zone: 1 (top OSB layer)
  Diameter: 70mm
  Depth: 12mm (OSB thickness)
  Purpose: Counterbore for washer

Drill 2:
  Zone: 1 (same layer)
  Diameter: 25mm
  Depth: 50mm (through OSB + air gap)
  Purpose: Fastener clearance hole
```

---

### Q: Why does the script create two instances per floor-wall combination?

**A:** Each floor typically connects to **two walls** - one above and one below:

**Instance Pair:**

1. **Hilti-Decke-Oben** (Top)
   - Connects floor/ceiling to upper wall
   - Uses top face of floor element
   - Direction: `vecDir` points upward (towards ceiling)
   - References: HCW, HCW-P, HCWL, Holzdolle, Custom
   - Machining: Element drills in positive zones (1-5)

2. **Hilti-Decke-Unten** (Bottom)
   - Connects floor to lower wall
   - Uses bottom face of floor element
   - Direction: `vecDir` points downward (towards floor below)
   - References: HSW, Custom
   - Machining: Beam drills, saw cross markings in negative zones (-5 to -1)

**Direction Determination:**
- Script calculates `vecDir` from floor element `vecZ`
- Compares floor center point to wall origin point
- Automatically determines top vs. bottom orientation
- Each instance has different OPM key: "Oben" or "Unten"

**Why Separate Instances:**
- Different reference types (HCW vs. HSW)
- Different machining operations (element drills vs. beam drills + saw cross)
- Different parameter sets in OPM
- Independent recalculation and editing

---

### Q: Can I mix imported data and wall references?

**A:** No, the script processes **either** wall references **or** import data, not both simultaneously:

**Selection Logic:**

1. **Wall references selected:**
   - Script scans selected walls for Hilti reference tools (drills)
   - Stores detected points in `_Map["ptLocs"]`
   - Import data is ignored

2. **No walls selected (Enter pressed):**
   - Script checks if import data exists (`bHasBottomImport` or `bHasTopImport`)
   - Reads HiltiExport.dxx from MapObject
   - Wall references are ignored

**Switching Modes:**
- Delete existing instances
- Re-insert script
- Select walls (Method 1) or press Enter (Method 2)

**Why Not Mixed:**
- Prevents duplicate detections
- Simplifies logic and troubleshooting
- Clear separation of data sources

---

### Q: What happens when I select "Custom" as reference type?

**A:** Custom mode ignores all standard Hilti reference tools and only detects drills matching your specified parameters:

**Behavior:**

| Reference Type | Detects | Ignores |
|----------------|---------|---------|
| HCW, HCW-P, HCWL, HSW, Holzdolle | Standard Hilti reference tool instances by script name and property values | Custom drills |
| **Custom** | Drills matching custom diameter (±0.1mm) in wall beams, any script source | HCW, HCW-P, HCWL, HSW, Holzdolle instances |
| All | Creates separate instances for each type (each instance filters independently) | N/A |

**Example:**

```
Wall contains:
- 8 × Hilti-Verankerung (HCW, Ø37mm)
- 4 × Hilti-Stockschraube (HSW, Ø9mm)
- 2 × Custom drill (Ø12mm) from different TSL

Reference = HCW:
  Detects: 8 HCW instances
  Ignores: 4 HSW + 2 custom drills

Reference = Custom (Ø12mm):
  Detects: 2 custom drills
  Ignores: 8 HCW + 4 HSW instances

Reference = All:
  Creates 5 instances (HCW, HCW-P, HCWL, Custom, Holzdolle if Baufritz)
  Each instance filters for its specific type
```

**Use Case:**
- Working with mixed hardware (standard + custom)
- Non-Hilti fastener systems
- Project-specific anchor requirements

---

### Q: How are zone numbers used?

**A:** Zone numbers determine **which sheet layer** receives the machining operation:

**Zone Numbering:**

```
Top Sheeting (Positive Zones):
  Zone 5: Fifth layer from top
  Zone 4: Fourth layer from top
  Zone 3: Third layer from top
  Zone 2: Second layer from top
  Zone 1: Top-most layer  ← DEFAULT for top drills

Floor Element Core (Beams):
  Zone 0: Core/beams

Bottom Sheeting (Negative Zones):
  Zone -1: Bottom-most layer  ← DEFAULT for bottom saw cross
  Zone -2: Second layer from bottom
  Zone -3: Third layer from bottom
  Zone -4: Fourth layer from bottom
  Zone -5: Fifth layer from bottom
```

**Application:**

| Operation | Default Zone | Adjustable | Purpose |
|-----------|--------------|------------|---------|
| Bottom saw cross | -1 | Yes (-5 to -1) | Target specific bottom sheet layer |
| Bottom ElemDrill (Baufritz) | -1 | Yes (-5 to -1) | Target specific bottom sheet layer |
| Top Drill 1 | 1 | Yes (1 to 5) | Target specific top sheet layer |
| Top Drill 2 | 1 | Yes (1 to 5) | Can be different from Drill 1 |
| Manual Drill | 1 | Yes (1 to 5) | User-specified layer |

**Multi-Layer Example:**

```
Floor Structure (Top to Bottom):
  Zone 2: Gypsum board (12mm)
  Zone 1: OSB sheathing (18mm)
  Zone 0: Joists (200mm)
  Zone -1: OSB subfloor (22mm)
  Zone -2: Gypsum ceiling (15mm)

Configuration:
  Top Drill 1: Zone 1 (OSB), Ø70mm, 18mm depth
  Top Drill 2: Zone 2 (Gypsum), Ø25mm, 12mm depth
  Bottom Saw Cross: Zone -1 (OSB subfloor)
```

---

## Troubleshooting Guide

### Issue: No drills are created

**Symptoms:**
- Script reports "no valid references found"
- Or script completes but no machining appears

**Possible Causes:**

1. **No wall references detected**
   - Wall elements not selected (Method 1)
   - Wall reference tools (Hilti-Stockschraube, Hilti-Verankerung) not applied
   - Reference tool direction doesn't match floor orientation

2. **Import file missing or invalid**
   - HiltiExport.dxx doesn't exist in parent folder
   - DXX file is corrupt or empty
   - DXX file doesn't contain matching script names

3. **Filter mismatch**
   - Reference type selection doesn't match wall reference types
   - Custom diameter doesn't match actual wall drill diameter (±0.1mm tolerance)

**Solutions:**
1. Verify wall reference tools are applied and positioned correctly
2. Check HiltiExport.dxx exists and contains data
3. Enable debug mode (`bDebug = true`) to visualize detection process
4. Try "All" option to detect all reference types

---

### Issue: Drills appear in wrong location

**Symptoms:**
- Drills offset from expected position
- Drills on wrong face of floor element

**Possible Causes:**

1. **Direction mismatch**
   - Wall reference tool direction doesn't align with floor normal
   - Floor element `vecZ` orientation is inverted

2. **Wall moved after reference application**
   - Wall reference tools preserve original position
   - Script uses stored `_Map["ptLocs"]` instead of current wall position

**Solutions:**
1. Re-apply wall reference tools after moving walls
2. Check wall reference tool direction (should point towards floor)
3. Delete Hilti-Decke instance and re-insert to refresh positions

---

### Issue: Saw cross markings don't appear

**Symptoms:**
- Bottom drills work, but no saw cross
- Or saw cross appears incomplete/clipped

**Possible Causes:**

1. **Saw cross disabled**
   - Length or Depth set to 0 in properties

2. **No sheeting at drill location**
   - Drill point falls in opening or cutout
   - Bottom sheeting (zone -1) doesn't exist

3. **Baufritz project**
   - Baufritz projects use ElemDrill instead of saw cross

**Solutions:**
1. Verify Length and Depth parameters are > 0
2. Check that bottom sheeting exists at drill locations
3. For Baufritz: Look for ElemDrill (Ø56mm, 12mm) instead of saw cross

---

### Issue: Many instances created ("All" option)

**Symptoms:**
- 6-7 instances per floor-wall connection
- Duplicate machining operations

**Cause:**
- "All" option selected for top and/or bottom references
- Creates instance for each reference type

**Solution:**
1. Review created instances
2. Identify which reference types are actually needed
3. Delete unnecessary instances manually
4. Or re-insert with specific reference type instead of "All"

---

### Issue: Manual drills don't appear

**Symptoms:**
- Added manual drill points via context menu
- But no drilling appears in model

**Possible Causes:**

1. **Manual drill parameters disabled**
   - Diameter or Depth set to 0 in OPM

2. **Manual drill points not stored**
   - Context menu command didn't complete successfully
   - _Map["manualDrills"] array is empty

**Solutions:**
1. Check OPM: **Manuelle Bohrung > Diameter** and **Depth** must be > 0
2. Verify manual drill points exist: Right-click > "Delete all manual drills" should show count
3. Re-add manual drill points via context menu

---

### Issue: Import Model command doesn't update

**Symptoms:**
- Modified HiltiExport.dxx externally
- Right-click > "Import Model" doesn't reflect changes

**Possible Causes:**

1. **File date unchanged**
   - Script compares file modification date
   - If date identical, cache is not refreshed

2. **MapObject not updated**
   - MapObject "HiltiExport" still contains old data

**Solutions:**
1. Verify HiltiExport.dxx file modification date changed
2. Delete MapObject "HiltiExport" from dictionary "Hilti"
3. Re-insert script to force re-read
4. Or use `_bOnDebug` to force cache refresh

---

## Version History

| Version | Date | Issue ID | Changes | Author |
|---------|------|----------|---------|--------|
| **1.14** | 2024-12-03 | HSB-23098 | Changed Holzdolle depth for Baufritz (45mm beam drill depth) | Marsel Nakuci |
| **1.13** | 2024-10-08 | HSB-22780 | Updated Holzdolle values for Baufritz (Ø30mm detection, Ø34mm drill) | Marsel Nakuci |
| **1.12** | 2024-09-10 | HSB-22652 | Added "Holzdolle" option for Baufritz projects | Marsel Nakuci |
| **1.11** | 2024-05-06 | HSB-21970 | Added HCW-P support (Ø37mm, 70mm depth) | Marsel Nakuci |
| **1.10** | 2024-03-11 | HSB-21590 | Baufritz: Replaced ElemSaw with ElemDrill for bottom connections (Ø56mm, 12mm, index 105) | Markus Sailer |
| **1.9** | 2023-03-15 | HSB-18322 | Don't apply tools at standard HCW, HCWL, HSW if Custom is selected as reference | Marsel Nakuci |
| **1.8** | 2023-03-15 | HSB-18322 | Fixed duplicate instance deletion logic | Marsel Nakuci |
| **1.7** | 2023-03-14 | HSB-18322 | Added "All" option for top and bottom references | Marsel Nakuci |
| **1.6** | 2023-02-13 | HSB-17936 | Avoid duplicated instances on insert (automatic cleanup) | Marsel Nakuci |
| **1.5** | 2023-01-11 | HSB-16519 | Publish mapRequest for dimension of points (DimRequest[]) | Marsel Nakuci |
| **1.4** | 2022-09-29 | HSB-16670 | Top drills only if inside beam with 5mm tolerance (drill validation) | Marsel Nakuci |
| **1.3** | 2022-09-29 | HSB-16670 | Fixed valid position investigation for elemDrills | Marsel Nakuci |
| **1.2** | 2021-09-10 | HSB-12697 | Fixed bug when importing from DXX | Marsel Nakuci |
| **1.1** | 2021-09-08 | HSB-12697 | Added description | Marsel Nakuci |
| **2.0** | 2020-01-13 | HSB-10144 | Manual drill color set to blue | Thorsten Huck |
| **1.9** | 2020-12-16 | HSB-10144 | Added properties for manual drill, add/delete manual drill triggers | Marsel Nakuci |
| **1.8** | 2020-07-29 | - | StexonImport data stored in MapObject, legacy storage purged | Thorsten Huck |
| **1.7** | 2019-06-25 | - | Publish nr of Stexon in MapX for other TSLs | Marsel Nakuci |
| **1.6** | 2019-03-14 | - | Saw crosses only executed if sheeting present in that area | Thorsten Huck |
| **1.5** | 2018-12-13 | - | Insertion points within 5mm of element edge are accepted | Thorsten Huck |
| **1.4** | 2018-12-13 | - | Auto detection of loose beams in import mode, error display and report | Thorsten Huck |
| **1.3** | 2018-11-08 | - | Auto-Stexon-Import added, requires BF-Stexon-Verankerung and/or BF-Stexon-Setzschraube | Thorsten Huck |
| **1.2** | 2018-06-06 | - | No-nail zones added | Thorsten Huck |
| **1.1** | 2018-03-13 | - | Wall reference can be optionally removed, machining remains static, "oben" display corrected | Thorsten Huck |
| **1.0** | 2018-03-12 | - | Initial release | Thorsten Huck |

---

## Related Scripts

### Primary Dependencies (Wall References)

| Script | Purpose | Direction | Reference Type |
|--------|---------|-----------|----------------|
| **Hilti-Stockschraube** | Creates threaded rod connections in walls | Bottom | HSW (Ø9mm, 70mm) |
| **Hilti-Verankerung** | Creates anchor connections in walls | Top | HCW, HCW-P, HCWL, Holzdolle (Ø30-42mm, 35-70mm) |

### Related Hilti Scripts

| Script | Purpose | Relation to Hilti-Decke |
|--------|---------|-------------------------|
| **Hilti-Einzeln** | Individual Hilti connection points | Alternative for single-point connections |
| **Hilti-Verteilung** | Distribution of Hilti fasteners | Complementary for distributed fastener patterns |
| **Hilti-P2P** | Point-to-point Hilti connections | Alternative for custom point placement |

### Workflow Integration

**Typical Workflow:**

1. **Design Phase:**
   - Create floor elements (ElementRoof/ElementFloor)
   - Create wall elements (ElementWallSF)
   - Position elements in 3D model

2. **Reference Phase:**
   - Apply **Hilti-Stockschraube** to bottom walls
   - Apply **Hilti-Verankerung** to top walls
   - Verify reference tool positions and orientations

3. **Connection Phase:**
   - Run **Hilti-Decke** (this script)
   - Select floor and wall elements
   - Configure drill parameters
   - Review statistics and error symbols

4. **Refinement Phase:**
   - Add manual drill points if needed
   - Adjust parameters in OPM
   - Verify machining operations
   - Check no-nail zones

5. **Documentation Phase:**
   - Dimension drill points (uses DimRequest[] data)
   - Generate shop drawings
   - Export to CNC (uses element drill/saw data)

---

## Technical Details

### Script Classification

- **Category:** Hardware/Hilti
- **Structure Type:** Floor/Ceiling
- **Function:** Floor-to-wall connections
- **Complexity:** High (851KB source code, 1716 lines)

### Key Technologies

- **Import System:** ModelMap/DXX file parsing
- **Caching:** MapObject persistent storage
- **Dependency Tracking:** Automatic recalculation on element changes
- **Drill Validation:** Shadow profile intersection testing (5mm tolerance)
- **Multi-instance Management:** Automatic duplicate detection and cleanup

### Performance Considerations

- **Large Projects:** Import mode processes all instances in DXX file (can be 100+ connections)
- **Loose Beams:** Import mode checks loose beams within 100mm of floor (additional processing)
- **Duplicate Prevention:** On insert, scans all existing instances on floor element
- **Recalculation:** Triggers on element modification, MapObject update, or manual refresh

### Coordinate Systems

- **World CS:** Global coordinate system (`_XW`, `_YW`, `_ZW`)
- **Floor CS:** Floor element local coordinate system (`vecX`, `vecY`, `vecZ`)
- **Connection Direction:** `vecDir` = ±`vecZ` based on wall-floor relationship
- **Insertion Point:** `_Pt0` = first drill location or floor origin (stored as offset from world origin)

---

## Summary

**Hilti-Decke** is a comprehensive floor-to-wall connection tool for Hilti Stexon wood coupler systems. It automates machining operations (drills, saw markings, no-nail zones) based on wall reference tools or imported Hilti export data. The script creates separate instances for top and bottom connections, supports multiple Hilti reference types (HCW, HCW-P, HCWL, HSW, Holzdolle), and includes advanced features like manual drill supplementation, automatic recalculation, and Baufritz-specific handling. With intelligent validation, duplicate prevention, and comprehensive statistics reporting, Hilti-Decke streamlines the floor-wall connection workflow for timber construction projects.

---

**Document Version:** 2.0
**Script Version:** 1.14 (2024-12-03)
**Documentation Size:** 47KB (comprehensive user guide)
**Coverage:** 5.5% of source code (851KB script → 47KB documentation)
