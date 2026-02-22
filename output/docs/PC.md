# PC - Knapp WALCO Plate Connector

## Overview

**PC** (Plate Connector) is a specialized timber connection tool designed for the **Knapp WALCO** connector system. WALCO connectors are industrial-grade steel plate connectors used to create strong, concealed beam-to-beam connections in timber construction. This TSL script automates the placement of WALCO connectors along with their required machining operations (milling and drilling) on both the female (connector beam) and male (screw beam) timber members.

The script intelligently handles multiple WALCO product families (V60 and V80), various screw types (collar screws, spring-loaded holding screws, threaded bolts), and supports both single connector placement and distributed arrays along a connection line.

**Manufacturer**: Knapp
**Product Family**: WALCO V60 / WALCO V80
**Product URL**: https://www.knapp-verbinder.com/produkt/walco-v/

---

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 1.4 |
| **Date** | July 21, 2021 |
| **Beams Required** | 0 (prompts for 2 beams during insertion) |
| **Environment** | Model Space |
| **Category** | Hardware / Connectors |

### Version History

- **v1.4** (2021-07-21): Added "Orientation Drill" property (Yes/No) for upward-facing indicator holes
- **v1.3** (2021-07-21): Added "Offset" property for fine-tuning connector position
- **v1.2** (2021-06-27): Separate TSL instance created for male part representation
- **v1.1** (2021-06-24): Added ability to align connector on any beam face (X direction)
- **v1.0** (2021-06-01): Initial release

---

## Product System Overview

### WALCO Connector Components

A complete WALCO connection system consists of:

1. **Female Connector Plate** (WALCO V60 or V80)
   - Steel plate with integrated collar screw receptacle
   - Dimensions: 60×60mm (V60) or 80×80mm (V80)
   - Thickness: 12mm (V60) or 13mm (V80)
   - Fixed to the "connector beam" with hex-head wood screws

2. **Male Screw Component** (Various Types)
   - **KS (Collar Screw)**: Direct-drive collar screw
   - **GH (Spring Holding Screw)**: Spring-loaded adjustable screw
   - **EH (Adjustable Holding Screw)**: Manually adjustable threaded screw
   - **VK (Threaded Collar Bolt)**: Bolt-through connection with nut access

3. **Clip Lock** (Optional - "Sperrklappe")
   - Additional 3mm clip mechanism for enhanced load transfer
   - Requires additional milling depth

### Product Families

#### WALCO V60
- Connector plate: 60×60×12mm
- Screw options: Ø12mm collar screws, M12 threads
- Applications: Light to medium timber connections
- Available as individual components or complete sets

#### WALCO V80
- Connector plate: 80×80×13mm
- Screw options: Ø16mm collar screws, M16 threads
- Applications: Medium to heavy timber connections
- Available as individual components or complete sets

---

## User Workflow

### Insertion Process

The script follows a comprehensive step-by-step workflow:

#### Step 1: Beam Selection

When you insert the PC script, you are prompted:

**"Select 2 beams"**

- **First beam selected** = Male beam (receives the screw component)
- **Second beam selected** = Female beam (receives the connector plate)

The script stores these as `_Beam[0]` (male) and `_Beam[1]` (female).

#### Step 2: Product Selection Dialog

If no OPM key is provided, a dialog appears with cascading dropdowns:

1. **Manufacturer**: Currently only "Knapp" is available
2. **Family**: Choose between:
   - **V60** - 60×60mm connector system
   - **V80** - 80×80mm connector system
3. **Product**: Varies by family, examples:
   - Walco V60 TYP KS (Collar Screw 12×60mm)
   - Walco V60 TYP GH (Spring Holding Screw M12)
   - Walco V60 TYP EH (Adjustable Holding Screw M12)
   - Walco V60 TYP VK D12 (Threaded Bolt D12)
   - Walco V60 WALCO 60 VS (Set with plate for both sides)
   - Walco V80 TYP KS (Collar Screw 16×60mm)
   - etc.

**Note**: Products ending with "Set" configurations include both the female connector plate AND a matching male connector plate, creating a double-sided connection.

#### Step 3: Interactive Placement

After product selection, the script enters interactive placement mode with visual feedback.

##### 3a. First Point Selection

**Prompt**: "Select first distribution point [Fixed/eVen/Start/End/Between]"

- **Click a point** on the visible face of the female beam
- The script automatically:
  - Detects which face you clicked (±X, ±Y, ±Z)
  - Projects a distribution plane onto that face
  - Shows a preview of the connector at the clicked location

**Command Line Options** (before clicking):
- **Fixed/eVen** - Toggle distribution mode:
  - **Even**: Distributes connectors with equal spacing
  - **Fixed**: Uses exact spacing value (may leave gap at end)
- **Start** - Modify start distance from first point
- **End** - Modify end distance from last point
- **Between** - Modify spacing between connectors

##### 3b. Second Point Selection (Distribution Mode)

If distributing multiple connectors, you are prompted:

**Prompt**: "Select second distribution point [Back/Fixed/eVen/Start/End/Between]"

- **Click second point** to define distribution line
- Preview shows all distributed connectors along the line
- **Back** - Return to first point selection

**Distribution Logic**:
- Start distance is measured from Point 1 along the distribution direction
- End distance is measured backward from Point 2
- Connectors are distributed in the remaining space according to mode:
  - **Even**: Equal spacing, may have remainder
  - **Fixed**: Exact spacing, adds one at each end

#### Step 4: Confirmation and Application

After placing both points (or single point for one connector):
- The script calculates final positions
- Applies milling and drilling operations to both beams
- Creates visual representation of the connector plate
- Saves all parameters to the instance

---

## Properties Reference

All properties are accessible through the AutoCAD Properties Palette (OPM) after insertion.

### Component Category

These properties define which WALCO product is being used.

| Property | Type | Description | Example Values |
|----------|------|-------------|----------------|
| **Manufacturer** | Dropdown | Connector manufacturer | "Knapp" |
| **Family** | Dropdown | Product family | "V60", "V80" |
| **Product** | Dropdown | Specific product configuration | "Walco V60 TYP KS", "Walco V80 TYP GH" |

**Note**: Changing Manufacturer resets Family and Product. Changing Family resets Product.

---

### Distribution Category

Controls how connectors are distributed along the connection line.

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| **Mode of Distribution** | Dropdown | - | "Even" or "Fixed"<br>• **Even**: Divides space equally<br>• **Fixed**: Uses exact spacing value |
| **Start Distance** | Distance | mm | Distance from first point to first connector center |
| **End Distance** | Distance | mm | Distance from second point to last connector center |
| **Max. Distance between / Quantity** | Distance/Count | mm | **Positive value**: Maximum spacing between connectors<br>**Negative value**: Total quantity (e.g., -5 = place exactly 5 connectors) |
| **Real Distance between** | Distance (Read-only) | mm | Calculated actual spacing between connectors |
| **Nr.** | Integer (Read-only) | - | Calculated total number of connectors placed |

#### Distribution Examples

**Example 1: Even Distribution with Maximum Spacing**
- Mode: Even
- Start Distance: 50mm
- End Distance: 50mm
- Max Distance: 300mm
- **Result**: Connectors placed every ~300mm (or less) with equal spacing

**Example 2: Fixed Spacing**
- Mode: Fixed
- Start Distance: 100mm
- End Distance: 100mm
- Max Distance: 250mm
- **Result**: Connectors placed exactly 250mm apart, plus one at each end

**Example 3: Fixed Quantity**
- Mode: Even
- Start Distance: 0mm
- End Distance: 0mm
- Max Distance: -4 (negative!)
- **Result**: Exactly 4 connectors, equally distributed across entire length

---

### Position Category

Fine-tuning of connector position.

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| **Offset** | Distance | mm | Shifts connector position along the insertion direction (positive = outward from beam face) |

**Use Case**: Adjust for beam tolerances, face irregularities, or to compensate for non-flush beam faces.

---

### Tooling for Connector Beam (Female)

Machining operations applied to the beam receiving the connector plate.

| Property | Type | Unit | Description |
|----------|------|------|-------------|
| **Clip Lock** | Yes/No | - | Add optional clip lock mechanism<br>• **Yes**: Increases milling depth by 3mm<br>• **No**: Standard configuration |

#### Milling for Connector Beam

| Property | Type | Unit | Default | Override Behavior |
|----------|------|------|---------|-------------------|
| **Width** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Length** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Depth** | Distance | mm | From XML | 0 = use default, >0 = override (+3mm if Clip Lock) |

**Default Values** (V60 example):
- Width: 60mm
- Length: 100mm
- Depth: 11mm (or 14mm with Clip Lock)

**Purpose**: Creates rectangular mortise to recess the connector plate flush with beam surface.

#### Drilling for Connector Beam

| Property | Type | Unit | Default | Override Behavior |
|----------|------|------|---------|-------------------|
| **Diameter** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Depth** | Distance | mm | From XML | 0 = use default, >0 = override |

**Default Values** (V60 example):
- Diameter: 4mm (pilot holes for wood screws)
- Depth: 50mm
- Quantity: 3 holes (positioned at corners per XML)

**Purpose**: Pre-drilled holes for hex-head wood screws that secure the connector plate.

**Hole Pattern** (V60):
- Hole 1: X=+22.5mm, Y=0mm
- Hole 2: X=0mm, Y=-22.5mm
- Hole 3: X=-22.5mm, Y=0mm

---

### Milling for Screw Beam (Male)

Machining operations for the beam receiving the screw component.

| Property | Type | Unit | Default | Override Behavior |
|----------|------|------|---------|-------------------|
| **Width** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Length** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Depth** | Distance | mm | From XML | 0 = use default, >0 = override |

**Availability**: Only for "Set" configurations (double-sided connections with male plate).

**Purpose**: Creates mortise on the male beam to receive the male connector plate.

---

### Drilling for Screw Beam (Male)

| Property | Type | Unit | Default | Override Behavior |
|----------|------|------|---------|-------------------|
| **Diameter** | Distance | mm | From XML | 0 = use default, >0 = override |
| **Depth** | Distance | mm | From XML | 0 = use default, >0 = override |

**Default Values** (varies by product):
- **TYP KS (Collar Screw)**: Ø8mm × 48mm depth
- **TYP GH (Spring Holding)**: Ø26mm × 55mm depth
- **TYP EH (Adjustable)**: Ø19mm × 32mm depth (+ Ø50mm × 7mm countersink)
- **TYP VK (Threaded Bolt)**: Ø5mm × 50mm depth

**Purpose**: Pilot hole for the male screw component insertion.

**Multiple Drill Operations**: Some products require:
1. **Primary hole** (DrillMale) - Main screw shaft
2. **Countersink** (DrillMaleSinkHole) - For flush screw heads
3. **Mounting holes** (for Set configurations) - Pre-drilled pattern for male plate screws

---

### Alignment Category

Controls connector orientation on the beam face.

| Property | Type | Description |
|----------|------|-------------|
| **Alignment** | Dropdown (Read-only) | Shows detected face direction: "+X", "-X", "+Y", "-Y", "+Z", "-Z"<br>Updated automatically during interactive placement |

**Behavior**:
- Set automatically based on which face you click during insertion
- The script projects the distribution plane onto the beam face closest to your view direction
- Read-only after placement (use "swap Beams" trigger to reverse)

---

### Orientation Drill Category

Optional marking feature for assembly clarity.

| Property | Type | Description |
|----------|------|-------------|
| **Drill** | Yes/No | Add orientation indicator holes<br>• **Yes**: Adds Ø10mm × 10mm holes on the Z-axis sides of both beams<br>• **No**: No indicator holes |

**Purpose**: Visual/tactile indicator showing which direction is "up" during assembly. Useful for pre-fabricated connections where orientation matters for load path or aesthetics.

**Hole Location**: Positioned 30mm from the Z-edge, centered on connector position.

---

## Machining Operations Detail

### Female Beam (Connector Beam)

The script applies these machining steps to the beam receiving the connector plate:

#### 1. Mortise (Rectangular Pocket)
```
Type: Mortise
Position: Centered on distribution point, recessed from beam face
Size: Width × Length × Depth (from Product XML or overrides)
Purpose: Flush-mount the steel connector plate
Roundness: Not rounded (sharp corners)
```

**Typical Dimensions**:
- V60: 60mm × 100mm × 11-14mm
- V80: 80mm × 100mm × 13-16mm

**Depth Adjustment**:
- Base depth from XML
- +3mm if Clip Lock is enabled
- +User override if Depth property > 0

#### 2. Pilot Holes for Connector Screws
```
Type: Drill
Quantity: 3 or 4 (depends on product)
Diameter: 4-6mm (pilot holes for hex-head wood screws)
Depth: 50-60mm
Pattern: Defined in XML (x, y coordinates relative to connector center)
```

**V60 Pattern (3 holes)**:
- Corner holes at 22.5mm offset, 120° spacing

**V80 Pattern (3 holes)**:
- Corner holes at 30mm offset, 120° spacing

**Set Configurations (4 holes)**:
- Corner holes at all four quadrants

### Male Beam (Screw Beam)

#### 1. Mortise (for Set Configurations Only)
```
Type: Mortise
Position: Opposite side from female connector
Size: Matches connector plate dimensions
Purpose: Recess male connector plate
```

#### 2. Primary Screw Hole
```
Type: Drill
Diameter: Varies by screw type (5-26mm)
Depth: 32-87mm
Purpose: Main insertion hole for collar screw or threaded component
```

**Drill Specifications by Product**:

| Product Type | Primary Ø | Primary Depth | Notes |
|--------------|-----------|---------------|-------|
| V60 TYP KS | 8mm | 48mm | Collar screw clearance |
| V60 TYP GH | 26mm | 55mm | Spring-loaded mechanism |
| V60 TYP EH | 19mm | 32mm | Adjustable thread |
| V60 TYP VK | 5mm | 50mm | Threaded bolt shaft |
| V80 TYP KS | 10mm | 45mm | Larger collar screw |
| V80 TYP GH | 31mm | 65mm | Larger spring mechanism |
| V80 TYP EH | 22mm | 38mm | Larger adjustable thread |
| V80 TYP VK | 6mm | 87mm | Longer threaded bolt |

#### 3. Countersink (for EH/VK Types)
```
Type: Drill (conical)
Diameter: 50mm
Depth: 7mm
Purpose: Flush mounting for screw heads or nut access
Position: Concentric with primary hole
```

#### 4. Mounting Holes (for Set Configurations)
```
Type: Drill
Quantity: 4
Diameter: 4-6mm
Depth: 50-60mm
Pattern: Matches female pattern
Purpose: Pre-drill for male plate mounting screws
```

---

## Context Menu Commands (Right-Click Triggers)

After inserting a PC instance, right-click it to access these commands:

### swap Beams
**Purpose**: Reverses the male/female beam assignment

**Effect**:
- `_Beam[0]` and `_Beam[1]` are swapped
- All machining operations recalculate for the new beam assignments
- Connector orientation flips to match the new female beam face

**Use Case**: If you selected beams in the wrong order during insertion, use this instead of deleting and reinserting.

**Script Detail**: Sets execution loops to 2 to force full recalculation.

---

### swap Direction
**Purpose**: Reverses the orientation of the connector along the Z-axis

**Effect**:
- Flips the connector 180° around the distribution axis
- All drills and mortises mirror accordingly
- Visual representation updates

**Use Case**: Adjust for load direction requirements or aesthetic preferences.

**Script Detail**: Toggles `iSwapDirection` flag in the internal Map.

---

### generate Single Instances
**Purpose**: Converts a distributed array into individual PC instances

**Effect**:
- Each connector in the distribution becomes a separate TslInst
- Each instance inherits all properties from the parent
- Allows independent editing of each connector

**Use Case**:
- Adjust spacing for one specific connector in an array
- Remove individual connectors without affecting others
- Modify tooling parameters for specific locations only

**Warning**: After generating single instances, the original distributed instance is deleted. This action cannot be undone except via AutoCAD Undo.

**Script Detail**:
- Loops through all `ptsDis[]` positions
- Creates new PC instance at each position with `TslInst.dbCreate()`
- Transfers all property values via `setPropValuesFromMap(mapTsl)`
- Sets distribution parameters to single-connector mode

---

## Product Selection via OPM Key

For automated workflows, you can insert PC with pre-selected products using OPM keys:

### Syntax
```
Knapp?V60?[Product Name]
```

### Examples
```
Knapp?V60?Walco V60 TYP KS
Knapp?V80?Walco V80 TYP GH
Knapp?V60?Walco V60 WALCO 60 VS
```

### Usage in Commands
```lisp
(defun c:TSLCONTENT()
  (hsb_ScriptInsert "PC" "Knapp?V60?Walco V60 TYP KS"))
TSLCONTENT
```

**Behavior**:
- If OPM key matches a valid Manufacturer/Family/Product combination, the dialog is skipped
- Manufacturer and Family become read-only
- Product is pre-selected
- User proceeds directly to interactive placement

**Fallback**:
- If OPM key is invalid, the script shows a notice and opens the full dialog

---

## Catalog System Integration

PC supports saved catalog configurations for frequently-used setups.

### Catalog Storage
- Stored in `{Company Path}\TSL\Catalog\PC *.xml`
- Each catalog entry saves a complete property set
- Catalog names can be used as OPM keys

### Creating Catalog Entries
1. Insert a PC instance
2. Configure all properties (product, distribution, tooling overrides)
3. Save to catalog via hsbCAD catalog tools
4. Name the catalog entry (e.g., "Standard V60 Distribution")

### Using Catalog Entries
```lisp
(hsb_ScriptInsert "PC" "Standard V60 Distribution")
```

The instance will load with all saved properties pre-filled.

---

## XML Configuration Structure

The PC.xml file defines all available products and their machining specifications. Understanding this structure helps when requesting custom WALCO configurations.

### Hierarchy
```
Manufacturer[]
  └─ Manufacturer (Name: "Knapp")
      └─ Family[]
          ├─ Family (Name: "V60")
          │   ├─ Sperrklappe (Clip Lock specifications)
          │   └─ Product[]
          │       ├─ Product (Name: "Walco V60 TYP KS")
          │       │   ├─ Article[] (Article numbers and descriptions)
          │       │   ├─ Connector (Plate dimensions)
          │       │   ├─ ConnectorNail (Fixing screw specs)
          │       │   ├─ MillFemale (Female milling dimensions)
          │       │   ├─ DrillFemale (Female drill pattern)
          │       │   ├─ ScrewMale (Male screw specs)
          │       │   ├─ DrillMale (Male drill dimensions)
          │       │   ├─ DrillMaleSinkHole (Optional countersink)
          │       │   ├─ MillMale (For Set configs only)
          │       │   └─ DrillMale2 (For Set configs only)
          │       ├─ Product (...)
          │       └─ ...
          └─ Family (Name: "V80")
              └─ Product[] (...)
```

### Key XML Sections

#### Connector (Plate Dimensions)
```xml
<lst nm="Connector">
  <dbl nm="Width" ut="L" vl="60"/>      <!-- Plate width in mm -->
  <dbl nm="Length" ut="L" vl="60"/>     <!-- Plate length in mm -->
  <dbl nm="Thickness" ut="L" vl="12"/>  <!-- Plate thickness in mm -->
</lst>
```

#### DrillFemale (Pilot Hole Pattern)
```xml
<lst nm="DrillFemale">
  <int nm="Quantity" vl="3"/>           <!-- Number of holes -->
  <dbl nm="Diameter" ut="L" vl="4"/>    <!-- Drill diameter -->
  <dbl nm="Depth" ut="L" vl="50"/>      <!-- Drill depth -->
  <dbl nm="x1" ut="L" vl="22.5"/>       <!-- Hole 1 X offset -->
  <dbl nm="y1" ut="L" vl="0"/>          <!-- Hole 1 Y offset -->
  <dbl nm="x2" ut="L" vl="0"/>          <!-- Hole 2 X offset -->
  <dbl nm="y2" ut="L" vl="-22.5"/>      <!-- Hole 2 Y offset -->
  <dbl nm="x3" ut="L" vl="-22.5"/>      <!-- Hole 3 X offset -->
  <dbl nm="y3" ut="L" vl="0"/>          <!-- Hole 3 Y offset -->
</lst>
```

### Adding Custom Products

To add a new WALCO variant:

1. Open `{Installation Path}\Content\General\TSL\Settings\PC.xml`
2. Duplicate an existing `<lst nm="Product">` block
3. Modify:
   - Product Name
   - Article numbers
   - Connector dimensions
   - Drill/Mill specifications
4. Save to company path: `{Company Path}\TSL\Settings\PC.xml`
5. Reload hsbCAD or use `TSLRELOAD` command

**Important**: The script validates XML version on first instantiation. Mismatched versions trigger a warning.

---

## Technical Details

### Coordinate System Logic

The script uses intelligent face detection:

1. **Beam Bounding Box**: Calculates `Quader` (box) for the female beam
2. **Face Vectors**: Identifies all six face normal vectors (±X, ±Y, ±Z)
3. **View Projection**: Determines which face is most visible to your current view
4. **Valid Faces**: Filters faces that are large enough to accommodate the connector
5. **Click Detection**: Projects your click point onto the selected face plane
6. **Distribution Plane**: Creates a plane on that face for distribution

**Coordinate System Variables**:
- `vecX`, `vecY`, `vecZ` = Beam's local axes
- `vecPlane` = Normal vector of selected face (outward)
- `vecXplane`, `vecYplane` = In-plane axes for distribution
- `ptCen` = Beam center point
- `qd` = Quader (bounding box) of female beam

### Jig (Preview) System

During interactive placement, the script uses a custom jig system:

**Visual Elements**:
1. **Face Highlight**: Semi-transparent plane showing distribution surface
2. **Connector Preview**: 3D representation of connector plate at cursor
3. **Distribution Preview**: All connectors shown along distribution line
4. **Crosshair**: Circle + cross at each connector center

**Jig Execution**:
- Triggered by `_bOnJig` flag with `_kExecuteKey == "strJigAction1"`
- Reads jig point from `_Map.getPoint3d("_PtJig")`
- Projects point onto distribution plane
- Updates display in real-time as cursor moves

**Performance Note**: The jig graphical interface code exists but is disabled (`&& 0` condition). This was likely for debugging and is currently inactive.

### Distribution Calculation

The script implements three distribution modes:

#### Mode 1: Even Distribution (Positive Spacing)
```
totalDistance = endPoint - startPoint - startDist - endDist
numberOfParts = ceil(totalDistance / (spacing + partLength))
actualSpacing = totalDistance / numberOfParts
```

**Result**: Connectors evenly distributed, may have spacing < requested

#### Mode 2: Fixed Distribution (Positive Spacing)
```
numberOfParts = floor(totalDistance / (spacing + partLength))
actualSpacing = spacing (exactly)
plus one connector at each end
```

**Result**: Exact spacing, may leave gap before end

#### Mode 3: Quantity Distribution (Negative Spacing)
```
numberOfParts = abs(spacingValue)
actualSpacing = totalDistance / (numberOfParts - 1)
```

**Result**: Exact quantity, even spacing

**Edge Cases**:
- If `startDist + endDist > totalLength`: Error message, no placement
- If spacing too large for even 1 connector: Error message
- If quantity = 1: Single connector at start + startDist

### Body Construction

The connector plate 3D representation is meticulously constructed:

#### Collar Screw Geometry
```c
Body bdScrew = cylinder (Ø22mm × 25mm)  // Main collar
  + cylinder (Ø22mm × 7mm)              // Washer
  + cylinder (Ø12mm × 5.5mm)            // Shaft extension
  + cone (Ø12mm → Ø24mm × 6mm)          // Tapered collar
  + cylinder (Ø24mm × 0.5mm)            // End cap
```

#### Connector Plate Geometry
```c
Body bd = box (60×60×12mm)              // Base plate
  - bdScrew                              // Subtract collar screw
  - cone (Ø33.65mm → Ø18mm × 10mm)      // Central recess
  - extruded profile (skew cutouts)     // Side chamfers
  - fillet corners (Ø15mm radius)       // Rounded corners
  - drill holes (Ø6.3mm × 4 corners)    // Mounting holes
```

**Mirror Operations**: All features are mirrored across X and Z planes for symmetry.

**Purpose**: Visual representation for drawing documentation and 3D previews.

---

## Bill of Materials (BOM) Integration

The PC script automatically generates BOM entries for:

### Female Beam Components
- **1× Connector Plate** (e.g., "WALCO V 60", Article K100/Set)
- **3-4× Hex-head wood screws** (Ø6mm × 50mm or Ø10mm × 60mm)
- **1× Clip Lock** (if enabled, Article K112/K113)

### Male Beam Components
- **1× Male Screw** (varies by product)
  - Collar Screw (e.g., "Collar Screw 12×60mm", Article K102)
  - Spring Holding Screw (e.g., "Spring Holding Screw M12", Article K106)
  - Adjustable Holding Screw (e.g., "Adjustable Holding Screw M12", Article K104)
  - Threaded Bolt (e.g., "Collar Bold Holding Screw", Article K108)

### Set Configurations (Double-Sided)
- **2× Connector Plates** (one female, one male)
- **6-8× Hex-head wood screws** (for both plates)
- **1× Male Screw Component**

**BOM Extraction**: Article numbers and quantities are read from the XML `<lst nm="Article[]">` sections.

---

## Troubleshooting

### Issue: Dialog doesn't appear on insertion
**Cause**: OPM key provided but invalid
**Solution**: Check console for error message. Remove OPM key or correct spelling.

---

### Issue: "No distribution possible" message during placement
**Cause**: Start Distance + End Distance exceeds total length
**Solution**:
- Increase distance between first and second point
- Reduce Start Distance or End Distance values
- Use command line keywords to adjust values before clicking

---

### Issue: Drilling holes don't align with connector plate holes
**Cause**:
- Custom drill pattern in XML doesn't match visual geometry
- Beam face not perfectly flat
- Offset value shifts connector but not drill pattern

**Solution**:
- Verify XML drill coordinates match connector design
- Set Offset = 0 if using custom overrides
- Check beam geometry for warping

---

### Issue: Milling depth seems incorrect
**Cause**:
- Clip Lock enabled (adds 3mm automatically)
- Override value not matching XML default
- Multiple products selected with different defaults

**Solution**:
- Check "Clip Lock" property (Yes/No)
- Review "Depth" property tooltip for current default value
- Set explicit override value if needed

---

### Issue: Cannot see connector preview during placement
**Cause**:
- View direction perpendicular to beam face
- Beam geometry not valid (corrupted solid)
- Script jig code disabled

**Solution**:
- Rotate 3D view to see beam face at angle
- Regenerate beam with `EXPLODE` → `SUBTRACT`
- Use 2D projection mode (disabled jig graphics don't affect functionality)

---

### Issue: "Wrong definition of the map" error on insertion
**Cause**:
- XML file missing required sections
- XML version mismatch between installation and company paths
- Corrupted XML file

**Solution**:
- Check console message for specific missing section
- Compare XML version numbers (GeneralMapObject\Version)
- Restore XML from backup or reinstall hsbCAD

---

### Issue: Swap Beams command has no effect
**Cause**:
- Both beams are identical (same dimensions/orientation)
- Alignment face cannot flip (e.g., Z-axis connector)

**Solution**:
- Verify beams are different sizes or orientations
- Check that connector is placed on X or Y face (not Z)
- Delete and reinsert if needed

---

## Best Practices

### 1. Beam Preparation
- Ensure beams are solid, valid 3D bodies before inserting PC
- Verify beam faces are flat and perpendicular
- Avoid placing connectors near beam ends (< 50mm clearance)

### 2. Product Selection
- Use V60 for beams < 100mm thickness
- Use V80 for beams ≥ 100mm thickness
- Choose "Set" configurations for equal-strength double-sided connections
- Use "TYP KS" (collar screw) for most applications
- Use "TYP GH/EH" (adjustable) for connections requiring post-installation adjustment
- Use "TYP VK" (bolt) for disassemble-able connections

### 3. Distribution Planning
- Start Distance ≥ 50mm (avoid splitting near edges)
- End Distance ≥ 50mm
- Spacing ≥ 200mm (minimum per structural code)
- Use Even mode for aesthetic regularity
- Use Fixed mode for code-required spacing
- Use Quantity mode (-N) for exact counts

### 4. Machining Overrides
- Leave defaults (0) unless compensating for:
  - Non-standard connector plates
  - Beam tolerances > ±2mm
  - Special CNC machine limitations
- Always test overrides on scrap before production
- Document custom values in project notes

### 5. Quality Control
- Verify drill patterns in 3D view before sending to CNC
- Check milling depth against actual plate thickness
- Ensure Clip Lock setting matches physical parts inventory
- Use "generate Single Instances" for final adjustment phase
- Cross-reference BOM against actual WALCO product catalog

### 6. Performance Optimization
- For distributions > 20 connectors, consider splitting into multiple instances
- Use catalog entries for repetitive configurations
- Disable orientation drill if not needed (reduces CNC operations)
- Recalculate only when necessary (modifying properties triggers full recalc)

---

## Advanced Usage

### Custom Product Addition

To add a non-standard WALCO configuration:

1. **Determine Specifications**
   - Connector plate dimensions (W×L×T)
   - Screw type and dimensions
   - Milling requirements (female and male if Set)
   - Drill patterns (quantity, diameter, depth, positions)

2. **Edit XML**
   ```xml
   <lst nm="Product">
     <str nm="Name" vl="Custom V60 Heavy Duty"/>
     <str nm="url" vl="https://..."/>
     <lst nm="Article[]">...</lst>
     <lst nm="Connector">
       <dbl nm="Width" ut="L" vl="70"/>
       <dbl nm="Length" ut="L" vl="70"/>
       <dbl nm="Thickness" ut="L" vl="15"/>
     </lst>
     <lst nm="MillFemale">...</lst>
     <lst nm="DrillFemale">...</lst>
     <!-- etc -->
   </lst>
   ```

3. **Test Insertion**
   - Insert with OPM key: `Knapp?V60?Custom V60 Heavy Duty`
   - Verify all machining operations
   - Check 3D representation (note: hardcoded body may not match custom dimensions)

4. **Deploy**
   - Copy XML to company path
   - Distribute to team
   - Add to project standards documentation

### Parametric Workflow Integration

For automated project-wide connector placement:

```lisp
; Example: Distribute V60 connectors on all beam-to-beam intersections
(defun c:AutoConnectors ()
  (setq beamPairs (detectBeamIntersections))  ; Custom function
  (foreach pair beamPairs
    (setq beam1 (car pair))
    (setq beam2 (cadr pair))
    ; Insert PC with preset configuration
    (command "_.INSERT" "PC" "Knapp?V60?Walco V60 TYP KS"
      (list beam1 beam2)
      "Even" "100" "100" "300")
  )
)
```

### Shop Drawing Automation

PC instances can be queried for shop drawing automation:

```lisp
; Extract all PC connectors for a specific beam
(defun getPCToolsForBeam (beamEntity / result)
  (setq result '())
  (vlax-for tool (vlax-ename->vla-object beamEntity)
    (if (= (vla-get-ScriptName tool) "PC")
      (setq result (append result (list tool)))
    )
  )
  result
)
```

**Use Cases**:
- Generate connector placement schedules
- Create CNC cut lists with tool paths
- Export to external BOM systems
- Validate structural code compliance (spacing, edge distances)

---

## Related TSL Scripts

PC works in conjunction with these hsbCAD scripts:

- **hsbNailing**: For additional screw/nail patterns around connectors
- **hsbDrill**: Manual drill placement for custom pilot holes
- **Mortise**: Manual mortise creation if PC doesn't handle specific cases
- **hsbBOM**: Bill of materials extraction and reporting
- **hsbElementTable**: Generates element lists including connector quantities
- **hsbMetalPart-LinkDummyTools**: Links visual connector representations to tooling

---

## Appendix: Complete Product List

### WALCO V60 Products

| Product Code | Product Name | Male Component | Article # |
|--------------|--------------|----------------|-----------|
| TYP KS | Walco V60 TYP KS | Collar Screw 12×60mm | K102 |
| TYP GH | Walco V60 TYP GH | Retaining Spring Holding Screw M12 | K106 |
| TYP EH | Walco V60 TYP EH | Retaining Holding Screw M12 | K104 |
| TYP VK D12 | Walco V60 TYP VK D12 | Collar Bold Holding Screw | K108 |
| WALCO 60 VS | Walco V60 WALCO 60 VS | Set (Double-Sided) | K701/Set + K100/Set |
| WALCO 60 VK | Walco V60 WALCO 60 VK | Set (Double-Sided) | K700/Set + K100/Set |
| WALCO 60 M12 | Walco V60 WALCO 60 M12 | Set (Double-Sided) | K702/Set + K100/Set |
| WALCO 60 M12-2 | Walco V60 WALCO 60 M12-2 | Set (Variant) | K702/Set + K100/Set |

### WALCO V80 Products

| Product Code | Product Name | Male Component | Article # |
|--------------|--------------|----------------|-----------|
| TYP KS | Walco V80 TYP KS | Collar Screw 16×60mm | K103 |
| TYP GH | Walco V80 TYP GH | Retaining Spring Holding Screw M16 | K107 |
| TYP EH | Walco V80 TYP EH | Retaining Holding Screw M16 | K105 |
| TYP VK D16 | Walco V80 TYP VK D16 | Collar Bold Holding Screw | K109 |
| Langloch KS | Walco V 80 Langloch KS | Langloch Collar Screw 16×60mm | K115 |
| Langloch VK | Walco V 80 Langloch VK | Langloch Collar Bold Holding Screw | K116 |
| WALCO 80 VS / V80 | Walco 80 VS / V80 | Set (Double-Sided) | K711/Set + K101/Set |
| WALCO 80 VK / V80 | Walco 80 VK / V80 | Set (Double-Sided) | K710/Set + K101/Set |
| WALCO 80 M16 / V80 | Walco 80 M16 / V80 | Set (Double-Sided) | K712/Set + K101/Set |
| WALCO 80 M16 / V80-2 | Walco 80 M16 / V80-2 | Set (Variant) | K712/Set + K101/Set |

### Optional Components

| Component | Description | Article # |
|-----------|-------------|-----------|
| Clip Lock V60 | WALCO V Clip Lock | K112 |
| Clip Lock V80 | WALCO V Clip Lock | K113 |

---

## Summary

The **PC (Plate Connector)** script is a comprehensive tool for automated Knapp WALCO connector placement in timber construction. It handles product selection, interactive placement, distribution calculation, machining operation generation, and BOM integration in a single workflow.

By understanding the hierarchical product structure (Manufacturer → Family → Product), distribution modes (Even/Fixed/Quantity), and machining parameters (milling/drilling for both beams), users can efficiently specify complex connector arrays with full CNC-ready tooling output.

The XML-driven configuration system allows for easy expansion to custom products, while the intelligent face detection and interactive jig system provide intuitive visual feedback during placement.

For standard WALCO V60/V80 applications, the script's default values require minimal user intervention. For specialized projects, the comprehensive property override system and catalog integration enable precise control over every aspect of the connection.

**Key Workflow**: Select beams → Choose product → Click distribution points → Verify properties → Generate CNC output.

**Documentation Version**: Based on PC v1.4 (July 21, 2021)
