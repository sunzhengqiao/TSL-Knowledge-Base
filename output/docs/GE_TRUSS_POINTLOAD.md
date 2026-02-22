# GE_TRUSS_POINTLOAD

## Overview

GE_TRUSS_POINTLOAD is a structural framing automation tool designed for North American stick-frame construction that creates point load reinforcement assemblies at the bearing locations of roof trusses where they transfer loads to walls below. When a truss bears on top of a wall, concentrated loads require additional studs (posts) to properly carry that load down through one or more floor levels to the foundation. This script automates the entire process: identifying bearing points on trusses, locating walls underneath, removing interfering existing studs, inserting the correct number of reinforcement posts, creating inter-story transfer beams between stacked walls, and intelligently adjusting any blocking that conflicts with the new framing.

The script integrates directly with the hsbCAD Framing Defaults Editor inventory system, ensuring that every new post receives the correct lumber species, grade, material designation, and dimensional properties from the project's master lumber catalog. This maintains consistency across the entire project and eliminates manual property assignment errors.

**Script Architecture**: This is a parent-child cloning script. During insertion, it selects trusses and walls, then creates independent clones of itself—one per bearing reaction point found on the selected trusses. Each clone operates independently on its assigned bearing location with all geometric data stored in its Map. This architecture allows the script to handle multiple trusses with multiple bearing points in a single operation while keeping each bearing point's configuration independently adjustable.

**Version Note**: The current version (v2.2) has hardware connector insertion functionality (Simpson Strong-Tie twist straps HTS20/H2.5T, MSTA straps, hold-down anchors DTT2Z/HTT4) commented out but preserved in the code for future use. These features were based on uplift reaction values and heel height thresholds and may be re-enabled in future versions.

## Usage Environment

| Property | Value |
|---|---|
| Script Type | Object (O-Type) |
| Execution Context | Model Space |
| Beams Required | 0 (no pre-selection needed) |
| Implicit Insert | Yes (launches immediately upon command execution) |
| Version | 2.2 (May 2014) |
| Region | North America (stick-frame construction) |

This script operates in Model Space on 3D wall and truss entities. It requires that roof trusses have been placed on walls with properly defined bearing reactions. The walls should already be framed with standard stick-frame members (studs, top plates, bottom plates, blocking).

## Prerequisites

Before running GE_TRUSS_POINTLOAD, ensure the following conditions are met:

### 1. Roof Trusses with Bearing Reaction Markers

One or more TrussEntity objects must exist in the model. These trusses must contain **Alpine-BearingReaction** TSL instances within their definitions, which identify bearing points and provide uplift reaction values. Without these bearing reaction markers, the script cannot locate the load transfer points.

The Alpine-BearingReaction TSL provides:
- **Position**: The bearing point location in truss-local coordinates (transformed to world coordinates using the truss's CoordSys)
- **Uplift Value**: The maximum vertical uplift reaction at the bearing point (stored in Map as "MaxVerticalUplift")

### 2. Framed Walls Below Trusses

The walls that support the trusses must already be framed (studs, plates, blocking in place) and must be positioned directly beneath the truss bearing points. If the structure has multiple stories, all stacked walls from the truss down to the foundation should be available for selection.

**Wall Type**: The walls must be of type ElementWall. The script filters specifically for wall elements and will skip any non-wall elements during processing.

**Vertical Alignment**: For multi-story point load paths, all walls from the truss bearing point down to the foundation should be vertically aligned so the script can trace the load path correctly through each level.

### 3. Framing Defaults Editor Configured

The hsbCAD Framing Defaults Editor inventory must be properly set up with lumber items. The script reads lumber specifications from this inventory to populate the lumber selection dropdown and assign properties to newly created beams.

**DLL Integration**:
- **Path**: `[Installation Path]\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll`
- **Namespace**: `hsbSoft.FramingDefaults.Inventory.Interfaces`
- **Class**: `InventoryAccessInTSL`
- **Function**: `GetLumberItems`

**Inventory Properties**:

| Property Key | Description |
|---|---|
| `NAME` | Full lumber item name |
| `WIDTH` | Lumber thickness (narrow dimension) |
| `HEIGHT` | Lumber depth (wide dimension) |
| `SPECIES\NAME` | Wood species name (e.g., "SPF", "Douglas Fir") |
| `GRADE\NAME` | Lumber grade (e.g., "No.2", "Select Structural") |
| `TREATMENT\NAME` | Treatment type (e.g., "PT") or "None" |
| `HSB_MATERIAL` | hsbCAD material designation applied to beams |
| `HSB_GRADE` | hsbCAD grade designation applied to beams |

## Usage Steps

### Step 1: Launch the Script

Execute the GE_TRUSS_POINTLOAD command from the hsbCAD TSL menu or command line. The script starts immediately in insertion mode due to its Implicit Insert flag.

### Step 2: Select Trusses

**Command Line Prompt**: "Select truss(es)"

Click on one or more roof truss entities in the model. The selection filter is restricted to TrussEntity objects only, so you cannot accidentally select beams or other objects. Press Enter or right-click to confirm the selection.

**Multiple Trusses**: You can select multiple trusses in a single operation. The script processes each truss independently, finding all bearing points and creating separate clones for each one.

If no trusses are selected, the script cancels and exits automatically.

### Step 3: Select Walls

**Command Line Prompt**: "Select walls"

Click on all wall elements that the point load needs to pass through. This includes:
- The top-story wall directly under the truss
- Any intermediate-story walls in multi-story structures
- The bottom-story wall at foundation level

The selection filter accepts ElementWall objects only. Press Enter or right-click to confirm.

**Multi-Story Selection Tip**: Select all stacked walls from the top floor down to the foundation in a single operation. The script sorts them by height automatically (highest first) and processes them in order, ensuring correct load path continuity through every level.

If no walls are selected, the script cancels and exits automatically.

### Step 4: Configure Properties (Dialog)

After selection, a properties dialog appears (shown once per session with last-used values recalled via catalog key "_LastInserted"). Here you configure:

- **Lumber Item**: The lumber specification for new posts
- **New Beams Qty.**: Number of studs to create (dynamic or fixed)
- **Post Assembly Name**: Optional identifier for BOM filtering
- **Beam Color**: Display color for visual identification
- **Lateral Offset**: Left/right shift along wall axis
- **Create Studs Between Floors**: Enable/disable transfer beams

These parameters also appear in the Properties Panel for post-insertion adjustment. Configure them as needed and confirm.

### Step 5: Automatic Processing

The script then processes each selected truss automatically through the following stages:

#### Stage 1: Bearing Point Detection

Scans each truss definition for Alpine-BearingReaction TSL instances to find every bearing location. For each bearing point, it extracts:
- Position (in truss-local coordinates, transformed to world space)
- Uplift reaction value (from Map key "MaxVerticalUplift")

A search body is constructed at each bearing point extending from ground level up to the bearing location, with dimensions:
- **Width** (along support direction): 250mm / 10"
- **Depth** (perpendicular to support): Full truss depth
- **Height**: From ground to bearing point

Any selected wall element whose outline intersects this search body is considered to be directly under the truss at that bearing point.

#### Stage 2: Ply Count Detection

The script determines how many plies the truss girder has at the bearing point through geometric analysis:

1. Collects all beams in the truss definition and transforms them to world coordinates
2. Creates temporary beam copies (required because `dbCopy` does not work directly within the truss definition loop)
3. Identifies the first non-vertical beam and constructs a thin intersection body (12mm / 0.5" thick) aligned with that beam's plane
4. All beams that intersect this thin body are considered to be in the same ply and are removed from the working set
5. The process repeats with remaining beams until all plies are counted
6. All temporary beams are erased after counting is complete

This ply count is used for the dynamic "Number of plies in girder" beam quantity option.

#### Stage 3: Self-Cloning

For each bearing point that intersects a selected wall, the script creates a clone of itself using `TslInst.dbCreate("GE_TRUSS_POINTLOAD", ...)`. All necessary geometric data is passed through the Map parameter:

- **PTREF**: Reference point (bearing point location)
- **V_SUPPORTX**: Support direction vector (horizontal direction perpendicular to wall)
- **TRUSS_HEIGHT**: Truss depth
- **PT_HIGHEST_ON_TRUSS**: Highest vertex on truss (for determining wall face)
- **PTHEEL**: Heel height point
- **UPLIFT**: Uplift reaction value
- **Plies**: Number of plies in girder
- **VXELREF**, **VZELREF**: Wall reference vectors
- **ELREFBEAMHEIGHT**, **ELREFBEAMWIDTH**: Reference wall beam dimensions
- **FIRST_INSERTED**: Flag set to 1 to trigger processing on clone creation

The insertion instance then erases itself via `eraseInstance()`. Each clone independently processes its assigned bearing location when `_bOnElementConstructed` fires or on first creation.

#### Stage 4: Wall Sorting and Opening Detection

**Sorting**: Selected walls are sorted by their origin Z-coordinate (height) in descending order, so `elAll[0]` is the highest wall (directly under the truss) and `elAll[length-1]` is the lowest (typically at foundation level).

**Opening Detection**: The script scans walls from top to bottom looking for openings. For each wall:
- If no openings are found, the wall is added to the "to frame" list
- If openings exist, it checks whether any opening is directly below the bearing point (within the cleaning zone plus a safety margin)
- If an opening is found directly below the bearing point, the script stops processing at that wall and does not continue to lower levels
- Walls above the opening (that have no openings in the load path) are still framed with reinforcement posts

This logic prevents the script from creating posts that would conflict with door or window openings.

#### Stage 5: Stud Replacement

At each bearing location on each wall in the load path (walls with no openings below the bearing point), the clone:

**A. Define Cleaning Zone**

Constructs a rectangular body centered on the bearing point (adjusted by any lateral offset):
- **Width** (along wall X-axis): Number of new beams × lumber width
- **Height** (vertical, along Z): Full height from ground level to reference point
- **Depth** (through wall, along support direction): 250mm / 10"

**B. Erase Existing Studs**

All existing studs whose bodies intersect the cleaning zone are erased.

**C. Sheeting Joint Preservation**

**Critical Logic**: Before erasing each stud, the script checks if the stud is located at a sheeting joint (where two panels meet edge-to-edge). This check is only performed on the topmost wall (first in the sorted list).

For each stud to be erased:
1. Scan all sheets on the wall
2. Get the left and right extremes of each sheet along the wall's X-axis
3. Check if the stud's left or right edge coincides with a sheet edge
4. If yes, the stud is at a sheeting joint
5. If a sheeting joint stud is erased, **increment the number of new studs by 1** to maintain panel nailing support

This automatic compensation ensures sheeting panels never lose their edge nailing support.

**D. Create New Studs**

New studs are placed in an alternating left-right pattern centered on the bearing point:

- **Stud 0**: Center (offset by half the beam width if total count is even)
- **Stud 1**: Left of center by one beam width
- **Stud 2**: Right of center by two beam widths
- **Stud 3**: Further left by three beam widths
- **And so on...**

This alternating placement ensures the studs are always symmetrically distributed around the bearing point, regardless of whether the total count is odd or even.

**E. Stretch to Plates**

Each new stud is created as a copy of an existing stud from the wall, then:
1. Width (thickness) is set to the selected lumber item's WIDTH value
2. Position is transformed to the calculated location
3. Color is set from the Beam Color property
4. Material is set from the HSB_MATERIAL field of the selected lumber item
5. Grade is set from the HSB_GRADE field
6. Information is set from the Post Assembly Name field
7. Module is set to a unique identifier combining the parent TSL instance handle and the element index
8. The stud is stretched vertically to fit precisely between the nearest top plate (above) and bottom plate (below) using `filterBeamsHalfLineIntersectSort()` and `stretchStaticTo()`

**F. Lumber Width Validation**

The script searches the inventory for a matching lumber item where:
- Thickness (WIDTH) matches the selected lumber item
- Height (HEIGHT) matches the wall's beam width (stud depth)

**If a match is found**: Material and grade are applied from the inventory.

**If no matching height is found**:
- Material is set to "UNDEFINED"
- Grade is set from the inventory
- Beam dimensions are taken from the wall's native beam dimensions
- A warning message is added to a running report that will be displayed after processing completes

The warning message format:
```
Error on wall: [code]-[number]
    Width: [actual width] was not defined on inventory list for [selected item]. Set values:
    Grade: [grade from inventory]
    Material: UNDEFINED
    Width taken from wall.
```

This ensures you always know when the lumber inventory needs updating.

#### Stage 6: Transfer Beams (if enabled)

When "Create studs between floors" is set to "Yes" and the current wall is not the bottom-most wall, a transfer beam is created for each new stud:

**Transfer Beam Properties**:
- **Position**: Centered at the wall's origin Z-height (the interface between floors)
- **Initial Length**: 100mm / 4" (default)
- **Dynamic Stretching**: The beam is stretched to span from the current wall's bottom plates (above) to the lower wall's top plates (below) using:
  - `filterBeamsHalfLineIntersectSort(bmAllBottomPlatesForTransfers, ptCen, _ZW)` for top connection
  - `filterBeamsHalfLineIntersectSort(bmAllTopPlatesForTransfers, ptCen, -_ZW)` for bottom connection
  - `stretchDynamicTo()` to adjust length
- **Properties Inherited**: Material, grade, color, information, and name from the wall studs

These transfer beams ensure the point load path is continuous from the truss all the way down through multi-story construction.

**Collection for Plates**: All top and bottom plates from all selected walls are collected in advance (`bmAllTopPlatesForTransfers`, `bmAllBottomPlatesForTransfers`) to enable efficient stretching operations. This is noted as a "Heavy operation, but necessary" in the code comments.

#### Stage 7: Blocking Adjustment

Existing horizontal blocking that conflicts with the new posts is handled intelligently using five distinct cases:

**Search Zone**: A wider zone (cleaning zone width + two additional beam widths on each side) is used to catch blocking members that may need trimming or adjustment.

**Case Analysis**:

For each blocking beam that intersects the search zone, the script determines the geometric relationship and applies the appropriate fix:

**Case 1: Fully Contained**
- **Condition**: Blocking entirely within the clean area
- **Action**: Erased completely
- **Logic**: `bdBlocking.hasIntersection(bdClean)` and both ends inside clean zone

**Case 2: Spanning**
- **Condition**: Blocking extends past both sides of the clean area
- **Action**: Duplicated, then each copy is cut so one piece remains on each side
- **Logic**: Left end is left of clean zone AND right end is right of clean zone
- **Implementation**:
  1. Create a copy of the blocking beam (`bmBlocking.dbCopy()`)
  2. Cut the original from the right boundary of clean zone
  3. Cut the copy from the left boundary of clean zone
  4. Result: Two blocking pieces, one on each side

**Case 3: Left Overlap**
- **Condition**: Blocking overlaps the left side of the clean area
- **Action**: Cut from the right boundary
- **Logic**: Left end is left of clean zone, right end is inside clean zone

**Case 4: Right Overlap**
- **Condition**: Blocking overlaps the right side of the clean area
- **Action**: Cut from the left boundary
- **Logic**: Left end is inside clean zone, right end is right of clean zone

**Case 5: Adjacent**
- **Condition**: Blocking just outside the clean area (within one stud width)
- **Action**: Stretched to meet the nearest new post
- **Logic**: Distance from clean zone boundary is less than one beam width
- **Implementation**: `stretchStaticTo()` to extend to the new stud

**Case 6: Error State**
- **Condition**: None of the above cases apply (should not happen)
- **Action**: Blocking is colored red (color index 1) to flag for manual review
- **Purpose**: Visual warning that unexpected geometry was encountered

This comprehensive blocking handling ensures that the framing remains structurally sound and properly connected after point load insertion.

### Step 6: Verify Results

After processing completes, you will see:

**Visual Feedback**:
- A rectangular outline with a diagonal cross appears at each point load location in Model Space
- The outline dimensions are based on the number of created beams and the reference wall dimensions
- Debug visualization points show key geometry (if debug mode is active)

**Command Line Report**:
```
Point load, [TrussEntity]    Uplift: [value]    Heel height: [value]    Plies: [count]
```

One line per bearing point processed, showing:
- Uplift reaction value
- Heel height (vertical distance from top of top plate to truss bearing face)
- Number of plies detected in girder

**Warning Messages**:
If any lumber width from the selected inventory item does not match wall stud depths, a detailed warning notice is displayed listing:
- Affected wall codes and numbers
- Expected vs. actual beam widths
- What substitute values were used (Material set to "UNDEFINED", dimensions from wall)

**Dependencies Set**: The script calls `setDependencyOnEntity(el)` for all associated wall elements. When a wall is reconstructed (studs repositioned, openings changed, plates adjusted, etc.), the point load assembly automatically recalculates to accommodate the new framing layout.

## Properties Panel Parameters

When an instance of GE_TRUSS_POINTLOAD is selected in the drawing, the following parameters are visible in the AutoCAD Properties Palette (OPM). These can be adjusted post-insertion to reconfigure the assembly.

### Lumber Info (Section Header)

**Type**: Read-only label (PropString index 0)

A section header that groups the lumber-related properties below it. This header cannot be edited.

### Lumber Item

| Property | Detail |
|---|---|
| Display Name | Lumber Item |
| Type | Dropdown (PropString) |
| Index | 1 |
| Default | First item in inventory |
| Options | All unique lumber items from Framing Defaults Editor |

Selects the lumber specification for all newly created studs and transfer beams. The dropdown shows all available lumber items from the project's Framing Defaults Editor inventory.

**Display Format**: Each entry is displayed as:
```
[Thickness] x [Species] [Grade] [Treatment]
```

Examples:
- `1.5 x SPF No.2`
- `1.5 x Douglas Fir Select Structural PT`
- `1.5 x Hem-Fir No.1`

**Treatment Handling**: If the treatment is set to "None" in the inventory, it is omitted from the display.

**Duplicate Removal**: The dropdown removes duplicate entries (same species/grade/treatment across different heights) so each combination appears only once. This simplifies the user interface when the inventory contains the same lumber type in multiple depths.

**Width/Height Matching Logic**:

When the selected item is applied during recalculation:

1. **Width (Thickness)**: Always taken from the selected lumber item's WIDTH field
2. **Height (Depth)**: The script searches the inventory for entries matching the selected item where HEIGHT equals the wall's beam width
3. **If a match is found**: Material and grade are applied from the matching inventory entry
4. **If no match is found**:
   - Material is set to "UNDEFINED"
   - Grade is taken from any entry with matching WIDTH
   - Height is taken from the wall's native beam width
   - A warning message is generated and displayed

**Technical Note**: The dropdown is populated from `sLumberItemNamesNoThicknessDisplay[]`, which is a filtered version of the inventory that removes duplicates while preserving the original index mapping to `sLumberItemKeys[]` for property retrieval.

### New Beams Qty.

| Property | Detail |
|---|---|
| Display Name | New Beams Qty. |
| Type | Dropdown (PropString) |
| Index | 2 |
| Default | "Number of plies in girder" |
| Options | "Number of plies in girder", "Number of plies in girder +1", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 |

Specifies how many reinforcement studs to create at each bearing point.

**Dynamic Options** (Recommended):

- **"Number of plies in girder"**: Automatically matches the number of plies detected in the truss girder at the bearing point through geometric analysis. For example, if the truss has a 3-ply girder, three studs are created. This follows standard engineering practice where bearing capacity should match girder capacity.

- **"Number of plies in girder +1"**: Creates one more stud than the detected ply count, providing additional bearing capacity and safety margin. Use this when engineering calculations indicate extra capacity is needed or when local building codes require it.

**Fixed Options** (1 through 10):

Allows explicit manual control over the exact number of studs when project-specific requirements dictate a fixed count regardless of girder configuration.

**Sheeting Joint Compensation**: Note that the actual count may increase by one at runtime if the script detects that an erased stud was at a sheeting joint. This automatic compensation preserves panel nailing support and is applied on top of your selected value.

**Engineering Consideration**: Using too few studs can result in crushing failure of the wood under concentrated loads. Using too many can waste material and labor. The dynamic "Number of plies" options provide a rational default based on the truss design.

### Post Assembly Name

| Property | Detail |
|---|---|
| Display Name | Post Assembly Name |
| Type | Text input (PropString) |
| Index | 3 |
| Default | Empty string |

An optional string value that is assigned to the **Information** field of every newly created stud and transfer beam.

**Recommended Uses**:
- **BOM Filtering**: Tag assemblies with identifiers (e.g., "PL-A1", "PL-B2") to filter and total point loads separately in material lists
- **Shop Drawings**: Include meaningful labels (e.g., "Girder Bearing", "Main Truss Support") that appear on fabrication drawings
- **Scheduling**: Use consistent naming conventions across the project to track and schedule point load assemblies
- **Quality Control**: Identify specific assemblies during framing inspection

**Naming Convention Tip**: Use a consistent format across your project, such as:
- `PL-[Grid]-[Floor]` (e.g., "PL-A1-2F" for point load at grid A1, second floor)
- `TRUSS-[Number]-BEAR-[Location]` (e.g., "TRUSS-05-BEAR-LEFT")

The value is stored in the beam's Information property and can be queried using standard hsbCAD BOM and reporting tools.

### Beam Color

| Property | Detail |
|---|---|
| Display Name | Beam color |
| Type | Dropdown (PropString) |
| Index | 4 |
| Default | Blue (index 5 in the dropdown) |
| Options | Default brown (32), Light brown (40), White (0), Red (1), Yellow (2), Green (3), Cyan (4), Blue (5), Magenta (6) |

Sets the display color for all newly created studs and transfer beams. Each option shows the color name followed by its AutoCAD color index number in parentheses.

**Color Index Mapping**:
- **Default brown**: 32 (standard stud color in many templates)
- **Light brown**: 40
- **White**: 0
- **Red**: 1
- **Yellow**: 2
- **Green**: 3
- **Cyan**: 4
- **Blue**: 5 (default)
- **Magenta**: 6

**Visual Identification Strategy**: Using a distinctive color (such as Blue or Magenta) that differs from your standard stud color (typically brown) makes point load reinforcement beams easy to distinguish visually from regular wall studs in:
- Plan views
- Elevations
- 3D views
- Section cuts
- Shop drawings

This color-coding helps framers, inspectors, and engineers quickly identify critical load-bearing members during construction and review.

**ByLayer Option**: The display representation uses color index -1 (ByLayer) for the outline graphics, but individual beams are assigned the selected color directly.

### Extra Features (Section Header)

**Type**: Read-only label (PropString index 5)

A section header that groups additional feature settings below it. This header cannot be edited.

### Lateral Offset

| Property | Detail |
|---|---|
| Display Name | Lateral offset |
| Type | Double (PropDouble) |
| Index | 0 |
| Default | 0 |
| Unit | Current drawing units (mm or inches) |
| Tooltip | "To right or left side of WALL. Can be positive or negative value" |

Shifts the entire point load reinforcement assembly left or right along the wall's length axis (X-axis) relative to the detected bearing point.

**Direction Convention**:
- **Positive value**: Moves assembly in the positive X direction of the wall coordinate system
- **Negative value**: Moves assembly in the negative X direction of the wall coordinate system

The wall's X-axis direction is determined by its origin and orientation. To predict the shift direction, you need to know your wall's coordinate system orientation (visible in wall properties or using coordinate system visualization tools).

**When to Use**:

1. **Opening Conflicts**: When the calculated bearing point would place posts too close to a nearby door or window opening
2. **Intersecting Walls**: When the bearing point is near a wall intersection and you need to shift the assembly to avoid the intersection zone
3. **Framing Coordination**: When coordinating with plumbing, electrical, or HVAC penetrations that require a specific location to remain clear
4. **Engineering Overrides**: When structural calculations indicate the load should be transferred at a specific offset from the geometric bearing point

**Caution**: Large offsets may cause the posts to miss the actual bearing point of the truss, which could be structurally incorrect. Use small offsets only when precise alignment adjustments are needed. Always verify that the offset assembly still provides adequate bearing support for the truss.

**Technical Implementation**: The offset is applied by modifying `_Pt0` during the calculation phase:
```c
_Pt0 = ptRef + vxElRef * dLateralOff;
```

Where `ptRef` is the detected bearing point and `vxElRef` is the wall's X-axis vector.

### Create Studs Between Floors

| Property | Detail |
|---|---|
| Display Name | Create studs between floors |
| Type | Dropdown (PropString) |
| Index | 6 |
| Default | "No" |
| Options | No, Yes |

Controls whether the script creates short transfer studs (also called transfer beams or transfer posts) that bridge the gap between stacked wall levels in multi-story construction.

**When set to "Yes"**:

For each new stud created in walls that are not the bottom-most wall:

1. A transfer beam is created with its center at the wall's origin Z-height (the floor level)
2. The transfer beam is initially created with a length of 100mm / 4"
3. The transfer beam is then dynamically stretched:
   - **Upward**: To the nearest bottom plate of the wall above (using `filterBeamsHalfLineIntersectSort()` with `_ZW` direction)
   - **Downward**: To the nearest top plate of the wall below (using `filterBeamsHalfLineIntersectSort()` with `-_ZW` direction)
4. The transfer beam receives identical properties as the wall studs:
   - Same material
   - Same grade
   - Same color
   - Same information tag
   - Same lumber width and depth

This creates a continuous vertical load path where point loads transfer from one wall through the floor system to the wall below.

**When set to "No"**:

Only the studs within each individual wall are created. The inter-floor gap is left unframed. This option is appropriate for:
- **Single-Story Construction**: When there are no stacked walls
- **Separate Transfer Framing**: When transfer framing is handled by a separate process or detail
- **Platform Framing with Blocking**: When the floor platform and blocking between walls provide adequate load transfer
- **Foundation Walls**: When the bottom wall sits directly on a concrete foundation with anchor bolts

**Structural Importance**: For multi-story structures, always enable "Create studs between floors" to ensure structural integrity. Without transfer beams, there will be a gap in the load path between floor levels that could result in:
- Concentrated loads not properly transferred to lower walls
- Excessive floor deflection or vibration
- Potential structural failure under design loads

**Platform Framing Detail**: The transfer beams span from the bottom plate of the upper wall to the top plate of the lower wall. This detail accommodates platform framing construction where each floor platform (joists and subfloor) sits on top of the walls below.

## Right-Click Menu

This script does not define any custom right-click context menu entries. All configuration is performed through the Properties Panel parameters described above.

To access the Properties Panel:
1. Select the GE_TRUSS_POINTLOAD instance in the drawing (click on the outline rectangle at the bearing point)
2. The AutoCAD Properties Palette (OPM) automatically displays the parameters
3. Modify any parameter
4. Press Enter or click outside the palette to trigger recalculation

## Settings and Data Persistence

### Framing Defaults Editor Integration

GE_TRUSS_POINTLOAD does not use standalone XML settings files. Instead, it reads lumber inventory data at runtime from the hsbCAD Framing Defaults Editor via a .NET DLL call.

**DLL Call Specification**:
- **Assembly Path**: `[Installation Path]\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll`
- **Namespace**: `hsbSoft.FramingDefaults.Inventory.Interfaces`
- **Class**: `InventoryAccessInTSL`
- **Method**: `GetLumberItems`

**Input Parameters** (Map):
- `CompanyPath`: `_kPathHsbCompany`
- `StickFramePath`: `_kPathHsbWallDetail`
- `InstallationPath`: `_kPathHsbInstall`

**Output** (Map):

Returns a hierarchical map structure containing all configured lumber items. Each lumber item is identified by a unique key (e.g., "0", "1", "2", etc.) and contains the following properties:

| Property Path | Type | Description | Example |
|---------------|------|-------------|---------|
| `[key]\NAME` | String | Full lumber item name | "SPF 2x4 Stud" |
| `[key]\WIDTH` | Double | Lumber thickness (narrow dimension) | 38.1 (mm) or 1.5 (inches) |
| `[key]\HEIGHT` | Double | Lumber depth (wide dimension) | 88.9 (mm) or 3.5 (inches) |
| `[key]\SPECIES\NAME` | String | Wood species name | "SPF", "Douglas Fir" |
| `[key]\GRADE\NAME` | String | Lumber grade | "No.2", "Select Structural" |
| `[key]\TREATMENT\NAME` | String | Treatment type or "None" | "PT", "None" |
| `[key]\HSB_MATERIAL` | String | hsbCAD material designation | "SPF" |
| `[key]\HSB_GRADE` | String | hsbCAD grade designation | "No.2" |

**Map Caching**: The output map is written to `c:\shared\tmp.dxx` for debugging purposes. This allows inspection of the inventory structure if issues arise.

### Catalog Persistence

The script uses hsbCAD's catalog system to remember the last-used property values between insertions within the same session:

- **Save**: `setCatalogFromPropValues("_LastInserted")` called at end of insertion phase
- **Restore**: `setPropValuesFromCatalog(_kExecuteKey)` called on `_bOnDbCreated`

**Catalog Key**: `"_LastInserted"`

When you insert the script again in the same session, it recalls your previous settings:
- Last selected lumber item
- Last selected beam quantity
- Last used post assembly name
- Last selected beam color
- Last lateral offset value
- Last transfer beam setting

This eliminates the need to reconfigure identical settings for multiple insertions.

**Session Scope**: The catalog persists for the current AutoCAD session only. When you close and reopen the drawing, the settings reset to defaults.

## Tips and Best Practices

### 1. Select All Stacked Walls

**Recommendation**: When working with multi-story buildings, select all walls from the top floor down to the foundation in a single operation.

**Reason**: The script sorts walls by height automatically (highest first) and processes them in order. Selecting all stacked walls ensures correct load path continuity through every level without requiring multiple script insertions.

**How to**: Use window selection or crossing selection to capture all vertically aligned walls in one pick operation.

### 2. Use Dynamic Beam Quantity

**Recommendation**: Use the "Number of plies in girder" option as the default for the New Beams Qty. parameter.

**Reason**: It automatically detects how many plies the truss has at the bearing location and creates a matching number of studs. This follows standard engineering practice where bearing capacity should match girder capacity and eliminates guesswork.

**Alternative**: Use "Number of plies in girder +1" when engineering analysis indicates additional capacity is required or when local building codes mandate extra bearing members.

### 3. Check Warning Messages

**Important**: Always read the command line and any dialog warnings after processing completes.

**Lumber Width Mismatch Warning**: If you see a message like:
```
Error on wall: W-101
    Width: 88.9 was not defined on inventory list for 1.5 x SPF No.2. Set values:
    Grade: No.2
    Material: UNDEFINED
    Width taken from wall.
```

**This means**: The selected lumber item does not have a HEIGHT entry that matches the wall's stud depth. The script still creates beams using the wall's native dimensions, but the material field shows "UNDEFINED".

**Resolution**:
1. Open the Framing Defaults Editor
2. Add a lumber item with the correct HEIGHT (e.g., 88.9mm or 3.5")
3. Re-select the correct lumber item in the Properties Panel
4. The script will recalculate with proper material assignment

### 4. Use Lateral Offset Sparingly

**Warning**: Large lateral offsets may cause the posts to miss the actual bearing point of the truss, which could be structurally incorrect.

**Best Practice**:
- Use offsets of less than 100mm (4") when possible
- Only use offsets when precise alignment adjustments are absolutely necessary to avoid conflicts
- Always verify in 3D view that the offset assembly still provides adequate bearing support for the truss

**Typical Use Case**: Shifting posts 25-50mm to avoid a nearby wall intersection or to align with modular framing grid.

### 5. Distinctive Colors for Identification

**Recommendation**: Set the beam color to something other than the default brown (such as Blue, Magenta, or Cyan).

**Benefits**:
- Makes point load reinforcement beams easy to distinguish from regular wall studs in all views
- Helps framers identify critical load-bearing members during construction
- Aids inspectors during building inspection
- Simplifies engineering review of structural elements

**Color Standards**: Consider establishing a project-wide color coding system:
- Blue = Point load reinforcements
- Magenta = Engineered posts/beams
- Cyan = Header assemblies
- Brown = Standard studs

### 6. Transfer Beams for Multi-Story

**Critical**: Always enable "Create studs between floors" for multi-story structures where the point load path must be continuous.

**Reason**: Without transfer beams, there will be a gap in the load path between floor levels. This gap means:
- Point loads cannot transfer from upper walls to lower walls
- Floor joists and subfloor must carry concentrated loads they're not designed for
- Potential for structural failure, especially under uplift conditions (wind, seismic)

**Single-Story Exception**: Only disable transfer beams when working with single-story construction where no stacked walls exist.

### 7. Blocking Is Handled Automatically

**Key Point**: You do not need to manually adjust blocking around the new posts. The script intelligently handles all five blocking scenarios:
- Erases blocking fully contained in the cleaning zone
- Splits blocking that spans across the cleaning zone
- Trims blocking that partially overlaps
- Stretches adjacent blocking to meet new studs
- Flags unexpected blocking in red for manual review

**Benefit**: Saves significant time and eliminates common framing errors where blocking interferes with point load posts.

### 8. Sheeting Joint Preservation

**Automatic Feature**: If an erased stud was located at a sheeting joint (where two panels meet edge-to-edge), the script automatically adds one extra stud to maintain the joint support.

**How It Works**:
1. Before erasing each stud, checks if any sheet's left or right edge aligns with the stud
2. If yes, increments the new beam count by 1
3. The extra stud is placed to preserve panel nailing support

**Benefit**: Prevents sheeting panels from losing their nailing support at joints without requiring manual intervention. This maintains structural sheathing capacity and prevents panel warping or failure.

### 9. Re-Processing on Element Changes

**Automatic Recalculation**: The script sets dependencies on all associated wall elements using `setDependencyOnEntity()`.

**What This Means**: When a wall is reconstructed (studs repositioned, openings changed, plates adjusted, dimensions modified, etc.), the point load assembly automatically recalculates to accommodate the new framing layout.

**Practical Impact**:
- Add a door or window opening after point load insertion → assembly adjusts or stops at the opening
- Change wall height → studs automatically stretch to new plate positions
- Modify wall stud spacing → blocking adjustments recalculate
- Change wall thickness → cleaning zone adjusts

**Manual Recalculation**: You can also force recalculation by selecting the instance and modifying any property in the Properties Panel.

### 10. Opening Detection and Stop Logic

**Important Behavior**: The script scans walls from top to bottom looking for openings. If it finds a wall with an opening directly below the bearing point, it stops processing at that wall and does not continue to lower levels.

**Load Path Logic**:
- Walls **above** the opening (with no openings in the load path) are framed with reinforcement posts
- The wall **containing** the opening (where the opening is below the bearing point) is **not** framed
- Walls **below** the opening are **not** processed

**Reason**: You cannot create point load posts through a door or window opening. The load path must terminate or be handled with alternate framing (header, beam, etc.).

**Engineering Consideration**: When an opening interrupts the point load path, you typically need to:
1. Design a header or beam to transfer the load around the opening
2. Use engineered posts on each side of the opening
3. Modify the framing plan to avoid placing openings in critical load paths

### 11. Multiple Trusses in One Operation

**Efficiency Tip**: You can select multiple trusses and all relevant walls in a single insertion.

**How It Works**: The script processes each truss independently, finding all bearing points and creating separate clones for each one.

**Benefits**:
- Faster than running the script once per truss
- Ensures consistent settings across all bearing points
- Reduces chance of missing a bearing location

**Example**: Select 10 trusses with 2 bearing points each → script creates 20 independent point load assemblies in one operation.

### 12. Post Assembly Naming Convention

**Recommendation**: Use a consistent naming convention for the Post Assembly Name field across your project.

**Example Conventions**:
- **Grid-Based**: "PL-A1", "PL-B3", "PL-C2" (point load at grid intersection)
- **Sequential**: "PL-01", "PL-02", "PL-03" (numbered in order)
- **Descriptive**: "Main Truss Left", "Garage Girder Right" (functional description)
- **Hierarchical**: "T05-L" (Truss 05, Left bearing), "T12-R" (Truss 12, Right bearing)

**Benefits**:
- Makes it easier to track and report point load assemblies in bills of material
- Simplifies shop drawing annotation
- Aids communication between design, engineering, and fabrication teams
- Enables filtering and querying in BOM reports

**Access in BOM**: The value appears in the Information column of beam reports and can be used as a filter or grouping criterion.

### 13. Verify Bearing Point Alignment

**Before Running**: In 3D view, visually verify that:
- Trusses are properly positioned on top of walls
- Bearing points (visible through Alpine-BearingReaction markers) align with wall locations
- Walls are vertically stacked in multi-story construction
- No major obstructions (chimneys, mechanical equipment) conflict with expected load paths

**After Running**: Check in 3D view that:
- Point load rectangles appear at expected truss bearing locations
- New studs (in distinctive color) are visible in walls
- No red-colored blocking (error state) appears
- Transfer beams bridge gaps between floors (if enabled)

### 14. Coordinate with Structural Engineer

**Critical**: Point load calculations are structural engineering decisions. Always coordinate with your project's structural engineer to:
- Verify required number of studs based on load calculations
- Confirm lumber species, grade, and treatment requirements
- Validate transfer beam adequacy for multi-story load paths
- Review any opening conflicts and alternate load path designs
- Approve hardware connector selections (if hardware insertion features are re-enabled)

This script automates the **placement** of point load assemblies but does not replace structural engineering analysis and approval.

## Technical Notes

### Script Architecture: Parent-Child Cloning Pattern

GE_TRUSS_POINTLOAD uses a self-cloning pattern to handle multiple bearing points efficiently:

**Insertion Phase** (Parent Instance):
1. User selects trusses and walls
2. Parent instance iterates over each truss
3. For each truss, scans definition for Alpine-BearingReaction instances
4. For each bearing point that intersects a selected wall:
   - Creates a new persistent clone using `tsl.dbCreate("GE_TRUSS_POINTLOAD", ...)`
   - Passes all geometric data through the Map parameter
   - Stores FIRST_INSERTED flag = 1 to trigger processing
5. Parent instance erases itself via `eraseInstance()`

**Execution Phase** (Child Clones):
1. Each clone independently processes when `_bOnElementConstructed` fires or `FIRST_INSERTED == 1`
2. Retrieves geometric data from `_Map`
3. Performs stud replacement, transfer beam creation, blocking adjustment
4. Sets `FIRST_INSERTED = 0` to prevent re-processing on subsequent reconstructions

**Benefits**:
- Each bearing point has independent parameters (can adjust one without affecting others)
- Efficient processing (parallel operations on separate instances)
- Clean separation of insertion logic from execution logic
- Supports undo/redo properly (each clone is a separate database object)

### Truss Bearing Detection Algorithm

**Objective**: Find all bearing points and uplift values from truss definitions.

**Process**:

1. **Get Truss Definition**: `TrussEntity.definition()` returns the TrussDefinition object
2. **Scan for TSL Instances**: `TrussDefinition.tslInst()` returns all TSL instances within the truss
3. **Filter for Bearing Markers**: Look for instances with script name "Alpine-BearingReaction"
4. **Extract Data**:
   - Position: `tslInTruss.ptOrg()` in truss-local coordinates
   - Transform to world: `ptCen.transformBy(csTruss)` using `teTruss.coordSys()`
   - Uplift: `tslInTruss.map().getDouble("MaxVerticalUplift")`
5. **Construct Search Body**:
   - Origin: Bearing point
   - X-axis: Support direction (perpendicular to wall, derived from truss beam directions)
   - Y-axis: `_ZW` (vertical)
   - Z-axis: Cross product of X and Y
   - Dimensions: 250mm × (ground to bearing height) × (truss depth)
6. **Intersect with Walls**: Any wall whose outline intersects this search body is under the truss at this bearing point

**Edge Cases**:
- Half trusses (not complete triangles): Uses highest point on truss instead of centroid to determine wall face
- Multiple bearing points per truss: Each gets its own clone
- Trusses with no Alpine-BearingReaction markers: Skipped (no bearing points found)

### Ply Count Detection: Geometric Analysis

**Objective**: Determine how many plies (layers) the truss girder has at the bearing location.

**Challenge**: TSL cannot directly query "number of plies" from a truss definition. Must use geometric inference.

**Algorithm**:

```c
// Pseudo-code representation
nPlies = 0
bmAllInTrussForcedCopy = all beams in truss (as copies)

// Remove first vertical beam if present
if (bmAllInTrussForcedCopy[0] is vertical) {
    swap with first non-vertical beam
}

while (bmAllInTrussForcedCopy is not empty) {
    bm0 = first beam in list

    // Create thin intersection body aligned with bm0's plane
    bdInt = thin body (25m × 25m × 12mm) at bm0, aligned to bm0's plane

    // Find all beams in same ply (intersecting the thin body)
    for each beam in bmAllInTrussForcedCopy (backwards) {
        if (beam intersects bdInt) {
            remove beam from list  // It's in this ply
        }
    }

    nPlies++
}

erase all temporary beams
```

**Key Concepts**:
- **Ply Definition**: All beams that lie in the same plane (within 12mm tolerance) are considered one ply
- **Thin Intersection Body**: A very thin (12mm / 0.5") body acts as a geometric "slice" to test which beams are coplanar
- **Iterative Removal**: Each iteration identifies one ply and removes its beams from the working set
- **Temporary Beams**: Required because `dbCopy()` doesn't work directly within the truss definition loop; beams are created via `Beam.dbCreate(body)` and erased after counting

**Typical Results**:
- Single-ply truss: nPlies = 1
- Double-ply truss: nPlies = 2
- Triple-ply truss (heavy loads): nPlies = 3

This value is stored in `_Map.setInt("Plies", nPlies)` and used for the dynamic beam quantity options.

### Wall Sorting and Processing Order

**Sorting Logic**:
```c
// Sort elAll[] by Z-coordinate (height) descending
for (s1 = 1 to nNrOfRows) {
    for (s2 = s1-1 to 0) {
        if (elAll[s11].ptOrg().Z() > elAll[s2].ptOrg().Z()) {
            swap(elAll[s2], elAll[s11])
        }
    }
}
```

**Result**: `elAll[0]` = highest wall, `elAll[length-1]` = lowest wall

**Processing Order**: Top to bottom (gravity load transfer direction)

**Opening Detection**: Scan from top to bottom; stop when an opening is found in the load path

**Benefit**: Ensures upper walls are framed even if lower walls have openings that interrupt the load path

### Cleaning Zone Geometry

**Purpose**: Define the area where existing studs must be erased and new studs will be placed.

**Construction**:
```c
ptBdCleanOrg = _Pt0  // Bearing point (+ lateral offset)
vCleanX = vCleanY.crossProduct(vCleanZ)  // Perpendicular to wall, horizontal
vCleanY = _ZW  // Vertical (always positive)
vCleanZ = vSupportX  // Along wall length axis (direction flag = 0)

dBdCleanX = nNewBeams * dBmWidth  // Width of all new studs combined
dBdCleanY = _ZW.dotProduct(_Pt0 - Point3d(0,0,0))  // Height from ground to bearing
dBdCleanZ = U(250, 10)  // 250mm / 10" depth through wall

bdClean = Body(ptBdCleanOrg, vCleanX, vCleanY, vCleanZ,
               dBdCleanX, dBdCleanY, dBdCleanZ,
               0, -1, 0)  // Flag 0 = direction insensitive for Z
```

**Slice for 2D Operations**:
```c
ppClean = bdClean.getSlice(Plane(_Pt0, vz))  // Slice by wall plane
plClean = ppClean.allRings()[0]  // Get outline polyline
```

**Stored**: `_Map.setPLine("PL_CLEAN_AREA", plClean)` for display purposes

### Beam Property Assignment Strategy

Each newly created stud and transfer beam receives properties from multiple sources:

| Property | Source | Assignment Code |
|----------|--------|-----------------|
| **Geometry** | Wall stud (copied) | `bmNew = bmAnyStud.dbCopy()` |
| **Width** | Lumber inventory WIDTH | `bmNew.setD(vx, dBmWidth)` |
| **Material** | Lumber inventory HSB_MATERIAL | `bmNew.setMaterial(sBmMaterial)` |
| **Grade** | Lumber inventory HSB_GRADE | `bmNew.setGrade(sBmGrade)` |
| **Color** | Property panel | `bmNew.setColor(nBmColor)` |
| **Information** | Property panel | `bmNew.setInformation(sBmInformation)` |
| **Module** | Instance + element index | `bmNew.setModule(_ThisInst.handle() + e)` |

**Width Validation**:
```c
bHeightFound = false
for each inventory item matching selected lumber {
    if (abs(inventory_HEIGHT - wall_beamWidth) < U(1, 0.01)) {
        dBmHeight = inventory_HEIGHT
        sBmMaterial = inventory_HSB_MATERIAL
        sBmGrade = inventory_HSB_GRADE
        bHeightFound = true
        break
    }
}

if (!bHeightFound) {
    sBmMaterial = "UNDEFINED"
    dBmHeight = wall.dBeamHeight()
    // Add warning to sWarningMessage
}
```

**Unique Module IDs**: Each element gets a unique module ID formed by concatenating:
- Parent TSL instance handle (unique per bearing point)
- Element index (0 for top wall, 1 for second wall, etc.)

This allows beams to be grouped by bearing point and by floor level for reporting and shop drawing purposes.

### Stud Placement: Alternating Pattern

**Objective**: Distribute studs symmetrically around the bearing point.

**Algorithm**:
```c
ptNewBmCenter = _Pt0  // Start at bearing point
ptNewBmCenter += vx * 0.5 * dBmWidth * (1 - (nNewBeams % 2))  // Offset for even count

for (n = 0 to nNewBeams - 1) {
    nSign = (n % 2 == 0) ? 1 : -1  // Alternate left/right
    ptNewBmCenter += vx * dBmWidth * n * nSign

    // Create beam at ptNewBmCenter
    // ...
}
```

**Pattern Examples**:

**3 Studs** (odd count):
```
  -1   0   +1     (beam indices × dBmWidth)
   2   0   1     (creation order)
```
Center stud first, then alternate left-right.

**4 Studs** (even count):
```
-1.5 -0.5 +0.5 +1.5    (beam indices × dBmWidth)
  1    0    2    3     (creation order)
```
Offset by half a beam width, then alternate left-right.

**Benefit**: Symmetric distribution regardless of odd/even count, balanced bearing on truss.

### Transfer Beam Creation and Stretching

**Creation**:
```c
if (el != elBottom && nUseTransferBeams) {
    ptTransferCen = bmNew.ptCen() + _ZW * _ZW.dotProduct(ptOrgEl - bmNew.ptCen())
    // Projects stud center onto wall origin Z-height

    dTransferL = U(100, 4)  // Initial length 100mm / 4"

    bmTransfer.dbCreate(ptTransferCen, _ZW, bmNew.vecY(), bmNew.vecZ(),
                        dTransferL, dTransferW, dTransferH,
                        -1, 0, 0)
}
```

**Stretching**:
```c
// Stretch upward to bottom plates of wall above
bmAllToStretchOnTop = filterBeamsHalfLineIntersectSort(
    bmAllBottomPlatesForTransfers, bmTransfer.ptCen(), _ZW)
if (bmAllToStretchOnTop.length() > 0) {
    bmTransfer.stretchDynamicTo(bmAllToStretchOnTop[0])
}

// Stretch downward to top plates of wall below
bmAllToStretchOnBottom = filterBeamsHalfLineIntersectSort(
    bmAllTopPlatesForTransfers, bmTransfer.ptCen(), -_ZW)
if (bmAllToStretchOnBottom.length() > 0) {
    bmTransfer.stretchDynamicTo(bmAllToStretchOnBottom[0])
}
```

**Key Functions**:
- **filterBeamsHalfLineIntersectSort**: Finds beams that intersect a half-line (ray) from a point in a direction, sorted by distance
- **stretchDynamicTo**: Extends the beam dynamically (adjusts length without changing other dimensions) to touch the target beam

**Plate Collection**: All top and bottom plates from all walls are collected in advance into `bmAllTopPlatesForTransfers[]` and `bmAllBottomPlatesForTransfers[]`. This is a "heavy operation" (as noted in code comments) but necessary for efficient stretching across multiple floor levels.

### Blocking Handling: Five-Case Logic

**Search Zone**: Wider than cleaning zone to catch adjacent blocking.
```c
dBdBlockingSearchX = dBdCleanX + 2 * dBmWidth  // Two extra beams on each side
```

**Case Determination**:

For each blocking beam `bmBlocking`:

```c
Point3d ptBmL = bmBlocking.ptCen() - vx * bmBlocking.dD(vx) * 0.5
Point3d ptBmR = bmBlocking.ptCen() + vx * bmBlocking.dD(vx) * 0.5

double distL = vx.dotProduct(ptBmL - ptMostLeftToClean)
double distR = vx.dotProduct(ptMostRightToClean - ptBmR)

if (bdBlocking.hasIntersection(bdClean)) {
    if (distL < 0 && distR < 0) {
        // Case 1: Fully contained
        bmBlocking.dbErase()
    }
    else if (distL >= 0 && distR >= 0) {
        // Case 2: Spanning
        Beam bmCopy = bmBlocking.dbCopy()
        bmBlocking.cut(ptMostRightToClean, -vx)  // Cut from right
        bmCopy.cut(ptMostLeftToClean, vx)        // Cut from left
    }
    else if (distL < 0 && distR >= 0) {
        // Case 3: Left overlap
        bmBlocking.cut(ptMostRightToClean, -vx)
    }
    else if (distL >= 0 && distR < 0) {
        // Case 4: Right overlap
        bmBlocking.cut(ptMostLeftToClean, vx)
    }
}
else if (distL < dBmWidth || distR < dBmWidth) {
    // Case 5: Adjacent (within one beam width)
    bmBlocking.stretchStaticTo(closest new stud)
}
else {
    // Error state: unexpected geometry
    bmBlocking.setColor(1)  // Red flag
}
```

**Visual Reference**:
```
Case 1: [----blocking----]        → Erase
        |==== clean ====|

Case 2: [-------blocking-------]  → Split into two
            |== clean ==|

Case 3: [----blocking----]         → Cut from right
            |== clean ==|

Case 4:         [----blocking----] → Cut from left
            |== clean ==|

Case 5: [--B--]  |== clean ==|    → Stretch to clean zone
```

### Element Deletion Cleanup

**Trigger**: When `_bOnElementDeleted` fires (user deletes a wall or the truss)

**Cleanup Process**:
```c
if (_bOnElementDeleted) {
    // 1. Erase all child TSLs that reference this instance
    TslInst allTsls[] = TslInst().collectOnGroup()
    for each tsl in allTsls {
        if (tsl.map().getString("HANDLE") == _ThisInst.handle()) {
            tsl.dbErase()
        }
    }

    // 2. Erase all beams created by this instance
    for each beam in _Beam[] {
        beam.dbErase()
    }

    // 3. Reset first-inserted flag
    _Map.setInt("FIRST_INSERTED", 0)
}
```

**Purpose**: Prevents orphaned beams and child TSLs when the parent element is deleted. Ensures database stays clean.

**Child TSL Check**: The script looks for TSLs with a Map entry "HANDLE" matching this instance's handle. This is used for hardware connector TSLs (currently commented out) that would be inserted as children of the point load assembly.

### Display Representation

**Model Space Display**:

```c
// Rectangular outline
PLine plRect
plRect.createRectangle(
    width = nCreatedBeams * dElRefBmH,
    height = dElRefBmW
)

// Diagonal cross
Line lnCross1, lnCross2
// From corner to opposite corner

// Hatch fill
Hatch hatch(plRect)

Display dp(-1)  // Color -1 = ByLayer
dp.draw(plRect)
dp.draw(lnCross1)
dp.draw(lnCross2)
dp.draw(hatch)
```

**Debug Visualization** (if `bDebug` flag is set):
```c
Point3d ptTrussCenter.vis()
Point3d ptHighestOnTruss.vis()
Point3d ptTopOnTopElement.vis()
Point3d ptMax.vis()  // Wall front face
Point3d ptMin.vis()  // Wall back face
Vector3d vSupportX.vis()
PLine plCleanArea.vis()
```

**Visibility**: The display outline and cross help you identify where each point load assembly is located. Combined with distinctive beam colors, this provides clear visual feedback in both 2D and 3D views.

## Related Scripts

| Script Name | Relationship | Description |
|-------------|--------------|-------------|
| **Alpine-BearingReaction** | Required | Provides bearing point locations and uplift values within truss definitions. Without this TSL in the truss, GE_TRUSS_POINTLOAD cannot find bearing points. This script must be part of the truss definition created by the truss manufacturer or engineer. |
| **GE_PLOT_POINTLOAD_INFO** | Optional (commented out in v2.2) | Display/annotation script for point load information on truss and element views. Referenced in code for future use. Would display uplift values, hardware connector info, and beam counts on shop drawings. |
| **GE_HDWR_STRAP_TWIST_HTS** | Optional (commented out in v2.2) | Hardware insertion for HTS twist straps (H2.5T, HTS20). Would be inserted based on heel height and uplift thresholds. Code preserved for future re-enablement. |
| **GE_HDWR_STRAP_TSA_ENHANCED** | Optional (commented out in v2.2) | Hardware insertion for MSTA strap connectors (MSTA12, MSTA36). Would be used for heel heights >= 12" based on uplift values. Code preserved for future re-enablement. |
| **GE_HDWR_WALL_HOLD_DOWN** | Optional (commented out in v2.2) | Hardware insertion for wall hold-down connectors (DTT2Z, HTT4) to slab at first floor. Would be inserted based on uplift ranges. Code preserved for future re-enablement. |
| **GE_HDWR_WALL_ANCHOR** | Optional (commented out in v2.2) | Wall anchor insertion with automatic rod type selection based on uplift. Referenced in code for future use. |
| **GE_WALL_POINTLOAD** | Separate functionality | Similar script for wall-based point loads (independent, not called by this script). Used when point loads originate from walls rather than trusses (e.g., beam bearing on wall, upper wall bearing on lower wall). |

**Hardware Insertion Note**: Version 2.0 (April 2014) commented out all hardware insertion functionality to focus on framing automation. The hardware logic is preserved in the code for potential future restoration. Users needing hardware connectors can manually insert the above hardware scripts after running GE_TRUSS_POINTLOAD.

## Version History Highlights

### v2.2 (May 7, 2014)
- **Lumber Dropdown Enhancement**: Displays format changed to `THICKNESS + MATERIAL + GRADE + TREATMENT` (e.g., "1.5 x SPF No.2 PT")
- **Cleaning Area Adjustment**: Recalculated for new lumber item values
- **Blocking Logic Update**: Fixed for new lumber property values
- **Per-Element Material Assignment**: Material and grade now assigned per element based on wall beam height matching
- **Width Validation**: Added validation of beam width against wall dimensions with detailed error reporting
- **Error Correction**: If lumber height not found in inventory, width is set from wall and material is set to "UNDEFINED" with detailed report message

### v2.1 (May 4, 2014)
- **Dynamic Stud Count Options**: Added "Number of plies in girder" and "Number of plies in girder +1" to New Beams Qty. dropdown
- **Color Names Dropdown**: Changed from numeric indices to named colors with indices (e.g., "Blue (5)", "Red (1)")

### v2.0 (April 29, 2014) - Major Refactoring
- **Hardware Insertion Commented Out**: All hardware connector insertion code (twist straps, MSTA straps, hold-downs, anchors) moved to comments but preserved for future use
- **Explicit Stud Selection**: Added options to select 1-10 studs directly (in addition to dynamic options)
- **Lumber Properties Integration**: Added material and grade assignment from Framing Defaults Editor inventory
- **Post Assembly Name**: Added text input field for tagging assemblies (Information property)
- **Transfer Beam Toggle**: Added "Create studs between floors" Yes/No option
- **Unique Module IDs**: Each assembly on each element receives unique module ID for tracking

**Rules Removed** (no longer in effect as of v2.0):
- Heel height thresholds for hardware selection
- Uplift ranges for connector types (H2.5T < 425 lbs, 425-700 lbs, etc.)
- Automatic MSTA strap insertion for heel >= 12"
- Automatic hold-down insertion for first floor
- Floor-to-floor strap insertion between levels

### v1.22 (November 3, 2013)
- **Stickframe Path**: Added to DLL call input parameters for Framing Defaults Editor access

### v1.0 (May 27, 2011) - Initial Release
- Full hardware insertion based on heel height and uplift thresholds
- Twist strap placement (H2.5T, HTS20)
- MSTA strap placement (MSTA12, MSTA36) with optional CS16 forcing
- Hold-down placement (DTT2Z, HTT4) with automatic/manual anchor selection
- Floor-to-floor transfer straps
- Display TSL integration (GE_PLOT_POINTLOAD_INFO)

## Troubleshooting

### Issue: No Bearing Points Detected

**Symptoms**: Script completes immediately after wall selection with no point loads created.

**Causes**:
1. Trusses do not contain Alpine-BearingReaction TSL instances
2. Bearing reaction positions do not intersect selected walls
3. Truss coordinate system transformation failed

**Solutions**:
- Verify trusses contain Alpine-BearingReaction markers (check truss definition in Truss Editor)
- Ensure walls are positioned directly under truss bearing points
- Check that trusses are properly placed (not floating, not misaligned)
- Select wider wall range to ensure intersection with search bodies

### Issue: Material Shows "UNDEFINED"

**Symptoms**: Command line warning message about beam width not matching inventory. Beams created with Material = "UNDEFINED".

**Cause**: The selected lumber item does not have a HEIGHT entry matching the wall's stud depth.

**Solution**:
1. Open Framing Defaults Editor
2. Check what lumber heights are defined for the selected species/grade/treatment
3. Either:
   - Add a lumber item with HEIGHT matching the wall stud depth, or
   - Select a different lumber item that has the correct HEIGHT, or
   - Modify wall to use standard lumber dimensions
4. Re-select the point load instance and change the Lumber Item property to trigger recalculation

### Issue: Posts Not Created on Lower Floors

**Symptoms**: Top floor has posts, but lower floors do not.

**Causes**:
1. Opening detected in load path (script stops processing below openings)
2. Walls not vertically aligned (intersection test fails)
3. Lower walls not selected during insertion

**Solutions**:
- Check for openings in walls directly below the bearing point
- Verify walls are vertically stacked and aligned
- Re-insert script and ensure all walls from top to bottom are selected
- Review wall origins and coordinate systems for alignment issues

### Issue: Transfer Beams Not Created

**Symptoms**: Studs exist in walls, but gaps exist between floor levels.

**Cause**: "Create studs between floors" is set to "No".

**Solution**:
- Select the point load instance
- In Properties Panel, change "Create studs between floors" to "Yes"
- Script recalculates and creates transfer beams

### Issue: Blocking Colored Red

**Symptoms**: Some blocking beams turn red after point load insertion.

**Cause**: Blocking geometry does not match any of the five expected cases (fully contained, spanning, left overlap, right overlap, adjacent). This is an error state.

**Solutions**:
- Manually review the red blocking beam
- Determine appropriate action (erase, trim, split, stretch)
- Adjust manually or adjust point load lateral offset to avoid the conflict
- Report unexpected geometry to hsbCAD support for script enhancement

### Issue: Sheeting Panels Lose Support

**Symptoms**: Visual inspection shows panel edges without nailing support.

**Cause**: This should not happen—the script automatically adds extra studs at sheeting joints. If it does occur, possible causes:
- Sheet edges not precisely aligned with original studs (rounding errors)
- Sheets added after point load insertion
- Sheet geometry corruption

**Solutions**:
- Manually add studs at panel edges
- Rebuild sheets to ensure proper edge alignment
- Delete and re-insert point load to trigger sheeting joint detection

### Issue: Script Causes AutoCAD Crash

**Symptoms**: AutoCAD hangs or crashes during insertion or recalculation.

**Causes**:
- Very large number of walls selected (> 100)
- Extremely complex truss definitions with hundreds of beams
- Corrupted wall or truss geometry
- Memory issues with ply count detection loop

**Solutions**:
- Select fewer walls per insertion (process building in sections)
- Simplify truss definitions if possible
- Audit and repair wall and truss geometry
- Increase AutoCAD memory allocation settings
- Contact hsbCAD support with sample drawing file

### Issue: Lateral Offset Moves Posts Off Bearing

**Symptoms**: Posts are not aligned with truss bearing location.

**Cause**: Lateral offset value is too large.

**Solution**:
- Select the instance
- Set Lateral Offset to 0 or a small value (< 50mm / 2")
- Verify in 3D view that posts align with truss bearing
- Adjust incrementally if offset is needed for clearance

## Summary

GE_TRUSS_POINTLOAD is a comprehensive structural framing automation tool that significantly reduces the time and complexity involved in creating point load assemblies for truss-to-wall connections in multi-story stick-frame construction. By automatically detecting bearing points, calculating required reinforcement, erasing and replacing studs, handling blocking conflicts, and creating transfer beams, it eliminates hundreds of manual operations per project while ensuring structural consistency and code compliance.

The integration with the Framing Defaults Editor inventory system ensures material specifications remain consistent across the project, and the self-cloning architecture allows independent configuration of each bearing point while maintaining ease of use.

**When to Use**: Whenever you have engineered roof trusses bearing on walls that require point load reinforcement studs to carry concentrated loads to the foundation.

**Key Benefits**:
- **Time Savings**: Automated stud replacement, blocking adjustment, and transfer beam creation
- **Accuracy**: Geometric analysis ensures correct ply count and bearing alignment
- **Consistency**: Lumber properties from central inventory eliminate manual property assignment errors
- **Flexibility**: Independent configuration per bearing point with dynamic or fixed stud counts
- **Intelligence**: Automatic sheeting joint preservation, opening detection, multi-story load path handling
- **Visibility**: Distinctive colors and display representation make point loads easy to identify

**Critical Requirements**:
- Alpine-BearingReaction markers in truss definitions
- Properly framed walls with studs and plates
- Configured Framing Defaults Editor inventory
- Vertically aligned walls for multi-story construction

For additional support, workflow guidance, or custom configuration assistance, contact your hsbCAD representative or consult the hsbCAD technical documentation library.
