# FLR_SimpsonHanger - Simpson Strong-Tie® Joist Hanger Installation Tool

**Version:** 5.26 (May 21, 2020)
**Script Type:** O-Type (Object Script)
**Application:** Floor, Roof, and Wall Framing Systems
**Vendor:** Simpson Strong-Tie®

---

## Overview

The **FLR_SimpsonHanger** script automatically installs Simpson Strong-Tie® joist hangers at beam-to-beam connections in timber frame structures. This tool intelligently selects appropriate hanger models from a built-in database based on joist and header dimensions, supporting single, double, triple, and quad joist configurations, including angled connections.

The script creates a parametric 3D hanger model that automatically updates when linked beams are modified, and outputs detailed hardware schedules including nailing specifications for fabrication and installation.

### Key Features

- **Automatic Hanger Selection:** Matches joist profiles (dimensional lumber, engineered I-joists) to compatible Simpson hanger models
- **Multi-Joist Support:** Handles single, double, triple, and quad joist configurations
- **Angled Connections:** Supports skewed joists with special S-type hangers
- **Wall Applications:** Works with floor joists connecting to walls
- **Smart Accessories:** Auto-generates web stiffeners for I-joists and backer blocks for headers
- **Comprehensive Nailing Data:** Tracks face nails, top nails, and joist nails with quantities
- **Hardware Export:** Outputs to BOM, schedules, and fabrication systems

---

## When to Use This Tool

### Typical Applications

1. **Floor Framing:**
   - Joists connecting to girder beams
   - Rim joist to floor joist connections
   - Multi-ply joist hangers

2. **Roof Framing:**
   - Rafter to ridge beam connections
   - Hip/valley rafter hangers
   - Truss to carrying beam connections

3. **Wall Framing:**
   - Floor joist to wall plate connections
   - Wall-to-wall joist support

### Prerequisites

Before using this tool, ensure:
- Joists and carrying beams/headers are already modeled
- Beams are assigned to proper Element groups (floor, wall, or roof)
- Joists have correct **Extrusion Profiles** set (e.g., "TJI 110 11.875", "2x10", etc.)

---

## Step-by-Step Usage Guide

### 1. Launch the Script

**Command:** Insert `FLR_SimpsonHanger` from the TSL library or command line.

### 2. Select Joists

**Prompt:** *"Select Joists, all must be parallel"*

- Select one or more joists that are parallel to each other
- The tool accepts both standard beams and trusses
- For multiple joists, the script will detect doubles, triples, or quads automatically

**Important:** All selected joists must run in the same direction.

### 3. Select Carrying Beams/Headers

**Prompt:** *"Select Carrying Beams"*

- Select the beam(s) that the joists are connecting to
- Can be girders, headers, or wall plates
- Multiple headers can be selected to place hangers on both sides

### 4. Automatic Hanger Placement

The script will:
- Calculate joist-to-header intersection points
- Determine connection geometry (square or angled)
- Detect ganged joists (doubles, triples, quads)
- Select appropriate hanger models from the library
- Create parametric hanger instances at each connection

### 5. Continuous Insertion Mode

After initial placement, the script re-prompts for additional joist selections, allowing you to:
- Continue placing hangers without re-launching the script
- Press **ESC** or **Enter** with no selection to exit

---

## Properties Panel (OPM)

Once placed, hangers can be customized through the AutoCAD Properties Palette:

### Core Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| **Execution Mode** | String | `Standard` = Auto-select hanger by joist profile<br>`Manual` = Geometry-based selection | Standard |
| **My Hanger Model** | String | Simpson model number (e.g., "HUC410-2", "IUS2.37/11.88") | Auto-selected |
| **My Custom Hanger Model** | String | Custom description when using **CUSTOM** option | "Hanger for [size]" |
| **Joist End Gap** | Double | Gap between joist end and header face | 0" (varies by model) |
| **Ship Loose** | Yes/No | Mark hanger for loose shipment (not pre-installed) | No |
| **Add Hanger On Top** | Yes/No | Create mirrored hanger on top face (floors only) | No |

### Nailing Specifications

| Property | Description | Example Values |
|----------|-------------|----------------|
| **Face Nails** | Nail type for face flanges | "0.148 x 3"", "0.162 x 3 1/2"" |
| **Face Nails Qty** | Quantity per face flange | 4, 6, 8 |
| **Top Nails** | Nail type for top flanges | "0.148 x 1 1/2"" |
| **Top Nails Qty** | Quantity per top flange | 2, 4 |
| **Joist Nails** | Nail type for joist attachment | "0.148 x 2 1/2"" |
| **Joist Nails Qty** | Quantity into joist | 6, 8, 10 |

**Note:** In Standard mode, nailing specifications are automatically populated from the hanger database. In Manual mode, you must specify nailing manually.

### Accessory Options

| Property | Options | Description |
|----------|---------|-------------|
| **Web Stiffener** | Yes/No | Creates web stiffener beams for I-joists (TJI, LPI, BCI) |
| **Backer Block** | None / Single / Double | Adds solid wood blocking behind hanger on header |

### Display Properties

| Property | Description |
|----------|-------------|
| **Hanger Color** | Color index for installed hangers (default: 6 - Magenta) |
| **Loose Hanger Color** | Color index for loose hangers (default: 2 - Yellow) |

---

## Execution Modes Explained

### Standard Mode (Recommended)

**How it works:**
1. Script reads joist's **Extrusion Profile** (e.g., "TJI 110 9.5 joist")
2. Queries hanger library for compatible models for that profile
3. Filters by connection type (single/double/triple/quad, square/angled)
4. Auto-populates hanger model and nailing specs

**When to use:**
- Joists have standard profiles (dimensional lumber, TJI, LPI, BCI, NI)
- You want automatic compliance with Simpson specifications
- You need nailing data from manufacturer

### Manual Mode

**How it works:**
1. Script measures joist width and height from geometry
2. Lists all hangers with dimensions matching joist ± tolerance
3. You select appropriate model from dropdown
4. You must manually enter nailing specifications

**When to use:**
- Custom joist profiles not in database
- Rectangular joists without specific extrusion profile
- You want to override auto-selected hanger
- Multiple joist sizes are selected (script auto-switches to Manual)

---

## Context Menu Commands

Right-click on a placed hanger to access:

| Command | Function |
|---------|----------|
| **Update Hanger List** | Re-imports hanger database from Excel file<br>Path: `<Company>\Excel\HangerList.xls` |

---

## Supported Hanger Types

The script recognizes and models the following Simpson hanger families:

### Face-Mount Hangers (F-Type)

Standard joist hangers with vertical face flanges and bottom seat.

**Examples:** HUC, LUC, U-Series

**Geometry:**
- Bottom seat: 1.5" × joist width
- Side plates: 75% of joist height
- Face flanges: 1" × variable height

### Top-Flange Hangers (TF-Type)

Hangers with top horizontal flanges for concealed installation.

**Examples:** IT-Series

### Concealed Flanges (CF-Type)

Hidden fastening systems for exposed beam applications.

### Skewed Hangers (S-Type)

Special geometry for angled joist-to-header connections (auto-detected when angle ≠ 90°).

**Examples:** SUR, SU-Series

**Geometry:**
- Adjustable face tabs that follow header angle
- Bottom tabs perpendicular to joist
- Top tabs parallel to joist

### Top-Tab Hangers (TT-Type)

Hangers with tabs extending above joist top.

**Examples:** IUS-Series

---

## Supported Joist Profiles

The script has built-in support for the following engineered joist profiles:

### TJI® Joists (Weyerhaeuser)

- TJI 110 9.5" joist
- TJI 110 11.875" joist
- TJI 230 9.5" joist
- TJI 230 11.875" joist
- TJI 360 9.5" joist
- TJI 360 11.875" joist
- TJI 560 11.875" joist

### LPI® Joists (Louisiana-Pacific)

- LPI 20 Plus 9.5" joist
- LPI 32 Plus 9.5" joist
- LPI 20 Plus 11.875" joist

### BCI® Joists (Boise Cascade)

- NI-20 9.5" joist
- NI-40x 9.5" joist
- NI-20 11.875" joist
- NI-40x 11.875" joist
- NI-80 11.875" joist

### Dimensional Lumber

Any rectangular profile (2x6, 2x8, 2x10, 2x12, etc.) based on actual dimensions.

---

## Web Stiffeners (I-Joists Only)

When **Web Stiffener = Yes** and the joist is an I-joist (TJI/LPI/BCI), the script automatically creates **two vertical wood stiffener beams** positioned against the I-joist web.

### Web Stiffener Specifications

| Joist Type | Stiffener Size | Stiffener Length |
|------------|----------------|------------------|
| TJI 110 9.5" | 5/8" × 4" | 6.625" |
| TJI 110 11.875" | 5/8" × 4" | 9" |
| TJI 230 9.5" | 7/8" × 4" | 6.625" |
| TJI 230 11.875" | 7/8" × 4" | 9" |
| TJI 360 9.5" | 7/8" × 4" | 6.625" |
| TJI 360 11.875" | 7/8" × 4" | 9" |
| TJI 560 11.875" | 1.5" × 4" | 9" |
| LPI 20/32 Plus 9.5" | 1" × 4" | 6.375" |
| LPI 20 Plus 11.875" | 1" × 4" | 8.75" |
| NI-Series 9.5" | 1" × 4" | 6.375" |
| NI-Series 11.875" | 1" × 4" | 8.75" |
| NI-80 11.875" | 1.5" × 4" | 8.75" |

### Positioning

- Located 1.5" below joist top edge
- Centered on joist web thickness
- Auto-positioned even if joist is moved
- Cut flush to joist top and bottom faces
- Assigned to same Element group as hanger

**Note:** Web stiffeners are only created for recognized I-joist profiles. Dimensional lumber joists ignore this setting.

---

## Backer Blocks

When **Backer Block ≠ None** and the header is an I-joist, the script creates solid wood blocking behind the hanger to provide bearing support.

### Backer Block Specifications

| Header Type | Backer Size | Thickness |
|-------------|-------------|-----------|
| TJI 110 9.5" | 5/8" × 6.625" | 5/8" |
| TJI 110 11.875" | 5/8" × 9" | 5/8" |
| TJI 230 9.5" | 5/8" × 6.625" | 5/8" |
| TJI 230 11.875" | 5/8" × 9" | 5/8" |
| TJI 360 9.5" | 1" × 6.625" | 1" |
| TJI 360 11.875" | 1" × 9" | 1" |
| TJI 560 11.875" | 2x6 (1.5" × 5.5") | 1.5" |
| LPI 20/32 Plus 9.5" | 1" × 6.375" | 1" |
| LPI 20 Plus 11.875" | 1" × 8.75" | 1" |
| NI-Series 9.5" | 1" × 6.375" | 1" |
| NI-Series 11.875" | 1" × 8.75" | 1" |
| NI-80 11.875" | 1.5" × 8.75" | 1.5" |

### Options

- **None:** No backer blocks created
- **Single:** One backer block on joist side of header
- **Double:** Two backer blocks (both sides of header web)

### Positioning

- Positioned 1.375" below header centerline
- Length: 12" (spans beyond hanger flanges)
- Auto-positioned centered on hanger location
- Assigned to same Element group as hanger

---

## Multi-Joist Configurations

The script automatically detects ganged joists (sistered beams) and selects appropriate multi-ply hangers.

### Detection Logic

When multiple joists are selected:
1. Script sorts joists perpendicular to header direction
2. Measures center-to-center spacing
3. Groups joists within 0.25" of touching (accounting for joist width)
4. Classifies as Single/Double/Triple/Quad

### Width Calculation

For doubled joists:
- **Total width** = Distance between outer joist centers + (Width₁ + Width₂) / 2

For tripled/quadded joists:
- Calculates total span perpendicular to joist direction
- Adds half-widths of first and last joist

### Tolerance Enforcement

Maximum allowed width = (Number of joists × Joist width) + (0.015625" × Number of gaps)

If tolerance is exceeded, the hanger **self-destructs** with error message:
```
Width tolerance exceeded for Simpson Hanger, width = [calculated]
Simpson Hanger self-destructing
```

**Solution:** Verify joist spacing and profile consistency.

---

## Angled Connections

When joist direction is **not perpendicular** to header (angle ≠ 90° ± 5°), the script automatically:

1. Switches to **Skewed Hanger Mode**
2. Changes hanger type to **S-Type**
3. Filters hanger library to only S-type models
4. Adjusts geometry to follow angled intersection

### Geometry Behavior

- **Bottom seat:** Perpendicular to joist
- **Face flanges:** Follow header angle
- **End cut:** Angled to match header face
- **Plan view symbol:** Shows both long and short sides of angled connection

### Supported Configurations

- Single angled joist: Uses `stAngleJoist` hanger list
- Double angled joist: Uses `stDoubleAngleJoist` hanger list
- Triple/quad angled: Not supported (script switches to Manual mode)

---

## Wall Applications

When joists connect to **ElementWall** objects (wall studs/plates), special behavior applies:

### Automatic Adjustments

1. **Joist geometry merged:** All parallel joists are treated as a single combined profile
2. **Add Hanger On Top:** Forced to **Yes** and locked (read-only)
   - Creates hanger on both top and bottom wall plates
3. **Joist cutting disabled:** Joists are not cut at connection (wall plates control geometry)
4. **Web stiffeners disabled:** Not created in wall applications

### Usage Pattern

1. Model wall with top and bottom plates
2. Model floor joists spanning between walls
3. Select joists, then select wall element
4. Hangers appear on both plates automatically

---

## Custom Hangers

When the database does not contain a suitable hanger, or you need a non-standard configuration:

### Option 1: **CUSTOM**

Select `****CUSTOM****` from the **My Hanger Model** dropdown.

**Behavior:**
- Creates a generic F-type (face-mount) hanger
- Uses joist dimensions to build hanger geometry
- **You must manually specify:**
  - Face Nails type and quantity
  - Top Nails type and quantity
  - Joist Nails type and quantity
- **My Custom Hanger Model** field auto-fills with description (e.g., "Hanger for 2-2x10")

**Hanger Geometry:**
- Bottom seat: 1.5" × joist width
- Side plates: 0.75" projection
- Face flanges: 1" × 75% joist height
- Material thickness: 0.08" (14-gauge steel)

### Option 2: **CUSTOM CONCEALED**

Select `****CUSTOM CONCEALED****` from the dropdown.

**Behavior:**
- Creates a CF-type (concealed flange) hanger
- No visible face flanges (all fastening from inside)
- Same manual nailing specification requirements

---

## Plan View Display

Hangers display in plan view (top view) with a distinctive symbol:

### Standard (Square) Connections

```
        |
    ┌───┘
    │
    │   [Joist]
    │
    └───┐
        |
```

- Two L-shaped lines representing face flanges
- Offset 1" from joist edges
- Leg length: 3"

### Angled Connections

```
      /
    ─┘
   /   [Joist]
  /
 ┴
```

- One line parallel to header (long side)
- One line perpendicular to joist (short side)

### Layout Display

The same symbols appear in the **LayoutDisplay** representation for shop drawings and assembly plans.

---

## 3D Model Display

In model space, hangers display as simplified 3D solids:

### Components Modeled

1. **Bottom Seat:** Horizontal plate supporting joist bottom
2. **Side Plates:** Vertical plates running up joist sides (75-80% of joist height)
3. **Face Flanges:** Vertical tabs extending from sides for header attachment
4. **Top Tabs:** (TT-type only) Horizontal tabs extending above joist top

### Color Coding

- **Installed hangers:** Magenta (color 6) or user-specified color
- **Ship Loose hangers:** Yellow (color 2) or user-specified loose color
- **Manual mode hangers:** Cyan (color 12) - warning color

### View Directions

- **Hidden from top view:** Hanger 3D solid hidden when viewing from Z axis
- **Visible in elevations:** Shows in front/side views
- **Plan symbol separate:** Plan view uses simplified 2D symbol (not 3D projection)

---

## Beam Cutting

The script automatically cuts joists at the hanger connection:

### Cut Behavior

- **Cut plane:** Perpendicular to header, offset by **Joist End Gap**
- **Default gap:** Varies by hanger model (0", 0.1875", etc.)
- **Additional clearance:** 0.08" for hanger material thickness

### Cut Application

- **Floor/Roof joists:** Always cut
- **Wall joists:** Not cut (wall element controls joist ends)
- **Flush cuts:** When End Gap = 0", cut is at header face

### Manual Cuts

If you manually add cuts to the joist before placing the hanger, the script preserves them and adds its cut without removing yours.

---

## Hardware Output and Scheduling

The script exports comprehensive hardware data for multiple downstream systems:

### Output Formats

1. **DXA Output (hsbCAD Export System)**
   - Name: Hanger model number
   - Width, Length, Height: Dimensional data
   - Group: Element group name or "Loose"
   - Label: Face nail specification
   - Sublabel: Joist nail specification
   - Info: Top nail specification
   - Loose: Yes/No flag

2. **Pipeline Export (Custom Fabrication System)**
   - ItemType: "Hanger"
   - ItemDescription: Model number
   - Quantity: 1 (or 2 if Add Hanger On Top)
   - QuantityType: "Each"
   - Dependency: Handle of connected joist beam
   - Notes: "Dependency is the handle of the male beam it is attached to"

3. **Hardware Component System**
   - Main component: Hanger with model number
   - Sub-components: Individual nail types with quantities
   - Description: "Hanger"
   - Originator: "RC Hardware"

4. **Map Object Registry**
   - Dictionary: "moHangers"
   - Key: "moHangers"
   - Contains: List of all placed hanger instances
   - Used by: Schedule TSLs (e.g., hanger list generators)

### Schedule Data Structure

Each hanger writes to `_Map` (internal data storage):

```
stModel          → "HUC410-2"
ptCenter         → 3D insertion point
stNotes          → General notes
stJoistNails     → "0.148 x 2 1/2""
stFaceNails      → "0.148 x 3""
stTopNails       → "0.148 x 1 1/2""
iJoistNailsQty   → 8
iFaceNailsQty    → 4
iTopNailsMin     → 2
stWeb            → "Yes" / "No"
HANGER_SCHEDULE  → 1 (flag for schedule scripts)
HANGER_QTY       → 1 or 2
HANGER_LOOSE     → 0 or 1
HANGER_MODEL     → Model string
HANGER_POINTS    → Array of insertion points
HANGER_VECTOR    → Direction vector
```

### Nailing Bill of Materials

Each hanger instance exports up to **3 separate nail line items**:

1. **Top Nails:** (Quantity × Hanger Count) of specified top nail type
2. **Face Nails:** (Quantity × Hanger Count) of specified face nail type
3. **Joist Nails:** (Quantity × Hanger Count) of specified joist nail type

**Example output:**
```
1 × HUC410-2, Nails: (2) 0.148 x 1 1/2"-top, (4) 0.148 x 3"-face, (8) 0.148 x 2 1/2"-joist
```

---

## Library Management

### Hanger Database Location

The script reads hanger specifications from an Excel file:

**File:** `<hsb Company>\Excel\HangerList.xls`

**Alternate script:** `FLR_HangerList.mcr` (loads Excel data into MapObject)

### Database Structure

The hanger library is stored in a MapObject:

- **Dictionary:** "Hangers"
- **Entry:** "Simpson"
- **Map Keys:** Hanger model numbers (e.g., "HUC410-2", "IUS2.37/11.88")

Each hanger map contains:

```
dWidth          → Joist width capacity (inches)
dJoistHeight    → Joist height capacity (inches)
dHangerHeight   → Height of hanger side plates (inches)
stType          → "F", "TF", "CF", "S", "TT"
stWebStiff      → "Yes" / "No"
stFaceNails     → "0.148 x 3""
stTopNails      → "0.148 x 1 1/2""
stJoistNails    → "0.148 x 2 1/2""
iFaceNailsQty   → 4
iTopNailsQty    → 2
iJoistNailsQty  → 8
stSingleJoist   → "TJI 110 9.5 JOIST, 2X10, LPI 20 PLUS 9.5 JOIST"
stDoubleJoist   → "2X10, 2X12"
stTripleJoist   → "2X10"
stQuadJoist     → "2X10"
stAngleJoist    → "2X10, 2X12"
stDoubleAngleJoist → "2X10"
```

### Updating the Library

To refresh the hanger database:

1. Edit `HangerList.xls` in Excel (add/modify hanger specifications)
2. Right-click on any placed hanger in AutoCAD
3. Select **"Update Hanger List"** from context menu
4. Script re-imports Excel data into MapObject
5. Confirmation message: "Retrieved Hanger list of length [count]"

**Note:** The library auto-updates the first time the script runs in each drawing.

---

## Troubleshooting

### Error: "No valid hangers listed for Joist Key [profile]"

**Cause:** The joist's Extrusion Profile is not found in the hanger database.

**Solution:**
1. Verify joist Extrusion Profile matches database format (e.g., "TJI 110 11.875 JOIST")
2. Switch to **Manual Mode** to select hangers by geometry instead
3. Update hanger database to include the profile

### Error: "No available hangers for this situation"

**Cause:** No hangers in the database match the joist dimensions (in Manual mode).

**Solution:**
1. Select `****CUSTOM****` hanger option
2. Manually specify hanger geometry and nailing
3. Add appropriate hangers to the Excel database

### Error: "Width tolerance exceeded, width = [value]"

**Cause:** Ganged joists are spaced too far apart for a standard multi-ply hanger.

**Solution:**
1. Verify joist center-to-center spacing
2. Check that all joists have consistent widths
3. Ensure joists are truly sistered (not separate singles)
4. Adjust joist positions to be within 0.25" of touching

### Script Self-Destructs on Insertion

**Possible causes:**
1. **No beams selected:** Select at least 1 joist and 1 header
2. **Non-parallel joists:** All joists must run in same direction
3. **Invalid beam references:** Beams may have been deleted or corrupted

**Solution:**
- Re-insert script with valid beam selections
- Verify beam Element assignments

### Web Stiffeners Not Created

**Possible causes:**
1. Joist is not an I-joist (dimensional lumber doesn't get stiffeners)
2. Extrusion Profile doesn't match recognized I-joist profiles
3. Web Stiffener property is set to "No"

**Solution:**
- Set **Web Stiffener = Yes**
- Verify joist profile matches TJI/LPI/BCI formats exactly
- Check for case-sensitivity in profile names (script converts to CAPS)

### Hangers Display in Wrong Color (Cyan/Color 12)

**Cause:** Script is in Manual Mode (warning that hanger was not auto-validated).

**Meaning:** You should verify the hanger selection is appropriate for the application.

**Solution:**
- If intentional, ignore the warning color
- If unintentional, switch to Standard Mode for auto-validation

### Hanger Model Changed But Nailing Didn't Update

**Cause:** Nailing only auto-updates on insertion or when **My Hanger Model** is changed. Other property changes don't trigger nailing updates.

**Solution:**
1. Switch to a different hanger model
2. Switch back to desired model
3. Nailing will now update from database

---

## Technical Notes

### Script Behavior Details

1. **Parametric Recalculation:**
   - Hanger geometry auto-updates when linked joists/headers move
   - Web stiffeners and backer blocks reposition automatically
   - Cuts are re-applied to joists on every recalculation

2. **Compare Key (for Scheduling):**
   - Script generates a comparison key from all properties
   - Identical hangers (same model, nails, accessories) group together in schedules
   - Formula: Model + Notes + Web + Backer + JoistNails + FaceNails + TopNails + ShipLoose

3. **Element Assignment:**
   - Hanger inherits Element group from the first joist selected
   - Web stiffeners and backer blocks also assign to this Element
   - Ensures hangers appear in correct panel/assembly schedules

4. **Position Number:**
   - Auto-assigned from hsbCAD position numbering system
   - Read-only property
   - Used for tracking in fabrication sequences

5. **Self-Healing:**
   - If a beam is deleted, the hanger self-destructs on next recalculation
   - Prevents orphaned hangers with invalid references
   - Confirmation message logged to command line

### Performance Considerations

- **First use in drawing:** Script triggers `FLR_HangerList.mcr` to load database (~2-3 second delay)
- **Subsequent uses:** Database is cached in MapObject (instant)
- **Multi-insertion mode:** Efficiently places dozens of hangers without re-launching
- **Library update:** Regenerates MapObject from Excel (5-10 seconds for ~150 hanger models)

### Units Handling

- Script is **unit-agnostic** (works in both inch and millimeter templates)
- All hardcoded dimensions use `U()` function for conversion
- Database dimensions stored in inches (converted on read if template is metric)

### Version History Highlights

- **V5.26 (2020):** Fixed validation for missing beams, improved angled connection display
- **V5.21 (2019):** Added wall support, top hanger option
- **V5.19 (2019):** Added nails as hardware components
- **V5.15 (2017):** Added shop floor display representation
- **V4.9 (2017):** Added tolerance for hanger selection
- **V4.0 (2014):** Integrated with hanger list MapObject system
- **V2.3 (2009):** Converted to O-Type to avoid mirror bug
- **V1.0 (2008):** Initial release with .NET Excel reader

---

## Related Tools

The following scripts work in conjunction with FLR_SimpsonHanger:

### Prerequisite Scripts

- **FLR_HangerList:** Loads Simpson hanger database from Excel file
  - Auto-triggered on first use in each drawing
  - Contains specifications for 150+ Simpson hanger models

### Schedule/Output Scripts

- **Schedule TSLs:** Query the "moHangers" MapObject to generate:
  - Hanger schedules by Element
  - Hardware bills of material
  - Fabrication cut lists

- **Layout Tools:** Read `HANGER_SCHEDULE` map data to:
  - Place hanger symbols on shop drawings
  - Dimension hanger locations
  - Create installation guides

### Related Hardware Scripts

- **FLR_SimpsonETB:** Simpson ETB (economical top-flange) hangers
- **Simpson StrongTie Anchor:** Simpson anchor systems
- **Generic Hanger:** Customizable hanger creator for non-Simpson hardware

---

## Best Practices

### Modeling Workflow

1. **Model structure first:** Create beams, assign Extrusion Profiles
2. **Group into Elements:** Assign beams to wall/floor/roof Elements
3. **Place hangers in batch:** Use continuous insertion mode for efficiency
4. **Review in 3D:** Verify hanger placement and orientation
5. **Check schedules:** Ensure hangers appear in correct Element BOMs

### Database Management

- **Maintain Excel master:** Keep `HangerList.xls` as the authoritative source
- **Document custom hangers:** Add notes in Excel for non-standard models
- **Version control:** Back up Excel file when adding new hanger types
- **Standardize profiles:** Use consistent naming for joist Extrusion Profiles

### Quality Control

- **Standard mode preferred:** Use Manual mode only when necessary
- **Verify nailing:** Check that face/top/joist nail specs meet code requirements
- **Check accessories:** Ensure web stiffeners and backers are specified correctly
- **Review loose hangers:** Confirm that "Ship Loose" flags match installation plan
- **Validate dimensions:** Use cyan color (Manual mode) as a flag for manual review

### Fabrication Coordination

- **Export early:** Generate hardware schedules before cutting lists
- **Cross-reference:** Match hanger locations to joist layout drawings
- **Loose vs. installed:** Clearly communicate which hangers ship loose vs. pre-installed
- **Nailing instructions:** Include nail specifications on shop drawings

---

## Limitations and Constraints

### Known Limitations

1. **Excel dependency:** Requires `HangerList.xls` file and `FLR_HangerList.mcr` script
2. **Simpson-specific:** Database contains only Simpson Strong-Tie® products (extend for other manufacturers)
3. **I-joist profiles:** Web stiffener sizes only defined for 15 common I-joist types
4. **Angled triple/quad:** Not supported for angled connections (auto-switches to Manual)
5. **Profile case-sensitivity:** Joist profiles must match database capitalization

### Maximum Capacities

- **Max joists per hanger:** 4 (quad)
- **Max width tolerance:** 0.015625" per gap between joists
- **Angle detection threshold:** ± 5° from perpendicular to trigger skewed mode

### Not Included

- **Structural calculations:** Script does not verify load capacity
- **Code compliance:** User must verify hanger selection meets building codes
- **Installation details:** Does not model individual fastener locations
- **Joist reactions:** Does not calculate or display bearing forces

---

## Summary

**FLR_SimpsonHanger** is a production-grade tool for automating joist hanger placement in timber frame structures. Its intelligent database-driven selection system ensures code-compliant hardware specifications while dramatically reducing manual modeling time.

Key strengths:
- **Automation:** Auto-selects hangers from 150+ models based on joist profiles
- **Accuracy:** Database ensures correct nailing per Simpson specifications
- **Flexibility:** Supports standard and custom hangers, multiple joist types
- **Integration:** Full hardware export to schedules, BOMs, and fabrication systems
- **Parametric:** Updates automatically when beams are repositioned

Use this tool early in the design process to validate framing connections, then leverage the detailed hardware output for accurate material takeoffs and fabrication planning.

---

**Document Version:** 1.0
**Script Version:** 5.26
**Last Updated:** 2026-02-21
**Author:** Craig Colomb (original), hsbCAD Documentation Team
**Contact:** cc@hsb-cad.com
