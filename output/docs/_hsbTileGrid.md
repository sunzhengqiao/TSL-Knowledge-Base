# _hsbTileGrid

## Overview

The **_hsbTileGrid** script is the foundational tile distribution engine for the hsbCAD roof tiling system. It creates a two-dimensional grid representing the horizontal (left-to-right) and vertical (eave-to-ridge) distribution of roof tiles on selected roofplanes. This tool serves as the core calculation and visualization layer for all downstream roof tiling operations including verge tiles, ridge tiles, lath distribution, and material quantity takeoffs.

**Key Capabilities:**
- Calculates optimal tile spacing based on manufacturer tile family specifications
- Visualizes tile grid overlay directly on 3D roofplane geometry
- Provides color-coded distribution range indicators (green = within tolerance, red = requires adjustment)
- Exports comprehensive tiling data to roofplane entities for consumption by related tools
- Supports both standard and staggered tile distribution patterns
- Handles complex roof geometries including openings, dormers, chimneys, and multi-ridge configurations

## Script Type and Environment

| Property | Value |
|----------|-------|
| **Script Type** | O (Object - Parametric Entity) |
| **Workspace** | Model Space |
| **Required Beams** | 0 |
| **Required Entities** | 1+ ERoofPlane entities |
| **Major Version** | 5 |
| **Minor Version** | 9 |
| **Last Updated** | July 22, 2023 |
| **DLL Dependencies** | `RoofTilingManager.dll` (in `[Install]\Utilities\RoofTiles\`) |

## Prerequisites

### Required Data
1. **ERoofPlane Entity**: One or more roof plane entities must exist in the drawing. The script attaches to these entities.

2. **Roof Tile Style Assignment**: Each target roofplane must have a **roof tile family** assigned through the hsbCAD Roof Tiling Manager. The script extracts the following data from the roofplane's embedded tile definition:
   - Tile family name, manufacturer ID, and product specifications
   - Standard tile horizontal spacing range (minimum/maximum)
   - Standard tile vertical spacing range (minimum/maximum)
   - Half-tile availability and spacing (for staggered patterns)
   - Eave definition including eave tile offset and lath dimensions
   - Ridge connection definition including ridge batten distance
   - Verge tile definitions (left/right edge tiles)
   - Tile distribution mode (0 = standard, 1 = staggered)

3. **Valid Dimension Style**: At least one dimension style must be available in the drawing for text and dimension annotations.

### Recommended Setup
- Define verge edge topology on roofplanes to enable automatic horizontal alignment detection
- Configure eave and ridge definitions through the Roof Tiling Manager for complete vertical distribution data
- Ensure roofplane geometry is finalized before running the script (the instances dynamically recalculate when roofplanes change, but major geometry changes may require recreation)

## Dual-Instance Architecture

The `_hsbTileGrid` script uses a unique **dual-instance pattern**. When you insert the script on a roofplane, it creates **two separate TSL instances**:

1. **Horizontal Grid Instance** (mode=1)
   - Distributes tile columns from left to right
   - Controls horizontal alignment (left/center/right/automatic)
   - Manages half-tile column placement for staggered patterns
   - Displays as `[ScriptName]-Horizontal` in the Properties Palette

2. **Vertical Grid Instance** (mode=2)
   - Distributes tile rows from eave to ridge
   - Controls Z-offset (counter batten/insulation buildup)
   - Manages eave front cut orientation
   - Manages fixed lath positions
   - Supports sloped dormer roof adjustments
   - Displays as `[ScriptName]-Vertical` in the Properties Palette

The **inserter instance** (mode=0) is a temporary creation helper that spawns both grid instances then deletes itself.

**Why Two Instances?**
- Different parameter sets for horizontal vs. vertical distribution
- Independent control over each distribution direction
- Horizontal instance exports column data, vertical instance exports row data and calculates tile counts
- Both instances share the same roofplane but have distinct OPM property sets

## Installation and First-Time Execution

### Launching the Script

1. **Start the tool**: Run `_hsbTileGrid` from the hsbCAD TSL menu, toolbar, or command line.

2. **Properties Dialog** (first insertion only): On initial insertion, a properties dialog appears with the following initial configuration options:

   | Parameter | Default | Description |
   |-----------|---------|-------------|
   | **Z-Offset** | 0 mm | Total distance from rafter top to tile lath underside |
   | **Horizontal Grid Alignment** | Automatic | Left, Center, Right, or Automatic (auto-detects from verge topology) |
   | **Eave front cut** | by Roofplane | Controls eave front cut orientation: by Roofplane, Plumb, or perpendicular to roof |
   | **Dimstyle** | (sorted list) | Dimension style for annotations |
   | **Text Height** | 80 mm | Height of annotation text |
   | **Display Content** | All | Controls visibility: All, Dimension, or Grid |
   | **Group** | (empty) | Optional group assignment path |

3. **Select Roofplane(s)**: The command prompts `"Select roofplane(s)"`. Click one or more ERoofPlane entities in the model. You may select:
   - **Main roofplanes**: The tool creates horizontal and vertical grid instances on each
   - **Opening roofplanes** (dormers, chimneys): Automatically identified as openings and subtracted from the tiling area of the parent roof

4. **Automatic Instance Creation**: For each selected main roofplane, the script creates:
   - One horizontal grid instance (if not already attached)
   - One vertical grid instance (if not already attached)

   If a grid instance already exists on a roofplane, the script reports `"[ScriptName]-[Horizontal/Vertical] already attached to roofplane"` and skips that direction.

5. **Catalog Defaults**: If a `_Default` catalog entry exists for this script (created via the "Save defaults" context menu), the tool automatically applies those saved property values to new instances.

### Silent Execution

After the first insertion with dialog, subsequent executions can be silent by saving a `_Default` catalog entry. The script will then use the saved defaults without prompting the user.

## Parameter Reference

### Display Category (Both Instances)

#### Dimstyle
- **Type**: PropString (dropdown)
- **Default**: Sorted list of available dimension styles
- **Description**: Selects the dimension style used for all text and dimension annotations displayed on the grid. If the catalog entry references a dimension style not present in the current drawing, the script resets to the first available style to prevent OPM display issues.

#### Text Height
- **Type**: PropDouble
- **Default**: 80 mm
- **Unit**: Length (mm/inches depending on drawing template)
- **Description**: Sets the height of annotation text displayed on the grid including manufacturer name, tile family, and surface/color information.

#### Display Content
- **Type**: PropString (dropdown)
- **Options**: All | Dimension | Grid
- **Default**: All
- **Description**: Controls what is displayed on the roofplane:
  - **All**: Shows both grid lines and dimension annotations
  - **Dimension**: Shows only dimension annotations (hides grid lines)
  - **Grid**: Shows only grid lines (hides dimension annotations)
- **Shortcut**: Double-click the instance to cycle through these modes: All → Dimension → Grid → All

### General Category (Both Instances)

#### Group
- **Type**: PropString (text input)
- **Default**: (empty)
- **Description**: Assigns the instance to an hsbCAD group for organizational purposes. Supports three naming patterns:

  **(A) Absolute Group Path**: `House\Roof\Tiling`
  - Creates or assigns to the exact path specified
  - Levels separated by backslash (`\`)

  **(B) Relative Group Name**: `Tiling`
  - Places the instance below the roofplane's parent group
  - If roofplane is in `House\5000 Roof`, instance is assigned to `House\5000 Roof\Tiling`

  **(C) Relative with Wildcards**: `**80 Tiling`
  - Copies characters from the parent group name using wildcards (`*`)
  - If roofplane is in `House\5000 Roof`, `**80 Tiling` creates `House\5080 Tiling`
  - The `**` copies two characters from the parent group name (`50` from `5000`)

### Geometry Category (Vertical Instance Only)

#### Z-Offset
- **Type**: PropDouble
- **Default**: 0 mm
- **Unit**: Length
- **Range**: 0 to unlimited
- **Description**: Defines the total distance between the upper face of the rafter (roofplane surface) and the underside of the tile lath. This accounts for:
  - Counter battens running perpendicular to the main laths
  - Insulation boards between structural roof and tile plane
  - Ventilation air gaps
  - Any other buildup layers
- **Effect on Geometry**:
  - Shifts the entire tile distribution plane upward by this distance
  - Affects chimney opening intersection (chimneys are re-intersected with the offset plane)
  - Modifies eave overhang calculation when combined with eave front cut mode
- **Export**: Stored in roofplane's `Hsb_TileExportData` SubMapX for downstream tool consumption
- **Trigger**: Changing this value triggers a dependency update, causing horizontal grid instance and related tools to recalculate

#### Eave front cut
- **Type**: PropString (dropdown)
- **Options**: by Roofplane | Plumb | perpendicular to roof
- **Default**: by Roofplane
- **Description**: Overrides the orientation of the eaves front cut, which affects how the eave is intersected when the Z-Offset is greater than zero.
  - **by Roofplane**: Uses the roofplane's own front cut setting (reads the `FRONTCUTPERPTOROOFPLANE` property from the ERoofPlane entity)
  - **Plumb**: Forces a vertical (plumb) cut at the eave, extending straight down from the offset tile plane
  - **perpendicular to roof**: Forces a cut perpendicular to the roof slope
- **Impact**:
  - With Z-Offset > 0 and "perpendicular to roof" mode, the eave edge moves back along the roof slope by `Z-Offset * tan(pitch)`
  - Affects eave tile overhang calculation and vertical distribution starting point
- **Trigger**: Changing this value triggers a dependency update

### Geometry Category (Vertical Instance - Sloped Dormer)

#### Adjust sloped dormer
- **Type**: PropString (dropdown)
- **Options**: No adjustment | Adjust tiling | Adjust pitch upwards | Adjust pitch downwards | Move roofplane upwards | Move roofplane downwards
- **Default**: No adjustment
- **Visibility**: Only appears when a single-pitched dormer roof connection is detected
- **Description**: Controls how the script handles the intersection between a sloped dormer roof and the main roof to maintain continuous tile coursing.

**Detection Logic**: The script detects a sloped dormer when:
- A neighboring roofplane exists with a different pitch
- The neighboring roofplane's vertical distribution intersects the current roofplane's tile plane
- Both roofplanes share the same horizontal orientation (eave direction)

**Adjustment Options**:

1. **No adjustment**:
   - The dormer tiling is calculated independently
   - No attempt is made to match the main roof tile coursing

2. **Adjust tiling**:
   - Recalculates the dormer's tile spacing to align with the main roof's tile courses
   - The dormer roofplane geometry is not modified
   - Tile spacing is adjusted within allowable min/max range to hit the intersection point

3. **Adjust pitch upwards/downwards**:
   - Physically modifies the dormer roofplane angle to align tile courses
   - Rotates the dormer roof around the eave line
   - Adjusts the ridge height to match the intersection point with the main roof grid
   - Stores original roofplane vertices in `_Map` for restoration

4. **Move roofplane upwards/downwards**:
   - Vertically shifts the entire dormer roofplane (in WCS Z-direction)
   - Does not change the roof pitch
   - Adjusts the elevation to align tile courses with the main roof

**Restoration**: When switching from an adjustment mode back to "No adjustment" or changing the Z-Offset, the script restores the original roofplane geometry from the saved `mapPtsEr` map data.

### Grid Category (Horizontal Instance Only)

#### Horizontal Grid Alignment
- **Type**: PropString (dropdown)
- **Options**: Left | Center | Right | (Automatic - only during insertion)
- **Default**: Automatic (during insertion), resolves to Left/Center/Right after creation
- **Description**: Controls how the horizontal tile columns are aligned on the roofplane.

**Alignment Modes**:

1. **Left**:
   - Distribution starts from the left verge edge
   - Remainder space (if any) appears at the right edge
   - Use when right edge is a valley, hip, or open edge

2. **Center**:
   - Distribution is centered on the roofplane
   - Remainder space is split equally between left and right edges
   - Use for gable roofs with symmetrical verges

3. **Right**:
   - Distribution starts from the right verge edge
   - Remainder space (if any) appears at the left edge
   - Use when left edge is a valley, hip, or open edge

4. **Automatic** (insertion only):
   - Script analyzes the roofplane's verge edge topology
   - If a right verge tile is defined → selects **Right**
   - If only a left verge tile is defined → selects **Left**
   - If no verge tiles are defined → selects **Center**
   - After insertion, "Automatic" is replaced with the resolved mode

**Technical Details**:
- The script reads `EdgeTileData` from the roofplane
- Verge edges are identified by their parallel orientation to the slope direction (vecY)
- Edge tile type is checked: `_kTileRight`, `_kTileLeft`, `_kTileRightOpening`, `_kTileLeftOpening`

## Interactive Features

### Grip Points

#### Horizontal Grid Instance
- No user-modifiable grip points
- Half-tile column positions are added via context menu, not grips

#### Vertical Grid Instance
- **_Pt0** (Insertion Point):
  - Located at the selected eave edge
  - **Move _Pt0** to select a different eave as the distribution reference (useful for roofs with multiple eaves)
  - Script automatically snaps _Pt0 to the closest eave segment
  - If no eave exists, _Pt0 is placed at the lowest point of the roof

- **_PtG[0]** (Dimension Grip):
  - Controls the position of the dimension line annotation
  - **Drag _PtG[0]** to reposition the dimension line perpendicular to the distribution direction
  - Preserved in the instance map as relative vectors from _PtW

- **_PtG[1...n]** (Fixed Lath Positions):
  - Added via "Add fixed lath" context menu
  - Represents fixed lath positions that the distribution must incorporate
  - Script adjusts tile spacing around fixed lath positions
  - Remove via "Remove fixed lath" context menu

### Double-Click Behavior

Double-clicking a grid instance cycles through display modes:
1. **All** → **Dimension** → **Grid** → **All** (repeats)

This provides a quick shortcut to toggle visibility without opening the Properties Palette. The current mode is stored in the `Display Content` property.

### Context Menu Commands

#### Common Commands (Both Instances)

##### Reset rooftile information
- **Action**: Clears all exported tile data stored in the roofplane's `Hsb_TileExportData` SubMapX
- **Use Case**:
  - Start the tiling process from scratch
  - Clear inconsistent or corrupted data
  - Prepare for reassignment of tile style
- **Warning**: This removes all data exported by grid, verge, ridge, and lath tools - they will need to recalculate

##### Save defaults
- **Action**: Saves the current instance's property values as the `_Default` catalog entry
- **Effect**: Future insertions automatically use these saved settings instead of showing the properties dialog
- **Storage**: Catalog entries are stored per script name with mode suffix:
  - `_hsbTileGrid-Horizontal` for horizontal instances
  - `_hsbTileGrid-Vertical` for vertical instances

#### Horizontal Grid Instance Commands

##### Start with full verge / Start with half verge
- **Availability**: Only appears when the tile family uses a staggered distribution pattern (`TileDistribution == 1`)
- **Action**: Toggles the staggered pattern starting mode
- **Effect**:
  - **Start with full verge**: First row at verge begins with a full tile
  - **Start with half verge**: First row at verge begins with a half tile (offset by half-tile width)
- **Storage**: `SwapStaggered` flag in instance map
- **Visual Indication**: Staggered rows are displayed with offset grid lines

##### Add [Half Tile Name]
- **Availability**: Only appears when the tile family includes a half-tile definition in the database
- **Action**: Inserts a half-tile column at a user-picked location
- **Workflow**:
  1. Select this menu item
  2. Command prompts: `"Pick point in tile column"`
  3. Click within the desired tile column
  4. Script adds the half-tile at the snapped grid position
- **Automatic Addition**: If the distribution does not fit within tolerance, the script may automatically add a half-tile column to achieve a valid fit
- **Display**: Half-tile columns are drawn in cyan (color 12) to distinguish from standard columns
- **Validation**:
  - Half-tile columns outside the distribution range are automatically removed with a warning
  - Overlapping half-tile columns are consolidated
- **Export**: Half-tile column positions are exported to roofplane for verge tile and quantity tools

##### Remove [Half Tile Name]
- **Availability**: Only appears when half-tile columns exist on the roofplane
- **Action**: Removes a previously added half-tile column
- **Workflow**:
  1. Select this menu item
  2. Command prompts: `"Pick point near tile column"`
  3. Click near the half-tile column to remove
  4. Script removes the closest half-tile column within one tile width
- **Feedback**: If no half-tile is found nearby, displays message: `"Could not find a column nearby. Try to pick a point closer to a half tile column..."`

##### Set horizontal distribution
- **Action**: Manually enter a custom tile spacing value within the allowable range
- **Workflow**:
  1. Select this menu item
  2. Command line displays: `"Enter distribution value (MinValue...MaxValue) AverageValue to fit (0 = reset)"`
  3. Enter a value:
     - **Within range**: Sets custom spacing to that value
     - **0**: Resets to automatic calculation
     - **Outside range**: Ignored, no change
- **Calculation Helper**: The command line shows the calculated average spacing that would produce a perfect fit (no remainder)
- **Use Case**:
  - Override automatic spacing when you need a specific column width
  - Fine-tune distribution when automatic calculation produces unwanted remainder
- **Warning**: Custom values may cause the distribution to exceed tolerance at verges

##### Reset custom distribution
- **Availability**: Only appears when a custom horizontal distribution value has been set
- **Action**: Removes the manually set distribution value and returns to automatic calculation
- **Effect**: Script recalculates optimal spacing based on roofplane width and tile min/max range

#### Vertical Grid Instance Commands

##### Add fixed lath
- **Action**: Adds a fixed lath position by clicking a point on the roof
- **Workflow**:
  1. Select this menu item
  2. Command prompts: `"Pick point"`
  3. Click on the roof surface where you want a lath positioned
  4. Script projects the point to the tile plane and adds it to `_PtG` array
- **Effect**:
  - The vertical distribution incorporates this fixed position
  - Tile spacing adjusts around fixed lath positions to maintain valid ranges
- **Use Case**:
  - Place a lath at a dormer connection to align tiles
  - Position a lath at a ventilation opening
  - Match existing conditions on renovation projects
- **Storage**: Fixed lath positions are stored as grip points (`_PtG[1...n]`)

##### Remove fixed lath
- **Availability**: Only appears when fixed laths exist (`_PtG.length() > 1`)
- **Action**: Removes a previously added fixed lath
- **Workflow**:
  1. Select this menu item
  2. Command prompts: `"Pick point near fixed lath"`
  3. Click near the lath to remove
  4. Script removes the closest fixed lath

##### Set lath section
- **Availability**: Only appears when no lath section data is found from the ridge definition
- **Action**: Manually overrides the lath cross-section dimensions (width and height)
- **Workflow**:
  1. Select this menu item
  2. Command prompts: `"Enter lath width, 0 = use default (CurrentValue)"`
  3. Enter width value (or 0 to reset)
  4. Command prompts: `"Enter lath height, 0 = use default (CurrentValue)"`
  5. Enter height value (or 0 to reset)
- **Storage**:
  - Stored in instance map as `LathWidth` and `LathHeight`
  - Removed from map when reset to 0
- **Use Case**:
  - Override lath dimensions when they are not defined in the tile family
  - Adjust for non-standard lath sections

##### Use sloped dormer roof function / Do not use sloped dormer roof function
- **Action**: Toggles the sloped dormer adjustment feature on or off
- **Storage**: `bAdjustDormer` flag in instance map
- **Effect**:
  - **When enabled**: Script detects single-pitched dormer roofs and provides adjustment options via the "Adjust sloped dormer" property
  - **When disabled**: No dormer detection or adjustment is performed
- **Default**: Disabled (off)

## Distribution Logic and Calculations

### Horizontal Distribution (Column Spacing)

The horizontal grid instance calculates tile column positions from left to right across the roofplane.

#### Data Sources
1. **Standard Tile Horizontal Spacing**:
   - `dXMin` and `dXMax` from tile family definition
   - Average: `dAv = (dXMin + dXMax) / 2`
   - Tolerance: `dDist = (dXMax - dXMin) / 2`

2. **Half Tile Horizontal Spacing** (if available):
   - `dXMinHalf` and `dXMaxHalf` from database query via `RoofTilingManager.dll`
   - Used for staggered patterns and automatic fit adjustments

3. **Verge Tile Spacing** (if verges are defined):
   - `dVergeL` (left verge width) and `dVergeR` (right verge width)
   - Retrieved from left/right verge `EdgeTileData`
   - Accounts for special verge tile widths that differ from standard tiles

#### Distribution Calculation Steps

1. **Determine Distribution Length**:
   - Get roofplane extent in X-direction from `ppRoof.extentInDir(vecX)`
   - Adjust for verge offsets if verges are defined
   - Store as `dDistribute`

2. **Calculate Number of Columns**:
   - `nColumn = dDistribute / dAv`
   - `dRest = dDistribute - (nColumn * dAv)` (remainder space)

3. **Adjust for Verge Tiles**:
   - If left verge exists: subtract `dVergeL` from distribution length
   - If right verge exists: subtract `dVergeR` from distribution length
   - Recalculate `nColumn` and `dRest`

4. **Calculate Adjusted Grid Spacing**:
   - If `dRest < total tolerance`: spread remainder evenly → `dGrid = dAv + (dRest / nColumn)`
   - If `dRest > total tolerance`: add one column → `dGrid = dAv + ((dRest - dGrid) / (nColumn + 1))`
   - This ensures the distribution fits within the allowable tile spacing range

5. **Apply Custom Spacing** (if set):
   - If user has set a custom distribution value, override `dGrid` with `dXMaxCustom`

6. **Calculate Starting Position**:
   - **Left alignment**: Start at left verge, remainder on right
   - **Right alignment**: Start at right verge, remainder on left
   - **Center alignment**: Split remainder equally on both sides

7. **Generate Grid Points**:
   - Start at calculated first position
   - Step by `dGrid` until reaching the opposite extreme
   - Insert half-tile columns at `_PtG` positions with spacing `dAvHalf`
   - Stop when remainder is less than `dGrid + tolerance`

#### Staggered Pattern Handling

For staggered tile distributions (`TileDistribution == 1`):

1. **Detect Staggerable Verges**:
   - Check if verge tiles have both full and half-width options
   - Compare `dAv1` (full verge width) vs `dAv2` (half verge width)

2. **Swap Staggered Mode**:
   - `bSwapStaggered` flag controls whether to start with full or half verge tile
   - Affects which row is offset by half-tile width

3. **Automatic Half-Tile Addition**:
   - If distribution does not fit within tolerance
   - And verge tiles support half-widths
   - Script automatically adds a half-tile column to improve fit
   - Stored in map as `PtGAdded` flag

#### Range Validation

The horizontal grid displays distribution fit status:
- **Green indicators**: Distribution fits within allowable tile spacing range
- **Red indicators**: Distribution requires adjustment (out of tolerance)
- Indicators are shown near verge edges as colored rectangles or lines

### Vertical Distribution (Row Spacing)

The vertical grid instance calculates tile row positions from eave to ridge along the roof slope.

#### Data Sources

1. **Standard Tile Vertical Spacing**:
   - `dYMin` and `dYMax` from tile family `VerticalTileSpacing`
   - Average: `dStandardAv = (dYMin + dYMax) / 2`
   - Tolerance: `dStandardDist = (dYMax - dYMin) / 2`

2. **Eave Tile Spacing** (if eave definition exists):
   - `dEaveLATs[]` array containing min/max ranges for each eave
   - Retrieved from `EavesDefinition` in edge tile map
   - `dEaveAv` and `dEaveDist` calculated per eave

3. **Ridge Batten Distance**:
   - `dRidgeLAFs[]` array containing ridge batten distance for each ridge
   - Retrieved from `RidgeConnectionDefinition` in edge tile map
   - Controls the distance from the last lath to the ridge

4. **Lath Section Dimensions**:
   - `dYLath` (lath width) and `dZLath` (lath height)
   - Retrieved from ridge or eave definition
   - Can be overridden via "Set lath section" context menu

#### Edge Classification

The script classifies all roofplane edges into categories:

| Edge Type | Description | Detection Method |
|-----------|-------------|------------------|
| **Verges** | Parallel to slope direction | `vecXSeg.angleTo(vecY) ≈ 0° or 180°` |
| **Eaves** | Horizontal bottom edges | `tileType == 0` or `EavesDefinition` exists |
| **Ridges** | Horizontal top edges | `tileType == 1` or `RidgeConnectionDefinition` exists |
| **Saddle Ridges** | Ridge connecting to another roof | `tileTypePartner == 1` |
| **Pent Ridges** | Ridge without connection | `tileTypePartner != 1` |
| **Sloped Edges** | Valleys, hips, diagonal edges | All other angles |

#### Distribution Calculation Steps

1. **Order Edges Bottom-to-Top**:
   - Sort `edgesHorizontal[]` along `-vecY` direction
   - Edge [0] is the bottommost (eave)
   - Edge [last] is the topmost (ridge)

2. **Collect Grip Points**:
   - Extract midpoints of each eave and ridge edge
   - Project to the offset tile plane (`pnErp + vecZ * dZOffsetTilePlane`)
   - Store as `ptsGripsV[]` array
   - Assign edge types to `nEdgeHtype[]` (0=eave, 1=saddle ridge, 2=pent ridge, 3=ridge no data)

3. **Add Fixed Lath Positions**:
   - Append user-defined fixed laths from `_PtG[]` to `ptsGripsV[]`
   - Project to tile plane

4. **Calculate Eave-to-Ridge Distance**:
   - `dDormerLength = vecY.dotProduct(ptsGripsV[last] - ptsGripsV[first]) - dEaveAv`
   - Subtract eave tile offset
   - Subtract ridge batten distance

5. **Calculate Number of Rows**:
   - `nNRow = dDormerLength / dStandardAv`
   - `dDiff = dDormerLength - (nNRow * dStandardAv)` (remainder)

6. **Adjust for Tolerance**:
   - If `|dDiff| > |dDiff - dStandardAv|`: add one row, adjust remainder
   - Calculate `dAv = dDiff / totalTolerance`
   - Adjusted spacing: `dAdjusted = dStandardAv + (dAv * dStandardDist)`

7. **Generate Grid Points**:
   - Start at eave position + eave offset
   - Step by `dAdjusted` spacing
   - Incorporate fixed lath positions at exact locations
   - Stop at ridge position - ridge batten distance

8. **Export to Roofplane**:
   - Store `VerticalDistribution` point array in `Hsb_TileExportData`
   - Store eave vector, Z-offset, front cut mode

#### Eave Front Cut Handling

The eave front cut mode affects how the eave edge is projected when Z-Offset > 0:

1. **by Roofplane** (default):
   - Reads `FRONTCUTPERPTOROOFPLANE` flag from ERoofPlane entity
   - If true: uses perpendicular cut
   - If false: uses plumb cut

2. **Plumb** (vertical):
   - Eave edge extends vertically downward (`vecZEave = _ZW`)
   - Tile overhang is calculated vertically

3. **perpendicular to roof**:
   - Eave edge extends perpendicular to roof slope (`vecZEave = vecZ`)
   - Eave edge moves back along slope by `dZOffset * tan(pitch)`
   - Tile overhang is reduced

#### Tile Overhang Calculation

The script adjusts the roofplane profile to account for tile overhang at eaves:

1. **Get Tile Overhang Distance**:
   - `dOverhang = mapStandardTile.getDouble("DistanceToTopOfLathKey")`
   - This is the distance from the top of the lath to the tile's edge

2. **Calculate Used Overhang**:
   - `dUsedOverhang = dOverhang - (dEaveAv)` (subtract eave tile offset)
   - Different for each eave if multiple eaves exist

3. **Extend PlaneProfile at Eaves**:
   - Move eave edge grip points outward by `-vecY * dUsedOverhang`
   - Skip valley edges (where `partnerRoofplane.bIsValid()`)

4. **Contract at Ridges**:
   - Move ridge edge grip points inward by `-vecY * dRidgeLAF`
   - Only affects saddle and pent ridges with defined batten distances

The extended profile (`ppS`) is used for all grid visualization and dimension calculations.

#### Sloped Dormer Adjustment

When "Use sloped dormer roof function" is enabled and a sloped dormer connection is detected:

1. **Detect Main Roof Connection**:
   - Search for neighboring roofplanes with different pitch
   - Check if tile planes intersect
   - Verify same horizontal orientation

2. **Find Intersection Point**:
   - Calculate intersection line between dormer tile plane and main roof tile plane
   - Project to a plane perpendicular to X-axis to find `ptDormer1`

3. **Read Main Roof Grid Data**:
   - Access main roofplane's `Hsb_TileExportData`
   - Get `VerticalDistribution` point array
   - Find the grid point closest to the intersection

4. **Apply Adjustment** (based on "Adjust sloped dormer" property):

   **Adjust tiling**:
   - Calculate distance from dormer eave to intersection point
   - Calculate number of rows required
   - Adjust tile spacing to exactly hit the intersection point
   - `dDormerAv = dStandardAv + (adjustment within tolerance)`

   **Adjust pitch upwards/downwards**:
   - Calculate angle change required to align tile courses
   - Rotate dormer roofplane around eave line
   - Adjust ridge height to match intersection
   - Store original vertices in `mapPtsEr` for restoration

   **Move roofplane upwards/downwards**:
   - Calculate vertical shift required
   - Move entire dormer roofplane in Z-direction
   - Preserve roof pitch

5. **Visualize Adjustment**:
   - Draw circle at intersection point with radius = adjusted spacing
   - Helps verify the adjustment is correct

## Opening Handling (Dormers, Chimneys, Skylights)

The script automatically detects and subtracts openings from the tiling area.

### Opening Detection

1. **Identify Openings**:
   - Call `er.findContainingRoofplanes()` to get all child roofplanes
   - These are typically dormers, chimneys, or skylights

2. **Classify Opening Type**:
   - Chimney (`planeType == 4`): Requires Z-offset adjustment
   - Loggia (`planeType == 5`): Excluded from tiling but not from tile count
   - Other openings: Standard subtraction

3. **Transform Chimney Openings**:
   - If `dZOffsetTilePlane > 0`, chimney must be re-intersected with the offset plane
   - Transform: `plOpening.transformBy(vecY * sin(pitch) * dZOffsetTilePlane)`
   - This accounts for the chimney intersecting the sloped tile plane at a different location than the rafter plane

4. **Subtract from Profile**:
   - Use `ppRoof.joinRing(plOpening, _kSubtract)`
   - Creates a PlaneProfile with holes

### Opening Effect on Distribution

- **Horizontal distribution**: Runs continuously across the roofplane; openings create voids in the grid
- **Vertical distribution**: Runs from eave to ridge; openings create voids in the grid
- **Tile counting**: Openings are excluded from tile quantity calculations (intersection test used)

## Visualization and Display

### Grid Lines

The horizontal and vertical grid lines are drawn using:
- **Color**: 252 (cyan) for main grid, 12 (cyan) for half-tile columns
- **LineType**: Hidden (`sLineType = "Hidden"`)
- **LineScale**: `dLineScale = 1` (can be adjusted)

Grid lines are drawn perpendicular to the distribution direction:
- Horizontal grid: Vertical lines (parallel to vecY)
- Vertical grid: Horizontal lines (parallel to vecX)

### Range Indicators

Distribution range indicators show whether the tile spacing fits within tolerance:

| Color | Meaning | Transparency |
|-------|---------|--------------|
| **Green (72)** | Distribution fits within min/max range | 80% |
| **Red (10)** | Distribution out of tolerance, requires adjustment | 80% |
| **Grey (252)** | Neutral/default | 40% |

Range indicators are displayed as:
- Colored rectangles at eave and ridge edges (vertical distribution)
- Colored lines at verge edges (horizontal distribution)

### Alternative Block Display

If AutoCAD blocks with the following names exist in the drawing, they are used for range visualization:
- `hsbTileGrid`: Default range block
- `hsbTileGridGreen`: Green (fits within range)
- `hsbTileGridRed`: Red (out of range)
- `hsbTileGridGrey`: Grey (neutral)

The blocks are automatically scaled to fit the range area.

### Dimension Annotations

Dimensions are displayed using the selected dimension style (`sDimStyle`):

**Horizontal Grid**:
- Dimension line perpendicular to vecX (typically horizontal)
- Shows spacing between grid lines
- Projected to a plane below the roofplane by `0.5 * dYErp + 0.1 * dTxtH`

**Vertical Grid**:
- Dimension line perpendicular to vecY (typically along slope)
- Shows spacing between grid lines
- Includes a grip point (`_PtG[0]`) to reposition the dimension line

**Text Content**:
- Manufacturer name + tile family name
- Surface + color
- Displayed at `_Pt0 + vecX * 100mm`

### Display Modes

Controlled by the `Display Content` property:

| Mode | Grid Lines | Dimensions | Text |
|------|------------|------------|------|
| **All** | Visible | Visible | Visible |
| **Dimension** | Hidden | Visible | Visible |
| **Grid** | Visible | Hidden | Hidden |

## Data Export and Integration

The script exports comprehensive tiling data to the roofplane's `Hsb_TileExportData` SubMapX for consumption by downstream tools.

### Exported Data Structure

#### Horizontal Grid Exports

```
Hsb_TileExportData
├── HorizontalDistribution (Point3d[])    // Grid column positions
├── ColumnWidth (double)                   // Adjusted tile spacing
├── Staggered (int)                        // Staggered pattern flag
├── Distance (double)                      // Half-tile offset distance
├── nHorizontalAlignment (int)             // Alignment mode (0=L, 1=C, 2=R)
├── dAvHalf (double)                       // Half-tile width
├── bPtGLR (int)                          // Half-tile column location flag
├── PtGsHalfColumn (Point3d[])            // Half-tile column positions
├── VergePoint (Point3d)                  // Left/right verge reference (optional)
└── VergePoint1 (Point3d)                 // Opposite verge reference (optional)
```

#### Vertical Grid Exports

```
Hsb_TileExportData
├── VerticalDistribution (Point3d[])      // Grid row positions
├── ZOffsetTilePlane (double)             // Z-offset value
├── FrontCutMode (int)                    // Eave front cut mode
├── EaveVector (Vector3d)                 // Eave direction vector
├── ppErp (PlaneProfile)                  // Roofplane profile
├── ppS (PlaneProfile)                    // Extended profile with overhang
├── mapTiles (Map)                        // Tile count by type
└── mapHardware (Map)                     // Hardware export data (BOM)
```

### Tile Counting

The vertical grid instance counts tiles by intersecting the horizontal column lines with the staggered row profiles:

1. **Create Staggered Profiles**:
   - `ppStaggered1`: Profile for rows 0, 2, 4, ... (even rows)
   - `ppStaggered2`: Profile for rows 1, 3, 5, ... (odd rows, offset by half-tile)

2. **Intersect Columns with Rows**:
   - For each column line, intersect with `ppStaggered1` and `ppStaggered2`
   - Count intersection points to determine tile quantity per row

3. **Classify Tile Types**:
   - Standard full tiles
   - Half tiles (at half-tile columns)
   - Verge tiles (left/right edges)

4. **Export Counts**:
   - Store in `mapTiles` map with keys: tile type → quantity
   - Export to `mapHardware` for BOM generation

### Hardware Export Format

The script exports hardware/material data for bill-of-material tools:

```
mapHardware
├── Category: "Rooftiles"
├── Manufacturer: [manufacturer name]
├── Model: [tile family name]
├── Material: [surface + color]
├── TileWidth: [tile width in current units]
├── TileHeight: [tile height in current units]
├── RoofPitch: [roof pitch in degrees]
├── FullTileCount: [quantity]
├── HalfTileCount: [quantity]
└── TotalArea: [coverage area]
```

This data feeds into the hsbCAD BOM system and can be accessed by:
- `HSB_G-BillOfMaterial.mcr`
- Shop drawing scripts
- Export tools (Excel, CSV, PDF)

## Related Scripts and Workflow Integration

The `_hsbTileGrid` script is the foundation of the roof tiling workflow. It integrates with:

### Upstream Dependencies

| Script | Purpose | Data Provided to _hsbTileGrid |
|--------|---------|-------------------------------|
| **Roof Tiling Manager** | Assigns tile family to roofplane | Tile family definition, spacing ranges, tile types |
| **ERoofPlane** | Roof geometry | Coordsys, envelope, edge topology |

### Downstream Consumers

| Script | Purpose | Data Consumed from _hsbTileGrid |
|--------|---------|----------------------------------|
| **hsbTileVerge** | Verge tile placement | Horizontal distribution, verge points, alignment |
| **hsbTileRidge** | Ridge tile placement | Vertical distribution, ridge points, batten distance |
| **hsbTileLath** | Lath distribution | Vertical distribution, lath section, spacing |
| **hsbTileEdge** | Edge tile placement | Grid points, profile data |
| **hsbTileStart** | Starter course tiles | Eave points, eave offset, first row position |
| **hsbTileSingle** | Single tile placement | Grid points for snapping |
| **hsbTileMaster** | Tile distribution master control | All grid data, tile counts |
| **HSB_G-BillOfMaterial** | Material takeoff | Hardware export data, tile counts |

### Typical Workflow

1. **Assign Tile Style**: Use Roof Tiling Manager to assign a tile family to the roofplane
2. **Run _hsbTileGrid**: Creates horizontal and vertical grid instances
3. **Verify Distribution**: Check range indicators (green = good, red = adjust)
4. **Adjust Parameters**: Modify alignment, Z-offset, or custom spacing as needed
5. **Add Verge Tiles**: Run verge tile script to place edge tiles
6. **Add Ridge Tiles**: Run ridge tile script to place ridge tiles
7. **Add Laths**: Run lath distribution script to create tile battens
8. **Add Special Tiles**: Run edge, starter, or single tile scripts as needed
9. **Generate BOM**: Run bill-of-material script to create quantity takeoff

## Troubleshooting and Common Issues

### Issue: "Could not find valid roof tile data"

**Cause**: Roofplane does not have a tile style assigned, or the tile family definition is incomplete.

**Solution**:
1. Open the Roof Tiling Manager
2. Assign a valid tile family to the roofplane
3. Verify the tile family has:
   - Horizontal spacing min/max defined
   - Vertical spacing min/max defined
   - Manufacturer data
4. Re-run the script

### Issue: Red range indicators (out of tolerance)

**Cause**: The roofplane dimensions do not allow the tiles to fit within the min/max spacing range.

**Solutions**:
1. **Adjust horizontal alignment**: Try Left/Center/Right to see if a different alignment produces a better fit
2. **Use custom distribution**: Set a manual spacing value within the range via "Set horizontal distribution"
3. **Add half-tile column**: If half-tiles are available, add a half-tile column to improve fit
4. **Adjust roofplane geometry**: Slightly resize the roofplane to accommodate whole tiles
5. **Choose a different tile family**: Select a tile with a wider spacing tolerance

### Issue: Horizontal and vertical instances out of sync

**Cause**: One instance was modified or recreated without updating the other.

**Solution**:
1. Delete both grid instances
2. Re-run the script to create a matched pair
3. Alternatively, use "Reset rooftile information" context menu to clear data, then let both instances recalculate

### Issue: Sloped dormer adjustment not working

**Cause**: The dormer connection is not detected, or the geometry does not support the adjustment.

**Solution**:
1. Verify the dormer is a single-pitched roof
2. Check that the dormer's tile plane intersects the main roof's tile plane
3. Ensure both roofs have the same horizontal orientation (eave direction)
4. Try different adjustment modes (Adjust tiling, Adjust pitch, Move roofplane)
5. If geometry is too complex, disable the dormer function and manually adjust the dormer roofplane

### Issue: Dimension line not visible

**Cause**: Display Content is set to "Grid" mode, or the dimension style is invalid.

**Solution**:
1. Check `Display Content` property - set to "All" or "Dimension"
2. Verify `Dimstyle` property references a valid dimension style in the drawing
3. Check `Text Height` is large enough to be visible at the current zoom level
4. Double-click the instance to cycle through display modes

### Issue: Grid appears at wrong elevation

**Cause**: Z-Offset is set incorrectly, or the eave front cut mode is wrong.

**Solution**:
1. Check `Z-Offset` property on vertical grid instance
2. Verify `Eave front cut` mode matches your project's construction method
3. For standard construction (counter battens), use "perpendicular to roof" mode
4. For direct lath attachment, use "by Roofplane" or "Plumb" mode

### Issue: Half-tile columns are removed automatically

**Cause**: Half-tile columns are outside the distribution range or overlap with other half-tiles.

**Solution**:
1. Review the command line message indicating why the column was removed
2. Verify the picked point is within the roofplane extents
3. Ensure the half-tile column does not overlap another half-tile (spacing must be > half-tile width)
4. Check that the distribution range is wide enough to accommodate the half-tile

### Issue: "Already attached to roofplane" message

**Cause**: A grid instance already exists on the selected roofplane.

**Solution**:
1. This is informational, not an error
2. The existing instance will remain unchanged
3. To recreate the instance:
   - Delete the existing instance
   - Re-run the script
4. To modify the existing instance:
   - Select it and change properties in the OPM
   - Use context menu commands

## Tips and Best Practices

### Planning and Setup

1. **Assign tile styles first**: Always assign a complete tile family to roofplanes before running this script. Attempting to run the script without tile data will result in deletion.

2. **Use Automatic alignment initially**: The "Automatic" horizontal alignment mode intelligently selects the best alignment based on your roofplane's verge topology. You can always override it later if needed.

3. **Save defaults for repetitive work**: If you use the same settings across multiple projects (e.g., standard Z-offset for counter battens), save them as a `_Default` catalog entry to skip the properties dialog.

4. **Organize with groups**: Use the Group property with wildcards to automatically organize grid instances into project groups. Example: If your roofplanes are in `Building\5000 Roof`, set Group to `**80 Grid` to create `Building\5080 Grid`.

### Working with the Grid

5. **Check range indicators**: Always verify the color-coded range indicators after creating the grid. Green means the distribution is valid, red means adjustments are needed.

6. **Use double-click for quick display toggle**: Instead of opening the Properties Palette, double-click the instance to cycle through All/Dimension/Grid display modes.

7. **Drag grip points for dimension positioning**: The vertical grid's dimension line can be repositioned by dragging `_PtG[0]`. This helps keep dimensions readable when the roof has complex geometry.

8. **Move _Pt0 to select different eave**: For roofs with multiple eaves (e.g., L-shaped), move the vertical grid's _Pt0 to the eave you want to use as the distribution reference.

### Distribution Fine-Tuning

9. **Use custom distribution sparingly**: Manual spacing overrides can cause out-of-tolerance conditions at verges. Only use "Set horizontal distribution" when automatic calculation is unacceptable.

10. **Add fixed laths for alignment**: When tiles must align with specific features (dormers, ventilation openings), use "Add fixed lath" to force a tile course at that location.

11. **Understand staggered patterns**: For staggered tile families, the "Start with full verge / Start with half verge" toggle controls which row starts with a full tile. Experiment with both modes to find the best visual result.

12. **Leverage automatic half-tile addition**: If the distribution is out of tolerance, the script may automatically add a half-tile column to achieve a fit. Check for cyan-colored columns indicating automatic additions.

### Z-Offset and Front Cut

13. **Set Z-Offset for counter battens**: If your roof construction includes counter battens or insulation above the rafters, enter the total buildup thickness in the Z-Offset property. This ensures the tile grid is calculated at the correct elevation.

14. **Match front cut to construction method**:
    - **Plumb cut**: Traditional framing, tail cut is vertical
    - **Perpendicular to roof**: Modern construction, tail cut follows roof slope
    - **by Roofplane**: Uses the roofplane's own setting

15. **Visualize Z-Offset effect**: The offset plane is where tiles sit, not the rafter plane. If openings (chimneys) look wrong, verify the Z-Offset is correct.

### Sloped Dormer Roofs

16. **Enable dormer function cautiously**: The sloped dormer adjustment feature modifies roofplane geometry. Always save your drawing before using "Adjust pitch" or "Move roofplane" modes.

17. **Use "Adjust tiling" first**: This mode adjusts tile spacing without modifying the roofplane. Try it before resorting to geometry changes.

18. **Restore original geometry**: To undo dormer adjustments, change the "Adjust sloped dormer" property back to "No adjustment" or modify the Z-Offset. The script restores the original roofplane vertices.

### Data Export and Integration

19. **Use "Reset rooftile information" to start fresh**: If tiling data becomes inconsistent (e.g., after changing tile families), use this context menu to clear all exported data and force recalculation.

20. **Understand the dual-instance relationship**: The horizontal and vertical instances work together - both must exist for complete functionality. Deleting one may cause downstream tools to fail.

21. **Trigger dependency updates**: When you change Z-Offset or Eave front cut on the vertical instance, the horizontal instance automatically recalculates. This is by design - the offset plane affects both distributions.

### Debugging and Validation

22. **Enable debug mode**: To see internal calculations and grid point IDs, add `DEBUGTSL` or `_hsbTileGrid` to the project's "Special" string (project settings). This displays additional visual markers and command-line messages.

23. **Verify dimension style**: If text appears at the wrong size or with the wrong font, check that the Dimstyle property references a valid dimension style in your drawing template.

24. **Check for half-tile database availability**: If the "Add [Half Tile Name]" context menu does not appear, the tile family may not have half-tiles defined in the database. Contact your tile supplier or hsbCAD support to add half-tile data.

### Performance

25. **Use `envelopeBody()` for complex roofs**: The script automatically uses lightweight geometry calculations for large roofplanes. If performance is slow, simplify the roofplane geometry or reduce the number of openings.

26. **Limit fixed lath positions**: Each fixed lath adds complexity to the distribution calculation. Use them only when necessary for alignment.

## Technical Notes

### Script Architecture

- **Execution Mode**: The script has three modes controlled by the `nMode` variable:
  - `mode = 0`: Inserter (temporary instance that creates horizontal and vertical instances)
  - `mode = 1`: Horizontal grid instance
  - `mode = 2`: Vertical grid instance

- **OPM Key Naming**: The instances display as `[ScriptName]-Horizontal` and `[ScriptName]-Vertical` in the Properties Palette (OPM), making them easily identifiable.

- **Dependency Tracking**: Both instances call `setDependencyOnEntity(_Entity[0])` to establish a dependency link with the roofplane. When the roofplane changes, both instances automatically recalculate.

### Geometry Coordinate Systems

- **Roofplane CoordSys**: Retrieved via `er.coordSys()`
  - `vecX`: Left-to-right direction (perpendicular to slope)
  - `vecY`: Eave-to-ridge direction (parallel to slope)
  - `vecZ`: Normal to roofplane surface

- **World Coordinate System**:
  - `_XW`, `_YW`, `_ZW`: World axes
  - Used for plumb cuts and vertical offsets

- **Tile Plane**: Offset from roofplane by `dZOffsetTilePlane` in Z-direction

### Edge Topology Detection

The script uses the roofplane's `edgeTileTopology()` and `edgeTileData()` methods to classify edges:

```cpp
EdgeTileData edges[] = er.edgeTileTopology();
for (int i = 0; i < edges.length(); i++) {
    int tileType = edges[i].tileType();
    // 0 = eave, 1 = ridge, _kTileLeft, _kTileRight, etc.
}
```

Edge classification drives:
- Verge identification (for horizontal alignment)
- Eave/ridge identification (for vertical distribution)
- Edge tile data retrieval (spacing, offsets, lath dimensions)

### PlaneProfile Operations

The script uses `PlaneProfile` extensively for:
- Roofplane boundary representation (`ppErp`)
- Opening subtraction (`ppRoof.joinRing(plOpening, _kSubtract)`)
- Tile overhang extension (`ppS` - extended profile)
- Staggered pattern masking (`ppStaggered1`, `ppStaggered2`)

PlaneProfile methods used:
- `extentInDir(vec)`: Get extent line segment in a direction
- `pointInProfile(pt)`: Test if point is inside/outside/on boundary
- `getGripEdgeMidPoints()`: Get edge midpoints for manipulation
- `moveGripEdgeMidPointAt(index, vec)`: Offset edge by vector
- `allRings()`: Get all rings (outer + holes)

### Unit Safety

The script initializes with `U(1,"mm")` and uses `U()` throughout for all dimensional values, ensuring correct behavior in both millimeter and inch drawing templates:

```cpp
U(1, "mm"); // Set base unit to millimeters
double dTxtH = U(80); // 80mm or equivalent in current drawing units
```

### DLL Integration

The script calls external .NET assembly `RoofTilingManager.dll` via `callDotNetFunction2()`:

```cpp
String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\RoofTiles\\RoofTilingManager.dll";
String strType = "hsbCad.Roof.TilingManager.Editor";
Map mapOut = callDotNetFunction2(strAssemblyPath, strType, "GetTiles", mapIn);
```

This retrieves half-tile data from the tile database when not available in the roofplane's embedded definition.

### Catalog System

The script supports named catalog entries for property persistence:

- `_Default`: Automatic default for new insertions
- `_LastInserted`: Last used values
- Custom named catalogs: User-defined presets

Catalog entries are stored per script name with mode suffix:
- `_hsbTileGrid-Horizontal` for horizontal instances
- `_hsbTileGrid-Vertical` for vertical instances

### Map Data Structure

The instance map (`_Map`) stores runtime data:

| Key | Type | Purpose |
|-----|------|---------|
| `mode` | int | Instance mode (0/1/2) |
| `SwapStaggered` | int | Staggered pattern toggle |
| `XMaxCustom` | double | Custom horizontal spacing override |
| `PtGAdded` | int | Flag for automatic half-tile addition |
| `nHalfRemoved` | int | Flag for half-tile removal |
| `ptsGrid` | Point3d[] | Calculated grid point positions |
| `mapHalfColumn` | Map | Half-tile column positions |
| `Grip[]` | Map | Grip point storage for _Pt0 movement |
| `bAdjustDormer` | int | Sloped dormer function enable flag |
| `mapPtsEr` | Map | Original roofplane vertices (for dormer restoration) |
| `LathWidth` | double | Lath section width override |
| `LathHeight` | double | Lath section height override |

### SubMapX Export Structure

The roofplane's `Hsb_TileExportData` SubMapX contains:

```
Hsb_TileExportData (Map)
├── ZOffsetTilePlane (double)
├── FrontCutMode (int)
├── HorizontalDistribution (Point3d[])
├── VerticalDistribution (Point3d[])
├── ColumnWidth (double)
├── Staggered (int)
├── Distance (double)
├── nHorizontalAlignment (int)
├── dAvHalf (double)
├── bPtGLR (int)
├── PtGsHalfColumn (Point3d[])
├── VergePoint (Point3d)
├── VergePoint1 (Point3d)
├── EaveVector (Vector3d)
├── ppErp (PlaneProfile)
├── ppS (PlaneProfile)
├── mapTiles (Map)
└── mapHardware (Map)
```

This data is persistent and survives drawing close/reopen cycles.

### Version History Highlights

| Version | Date | Author | Key Changes |
|---------|------|--------|-------------|
| 5.9 | Jul 2023 | nils.gregor | Bugfix: Offset at verges |
| 5.8 | Jun 2019 | nils.gregor | Bugfix: Non-millimeter units |
| 5.7 | May 2019 | nils.gregor | Adjusted horizontal distribution with half standard tiles as verge tiles |
| 5.6 | May 2019 | nils.gregor | Adjusted sloped dormer function |
| 5.0 | Apr 2019 | nils.gregor | Elementary behavior changes, initial V22 release |
| 4.0 | Jul 2018 | thorsten.huck | Staggered distribution uses full verge tile as base |
| 3.7 | Jul 2018 | thorsten.huck | Automatic horizontal distribution mode |
| 3.6 | Jul 2018 | thorsten.huck | Context commands for average and custom distribution |
| 3.4 | Jun 2018 | thorsten.huck | Vertical grid dimension grip added |
| 3.0 | Jan 2018 | thorsten.huck | Distribution preview at additional eaves/ridges |
| 2.4 | Sep 2016 | thorsten.huck | Front cut property, alternative grid block display |
| 2.0 | May 2016 | thorsten.huck | Vertical distribution honors connecting ridge tile |
| 1.0 | May 2015 | thorsten.huck | Initial release |

The script has evolved significantly from a simple grid visualization tool to a comprehensive tile distribution calculation engine with support for complex roof geometries, staggered patterns, and automatic adjustment features.

## Glossary

| Term | Definition |
|------|------------|
| **ERoofPlane** | hsbCAD entity representing a roof surface |
| **EdgeTileData** | Data structure containing edge classification and tile information |
| **PlaneProfile** | 2D profile with holes, used for roof boundary and opening handling |
| **Verge** | Roof edge parallel to slope direction (gable edge) |
| **Eave** | Roof edge at bottom (horizontal) |
| **Ridge** | Roof edge at top (horizontal) |
| **Saddle Ridge** | Ridge connecting two roof planes |
| **Pent Ridge** | Ridge without connection (mono-pitch roof top edge) |
| **Lath** | Horizontal batten attached to rafters, tiles hang on laths |
| **Counter Batten** | Vertical batten between rafters and laths (for ventilation/insulation) |
| **LAF** (Lattenabstand First) | Ridge batten distance - spacing from last lath to ridge |
| **LAT** (Lattenabstand Traufe) | Eave tile offset - spacing from eave to first lath |
| **Staggered Distribution** | Tile pattern where alternating rows are offset by half-tile width |
| **Half Tile** | Tile with half the standard width, used at verges for staggered patterns |
| **Front Cut** | Orientation of the eave cut (plumb, perpendicular, or by roofplane setting) |
| **Z-Offset** | Vertical distance from rafter plane to tile lath underside |
| **SubMapX** | hsbCAD's entity-attached key-value data storage |

## Support and Updates

For questions, issues, or feature requests related to the `_hsbTileGrid` script:

- **hsbCAD Support**: support@hsbcad.com
- **Documentation**: This guide is generated from script version 5.9 (July 2023)
- **Required hsbCAD Version**: V22 or later
- **DLL Dependency**: RoofTilingManager.dll version 20.0.0.1 or later

**Script Location**: `[hsbCAD Install]\Content\General\TSL\_hsbTileGrid.mcr`

---

*Document generated from TSL script analysis - Version 5.9*