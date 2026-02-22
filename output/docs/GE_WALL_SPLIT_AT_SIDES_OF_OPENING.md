# GE_WALL_SPLIT_AT_SIDES_OF_OPENING

## Overview and Purpose

**GE_WALL_SPLIT_AT_SIDES_OF_OPENING** is a powerful wall fabrication tool that divides a framed wall element into multiple independent wall panels by cutting the wall at one or both sides of a door or window opening. This allows large walls with openings to be split into smaller, manageable panels for easier fabrication, transportation, and installation on site.

When activated, the script analyzes the opening's location and jack stud positions, then precisely cuts the wall element(s) to create separate panels. Each resulting panel becomes an independent wall element with its own element number, fabrication drawings, and material lists.

This tool is essential for modular construction workflows where shipping constraints or crane capacity limits require walls to be broken down into components that can be assembled on-site.

### Key Capabilities

- **Three split modes**: Split on left side only, right side only, or both sides simultaneously
- **Intelligent framing redistribution**: Automatically reassigns studs, plates, headers, and cripples to the correct wall panel
- **Automatic sheathing management**: Splits and trims OSB/plywood sheets at the new panel boundaries
- **Rough opening handling**: Correctly adjusts sheathing when openings use rough dimensions (frame gap larger than finished opening)
- **Vertical splitting**: When both sides are split, optionally creates separate top (cripple) and bottom (sill) panels

### Business Context

In stick-frame construction, large walls with windows or doors are often too long or heavy to transport as single units. By splitting at the opening sides, fabricators can:

- Ship smaller panels that fit standard truck beds or shipping containers
- Reduce crane loads during installation
- Enable pre-fabrication of opening panels with pre-installed windows or doors
- Simplify quality control by handling smaller assemblies

After splitting, each panel is re-framed, numbered, and tracked independently through the manufacturing workflow.

---

## Script Metadata

| Attribute | Value |
|-----------|-------|
| **Script Type** | O (Object - persistent entity in the drawing) |
| **Beams Required** | 0 (script selects opening interactively) |
| **Points Required** | 0 |
| **Environment** | Model Space only |
| **Version** | 1.7 (March 27, 2013) |
| **Author** | David Rueda (hsbSOFT) |
| **Category** | StickFrame - Wall Fabrication |

---

## Prerequisites and Requirements

Before running this script, ensure the following conditions are met:

### 1. Wall Must Be Fully Framed

The wall element must have completed framing. Both beams (studs, plates, headers) and sheets (sheathing panels) must exist in the wall.

**Why**: The script redistributes existing framing members and sheathing to the new panel boundaries. If the wall has not been framed, the script will display an error and cancel the operation.

**Check**: Run the wall framing command or verify that the wall displays studs and sheathing panels before executing this tool.

### 2. Opening Must Be OpeningSF Type

The selected opening must be a standard **OpeningSF** type (stick-frame window or door opening created by hsbCAD's opening insertion tools).

**Not Supported**: Generic openings, user-drawn polylines, or non-SF opening types will be rejected with an error message.

**Check**: If uncertain, right-click the opening and verify its type in the properties palette.

### 3. Jack Studs (Trimmer Studs) Required on Both Sides

The opening must have jack studs on **both the left and right sides**, regardless of which split mode you select. The script uses the jack stud outer faces as cut reference points to determine exactly where the wall should be divided.

**Why**: Even when splitting only one side, the script needs both jack stud positions to calculate cut planes and sheathing adjustments accurately.

**If Missing**: The script will display "ERROR: Opening must have jack studs (both sides)" and cancel without making changes.

**Check**: Inspect the opening framing in plan view or 3D view to confirm trimmer studs exist on both sides of the opening.

### 4. Wall Must Be a Wall Element

The element must be a valid **Wall** type (not a floor, roof, or other element type).

**Check**: Select the element and verify its type in the properties palette.

### 5. No Overlapping or Duplicate Operations

Do not run this script multiple times on the same opening. The split operation is designed to execute once during insertion. Subsequent recalculations rebuild framing within the already-split panels but do not re-split the wall.

---

## Usage Instructions

### Step 1: Insert the Script

Run the TSL insertion command in hsbCAD:

```
Command: TSLINSERT
```

Select **GE_WALL_SPLIT_AT_SIDES_OF_OPENING** from the script library.

### Step 2: Select the Opening

When prompted, click on a door or window opening that is already inserted into the framed wall. The script will validate that the selection is a supported opening type.

**Prompt**: `Select an opening:`

**What to Click**: Click directly on the opening entity (visible as a rectangular cutout with framing around it).

**If Invalid**: If the selection is not a valid OpeningSF opening, the script will display an error message and cancel.

### Step 3: Choose the Split Type

The command line will present a split type selection prompt:

```
Set split type    [0: Both sides of opening / 1: Left Side of opening / 2: Right side of opening]
```

Enter one of the following numbers and press **Enter**:

| Input | Split Mode | Result |
|-------|------------|--------|
| **0** | **Both sides** | Splits the wall on both the left and right sides of the opening. Creates up to **four** separate panels: left panel, center/opening panel, top cripple panel (above opening), and bottom sill panel (below opening, if sill height ≥ 100mm). |
| **1** | **Left side only** | Splits on the left side of the opening. Creates **two** panels: the section to the left of the opening, and the remainder containing the opening. |
| **2** | **Right side only** | Splits on the right side of the opening. Creates **two** panels: the remainder containing the opening, and the section to the right of the opening. |

**Recommendation**: Use option **0** (both sides) when the opening is centrally located and you want maximum flexibility in panel sizes. Use options **1** or **2** when the opening is near one edge and splitting only one side is sufficient.

### Step 4: Wait for Processing

The script will execute the following operations automatically:

1. **Validate opening and wall**: Checks for jack studs, framing, and valid element type
2. **Collect framing beams**: Identifies all horizontal and vertical beams in the opening module
3. **Mark beams by location**: Tags beams as LEFT, RIGHT, TOP, BOTTOM, or CENTER based on their position relative to the opening
4. **Erase original framing**: Deletes all beams except those explicitly marked to be redistributed
5. **Split the wall element**: Cuts the wall at jack stud faces and creates new wall elements
6. **Redistribute beams**: Assigns preserved beams to the correct panel based on their location tags
7. **Adjust plates and sheathing**: Trims top plates, bottom plates, and sheathing panels at the new boundaries

**Duration**: The operation typically completes in 1-3 seconds, depending on wall complexity.

### Step 5: Confirm Success

When complete, the command line will display:

```
Wall successfully split. Please re-frame resulting walls.
```

At this point, the wall has been split into separate elements, but the new framing geometry has not yet been generated.

### Step 6: Re-Frame All Resulting Walls

**Critical Step**: You must manually re-frame each of the newly created wall elements.

**Why**: The split operation sets new panel boundaries and reassigns beams, but it does not generate new framing geometry. Re-framing each wall triggers hsbCAD to rebuild studs, plates, headers, cripples, and sheathing within the new boundaries.

**How to Re-Frame**:

1. Select the first resulting wall panel
2. Run the wall framing command (or double-click the wall element to trigger recalculation)
3. Repeat for each additional panel

**Number of Panels to Re-Frame**:

- **Left side only (option 1)**: Re-frame 2 walls
- **Right side only (option 2)**: Re-frame 2 walls
- **Both sides (option 0)**: Re-frame 3-4 walls (left, right, center/top, and possibly bottom if sill height ≥ 100mm)

**Visual Check**: After re-framing, verify that studs, plates, and sheathing are correctly positioned within each panel.

---

## Detailed Parameter Reference

### Split Type (Command-Line Selection)

**Parameter Name**: Split Type
**Type**: Integer (0, 1, or 2)
**When Prompted**: During insertion (Step 3)
**Cannot Be Changed After Insertion**: The split type is fixed at insertion time and cannot be modified later via the Properties Palette.

**Value Meanings**:

#### Option 0: Both Sides of Opening

**Effect**: Splits the wall on both the left and right sides of the opening.

**Resulting Panels**:

1. **Left panel**: The wall section to the left of the opening. Top and bottom plates are cut at the outer face of the left jack stud.
2. **Right panel**: The wall section to the right of the opening. Top and bottom plates are cut at the outer face of the right jack stud.
3. **Center/Opening panel**: The section spanning the opening, including the header, jack studs, and king studs.
4. **Top cripple panel** (optional): If `bSplitVertically` is true, the zone above the opening (cripple studs above the header) becomes a separate element. The top panel's base height is adjusted to start at the top of the opening header.
5. **Bottom sill panel** (optional): If `bSplitVertically` is true **and** the sill height is at least 100mm (approximately 4 inches), the zone below the opening (cripple studs below the sill) becomes a separate element.

**When to Use**: When the opening is centrally located in a long wall and you want to create the smallest possible panel sections for easier handling.

**Example Scenario**: A 30-foot wall with a 4-foot-wide window centered at 15 feet. Splitting both sides creates two 13-foot panels (left and right), a 4-foot opening panel, and potentially separate top and bottom cripple panels.

#### Option 1: Left Side of Opening

**Effect**: Splits only on the left side of the opening.

**Resulting Panels**:

1. **Left panel**: The wall section to the left of the opening. Top and bottom plates are cut at the outer face of the left jack stud.
2. **Remainder panel**: The rest of the wall, including the opening, header, and all framing to the right.

**When to Use**: When the opening is near the right end of the wall and splitting the left side alone is sufficient to achieve the desired panel size.

**Example Scenario**: A 24-foot wall with a door opening 6 feet from the left end. Splitting the left side creates a 6-foot panel and an 18-foot panel containing the door.

#### Option 2: Right Side of Opening

**Effect**: Splits only on the right side of the opening.

**Resulting Panels**:

1. **Remainder panel**: The wall section containing the opening and all framing to the left.
2. **Right panel**: The wall section to the right of the opening. Top and bottom plates are cut at the outer face of the right jack stud.

**When to Use**: When the opening is near the left end of the wall and splitting the right side alone is sufficient.

**Example Scenario**: A 20-foot wall with a window opening 14 feet from the left end. Splitting the right side creates a 14-foot panel containing the window and a 6-foot panel.

---

## Technical Details: How the Script Works

### Phase 1: Insertion and Validation

When the script is first inserted (`_bOnInsert` is true), it performs the following steps:

1. **Select Opening**: Prompts the user to select an opening entity.
2. **Validate Opening Type**: Casts the selection to `OpeningSF` type. If invalid, displays an error and cancels.
3. **Prompt for Split Type**: Asks the user to choose 0, 1, or 2.
4. **Store Choice in Map**: Saves the split type to `_Map.setInt("CHOICE", nChoice)` for use during execution.
5. **Initialize Flags**: Sets `ExecutionMode=0` and `SplitWall=0` to indicate the wall has not yet been split.

### Phase 2: Wall Splitting Logic (Executed Once)

When `_Map.getInt("SplitWall")==0`, the script executes the main splitting logic:

#### Step 1: Retrieve Wall and Opening Geometry

- **Wall Element**: Extracts the wall from the opening using `opSf.element()`.
- **Coordinate System**: Gets the wall's local coordinate system (origin, X-axis, Y-axis, Z-axis).
- **Wall Dimensions**: Calculates wall length, width (thickness), and height.
- **Opening Dimensions**: Extracts opening width, height, sill height, and gap dimensions (top, bottom, sides).

#### Step 2: Calculate Reference Points

The script calculates critical reference points for cutting and adjusting framing:

- **ptLeftOp**: Left edge of opening (including side gap and tolerance).
- **ptRightOp**: Right edge of opening (including side gap and tolerance).
- **ptTopOp**: Top edge of opening (including top gap and tolerance).
- **ptBottomOp**: Bottom edge of opening (including bottom gap and tolerance).
- **ptCenOp**: Center point of opening.

**Rough Dimension Offset**: If the opening uses rough dimensions (the rough opening width is larger than the finished opening width), the script calculates an offset value:

```c
double dOffsetWhenRoughDimension= (dOpWRough-dOpW)/2;
```

This offset is used later to adjust sheathing panels at the split edges.

#### Step 3: Identify Jack Studs

The script searches for jack studs (trimmer studs) on both sides of the opening:

- **Left Jack Studs**: Uses `filterBeamsHalfLineIntersectSort` to find all beams of type `_kSFSupportingBeam` to the left of the opening.
- **Right Jack Studs**: Finds jack studs to the right of the opening.
- **Most Extreme Jack Studs**: Identifies the outermost jack stud on each side to determine the cut plane locations.

**Cut Points**:

- **ptStretchTopsAtLeft**: Outer face of the leftmost left-side jack stud (used to cut top plates).
- **ptStretchBottomsAtLeft**: Outer face of the rightmost left-side jack stud (used to cut bottom plates).
- **ptStretchTopsAtRight**: Outer face of the rightmost right-side jack stud.
- **ptStretchBottomsAtRight**: Outer face of the leftmost right-side jack stud.

**Why Two Points per Side**: Top plates and bottom plates may be cut at slightly different locations depending on the jack stud configuration.

#### Step 4: Tag Beams by Location

The script creates search volumes (bounding boxes) around the opening to identify which beams belong to which zone:

- **Top Search Volume**: A box extending upward from the top of the opening.
- **Bottom Search Volume**: A box extending downward from the bottom of the opening.
- **Left Search Volume**: A box extending left from the left edge of the opening.
- **Right Search Volume**: A box extending right from the right edge of the opening.

For each beam in the wall:

1. Test if the beam intersects any search volume.
2. If intersection found, tag the beam with a location label (LEFT, RIGHT, TOP, BOTTOM, CENTER).
3. Store the tag in the beam's submap: `subMap.setString("LOCATION","TOP")`.
4. Assign the beam's panhandle to the script instance: `bm.setPanhand(_ThisInst)`.

**Why Tag Beams**: Later, during the re-framing phase, the script reassigns beams to the correct wall panel based on these tags.

#### Step 5: Erase Original Framing and Sheathing

To force a clean re-frame, the script erases:

- **All beams** except those explicitly tagged with `DONT_ERASE_ME=1` (which includes the marked location beams).
- **All sheathing panels** (these will be reconstructed during re-framing).

#### Step 6: Split the Wall Element

Depending on the split type, the script creates new wall elements:

##### Split Left Side

1. **Create a copy** of the original wall: `wlNew = wlOriginal.dbCopy()`.
2. **Adjust start and end points**:
   - **Original wall** (will become center panel): Set start to original start, set end to `ptSplitLeft`.
   - **New wall copy** (will become left panel): Set start to `ptSplitLeft`, set end to original end.
3. **Tag elements**: Mark the center panel as `POSITION=CENTER` and the left panel as `POSITION=LEFT`.
4. **Adjust wall arrow**: Reposition the element icon to the center of the new left panel.

##### Split Right Side

1. **Create a copy** of the wall (or the center panel if left was already split).
2. **Adjust start and end points**:
   - **Original wall**: Set start to original start, set end to `ptSplitRight`.
   - **New wall copy**: Set start to `ptSplitRight`, set end to original end.
3. **Tag elements**: Mark as `POSITION=CENTER` and `POSITION=RIGHT`.

##### Split Vertically (When Both Sides Are Split)

If `bSplitVertically` is true (both sides split):

1. **Create top panel**: The center panel becomes the top panel.
2. **Move top panel upward**: Transform the top panel by the opening top point elevation.
3. **Adjust top panel base height**: Set the base height to span from the top of the opening to the original wall top.
4. **Create bottom panel (if sill height ≥ 100mm)**:
   - Copy the center panel.
   - Set the bottom panel's base height to the sill height.
   - Tag as `POSITION=BOTTOM`.
5. **Erase opening**: The opening entity is deleted because it now belongs to the top panel.

#### Step 7: Store Data in Map

All calculated reference points, vectors, and dimensions are stored in `_Map` for use during the re-framing phase:

- Opening reference points (left, right, top, bottom, center)
- Cut points for plates (left and right)
- Search points for sheathing adjustment
- Wall dimensions and rough dimension offset
- Opening entity reference

**Why Store in Map**: The re-framing logic executes later when the user triggers re-framing on each panel. The stored data allows the script to correctly adjust plates and sheathing without re-calculating geometry.

#### Step 8: Display Success Message

The script displays:

```
Wall successfully split. Please re-frame resulting walls.
```

And sets `_Map.setInt("SplitWall",1)` to prevent the splitting logic from running again.

---

### Phase 3: Re-Framing Logic (Executed for Each Panel)

When the user re-frames each wall panel, the script's construction logic (`_bOnElementConstructed`) executes for each element:

#### Step 1: Determine Panel Position

The script reads the element's submap to determine its position:

```c
Map subMap= el.subMapX("SUBMAP");
String sPosition= subMap.getString("POSITION");
```

Possible values: `LEFT`, `RIGHT`, `CENTER`, `TOP`, `BOTTOM`.

#### Step 2: Process Left Panel

For the **left panel** (`POSITION=LEFT`):

1. **Adjust Top Plates**:
   - Find all horizontal beams of type `_kTopPlate`, `_kSFTopPlate`, or `_kSFVeryTopPlate`.
   - Apply a cut at `ptStretchTopsAtLeft` to trim the plates at the left jack stud face.
   - Use `bm.addToolStatic(Cut(ptStretchTopsAtLeft, vCutLeft), true)`.

2. **Adjust Bottom Plates**:
   - Find all horizontal beams of type `_kBottom` or `_kSFBottomPlate`.
   - Apply a cut at `ptStretchBottomsAtLeft`.

3. **Adjust Sheathing (if rough dimension offset > 0)**:
   - Create a search volume at `ptSearchSheetsAtLeft`.
   - For each sheathing zone (zones -5 to 5, excluding 0):
     - Find sheets that intersect the search volume.
     - Calculate the distance from the sheet edge to the cut point.
     - **If distance > 0** (sheet must be extended):
       - Copy the sheet.
       - Move the copy by `dOffsetWhenRoughDimension` along the X-axis.
       - Join the original and copy using `sh1.dbJoin(sh2)`.
       - If the extended sheet exceeds the zone width, split it at the cut point using `sh1.dbSplit(Plane(ptCut, vxOriginal), 0)`.

**Why Adjust Sheathing for Rough Dimensions**: When openings are dimensioned to the inside of the frame (rough opening larger than finished opening), the sheathing must be extended to cover the additional frame width at the split edge.

#### Step 3: Process Right Panel

For the **right panel** (`POSITION=RIGHT`):

1. **Adjust Top Plates**: Apply cut at `ptStretchTopsAtRight`.
2. **Adjust Bottom Plates**: Apply cut at `ptStretchBottomsAtRight`.
3. **Adjust Sheathing**: Same logic as left panel, but extending sheets in the opposite direction.

#### Step 4: Process Center Panel

For the **center panel** (`POSITION=CENTER`):

1. **Adjust Top Plates (if header not below plate)**:
   - If `bHeaderBelowPlate` is false, apply cuts at both `ptStretchTopsAtLeft` and `ptStretchTopsAtRight`.
2. **Adjust Bottom Plates**: Apply cuts at both left and right cut points.
3. **Preserve Opening**: The opening entity remains attached to the center panel (unless vertical splitting was performed).

#### Step 5: Process Top Panel

For the **top panel** (`POSITION=TOP`):

1. **Erase all beams** except those explicitly marked with `DONT_ERASE_ME=1` (the beams tagged as TOP during the splitting phase).
2. **Reassign tagged beams**: All beams with `LOCATION=TOP` are assigned to the top panel element group.
3. **Re-framing**: When the user re-frames this panel, hsbCAD generates new framing (cripple studs, plates) within the top panel boundaries.

#### Step 6: Process Bottom Panel

For the **bottom panel** (`POSITION=BOTTOM`):

1. **Erase all beams** except those marked `DONT_ERASE_ME=1`.
2. **Reassign tagged beams**: All beams with `LOCATION=BOTTOM` are assigned to the bottom panel element group.
3. **Re-framing**: When re-framed, hsbCAD generates sill cripples and plates within the bottom panel boundaries.

#### Step 7: Erase Unmarked Beams

At the end of the construction phase, the script erases any beams that were not explicitly marked for preservation:

```c
if(!subMap.getInt("DONT_ERASE_ME"))
    bm.dbErase();
```

This ensures that only the correctly assigned beams remain in each panel.

---

## Examples and Use Cases

### Example 1: Split Both Sides of Centered Window

**Scenario**: You have a 24-foot wall (7.3m) with a 4-foot (1.2m) window opening centered at 12 feet (3.66m).

**Steps**:

1. Run `GE_WALL_SPLIT_AT_SIDES_OF_OPENING`.
2. Select the window opening.
3. Choose **0** (both sides).
4. The script creates:
   - **Left panel**: 10 feet (3.05m) - from wall start to left jack stud.
   - **Center panel**: 4 feet (1.2m) - containing the window opening and header.
   - **Right panel**: 10 feet (3.05m) - from right jack stud to wall end.
   - **Top panel** (if vertical split): Cripple zone above the header.
   - **Bottom panel** (if sill height ≥ 100mm): Cripple zone below the sill.

5. Re-frame all panels.

**Result**: Three to five manageable panels instead of one large 24-foot wall.

### Example 2: Split Left Side Only for Shipping Constraint

**Scenario**: You have an 18-foot wall with a door opening 6 feet from the left end. Your truck bed is 12 feet long.

**Steps**:

1. Run `GE_WALL_SPLIT_AT_SIDES_OF_OPENING`.
2. Select the door opening.
3. Choose **1** (left side only).
4. The script creates:
   - **Left panel**: 6 feet (1.83m).
   - **Remainder panel**: 12 feet (3.66m) - containing the door.

5. Re-frame both panels.

**Result**: Two panels, both under 12 feet, that fit in your truck.

### Example 3: Handling Rough Dimension Openings

**Scenario**: You have a wall with a window opening. The finished opening width is 36 inches, but the rough opening (inside of frame) is 38 inches. The sheathing is installed before the window, so it must extend to the rough opening edges.

**Steps**:

1. Run `GE_WALL_SPLIT_AT_SIDES_OF_OPENING`.
2. Select the window.
3. Choose **0** (both sides).
4. The script detects the rough dimension offset (1 inch per side) and automatically adjusts sheathing:
   - Sheathing on the left panel is extended 1 inch to the right.
   - Sheathing on the right panel is extended 1 inch to the left.
   - If the extended sheets exceed the zone width, they are split at the stud location.

**Result**: Sheathing aligns correctly with the rough opening frame, not the finished opening dimension.

---

## Important Notes and Tips

### Always Re-Frame After Splitting

**Critical**: The split operation sets new panel boundaries but does **not** generate new framing geometry. You must manually re-frame each resulting wall panel.

**Why**: The script erases most of the original beams (except those explicitly tagged) and redistributes the preserved beams. New framing is generated only when you re-frame each panel.

**How**: Select each panel and run the wall framing command, or double-click the wall element to trigger recalculation.

### Jack Studs Are Mandatory on Both Sides

Even if you only split one side, the tool requires jack studs on **both sides** of the opening.

**Why**: The script uses jack stud positions from both sides to calculate cut geometry and sheathing adjustments accurately.

**If Missing**: The operation will cancel with an error message.

### The Opening Must Be Framed Before Splitting

Running the tool on an unframed wall will produce an error:

```
Error: wall must be framed prior to this operation
```

**Fix**: Frame the wall completely (run the wall framing command) before inserting this script.

### Doors vs. Windows: Bottom Panel Threshold

For door openings where the sill height is less than **100mm (approximately 4 inches)**, the bottom sill wall panel is **not created**.

**Why**: Doors that extend to the floor have no sill zone worth creating as a separate panel.

**Windows**: Windows with sill heights ≥ 100mm will generate a separate bottom panel containing the sill cripples.

### Rough Dimension Openings: Automatic Sheathing Adjustment

If the opening uses rough dimensions (the structural framing gap is larger than the finished opening size), the script automatically adjusts sheathing at the split edges.

**What Happens**: Sheathing panels that cross the split line are extended to cover the additional frame width, then split at the cut point if they exceed the zone width.

**Manual Override**: None. The script handles this automatically based on the opening's rough dimension properties.

### Undo Before Re-Framing

If the split result is not as expected, use AutoCAD's `UNDO` command **immediately** before re-framing any panels.

**Why**: Once you re-frame the panels, new framing geometry is generated, making it harder to undo the split operation cleanly.

### Element Icons (Arrows) Are Repositioned

After splitting, the wall direction arrows (element icons) are repositioned to prevent overlapping:

- **Left and right panels**: Icons are centered.
- **Top and bottom panels**: Icons are offset 1500mm (60 inches) left/right from the center point.

**Why**: This ensures each panel's icon remains visible and distinct in plan view.

### One-Time Operation

This tool runs the wall-splitting logic **only once** during insertion.

**Subsequent Recalculations**: When you later modify a panel (change height, move studs, etc.), the script's construction logic rebuilds framing within the already-split panel boundaries but does **not** re-split the wall.

**Re-Running the Script**: Do not attempt to run this script multiple times on the same opening. The script is designed for single execution.

### Vertical Splitting (Top and Bottom Panels)

When you choose option **0** (both sides), the script optionally creates top and bottom panels.

**Top Panel**: Contains cripple studs above the header.
**Bottom Panel**: Contains cripple studs below the sill (only if sill height ≥ 100mm).

**Why Useful**: For very tall walls with small windows, separating the cripple zones allows easier handling of the opening panel itself.

**Control**: Vertical splitting is enabled automatically when both sides are split. There is no separate user control for this feature.

---

## Common Errors and Troubleshooting

### Error: "Not valid opening provided"

**Cause**: The selected entity is not an **OpeningSF** type, or the selection was cancelled.

**Fix**:

- Ensure you click directly on a stick-frame window or door opening created by hsbCAD.
- Check that the opening is of type `OpeningSF` (not a generic opening or user-drawn polyline).

### Error: "ERROR: Opening must have jack studs (both sides)"

**Cause**: The opening does not have jack studs (trimmer studs) on both the left and right sides.

**Fix**:

- Inspect the opening framing in plan or 3D view.
- Ensure jack studs are present on both sides of the opening.
- If jack studs are missing, re-frame the opening or manually insert jack studs before running this script.

### Error: "Error: wall must be framed prior to this operation"

**Cause**: The wall element has no beams or sheets (the wall has not been framed).

**Fix**:

- Select the wall element.
- Run the wall framing command to generate studs, plates, and sheathing.
- Verify that beams and sheets are visible before running this script again.

### Error: "Not valid choice, tsl will be deleted"

**Cause**: You entered an invalid number at the split type prompt (not 0, 1, or 2).

**Fix**:

- Re-insert the script.
- When prompted for split type, enter only **0**, **1**, or **2**.

### Sheathing Not Adjusted Correctly

**Cause**: The opening may not be using rough dimensions, or the rough dimension offset is zero.

**Fix**:

- Check the opening's properties to verify the rough opening width.
- If the rough opening width equals the finished opening width, no sheathing adjustment is applied (this is expected behavior).
- For openings that require extended sheathing, ensure the rough opening width is set correctly before splitting.

### Panels Overlapping or Misaligned After Re-Framing

**Cause**: The re-framing may have been executed in the wrong order, or the original wall was not fully framed before splitting.

**Fix**:

- Use `UNDO` to restore the original wall.
- Verify that the wall is fully framed (beams and sheets present).
- Re-run the script.
- Re-frame all panels in sequence (left panel, then right panel, then center/top, then bottom).

---

## Related Scripts and Workflow

### Upstream Scripts (Used Before This Script)

| Script | Purpose |
|--------|---------|
| **Wall Creation** | Create the base wall element (start point, end point, height). |
| **Opening Insertion** | Insert door or window openings into the wall. |
| **Wall Framing** | Generate studs, plates, headers, jack studs, and sheathing. |

### Downstream Scripts (Used After This Script)

| Script | Purpose |
|--------|---------|
| **Wall Framing** | Re-frame each resulting panel to generate new framing geometry. |
| **Element Numbering** | Assign unique position numbers to each panel for tracking. |
| **Shop Drawing Generation** | Generate fabrication drawings for each panel. |
| **BOM Extraction** | Generate material lists for each panel independently. |

### Complementary Tools

| Script | Purpose |
|--------|---------|
| **HSB_G-BillOfMaterial** | Generate material lists for all wall panels. |
| **HSB_E-Insulation** | Add insulation to individual wall panels after splitting. |
| **HSB_W-Blocking** | Add blocking to specific panels as needed. |
| **GE_WALL_SHEAR_WALL** | Apply shear wall engineering to individual panels. |

### Typical Workflow

1. **Create wall element** (define start, end, height).
2. **Insert openings** (doors and windows).
3. **Frame the wall** (generate studs, plates, headers, sheathing).
4. **Run GE_WALL_SPLIT_AT_SIDES_OF_OPENING** (split the wall into panels).
5. **Re-frame each panel** (trigger framing recalculation).
6. **Number panels** (assign position numbers).
7. **Generate shop drawings** (fabrication documentation for each panel).
8. **Export to manufacturing** (CNC, material lists).

---

## Technical Reference

### Script Type

**O (Object)**: This script creates a persistent object in the drawing that recalculates when the associated elements change.

### Dependencies

- **Element**: The wall element being split.
- **Opening**: The selected door or window opening (must be OpeningSF type).
- **Beam**: All framing beams (studs, plates, headers) in the wall.
- **Sheet**: All sheathing panels in the wall.

### Key TSL Functions Used

| Function | Purpose |
|----------|---------|
| `getOpening()` | Prompts user to select an opening entity. |
| `getInt()` | Prompts user to enter an integer (split type selection). |
| `Element.dbCopy()` | Creates a copy of a wall element. |
| `Wall.setStartEnd()` | Adjusts the start and end points of a wall. |
| `Beam.addToolStatic()` | Applies a cut tool to a beam (trims plates). |
| `Sheet.dbJoin()` | Joins two sheathing panels into one. |
| `Sheet.dbSplit()` | Splits a sheathing panel at a plane. |
| `Beam.filterBeamsPerpendicular()` | Filters beams perpendicular to a vector. |
| `Body.hasIntersection()` | Tests if a bounding box intersects a beam or sheet. |
| `Map.setPoint3d()` | Stores a 3D point in the script's internal data map. |
| `Map.getString()` | Retrieves a string value from a submap (e.g., panel position). |

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Jan 6, 2012 | Initial release. |
| 1.1 | Jan 9, 2012 | Added bottom wall icon repositioning; added framing check; swapped option sides; avoid bottom wall for doors (sill < 4in). |
| 1.2 | Jan 18, 2012 | Fixed opening origin recalculation; walls are split (not just cut); improved geometric collection of beams. |
| 1.3 | Jan 23, 2012 | Code cleanup. |
| 1.4 | Feb 2, 2012 | Fixed VTP (very top plate) issues; added support for headers below plate. |
| 1.5 | Aug 23, 2012 | Version control implemented. |
| 1.6 | Aug 23, 2012 | Fixed opening anchor issues; improved beam collection; redefined side vectors; improved sheathing control for rough dimensions. |
| **1.7** | **Mar 27, 2013** | **Fixed opening movement due to anchor location (inside/outside frame); recalculated offset based on opening size plus gaps.** |

### Author

**David Rueda (dr@hsb-cad.com)**
hsbSOFT, United States of America

---

## Summary

**GE_WALL_SPLIT_AT_SIDES_OF_OPENING** is an essential tool for stick-frame fabrication workflows where large walls with openings must be divided into smaller, manageable panels for shipping and installation. By splitting at the opening sides, the script creates independent wall elements with correctly redistributed framing and sheathing. The tool handles rough dimension openings, adjusts sheathing automatically, and supports three split modes (left only, right only, or both sides with optional vertical splitting).

**Key Takeaways**:

- Always ensure the wall is fully framed before running the script.
- Jack studs are required on both sides of the opening, even for one-sided splits.
- Re-frame all resulting panels after splitting to generate new framing geometry.
- Use option 0 (both sides) for maximum panel size reduction; use options 1 or 2 for targeted single-side splits.
- The script handles rough dimension openings automatically by extending and trimming sheathing as needed.

For questions or support, contact hsbSOFT technical support or refer to the hsbCAD user documentation.

---

**Document Version**: 2.0
**Last Updated**: 2026-02-20
**Script Version**: 1.7
**Target Audience**: Timber structure designers, CAD operators, fabrication engineers
