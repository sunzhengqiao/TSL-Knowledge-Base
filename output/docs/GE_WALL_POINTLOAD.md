# GE_WALL_POINTLOAD

## Overview

GE_WALL_POINTLOAD is a parametric structural reinforcement tool designed for North American stick-frame wall construction. It automatically creates king stud assemblies at concentrated load points (such as where beams, ridges, or other structural members transfer vertical loads into walls) and provides visual indicators to mark these critical load locations.

The script operates as an intelligent, recalculating entity attached to a wall element. When inserted, it analyzes the wall framing, automatically removes or cuts interfering studs, creates the required number of king studs, stretches them between the top and bottom plates, and maintains this configuration dynamically as the wall is modified.

Developed specifically for imperial units (inches) and integrated with the hsbCAD Framing Defaults Editor, the tool ensures that newly created studs inherit correct lumber dimensions, material grades, and structural properties from the project's lumber catalog.

**Key Capabilities:**
- Automatic creation of 1-6 king studs at point load locations
- Intelligent interference management (cuts/removes conflicting framing)
- Dynamic stretching to top and bottom plates
- Parametric updates when wall geometry changes
- Visual load indicators (text label or X marker)
- Integration with lumber catalog for material properties

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D `ElementWall` entities and creates physical studs. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Model generation tool, not for drawing annotation. |

**Technical Details:**
- **Script Type:** Type O (Object) — Attaches to wall element, recalculates on element changes
- **Unit System:** Imperial (inches) — Script calls `Unit(1,"inch")` internally
- **Version:** 1.13 (November 3, 2013)
- **Beams Required:** 0 (selects walls, not beams)
- **Developer:** David Rueda (dr@hsb-cad.com)

---

## Prerequisites

Before using GE_WALL_POINTLOAD, ensure the following conditions are met:

### 1. Wall Requirements
- **At least one stick-frame wall element** must exist in the model
- The wall must contain **framed structural members** (studs and plates)
- **Top and bottom plates must be present** — studs are automatically stretched between these plates
- The wall should **not have empty framing** (if no beams exist, script enters display-only mode)

### 2. Geometric Constraints
- The insertion point **must not overlap window/door openings** or header beams
- Sufficient space must be available along the wall length to accommodate the stud group
- The point load location is automatically clamped away from wall ends to keep studs inside panel boundaries

### 3. Software Requirements
- **hsbCAD Framing Defaults Editor** must be configured with valid lumber items
- Required DLL: `hsbFramingDefaults.Inventory.dll` located at:
  ```
  [Installation Path]\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll
  ```
- At least one lumber item in the catalog must have **width and height greater than zero**

### 4. Drawing Setup
- Drawing must have at least one dimension style defined (for text/marker display)
- Recommended: Configure color standards for new studs (default is color 2 / yellow)

---

## Usage Steps

### Step 1: Launch the Script
**Command:** `TSLINSERT` → Select `GE_WALL_POINTLOAD.mcr`

Alternatively, double-click the script in the hsbCAD tool palette or use the appropriate toolbar button if configured.

### Step 2: Select Wall Elements
```
Command Line Prompt: "Select a set of Walls"
Action: Click one or more wall elements that will receive the point load reinforcement.
```

**Notes:**
- Only entities of type `Wall` are accepted
- Non-wall entities in the selection set are automatically ignored
- Multiple walls can be selected — one independent instance is created per wall

### Step 3: Pick Insertion Point
```
Command Line Prompt: "Select an insertion point"
Action: Click the location along the wall face where the point load bears down.
```

**How the Point is Processed:**
- The script automatically snaps the point to the wall centerline
- The position is clamped inward from both wall ends by half the total stud group width
- This ensures all studs remain fully within the panel boundary
- The final position is stored as `_Pt0` and becomes the parametric anchor

### Step 4: Configure Parameters
A dialog appears showing all adjustable properties:
- Number of studs (1-6)
- Lumber item selection
- Stud color
- Display mode (text label vs. X marker)
- Dimension style
- Text offset

Review and adjust parameters, then click **OK** to confirm or **Cancel** to abort.

### Step 5: Result
The script creates:
- **King studs:** The specified number of vertical studs at the load location, automatically stretched to plates
- **Visual indicator:** Either a text label (e.g., "3x") or an X marker at the insertion point
- **Interference cleanup:** Any conflicting studs are automatically removed or cut

**Multiple Walls:** If you selected multiple walls in Step 2, an independent instance is created for each wall at the same nominal insertion point.

---

## Properties Panel (OPM Parameters)

All parameters are editable at any time through the AutoCAD Properties Palette. Changes trigger immediate recalculation.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Number of Beams in Point Load** | Integer (dropdown) | 1 | 1, 2, 3, 4, 5, 6 | How many king studs to create side-by-side at the point load location. Each stud uses the standard stud width from the selected lumber item. More studs = greater load capacity. |
| **Lumber item** | String (dropdown) | Second item in catalog | (populated from Framing Defaults Editor) | The lumber size, species, material, and grade for the new king studs. This dropdown reads directly from the hsbCAD Framing Defaults inventory. The selected item controls `dBeamWidth`, `dBeamHeight`, `sBeamMaterial`, and `sBeamGrade`. |
| **Color for new Beams** | Integer | 2 (yellow) | -1 to 255 (ACI color index) | AutoCAD color index applied to all created studs. Use -1 for ByLayer, 1 for red, 2 for yellow, etc. Invalid values (outside -1 to 255) are automatically reset to -1. |
| **What display to use** | String (dropdown) | Identify with Text | "Identify with Text", "Mark Location with an X" | Controls the graphical marker drawn at the load position. **"Identify with Text"** displays the stud count as text (e.g., "2x") centered below the group. **"Mark Location with an X"** draws two diagonal lines forming an X across the full width of the stud group. |
| **DimStyle** | String (dropdown) | First dimension style | (populated from drawing) | AutoCAD dimension style applied when drawing the text label or X marker. Controls text font, size, and appearance. |
| **Offset text from wall** | Double | 7 inches | >0 | Vertical distance (perpendicular to the wall face, downward from the bottom plate line) by which the text label is offset. Only affects "Identify with Text" display mode. Larger values move the text further below the wall. |

### Parameter Dependencies

**Important Relationships:**
- Changing **Number of Beams in Point Load** causes all studs to be erased and recreated
- Changing **Lumber item** triggers complete stud regeneration with new dimensions
- **Color for new Beams** applies only to newly created studs (does not affect existing studs unless regenerated)
- **What display to use** switches between text and X marker modes immediately
- **Offset text from wall** has no effect when "Mark Location with an X" is selected

---

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Re-Create Point Load** | Forces a complete reconstruction of all king studs and interference management. Use this command when: <br>• You have manually modified surrounding framing members <br>• Adjacent studs have been added or moved <br>• The wall has been stretched or modified <br>• You need to re-evaluate interference with existing beams <br><br>This option triggers the same logic as `_bOnElementConstructed` and `_bOnDbCreated`, including: <br>• Erasing all previously created studs stored in `_Map.Studs` <br>• Re-scanning for interfering beams <br>• Re-applying cut operations to adjacent members <br>• Regenerating the complete stud set from scratch <br>• Cleaning up obsolete beam references in the entity map |

**When to Use Re-Create:**
- After wall reconstruction or framing regeneration
- When interference patterns have changed
- If studs appear misaligned with plates
- To reset the tool after manual edits to surrounding framing

---

## Workflow Details

### Automatic Interference Management

When studs are created (during insertion or when using "Re-Create Point Load"), the script intelligently handles interfering beams:

#### 1. Perpendicular Beams (Blocking, Bracing)
**Condition:** Beams running perpendicular to the wall face (parallel to wall Y axis) that fall within the stud group footprint.

**Action:** Completely erased.

**Logic:** These beams would conflict with the vertical king studs and are removed entirely.

#### 2. Parallel Beams (Edge Intersection)
**Condition:** Beams running parallel to the wall face that partially intersect the left or right boundary of the stud group.

**Action:** Cut at the boundary using a static `Cut` tool.

**Result:** The beam terminates cleanly at the edge of the new studs. Only one side of the beam remains.

**Implementation:**
- Left boundary beams are cut with `ct1 = Cut(_Pt0 - dPLW/2*vx, vx)`
- Right boundary beams are cut with `ct2 = Cut(_Pt0 + dPLW/2*vx, -vx)`

#### 3. Beams Spanning Full Width
**Condition:** Beams that intersect both the left and right boundaries of the stud group.

**Action:** The beam is split into two copies:
- **Left copy:** Cut at the right boundary (kept on the left side)
- **Right copy:** Cut at the left boundary (kept on the right side)

**Tracking:** References to both halves are stored in the entity map:
- Left segments → `_Map["BlockL"]`
- Right segments → `_Map["BlockR"]`

**Cleanup:** If the point load is moved or re-created, these stored references are checked. Invalid or obsolete cuts are cleaned up.

#### 4. Close Parallel Beams (Auto-Shift)
**Condition:** Beams parallel to the wall face whose center is between 0.5× and 1.25× the stud group half-width from the insertion point.

**Action:** The beam is automatically shifted outward by the minimum distance needed to clear the stud group (plus 0.75" clearance).

**Purpose:** Avoids deleting beams that are very close but not directly intersecting.

### Stud Creation and Stretching

#### Creation Process
1. **Calculate stud positions:** Starting from `ptInsert - (dPLW - dW)/2 * vx`, studs are placed at 1.5" on-center spacing
2. **Create beams:** Each stud is created with:
   - Length: Initially 1" (arbitrary small value)
   - Width: From selected lumber item
   - Height: From selected lumber item
   - Orientation: Along wall Y axis (vertical)
   - Type: `_kStud`
   - Module: `"PL-" + dModule` (unique identifier based on distance from wall origin)

3. **Set properties:**
   - Color: From `nColor` parameter
   - Material: From lumber item catalog
   - Grade: From lumber item catalog
   - Panhand: Attached to parent wall element
   - Element group: Assigned to wall with type 'Z'

4. **Store references:** All created studs are saved to `_Map.Studs` as `bm1`, `bm2`, etc.

#### Automatic Stretching
After creation, each stud is dynamically stretched to reach the nearest plates:

**Algorithm (per stud, per direction):**
```
For each stud:
  For positive and negative height directions:
    1. Cast a half-line from stud center in that direction
    2. Filter wall beams to find those typed as plates
    3. Sort hits by distance from stud center
    4. Take the first (closest) plate beam
    5. Stretch the stud end to that plate face using stretchDynamicTo()
```

**Plate Types Recognized:**
- `_kSFBottomPlate`
- `_kSFTopPlate`
- `_kSFAngledTPLeft`
- `_kSFAngledTPRight`
- `_kSFVeryTopPlate`
- `_kTopPlate`
- `_kBottom`
- Beams with hsbId "31", "32", or "4"

**Result:** Studs automatically adjust to wall height and accommodate angled top plates.

### Opening Conflict Detection

Before creating studs, the script checks for header beams (window/door openings):

#### Detection Method
For each header beam in the wall:
1. Get the beam's start and end points along the wall X axis
2. Check if the header spans across the left or right boundary of the stud group
3. Use dot product comparisons to determine overlap

#### Conflict Response
If overlap is detected:
- **Warning message:** `"Too close to opening. Cannot position PointLoad on Opening on wall [number]"`
- **Visual feedback:** Red rectangles (color 1) are drawn showing where studs would have been placed
- **No geometry created:** The script returns without creating physical studs
- **Diagnostic display:** Red X markers indicate the conflict

#### Resolution
- Move the insertion point away from the opening
- Use the entity grip to reposition the point load
- Run "Re-Create Point Load" from the right-click menu

### Display Modes

#### Mode 1: Identify with Text
**Appearance:** Text label displaying the number of studs (e.g., "2x", "3x", "4x")

**Position:** Centered horizontally on the stud group, offset vertically below the wall bottom plate by the "Offset text from wall" distance

**Anchor:** The text position becomes `_Pt0` for grip editing

**Use case:** Standard annotation for shop drawings and framing plans

#### Mode 2: Mark Location with an X
**Appearance:** Two diagonal polylines crossing at the insertion point, spanning the full width and thickness of the stud group

**Lines:**
- Diagonal 1: From bottom-left to top-right
- Diagonal 2: From bottom-right to top-left

**Anchor:** The center of the X becomes `_Pt0` for grip editing

**Use case:** Quick visual reference when text labels would clutter the view

#### Mode 3: Display-Only (Automatic)
**Trigger:** Activated automatically when the selected wall has no framed beams or all beams are panhandled assemblies

**Appearance:** Rectangular outlines (not solid beams) showing where studs would be created, drawn in the current display color

**Purpose:** Lets designers preview the point load intent before the wall is fully framed

**Limitation:** No physical geometry is created; this is purely visual feedback

### Module Labeling

Each created king stud receives a unique module identifier:

**Format:** `"PL-" + dModule`

Where `dModule = abs(el.vecX().dotProduct(el.ptOrg() - _Pt0))`

**Meaning:** The absolute distance (along wall X axis) from the wall origin to the insertion point

**Purpose:**
- All studs in the same point load group share the same module label
- Enables grouping in BOM exports
- Aids in shop drawing organization
- Identifies load-bearing components distinct from regular wall studs

**Example:** A point load at 48" from the wall origin produces module `"PL-48.000"`

---

## Settings Files and External Dependencies

### Required DLL
**File:** `hsbFramingDefaults.Inventory.dll`

**Location:**
```
[Installation Path]\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll
```

**Purpose:** Provides access to the lumber catalog configured in the hsbCAD Framing Defaults Editor

**Class/Method:**
- **Namespace:** `hsbSoft.FramingDefaults.Inventory.Interfaces`
- **Class:** `InventoryAccessInTSL`
- **Method:** `GetLumberItems`

**Input (Map):**
- `CompanyPath`: Company-specific content folder path
- `StickFramePath`: Stick-frame detail folder path
- `InstallationPath`: hsbCAD installation root path

**Output (Map):**
- Array of lumber items, each with:
  - `NAME`: Display name (e.g., "2x6 SPF No.2")
  - `WIDTH`: Beam width in drawing units
  - `HEIGHT`: Beam depth in drawing units
  - `HSB_MATERIAL`: Material code (e.g., "SPF")
  - `HSB_GRADE`: Grade code (e.g., "No.2")

### Data Validation
The script performs validation before creating studs:

**Check:**
```c
if (dBeamWidth <= 0 || dBeamHeight <= 0) {
    reportNotice("Data incomplete, check values for selected lumber item");
    eraseInstance();
}
```

**Error Message Content:**
- Material: [value from catalog]
- Grade: [value from catalog]
- Width: [value from catalog]
- Height: [value from catalog]

**Resolution:** Open the hsbCAD Framing Defaults Editor and correct the lumber item data.

---

## Tips & Best Practices

### Positioning Strategy
**Recommended workflow:**
1. Frame the wall completely first (studs, plates, blocking)
2. Insert the point load tool at the desired location
3. Let the script handle interference automatically
4. Use "Re-Create Point Load" only if manual edits are made afterward

**Why:** The automatic interference detection works best when the wall framing is complete.

### Multiple Walls
When inserting on multiple walls simultaneously:
- Each wall receives an **independent instance**
- All instances share the same parameter values from the insertion dialog
- Each instance recalculates independently based on its own wall geometry
- Different walls can have different heights, framing patterns, and plate configurations

**Use case:** Applying the same point load to a multi-panel wall assembly in one operation.

### Grip Editing
After insertion, you can reposition the point load using AutoCAD grips:
- **Text mode:** Drag the text label along the wall face
- **X marker mode:** Drag the center of the X

**Constraints:**
- Movement is constrained to the wall's X axis
- Position is automatically clamped to keep studs inside the panel
- The stud group and indicator update dynamically as you drag

### Color Management
**Default behavior:** New studs are created in color 2 (yellow)

**Best practice:**
- Set `Color for new Beams` to -1 (ByLayer) to respect layer color standards
- Or use a project-specific color code for load-bearing members

**Color restrictions:** Values outside -1 to 255 are automatically reset to -1

### Lumber Item Selection
**Critical:** The selected lumber item must have valid width and height values in the catalog.

**Common issue:** Empty or zero-dimension lumber items cause script failure

**Solution:**
1. Open hsbCAD → Settings → Framing Defaults Editor
2. Navigate to Lumber Items
3. Verify that all items have Width > 0 and Height > 0
4. Save the catalog and reload the script

### BOM Integration
King studs created by this script:
- Appear in wall BOM exports
- Are tagged with the unique module identifier `"PL-[distance]"`
- Can be filtered/sorted by module for takeoff reports
- Inherit material and grade from the lumber catalog

**Recommendation:** Use BOM filters to separate point load studs from regular wall studs for accurate material takeoffs.

### Structural Engineering Coordination
This tool creates **framing geometry only**. It does not:
- Perform structural calculations
- Verify load capacity
- Generate engineering reports

**Required:** Coordinate with structural engineer to determine:
- Number of king studs required (1-6)
- Appropriate lumber species and grade
- Additional hardware requirements (not handled by this script)

### Revision Workflow
If you need to modify a point load after insertion:

**Option 1: Edit properties** (for parameter changes)
- Select the instance
- Modify values in the Properties Palette
- Changes apply immediately

**Option 2: Re-Create Point Load** (for geometry reset)
- Right-click the instance
- Choose "Re-Create Point Load"
- All studs and interference management are regenerated

**Option 3: Delete and re-insert** (for major changes)
- Erase the instance
- Run the script again
- Select new parameters

---

## Troubleshooting

### Problem: No Studs Created, Red Marker Displayed

**Possible Causes:**
1. **Opening conflict:** The insertion point overlaps a header beam
2. **Empty wall:** The wall has no framed beams
3. **All panhandled beams:** Every beam in the wall is part of an assembly

**Diagnosis:**
- Check the command line for warning messages
- Look for red rectangles or X markers indicating conflict
- Use the "Re-Create Point Load" option after fixing the issue

**Solutions:**
- **For opening conflicts:** Move the insertion point away from windows/doors using the grip
- **For empty walls:** Complete wall framing first, then re-insert
- **For panhandled beams:** Not a valid use case; use on normally framed walls

### Problem: Studs Not Stretching to Plates

**Possible Causes:**
1. **Missing plates:** The wall has no top or bottom plate beams
2. **Incorrect plate types:** Plates are not typed correctly in the beam properties
3. **Plate filtering issue:** Plates have incorrect hsbId codes

**Diagnosis:**
- Select a plate beam and check its Type property
- Verify hsbId is "31", "32", or "4" (or beam type is one of the recognized plate types)

**Solutions:**
- Correct beam types in the Properties Palette
- Re-run wall framing generation
- Use "Re-Create Point Load" to re-evaluate plate connections

### Problem: Lumber Item Validation Error

**Error Message:**
```
Data incomplete, check values for selected lumber item
Material: [value]
Grade: [value]
Width: [value]
Height: [value]
```

**Cause:** The selected lumber item has width ≤ 0 or height ≤ 0 in the catalog

**Solution:**
1. Note the material and grade shown in the error message
2. Open hsbCAD → Settings → Framing Defaults Editor
3. Find the lumber item in the catalog
4. Enter valid Width and Height values (in inches)
5. Save the catalog
6. Re-insert the script

### Problem: Color Not Applied to Studs

**Possible Causes:**
1. **Invalid color value:** Color parameter is outside -1 to 255 range
2. **ByLayer override:** Color is set to -1 (ByLayer) and layer has a different color
3. **Manual color change:** Studs were manually recolored after creation

**Solutions:**
- Check `Color for new Beams` parameter (valid range: -1 to 255)
- If using ByLayer (-1), check the wall's layer color setting
- Use "Re-Create Point Load" to regenerate studs with current color parameter

### Problem: Interference Management Not Working

**Symptoms:**
- Studs overlap with existing blocking
- Adjacent beams are not cut
- Duplicate beams appear

**Diagnosis:**
- Check if "Re-Create Point Load" has been run recently
- Verify the wall has been reconstructed after manual edits

**Solutions:**
- Always use "Re-Create Point Load" after manual framing changes
- Avoid manually editing beams stored in the entity map
- If problems persist, delete the instance and re-insert

### Problem: Dialog Not Appearing During Insertion

**Cause:** The `showDialogOnce()` call is not executing

**Quick fix:**
- Complete the command line prompts (select walls, select point)
- The dialog should appear after the point is selected
- If it doesn't, cancel the command and try again

### Problem: Multiple Instances Not Creating on All Selected Walls

**Cause:** Some selected entities are not type `Wall`

**Solution:**
- Filter the selection to only include wall elements
- Check that all entities are `ElementWall` type (not beams, sheets, or other entities)
- Re-run the script and select only valid wall entities

---

## FAQ

### General Usage

**Q: Can I use this tool for a single king stud?**

**A:** Yes. Set the "Number of Beams in Point Load" parameter to 1. The script supports 1 to 6 studs.

---

**Q: What happens if I change the lumber item after insertion?**

**A:** The existing studs are erased and completely regenerated with the new lumber dimensions, material, and grade. All interference management and plate stretching are re-run automatically.

---

**Q: Can I slide the point load along the wall after insertion?**

**A:** Yes. Drag the insertion grip (the X mark or text label) along the wall face. The script automatically clamps the position to keep studs inside the wall boundaries and recalculates the stud group position immediately.

---

**Q: Does this script work with metric drawings?**

**A:** No. The script is hardcoded to imperial units (`Unit(1,"inch")`). Use it only in inch-based drawings. For metric projects, a separate metric version would be required.

---

### Structural & Design

**Q: How do I know how many king studs are required for a given load?**

**A:** Consult your structural engineer. This script creates the geometry but does not perform structural calculations. The engineer will specify the required number based on load magnitude, lumber grade, and code requirements.

---

**Q: Can I use different lumber sizes for different point loads in the same wall?**

**A:** Yes. Each instance of GE_WALL_POINTLOAD is independent and can have a different lumber item selected. Insert the script multiple times with different parameters.

---

**Q: What if the load is at an angle or not perfectly vertical?**

**A:** This script is designed for vertical point loads only. For angled loads, consult your structural engineer for a custom framing solution.

---

### Display & Annotation

**Q: Why did my custom tag color disappear after I changed a parameter?**

**A:** Some parameter changes (like changing the lumber item or number of studs) trigger complete stud regeneration, which resets colors to the current "Color for new Beams" value. Set the color parameter before making other changes.

---

**Q: Can I change the text size or font of the label?**

**A:** Yes. Select a different dimension style in the "DimStyle" parameter. The text font, size, and appearance are controlled by the AutoCAD dimension style settings.

---

**Q: Why doesn't the offset parameter affect the X marker?**

**A:** The "Offset text from wall" parameter only affects "Identify with Text" mode. The X marker is drawn directly at the wall face with no offset.

---

### Technical & Integration

**Q: What is the module label used for?**

**A:** The module label (`"PL-[distance]"`) groups all king studs from the same point load instance. This enables:
- BOM filtering and sorting
- Shop drawing organization
- Identification of load-bearing components
- Tracking studs across different framing revisions

---

**Q: Can I export the point load data to Excel or a database?**

**A:** The studs are standard hsbCAD beams with module labels, so they appear in any BOM export. Filter by module prefix "PL-" to extract point load data. The module number indicates the location along the wall.

---

**Q: Does this script work with panelized wall assemblies?**

**A:** No. If all beams in a wall are part of assemblies (have panhandle references), the script enters display-only mode and does not create physical studs. Use on standard stick-framed walls.

---

**Q: What happens if the wall is deleted?**

**A:** The point load instance is attached to the wall element. If the wall is deleted, the instance and its studs are deleted as well (standard hsbCAD element-to-tool relationship).

---

**Q: Can I copy this instance to another wall?**

**A:** Not directly. The script stores references to specific beams in the entity map. Copying would create invalid references. Instead, run the script again on the target wall with the same parameters.

---

### Compatibility & Updates

**Q: What version of hsbCAD is required?**

**A:** The script was developed in 2013 for hsbCAD systems with the Framing Defaults Editor. Verify that your installation includes the required DLL at `\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll`.

---

**Q: Is this script compatible with newer hsbCAD versions?**

**A:** Generally yes, as it uses standard TSL functions. However, if the Framing Defaults Editor interface has changed, the lumber item retrieval may need updates. Test in your specific version.

---

**Q: Can I modify the script to support more than 6 studs?**

**A:** The limit is defined in line 98: `int arNumberBm[] = {1,2,3,4,5,6};`. Technically you could expand this array, but structural engineering best practices rarely require more than 6 king studs at a single point. Consult a structural engineer before modifying.

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| v1.13 | Nov 3, 2013 | David Rueda | Added stick-frame path to mapIn when calling DLL |
| v1.12 | Mar 26, 2013 | David Rueda | Beam width, height, grade, and material now set from Framing Defaults Editor; Added color restriction for new beams |
| v1.11 | Aug 5, 2012 | David Rueda | Description added to script header |
| v1.10 | Jan 23, 2012 | David Rueda | Fixed problem with split top plates |
| v1.9 | Jan 19, 2012 | David Rueda | Set created stud properties from any adjacent stud not part of an assembly |
| v1.8 | Mar 22, 2011 | Randy L. | Point load will stay within wall boundaries |
| v1.7 | — | (Unknown) | Bug fix on element construction |
| v1.6 | — | (Unknown) | Adapted for plate with Id 31 |
| v1.5 | — | Randy (assumed) | Redesigned with faster, easier functionality |
| v1.4 | — | Randy (assumed) | Will display red if on opening conflict |
| v1.3 | — | Randy (assumed) | Insert logic changed |
| v1.2 | — | Randy (assumed) | Should not recalculate on DWG insert |
| v1.1 | — | Randy (assumed) | Added check for top and bottom plates |
| v1.0 | — | Randy (assumed) | Initial release |

---

## Related Tools

### Complementary Scripts
- **GE_WALL_SHEAR_WALL** — Apply structural shear wall definitions and nailing patterns
- **GE_WALL_SECTION_BLOCKING** — Add horizontal blocking at specified heights
- **GE_HDWR_WALL_HOLD_DOWN** — Place hold-down anchors at wall ends
- **HSB_W-Post** — Create wall posts and king studs with custom configurations

### Workflow Integration
1. **Model walls** using hsbCAD wall creation tools
2. **Frame walls** using standard stud generation
3. **Apply point loads** using GE_WALL_POINTLOAD
4. **Add hardware** using hardware connector scripts
5. **Generate shop drawings** using layout and dimensioning tools
6. **Export BOM** filtered by module labels

---

## Technical Notes

### Entity Map Structure
The script stores beam references in `_Map` for cleanup and tracking:

```
_Map
├── Studs (Map)
│   ├── bm1 (Beam entity)
│   ├── bm2 (Beam entity)
│   ├── ...
│   └── bm[n] (Beam entity, n = number of studs)
├── BlockL[] (Beam entity array - left-side cut beams)
└── BlockR[] (Beam entity array - right-side cut beams)
```

**Purpose:**
- **Studs map:** Allows complete erasure and regeneration when parameters change
- **BlockL/BlockR arrays:** Tracks beams that were cut during interference management, enabling cleanup if point load is moved

### Geometric Calculations

**Stud group width:**
```c
dPLW = pBm * U(1.5)  // Number of studs × 1.5 inches
```

**Insertion point clamping:**
```c
dSizeEndCheck = pBm * U(1.5)
lnSegEl = LineSeg(
    ptEnds[0] + el.vecX() * dSizeEndCheck/2,
    ptEnds[1] - el.vecX() * dSizeEndCheck/2
)
_Pt0 = lnSegEl.closestPointTo(_Pt0)
```

**Result:** Insertion point is constrained to a line segment that is shorter than the wall by half the stud group width on each end.

### Performance Considerations
- **Beam filtering:** The script uses `realBody().hasIntersection()` checks, which can be slow for walls with hundreds of beams
- **Recommendation:** Use on typical residential walls (20-50 beams) for best performance
- **For large commercial walls:** Consider using the tool only where structurally required

---

*Document Version: 2.0*
*Generated: 2026-02-21*
*Script Version: 1.13 (November 3, 2013)*
*Target Audience: CAD operators and timber frame designers*
