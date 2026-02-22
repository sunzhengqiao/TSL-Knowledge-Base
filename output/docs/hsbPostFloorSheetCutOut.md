# hsbPostFloorSheetCutOut

**Version:** 1.3
**Type:** O-Type (Object)
**Environment:** Model Space
**Category:** StickFrame / Floor
**Author:** marsel.nakuci@hsbcad.com
**Last Updated:** 17.09.2019

## Overview

The `hsbPostFloorSheetCutOut` script is an intelligent automation tool that creates cutouts in horizontal floor sheets (OSB, plywood, or other sheathing materials) where vertical posts (columns, studs) penetrate through the floor assembly. This script is essential for timber frame construction where floor systems must accommodate vertical structural members passing through them.

### Primary Function

The script performs a dual-mode operation:
1. **Distribution Mode:** Analyzes selected posts and sheets, automatically creating dedicated TSL instances for each post-sheet intersection combination
2. **Tool Mode:** Each created instance continuously monitors its assigned post and sheets, applying dynamic cutouts that automatically recalculate when geometry changes

### Key Capabilities

- **Automatic Intersection Detection:** Intelligently identifies which sheets intersect with which posts based on 3D geometry
- **Parametric Gap Control:** User-defined clearance ensures proper installation tolerance around posts
- **Sheet Splitting:** When a cutout divides a sheet into multiple pieces, the script automatically creates separate sheet entities
- **Duplicate Prevention:** Built-in logic prevents redundant TSL instances from being created for the same post-sheet combination
- **Dynamic Recalculation:** Cutouts update automatically when post positions, dimensions, or sheet geometry changes
- **Incremental Sheet Addition:** After initial placement, users can add additional sheets to existing cutout instances via context menu

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object - Independent TSL entity) |
| **Model Space** | Yes (operates in 3D model environment) |
| **Paper Space** | No |
| **Required Beams** | 0 (prompts user to select) |
| **Major Version** | 1 |
| **Minor Version** | 3 |
| **Keywords** | sheet, post, beam, beamcut, gap |
| **DxaOut** | 1 (outputs graphical representation) |
| **ImplInsert** | 1 (custom insertion logic) |

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.3 | 17.09.2019 | marsel.nakuci@hsbcad.com | TFC-39: Removed unnecessary user messages |
| 1.2 | 02.02.2019 | marsel.nakuci@hsbcad.com | Gap value now included in duplicate detection logic |
| 1.1 | 31.01.2019 | marsel.nakuci@hsbcad.com | Added functionality to avoid duplication of TSL instances |
| 1.0 | 28.01.2019 | marsel.nakuci@hsbcad.com | Initial release |

## Prerequisites

### Required Elements

Before using this script, ensure the following elements exist in your model:

1. **Vertical Post Beams**
   - Must be `Beam` or `GenBeam` entities
   - X-axis must be parallel to World Z-axis (vertical orientation)
   - Can be wall studs, columns, or any vertical timber member
   - Multiple posts can be processed simultaneously

2. **Horizontal Floor Sheets**
   - Must be `Sheet` entities (OSB, plywood, gypsum, etc.)
   - Z-axis must be parallel to World Z-axis (horizontal orientation)
   - Can be floor sheathing, subfloor panels, or platform decking
   - Multiple sheets can be processed simultaneously

### Minimum Selection

- At least **1 vertical post beam**
- At least **1 horizontal sheet**

If fewer than 2 entities total are selected, the script will display an error message and abort.

### Geometric Requirements

- **Posts:** Beam's local X-axis parallel to World Z (`vecX().isParallelTo(_ZW)`)
- **Sheets:** Sheet's local Z-axis parallel to World Z (`vecZ().isParallelTo(_ZW)`)
- Posts must actually intersect the plane of the sheet (not just be in the same general area)

## Parameters

The script exposes one user-configurable parameter through the AutoCAD Properties Palette (OPM):

### Gap

| Property | Details |
|----------|---------|
| **Type** | PropDouble (floating-point number) |
| **Default Value** | 0 mm |
| **Units** | Linear (mm, inches - based on drawing units) |
| **Index** | 0 |
| **Category** | General |
| **Description** | Defines the gap between the sheets and the columns |

#### Purpose

The `Gap` parameter adds clearance around the post cross-section when calculating the cutout profile. This is essential for:

1. **Installation Tolerance:** Allows the sheet to be installed around the post without binding
2. **Thermal Expansion:** Provides space for material expansion/contraction
3. **Installation Error:** Accommodates minor misalignment during construction
4. **Acoustic Separation:** Prevents direct contact between post and sheet

#### How It Works

The gap is applied symmetrically on all sides of the post cross-section:
- **Original Post Dimensions:** Width (W) × Height (H)
- **Cutout Dimensions:** (W + 2×Gap) × (H + 2×Gap)

#### Typical Values

| Application | Recommended Gap | Reason |
|-------------|-----------------|--------|
| Tight fit (no tolerance) | 0 mm | Post installed before sheet |
| Standard installation | 2-5 mm | Normal field tolerance |
| Rough framing | 5-10 mm | Field adjustment needed |
| Acoustic separation | 10-15 mm | Vibration isolation |

#### Impact on Selection

The gap value affects:
1. **Which sheets are considered intersecting:** Larger gaps may cause sheets near the post edge to be included
2. **Final cutout size:** Directly increases the hole dimensions
3. **Duplicate detection:** A TSL with the same post and sheets but different gap value is considered unique

## Usage Instructions

### Step-by-Step Workflow

#### Step 1: Launch the Script

**Method A: Via TSL Browser**
1. Open the hsbCAD TSL Browser
2. Navigate to the script (typically under StickFrame → Floor or General category)
3. Double-click `hsbPostFloorSheetCutOut`

**Method B: Via Command Line**
```
Command: TSLINSERT
Select TSL: hsbPostFloorSheetCutOut
```

**Method C: Via AutoLISP Shortcut**
```lisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbPostFloorSheetCutOut")) TSLCONTENT
```

#### Step 2: Configure Gap (Optional)

If you need a clearance gap:
1. The script may display a settings dialog (if invoked with catalog support)
2. Alternatively, set the gap after insertion via the Properties Palette
3. Default gap is 0 mm (tight fit)

**Note:** If you invoke the script with an execution key (catalog name), it will automatically load those stored parameters. Otherwise, it loads the last-inserted values or shows a dialog.

#### Step 3: Select Entities

When prompted **"Select sheets and beams"**:

1. **Selection Strategy A: Window Selection**
   - Use a window or crossing selection to capture all relevant posts and sheets
   - The script will automatically filter:
     - Vertical beams → Posts collection
     - Horizontal sheets → Sheets collection
   - Non-qualifying entities are ignored

2. **Selection Strategy B: Individual Selection**
   - Click each post beam individually
   - Click each sheet individually
   - Press Enter when complete

3. **Multi-Floor Selection**
   - You can select posts and sheets from multiple floor levels
   - The script will create appropriate cutouts based on geometric intersection

4. **Press Enter** to confirm the selection

#### Step 4: Script Processing

The script now enters **Distribution Mode** and performs the following:

1. **Entity Classification**
   - Separates beams from sheets
   - Validates vertical orientation (beams) and horizontal orientation (sheets)
   - Discards non-conforming entities

2. **Intersection Analysis (First Pass)**
   - For each vertical post:
     - Calculates post cross-section + gap
     - Projects cutout profile onto sheet plane
     - Identifies all sheets intersecting this profile
     - Checks if sheet would be split by cutout

3. **Sheet Splitting (If Needed)**
   - If a cutout divides a sheet into 2+ pieces:
     - Creates new sheet entities for each piece
     - Adds new sheets to the master sheet collection

4. **Second Pass Processing**
   - The loop runs **twice** (`for k=0; k<2; k++`)
   - First pass: Identifies intersections and creates split sheets
   - Second pass: Processes the newly-created sheets
   - This ensures cutouts are applied to all sheet fragments

5. **Duplicate Detection**
   - For each post, checks if a TSL instance already exists with:
     - Same post beam reference
     - Same intersecting sheets collection
     - Same gap value
   - If duplicate found: Skips creation (or replaces if sheets/gap differ)
   - If unique: Creates new TSL instance

6. **TSL Instance Creation**
   - Creates one TSL instance per post
   - Each instance references:
     - `_Beam[0]`: The post beam
     - `_Sheet[]`: All intersecting sheets
   - Sets mode to 1 (Tool Mode) in the TSL's internal Map
   - Positions the TSL at the intersection point of the post axis and the top face of the first sheet

#### Step 5: Automatic Cutout Application (Tool Mode)

After the distribution TSL erases itself, the newly-created instances take over:

1. **Reference Validation**
   - Each TSL instance validates that:
     - Beam[0] is still valid and vertical
     - Sheets are still valid and horizontal
   - If invalid: TSL erases itself and logs error

2. **Cutout Geometry Calculation**
   - Retrieves post center point, orientation vectors, and dimensions
   - Calculates cutout dimensions: `(Width + 2×Gap) × (Height + 2×Gap) × Length`
   - Creates a `BeamCut` tooling object

3. **Tool Application**
   - Applies the BeamCut to all sheets in the `_Sheet[]` array
   - Each sheet's geometry is modified to include the cutout
   - The cutout is subtracted from the sheet's solid body

4. **Visual Feedback**
   - Draws a PlaneProfile (Color 12 - cyan) showing the cutout boundary
   - Displays extent lines in Y and Z directions showing cutout dimensions
   - This visual appears in the viewport for verification

### Advanced Operations

#### Adding Sheets to Existing Cutouts

After initial placement, you may need to add more sheets (e.g., a second layer of sheathing):

**Method A: Context Menu**
1. Right-click the TSL instance in the model
2. Select **"Add Sheet"** from the context menu
3. When prompted "Select sheet(s)", click the additional sheets
4. Press Enter to confirm
5. The script recalculates and applies cutouts to the new sheets

**Method B: Double-Click**
1. Double-click the TSL instance
2. This triggers the same "Add Sheet" function
3. Select additional sheets and press Enter

**Important:** The script will run **2 execution loops** when adding sheets to ensure all split sheets are processed.

#### Updating Gap Value

If you need to change the gap after insertion:

1. Select the TSL instance
2. Open the AutoCAD Properties Palette (Ctrl+1)
3. Locate the **Gap** parameter under the "General" category
4. Change the value (e.g., from 0 to 5 mm)
5. The script automatically recalculates the cutout with the new gap

**Note:** Changing the gap will not create a new TSL instance, it will update the existing one.

#### Replacing an Existing TSL

If you re-run the script with:
- Same post beam
- Different selection of sheets, OR
- Different gap value

The script will:
1. Detect the existing TSL instance
2. Erase the old instance (`tslBeam.dbErase()`)
3. Create a new instance with the updated parameters

This allows you to correct mistakes or update the design.

#### Preventing Duplicates

If you accidentally re-run the script with:
- Same post beam
- Same sheets
- Same gap value

The script will:
1. Detect the existing TSL instance
2. Display: **"Beam is already been calculated for these sheets and gap"**
3. Skip creation (no duplicate instance)

This prevents cluttering the model with redundant TSL instances.

## Understanding the Two-Mode Operation

### Distribution Mode (Mode = 0)

**When Active:** Only during initial insertion (`_bOnInsert` and `nMode == 0`)

**Purpose:** Analyze all selected posts and sheets, create individual TSL instances

**Process Flow:**
```
User Selects Posts + Sheets
         ↓
Classify Entities (vertical beams, horizontal sheets)
         ↓
For Each Post:
    ├─ Calculate Post Section + Gap
    ├─ Find All Intersecting Sheets
    ├─ Check for Sheet Splitting
    ├─ Create Split Sheets (if needed)
    ├─ Detect Duplicate TSL
    └─ Create New TSL Instance (Tool Mode)
         ↓
Erase Distribution TSL (self-destruct)
```

**Key Variables:**
- `nMode = 0` (set by absence of Map data)
- Operates on `_Entity[]` array (user selection)
- Creates child TSL instances via `tslNew.dbCreate()`

### Tool Mode (Mode = 1)

**When Active:** All TSL instances created by Distribution Mode

**Purpose:** Apply and maintain the actual cutout geometry

**Process Flow:**
```
TSL Instance Created (mode=1 in Map)
         ↓
Validate References (beam vertical? sheets horizontal?)
         ↓
Calculate Cutout Geometry
         ↓
Create BeamCut Tool Object
         ↓
Apply to All Sheets
         ↓
Draw Visual Feedback (cyan profile, extent lines)
         ↓
Listen for Recalc Triggers:
    ├─ Add Sheet (context menu or double-click)
    ├─ Geometry Changes (post moves, sheets modified)
    └─ Parameter Changes (gap value updated)
```

**Key Variables:**
- `nMode = 1` (retrieved from `_Map.getInt("mode")`)
- Operates on `_Beam[0]` and `_Sheet[]` arrays
- Responds to recalc triggers

## Internal Logic Explanation

### Coordinate System and Geometry

#### Post Beam Reference Frame

For a vertical post, the script uses the beam's local coordinate system:
- **vecX:** Along the beam length (vertical, parallel to World Z)
- **vecY:** Across the beam width (horizontal)
- **vecZ:** Across the beam height/depth (horizontal)

#### Cutout Profile Calculation

Given a post with center point `ptPostCenter`:

1. **Define corner points WITH gap:**
   ```c
   Point3d pt1 = ptPostCenter + vecY * (0.5 * Width + Gap) - vecZ * (0.5 * Height + Gap);
   Point3d pt2 = ptPostCenter - vecY * (0.5 * Width + Gap) + vecZ * (0.5 * Height + Gap);
   ```
   These represent opposite corners of the enlarged rectangle.

2. **Define corner points WITHOUT gap:**
   ```c
   Point3d pt3 = pt1 - vecY * Gap + vecZ * Gap;
   Point3d pt4 = pt2 + vecY * Gap - vecZ * Gap;
   ```
   These represent the actual beam cross-section.

3. **Create profile with gap (for intersection testing):**
   ```c
   PlaneProfile ppBeam;
   ppBeam.createRectangle(seg, vecY, vecZ);
   ```

4. **Create polyline without gap (for sheet splitting):**
   ```c
   PLine plBeam;
   plBeam.createRectangle(seg2, vecY, vecZ);
   ```

#### Intersection Detection

For each sheet:

1. **Get sheet envelope:**
   ```c
   PLine pl = sheets[j].plEnvelope();
   PlaneProfile ppSheet(pl);
   ```

2. **Test for intersection:**
   ```c
   int bOk = ppIntersect.intersectWith(ppBeam);
   ```
   If `bOk == true`, the sheet intersects the post cutout area.

3. **Subtract post profile from sheet profile:**
   ```c
   ppSheet.subtractProfile(ppBeam);
   PLine plRings[] = ppSheet.allRings(true, false);
   ```

4. **Check for sheet splitting:**
   ```c
   if (plRings.length() > 1)
   ```
   If the result has multiple rings (closed loops), the sheet has been divided.

#### Sheet Splitting Logic

When a cutout divides a sheet:

1. **Analyze split geometry:**
   ```c
   LineSeg seg1 = PlaneProfile(plRings[0]).extentInDir(vecY);
   LineSeg seg2 = PlaneProfile(plRings[1]).extentInDir(vecY);
   ```
   Find the extent of each resulting piece.

2. **Calculate split direction:**
   ```c
   Vector3d vecSplit = post.vecD(seg1.ptMid() - seg2.ptMid());
   ```
   Determine which direction to split the sheet (perpendicular to the post).

3. **Perform database split:**
   ```c
   Sheet sheetSplit[] = sheets[j].dbSplit(Plane(ptPostCenter, vecSplit), 0);
   ```
   This creates new sheet entities in the database.

4. **Add to intersection list:**
   ```c
   sheetsIntersected.append(sheetSplit);
   ```
   The new sheets are now tracked.

5. **Add to master sheet list:**
   ```c
   if (sheets.find(sh) < 0)
       sheets.append(sh);
   ```
   Ensures the second loop pass will process the new sheets.

### Duplicate Detection Algorithm

For each post beam, the script:

1. **Collect all TSL instances in the model:**
   ```c
   Group grp();
   Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
   ```

2. **Filter for this script:**
   ```c
   if (t.scriptName() != scriptName()) continue;
   ```

3. **Find TSLs referencing the current post:**
   ```c
   Beam beamTsl[] = t.beam();
   if (beamTsl[0] != post) continue;
   ```

4. **Compare sheet count and gap value:**
   ```c
   if ((sheetsIntersected.length() == tslBeam.sheet().length()) &&
       tslBeam.propDouble(sGapName) == dGap)
   {
       reportMessage("|Beam is already been calculated for these sheets and gap|");
       continue;  // Skip creation
   }
   ```

5. **If different, erase old and create new:**
   ```c
   else
   {
       tslBeam.dbErase();
       // Continue with creation
   }
   ```

### Two-Pass Loop Explained

```c
for (int k = 0; k < 2; k++)
{
    for (int i = 0; i < posts.length(); i++)
    {
        // ... intersection and splitting logic ...

        if (k == 1)  // Only create TSL instances on second pass
        {
            // ... TSL creation logic ...
        }
    }
}
```

**Why Two Passes?**

1. **First Pass (k=0):**
   - Identifies intersecting sheets
   - Splits sheets if needed
   - Appends new sheets to the master array
   - Does NOT create TSL instances

2. **Second Pass (k=1):**
   - Processes the updated sheet array (including newly split sheets)
   - Identifies final intersection list
   - Creates TSL instances

Without the second pass, newly-split sheets would not be included in the cutout calculation, leading to incomplete results.

### BeamCut Tool Application

In Tool Mode (mode=1), the actual cutting is performed:

1. **Calculate cutout dimensions:**
   ```c
   double dX = post.solidLength();       // Post length
   double dY = post.dW() + 2 * dGap;     // Width + gap
   double dZ = post.dH() + 2 * dGap;     // Height + gap
   ```

2. **Create BeamCut object:**
   ```c
   BeamCut bc(ptCen, vecX, vecY, vecZ, dX, dY, dZ, 0, 0, 0);
   ```
   This defines a rectangular cut profile.

3. **Apply to each sheet:**
   ```c
   for (int i=0; i<_Sheet.length(); i++)
   {
       _Sheet[i].addTool(bc);
   }
   ```
   The `addTool()` method subtracts the cut volume from the sheet's solid geometry.

### Visual Display Logic

The cyan cutout preview is generated as follows:

1. **Find intersection with sheet top face:**
   ```c
   Line(ptCen, vecX).hasIntersection(
       Plane(_Sheet[0].ptCen() + _ZW * 0.5 * _Sheet[0].dH(), _ZW),
       ptRef
   );
   ```

2. **Create cutout body:**
   ```c
   Body bd(ptCen, vecX, vecY, vecZ, dX, dY, dZ, 0, 0, 0);
   ```

3. **Project shadow profile onto sheet plane:**
   ```c
   PlaneProfile pp = bd.shadowProfile(Plane(ptRef, vecX));
   ```

4. **Display the profile and extent lines:**
   ```c
   Display dp(12);  // Cyan color
   dp.draw(pp);
   dp.draw(pp.extentInDir(vecY));
   dp.draw(pp.extentInDir(vecZ));
   ```

## Context Menu and Recalc Triggers

### Add Sheet Command

**Trigger Setup:**
```c
String sTriggerAddSheet = T("|Add Sheet|");
addRecalcTrigger(_kContext, sTriggerAddSheet);
```

**Activation:**
- Right-click context menu: "Add Sheet"
- Double-click the TSL instance (`_kExecuteKey == sDoubleClick`)

**Handler:**
```c
if (_bOnRecalc && (_kExecuteKey == sTriggerAddSheet || _kExecuteKey == sDoubleClick))
{
    PrEntity ssE(T("|Select sheet(s)|"), Sheet());
    if (ssE.go())
        _Sheet.append(ssE.sheetSet());

    setExecutionLoops(2);  // Run calculation twice
    return;
}
```

**Why 2 Execution Loops?**
- First loop: Adds sheets to the `_Sheet[]` array
- Second loop: Applies cutouts to the updated sheet list
- Ensures proper recalculation

## Error Messages and Validation

### User-Facing Messages

| Message | Trigger | Solution |
|---------|---------|----------|
| "There should be at least a post and a beam selected" | Fewer than 2 entities selected | Select at least 1 beam and 1 sheet |
| "Invalid beam reference" | Referenced beam is no longer vertical or deleted | Re-insert the TSL with a valid vertical beam |
| "Invalid sheet reference" | Referenced sheet is no longer horizontal or deleted | Re-insert the TSL with valid horizontal sheets |
| "Beam is already been calculated for these sheets and gap" | Duplicate insert attempt | No action needed, TSL already exists |
| "Could not find intersection between beam and plate" | Post axis does not intersect sheet plane | Verify post and sheet geometry alignment |

### Validation Checks

**During Distribution Mode:**
1. Minimum 2 entities selected
2. At least 1 beam is vertical
3. At least 1 sheet is horizontal

**During Tool Mode:**
1. `_Beam[0]` is valid and vertical
2. `_Sheet.length() >= 1`
3. All sheets are valid and horizontal
4. Post axis intersects sheet plane

If any validation fails, the TSL instance erases itself to prevent errors.

## Visual Feedback

### Color Coding

| Element | Color | Purpose |
|---------|-------|---------|
| Cutout profile | 12 (Cyan) | Shows the exact cutout boundary |
| Extent lines (Y) | 12 (Cyan) | Shows cutout width dimension |
| Extent lines (Z) | 12 (Cyan) | Shows cutout height dimension |
| Debug vectors | 150 (varies) | Internal development visualization |

### What You See

When a TSL instance is active:
1. A rectangular outline (cyan) at the sheet level showing the cutout perimeter
2. Two perpendicular extent lines indicating the cutout dimensions
3. The actual holes in the sheets (created by the BeamCut tool)

### Debugging Mode

If the debug flag is enabled:
```c
int bDebug = _bOnDebug;
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
```
- TSL instances in Distribution Mode will NOT erase themselves
- Additional visual feedback (split vectors, etc.) will be displayed
- Console messages will be printed

## Best Practices

### Before Using the Script

1. **Verify Element Orientation**
   - Ensure posts are truly vertical (X-axis parallel to World Z)
   - Ensure sheets are truly horizontal (Z-axis parallel to World Z)
   - Use the UCS or beam properties to check orientation

2. **Set Appropriate Gap Value**
   - Consider the construction sequence (post before sheet, or sheet before post?)
   - Account for material tolerances (rough lumber vs. engineered)
   - Consider acoustic or thermal separation requirements

3. **Clean Up Existing TSLs**
   - If re-running the script, understand that it will replace existing TSLs with different sheet selections
   - Delete unnecessary TSL instances manually if needed

### During Selection

1. **Use Window Selection**
   - Fastest method for multiple posts and sheets
   - The script automatically filters the correct entities

2. **Select All Relevant Sheets**
   - Include all layers (subfloor, underlayment, finish floor if applicable)
   - The script will split sheets as needed

3. **Process Multiple Floors Separately**
   - While you CAN select posts/sheets from multiple levels, it's clearer to process each floor separately
   - This makes verification easier

### After Insertion

1. **Verify Cutouts**
   - Visually inspect the cyan preview profiles
   - Check that all sheets have appropriate cutouts
   - Use 3D views to verify the cuts penetrate fully

2. **Add Sheets Incrementally**
   - If you add another layer of sheathing later, use "Add Sheet" context menu
   - This is more efficient than re-running the entire script

3. **Update Gap If Needed**
   - Use the Properties Palette to adjust the gap value
   - The cutouts will automatically recalculate

### Performance Considerations

1. **Large Projects**
   - Selecting 100+ posts and sheets will take time due to the double-loop algorithm
   - Consider processing the project in zones (e.g., by gridline)

2. **Complex Sheet Splitting**
   - If a single sheet is split by multiple posts, multiple new sheets will be created
   - This can increase the sheet count significantly
   - Monitor model performance

3. **Recalculation Frequency**
   - The TSL recalculates whenever the post or sheets change
   - In very large models, this may cause lag
   - Consider freezing TSL instances if the geometry is final

## Troubleshooting

### Issue: "No cutouts are created"

**Possible Causes:**
1. Posts are not vertical (X-axis not parallel to World Z)
2. Sheets are not horizontal (Z-axis not parallel to World Z)
3. Posts and sheets do not actually intersect in 3D space

**Solutions:**
- Check beam and sheet orientations using Properties
- Verify that the post axis passes through the sheet plane
- Use the UCS to align coordinate systems

### Issue: "Sheets are split unexpectedly"

**Possible Causes:**
1. The gap value is too large, causing the cutout to divide the sheet
2. Multiple posts are close together, causing overlapping cutouts

**Solutions:**
- Reduce the gap value
- Check post spacing
- Review the cyan preview to verify cutout size

### Issue: "TSL instances are duplicated"

**Possible Causes:**
1. The script was run multiple times with slightly different sheet selections
2. The gap value was different between runs

**Solutions:**
- The script should prevent exact duplicates automatically
- If duplicates exist, delete the unwanted TSL instances manually
- Re-run with the correct selection to replace

### Issue: "Cannot add sheets via context menu"

**Possible Causes:**
1. The TSL instance is no longer valid (beam or sheet was deleted)
2. The context menu is not configured correctly

**Solutions:**
- Verify that the referenced beam and sheets still exist
- Check that the TSL instance is selected (not just highlighted)
- Use double-click as an alternative

### Issue: "Cutouts are too small or too large"

**Possible Causes:**
1. Gap value is incorrect
2. Post cross-section dimensions have changed
3. Units mismatch (mm vs. inches)

**Solutions:**
- Check the Gap parameter in Properties Palette
- Verify the post's dW() and dH() values
- Ensure drawing units are consistent

### Issue: "Visual feedback (cyan profile) is not displayed"

**Possible Causes:**
1. The TSL is in Distribution Mode (only exists during insertion)
2. The post axis does not intersect the sheet plane
3. The display layer is frozen or off

**Solutions:**
- Wait for the script to complete (Distribution Mode erases itself)
- Check the console for "could not find intersection" error messages
- Verify that the TSL instance's layer is visible

## Advanced Topics

### Catalog Support

The script includes catalog functionality:

```c
String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
if (sEntries.find(sKey) > -1)
    setPropValuesFromCatalog(sKey);
```

**Usage:**
1. Create a catalog entry with predefined gap values (e.g., "TightFit", "StandardGap", "WideGap")
2. Invoke the script with the catalog key via `_kExecuteKey`
3. The script will automatically load those parameters

**Example:**
```
Catalog Entry: "STANDARD_5MM"
   Gap: 5 mm
```

Invoke with: `hsb_ScriptInsert "hsbPostFloorSheetCutOut" "STANDARD_5MM"`

### Integration with Workflows

**Typical Timber Frame Workflow:**

1. **Frame Layout**
   - Create wall elements with studs (vertical beams)
   - Create floor joist/beam layout

2. **Sheathing Application**
   - Apply floor sheets (OSB/plywood) using hsbCAD sheet distribution tools
   - Sheets span across joists

3. **Post Penetrations**
   - Posts from floor below (or above) penetrate the floor assembly
   - **Run hsbPostFloorSheetCutOut** to create automatic cutouts

4. **Detail Refinement**
   - Adjust gap values if needed for acoustic/thermal separation
   - Add fire-stopping material references (manual annotation)

5. **Shop Drawings**
   - The cutouts will appear in shop drawings
   - CNC export will include the cutout geometry

### Extending the Script

**Potential Enhancements (for developers):**

1. **Non-Rectangular Posts**
   - Currently assumes rectangular cross-sections
   - Could be extended to support circular posts (drilled holes instead of rectangular cuts)

2. **Variable Gap by Side**
   - Allow different gap values for each side (top/bottom/left/right)
   - Useful for asymmetric tolerance requirements

3. **Automatic Fire-Stopping**
   - Detect cutouts and automatically insert fire-stopping material references
   - Integration with material libraries

4. **Batch Processing Mode**
   - Process entire floors at once without user selection
   - Automatically detect all vertical posts and horizontal sheets

5. **Interference Checking**
   - Warn if cutouts overlap (multiple posts too close together)
   - Suggest minimum post spacing based on gap values

## Related Scripts and Tools

### Complementary Scripts

| Script | Relationship | Use Case |
|--------|--------------|----------|
| **hsbSheetDistribution** | Upstream | Creates the floor sheets that this script cuts |
| **hsbBeamcut** | Similar | Manual beam cutting (this script uses BeamCut internally) |
| **hsbBlocking** | Related | Adds blocking between floor joists around cutouts |
| **HSB_E-SquaredMill** | Downstream | Additional milling operations on cut sheets |
| **FLR_Chase** | Parallel | Creates larger openings (stairs, HVAC chases) in floor systems |
| **hsbCLT-Opening** | Similar | CLT panel cutouts (different construction method) |

### Workflow Scripts

| Stage | Script | Purpose |
|-------|--------|---------|
| 1. Framing | GenBeam creation tools | Create vertical posts |
| 2. Sheathing | hsbSheetDistribution | Apply floor sheets |
| 3. Cutouts | **hsbPostFloorSheetCutOut** | Create post penetrations |
| 4. Detail | hsbBlocking | Add blocking around openings |
| 5. Documentation | hsbLayoutDim | Dimension cutouts in shop drawings |
| 6. Export | hsbCNC | Export cutout geometry to CNC machines |

## Technical Reference

### Script Classification

| Category | Value |
|----------|-------|
| **Primary Category** | Base / Function |
| **Secondary Category** | StickFrame / Floor |
| **Functional Module** | HSB_E (Element operations) |
| **Construction System** | Stick Frame, Platform Framing |
| **Output Type** | Model Space geometry modification |

### API and Functions Used

**Key TSL APIs:**
- `PrEntity`: Entity selection prompt
- `Beam.vecX()`: Beam orientation vectors
- `Sheet.plEnvelope()`: Sheet boundary polyline
- `PlaneProfile`: 2D profile operations
- `BeamCut`: Solid subtraction tool
- `dbSplit()`: Database-level sheet splitting
- `addTool()`: Apply machining operation
- `TslInst.dbCreate()`: Create new TSL instance
- `Group.collectEntities()`: Query all entities of a type
- `addRecalcTrigger()`: Register context menu commands
- `setExecutionLoops()`: Control recalculation cycles

**Geometric Functions:**
- `isParallelTo()`: Vector parallelism check
- `hasIntersection()`: Line-plane intersection
- `intersectWith()`: Profile-profile intersection
- `subtractProfile()`: Boolean 2D subtraction
- `shadowProfile()`: 3D body projection to plane
- `extentInDir()`: Bounding extent in direction

**Data Structures:**
- `Point3d`: 3D coordinates
- `Vector3d`: Direction and magnitude
- `Line`: Infinite line
- `LineSeg`: Finite line segment
- `Plane`: Infinite plane
- `PLine`: Polyline
- `PlaneProfile`: Closed 2D profile
- `Body`: 3D solid
- `Map`: Key-value container

### Internal Map Structure

**Distribution Mode (mode=0):**
```
_Map: (empty - no Map data triggers mode 0)
```

**Tool Mode (mode=1):**
```
_Map:
  ├─ "mode": int = 1
  └─ (other keys may be added in future versions)
```

### Property Indices

The script uses index-based property management:

```c
int nDoubleIndex = 0;
int nStringIndex = 0;
int nIntIndex = 0;

PropDouble dGap(nDoubleIndex++, U(0), "Gap");  // Index 0
```

Currently only one property exists, but the index system allows for easy extension.

## Frequently Asked Questions

**Q: Can this script work with angled posts (not perfectly vertical)?**
**A:** No. The script specifically checks for `vecX().isParallelTo(_ZW)`, which requires the post's X-axis to be parallel to the World Z-axis. Angled posts are ignored.

**Q: What happens if a post is on the edge of a sheet but not quite intersecting?**
**A:** The script uses geometric intersection testing. If the post's cross-section (+ gap) does not intersect the sheet's envelope, the sheet will not be included in the cutout list.

**Q: Can I use this script for wall sheets with horizontal beams?**
**A:** No. The script is specifically designed for vertical posts penetrating horizontal sheets. For wall sheets (vertical) with horizontal beams, you would need a different script or manual beamcut operations.

**Q: Why does the script create separate TSL instances for each post instead of one master instance?**
**A:** This design allows:
- Independent recalculation per post
- Easier debugging and verification
- Better performance (only affected TSLs recalculate when geometry changes)
- Simpler deletion (remove one post's cutout without affecting others)

**Q: Can I change which sheets are included after the TSL is created?**
**A:** Yes, in two ways:
1. Use "Add Sheet" context menu to append additional sheets
2. Re-run the script with the same post but different sheet selection (the old TSL will be replaced)

**Q: What if I delete a sheet that is referenced by the TSL?**
**A:** The TSL will detect the invalid reference during recalculation and erase itself, logging an "Invalid sheet reference" error.

**Q: Does the cutout update automatically if I move the post?**
**A:** Yes. The TSL is parametric - it recalculates whenever the post's geometry changes (position, rotation, or dimensions).

**Q: Can I export the cutout geometry to CNC machines?**
**A:** Yes. The cutouts are real BeamCut tools applied to the sheet entities. hsbCAD's CNC export tools will recognize and export this geometry.

**Q: How do I remove all cutouts created by this script?**
**A:** Select all TSL instances of type "hsbPostFloorSheetCutOut" (use filter or selection set) and delete them. The sheets will revert to their original geometry.

**Q: Why is the script running slowly with many posts and sheets?**
**A:** The double-loop algorithm (2 passes × N posts × M sheets) has O(N×M) complexity. For large projects (100+ posts, 50+ sheets), consider:
- Processing in zones (by gridline or area)
- Using faster hardware
- Upgrading to the latest hsbCAD version (performance improvements)

**Q: Can I customize the visual feedback color?**
**A:** Not through parameters. The script hardcodes Color 12 (cyan). To change it, you would need to modify the script source code:
```c
Display dp(12);  // Change 12 to desired color index
```

## Summary

The `hsbPostFloorSheetCutOut` script is a powerful automation tool for timber frame construction, specifically designed to handle the common scenario of vertical posts penetrating horizontal floor assemblies. Its dual-mode architecture (Distribution + Tool) ensures efficient processing of multiple posts and sheets while maintaining parametric, recalculable cutout geometry.

**Key Strengths:**
- Intelligent automation (no manual calculations needed)
- Parametric design (cutouts update automatically)
- Robust duplicate prevention
- Sheet splitting capability
- Extensible (add sheets after insertion)

**Ideal For:**
- Platform frame floor systems with vertical posts/columns
- Multi-layer sheathing applications
- Projects requiring precise installation tolerances
- CNC manufacturing workflows

**Limitations:**
- Requires vertical posts and horizontal sheets (no arbitrary angles)
- Rectangular cross-sections only (no circular or complex profiles)
- Does not automatically add fire-stopping or blocking (manual operations)

By understanding the script's operation and best practices outlined in this guide, users can efficiently create accurate, production-ready floor assemblies with automated post penetration cutouts.
