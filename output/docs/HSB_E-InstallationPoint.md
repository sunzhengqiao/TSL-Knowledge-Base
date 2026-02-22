# HSB_E-InstallationPoint - Installation Point for MEP Systems

## Overview

**HSB_E-InstallationPoint** creates intelligent installation points for electrical, plumbing, and other MEP (Mechanical, Electrical, Plumbing) systems within wall elements. This script places parametric electrical boxes, outlet symbols, and installation tubes that automatically adapt to wall geometry and can apply CNC tooling for manufacturing.

### Primary Use Cases
- Electrical outlets (single, double)
- Light switches (single, double, double-pole)
- Light connection points
- Water and ground connections
- Custom installation boxes
- Pull switches and special electrical devices

---

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 3.11 (November 28, 2025) |
| **Beams Required** | 0 |
| **Grip Points** | 0 |
| **Environment** | Model Space |
| **DXF Output** | Supported |

---

## Insertion Workflow

### Step 1: Launch the Script
- Execute `HSB_E-InstallationPoint` from the hsbCAD toolbar or command line
- Optionally use a catalog preset for predefined configurations

### Step 2: Configure Installation Type
- A dialog appears with configuration options
- Select the installation type (Outlet, Switch, Water, etc.)
- Configure box shape, size, and side (front/back)
- Set tooling options if CNC machining is required

### Step 3: Select Wall Element
**Prompt:** "Select an element"
- Click on the wall element where you want to place installation points

### Step 4: Place Installation Points
**Prompt:** "Select position" (repeating)
- Click multiple points on the wall to place installation boxes
- Press **ESC** or **Enter** to finish placement
- The script automatically calculates height and orientation

### Step 5: Review Result
- Installation boxes appear at selected locations
- Symbols and text labels show installation type
- Optional installation tubes extend through wall zones
- CNC tooling is automatically applied to wall and sheeting

---

## User Interface

### Dialog Configuration (On Insert)

When inserting new installation points, a dialog allows you to configure:

1. **Installation Type** - Select from 12 predefined types
2. **Box Shape** - Circle, Rectangle, Slotted, or Custom block
3. **Side Placement** - Front, Back, or Both
4. **Tube Configuration** - Top/bottom tubes with catalog selection
5. **Tooling Options** - Mill or drill settings for CNC

### Properties Palette (OPM)

After insertion, all parameters are editable through the AutoCAD Properties Palette, organized in categories:

---

## Parameter Categories

### 1. Type & Position

Controls what type of installation and where it's located.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Point select mode** | Choice | "Create on selected point" | How to determine point position:<br>• Create on selected point<br>• Create on selected height |
| **Type** | Choice | "Outlet" | Installation device type (12 options) |
| **Subtype** | Text | (empty) | Custom subtype for filtering in dimensions |
| **Horizontal offset** | Distance | 0 mm | Horizontal shift along wall |
| **Height** | Distance | 200 mm | Elevation from wall bottom |
| **Side** | Choice | "Front" | Wall side:<br>• Front<br>• Back<br>• Front and back (on insert only) |
| **Number of custom boxes** | Integer | 1 | Number of boxes for "Custom" type |
| **Orientation** | Choice | "Horizontal" | Box alignment:<br>• Horizontal<br>• Vertical |

#### Installation Type Options

1. **Outlet** - Single electrical outlet (Description: A)
2. **Double outlet** - Two outlets in single box (Description: B)
3. **Switch** - Single light switch (Description: C)
4. **Double switch** - Two switches (Description: D)
5. **Double-pole switch** - Two-pole switch (Description: E)
6. **Pull switch** - Ceiling pull switch (Description: F)
7. **Double-pole pull switch** - Two-pole pull switch (Description: G)
8. **Light connection** - Ceiling light connection (Description: H)
9. **Water** - Water connection point (Description: I)
10. **Ground** - Grounding point (Description: J)
11. **Additional open** - Custom open connection (Description: K)
12. **Additional closed** - Custom closed connection (Description: L)
13. **Custom** - User-defined (Description: X)

---

### 2. Boxshape & Size

Defines the physical dimensions and shape of the installation box.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Shape** | Choice | "Circle" | Box geometry:<br>• Circle<br>• Rectangular<br>• Slotted<br>• Custom |
| **Custom block** | Block Name | (empty) | Reference block for custom shape - the pline will be extracted as milling path |
| **Diameter, or width of box** | Distance | 72 mm | Box diameter (circle) or width (rectangular/slotted) - aligned to orientation |
| **Height of box** | Distance | 72 mm | Box height (rectangular/slotted only) - perpendicular to orientation |
| **Box overlap** | Distance | 4 mm | Overlap distance between multiple boxes |
| **Depth box** | Distance | 50 mm | Box depth into wall thickness |
| **Make area between boxes squared** | Yes/No | No | Creates squared area between multiple boxes |

**Shape Behavior:**
- **Circle**: Diameter parameter sets the circular cutout size
- **Rectangular**: Width × Height creates a rectangular box
- **Slotted**: Creates an oval shape with semicircular ends
- **Custom**: Uses a block definition's polyline as the cutting profile

---

### 3. Tubes

Installation tubes extend from the box through wall zones for cable/pipe routing.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Add tube to top** | Yes/No | No | Create tube extending upward |
| **Catalog tube to top** | Catalog | (first available) | Preset configuration for top tube |
| **Extend tube at top** | Distance | 0 mm | Additional extension beyond wall |
| **Add tube to bottom** | Yes/No | No | Create tube extending downward |
| **Catalog tube to bottom** | Catalog | (first available) | Preset configuration for bottom tube |
| **Extend tube at bottom** | Distance | 0 mm | Additional extension beyond wall |
| **Amount of tubes** | Choice | 1 | Number of tubes (1 or 2) - for dual conduit routing |

**Tube Behavior:**
- Tubes are created using the **HSB_E-InstallationTube** script
- They automatically detect wall boundaries and extend through all zones
- Tube properties can be reset via context menu
- Diameter is automatically retrieved from catalog settings

---

### 4. Visualization

Controls how the installation point appears in drawings.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Draw box as body** | Yes/No | No | Show 3D box body in addition to outline |
| **Color of box** | Color Index | 5 | AutoCAD color for box outline |
| **Color of symbol** | Color Index | 1 | AutoCAD color for electrical symbol |
| **Symbol size** | Distance | 50 mm | Size of electrical symbol graphics |
| **Text size** | Distance | 50 mm | Height of description text |
| **Elevation view** | Choice | "Symbol" | What to show in elevation:<br>• Symbol<br>• Description<br>• Symbol and description<br>• Show nothing |
| **Overrule description** | Text | (empty) | Custom text instead of automatic description |
| **Hatch pattern front** | Hatch | (default) | Fill pattern for front-side boxes |
| **Hatch scale front** | Scale | 1.0 | Scale factor for front hatch |
| **Hatch pattern back** | Hatch | (default) | Fill pattern for back-side boxes |
| **Hatch scale back** | Scale | 1.0 | Scale factor for back hatch |
| **Number of symbols per box** | Integer | 1 | How many symbols to draw per box (1-n) |
| **True color front** | Color | 3 | True color for front installations |
| **True color back** | Color | 4 | True color for back installations |
| **Show height of point** | Yes/No | No | Display height dimension in front view |

**Symbol Display:**
- Each installation type has a unique graphical symbol
- Symbols adapt to wall orientation and view direction
- Description text is always horizontal and screen-aligned
- Front vs. back installations use different colors for easy identification

---

### 5. DXF Visualization

Specialized settings for DXF export output.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dxf output Color** | Color Index | 3 | Color for DXF exported geometry |
| **Dxf output Layer** | Text | "05_Electra" | Target layer in DXF file |
| **Offset dxf centerpoint** | Distance | 0 mm | Offset for centerpoint visualization only (not the box itself) |

**DXF Export Behavior:**
- Different symbols are generated based on box shape:
  - **Circle**: Plus sign (+ symbol) at center
  - **Rectangular**: Corner indicators at four corners
  - **Slotted**: Horizontal and vertical reference lines
- Back-side installations include a diagonal line indicator
- All DXF geometry respects the specified layer and color

---

### 6. Tooling

CNC machining operations applied to wall elements and sheeting.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool type** | Choice | "None" | Tooling operation:<br>• None<br>• Mill<br>• Drill |
| **Apply tooling per zone** | Yes/No | Yes | Apply separate tools per sheeting zone vs. all-at-once |
| **Show cut out in sheeting** | Yes/No | Yes | Create cutouts in wall sheeting panels |
| **Cut out tool** | Choice | "Drill" | Tool type for sheet cutouts:<br>• Drill (segmented hole)<br>• Free profile (perfect round) |
| **Apply beamcut to beams** | Yes/No | Yes | Cut through studs/beams behind installation box |
| **Apply no nail area** | Yes/No | No | Create no-nailing zone around box |
| **Offset no nail area** | Distance | 10 mm | Expansion offset for no-nail zone |
| **Excluded sheeting zones (index)** | Text | (empty) | Zone indexes to skip (e.g., "1;3;5") - separated by semicolon |

**Tooling Application:**
- Tooling is automatically applied to **Element zones** (wall sheeting layers)
- Both front and back zones can be processed
- Excluded zones are skipped completely

---

### 7. Mill Settings (Sub-category of Tooling)

Specific parameters when **Tool type** = "Mill"

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Mill direction** | Choice | "Forward" | Milling path direction:<br>• Forward<br>• Backward |
| **Toolindex mill** | Integer | 0 | CNC tool index for router bit |
| **Extra depth mill** | Distance | 0 mm | Additional milling depth beyond calculated |
| **Apply vacuum for mill** | Yes/No | Yes | Enable vacuum during milling |
| **Side for mill** | Choice | "Left" | Tool approach side:<br>• Left<br>• Right |
| **Turning direction mill** | Choice | "Turn against course" | Router rotation:<br>• Turn against course<br>• Turn with course |
| **Overshoot mill** | Yes/No | Yes | Extend tool path beyond profile |

---

### 8. Drill Settings (Sub-category of Tooling)

Specific parameters when **Tool type** = "Drill"

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Toolindex drill** | Integer | 0 | CNC tool index for drill bit |
| **Extra depth drill** | Distance | 0 mm | Additional drilling depth |
| **Apply vacuum for drill** | Yes/No | Yes | Enable vacuum during drilling |

---

### 9. Noggin (Blocking)

Optional horizontal blocking beam between studs at installation point height.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Create** | Yes/No | No | Insert horizontal noggin (blocking) |
| **Elevation** | Distance | 1250 mm | Height of noggin center |
| **Alignment** | Choice | "Center" | Depth alignment:<br>• Front<br>• Center<br>• Back |
| **Offset** | Distance | 0 mm | Fine depth adjustment |
| **Width** | Distance | 0 (auto) | Noggin width (0 = use element beam width) |
| **Height** | Distance | 0 (auto) | Noggin height (0 = use element beam height) |
| **Name** | Text | (empty) | Noggin name for BOM |
| **Material** | Text | (empty) | Wood species or material |
| **Grade** | Text | (empty) | Material grade/quality |
| **Information** | Text | (empty) | Additional notes |
| **Label** | Text | (empty) | Custom label |
| **Beam code** | Text | (empty) | Reference code |
| **Interdistance** | Distance | 0 mm | Spacing value for extra milling between boxes |

**Noggin Behavior:**
- The script automatically finds adjacent studs to stretch the noggin between them
- Noggin is added to the element group and assigned to Zone 0, character 'Z'
- If studs cannot be found, an error is reported

---

## Context Menu Operations

Right-click on an installation point to access these commands:

### 1. Reset Tube Properties
**Purpose:** Clears stored tube configurations and forces tubes to use current catalog settings

**Use When:**
- Tube catalog has been updated
- You want to restore default tube behavior
- Tubes are not reflecting current settings

### 2. Delete Installation Point and Tubes
**Purpose:** Removes the installation point and all associated tubes

**Warning:** This action cannot be undone through Undo command

### 3. Add/Remove Extra Mill Negative
**Purpose:** Toggles extra milling on the negative side (left) of the installation box

**Use When:**
- Multiple boxes are placed in a row
- You need to mill the gap between adjacent boxes
- Creating continuous channels for cable routing

### 4. Add/Remove Extra Mill Positive
**Purpose:** Toggles extra milling on the positive side (right) of the installation box

**Use When:**
- Similar to negative milling, but on opposite side
- Creating extended channels

### 5. Automatically Calculate Extra Millings
**Purpose:** Analyzes all installation points on the element and automatically determines which boxes need extra milling based on interdistance

**Logic:**
- Sorts all installation points along the wall
- Checks distance between adjacent points
- If distance ≤ 100 mm: Adds extra milling between boxes
- If distance > 100 mm: Removes extra milling

**Use When:**
- After adding/moving multiple installation points
- To ensure proper channel continuity
- Before finalizing manufacturing data

---

## Workflow Examples

### Example 1: Standard Electrical Outlet

**Scenario:** Place a single outlet at 300mm height on wall front

**Steps:**
1. Run `HSB_E-InstallationPoint`
2. In dialog, select:
   - Type: **Outlet**
   - Side: **Front**
   - Height: **300 mm**
   - Shape: **Circle** (72mm diameter)
   - Add tube to bottom: **Yes**
3. Select wall element
4. Click at desired horizontal position
5. Press ESC to finish

**Result:**
- Circular box appears at 300mm height
- Outlet symbol (fork with arc) displays
- Tube extends from box down through wall
- Description "A 300" appears above symbol

---

### Example 2: Double Light Switch with Noggin

**Scenario:** Install a double switch at 1100mm with horizontal blocking

**Steps:**
1. Run script
2. Configure:
   - Type: **Double switch**
   - Height: **1100 mm**
   - Orientation: **Horizontal**
   - Shape: **Rectangular** (72 × 72 mm)
   - **Create noggin: Yes**
   - Noggin elevation: **1100 mm**
3. Select wall element
4. Click position
5. Press ESC

**Result:**
- Rectangular box at 1100mm
- Double switch symbol (two switch levers)
- Horizontal noggin beam between studs at same height
- Box provides structural support for switch installation

---

### Example 3: Water Connection with CNC Tooling

**Scenario:** Create water connection with automatic CNC machining

**Steps:**
1. Run script
2. Configure:
   - Type: **Water**
   - Side: **Back**
   - Height: **400 mm**
   - Shape: **Circle** (diameter 72mm)
   - **Tool type: Mill**
   - **Show cut out in sheeting: Yes**
   - **Apply beamcut to beams: Yes**
3. Select wall element
4. Click position
5. Press ESC

**Result:**
- Circular box on wall back
- "W" symbol in circle
- **Milling operations** applied to all sheeting zones
- **Beamcuts** applied to studs intersecting the box
- Ready for CNC export

---

### Example 4: Custom Block Installation

**Scenario:** Use a custom-shaped block for a specialized outlet

**Steps:**
1. Create a block in AutoCAD with a polyline defining the desired cutout shape
2. Run `HSB_E-InstallationPoint`
3. Configure:
   - Type: **Custom**
   - Shape: **Custom**
   - **Custom block:** [Select your block name]
   - Height: **300 mm**
4. Select wall element
5. Click position

**Result:**
- Custom profile extracted from block
- Used as milling path
- Box shape matches block polyline
- All tooling follows custom geometry

---

### Example 5: Front and Back Installation with Tubes

**Scenario:** Through-wall installation with boxes on both sides

**Steps:**
1. Run script (only available during insertion)
2. Configure:
   - Type: **Outlet**
   - Side: **Front and back** (only available on insert)
   - Add tube to top: **Yes**
   - Add tube to bottom: **Yes**
3. Select wall element
4. Click position once

**Result:**
- **Two installation points** created automatically
- One on front, one on back
- Only front installation has tubes
- Both share same horizontal and vertical position
- Aligned through-wall installation

---

### Example 6: Row of Outlets with Automatic Milling

**Scenario:** Install 4 outlets in a row with continuous channel

**Steps:**
1. Insert 4 installation points at:
   - 300mm, 400mm, 500mm, 600mm horizontal positions
   - All at 300mm height
   - Set **Interdistance: 50mm**
2. Select the first installation point
3. Right-click → **Automatically calculate extra millings**

**Result:**
- Script analyzes all 4 points
- Detects they are within 100mm of each other
- Automatically adds extra milling between adjacent boxes
- Creates continuous 50mm wide channel connecting all outlets

---

## Technical Details

### Coordinate System Behavior

1. **Insertion Point (`_Pt0`):**
   - Projected onto wall front plane
   - Adjusted by horizontal offset
   - Serves as reference for all calculations

2. **Grip Point (`_PtG[0]`):**
   - The actual 3D position of the installation box center
   - Calculated as: `_Pt0 + wall_Y_axis * Height`
   - Can be moved dynamically with AutoCAD grips

3. **Height Synchronization:**
   - When grip point moves: Height property updates automatically
   - When Height property changes: Grip point repositions
   - Property name tracked: `_kNameLastChangedProp`

### Box Geometry Calculation

**For multiple boxes:**
- First box center: `ptInsert - orientation_vector * (boxes - 1) * 0.5 * (width - overlap)`
- Subsequent boxes offset by: `(width - overlap)` along orientation vector
- Boxes overlap by the specified overlap distance

**Orientation:**
- Horizontal: Aligned with wall X-axis
- Vertical: Rotated 90° around wall Z-axis
- Custom block: Uses block's inherent orientation

### Zone Detection and Side Logic

The script automatically detects wall side orientation:

1. **Front detection:**
   - Checks if Zone 1 sheeting exists
   - Validates that icon side matches zone side
   - Issues warning if mismatch detected

2. **Back detection:**
   - Checks if Zone -1 (Zone 6) sheeting exists
   - Validates alignment
   - Adjusts arrow flip if needed

3. **Arrow flip flag:**
   - `nArrowFlipped = 1`: Normal orientation
   - `nArrowFlipped = -1`: Icon and zone sides don't match

### Tooling Application Logic

**Sheeting zones:**
```
For Front (nSide = 1): Zones 1, 2, 3, 4, 5
For Back (nSide = -1): Zones -1, -2, -3, -4, -5
```

**Per-zone tooling** (when "Apply tooling per zone" = Yes):
- Each zone gets individual `ElemMill` or `ElemDrill`
- Depth = zone thickness
- Allows different depths per layer

**All-at-once tooling** (when "Apply tooling per zone" = No):
- Single `ElemMill`/`ElemDrill` for entire side
- Depth = sum of all zone thicknesses
- More efficient for uniform sheeting

**Excluded zones:**
- Entered as semicolon-separated indexes: "1;3;5"
- Completely skipped during tooling application
- Useful for leaving exterior cladding intact

### Beamcut Application

When "Apply beamcut to beams" is enabled:

1. **Intersection check:**
   - Creates a test body at box location
   - Tests each beam's envelope for intersection
   - Only processes intersecting beams

2. **Alignment detection:**
   - If beam is parallel to wall X-axis: Uses `beamCutHorizontal`
   - Otherwise: Uses standard `beamCut` with 1000mm width
   - Both cuts are "through" cuts (depth = box depth)

3. **Directionality:**
   - Beamcut always applied from opposite side of installation
   - For front installation: Cuts from back
   - For back installation: Cuts from front

### Tube Creation Logic

**Automatic tube insertion:**

1. **Boundary detection:**
   - Uses `el.plEnvelope()` to find wall outline
   - Fallback: Uses `profBrutto` of Zone 0
   - Intersects with vertical plane through insertion point

2. **Tube endpoints:**
   - **Bottom tube:** From box to bottom boundary - extend
   - **Top tube:** From box to top boundary + extend
   - Offset by half box size in vertical direction

3. **Property persistence:**
   - When tubes are deleted, their properties are saved in parent map
   - On recreation, saved properties are restored
   - Catalog keys: `"TopTubeCatalog"`, `"BottomTubeCatalog"`

4. **Dual tubes:**
   - When "Amount of tubes" = 2:
   - Tube diameter is retrieved from catalog
   - Tubes are offset horizontally by ±diameter/2
   - Creates side-by-side conduit routing

### DXF Output Geometry

Different visualization patterns based on box shape:

**Circle:**
- Centerpoint: Plus sign (horizontal + vertical lines, 50% of symbol size)
- Optional diagonal if on back side

**Rectangular:**
- Four corner indicators (L-shaped lines at each corner)
- Each indicator is 25% of box size
- Optional diagonal if on back side

**Slotted:**
- Horizontal centerline (full width)
- Two horizontal lines at ±25% height
- Vertical centerline
- Optional diagonal if on back side

**All shapes:**
- Diagonal line from top-left to bottom-right if `nSide < 0` (back side)

### Symbol Drawing System

Each installation type has a unique symbol geometry:

**Outlet Symbol:**
- Vertical line extending from wall
- Horizontal crossbar
- Arc at top (created using bulge vertex)

**Switch Symbol:**
- Circle at base
- Angled lever line
- Position indicates switch state

**Water/Ground Symbols:**
- Vertical line
- Circle at top
- Letter inside circle ("W" for water, "A" for ground)

**Symbol coordinate transformation:**
1. **Plan view (top):** Drawn in wall plane, hidden from Y-direction
2. **Elevation view (front):** Transformed to elevation coordinate system
3. **Hide directions:** Automatically applied to prevent incorrect views

### BOM (Bill of Materials) Data

The script exports structured BOM data:

```
Map structure:
- Name: Installation type (e.g., "Outlet")
- Label: Subtype
- SubLabel: Box shape
- Type: Overrule description (if specified)
- Width: Box size
- Height: Box height
- NettoWidth: Box size
- NettoHeight: Box height
```

Accessed via: `_Map.getMap("BOM")`

### Dimension Information Export

The script publishes dimension requests for `hsbViewDimension` and similar TSLs:

**DimRequest structure:**
- **vecDimLineDir:** Dimension line direction (horizontal/vertical)
- **vecPerpDimLineDir:** Extension line direction
- **AllowedView:** View vector where dimension is visible
- **Node[]:** Array of 3 points (start, mid, end of box extent)
- **Stereotype:** Script name for filtering
- **ParentEnt:** Reference to this installation point
- **AlsoReverseDirection:** Flag for bidirectional dimensioning

**Published via:** `_ThisInst.setSubMapX("Hsb_DimensionInfo", mapX)`

### Noggin Stretching Algorithm

1. **Stud search:**
   - Cast half-line from noggin center in -X direction
   - Find closest beam intersection → Left stud
   - Cast half-line in +X direction
   - Find closest beam intersection → Right stud

2. **Noggin creation:**
   - Create beam at center position
   - Default size: 50mm length × element beam dimensions
   - Color: 32 (brown)
   - Type: `_kBlocking`

3. **Dynamic stretching:**
   - `bmNoggin.stretchDynamicTo(bmAtLeft)` → Creates contact entity
   - `bmNoggin.stretchDynamicTo(bmAtRight)` → Creates contact entity
   - Contact entities assigned to element group
   - Noggin assigned to Zone 0, character 'Z'

4. **Error handling:**
   - If either stud not found: Reports error and skips noggin creation

### Extra Milling System

**Negative milling** (left side):
- Creates rectangular mill zone at: `ptBox + vxBox * (interDistance * 0.5)`
- Width = `interDistance`
- Height = `dBoxHeight`

**Positive milling** (right side):
- Creates rectangular mill zone at: `ptBox - vxBox * (interDistance * 0.5)`
- Same dimensions as negative

**Automatic calculation:**
1. Gets all `HSB_E-InstallationPoint` instances on element
2. Sorts by position along orientation vector
3. For each adjacent pair:
   - If distance ≤ 100mm: Ensures negative milling is ON
   - If distance > 100mm: Ensures negative milling is OFF
4. Uses context menu triggers to toggle states

**Stored in map:**
- `_Map.getInt("Negative")` - Negative milling state
- `_Map.getInt("Positive")` - Positive milling state

---

## Advanced Features

### Multi-Symbol Display

When "Number of symbols per box" > 1:

**Even number of symbols:**
- Symbols distributed symmetrically around center
- Spacing = `dBoxSize / numberOfSymbolsPerBox`
- Example: 4 symbols → positions at -1.5, -0.5, +0.5, +1.5 × spacing

**Odd number of symbols:**
- One symbol at center
- Remaining symbols distributed equally on both sides
- Example: 5 symbols → positions at -2, -1, 0, +1, +2 × spacing

### Execution Loops

The script uses **2 execution loops** when tubes are created:

**Why?**
- First loop: Installation point creates its map data
- Second loop: Tubes can read parent map and create properly
- Dependency: Tubes need parent's map to be complete

**Implementation:**
```c
setExecutionLoops(2);
if (!bLastExecutionLoop())
    return;  // Exit on first loop, continue on second
```

### Height Display in Front View

When "Show height of point" = Yes:

1. **Reference line:**
   - From outlet center to text point
   - Offset by box size + 0.5 × box size

2. **Text:**
   - Formatted height value (e.g., "300")
   - Placed at text point
   - Hidden from Y-direction (only visible in front view)
   - Device-aligned (always horizontal on screen)

3. **Purpose:**
   - Allows contractors to verify installation heights
   - Visible in shop drawings and layout prints
   - Useful for quality control in hsbMake

### Custom Block Validation

When using custom blocks:

**Requirements:**
1. Block must contain at least one polyline entity
2. Polyline plane must be aligned with wall plane (± tolerance)
3. Polyline becomes the milling path

**Validation:**
```c
if (abs(plBox.coordSys().vecZ().dotProduct(vzEl)) < 1 - dEps)
    → Error: "Pline of block not aligned with element"
```

**Extraction:**
- Searches all entities in block
- Finds first valid `EntPLine`
- Transforms to installation point coordinate system
- Uses as tooling profile

### Side Verification

The script performs automatic side verification:

**Warning conditions:**
1. Icon side doesn't match Zone 1 side
2. Icon side doesn't match Zone 6 side

**Auto-correction:**
- Flips `nSide` internally
- Sets `nArrowFlipped = -1`
- Maintains user's intended "front" as display reference
- Reports warning to user

**Purpose:**
- Ensures tooling is applied to correct zones
- Prevents manufacturing errors
- Alerts user to potential modeling issues

---

## Integration with Other Scripts

### HSB_E-InstallationTube

**Purpose:** Creates conduit/pipe routing through wall
**Triggered by:** "Add tube to top/bottom" properties
**Communication:**
- Parent passes catalog name via map
- Tube reads `"InstallationPointSettings"` map
- Tube stores its properties back to parent on deletion
- Property persistence enables configuration memory

**Map structure:**
```
InstallationPointSettings:
  - InstallationPoint: (Entity reference to parent)
  - Position: "Top" or "Bottom"
  - CatalogName: "TopTubeCatalog" or "BottomTubeCatalog"
```

### hsbViewDimension

**Purpose:** Automatic dimensioning in layout views
**Integration:** Via `Hsb_DimensionInfo` MapX
**Data published:**
- Box extent points for horizontal/vertical dimensions
- Subtype for filtering
- Zone index information

### DXF Export Systems

**Output structure:**
```
_Map["hsb_DxfOutput"]["PLineDisplay[]"]:
  - Path: PLine geometry
  - Layer: "05_Electra"
  - Color: 3 (or user-specified)
```

**Consumed by:**
- `hsb_DxfExport` or similar export scripts
- External DXF processing tools

---

## Common Issues and Solutions

### Issue 1: Installation Point Not Visible

**Symptoms:**
- Script executes but nothing appears
- No error messages

**Causes & Solutions:**
1. **Zone mismatch:**
   - Check if element has sheeting zones
   - Verify "Side" property matches existing zones
   - Look for warning message about side mismatch

2. **Display settings:**
   - Check "Elevation view" property
   - Verify "Show nothing" is not selected
   - Ensure symbol color is not background color

3. **View direction:**
   - Symbol may be hidden in current view
   - Try top view or front view
   - Check hide directions in Display object

### Issue 2: Tubes Not Creating

**Symptoms:**
- Installation box appears but no tubes
- Warning: "Points for tube cannot be found!"

**Causes & Solutions:**
1. **Wall outline invalid:**
   - Element envelope (plEnvelope) may be invalid
   - Check element geometry
   - Verify element is properly formed

2. **Tube settings:**
   - "Add tube to top/bottom" must be "Yes"
   - Catalog must be specified
   - Check if catalog exists

3. **Execution loop:**
   - Script needs 2 loops when creating tubes
   - Debug flag `bOnDebug=true` may be set
   - Set to `false` for production use

### Issue 3: Tooling Not Applied

**Symptoms:**
- Box visible but no CNC tooling on element
- Sheets or beams not cut

**Causes & Solutions:**
1. **Tool type setting:**
   - Verify "Tool type" is not "None"
   - Check "Show cut out in sheeting" property

2. **Zone exclusions:**
   - Review "Excluded sheeting zones" property
   - Ensure target zones are not excluded

3. **Intersection check:**
   - For beams: Box must intersect beam envelope
   - For sheets: Drill/profile must touch sheet
   - Check box depth and position

4. **Per-zone vs. all-at-once:**
   - "Apply tooling per zone" affects how tooling is applied
   - Try toggling this setting

### Issue 4: Noggin Not Created

**Symptoms:**
- Error: "Could not find studs for noggin stretching"

**Causes & Solutions:**
1. **Stud spacing too wide:**
   - No beams found in search direction
   - Check wall framing exists
   - Verify beams are at correct height

2. **Noggin elevation:**
   - May be above or below all beams
   - Adjust "Elevation" property
   - Typical range: 300mm - 2000mm

3. **Beam alignment:**
   - Studs must be roughly perpendicular to wall direction
   - Check beam orientations

### Issue 5: Custom Block Not Working

**Symptoms:**
- Error: "No custom block specified"
- Error: "Pline of block not aligned with element"

**Causes & Solutions:**
1. **Block name:**
   - Must select a valid block name
   - Block must exist in drawing
   - Check spelling

2. **Block contents:**
   - Block must contain a polyline (PLine)
   - Other entities are ignored
   - Ensure pline is the cutting profile

3. **Pline orientation:**
   - Pline plane must match wall plane
   - Use same Z-vector as wall
   - Check with `.vis()` for debugging

### Issue 6: Symbols Overlapping

**Symptoms:**
- Multiple symbols drawn in same location
- Visual clutter

**Causes & Solutions:**
1. **Number of symbols per box:**
   - Review "Number of symbols per box" property
   - Reduce if too many
   - Use 1 for standard installations

2. **Box spacing:**
   - Increase "Box overlap" to separate boxes more
   - Adjust horizontal positions manually

### Issue 7: DXF Output Missing

**Symptoms:**
- No geometry in DXF export

**Causes & Solutions:**
1. **DXF settings:**
   - Verify "Dxf output Layer" is correct
   - Check if layer is frozen in export
   - Verify color is not 0 (invisible)

2. **Export script:**
   - Ensure DXF export script reads `hsb_DxfOutput` map
   - Check export script compatibility

### Issue 8: Height and Grip Point Desynchronized

**Symptoms:**
- Changing height doesn't move grip point
- Moving grip point doesn't update height

**Causes & Solutions:**
1. **Property tracking:**
   - System uses `_kNameLastChangedProp`
   - May require recalculation
   - Try manual recalc (right-click on instance)

2. **Coordinate system:**
   - Grip point projected to wall plane
   - Check wall coordinate system validity

### Issue 9: Extra Milling Not Working

**Symptoms:**
- "Automatically calculate extra millings" has no effect

**Causes & Solutions:**
1. **Interdistance:**
   - Must be > 0
   - Sets the width of extra milling zones
   - Typical value: 50mm

2. **Installation point spacing:**
   - Points must be within 100mm to auto-enable
   - Check actual distances
   - Use manual toggle if needed

3. **Orientation:**
   - All points should have same orientation
   - Sorting algorithm uses orientation vector

---

## Best Practices

### 1. Planning Installation Layouts

**Before inserting:**
- Review electrical/plumbing plans
- Identify required heights (outlets typically 300mm, switches 1100mm)
- Determine if front or back side placement is needed
- Check wall framing layout for noggin placement

**Catalog presets:**
- Create catalog entries for standard configurations
- Typical: "Standard Outlet", "Standard Switch", "Water Connection"
- Saves time and ensures consistency

### 2. Tube Configuration

**When to use tubes:**
- Always for outlets and switches (wiring needs routing)
- Water/ground connections
- Any penetration requiring conduit

**Tube direction:**
- Bottom tubes: For floor-fed installations
- Top tubes: For ceiling-fed installations
- Both: For through-wall pass-throughs

**Tube extension:**
- Set extension to account for floor/ceiling construction
- Typical: 100-200mm beyond wall boundary

### 3. Tooling Strategy

**For manufacturing:**
- Enable "Tool type" = Mill or Drill
- Use "Per zone" for multi-layer walls
- Use "All at once" for uniform sheeting

**For visualization only:**
- Tool type = None
- Enable "Show cut out in sheeting" for visual reference
- No actual CNC operations applied

**Exclusions:**
- Exclude exterior zones if cladding is field-installed
- Exclude zones with pre-installed components

### 4. Symbol Visibility

**For construction drawings:**
- Elevation view: "Symbol and description"
- Show height: Yes (for verification)
- Large symbol size (50-100mm)

**For shop drawings:**
- Elevation view: "Show nothing" (avoid clutter)
- Enable DXF output
- Focus on box outlines only

### 5. Noggin Usage

**When to add noggins:**
- Electrical boxes requiring solid backing
- Water connections needing support
- Any installation transferring load to wall

**Noggin elevation:**
- Match installation point height exactly
- Typical switch height: 1100mm
- Typical outlet height: 300mm

**Alignment:**
- Front: For front-mounted switches (provides backing)
- Center: For neutral installations
- Back: For back-side connections

### 6. Custom Blocks

**Block preparation:**
- Draw polyline in top view (XY plane)
- Close the polyline
- Set insertion point at center
- Test with single instance before batch use

**Naming convention:**
- Use descriptive names: "Outlet_Custom_Square"
- Store in library for reuse

### 7. Front and Back Installation

**When to use:**
- Through-wall electrical boxes
- Mirrored installations on both sides
- Structural connections requiring both-side access

**Important:**
- Only available during initial insertion
- Cannot be changed later via properties
- Create separate instances if needed after insertion

### 8. Multi-Box Installations

**Row installations:**
1. Insert all points first
2. Set consistent "Interdistance" on all
3. Use "Automatically calculate extra millings"
4. Verify continuous channel in 3D view

**Vertical stacks:**
- Use vertical orientation
- Set consistent horizontal offset
- Consider separate noggins at each height

---

## Performance Considerations

### Large Projects

**When working with many installation points:**
- Use catalog presets to speed insertion
- Batch-insert multiple points in single script execution
- Disable tubes temporarily if not needed for current work
- Turn off tooling during design phase

### Recalculation Time

**Factors affecting performance:**
- Number of tubes (each tube recalculates parent)
- Tooling complexity (per-zone slower than all-at-once)
- Noggin creation (searches for adjacent beams)
- Extra milling calculations (sorts all instances)

**Optimization:**
- Disable "Create noggin" if not needed
- Use "Apply tooling per zone" = No when possible
- Limit "Number of symbols per box" to 1

### Execution Loops

**Normal behavior:**
- 2 loops when tubes are enabled
- 1 loop when tubes are disabled
- Each loop recalculates entire script

**Debug mode:**
- Set `bOnDebug = false` for production
- When `true`, skips second execution loop
- Used for development/testing only

---

## Related Scripts

| Script | Relationship | Purpose |
|--------|--------------|---------|
| **HSB_E-InstallationTube** | Child | Creates cable/pipe routing tubes |
| **hsbViewDimension** | Consumer | Reads dimension info for automatic dimensioning |
| **hsbCLT-Drill** | Similar | Basic drilling operations |
| **hsbCLT-Mill** | Similar | Milling operations on CLT panels |
| **hsbViewTag** | Consumer | Can tag installation points in views |
| **hsbBOM** | Consumer | Reads BOM data for material lists |

---

## Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| **3.11** | Nov 28, 2025 | Additional tube diameter check for offset |
| **3.10** | Nov 27, 2025 | Ensure tube diameter picked up for offset |
| **3.9** | Nov 20, 2024 | Fix visibility for height property, add hide direction in top view |
| **3.8** | Nov 20, 2024 | Add property to display height of installation point |
| **3.7** | Oct 30, 2024 | Fix PropDouble index |
| **3.0** | Jun 23, 2021 | Installation shape published as dimension requests |
| **2.9** | Apr 6, 2021 | Add array length check before using `_PtG[]` |
| **2.0** | Aug 28, 2020 | Allow moving installation point with grip point |
| **1.46** | Jun 19, 2020 | Add option for 1 or 2 tubes |
| **1.07** | May 13, 2015 | Add option to auto-insert tube |
| **1.00** | Mar 14, 2013 | Pilot version |

---

## Technical Requirements

### Software
- hsbCAD (version supporting TSL 8)
- AutoCAD or compatible CAD platform

### Dependencies
- **HSB_E-InstallationTube.mcr** - For tube creation
- **TslUtilities.dll** - For dialog UI (optional, for custom dialogs)
- Element with valid zone structure

### File Locations
- Script: `[hsbCAD]\Content\General\TSL\HSB_E-InstallationPoint.mcr`
- Catalogs: `[Company or Install]\TSL\Settings\` (XML format)

---

## Summary

**HSB_E-InstallationPoint** is a comprehensive solution for electrical and MEP installations in timber construction. It combines:

✓ **12 predefined installation types** with unique symbols
✓ **Flexible box shapes** (circle, rectangle, slotted, custom)
✓ **Automatic tube routing** through wall zones
✓ **CNC tooling integration** (milling and drilling)
✓ **Optional noggin creation** for structural support
✓ **DXF export capability** for fabrication
✓ **BOM integration** for material tracking
✓ **Dimension publishing** for automated layout dimensioning

The script's intelligent behavior includes:
- Automatic side detection and verification
- Dynamic height synchronization with grip points
- Property persistence for tube configurations
- Extra milling calculation for continuous channels
- Multi-symbol support for complex installations

Whether you're planning electrical layouts, generating shop drawings, or preparing CNC manufacturing data, this script provides the tools needed for efficient, accurate installation point documentation and fabrication.

---

*For additional support, consult the hsbCAD documentation or contact your hsbCAD administrator.*
