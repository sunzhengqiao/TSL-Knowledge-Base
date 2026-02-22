# Hilti-Verankerung

**Hilti Wood Connector Placement System for Timber Frame Structures**

---

## Overview

**Hilti-Verankerung** is a comprehensive TSL script for placing Hilti Stexon wood connector systems (HCW, HCWL) in timber frame wall constructions. This tool automates the placement, drilling, milling, and hardware generation for Hilti wood-to-concrete/wood connections, supporting multiple placement modes and ensuring compliance with European Technical Assessment ETA-21/0357.

### Key Capabilities

- **Multiple Connector Types**: HCW (ø37mm), HCWL (ø42mm), HCW-P, and custom configurations
- **Intelligent Placement Modes**: Stud-based, plate-based, element-based, and plate-joist intersection modes
- **Automatic Tooling**: Generates drilling, milling, and housing operations based on connector type
- **Collision Detection**: Prevents overlapping connectors and automatically resolves conflicts
- **Visual Representation**: Displays block representations of connectors in model space
- **BOM Integration**: Automatically generates hardware components for material takeoff
- **Export Functionality**: Exports all Hilti connectors to .dxx file format for fabrication
- **Catalog System**: Pre-configured settings accessible via right-click menu
- **Company-Specific Variants**: Special configurations for Baufritz workflows

---

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Environment** | Model Space |
| **Version** | 2.17 (2025-07-09) |
| **Required Beams** | 0 (selectable during insertion) |
| **Supported Elements** | ElementWall (stick frame walls) |
| **Keywords** | Hilti, Stexon, HCW, HCWL, wood connector |
| **Baufritz Support** | Yes (specialized workflow) |

---

## Prerequisites

Before using this script, ensure the following conditions are met:

### Required Model Elements

1. **Wall Elements**: At least one `ElementWall` (stick frame wall) must exist in the model
2. **Horizontal Plates**: Bottom or top plates of walls must be present
3. **Optional Studs**: Vertical studs can be selected for stud-mounted placement mode
4. **Joists (Optional)**: For plate-joist intersection mode, perpendicular joists/beams must intersect plates

### File Dependencies

| File Type | Location | Purpose |
|-----------|----------|---------|
| **HCW.dwg** | `[Company Path]\Block\` | Block representation for HCW connector |
| **HCWL.dwg** | `[Company Path]\Block\` | Block representation for HCWL connector |
| **HSW M12.dwg** | `[Company Path]\Block\` | Block representation for hanger bolt (Stockschraube) |

### Technical Requirements

| Component | Minimum Specification |
|-----------|----------------------|
| **Plate Thickness** | 45mm minimum (timber member receiving drilling) |
| **Plate Width** | 100mm minimum (stud mode), 80mm minimum (stud-less mode) |
| **Plate Length** | 400mm minimum (for HCW, HCW-P types) |
| **Edge Distance** | Per ETA-21/0357 requirements (not enforced by script) |

### Regulatory Compliance

**IMPORTANT**: Users must refer to the **European Technical Assessment ETA-21/0357 (2025/01/31)** titled "HCW Wood connector ETA 21-0357" for:
- Load-carrying capacity values
- Minimum cross-section requirements
- Edge distance requirements
- Installation specifications

The script does **not enforce** edge distance constraints (removed in v2.11) - users are responsible for compliance.

---

## Parameter Reference

### Version Category

Controls the connector type and automatically sets related parameters.

#### Version (PropString, Index 0)

| Available Options | Description |
|-------------------|-------------|
| **Custom** | User-defined drilling parameters, no automatic settings |
| **HCW** | Standard Hilti connector, ø37mm, depth 250mm |
| **HCWL** | Long connector with L-bracket, ø42mm, depth 250mm |
| **HCW-P** | HCW variant (same tooling as HCW) |
| **Holzdolle*** | Baufritz-specific variant, ø34mm |
| **HCWL+K*** | Baufritz-specific HCWL variant, ø42mm |

*Available only when project is configured for Baufritz

**Behavior**:
- Selecting a predefined version locks the diameter property
- Switching to "Custom" unlocks diameter and depth for manual input
- For Baufritz projects, changing diameter automatically updates version

---

### Drill Category

Primary drilling parameters for the connector socket.

#### Diameter (PropDouble, Index 0)

- **Default**: 30mm
- **Unit**: Length (mm)
- **Range**: Any positive value
- **Auto-Set Values**:
  - HCW / HCW-P: 37mm (locked)
  - HCWL / HCWL+K: 42mm (locked)
  - Holzdolle: 34mm (locked)
  - Custom: User-defined (unlocked)

**Property Interaction**:
- Read-only when predefined version is selected
- For Baufritz: Always active, changing diameter switches version
- Diameter changes trigger version re-evaluation

#### Depth (PropDouble, Index 1)

- **Default**: 250mm (standard), 100mm (Baufritz)
- **Unit**: Length (mm)
- **Range**: Minimum 70mm for HCW
- **Description**: Drilling depth into the plate from bottom surface

**Important**: This is the depth of the main connector socket, not the fastener drill hole.

#### Tooling Type HCWL (PropString, Index 5)

- **Options**: "House" (slot milling), "Drill" (circular drilling)
- **Default**: House
- **Visibility**: Only shown when HCWL or HCWL+K version is selected
- **Description**:
  - **House**: Creates a slotted rectangular pocket for L-bracket insertion (recommended)
  - **Drill**: Creates a circular drill hole only

**Technical Note**: HCWL typically requires both a slotted housing (from below) and an upper 75mm drill hole for L-bracket installation.

---

### Second Drill Category

Additional drilling for sinkhole or stud penetration.

#### Diameter (PropDouble, Index 7)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Behavior**:
  - If value > primary diameter → Creates sinkhole at plate surface
  - If value ≤ primary diameter → Creates stud drilling when drill center is inside stud

**Use Case**: For creating recessed bolt heads or for drilling through studs when connectors are placed at stud locations.

#### Depth (PropDouble, Index 8)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Description**: Depth of secondary drill operation

---

### Alignment Category

Controls connector positioning and orientation.

#### Z-Offset from Axis (PropDouble, Index 2)

- **Default**: 0mm
- **Unit**: Length (mm)
- **Description**: Offset along the wall's Z-axis (perpendicular to wall length) from the calculated center point
- **Positive**: Shifts connector toward positive Z direction
- **Negative**: Shifts connector toward negative Z direction

**Reference Point**: The "axis" is the wall's centerline at the plate location. For HCWL, this determines the X-distance shown in element views.

#### Edge Offset X (PropDouble, Index 3)

- **Default**: 0mm
- **Unit**: Length (mm)
- **Applies To**: Stud mode only (ignored when no stud is selected)
- **Description**: Distance from stud edge to connector center
- **For HCWL**: Automatically set to 8mm in Baufritz workflows to achieve flush mounting

**Important**: This property is relevant only when the connector is attached to a stud. For plate-only placement, use Z-Offset instead.

#### Rotation (PropDouble, Index 4)

- **Default**: 0°
- **Unit**: Angle (degrees)
- **Description**: Rotation angle of the drilling/tooling operation around its axis
- **Standard Projects**: Adds 90° offset internally
- **Baufritz Projects**: Uses value directly (no offset)

**Use Case**: Adjust for non-standard orientations or when drilling direction needs modification.

---

### Milling Category

Parameters for milling operations at plates and studs.

#### Width (PropDouble, Index 5)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Description**: Width of milling operation at the bottom surface of the plate
- **Purpose**: Creates a recessed area for connector hardware

#### Depth (PropDouble, Index 6)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Description**: Depth of milling operation at the bottom surface of the plate
- **Purpose**: Determines how deep the recessed area extends into the plate

**Note**: Plate milling is separate from stud milling (see below).

#### Milling Depth Stud (PropDouble, Index 9)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Applies To**: HCWL connectors with attached studs
- **Description**: Depth of milling operation into the stud face
- **Purpose**: Creates clearance for HCWL L-bracket at stud location

**Added**: Version 2.12 (HSB-23567)

#### Milling Width Stud (PropDouble, Index 10)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Applies To**: HCWL connectors with attached studs
- **Description**: Width of milling area on stud face

**Added**: Version 2.14 (HSB-23993)

#### Milling Height Stud (PropDouble, Index 11)

- **Default**: 0mm (disabled)
- **Unit**: Length (mm)
- **Applies To**: HCWL connectors with attached studs
- **Description**: Height of milling area on stud face

**Added**: Version 2.14 (HSB-23993)

#### Milling Offset Stud (PropDouble, Index 12)

- **Default**: 0mm
- **Unit**: Length (mm)
- **Applies To**: HCWL connectors with attached studs
- **Description**: Vertical offset from the bottom of the stud to the start of the milling operation
- **Purpose**: Allows precise positioning of stud milling relative to stud bottom face

**Added**: Version 2.15 (HSB-24083)

**Technical Note**: Stud milling starts from the bottom of the stud and extends upward by the milling height value, offset by this parameter.

---

### General Category

User-defined text and display settings.

#### Description (PropString, Index 1)

- **Default**: Empty string
- **Type**: Text input
- **Description**: Custom text label displayed in element views
- **Purpose**: Allows users to add notes, identifiers, or specifications to individual connectors

**Display**: Text appears in element view at the connector location with 50mm text height.

#### Text Description at Zones (PropString, Index 2)

- **Default**: "0"
- **Type**: Text input (semicolon-separated list)
- **Format**: "1;3;5" (zone numbers)
- **Description**: Specifies which element zones should display the description text
- **Purpose**: Control visibility of connector labels in specific viewing zones

**Example**: "1;3" shows text only in zones 1 and 3 of the element view.

---

### Marking Category

Marking options for HCWL connectors at stud locations.

#### Marking (PropString, Index 3)

| Option | Description |
|--------|-------------|
| **None** | No marking generated (default) |
| **Mark** | Generates marker lines on stud face at connector location |
| **Mill** | Creates shallow surface milling on stud face as visual marker |

- **Applies To**: HCWL connectors only, when attached to a stud
- **Purpose**: Provides visual guidance for installers during assembly
- **Visibility**: Hidden when connector is not HCWL or no stud is attached

**Added**: Version 1.29 (HSB-19773)

---

### Fasteners Category

Specifies the anchor bolt or hanger bolt for concrete/wood connections.

#### Fastener (PropString, Index 4)

| Option | Article Number | Length | Type |
|--------|---------------|--------|------|
| **None** | - | - | No fastener |
| **HST3 M12x165** | 2107687 | 165mm | Concrete anchor |
| **HST3 M12x185** | 2107687 | 185mm | Concrete anchor |
| **HAS-U 8.8 M12x180** | 2226626 | 180mm | Chemical anchor |
| **HAS-U 8.8 M12x200** | 2226626 | 200mm | Chemical anchor |
| **Stockschraube HSW M12x220/60 8.8** | 2316491 | 220mm | Hanger bolt (wood) |
| **Stockschraube HSW M12x140/60 8.8** | 216376 | 140mm | Hanger bolt (wood) |

- **Default**: None
- **Purpose**: Selects the type of threaded fastener that will be installed through the HCW/HCWL connector
- **BOM Integration**: Selected fastener is automatically added to hardware components

**Connection Types**:
- **HST3**: For post-installed concrete anchors
- **HAS-U**: For chemical anchoring in concrete
- **Stockschraube (HSW)**: For wood-to-wood connections using hanger bolts

**Visual Representation**: When Stockschraube is selected, a block representation (HSW M12.dwg) is displayed in the model.

---

## Insertion and Placement Modes

The script supports **four distinct insertion modes** based on user selection:

### Mode 1: Stud Mode (One-Click Placement)

**When to Use**: When connectors must be placed at specific stud locations.

**Workflow**:

1. **Start** the script (from TSL browser or command line)
2. **Configure** initial settings in dialog (Version, Depth)
3. **Select** one or more vertical studs when prompted with "Select stud(s), bottom plate(s) or element(s)"
4. Script automatically creates connector instances attached to each stud

**Automatic Behavior**:
- Connector is placed at stud center point
- Drilling operations target plates intersecting the stud
- **Default Placement**: Right side of stud (relative to wall direction)
- **First Stud**: Cannot have connector on left side
- **Last Stud**: Cannot have connector on right side
- **Collision Prevention**: Script prevents placing two connectors on the same side of same stud

**Post-Placement Options** (via right-click menu):
- **Flip Side**: Move connector to opposite side of stud
- **Copy + Mirror**: Create duplicate connector on opposite side

**Detected Plates**:
- Script automatically finds all horizontal plates intersecting the selected stud
- Use "Add plate for drilling" / "Remove plate for drilling" triggers to manually adjust plate selection

---

### Mode 2: Plate Point Mode (Manual Point Selection)

**When to Use**: When connectors must be placed at specific coordinates on a single plate.

**Workflow**:

1. **Start** the script and configure settings
2. **Select** a single bottom plate when prompted
3. **Click** point(s) on the plate where connectors should be placed
4. Press **Enter** to finish point selection, or select joists to switch to Mode 4

**Characteristics**:
- Connectors are not attached to studs (independent placement)
- Coordinates can be selected in plan view or element view
- Multiple connectors can be placed on same plate in sequence
- Press **Escape** or **Enter** to exit point selection mode

**Special Behavior**:
- Pressing Enter during point selection prompts for joist selection (switches to Mode 4)
- No automatic stud detection—connectors are plate-only

---

### Mode 3: Element Point Mode (Element-Based Placement)

**When to Use**: When placing connectors within a wall element without pre-selecting plates.

**Workflow**:

1. **Start** the script and configure settings
2. **Select** one or more wall elements when prompted
3. **Click** points within the element outline to place connectors
4. Press **Enter** to finish placement

**Element Selection Behavior**:
- **Multiple Elements**: Points must be selected in plan view; script determines which element contains each point
- **Single Element**: Points can be selected in element view; script projects points onto element base

**Automatic Plate Detection**:
- Script finds bottom plates within the selected element
- Connectors are placed on the base plate at clicked locations
- Element association is maintained for BOM grouping

**Use Case**: Rapid placement across entire wall without manually selecting individual plates.

---

### Mode 4: Plate-Joist Intersection Mode (Automatic Grid Placement)

**When to Use**: When connectors must be placed at every intersection of plates and joists.

**Workflow**:

1. **Start** the script and configure settings
2. **Select** multiple bottom plates when prompted
3. Press **Enter** when asked for point input
4. **Select** joist(s) (perpendicular beams crossing the plates)
5. Script automatically creates connectors at all intersections

**Automatic Placement**:
- Script calculates intersection points between plates and joists
- Creates one connector instance per intersection
- Both parallel and perpendicular joist orientations supported
- For parallel joists: Manual point input is required (falls back to plate point mode)

**Special Case - Single Plate + Single Parallel Joist**:
- If plate and joist are parallel, script prompts for manual point selection along the joist
- Multiple points can be clicked to place connectors at specific intervals

**Use Case**: Floor-to-wall connections where joists intersect wall plates at regular intervals.

---

### Insertion Mode Summary Table

| Mode | Selection Sequence | Result | Stud Attachment |
|------|-------------------|--------|-----------------|
| **Stud** | Select studs only | One connector per stud | Yes |
| **Plate Point** | Select plate → Click points | One connector per point | No |
| **Element Point** | Select element → Click points | One connector per point | No |
| **Plate-Joist** | Select plates + Enter + Select joists | One connector per intersection | No |

---

## Right-Click Menu (Context Commands)

Once placed, Hilti connectors provide interactive context menu options:

### Flip Side

- **Applies To**: Stud-mounted connectors only
- **Function**: Mirrors the connector to the opposite side of the stud
- **Visibility**: Only shown when connector is attached to a stud
- **Shortcut**: Double-click on connector (if configured)

**Use Case**: Quick correction when connector was placed on wrong side.

---

### Copy + Mirror

- **Applies To**: Stud-mounted connectors only
- **Function**: Creates a duplicate connector instance on the opposite side of the same stud
- **Result**: Two connectors (left and right) on the same stud
- **Visibility**: Only shown when connector is attached to a stud and opposite side is available

**Important**: This command checks if the opposite side already has a connector and prevents duplicate creation.

---

### Select Stud

- **Function**: Prompts user to select a different stud to attach the connector to
- **Behavior**:
  - Displays "Select stud" prompt
  - User clicks a new stud
  - Connector is re-associated with the new stud
  - Position and drilling operations update accordingly

**Use Case**: Moving connector to different stud without deleting and recreating.

---

### Add Plate for Drilling

- **Function**: Prompts user to select additional plates to receive drilling operations
- **Behavior**:
  - Displays "Select beams" prompt
  - User selects one or more beams
  - Selected plates are added to the drilling target list
  - Drilling/milling operations are applied to newly added plates

**Use Case**: When automatic plate detection misses a plate, or when additional drilling is needed in top plates.

**Storage**: Plate list is stored in `_Map` under key "plates".

---

### Remove Plate for Drilling

- **Function**: Prompts user to select plates to exclude from drilling operations
- **Behavior**:
  - Displays "Select beams" prompt
  - User selects one or more beams
  - Selected plates are removed from the drilling target list
  - Drilling/milling operations no longer affect removed plates

**Use Case**: When script incorrectly targets a plate, or when selective drilling is needed.

---

### Hilti Export

- **Function**: Exports **all** Hilti-Verankerung and Hilti-Stockschraube instances in the drawing to a .dxx file
- **File Location**: Parent folder of current drawing
- **File Name**: `HiltiExport.dxx`
- **Content**: ModelMap with solid info and analyzed tool info

**Workflow**:
1. Right-click any Hilti connector
2. Select "Hilti Export"
3. Script collects all Hilti TSL instances in Model Space
4. Exports to `[Drawing Folder]\..\HiltiExport.dxx`

**Supported Scripts**: `Hilti-Verankerung`, `Hilti-Stockschraube`

**Use Case**: Export fabrication data for CNC machines or external processing.

---

### Catalog Entries (Dynamic Menu)

- **Function**: Applies pre-configured settings from catalog to the current connector instance
- **Menu Content**: Dynamically populated from TSL catalog system
- **Filtering**:
  - Entries starting with `_L` are excluded
  - Entry named "Vorgabe" is excluded
  - **Exterior Walls (AW)**: Only entries starting with "AW" shown
  - **Interior Walls (ZW)**: Only entries starting with "ZW" shown

**Catalog Entry Behavior**:
- When catalog entry is selected, all properties are updated from catalog
- **Exception**: For non-HCWL entries (non-D42), position properties (Z-Offset, Edge Offset X) are NOT changed

**Special Logic for D42 Detection**:
- If catalog entry name contains "D42", it's treated as HCWL
- Position properties are updated for D42 entries
- Non-D42 entries preserve existing position settings

**Baufritz-Specific**:
- Catalog filtering by wall type (AW/ZW) is enforced
- Custom versions (Holzdolle, HCWL+K) may have dedicated catalog entries

---

## Operational Logic and Workflows

### Automatic Plate Detection

When a connector is placed (any mode), the script performs automatic plate detection:

**Stud Mode**:
1. Script finds all beams perpendicular to wall direction (`_ZW.filterBeamsPerpendicularSort`)
2. Filters beams intersecting the stud's bounding volume
3. Plates are sorted by distance from base reference point
4. **Baufritz Exception**: Plates ≤27mm thick are ignored (first plate skip logic)

**Element Mode**:
1. Script uses `filterBeamsHalfLineIntersectSort` to find plates along wall Y-axis
2. Determines base plane from first (bottom-most) plate
3. Removes plates not on the same base plane (tolerance: 0.1mm)
4. Result is the set of plates at wall base

**Manual Override**:
- Use "Add plate for drilling" to include missed plates
- Use "Remove plate for drilling" to exclude incorrectly detected plates

---

### Collision Detection and Resolution

**When Collision is Detected**:
- Script compares all Hilti instances on the drawing
- For each pair of instances with overlapping drill zones:
  - Calculates distance from each connector to wall end
  - **Keeps**: Connector farther from wall end
  - **Deletes**: Connector closer to wall end

**Automatic Deletion**:
- Occurs during recalculation after placement
- User sees warning message: "already attached to beam [beam name]"
- No manual intervention required

**Prevention**:
- Script checks existing connectors before placement in stud mode
- Prevents placing two connectors on same side of same stud

**Collision Zone Calculation**:
- Based on connector diameter and edge offsets
- Considers Z-axis offset positions
- HCWL connectors have larger collision zones than HCW

---

### Coordinate Dimensioning (Element View)

**Purpose**: Display X-coordinate distance from reference point in element views.

**Reference Point Selection**:
- **Standard**: First stud of the element
- **Baufritz**: Stud with color index 32 (if present)

**Calculation**:
- Distance is measured from reference stud center along wall X-axis
- Distance is displayed as text at connector location in element view
- Text follows wall orientation (readable when viewing element)

**Display Logic**:
- Only the **first instance** in the coordinate sequence draws dimension text
- Subsequent instances suppress dimension drawing (prevents duplicate text)
- Text is drawn in element zone views specified by "Text description at zones" property

**Implementation Detail**:
- Script creates dependency tracking via `MapObject` to coordinate which instance draws text
- Uses `setDependencyOnDictObject` to link instances
- First instance in sorted list becomes the "master" for text drawing

---

### Version-Specific Tooling

Different connector versions generate different tooling operations:

#### HCW (Version 1)

**Primary Drill**:
- Diameter: 37mm (locked)
- Depth: 250mm default
- Entry: From bottom of plate

**Secondary Drill** (if enabled):
- Purpose: Sinkhole or stud drilling
- Behavior: If diameter > 37mm, creates recessed area at surface

**Milling** (if enabled):
- Plate bottom milling for connector seating
- Width/Depth user-defined

**Stud Operations**:
- No automatic stud milling
- Stud drilling only if drill center is inside stud boundary

**Hardware Component**:
- Article: 2316449
- Model: "Wood coupler HCW 37x45 M12"

---

#### HCWL (Version 2)

**Primary Tooling**:
- Diameter: 42mm (locked)
- Depth: 250mm default

**Tooling Type Options**:

**House Mode** (Default):
- Creates slotted rectangular housing from below
- Entry direction: From bottom of plate, depth-controlled
- Purpose: L-bracket insertion pocket

**Drill Mode**:
- Creates circular drill hole
- Same diameter and depth as House mode

**Upper Drill**:
- Always created in addition to housing/drill
- Diameter: 75mm (fixed)
- Purpose: L-bracket top insertion clearance

**Stud Milling** (if milling depth > 0):
- Width: User-defined (property 10)
- Height: User-defined (property 11)
- Depth: User-defined (property 9)
- Offset from stud bottom: User-defined (property 12)
- Purpose: Clearance for L-bracket at stud face

**Marking Options**:
- Mark: Generates marker lines on stud
- Mill: Shallow surface milling as marker

**Hardware Component**:
- Article: 2316495
- Model: "Wood coupler HCWL 40x295 M12"

**Baufritz Special**: Extra gap offset (dFlushExtraGap) for flush mounting (9.1mm standard, 0mm Baufritz)

---

#### HCW-P (Version 3)

**Identical Tooling to HCW**:
- Diameter: 37mm
- Depth: 250mm
- Same drilling operations

**Difference**:
- Different hardware article (same number 2316449)
- Model description: "Wood coupler HCW-P"
- Specific dowel/dübel variant

**Note**: Tooling commented out in v2.6 for Baufritz per request (HSB-23098)

---

#### Custom (Version 0)

**User-Defined Parameters**:
- Diameter: Unlocked, user sets any value
- Depth: Unlocked, user sets any value
- Secondary drill: User-defined
- Milling: User-defined

**No Automatic Settings**:
- No validation of beam dimensions
- No hardware component generation
- Full manual control

**Use Case**: Non-standard connectors, prototyping, or legacy configurations

---

#### Baufritz-Specific Versions

**Holzdolle (Version 4)**:
- Diameter: 34mm (locked)
- Depth: 100mm default (Baufritz override)
- Article: Empty string (no hardware component)
- Model: "Wood coupler Holzdolle"

**HCWL+K (Version 5)**:
- Diameter: 42mm (locked)
- Same tooling as HCWL
- Article: 2316495
- Model: "Wood coupler Hilti HCWL+K"

---

### Property Interaction and Triggers

The script implements complex property dependencies:

#### Version ↔ Diameter Synchronization (Baufritz)

**When Version Changes**:
- HCW or HCW-P → Diameter set to 37mm
- HCWL or HCWL+K → Diameter set to 42mm
- Holzdolle → Diameter set to 34mm
- Custom → Diameter unlocked

**When Diameter Changes**:
- 37mm → Version set to HCW (unless already HCW-P)
- 42mm → Version set to HCWL (unless already HCWL+K)
- 34mm → Version set to Holzdolle
- Other value → Version set to Custom

**Implementation**: Mutual trigger on `_kNameLastChangedProp`

---

#### Version → Edge Offset X (HCWL Baufritz)

**Trigger**: When version changes to HCWL or HCWL+K in Baufritz projects
- Edge Offset X automatically set to 8mm
- Purpose: Achieve flush mounting with stud edge
- Execution loops set to 2 for proper recalculation

---

#### Z-Offset / Pt0 Drag Synchronization

**When Z-Offset Property Changes**:
- New Pt0 calculated from base point
- Boundary check (optional, commented out)
- Pt0 updated to reflect new offset

**When Pt0 Dragged in View**:
- View direction detected
- If element view (parallel to vecZ): Point projected to correct plane
- Z-Offset recalculated from new Pt0
- Property updated to show new offset value

**Storage**: Current Pt0 stored in `_Map` under key "pt0" for persistence

---

### Block Representation Drawing

**Purpose**: Display visual 3D blocks in model space for connector representation.

**Block Files Used**:

| Version | Block File | Color | Offsets |
|---------|-----------|-------|---------|
| HCW | HCW.dwg | Color 7 (white) | Y: 0mm, Z: varies |
| HCWL | HCWL.dwg | Color 7 (white) | Y: 0mm, Z: varies |
| Stockschraube | HSW M12.dwg | Color 7 (white) | Fastener-dependent |

**Drawing Logic**:
1. Script checks if block file exists at `[Company Path]\Block\[BlockName].dwg`
2. If found, block is inserted at connector points
3. Block orientation matches wall coordinate system (vecX, vecY, vecZ)
4. Offsets applied based on connector geometry

**Conditional Drawing**:
- Blocks drawn only if file is found (no error if missing)
- Multiple insertion points if connector affects multiple plates
- Block color can be overridden via Map parameter "Color"

**Function**: `drawBlock(Map _min)` handles all block insertion logic

---

### Hardware Component Generation

**Automatic BOM Integration**: Every placed connector generates hardware components for material takeoff.

#### Main Connector Component

**For HCW**:
```
Article Number: 2316449
Manufacturer: Hilti
Model: Wood coupler HCW 37x45 M12
Category: Connector
Quantity: 1
RepType: _kRTTsl (TSL-generated)
```

**For HCWL**:
```
Article Number: 2316495
Manufacturer: Hilti
Model: Wood coupler HCWL 40x295 M12
Category: Connector
Quantity: 1
RepType: _kRTTsl
```

**For HCW-P**:
```
Article Number: 2316449
Model: Wood coupler HCW-P
(same as HCW, different model name)
```

---

#### Fastener Component (if selected)

**Example - HST3 M12x165**:
```
Article Number: 2107687
Manufacturer: Hilti
Model: HST3 M12x165
Category: Connector
Quantity: 1
Dimensions: Length 165mm, ø12mm
RepType: _kRTTsl
```

**Fastener Data**:
| Fastener | Article | Length | Diameter |
|----------|---------|--------|----------|
| HST3 M12x165 | 2107687 | 165mm | 12mm |
| HST3 M12x185 | 2107687 | 185mm | 12mm |
| HAS-U M12x180 | 2226626 | 180mm | 12mm |
| HAS-U M12x200 | 2226626 | 200mm | 12mm |
| HSW M12x220/60 | 2316491 | 220mm | 12mm |
| HSW M12x140/60 | 216376 | 140mm | 12mm |

---

#### Component Grouping

**Group Assignment**:
- Script determines element group from parent element
- If element valid: Hardware assigned to element's ElementGroup
- If loose entity: Assigned to first group containing TSL instance

**Linked Entity**: Hardware component linked to parent element (wall) for traceability

**RepType Marker**: All TSL-generated components have `RepType = _kRTTsl`
- Allows script to identify and replace components on recalculation
- Prevents duplicate hardware accumulation

**Update Mechanism**:
1. On recalculation, script collects existing hardware (`_ThisInst.hardWrComps()`)
2. Removes all components with `RepType == _kRTTsl`
3. Generates fresh components based on current parameters
4. Sets hardware list with `_ThisInst.setHardWrComps(hwcs)`

**Execution Loops**: Set to 2 on `_bOnDbCreated` to ensure hardware is committed to database

---

## Validation and Error Checking

The script performs comprehensive validation to ensure proper placement:

### Beam Dimension Validation

**Minimum Plate Thickness (45mm)**:
```
Error: "Beam thickness [actual] smaller than minimal thickness 45mm"
Display: Red text at connector location
```

**Minimum Plate Width**:
- **Stud Mode**: 100mm minimum
- **No Stud Mode**: 80mm minimum
```
Error: "Beam width [actual] smaller than minimal width 100mm"
```

**Minimum Plate Length** (HCW, HCW-P, Holzdolle):
- 400mm minimum
```
Error: "Beam length [actual] smaller than minimal length 400mm"
```

**Display Behavior**:
- Errors shown in device coordinates (_kDeviceX) for readability
- Text height: 20mm
- Color: 1 (red)
- **Baufritz Exception**: Error display suppressed (validation still performed)

---

### Element Reference Validation

**Required**: At least one element reference
```
Error: "This tool requires one element. Tool will be deleted."
Action: Instance erased
```

**Element Type Check**:
```
Error: "Could not find reference to element."
Action: Instance erased
```

**Dummy Mode**: Script returns early if `_Map.getInt("Dummy")` is true (no validation performed)

---

### Insertion Validation

**Duplicate Insertion Prevention**:
- `insertCycleCount() > 1` → Erase instance
- Prevents accidental multi-creation during insertion

**Stud Alignment Check**:
- Studs must be parallel to _ZW (world Z-axis)
- Filtering: `_ZW.filterBeamsParallel(beams)`

**Stud-Element Association**:
- Beams not part of an element are collected as "joists"
- Beams part of an element are processed as "studs" or "plates"

---

### Collision Prevention (Stud Mode)

**Existing Instance Check**:
1. Script queries all tools connected to selected stud
2. Filters for TslInst of same script name
3. Checks FlipX state (left/right side)
4. Prevents placement if same side already occupied

**Message**:
```
"[Script name] already attached to beam [beam name] ([posnum])"
```

**Allow Flags**: `bAllowLR[] = { left, right }` controls placement permission

---

## Advanced Features

### Multi-Instance Coordination (Text Drawing)

**Problem**: Multiple connectors in same element view would draw overlapping dimension text.

**Solution**: First-instance-only drawing pattern

**Implementation**:
1. Script creates `MapObject` with key "DimensioningController_[Element Handle]"
2. Stores handles of all Hilti instances on that element
3. Instances sorted by X-coordinate
4. Only first instance in sorted list draws dimension text
5. Other instances check MapObject and suppress text drawing

**Dependency Tracking**:
```c
_ThisInst.setDependencyOnDictObject(mo.dictionaryHandle(), mo.handle());
```
- Ensures instance is notified when MapObject changes
- Triggers recalculation if another instance is deleted

---

### Baufritz-Specific Workflow Differences

**Project Detection**:
```c
String sProjectSpecial = projectSpecial();
sProjectSpecial.makeUpper();
int bBaufritz = (sProjectSpecial == "BAUFRITZ");
```

**Key Differences**:

| Feature | Standard | Baufritz |
|---------|----------|----------|
| **Default Depth** | 250mm | 100mm |
| **Diameter Property** | Locked for predefined versions | Always editable |
| **Version-Diameter Sync** | One-way (version → diameter) | Two-way (mutual) |
| **Rotation Offset** | +90° | 0° (direct) |
| **Error Display** | Shown | Suppressed |
| **Edge Distance Check** | None (removed v2.11) | None |
| **Plate Thickness Filter** | None | Skip plates ≤27mm |
| **Reference Stud** | First stud | Stud with color 32 (if present) |
| **HCWL Edge Offset** | User-defined | Auto-set to 8mm |
| **Flush Gap Offset** | 9.1mm | 0mm |
| **HCW-P Tooling** | Enabled | Commented out (v2.6) |
| **Extra Versions** | None | Holzdolle, HCWL+K |

---

### Export to .dxx File

**Export Trigger**: Right-click → "Hilti Export"

**Collection Logic**:
1. Collect all entities in current Group: `Group().collectEntities(true, TslInst(), _kModelSpace)`
2. Filter for script names: "Hilti-Verankerung", "Hilti-Stockschraube"
3. Case-insensitive matching

**ModelMap Composition**:
```c
ModelMapComposeSettings mmFlags;
mmFlags.addSolidInfo(TRUE);        // Include solid geometry
mmFlags.addAnalysedToolInfo(TRUE);  // Include analyzed tooling

ModelMap mm;
mm.setEntities(Hiltis);
mm.dbComposeMap(mmFlags);
```

**File Output**:
- Path: Parent folder of current drawing (`[DWG Path]\..`)
- Filename: `HiltiExport.dxx`
- Format: hsbCAD ModelMap .dxx format
- Content: Geometry, tooling, properties of all Hilti instances

**Post-Export**:
- Execution loops set to 2
- Debug message: "[Script] [count] exported to [path]"

**Use Case**: Transfer to CNC machine, external fabrication system, or documentation

---

### Catalog System Integration

**Catalog Storage**: TSL catalog system (accessible via OPM)

**Entry Naming Convention**:
- **AW_[Name]**: Exterior wall (Aussenswand) configurations
- **ZW_[Name]**: Interior wall (Zwischenwand) configurations
- **_L[Name]**: Excluded from menu (internal use)
- **Vorgabe**: Default entry, excluded from menu

**Dynamic Menu Generation**:
```c
String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
for (int i=0; i<sEntries.length(); i++) {
    // Filter logic
    if (sEntry.left(2) == "_l" || sEntry == "vorgabe") continue;
    if (bExposed && sEntry.left(2) != "aw") continue;
    if (!bExposed && sEntry.left(2) != "zw") continue;

    addRecalcTrigger(_kContext, sEntries[i]);
}
```

**Exposure Detection**: Based on wall element's `bExposed()` property
- Exposed wall (exterior) → Show AW entries
- Non-exposed wall (interior) → Show ZW entries

**Catalog Application**:
- Right-click → Select catalog entry name
- `_ThisInst.setPropValuesFromCatalog(sEntries[i])`
- **Exception**: Non-D42 entries preserve position properties
- Execution loops set to 2 for recalculation

**D42 Detection**:
```c
int b42 = sEntry.find("D42", -1, false) > -1;
```
- D42 in name → HCWL connector, update all properties
- No D42 → Non-HCWL, preserve dOffsetAxisZ and dEdgeOffsetX

---

## Troubleshooting and Common Issues

### Issue: Connector Disappears After Placement

**Possible Causes**:
1. **Collision with Existing Connector**: Another Hilti instance is too close; script auto-deletes the closer one
2. **Beam Dimension Violation**: Plate thickness < 45mm causes deletion
3. **No Element Reference**: Script requires valid element association

**Solutions**:
- Check for existing connectors on same stud/plate
- Verify plate dimensions meet minimum requirements
- Ensure selected beam is part of an element
- Review console messages for error reports

---

### Issue: Wrong Side Placement on Stud

**Cause**: Default placement is right side of stud

**Solutions**:
- **After Placement**: Right-click → "Flip Side"
- **For Both Sides**: Right-click → "Copy + Mirror"
- **Re-select Stud**: Right-click → "Select stud" → Pick different stud

---

### Issue: Missing Plates in Drilling Operation

**Symptoms**: Connector doesn't drill expected plates

**Causes**:
- Automatic plate detection missed some plates
- Plates are not in element's bottom plate layer
- Baufritz: Plate thickness ≤27mm (automatically excluded)

**Solutions**:
- Right-click → "Add plate for drilling" → Select missing plates
- Check plate alignment with wall base plane
- Verify plates are perpendicular to wall direction (_ZW)

---

### Issue: Extra Plates Being Drilled

**Symptoms**: Drilling appears on unintended plates (e.g., top plates)

**Causes**:
- Automatic detection included all perpendicular plates
- Plates on same base plane but wrong location

**Solutions**:
- Right-click → "Remove plate for drilling" → Select unwanted plates
- Manually curate plate list per connector instance

---

### Issue: Catalog Entries Not Showing in Menu

**Possible Causes**:
1. **Wall Type Mismatch**:
   - Exterior wall (bExposed=true) shows only AW_ entries
   - Interior wall (bExposed=false) shows only ZW_ entries
2. **Entry Name Format**:
   - Entries starting with "_L" are hidden
   - Entry named "Vorgabe" is hidden

**Solutions**:
- Verify wall exposure property matches catalog prefix (AW/ZW)
- Rename catalog entries to follow convention
- Check catalog exists in TSL catalog system for script "Hilti-Verankerung"

---

### Issue: Diameter Property Is Read-Only

**Cause**: Predefined version (HCW, HCWL, HCW-P, Holzdolle, HCWL+K) is selected

**Solution**:
- Change Version property to "Custom" to unlock diameter
- For Baufritz: Diameter is always editable, but changing it switches version

---

### Issue: Coordinate Dimension Text Not Showing

**Possible Causes**:
1. **Zone Mismatch**: "Text description at zones" property doesn't match current view zone
2. **Not First Instance**: Only the first connector (by X-coordinate) draws dimension text
3. **Reference Stud Missing**: No valid reference stud found for X-coordinate calculation

**Solutions**:
- Set "Text description at zones" to "0" (all zones) or specific zone number
- Check if another connector with lower X-coordinate exists (it draws the text)
- Verify first stud exists (or stud with color 32 for Baufritz)

---

### Issue: Block Representation Not Displaying

**Possible Causes**:
1. **Block File Missing**: HCW.dwg or HCWL.dwg not found at `[Company Path]\Block\`
2. **Wrong Path**: Company path not configured correctly
3. **Incorrect Block Version**: Block file exists but is incompatible

**Solutions**:
- Copy HCW.dwg and HCWL.dwg to company Block folder
- Check `_kPathHsbCompany` variable in script debug
- Ensure block files are valid AutoCAD .dwg format
- Script silently skips drawing if block not found (no error message)

---

### Issue: Hardware Not Appearing in BOM

**Possible Causes**:
1. **Custom Version**: Custom version (nVersion==0) doesn't generate hardware
2. **Holzdolle (Baufritz)**: Article number is empty string (no component)
3. **RepType Filter**: BOM export may filter _kRTTsl type components

**Solutions**:
- Use predefined version (HCW, HCWL, HCW-P) for automatic hardware
- Check BOM export settings to include TSL-generated components
- Verify hardware components with `_ThisInst.hardWrComps()` in debug mode

---

### Issue: Stud Milling Not Applied

**Symptoms**: HCWL connector on stud doesn't show milling

**Causes**:
- "Milling depth stud" property is 0mm (disabled)
- No stud attached to connector
- Version is not HCWL or HCWL+K

**Solutions**:
- Set "Milling depth stud" to desired value (e.g., 20mm)
- Ensure connector is attached to a stud (use stud mode or "Select stud")
- Verify version is HCWL or HCWL+K
- Set width and height properties if needed (v2.14+)

---

### Issue: Export Fails or Creates Empty .dxx File

**Possible Causes**:
1. **No Hilti Instances Found**: Drawing contains no Hilti-Verankerung or Hilti-Stockschraube
2. **Write Permission**: Parent folder is read-only or protected
3. **Path Resolution Error**: Drawing path string parsing failed

**Solutions**:
- Verify at least one Hilti connector exists in Model Space
- Check file permissions on parent folder
- Save drawing to a simple path without special characters
- Review debug message for actual file path

---

## Related Scripts and Workflow Integration

### Hilti-Stockschraube

**Relationship**: Companion script for hanger bolt connections

**Difference**:
- Hilti-Stockschraube: Focuses on HSW hanger bolt installations
- Hilti-Verankerung: Focuses on HCW/HCWL connector installations

**Integration**: Both scripts export together via "Hilti Export" command

**Use Case**: Use Hilti-Stockschraube for direct wood-to-wood connections without connector sockets

---

### Hilti-Verteilung

**Relationship**: Distribution/pattern creation tool for Hilti connectors

**Dependency**: Creates dependency link (v3.5, HSB-9jun19)

**Purpose**: Automates creation of multiple Hilti-Verankerung instances in patterns
- Linear distributions along wall plates
- Grid patterns at joist intersections
- Spacing rules based on structural requirements

**Workflow**: Run Hilti-Verteilung first, then adjust individual instances with Hilti-Verankerung properties

---

### Wall Element Creation Scripts

**Prerequisites**: Wall elements must exist before using Hilti-Verankerung

**Related Scripts**:
- `hsb_CreateElement`: Creates wall elements from beams
- `GE_WALL_*` series: Regional wall creation tools
- `HSB_W-*` series: Wall framing tools

**Workflow Sequence**:
1. Create wall frame (studs and plates)
2. Convert to Element using element creation tool
3. Place Hilti connectors using Hilti-Verankerung

---

### Shop Drawing Scripts

**Integration Point**: Hilti connectors appear in shop drawings

**Related Scripts**:
- `sd_ABeamcutDE`: Shop drawing for beam cutting (may show Hilti drilling)
- `HSB_D-Element`: Element display in shop drawings
- `NA_WALL_SHOP_DRAWING`: North American wall shop drawing (may show connectors)

**Visibility**: Hilti connectors contribute to:
- Drilling schedules
- Milling operations lists
- Hardware component BOMs
- Assembly instructions

---

### BOM and Scheduling Scripts

**Integration**: Hardware components feed into BOM systems

**Related Scripts**:
- `HSB_G-BillOfMaterial`: General BOM generation (includes Hilti hardware)
- `hsbBOM`: Core BOM functionality
- `HSB_E-ElementTable`: Element-based schedules (may list connectors)

**Hardware Flow**:
1. Hilti-Verankerung generates HardWrComp objects
2. BOM scripts collect hardware from all entities
3. Hardware grouped by ElementGroup
4. Export to Excel, PDF, or other formats

---

### CNC and Manufacturing Integration

**Export Format**: .dxx ModelMap format

**Compatible Systems**:
- hsbCAD CNC export modules
- Hundegger machining centers (via ModelMap import)
- Weinmann production lines (via hsbCAD interface)
- Custom fabrication systems supporting .dxx

**Workflow**:
1. Design wall with Hilti connectors in hsbCAD
2. Export via "Hilti Export" (creates HiltiExport.dxx)
3. Import .dxx into CNC programming software
4. CNC machine executes drilling/milling operations

**Data Included**:
- 3D solid geometry of connectors
- Analyzed tooling operations (drills, mills, housings)
- Coordinates relative to element origin
- Tool specifications (diameter, depth, rotation)

---

## Best Practices and Recommendations

### Design Stage

1. **Plan Connector Locations Early**:
   - Consider structural load paths
   - Verify edge distance requirements per ETA-21/0357
   - Account for MEP penetrations and blocking

2. **Use Stud Mode When Possible**:
   - More reliable plate detection
   - Easier to relocate (flip side, copy+mirror)
   - Better for parametric updates if stud spacing changes

3. **Leverage Catalog Entries**:
   - Create catalog entries for standard configurations
   - Use AW/ZW naming for automatic filtering
   - Include position offsets in catalog for consistency

4. **Check Beam Dimensions First**:
   - Ensure plates are ≥45mm thick before placing connectors
   - Verify plate width ≥100mm for stud mode
   - For HCW: plate length ≥400mm

---

### Placement Stage

5. **Use Appropriate Insertion Mode**:
   - **Stud Mode**: Regular wall framing with vertical studs
   - **Plate Point Mode**: Irregular spacing or non-stud locations
   - **Element Mode**: Quick placement across multiple walls
   - **Plate-Joist Mode**: Floor-to-wall connections at joist grid

6. **Verify Automatic Plate Detection**:
   - After placement, check drilling targets
   - Use "Add/Remove plate for drilling" to adjust
   - For Baufritz: Remember first plate (≤27mm) is auto-excluded

7. **Coordinate Dimension Text Management**:
   - Set reference stud (color 32 for Baufritz)
   - Use "Text description at zones" to control visibility
   - Only first instance draws text (others auto-suppress)

---

### Modification Stage

8. **Use Context Menu Efficiently**:
   - Flip Side: Quick correction of side placement
   - Copy + Mirror: Create symmetrical pairs
   - Catalog Entries: Apply standard configurations
   - Select Stud: Relocate without deleting

9. **Adjust Position Properties Carefully**:
   - Z-Offset: For perpendicular-to-wall adjustment
   - Edge Offset X: For stud-relative positioning (stud mode only)
   - Rotation: For non-standard orientations

10. **HCWL-Specific Considerations**:
    - Default to "House" tooling type for proper L-bracket pocket
    - Set stud milling if flush mounting required
    - Use "Marking" property to aid assembly (Mark or Mill)
    - For Baufritz: Edge Offset X auto-sets to 8mm

---

### Documentation and Export

11. **Hardware Component Validation**:
    - Use predefined versions for automatic BOM integration
    - Select appropriate fastener type for connection substrate
    - Verify hardware quantities in BOM before fabrication

12. **Export for Fabrication**:
    - Right-click any Hilti connector → "Hilti Export"
    - Verify HiltiExport.dxx file created in parent folder
    - Import to CNC software and validate tooling paths
    - Check drill depths and milling dimensions

13. **Shop Drawing Coordination**:
    - Ensure connectors appear in element shop drawings
    - Cross-reference drilling schedules with placement locations
    - Include hardware list in assembly documentation

---

### Quality Assurance

14. **Collision Check**:
    - Review console messages for "already attached" warnings
    - Manually check connector spacing in plan view
    - Verify no overlapping drill zones

15. **Dimensional Validation**:
    - Check coordinate dimension text in element view
    - Verify Z-offset values match design intent
    - Confirm rotation angles are correct (especially Baufritz)

16. **Catalog Consistency**:
    - Use same catalog entry for similar wall types
    - Document custom configurations for future reference
    - Test catalog entries on sample walls before production

---

### Project-Specific Workflows

17. **Standard Projects**:
    - Default depth: 250mm
    - Error messages displayed for dimension violations
    - Rotation: +90° internal offset applied
    - Edge distance: User responsibility (not enforced)

18. **Baufritz Projects**:
    - Default depth: 100mm
    - Error messages suppressed (validation still performed)
    - Rotation: No internal offset (direct value)
    - Diameter always editable (version-diameter sync)
    - First plate (≤27mm) automatically excluded
    - Reference stud: Color 32 prioritized
    - HCWL Edge Offset: Auto-set to 8mm

---

### Maintenance and Updates

19. **Version Control**:
    - Current version: 2.17 (July 2025)
    - Check for updates addressing new Hilti connector types
    - Review version history for bug fixes related to your workflow

20. **Block File Management**:
    - Keep HCW.dwg, HCWL.dwg, HSW M12.dwg updated
    - Store in company Block folder for consistent visualization
    - Test block insertion after hsbCAD updates

---

## Technical Reference

### Property Index Reference

| Index | Type | Name | Category | Default |
|-------|------|------|----------|---------|
| 0 (String) | PropString | Version | Version | "HCW" |
| 1 (String) | PropString | Description | General | "" |
| 2 (String) | PropString | Text description at zones | General | "0" |
| 3 (String) | PropString | Marking | Marking | "None" |
| 4 (String) | PropString | Fastener | Fasteners | "None" |
| 5 (String) | PropString | Tooling Type HCWL | Drill | "House" |
| 0 (Double) | PropDouble | Diameter | Drill | 30mm |
| 1 (Double) | PropDouble | Depth | Drill | 250mm (100mm Baufritz) |
| 2 (Double) | PropDouble | Z-Offset from Axis | Alignment | 0mm |
| 3 (Double) | PropDouble | Edge offset X | Alignment | 0mm |
| 4 (Double) | PropDouble | Rotation | Alignment | 0° |
| 5 (Double) | PropDouble | Width | Milling | 0mm |
| 6 (Double) | PropDouble | Depth (milling) | Milling | 0mm |
| 7 (Double) | PropDouble | Diameter (2nd drill) | Second drill | 0mm |
| 8 (Double) | PropDouble | Depth (2nd drill) | Second drill | 0mm |
| 9 (Double) | PropDouble | Milling depth stud | Milling | 0mm |
| 10 (Double) | PropDouble | Milling width stud | Milling | 0mm |
| 11 (Double) | PropDouble | Milling height stud | Milling | 0mm |
| 12 (Double) | PropDouble | Milling offset stud | Milling | 0mm |

---

### Map Storage Keys

| Key | Type | Purpose |
|-----|------|---------|
| `FlipX` | Int | Stud side placement (0=right, 1=left) |
| `Dummy` | Int | Dummy mode flag (skip execution if true) |
| `pt0` | Point3d | Stored insertion point (absolute) |
| `plates` | EntityArray | Manual plate selection for drilling |
| `TestLocation` | (various) | Temporary trigger flag (removed after use) |

---

### Version History Summary

| Version | Date | Key Changes |
|---------|------|-------------|
| 2.17 | 2025-07-09 | Baufritz-specific modifications (HSB-24279) |
| 2.16 | 2025-05-23 | Added HSW hanger bolt block representation (HSB-24083) |
| 2.15 | 2025-05-23 | Stud milling offset property (HSB-24083) |
| 2.14 | 2025-05-08 | Milling width/height for HCWL studs (HSB-23993) |
| 2.13 | 2025-03-20 | House/Drill tooling option for HCWL (HSB-20098) |
| 2.12 | 2025-03-06 | Milling depth at studs for HCWL (HSB-23567) |
| 2.11 | 2025-03-06 | Removed edge distance check; added ETA reference (HSB-23568) |
| 2.10 | 2025-03-04 | Baufritz modifications (HSB-23612) |
| 2.9 | 2025-02-11 | Fixed milled fastener position (HSB-19773) |
| 2.8 | 2024-12-12 | Added missing hanger bolt (HSB-19773) |
| 2.7 | 2024-12-10 | Adjusted to Hilti requirements (HSB-19773) |
| 2.6 | 2024-12-03 | Commented out HCW-P tooling (HSB-23098) |
| 2.5 | 2024-10-11 | Fixed HCWL House tooling for Baufritz |
| 2.4 | 2024-10-08 | Changed TSL image (HSB-19775) |
| 2.3 | 2024-10-08 | Added HCWL+K for Baufritz (HSB-22780) |
| 2.2 | 2024-09-22 | Fixed beamcut at stud for HCWL (20240922) |
| 2.1 | 2024-09-10 | Added Holzdolle option for Baufritz (HSB-22652) |
| 2.0 | 2024-08-22 | Draw block only when found (HSB-19773) |
| 1.29 | 2024-06-20 | Added "Marking" property for HCWL studs (HSB-19773) |
| 1.28 | 2024-06-20 | Block representation for HCW and HCWL (HSB-19774) |
| 1.27 | 2024-05-06 | Catalog trigger position property fix (HSB-21970) |

---

## Appendix: Coordinate Systems and Geometry

### Wall Coordinate System

```
vecX = Wall length direction (horizontal)
vecY = Wall height direction (vertical)
vecZ = Wall thickness direction (perpendicular to wall plane)

_Pt0 = Insertion point (connector center)
ptBase = Base reference point (on bottom plate)
ptMid = Midpoint reference (for offset calculations)
```

### Stud Coordinate System (when stud attached)

```
vecXstud = Stud length direction (vertical, parallel to wall vecY)
vecYstud = Stud thickness direction (parallel to wall vecY or perpendicular)
vecZstud = Stud width direction (perpendicular to wall plane)

FlipX = false → Connector on right side of stud
FlipX = true → Connector on left side of stud
```

### Plate Coordinate System

```
vecXbm = Plate length direction (along wall)
vecYbm = Plate thickness direction (vertical)
vecZbm = Plate width direction (perpendicular to wall)

Drill enters from bottom surface (negative vecYbm direction)
```

---

## Appendix: Regulatory Compliance

### European Technical Assessment ETA-21/0357

**Document Title**: "HCW Wood connector ETA 21-0357 (31.01.2025)"

**Required Reading**: Users must consult this document for:

1. **Load-Carrying Capacity**:
   - Tension and shear values
   - Partial safety factors
   - Characteristic values

2. **Minimum Cross-Sections**:
   - Timber member thickness requirements
   - Width and length specifications
   - Material grade requirements

3. **Edge Distances**:
   - Distance from connector to timber edge
   - Distance from connector to timber end
   - Spacing between multiple connectors

4. **Installation Requirements**:
   - Drilling tolerances
   - Torque specifications
   - Assembly sequence

**Important**: The script does **not enforce** these requirements automatically (removed in v2.11). Compliance is the user's responsibility.

---

## Appendix: File Paths and Locations

### Company Path
```
_kPathHsbCompany + "\TSL\Settings\"
_kPathHsbCompany + "\Block\"
```

### Installation Path
```
_kPathHsbInstall + "\Content\General\TSL\Settings\"
```

### Drawing Path
```
_kPathDwg + "\..\HiltiExport.dxx"
```

### Block Files
```
[Company Path]\Block\HCW.dwg
[Company Path]\Block\HCWL.dwg
[Company Path]\Block\HSW M12.dwg
```

---

## Document Information

| Property | Value |
|----------|-------|
| **Script Name** | Hilti-Verankerung.mcr |
| **Documentation Version** | 1.0 |
| **Script Version Documented** | 2.17 (2025-07-09) |
| **Total Script Lines** | 11,485 |
| **Author** | Marsel Nakuci (hsbCAD) |
| **Company** | hsbCAD GmbH |
| **Last Updated** | 2025-07-09 |
| **Documentation Generated** | 2026-02-20 |

---

**End of Documentation**
