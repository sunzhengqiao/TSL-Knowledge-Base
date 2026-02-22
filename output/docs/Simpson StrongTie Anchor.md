# Simpson StrongTie Anchor

## Overview

The **Simpson StrongTie Anchor** script creates and manages hold-down anchors for timber-framed walls. Hold-down anchors are critical structural hardware that resist uplift forces at wall ends, corners, and openings in timber construction. This script places the anchor on selected beams (typically wall studs), generates the 3D metal bracket representation, applies machining tooling to the host beam, optionally creates mounting sheets (sheathing panels) and blocking members in the bay where the anchor is located, and registers the anchor as a hardware component in the bill of materials.

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 2.13 (November 11, 2025) |
| **Required Beams** | 0 (selected during insertion) |
| **Category** | Hardware / Connector / Hold-Down |
| **Manufacturer** | Simpson StrongTie |
| **Keywords** | Simpson, anchor, HTT, hold-down, uplift |

---

## Script Metadata

### Header Information

| Header | Value | Description |
|--------|-------|-------------|
| `#Version` | 8 | TSL format version |
| `#Type` | O | Object-type script (programmatic insertion) |
| `#NumBeamsReq` | 0 | No fixed beam requirement (user selects during insertion) |
| `#MajorVersion` | 2 | Major version number |
| `#MinorVersion` | 13 | Minor version number |
| `#DxaOut` | 1 | DXF output enabled |
| `#ImplInsert` | 1 | Implicit insertion enabled |
| `#FileState` | 1 | File state flag |

### Version History

| Version | Date | Change Description | Author |
|---------|------|-------------------|--------|
| 2.13 | 11.11.2025 | HSB-24881: Add property "CNC catalog" for hsbCNC TSL; Implement onDbErase cleanup | Marsel Nakuci |
| 2.12 | 15.03.2022 | HSB-14511: Tooling width/height defined as extra measures | Marsel Nakuci |
| 2.11 | 04.03.2022 | HSB-14511: Add properties to add tooling for each sheeting zone | Marsel Nakuci |
| 2.10 | 04.12.2019 | HSB-6082: Show display from the blocks | Marsel Nakuci |
| 2.9 | 04.12.2019 | HSB-6109: Fix gap calculation (dXTotal = dC + dInterdistance) | Marsel Nakuci |
| 2.8 | 03.12.2019 | HSB-6081: Families are read from XML | Marsel Nakuci |
| 2.7 | 03.12.2019 | HSB-6081: Transfer families and parameters into XML | Marsel Nakuci |
| 2.6 | 03.12.2019 | HSB-6081: Add family HD | Marsel Nakuci |
| 2.5 | 16.10.2019 | Bugfix: Family AH avoid creating triangles | Nils Gregor |
| 2.4 | 24.09.2018 | New family added: AH | Thorsten Huck |
| 2.3 | 14.09.2018 | Bugfix: Supports special type overrides | Thorsten Huck |
| 2.2 | 13.09.2018 | Bugfix: Placement on icon/opposite side in plan view (take II) | Thorsten Huck |
| 2.1 | 13.09.2018 | Bugfix: Placement on icon/opposite side in plan view | Thorsten Huck |
| 2.0 | 13.09.2018 | Supports special type overrides based on projectSpecial settings | Thorsten Huck |
| 1.9 | 10.09.2018 | Icon side is default side of mounting sheet with alignment left/right | Thorsten Huck |
| 1.8 | 04.07.2018 | New property to specify the side of the mounting sheet | Thorsten Huck |
| 1.7 | 12.06.2018 | Bugfix: Unit conversion | Thorsten Huck |
| 1.6 | 11.06.2018 | Bugfix: Alignment beam | Thorsten Huck |
| 1.5 | 06.06.2018 | Bugfix | Thorsten Huck |
| 1.4 | 06.06.2018 | Sheet based on first zone defined | Thorsten Huck |
| 1.3 | 06.06.2018 | Creates blocking if in between studs and with mounting sheet; requires hsbCNC 6.8+ | Thorsten Huck |
| 1.2 | 17.04.2018 | Translation issue fixed | Thorsten Huck |
| 1.1 | 14.03.2018 | Bugfixes | Thorsten Huck |
| 1.0 | 14.03.2018 | Initial release | Thorsten Huck |

---

## Usage Environment

| Environment | Supported | Notes |
|------------|-----------|-------|
| **Model Space** | ✓ Yes | Primary environment — place anchors on 3D wall studs |
| **Paper Space** | ✗ No | Not designed for layout or paper space use |
| **Shop Drawing** | ✗ No | This is a model-level hardware insertion script |

**Workflow Context**: This script operates in the **Model Space** during the wall framing phase. It is typically used after wall elements have been created and before final sheet/sheathing distribution. The script integrates with the element zone system and can automatically create mounting sheets and CNC tooling for fabrication.

---

## Prerequisites

### Required Entities
- **At least one GenBeam** (typically a wall stud or post)
- **Element Association**: For full functionality (mounting sheets, zone detection, CNC tooling), the selected beam should belong to an Element (wall/floor/roof)

### Settings File
The script reads product catalog data from an XML configuration file:

**File name**: `Simpson StrongTie Anchor.xml`

**Search locations** (in order):
1. Company path: `[hsbCompany]\TSL\Settings\Simpson StrongTie Anchor.xml`
2. Installation path: `[hsbInstall]\Content\General\TSL\Settings\Simpson StrongTie Anchor.xml`

**Fallback behavior**: If no XML file exists, the script creates a default HTT family configuration automatically with HTT5 as the default model.

### Software Requirements
- **hsbCNC version 6.8 or higher** (for sheet-level CNC tooling integration)

### Optional Resources
- **Block files**: For enhanced 2D representation, matching AutoCAD block files (`.dwg`) can be placed in `[hsbCompany]\Block\` named after the model (e.g., `HTT5.dwg`, `AH9035.dwg`) or family (e.g., `HTT.dwg`)

---

## Supported Product Families

The script supports multiple Simpson Strong-Tie hold-down anchor families. Families and their models are defined in the XML settings file and can be extended by users.

### Default Families

| Family Code | Full Name | Description | Typical Use | Geometric Features |
|-------------|-----------|-------------|-------------|-------------------|
| **HTT** | Hold-Down Tension Tie | Standard hold-down with triangular side plates | Wall studs, uplift resistance at wall ends | L-shaped bracket with triangular gusset plates |
| **AH** | Angle Hold-Down | Angle-type anchor brackets | Various wall heights and load capacities | Simple L-shaped angle bracket without gussets |
| **HD** | Heavy-Duty Hold-Down | High-capacity hold-downs | High-load applications, engineered walls | Reinforced L-bracket with larger base plate |

### Product URLs
The script automatically sets hyperlinks to Simpson Strong-Tie product pages based on your system's language setting:

- **English**: strongtie.co.uk
- **German**: strongtie.de
- **French**: simpson.fr

### Default HTT Models

The default XML configuration includes the HTT5 model. Additional models are typically defined in the deployed XML file:

| Model | A (Height) | B (Depth) | C (Width) | t (Thickness) | tB (Base Thickness) | Nail Holes (A) | Base Bolt Ø |
|-------|-----------|-----------|-----------|--------------|-------------------|---------------|-------------|
| HTT5 | 404 mm | 62 mm | 64 mm | 3.0 mm | 11.4 mm | 26 | Ø 17.5 mm |
| HTT22* | 559 mm | 62 mm | 64 mm | 3.0 mm | 11.4 mm | 32 | Ø 17.5 mm |

*Additional models (HTT22, various AH and HD sizes) are defined in the XML configuration deployed at your company.

### Model Parameter Definitions

Each model in the XML file is defined by the following parameters:

| Parameter | Unit | Description |
|-----------|------|-------------|
| **A** | mm | Total height of the vertical leg |
| **B** | mm | Depth of the base plate (horizontal leg) |
| **C** | mm | Width of the anchor bracket |
| **t** | mm | Thickness of the vertical leg sheet metal |
| **tB** | mm | Thickness of the base plate sheet metal |
| **diamA** | mm | Diameter of nail holes on the vertical leg |
| **nDiamA** | count | Number of nail holes on the vertical leg |
| **zOffsetBase** | mm | Z-offset from bracket base to base bolt hole centerline |
| **diamBase** | mm | Diameter of base bolt hole in the bracket |
| **diamPlate** | mm | Diameter of base bolt hole drilled through the bottom plate |
| **nDiamB** | count | Number of base bolts (typically 1) |
| **dATriang** | mm | Height of triangular gusset plate (HTT family only; set to 0 for AH/HD) |

---

## Usage Steps

### Step 1: Launch the Script

The script is **best launched from the ribbon or palette** for a streamlined workflow. It supports multiple insertion methods:

#### Method A: Silent Insertion with Preset (Recommended)
Launch from ribbon/palette with a family-model token:
```
hsb_ScriptInsert "Simpson StrongTie Anchor" "HTT?HTT5"
```
This silently applies the saved catalog entry "HTT5" from the HTT family without showing any dialog.

#### Method B: Family-Preset Insertion
Launch with only the family preset:
```
hsb_ScriptInsert "Simpson StrongTie Anchor" "HTT"
```
This locks the family to HTT and shows the model selection dialog.

#### Method C: Manual Insertion
Launch without any preset (shows 2-step dialogs):
```
hsb_ScriptInsert "Simpson StrongTie Anchor"
```

**Available command shortcuts**:
- HTT family: `hsb_ScriptInsert "Simpson StrongTie Anchor" "HTT"`
- AH family: `hsb_ScriptInsert "Simpson StrongTie Anchor" "AH"`

### Step 2: Select Family and Model

**If launched without a family preset**:
1. A dialog appears prompting you to choose the anchor family (HTT, AH, HD, or other families defined in your settings)
2. Select the desired family and press **OK**
3. A second dialog appears with the model selection list for that family

**If launched with a family preset**:
1. The family is locked (read-only)
2. A dialog appears with the model list for that family
3. Select the desired model (e.g., HTT5, HTT22, AH9035)

**If launched with a family-model token**:
- No dialog appears; the script silently applies the catalog preset

**Catalog Auto-Creation**: On first insertion for a family, the script automatically creates default catalog entries for all models within that family. Subsequent insertions can then use these saved presets.

### Step 3: Select Beam(s)

After confirming the model selection, the command line prompts:

> **Select beam(s)**

**What to do**:
1. Click on one or more beams (studs or posts) where the anchor should be placed
2. You can select multiple beams in a single operation
3. Press **Enter** to confirm the selection

**Selection Tips**:
- Select wall studs at corners or wall ends for uplift resistance
- Select studs adjacent to large openings (doors, windows) where uplift forces are critical
- For multi-story construction, select studs that align vertically across floors

### Step 4: Specify Reference Side

Depending on the beam orientation relative to the element coordinate system:

#### For Vertical Studs in Plan View (Z-axis parallel to element Z):
The command line prompts you to type the side designation:

> **Select side [Iconside/Left/Opposite Side/Right]**

**What to do**:
- Type the **first letter** of the desired side:
  - **I** = Icon Side (positive Z direction of element)
  - **L** = Left Side (negative X direction of element)
  - **O** = Opposite Side (negative Z direction of element)
  - **R** = Right Side (positive X direction of element)
- Press **Enter**

#### For Other Orientations:
The command line prompts:

> **Pick side**

**What to do**:
- Click a point on the beam face where you want the anchor to be attached
- The script automatically snaps to the nearest beam face and determines the alignment direction

### Step 5: Automatic Placement

After confirming the side selection, the script automatically:

1. **Creates separate anchor instances**: One TslInst is created for each selected beam
2. **Positions the anchor**: Places it on the chosen face at the bottom plate elevation (ptOrg of element)
3. **Generates 3D geometry**: Creates the metal bracket solid with correct dimensions
4. **Applies tooling**: If milling depth > 0, creates a BeamCut recess in the host beam
5. **Drills base bolt hole**: Creates a drill through any bottom plate below the anchor
6. **Creates mounting sheets** (if configured): Generates sheathing panels in element zones
7. **Creates blocking** (if applicable): Inserts a blocking member between studs when anchor is on left/right face
8. **Spawns CNC tooling**: Attaches hsbCNC instances to mounting sheets for fabrication
9. **Registers hardware**: Adds the anchor to the bill of materials with manufacturer and model information
10. **Erases original instance**: The initial insertion instance removes itself after distributing clones

**Result**: Each selected beam now has an anchor instance associated with it, visible in both Model Space (3D) and element views (2D).

---

## Properties Panel Parameters

### Category: Model

| Parameter | Type | Default | Editable | Description |
|-----------|------|---------|----------|-------------|
| **Family** | String (dropdown) | First available family | Read-only after insertion | Selects the product family (HTT, AH, HD). Change via right-click menu "-> [FamilyName]". |
| **Model** | String (dropdown) | First model in family | Yes | Selects the specific model within the chosen family (e.g., HTT5, HTT22, AH9035). Available models are populated from the XML settings file. |

**Business Logic**:
- The **Family** property determines which product line to use
- The **Model** property determines the exact geometric dimensions (A, B, C, t, etc.)
- Changing the model recalculates the 3D geometry, tooling, and hardware BOM entry
- The model list is dynamically populated based on the selected family

**Dependencies**:
- Model ← depends on Family
- All geometric calculations ← depend on Model parameters from XML

### Category: Alignment

| Parameter | Type | Default | Editable | Description |
|-----------|------|---------|----------|-------------|
| **Axis Offset** | Double (mm) | 0 | Yes | Z-axis offset from the beam center to shift the anchor position along the element thickness direction. Positive values move toward the element's positive Z direction. |
| **Inter Distance** | Double (mm) | 0 | Yes | Creates two anchors symmetrically spaced when set > anchor depth (B dimension). Set to 0 for a single anchor. The script validates beam face width to ensure both anchors fit. |

**Business Logic**:

**Axis Offset**:
- Used to position the anchor off-center from the beam when required by design
- Automatically clamped to prevent the anchor from exceeding the beam boundary
- Calculation: `dMaxZOffset = 0.5 × (element beam width - C) - (0.5 × Inter Distance if > 0)`
- Applied along the element's Z-axis (thickness direction)
- Common use case: Offset anchor when beam is wider than typical stud width

**Inter Distance**:
- When > 0 and > B (anchor depth), creates two anchors side-by-side
- Anchors are placed symmetrically: `± 0.5 × Inter Distance` from the beam center along vecXC
- Validation checks:
  - Must be either 0 (single anchor) or > B (anchor depth)
  - Beam face width must be ≥ `2 × B + Inter Distance` (room for both anchors)
- Common use case: Dual hold-downs on wide studs or posts for increased uplift capacity

**Dependencies**:
- Axis Offset maximum value ← depends on element beam width, anchor width (C), and Inter Distance
- Inter Distance validation ← depends on anchor depth (B) and beam face width

### Category: Tooling

These parameters control the machining operations applied to the host beam and mounting sheets.

| Parameter | Type | Default | Editable | Description |
|-----------|------|---------|----------|-------------|
| **Depth** | Double (mm) | 0 | Yes | Milling depth into the beam face to recess the anchor bracket. Set to 0 for surface-mounted anchors (no milling). |
| **Gap** | Double (mm) | 0 | Yes | Additional clearance added to the milling pocket in both length and width directions. Creates a larger recess than the anchor footprint. |
| **Tooling Index** | String | (empty) | Yes | CNC tool index for each sheeting zone. Separate multiple entries with semicolons (`;`). Each entry corresponds to a zone from inside to outside. |
| **Tooling Type** | String | "Saw" | Yes | CNC tooling type for each sheeting zone. Separate entries with semicolons (`;`). Valid: `Saw`, `Milling`, `SawNoNail`, `MillingNoNail` or numeric `1`, `2`, `3`, `4`. |
| **Tooling Width** | String | (empty) | Yes | Additional tooling width (mm) applied to the CNC cut for each zone. Semicolon-separated values. |
| **Tooling Height** | String | (empty) | Yes | Additional tooling height (mm) applied to the CNC cut for each zone. Semicolon-separated values. |

**Business Logic**:

**Depth & Gap**:
- A BeamCut is applied to the host beam with dimensions:
  - Width: `dXTotal + 2 × Gap` where `dXTotal = C + Inter Distance`
  - Height: `A + Gap`
  - Depth: `Depth`
- The beamcut is centered at the anchor reference point and cuts into the beam face
- Set Depth = 0 to disable milling (surface-mounted anchor)
- Gap provides clearance for anchor installation and tolerances

**Tooling Index, Type, Width, Height**:
- These are **zone-specific** parameters for mounting sheet CNC tooling
- Format: semicolon-delimited strings, one entry per zone (zones 1-5)
- Example: `"10;12;14;;16"` = tool index 10 for zone 1, 12 for zone 2, 14 for zone 3, skip zone 4, 16 for zone 5
- Empty or missing entries skip that zone (no CNC tooling created)
- **Tooling Type** values:
  - `Saw` or `1` = Saw cut with solid operation
  - `Milling` or `2` = Milling cut with solid operation
  - `SawNoNail` or `3` = Saw cut with solid operation + no-nail area
  - `MillingNoNail` or `4` = Milling cut with solid operation + no-nail area
- **Tooling Width/Height**: Extra dimensions added to the base CNC cut rectangle
  - Base rectangle: `(C + 2 × Tooling Width) × (A + Tooling Height)`
- Creates or updates hsbCNC child instances stored in _Map with keys "Cnc0" through "Cnc4"

**Dependencies**:
- BeamCut dimensions ← depend on Depth, Gap, C (model width), A (model height), Inter Distance
- CNC child TSL creation ← depends on all four Tooling parameters being non-empty for a zone

### Category: Mounting Sheet

These parameters control the optional sheathing panels created behind the anchor to provide a nailing surface.

| Parameter | Type | Default | Editable | Description |
|-----------|------|---------|----------|-------------|
| **Height** | Double (mm) | 625 | Yes | Height of the optional mounting sheet (sheathing panel) created behind the anchor. Set to 0 to disable mounting sheet creation. |
| **Coverage** | String | (empty) | Yes | Coverage (overlap) of mounting sheets per zone in mm. Separate entries with semicolons (`;`). Listed from inside to outside. Enter `0` to skip a zone. Extends sheet in both directions (height and width). |
| **Face** | String (dropdown) | "Icon Side" | Conditional | Determines which face of the element the mounting sheet is placed on: **Icon Side** or **Opposite Side**. Only editable when anchor is on left/right side of beam. |
| **CNC Catalog** | String (dropdown) | (empty) | Yes | Pre-defined CNC catalog for the hsbCNC TSL applied to every zone where a sheet is created. Leave empty to use default CNC parameters. |

**Business Logic**:

**Height**:
- Creates a rectangular sheet with height = Height and width = distance between studs
- Sheet is placed in each element zone where Coverage is non-zero or not specified
- Sheet inherits material and color from the corresponding element zone
- Sheet is positioned at the bottom plate elevation and extends upward by Height
- Set to 0 to completely disable mounting sheet and blocking creation

**Coverage**:
- Format: semicolon-delimited numeric values in mm, one per zone (zones 1-5 from inside out)
- Example: `"12;12;0;0;0"` = 12mm coverage on zones 1 and 2, skip zones 3-5
- Coverage extends the sheet dimensions:
  - Width: `base_width + 2 × Coverage`
  - Height: `Height + 2 × Coverage`
- Used to ensure sheets overlap adjacent studs or framing members
- Zero or empty = sheet exactly fits the bay without overlap

**Face**:
- Controls which side of the element the mounting sheet is placed on
- Only editable when anchor is on **left or right** face of beam (bLeftRight = true)
- When anchor is on icon/opposite face, this property is read-only and automatically set
- Options:
  - **Icon Side**: Mounting sheet on positive Z face of element
  - **Opposite Side**: Mounting sheet on negative Z face of element
- Can be toggled via right-click menu "Flip Mounting Side"

**CNC Catalog**:
- Dropdown populated from available hsbCNC catalog entries
- When specified, each mounting sheet zone gets an hsbCNC instance created with catalog parameters
- When empty, hsbCNC instances use default parameters:
  - Tool Type: Saw
  - Operation: Solid Operation with Nonail area
  - Tool Side: Automatic (or Right if nSide = -1)
  - Turning Direction: Against course
- CNC instances are stored in _Map with keys "CncMain0" through "CncMain4"
- Cleanup: CNC instances are automatically deleted when the anchor is erased (version 2.13+)

**Dependencies**:
- Sheet creation ← depends on Height > 0 AND element being valid
- Sheet dimensions ← depend on Height, Coverage, and beam spacing
- CNC creation ← depends on CNC Catalog OR default parameters
- Blocking creation ← depends on Height > 0 AND anchor on left/right face (bLeftRight)

**Workflow Integration**:
- Changing Height, Coverage, or Face triggers sheet re-creation (bCreateSheet = true)
- Sheets are assigned to element zone with layer code 'Z'
- Blocking is created at top of mounting sheet, assigned to zone 0 with layer code 'Z'
- Blocking inherits material from element zone 0
- Blocking is dynamically stretched to adjacent studs

---

## Right-Click Context Menu

The right-click menu provides quick access to repositioning and configuration commands without re-inserting the anchor.

### Side Repositioning Commands

| Menu Item | Description | Effect on _Pt0 | Available When |
|-----------|-------------|---------------|----------------|
| **Icon Side** | Moves anchor to icon side (positive Z direction) | `_Pt0 = ptCen + vecZ × 0.5 × beam_dD(vecZ)` | Always |
| **Opposite Side** | Moves anchor to opposite side (negative Z direction) | `_Pt0 = ptCen - vecZ × 0.5 × beam_dD(vecZ)` | Always |
| **Left Side** | Moves anchor to left side (negative X direction) | `_Pt0 = ptCen - vecX × 0.5 × beam_dD(vecX)` | Always |
| **Right Side** | Moves anchor to right side (positive X direction) | `_Pt0 = ptCen + vecX × 0.5 × beam_dD(vecX)` | Always |
| **Flip Mounting Side** | Toggles mounting sheet between icon side and opposite side | Toggles `bFlipMounting` flag, updates Face property | Only when anchor is on left/right face |

**Behavior Notes**:
- Side repositioning commands set the `bSetLocation` flag and trigger mounting sheet/blocking re-creation
- The anchor automatically snaps to the new face and recalculates all geometry
- Double-clicking the anchor has the same effect as selecting the "opposite side" context menu option

### Family Switching Commands

| Menu Item | Description | Effect |
|-----------|-------------|--------|
| **-> HTT** | Switches anchor to HTT family | Changes Family property, reloads model list, triggers recalculation |
| **-> AH** | Switches to AH family | Changes Family property, reloads model list, triggers recalculation |
| **-> HD** | Switches to HD family | Changes Family property, reloads model list, triggers recalculation |

**Behavior Notes**:
- One menu entry appears for each family **different from** the currently selected family
- Switching family preserves the anchor position but changes available models
- After switching family, you should verify the model selection is appropriate for the new family

### Utility Commands

| Menu Item | Description | Available When |
|-----------|-------------|----------------|
| **Reset + Erase** | Deletes all mounting sheets and blocking, then erases the anchor instance | When _Sheet.length() > 1 |
| **Export Xml** | Exports current settings map to XML file at company settings path | When XML file does not exist but MapObject is valid |

**Behavior Notes**:
- **Reset + Erase** is a destructive operation and cannot be undone (use with caution)
- **Export Xml** is useful for saving customized product catalogs to share across projects

---

## User Workflow

### Typical Workflow: Single Anchor on Wall Stud

1. **Launch script** from ribbon with family preset (e.g., "HTT")
2. **Select model** "HTT5" from dialog
3. **Select studs** at wall ends or corners (click multiple studs)
4. **Specify side** "I" (Icon Side) for exterior face placement
5. **Result**: HTT5 anchors appear on selected studs, mounting sheets created in zones 1-2, blocking inserted between studs

### Advanced Workflow: Dual Anchors with Custom Tooling

1. **Launch script** with silent preset: `HTT?HTT22`
2. **Select post** at corner (larger 6×6 post)
3. **Specify side** "I" (Icon Side)
4. **Adjust properties**:
   - Inter Distance = 150 mm (creates two anchors 150mm apart)
   - Depth = 25 mm (recess anchors 25mm into post)
   - Gap = 3 mm (add 3mm clearance around milling pocket)
   - Tooling Index = "10;12"
   - Tooling Type = "Saw;Milling"
5. **Result**: Two HTT22 anchors side-by-side, milled recess, custom CNC tooling per zone

### Troubleshooting Workflow: Anchor on Wrong Side

1. **Right-click** the anchor instance
2. **Select** "Opposite Side" (or "Left Side", "Right Side" as needed)
3. **Result**: Anchor moves to new face, mounting sheets and blocking re-created automatically

---

## Settings

### XML Configuration File

The script reads its product catalog from an XML file using the standard hsbCAD `<Hsb_Map>` format.

**File name**: `Simpson StrongTie Anchor.xml`

**File locations (searched in order)**:
1. `[hsbCompany]\TSL\Settings\Simpson StrongTie Anchor.xml`
2. `[hsbInstall]\Content\General\TSL\Settings\Simpson StrongTie Anchor.xml`

**Persistence**: Settings are cached in the drawing database as a MapObject under dictionary `"hsbTSL"` with key `"Simpson StrongTie Anchor"`. The script uses `setDependencyOnDictObject()` to automatically recalculate when settings change.

### XML Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Family[]">
    <lst nm="Family">
      <str nm="Name" vl="HTT"/>
      <str nm="URL_E" vl="http://www.strongtie.co.uk/products/detail/hold-down/81"/>
      <str nm="URL_G" vl="http://www.strongtie.de/products/detail/zuganker/81"/>
      <str nm="URL_F" vl="http://www.simpson.fr/products/detail/ancrage-pour-montant-d-039-ossature/81"/>
      <lst nm="Model[]">
        <lst nm="Model">
          <str nm="Name" vl="HTT5"/>
          <dbl nm="A" ut="L" vl="404"/>       <!-- Height (mm) -->
          <dbl nm="B" ut="L" vl="62"/>        <!-- Depth (mm) -->
          <dbl nm="C" ut="L" vl="64"/>        <!-- Width (mm) -->
          <dbl nm="t" ut="L" vl="3"/>         <!-- Thickness leg A (mm) -->
          <dbl nm="tB" ut="L" vl="11.4"/>     <!-- Thickness leg B (mm) -->
          <dbl nm="diamA" ut="L" vl="4.7"/>   <!-- Nail hole diameter (mm) -->
          <int nm="nDiamA" vl="26"/>          <!-- Number of nail holes -->
          <dbl nm="zOffsetBase" ut="L" vl="33"/>   <!-- Base bolt Z offset (mm) -->
          <dbl nm="diamBase" ut="L" vl="17.5"/>    <!-- Base bolt hole in bracket (mm) -->
          <dbl nm="diamPlate" ut="L" vl="20"/>     <!-- Base bolt hole in plate (mm) -->
          <int nm="nDiamB" vl="1"/>                <!-- Number of base bolts -->
          <dbl nm="dATriang" ut="L" vl="165"/>     <!-- Triangle height (mm) - HTT only -->
        </lst>
        <lst nm="Model">
          <str nm="Name" vl="HTT22"/>
          <!-- Additional model parameters -->
        </lst>
      </lst>
    </lst>
    <lst nm="Family">
      <str nm="Name" vl="AH"/>
      <!-- AH family definition -->
    </lst>
    <lst nm="Family">
      <str nm="Name" vl="HD"/>
      <!-- HD family definition -->
    </lst>
  </lst>
  <lst nm="GeneralMapObject">
    <str nm="Identifier" vl="Simpson StrongTie Anchor"/>
    <str nm="CustomFileName" vl="Simpson StrongTie Anchor"/>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Adding New Families or Models

To extend the product catalog:

1. **Open the XML file** in a text editor
2. **Add a new Family block** under `Family[]`:
   ```xml
   <lst nm="Family">
     <str nm="Name" vl="NEW_FAMILY"/>
     <str nm="URL_E" vl="http://..."/>
     <str nm="URL_G" vl="http://..."/>
     <str nm="URL_F" vl="http://..."/>
     <lst nm="Model[]">
       <!-- Add models here -->
     </lst>
   </lst>
   ```
3. **Add Model entries** within `Model[]` with all required parameters (A, B, C, t, tB, diamA, nDiamA, zOffsetBase, diamBase, diamPlate, nDiamB, dATriang)
4. **Save the XML file**
5. **Reload the drawing** or recalculate the TSL instance

**Required Model Parameters**:
- All dimension parameters must include `ut="L"` (length unit)
- All count parameters (nDiamA, nDiamB) are integers without units
- Set `dATriang = 0` for families without triangular gussets (AH, HD)

### OPM Catalog System

The script uses the hsbCAD OPM catalog system to save and recall property presets.

**Catalog Naming Convention**:
- Format: `[ScriptName]-[FamilyName]`
- Example: `Simpson StrongTie Anchor-HTT`

**Catalog Entry Structure**:
- Each catalog entry stores all property values for a specific model configuration
- Entry name = Model name (e.g., "HTT5", "AH9035")

**Auto-Creation**:
- On first insertion for a family, the script automatically creates default catalog entries for all models in that family
- Subsequent insertions can silently apply catalog entries using the token format: `[Family]?[Model]`

**Manual Catalog Management**:
- Save current properties: Right-click anchor → Properties → Catalog → Save As
- Load saved preset: Right-click anchor → Properties → Catalog → [Entry Name]

### Special Project Configurations

The script recognizes special project keywords via `projectSpecial()`:

**BAUFRITZ**:
- Clones HTT family models and adds descriptive suffixes:
  - "HTT5 Holz (Gefach)"
  - "HTT22 Holz (Gefach)"
  - "HTT5 Beton (Gefach)"
  - "HTT22 Beton (Gefach)"
- Sets instance color to 5 (blue) instead of default 253
- Activates additional display layer J5 for anchor visualization
- Enables special text labels on mounting sheets

**Adding New Special Configurations**:
1. Add company name to `sSpecials[]` array in script
2. Find the array index: `nSpecial = sSpecials.find(projectSpecial().makeUpper())`
3. Add conditional logic based on `nSpecial` value

---

## Technical Notes

### Script Type O (Object)

The script is an **O-type TSL**, which means:
- It is NOT permanently attached to a specific beam during insertion
- Instead, it programmatically selects beams and **clones itself** onto each selected beam
- The original insertion instance **erases itself** after distributing clones
- Each clone becomes an independent TslInst with its own properties and references

**Cloning Process**:
1. User selects multiple beams during insertion
2. Script loops through selected beams
3. For each beam, creates a new TslInst via `tslNew.dbCreate()` with:
   - Same script name
   - Same coordinate system (vecX, vecY)
   - Reference to current beam (`gbsTsl[] = {beam}`)
   - Copy of all properties (`nProps[], dProps[], sProps[]`)
4. Original insertion instance calls `eraseInstance()` and returns

### Coordinate System

The anchor uses different coordinate systems depending on element association:

**When Beam Belongs to an Element**:
- **vecX** = Element vecX (width direction)
- **vecY** = Element vecY (length direction, vertical in walls)
- **vecZ** = Element vecZ (thickness direction)
- **ptOrg** = Element origin (typically bottom plate elevation)

**When Beam is Standalone** (not part of an element):
- **vecX** = Beam vecY
- **vecY** = Beam vecX (inverted to ensure upward direction)
- **vecZ** = -Beam vecZ
- **ptOrg** = Beam center - vecY × 0.5 × beam length
- Special correction: If vecY is parallel but opposite to world Z, flip vecX and vecY

**Local Coordinate System for Anchor**:
- **vecXC** = Cross-product direction (width of anchor placement face)
- **vecYC** = vecY (upward direction)
- **vecZC** = vecDir (outward from beam face)

### 3D Solid Construction

The anchor bracket is constructed from multiple Body primitives:

**Main L-Bracket**:
```cpp
Body bd(ptRef, vecXC, vecYC, vecZC, dC, dA, dT, 0, 1, 1);  // Vertical leg
bd.addPart(Body(ptRef, vecXC, vecYC, vecZC, dC, dTB, dB, 0, 1, 1));  // Base plate
```

**Triangular Gussets** (HTT family only):
```cpp
if (nFamily == 0) {
  Point3d ptTriang = ptRef + vecYC × dTB;
  PLine plTriang(ptTriang, ptTriang + vecZC × dB, ptTriang + vecY × dATriang);
  plTriang.close();
  plTriang.transformBy(-vecXC × 0.5 × dC);
  bd.addPart(Body(plTriang, vecXC × dT, 1));  // Left gusset
  plTriang.transformBy(vecXC × dC);
  bd.addPart(Body(plTriang, vecXC × dT, -1));  // Right gusset
}
```

**Dimensions**:
- Vertical leg: C (width) × A (height) × t (thickness)
- Base plate: C (width) × tB (thickness) × B (depth)
- Gussets: Triangular profile with height = dATriang, extruded by t

### Tooling Operations

**BeamCut** (Milling Recess):
```cpp
double dXBc = dXTotal + 2 × dGap;  // Width = anchor footprint + inter distance + gaps
double dYBc = dA + dGap;            // Height = anchor height + gap
double dZBc = dDepth;               // Depth = milling depth
BeamCut bc(ptBc, vecXC, vecYC, vecZC, dXBc, dYBc, 2 × dZBc, 0, dYFlag, 1);
bc.addMeToGenBeams(beams);  // Apply to all beams in element
```

**Drill** (Base Bolt Hole):
```cpp
// Through bottom plate (if in left/right mode)
if (bLeftRight) {
  Drill drill(ptDr, ptDr + vecYC × vecYC.dotProduct(ptOrg - ptDr), dDiamPlate × 0.5);
  drill.addMeToGenBeamsIntersect(bmPlates);
}

// In anchor bracket
bd.addTool(Drill(ptDr, ptDr + vecYC × dTB, dDiamBase × 0.5));
```

### Hardware Component Registration

The anchor is registered as a HardWrComp with:

**Manufacturer**: "Simpson StrongTie"
**Material**: "SS Grade 33" (stainless steel grade 33)
**Category**: "Connector"
**RepType**: `_kRTTsl` (distinguishes script-generated hardware from manual entries)

**Quantity Calculation**:
```cpp
int nHWQty = dInterdistance > 0 ? 2 : 1;  // 1 or 2 anchors
HardWrComp hwc(sModel, nHWQty);
```

**Scale Dimensions** (for BOM visualization):
```cpp
hwc.setDScaleX(dA);  // Height
hwc.setDScaleY(dC);  // Width
hwc.setDScaleZ(dB);  // Depth
```

### Element Group Assignment

**Anchor Instance**:
- Group: Element group (if beam belongs to element)
- Zone: 0 (core framing)
- Layer: 'E' (element entities)
- Command: `assignToElementGroup(el, true, 0, 'E')`

**Mounting Sheets**:
- Group: Element group
- Zone: Corresponding zone number (1-5, positive or negative)
- Layer: 'Z' (zone-specific supplementary)
- Material & Color: Inherited from element zone
- Command: `sheet.assignToElementGroup(el, true, nZone, 'Z')`

**Blocking Members**:
- Group: Element group
- Zone: 0 (core framing)
- Layer: 'Z' (supplementary)
- Type: `_kBlocking`
- Material: Inherited from element zone 0
- Dynamic stretching: `bmNew.stretchDynamicTo(vertical_studs)`

### CNC Child TSL Creation

For each mounting sheet zone, the script creates an hsbCNC instance:

**Storage**: Stored in script's Map with keys:
- "CncMain0" through "CncMain4" (main sheet CNC)
- "Cnc0" through "Cnc4" (zone-specific custom tooling)

**Creation Method A** (No CNC Catalog):
```cpp
TslInst tslCNC;
Map mapTslCNC;
GenBeam gbsCNC[] = {};
Entity entsCNC[] = {el, sheet};
Point3d ptsCNC[] = {sheet.ptCenSolid()};
int nPropsCNC[] = {nZone, 1};  // zone, tool index
double dPropsCNC[] = {0, 0, U(75)};  // depth, angle, text height
String sPropsCNC[] = {
  (nSide == -1 ? "Right" : "Automatic"),  // tool side
  "Against course",  // turning direction
  "No",              // overshoot
  "Saw",             // tool type
  "Standard",        // tool relation
  "Solid Operation with Nonail area",  // operation
  ""                 // text
};
tslCNC.dbCreate("hsbCNC", vecX, vecY, gbsCNC, entsCNC, ptsCNC,
                nPropsCNC, dPropsCNC, sPropsCNC, _kModelSpace, mapTslCNC);
_Map.setEntity("CncMain" + z, tslCNC);
```

**Creation Method B** (With CNC Catalog, v2.13+):
```cpp
tslCNC.dbCreate("hsbCNC", _XW, _YW, gbsCNC, entsCNC, ptsCNC,
                sCatalogName, bForceModelSpace, mapTslCNC, sExecuteKey, "OnDbCreated");
```

**Custom Tooling per Zone** (Tooling Index/Type/Width/Height specified):
```cpp
// Create polyline for CNC cut area
PLine plTool;
plTool.createRectangle(
  LineSeg(_Pt0 - (0.5 × dC + dWidthI) × vecXC,
          _Pt0 + (0.5 × dC + dWidthI) × vecXC + (dA + dHeightI) × vecYC),
  vecXC, vecYC);
mapTslCNC.setPLine("plCNC", plTool);

// Set properties based on Tooling Type
// Update or create hsbCNC instance
_Map.setEntity("Cnc" + z, tslCNC);
```

### On-Erase Cleanup (v2.13+)

When the anchor instance is deleted, it automatically erases associated entities:

**Trigger**:
```cpp
addRecalcTrigger(_kErase, TRUE);
if (_bOnDbErase) { ... }
```

**Cleanup Operations**:
1. **CNC Instances** (zones 0-4):
   - "Cnc0" through "Cnc4" (custom tooling)
   - "CncMain0" through "CncMain4" (main sheet tooling)
2. **Blocking Member**:
   - "Blocking" stored in Map
3. **Method**:
   ```cpp
   for (int z = 0; z < 5; z++) {
     if (_Map.hasEntity("Cnc" + z)) {
       Entity EntI = _Map.getEntity("Cnc" + z);
       EntI.dbErase();
     }
     if (_Map.hasEntity("CncMain" + z)) {
       Entity EntI = _Map.getEntity("CncMain" + z);
       EntI.dbErase();
     }
   }
   if (_Map.hasEntity("Blocking")) {
     Entity Ent = _Map.getEntity("Blocking");
     Ent.dbErase();
   }
   ```

**Purpose**: Prevents orphaned entities in the drawing when anchors are deleted

### Interdistance Validation

The script enforces strict validation rules for dual anchor placement:

**Validation 1: Interdistance must exceed anchor depth**:
```cpp
if (dInterdistance > 0 && dInterdistance < dB) {
  reportMessage("the interdistance must be greater than the anchor width.");
  dInterdistance.set(0);
  setExecutionLoops(2);
  return;
}
```

**Validation 2: Beam face must accommodate both anchors**:
```cpp
double dXCBm = bdEnv.lengthInDirection(vecXC);  // Beam face width
if (dInterdistance > 0 && dXCBm < dInterdistance + 2 × dB) {
  reportMessage("cannot place 2 anchors on this face");
  dInterdistance.set(0);
  setExecutionLoops(2);
}
```

**Anchor Distribution**:
```cpp
int nHWQty = dInterdistance > 0 ? 2 : 1;
Vector3d vecLoc = -vecXC × (nHWQty - 1) × 0.5 × dInterdistance;
bd.transformBy(vecLoc);
drill.transformBy(vecLoc);
for (int i = 0; i < nHWQty; i++) {
  dpModel.draw(bd);
  if (bmPlates.length() > 0) drill.addMeToGenBeamsIntersect(bmPlates);
  vecLoc = vecXC × dInterdistance;
  bd.transformBy(vecLoc);
  drill.transformBy(vecLoc);
}
```

### Block Display

The script searches for AutoCAD block files for enhanced 2D representation:

**Search Order**:
1. **Drawing block table**: `_BlockNames.find(sBlockName)`
2. **Company Block folder**: `[hsbCompany]\Block\[sBlockName].dwg`

**Block Naming**:
- **Model-specific**: Model name (e.g., "HTT5.dwg", "AH9035.dwg")
  - For models with "/" (e.g., "AH19050/2"), convert to "AH19050-2.dwg"
- **Family fallback**: Family name (e.g., "HTT.dwg")

**Display**:
```cpp
if (iIndexBlock > -1) {
  Block block(_BlockNames[iIndexBlock]);
  dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
} else {
  String sFile = findFile(sFullPath);
  if (sFile.length() > 0) {
    Block block(sFile);
    dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
  }
}
```

### Localization

All user-facing strings use the `T("|...|")` translation mechanism:

**Language Detection**:
```cpp
String sIsoCode = T("|IsoCode|");  // BG, HR, EN, DE, FR, etc.
String sIsoCodes[] = {"BG", "HR", "CS", "DA", "NL", "EN", "ET", "FI", "FR", "DE", ...};
int nIsoCode = sIsoCodes.find(sIsoCode);
```

**URL Localization**:
```cpp
if (nIsoCode == 8)       // French
  sURLs.append(sURLF);
else if (nIsoCode == 9)  // German
  sURLs.append(sURLG);
else                     // English (default)
  sURLs.append(sURLE);
```

**Hyperlink Assignment**:
```cpp
if (sURL.find(".", 0) > 0) _ThisInst.setHyperlink(sURL);
```

### MapObject Persistence

Settings are cached in the drawing database for performance:

**Dictionary**: `"hsbTSL"`
**Key**: `"Simpson StrongTie Anchor"` (same as script name)

**Read/Create Flow**:
```cpp
MapObject mo(sDictionary, sFileName);
if (mo.bIsValid()) {
  // Settings already in database
  mapSetting = mo.map();
  setDependencyOnDictObject(mo);  // Auto-recalc when settings change
} else if (sFile.length() > 0) {
  // Read from XML, write to database
  mapSetting.readFromXmlFile(sFile);
  mo.dbCreate(mapSetting);
} else {
  // No XML, no database -> create defaults
  [create default HTT family]
  mo.dbCreate(mapSetting);
}
```

**Export XML**:
```cpp
String sTriggerExportXml = T("|Export Xml|");
addRecalcTrigger(_kContext, sTriggerExportXml);
if (_bOnRecalc && (_kExecuteKey == sTriggerExportXml)) {
  mapSetting.writeToXmlFile(sFullPath);
  setExecutionLoops(2);
  return;
}
```

### Unit System

All dimensions use millimeters with `U()` conversion:

**Default Unit Declaration**:
```cpp
U(1, "mm");
```

**Dimension Examples**:
```cpp
PropDouble dZOffset(nDoubleIndex++, U(0), "Axis Offset");
PropDouble dHeightSheet(nDoubleIndex++, U(625), "Height");
double dEps = U(.1);  // Epsilon for floating-point comparisons
```

**XML Storage**:
```xml
<dbl nm="A" ut="L" vl="404"/>  <!-- Stored as 404mm -->
<unit ut="L" uv="millimeter"/>
```

**Cross-Template Compatibility**: The `U()` function ensures dimensions work correctly in both metric (mm) and imperial (inch) drawing templates.

---

## Tips and Best Practices

### Preferred Insertion Method
- **Launch from ribbon/palette** with a family token (e.g., `HTT?HTT5`) for the fastest workflow
- Avoid launching from command line without presets unless you need to change families frequently
- Set up catalog entries for commonly used models to enable silent insertion

### Dual Anchor Placement
- Use **Inter Distance** for dual hold-downs on wide posts or doubled studs
- Ensure beam face width ≥ `2 × B + Inter Distance` before setting dual anchors
- Typical inter-distance values: 100-200mm for standard applications

### Mounting Sheets
- The mounting sheet is created **within the bay between adjacent studs**
- Sheet height and coverage can be fine-tuned per zone using semicolon-separated values
- Example: `Coverage = "12;12;0;0;0"` creates sheets only in zones 1 and 2 with 12mm overlap
- Mounting sheets inherit material and color from the corresponding element zone
- Set `Height = 0` to completely disable mounting sheet and blocking creation

### CNC Integration
- When a mounting sheet is created, the script **automatically spawns an hsbCNC instance**
- Control global CNC behavior using the **CNC Catalog** property
- Control per-zone CNC behavior using **Tooling Index**, **Tooling Type**, **Tooling Width**, **Tooling Height**
- Empty tooling parameters = no custom CNC tooling for that zone (uses main CNC instance only)
- CNC instances are automatically cleaned up when the anchor is deleted (v2.13+)

### Blocking Members
- Blocking is created **automatically when the anchor is on a left or right face** within an element
- Blocking is inserted at the top of the mounting sheet between studs
- Blocking inherits material from element zone 0 and is dynamically stretched to adjacent studs
- Blocking is assigned to zone 0 with layer code 'Z'

### Hyperlinks
- The script automatically sets a **hyperlink on the anchor instance** pointing to the Simpson Strong-Tie product page
- URL language (English, German, French) is selected automatically based on system ISO code
- Access hyperlink: Right-click anchor → Hyperlink → Follow

### Axis Offset
- Use **Axis Offset** to shift the anchor along the element thickness direction
- Useful when beam is wider than typical stud width or when anchor needs to align with specific sheathing zones
- The script automatically clamps the value to prevent the anchor from extending beyond beam boundaries
- Calculation: `dMaxZOffset = 0.5 × (element beam width - C) - (0.5 × Inter Distance if > 0)`

### Relocating After Placement
- Instead of re-inserting, use the **right-click context menu** to move the anchor:
  - Icon Side, Opposite Side, Left Side, Right Side
  - Flip Mounting Side (for left/right placement)
- **Double-click** the anchor to toggle to the opposite side
- **Drag the grip point** (`_Pt0`) to a new location — the script automatically snaps to the nearest face and recalculates

### Exporting Settings
- If you have customized anchor settings in the drawing database and want to save them as an XML file:
  1. Right-click anchor → **Export Xml**
  2. The XML file is written to `[hsbCompany]\TSL\Settings\Simpson StrongTie Anchor.xml`
  3. Copy this file to other projects to share the custom catalog

### Debugging
- Set `projectSpecial()` to include `"DEBUGTSL"` or `"Simpson StrongTie Anchor"` to enable debug mode
- Debug mode shows visual debugging aids (blocking preview, coordinate axes, reference points)
- Debug mode disables certain automatic operations (sheet creation, blocking insertion) for inspection

### Performance
- Use `envelopeBody()` instead of `realBody()` for performance in complex scripts
- The script uses MapObject caching to avoid re-reading the XML file on every recalculation
- Dependency tracking via `setDependencyOnDictObject()` ensures automatic recalculation only when settings change

---

## Common Issues and Solutions

### Issue: "The interdistance must be greater than the anchor width"

**Cause**: You set Inter Distance to a value less than the anchor depth (B dimension).

**Solution**:
- Set Inter Distance = 0 for a single anchor, OR
- Set Inter Distance > B (e.g., for HTT5 with B=62mm, use ≥ 65mm)

### Issue: "Cannot place 2 anchors on this face"

**Cause**: The beam face width is not sufficient to accommodate two anchors with the specified inter-distance.

**Solution**:
- Reduce Inter Distance, OR
- Place anchor on a wider beam/post, OR
- Set Inter Distance = 0 for a single anchor

### Issue: Mounting sheets not created

**Possible Causes**:
1. Height parameter set to 0
2. Beam not associated with an element
3. Coverage parameter skips all zones (e.g., "0;0;0;0;0")

**Solution**:
- Ensure Height > 0 (default 625mm)
- Ensure beam belongs to an element (wall/floor/roof)
- Set Coverage to non-zero values for desired zones (e.g., "12;12")

### Issue: CNC tooling not appearing on mounting sheets

**Possible Causes**:
1. Tooling Index, Type, Width, or Height parameters empty or incomplete
2. Zone specified in parameters does not exist or has no mounting sheet

**Solution**:
- Verify all four tooling parameters have values for the desired zone
- Format: semicolon-separated, one entry per zone
- Example: `Tooling Index = "10;12"`, `Tooling Type = "Saw;Milling"`, `Tooling Width = "5;5"`, `Tooling Height = "10;10"`
- Alternatively, use CNC Catalog parameter for global CNC behavior

### Issue: Anchor on wrong side after insertion

**Cause**: Side selection during insertion was incorrect.

**Solution**:
- Right-click anchor → Select correct side (Icon Side, Opposite Side, Left Side, Right Side)
- OR double-click anchor to toggle to opposite side
- OR drag anchor grip point to new location

### Issue: Blocking not created

**Possible Causes**:
1. Anchor not on left or right face (blocking only created for left/right placement)
2. Height parameter set to 0
3. Beam not associated with an element
4. Only one vertical stud in element (blocking requires at least 2 studs to span between)

**Solution**:
- Ensure anchor is on left or right face (not icon/opposite)
- Ensure Height > 0
- Ensure beam belongs to an element with multiple vertical studs

### Issue: "No model definition for this family"

**Cause**: XML file family definition is missing the `Model[]` section.

**Solution**:
1. Open XML file in text editor
2. Add `<lst nm="Model[]">` section under the family
3. Add at least one `<lst nm="Model">` entry with all required parameters

### Issue: Custom family not appearing in dropdown

**Cause**: Family not defined in XML file or MapObject not refreshed.

**Solution**:
1. Verify family exists in XML file under `Family[]`
2. Delete the MapObject from drawing database (use `MAPOBJECT` command → hsbTSL → Simpson StrongTie Anchor → Delete)
3. Reload the drawing or recalculate the anchor instance

---

## Keyboard Shortcuts and Command Examples

### Custom Commands (Place in CUI/Ribbon)

**Insert HTT Family**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie Anchor" "HTT")) TSLCONTENT
```

**Insert AH Family**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie Anchor" "AH")) TSLCONTENT
```

**Reposition: Icon Side**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Icon Side|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Reposition: Opposite Side**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Opposite Side|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Reposition: Left Side**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Left Side|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Reposition: Right Side**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Right Side|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Flip Mounting Side**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Mounting Side|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Reset and Erase**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset + Erase|") (_TM "|Select Anchor|"))) TSLCONTENT
```

**Switch to HTT Family**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey "-> HTT" (_TM "|Select Anchor|"))) TSLCONTENT
```

**Switch to AH Family**:
```lisp
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey "-> AH" (_TM "|Select Anchor|"))) TSLCONTENT
```

---

## Related Scripts and Workflow Integration

### Related Simpson StrongTie Scripts
- **Simpson StrongTie BT**: Beam-to-beam tension connectors
- **Simpson StrongTie EL**: Embedded L-brackets
- Other Simpson hardware scripts in the TSL library

### Integration with hsbCAD Workflow

**Upstream Dependencies** (what should be done before using this script):
1. **Create Element**: Wall/floor/roof element with studs and zones
2. **Define Zones**: Configure zone materials and thicknesses
3. **Position Beams**: Place studs at correct locations (corners, wall ends, openings)

**Downstream Operations** (what can be done after using this script):
1. **Sheet Distribution**: Add remaining sheathing to wall zones (script already creates mounting sheets)
2. **CNC Processing**: Export CNC data for fabrication (hsbCNC instances already attached)
3. **Bill of Materials**: Generate hardware BOM (anchors already registered as HardWrComp)
4. **Shop Drawings**: Create fabrication drawings showing anchor locations and drilling

### Child TSL Scripts Created

This script creates the following child TSL instances:

| Script Name | Quantity | Storage Key | Purpose | Cleanup |
|-------------|----------|-------------|---------|---------|
| **hsbCNC** | 1 per zone (up to 5) | CncMain0-CncMain4 | Main CNC tooling for mounting sheets | Auto-erased on anchor deletion (v2.13+) |
| **hsbCNC** | 1 per zone (up to 5) | Cnc0-Cnc4 | Custom zone-specific CNC tooling | Auto-erased on anchor deletion (v2.13+) |
| **BF-ZoneText** | 1 per zone (BAUFRITZ special only) | Not stored | Text label "Platte schrauben" on mounting sheet | No auto-cleanup |

**Note**: In version 2.13+, all CNC child instances are automatically deleted when the anchor is erased via the `_bOnDbErase` event handler.

---

## Glossary

| Term | Definition |
|------|------------|
| **Hold-Down Anchor** | Metal bracket hardware that resists uplift forces on timber walls |
| **HTT** | Hold-Down Tension Tie (Simpson product family) |
| **AH** | Angle Hold-Down (Simpson product family) |
| **HD** | Heavy-Duty Hold-Down (Simpson product family) |
| **Inter Distance** | Spacing between two anchors when placed side-by-side on a single beam |
| **Mounting Sheet** | Sheathing panel (OSB/plywood) created behind the anchor as a nailing surface |
| **Blocking** | Horizontal timber member inserted between studs at anchor location |
| **Axis Offset** | Distance to shift the anchor along the element thickness direction |
| **Icon Side** | Positive Z direction of element coordinate system |
| **Opposite Side** | Negative Z direction of element coordinate system |
| **Left Side** | Negative X direction of element coordinate system |
| **Right Side** | Positive X direction of element coordinate system |
| **BeamCut** | Milling recess in a timber member |
| **Drill** | Circular hole machining operation |
| **CNC Catalog** | Pre-saved set of hsbCNC parameters for consistent tooling |
| **MapObject** | hsbCAD database object for persistent settings storage |
| **OPM** | Object Property Manager (AutoCAD Properties Palette) |
| **TslInst** | TSL script instance (intelligent parametric entity) |
| **GenBeam** | Generic timber beam/member entity |
| **Element** | Complete assembly (wall/floor/roof) containing beams and sheets |
| **Zone** | Layer within an element (e.g., interior sheathing, exterior sheathing) |
| **HardWrComp** | Hardware Component (BOM entry for connectors, fasteners, etc.) |

---

## Contact and Support

For questions about this script or to request additional Simpson Strong-Tie product families:

- **Script Author**: Marsel Nakuci (marsel.nakuci@hsbcad.com)
- **Original Author**: Thorsten Huck (thorsten.huck@hsbcad.com)
- **Product Manufacturer**: Simpson Strong-Tie
  - UK: www.strongtie.co.uk
  - Germany: www.strongtie.de
  - France: www.simpson.fr

For hsbCAD software support and documentation:
- Visit the hsbCAD support portal
- Contact your local hsbCAD representative

---

**Document Version**: 2.0
**Last Updated**: 2026-02-21
**Script Version**: 2.13 (11.11.2025)
