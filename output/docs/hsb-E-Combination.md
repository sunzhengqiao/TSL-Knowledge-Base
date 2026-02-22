# hsb-E-Combination

**Electrical Outlet/Junction Box Combination Tool**

## Overview

**hsb-E-Combination** is a sophisticated MEP (Mechanical/Electrical/Plumbing) tool designed to create and manage electrical installations within timber wall elements. It defines electrical outlet boxes, junction boxes, and electrical chases (cable routing pathways) with automatic CNC machining operations for wall studs and sheathing.

This script works in conjunction with **hsbInstallationPoint** to create complete electrical wiring systems with proper visualization in both plan and element views, automatic collision detection, and BOM (Bill of Materials) export capabilities.

---

## Pass 1: Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 18.13 (August 2025) |
| **Beams Required** | 0 |
| **Keywords** | Electrical, Installation, Element |
| **File State** | Production (1) |
| **DXA Output** | Enabled |
| **Implicit Insert** | Yes |

### Recent Version History

- **18.13** (Aug 2025): Add trigger to control CNC element tooling suppression
- **18.12** (Aug 2025): Add XML flag to suppress element CNC tools
- **18.11** (Nov 2024): Write TSL handle/ID to hardware notes
- **18.10** (Aug 2024): Check body operation on genbeam
- **18.9** (Apr 2024): Fix vertical alignment path calculation; Rubner catalog support
- **18.8** (Mar 2024): Create new wall reference after wall joins
- **18.7** (Jan 2024): Add strategy to mill by destroying all material
- **18.6** (Jan 2024): Add MaxWidthForClosedMill parameter

---

## Pass 2: Environment & Context

### Execution Environment

**Model Space Operation**: Creates 3D machining operations (drills, mills, slots) on wall studs and sheathing panels.

**Paper Space Visualization**: Generates electrical symbols and annotations in layout views for shop drawings and installation plans.

### Workflow Position

This tool operates within the **MEP Installation Workflow**:

1. **Prerequisite**: Wall element must be created first
2. **Parent Entity**: Requires **hsbInstallationPoint** (wirechase/conduit routing)
3. **Output**: Creates electrical box installations with CNC tooling paths
4. **Downstream**: Feeds into electrical BOM, shop drawings, and CNC export

### Dependencies

**Required Components**:
- `hsbInstallationPoint.mcr` - Parent wirechase entity
- `hsbElectraTsl.dll` - Dialog interface library
- Block definitions in `<hsbCompany>\Block\Electrical\` directory
- Optional XML settings: `<hsbCompany>\TSL\Settings\hsbInstallationPointSettings.xml`

**Compatible Elements**:
- ElementWall (stick-frame walls)
- Walls with multiple zones (interior/exterior sheathing)

---

## Pass 3: User Interface

### Insertion Workflow

#### **Step 1: Initial Selection**

When inserting hsb-E-Combination, the user is prompted:

```
"Select wirechase or element"
```

**Two insertion methods**:

**Method A - From Existing Wirechase** (Recommended):
1. Select an existing **hsbInstallationPoint** entity
2. Combination is automatically linked to wirechase
3. Inherits room assignment and elevation from parent

**Method B - Quick Insert on Wall**:
1. Click directly on a wall element (no wirechase selected)
2. System automatically creates default wirechase at click location
3. User prompted for catalog selection

#### **Step 2: Catalog Selection**

If no catalog entry specified (non-catalog insert), the **Combination Dialog** appears:

**Dialog Features**:
- Searchable list of combination types (outlets, switches, junction boxes)
- Preview of block symbols
- Height/elevation presets
- Property configuration

**Available Heights** (default):
- 300mm, 400mm, 500mm (low outlets)
- 1000mm, 1100mm, 1200mm (standard outlets/switches)
- 1900mm, 2000mm, 2200mm (high outlets)
- 2550mm, 2650mm (ceiling-level junction boxes)

#### **Step 3: Placement Configuration** (Catalog Mode)

When using catalog entry (e.g., command-line insertion), up to 3 prompts appear:

**Prompt 1 - Elevation** (if enabled):
```
"Enter '-' to insert at elevation 1100 Horizontal/Index 1
 Elevation [1100]"
```
- Enter elevation in mm
- Press Enter to accept default
- Enter `-` to skip to next prompt

**Prompt 2 - Alignment** (if enabled):
```
"Enter '-' to insert with alignment Horizontal/Index 1
 Select Alignment: [Horizontal/Vertical] <Horizontal>"
```
- **Horizontal**: Combination aligned horizontally (typical outlets)
- **Vertical**: Combination aligned vertically (stacked configuration)

**Prompt 3 - Position Index** (if enabled):
```
"Select position: [Left/Center/Right] or new position index <1>"
```

**Horizontal Alignment Options**:
- **Left** (1): Left-most position
- **Center**: Middle position
- **Right**: Right-most position
- **Number (1-9)**: Specific position index for complex arrays

**Vertical Alignment Options**:
- **Top**: Highest position
- **Center**: Middle height
- **Bottom**: Lowest position

### Properties Panel (OPM)

#### **General Category**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Elevation** | Double | 350mm | Height above floor level |
| **Alignment** | String | Horizontal | Horizontal or Vertical distribution |
| **Position Index** | Integer | 1-9 | Location relative to insertion point |
| **Zone** | Integer | 1-99 | Target zone index (99 = outermost) |
| **Tooling Shape** | String | by Installation | Drill shape selection |

**Tooling Shape Options**:
- **by Installation**: Inherits from installation point settings
- **Slotted Hole**: Elongated mill for rectangular boxes
- **Rectangular**: Square/rectangular milling
- **Custom shapes**: User-defined via XML configuration

#### **Geometry Category**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Depth** | Double | 70mm | Drilling/milling depth into wall |
| **Diameter (Height)** | Double | 68mm | Box diameter/height |
| **Width** | Double | 0mm | Box width (for rectangular) |
| **Offset Installations** | Double | 70mm | Spacing between multiple boxes |
| **Toolindex** | Integer | 1 | CNC tool number for machining |
| **Rotation Symbol** | Double | 0° | Symbol rotation angle |

#### **Geometry Horizontal Offset Category**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Horizontal Offset Installation** | Double | 70mm | Horizontal shift from insertion point |
| **Extra Tool Offset** | Yes/No | No | Create additional tool at offset location |
| **Extra Tool Opposite** | Yes/No | No | Mirror tool to opposite wall face |
| **Width** | Double | 0mm | Horizontal wirechase width override |

#### **Text Category**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Description 1** | String | "" | Primary label text |
| **Description 2** | String | "" | Secondary label text |
| **Text 1-5** | String | "" | Additional annotation fields |

#### **Block Category**

| Property | Type | Description |
|----------|------|-------------|
| **Block 1-5** | File Path | Block symbol definitions (DWG files) |

**Block Path Format**: Full path or filename to DWG block in `<hsbCompany>\Block\Electrical\` directory

Example: `C:\hsbCAD\Company\Block\Electrical\Outlet_Double.dwg`

### Context Menu Commands

Right-click on combination instance to access:

| Command | Function |
|---------|----------|
| **Edit** | Opens combination configuration dialog |
| **Supress CnC Element Tooling** | Toggle CNC machining on/off |
| **Export Settings** | Save current configuration to XML |
| **Import Settings** | Load configuration from XML |
| **Rotate Text 45°/90°/180°** | Adjust annotation rotation |
| **Create Annotation** | Generate standalone annotation entity |
| **Mask/Show Annotation** | Toggle annotation visibility |
| **Change Elevation** | Adjust installation height |

### Display Modes

The script supports multiple display representations:

1. **Standard Display**: Shows electrical symbols and tooling
2. **Electrical Display**: Isolated electrical symbol view (if "Electrical" display set defined)
3. **Plan View**: 2D symbols with annotations
4. **Element View**: 3D representation with elevation markers

---

## Pass 4: Parameter Semantics

### Core Installation Parameters

#### **Elevation (dElevation)**

**Business Meaning**: Vertical distance from floor slab to center of electrical box.

**Typical Values**:
- **300-500mm**: Low outlets (kitchen appliances, floor outlets)
- **1100mm**: Standard outlet height (AFF - Above Finished Floor)
- **1200mm**: Switch height standard
- **2000mm+**: High outlets, ceiling junction boxes

**Interaction**: Combined with floor elevation and floor thickness to calculate absolute Z-coordinate in 3D space.

#### **Tooling Shape (sShape)**

**Business Meaning**: Defines the milling/drilling profile for creating the electrical box cavity.

**Shape Options Explained**:

1. **by Installation**: Uses settings from parent hsbInstallationPoint
2. **Slotted Hole**: Elongated oval - for multi-gang boxes or conduit entry
3. **Rectangular**: Square or rectangular cavity - for standard electrical boxes
4. **Custom Shapes**: User-defined profiles via XML (e.g., "Type F70", "ALU profile")

**Custom Shape Configuration** (XML):
```xml
<lst nm="SlottedShape[]">
  <lst nm="Element">
    <str nm="Name" vl="Deep Junction Box"/>
    <dbl nm="Radius" ut="L" vl="75"/>
    <int nm="ToolIndex" vl="3"/>
  </lst>
</lst>
```

#### **Depth (dDepth)**

**Business Meaning**: How far the cavity extends into the wall assembly.

**Calculation Logic**:
- If `Depth = 0`: Automatically uses zone thickness (full penetration)
- If `Depth > 0`: Fixed depth from surface
- **Collision Detection**: Automatically extended if interfering with studs detected

**Safety Feature**: Prevents incomplete drilling that could cause installation failures.

#### **Zone (nRelativeZn)**

**Business Meaning**: Which sheathing layer receives the tooling.

**Zone Numbering**:
- **1**: Innermost zone (typically interior gypsum)
- **2**: Next layer (insulation or OSB)
- **99**: Outermost zone (exterior sheathing) - special code for automatic detection

**Typical Use Case**: Zone 1 for interior outlets, Zone 99 for exterior mounting boxes.

#### **Position Index (nPos)**

**Business Meaning**: Controls placement when multiple combinations share one installation point.

**Horizontal Alignment**:
- **1**: Left-most box
- **2, 3, 4...**: Sequential positions to the right
- **Odd numbers**: Standard positions
- **Even numbers**: Intermediate positions (VDE alignment mode)

**Vertical Alignment**:
- **1**: Top-most box
- **Higher numbers**: Descend downward

**VDE Alignment Mode** (German electrical code):
- When enabled, vertical combinations auto-increment from bottom upward
- Position indices are inverted when installation point is flipped

#### **Diameter & Width**

**Business Meaning**:
- **Diameter**: Height/vertical dimension of box (or circular drill diameter)
- **Width**: Horizontal dimension (only for rectangular shapes)

**Standard Box Sizes**:
- **68mm**: Standard German junction box (most common)
- **74mm**: Larger deep boxes
- **150x150mm**: Large junction/pull boxes

### Offset Parameters

#### **Horizontal Offset Installation (dHorizontalOffset)**

**Business Meaning**: Shifts the combination horizontally along the wall plane.

**Use Cases**:
1. **Cable Chase Routing**: Offset box to align with vertical conduit path
2. **Stud Avoidance**: Move box to avoid framing member interference
3. **Multi-Row Installations**: Create horizontally separated outlet rows

**Interaction with Extra Tool Offset**: When horizontal offset is set AND "Extra Tool Offset" = Yes, system creates drilling at both the installation point AND the offset location (for cable routing).

#### **Extra Tool Opposite (sOppositeTool)**

**Business Meaning**: Mirrors the entire tooling operation to the opposite wall face.

**Use Cases**:
- Back-to-back outlets in partition walls
- Through-wall junction boxes
- Double-sided electrical installations

**Tooling Behavior**: Creates identical drill/mill pattern on both sides with automatic depth adjustment.

#### **Width (Horizontal Wirechase) (dWidthHorWirechase)**

**Business Meaning**: Overrides the width of the horizontal cable chase (milled slot connecting outlets).

**Default Behavior**: Uses installation point's default chase width.

**When to Override**: Creating wider chases for multiple cable runs or larger conduit.

### Text & Annotation Parameters

#### **Description 1 & 2**

**Business Meaning**: Primary identification labels visible in plan and element views.

**Typical Content**:
- **Description 1**: Circuit number (e.g., "A1.2", "L3")
- **Description 2**: Function (e.g., "Kitchen Outlets", "Lighting Circuit")

**Display Behavior**: Automatically positioned relative to symbol with adjustable rotation.

#### **Text 1-5**

**Business Meaning**: Additional metadata fields for BOM export and detailed labeling.

**Typical Usage**:
- **Text 1**: Manufacturer part number
- **Text 2**: Device type (GFCI, Switch, Dimmer)
- **Text 3**: Load rating (15A, 20A)
- **Text 4**: Cable specification (12/2 NM-B)
- **Text 5**: Special notes

**Export Integration**: These fields are included in electrical BOM exports and can be mapped to custom ERP fields.

### Advanced Settings (XML Configuration)

#### **VDE Alignment**

**Business Meaning**: Enables German electrical standard (VDE) compliant vertical spacing.

**Behavior**: Combinations automatically distribute vertically with standard spacing between outlets (typically 200-300mm increments).

**Configuration**:
```xml
<int nm="VDEAlignment" vl="1"/>
```

#### **Relief Tooling (Collision Avoidance)**

When electrical box collides with wall studs, system automatically creates relief cuts:

**Parameters**:
- **CombinationReliefDepth**: Depth of relief cut on stud
- **CombinationReliefDepthExposed**: Separate depth for exterior walls
- **CombinationReliefHeight**: Height of relief notch
- **CombinationReliefMode**: Strategy (0=notch, 1=full removal)

**Business Logic**: Prevents electrical box interference with structural framing while maintaining stud integrity.

#### **Milling Strategy**

**CombinationMaxClosedMilling**: Maximum width/height for closed-contour milling.

**Purpose**: Large rectangular mills leave a small "peninsula" strip to prevent cutout from falling into wall cavity during CNC machining (helps with dust extraction).

**Example**:
```xml
<dbl nm="CombinationMaxClosedMilling" ut="L" vl="100"/>
```
- If Width or Height < 100mm: Closed contour (complete cutout)
- If Width or Height ≥ 100mm: Open contour (small holding strip remains)

---

## Pass 5: Logic Flow & User Workflow

### Complete User Workflow

#### **Scenario 1: Standard Outlet Installation**

**Goal**: Install standard 1100mm height outlet in residential wall.

**Steps**:

1. **Preparation**:
   - Wall element already created with studs and sheathing
   - Installation point (wirechase) created at desired location

2. **Insert Combination**:
   ```
   Command: hsb-E-Combination
   Select wirechase or element: [Select hsbInstallationPoint]
   Enter elevation [1100]: 1100
   Select Alignment [Horizontal/Vertical] <Horizontal>: H
   Select position [Left/Center/Right]: Left
   ```

3. **Result**:
   - Combination inserted at 1100mm height
   - Position 1 (left-most)
   - Horizontal alignment
   - Inherits catalog settings (diameter 68mm, depth 70mm)

4. **Automatic Operations**:
   - System calculates target zone (interior gypsum)
   - Creates 68mm diameter drill through gypsum layer
   - Checks for stud interference
   - If stud collision detected: creates relief notch automatically
   - Displays electrical symbol in plan view
   - Adds elevation marker in element view

5. **Verification**:
   - Check element view: 3D drill hole visible
   - Check plan view: Symbol shows at correct wall position
   - Review Properties: Confirm elevation, depth, zone

#### **Scenario 2: Multi-Outlet Array (3 Outlets Horizontal)**

**Goal**: Create kitchen counter triple outlet at 1100mm.

**Steps**:

1. **Insert First Outlet** (Main):
   ```
   Insert combination with catalog "Kitchen_Outlet"
   Position Index: 1 (Left)
   ```

2. **Add Second Outlet**:
   - Use same installation point
   - Insert another combination
   - Position Index: 3 (Center-right)
   - System automatically spaces based on "Offset Installations" property (70mm default)

3. **Add Third Outlet**:
   - Position Index: 5 (Right-most)

4. **Result**:
   - Three equally spaced outlets
   - Shared horizontal cable chase automatically generated
   - All linked to same installation point

5. **Adjustment** (if needed):
   - Select any combination
   - Modify "Offset Installations" to 100mm
   - All three outlets re-space automatically

#### **Scenario 3: Back-to-Back Outlets (Opposite Faces)**

**Goal**: Install outlets on both sides of partition wall.

**Steps**:

1. **Insert First Side**:
   - Standard combination on icon side
   - Elevation: 1100mm
   - Zone: 1 (interior)

2. **Create Opposite Side**:
   - Select combination
   - Properties Panel → **Extra Tool Opposite**: Yes
   - System creates:
     - Drill on opposite wall face
     - Adjusted depth (accounts for wall thickness)
     - Mirrored symbol placement

3. **Manual Alternative**:
   - Insert second combination
   - Use installation point's "Flip Side" command
   - Insert combination on opposite side
   - Both combinations share same cable chase

#### **Scenario 4: Custom Rectangular Junction Box**

**Goal**: Install 150x150mm ceiling junction box for lighting circuit.

**Steps**:

1. **Configure Properties**:
   - Elevation: 2650mm (near ceiling)
   - Tooling Shape: Rectangular
   - Diameter (Height): 150mm
   - Width: 150mm
   - Depth: 75mm
   - Zone: 1

2. **Insert**:
   - Select wirechase
   - Place combination

3. **Milling Behavior**:
   - System checks 150mm against **CombinationMaxClosedMilling** setting
   - If 150 > MaxClosedMilling (e.g., 100mm):
     - Creates open-contour mill with small peninsula strip
     - Prevents large cutout from falling during CNC
   - If 150 ≤ MaxClosedMilling:
     - Creates fully closed contour

4. **CNC Export**:
   - Rectangular mill path exported with Tool Index
   - Corner radiusing applied automatically
   - Strip dimensions calculated for manual removal

#### **Scenario 5: Offset Installation for Cable Routing**

**Goal**: Offset outlet horizontally to align with vertical conduit chase.

**Steps**:

1. **Set Horizontal Offset**:
   - Horizontal Offset Installation: 200mm

2. **Enable Extra Tooling**:
   - Extra Tool Offset: Yes

3. **Result**:
   - Main box drilled at offset location (200mm from installation point)
   - Additional drill at installation point for cable entry
   - Horizontal slot mill connecting both drills (automatic cable chase)

4. **Use Case**: Aligning outlet with vertical conduit run hidden in wall cavity.

### Conditional Logic Branches

#### **Branch 1: Shape-Based Tooling**

```
IF Tooling Shape = "by Installation":
    → Use parent wirechase settings
    → Inherit diameter, depth from installation point
    → Support multiple position indices (1-9)

ELSE IF Tooling Shape = "Slotted Hole":
    → Create elongated oval mill
    → Limited to 3 position indices (Left, Center, Right)
    → Apply slotted shape radius from XML
    → Add peninsula strip if length > MaxClosedMilling

ELSE IF Tooling Shape = "Rectangular":
    → Create rectangular mill
    → Use Diameter (Height) and Width properties
    → Limited to 3 position indices
    → Apply corner rounding
    → Add peninsula strip if dimensions > MaxClosedMilling
```

#### **Branch 2: Collision Detection & Relief**

```
DURING Tooling Application:
    1. Collect all beams (studs) and sheets in wall zone
    2. FOR EACH stud:
        IF drill/mill intersects stud body:
            → Calculate interference depth
            → IF ReliefMode = 0 (notch):
                → Create notch beamcut on stud
                → Depth = ReliefDepth (or ReliefDepthExposed if exterior)
                → Height = ReliefHeight + ReliefHeightExtension
            → ELSE IF ReliefMode = 1 (full removal):
                → Extend drill depth through entire stud

    3. FOR EACH sheet (if not BeamOnly mode):
        IF drill/mill intersects sheet:
            → Extend depth to penetrate sheet
            → Display alert if steel plate detected
```

#### **Branch 3: Annotation Creation**

```
BASED ON CreateAnnotation Setting:

IF CreateAnnotation = 0:
    → No automatic annotation created
    → User must manually create via context menu

ELSE IF CreateAnnotation = 1:
    → Create separate annotation entity (fixed position)
    → Position: Offset from symbol by dPlanAnnotationOffset
    → Content: Description 1 + Description 2 + Elevation

ELSE IF CreateAnnotation = 2:
    → Create annotation linked to additional grip point
    → User can drag annotation independently
    → Grip index stored in _Map for persistence
```

#### **Branch 4: VDE Vertical Distribution**

```
IF VDEAlignment = TRUE AND Alignment = "Vertical":
    WHEN Adding New Combination:
        1. Count existing combinations on same installation point
        2. Calculate next position index:
            → IF Direction = "Bottom": Index = 1
            → IF Direction = "Top": Index = (ExistingCount × 2) - 1
        3. Auto-increment position from bottom upward

    WHEN Installation Point Flips Side:
        → Invert all position indices
        → Maintain relative spacing
```

#### **Branch 5: Opposite Side Tooling**

```
IF Extra Tool Opposite = YES:
    1. Calculate opposite wall face location
    2. Mirror tool geometry across wall centerline
    3. Adjust depth:
        → OppositeDepth = WallThickness - OriginalDepth
    4. Apply same relief logic on opposite side
    5. Create mirrored symbol (different color: magenta vs. cyan)
```

### Special Modes

#### **Mode -1: Dummy/Catalog Mode**

**Purpose**: Used internally for catalog preview and property definition.

**Behavior**:
- Defines properties only
- No geometry calculated
- Returns immediately (no execution)

**Triggered By**: Internal catalog system calls.

#### **Mode 0: Standard Combination Mode** (Default)

**Purpose**: Full functional execution.

**Behavior**:
- Complete tooling generation
- Symbol display
- Annotation creation
- CNC export

#### **Mode 1: Annotation Mode**

**Purpose**: Creates standalone annotation entity (no tooling).

**Behavior**:
- No drills or mills
- Only text and labels
- Linked to parent combination via Map

---

## Pass 6: User Guide

### Quick Start Guide

#### **Installation: Basic Outlet**

**Prerequisites**:
- Wall element created
- Installation point (wirechase) placed on wall

**Steps**:

1. **Launch Tool**:
   - Command: `hsb-E-Combination`
   - Or: Insert menu → Electrical → Combination

2. **Select Parent**:
   - Click on existing **hsbInstallationPoint** (wirechase)
   - Or: Click directly on wall (auto-creates wirechase)

3. **Choose Catalog** (if dialog appears):
   - Browse combination types
   - Select "Standard Outlet 1100mm"
   - Click OK

4. **Configure Position** (if prompted):
   - Elevation: 1100mm (standard outlet height)
   - Alignment: Horizontal
   - Position: Left

5. **Verify Result**:
   - Plan View: Electrical symbol appears
   - Element View: 3D drill hole visible
   - Properties Panel: Shows all settings

#### **Editing Existing Combination**

**Method 1: Context Menu**:
1. Right-click combination
2. Select "Edit"
3. Modify settings in dialog
4. Click OK

**Method 2: Properties Panel (OPM)**:
1. Select combination
2. Open Properties Panel (Ctrl+1)
3. Modify any property
4. Press Enter to apply
5. Combination recalculates automatically

**Method 3: Double-Click**:
1. Double-click combination entity
2. Edit dialog appears
3. Make changes
4. Click OK

### Common Use Cases

#### **Use Case 1: Kitchen Counter Outlets**

**Scenario**: Install 3 outlets spaced evenly above kitchen counter.

**Solution**:

1. Create installation point at desired location (1100mm height)
2. Insert first combination:
   - Catalog: "Kitchen Outlet"
   - Position Index: 1 (Left)
3. Insert second combination:
   - Same installation point
   - Position Index: 3 (Center-right)
4. Insert third combination:
   - Position Index: 5 (Right)
5. Adjust spacing:
   - Select any combination
   - Set "Offset Installations" to 150mm (if wider spacing needed)

**Result**: Three outlets with horizontal cable chase connecting them.

#### **Use Case 2: Bathroom GFCI Circuit**

**Scenario**: Install GFCI outlet with specific circuit labeling.

**Solution**:

1. Insert combination with catalog "GFCI Outlet 1100mm"
2. Configure properties:
   - Description 1: "Bath_GFCI_A2"
   - Description 2: "Ground Fault Protected"
   - Text 1: "Leviton 5280"
   - Text 2: "20A GFCI"
   - Text 3: "12/2 NM-B"
3. Verify zone = 1 (interior surface)
4. Check depth = 70mm (standard)

**Result**: Properly labeled GFCI outlet with complete BOM data.

#### **Use Case 3: Light Switch at Door**

**Scenario**: Install switch 1200mm height near door opening.

**Solution**:

1. Create installation point at door side (1200mm)
2. Insert combination:
   - Catalog: "Switch Single Pole"
   - Elevation: 1200mm
   - Zone: 1
3. If interference with door framing:
   - System auto-creates relief notch on king stud
   - Verify relief depth in properties

**Result**: Switch with automatic stud clearance.

#### **Use Case 4: Ceiling Junction Box for Lighting**

**Scenario**: Install junction box in ceiling for light fixture.

**Solution**:

1. Create vertical wall or ceiling element
2. Place installation point at ceiling location
3. Insert combination:
   - Elevation: 2650mm (near top of wall)
   - Tooling Shape: Rectangular
   - Diameter (Height): 100mm
   - Width: 100mm
   - Depth: 60mm
   - Zone: 1 (interior ceiling)
4. System creates rectangular mill with rounded corners

**Result**: Ceiling junction box ready for fixture installation.

#### **Use Case 5: Exterior Wall Outlet**

**Scenario**: Install weatherproof outlet on exterior wall face.

**Solution**:

1. Create installation point on exterior wall
2. Insert combination:
   - Zone: 99 (auto-detects outermost zone)
   - Depth: 50mm (surface mount box)
   - Extra Tool Opposite: No
3. System drills through exterior sheathing only

**Special Consideration**: Verify wall has exterior zone defined (OSB, plywood, or siding).

#### **Use Case 6: Cable Routing with Offset**

**Scenario**: Outlet needs horizontal offset to align with vertical conduit chase.

**Solution**:

1. Insert combination with standard settings
2. Modify properties:
   - Horizontal Offset Installation: 200mm
   - Extra Tool Offset: Yes
   - Width (Horizontal Wirechase): 40mm
3. System creates:
   - Drill at offset location (outlet box)
   - Drill at installation point (cable entry)
   - Horizontal slot connecting both (cable chase)

**Result**: Outlet aligned with vertical conduit run.

### Advanced Features

#### **Custom Electrical Symbols (Block Management)**

**Defining Custom Blocks**:

1. Create DWG block file:
   - Origin at box center
   - Size: 200mm × 200mm recommended
   - Include symbol geometry and attributes

2. Save block to: `<hsbCompany>\Block\Electrical\CustomSymbol.dwg`

3. Configure combination properties:
   - Block 1: Path to custom block DWG
   - Block 2-5: Additional blocks for multi-symbol combinations

4. System automatically:
   - Scales block to match text height
   - Aligns block based on wall orientation
   - Applies rotation from "Rotation Symbol" property

**Block Attribute Overrides**:

Create special block attribute `hsb-E-BlockData` to override:
- Drill diameter
- Drill depth
- Text visibility
- Annotation display

#### **Export Overrides for BOM**

**Purpose**: Customize how combinations appear in electrical parts list.

**Configuration**:

1. Create file: `<hsbWallDetail>\CombinationExportOverrides.xml`

2. Define override mapping:
```xml
<Hsb_Map>
  <lst nm="Override[]">
    <lst nm="Item">
      <str nm="SourceDescription" vl="Standard Outlet"/>
      <str nm="TargetPartNumber" vl="LEV-5320"/>
      <str nm="TargetDescription" vl="Leviton 15A Duplex Outlet"/>
      <dbl nm="UnitCost" vl="2.50"/>
    </lst>
  </lst>
</Hsb_Map>
```

3. Use context menu:
   - Right-click combination
   - "Export Settings" → Saves current settings
   - "Import Settings" → Loads settings

**Result**: BOM exports use custom part numbers and descriptions.

#### **VDE Alignment (German Electrical Standard)**

**What is VDE Alignment?**

German electrical code (VDE) requires specific vertical spacing between outlets in multi-outlet installations.

**Enabling VDE Mode**:

1. Edit settings file: `<hsbCompany>\TSL\Settings\hsbInstallationPointSettings.xml`

2. Add VDE flag:
```xml
<int nm="VDEAlignment" vl="1"/>
```

3. When inserting vertical combinations:
   - Position Index auto-increments from bottom upward
   - Spacing automatically applied per VDE standards
   - Flipping side inverts sequence

**Typical VDE Spacing**: 200-300mm vertical separation between outlet centers.

#### **Collision Relief Configuration**

**When to Use**: Electrical boxes frequently interfere with wall studs.

**Configuration Options**:

**Option 1: Notch Relief** (Default):
```xml
<map nm="Combination\Relief">
  <int nm="Mode" vl="0"/>
  <dbl nm="Height" ut="L" vl="100"/>
  <dbl nm="Depth" ut="L" vl="70"/>
  <dbl nm="DepthExposed" ut="L" vl="50"/>
</map>
```
- Creates shallow notch on stud
- Maintains stud structural integrity
- Suitable for non-load-bearing walls

**Option 2: Full Penetration**:
```xml
<int nm="Mode" vl="1"/>
```
- Drills completely through stud
- Use only when approved by engineer
- Typical for small diameter (≤68mm) in 2×4 studs

**Interior vs. Exterior**:
- `Depth`: Interior wall relief depth
- `DepthExposed`: Exterior wall relief (typically shallower)

#### **Suppressing CNC Tooling**

**Purpose**: Temporarily disable CNC operations without deleting combinations.

**Method 1: Global Setting**:
1. Right-click any combination
2. Select "Supress CnC Element Tooling"
3. Choose "Yes"
4. All combinations stop creating CNC tools

**Method 2: XML Configuration**:
```xml
<int nm="SupressCnCElementTooling" vl="1"/>
```

**Use Cases**:
- Design phase (no machining needed yet)
- Manual installation (no CNC)
- Verification before CNC export

### Troubleshooting

#### **Problem: Combination Deletes Automatically After Insert**

**Cause**: No valid installation point or block definitions found.

**Solutions**:
1. Ensure **hsbInstallationPoint** exists before inserting combination
2. Verify block paths in properties point to valid DWG files
3. Check `<hsbCompany>\Block\Electrical\` directory contains block files
4. If using custom blocks, verify Block 1-5 properties are not empty

#### **Problem: Drill/Mill Not Appearing in Element**

**Cause**: Depth set to zero or zone mismatch.

**Solutions**:
1. Check **Depth** property:
   - If Depth = 0: System uses zone thickness (may be auto-calculated)
   - If Depth > 0: Fixed depth should work
2. Verify **Zone** property:
   - Ensure zone exists in wall (check wall zoning)
   - Zone 99 = outermost zone (auto-detect)
3. Check **Supress CnC Element Tooling** is OFF
4. Recalculate element (right-click element → Recalculate)

#### **Problem: Symbol Not Visible in Plan View**

**Cause**: Block path invalid or display mode incorrect.

**Solutions**:
1. Verify **Block 1** property contains valid path
2. Check display mode:
   - Use "Standard" or "Electrical" display set
   - Avoid "Simplified" views
3. Confirm text height > 0 (symbols scale with text)
4. Check layer visibility (combinations draw on "I" layer)

#### **Problem: Annotation Text Overlaps Symbol**

**Cause**: Annotation offset too small.

**Solutions**:
1. Edit settings XML:
```xml
<map nm="Combination\Text">
  <dbl nm="PlanAnnotationOffset" ut="L" vl="300"/>
</map>
```
2. Or use **Rotation Symbol** property to rotate symbol away from text
3. Or use context menu "Rotate Text 90°" to adjust annotation angle

#### **Problem: Collision with Stud Not Creating Relief**

**Cause**: Relief settings disabled or depth too small.

**Solutions**:
1. Verify relief is enabled in settings:
```xml
<dbl nm="CombinationReliefDepth" ut="L" vl="70"/>
```
2. Ensure **ReliefDepth** > 0
3. Check collision detection:
   - System only creates relief if drill actually intersects stud body
   - Use element view to verify interference
4. Force recalculation (edit any property and press Enter)

#### **Problem: Opposite Side Tool Not Appearing**

**Cause**: Wall has only one zone or depth calculation error.

**Solutions**:
1. Verify wall has zones on both sides (interior and exterior sheathing)
2. Check total wall thickness:
   - Opposite Depth = Wall Thickness - Original Depth
   - If calculation results in negative depth, no opposite tool created
3. Ensure **Extra Tool Opposite** = Yes in properties

#### **Problem: BOM Export Shows Incorrect Part Numbers**

**Cause**: Export overrides not configured or missing data.

**Solutions**:
1. Check **Description 1** and **Description 2** are populated
2. Verify **Text 1-5** fields contain required BOM data
3. Configure export overrides XML if custom mapping needed
4. Use context menu "Export Settings" to save correct configuration
5. Reload settings with "Import Settings"

### Best Practices

#### **Modeling Strategy**

1. **Create Wirechase First**: Always place **hsbInstallationPoint** before adding combinations
2. **Use Catalogs**: Define standard combinations in catalog for consistency
3. **Room Assignment**: Ensure walls are assigned to rooms for proper floor elevation
4. **Zone Planning**: Design wall zoning before placing electrical components

#### **Naming Conventions**

1. **Description 1**: Use circuit identifier format (e.g., "Panel_A_Circuit_3")
2. **Description 2**: Use functional description (e.g., "Kitchen Outlets")
3. **Text Fields**: Reserve for BOM data (part numbers, specifications)

#### **Performance Optimization**

1. **Limit Block Complexity**: Keep electrical symbols simple (low vertex count)
2. **Use Standard Catalogs**: Pre-configured combinations calculate faster
3. **Batch Insertion**: Insert multiple combinations before recalculating element
4. **Suppress Tooling During Design**: Enable CNC tooling only for final export

#### **Quality Control**

1. **Verify Elevations**: Check all combinations relative to floor level
2. **Collision Review**: Inspect relief cuts on studs (element view)
3. **BOM Validation**: Export electrical list and verify part numbers
4. **CNC Preview**: Review tooling paths before export to machine

---

## Technical Notes

### Required File Structure

```
<hsbCompany>\
├── Block\
│   └── Electrical\
│       ├── Outlet_Single.dwg
│       ├── Outlet_Double.dwg
│       ├── Switch_Single.dwg
│       ├── Switch_Triple.dwg
│       ├── Junction_Box.dwg
│       └── [Custom symbols...]
│
└── TSL\
    └── Settings\
        └── hsbInstallationPointSettings.xml
```

### XML Settings File Structure

**Location**: `<hsbCompany>\TSL\Settings\hsbInstallationPointSettings.xml`

**Complete Example**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- VDE Alignment -->
  <int nm="VDEAlignment" vl="1"/>

  <!-- Annotation Settings -->
  <int nm="CreateAnnotation" vl="1"/>
  <int nm="CreateAnnotationElement" vl="1"/>
  <int nm="DrawDrillGuideLine" vl="0"/>
  <int nm="CombinationDrawFilledSymbol" vl="1"/>
  <int nm="CombinationDrawElevationElementView" vl="1"/>

  <!-- Milling Strategy -->
  <dbl nm="CombinationStandardDiameter" ut="L" vl="68"/>
  <dbl nm="CombinationMaxClosedMilling" ut="L" vl="100"/>

  <!-- Suppress CNC -->
  <int nm="SupressCnCElementTooling" vl="0"/>

  <!-- Relief Settings -->
  <map nm="Combination">
    <map nm="Relief">
      <int nm="Mode" vl="0"/>
      <dbl nm="Height" ut="L" vl="100"/>
      <dbl nm="HeightExtension" ut="L" vl="20"/>
      <dbl nm="Depth" ut="L" vl="70"/>
      <dbl nm="DepthExposed" ut="L" vl="50"/>
      <int nm="BeamOnly" vl="0"/>
    </map>

    <map nm="Text">
      <int nm="Hide" vl="0"/>
      <int nm="Color" vl="1"/>
      <dbl nm="TextHeight" ut="L" vl="100"/>
      <dbl nm="Angle" ut="A" vl="0"/>
      <str nm="DimStyle" vl="Standard"/>
      <dbl nm="PlanAnnotationOffset" ut="L" vl="200"/>
    </map>
  </map>

  <!-- Custom Slotted Shapes -->
  <map nm="SlottedShape[]">
    <map nm="Element">
      <str nm="Name" vl="Deep Box 75"/>
      <dbl nm="Radius" ut="L" vl="75"/>
      <int nm="ToolIndex" vl="3"/>
    </map>
  </map>

  <!-- Installation Point Settings -->
  <map nm="InstallationPoint">
    <int nm="UseGenbeamReference" vl="0"/>
  </map>

  <!-- Insertion Prompts -->
  <map nm="OnInsertCombination">
    <int nm="PromptElevation" vl="1"/>
    <int nm="PromptOrientation" vl="1"/>
    <int nm="PromptAlignment" vl="1"/>
  </map>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### DLL Dependencies

**hsbElectraTsl.dll**:
- Location: `<hsbInstall>\utilities\electraTsl\hsbElectraTsl.dll`
- Purpose: Provides combination dialog interface
- Required Methods:
  - `ShowCombinationDialog`: Main configuration dialog
  - `DefineOverride`: Export override definition
  - `FindOverride`: BOM export mapping

**TslUtilities.dll**:
- Location: `<hsbInstall>\Utilities\DialogService\TslUtilities.dll`
- Purpose: Standard UI dialogs
- Used For: Yes/No prompts, option selection, text input

### Coordinate System

**Reference Point (_Pt0)**:
- Located at installation point position
- Height = Floor Elevation + User-specified Elevation
- Horizontal position inherited from parent wirechase

**Zone Coordinate System**:
- Z-axis perpendicular to wall plane
- X-axis along wall length
- Y-axis parallel to wall height (vertical)

**Drill Direction**:
- Always perpendicular to zone surface
- Depth measured from zone exterior face inward

### CNC Export Data

Combinations export the following CNC operations:

1. **Drill Operations** (circular):
   - Center point (X, Y, Z)
   - Diameter
   - Depth
   - Tool index

2. **Mill Operations** (rectangular/slotted):
   - Contour polyline (2D profile)
   - Depth (extrusion distance)
   - Tool index
   - Corner radius

3. **Relief Cuts** (notches on studs):
   - Beam reference
   - Notch profile (rectangular)
   - Depth

**Export Format**: Standard hsbCAD CNC XML or proprietary machine format.

---

## Related Scripts

| Script | Relationship | Purpose |
|--------|--------------|---------|
| **hsbInstallationPoint** | Parent | Wirechase/conduit routing, room assignment |
| **hsb-E-BlockData** | Companion | Block attribute override data |
| **HSB_G-BillOfMaterial** | Consumer | Extracts electrical BOM from combinations |
| **HSB_D-Element** | Display | Element view rendering |
| **HSB_D-Sheet** | Display | Shop drawing generation |
| **instaCell** | Related | Cellular/structured wiring (alternative system) |
| **instaCombination** | Related | Alternative combination system |
| **mepItem** | Related | General MEP item placement |

---

## Summary

**hsb-E-Combination** is a comprehensive electrical installation tool that bridges design and manufacturing:

- **For Designers**: Intuitive placement of outlets, switches, and junction boxes with automatic collision avoidance
- **For Detailers**: Complete BOM data with customizable part numbers and descriptions
- **For Fabricators**: Precise CNC tooling paths for automated drilling and milling
- **For Installers**: Clear shop drawings with elevations and circuit identification

The script's sophisticated logic handles complex scenarios (multi-outlet arrays, back-to-back installations, offset routing) while maintaining simplicity for standard use cases. Integration with hsbInstallationPoint provides a complete MEP workflow from design through production.

---

**Version**: 18.13 (August 2025)
**Category**: MEP / Electrical / Element Tools
**Target Users**: Timber construction designers, electrical engineers, CAD operators
**Complexity Level**: Intermediate to Advanced
