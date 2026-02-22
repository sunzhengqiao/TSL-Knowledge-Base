# GE_HDWR_WALL_ANCHOR_MULTIPLE

## Overview

| Property | Value |
|----------|-------|
| Script Name | GE_HDWR_WALL_ANCHOR_MULTIPLE |
| Type | Object (O) |
| Version | 1.10 (June 15, 2014) |
| Category | Hardware - Wall Anchoring / Multi-Point Distribution |
| Keywords | Wall, TieRod, Hardware, Anchor, Distribution |
| Beams Required | 0 |
| Units | Inches |
| Author | David Rueda (hsbSOFT) |

**GE_HDWR_WALL_ANCHOR_MULTIPLE** is an **intelligent distribution controller** that automatically places multiple wall anchoring hardware instances along the entire length of a selected Stick Frame wall element. Instead of manually inserting individual anchor points one at a time, this master script calculates optimal spacing, intelligently avoids openings (doors and windows), and programmatically spawns the appropriate child anchor scripts at each computed location—all in a single operation.

This script supports **ten different anchoring scenarios**, ranging from ATC (All-Thread-Connected) rod systems and screw anchors to adhesive anchors, embedded anchors, J-bolt anchors, and MAS anchors. Each scenario delegates the actual 3D geometry creation to a specialized child script (e.g., `GE_HDWR_WALL_ANCHOR`, `GE_HDWR_ANCHOR_ADHESIVE`, `GE_HDWR_ANCHOR_EMBEDDED`, etc.).

It represents the **recommended workflow** for rapidly applying engineering-specified anchoring across entire building perimeters, particularly when combined with element-level automation tools for production housing projects.

### Key Capabilities

- **Automatic Distribution**: Places anchors at user-defined spacing along the full wall length, starting from each end and spanning across wall segments between openings
- **Opening Avoidance**: Automatically detects door and window openings in the wall and distributes anchors only in the solid wall segments between them
- **Multiple Anchor Types**: Supports ten different engineering scenarios, each mapped to a specialized child TSL script
- **Second-Floor Auto-Detection**: Walls detected above the first floor (higher than 59 inches from world origin) are automatically set to "None" to prevent duplicate hardware on upper-level walls in multi-story construction
- **Duplicate Prevention**: If a child anchor TSL is already attached to the same wall element, the script erases itself to avoid conflicts
- **Bulk Removal**: Provides a right-click context menu option to remove all child anchor instances from the wall at once
- **Re-Distribution**: Allows quick recalculation and re-placement of all anchors when the scenario or spacing changes
- **Map-Based Automation**: Supports programmatic scenario selection via Map keys for batch processing workflows

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Primary environment. Creates and manages child anchor TSL instances on wall elements. |
| Paper Space | No | This is a distribution controller; it does not generate shop drawing content directly. |
| Shop Drawing | No | Not applicable for 2D drawing generation. |
| Element Required | Yes | Requires a Stick Frame Wall Element (`ElementWallSF`) |
| Automation Compatible | Yes | Supports Map-based type injection for batch processing workflows |
| Implicit Insert | Yes | Script uses implicit insert mode (`#ImplInsert 1`); second insertion attempt triggers self-erasure |

## Prerequisites

Before using this script, ensure the following requirements are met:

### Required Elements
- **Wall Element**: A Stick Frame Wall Element (`ElementWallSF`) must exist in the model. The script validates this requirement during insertion and will erase itself if the selected entity is not a valid stick-frame wall.

### Required Child Scripts
The following child scripts must be available in the TSL directory, depending on which scenarios you intend to use:

| Scenario | Child Script Required |
|----------|----------------------|
| 1/2" ATC Engineering | `GE_HDWR_WALL_ANCHOR` |
| 1/2" ATC & Anchor Engineering | `GE_HDWR_WALL_ANCHOR` |
| CUP Engineering | `GE_HDWR_WALL_ANCHOR` |
| 3/8" ATC Engineering | `GE_HDWR_WALL_ANCHOR` |
| Adhesive Anchor | `GE_HDWR_ANCHOR_ADHESIVE` |
| Embedded Anchor | `GE_HDWR_ANCHOR_EMBEDDED` |
| J-Bolt Anchor | `GE_HDWR_ANCHOR_J-BOLT` |
| Screw Anchor | `GE_HDWR_ANCHOR_SCREW` |
| MAS Anchor | `GE_HDWR_ANCHOR_MAS` |
| None | (no child script) |

### System Requirements
- **No Beams Required**: The script obtains all geometric information from the wall element itself (origin, axis vectors, width, opening locations)
- **hsbCAD Installation**: Script accesses installation paths (`_kPathHsbInstall`) for child script references

## Usage Instructions

### Step 1: Launch the Script

**Command**: `TSLINSERT` or use the hsbCAD ribbon/toolbar to insert a TSL script.

**Action**: Browse to and select `GE_HDWR_WALL_ANCHOR_MULTIPLE` from the script list.

> **Note**: This script uses implicit insert mode. If you attempt to insert it a second time on the same wall, it will automatically erase itself to prevent duplicates.

### Step 2: Select the Target Wall

**Command Line Prompt**: `Select a Wall`

**Action**: Click on the wall element where anchors should be distributed. Only one wall can be selected per instance of this script.

**What Happens**:
- The script assigns itself to the selected wall element using `assignToElementGroup(el, TRUE, 0, 'Z')`
- It positions its origin at the wall's starting corner
- A small visual marker (circle with letter "E") appears at the wall origin in color 12 (light gray)

> **Important**: If you attempt to insert the script a second time on a wall that already has child anchors attached, the script will automatically erase itself to prevent duplicates. This is a built-in safety mechanism to avoid stacking multiple distribution controllers on the same wall.

### Step 3: Choose the Engineering Scenario

**Command Line Prompt**:
```
Specify Engineering Type: 1= 1/2 ATC; 2= 1/2 ATC+Anchor; 3= CUP; 4= 3/8 ATC;
5= Adhesive; 6= Embedded; 7= J-Bolt; 8= Screw; 9= MAS; 10= None -- [1/2/3/4/5/6/7/8/9/10]
```

**Action**: Type the number corresponding to your desired anchoring scenario and press Enter.

#### Scenario Details

| Number | Scenario Name | Child Script | Hardware Type Applied | Description |
|--------|--------------|--------------|----------------------|-------------|
| 1 | 1/2" ATC Engineering | `GE_HDWR_WALL_ANCHOR` | `1/2" ATC Rod` | Places 1/2" diameter all-thread-connected rods at each distribution point along the wall |
| 2 | 1/2" ATC & Anchor Engineering | `GE_HDWR_WALL_ANCHOR` | `3/8" ATC Rod` + `3/8" x 6" Screw Anchor` | **Combined scenario**: Places 3/8" ATC rods at rod points (wall ends and opening edges) AND 3/8" x 6" screw anchors at intermediate plate positions (offset by half the spacing value). Provides both vertical tie-down and lateral plate anchorage. |
| 3 | CUP Engineering | `GE_HDWR_WALL_ANCHOR` | `3/8" x 6" Screw Anchor` | Places 3/8" x 6" screw anchors at **both** rod points and plate positions, providing comprehensive plate anchorage across the entire wall |
| 4 | 3/8" ATC Engineering | `GE_HDWR_WALL_ANCHOR` | `3/8" ATC Rod` | Similar to scenario 1 but with 3/8" diameter ATC rods instead of 1/2" |
| 5 | Adhesive Anchor | `GE_HDWR_ANCHOR_ADHESIVE` | (Defined by child script) | Delegates to adhesive anchor child script for epoxy-set post-installed anchors |
| 6 | Embedded Anchor | `GE_HDWR_ANCHOR_EMBEDDED` | (Defined by child script) | Delegates to embedded anchor child script for cast-in-place anchors |
| 7 | J-Bolt Anchor | `GE_HDWR_ANCHOR_J-BOLT` | (Defined by child script) | Delegates to J-bolt child script for traditional J-bolt foundation anchors |
| 8 | Screw Anchor | `GE_HDWR_ANCHOR_SCREW` | (Defined by child script) | Delegates to screw anchor child script for concrete screw-type anchors |
| 9 | MAS Anchor | `GE_HDWR_ANCHOR_MAS` | (Defined by child script) | Delegates to MAS anchor child script for MAS anchoring system hardware |
| 10 | None | (no child script) | N/A | No hardware is placed. Useful for upper-floor walls or walls that do not require anchoring. This is the automatic default for walls detected on upper floors. |

**After Selection**: The script immediately calculates anchor positions and creates all child instances based on the current spacing parameter (default: 48 inches).

### Step 4: Adjust Properties (Optional)

**Action**: Select the master script instance (identified by the small "E" marker circle at the wall origin), then open the **Properties Palette** (Ctrl+1 or right-click → Properties) to modify parameters.

**Available Parameters**:
- **Scenario**: Change the engineering scenario (triggers automatic redistribution of all child anchors)
- **Spacing**: Adjust the on-center spacing between anchor points (triggers automatic redistribution)

Changes to these parameters trigger automatic erasure of existing child anchors and recreation with new settings.

### Step 5: Fine-Tune Child Anchors (Optional)

**Action**: Each child anchor instance created by this master script is a fully independent TSL entity. You can select any individual child anchor and modify its properties through the Properties Palette.

**Child-Level Parameters** (varies by child script):
- Hardware type/model selection
- Washer configuration
- Embedment depth
- Rod diameter and length
- Anchor spacing within the child instance

> **Note**: Refer to the documentation for the specific child script (e.g., `GE_HDWR_WALL_ANCHOR`, `GE_HDWR_ANCHOR_ADHESIVE`) for details on available child-level parameters.

## Properties Panel Parameters

The Properties Palette displays two main user-adjustable parameters when the master script instance is selected:

### Scenario (PropString)
- **Type**: Dropdown list
- **Default**: `1/2" ATC Engineering`
- **Index**: 0
- **Description**: The anchoring engineering scenario to apply to the wall. Determines which child TSL is created and what hardware types are passed to it.

**Available Options**:
1. 1/2" ATC Engineering
2. 1/2" ATC & Anchor Engineering
3. CUP Engineering
4. 3/8" ATC Engineering
5. Adhesive Anchor
6. Embedded Anchor
7. J-Bolt Anchor
8. Screw Anchor
9. MAS Anchor
10. None

**Behavior**: When changed, the script automatically erases all existing child anchor instances on the wall and creates new ones of the correct type. You do not need to manually remove old anchors before switching scenarios.

### Spacing (PropDouble)
- **Type**: Length
- **Default**: 48 inches (4 feet)
- **Index**: 0
- **Units**: Current drawing units (typically inches)
- **Description**: The on-center spacing between anchor points along the wall length. Anchors are distributed from each end of the wall and from each side of every opening, with this value controlling the interval between consecutive anchors.

**Distribution Behavior**:
The **Spacing** parameter controls two related distribution grids:

1. **Rod Points**: Anchor positions at regular intervals starting from:
   - Wall start edge (offset 3" inward from wall start)
   - Each opening edge (offset 5" from opening sides)
   - Wall end edge
   - Multiple wall segments (separated by openings) each receive their own independent distribution

2. **Plate Points** (used in scenarios 2 and 3 only): An additional set of positions offset by **half the spacing** from the rod points. This places anchors at midpoints between the rod locations, typically used for bottom plate screw anchors.

**Example**: With a 48" spacing:
- Rod points: 3", 51", 99", 147", etc. (every 48")
- Plate points: 27", 75", 123", etc. (every 48", starting at 24" offset)

**Recalculation Trigger**: When the Spacing value is changed in the Properties Palette, all existing child anchors are automatically erased and new ones are created at the updated positions.

## Right-Click Context Menu

When you right-click on the master script instance, the following menu options are available:

### Re-distribute
**Action**: Erases all existing child anchor instances on the wall and recalculates their positions based on the current Scenario and Spacing values.

**When to Use**:
- After modifying wall geometry (adding or moving openings, extending the wall, changing wall length)
- After manually deleting some child anchors and wanting to restore complete distribution
- After changing wall element properties that might affect anchor placement

**What Happens**:
1. Script scans all TSL instances attached to the wall element
2. Erases all instances whose script name matches any entry in the child script list
3. Recalculates distribution points based on current wall geometry and parameters
4. Creates new child anchor instances at all calculated positions

### Remove Existing
**Action**: Erases all child anchor TSL instances that belong to the current wall element, regardless of their specific anchor type.

**When to Use**:
- Preparing to manually place anchors at specific locations rather than using automatic distribution
- Removing all anchoring from a wall that no longer requires it
- Clearing anchors before switching to a different anchoring system

**What Happens**:
1. Script scans all TSL instances attached to the wall element
2. Identifies all instances whose script name matches any entry in the child script list (`GE_HDWR_WALL_ANCHOR`, `GE_HDWR_ANCHOR_ADHESIVE`, etc.)
3. Validates that each instance is attached to the same wall element (by handle comparison)
4. Erases all matching instances

**Important**: This provides a quick way to strip all automatically placed anchors from a wall without having to select them individually. Only anchors on the same wall element are affected; anchors on other walls remain untouched.

## Distribution Logic and Calculation

Understanding how the script calculates anchor positions is essential for troubleshooting and optimization.

### Wall Geometry Analysis

1. **Wall Length Calculation**:
   ```
   Wall Length = abs(el.vecX().dotProduct(elSF.ptEndOutline() - elSF.ptStartOutline())) - U(3)
   ```
   - Uses `ptStartOutline()` and `ptEndOutline()` from the `ElementWallSF` interface
   - Subtracts 3 inches from total for edge clearance
   - Projects along wall X-axis to handle angled or split walls

2. **Opening Detection**:
   - Retrieves all openings via `el.opening()`
   - For each opening, creates exclusion zones extending 5 inches beyond each side
   - Openings divide the wall into multiple segments for independent distribution

### Distribution Point Generation

#### Rod Points (All Scenarios)
Starting points for rod anchor distribution:
1. Wall start edge + 3" offset
2. Each opening left edge - 5" clearance
3. Each opening right edge + 5" clearance
4. Wall end edge - 3" offset

From each starting point, the script generates additional points at the specified spacing until reaching the next boundary (opening or wall end).

**Algorithm**:
```
For each wall segment between openings:
    ptNext = ptStart + Spacing * wall.vecX()
    While ptNext is between ptStart and ptEnd:
        Add ptNext to distribution array
        ptNext += Spacing * wall.vecX()
```

#### Plate Points (Scenarios 2 and 3 Only)
Additional anchor positions offset by half the rod spacing:
1. Start at Rod Point + (Spacing / 2)
2. Continue at regular Spacing intervals

**Example Distribution** (48" spacing, 240" wall with 36" door at 120"):

**Rod Points**:
- Segment 1 (0-115"): 3", 51", 99"
- Segment 2 (156-240"): 161", 209"

**Plate Points**:
- Segment 1: 27", 75"
- Segment 2: 185", 233"

### Opening Clearance Logic

The script maintains precise clearances around openings:

**Opening Exclusion Zone**:
- 5 inches on each side of the opening
- Applied to both rod points and plate points
- Low sill openings (< 16") also exclude plate points within the opening span

**Edge Clearance**:
- 3 inches from wall start edge
- 3 inches from wall end edge
- Prevents anchors from being placed at the very edge of the bottom plate

### Point Ordering and Sorting

After all distribution points are calculated, the script sorts them along the wall's X-axis:
```
arPtStartRod = Line(el.ptOrg(), el.vecX()).orderPoints(arPtStartRod)
```
This ensures consistent left-to-right placement regardless of the order in which wall segments are processed.

## Child Script Creation and Communication

The master script uses programmatic TSL instantiation to create child anchor instances.

### Creation Method

```c
TslInst tsl;
tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints,
             lstPropInt, lstPropDouble, lstPropString, TRUE, mpPropRod);
```

**Parameters**:
- `sScriptName`: Child script filename (e.g., `"GE_HDWR_WALL_ANCHOR"`)
- `vecUcsX`, `vecUcsY`: World coordinate system axes (`_XW`, `_YW`)
- `lstBeams`: Empty array (no beams required)
- `lstEnts`: Single-element array containing the wall element
- `lstPoints`: Single-element array containing the anchor insertion point
- `lstPropInt`, `lstPropDouble`, `lstPropString`: Empty arrays (not used)
- `TRUE`: Create visible instance
- `mpPropRod`: Map containing hardware type specification

### Hardware Type Propagation

For scenarios 1-4 (all using `GE_HDWR_WALL_ANCHOR` child script), the master script passes hardware type information via Map parameters:

**Scenario 1** (1/2" ATC):
```c
mpPropRod1_2.appendString("  Hardware Type", "1/2\" ATC Rod");
```

**Scenario 2** (1/2" ATC & Anchor):
```c
mpPropRod3_8.appendString("  Hardware Type", "3/8\" ATC Rod");
mpPropAnchor.appendString("  Hardware Type", "3/8\" x 6\" Screw Anchor");
```

**Scenario 3** (CUP):
```c
mpPropAnchor.appendString("  Hardware Type", "3/8\" x 6\" Screw Anchor");
```

**Scenario 4** (3/8" ATC):
```c
mpPropRod3_8.appendString("  Hardware Type", "3/8\" ATC Rod");
```

**Scenarios 5-9**: Delegate entirely to the specialized child script with default Map properties.

### Parent-Child Relationship

**Architecture**:
- **Parent**: `GE_HDWR_WALL_ANCHOR_MULTIPLE` (this script) acts as the **master controller**
- **Children**: Individual anchor instances (`GE_HDWR_WALL_ANCHOR`, `GE_HDWR_ANCHOR_ADHESIVE`, etc.)

**Key Characteristics**:
- The master script does **not** create any 3D geometry itself
- All geometry generation, drill operations, and hardware BOM entries are handled by child scripts
- The master script maintains parallel arrays (`arTypes` and `arTSLNames`) that map each scenario name to its corresponding child TSL script name
- Child instances are fully independent after creation and can be modified individually
- The master script tracks children via script name matching when performing redistribution or removal

## Second-Floor Auto-Detection

The script includes intelligent multi-story logic to prevent duplicate anchoring on upper floors.

### Detection Logic

```c
if (_bOnInsert || _bOnDbCreated) {
    double dTest = _ZW.dotProduct(el.ptOrg() - _PtW);
    if (dTest > U(59)) {
        strType.set(arTypes[arTypes.length()-1]);  // Set to "None"
        reportMessage("\n" + scriptName() + " has been set to not add engineering components to wall " + el.number());
    }
}
```

**How It Works**:
1. Calculates the vertical distance from world origin to wall origin
2. If wall origin is more than 59 inches above the world Z-plane, assumes second floor or higher
3. Automatically sets Scenario to "None"
4. Displays message to user explaining the automatic setting
5. No child anchors are created

**Rationale**:
- In typical multi-story construction, continuous rod systems extend from foundation through multiple floors
- Anchoring hardware should only be placed at the first floor level
- Upper floor walls should not receive duplicate hardware
- The 59" threshold represents approximately 5 feet minus typical floor thickness, catching most second-floor walls

**Override**:
If you need to override this behavior (e.g., for a split-level design or unusual floor heights), simply change the Scenario back to the desired type in the Properties Palette after insertion.

## Map-Based Automation

For batch processing or automation workflows, the script accepts a Map key to pre-select the engineering scenario without command-line interaction.

### Map Key Interface

**Map Key**: `TYPE` (String)

**Value**: An integer (as string) from 1 to 10 corresponding to the scenario numbers

**Behavior**:
```c
if (_Map.hasString("TYPE")) {
    int nMap = _Map.getString("TYPE").atoi();
    if (nMap > 0 && nMap < arTypes.length()) {
        strType.set(arTypes[nMap-1]);
        _Map.removeAt("TYPE", 0);
    }
}
```

**Usage Example**:
```c
// External automation script
Map mpControl;
mpControl.appendString("TYPE", "3");  // Select CUP Engineering

TslInst tslAnchor;
tslAnchor.dbCreate("GE_HDWR_WALL_ANCHOR_MULTIPLE", _XW, _YW, lstBeams, lstEnts,
                   lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpControl);
```

This allows external automation scripts to insert `GE_HDWR_WALL_ANCHOR_MULTIPLE` on multiple walls with pre-configured scenarios without user prompts.

**Map Cleanup**: The script removes the "TYPE" key from the Map after reading it, preventing contamination of child instances.

## Visual Indicators

The script provides visual feedback to help users locate and identify the master controller instance.

### Marker Display

**Geometry**:
- Small circle with radius = 0.5 inches
- Centered at wall origin (bottom corner of wall)
- Offset slightly in X and Z to avoid overlapping with wall geometry

**Text Label**:
- Letter "E" (for "Engineering")
- Text height: 0.5 inches
- Aligned with world coordinate system

**Color**: 12 (light gray/cyan)

**Purpose**:
- Marks the presence of the master controller
- Helps users locate the script instance for property editing
- Only visible in Model Space
- Does not appear on printed output or shop drawings

**Location Calculation**:
```c
Point3d pt = el.ptOrg() - el.vecZ() * (el.dBeamWidth() - dTH) + el.vecX() * dTH;
```
This positions the marker at the wall origin, offset slightly for visibility.

## Recalculation Triggers

The script automatically recalculates and redistributes child anchors under specific conditions:

### Trigger Conditions

1. **On Initial Insertion** (`_bOnInsert`):
   - First-time creation of the master script instance
   - User selects wall and scenario
   - Initial distribution is calculated and created

2. **On "Re-distribute" Menu Selection** (`_kExecuteKey == strRecalc`):
   - User explicitly requests redistribution via right-click menu
   - All existing child anchors are erased
   - New distribution is calculated based on current parameters

3. **On Element Reconstruction with No Children** (`_bOnElementConstructed && nQtyRods == 0`):
   - Wall element is reconstructed (e.g., after wall edit)
   - No child anchors currently exist on the wall
   - Script regenerates distribution to restore anchors

4. **On Spacing Property Change** (`_kNameLastChangedProp == "Spacing"`):
   - User modifies the Spacing parameter in Properties Palette
   - Triggers immediate redistribution with new spacing value

**Common Pattern**:
```c
if (_bOnInsert || _kExecuteKey == strRecalc ||
    (_bOnElementConstructed && nQtyRods == 0) ||
    _kNameLastChangedProp == "Spacing") {

    // Erase existing children
    // Recalculate distribution points
    // Create new child instances
}
```

## Duplicate Detection and Prevention

The script implements robust duplicate prevention to avoid stacking multiple distribution controllers on the same wall.

### Detection Method

```c
TslInst tslElAll[] = el.tslInstAttached();
for (int i = 0; i < tslElAll.length(); i++) {
    if (arTSLNames.find(tslElAll[i].scriptName(), -1) > -1 &&
        tslElAll[i].handle() != _ThisInst.handle()) {

        Element elTsl = tslElAll[i].element();
        String strEl;
        if (elTsl.bIsValid()) strEl = elTsl.number();

        if (strEl == el.number()) {
            eraseInstance();
            return;
        }
    }
}
```

**How It Works**:
1. Retrieves all TSL instances attached to the wall element
2. Checks if any instance's script name matches any entry in the child script list
3. Excludes the current instance (by handle comparison)
4. Validates that the matching instance is attached to the same wall (by element number)
5. If a duplicate is found, erases the new instance to prevent conflicts

**Benefits**:
- Prevents accidental double-insertion of the master script
- Ensures only one distribution controller per wall
- Avoids creating duplicate child anchors on the same wall
- Maintains data integrity and prevents BOM errors

### Implicit Insert Mode

The script uses `#ImplInsert 1`, which enforces single-insertion behavior:

```c
if (insertCycleCount() > 1) eraseInstance();
```

This provides an additional layer of duplicate prevention at the insertion level.

## Technical Implementation Details

### Script Type and Metadata

**Type**: Object (O-Type)
- Not attached to specific beams
- Attached to wall element via `assignToElementGroup()`
- Survives wall modifications and updates

**Implicit Insert**: `#ImplInsert 1`
- Allows only one insertion cycle
- Second attempt triggers automatic self-erasure

**File State**: `#FileState 1`
- Script is in released/production state

### Version History

The script has evolved significantly since its initial release:

**Version 1.0** (Original):
- Basic ATC rod distribution
- Single scenario support

**Version 0.9-1.3** (2010):
- Added "None" rule for second-floor walls
- Improved opening handling
- CUP rule adjustments

**Version 1.4-1.5** (2010-2012):
- Added Spacing property
- Separated custom and general versions

**Version 1.6-1.8** (2012):
- Child TSL name changes (`GE_HDWR_ATC_ROD_ANCHORS` → `GE_HDWR_ATC_ROD_ANCHOR` → `GE_HDWR_WALL_ANCHOR`)
- Description and thumbnail added
- Code optimization for string variables

**Version 1.9** (March 2012):
- Major rename: `GE_HDWR_ATC_ROD_MASTER` → `GE_HDWR_WALL_ANCHOR_MULTIPLE`
- Reflects expanded role beyond ATC rod-only distribution

**Version 1.10** (June 2014):
- Added support for multiple child TSL types beyond original `GE_HDWR_WALL_ANCHOR`
- Code restructured for easier addition of new child anchor TSLs
- Enhanced auto-deletion and recalc triggers to work with any TSL in the anchor list

### Element Assignment

```c
assignToElementGroup(el, TRUE, 0, 'Z');
```

**Parameters**:
- `el`: Wall element
- `TRUE`: Assign to element group
- `0`: Group index
- `'Z'`: Binding axis (Z-axis, perpendicular to wall face)

**Effect**:
- Script moves and recalculates when the wall is modified
- Maintains association with wall element throughout wall lifecycle
- Ensures anchors update when wall geometry changes

### Performance Optimization

**Envelope vs. Real Body**:
- The script uses simple marker geometry (circle + text) instead of complex solids
- No `realBody()` or `envelopeBody()` calls required
- Minimal computational overhead
- Fast regeneration even with many child instances

**Child Counting**:
```c
int nQtyRods = 0;
for (int i = 0; i < tslElAll.length(); i++) {
    if (arTSLNames.find(tslElAll[i].scriptName(), -1) > -1) {
        // Validate element attachment
        if (strEl == el.number()) nQtyRods++;
    }
}
```
Used to determine if recalculation is needed after element reconstruction.

## Troubleshooting and Best Practices

### Common Issues and Solutions

#### Issue: Script erases itself immediately after insertion
**Cause**: Attempting to insert a second master instance on a wall that already has child anchors

**Solution**:
- Use "Remove Existing" context menu option to clear existing anchors first
- Or select the existing master instance and modify its properties instead of inserting a new one

#### Issue: Anchors are not placed where expected
**Cause**: Opening clearances or edge offsets reducing available distribution space

**Solution**:
- Check wall length and opening positions
- Verify 3" edge clearance and 5" opening clearance are appropriate for your design
- Adjust spacing parameter to fit within available segments
- Use debug mode (`_bOnDebug`) to visualize calculated distribution points

#### Issue: Second-floor walls receive "None" scenario automatically
**Cause**: Wall origin is more than 59" above world origin, triggering second-floor detection

**Solution**:
- If this is incorrect (e.g., split-level design), manually change Scenario in Properties Palette
- Adjust wall Z-position if placement is incorrect
- For permanent override, modify the 59" threshold in the script (requires programming knowledge)

#### Issue: Some child anchors are missing after redistribution
**Cause**: Wall segment too short to fit anchors at specified spacing

**Solution**:
- Reduce spacing parameter
- Check for very narrow wall segments between closely spaced openings
- Consider manual placement for problematic areas

#### Issue: Child anchors remain after switching to "None" scenario
**Cause**: Scenario change only affects new distribution, existing anchors must be removed

**Solution**:
- Use "Remove Existing" context menu option
- Or use "Re-distribute" which erases existing children before applying new scenario

### Best Practices

#### For Production Efficiency
1. **Use for entire building perimeters**: Apply to every exterior wall in the project for consistent anchoring
2. **Combine with automation**: Use Map-based scenario selection for batch processing of multiple walls
3. **Set spacing early**: Establish standard spacing (typically 48" or 60") before distributing to multiple walls
4. **Verify before finalizing**: Review anchor distribution before generating shop drawings or CNC output

#### For Design Flexibility
1. **Start with automatic distribution**: Use the master script for initial layout
2. **Fine-tune individual anchors**: After distribution, select and modify specific child anchors as needed
3. **Use different scenarios per wall**: Different walls can have different scenarios (e.g., 1/2" ATC for shear walls, CUP for standard walls)
4. **Adjust after wall edits**: Use "Re-distribute" after adding or moving openings

#### For Multi-Story Projects
1. **Let second-floor auto-detection work**: Don't override unless necessary
2. **Verify continuous rod systems**: Ensure first-floor anchors support continuous rods through upper floors
3. **Document exceptions**: Note any walls that require manual scenario override
4. **Check vertical alignment**: Ensure upper-floor walls align with first-floor anchor points

#### For Collaboration
1. **Visual markers help coordination**: The "E" marker makes master script instances easy to locate
2. **Document scenario choices**: Record why specific scenarios were chosen for different walls
3. **Standardize spacing**: Use consistent spacing across projects for estimating and purchasing
4. **Share child script library**: Ensure all team members have the same child script versions

## Related Scripts

### Child Scripts (Direct Dependencies)

| Script Name | Purpose | Used By Scenario |
|-------------|---------|------------------|
| `GE_HDWR_WALL_ANCHOR` | Generic wall anchor with configurable hardware types | Scenarios 1-4 (ATC and CUP) |
| `GE_HDWR_ANCHOR_ADHESIVE` | Adhesive-set post-installed anchors | Scenario 5 |
| `GE_HDWR_ANCHOR_EMBEDDED` | Cast-in-place embedded anchors | Scenario 6 |
| `GE_HDWR_ANCHOR_J-BOLT` | Traditional J-bolt foundation anchors | Scenario 7 |
| `GE_HDWR_ANCHOR_SCREW` | Concrete screw-type anchors | Scenario 8 |
| `GE_HDWR_ANCHOR_MAS` | MAS anchoring system hardware | Scenario 9 |

### Related Wall Tools

| Script Name | Purpose | Relationship |
|-------------|---------|--------------|
| `GE_HDWR_WALL_HOLD_DOWN` | Wall hold-down hardware distribution | Similar distribution controller for hold-down devices |
| `GE_WALL_SHEAR_WALL` | Shear wall definition and engineering | Often used together with anchoring |
| `HSB_W-Post` | Wall post/stud distribution | Complementary wall framing tool |
| `HSB_E-Identification` | Element identification and marking | Used to identify walls before anchoring |

### Workflow Integration Scripts

| Script Name | Purpose | Workflow Stage |
|-------------|---------|----------------|
| `hsb_CreateElement` | Element creation from beams | Prerequisite: Creates wall elements |
| `HSB_G-BillOfMaterial` | BOM generation | Downstream: Includes anchor quantities |
| `sd_BeamAssembly` | Shop drawing generation | Downstream: Shows anchor placement |
| `HSB_G-Stack` | Logistics and shipping | Downstream: Considers hardware in shipping plans |

## Examples and Use Cases

### Example 1: Standard Perimeter Wall Anchoring

**Scenario**: 8-foot tall exterior walls, 48" spacing, 1/2" ATC rods

**Steps**:
1. Insert `GE_HDWR_WALL_ANCHOR_MULTIPLE` on first perimeter wall
2. Select wall when prompted
3. Choose scenario 1 (1/2" ATC Engineering)
4. Verify anchor distribution in Model Space
5. Copy to remaining perimeter walls (or use automation script)

**Result**: Consistent 1/2" ATC rod distribution across entire building perimeter at 48" o.c.

### Example 2: Shear Wall with Combined Hardware

**Scenario**: Shear wall requiring both vertical tie-down and bottom plate anchorage

**Steps**:
1. Insert `GE_HDWR_WALL_ANCHOR_MULTIPLE` on shear wall
2. Select wall when prompted
3. Choose scenario 2 (1/2" ATC & Anchor Engineering)
4. Adjust spacing to 24" for increased density
5. Verify rod points (every 24") and plate points (offset 12")

**Result**: Dense anchor distribution with 3/8" ATC rods and intermediate screw anchors for comprehensive shear resistance.

### Example 3: Multi-Story Building Automation

**Scenario**: 20 exterior walls across 2 floors, mixed scenarios

**Steps**:
1. Create automation script with Map-based scenario selection
2. For first-floor walls: Set `TYPE = "1"`  (1/2" ATC)
3. For second-floor walls: Let auto-detection set to "None"
4. Run batch insertion on all walls
5. Review and adjust any exceptions

**Result**: First floor fully anchored, second floor correctly skipped, minimal manual intervention.

### Example 4: Renovation with Existing Openings

**Scenario**: Adding anchors to existing wall with 4 windows

**Steps**:
1. Insert `GE_HDWR_WALL_ANCHOR_MULTIPLE` on wall
2. Select wall (wall already has window openings defined)
3. Choose scenario 3 (CUP Engineering)
4. Script automatically avoids all 4 window openings
5. Verify 5" clearance on each side of each opening

**Result**: Anchors distributed in 5 solid wall segments between/around windows with proper clearances.

## Technical Notes

### Script Architecture

**Design Pattern**: Parent-Child Controller
- **Master script** (this script): Handles distribution logic, parameter management, and child lifecycle
- **Child scripts**: Handle geometry creation, hardware specification, and BOM contribution

**Benefits**:
- Separation of concerns (distribution logic vs. geometry creation)
- Reusable child scripts (can be inserted individually or via master)
- Easier maintenance (child scripts can be updated independently)
- Scalable (easy to add new anchor types by adding to `arTypes` and `arTSLNames` arrays)

### Array-Based Scenario Management

```c
String arTypes[0], arTSLNames[0];
arTypes.append("1/2\" ATC Engineering");       arTSLNames.append("GE_HDWR_WALL_ANCHOR");
arTypes.append("1/2\" ATC & Anchor Engineering"); arTSLNames.append("GE_HDWR_WALL_ANCHOR");
// ... etc.
```

**Advantages**:
- Easy to add new scenarios (just append to both arrays)
- Automatic dropdown list generation
- Consistent index-based mapping between scenario names and child scripts
- Dynamic command-line prompt construction

### Child Script Name Resolution

The script maintains parallel arrays to map scenarios to child scripts:

**Mapping Table**:
```c
Index 0: "1/2\" ATC Engineering"            → "GE_HDWR_WALL_ANCHOR"
Index 1: "1/2\" ATC & Anchor Engineering"   → "GE_HDWR_WALL_ANCHOR"
Index 2: "CUP Engineering"                  → "GE_HDWR_WALL_ANCHOR"
Index 3: "3/8\" ATC Engineering"            → "GE_HDWR_WALL_ANCHOR"
Index 4: "Adhesive Anchor"                  → "GE_HDWR_ANCHOR_ADHESIVE"
Index 5: "Embedded Anchor"                  → "GE_HDWR_ANCHOR_EMBEDDED"
Index 6: "J-Bolt Anchor"                    → "GE_HDWR_ANCHOR_J-BOLT"
Index 7: "Screw Anchor"                     → "GE_HDWR_ANCHOR_SCREW"
Index 8: "MAS Anchor"                       → "GE_HDWR_ANCHOR_MAS"
Index 9: "None"                             → " " (empty)
```

**Resolution**:
```c
int nType = arTypes.find(strType) + 1;  // Get 1-based index
String sTSLToClone = arTSLNames[arTypes.find(strType)];  // Get corresponding child script name
```

### Coordinate System and Geometry

**World Coordinate System**:
- `_XW`: World X-axis (horizontal, typically building length direction)
- `_YW`: World Y-axis (horizontal, typically building width direction)
- `_ZW`: World Z-axis (vertical, gravity direction)

**Wall Local Coordinate System**:
- `el.vecX()`: Along wall length
- `el.vecY()`: Wall height direction (typically vertical)
- `el.vecZ()`: Perpendicular to wall face (wall thickness direction)

**Point Calculations**:
All anchor positions are calculated in world coordinates but use wall local axes for direction:
```c
Point3d ptNextRod = pt1 + dAddRod * el.vecX();
```

### Opening Handling Algorithm

**Complex Multi-Opening Logic**:
1. Collect all wall openings via `el.opening()`
2. For each opening, define start and end points with 5" clearance
3. Add these points to the `arPtStartRod` array as distribution boundaries
4. Sort all points along wall X-axis
5. Process segments between consecutive boundary points
6. Generate distribution within each valid segment

**Benefit**: Handles any number of openings of any size automatically without special cases.

### Debug Mode Visualization

When `_bOnDebug` is true (typically when `_bOnDbCreated` is true):
```c
if (_bOnDebug) {
    for (int r = 0; r < arPtStartRod.length(); r++) {
        Point3d ptR = arPtStartRod[r];
        ptR.vis(3);  // Draw rod points in color 3 (green)
    }
    for (int r = 0; r < arPtStartPlate.length(); r++) {
        Point3d ptP = arPtStartPlate[r];
        ptP.vis(1);  // Draw plate points in color 1 (red)
    }
}
```

**Purpose**: Allows visual verification of calculated distribution points before child script creation.

**How to Enable**: Set `_bOnDbCreated` flag in development mode (typically via MapObject or developer settings).

## Summary

**GE_HDWR_WALL_ANCHOR_MULTIPLE** is a powerful automation tool that transforms the tedious process of manual anchor placement into a single-click operation. By intelligently calculating distribution points, avoiding openings, and delegating geometry creation to specialized child scripts, it enables rapid, consistent, and error-free anchoring across entire building projects.

**Key Takeaways**:
- **Efficiency**: Anchor an entire wall in seconds instead of minutes
- **Consistency**: Uniform spacing and clearances across all walls
- **Flexibility**: Ten different scenarios covering most North American anchoring requirements
- **Intelligence**: Automatic second-floor detection and opening avoidance
- **Scalability**: Designed for batch processing and automation workflows
- **Maintainability**: Parent-child architecture separates distribution logic from hardware specifics

**When to Use**:
- Production housing projects with repetitive wall layouts
- Commercial projects requiring consistent anchoring specifications
- Multi-story buildings where second-floor auto-detection saves time
- Any project where manual anchor placement is time-consuming or error-prone

**When Not to Use**:
- Walls with highly irregular geometry requiring custom anchor placement
- Projects with unique anchoring requirements not covered by the ten scenarios
- Situations where manual placement provides better control over specific locations

For most timber frame and light-frame construction projects, this script represents the **recommended workflow** for wall anchoring distribution, offering an optimal balance of automation, control, and flexibility.
