# hsbFixingScrews

## Overview and Purpose

**hsbFixingScrews** is an advanced screw and fastener distribution tool designed to automate the placement of fixing screws along timber members in both individual beams and wall elements. This script reads from an XML-based screw catalog (supporting manufacturers like Würth, Spax, and others), allows users to select specific products through an interactive step-by-step dialog, and distributes screws along user-defined paths with precise control over spacing and positioning.

The script operates in two distinct modes:
1. **Single Beam Mode**: Interactive graphical placement with real-time jig preview and on-screen parameter controls
2. **Wall Element Mode**: Automatic distribution along wall plates with intelligent window exclusion and opening-specific nailing patterns

Beyond visual representation, the tool automatically generates Bill of Material (BOM) entries for hardware tracking and can apply actual drill tooling operations to the host beams for CNC machining integration.

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object - Independent Entity) |
| **Workspace** | Model Space |
| **Required Beams** | 0 (beams selected during insertion) |
| **Implicit Insert** | Yes |
| **DXA Output** | Enabled (shop drawing visibility) |
| **Current Version** | 1.9 (May 10, 2023) |
| **Initial Release** | 1.0 (April 29, 2021) |
| **Author** | Marsel Nakuci (hsbCAD Development Team) |

## Prerequisites

### System Requirements
- **hsbCAD** installation with TSL scripting support enabled
- AutoCAD platform (underlying CAD system)
- Access to the ScrewCatalog.xml settings file

### Settings File Location
The script searches for `ScrewCatalog.xml` in the following order:
1. **Company Path** (Priority): `[CompanyPath]\TSL\Settings\ScrewCatalog.xml`
2. **Installation Path** (Fallback): `[InstallPath]\Content\General\TSL\Settings\ScrewCatalog.xml`

If no valid catalog is found, or if no manufacturers are defined in the catalog, the script will display an error message and automatically delete itself.

### Target Geometry
The script can be applied to:
- **Individual timber members**: GenBeam, Sheet, or Panel entities
- **Wall elements**: ElementWall or ElementWallSF (Stick Frame walls)

## Usage Instructions

### Step 1: Launch and Selection

1. **Invoke the script** via the hsbCAD TSL menu or command line using `hsbFixingScrews`

2. **Select target geometry**:
   - **Option A - Wall Mode**: Click on one or more wall elements and press Enter
     - The script enters **Wall Distribution Mode**
     - Multiple walls can be processed simultaneously
   - **Option B - Beam Mode**: Press Enter without selecting walls
     - A second prompt appears: "Select Beam, Sheet or Panel"
     - Click on a single timber member
     - The script enters **Single Beam Mode**

### Step 2: Product Selection (Step-by-Step Dialogs)

The script uses a three-tier hierarchical selection system:

#### 2.1 Select Manufacturer
- A dialog appears with a dropdown listing all available manufacturers from the catalog
- Examples: "Würth", "Spax", "Fischer", etc.
- Select the desired manufacturer and confirm
- The selection is locked and becomes read-only for subsequent dialogs

#### 2.2 Select Family
- After manufacturer confirmation, a second dialog displays available screw families
- Examples (Würth): "Wood Screw Hexagon Head", "ASSY 3.0", "IN.FORCE 4Cut"
- Examples (Spax): "Wirox Universal", "Panelfast", "PowerLag"
- Select the desired family and confirm
- The family selection becomes read-only

#### 2.3 Select Product (Size)
- A third dialog shows available products in "DiameterxLength" format
- Examples: "6x80", "8x100", "10x160", "12x200"
- Select the specific screw size you need and confirm
- All three selections are now locked and define the screw specification

**Note**: You can bypass these dialogs by invoking the script with an execute key in the format: `Manufacturer?Family?Product` (e.g., `Wuerth?ASSY 3.0?8x100`)

### Step 3: Placement - Single Beam Mode

This mode provides the most interactive experience with graphical feedback.

#### 3.1 First Drill Point Prompt
**Prompt**: "Select drill point [Fixed/Start/End/Between]"

- **Click on a beam face** in the 3D viewport to place the first screw position
- The script automatically detects which face you're targeting based on the view direction
- A real-time graphical jig displays:
  - Preview screw position as a filled circle
  - Parameter control boxes for interactive adjustment
  - Distribution mode indicator

**Interactive Controls During Prompt**:
- **Graphical buttons** (clickable boxes near the beam):
  - **Mode box**: Toggle between "Even" and "Fixed" distribution
  - **Start box**: Click to enter a new Start Distance value
  - **End box**: Click to enter a new End Distance value
  - **Between box**: Click to enter a new Max Distance Between value

- **Command-line keywords** (type and press Enter):
  - **F** or **Fixed/eVen**: Toggle distribution mode
  - **S** or **Start**: Enter Start Distance
  - **E** or **End**: Enter End Distance
  - **B** or **Between**: Enter Max Distance Between

#### 3.2 Second Drill Point Prompt
**Prompt**: "Select second drill point [firstDrill/Fixed/Start/End/Between]"

- **Click a second point** on the same face to define the distribution path
- The distribution line connects the two points
- Screw positions are previewed as small filled circles along the line
- Real-time feedback shows if distribution is possible given current parameters

**Additional keyword**:
- **firstDrill**: Return to the first drill point prompt to redefine the start point

**Visual Feedback**:
- If Start Distance + End Distance > total length: "no distribution possible" message appears
- Preview updates dynamically as you adjust parameters via graphical buttons or keywords

#### 3.3 Confirmation
- Press **Enter** to accept the placement
- Press **Escape** to cancel and delete the instance

### Step 4: Placement - Wall Distribution Mode

When one or more walls are selected, the script operates automatically:

1. **Plate Selection**: Based on the "Beam" property, the script targets:
   - Top Plate only
   - Bottom Plate only
   - Both plates (creates separate instances for each)

2. **Opening Detection**:
   - The script identifies window and door openings in the wall
   - Window openings are detected by the presence of sill beams
   - King studs adjacent to openings are automatically identified

3. **Window Exclusion** (if "Exclude Window" = Yes):
   - Areas beneath window openings are excluded from standard distribution
   - The distribution path is split into segments around each window
   - Special nailing pattern is applied near king studs:
     - **3 screws** at **30mm spacing**
     - Positioned **85mm** from the edge of the king stud
     - Applied on both left and right sides of each window opening

4. **Instance Creation**:
   - The inserting instance creates child instances for each plate/segment
   - Each child instance operates independently on its assigned beam
   - The original inserting instance deletes itself after spawning children

5. **Automatic Alignment**:
   - Top Plate: Screws face downward (negative Y direction)
   - Bottom Plate: Screws face upward (positive Y direction)
   - Angle is automatically inverted based on zone selection (-1 or 1)

### Step 5: Post-Placement Editing

After placement, you can modify the screw distribution:

#### Via Properties Palette (OPM)
- Select the screw distribution instance
- Modify any parameter in the AutoCAD Properties Palette
- The distribution automatically recalculates

#### Via Grip Points
- **_Pt0 Grip** (start point): Drag to reposition the distribution start
- **_PtG0 Grip** (end point): Drag to reposition the distribution end
- Both points are automatically projected onto the selected face plane
- Distribution updates dynamically

#### Special Behavior - Angle = 0
When the Angle parameter is set to 0° (or any multiple of 180°):
- The distribution path is automatically **centered on the beam width**
- This ensures perpendicular entry to the face
- Triggered only on property change or instance creation

## Parameter Reference

### Component Category

#### Manufacturer
- **Type**: String (Dropdown)
- **Default**: First available from catalog
- **Description**: Selects the screw manufacturer from the XML catalog
- **Examples**: "Würth", "Spax", "Fischer", "Simpson Strong-Tie"
- **Behavior**:
  - Populated from `ScrewCatalog.xml` → `Manufacturer[]` → `Name`
  - Becomes read-only after dialog confirmation
  - Changing this property refreshes Family and Product lists

#### Family
- **Type**: String (Dropdown)
- **Default**: First available for selected manufacturer
- **Description**: Selects the screw type/family within the chosen manufacturer
- **Examples**: "Wood Screw", "ASSY 3.0 8xX", "IN.FORCE 4Cut", "Panelfast"
- **Behavior**:
  - Filtered based on Manufacturer selection
  - Contains all families defined under the manufacturer in the catalog
  - Becomes read-only after dialog confirmation

#### Product
- **Type**: String (Dropdown)
- **Default**: First available for selected family
- **Description**: Selects the specific product size, displayed as "DiameterxLength"
- **Display Format**: `[Thread Diameter]x[Length]` (e.g., "8x100" = 8mm diameter, 100mm length)
- **Behavior**:
  - Filtered based on Family selection
  - Each entry corresponds to a unique Length value in the Product[] array
  - Diameter is inherited from the Family definition

### Alignment Category

#### Alignment
- **Type**: String (Dropdown)
- **Options**: "+X", "-X", "+Y", "-Y", "+Z", "-Z"
- **Default**: Auto-detected based on view direction
- **Visibility**: Hidden during insertion (auto-calculated)
- **Description**: Defines which face of the beam receives the screws
- **Behavior**:
  - Automatically set during insertion based on the face you click
  - In Single Beam Mode: Uses view direction to determine the face closest to the click
  - In Wall Mode: Automatically calculated based on plate orientation and zone
  - Face normal vectors:
    - "+X" = beam's +X face
    - "-Y" = beam's -Y face (typical for top plates)
    - "+Y" = beam's +Y face (typical for bottom plates)

#### Angle
- **Type**: Double (Millimeters)
- **Default**: 30mm
- **Range**: Any angle value (typically 0° - 90°)
- **Description**: Inclination angle of the screw in degrees
- **Behavior**:
  - Rotation axis follows the distribution direction (vecZnail)
  - Positive angle rotates away from the face normal
  - Negative angle rotates toward the face normal
  - **Special Case**: When set to 0° (or 180°, 360°, etc.):
    - Distribution path automatically centers on beam width
    - Ensures perpendicular entry to the face
    - Only triggers on property change or creation (not on grip drag)
  - In Wall Mode: Angle is automatically inverted for different zones
    - Zone +1: Angle becomes -Angle (exterior side)
    - Zone -1: Angle remains positive (interior side)

#### Offset from Plate
- **Type**: Double (Millimeters)
- **Default**: 13mm
- **Description**: Distance from the beam face to the screw head position
- **Behavior**:
  - Defines the gap between the beam surface and the starting point of the screw
  - Positive values move the screw start point away from the face
  - Used to simulate countersinking or recess depth
  - The screw geometry calculation uses this to position the entry point

### Distribution Category

#### Mode of Distribution
- **Type**: String (Dropdown)
- **Options**: "Even", "Fixed"
- **Default**: "Even"
- **Description**: Controls how screws are spaced along the distribution path
- **"Even" Mode**:
  - Divides the available length into equal segments
  - Number of screws calculated as: `floor(availableLength / maxDistance) + 1`
  - Actual spacing is adjusted to fit the total length evenly
  - No screw at the exact end point (end distance is respected)
  - **Use case**: When you want uniform spacing that fills the entire length

- **"Fixed" Mode**:
  - Uses the exact "Max Distance Between" value
  - Places screws at the specified interval
  - Adds an **extra screw at the end point**
  - Actual spacing between screws remains constant (not adjusted)
  - **Use case**: When spacing must match a specific building code requirement

**Keyboard Toggle**: Type **F** during insertion to switch between modes

#### Start Distance
- **Type**: Double (Millimeters)
- **Default**: 0mm
- **Description**: Offset distance from the start point before the first screw is placed
- **Behavior**:
  - Positive values move the first screw away from the start point
  - If Start Distance + End Distance > total length: distribution fails
  - In Wall Mode: Applied consistently across all plate segments
  - **Interactive Edit**: Click "Start" button in jig or type **S** during insertion

**Example**: Start Distance = 50mm means first screw is 50mm from the distribution line start

#### End Distance
- **Type**: Double (Millimeters)
- **Default**: 0mm
- **Description**: Offset distance from the end point after the last screw
- **Behavior**:
  - Positive values move the last screw away from the end point
  - Works in conjunction with Start Distance to define the active distribution zone
  - In "Fixed" mode: The extra end screw respects this distance
  - **Interactive Edit**: Click "End" button in jig or type **E** during insertion

**Example**: End Distance = 50mm means last screw is 50mm before the distribution line end

#### Max. Distance between / Number
- **Type**: Double (Millimeters or Integer)
- **Default**: 500mm
- **Description**: Maximum spacing between screws OR exact number of screws (when negative)
- **Positive Value**: Maximum distance between screws
  - Example: `500` = screws will be spaced no more than 500mm apart
  - Actual spacing calculated to fit the available length
  - In "Even" mode: spacing is adjusted for uniform distribution
  - In "Fixed" mode: exact spacing is used, with extra screw at end

- **Negative Integer**: Exact number of screws
  - Example: `-5` = exactly 5 screws will be placed
  - The integer part is used (e.g., `-5.7` becomes 5 screws)
  - Screws are distributed evenly across the available length
  - Start and End distances are still respected
  - **Special Case**: `-1` = single screw at Start Distance position

**Interactive Edit**: Click "Between" button in jig or type **B** during insertion

#### Real Distance between
- **Type**: Double (Millimeters)
- **Read-Only**: Yes
- **Default**: Calculated automatically
- **Description**: Displays the calculated actual distance between screws after distribution
- **Calculation**:
  - In "Even" mode: `availableLength / numberOfIntervals`
  - In "Fixed" mode: Same as "Max Distance Between" value
  - When using negative number: `availableLength / (numberOfScrews - 1)`

#### Nr. (Number of Screws)
- **Type**: Integer
- **Read-Only**: Yes
- **Default**: Calculated automatically
- **Description**: Displays the total number of screws placed in the distribution
- **Behavior**:
  - Updates automatically when parameters change
  - Used for Bill of Material quantity calculation
  - In Wall Mode: Each segment has its own count
  - Includes all screws: regular distribution + opening-specific nailing patterns

### Wall Distribution Rules Category

**Visibility**: These parameters are **only visible when the script is applied to a wall element**. They are hidden in Single Beam Mode.

#### Zone
- **Type**: Integer (Dropdown)
- **Options**: -1 (Interior), +1 (Exterior)
- **Default**: -1
- **Description**: Defines which side (zone) of the wall the screws are placed on
- **Values**:
  - **-1**: Interior side of the wall
  - **+1**: Exterior side of the wall
- **Behavior**:
  - Affects screw angle direction (angle is inverted for zone +1)
  - Determines which face of the plate receives the screws
  - Used in coordinate system transformations to position screws correctly

#### Beam
- **Type**: String (Dropdown)
- **Options**: "Top Plate", "Bottom Plate", "Both"
- **Default**: "Top Plate"
- **Description**: Specifies which plate(s) in the wall receive the screws
- **Behavior**:
  - **"Top Plate"**: Single instance created for the top horizontal beam
  - **"Bottom Plate"**: Single instance created for the bottom horizontal beam
  - **"Both"**: Two separate instances created (one for top, one for bottom)
  - Plate identification:
    - Script filters horizontal beams (perpendicular to wall Y-axis)
    - Uses half-line intersection from wall center to find top/bottom
    - Top plate: Last beam in upward (+Y) direction
    - Bottom plate: Last beam in downward (-Y) direction

#### Exclude Window
- **Type**: String (Dropdown)
- **Options**: "No", "Yes"
- **Default**: "No"
- **Description**: When set to "Yes", excludes the area beneath window openings from screw distribution
- **Behavior - "No"**:
  - Screws distributed continuously along the entire plate length
  - No special handling for openings

- **Behavior - "Yes"**:
  - Window openings are detected (identified by sill beams below the opening)
  - Distribution path is split into segments around each window
  - Exclusion zone extends **145mm** on each side of the opening
  - **Special nailing pattern** applied at window edges:
    - Left king stud: 3 screws at 30mm spacing, 85mm from stud edge
    - Right king stud: 3 screws at 30mm spacing, 85mm from stud edge
    - Nailing direction follows the zone setting
  - Segments between windows use standard distribution parameters (Start Distance = 0, End Distance = 0)
  - First and last segments respect the original Start/End Distance settings

**Opening Detection Logic**:
1. All openings in the wall are analyzed
2. A point at the center of each opening (at wall mid-height) is used
3. Beams are filtered using half-line intersection downward (-Y direction)
4. If a **Sill** beam type is found: Classified as window
5. If no sill beam: Classified as door (no exclusion)
6. King studs are identified as vertical beams adjacent to the opening

### Drill Category

These parameters control the optional drill tooling operation applied to the host beam(s).

#### Drill
- **Type**: String (Dropdown)
- **Options**: "No", "Yes"
- **Default**: "No"
- **Description**: Enables or disables applying actual drill operations (tooling) to the host beam
- **Behavior - "No"**:
  - Only visual representation of screws is displayed
  - No geometry modification to the beam
  - Suitable for visualization and BOM generation

- **Behavior - "Yes"**:
  - Applies a Drill tool to the beam at each screw position
  - Creates actual cylindrical voids in the beam geometry
  - Drill parameters use Diameter and Depth settings
  - If multiple beams are linked (via "add Genbeam"), the drill extends through them
  - Suitable for CNC machining preparation

#### Diameter
- **Type**: Double (Millimeters)
- **Default**: 0mm
- **Description**: Drill hole diameter for tooling operations
- **Behavior**:
  - **When 0 or negative**: Drill diameter defaults to the **thread diameter** of the selected screw
  - **When positive**: Uses the specified value as the drill diameter
- **Typical Use Cases**:
  - `0` = Auto-size to screw thread (no clearance)
  - `thread + 0.5mm` = Tight clearance hole
  - `thread + 1mm` = Standard clearance hole
  - `thread + 2mm` = Loose clearance hole

**Example**: For a 6mm thread screw:
- Diameter = 0 → 6mm drill
- Diameter = 6.5 → 6.5mm drill (0.5mm clearance)

#### Depth
- **Type**: Double (Millimeters)
- **Default**: 0mm
- **Description**: Drill hole depth for tooling operations
- **Behavior**:
  - **When 0**: Drill depth defaults to the **full screw length**
  - **When -1**: Also uses the full screw length (same as 0)
  - **When positive**: Uses the specified value as the explicit drill depth
  - Drill direction follows the screw angle and alignment
  - If depth exceeds beam thickness, the drill will penetrate through

**Through-Drilling**: When a second beam is added via "add Genbeam":
- If Depth ≠ 0: The drill extends through both beams
- Useful for bolted connections between overlapping members

**Example**: For a 100mm screw:
- Depth = 0 → 100mm drill
- Depth = 50 → 50mm drill (pilot hole)
- Depth = 150 → 150mm drill (through-hole for longer connections)

## Context Menu Options (Right-Click)

After the script is placed in **Single Beam Mode**, right-clicking the instance provides additional operations:

### add Genbeam
- **Purpose**: Links an additional beam to the screw distribution
- **Workflow**:
  1. Right-click the screw distribution instance → "add Genbeam"
  2. Select a second beam from the drawing
  3. The beam is added to the internal `_GenBeam` array
  4. If drilling is enabled, drill operations extend through both beams
- **Use Cases**:
  - Through-bolting scenarios (screw passes through one beam into another)
  - Lap joints where two beams overlap
  - Structural connections requiring penetration through multiple members

### remove Genbeam
- **Purpose**: Removes a previously added secondary beam
- **Availability**: Only appears when more than one beam is associated with the instance
- **Workflow**:
  1. Right-click the instance → "remove Genbeam"
  2. Select the beam to remove
  3. The beam is removed from the `_GenBeam` array
  4. Drill operations no longer affect the removed beam

### generate Single Instances
- **Purpose**: Breaks the distribution into individual single-screw instances
- **Workflow**:
  1. Right-click the instance → "generate Single Instances"
  2. The script creates a new independent TSL instance for each screw position
  3. Each new instance has:
     - Distribution mode set to single screw (`dDistanceBetween = -1`)
     - Start Distance = 0
     - Same manufacturer, family, product, angle, drill settings as parent
  4. The original distribution instance is **deleted** after conversion
- **Use Cases**:
  - When you need to individually edit or reposition specific screws
  - Fine-tuning screw positions after automated distribution
  - Removing specific screws from the pattern while keeping others
  - Creating irregular patterns based on an initial regular distribution

**Note**: This operation is **irreversible**. You cannot merge single instances back into a distribution.

## Settings Configuration: ScrewCatalog.xml

The screw catalog is the central configuration file that defines all available manufacturers, families, and products.

### File Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>

  <lst nm="Manufacturer[]">
    <lst nm="Manufacturer">
      <str nm="Name" vl="Würth"/>

      <lst nm="Family[]">
        <lst nm="Family">
          <str nm="Name" vl="Wood Screw Hexagon Head"/>
          <dbl nm="Diameter Thread" ut="L" vl="8.0"/>
          <dbl nm="Diameter Head" ut="L" vl="13.0"/>
          <dbl nm="Length Head" ut="L" vl="5.0"/>
          <str nm="url" vl="https://www.wuerth.com/..."/>
          <str nm="Norm" vl="DIN 571"/>
          <str nm="Material" vl="Steel"/>
          <str nm="Surface" vl="Galvanized"/>
          <str nm="Thread Type" vl="Full Thread"/>
          <str nm="Property class" vl="4.8"/>

          <lst nm="Product[]">
            <lst nm="Product">
              <dbl nm="Length" ut="L" vl="80"/>
              <str nm="ArticleNumber" vl="0571 080"/>
              <str nm="Description" vl="EAN 4003544771789"/>
            </lst>
            <lst nm="Product">
              <dbl nm="Length" ut="L" vl="100"/>
              <str nm="ArticleNumber" vl="0571 100"/>
              <str nm="Description" vl="EAN 4003544771796"/>
            </lst>
          </lst>
        </lst>

        <lst nm="Family">
          <str nm="Name" vl="ASSY 3.0"/>
          <!-- Another family definition -->
        </lst>
      </lst>
    </lst>

    <lst nm="Manufacturer">
      <str nm="Name" vl="Spax"/>
      <!-- Another manufacturer -->
    </lst>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Catalog Hierarchy

**Level 1: Manufacturer**
- Defines the brand/company
- Required field: `Name`

**Level 2: Family**
- Defines the screw type/series within a manufacturer
- Required fields:
  - `Name`: Family designation (displayed in dialog)
  - `Diameter Thread`: Thread diameter in mm (shared by all products in family)
  - `Diameter Head`: Head diameter in mm
  - `Length Head`: Head length/height in mm
- Optional fields:
  - `url`: Product reference URL
  - `Norm`: Applicable standard (DIN, ISO, ANSI, etc.)
  - `Material`: Base material (Steel, Stainless Steel, etc.)
  - `Surface`: Surface treatment (Galvanized, Zinc-plated, etc.)
  - `Thread Type`: Full Thread, Partial Thread, etc.
  - `Property class`: Strength grade (4.8, 8.8, etc.)

**Level 3: Product**
- Defines individual screw sizes within a family
- Required fields:
  - `Length`: Screw length in mm
  - `ArticleNumber`: Manufacturer article/part number
  - `Description`: Product identifier (EAN, UPC, or custom description)
- Display name: Automatically generated as `[Diameter Thread]x[Length]`

### Adding Custom Entries

**To add a new manufacturer:**
1. Open `ScrewCatalog.xml` in a text editor
2. Copy an existing `<lst nm="Manufacturer">...</lst>` block
3. Change the `Name` value
4. Add or modify Family entries as needed
5. Save the file

**To add a new family to an existing manufacturer:**
1. Locate the desired manufacturer block
2. Copy an existing `<lst nm="Family">...</lst>` block
3. Update all field values
4. Ensure `Diameter Thread`, `Diameter Head`, and `Length Head` are accurate
5. Save the file

**To add a new product size:**
1. Locate the desired family block
2. Copy an existing `<lst nm="Product">...</lst>` block
3. Update `Length`, `ArticleNumber`, and `Description`
4. Save the file

### Version Validation

When a new instance is created (`_bOnDbCreated = true`), the script performs version checking:

1. Reads the version from the in-memory MapObject (cached in drawing database)
2. Reads the version from the XML file on disk
3. If versions differ: Displays a notice with:
   - Current version (from drawing)
   - Other version (from disk)
   - File paths for both sources
4. This ensures all team members are aware of catalog updates

**Best Practice**: Increment the `Version` number in `GeneralMapObject` whenever you modify the catalog.

### Catalog Presets (Named Configurations)

The script supports pre-configured catalog entries for quick insertion:

**How it works:**
1. Create a catalog entry using the hsbCAD catalog system
2. Name it (e.g., "StandardFraming", "HeavyDutyConnection")
3. Invoke the script with the preset name as execute key: `hsbFixingScrews StandardFraming`
4. The script loads Manufacturer, Family, and Product automatically (no dialogs)

**Note**: Preset names must not match any manufacturer name to avoid conflicts.

## Technical Details

### Script Type and Behavior
- **O-Type (Object)**: Exists as an independent entity in Model Space
- **NumBeamsReq = 0**: Does not require pre-selected beams at insertion time
- **Implicit Insert**: Automatically enters insertion mode when invoked
- **DxaOut = 1**: Display entities are included in DXA (shop drawing) output

### Coordinate Systems and Geometry

**Beam Coordinate System:**
- `vecX`: Beam length direction
- `vecY`: Beam width direction
- `vecZ`: Beam height direction
- `ptCen`: Beam center point

**Face Alignment:**
- The "Alignment" parameter determines which face receives screws
- Face normal vectors:
  - "+X" → `vecX` face (end face)
  - "-X" → `-vecX` face (opposite end)
  - "+Y" → `vecY` face (right side)
  - "-Y" → `-vecY` face (left side)
  - "+Z" → `vecZ` face (top)
  - "-Z" → `-vecZ` face (bottom)

**Screw Coordinate System:**
- `vecXnail`: Screw axis direction (inverted from face normal, rotated by angle)
- `vecYnail`: Perpendicular to both screw axis and distribution direction
- `vecZnail`: Distribution direction (direction from _Pt0 to _PtG0)
- Rotation: `csRotate.setToRotation(dAngle, vecZnail, pt0NailStart)`

### Distribution Algorithm

**Even Mode:**
```
availableLength = totalLength - startDistance - endDistance
numberOfIntervals = floor(availableLength / maxDistance)
actualSpacing = availableLength / numberOfIntervals
numberOfScrews = numberOfIntervals + 1

For i = 0 to numberOfIntervals:
    position = startPoint + startDistance + (i * actualSpacing)
```

**Fixed Mode:**
```
availableLength = totalLength - startDistance - endDistance
numberOfIntervals = floor(availableLength / maxDistance)
numberOfScrews = numberOfIntervals + 2  // +1 for start, +1 for end

positions[0] = startPoint + startDistance
For i = 1 to numberOfIntervals:
    positions[i] = positions[0] + (i * maxDistance)
positions[numberOfIntervals + 1] = endPoint - endDistance
```

**Negative Number (Exact Count):**
```
numberOfScrews = abs(floor(distanceBetween))
if numberOfScrews == 1:
    position = startPoint + startDistance
else:
    spacing = availableLength / (numberOfScrews - 1)
    For i = 0 to (numberOfScrews - 1):
        position = startPoint + startDistance + (i * spacing)
```

### Drill Geometry Calculation

For each screw position:
1. **Determine screw entry point**: `ptGap = pnNailStart.closestPointTo(ptDistribution)`
2. **Get beam cross-section**: Slice the beam body perpendicular to the distribution direction
3. **Calculate drill line**: `Line(ptGap, vecXnail)` (screw axis)
4. **Find intersections**: Intersection points between drill line and beam cross-section
5. **Determine start/end**:
   - `ptStart`: Intersection closest to the face (where screw enters)
   - `ptEnd`: Intersection farthest from the face (where screw exits/stops)
6. **Create drill**:
   - Diameter: `dDiameterDrillReal` (from property or thread diameter)
   - Depth: `dLengthDrillReal` (from property or screw length)
   - Drill: `Drill(ptGap - vecXnail*epsilon, ptGap + vecXnail*(depth+epsilon), radius)`
7. **Apply to beam(s)**:
   - Primary beam: `_GenBeam[0].addTool(drill)`
   - Secondary beam (if added and depth ≠ 0): `_GenBeam[1].addTool(drill)`

### Display System

**Visual Elements:**
- **Screw positions**: Small filled circles on the beam face (Color 1 - Red)
- **Drill depth indicators**: Line segments showing drill direction and depth (Color 252 - Gray)
- **Drill end caps**: Filled circles at drill end points (Color 1 - Red)
- **Screw body preview** (Single Beam Mode): 3D solid representation using thread/head geometry (Color 252 - Gray)

**DXA Integration:**
```c
Display dp(1);
dp.showInDxa(true);  // Enable DXA output for shop drawings
```
- All display entities are flagged for inclusion in DXA output (version 1.9+)
- Shop drawings will show screw positions and drill indicators
- Useful for fabrication documentation

### Hardware BOM Generation

For each distribution instance, a hardware component is automatically created:

**Component Properties:**
- **Article Number**: From catalog (`sArticleNr`)
- **Manufacturer**: Selected manufacturer name
- **Model**: Selected product (DiameterxLength format)
- **Family**: Selected family name
- **Quantity**: Number of screws in distribution (`nNrResult`)
- **Category**: "Connector"
- **Rep Type**: `_kRTTsl` (identifies components created by TSL scripts)
- **Linked Entity**: Host beam (first beam in `_GenBeam`)
- **Group**: Element group name (inherited from parent element or beam)
- **Scale Dimensions**:
  - X: Screw length (`dLengthScrew`)
  - Y: Thread diameter (`dDiameterThread`)

**BOM Lifecycle:**
- Existing TSL-generated components (`repType == _kRTTsl`) are removed each recalculation
- New component is created based on current parameter values
- Components persist in the drawing database
- Accessible via hsbCAD BOM reporting tools

### MapIO Support (Programmatic Creation)

The script supports the MapIO protocol for automation and element constructors:

**Usage:**
```c
// Create a map with property values
Map mapProps;

// String properties
Map mapPropStrings;
mapPropStrings.appendString("sManufacturer", "Würth");
mapPropStrings.appendString("sFamily", "ASSY 3.0");
mapPropStrings.appendString("sProduct", "8x100");
mapPropStrings.appendString("sAlignment", "+Y");
mapPropStrings.appendString("sModeDistribution", "Even");
mapPropStrings.appendString("sDrill", "Yes");
mapProps.setMap("PROPSTRING[]", mapPropStrings);

// Double properties
Map mapPropDoubles;
mapPropDoubles.appendDouble("dAngle", U(45));
mapPropDoubles.appendDouble("dGapNail", U(10));
mapPropDoubles.appendDouble("dDistanceBottom", U(50));
mapPropDoubles.appendDouble("dDistanceTop", U(50));
mapPropDoubles.appendDouble("dDistanceBetween", U(300));
mapProps.setMap("PROPDOUBLE[]", mapPropDoubles);

// Integer properties
Map mapPropInts;
mapPropInts.appendInt("nZone", -1);
mapProps.setMap("PROPINT[]", mapPropInts);

// Create instance
TslInst tslNew;
tslNew.dbCreate("hsbFixingScrews", vecX, vecY, genbeams, entities, points,
                intProps, doubleProps, stringProps, _kModelSpace, mapProps);
```

**Behavior:**
- If `_Map` contains property maps on `_bOnMapIO`: Properties are loaded from map
- Dialog is shown for user confirmation
- Updated property map is returned via `_Map`
- On element construction: Properties are applied silently (no dialog)

### Performance Optimizations

**Settings Caching:**
- ScrewCatalog.xml is loaded once and cached as a MapObject in the drawing database
- Dictionary key: `"hsbTSL"` / `"ScrewCatalog"`
- Subsequent instances reuse cached data (no file I/O)
- Dependency tracking: `setDependencyOnDictObject(mo)` ensures recalculation if catalog changes

**Envelope vs. Real Body:**
- Drill calculations use `gb.envelopeBody(true, true)` for accurate cross-sections
- Visual preview uses envelope geometry for faster performance
- Real body only accessed when drill tooling is applied

**Execution Loops:**
- `setExecutionLoops(2)` used when:
  - Properties change that affect dependent calculations
  - Hardware components are created (requires second pass for BOM update)
  - Angle is set to 0° (triggers auto-centering)
  - Beams are added/removed via context menu

## Workflow Examples

### Example 1: Standard Wall Bottom Plate Nailing

**Scenario**: Distribute screws along the bottom plate of a wall, spacing them 400mm apart, with 50mm offset from each end, excluding window areas.

**Steps:**
1. Invoke `hsbFixingScrews`
2. Select one or more walls, press Enter
3. Dialog 1 - Manufacturer: Select "Würth"
4. Dialog 2 - Family: Select "ASSY 3.0 8xX"
5. Dialog 3 - Product: Select "8x100"
6. **Properties Palette** (after automatic placement):
   - Zone: -1 (Interior)
   - Beam: "Bottom Plate"
   - Exclude Window: "Yes"
   - Angle: 30
   - Start Distance: 50
   - End Distance: 50
   - Max Distance Between: 400
   - Mode: "Even"

**Result:**
- Screws distributed along bottom plate
- Areas beneath windows excluded
- Special 3-screw patterns at window edges (85mm from king studs, 30mm spacing)
- Continuous distribution in segments between windows

### Example 2: Single Beam Angled Screws with Drilling

**Scenario**: Place 10 screws evenly along a beam at 45° angle, with pilot holes for CNC machining.

**Steps:**
1. Invoke `hsbFixingScrews`
2. Press Enter (skip wall selection)
3. Select a single beam
4. Dialog 1 - Manufacturer: Select "Spax"
5. Dialog 2 - Family: Select "Wirox Universal"
6. Dialog 3 - Product: Select "6x80"
7. Click first point on beam top face
8. **During prompt**:
   - Type "B" → Enter "-10" → Enter (set exact count to 10 screws)
   - Type "S" → Enter "100" → Enter (start 100mm from beginning)
   - Type "E" → Enter "100" → Enter (end 100mm from end)
9. Click second point to define distribution direction
10. Press Enter to confirm
11. **Properties Palette**:
    - Angle: 45
    - Drill: "Yes"
    - Diameter: 0 (auto-size to 6mm thread)
    - Depth: 0 (auto-size to 80mm length)

**Result:**
- 10 screws evenly distributed
- 45° angle from face normal
- Drill tooling applied (6mm diameter, 80mm depth)
- Ready for CNC export

### Example 3: Through-Bolting Two Overlapping Beams

**Scenario**: Create a bolted lap joint with screws passing through two beams.

**Steps:**
1. Place hsbFixingScrews on the first beam (primary)
2. Select product (e.g., "12x200" for long screws)
3. Define distribution (e.g., 4 screws at 150mm spacing)
4. **Right-click instance** → "add Genbeam"
5. Select the second beam (secondary)
6. **Properties Palette**:
   - Drill: "Yes"
   - Diameter: 12.5 (clearance hole for 12mm screw)
   - Depth: 200 (full screw length, penetrates both beams)

**Result:**
- Screws visualized passing through both beams
- Drill holes created in both beams (shared drill tooling)
- BOM includes screw count
- Suitable for structural bolted connections

### Example 4: Custom Distribution with Individual Editing

**Scenario**: Start with automated distribution, then manually adjust individual screw positions.

**Steps:**
1. Create distribution with desired base pattern (e.g., 8 screws at 300mm spacing)
2. **Right-click instance** → "generate Single Instances"
3. The distribution breaks into 8 independent screw instances
4. Select and delete specific screws as needed
5. Drag grip points on remaining screws to fine-tune positions
6. Each screw can have individually modified parameters (angle, drill depth, etc.)

**Result:**
- Irregular pattern based on regular foundation
- Full control over each screw position
- Each screw is an independent TSL instance

## Tips and Best Practices

### Workflow Efficiency

**Use Execute Keys for Repetitive Work:**
- Instead of clicking through dialogs each time, use command line invocation:
  ```
  hsbFixingScrews Wuerth?ASSY 3.0?8x100
  ```
- Create AutoCAD toolbar buttons or aliases for common configurations

**Leverage Catalog Presets:**
- Save common configurations as named presets in the catalog system
- Example: "WallBottomStandard", "TopPlateHeavy", "BeamLapJoint"
- Invoke with: `hsbFixingScrews WallBottomStandard`

**Interactive Jig for Quick Adjustments:**
- During insertion, use the graphical buttons instead of typing
- Click "Mode" box to toggle Even/Fixed quickly
- Click "Between" box to change spacing without typing keywords
- Visual feedback is instant

### Distribution Strategy

**Use "Even" Mode for:**
- Aesthetic uniformity (e.g., exposed beams)
- When exact spacing is less critical than even appearance
- Filling a length with maximum screws within a spacing limit

**Use "Fixed" Mode for:**
- Building code compliance (exact 400mm spacing requirement)
- Structural calculations based on specific spacing
- When you need an exact end anchor point

**Use Negative Numbers for:**
- Exact screw counts from engineering drawings
- When you know "10 screws needed" but not the spacing
- Quick testing of different quantities (just change -8 to -10)

### Angle and Alignment

**Auto-Centering with Angle = 0:**
- Perpendicular screws (0°) automatically center on beam width
- Useful for face-mounted connections
- To disable: Set angle to 0.01° instead of 0°

**Angle for Toenailing:**
- 30° - 45° typical for toenail connections
- Positive angle: Screw angles away from face normal
- Negative angle: Screw angles toward face normal
- Use zone setting to control direction on walls

**Alignment Detection:**
- The script uses view direction to guess the face you're targeting
- For ambiguous cases: Zoom in closer and click directly on the desired face
- You can override in Properties Palette after placement

### Drilling Best Practices

**Pilot Holes:**
- Set Depth < screw length for pilot holes (e.g., Depth = 50 for 100mm screw)
- Helps prevent wood splitting
- Use Diameter = 0 for auto-sizing to thread diameter

**Clearance Holes:**
- Set Diameter > thread diameter (e.g., thread 6mm → Diameter 7mm)
- Allows for bolt/screw movement
- Typical clearances: +0.5mm (tight), +1mm (standard), +2mm (loose)

**Through-Holes:**
- Use "add Genbeam" to link second beam
- Set Depth > 0 (any non-zero value) to extend drill through both beams
- Verify beam alignment before drilling

### Wall Mode Considerations

**Window Exclusion Planning:**
- Always use "Exclude Window = Yes" for bottom plates
- Special nailing pattern (3 screws at king studs) is structural
- 85mm offset from stud edge is standard for code compliance
- If you need different patterns, use Single Beam Mode on individual plates

**Zone Selection:**
- Zone -1 (Interior): Common for interior-facing screws
- Zone +1 (Exterior): Common for exterior sheathing attachment
- Zone affects screw angle direction (automatically inverted)

**Both Plates vs. Separate:**
- "Both" creates two independent instances (one per plate)
- Separate instances allow different parameters for top/bottom
- If you need identical settings, "Both" is most efficient

### Team Collaboration

**Catalog Management:**
- Keep ScrewCatalog.xml in company path for team-wide consistency
- Increment version number when making changes
- The script alerts users when their cached version differs from disk version
- Document custom manufacturer/family additions for the team

**BOM Integration:**
- Hardware components are linked to element groups
- Element-based BOM reports will include screw quantities
- Article numbers flow through to material ordering systems
- Rep Type = _kRTTsl allows filtering TSL-generated hardware

### Troubleshooting

**"no distribution possible" message:**
- Check: Start Distance + End Distance < total length
- Reduce start/end distances or increase distribution length
- Verify you're clicking on the correct beam face

**Screws outside beam:**
- "distribution outside the genbeam" message
- Usually caused by grip point dragging beyond beam extents
- Reset grip points to positions within beam bounds

**Version mismatch notice:**
- Someone has updated ScrewCatalog.xml
- Check with team to determine which version is correct
- Replace your local file or ask others to update

**Drill not appearing:**
- Ensure "Drill = Yes" in Properties Palette
- Check Diameter and Depth are not both 0 (auto-sizing requires valid screw data)
- Verify screw intersects beam geometry (cross-section slice must succeed)

**Missing manufacturers in dialog:**
- ScrewCatalog.xml file not found or corrupt
- Check file exists in company or installation path
- Validate XML structure (must be valid Hsb_Map format)
- Ensure at least one Manufacturer block exists

## Advanced Topics

### Script Lifecycle and Recalculation

**Insertion Phase** (`_bOnInsert = true`):
1. Prompt for walls or beam selection
2. Step-by-step dialogs for product selection (unless execute key provided)
3. In Single Beam Mode: Interactive jig with graphical controls
4. In Wall Mode: Automatic instance spawning, then self-deletion

**Recalculation Triggers**:
- Property change via OPM: Script recalculates distribution
- Grip point drag: Live preview during drag, recalculate on release
- Context menu action: Add/remove beam, generate single instances
- Angle set to 0: Auto-centering triggered

**Execution Loops**:
- Loop 2: Used for hardware BOM updates and property-dependent recalculations
- Loop 3+: Rare, used only for complex multi-stage operations

### Jig System (Graphical Interface)

The jig system provides real-time visual feedback during insertion:

**Jig Action**: `strJigAction1`
- Called from `PrPoint.goJig()` during point prompts
- Map argument contains geometry and parameter data
- Jig rendering:
  - Graphical boxes for mode, start, end, between parameters
  - Screw position previews as filled circles
  - Distribution line visualization
  - "no distribution possible" warnings

**Interactive Elements**:
- **Clickable boxes**: Profile regions detect mouse clicks
  - Mode box: Toggle between Even/Fixed
  - Parameter boxes: Prompt for value input via `getString()`
- **Coordinate transformations**: View-aligned rendering using `getViewDirection()`
- **Highlight feedback**: Hover detection changes color (Color 3 for highlight)

**Performance**:
- Jig runs on every mouse move during point prompts
- Geometry is cached in `_Map` to avoid recalculation
- Profile tests (`pointInProfile`) for interaction detection

### Custom Extensions

**Modifying Distribution Algorithm:**
The distribution logic is centralized in lines 2823-2941. To add custom distribution modes:

1. Add new mode to `sModeDistributions[]` array (line 194)
2. Add conditional branch in distribution calculation section
3. Implement your spacing algorithm
4. Update `dDistanceBetweenResult` and `nNrResult` for BOM

**Adding Catalog Metadata:**
The catalog structure supports arbitrary metadata fields. To add custom fields:

1. Add new `<str>` or `<dbl>` entries in Family or Product blocks
2. Read values using `mapFamily.getString("YourField")` or `mapProduct.getDouble("YourField")`
3. Store in local variables for use in calculations or BOM

**Extending Hardware BOM:**
Hardware component creation (lines 3144-3200) can be extended:

```c
hwc.setNotes("Custom field: " + customValue);
hwc.setMaterial(mapFamily.getString("Material"));
// Add any HardWrComp properties as needed
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **1.9** | May 10, 2023 | HSB-18650: Standard display published for share and make (DXA output enabled) |
| **1.8** | Sep 14, 2021 | HSB-13076: Set distribution to center when angle is 0 (only on property change) |
| **1.7** | Sep 3, 2021 | HSB-13077: Fix bug when reading manufacturer, family, product from execute key |
| **1.6** | Jul 23, 2021 | HSB-12662: TSL works with ElementWall, not only ElementWallSF |
| **1.5** | Jun 18, 2021 | HSB-11613: Fix bug - write article number in hardware instead of family name, add trigger to generate single instances |
| **1.4** | May 29, 2021 | Small improvement in jig |
| **1.3** | May 12, 2021 | HSB-11613: Add command line options, support MapIO |
| **1.2** | May 4, 2021 | HSB-11613: Fix bug at start/end distance for distribution |
| **1.1** | May 2, 2021 | HSB-11613: Add graphics interface in jig |
| **1.0** | Apr 29, 2021 | HSB-11613: Initial release |

## Related Scripts and Workflows

### Complementary TSL Scripts

**hsbNailing**
- Alternative nailing distribution tool
- More focused on sheet-to-beam nailing patterns
- Works with nail families instead of screw catalogs
- Simpler parameter set for repetitive nailing tasks

**hsbDrill**
- Standalone drilling tool
- Provides more drill-specific options (countersink, counterbore)
- Can be used to add drilling to existing screw distributions

**HSB_E-NailClusters**
- Element-level nailing automation
- Applies standard nailing patterns to complete wall elements
- Works in conjunction with hsbFixingScrews for comprehensive fastening

### Integration Points

**Element Constructors:**
- Wall constructors can call hsbFixingScrews via MapIO
- Automated bottom plate anchoring during wall creation
- Standard top plate nailing as part of element assembly

**CNC Export Workflow:**
- Drill tooling operations flow to CNC export systems
- hsbCNC script reads drill geometry for machine code generation
- Screw positions can trigger marking operations for manual fastening

**BOM and Material Takeoff:**
- HSB_G-BillOfMaterial collects hardware components
- Linked to element groups for project-level material estimation
- Article numbers integrate with purchasing systems

**Shop Drawing Generation:**
- DXA output (version 1.9+) includes screw positions
- Shop drawing scripts (sd_*) can reference screw distributions
- Fabrication drawings show fastener layout for assembly crews

## Conclusion

**hsbFixingScrews** is a powerful and flexible tool for automating screw distribution in timber construction projects. Its dual-mode operation (Single Beam and Wall Element) addresses both detailed custom work and large-scale repetitive tasks. The integration with XML-based product catalogs ensures accuracy in material selection and BOM generation, while the interactive graphical jig provides intuitive control during placement.

Key strengths:
- **Flexibility**: Handles individual beams and complete wall elements
- **Precision**: Multiple distribution modes with exact spacing control
- **Integration**: BOM generation, drill tooling, and shop drawing output
- **Interactivity**: Real-time graphical feedback and on-screen parameter controls
- **Extensibility**: XML catalog structure supports unlimited manufacturers and products

For routine fastening operations, the script dramatically reduces manual placement time while maintaining accuracy and consistency. For complex structural connections, the through-drilling capability and angle control provide the necessary precision for engineered timber joints.

---

**Document Information**
- **Script**: hsbFixingScrews.mcr
- **Documentation Version**: 2.0
- **Last Updated**: Based on script version 1.9 (May 2023)
- **Target Audience**: CAD operators, timber structure designers, fabrication technicians
- **Skill Level**: Intermediate (basic hsbCAD knowledge required)
