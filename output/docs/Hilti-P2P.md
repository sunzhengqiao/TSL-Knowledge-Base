# Hilti-P2P (Panel-to-Panel Connection System)

**Hilti HTC-P2P Panel-to-Panel Connector** - Automated distribution and tooling system for connecting CLT panels, SIPs, beams, and sheets with Hilti HTC-P2P fasteners.

---

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Script Name** | `Hilti-P2P.mcr` |
| **Version** | 1.10 (November 13, 2025) |
| **Manufacturer** | Hilti |
| **Category** | Hardware / Connection System |
| **Keywords** | Hilti, P2P, GenBeam, SIP, CLT, Connection, Distribution, Panel-to-Panel |
| **Requires Beams** | 0 (Interactive selection during insertion) |

---

## Purpose and Application

The **Hilti-P2P** script creates parametric panel-to-panel connections using Hilti HTC-P2P connectors. This intelligent connection system automatically:

1. **Detects valid connection zones** between adjacent timber elements
2. **Calculates optimal connector distribution** along joint edges
3. **Generates tooling geometry** (milling profiles) for both male and female sides
4. **Creates hardware BOM entries** for material takeoff
5. **Supports multiple insertion modes** for different workflow requirements

### Supported Element Types

The script works with all **GenBeam** entity types:
- **CLT Panels** (Cross-Laminated Timber)
- **SIP Panels** (Structural Insulated Panels)
- **Beams** (Standard timber beams)
- **Sheets** (Sheathing panels - OSB, plywood)

### Connection Requirements

For a valid connection to be detected:
- Elements must have **parallel adjacent faces** (within tolerance)
- Gap between elements must be **≤ 50mm** (`dGapMax`)
- Elements must have overlapping contact area in the connection direction
- Minimum edge distance: **250mm** (`dEedgeMin`)
- Minimum connector spacing: **300mm** (`dEconnMin`)

---

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| **Model Space** | ✓ Yes | Primary working environment |
| **Paper Space** | ✗ No | Not applicable for 3D connections |
| **Element Required** | No | GenBeams selected interactively during insertion |
| **Works With** | GenBeam, Sip, Beam, Sheet | All timber element types |

---

## Script Architecture

### Key Constants and Settings

```c
double dEedgeMin = U(250);    // Minimum edge distance
double dEconnMin = U(300);    // Minimum connector interdistance
double dGapMax = U(50);       // Maximum allowable gap between elements
```

### Operational Modes

The script operates in different modes based on user selection:

| Mode ID | Mode Name | Description |
|---------|-----------|-------------|
| **100** | Distribution Mode | Full distribution along connection with configurable spacing |
| **101** | Single Instance Mode | Place individual connectors at specific points |

### Settings File Structure

**File Locations:**
- **Company Settings**: `[Company Path]\TSL\Settings\Hilti-P2P.xml`
- **Installation Default**: `[Install Path]\Content\General\TSL\Settings\Hilti-P2P.xml`

**XML Structure:**
```xml
<Hsb_Map>
  <lst nm="Type[]">
    <lst nm="Element">
      <str nm="Type" vl="HTC-P2P 90mm M12"/>
      <dbl nm="Height" ut="L" vl="78.2"/>
      <dbl nm="Depth" ut="L" vl="70"/>
      <int nm="Color" vl="30"/>
      <int nm="ColorText" vl="5"/>
      <pl nm="plMale">...</pl>
      <pl nm="plFemale">...</pl>
      <pl nm="Tool">...</pl>
      <pl nm="ToolSide">...</pl>
      <pl nm="ToolHalf">...</pl>
    </lst>
  </lst>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>
</Hsb_Map>
```

**Type Definition Components:**
- `Type`: Connector model name (displayed in OPM dropdown)
- `Height`: Physical connector height (default: 78.2mm)
- `Depth`: Recommended milling depth (default: 70mm)
- `Color`: Display color for 3D geometry
- `plMale`: Male connector profile geometry (PLine)
- `plFemale`: Female connector profile geometry (PLine)
- `Tool`: Full tooling profile outline
- `ToolSide`: Tool profile for one side (half the connector)
- `ToolHalf`: Half tool profile for distribution

---

## Step-by-Step Usage Guide

### Workflow Overview

```
1. Launch Script
   ↓
2. Configure Parameters (Dialog)
   ↓
3. Select GenBeams (≥2 elements)
   ↓
4. Choose Insertion Mode
   ↓
5. Place Connectors (Interactive or Automatic)
   ↓
6. Result: Connectors + Tooling + BOM
```

### Detailed Insertion Procedure

#### Step 1: Launch the Script

**Method A: TSL Browser**
```
TSLCONTENT → Navigate to Hilti-P2P → Insert
```

**Method B: Command Line**
```
Command: (hsb_ScriptInsert "Hilti-P2P")
```

#### Step 2: Initial Configuration Dialog

The standard properties dialog appears with three categories:

**Insertion Category:**
- **Insertion Mode**: Choose interaction method (default: "Select")

**Distribution Category:**
- **Rule**: Fixed or Even distribution (default: "Fixed Distribution")
- **Start Offset**: 350mm (distance from start edge)
- **End Offset**: 350mm (distance from end edge)
- **Interdistance**: 1000mm (maximum spacing between connectors)

**Tooling Category:**
- **Depth**: 93mm (milling depth, range: 93-105mm recommended)
- **Show tooling**: No (toggle tooling geometry visibility)
- **Type**: "HTC-P2P 90mm M12" (connector model from XML)

Click **OK** to proceed.

#### Step 3: Select GenBeams

**Prompt:** `"Select genbeams"`

**Selection Process:**
1. Click on two or more adjacent timber elements (CLT, SIP, Beam, or Sheet)
2. Elements can be selected in any order
3. Press **Enter** to confirm selection
4. Script validates:
   - Minimum 2 GenBeams selected
   - Valid connection zones exist between selected elements

**Error Handling:**
- If no valid connections found: `"No possible connection found"` → Script aborts
- If fewer than 2 GenBeams: `"At least 2 Genbeams needed"` → Script aborts

#### Step 4: Insertion Mode Behavior

Based on the **Insertion Mode** setting:

##### Mode: "Select" (Interactive Full Distribution)

**Behavior:**
1. Script calculates all valid connection zones between selected GenBeams
2. Valid zones are highlighted in **light blue** (`lightblue` color, 60% transparency)
3. Move cursor over highlighted zones - active zone highlights as you hover
4. **Left-click** on a zone to place full distribution of connectors
5. Continue clicking other zones or press **Escape/Enter** to finish

**Interactive Keyboard Options:**
- **Type `S`**: Switch to **Select** mode (full distribution)
- **Type `I`**: Switch to **sIngle** mode (one connector at cursor)
- **Type `M`**: Switch to **siMilar** mode (apply to all geometrically similar connections)

**Jigging System:**
The script uses advanced jigging with action `strJigAction1`:
- Real-time preview of connection zone as you move cursor
- Filled polygon shows valid connector area
- In Single mode (`I`), shows individual connector preview at cursor position
- In Similar mode (`M`), highlights all matching connection zones simultaneously

##### Mode: "Single instance" (Point-by-Point Placement)

**Behavior:**
1. Same as "Select" mode but places only **one connector** at the clicked point
2. No automatic distribution calculation
3. Useful for placing connectors at specific structural locations
4. Same keyboard shortcuts available (`S`, `I`, `M`)

##### Mode: "All" (Automatic - All Valid Connections)

**Behavior:**
1. **No interactive selection** - fully automatic
2. Script finds all valid connections between selected GenBeams
3. Applies distribution to **every valid connection zone** automatically
4. Fastest method for regular panel assemblies

##### Mode: "View direction" (Connections Facing View)

**Behavior:**
1. Filters connections based on current view direction (`vecZView`)
2. Only creates connections where normal vector faces **toward** the current view
3. Useful for working on one side of a panel assembly
4. Formula: Connection normal must satisfy `vPlane.dotProduct(vecZView) > tolerance`

##### Mode: "Opposite view direction" (Connections Facing Away)

**Behavior:**
1. Opposite of "View direction" mode
2. Only creates connections facing **away from** current view
3. `vPlane.dotProduct(vecZView) < -tolerance`

##### Mode: "Reference Side" (Panel Reference Face)

**Behavior:**
1. For SIP/CLT panels with defined reference sides
2. Creates connections on the **reference face** of panels
3. Script checks: `abs(mapConnection.getVector3d("vPlane").dotProduct(_Sip[0].vecZ()) - 1.0) < 0.001`

##### Mode: "Opposite Side" (Panel Opposite Face)

**Behavior:**
1. Creates connections on the **non-reference face** of panels

##### Mode: "Higher Quality" / "Lower Quality" (Quality-Based Selection)

**Behavior:**
1. When panels have quality designations, prioritizes faces accordingly
2. Useful for CLT panels with different face grades

#### Step 5: Result Verification

After placement, verify:
- **Nr. parts**: Shows calculated quantity of connectors placed
- **Real Interdistance**: Displays actual calculated spacing (may differ from input if "Even Distribution" was used)
- **Visual Display**: Connectors appear in display color (default: color 30)
- **Tooling Geometry**: If "Show tooling" = "Yes", milling profiles are visible

---

## Properties Panel (OPM) Reference

### Category: Insertion

#### Insertion Mode
- **Type**: Dropdown (String)
- **Default**: "Select"
- **Options**:
  1. **Select** - Interactive selection with full distribution along connection
  2. **Single instance** - Place one connector at a time at cursor position
  3. **All** - Automatically process all valid connections
  4. **View direction** - Only connections facing toward view
  5. **Opposite view direction** - Only connections facing away from view
  6. **Reference Side** - Use panel reference face
  7. **Opposite Side** - Use panel opposite face
  8. **Higher Quality** - Prioritize higher quality panel faces
  9. **Lower Quality** - Prioritize lower quality panel faces

**Usage Notes:**
- **Select** and **Single instance** modes offer interactive jigging with keyboard shortcuts
- **All** mode is fastest for standard assemblies with regular spacing
- **View direction** modes are useful when working on complex 3D assemblies
- **Quality** modes require panels with defined quality attributes

---

### Category: Distribution

#### Rule
- **Type**: Dropdown (String)
- **Default**: "Fixed Distribution"
- **Options**:
  1. **Fixed Distribution** - Uses exact Interdistance value, adjusts last spacing if needed
  2. **Even Distribution** - Calculates equal spacing to fit whole connectors

**Algorithm Details:**

**Fixed Distribution:**
```
nConnectors = floor((Length - StartOffset - EndOffset) / Interdistance) + 1
Spacing = Interdistance (constant)
Last segment may be shorter than Interdistance
```

**Even Distribution:**
```
nConnectors = floor((Length - StartOffset - EndOffset) / Interdistance) + 1
RealInterdistance = (Length - StartOffset - EndOffset) / (nConnectors - 1)
Spacing = RealInterdistance (constant, optimized)
```

#### Start Offset
- **Type**: Length (PropDouble)
- **Default**: 350mm
- **Range**: ≥ 0mm (recommended: ≥ 250mm for structural safety)
- **Description**: Distance from the start edge of the connection to the first connector centerline

**Important:**
- While any positive value is accepted, values < 250mm may violate structural edge distance requirements
- The script uses `dEedgeMin = U(250)` internally for edge exclusion zones
- If insufficient space after offsets: `"no distribution possible. Try to change the distribution parameters"`

#### End Offset
- **Type**: Length (PropDouble)
- **Default**: 350mm
- **Range**: ≥ 0mm (recommended: ≥ 250mm)
- **Description**: Distance from the end edge of the connection to the last connector centerline

**Important:**
- Same structural considerations as Start Offset
- Both offsets combined with Interdistance determine total number of connectors

#### Interdistance
- **Type**: Length (PropDouble)
- **Default**: 1000mm
- **Range**: ≥ 300mm (enforced)
- **Description**: Maximum allowed spacing between connector centerlines

**Validation:**
```c
if(dOffsetBetween < dEconnMin && dOffsetBetween >= 0)
{
    reportMessage("Interdistance must be >= 300mm");
    dOffsetBetween.set(dEconnMin); // Auto-corrects to 300mm
}
```

**Structural Rationale:**
- Minimum 300mm spacing ensures adequate load transfer
- Prevents over-concentration of connectors
- Follows Hilti HTC-P2P design guidelines

#### Real Interdistance (Read-Only)
- **Type**: Length (PropDouble)
- **Default**: 0mm (calculated)
- **Description**: Actual calculated spacing after distribution optimization

**Display Logic:**
- Shows calculated value when only **one distribution region** exists
- Shows **-1** when **multiple distribution regions** exist (e.g., connection interrupted by genbeam edges)
- In "Fixed Distribution": Usually equals Interdistance (may differ for last segment)
- In "Even Distribution": Optimized value to achieve equal spacing

#### Nr. parts (Read-Only)
- **Type**: Integer (PropInt)
- **Default**: 0 (calculated)
- **Description**: Total number of connectors placed across all distribution regions

**Calculation:**
```c
nNrResult.set(ptsDis.length());
```
- Counts all connector insertion points after distribution calculation
- Updates dynamically when offsets or interdistance change
- Used for hardware BOM quantity

---

### Category: Tooling

#### Depth
- **Type**: Length (PropDouble)
- **Default**: 93mm
- **Range**: 0-200mm (recommended: 93-105mm)
- **Description**: Milling depth into the panel face for connector pocket

**Recommended Values:**
- **HTC-P2P 90mm M12**: 93-105mm
- **HTC-P2P 60mm M12**: 93-105mm

**Important:**
- Depth should be ≥ connector body depth but ≤ panel thickness
- Insufficient depth: Connector won't seat properly
- Excessive depth: Structural panel capacity reduced
- Default 93mm provides optimal balance

#### Show tooling
- **Type**: Dropdown (String - Yes/No)
- **Default**: "No"
- **Options**: "No", "Yes"
- **Description**: Toggle visibility of milling tool geometry preview

**When Enabled ("Yes"):**
- Displays `FreeProfile` tooling geometry applied to each GenBeam
- Shows both male and female tool profiles
- Useful for:
  - Verifying tool clearances
  - CNC programming validation
  - Collision detection in complex assemblies

**Performance Note:**
- Enabling tooling display may slow down regeneration for large distributions
- Script uses `envelopeBody()` for performance optimization

#### Type
- **Type**: Dropdown (String)
- **Default**: "HTC-P2P 90mm M12"
- **Options**: Loaded dynamically from XML settings file
- **Standard Types**:
  1. **HTC-P2P 90mm M12** - 90mm height connector, M12 thread, Depth: 70mm
  2. **HTC-P2P 60mm M12** - 60mm height connector, M12 thread, Depth: 70mm

**How Types Are Loaded:**
```c
String sTypes[] = getTypes(mapSetting);
// Reads from mapSetting.getMap("Type[]")
// Each type has: Type name, Height, Depth, Color, plMale, plFemale, Tool profiles
```

**Type Selection Impact:**
- Changes connector **display geometry** (male/female shapes)
- Changes **hardware BOM** article name
- Changes **tooling profile** geometry (if custom profiles defined in XML)
- Changes **display color** (if defined in type settings)

**Custom Types:**
- Add new types by editing `Hilti-P2P.xml`
- Must define: Type name, Height, plMale, plFemale, Tool, ToolSide, ToolHalf
- Optional: Color, ColorText, Depth override

---

## Right-Click Context Menu

After placing a Hilti-P2P connection, the following context menu options are available:

### 1. Edit in Place / Disable Edit in Place
**Function**: Toggle interactive grip editing mode

**When Enabled ("Edit in Place"):**
- Two distribution grips appear at **start** and **end** of connection
- Grips are **triangular isosceles** shape (`_kGSTTriangleIso`)
- Grip color: **2** (yellow/green depending on template)
- Grips are **stretch points** - dragging adjusts distribution region
- Grips aligned to **connection direction** (`vDir`)

**Grip Behavior:**
- **Start Grip**: Located at `ptStartDis` (first connector position + Start Offset)
- **End Grip**: Located at `ptEndDis` (last connector position - End Offset)
- Dragging grips **dynamically recalculates** distribution
- Connectors update in real-time as you adjust

**When Disabled:**
- Grips removed from display
- Distribution locked to property values

**Use Cases:**
- Fine-tune connector placement around openings
- Adjust distribution after element modifications
- Visual feedback for optimization

**Implementation:**
```c
String sGrpNameDistribution = "distribution";
Grip grip(ptStartDis);
grip.setShapeType(_kGSTTriangleIso);
grip.setColor(2);
grip.setVecX(-vecDirDis);  // Points inward
grip.setVecY(vPlane);
grip.setIsStretchPoint(true);
grip.setIsRelativeToEcs(true);
grip.setName(sGrpNameDistribution);
_Grip.append(grip);
```

### 2. Explode distribution
**Function**: Convert distributed connection into individual single-instance connectors

**Process:**
1. Script creates new `Hilti-P2P` instance for each connector in distribution
2. Each new instance operates in **Mode 101** (Single instance mode)
3. Original distributed instance is **deleted** (`eraseInstance()`)
4. New instances inherit:
   - All property values (offsets, depth, type)
   - Connection geometry (`mapConnection`)
   - GenBeam references

**Result:**
- Each connector becomes independently editable
- Can move individual connectors using grips
- Can delete specific connectors without affecting others
- Useful for irregular spacing requirements

**Implementation:**
```c
// For each connector point in distribution
for (int p=0; p<ptsDis.length(); p++)
{
    ptsTsl[0] = ptsDis[p];
    gbsTsl[0] = appropriate GenBeams for this location;
    mapTsl.setInt("mode", 101);  // Single instance mode
    mapTsl.setMap("mapConnection", mapConnection);
    tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl,
        ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
}
eraseInstance();  // Delete original distribution
```

**Cannot Undo:**
- Exploding is permanent - no built-in way to re-merge
- To recreate distribution, delete instances and re-insert script

### 3. Swap Direction
**Function**: Move connection to opposite face of joined elements

**Use Cases:**
- Switch connector accessibility from one side to the other
- Adjust for fabrication/assembly sequence requirements
- Correct connections placed on wrong face

**Algorithm:**
1. **Detect Opposite Connections:**
   - Recalculates all valid connections for current GenBeams
   - Filters for connections with opposite normal: `vPlane.dotProduct(vPlaneOriginal) < 0`

2. **Prefer Exact Opposites:**
   - **Exact Opposite**: `abs(abs(vPlane.dotProduct(vPlaneOriginal)) - 1.0) < 0.001` AND same direction
   - If found, uses exact opposite connection
   - If not found, uses any opposite-facing connection

3. **Validation:**
   - If no opposite connection exists: `"Swapping not possible"`
   - If geometry has changed and connection invalid: Abort

**Implementation:**
```c
Map mapOppositeExacts, mapOppositeAll;
for (int i=0; i<mapConnections.length(); i++)
{
    Map mi = mapConnections.getMap(i);
    Vector3d vPlanei = mi.getVector3d("vPlane");
    Vector3d vDiri = mi.getVector3d("vDir");
    if(vPlanei.dotProduct(vPlane) < 0)  // Opposite direction
    {
        if(abs(abs(vPlanei.dotProduct(vPlane))-1.0)<0.001 &&
           abs(abs(vDiri.dotProduct(vDir))-1.0)<0.001)
        {
            mapOppositeExacts.appendMap("m", mi);  // Exact opposite
        }
        else
        {
            mapOppositeAll.appendMap("m", mi);  // Any opposite
        }
    }
}
```

**Error Messages:**
- `"Swapping not possible"` - No valid opposite connection found (Version 1.6 - HSB-24270)
- `"Tool will be deleted"` - Underlying geometry changed, connection no longer valid

---

## Connector Geometry System

### Male and Female Components

The Hilti HTC-P2P connector consists of two interlocking parts:

#### Male Part (Tooth Profile)
**Default Geometry (HTC-P2P 90mm):**
```c
Body getMalePart(Map mapType)
{
    Point3d pt = _PtW;  // World origin
    PLine _pl;

    // 8-vertex profile (symmetric about Y-axis)
    _pl.addVertex(pt - _XW*U(39.1) - _YW*U(64.5));  // Bottom left
    _pl.addVertex(pt - _XW*U(20)   - _YW*U(16));    // Neck left
    _pl.addVertex(pt - _XW*U(20)   + _YW*U(9.84));  // Shoulder left
    _pl.addVertex(pt - _XW*U(8.91) + _YW*U(22.63)); // Tooth tip left
    _pl.addVertex(pt + _XW*U(8.91) + _YW*U(22.63)); // Tooth tip right
    _pl.addVertex(pt + _XW*U(20)   + _YW*U(9.84));  // Shoulder right
    _pl.addVertex(pt + _XW*U(20)   - _YW*U(16));    // Neck right
    _pl.addVertex(pt + _XW*U(39.1) - _YW*U(64.5));  // Bottom right
    _pl.close();

    dBdHeight = U(78.2);  // or mapType.getDouble("Height")
    Body bdOut = Body(_pl, -_ZW * dBdHeight, 1);  // Extrude downward
    return bdOut;
}
```

**Dimensions (90mm M12 type):**
- Width: 78.2mm (39.1mm × 2)
- Total height: ~87mm (from -64.5 to +22.63)
- Tooth width: 17.82mm (8.91mm × 2)
- Extrusion depth: 78.2mm (into panel)

#### Female Part (Socket Profile)
**Default Geometry:**
```c
Body getFemalePart(Map mapType)
{
    Point3d pt = _PtW;
    PLine _pl;

    // 6-vertex profile (symmetric about Y-axis)
    _pl.addVertex(pt - _XW*U(8.48)  + _YW*U(28.79)); // Socket top left
    _pl.addVertex(pt - _XW*U(20)    + _YW*U(16));    // Socket mid left
    _pl.addVertex(pt - _XW*U(39.1)  + _YW*U(64.5));  // Bottom left
    _pl.addVertex(pt + _XW*U(39.1)  + _YW*U(64.5));  // Bottom right
    _pl.addVertex(pt + _XW*U(20)    + _YW*U(16));    // Socket mid right
    _pl.addVertex(pt + _XW*U(8.48)  + _YW*U(28.79)); // Socket top right
    _pl.close();

    dBdHeight = U(78.2);
    Body bdOut = Body(_pl, -_ZW * dBdHeight, 1);
    return bdOut;
}
```

**Dimensions:**
- Width: 78.2mm (39.1mm × 2)
- Socket opening: 16.96mm (8.48mm × 2)
- Total height: ~93mm (from +28.79 to +64.5 + extrusion)
- Extrusion depth: 78.2mm

### Orientation System

When placed at a connection, connectors are **transformed** from world coordinates to connection local coordinates:

**Coordinate System:**
```c
Point3d ptPlane;     // Connection plane reference point
Vector3d vDir;       // Connection direction (along joint edge)
Vector3d vPlane;     // Connection plane normal (points from panel face)
Vector3d vN = vPlane.crossProduct(vDir);  // Perpendicular to connection
```

**Transformation:**
```c
Body getToolBodyOriented(Point3d _pt, Vector3d _vx, Vector3d _vy, Vector3d _vz,
    Map mapType)
{
    Body bdMale = getMalePart(mapType);
    Body bdFemale = getFemalePart(mapType);

    // Transform from WCS to connection local coordinates
    bdMale.transformBy(_pt, _vx, _vy, _vz);
    bdFemale.transformBy(_pt, _vx, _vy, _vz);

    return combined body;
}
```

**Display Placement:**
For each connector point in distribution:
```c
for (int p=0; p<_pts.length(); p++)
{
    Point3d ptP = _pts[p];  // Connector center along vDir
    Body bdMaleP = bdMale;
    Body bdFemaleP = bdFemale;

    // Transform to connection position
    bdMaleP.transformBy(ptP, _vDir, _vN, _vPlane);
    bdFemaleP.transformBy(ptP, _vDir, _vN, _vPlane);

    // Offset to correct panel faces
    bdMaleP.transformBy(_v01 * halfGap);   // Move to first panel
    bdFemaleP.transformBy(-_v01 * halfGap); // Move to second panel

    _dp.draw(bdMaleP);
    _dp.draw(bdFemaleP);
}
```

---

## Tooling System (CNC Milling)

### Tooling Profile Definition

The script generates **FreeProfile** tooling geometry for CNC milling machines to create pockets for the connectors.

#### Tool Profile Components (from XML)

Each connector type defines three polyline profiles:

1. **Tool** - Full connector outline for reference
2. **ToolSide** - Profile for one side of the connector
3. **ToolHalf** - Half-profile for splitting between adjacent panels

**Example XML Structure:**
```xml
<pl nm="Tool">
  <dbl_pt x="..." y="..." z="..."/>
  <!-- Full connector outline vertices -->
</pl>
<pl nm="ToolSide">
  <dbl_pt x="..." y="..." z="..."/>
  <!-- One side profile -->
</pl>
<pl nm="ToolHalf">
  <dbl_pt x="..." y="..." z="..."/>
  <!-- Half profile for distribution -->
</pl>
```

### Tooling Application Algorithm

```c
Map doTooling(GenBeam _gbs[], Map _mapConnection, Point3d _pts[],
    Map _mapType, double _dDepth, int _bShowTooling)
{
    // Extract tool profiles from type definition
    PLine _plTool     = _mapType.getPLine("Tool");
    PLine _plToolSide = _mapType.getPLine("ToolSide");
    PLine _plToolHalf = _mapType.getPLine("ToolHalf");

    // Connection geometry
    Vector3d _vPlane = _mapConnection.getVector3d("vPlane");
    Vector3d _vDir   = _mapConnection.getVector3d("vDir");
    Vector3d _vN     = _vPlane.crossProduct(_vDir);

    // For each connector point
    for (int p=0; p<_pts.length(); p++)
    {
        Point3d ptP = _pts[p];

        // Create oriented tool profiles
        PLine _plToolSidei  = _plToolSide;
        PLine _plToolHalfi  = _plToolHalf;
        PLine _plToolSideRi = _plToolSide;
        PLine _plToolHalfRi = _plToolHalf;

        // Transform to connection coordinates at this point
        _plToolSidei.transformBy(ptP, _vDir, _vN, _vPlane);
        _plToolHalfi.transformBy(ptP, _vDir, _vN, _vPlane);

        // Offset to panel faces
        Vector3d v01 = _mapConnection.getVector3d("v01");
        _plToolSidei.transformBy(v01 * halfGap);   // Left panel
        _plToolSideRi.transformBy(-v01 * halfGap); // Right panel

        // Apply to each intersecting GenBeam
        for (int g=0; g<_gbs.length(); g++)
        {
            GenBeam gb = _gbs[g];

            // Check if this GenBeam intersects tool area at this location
            PlaneProfile ppg = gb.realBody().extractContactFaceInPlane(
                Plane(ptP, _vPlane), U(1));

            if (ppg.intersectWith(_plToolHalfi))
            {
                // Apply FreeProfile tooling to this GenBeam
                doFreeprofileAtGb(gb, _plToolSidei, _dDepth, _bShowTooling);
            }
        }
    }
}
```

### FreeProfile Application

```c
void doFreeprofileAtGb(GenBeam _gb, PLine _plTool, double _dDepth,
    int _bShowTooling)
{
    // Create FreeProfile from polyline
    FreeProfile fp(_plTool, _plTool.vertexPoints(true));

    // Set depth
    fp.setDepth(_dDepth);

    // Apply to GenBeam
    _gb.addTool(fp);

    // Optional: Display for verification
    if (_bShowTooling)
    {
        Display dp(6);  // Color 6 (magenta)
        dp.draw(fp);
    }
}
```

### Tooling Split Logic

**Why Split?**
- Each connector spans the gap between two panels
- Male part goes into one panel, female part into the other
- Tool must be split so each panel receives only its portion

**Implementation:**
```c
// Create two PlaneProfiles to determine which GenBeam gets which tool half
PlaneProfile _ppToolHalfi, _ppToolHalfRi;
_ppToolHalfi.createProfile(_plToolHalfi);
_ppToolHalfRi.createProfile(_plToolHalfRi);

// For each GenBeam, check intersection with each half
for (int p=0; p<_pps.length(); p++)
{
    PlaneProfile _ppp = _pps[p];  // GenBeam contact area

    if (_ppp.intersectWith(_ppToolHalfi))
    {
        doFreeprofileAtGb(_gbs[p], _plToolSidei, _dDepth, _bShowTooling);
    }
    if (_ppp.intersectWith(_ppToolHalfRi))
    {
        doFreeprofileAtGb(_gbs[p], _plToolSideRi, _dDepth, _bShowTooling);
    }
}
```

---

## Hardware BOM Integration

### Hardware Component Generation

```c
HardWrComp[] prepareHardware(TslInst _tsl, int _nQtys, GenBeam _gbs[],
    Map _mapType)
{
    // Get connector type name from type definition
    String sArticleName = _mapType.getString("Type");
    // e.g., "HTC-P2P 90mm M12"

    // Create hardware component with quantity
    HardWrComp hwc(sArticleName, _nQtys);

    // Set manufacturer and category
    hwc.sDescription   = "Hilti HTC-P2P Panel-to-Panel Connector";
    hwc.sManufacturer  = "Hilti";
    hwc.sCategory      = "Connector";

    // Assign to TslInst
    HardWrComp hwcs[] = _tsl.hardWrComps();
    hwcs.append(hwc);
    return hwcs;
}

// Application
int nNrHardware = ptsDis.length();  // Number of connectors
HardWrComp hwcs[] = prepareHardware(_ThisInst, nNrHardware, _GenBeam, mapType);
if (_bOnDbCreated) setExecutionLoops(2);  // Ensure BOM updates
_ThisInst.setHardWrComps(hwcs);
```

### BOM Output

When processed by hsbCAD BOM tools (`HSB_G-BillOfMaterial`, etc.), generates entries:

| Manufacturer | Category | Article | Quantity | Unit | Location |
|--------------|----------|---------|----------|------|----------|
| Hilti | Connector | HTC-P2P 90mm M12 | 15 | pcs | Element_001 |

**Quantity Calculation:**
- **Distribution Mode (100)**: `ptsDis.length()` - total connectors in distribution
- **Single Instance Mode (101)**: Always `1`
- Updates when:
  - Distribution parameters change (offsets, interdistance)
  - Grips moved in "Edit in Place" mode
  - Connection length changes due to GenBeam modifications

---

## Connection Detection Algorithm

### Overview

The core intelligence of the script lies in detecting valid connection zones between GenBeams. The algorithm handles various configurations:

- **Beam-to-Beam**: Side face to side face
- **Beam-to-Panel**: Beam end to panel face
- **Panel-to-Panel**: Panel edge to panel edge (primary use case)
- **Mixed Types**: Any combination of Beam, Sip, Sheet

### Connection Detection Process

```c
Map getConnection2Genbeams(GenBeam _gb0, GenBeam _gb1, double _dGapMax,
    Map _mAdditional)
{
    Map _mOut;

    // 1. Extract geometry
    Vector3d _vx  = _gb0.vecX();
    Vector3d _vy  = _gb0.vecY();
    Vector3d _vz  = _gb0.vecZ();
    Point3d _ptCen = _gb0.ptCen();
    Quader _qd0 = _gb0.quader();

    Vector3d _vx1  = _gb1.vecX();
    Vector3d _vy1  = _gb1.vecY();
    Vector3d _vz1  = _gb1.vecZ();
    Point3d _ptCen1 = _gb1.ptCen();
    Quader _qd1 = _gb1.quader();

    // 2. Check if preferred direction specified (for view-based modes)
    Vector3d _vPrefered;
    int _bPreferedVector = _mAdditional.hasVector3d("vPrefered");
    if (_bPreferedVector)
        _vPrefered = _mAdditional.getVector3d("vPrefered");

    // 3. Determine connection plane normal
    Vector3d _vPlane = _gb0.vecD(_ZW);  // Try Z direction first
    if (_bPreferedVector)
        _vPlane = _gb0.vecD(_vPrefered);

    Vector3d _vPlaneOther = _gb1.vecD(_vPlane);

    // 4. Check parallelism
    if (!_vPlane.isParallelTo(_vPlaneOther))
        return _mOut;  // Not parallel, no connection possible

    // 5. Check for intersection in connection plane (overlap test)
    PlaneProfile pp  = _gb0.envelopeBody().shadowProfile(Plane(_ptCen, _vPlane));
    PlaneProfile pp1 = _gb1.envelopeBody().shadowProfile(Plane(_ptCen, _vPlane));
    pp1.shrink(dEps);

    if (pp.intersectWith(pp1))
    {
        // Elements overlap in this direction - try perpendicular direction
        _vPlane = _vx.crossProduct(_vPlane);
        _vPlane.normalize();
        // Re-test...
    }

    // 6. Check gap distance
    Vector3d _v01 = _vDir.crossProduct(_vPlane);
    double _d12 = abs(_v01.dotProduct(_ptCen - _ptCen1));
    _d12 -= 0.5 * (_qd0.dD(_v01) + _qd1.dD(_v01));  // Subtract element thicknesses

    if (_d12 > _dGapMax)
        return _mOut;  // Gap too large (> 50mm)

    if (_d12 < -U(1))
    {
        // Elements overlap (beam head-to-head case)
        // Try alternate direction...
    }

    // 7. Calculate connection plane point
    Point3d _pt0 = _ptCen + _vPlane * 0.5 * _gb0.dD(_vPlane);
    Point3d _pt1 = _ptCen1 + _vPlane * 0.5 * _gb1.dD(_vPlane);
    Point3d _ptPlane = 0.5 * (_pt0 + _pt1);  // Midpoint between faces

    // 8. Determine connection direction and extent
    Plane pn(_ptPlane, _vPlane);
    PlaneProfile ppIntersect = calculateIntersectionArea(_gb0, _gb1, pn);
    LineSeg seg = ppIntersect.extentInDir(_vDir);
    Point3d ptL = seg.ptStart();
    Point3d ptR = seg.ptEnd();

    // 9. Store connection data
    _mOut.setPoint3d("ptPlane", _ptPlane);
    _mOut.setPoint3d("ptL", ptL);
    _mOut.setPoint3d("ptR", ptR);
    _mOut.setVector3d("vPlane", _vPlane);
    _mOut.setVector3d("vDir", _vDir);
    _mOut.setVector3d("v01", _v01);
    _mOut.setEntityArray("ents", {_gb0, _gb1});

    return _mOut;
}
```

### Multi-GenBeam Connection Discovery

```c
Map calcGenbeamConnections(GenBeam _genBeams[], double _dGapMax,
    Map _mAdditional)
{
    Map _mapConnections;

    // Test all pairs of GenBeams
    for (int i=0; i<_genBeams.length(); i++)
    {
        for (int j=i+1; j<_genBeams.length(); j++)
        {
            GenBeam gb0 = _genBeams[i];
            GenBeam gb1 = _genBeams[j];

            Map mapConn = getConnection2Genbeams(gb0, gb1, _dGapMax,
                _mAdditional);

            if (mapConn.length() > 0)  // Valid connection found
            {
                _mapConnections.appendMap("m", mapConn);
            }
        }
    }

    return _mapConnections;
}
```

### Connection Area Calculation

For complex geometries (panels with openings, irregular edges), the script calculates the **valid connection area** where connectors can be placed:

```c
PlaneProfile getConnectionArea(Entity _ents[], Plane _pn,
    Point3d _ptMid, Vector3d _vDir, Vector3d _vN, double _dOffset)
{
    PlaneProfile ppIntersectAll(_pn);

    // Extract contact faces from each GenBeam
    for (int e=0; e<_ents.length(); e++)
    {
        GenBeam gb = (GenBeam)_ents[e];
        PlaneProfile ppContact = gb.realBody().extractContactFaceInPlane(_pn, U(1));

        if (e == 0)
            ppIntersectAll = ppContact;
        else
            ppIntersectAll.intersectWith(ppContact);  // Boolean AND
    }

    // Shrink/grow to clean up small irregularities
    ppIntersectAll.shrink(-U(10));
    ppIntersectAll.shrink(U(10));

    return ppIntersectAll;
}
```

### Edge Exclusion Zones

When multiple GenBeams form a connection, the script creates **exclusion zones** around each GenBeam edge to prevent connectors too close to edges:

```c
// For each GenBeam in connection
for (int g=0; g<_GenBeam.length(); g++)
{
    GenBeam gb = _GenBeam[g];
    PlaneProfile ppg = gb.envelopeBody().extractContactFaceInPlane(pn, U(1));
    ppg.intersectWith(ppIntersectAll);

    PLine plsg[] = ppg.allRings(true, false);  // Get contours

    for (int i=0; i<plsg.length(); i++)
    {
        PlaneProfile ppi = PlaneProfile(plsg[i]);
        LineSeg lSegG = ppi.extentInDir(vDir);

        // Create exclusion zones at start and end of this GenBeam segment
        PlaneProfile ppRestricted(ppIntersectAll.coordSys());
        ppRestricted.createRectangle(
            LineSeg(lSegG.ptStart() - vDir*dOffsetTop - vN*U(10e3),
                    lSegG.ptStart() + vDir*dOffsetBottom + vN*U(10e2)),
            vN, vDir);
        ppRestrictedAll.unionWith(ppRestricted);

        // Same for end edge...
    }
}

// Subtract all exclusion zones from distribution region
ppRegion.subtractProfile(ppRestrictedAll);
```

**Result:** Connectors only placed in valid regions, respecting:
- Start/End offsets
- GenBeam edge distances
- Opening/cutout exclusions

---

## Distribution Calculation

### Fixed Distribution Algorithm

```c
Map calcDistribution(Point3d _ptStart, Point3d _ptEnd,
    double _dOffsetStart, double _dOffsetEnd, double _dOffsetBetween,
    double _dMinDistance, Vector3d _vDir, int _nMode)
{
    Map _mOut;
    Point3d ptsDis[0];

    // 1. Calculate available length
    Vector3d vecDis = _ptEnd - _ptStart;
    double dLength = _vDir.dotProduct(vecDis);

    // 2. Subtract offsets
    double dLengthAvailable = dLength - _dOffsetStart - _dOffsetEnd;

    // 3. Check minimum space
    if (dLengthAvailable < _dMinDistance)
    {
        _mOut.setInt("Error", 1);
        _mOut.setString("sError", "no distribution possible");
        return _mOut;
    }

    // 4. Calculate number of connectors
    int nConnectors = floor(dLengthAvailable / _dOffsetBetween) + 1;

    if (nConnectors < 1)
    {
        _mOut.setInt("Error", 1);
        return _mOut;
    }

    // 5. Mode-specific spacing calculation
    double dSpacing;

    if (_nMode == 0)  // Fixed Distribution
    {
        dSpacing = _dOffsetBetween;
    }
    else if (_nMode == 1)  // Even Distribution
    {
        if (nConnectors == 1)
            dSpacing = 0;
        else
            dSpacing = dLengthAvailable / (nConnectors - 1);
    }

    // 6. Generate connector points
    Point3d ptStart = _ptStart + _vDir * _dOffsetStart;

    for (int i=0; i<nConnectors; i++)
    {
        Point3d ptDis = ptStart + _vDir * (i * dSpacing);
        ptsDis.append(ptDis);
    }

    // 7. Return results
    _mOut.setPoint3dArray("ptsDis", ptsDis);
    _mOut.setDouble("dDistanceBetweenResult", dSpacing);
    _mOut.setInt("nNrResult", nConnectors);
    _mOut.setInt("Error", 0);

    return _mOut;
}
```

### Multi-Region Distribution

When connection is **interrupted** (e.g., by GenBeam edges or openings), the script handles **multiple distribution regions**:

```c
// Split connection area into separate regions
PLine plRegions[] = ppRegion.allRings(true, false);
PlaneProfile ppRegions[0];
for (int i=0; i<plRegions.length(); i++)
{
    ppRegions.append(PlaneProfile(plRegions[i]));
}

// Distribute connectors in each region independently
Point3d ptStartDiss[0], ptEndDiss[0];
for (int i=0; i<ppRegions.length(); i++)
{
    PlaneProfile ppRegioni = ppRegions[i];
    Plane pnN(ptPlaneMid, vN);

    // Find start and end points of this region
    Point3d ptsInteri[] = ppRegioni.intersectPoints(pnN, true, false);
    ptsInteri = Line(ptPlaneMid, vDir).orderPoints(ptsInteri);

    if (ptsInteri.length() == 2)
    {
        ptStartDiss.append(ptsInteri.first());
        ptEndDiss.append(ptsInteri.last());
    }
}

// Calculate distribution for each region
for (int i=0; i<ptStartDiss.length(); i++)
{
    Map mDistributioni = calcDistribution(ptStartDiss[i], ptEndDiss[i],
        0, 0, dOffsetBetween, U(0), vDir, nDistributionMode);

    if (!mDistributioni.getInt("Error"))
    {
        Point3d ptsDisi[] = mDistributioni.getPoint3dArray("ptsDis");
        ptsDis.append(ptsDisi);  // Accumulate all connector points
    }
}
```

**Result:**
- `Nr. parts` = total connectors across all regions
- `Real Interdistance` = -1 (indicates multiple regions)

---

## Error Messages and Troubleshooting

### Common Error Messages

#### "No possible connection found"
**When:** During insertion, after GenBeam selection

**Causes:**
1. Selected elements do not have parallel adjacent faces
2. Gap between elements exceeds 50mm
3. No overlapping area in connection direction
4. Elements too far apart

**Solutions:**
- Verify elements are properly positioned
- Check gap with dimension tool
- Ensure elements share a common edge/face
- Try selecting different elements

#### "At least 2 Genbeams needed"
**When:** During insertion or recalculation

**Cause:** Fewer than 2 GenBeams selected or linked

**Solution:** Select at least 2 GenBeams during insertion prompt

#### "Interdistance must be >= 300mm"
**When:** Changing Interdistance property

**Cause:** User attempted to set Interdistance < 300mm

**Solution:** Script auto-corrects to 300mm; adjust to acceptable value (≥300mm)

#### "no distribution possible. Try to change the distribution parameters"
**When:** After GenBeam selection, during distribution calculation

**Causes:**
1. Start Offset + End Offset ≥ connection length
2. Connection length too short for even one connector
3. Available length < minimum connector spacing

**Solutions:**
- Reduce Start Offset and/or End Offset
- Increase connection length (extend panels)
- Reduce Interdistance value
- Check connection area isn't fully excluded by edge zones

#### "Tool will be deleted"
**When:** During recalculation

**Causes:**
1. Underlying GenBeams were moved/modified
2. Connection no longer valid at original location
3. Gap became > 50mm
4. GenBeams deleted or faces changed

**Solution:**
- Review GenBeam modifications
- Delete orphaned connector instances
- Re-insert connector at new valid location

#### "Swapping not possible"
**When:** Using "Swap Direction" context menu

**Causes:**
1. No valid connection exists on opposite face
2. Geometry has changed since original placement
3. Only one-sided connection possible (e.g., edge condition)

**Solution:**
- Verify opposite face is accessible and unobstructed
- Check that GenBeams still form valid connection geometry
- May need to delete and re-insert if geometry significantly changed

#### "Start Offset must be >= 250mm" / "End Offset must be >= 250mm"
**When:** (Warning only - not enforced in current version)

**Note:** While the script suggests ≥ 250mm for structural safety, it does not enforce this limit. Users are responsible for meeting structural requirements.

---

## Advanced Usage Scenarios

### Scenario 1: CLT Wall-to-Floor Connection

**Objective:** Connect vertical CLT wall panel to horizontal CLT floor panel

**Setup:**
1. Two CLT panels perpendicular to each other
2. Common edge where wall sits on floor
3. Need connectors every 600mm along wall length

**Procedure:**
1. **Select Panels:**
   - Launch Hilti-P2P
   - Set Insertion Mode = "All"
   - Set Rule = "Even Distribution"
   - Set Interdistance = 600mm
   - Start Offset = 300mm, End Offset = 300mm
   - Click OK
   - Select wall panel, then floor panel
   - Press Enter

2. **Result:**
   - Script automatically detects connection along bottom edge of wall
   - Distributes connectors evenly at ~600mm spacing
   - Applies tooling to both panels:
     - Male profile into wall panel
     - Female profile into floor panel
   - Generates BOM entry with total connector count

### Scenario 2: SIP Panel Array with Openings

**Objective:** Connect multiple SIP panels forming a wall with window openings

**Setup:**
1. Four SIP panels in a row
2. Two window openings interrupt the joints
3. Need maximum 1000mm spacing, but avoid openings

**Procedure:**
1. **Select Panels:**
   - Launch Hilti-P2P
   - Insertion Mode = "All"
   - Rule = "Fixed Distribution"
   - Interdistance = 1000mm
   - Start Offset = 350mm, End Offset = 350mm
   - Select all four panels
   - Press Enter

2. **Automatic Handling:**
   - Script detects three connections (between panels 1-2, 2-3, 3-4)
   - For each connection:
     - Calculates valid area excluding window openings
     - Creates multiple distribution regions around openings
     - Places connectors respecting 350mm edge distance
   - Total connectors distributed across all valid regions

3. **Result:**
   - Nr. parts = 45 (example - varies by geometry)
   - Real Interdistance = -1 (multiple regions)
   - Connectors placed optimally around openings

### Scenario 3: Interactive Placement with Grips

**Objective:** Fine-tune connector distribution after initial placement

**Procedure:**
1. **Initial Placement:**
   - Use "Select" mode with default offsets
   - Place connectors on connection

2. **Enable Grip Editing:**
   - Right-click on placed connector instance
   - Select "Edit in Place"
   - Two triangular grips appear at start and end

3. **Adjust Distribution:**
   - **Move Start Grip** inward → increases Start Offset, removes first connector(s)
   - **Move Start Grip** outward → decreases Start Offset, may add connector
   - **Move End Grip** similarly affects End Offset
   - Connectors update in real-time as you drag

4. **Finalize:**
   - When satisfied, right-click → "Disable Edit in Place"
   - Distribution locked to current configuration

### Scenario 4: Explode for Custom Spacing

**Objective:** Create irregular spacing around structural load point

**Procedure:**
1. **Initial Distribution:**
   - Place connectors with "Even Distribution" for regular spacing
   - Result: 10 connectors at 800mm spacing

2. **Explode:**
   - Right-click → "Explode distribution"
   - Original instance deleted
   - 10 new single-instance connectors created

3. **Custom Adjustment:**
   - Select connector near load point
   - Move using grip to closer spacing (e.g., 400mm)
   - Delete unnecessary connectors
   - Result: Tighter spacing where needed, regular elsewhere

### Scenario 5: View-Based Batch Placement

**Objective:** Quickly apply connectors to one side of a complex 3D panel assembly

**Setup:**
1. Complex CLT building with panels at various angles
2. Need connectors on south-facing connections only
3. Don't want to individually select each connection

**Procedure:**
1. **Orient View:**
   - Set view looking at south face of building (view direction = north)
   - Use standard AutoCAD view commands

2. **Launch Script:**
   - Insertion Mode = "View direction"
   - Set distribution parameters
   - Select all relevant panels (can select entire building)
   - Press Enter

3. **Result:**
   - Script filters connections to only those facing the current view
   - Automatically places connectors on all south-facing connections
   - Ignores north, east, west facing connections

4. **Repeat for Other Sides:**
   - Change view to east, west, north
   - Repeat process for each direction

---

## Technical Implementation Details

### Script Lifecycle

```
Insertion Phase (_bOnInsert = true)
   ↓
1. Check insert cycle count
   If > 1 → eraseInstance(), return
   ↓
2. Load settings from XML
   MapObject or readFromXmlFile()
   ↓
3. Show properties dialog
   showDialog() or setPropValuesFromCatalog()
   ↓
4. Prompt for GenBeam selection
   PrEntity ssE("Select genbeams", GenBeam())
   ↓
5. Calculate all connections
   calcGenbeamConnections()
   ↓
6. Mode-specific placement
   ├─ Select/Single: Jigging with goJig()
   ├─ All: Automatic placement
   └─ View direction: Filtered by view
   ↓
7. Create instances with dbCreate()
   ↓
8. Return (insertion complete)

Recalculation Phase (_bOnRecalc = false, _bOnInsert = false)
   ↓
1. Detect mode from _Map
   Mode 100: Distribution
   Mode 101: Single instance
   ↓
2. Validate GenBeams still exist
   ↓
3. Recalculate connection
   findConnection() or calcGenbeamConnections()
   ↓
4. Calculate distribution
   calcDistribution() with current parameters
   ↓
5. Generate geometry
   ├─ drawSymbol()
   ├─ doTooling()
   └─ prepareHardware()
   ↓
6. Update display and BOM
   setHardWrComps()
```

### Map Data Structure

The script uses **Map** extensively to pass connection data:

```c
// Connection Map (mapConnection)
{
    "ptPlane": Point3d,      // Reference point on connection plane
    "ptL": Point3d,          // Left extent of connection
    "ptR": Point3d,          // Right extent of connection
    "vPlane": Vector3d,      // Connection plane normal
    "vDir": Vector3d,        // Connection direction (along edge)
    "v01": Vector3d,         // Perpendicular direction (between elements)
    "ents": Entity[],        // GenBeams forming this connection
    "pp": PlaneProfile,      // Valid connection area (2D)
    "pp200": PlaneProfile,   // Connection area offset by 200mm (for jigging)
    "ptsEdges": Point3d[],   // Edge points (for similar connection detection)
    "Type": String           // Connection type identifier
}

// Type Map (mapType)
{
    "Type": String,          // "HTC-P2P 90mm M12"
    "Height": double,        // 78.2mm
    "Depth": double,         // 70mm
    "Color": int,            // 30
    "ColorText": int,        // 5
    "plMale": PLine,         // Male connector profile
    "plFemale": PLine,       // Female connector profile
    "Tool": PLine,           // Full tool outline
    "ToolSide": PLine,       // Tool side profile
    "ToolHalf": PLine        // Half tool profile
}

// Additional Map (mAdditional)
{
    "vPrefered": Vector3d,   // Preferred direction for view-based modes
    "bOnlyPanelFaces": int   // Flag for panel face filtering
}
```

### Coordinate Systems

**World Coordinate System (WCS):**
```c
_XW, _YW, _ZW  // Global axes
_PtW           // World origin
```

**Connection Local Coordinate System:**
```c
Point3d ptPlane;     // Origin
Vector3d vDir;       // X-axis (along connection)
Vector3d vN;         // Y-axis (perpendicular to connection)
Vector3d vPlane;     // Z-axis (normal to connection plane)
```

**Transformation Example:**
```c
// Transform connector body from WCS to connection coordinates
Body bd = getMalePart(mapType);  // Body at world origin, oriented to WCS
bd.transformBy(ptPlane, vDir, vN, vPlane);  // Reorient to connection
bd.transformBy(v01 * halfGap);   // Offset to panel face
```

### Performance Optimization

The script uses several techniques for performance:

1. **envelopeBody() vs realBody():**
   ```c
   // Use envelope for fast intersection tests
   PlaneProfile pp = _gb.envelopeBody().shadowProfile(plane);

   // Use realBody only for accurate contact extraction
   PlaneProfile ppContact = _gb.realBody().extractContactFaceInPlane(plane, U(1));
   ```

2. **Execution Loops:**
   ```c
   if (_bOnDbCreated) setExecutionLoops(2);
   ```
   Ensures BOM and geometry update properly on creation

3. **Jigging Optimization:**
   - Pre-calculates connection areas (`pp200`) with 200mm offset for faster hover detection
   - Uses `lightblue` transparent fill for minimal rendering overhead

4. **MapObject Caching:**
   ```c
   MapObject mo(sDictionary, sFileName);
   if (mo.bIsValid())
       mapSetting = mo.map();  // Fast - from memory
   else
       mapSetting.readFromXmlFile(sFile);  // Slower - from disk
   ```

---

## Comparison with Related Scripts

### vs. Generic Angle Brackets (GA.mcr)

| Feature | Hilti-P2P | GA.mcr |
|---------|-----------|--------|
| **Connection Type** | Panel-to-panel (flush) | Angle bracket (perpendicular) |
| **Geometry** | Interlocking male/female | External metal bracket |
| **Tooling** | Internal milling (FreeProfile) | External attachment |
| **Typical Use** | CLT/SIP edge-to-edge | Beam-to-beam corners |
| **Distribution** | Linear along edge | Usually single placement |
| **Manufacturer** | Hilti (specific product) | Generic (configurable) |

### vs. Other Hilti Scripts

| Script | Purpose | Comparison to Hilti-P2P |
|--------|---------|-------------------------|
| **Hilti-Verankerung** | Floor/wall anchoring | Vertical connections; Hilti-P2P is horizontal |
| **Hilti-Einzeln** | Single point fastener | Individual fastener; Hilti-P2P is distributed system |
| **Hilti-Decke** | Ceiling connections | Specialized for ceiling; Hilti-P2P is general panel |
| **Hilti-Stockschraube** | Threaded rod connection | Different fastener type |

### vs. Simpson StrongTie Connectors

| Aspect | Hilti-P2P | Simpson Connectors |
|--------|-----------|-------------------|
| **Manufacturer** | Hilti | Simpson StrongTie |
| **Product Line** | HTC-P2P system | Various (hangers, anchors, straps) |
| **Installation** | Concealed (inside panel) | Mostly exposed (surface-mounted) |
| **Aesthetics** | Hidden connection | Visible metal |
| **Load Transfer** | Shear in panel plane | Varies by product |

---

## Customization and Extension

### Adding New Connector Types

To add a custom HTC-P2P variant to the XML settings:

1. **Open Settings File:**
   `[Install Path]\Content\General\TSL\Settings\Hilti-P2P.xml`

2. **Add New Type Element:**
```xml
<lst nm="Type[]">
  <!-- Existing types... -->

  <lst nm="Element">
    <str nm="Type" vl="HTC-P2P 120mm M16"/>
    <dbl nm="Height" ut="L" vl="100.0"/>
    <dbl nm="Depth" ut="L" vl="85.0"/>
    <int nm="Color" vl="40"/>
    <int nm="ColorText" vl="6"/>

    <!-- Define male profile -->
    <pl nm="plMale">
      <dbl_pt x="-50.0" y="-80.0" z="0.0"/>
      <dbl_pt x="-25.0" y="-20.0" z="0.0"/>
      <!-- ... more vertices ... -->
      <bl vl="true"/>  <!-- Closed polyline -->
    </pl>

    <!-- Define female profile -->
    <pl nm="plFemale">
      <dbl_pt x="-10.0" y="35.0" z="0.0"/>
      <!-- ... vertices ... -->
      <bl vl="true"/>
    </pl>

    <!-- Define tooling profiles -->
    <pl nm="Tool"><!-- Full outline --></pl>
    <pl nm="ToolSide"><!-- One side --></pl>
    <pl nm="ToolHalf"><!-- Half profile --></pl>
  </lst>
</lst>
```

3. **Increment Version:**
```xml
<lst nm="GeneralMapObject">
  <int nm="Version" vl="2"/>  <!-- Increment from 1 to 2 -->
</lst>
```

4. **Save and Reload:**
   - Save XML file
   - In AutoCAD, delete MapObject: `(hsb_DeleteMapObject "hsbTSL" "Hilti-P2P")`
   - Re-insert script - new type appears in dropdown

### Modifying Distribution Behavior

To change minimum spacing constraint:

**In Script (requires recompilation):**
```c
// Line ~141
double dEconnMin = U(300);  // Change to U(250) for 250mm minimum
```

**Or Create Wrapper Script:**
```c
// Custom script that calls Hilti-P2P with modified constraints
#Version 8
#Type T
#BeginContents

// Set custom minimum spacing
double dCustomMin = U(250);

// Call main script
TslInst tsl;
tsl.dbCreate("Hilti-P2P", ...);

// Override interdistance if needed
// (Access via properties after creation)
#End
```

### Integration with Custom Workflows

**Example: Automatic Placement on Element Creation**

```c
// In wall/floor element script
#BeginContents

// Create wall element
Element elem = createWallElement(...);

// Auto-apply Hilti-P2P connectors
GenBeam beams[] = elem.genBeams();
TslInst connTsl;
Map mapTsl;
mapTsl.setInt("Mode", 100);  // Distribution mode
mapTsl.setString("InsertionMode", "All");

Point3d pts[] = {_Pt0};
int nProps[] = {};
double dProps[] = {U(350), U(350), U(1000)};  // Offsets, interdistance
String sProps[] = {"All", "Fixed Distribution", "No", "HTC-P2P 90mm M12"};

connTsl.dbCreate("Hilti-P2P", _XW, _YW, beams, {}, pts,
    nProps, dProps, sProps, _kModelSpace, mapTsl);

#End
```

---

## Frequently Asked Questions

### General Questions

**Q: What does "P2P" stand for?**

A: Panel-to-Panel. The HTC-P2P system is specifically designed for connecting the edges of timber panels (CLT, SIPs, etc.) in a flush, edge-to-edge configuration.

---

**Q: Can I use this script for beam-to-beam connections?**

A: Yes, the script works with any GenBeam type. However, the HTC-P2P connector is optimized for panel connections. For beam-to-beam connections, consider:
- Generic angle brackets (GA.mcr)
- Simpson StrongTie hangers
- Rothoblaas beam connectors

---

**Q: Why does the script require at least 2 GenBeams?**

A: The connector physically joins two elements, so it needs both elements to:
- Calculate the connection geometry
- Apply tooling to both sides (male to one, female to other)
- Generate proper BOM quantities

---

**Q: What's the difference between "Select" and "Single instance" modes?**

A:
- **Select**: Distributes multiple connectors along the full connection length when you click
- **Single instance**: Places only one connector at the exact cursor position when you click
- Both offer interactive selection with jigging, but "Select" creates a distribution, "Single instance" creates individual connectors

---

### Technical Questions

**Q: How does the script handle panels with openings (windows, doors)?**

A: The script uses **PlaneProfile Boolean operations**:
1. Extracts contact face from each GenBeam using `extractContactFaceInPlane()`
2. Creates intersection of all contact faces
3. Automatically excludes opening areas (they're not part of the solid body)
4. Creates multiple distribution regions around openings
5. Distributes connectors in each valid region independently

Result: Connectors automatically avoid openings without manual intervention.

---

**Q: Why is my "Real Interdistance" showing -1?**

A: This indicates **multiple distribution regions** exist for the connection. This happens when:
- Connection is interrupted by GenBeam edges (multiple panels meeting at one joint)
- Openings split the connection into separate segments
- Complex geometry creates non-contiguous valid areas

Each region has its own spacing, so a single "Real Interdistance" value isn't meaningful. Total `Nr. parts` shows combined connector count across all regions.

---

**Q: Can I change the connector geometry (male/female shapes)?**

A: Yes, by editing the XML settings file:
1. Open `Hilti-P2P.xml`
2. Modify `<pl nm="plMale">` and `<pl nm="plFemale">` polyline vertices
3. Vertices are in **millimeters** in world coordinates (origin-based)
4. Must maintain symmetric profile (male and female interlock)
5. Also update `<pl nm="Tool">`, `<pl nm="ToolSide">`, `<pl nm="ToolHalf">` for tooling

**Warning:** Modified geometry may not match actual Hilti products - for reference only.

---

**Q: How does "Even Distribution" differ from "Fixed Distribution" mathematically?**

A:

**Fixed Distribution:**
```
Length = Connection length - Start Offset - End Offset
nConnectors = floor(Length / Interdistance) + 1
Actual spacing = Interdistance (constant)
Last segment may be shorter
```

**Even Distribution:**
```
Length = Connection length - Start Offset - End Offset
nConnectors = floor(Length / Interdistance) + 1  (same calculation)
Actual spacing = Length / (nConnectors - 1)  (optimized to fill space)
All segments equal
```

Both calculate the same **number** of connectors, but "Even" adjusts spacing to fill the length perfectly.

---

**Q: Why does the script use `envelopeBody()` instead of `realBody()` in some places?**

A: **Performance optimization:**
- `envelopeBody()`: Fast, simplified bounding box representation
- `realBody()`: Accurate geometry including all details

**Usage strategy:**
- Fast intersection tests → `envelopeBody()`
- Accurate contact extraction → `realBody()`
- Display geometry → Depends on `bShowTooling` setting

For a 100-panel assembly, using `envelopeBody()` for initial filtering can reduce calculation time from minutes to seconds.

---

**Q: What happens if I move a GenBeam after placing connectors?**

A: The script **automatically recalculates**:
1. Detects GenBeam movement via dependency tracking
2. Re-evaluates connection at new location
3. If connection still valid → updates connector positions
4. If connection invalid → displays `"Tool will be deleted"` error

**To update manually:** Select connector, right-click → Properties → change any value → OK (forces recalc)

---

**Q: Can I script the insertion to avoid the dialog?**

A: Yes, use **catalog-based insertion**:

1. **Create catalog preset** (one-time setup):
   ```
   In AutoCAD, insert Hilti-P2P normally, configure all parameters
   Right-click instance → Save to Catalog → Name: "MyPreset"
   ```

2. **Call with preset**:
   ```c
   (hsb_ScriptInsert "Hilti-P2P" "MyPreset")
   ```

Or programmatically:
```c
TslInst tsl;
Map mapTsl;
mapTsl.setInt("Mode", 100);

Point3d pts[] = {_Pt0};
int nProps[] = {};
double dProps[] = {U(350), U(350), U(1000)};
String sProps[] = {"All", "Fixed Distribution", "No", "HTC-P2P 90mm M12"};

tsl.dbCreate("Hilti-P2P", _XW, _YW, genBeamArray, {}, pts,
    nProps, dProps, sProps, _kModelSpace, mapTsl);
```

---

### Troubleshooting Questions

**Q: Script says "No possible connection found" but elements are clearly adjacent. Why?**

A: Check these common issues:

1. **Gap too large:** Measure actual gap - must be ≤ 50mm
2. **Faces not parallel:** Even slight angles prevent connection detection
   - Use AutoCAD `LIST` command on both GenBeams
   - Compare Z vectors (vecZ) - must be parallel
3. **No overlapping area:** Elements may be adjacent but not overlapping in connection direction
   - Top view: Do elements share common edge?
4. **Wrong face selected:** For panels, connection must be on edge, not top/bottom face

**Debug method:**
```c
// Temporarily enable debug mode
int bDebug = 1;  // Add to script temporarily
// This activates .vis() visualization commands
// Connection vectors and points become visible
```

---

**Q: Distribution creates too few connectors. How can I get more?**

A: Possible causes and solutions:

1. **Interdistance too large:**
   - Reduce Interdistance value (e.g., from 1000mm to 600mm)

2. **Offsets too large:**
   - Start Offset + End Offset consuming most of connection length
   - Reduce offsets (minimum safe: 250mm)

3. **Connection length shorter than expected:**
   - Measure actual connection length
   - `nConnectors = floor((Length - OffsetStart - OffsetEnd) / Interdistance) + 1`

4. **Multiple regions hiding actual distribution:**
   - `Nr. parts` shows total count (may be more than visible in one region)
   - Check both sides of openings

**Example calculation:**
```
Connection length: 3000mm
Start Offset: 350mm
End Offset: 350mm
Interdistance: 1000mm

Available length: 3000 - 350 - 350 = 2300mm
nConnectors: floor(2300 / 1000) + 1 = 3 connectors
Spacing (Even mode): 2300 / 2 = 1150mm
```

---

**Q: How do I export connector locations for CNC programming?**

A: The script generates **FreeProfile** tooling entities on GenBeams. To export:

**Method 1: Direct CNC Export (if supported)**
```
Use hsbCAD CNC export tools:
HSB_G-CNC → Select GenBeam → Export
FreeProfile geometry included automatically
```

**Method 2: Extract Points Programmatically**
```c
// Custom export script
TslInst connInst;  // Your Hilti-P2P instance
Map mapConn = connInst._Map.getMap("mapConnection");
Point3d pts[] = /* get connector distribution points */;

// Write to CSV
String sOutput = "X,Y,Z,Type\n";
for (int i=0; i<pts.length(); i++)
{
    Point3d pt = pts[i];
    sOutput += pt.x() + "," + pt.y() + "," + pt.z() + ",HTC-P2P\n";
}
writeStringToFile(sOutput, "C:\\Temp\\connectors.csv");
```

**Method 3: Visual Verification**
- Set "Show tooling" = "Yes"
- Use AutoCAD `MASSPROP` or `LIST` on visible FreeProfile entities

---

**Q: Can I use custom spacing (not regular distribution)?**

A: Yes, two methods:

**Method 1: Explode and manually adjust**
1. Place with regular distribution
2. Right-click → "Explode distribution"
3. Move individual connector instances to desired positions

**Method 2: Place individual connectors**
1. Use "Single instance" insertion mode
2. Click at each desired location
3. Repeat until all connectors placed

**Method 3: Script-based custom pattern**
```c
// Create custom distribution in your own script
Point3d customPts[] = {
    _Pt0 + _XW*U(300),
    _Pt0 + _XW*U(800),
    _Pt0 + _XW*U(1200),  // Irregular spacing
    _Pt0 + _XW*U(2500)
};

for (int i=0; i<customPts.length(); i++)
{
    TslInst tsl;
    Map mapTsl;
    mapTsl.setInt("mode", 101);  // Single instance mode
    // ... create instance at customPts[i] ...
}
```

---

## Related Scripts and Workflows

### Complementary Scripts

These scripts work well in combination with Hilti-P2P:

| Script | Purpose | Typical Sequence |
|--------|---------|------------------|
| **hsbCLT-Opening** | Create openings in CLT panels | 1. Create openings → 2. Apply Hilti-P2P (auto-avoids openings) |
| **hsbCLT-LevelMarker** | Mark panel assembly levels | 1. Apply connectors → 2. Add level markers for fabrication |
| **hsbCLT-Lift** | Define lifting points | 1. Apply connectors → 2. Calculate lifting based on BOM weight |
| **HSB_G-BillOfMaterial** | Generate hardware BOM | 1. Apply connectors → 2. Extract BOM with HSB_G-BillOfMaterial |
| **HSB_E-ElementTable** | Create element tables | 1. Complete connections → 2. Generate tables with hardware counts |
| **hsbCNC** | CNC export for machining | 1. Apply connectors (creates FreeProfiles) → 2. Export with hsbCNC |

### Typical Workflow Integration

**CLT Building Assembly Workflow:**
```
1. Create CLT panels (hsbCLT-MasterPanelManager)
   ↓
2. Add openings (hsbCLT-Opening)
   ↓
3. Position panels in assembly
   ↓
4. Apply Hilti-P2P connectors ← This script
   ↓
5. Add other hardware (anchors, hangers)
   ↓
6. Generate BOM (HSB_G-BillOfMaterial)
   ↓
7. Create shop drawings (sd_* scripts)
   ↓
8. Export CNC (hsbCNC)
```

**SIP Panel Wall Workflow:**
```
1. Create SIP wall element
   ↓
2. Distribute panels with openings
   ↓
3. Apply Hilti-P2P at panel joints ← This script
   ↓
4. Add perimeter fasteners (Nail-* scripts)
   ↓
5. Apply wall anchoring (Hilti-Verankerung)
   ↓
6. Generate element BOM
   ↓
7. Create layout drawings
```

---

## Performance and Optimization Tips

### Large Assemblies (>50 panels)

1. **Use "All" mode for batch operations**
   - Faster than interactive "Select" mode
   - Processes all connections in one pass

2. **Disable "Show tooling" during design**
   - Enable only for final verification
   - Reduces regeneration time significantly

3. **Work in sections**
   - Freeze distant layers during connector placement
   - Reduces visual complexity

4. **Use Layer States**
   - Create layer state with only active elements visible
   - Speeds up jigging and selection

### Memory Management

**For assemblies with 100+ connector instances:**

1. **Purge regularly**
   ```
   Command: PURGE
   Select: All
   ```

2. **Use `envelopeBody()` for checks**
   - Script already optimized, but custom extensions should follow this pattern

3. **Delete temporary construction geometry**
   - Script automatically cleans up, but verify no orphaned entities

### Regeneration Speed

**If script feels slow on recalculation:**

1. **Check GenBeam complexity**
   - Highly detailed GenBeams (many faces, openings) slow extraction
   - Simplify geometry where possible

2. **Reduce distribution resolution**
   - Increase Interdistance to place fewer connectors
   - 600mm vs 1000mm: ~40% fewer calculations

3. **Avoid excessive "Edit in Place" sessions**
   - Each grip drag triggers full recalculation
   - Plan adjustments, then make changes

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| **1.10** | Nov 13, 2025 | Optimized calculation performance (HSB-24302) | Marsel Nakuci |
| **1.9** | Nov 13, 2025 | Fixed swap direction in single instance mode (HSB-24302) | Marsel Nakuci |
| **1.8** | Nov 13, 2025 | Added Type property; extended XML to support different connector types (HSB-24850) | Marsel Nakuci |
| **1.7** | Jul 3, 2025 | Improved face normal calculation for panels with openings - includes all points (HSB-24270) | Marsel Nakuci |
| **1.6** | Apr 29, 2025 | Added check when swapping not possible (error message) | Marsel Nakuci |
| **1.5** | Apr 24, 2025 | Error handling for tool profile description retrieval | Marsel Nakuci |
| **1.4** | Mar 28, 2025 | Improved face outer normal detection; ignore small area faces (HSB-23391) | Marsel Nakuci |
| **1.3** | Mar 27, 2025 | Implemented distribution for multiple regions (around openings/edges) (HSB-23391) | Marsel Nakuci |
| **1.2** | Mar 27, 2025 | Fixed plane normal calculation for panels with openings (HSB-23391) | Marsel Nakuci |
| **1.1** | Mar 24, 2025 | Fixed view direction connection detection - exclude normal-facing connections (HSB-23391) | Marsel Nakuci |
| **1.0** | Mar 21, 2025 | Initial release (HSB-23391) | Marsel Nakuci |
| 0.80 | Mar 14, 2025 | Added "Select" insertion mode with jigging | Marsel Nakuci |
| 0.70 | Mar 14, 2025 | New routine for capturing connection couples | Marsel Nakuci |
| 0.60 | Mar 13, 2025 | FreeProfile applied separately to each GenBeam (half-profile split) | Marsel Nakuci |
| 0.50 | Mar 13, 2025 | Improved display; added TSL image; added "Swap side"; added "Remove genbeams" | Marsel Nakuci |
| 0.40 | Mar 6, 2025 | Added command to add GenBeams in distribution mode | Marsel Nakuci |
| 0.30 | Feb 28, 2025 | Added grips to control distribution | Marsel Nakuci |
| 0.20 | Feb 28, 2025 | Consider beam head with panel connections | Marsel Nakuci |

### Recent Improvements Summary

**Version 1.10 (Current):**
- Performance optimization for large assemblies
- Faster connection detection algorithm
- Improved memory management

**Version 1.8 (Major Feature):**
- Dynamic connector type system
- XML-based type definitions
- Multiple connector models supported
- Future-proof for new Hilti products

**Version 1.7 (Accuracy):**
- Better handling of complex panel geometries
- Accurate normal calculation for panels with multiple openings
- Improved face detection on non-rectangular panels

**Version 1.3 (Multiple Regions):**
- Breakthrough feature for real-world assemblies
- Automatically handles interrupted connections
- Distributes around openings without manual intervention

---

## Support and Resources

### Hilti Product Information

- **Product:** Hilti HTC-P2P Panel-to-Panel Connector
- **Manufacturer:** Hilti Corporation
- **Product Line:** Timber Construction Systems
- **Technical Documentation:** [Hilti Website](https://www.hilti.com) → Timber Construction

**Typical Specifications:**
- **HTC-P2P 90mm M12:** Load capacity ~10 kN (verify with current Hilti specs)
- **HTC-P2P 60mm M12:** Load capacity ~7 kN (verify with current Hilti specs)
- **Materials:** Steel connector, galvanized finish
- **Installation:** Concealed within panel edges

### hsbCAD Documentation

- **TSL Language Reference:** `CLAUDE.md` in this repository
- **PRD Documentation System:** `PRD-TSL-UserGuide-Generation-System.md`
- **Hardware Scripts:** See `Hardware/` category in TSL classification

### Training and Examples

**Example Files:**
- `TSL/DialogExample.mcr` - Dialog UI patterns
- `TSL/GA.mcr` - Complex hardware connector example (similar structure)
- `TSL/Settings/Hilti-P2P.xml` - Connector type definitions

**Learning Path:**
1. Start with simple "All" mode on two-panel connection
2. Practice "Select" mode with interactive placement
3. Explore "Edit in Place" grip editing
4. Try "Explode distribution" for custom spacing
5. Advanced: Edit XML to add custom connector types

---

## Conclusion

The **Hilti-P2P** script represents a sophisticated connection automation system for modern timber construction. By intelligently detecting valid connection zones, calculating optimal distributions, generating precision tooling, and integrating with BOM workflows, it significantly accelerates the design and fabrication of CLT, SIP, and timber frame assemblies.

**Key Strengths:**
- **Automatic connection detection** across all GenBeam types
- **Flexible insertion modes** for various workflow requirements
- **Intelligent distribution** with multi-region support (handles openings automatically)
- **Integrated CNC tooling** via FreeProfile generation
- **Hardware BOM integration** for material takeoff
- **Extensible type system** via XML configuration

**Best Use Cases:**
- CLT building assemblies with panel-to-panel connections
- SIP wall systems requiring regular edge fastening
- Hybrid timber structures mixing beams and panels
- Prefabricated modules with standardized connection details

**When to Use Alternatives:**
- **Angle connections** → Use GA.mcr or Simpson bracket scripts
- **Vertical anchoring** → Use Hilti-Verankerung
- **Beam hangers** → Use Simpson StrongTie or BMF hanger scripts
- **Nailed connections** → Use Nail-* scripts

---

**Script Location:** `TSL/Hilti-P2P.mcr`
**Settings Location:** `TSL/Settings/Hilti-P2P.xml`
**Documentation Version:** 1.0 (Generated for TSL v1.10)
**Last Updated:** 2026-02-20
