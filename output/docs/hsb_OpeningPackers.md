# hsb_OpeningPackers

Creates reveal boards (packers) or covering boards around wall openings such as windows and doors with full control over positioning, dimensions, and assignment.

## Overview

This script generates sheet entities along the inside faces (reveals) of openings in wall elements, commonly known as packers or reveal liners. Since version 1.3, it can also produce covering boards that sit in front of the opening rather than inside the reveal. Users can control which sides of the opening receive boards (top, bottom, left, right, or any combination), specify independent dimensions for each side, and assign the resulting sheets to a specific wall zone for accurate BOM output. The script supports both manual insertion by selecting individual openings and automated attachment through element or opening details, making it suitable for both one-off adjustments and batch workflows.

The script is particularly useful in timber construction where openings require finished reveal surfaces or external trim boards that integrate with the wall assembly. By allowing independent control of width, thickness, and gaps on each side, the script can accommodate various framing conditions and finish requirements within a single tool.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Model Space | Yes |
| Paper Space | No |
| Version | 1.8 |
| Keywords | opening, Öffnung, packer, Laibungsplatte |

## Prerequisites

1. **Wall element must exist**: The target wall element must already be placed in the drawing with its openings (windows, doors) defined.
2. **Element must be calculated**: When using the "Construction" reference mode, the wall element must have completed its calculation so that framing members (studs, headers, sills) around the opening are present. The script monitors the element's genBeam() array and waits until beams are available.
3. **Openings must be present**: At least one opening entity must exist within the wall element. The script operates on Opening entities, not raw voids.

## Usage Steps

### Manual Insertion

1. **Launch the script**
   - Start the `hsb_OpeningPackers` command from the hsbCAD ribbon, toolbar, or by typing the command at the AutoCAD command line.

2. **Configure in the dialog**
   - A property dialog appears where you can set all parameters before placement.
   - Alternatively, if catalog entries have been saved previously, you can select a stored preset from the catalog list by using the `_kExecuteKey` parameter with a catalog name.
   - Adjust the board type (Packer vs. Covering board), dimensions, gaps, which sides to create, zone alignment, and sheet properties.
   - Press **OK** to confirm the settings.

3. **Select opening(s)**
   - The command line prompts: **"Select opening(s)"**.
   - Click on one or more openings in the model. Each opening will receive its own set of boards based on the configured parameters.
   - Press **Enter** to confirm the selection.

4. **Result**
   - The script creates one TSL instance per selected opening.
   - Sheet entities are generated on the enabled sides of each opening according to the create vertical/horizontal settings.
   - A small text label showing the script name appears near the opening at the wall outline for identification.
   - The text label is placed on layer "T" (tooling layer), making it non-printable.

### Automated Attachment via Element Details

The script can also be attached to elements or openings through the hsbCAD wall detail system. When attached this way:

- The script is triggered automatically during element calculation.
- If attached to an element that contains multiple openings, the script automatically clones itself so that each opening receives its own set of packer boards.
- Properties can be pre-configured through the detail's map input/output (mapIO) system, allowing standardized configurations across a project.
- The mapIO protocol supports PROPSTRING[], PROPINT[], and PROPDOUBLE[] arrays for passing parameter values programmatically.
- When the element is deleted, attached instances are automatically cleaned up via the `_bOnElementDeleted` flag.

### Modifying After Placement

- Select the TSL instance in the drawing and adjust parameters in the **Properties Palette (OPM)**.
- Changes are applied immediately on the next recalculation.
- If the wall element or opening geometry changes (for example, the opening is resized or studs are moved), the packer boards update automatically.
- Previously created sheets are stored in the instance's `_Map` via `setEntityArray()` and are deleted and regenerated on each recalculation to ensure geometry remains current.

## Properties Panel Parameters

### Sheet Definition

| Parameter | Type | Default | Options / Format | Description |
|-----------|------|---------|------------------|-------------|
| **Insert as** | Dropdown | Packer | Packer, Covering board | Defines the position of the boards. **Packers** are placed inside the opening reveal (perpendicular to the wall face). **Covering boards** cover the opening from the outside, sitting flat on the wall surface. This fundamentally changes the board orientation and attachment strategy. |
| **Width** | Text | 100 | Single value or semicolon-separated (top;bottom;right;left) | Width of the board in current drawing units (automatically converted via U() function from mm). A single value applies to all four sides. Use semicolons to set independent widths, for example `120;120;100;100`. For Packers, this controls the depth into the reveal. For Covering boards, this controls the coverage width on the wall face. |
| **Thickness** | Text | 20 | Single value or semicolon-separated (top;bottom;right;left) | Thickness of the board in current drawing units. A single value applies to all four sides. Use semicolons for independent values. For Packers, this is the material thickness perpendicular to the reveal surface. For Covering boards, this is the outward projection from the wall face. |
| **Gap at the ends** | Text | _(empty)_ | Single value or semicolon-separated (top;bottom;right;left) | Gap at the ends of each board, effectively shortening the board. A single value applies to all sides. Use semicolons for independent values. This is useful to avoid boards overlapping at corners. The gap is applied to both ends of the board, so a value of 20 shortens the board by 40 total. |
| **Gap to opening** | Text | _(empty)_ | Single value or semicolon-separated (top;bottom;right;left) | Gap between the board and the edge of the opening. A single value applies to all sides. Use semicolons for independent values. This can be used to inset boards from the opening edge. The gap moves the board away from the opening perimeter. |
| **Sheet properties** | Text | _(empty)_ | Semicolon-separated: ColourIndex;Name;Material;Grade;Information;Label;SubLabel;Beamcode | Sets the sheet entity properties for BOM output and identification. Empty properties need a blank space as placeholder. Example: `2;Packer;OSB; ;on site` sets color to 2, name to "Packer", material to "OSB", skips Grade, and sets Information to "on site". Color range is -1 (ByLayer) to 254. |
| **Assign to zone** | Dropdown | 0 | -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5 | Determines which wall zone the generated sheets are assigned to via `assignToElementGroup()`. This affects BOM grouping and zone-based operations. The assignment uses 'Z' group type (zone-based). |

### Sheet Position

| Parameter | Type | Default | Options / Format | Description |
|-----------|------|---------|------------------|-------------|
| **Zone to align sheet to** | Dropdown | 0 | -5 through 6 | Specifies the wall zone that the sheet is aligned to in the through-wall direction. Negative zones are toward the outside of the wall, positive zones toward the inside. Zone 0 is the structural core. Zone 6 is a special value that aligns to the innermost face of zone 5 (ptOrg + dH for zone 5). This parameter determines the reference plane for positioning the sheet in the Z-direction. |
| **Offset to zone** | Number | 0.0 | Any numeric value in current drawing units | Additional offset from the selected zone in the wall Z-direction. The sign convention: positive values move toward the outside of the wall (negative Z direction in element coordinate system). The offset is applied relative to the zone reference point established by "Zone to align sheet to". |
| **Create a vertical sheet(s)** | Dropdown | None | None, Left, Right, Both | Controls which vertical (side) boards are created. "None" skips both vertical sides. "Left" creates only the left reveal board. "Right" creates only the right reveal board. "Both" creates boards on both the left and right reveals of the opening. The script internally uses an nContunes array to track which sides should be skipped. |
| **Create a horizontal sheet(s)** | Dropdown | None | None, Bottom, Top, Both | Controls which horizontal boards are created. "None" skips both horizontal sides. "Bottom" creates only the bottom (sill) board. "Top" creates only the top (header) board. "Both" creates boards at both the top and bottom reveals. |
| **Reference** | Dropdown | Construction | Construction, Opening | Defines the reference geometry for positioning the boards. **Construction** uses the closest framing beams around the opening (studs, header, sill) as reference edges via `filterBeamsHalfLineIntersectSort()`. **Opening** uses the geometric boundary of the opening entity itself (opening width and height). Construction mode requires that the element has been calculated and beams exist. |
| **Ignore parallel beams** | Dropdown | No | No, Yes | Only relevant when Reference is set to "Construction". When set to "Yes", beams running parallel to the reveal direction are ignored when searching for the nearest framing member via `isParallelTo()` check. This helps in cases where parallel trimmer studs or cripple studs might cause incorrect packer alignment. The script iterates through filtered beams and removes any with `vecX()` parallel to the reveal direction. |

### Behavior of TSL Instance

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Delete TSL after insertion** | Dropdown | No | No, Yes | When set to "Yes", the TSL instance is erased from the drawing after the sheets are created via `eraseInstance()`. The sheets remain as standalone entities but will no longer update when the wall changes. When set to "No", the TSL instance stays in the drawing and the sheets update dynamically whenever the wall or opening is modified during recalculation. This is controlled by checking the flag at the end of the calculation cycle. |

## Right-Click Menu Options

This script does not add custom right-click context menu items. To modify the packer boards after placement, select the TSL instance and use the Properties Palette.

## Settings / Configuration

This script does not use external XML settings files. All configuration is handled through the Properties Panel parameters described above.

**Catalog support**: The script supports the standard hsbCAD catalog system. You can save your current property configuration as a named catalog entry via `setCatalogFromPropValues()` and recall it during future insertions via `setPropValuesFromCatalog()`. Catalog entries are managed through the property dialog that appears on insertion. The `_kExecuteKey` parameter can be used to silently apply a specific catalog entry by name without showing the dialog. This is especially useful for standardizing packer dimensions and material properties across a project.

**Last inserted settings**: The script can optionally load settings from the most recently inserted instance using the `sLastInserted` catalog key, though this behavior is controlled by the `_kExecuteKey` logic and dialog interaction.

## Advanced Features

### Semicolon-Separated Value Parsing

The Width, Thickness, Gap at the ends, and Gap to opening parameters all support semicolon-separated values in the order: **top; bottom; right; left**. The script uses `tokenize(";")` to split the input strings and maps them to an internal ordering array:

- **nOrderArray[]** = { 2, 0, 3, 1 } maps the four reveal directions (top, bottom, right, left) to the internal iteration order
- **Single value** (for example `100`): Applies uniformly to all four sides via array length check
- **Four values** (for example `120;100;80;80`): Sets top=120, bottom=100, right=80, left=80
- **Fewer than four values**: Missing values default to zero via conditional array length checks

The combined gap effect is additive at each end:
- **Total gap at corner** = Gap at ends + Gap to opening for that particular side
- The script calculates `dUsedLength = dLength[i] - dGap1 - dGap2` where dGap1 and dGap2 incorporate both types of gaps

### Geometric Calculation Details

The script performs sophisticated 3D geometry calculations to position sheets correctly:

1. **Element coordinate system**: Extracted via `el.coordSys()` providing ptOrg, vecX, vecY, vecZ
2. **Opening coordinate system**: Extracted via `op.coordSys()` providing opening-local vectors
3. **Mid-plane reference**: Calculated as `ptZ0Mid = el.zone(0).ptOrg() + vecZ * 0.5 * el.zone(0).dH()` to establish the structural centerline
4. **Height vectors**: Defined as { vecXOp, vecYOp, -vecXOp, -vecYOp } for the four reveal directions
5. **Length vectors**: Defined as { vecYOp, vecXOp, vecYOp, vecXOp } perpendicular to each reveal

For **Construction reference mode**:
- Uses `filterBeamsHalfLineIntersectSort()` to find beams intersecting a ray from opening center in the reveal direction
- Extracts beam center via `ptCen()` and beam depth via `dD(vecHeight[i])`
- Calculates packer reference point as beam face minus projection offsets
- Falls back to Opening mode if no beams are found

For **Opening reference mode**:
- Uses opening dimensions directly: `dOpDiams[] = { 0.5 * op.width(), 0.5 * op.height() }`
- Positions boards at opening perimeter plus gap offsets

### Sheet Creation and Transformation

The script creates sheets differently based on Packer vs. Covering board mode:

**For Packers (nFunction == 0)**:
1. Sheet is created with orientation perpendicular to wall face
2. Uses `Sheet.dbCreate(ptSh, vecL, vecHeight[i], -nSign * vecZ, dUsedLength, dWidths, dHeights)`
3. Applies 90-degree rotation via `CoordSys.setToRotation(90, vecLength[i], ptSh)` to orient into reveal
4. Transforms sheet via `sh.transformBy(csSh)` to final position

**For Covering boards (nFunction == 1)**:
1. Sheet is created parallel to wall face
2. No rotation transformation applied
3. Thickness extends outward from wall surface

### Zone Alignment Logic

The script implements complex zone alignment with sign handling:

```
int nSign = -1;  // Default for outside zones

if (nZone > 0) {
    // Inside zones
    if (nZone == 6)
        ptZRef += vecZ * el.zone(nZone-1).dH();  // Special: inner face of zone 5
    nSign = 1;
} else if (nZone < 0) {
    // Outside zones
    ptZRef -= vecZ * el.zone(nZone).dH();
}
```

The offset direction is controlled by `nSign`, ensuring that positive offset values consistently move toward the outside regardless of zone sign.

### Multi-Opening Cloning

When the script is attached to an Element entity (rather than a specific Opening) and the element contains multiple openings:

1. Script detects `_Entity[0].bIsKindOf(Element())`
2. Extracts all openings via `Opening ops[] = el.opening()`
3. If `ops.length() > 1`, enters cloning mode
4. Creates new TSL instance for each opening via `tslNew.dbCreate()`
5. Each instance receives identical property values from the parent
6. Parent instance erases itself via `eraseInstance()` after successful cloning

This automatic cloning ensures that element-level detail attachments correctly apply packer boards to all openings without manual per-opening setup.

### Error Handling and Validation

The script includes several validation checks with user feedback:

1. **No openings found**: Reports "could not find reference to element" and erases instance
2. **Insufficient beams**: Reports "could not find beams around opening" and erases instance (Construction mode only)
3. **Gap too large**: Reports "Opening is to small or gap is to big" and skips the affected side if `dUsedLength < dEps` (dEps = 0.1mm)
4. **Invalid color index**: Clamps color to range -1 to 254 via bounds check
5. **Waiting for construction**: Script returns early without error if `el.genBeam().length() < 1` in Construction mode, allowing element to complete calculation

### Debug Mode Support

The script implements the standard hsbCAD debug controller pattern:

```c
int bDebug = _bOnDebug;
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
if (mo.bIsValid()) {
    Map m = mo.map();
    for (int i=0; i<m.length(); i++)
        if (m.getString(i) == scriptName())
            bDebug = true;
}
if (bDebug)
    reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
```

When debug mode is enabled, the script reports its execution start with instance handle for troubleshooting.

## Tips and Best Practices

### Choosing Between Packer and Covering Board

- Use **Packer** mode for boards that line the inside of the opening reveal (the depth between the wall face and the window or door frame). These boards are oriented perpendicular to the wall face and fill the reveal cavity. Typical applications include OSB or plywood reveal liners that provide a nailing surface for interior trim or create a thermal break.

- Use **Covering board** mode for trim boards that sit flat on the wall surface around the opening perimeter, covering the junction between the wall finish and the opening. These boards are oriented parallel to the wall face. Typical applications include exterior casing, brick mold, or decorative trim that extends beyond the opening edge.

### Using Semicolon-Separated Values

The Width, Thickness, Gap at the ends, and Gap to opening parameters all support semicolon-separated values in the order: **top; bottom; right; left**. This allows you to specify different dimensions for each side of the opening independently:

- **Single value** (for example `100`): Applies uniformly to all four sides.
- **Four values** (for example `120;100;80;80`): Sets top=120, bottom=100, right=80, left=80.
- **Fewer than four values**: Missing values default to zero. For example, `120;100` sets top=120, bottom=100, right=0, left=0. This can be used to selectively disable specific sides.

**Example**: To create packers only on the left and right sides with different widths:
- Width: `0;0;100;120` (no top/bottom, 100mm right, 120mm left)
- Create vertical: Both
- Create horizontal: None

### Managing Corner Overlaps

When creating boards on multiple sides, the boards at the corners may overlap. Use the **Gap at the ends** parameter to shorten boards so they meet cleanly at the corners. For example, if you want the horizontal boards (top and bottom) to run the full width and the vertical boards (left and right) to fit between them, set the "Gap at the ends" for the vertical boards to match the thickness of the horizontal boards.

**Example calculation**:
- Horizontal board thickness: 20mm
- Set vertical "Gap at the ends": 20 (will shorten by 20mm at each end)
- Result: Vertical boards will be 40mm shorter total (20mm at each end), creating a clean miter-like junction

The combined gap effect is additive: the total shortening at each end is the sum of the "Gap at the ends" value and the "Gap to opening" value for that particular corner. For instance:
- Gap at ends: 20mm
- Gap to opening: 5mm
- Total shortening at each end: 25mm

### Reference Mode Selection

- **Construction** mode references the actual framing members (studs, header beam, sill plate) around the opening. This is more accurate when framing members are offset from the opening edge, but requires that the wall element has been calculated first so that beams exist around the opening. The script will wait (return early without error) until beams are available.

- **Opening** mode references the geometric opening boundary directly. This is simpler and works even before the wall framing is calculated, but may not account for framing member offsets or trimmer stud positions. It uses the theoretical opening dimensions rather than actual built conditions.

**When to use Construction mode**:
- Opening has complex framing (multiple trimmers, king studs)
- Framing is offset from opening edge due to rough opening sizing
- Packers need to align precisely with stud faces for attachment
- Element calculation is already complete

**When to use Opening mode**:
- Quick placement before element calculation
- Simple openings where framing matches opening edge
- Covering boards where precise framing alignment is not critical
- You want consistent positioning regardless of framing variations

If your packers appear too short or too long relative to the actual reveal depth, try switching between these two modes.

### Handling Parallel Beams

When using Construction reference mode, the script finds the nearest beam on each side of the opening using `filterBeamsHalfLineIntersectSort()`. In some framing configurations, a beam running parallel to the reveal direction (such as a doubled trimmer stud or cripple stud) may be detected instead of the intended perpendicular framing member.

Enable **Ignore parallel beams** (set to "Yes") to skip these parallel members and locate the correct perpendicular framing reference. The script uses `vecX().isParallelTo(vecHeight[i])` to identify and remove parallel beams from the candidate list.

**Common scenarios requiring this setting**:
- Doubled trimmer studs (two studs side-by-side at opening edge)
- Cripple studs above or below the opening
- Blocking or nailers running parallel to the reveal
- Multi-ply headers with stacked members

### Persistent vs. One-Shot Placement

- Set **Delete TSL after insertion** to **"No"** (default) if you want the packer boards to remain parametric and update automatically when the wall or opening changes. This is recommended for active design phases where geometry is still evolving. The sheets will regenerate on every element recalculation, ensuring they remain accurate.

- Set it to **"Yes"** if you want to create static sheet entities that do not update. This is useful for final production output or when you plan to manually adjust the sheets afterward. The TSL instance is removed after creating the sheets, leaving only the Sheet entities in the drawing.

**Performance consideration**: In large projects with many openings, parametric instances (Delete = No) will add to recalculation time. For final production drawings, consider setting Delete = Yes to improve performance.

### Element Detail Workflow

For production projects, consider attaching this script to wall element details rather than inserting it manually on each opening. This approach provides several advantages:

- **Consistency**: All openings in the wall automatically receive packer boards during element calculation with identical settings
- **Efficiency**: A single detail attachment handles all openings in the wall without additional user action
- **Automation**: Automatic updates occur when the wall is recalculated, without manual re-insertion
- **Standardization**: Project-wide standards can be enforced through detail library entries

**Setup procedure**:
1. Configure the script properties in the element detail using mapIO protocol
2. Set PROPSTRING[], PROPINT[], and PROPDOUBLE[] arrays in the detail's map
3. Attach the detail to wall elements or opening types
4. Script will automatically clone itself for multiple openings via `TslInst.dbCreate()` loop

When attached to an element with multiple openings, the script automatically creates separate instances for each opening. A single detail attachment therefore handles all openings in the wall without any additional user action.

### Sheet Properties String Format

The **Sheet properties** parameter expects a semicolon-separated string with up to eight fields:

| Position | Field | Example | Notes |
|----------|-------|---------|-------|
| 1 | Colour Index | `2` | Valid range: -1 to 254, where -1 means ByLayer. Invalid values are clamped to range. |
| 2 | Name | `Packer` | Sheet name for BOM grouping |
| 3 | Material | `OSB` | Material description |
| 4 | Grade | ` ` | Material grade (blank space to skip) |
| 5 | Information | `on site` | Additional info field |
| 6 | Label | `P1` | Primary label for identification |
| 7 | Sub Label | _(empty)_ | Secondary label (can be omitted) |
| 8 | Beam Code | `PKR` | Custom beam code for filtering |

**Parsing rules**:
- Unused fields at the end can be omitted entirely
- Fields in the middle that should remain empty must contain at least a blank space character as a placeholder to maintain correct field ordering
- The script pads the array to 9 elements via `for (int i=sPropArray.length()-1; i<9; i++)` to prevent index errors

**Example strings**:
- Full specification: `2;Packer;OSB;Grade A;on site;P1;A;PKR`
- Skip grade and sub-label: `2;Packer;OSB; ;on site;P1; ;PKR`
- Minimal: `2;Packer;OSB` (remaining fields will be empty strings)

### Zone Assignment Strategy

The **Assign to zone** parameter determines BOM grouping and zone-based operations. Strategic zone assignment helps organize packer boards in the material takeoff:

- **Zone 0** (default): Assigns to structural core - suitable for reveal boards that are part of the rough opening assembly
- **Negative zones**: Assigns to exterior zones - suitable for exterior trim or casing boards
- **Positive zones**: Assigns to interior zones - suitable for interior finish reveal boards
- **Match finish zone**: If packers coordinate with a specific wall finish layer, assign to that zone's number for consistent BOM grouping

The assignment uses `assignToElementGroup(el, true, nAsignZone, 'Z')` which links sheets to the specified zone with 'Z' group type (zone-based).

### Troubleshooting Common Issues

**Problem**: Packers appear at incorrect depth
- **Solution**: Check "Zone to align sheet to" and "Offset to zone" settings. Verify zone numbering matches your wall assembly. Try adjusting offset incrementally.

**Problem**: Script reports "could not find beams around opening"
- **Solution**: Element has not completed calculation. Wait for element to calculate, or switch Reference mode to "Opening" for immediate placement.

**Problem**: Script reports "Opening is to small or gap is to big"
- **Solution**: Total gaps (Gap at ends + Gap to opening) exceed the board length. Reduce gap values or increase opening size.

**Problem**: Boards overlap at corners
- **Solution**: Use "Gap at the ends" to shorten boards. Set gap equal to adjacent board thickness for clean miters.

**Problem**: Packers reference wrong beams (parallel framing)
- **Solution**: Enable "Ignore parallel beams" to skip trimmer studs and cripple studs.

**Problem**: Boards don't update when opening moves
- **Solution**: Check that "Delete TSL after insertion" is set to "No". If set to "Yes", TSL instance was removed and sheets are now static.

**Problem**: Wrong boards created (left instead of right, etc.)
- **Solution**: Verify "Create a vertical sheet(s)" and "Create a horizontal sheet(s)" dropdown settings match your intent.

**Problem**: Boards appear on wrong side of wall
- **Solution**: Check zone alignment settings. Negative "Offset to zone" may be needed, or different "Zone to align sheet to" value.

## Technical Notes

- The script creates **Sheet** entities, not GenBeam (timber member) entities. Sheets appear in the BOM as paneling or sheeting material and are treated differently from structural framing members.

- When the script is attached to an Element (rather than a specific Opening) and the element contains multiple openings, the script automatically clones itself to produce one instance per opening. This cloning is handled transparently during recalculation via the `TslInst.dbCreate()` loop at lines 286-297.

- The script stores references to created sheets internally via `_Map.setEntityArray(entsSh, false, "Sheet", "Name", "Entry")`. On each recalculation, previously created sheets are deleted via `_Map.getEntityArray()` retrieval and `dbErase()` loop, then regenerated from scratch to reflect any geometry changes.

- A small text label with the script name is drawn near the opening at the wall outline using `Display.draw()`. This label is placed on layer "T" (tooling layer via `dp.elemZone(el, 0, 'T')`) and does not appear on printed output or plot results.

- Zone alignment follows the standard hsbCAD zone numbering convention: negative zones are toward the outside of the wall, positive zones toward the inside, and zone 0 is the structural core. Zone 6 is a special value that aligns the board to the inner face of zone 5 via `ptZRef += vecZ * el.zone(nZone-1).dH()`.

- The offset direction follows the wall Z-axis convention: positive offset values move the board toward the outside of the wall (element coordinate system has Z pointing outward).

- The script supports the hsbCAD mapIO protocol, meaning it can receive property values programmatically from parent scripts or element detail configurations without requiring interactive user input. The protocol checks for `_bOnMapIO`, `_bOnElementDeleted`, and `_bOnElementConstructed` flags.

- If the calculated board length becomes zero or negative (because the opening is too small for the specified gap values), the script reports the warning message "Opening is to small or gap is to big" at the command line via `reportMessage()` and skips the affected side via `continue` rather than creating an invalid board.

- The script requires at least one framing beam on each side of the opening when using Construction reference mode. If suitable beams cannot be found via `filterBeamsHalfLineIntersectSort()`, the script falls back to the opening boundary geometry. If no valid reference can be established at all, the script reports an error message and erases itself via `eraseInstance()`.

- The script unit is set to millimeters internally via `U(1,"mm")`, but all dimension values entered by the user are interpreted in the current drawing units thanks to the standard hsbCAD unit conversion system using `U()` wrapper function.

- The script uses `dEps = U(.1)` as a tolerance value for geometric comparisons and length validation. Board lengths less than 0.1mm are considered invalid.

- Text display uses `dp.textHeight(U(30))` to set 30mm text height, ensuring readability at typical drawing scales.

- The script implements insert cycle counting via `insertCycleCount() > 1` check to prevent infinite recursion during interactive insertion with multiple entities.

- Visual debugging is supported via `.vis()` calls on Point3d objects (lines 339, 349, 457, 463) which are active during development but do not affect production behavior.

- The internal `nOrderArray[] = {2, 0, 3, 1}` maps user-facing "top, bottom, right, left" parameter ordering to the script's internal iteration order based on reveal direction vectors.

- Sheet transformation for Packer mode uses `CoordSys.setToRotation(90, vecLength[i], ptSh)` which rotates the sheet 90 degrees around the length vector axis, effectively orienting it perpendicular to the wall face and into the reveal cavity.

- The script calculates sheet insertion point with careful geometric projection: `ptSh = ptsPackers[i] + vecL * (vecL.dotProduct(ptsPackers[nI] - ptsPackers[i]) - 0.5 * (dLength[i] + dGap1 - dGap2)) - vecH * dOpGaps[nOrderArray[i]]` which positions the sheet center accounting for both end gaps and opening gaps.

- Version history tracking is maintained in both `#BeginDescription` header and inline XML `<History>` tags, following hsbCAD documentation standards.

## Version History

| Version | Date | Description | Author |
|---------|------|-------------|--------|
| 1.8 | 21.02.2023 | HSB-17931: Bugfix ignore parallel beams | Nils Gregor |
| 1.7 | 16.02.2023 | HSB-17931: Bugfix wait for genBeam of elements | Nils Gregor |
| 1.6 | 12.02.2023 | HSB-17931: Await element construction and add properties to define base points | Nils Gregor |
| 1.5 | 22.06.2021 | HSB-12291: Assign text to layer "T" not printable | Marsel Nakuci |
| 1.4 | 15.01.2021 | HSB-10022: Add mapIO, don't always load properties from lastInserted | Marsel Nakuci |
| 1.3 | 21.06.2020 | HSB-7977: Add option covering board | Nils Gregor |
| 1.2 | 28.04.2020 | HSB-6678: Added German description | Nils Gregor |
| 1.1 | 11.03.2020 | HSB-6678: Changed some texts for translation | Nils Gregor |
| 1.0 | 11.03.2020 | HSB-6678: Initial release | Nils Gregor |

## Related Tools

- **Opening**: The core opening entity that this script operates on
- **Element**: Wall element containing openings and framing
- **Sheet entities**: The output objects created by this script
- **hsbCAD Element Details**: System for attaching scripts to elements
- **Zone management tools**: For configuring wall zone definitions
- **BOM extraction tools**: For reporting material quantities from assigned sheets
