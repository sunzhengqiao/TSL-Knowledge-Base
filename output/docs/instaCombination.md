# instaCombination

**Version:** 3.8
**Category:** MEP (Mechanical, Electrical, Plumbing)
**Type:** Object (O-Type)

## Overview

The `instaCombination` script is the **parent controller** for creating and managing MEP installation layouts in timber construction elements. It organizes multiple installation cells (electrical outlets, junction boxes, switches, etc.) into a coordinated combination and handles automatic conduit routing between them.

This script is the orchestrator of a **three-script suite**:
- **instaCombination** (this script) - Parent controller managing the overall layout
- **instaCell** - Individual installation points (outlets, boxes, switches)
- **instaConduit** - Routing paths connecting cells or running to element edges

### Key Capabilities

- **Multi-Element Support**: Works with SIP panels, CLT/BSP panels, stick-frame walls, log walls, floor elements, and roof elements
- **Rule-Based Insertion**: Save complete cell configurations as reusable rules for consistent installations
- **Automatic Conduit Creation**: Link combinations and automatically generate routing paths
- **Flexible Tooling Options**: Generate CNC machining operations (drilling, milling, mortises, beamcuts, sawlines)
- **Multi-Storey Placement**: Insert on multiple parallel wall elements simultaneously
- **Log Wall Integration**: Specify elevation by log course number instead of absolute distance
- **Plan/Elevation Display**: Automatic view-dependent visualization with customizable colors and symbols

## Prerequisites

### Element Requirements
At least one of the following must exist:
- **ElementWall** - SIP wall, CLT panel, or stick-frame wall
- **ElementRoof** - Roof structure
- **ElementLog** - Log wall construction
- **GenBeam** - Loose timber members (beams, panels)

### Multi-Storey Requirements
For multi-storey insertion:
- Multiple parallel wall elements
- All walls must share the same X-axis orientation
- Insertion point must fall within each wall's contour

## Script Properties

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Environment | Model Space |
| Version | 3.8 (January 17, 2024) |
| Beams Required | 0 |
| DXA Output | Enabled |
| Implicit Insert | Enabled |
| Keywords | Electra, Sanitary, Sip, Installation, CLT, BSP |

## Installation Workflow

### Step 1: Launch the Script

Run the script via command line or toolbar button:
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCombination")) TSLCONTENT
```

### Step 2: Configure Properties (Dialog)

The insertion dialog appears with the following configuration options:

**Rule Category:**
- Select a previously saved rule (e.g., "4x Outlet 1200mm")
- Or use `<Default>` to create a single cell combination

**Alignment Settings:**
- **Elevation**: Vertical offset from element origin (or log course number for log walls)
- **Direction**: Horizontal or Vertical cell arrangement
- **Position**: Anchor point (First Cell, Middle Cell, or Last Cell)
- **Face**: Reference Side or Opposite Side of the element

**Tooling Settings:**
- **Tooling Mode**: byCell, byCell with Mill, byCombination, Sawline, or Milling
- **Tool Index**: Priority index for element-based tooling (stick-frame/roof only)
- **Radius**: Corner radius for milling operations

**Conduit Settings:**
- **Catalog**: Select conduit catalog for automatic routing (or Disabled)
- **Alignment**: Disabled, Bottom, Top, or Top + Bottom edge connections

**Display Settings:**
- **Format**: Display string with variables (@(Quantity)x @(Length) x @(Width))

### Step 3: Select Element or Combinations

**Standard Selection:**
- Select the target wall, floor, roof, or panel element
- Click to confirm

**Linking Mode (if conduit catalog selected):**
- Select element AND/OR existing combinations to link
- Conduits will be auto-created between selected combinations

### Step 4: Pick Insertion Point with Jig Preview

The script displays a visual jig showing:
- **Element View (side/front)**: Green/cyan filled outline, elevation dimension
- **Plan View (top)**: Yellow circle at insertion point, elevation text
- **Conduit Preview**: Green filled paths showing automatic routing (if catalog selected)

**Visual Feedback:**
- ✅ **Green/Cyan Preview**: Valid placement position
- ❌ **Red X Symbol**: Cursor outside element boundary

### Step 5: Use Command-Line Keywords (Optional)

While jig is active, type keywords to modify insertion:

| Keyword | Function | Availability |
|---------|----------|--------------|
| **Elevation** | Enter numeric elevation value | All views |
| **PickPoint** | Set elevation by picking a point | Element view |
| **LogCourse** | Enter log course number | Log walls only |
| **flipFace** | Switch to opposite side | Conduit mode |
| **conduitBottom** | Create conduit to bottom edge | Conduit mode |
| **conduitTop** | Create conduit to top edge | Conduit mode |
| **conduitBOth** | Create conduits to both edges | Conduit mode |
| **conduitNone** | Disable edge conduits | Conduit mode |

### Step 6: Confirm or Continue

- Press **Enter** or **Click** to place the combination
- The script creates the combination with default cell(s)
- If linking combinations, repeat to place additional linked combinations
- Press **Esc** to cancel

## Parameter Reference

### Rule Category

#### Rule
**Type:** Dropdown (String)
**Default:** `<Default>`
**Category:** Rule

Selects a saved configuration rule or creates a new default combination.

**Available Values:**
- `<Default>` - Creates a single default cell
- `<LastInserted>` - Reuses the last inserted configuration
- Custom rule names (e.g., "Kitchen Outlet", "4x Switch 1200mm")

**Business Logic:**
Rules store complete cell configurations including:
- Number and type of cells (instaCell script instances)
- Cell properties (diameter, depth, offset, tool type)
- Conduit connections between cells (if defined)
- Cell spacing and arrangement

**When to Use:**
- Use `<Default>` for quick single-cell placement
- Use saved rules for repetitive installations (standard outlet heights, switch banks)
- Create rules via context menu "Save as rule" after configuring a combination

---

### Alignment Category

#### Elevation
**Type:** Double (Length)
**Default:** 0
**Unit:** Current drawing units (mm/inches)
**Category:** Alignment

Vertical offset from the element's origin point.

**Log Wall Mode:**
When `IsCourseElevation` is enabled for log walls, this value represents the **log course number** (1, 2, 3...) instead of absolute distance. The script automatically calculates the actual elevation based on log heights.

**Snapping Behavior:**
- When dragging `_Pt0` grip point, elevation automatically updates
- For log walls in course mode, snaps to nearest course centerline
- For regular mode, reflects exact vertical distance

**Vertical Cell Offset:**
When `Direction = Vertical` and `Position = First Cell`, if the combination has ≥ `nNumRequiredCellOffset` cells (default 5), the elevation is automatically offset by `nNumVerticalCellOffset` cells. This keeps tall installations within comfortable reach.

**Tips:**
- For standard outlets: Use 300-400mm above floor
- For switches: Use 1100-1200mm above floor
- For log walls: Specify course number for automatic alignment with log layers

---

#### Direction
**Type:** Dropdown (String)
**Default:** Horizontal
**Category:** Alignment

Orientation of cell arrangement within the combination.

**Available Values:**
- **Horizontal** - Cells arranged along the element's X-axis (longitudinal direction)
- **Vertical** - Cells arranged along the element's Y-axis (height direction)

**Effect on Display:**
- Horizontal: Cells spread left-right in elevation view, front-back in plan view
- Vertical: Cells spread bottom-top in elevation view (common for multi-gang outlets)

**Effect on Tooling:**
- Direction determines the primary axis for CNC operations
- Conduit routing adapts to match cell sequence

**When to Use:**
- Horizontal: Standard single outlets, spaced junction boxes
- Vertical: Multi-gang switch plates, vertical outlet stacks

---

#### Position
**Type:** Dropdown (String)
**Default:** First Cell
**Category:** Alignment

Defines which cell in the combination aligns to the insertion point `_Pt0`.

**Available Values:**
- **First Cell** - Insertion point at the first cell center
- **Middle Cell** - Insertion point at the middle of the combination
- **Last Cell** - Insertion point at the last cell center

**Calculation Logic:**
The script calculates total combination length by summing:
```
dLength = Σ(cell_width + 2 × cell_offset)
```

Then positions cells relative to `_Pt0`:
- **First Cell**: `ptRef = _Pt0`
- **Middle Cell**: `ptRef = _Pt0 - vecDir × 0.5 × (dLength - dLengthFirst)`
- **Last Cell**: `ptRef = _Pt0 - vecDir × (dLength - 0.5 × (dLengthFirst + dLengthLast))`

**When to Use:**
- First Cell: When dimensioning from left/bottom edge
- Middle Cell: When centering on a reference line (e.g., room centerline)
- Last Cell: When dimensioning from right/top edge

---

#### Face
**Type:** Dropdown (String)
**Default:** Reference Side
**Category:** Alignment

Specifies which face of the element receives the installation.

**Available Values:**
- **Reference Side** - The element's positive Z-face (typically exterior or reference surface)
- **Opposite Side** - The element's negative Z-face (typically interior or opposite surface)

**Visual Indicators:**
- **Reference Side**: Green symbol in element view
- **Opposite Side**: Cyan symbol in element view

**Auto-Detection in Plan View:**
When inserting from plan view, the script automatically determines face based on pick point location relative to the element contour.

**Flipping:**
- Use context menu "Flip Face" to switch after placement
- Use `flipFace` keyword during jig insertion
- Double-click the combination to toggle face

**Coordinate System Impact:**
Face selection affects `vecFace` direction:
```c
Vector3d vecFace = nFace * vecZ;  // nFace = ±1
Point3d ptFace = ptCen + vecFace × 0.5 × dZ;
```

---

### Tooling Category

#### Tooling
**Type:** Dropdown (String)
**Default:** byCell
**Category:** Tooling

Controls how CNC machining operations are generated for the installation.

**Available Values:**

**1. byCell** - Individual tool per cell
- Creates separate Mortise/Drill/Cut for each instaCell
- Each cell controls its own tool geometry
- Most flexible for mixed cell types

**2. byCell with Mill** - Individual tool + connection milling
- Same as byCell, plus adds milling pockets between adjacent cells
- Pocket size: `dWidthConnection × dDepthConnection` (default 30mm × 30mm)
- Used for recessed routing channels between boxes

**3. byCombination** - Single encompassing tool
- Creates one large Mortise covering all cells
- Dimensions: `dLength × dWidth × dDepth`
- Faster machining, less precise fit
- Corner radius controlled by `Radius` parameter

**4. Sawline** (Stick-frame/Roof elements only)
- Generates element-level Sawline tool at `nToolIndex`
- Cuts through entire element thickness
- Used for large openings or panel edge cuts

**5. Milling** (Stick-frame/Roof elements only)
- Generates element-level Milling tool at `nToolIndex`
- Respects `Radius` parameter for rounded corners
- Surface-level milling operation

**Tool Application Logic:**
```c
if (bByCell) {
    // Each cell adds its own tool
    for each cell: cell.addTool(cellTool);
}
if (bByCellMill) {
    // Add connection pockets between cells
    for each gap: el.addTool(Mortise(connection pocket));
}
if (bByCombination) {
    Mortise ms(ptMid, vecDir, vecPerp, -vecFace, dLength, dWidth, dDepth);
    el.addTool(ms);
}
```

**When to Use:**
- **byCell**: Mixed cell types, precise individual fits
- **byCell with Mill**: Recessed conduit channels between boxes
- **byCombination**: Fast roughing, uniform box arrays
- **Sawline/Milling**: Through-cuts, edge preparation for panels

---

#### Tool Index
**Type:** Integer
**Default:** 1
**Range:** 1-999
**Category:** Tooling
**Visibility:** Hidden unless element is stick-frame/roof AND tooling mode is Sawline/Milling

Priority index for element-based tooling operations.

**Purpose:**
Controls the order in which element tools are executed during CNC machining. Lower indices execute first.

**When Visible:**
Only appears when:
1. Element type is `ElementWallSF` or `ElementRoof`
2. Tooling mode is `Sawline` or `Milling`

**Usage Pattern:**
```
Tool Index 1: Primary structural cuts (openings, edges)
Tool Index 2: Secondary cuts (pockets, grooves)
Tool Index 3: Installation cuts (electrical, plumbing)
Tool Index 4+: Detail work
```

---

#### Radius
**Type:** Double (Length)
**Default:** 0
**Unit:** Current drawing units
**Category:** Tooling

Corner radius for milling operations.

**Application:**
- Used in `byCombination` mode to create rounded-corner Mortises
- Used in `Milling` element tool mode for rounded milling paths
- Ignored when radius = 0 (sharp corners)

**Constraint:**
When `radius > 0` and `Tooling = Sawline`, the script automatically switches to `byCombination` mode and reports a warning.

**Typical Values:**
- 0 mm: Sharp corners (standard drill/router bits)
- 3-5 mm: Small radius for compact installations
- 10-15 mm: Large radius for easier routing, less stress concentration

---

### Conduit Category

#### Catalog
**Type:** Dropdown (String)
**Default:** `<Disabled>`
**Category:** Conduit
**Visibility:** Insert mode only

Selects a conduit catalog for automatic conduit creation.

**Available Values:**
- `<Disabled>` - No automatic conduits
- Catalog names from `instaConduit` script catalogs (e.g., "PVC 20mm", "Flexible 25mm")

**When Selected:**
1. Enables linking mode during insertion (select existing combinations)
2. Enables `Alignment` parameter for edge conduits
3. Changes insertion prompt to "Select element or combinations to connect"
4. Displays conduit preview during jig (green filled paths)

**Linking Behavior:**
When you select existing combinations during insertion:
- Script automatically creates `instaConduit` instances connecting the new combination to selected combinations
- Routing follows orthogonal paths (horizontal-then-vertical or vertical-then-horizontal)
- Conduit width from catalog determines preview thickness

**Catalog Properties Used:**
```c
Map properties = TslInst().mapWithPropValuesFromCatalog("instaConduit", sConduitCatalog);
double dWidthConduit = properties.getMap("PropDouble[]").getMap(0).getDouble("dValue");
String anchor = properties.getMap("PropString[]").getMap(2).getString("strValue");
```

**After Insertion:**
This property becomes hidden (read-only) as conduits are managed separately after creation.

---

#### Alignment
**Type:** Dropdown (String)
**Default:** Disabled
**Category:** Conduit
**Visibility:** Insert mode only (if Catalog selected)

Controls automatic conduit creation to element edges.

**Available Values:**
- **Disabled** - No edge conduits
- **Bottom** - Create conduit from combination to bottom edge of element
- **Top** - Create conduit from combination to top edge of element
- **Top + Bottom** - Create conduits to both edges

**Edge Detection Logic:**
The script finds the intersection of the element contour with a vertical line through the insertion point, creating conduits that run perpendicular to the element face.

**Keywords During Jig:**
You can change this setting during insertion using keywords:
- `conduitBottom` → Bottom
- `conduitTop` → Top
- `conduitBOth` → Top + Bottom
- `conduitNone` → Disabled

**Visual Preview:**
During jig, edge conduits display as green filled rectangles extending to element boundaries.

**Anchor Mode:**
If the conduit catalog's anchor property is set to `Combination` (instead of `Cells`), conduits attach to the combination's center node rather than individual cell nodes.

**After Insertion:**
Like `Catalog`, this becomes hidden after placement.

---

### Display Category

#### Format
**Type:** String
**Default:** `@(Quantity)x @(Length:RL0) x @(Width:RL0)`
**Category:** Display

Display format string for the combination description, supporting variable substitution.

**Available Variables:**
The script auto-populates these variables from cell dimensions:

| Variable | Description | Type | Source |
|----------|-------------|------|--------|
| `@(Quantity)` | Number of cells | Integer | `tslCells.length()` |
| `@(Length)` | Total combination length | Double | Σ(cell widths + offsets) |
| `@(Width)` | Maximum cell width | Double | Max perpendicular dimension |
| `@(Depth)` | Maximum cell depth | Double | Max depth from all cells |
| `@(Elevation)` | Actual elevation value | Double | `dThisElevation` (course-adjusted for log walls) |

**Format Syntax:**
- `@(VarName)` - Default format
- `@(VarName:RL0)` - Round to integer
- `@(VarName:RL2)` - Round to 2 decimal places

**Example Formats:**
```
"@(Quantity)x @(Length:RL0) x @(Width:RL0)"  →  "4x 600 x 80"
"Outlets: @(Quantity) @ @(Elevation:RL0)mm"  →  "Outlets: 3 @ 1200mm"
"@(Length:RL0)×@(Width:RL0)×@(Depth:RL0)"    →  "450×100×50"
```

**Usage:**
This string is used by:
- Block attribute filling
- Report generation
- BOM (Bill of Materials) export
- Layout annotations

**Entity Format Access:**
```c
Entity entFormat = _ThisInst;
String sVariables[] = entFormat.formatObjectVariables();
```

---

## Context Menu Commands

Right-click a placed combination to access these commands:

### Root-Level Commands

#### Flip Face
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Switches the installation to the opposite face of the element

**Effect:**
- Changes `Face` property (Reference Side ↔ Opposite Side)
- Recalculates all child cells with new face orientation
- Moves plan view grip point to opposite side
- Updates visual color (Green ↔ Cyan)

**Alternative Method:** Double-click the combination

**Coordinate Impact:**
```c
// Before: nFace = 1 (Reference Side)
vecFace = vecZ;
// After: nFace = -1 (Opposite Side)
vecFace = -vecZ;
```

---

#### Show/Hide Tools
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select combination|"))) TSLCONTENT
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Toggles visibility of CNC tooling geometry (Mortises, Drills, Cuts)

**Behavior:**
- Command text changes dynamically: "Hide Tools" when visible, "Show Tools" when hidden
- Calls `_ThisInst.setShowElementTools(bShowElementTool)`
- State stored in `_Map.setInt("ShowElementTool", value)`

**When to Use:**
- Hide tools: Clean view for layout review, dimensioning, or rendering
- Show tools: Verify CNC operations, check tool depth, inspect clearances

---

#### Save as rule
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save as rule|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Saves the current combination configuration as a reusable rule

**Dialog:**
Prompts for:
- **Name**: Rule name (e.g., "Kitchen Outlet 1200mm")

**What Gets Saved:**
```xml
<lst nm="Rule[]">
  <lst nm="RuleName">
    <lst nm="Cell[]">
      <lst nm="Cell">
        <str nm="scriptName" vl="instaCell"/>
        <lst nm="Properties">
          <lst nm="PropDouble[]">
            <dbl nm="Diameter" ut="L" vl="80"/>
            <dbl nm="Depth" ut="L" vl="50"/>
            ...
          </lst>
        </lst>
      </lst>
      ...
    </lst>
  </lst>
</lst>
```

**Storage:**
- Saved to `instaCombination.xml` in company settings folder
- Persisted via MapObject to drawing database
- Available in all future drawings

**Rule Contents:**
- Complete cell list with script names
- All cell properties (PropDouble, PropInt, PropString values)
- Cell sequence and spacing

**After Saving:**
The rule name appears in the `Rule` dropdown for future insertions.

---

#### Delete rule
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete rule|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Removes a saved rule from settings

**Dialog:**
Prompts for:
- **Name**: Select rule to delete from dropdown

**Effect:**
- Removes the rule from `mapRules` collection
- Updates `instaCombination.xml` settings file
- Does NOT affect existing combinations created from that rule

**Use Case:**
Clean up obsolete or test rules.

---

### Settings Submenu

#### Specify vertical cell offset
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Specify vertical cell offset|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Configure automatic elevation offset for tall vertical combinations

**Dialog Parameters:**
- **Cell Offset**: Number of cells to skip from bottom (default 0 = disabled)
- **Required cells**: Minimum cells before offset applies (default 5)

**Purpose:**
For vertical outlet/switch stacks, automatically offset the combination upward to keep installations within comfortable reach (1200-1800mm zone).

**Example:**
```
Vertical combination: 8 outlets, each 150mm tall
Without offset: Bottom outlet at floor level (0mm)
With offset (Cell Offset = 2, Required = 5):
  → Skip 2 cells (300mm)
  → Bottom outlet now at 300mm above floor
```

**Logic:**
```c
if (nDirection == 1 && nPosition == 0 && tslCells.length() >= nNumRequiredCellOffset) {
    for (int i = 0; i < nNumVerticalCellOffset; i++) {
        ptRef -= vecDir × 0.5 × (dDirCells[i] + dDirCells[i+1]);
    }
}
```

**Storage:**
Settings saved to `instaCombination.xml` → `Combination\Placement\VerticalOffset`

---

#### Plan view settings
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Plan view settings|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Configure appearance settings for plan view (top-down) display

**Dialog Parameters:**

**Text Category:**
- **Text Height**: Text size for elevation labels (0 = use dimstyle default)
- **Dimstyle**: Dimension style for annotation
- **Color**: Text color (ACI color index, 7 = white/black)

**Symbols Category:**
- **Scalefactor**: Symbol scale relative to text height (default 1.0)
- **Color**: Symbol color (0 = byBlock)

**Display Behavior:**
Plan view shows:
- Yellow circle at insertion point (size = `dViewHeight / 150`)
- Yellow line from insertion to element contour
- Elevation text: `"|Elevation| " + dElevation`
- Grip point for perpendicular repositioning

**Storage:**
Settings saved to `instaCombination.xml` → `Combination\Planview`

**When Applied:**
```c
dpPlan.addViewDirection(vecY);  // Y-up view (plan)
dpPlan.addViewDirection(-vecY); // Y-down view (plan)
```

---

#### Element view settings
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Element view settings|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Configure appearance settings for element view (elevation/section) display

**Dialog Parameters:**

**Text Category:**
- **Text Height**: Text size for dimension text (0 = use dimstyle)
- **Dimstyle**: Dimension style
- **Color**: Text color (ACI index)

**Symbols Category:**
- **Scalefactor**: Symbol scale factor
- **Color Icon**: Symbol color for reference side (0 = byBlock)
- **Color Opposite**: Symbol color for opposite side (0 = byBlock)
- **Offset**: Perpendicular offset for block symbols (currently hidden/not implemented)

**Display Behavior:**
Element view shows:
- Filled planeprofile of tooling shape (Green for reference, Cyan for opposite)
- Dimension showing elevation from element bottom
- Conduit paths (if any)
- Cell symbols with view-direction filtering

**Storage:**
Settings saved to `instaCombination.xml` → `Combination\Elementview`

**When Applied:**
```c
dpElement.addViewDirection(vecZ);   // Front view
dpElement.addViewDirection(-vecZ);  // Back view
dpElement.showInDxa(true);          // Show in DXA output
```

---

#### Log Wall Settings
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Log Wall Settings|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Toggle elevation mode for log wall installations

**Dialog Parameter:**
- **Elevation from course number**: Yes/No

**Modes:**

**Course Number Mode (Yes):**
- `Elevation` property represents log course number (1, 2, 3...)
- Script calculates actual height: `dHeightFromCourseNr(n) + 0.5 × course_height`
- Dragging `_Pt0` snaps to nearest course centerline
- Ideal for log construction workflow

**Absolute Elevation Mode (No):**
- `Elevation` property represents exact distance from element origin
- Standard behavior for stick-frame, CLT, SIP
- Free positioning

**Auto-Detection:**
When an `ElementLog` is detected, course mode is enabled by default.

**Calculation Example:**
```c
// Log wall with first log = 200mm, visible logs = 150mm
// Course mode, Elevation = 3 (third course)
int nCourseNr = 3 - 1; // zero-based = 2
dThisElevation = elLog.dHeightFromCourseNr(2) + 0.5 × 150mm;
// Result: height of courses 1+2 + half of course 3 height
```

**Storage:**
Settings saved to `instaCombination.xml` → `Combination\LogWall\IsCourseElevation`

---

#### Show all Commands for UI Creation
```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show all Commands for UI Creation|") (_TM "|Select combination|"))) TSLCONTENT
```

**Function:** Displays complete list of command strings for creating toolbar buttons or ribbon commands

**Output Format:**
Opens a report dialog showing formatted command strings:

```
Command to insert a new instance of the tool:
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCombination")) TSLCONTENT

Command to flip the face of the tool:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select combination|"))) TSLCONTENT

[... all commands listed ...]
```

**Use Case:**
- Creating custom toolbar buttons
- Building ribbon interface definitions
- Generating keyboard shortcuts
- Documenting command syntax

---

## Usage Examples

### Example 1: Standard Outlet Installation (Stick-Frame Wall)

**Scenario:** Place a single electrical outlet at 400mm height on a stick-frame wall

**Steps:**
1. Run `instaCombination`
2. Dialog: Accept all defaults (Rule = Default, Elevation = 0, Face = Reference Side)
3. Select the wall element
4. In command line, type `Elevation` → Enter `400`
5. Click insertion point on wall
6. Result: Single instaCell created at 400mm height, facing reference side

**What Gets Created:**
- 1 `instaCombination` instance at insertion point
- 1 `instaCell` child (default catalog entry)
- 1 Mortise tool (if cell has tooling enabled)

---

### Example 2: Vertical Switch Stack with Rule (Log Wall)

**Scenario:** Create a 4-switch vertical stack at log course 5 and save as rule

**Steps:**
1. Run `instaCombination`
2. Dialog:
   - Rule = `<Default>`
   - Elevation = `5` (course number)
   - Direction = `Vertical`
   - Position = `Middle Cell`
   - Face = `Reference Side`
3. Select log wall element
4. Click insertion point (script auto-calculates course 5 centerline)
5. Manually add 3 more `instaCell` instances via context menu or editing
6. Configure each cell (diameter, depth, offset)
7. Right-click combination → "Save as rule" → Enter name "4x Switch Stack"
8. Future insertions: Select "4x Switch Stack" from Rule dropdown

**What Gets Saved in Rule:**
```xml
<lst nm="4x Switch Stack">
  <lst nm="Cell[]">
    <lst nm="Cell">
      <str nm="scriptName" vl="instaCell"/>
      <lst nm="Properties">
        <lst nm="PropDouble[]">
          <dbl nm="0" ut="L" vl="80"/>  <!-- Diameter -->
          <dbl nm="1" ut="L" vl="50"/>  <!-- Depth -->
          ...
        </lst>
      </lst>
    </lst>
    <!-- 3 more cells -->
  </lst>
</lst>
```

---

### Example 3: Horizontal Outlet Row with Conduits (SIP Panel)

**Scenario:** Place 3 outlets in a horizontal row with conduit routing between them and to bottom edge

**Steps:**
1. Run `instaCombination`
2. Dialog:
   - Rule = Custom rule "3x Outlet Row" (pre-created)
   - Elevation = `1200`
   - Direction = `Horizontal`
   - Position = `First Cell`
   - Tooling = `byCell with Mill` (adds connection pockets)
   - Catalog = `PVC 20mm`
   - Alignment = `Bottom`
3. Select SIP panel
4. Click insertion point
5. Result:
   - 3 cells in horizontal row
   - 2 `instaConduit` instances connecting cells (auto-created from rule if defined, or manually added)
   - 1 `instaConduit` running from leftmost cell to bottom panel edge

**Tooling Generated:**
- 3 Mortises (one per cell)
- 2 milling pockets (30mm × 30mm) between cells for conduit channels
- All tools added to SIP panel's genbeam

---

### Example 4: Multi-Storey Installation (Parallel Walls)

**Scenario:** Place identical outlet at same location on 5 parallel walls (multi-storey building)

**Steps:**
1. Run `instaCombination`
2. Dialog: Configure outlet properties (Elevation = 300, Rule = "Standard Outlet")
3. Select **all 5 wall elements** (Shift+Click or window selection)
4. Click insertion point on first wall
5. Script validates:
   - All walls are parallel (same vecX orientation)
   - Insertion point falls within each wall's contour
   - Skips any non-parallel walls with warning message
6. Result: 5 combinations created, one on each wall at identical X-Y position

**Validation Messages:**
```
Element 3 is not parallel to reference element and will be skipped.
Location is outside of element 4 and will be skipped.
```

---

### Example 5: Linking Combinations with Automatic Conduits

**Scenario:** Connect 3 existing combinations with conduit routing

**Steps:**
1. Run `instaCombination`
2. Dialog:
   - Catalog = `Flexible 25mm`
   - Other settings as needed
3. Prompt changes to: "Select element or combinations to connect"
4. Select existing combination A
5. Select existing combination B
6. Select existing combination C
7. Click insertion point for new combination D
8. Result:
   - New combination D created
   - 3 `instaConduit` instances auto-created: A→D, B→D, C→D
   - Routing uses orthogonal paths (horizontal-then-vertical or vice versa)

**Routing Algorithm:**
```c
// Find closest node in target combination
for each node in combination B:
    if (node.vecNormal points toward combination A) {
        create polyline: pt1 → pt_corner → pt2
    }
```

**Visual During Jig:**
Green filled conduit paths preview the routing before placement.

---

## Settings Files

### File Location

**Primary Location (Company Path):**
```
_kPathHsbCompany\TSL\Settings\instaCombination.xml
```

**Fallback Location (Installation Path):**
```
_kPathHsbInstall\Content\General\TSL\Settings\instaCombination.xml
```

### File Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>

  <lst nm="Rule[]">
    <lst nm="Kitchen Outlet">
      <lst nm="Cell[]">
        <lst nm="Cell">
          <str nm="scriptName" vl="instaCell"/>
          <lst nm="Properties">
            <lst nm="PropDouble[]">
              <dbl nm="0" ut="L" vl="80.0"/>  <!-- Diameter -->
              <dbl nm="1" ut="L" vl="50.0"/>  <!-- Depth -->
              <dbl nm="2" ut="L" vl="0.0"/>   <!-- Angle -->
              <dbl nm="3" ut="L" vl="20.0"/>  <!-- Offset -->
              <dbl nm="4" ut="L" vl="100.0"/> <!-- Height -->
            </lst>
            <lst nm="PropString[]">
              <str nm="1" vl="Mortise"/>      <!-- Tool type -->
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>

  <lst nm="Combination">
    <lst nm="ConnectionPocket">
      <dbl nm="Width" ut="L" vl="30.0"/>
      <dbl nm="Depth" ut="L" vl="30.0"/>
    </lst>

    <lst nm="Placement">
      <lst nm="VerticalOffset">
        <int nm="CellOffset" vl="2"/>
        <int nm="NumRequired" vl="5"/>
      </lst>
    </lst>

    <lst nm="Planview">
      <int nm="Color" vl="252"/>
      <str nm="DimStyle" vl="Standard"/>
      <dbl nm="TextHeight" ut="L" vl="60.0"/>
      <dbl nm="Scale" vl="1.0"/>
      <int nm="ColorSymbol" vl="0"/>
    </lst>

    <lst nm="Elementview">
      <int nm="Color" vl="7"/>
      <str nm="DimStyle" vl="Standard"/>
      <dbl nm="TextHeight" ut="L" vl="60.0"/>
      <dbl nm="Scale" vl="1.0"/>
      <int nm="ColorSymbol" vl="0"/>
      <int nm="ColorOpposite" vl="0"/>
    </lst>

    <lst nm="LogWall">
      <int nm="IsCourseElevation" vl="1"/>
    </lst>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Version Validation

On script creation (`_bOnDbCreated`), the script compares versions:

```c
int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");

if (nVersion != nVersionInstall) {
    reportNotice("A different Version of the settings has been found for instaCombination\n"
        + "Current Version " + nVersion + " at " + _kPathDwg + "\n"
        + "Other Version " + nVersionInstall + " at " + sFile);
}
```

**What to Do:**
- Review both XML files
- Merge custom rules if needed
- Update company XML to match installation version

---

## Technical Details

### Script Lifecycle

**1. Initialization (_bOnInsert)**
```c
// Dialog selection
showDialog();

// Element selection
PrEntity ssE("Select element or combinations to connect", ElementWall());

// Jig with preview
nGoJig = ssP.goJig(kJigAction, mapArgs);

// Child creation
tslNew.dbCreate("instaCell", vecDir, vecPerp, ...);
```

**2. First Calculation (_bOnDbCreated)**
```c
// Create default cell or cells from rule
if (mapRule.length() < 1) {
    // Single default cell
    tslNew.dbCreate("instaCell", ...);
} else {
    // Multiple cells from rule
    for each cell in mapRule:
        tslNew.dbCreate(scriptName, ...);
}
```

**3. Recalculation (Property Change, Grip Drag)**
```c
// Update cells
for each cell:
    cell.transformBy(vecMove);

// Update tooling
if (bByCombination) {
    Mortise ms(ptMid, vecDir, vecPerp, -vecFace, dLength, dWidth, dDepth);
    el.addTool(ms);
}

// Update conduits (automatic via dependency)
```

---

### Coordinate System

**Element CS:**
```c
ptOrg = el.ptOrg();          // Element origin (usually bottom-left)
vecX = el.vecX();            // Longitudinal axis
vecY = el.vecY();            // Height axis
vecZ = el.vecZ();            // Thickness axis (face normal)
```

**Tool CS:**
```c
vecFace = nFace × vecZ;                    // ±Z depending on face
vecDir = (nDirection == 0) ? vecX : vecY;  // Cell arrangement axis
vecPerp = vecDir.crossProduct(-vecFace);   // Perpendicular axis
CoordSys cs(_Pt0, vecDir, vecPerp, vecFace);
```

**Special Cases:**
- **Flattened XY (SIP panels laid flat):** `vecDir = _XW`
- **3D Wall (vertical panels):** `vecDir = _ZW.crossProduct(vecZ)`
- **Vertical Direction:** `vecDir = vecDir.crossProduct(vecZ)`

---

### Child Script Communication

**Parent → Cell (Map):**
```c
Map mapTsl;
mapTsl.setVector3d("vecFace", vecFace);
tslNew.dbCreate("instaCell", vecDir, vecPerp, genbeams, entities, points,
    catalog, forceModelSpace, mapTsl, executeKey, "OnDbCreated");
```

**Cell → Parent (Map Persistence):**
```c
_Map.setEntityArray(cells, false, "Cell[]", "", "Cell");
Entity cells[] = _Map.getEntityArray("Cell[]", "", "Cell");
```

**Conduit → Cell (Map):**
```c
mapTsl.setInt("nodeIndexA", index1);
mapTsl.setEntity("cell1", cellA);
mapTsl.setVector3d("vecN1", vecNormal1);
mapTsl.setPoint3d("pt", pt1);
```

---

### Node System (Conduit Anchoring)

**Cell Nodes:**
Each `instaCell` publishes snap nodes in its map:
```c
Map mapNodes = _Map.getMap("Node[]");
for each node:
    node.getPoint3d("pt");           // Node location
    node.getVector3d("vecNormal");   // Normal direction (outward)
    node.getInt("nodeIndex");        // Node ID
    node.getEntity("Cell");          // Parent cell
```

**Combination Nodes:**
The combination itself can publish nodes (when anchor mode = "Combination"):
```c
Map mapCombinationNodes = _ThisInst.subMapX(kInstaCombination);
Map mapSnaps = mapCombinationNodes.getMap(kSnaps);
```

**Conduit Routing:**
```c
// Find best matching nodes
for each node in source:
    if (node.vecNormal points toward target) {
        score = distance + angle_penalty;
        if (score < best_score) {
            best_node = node;
        }
    }
```

---

### Grip Point Behavior

**_Pt0 (Main Grip):**
- Vertical dragging: Updates `Elevation` property
- For log walls in course mode: Snaps to nearest course centerline
- Triggers recalculation of all cells

**_PtG[0] (Plan View Grip):**
- Visible only in plan view (Y-axis view)
- Allows perpendicular repositioning of plan symbol
- Stored as offset: `_Map.setDouble("ZOffsetPlan", offset)`
- Survives face flip operation

**Grip Persistence:**
```c
// Save grip offset relative to _Pt0
if (!_Map.hasVector3d("grip" + i)) continue;
_PtG[i] = _PtW + _Map.getVector3d("grip" + i);
```

---

### Tooling Generation Details

#### byCell Mode
Each cell creates its own tool:
```c
// In instaCell script
Mortise ms(ptCell, vecX, vecY, vecZ, dWidth, dHeight, dDepth);
_Beam0.addTool(ms);
```

#### byCell with Mill Mode
Adds connection pockets between cells:
```c
for (int i = 0; i < tslCells.length() - 1; i++) {
    Point3d pt = (ptLocs[i] + ptLocs[i+1]) × 0.5;
    Mortise ms(pt, vecDir, vecPerp, -vecFace,
        dL, dWidthConnection, dDepthConnection, 0, 0, 1);
    el.addTool(ms);
}
```

#### byCombination Mode
Single large mortise:
```c
Point3d ptMid = ptRef + vecDir × 0.5 × (dLength - dLengthFirst);
Mortise ms(ptMid, vecDir, vecPerp, -vecFace, dLength, dWidth, dDepth, 0, 0, 1);
if (abs(dRadius) > 0) {
    ms.setRadius(dRadius);
}
el.addTool(ms);
```

#### Sawline/Milling Mode (Element Tools)
```c
// Create nailing as element tool container
Nailing nn(ptMid, vecDir, vecPerp);
nn.setToolIndex(nToolIndex);
nn.addPlaneProfile(ppTool, -vecFace, _kToolSaw);  // or _kToolMill
el.addTool(nn);
```

---

### Display Logic

**View Detection:**
```c
Vector3d vecZView = getViewDirection();
int bIsPlan = vecZView.isParallelTo(vecY);
```

**Plan View Display:**
- Circle at insertion point: `dViewHeight / 150` radius
- Yellow line: insertion to contour
- Elevation text with dimension
- Grip point for symbol repositioning

**Element View Display:**
- Filled planeprofile (tool shape)
- Color: Green (reference side), Cyan (opposite side)
- Elevation dimension from element bottom
- Conduit paths

**Display Filtering:**
```c
dpElement.addViewDirection(vecZ);   // Show in front view
dpElement.addViewDirection(-vecZ);  // Show in back view
dpElement.addHideDirection(vecY);   // Hide in plan view

dpPlan.addViewDirection(vecY);      // Show in plan view
dpPlan.addViewDirection(-vecY);
```

---

## Tips and Best Practices

### 1. Rule Management

**Create Rules After Manual Configuration:**
- Place a combination
- Add/remove cells to match your needs
- Adjust all cell properties (diameter, depth, tool type, offset)
- Right-click → "Save as rule" → Name it descriptively

**Rule Naming Convention:**
```
Good: "Kitchen Outlet 300mm", "4x Switch Vertical", "Bathroom GFI"
Bad: "Rule1", "Test", "MyRule"
```

**Rule Reuse:**
Rules are drawing-independent and persist in company settings. Create once, use everywhere.

---

### 2. Elevation Strategies

**Stick-Frame Walls:**
- Use absolute elevation values
- Standard outlet: 300-400mm above floor
- Standard switch: 1100-1200mm above floor
- Kitchen counter outlet: 1000-1100mm (300mm above counter)

**Log Walls:**
- Enable "Elevation from course number" in Log Wall Settings
- Specify course number (1, 2, 3...) instead of mm
- Script auto-calculates centerline of each course
- Dragging snaps to nearest course

**Multi-Storey:**
- Use consistent elevation across all floors
- Let script handle individual wall origins
- Check for parallel walls before insertion

---

### 3. Conduit Planning

**Manual Routing:**
- Place combinations first without conduit catalog
- Add `instaConduit` instances later for precise routing

**Automatic Routing:**
- Select conduit catalog during insertion
- Select existing combinations to link
- Preview conduit paths during jig (green fill)
- Edge conduits: Use `Alignment` parameter for automatic bottom/top connections

**Anchor Mode:**
- Cells: Conduits attach to individual cell nodes (flexible, precise)
- Combination: Conduits attach to combination center (simplified, cleaner for large arrays)

---

### 4. Tooling Optimization

**For CNC Efficiency:**
- Use `byCombination` for uniform arrays (faster machining)
- Use `byCell` for mixed cell types (precise fits)
- Add `byCell with Mill` for recessed conduit channels

**For Panel Edges:**
- Use `Sawline` mode for through-cuts (panel edges, large openings)
- Set `Tool Index` low (1-2) to execute before other operations

**Radius Selection:**
- 0mm: Sharp corners (square drill bits, router)
- 3-5mm: Standard radius for most installations
- 10mm+: Large radius for structural pockets, reduced stress

---

### 5. View Display Customization

**Plan View:**
- Use high-contrast color (yellow/darkyellow by default)
- Set text height relative to scale: Large drawings = larger text
- Enable grip point for symbol repositioning perpendicular to element

**Element View:**
- Use color coding: Green = reference, Cyan = opposite
- Match dimstyle to project standard
- Hide tools (`Show/Hide Tools`) for clean layout views

**DXA Output:**
- Combinations automatically show in DXA extraction
- Use `Format` string to control BOM descriptions
- `showInDxa(true)` is enabled by default

---

### 6. Common Workflows

**Workflow A: Quick Single Outlet**
1. Run script → Accept defaults → Select wall → Click point → Done
2. Time: 10 seconds

**Workflow B: Repetitive Installation from Rule**
1. Run script → Select rule → Select elevation/face → Insert multiple times
2. Time: 5 seconds per instance (after rule creation)

**Workflow C: Complex Multi-Room Layout**
1. Create rules for each outlet type (standard, GFI, switch, etc.)
2. Insert combinations room-by-room using appropriate rules
3. Add conduits manually or via linking during insertion
4. Verify tooling visibility
5. Export to CNC

**Workflow D: Multi-Storey Building**
1. Configure one combination perfectly on ground floor
2. Save as rule
3. Use multi-storey insertion to place on all parallel walls at once
4. Check for skipped walls (non-parallel or out-of-contour)

---

### 7. Troubleshooting

**Issue: Combination not visible**
- Check view direction (plan vs element view)
- Verify layer assignment (Zone 0 = Z-Layer as of v3.8)
- Check if element is valid

**Issue: Cells not positioning correctly**
- Verify `Direction` setting (Horizontal vs Vertical)
- Check `Position` setting (First/Middle/Last)
- Ensure cells are valid (no deleted/corrupted children)

**Issue: Conduits not created**
- Verify conduit catalog is selected (not `<Disabled>`)
- Check that linking combinations are on same element
- Ensure cell nodes are valid

**Issue: Tools not appearing in CNC**
- Check `Show/Hide Tools` state
- Verify tooling mode is not `Disabled`
- For element tools: Confirm element type supports it (stick-frame/roof)

**Issue: Multi-storey skipping walls**
- Check message: "is not parallel to reference element"
  → Fix: Rotate wall to match reference X-axis
- Check message: "Location is outside of element"
  → Fix: Move insertion point within wall contour

**Issue: Log wall elevation incorrect**
- Verify "Elevation from course number" setting
- Check course number value (1-based, not 0-based)
- Ensure `ElementLog` is valid

---

## Related Scripts

### Parent-Child Relationships

**instaCombination** (this script)
- **Creates:** `instaCell` (one or more)
- **Creates:** `instaConduit` (optional, for routing)
- **Attached to:** Element (ElementWall, ElementRoof, etc.) or GenBeam

### Sibling Scripts

**instaCell**
- Individual installation cell (outlet box, junction box, switch)
- Properties: Diameter, Depth, Angle, Offset, Height, Tool Type
- Creates: Drill, Mortise, or Beamcut tool
- Publishes: Node array for conduit anchoring

**instaConduit**
- Routing conduit connecting cells or running to edges
- Properties: Width, Routing type, Anchor mode
- Reads: Cell nodes, combination nodes
- Creates: Drill or Mortise for conduit channel

---

## Version History

### Version 3.8 (January 17, 2024)
**HSB-20506** - Layer assignment on zone 0 = Z-Layer

### Version 3.7 (September 6, 2022)
**HSB-16090** - Centered anchoring of combination supported, new property to toggle available anchor nodes

### Version 3.6 (September 6, 2022)
**HSB-16089** - New command to list full syntax of available commands in report dialog, formatting dialog added

### Version 3.5 (August 3, 2022)
**HSB-16091** - Relevant face terminology unified

### Version 3.4 (August 1, 2022)
**HSB-16090** - Snap profiles published

### Version 3.3 (July 26, 2022)
**HSB-14204** - Minor changes in description and naming

### Version 3.2 (December 14, 2021)
**HSB-14015** - Supports multi storey element insertion, bugfix planview face detection

### Version 3.1 (December 13, 2021)
**HSB-14130** - Bugfix selection loose genbeams

### Version 3.0 (December 10, 2021)
**HSB-14083** - Supports conduit creation to edge on insert

### Version 2.9 (December 8, 2021)
**HSB-14084** - Conduit preview when linking combinations with conduits

### Version 2.8 (December 2, 2021)
**HSB-13202** - Block in dwg now updated when hardware is stored

### Version 2.7 (December 1, 2021)
**HSB-13729** - New property to select conduit catalog on insert to auto connect to selected combinations, supports export to share and make

### Version 2.6 (October 8, 2021)
**HSB-13446** - Bugfix duplicate on insert, planview jig enhanced, face flip does not alter node sequence

### Version 2.5 (September 29, 2021)
**HSB-13203** - Supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property

### Version 2.4 (September 16, 2021)
**HSB-13129** - Conduit supports rule based insertion

### Version 2.3 (July 20, 2021)
**HSB-12641** - Height of mortise and beamcut shapes support byCombination

### Version 2.2 (June 25, 2021)
**HSB-12284** - Supporting mortise or beamcut tools of cells

### Version 2.1 (June 18, 2021)
**HSB-12298** - Bugfix default insert

### Version 2.0 (March 29, 2021)
**HSB-11403** - Snapping improved

### Version 1.0 (February 17, 2021)
**HSB-10758** - Initial version

---

## FAQ

**Q: What's the difference between `byCell` and `byCombination` tooling?**
A: `byCell` creates individual tools for each cell (flexible, mixed types). `byCombination` creates one large tool covering all cells (faster machining, uniform arrays).

**Q: Can I change the rule after insertion?**
A: Rules only apply during insertion. After placement, you manually add/remove cells and adjust properties. Save the modified combination as a new rule if needed.

**Q: How do I switch the installation to the other wall face?**
A: Right-click → "Flip Face", or double-click the combination. The symbol changes from green to cyan (or vice versa).

**Q: Why do conduits not appear after linking combinations?**
A: Ensure the conduit catalog was selected during insertion. Conduits are only auto-created during the insertion phase, not afterward.

**Q: Can I use this on ceiling elements?**
A: Yes. The script supports `ElementRoof` (floor/ceiling structures). The coordinate system adapts automatically.

**Q: What happens to tools when I change tooling mode?**
A: The script recalculates and replaces all tools. Previous tools are removed.

**Q: How do I create a rule with conduits?**
A: Currently, rules store cell configurations but not conduits. You must add conduits manually after rule-based insertion, or select a conduit catalog to auto-create edge conduits.

**Q: Can I import/export rules between projects?**
A: Rules are stored in `instaCombination.xml`. Copy this file from company path to another project's company path to transfer rules.

---

## Command Reference

### Insertion Command
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCombination")) TSLCONTENT
```

### Silent Insertion (No Dialog, Use Catalog Entry)
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCombination" "ABC123")) TSLCONTENT
```
*(Replace "ABC123" with catalog entry name)*

### Context Commands
```
Flip Face:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select combination|"))) TSLCONTENT

Save as rule:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save as rule|") (_TM "|Select combination|"))) TSLCONTENT

Delete rule:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete rule|") (_TM "|Select combination|"))) TSLCONTENT

Hide Tools:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select combination|"))) TSLCONTENT

Show Tools:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select combination|"))) TSLCONTENT

Specify vertical cell offset:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Specify vertical cell offset|") (_TM "|Select combination|"))) TSLCONTENT

Plan view settings:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Plan view settings|") (_TM "|Select combination|"))) TSLCONTENT

Element view settings:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Element view settings|") (_TM "|Select combination|"))) TSLCONTENT

Log Wall Settings:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Log Wall Settings|") (_TM "|Select combination|"))) TSLCONTENT

Show all Commands:
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show all Commands for UI Creation|") (_TM "|Select combination|"))) TSLCONTENT
```

---

## Summary

The `instaCombination` script is a comprehensive MEP layout tool for timber construction, orchestrating the placement of electrical, plumbing, and mechanical installations across walls, floors, and roofs. Its rule-based workflow, automatic conduit routing, and flexible tooling options make it ideal for both quick single installations and complex multi-room layouts. The script's deep integration with log walls, multi-storey placement, and CNC tooling generation streamlines the workflow from design to fabrication.

**Key Strengths:**
- Rule-based reusability
- Automatic conduit linking
- Multi-storey batch placement
- Log wall course integration
- Flexible tooling modes (byCell, byCombination, Sawline, Milling)
- View-adaptive display (plan/element)

**Typical Users:**
- MEP designers
- Timber construction engineers
- CNC programmers
- Shop drawing technicians
