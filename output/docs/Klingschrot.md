# Klingschrot - Log Wall Corner Connection Tool

## Overview

The **Klingschrot** script creates traditional log wall corner connections using the specialized "Klingschrot" joinery technique, a sophisticated timber joining method used in high-quality log construction. This connection method employs a special milling tool with a precisely defined radius of 175mm and tool width of 80mm to create interlocking curved joints between perpendicular log walls.

The script automatically detects intersecting log wall elements (ElementLog) and generates the appropriate milling operations and beam cuts to create precise interlocking corner joints. It supports both L-shaped corner connections and T-connections where one wall continues through while another terminates.

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Environment** | Model Space |
| **Requires Beams** | No (0 beams required) |
| **Requires Elements** | Yes - Log wall elements (ElementLog) |
| **Major Version** | 1 |
| **Minor Version** | 3 |
| **Last Updated** | 20.06.2023 |
| **Execution Mode** | Automatic distribution + individual connections |

---

## Prerequisites

Before using this script, ensure the following conditions are met:

### Required Elements

1. **Log wall elements (ElementLog)** - You must have at least two log wall elements in your drawing that intersect at the connection point
2. **Perpendicular walls** - The script **only supports perpendicular (90-degree) wall connections**. Walls at other angles will be automatically skipped with a warning message
3. **Proper log courses** - The log wall elements should have properly defined log courses with correct tongue dimensions
4. **Sufficient intersection area** - The intersection area must be larger than 4 square units

### Machine Requirements

5. **Klingschrot milling tool** - The specialized Klingschrot tool (R=175mm, W=80mm) must be available in your CNC machine configuration
6. **Tool capability** - Your milling machine must support the specific curved cutting pattern required by this connection type

### Drawing State

7. **Model Space active** - The script operates in Model Space (not Paper Space)
8. **Proper wall geometry** - Log walls should have valid envelope geometry and properly defined dimensions

---

## Usage Workflow

### Phase 1: Initial Insertion and Element Selection

1. **Start the command** by running the Klingschrot script from the TSL menu or command line

2. **Catalog/Preset Selection (Optional)**
   - If executed via a specific Execute Key and catalog presets are available, the script will automatically load those settings
   - Otherwise, the standard property dialog will appear for parameter configuration

3. **Configure Parameters** (if dialog appears)
   - Set desired seat width and depth values
   - Select connection type (Concave, Convex, or Diagonal)
   - Adjust vertical offset if needed
   - See [Properties Panel Parameters](#properties-panel-parameters) section for detailed descriptions

4. **Select Log Wall Elements**
   - When prompted with "Select elements", click on the log wall elements you want to connect
   - You can select multiple walls - the script will automatically find all perpendicular intersections
   - Press Enter to complete the selection

5. **Automatic Distribution**
   - The script enters "Wall Distribution Mode" (mode 1)
   - It automatically detects all perpendicular intersections between selected walls
   - For each valid intersection, it creates a separate Klingschrot connection instance
   - The original instance is then erased, replaced by individual connection instances

### Phase 2: Connection Processing

After automatic distribution, each connection instance:

1. **Analyzes the intersection geometry**
   - Detects whether it's a corner (L-type) or T-connection
   - Calculates the connection volume and height range
   - Determines which wall is "through" and which terminates (for T-connections)

2. **Creates visual representation**
   - Displays a distinctive "K" symbol in plan view at the intersection
   - Shows semi-transparent yellow connection zones in 3D
   - Adds wall number labels (e.g., "Wall1-Wall2")

3. **Generates tooling operations**
   - Adds Klingschrot milling tools to individual log beams
   - Applies seat cuts if configured
   - Respects any logs that have been manually excluded

---

## Properties Panel Parameters

After insertion, you can modify connection parameters through the AutoCAD Properties Palette (OPM).

### General Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **Base Height** | Length | 0 | mm | Defines the starting height of the connection from the base point. The connection will only affect logs above this elevation. Use grips or enter a value to offset the connection vertically. |
| **End Height** | Length | 0 (auto) | mm | Defines the maximum height of the connection. Set to 0 for automatic detection based on wall heights. When set to a specific value, the connection will stop at that elevation, leaving upper logs uncut. |

**Usage Tips:**
- Leave both at 0 initially for automatic full-height connections
- Set Base Height > 0 to start the connection above the foundation
- Set End Height to a specific value to exclude top logs from machining

### Seatcut / Tapering Category

These parameters control the seat cuts (overlap joints) applied to the logs.

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **Seat width** | Length | 0 | mm | The width of the seat cut or diagonal milling applied to the logs. This creates an overlapping joint that improves weather resistance and structural integrity. |
| **Seat depth** / **Tapering** | Length | 0 | mm | The depth of the seat cut. The label changes based on connection type: "Seat depth" for Concave/Convex, "Tapering" for Diagonal. **Negative values force an additional beam cut operation** to completely clear material. |
| **Type** | Selection | Concave | - | Connection type selection: **Concave** (standard curved inward), **Convex** (curved outward), or **Diagonal** (angled cut). **Note:** Only "Concave" is available for T-connections due to geometric constraints. |

**Connection Type Details:**

- **Concave** (Default)
  - Curved joint with inward-facing arc
  - Works for both corner and T-connections
  - Best weather protection
  - Most traditional appearance

- **Convex**
  - Curved joint with outward-facing arc
  - Only available for corner (L-type) connections
  - Alternative aesthetic appearance
  - Color indicator: Yellow-orange in plan view

- **Diagonal**
  - Angled straight cut instead of curved
  - Only available for corner (L-type) connections
  - Simpler machining requirement
  - Color indicator: White in plan view

**Property Behavior:**
- The Type dropdown automatically hides options when a T-connection is detected
- If you manually switch a corner to a T-connection configuration, the Type will automatically reset to Concave

### Tool Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **Vertical Offset** | Length | 0 | mm | Moves the milling tool in the vertical direction relative to each log course center. Positive values shift the tool upward, negative values downward. Use this to fine-tune the vertical position of the curved cut. |
| **Orientation T-Connection** | Selection | Positive | - | Controls the orientation direction on T-connections. Options: **Positive** or **Negative**. This determines which side of the "through" wall the connection favors. Can also be toggled by double-clicking the connection. Only visible when a T-connection is detected. |

**Note on Tool Dimensions:**
- **Tool Radius**: Fixed at 175mm (cannot be changed)
- **Tool Width**: Fixed at 80mm (cannot be changed)

These values are hard-coded to match the physical Klingschrot tooling specifications. Earlier versions allowed these to be adjustable, but they are now static values as of Version 1.2.

---

## Interactive Controls

### Grip Manipulation

The connection displays **4 arrow-shaped grips** that allow visual, real-time adjustment:

#### Bottom Grips (2x - Blue Arrows Pointing Down)
- **Location**: At the base height of the connection
- **Function**: Drag vertically to adjust the starting height of the connection
- **Synchronization**: Both bottom grips move together
- **Effect**: Updates the "Base Height" property
- **Visibility**: Hidden when viewing perpendicular to the connection axis

#### Top Grips (2x - Blue Arrows Pointing Up)
- **Location**: At the end height of the connection
- **Function**: Drag vertically to adjust the maximum height of the connection
- **Synchronization**: Both top grips move together
- **Effect**: Updates the "End Height" property
- **Constraint**: Cannot be dragged below the visible height of the first log

**During Grip Dragging:**
- A semi-transparent preview shows the new connection volume
- Affected log cross-sections are highlighted in light blue
- The "K" symbol moves to the new elevation
- Changes are applied when you release the grip

### Double-Click Behavior

**Double-clicking** on the connection instance toggles the **Orientation** parameter (for T-connections only).

- First double-click: Changes from Positive to Negative
- Second double-click: Changes back to Positive
- Same effect as using the right-click menu "Swap Direction" command
- Only functional when the connection is a T-type

### Property Panel Synchronization

- Changing "Base Height" or "End Height" in the Properties Palette immediately updates grip positions
- Moving grips immediately updates the corresponding property values
- All changes trigger automatic recalculation (2 execution loops)

---

## Right-Click Context Menu

Right-click on the Klingschrot connection instance to access these specialized commands:

| Menu Item | Function | When Available |
|-----------|----------|----------------|
| **Swap Direction** | Toggles the orientation between Positive and Negative for T-connections. This flips which side of the "through" wall the connection favors. Same effect as double-clicking the instance. | T-connections only |
| **Remove Logs from Connection** | Opens a selection prompt allowing you to select individual logs (beams) to exclude from the connection processing. Useful when certain logs have special profiles, hardware conflicts, or should not receive the Klingschrot tooling. Selected logs are stored and excluded from all future recalculations. | When beams exist in either wall |
| **Restore all logs of Connection** | Re-includes all previously removed logs back into the connection processing. Clears the exclusion list. | Only when logs have been previously removed |

**Usage Example - Remove Logs:**
1. Right-click on connection → "Remove Logs from Connection"
2. Click on individual logs you want to exclude
3. Press Enter to confirm
4. The connection recalculates, skipping the selected logs
5. The excluded logs are stored in the connection's internal map

**Usage Example - Restore Logs:**
1. Right-click on connection → "Restore all logs of Connection"
2. All previously excluded logs are immediately re-included
3. The connection recalculates with full log coverage

---

## Connection Types and Detection

The script automatically detects the connection type based on wall geometry.

### Corner Connection (L-Type)

**Detection Criteria:**
- Two walls meet at an intersection
- Both walls terminate at the intersection (neither continues through)
- Walls are perpendicular (90 degrees)

**Available Features:**
- All three connection types are available (Concave, Convex, Diagonal)
- Seat cuts are applied symmetrically to both walls
- Both walls receive equal treatment

**Typical Applications:**
- Building corners
- External wall intersections
- Enclosed room corners

### T-Connection

**Detection Criteria:**
- Two walls meet at an intersection
- **One wall continues through** while the other wall terminates at it
- The script detects which wall extends beyond the intersection by at least 1.5 times the width of the intersecting wall

**Automatic Behavior:**
- Only the **Concave** connection type is available (Type dropdown is hidden)
- If the first wall is detected as "through", the script automatically swaps wall order and recalculates
- The "Orientation" property becomes visible and functional

**Available Features:**
- Orientation control (Positive/Negative)
- Seat cuts with different behavior than corner connections
- Additional tolerance for seat cuts (increased in Version 1.3)

**Typical Applications:**
- Interior wall connections
- Partition walls meeting exterior walls
- Cross-bracing wall configurations

### Invalid Configurations

The script will display an error and erase the instance if:

1. **Non-perpendicular walls**: "supports only perpendicular connections"
   - Walls must be exactly 90 degrees to each other
   - The script uses `Vector3d.isPerpendicularTo()` for detection

2. **No intersection detected**: "Could not detect connection type between elements"
   - Walls do not overlap in plan view
   - Intersection area is too small (< 4 square units)
   - Walls are on different vertical levels with no overlap

3. **Insufficient height**: If calculated connection height is invalid or zero

---

## Visual Indicators and Display

### Plan View (Top-Down)

The connection displays distinct visual elements in plan view:

#### "K" Symbol
- Positioned at the intersection point
- Size proportional to the smaller wall width
- Drawn with filled polylines for visibility
- Always displayed at the top height of the connection
- Color matches the connection type (see below)

#### Color Coding by Type
- **Concave**: Olive/khaki color (RGB: 219, 208, 81)
- **Convex**: Yellow-orange color (RGB: 254, 204, 102)
- **Diagonal**: White

#### Connection Footprint
- Semi-transparent yellow filled profile showing the connection area
- Includes both wall intersections plus any extra length for non-through walls

### 3D Model View

#### Connection Volume
- Semi-transparent yellow zones (60% transparency)
- Two horizontal planes (at base and end height)
- Vertical line connecting them
- Preview turns lighter during grip dragging

#### Text Labels
- Wall numbers displayed (e.g., "Wall1-Wall2")
- Positioned at the top of the connection
- Text height: 90mm (drawing units)
- Visibility optimized for 3D views perpendicular to wall faces

#### Grip Dragging Preview
- Previous connection volume shown at 50% transparency
- New connection volume highlighted in light blue
- Affected log cross-sections displayed
- Real-time visual feedback

### Visibility Control

The script uses advanced Display filters:

- **Plan displays**: Visible only when viewing along ±Z axis
- **Model displays**: Hidden when viewing along ±Z axis (top/down)
- **Text labels**: Visible from wall face directions only
- **Grips**: Hidden when viewing perpendicular to connection axis

**Drawing Order:**
- The connection is automatically set to draw in front (setDrawOrderToFront)
- Ensures visibility above wall and log graphics

---

## Tooling Operations Generated

The script generates multiple types of machining operations applied to individual log beams.

### Klingschrot Milling Tool

**Tool Specification:**
- **Class**: `Klingschrot` (custom tool type)
- **Radius**: 175mm (fixed)
- **Width**: 80mm (arc width of the milling head)
- **Speed**: 0 (default)
- **Mill Head Index**: 0

**Application Pattern:**

For each log course within the connection height range:

1. **Upper Tool Application**
   - Position: Offset above log center by (dOffsetCen + dRadius)
   - Direction: Upward (+Z)
   - Applied if: Tool location is below the connection top height
   - Skip if: Tool would extend above the connection boundary

2. **Lower Tool Application**
   - Position: Offset below log center by (dOffsetCen + dRadius - dYDelta)
   - Direction: Downward (-Z)
   - Applied if: Tool location is above the connection base height
   - Skip if: Tool would extend below the connection boundary

**Offset Calculation:**
- `dOffsetCen = 0.25 * visible_height + radius`
- `dYDelta` accounts for the inclining height based on circular intersection geometry

**Lead Width (Horizontal Extent):**
- Varies based on wall width, tool width, seat cuts, and connection type
- For through walls: includes extra length beyond the intersection
- For terminating walls: stops at the intersecting wall face

### Seat Cut (BeamCut Tool)

Applied when **Seat width** or **Seat depth** is greater than zero.

#### Corner Connection Seat Cuts

- **On Wall 0 logs**:
  - Position: Calculated based on seat depth and width
  - Direction: Along the intersecting wall axis
  - Creates overlap joint on one face

- **On Wall 1 logs**:
  - Position: Calculated symmetrically
  - Direction: Along the other wall axis
  - Creates matching overlap joint

- **Diagonal Type**:
  - Additional angled cuts (`bc0D`, `bc1D`)
  - Cut along the diagonal between the two seat offsets
  - Applied to both walls

#### T-Connection Seat Cuts

- **On Through Wall (Wall 0)**:
  - Single cut at the intersection face
  - Width-based offset if Seat width > 0
  - Optional second cut (`bc02`) if width is specified

- **On Terminating Wall (Wall 1)**:
  - Cut at the junction point
  - Depth follows the specified seat depth

**Negative Depth Handling:**
- When Seat depth < 0, the description changes to warn about "forcing an additional beamcut"
- This ensures complete material removal in special geometric cases

### Log Exclusion Handling

Before applying any tools to a log:

```
if (bmRemovals.find(log) > -1) {
    continue; // Skip this log
}
```

Logs in the removal list (set via right-click menu) are completely excluded from all tooling operations.

---

## Automatic Recalculation and Triggers

The script uses a sophisticated trigger system for automatic updates.

### Recalculation Triggers

| Trigger Event | Execute Key | Action |
|---------------|-------------|--------|
| Grip point drag | `"_Grip"` | Live preview during dragging, update heights on release |
| Double-click | `"TslDoubleClick"` | Toggle orientation (T-connections) |
| Context menu: Swap Direction | Translated string | Toggle orientation |
| Context menu: Remove Logs | Translated string | Prompt for log selection, store in map |
| Context menu: Restore Logs | Translated string | Clear removal list from map |
| Property change | Property name | Update grips, recalculate geometry |
| Element deletion | `_bOnElementDeleted` | Clear removal list |

### Execution Loop Control

The script uses `setExecutionLoops(2)` extensively:

**When 2 loops are triggered:**
- After grip manipulation (to update properties and recalculate)
- After property changes (to update grips and recalculate)
- After T-connection swap (element order changes)
- After removing/restoring logs
- When seat width becomes invalid (forced reset)

**First Loop:**
- Detects changes
- Updates internal state
- May swap element order (for T-connections)

**Second Loop:**
- Performs final calculations with corrected state
- Generates all tooling
- Updates display

### Map Storage for Persistence

| Map Key | Type | Purpose |
|---------|------|---------|
| `"mode"` | Int | 1 = Distribution mode, 2 = Connection mode |
| `"swap"` | Int | Swap flag (legacy, not actively used) |
| `"isTConnection"` | Int | Boolean flag indicating T-connection type |
| `"ptsZ"` | Point3d[] | Stores last grip positions for drag preview |
| `"Log[]"` | Entity[] | Array of excluded logs (from "Remove Logs" command) |

The map is automatically cleaned when elements are deleted (`_bOnElementDeleted`).

---

## Workflow Integration

### Typical Project Workflow

1. **Design Phase**
   - Create log wall elements (ElementLog) in your project
   - Define wall positions, heights, and log courses
   - Ensure walls are properly perpendicular where connections are needed

2. **Connection Insertion**
   - Select multiple log walls
   - Run Klingschrot script
   - Script automatically creates connections at all perpendicular intersections

3. **Connection Refinement**
   - Adjust base/end heights using grips if needed
   - Configure seat cuts for weather protection
   - Exclude problematic logs via right-click menu
   - Fine-tune with vertical offset

4. **Verification**
   - Check 3D model view to verify connection geometry
   - Ensure all logs are properly machined
   - Verify no tool conflicts with other hardware

5. **Production Output**
   - Export to CNC machine
   - The Klingschrot tool operations are included in beam tool lists
   - Seat cuts are included as standard BeamCut operations

### Related Scripts

The Klingschrot script interacts with and complements other log wall tools:

- **Tirolerschloss** - Alternative log wall connection type for traditional timber joinery
  - The script automatically removes duplicate connections from the same walls
  - Only one connection type should be active per wall pair

- **ElementLog Creation Tools** - Required to create the base log wall elements

- **Log Course Definition Tools** - Used to set up the vertical stacking pattern
  - Log courses must be properly defined for accurate tool placement

- **CNC Export Tools** - For generating machine code from the tool operations

- **HSB_G-BillOfMaterial** - Can include Klingschrot connections in material lists

---

## Advanced Features and Technical Details

### Duplicate Connection Prevention

When the script creates a new connection, it automatically checks for existing connections:

```
String sLogConnectionScripts[] = { "Tirolerschloss", "Klingschrot" };
```

For each attached TSL instance:
- If the script name matches a log connection type
- And it's attached to both walls
- And it's not the current instance
- Then: **Erase the duplicate**

This ensures only one connection type is active per wall pair.

### Intersection Detection Algorithm

1. **Extract wall outlines** in plan view (PlaneProfile)
2. **Test for intersection** using PlaneProfile.intersectWith()
3. **Verify area** > 4 square units
4. **Calculate midpoint** of intersection region
5. **Extend for non-through walls** to include extra length
6. **Create test body** (bdx) for beam filtering

### Log Course Processing

For each log course in Wall 0:
1. Get vertical range (dYMin to dYMax)
2. Create a body spanning that height range
3. Intersect with connection volume (bdx)
4. Filter logs from both walls that intersect this zone
5. Apply tools to each log at the calculated positions

This ensures tools are correctly positioned even when:
- Log courses are irregular
- Logs have varying heights
- Walls have different log patterns

### Geometric Calculations

**Connection Vectors:**
- `vecXC0`, `vecXC1`: Wall X-axes pointing toward the connection
- `vecYC0`, `vecYC1`: Wall Y-axes (perpendicular to X)
- `vecXCM`, `vecYCM`: Mean vectors for symmetric positioning
- `vecZC0`, `vecZC1`: Wall thickness directions pointing toward connection

**Through Wall Detection:**
- If `(vecXC0 · (ptEnd0 - ptm)) > 1.5 * dZ1`: Wall 0 is through
- If `(vecXC1 · (ptEnd1 - ptm)) > 1.5 * dZ0`: Wall 1 is through
- If exactly one is through: **T-connection**
- If both or neither: **Corner connection**

**Inclining Height (dYDelta):**
- Creates a circle with radius = tool radius
- Intersects with plane at wall face
- Calculates vertical distance from circle center to intersection
- Used to adjust lower tool position for proper engagement

### Coordinate Systems

The script uses multiple coordinate systems:

1. **World Coordinate System** (_XW, _YW, _ZW)
   - Used for vertical calculations
   - All height measurements are along _ZW

2. **Element Coordinate Systems**
   - Each ElementLog has its own vecX, vecY, vecZ
   - Used for wall-relative calculations

3. **Connection Coordinate Systems**
   - vecXC*, vecYC* point toward/along the connection
   - Used for tool positioning and seat cuts

4. **Tool Coordinate Systems**
   - vecXT, vecYT, vecZT define tool orientation
   - Rotated appropriately for each wall's logs

### Performance Optimizations

- Uses `envelopeBody()` instead of `realBody()` where possible
- Filters beams early using body intersection tests
- Skips debug visualizations when not in debug mode
- Reuses calculated geometric values across log courses

---

## Settings and Configuration

### Catalog System Support

The script supports the standard hsbCAD catalog system:

**On Insertion:**
- If `_kExecuteKey` matches a catalog name: Load those property values
- Otherwise: Show the standard property dialog

**Catalog Paths:**
- Standard hsbCAD catalog locations are used
- Catalog name: Same as script name ("Klingschrot")
- Last inserted values are stored under special key `"|_LastInserted|"`

### Translation Support

All user-facing strings use the `T()` translation function:

```
String tDefault = T("|_Default|");
String tConcave = T("|Concave|");
String sTriggerSwap = T("|Swap Direction|");
```

Translation keys use the `|key|` pipe notation for lookup in language files.

### Debug Mode

When `bDebug = _bOnDbCreated` (debug flag is set):

**Additional Visualizations:**
- Intersection profiles shown with `.vis()` calls
- Reference points and vectors drawn
- Log centers marked with colors
- Debug messages for tool placement decisions

**Property Changes:**
- Type dropdown remains visible even for T-connections
- Read-only restrictions are lifted

**Behavior Changes:**
- In distribution mode, connections are visualized but not created
- Detailed console output for troubleshooting

### Unit Handling

```
U(1, "mm");
```

All dimensions are specified in millimeters. The `U()` function ensures correct conversion to the current drawing units (mm or inches).

---

## Troubleshooting Guide

### Common Issues and Solutions

#### Issue: "supports only perpendicular connections" message

**Cause:** Your walls are not exactly 90 degrees to each other.

**Solutions:**
1. Use AutoCAD's ROTATE command to ensure walls are exactly perpendicular
2. Check wall orientation using UCS and dimension tools
3. Verify wall elements were created with proper alignment
4. Use ORTHO mode when drawing walls to ensure 90-degree angles

---

#### Issue: "Could not detect connection type between elements" message

**Cause:** Walls do not intersect properly.

**Solutions:**
1. Verify walls actually overlap in plan view (use PLAN command)
2. Check that walls are on the same vertical level
3. Ensure intersection area is sufficient (> 4 square units)
4. Move walls closer if gap exists
5. Verify wall outlines are valid (not corrupted geometry)

---

#### Issue: Connection appears but no tooling is generated

**Cause:** No log beams found within the connection volume.

**Solutions:**
1. Check that log courses are properly defined on both walls
2. Verify logs actually exist at the intersection height range
3. Adjust Base Height and End Height to match log positions
4. Ensure logs are not filtered out by other criteria
5. Check if logs were accidentally added to the removal list (use "Restore all logs")

---

#### Issue: Only "Concave" type is available

**Cause:** The script detected a T-connection.

**Explanation:** T-connections can only use Concave type due to geometric constraints. This is intentional behavior, not a bug.

**Solutions:**
1. If you need other types, modify wall geometry to create a corner connection instead
2. Ensure both walls terminate at the intersection
3. Check wall lengths - if one extends significantly beyond the intersection, it's detected as "through"

---

#### Issue: Connection is on the wrong side of a T-connection

**Solutions:**
1. Double-click the connection to toggle orientation
2. Right-click → "Swap Direction"
3. Use the Orientation property in the Properties Palette
4. If still wrong, swap the wall order by deleting and reinserting

---

#### Issue: Grips are not visible

**Cause:** Viewing direction hides grips.

**Solutions:**
1. Rotate the view to be perpendicular to the connection plane
2. Switch to a 3D isometric view
3. Grips are hidden when viewing straight down (plan view) or along the connection axis
4. Use PLAN or 3DORBIT to change viewpoint

---

#### Issue: Seat width/depth not creating visible cuts

**Cause:** Values may be too small or walls too thin.

**Solutions:**
1. Increase seat width and depth values (try 20-30mm as starting point)
2. Check that values are positive (negative depth has special meaning)
3. Verify wall thickness is sufficient for the seat dimensions
4. Switch to 3D view to see the seat cuts more clearly
5. Check individual log properties to verify BeamCut tools were added

---

#### Issue: Some logs are not being cut

**Possible Causes:**

1. **Logs in removal list**
   - Solution: Right-click → "Restore all logs of Connection"

2. **Logs outside height range**
   - Solution: Adjust Base Height or End Height to include those logs

3. **Tool position above/below log**
   - Solution: Adjust Vertical Offset parameter

4. **Logs not intersecting connection volume**
   - Solution: Check log positions, may be misaligned

---

#### Issue: Error "Unexpected error detecting the connection height"

**Cause:** Geometry calculation failed.

**Solutions:**
1. Delete connection and re-insert
2. Verify wall element geometry is valid (not corrupted)
3. Check that walls have proper envelope geometry
4. Ensure log courses are properly defined
5. Try simplifying wall geometry if very complex

---

#### Issue: Connection recalculates very slowly

**Possible Causes:**
1. Very large number of logs in the walls
2. Complex wall geometry with many components
3. Debug mode enabled

**Solutions:**
1. Disable debug mode if enabled
2. Reduce log count by adjusting log course parameters
3. Simplify wall elements if possible
4. Close unnecessary drawings to free memory

---

#### Issue: Width validation message appears

**Cause:** Lead width calculation resulted in negative value.

**Auto-correction:** The script automatically sets Seat width to 0 and recalculates.

**Prevention:**
1. Don't use excessively large seat width values
2. Ensure wall thickness is sufficient (typically > 150mm)
3. For thin walls, reduce or eliminate seat cuts

---

### Visual Verification Checklist

Before finalizing the connection:

- [ ] Connection symbol ("K") is visible in plan view at correct location
- [ ] 3D view shows yellow connection zones at expected heights
- [ ] Wall numbers are displayed correctly
- [ ] All four grips are visible in appropriate views
- [ ] Each log shows the curved Klingschrot tool in its tool list
- [ ] Seat cuts appear if configured (check individual log properties)
- [ ] No unwanted logs are being cut
- [ ] Connection color matches the expected type
- [ ] No error messages in the command line

---

## Version History and Changes

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| **1.3** | 20.06.2023 | T-Connection seat tolerance increased to improve fit and reduce machining issues | Thorsten Huck |
| **1.2** | 20.06.2023 | Tool properties (radius and width) changed from user-adjustable PropDouble to static values (175mm and 80mm). Seat cuts now added as individual tools instead of combined operations. | Thorsten Huck |
| **1.1** | 07.06.2023 | Initial version of log connection of type Klingschrot | Thorsten Huck |

### Migration Notes

**From 1.1 to 1.2:**
- Tool radius and width properties were removed from the Properties Palette
- Existing instances with custom tool dimensions will be overridden with standard values (175mm/80mm)
- Seat cuts are now separate BeamCut tools, improving CNC output clarity

**From 1.2 to 1.3:**
- No user-visible changes
- Improved tolerance for T-connection seat cuts
- Existing connections will benefit from improved fit on recalculation

---

## Technical Reference

### Script Commands

The script provides AutoCAD command line integration:

#### Insert Command
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Klingschrot")) TSLCONTENT
```

#### Optional Commands
```
// Swap direction
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Direction|") (_TM "|Select connection|"))) TSLCONTENT

// Remove logs
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Logs from Connection|") (_TM "|Select connection|"))) TSLCONTENT

// Restore logs
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Restore all logs of Connection|") (_TM "|Select connection|"))) TSLCONTENT
```

### Color Definitions

The script uses intelligent background-adaptive colors:

| Color Variable | Light Background RGB | Dark Background RGB | Purpose |
|----------------|---------------------|---------------------|---------|
| grey | 99, 100, 102 | 199, 200, 202 | General graphics |
| white | 0, 0, 0 | 255, 255, 255 | Text and symbols |
| darkyellow | 254, 204, 102 | 254, 204, 102 | Connection volumes, convex type |
| olive (Concave) | 219, 208, 81 | 219, 208, 81 | Concave type indicator |
| lightblue | 204, 204, 255 | 204, 204, 255 | Grip drag preview |

Background detection: Averages RGB values of background color; if < 127, it's a dark background.

### Required TSL Types

The script uses these advanced hsbCAD types:

- **ElementLog**: Log wall element type
- **LogCourse**: Individual horizontal log course within a wall
- **Klingschrot**: Custom tool type for the specific milling operation
- **BeamCut**: Standard beam cutting tool for seat cuts
- **PlaneProfile**: 2D profile in a plane for intersection calculations
- **CoordSys**: Coordinate system definition

### Dependency on Other Systems

- **Element Group Assignment**: Uses `assignToElementGroup()` with 'T' flag
- **Translation System**: Relies on `T()` function for multi-language support
- **Catalog System**: Uses `TslInst().getListOfCatalogNames()` for preset detection
- **Map Objects**: For persistent data storage across recalculations

---

## Best Practices and Recommendations

### Design Phase

1. **Plan wall layout carefully**
   - Ensure all corners and junctions are exactly perpendicular
   - Use construction lines and ORTHO mode during wall placement
   - Consider connection requirements when positioning walls

2. **Define log courses consistently**
   - Use uniform log heights where possible
   - Ensure tongue dimensions are properly set
   - Verify log course coverage extends through intersection zones

3. **Consider machining constraints**
   - Verify your CNC machine has the Klingschrot tool (R=175, W=80)
   - Check machine reach and accessibility for curved cuts
   - Plan for any machine-specific limitations

### Connection Configuration

4. **Start with defaults**
   - Leave Base Height and End Height at 0 for initial insertion
   - Begin with no seat cuts (width/depth = 0)
   - Use Concave type as default
   - Adjust only after verifying basic connection works

5. **Use seat cuts strategically**
   - Add seat cuts for exterior walls exposed to weather (20-30mm typical)
   - Reduce or eliminate for interior walls
   - Negative depth only when specifically needed for clearance

6. **Height range management**
   - Set Base Height > 0 to exclude foundation logs from machining
   - Set End Height to preserve top logs for special hardware or roof connections
   - Use grips for visual feedback when adjusting heights

### Quality Control

7. **Verify before finalizing**
   - Check 3D view from multiple angles
   - Inspect individual log tool lists (click on logs, view properties)
   - Ensure seat cuts don't conflict with other hardware
   - Verify no logs are accidentally excluded

8. **Test on simple geometry first**
   - Create test connections on simplified wall pairs
   - Verify output before applying to entire building
   - Check CNC output files for correctness

9. **Document custom settings**
   - Save frequently used configurations as catalog presets
   - Name presets clearly (e.g., "Exterior_Corner_30mm_Seat")
   - Share catalog files across team for consistency

### Production Workflow

10. **Coordinate with other trades**
    - Ensure Klingschrot cuts don't interfere with:
      - Electrical chases
      - HVAC penetrations
      - Hardware installations
      - Other timber connections

11. **Review CNC output**
    - Verify tool paths are correct
    - Check for any impossible cuts or collisions
    - Confirm tool diameter matches machine capabilities
    - Test on sample logs if possible

12. **Maintain flexibility**
    - Use "Remove Logs from Connection" for special cases
    - Don't over-constrain with excessive seat cuts
    - Allow for field adjustment when necessary

---

## Comparison with Alternative Connection Types

### Klingschrot vs. Tirolerschloss

| Aspect | Klingschrot | Tirolerschloss |
|--------|-------------|----------------|
| **Geometry** | Curved milling (R=175mm) | Different joinery pattern |
| **Tool Requirements** | Specialized Klingschrot tool | Different tooling |
| **Visual Appearance** | Smooth curved interlocking | Alternative aesthetic |
| **Structural Performance** | High interlocking strength | Different load transfer |
| **Weather Resistance** | Excellent with seat cuts | Varies by configuration |

**Choosing Between Them:**
- Use **Klingschrot** for:
  - Traditional Alpine log construction
  - Projects requiring specific curved aesthetic
  - When weather resistance is critical
  - When CNC machine has the Klingschrot tool

- Use **Tirolerschloss** for:
  - Alternative traditional joinery style
  - Different architectural requirements
  - When specific tooling dictates

**Important:** Only one connection type should be active per wall pair. The script automatically removes duplicates.

---

## Frequently Asked Questions

### General Questions

**Q: What does "Klingschrot" mean?**

**A:** Klingschrot is a traditional German/Austrian log joinery technique. The name refers to the specific pattern and milling method used to create interlocking log corners. "Kling" suggests the ringing/fitting together, and "schrot" relates to cutting or notching.

---

**Q: Can I use this script on non-log walls (stick frame, CLT, etc.)?**

**A:** No. The script specifically requires ElementLog type elements. It's designed for traditional log construction and won't work with stick frame (GenBeam-based walls), CLT panels, or SIP panels. Use appropriate connection scripts for those structure types.

---

**Q: Why are the tool dimensions (175mm radius, 80mm width) fixed?**

**A:** These dimensions match the physical Klingschrot milling tool specifications. Making them fixed (as of Version 1.2) ensures consistency with actual machine capabilities and prevents configuration errors that could result in impossible-to-machine connections.

---

**Q: Can the script handle walls at angles other than 90 degrees?**

**A:** No. The Klingschrot connection is specifically designed for perpendicular (90-degree) wall intersections. Walls at other angles will be silently skipped with a warning message. For angled connections, you'll need to use different joinery methods.

---

### Connection Type Questions

**Q: How do I force a corner connection instead of T-connection?**

**A:** The connection type is automatically detected based on wall geometry. To create a corner connection:
1. Ensure both walls terminate at the intersection
2. Neither wall should extend significantly beyond the junction (< 1.5× the intersecting wall width)
3. Shorten the "through" wall so it ends at the corner
4. Delete and re-insert the connection to trigger re-detection

---

**Q: Why can't I select Convex or Diagonal for my T-connection?**

**A:** T-connections can only use the Concave type due to geometric constraints. The curved joint must face inward toward the "through" wall to function properly. This is a geometric requirement, not a software limitation.

---

**Q: What's the difference between Positive and Negative orientation?**

**A:** For T-connections where one wall passes through:
- **Positive**: The connection favors one side of the through wall
- **Negative**: The connection favors the opposite side
- The effect depends on wall direction vectors and may need testing to see which works better for your specific geometry
- Use the Swap Direction command or double-click to toggle

---

### Height and Range Questions

**Q: What does "0 = automatic" mean for End Height?**

**A:** When End Height is set to 0, the script automatically calculates the maximum height based on:
- The tallest point of both wall envelopes
- The vertical extent of log courses
- The intersection geometry

This ensures the connection covers all logs that actually intersect.

---

**Q: Can I have different base heights for the two walls?**

**A:** No. The Base Height parameter applies equally to both walls. The connection is symmetric in the vertical direction. If you need asymmetric height ranges, you'll need to use other tools or manually exclude specific logs.

---

**Q: How do I connect only the middle logs, leaving top and bottom untouched?**

**A:** You can't directly specify a vertical window, but you can achieve this by:
1. Set Base Height to exclude bottom logs
2. Set End Height to exclude top logs
3. Alternatively, use "Remove Logs from Connection" to manually exclude specific top and bottom logs

---

### Seat Cut Questions

**Q: What seat width and depth values should I use?**

**A:** Typical recommendations:
- **Exterior walls**: 20-30mm width, 15-25mm depth for weather protection
- **Interior walls**: 0-15mm width, 0-10mm depth (minimal or none)
- **Heavy timber**: Up to 40mm width for structural overlap
- **Start conservative**: Begin with smaller values and increase as needed

---

**Q: What does negative seat depth do?**

**A:** A negative depth value forces an additional beam cut operation to completely clear material. This is rarely needed but can be useful when:
- Geometric interference requires extra clearance
- Previous machining left remnants
- Special joint configurations demand complete material removal

Use negative values only when specifically required, as they add extra machining operations.

---

**Q: Why does the label change from "Seat depth" to "Tapering"?**

**A:** The label automatically changes based on the connection Type property:
- **Concave/Convex**: "Seat depth" (creates a step/overlap)
- **Diagonal**: "Tapering" (creates an angled transition)

The parameter functions similarly but the label reflects its geometric meaning for each type.

---

### Tooling and Machining Questions

**Q: How do I verify the tools were actually added to the logs?**

**A:**
1. Click on an individual log beam at the connection
2. Open the Properties Palette
3. Look for the "Tools" section
4. You should see "Klingschrot" tools listed (usually 2 per log - upper and lower)
5. If seat cuts are configured, you'll also see "BeamCut" tools

---

**Q: Why do some logs have 2 tools while others have 0?**

**A:** Logs receive tools based on:
- **Vertical position**: Log must be within Base Height to End Height range
- **Tool clearance**: Tool must fit without extending beyond connection boundaries
- **Exclusion list**: Log must not be in the removal list
- **Intersection**: Log must actually intersect the connection volume

Logs outside these criteria receive no tools, which is correct behavior.

---

**Q: Can I edit the Klingschrot tool parameters after they're added to logs?**

**A:** The tool parameters are controlled by the connection instance, not individually per log. If you change connection properties (like Vertical Offset or seat cuts), the script recalculates and updates all log tools automatically. Direct editing of individual tools is not recommended and will be overwritten on recalculation.

---

### Exclusion and Special Cases Questions

**Q: I excluded a log by mistake. How do I get it back?**

**A:** Right-click on the connection → "Restore all logs of Connection". This clears the entire exclusion list. There's no way to restore individual logs; it's all-or-nothing.

If you want different logs excluded:
1. Restore all logs
2. Use "Remove Logs from Connection" again
3. Select only the logs you want excluded

---

**Q: Does the exclusion persist after closing and reopening the drawing?**

**A:** Yes. Excluded logs are stored in the connection's internal Map storage, which is saved with the drawing file. The exclusion list is persistent across sessions.

---

**Q: What happens if I delete a log that was in the exclusion list?**

**A:** When an element (wall) is deleted, the script automatically clears the exclusion list (`_bOnElementDeleted` trigger). If you delete individual logs but the walls remain, the exclusion list is maintained but the deleted log reference becomes invalid (harmless).

---

### Performance and Workflow Questions

**Q: How many connections can I create at once?**

**A:** There's no hard limit. The distribution mode will create one connection instance for each perpendicular intersection found among the selected walls. However:
- Very large numbers (> 100) may slow down recalculation
- Complex wall geometry increases processing time
- Consider processing in batches for very large buildings

---

**Q: Can I copy the connection to multiple locations?**

**A:** No. Don't use AutoCAD COPY command on Klingschrot connections. Instead:
1. Select multiple wall pairs during initial insertion
2. Let the script automatically distribute connections
3. Or: Insert the script separately for each wall pair

Copying TSL instances directly can cause element reference issues.

---

**Q: What happens when I modify the wall after inserting the connection?**

**A:** The connection should automatically recalculate when:
- Wall geometry changes
- Log courses are modified
- Wall elements are moved

However, if the modification is extensive (walls no longer perpendicular, no longer intersecting), you may need to delete and re-insert the connection.

---

### Troubleshooting Questions

**Q: The connection created successfully but I see no tools on any logs. Why?**

**A:** Check these in order:
1. View the connection in 3D - is the yellow zone visible?
2. Check Base Height and End Height - do they cover where the logs are?
3. Verify logs exist at that height range in both walls
4. Check if all logs were accidentally added to removal list
5. Try adjusting Vertical Offset
6. Delete connection and re-insert

---

**Q: I get "Unexpected error detecting the connection height" every time. What's wrong?**

**A:** This error indicates a geometry calculation failure. Common causes:
1. **Corrupted element geometry**: Delete and recreate the wall elements
2. **Invalid log courses**: Verify log course definitions are correct
3. **Zero-height walls**: Ensure walls have proper height
4. **Missing envelope**: Check wall elements have valid envelope geometry
5. **Software bug**: Update to latest hsbCAD version

---

**Q: Can I have both Klingschrot and Tirolerschloss on the same walls?**

**A:** No. The script automatically detects and removes duplicate log connection scripts on the same wall pair. Only one connection type is allowed per wall intersection. The most recently inserted connection will erase the previous one.

---

## Summary and Quick Reference

### Script Purpose
Traditional log wall corner connection using specialized Klingschrot milling technique with fixed tool dimensions (R=175mm, W=80mm).

### Key Requirements
- ElementLog type walls
- Perpendicular (90°) intersections
- Properly defined log courses
- Specialized Klingschrot CNC tool

### Main Parameters
| Parameter | Typical Value | Purpose |
|-----------|---------------|---------|
| Base Height | 0-500mm | Connection starting elevation |
| End Height | 0 (auto) | Connection ending elevation |
| Seat Width | 0-30mm | Overlap joint width |
| Seat Depth | 0-25mm | Overlap joint depth |
| Type | Concave | Joint geometry (Convex/Diagonal for corners) |
| Vertical Offset | 0mm | Fine-tune tool vertical position |
| Orientation | Positive | T-connection side preference |

### Interactive Controls
- **4 Grips**: Drag to adjust base/end heights visually
- **Double-click**: Toggle orientation (T-connections)
- **Right-click menu**: Swap direction, exclude/restore logs

### Connection Types
- **Corner (L-type)**: Both walls terminate, all types available
- **T-connection**: One wall continues through, Concave only

### Common Workflows
1. **Basic**: Select walls → Run script → Auto-distribute → Done
2. **Refined**: Basic + Adjust heights via grips + Configure seat cuts
3. **Special**: Refined + Exclude problematic logs + Fine-tune offsets

### Visual Indicators
- **Plan view**: "K" symbol with color coding (Concave=olive, Convex=yellow, Diagonal=white)
- **3D view**: Yellow connection zones + wall number labels

### Error Messages
- "supports only perpendicular connections" → Fix wall angles
- "Could not detect connection type" → Check wall overlap
- No visible errors but no tools → Check height range and log positions

---

## Related Documentation

### See Also
- **Tirolerschloss.md** - Alternative log wall connection type
- **ElementLog User Guide** - Creating and managing log wall elements
- **Log Course Definition** - Setting up vertical log stacking
- **CNC Export Tools** - Generating machine code from connections
- **HSB_G-BillOfMaterial.md** - Including connections in material lists

### External References
- hsbCAD User Manual - Log Construction chapter
- CNC Machine Specifications - Klingschrot tool requirements
- Traditional Timber Joinery - Historical context and variations

---

*Document Version: 2.0*
*Generated: 2026-02-20*
*Script Version: 1.3 (2023-06-20)*
*Documentation Coverage: Comprehensive analysis of 269KB source code*
