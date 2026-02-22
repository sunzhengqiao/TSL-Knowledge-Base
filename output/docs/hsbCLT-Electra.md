# hsbCLT-Electra

## Overview and Purpose

**hsbCLT-Electra** is a specialized TSL script for creating CNC-ready electrical installations on CLT (Cross-Laminated Timber) panels and wall elements. It automates the generation of socket cutouts, wire chase channels, and associated machining operations for electrical systems in timber construction.

### Key Capabilities

- **Three Socket Cutout Types**: Drill (circular), Slotted Hole (oblong), and Rectangular (box)
- **Wire Chase Milling**: Vertical or horizontal cable routing channels with flexible positioning
- **Automatic BOM Generation**: Hardware components are automatically created for material lists
- **Shop Drawing Integration**: Publishes dimension requests for automated fabrication drawings
- **Intelligent Collision Avoidance**: Automatically repositions text labels to prevent overlaps
- **Interactive Editing**: Grip points for direct manipulation and "Edit in Place" mode for wire chase adjustment
- **Catalog Support**: Pre-configured installation types for rapid deployment

### Target Use Cases

- Electrical outlet installations (single or multi-gang)
- Switch box configurations
- Cable routing channels (vertical/horizontal/angled)
- Wire-chase-only installations (no socket, just conduit milling)
- Integrated socket + wire chase systems

---

## Script Metadata

| Property | Value |
|----------|-------|
| **Type** | O (Object) - Parametric TSL entity |
| **Script Space** | Model Space |
| **Required Beams** | 0 (attaches directly to CLT panels or wall elements) |
| **Current Version** | 4.11 (May 22, 2025) |
| **Keywords** | CLT, Electrical, Conduit |
| **Export Support** | DXA export enabled (#DxaOut 1) |
| **Insertion Mode** | Implicit insertion (#ImplInsert 1) |

---

## Prerequisites

### Required Elements

1. **CLT Panel or Wall Element**: At least one `Sip` (CLT panel) or `ElementWall` containing CLT panels must exist in the model
2. **Valid 3D Geometry**: Panel or element must be a valid 3D solid with a defined coordinate system
3. **Access Rights**: Write access to the drawing database for creating tools and hardware components

### Optional Configuration

- **Settings File**: `hsbCLT-Electra.xml` in company or installation TSL Settings folder
  - Location 1 (Priority): `[CompanyPath]\TSL\Settings\hsbCLT-Electra.xml`
  - Location 2 (Fallback): `[InstallPath]\Content\General\TSL\Settings\hsbCLT-Electra.xml`
  - Purpose: Stores predefined format entries for the display text dropdown

- **Catalog Entries**: Predefined installation types in the hsbCAD catalog system

- **Raw Beam Geometry**: For "Tag Tools" functionality, a `Soligno-RiegelVerteilung` script attached to panels provides raw beam geometry for intersection testing

---

## Usage Instructions

### Step 1: Launch the Script

Choose one of the following methods:

**Method A: Standard Insertion**
```
Command: TSLINSERT
Select: hsbCLT-Electra
```

**Method B: Catalog Entry Insertion** (Recommended for repeated use)
- Use the catalog command to insert a preconfigured installation type
- Examples: "Socket 1x", "Socket 2x", "Wirechase"
- All property values are preloaded from the catalog definition
- Elevation can be overridden at the command line

**Method C: Command Line Shortcut**
```
(hsb_ScriptInsert "hsbCLT-Electra")
```

### Step 2: Select Target Panels or Elements

**Command Line Prompt:**
```
Select panels or elements which contain panels
```

**Selection Options:**

1. **Direct Panel Selection**: Click on one or more CLT panels (Sip entities)
   - If the selected panel belongs to a wall element, the script automatically upgrades to element-level assignment for better copy and recalculation behavior

2. **Element Selection**: Click on a wall element (ElementWall)
   - Script automatically finds all panels belonging to that element
   - Recommended for installations that may be copied or when panels are modified

3. **Mixed Selection**: If both panels and elements are selected, the element is prioritized

**Important Behavior Note:**
- Element-level assignment provides better behavior when panels are split, modified, or when the installation is copied
- If a panel has a valid element reference, the script automatically switches to element assignment mode

### Step 3: Confirm Elevation (Catalog Insertion Only)

**Applies only when inserting via catalog entry**

**Command Line Prompt:**
```
Elevation [350]:
```

**Options:**
- Press `Enter` to accept the default elevation from the catalog
- Type a new elevation value (in drawing units) and press `Enter` to override
- Example: Type `1200` for 1200mm elevation from the panel bottom

**Notes:**
- This prompt does NOT appear for standard insertion (Method A above)
- Elevation is measured from the bottom of the panel
- If the panel has a "FinishedFloor" elevation defined in its submap, the final position accounts for finished floor height

### Step 4: Specify Insertion Point

**Command Line Prompt:**
```
(Point selection mode)
```

**Action:**
- Click a point on or near the panel surface
- This point becomes the center of the socket(s) or the reference for the wire chase

**Automatic Adjustments:**
- The script automatically snaps the insertion point to the nearest outline point of the panel in the Z-direction (perpendicular to the panel face)
- The point is constrained to the panel envelope
- If you click outside the panel envelope, the point is moved to the closest valid location

### Step 5: Adjust Properties in the Properties Palette (OPM)

After placement, select the instance and modify parameters in the AutoCAD Properties Palette. Changes take effect immediately through automatic recalculation.

**See "Parameter Reference" section below for detailed property descriptions**

---

## Parameter Reference

### General Category

#### Quantity
- **Type**: Integer dropdown (0-5)
- **Default**: 1
- **Description**: Number of electrical boxes to create
- **Values**:
  - `0`: Wire-chase-only installation (no socket cutout)
  - `1-5`: Creates the specified number of socket cutouts
- **Usage**: Set to 2 for double switches, 3 for triple switches, etc.
- **Behavior**: When Quantity is less than 2, the "Offset between Installations" property is hidden in the display, and format expressions referencing this property are suppressed

#### Elevation
- **Type**: Double
- **Default**: 350 mm
- **Description**: Vertical height of the installation center measured from the bottom of the panel
- **Reference Point**: Panel bottom (or finished floor elevation if defined in panel submap)
- **Special Behavior**: For vertical alignment with more than 3 boxes, elevation is automatically adjusted to the second socket from the top
- **Interaction with Finished Floor**: If the panel has a "FinishedFloor" submap with "ElevationFinishedFloor" value, the script adds this offset to the elevation

#### Tooling Shape
- **Type**: Dropdown
- **Default**: Drill
- **Options**:
  1. **Drill**: Circular hole (uses Drill tool, depth is doubled)
  2. **Slotted Hole**: Oblong slot with rounded ends (uses Mortise tool with round end caps)
  3. **Rectangular**: Box-shaped pocket (uses BeamCut tool, writes flag to mapX for rectangular socket identification)
- **CNC Output**: Rectangular sockets are flagged with `bRectangularSocket` in the `ToolInfo` submap (as of version 4.11)

#### Alignment
- **Type**: Dropdown
- **Default**: Horizontal
- **Options**:
  - **Horizontal**: Distributes sockets along the panel width (X-direction)
  - **Vertical**: Distributes sockets along the panel height (Y-direction)
- **Special Behavior**: When vertical with more than 3 boxes, the elevation reference point shifts to the second from top
- **Effect on Wire Chase**: Determines the base distribution direction before wire chase alignment is applied

#### Diameter
- **Type**: Double
- **Default**: 70 mm
- **Description**:
  - For Drill: Diameter of the circular hole
  - For Slotted Hole: Width (cross-sectional dimension)
  - For Rectangular: Box width/height
- **Auto-correction**: If Quantity > 1 and Offset between Installations ≤ 0, the offset is automatically corrected to equal the diameter

#### Depth
- **Type**: Double
- **Default**: 70 mm
- **Description**: Penetration depth of the cutout into the panel material
- **Actual Cutting Depth**:
  - **Drill and Slotted Hole**: Doubled internally (actual CNC depth = 2 × Depth property)
  - **Rectangular**: Used as-is
- **Purpose**: The doubling ensures proper through-cutting for socket installations

#### Offset between Installations
- **Type**: Double
- **Default**: 68 mm
- **Description**: Center-to-center distance between multiple sockets when Quantity > 1
- **Visibility**: Hidden in the Properties Palette when Quantity < 2
- **Auto-correction**: If Quantity > 1 and this value is ≤ 0 with a valid Diameter, the script automatically sets it equal to Diameter
- **European Standard**: Typical module spacing is 71 mm for standard switch/socket combinations
- **Calculation**: Total span = (Quantity - 1) × Offset + Diameter

---

### Wirechase Category

The wire chase is a milled channel for cable routing, independent of the socket cutouts.

#### Alignment Wirechase
- **Type**: Dropdown (3×3 grid of options)
- **Default**: bottom left
- **Options** (9 total):

| Vertical | Horizontal Options |
|----------|-------------------|
| **bottom** | left, center, right |
| **both** | left, center, right |
| **top** | left, center, right |

- **Vertical Alignment**:
  - `bottom`: Wire chase extends downward from the installation
  - `both`: Wire chase extends from panel bottom to top (full height)
  - `top`: Wire chase extends upward from the installation

- **Horizontal Alignment**:
  - `left`: Chase is offset to the left of the installation center
  - `center`: Chase is centered on the installation
  - `right`: Chase is offset to the right of the installation center

- **Overshoot Interaction**: The "Overshoot" property extends the chase beyond the outermost socket

#### Depth Wirechase
- **Type**: Double
- **Default**: 27 mm
- **Description**: Milling depth of the wire chase channel into the panel face
- **Doubling Behavior**: Like socket depth, this is doubled internally for the actual CNC operation (actual depth = 2 × property value)
- **Typical Values**: 20-30 mm for standard conduit channels

#### Width
- **Type**: Double
- **Default**: 57 mm
- **Description**: Width of the wire chase channel
- **Grip Interaction**: Can be adjusted by dragging the square grips visible in the top view (plan view) when the wire chase is perpendicular to the view direction
- **Typical Values**: 50-60 mm for standard electrical conduit

#### X-Offset
- **Type**: Double
- **Default**: 0 mm
- **Description**: Horizontal offset of the wire chase relative to the installation center
- **Direction**: Measured along the panel face (X-direction of the panel coordinate system)
- **Grip Interaction**: Dragging the top-view wire chase grips updates this value
- **Use Case**: Shift the chase left or right when sockets are not centered on the desired conduit path

#### Z-Offset
- **Type**: Double
- **Default**: 20 mm
- **Description**: Depth offset of the wire chase relative to the panel surface
- **Direction**: Measured perpendicular to the panel face (inward)
- **Warning**: CNC tooling capabilities may limit the effective range of this offset (noted in property description)
- **Effect**: Positive values move the chase inward from the panel face

#### Overshoot
- **Type**: Double
- **Default**: 20 mm
- **Description**: Extension of the wire chase beyond the outermost drill or socket cutout
- **Purpose**: Ensures a smooth transition between the chase and the socket pocket
- **Calculation**: For bottom alignment, chase length = (distance from socket to panel bottom) + Overshoot
- **Typical Range**: 10-30 mm for gradual transitions

#### Side
- **Type**: Dropdown
- **Default**: unchanged
- **Options**:
  - **unchanged**: Wire chase is on the same face as the installation
  - **opposite Side**: Wire chase is mirrored to the other face of the panel
- **Use Case**: Allows sockets on one face with conduit routing on the opposite face (common in wall construction)
- **Transformation**: Uses plane mirroring about the panel mid-plane

#### Wirechase Tool Shape
- **Type**: Dropdown
- **Default**: Rectangular
- **Options**:
  - **Rectangular**: Creates a BeamCut (pocket milling with rectangular cross-section)
  - **Circular**: Creates a long Drill (bore path with circular cross-section)
- **Version**: Added in version 4.3 (HSB-18037, February 16, 2024)
- **CNC Considerations**:
  - Rectangular requires a flat end mill
  - Circular requires a drill bit and may be faster but less precise for wire capacity

---

### Display Category

Controls the visual representation in plan view, element view, and shop drawings.

#### Dimstyle
- **Type**: Dropdown (lists all dimension styles in the current drawing)
- **Default**: (system default dimstyle)
- **Description**: Dimension style used for formatting measurement text in annotations
- **Effect**: Controls text font, arrow style, and dimension formatting rules
- **Usage**: Select a dimstyle that matches your shop drawing standards

#### Text Height
- **Type**: Double
- **Default**: 40 mm
- **Description**: Height of annotation text in drawing units
- **Override Behavior**: Overrides the text size defined in the selected dimstyle
- **Typical Values**: 30-50 mm for shop drawings, 3-5 mm for architectural drawings (depending on scale)
- **Effects**:
  - Plan view label size
  - Element view label size
  - Leader line offset distances
  - Collision detection buffer zones

#### Colors
- **Type**: String (semicolon-separated color indices)
- **Default**: `-1;3;4`
- **Format**: `PlanColor;ElementIconSideColor;ElementOppositeSideColor`
- **Description**: Semicolon-separated color indices controlling display colors in different views
- **Color Index System**:
  - `-1`: ByBlock (inherits from block definition)
  - `1`: Red
  - `2`: Yellow
  - `3`: Green
  - `4`: Cyan
  - `5`: Blue
  - `6`: Magenta
  - `7`: White/Black (depends on background)
  - `8-255`: Extended ACI (AutoCAD Color Index)
- **Usage Examples**:
  - `1;2;3`: Red in plan, yellow on icon side, green on opposite side
  - `-1;-1;-1`: All views use block color
  - `150;150;150`: All views use ACI color 150

#### Format
- **Type**: Editable Dropdown / Text
- **Default**: `@(Elevation)`
- **Description**: Expression that controls the annotation text content
- **Dynamic Property Resolution**: Use `@(PropertyName)` syntax to insert property values
- **Formatting Codes**:
  - `\P`: Line break (multi-line text)
  - `@(Elevation)`: Resolves to the actual elevation value (formatted per dimstyle)
  - `@(Quantity)`: Resolves to the number of sockets
  - `@(Offset between Installations)`: Resolves to the spacing value
  - `@(Diameter)`: Resolves to the socket diameter
  - Any other `@(PropertyName)`: Resolves to the corresponding property value

- **Examples**:
  - `@(Elevation)`: Displays only the height (e.g., "350")
  - `@(Elevation)\P@(Quantity)x`: Displays height on first line, quantity on second (e.g., "350\n3x")
  - `h=@(Elevation) n=@(Quantity)`: Displays "h=350 n=2"
  - Custom text with embedded properties: `Elec Box: @(Quantity) @ @(Elevation)mm`

- **Automatic Suppression Rules**:
  - When Quantity < 2, any `@(Offset between Installations)` reference is suppressed
  - All prefix text containing a colon (`:`) is also suppressed when Quantity < 2
  - This prevents display of irrelevant spacing information for single installations

- **Dropdown List Management**:
  - Populated from the `hsbCLT-Electra.xml` settings file
  - Can be extended via "Add Entry" context menu command
  - If no entries exist, behaves as a free-text input
  - If entries exist but the current value is not in the list, the current value is appended

---

## Right-Click Context Menu

Select an hsbCLT-Electra instance and right-click to access these commands:

### Flip Side
- **Availability**: Always
- **Shortcut**: Double-click the instance
- **Function**: Mirrors the installation to the opposite face of the panel
- **Transformation**: Plane mirroring about the panel mid-plane
- **Effect**: Sockets, wire chase, and annotation are all flipped
- **Grip Handling**: Text leader grip is also mirrored
- **Trigger**: Also accessible via TslDoubleClick event

### Add Entry
- **Availability**: Always
- **Function**: Opens a dialog to enter a new format expression
- **Dialog Content**: Single-line text input for the format string
- **Validation**: New entry must not already exist in the list (case-insensitive check)
- **Persistence**: Saved to the settings dictionary object and written to XML file
- **Effect**: New entry appears in the Format dropdown and is automatically selected

### Edit Entry
- **Availability**: When the current Format value matches an existing list entry
- **Function**: Opens a dialog to modify the currently selected format expression
- **Dialog Content**: Pre-populated with the current format string
- **Validation**: Modified entry must not conflict with other entries
- **Effect**: Updates the entry in the dropdown list and settings file
- **Workflow**: Replaces the old entry, sets the new value as active, and triggers recalculation

### Remove Entry
- **Availability**: When the current Format value matches an existing list entry
- **Function**: Removes the currently selected format expression from the dropdown list
- **Behavior**:
  - If it's the last remaining entry, the entire entry list is cleared (Format field reverts to free-text input)
  - Otherwise, the Format property is set to the previous entry (or next entry if removing the first)
- **Persistence**: Removal is saved to the settings file

### Edit in Place
- **Availability**: When a wire chase exists (wire chase parameters are valid)
- **Function**: Activates special stretch grips for interactive wire chase adjustment
- **Visual Change**: Two triangular grips appear at the top and bottom of the wire chase in element view
- **Grip Behavior**:
  - Grips are colored cyan (color 4) to indicate stretch functionality
  - Grips use triangle isosceles shape (`_kGSTTriangleIso`)
  - Top grip points upward, bottom grip points downward
  - Dragging is constrained to the Y-axis (vertical direction)
  - X and Z components of grip drag are removed automatically
- **Version**: Added in version 4.7 (HSB-22525, October 2, 2024)
- **Persistence**: Edit mode state is stored in `_Map.getInt("directEdit")`
- **BeamCut Parameters**: When active, wire chase beamcut parameters are saved to `_Map.setMap("bcWireChase", mapBc)` for external tool access

### Disable Edit in Place
- **Availability**: When "Edit in Place" mode is currently active
- **Function**: Deactivates the wire chase stretch grips
- **Effect**: Returns to normal grip behavior (only text leader and top-view wire chase position grips remain)
- **Cleanup**: Removes "bcWireChase" map entry from instance map

### Tag Tools
- **Availability**: When raw beams from `Soligno-RiegelVerteilung` are detected
- **Prerequisite**: A `Soligno-RiegelVerteilung` TSL script must be attached to the panels, providing raw beam geometry
- **Function**: Checks whether the wire chase beamcut intersects with raw beam geometry
- **Tagging Logic**:
  - If the beamcut does NOT intersect with raw beams (falls in a gap): Tag the tool
  - If the intersection volume is very small (< 125 mm³): Tag the tool
  - Otherwise: No tagging
- **Tag Metadata**: Tagged beamcuts receive a `Hsb_Tag` submap with `"Tag" = "BearbeitungVerdeckterElektrokanal"`
- **Export Behavior**: Tagged tools can be handled differently during CNC export (e.g., skipped or flagged for manual review)
- **Version**: Added in version 4.4 (HSB-21889, April 23, 2024)
- **User Feedback**:
  - Success: "Tool was tagged"
  - Failure: "Es wurde kein Werkzeug getagged\nBitte Rohstäbe überprüfen" (German: "No tool was tagged\nPlease check raw beams")

### Tags bereinigen (Cleanup Tags)
- **Availability**: When tool tags exist (mapToolTags has content)
- **Function**: Removes previously assigned tool tags
- **Effect**: Resets the beamcut to its default export behavior (no special handling)
- **Cleanup**: Removes the `Hsb_Tag` submap from the wire chase beamcut
- **Persistence**: Clears `_Map.removeAt("mapToolTags", true)`

### Catalog Entries (Submenu)
- **Availability**: Always
- **Function**: Expands into a submenu listing all available catalog presets
- **Sorting**: Entries are sorted alphabetically
- **Exclusions**: `_LastInserted` and `_Default` catalog entries are excluded from the menu
- **Behavior**: Selecting an entry applies its predefined property values while preserving the current elevation
- **Workflow**:
  1. User right-clicks, hovers over "Catalog Entries"
  2. Submenu displays all catalog presets (e.g., "Socket 1x", "Socket 2x", "Wirechase")
  3. User selects an entry
  4. All properties are loaded from the catalog except Elevation
  5. Hardware components are regenerated (`_Map.setInt("AddHardware", true)`)
  6. Instance recalculates
- **Use Case**: Quickly switch an existing installation to a different configuration without reinserting

---

## Grip Points

Interactive grips for direct manipulation in the viewport:

### Text Leader Grip (PtG[0])
- **Location**: End of the text leader line in plan view
- **Shape**: Default AutoCAD grip (small square)
- **Color**: Default grip color
- **Function**: Drag to reposition the annotation label and leader line
- **Storage**: Offset from reference point is stored in `_Map.setDouble("dGripX", ...)` and `_Map.setDouble("dGripZ", ...)`
- **Constraint**: Vertical position (Y) is snapped to the reference point elevation
- **Update Trigger**: Moving this grip triggers `_kNameLastChangedProp == "_PtG0"`

### Wire Chase Position Grips (Top View)
- **Quantity**: 2 grips (left and right edges)
- **Location**: At the left and right edges of the wire chase channel
- **Visibility**: Visible in the top/plan view direction (looking down on the panel)
- **Shape**: Square (`_kGSTSquare`)
- **Color**: Red (1)
- **Function**: Drag to shift the wire chase horizontally or adjust its width
- **Behavior**:
  - Dragging constrained to the plan view plane (Z-component removed)
  - Both grips move together in the X-direction (width remains constant)
  - Updates `dWcWidth` and `dWirechaseOffsetX` properties
  - Considers alignment setting and panel side when calculating offset
- **Stretch Mode**: `setIsStretchPoint(true)`
- **Coordinate System**: Relative to ECS (`setIsRelativeToEcs(true)`)
- **Version**: Added in version 4.1 (HSB-21382, February 7, 2024)

### Wire Chase Stretch Grips (Edit in Place)
- **Quantity**: 2 grips (top and bottom of wire chase)
- **Location**: At the top and bottom endpoints of the wire chase channel
- **Visibility**: Visible in the element view direction (looking perpendicular to the panel face)
- **Activation**: Only available when "Edit in Place" mode is activated via context menu
- **Shape**: Isosceles triangle (`_kGSTTriangleIso`)
- **Color**: Cyan (4) - indicates stretch functionality
- **Orientation**:
  - Top grip points upward (VecX = +vecYE)
  - Bottom grip points downward (VecX = -vecYE)
  - Automatically corrected by `fixGripsEditInPlaceOrientation()` function
- **Function**: Drag to stretch the wire chase length
- **Drag Constraint**: Only movement along the Y-axis (vertical) is allowed; X and Z components are removed
- **Effect**: Directly modifies the wire chase beamcut length without changing properties
- **Geometry Update**: BeamCut parameters are recalculated from grip positions: `dXBcBc = abs(vecYE.dotProduct(ptGripBottom - ptGripTop))`
- **Version**: Triangle shape added in version 4.9 (HSB-22525, October 25, 2024)

---

## Settings and Configuration

### Settings File Structure

**File**: `hsbCLT-Electra.xml`

**XML Format**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Entry[]">
    <lst nm="Entry">
      <str nm="Entry" vl="@(Elevation)"/>
    </lst>
    <lst nm="Entry">
      <str nm="Entry" vl="@(Elevation)\P@(Quantity)x"/>
    </lst>
    <lst nm="Entry">
      <str nm="Entry" vl="h=@(Elevation) n=@(Quantity)"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

**Dictionary Storage**:
- **Dictionary Name**: `hsbTSL`
- **Object Name**: `hsbCLT-Electra` (or script name)
- **Persistence**: Created on first insertion, updated via context menu commands
- **Dependency Tracking**: `setDependencyOnDictObject(mo)` ensures recalculation when settings change

**Loading Sequence**:
1. Check for existing `MapObject("hsbTSL", "hsbCLT-Electra")` in drawing database
2. If exists: Load settings from dictionary
3. If not exists and on insert: Search for XML file in company path
4. If not found: Search in installation path
5. If found: Read XML and create persistent dictionary object

### Catalog System

**Catalog Entry Structure**:
- Catalog entries define presets for all properties:
  - General: Quantity, Tooling Shape, Alignment, Diameter, Depth, Offset
  - Wirechase: All wire chase parameters (alignment, depth, width, offsets, side, tool shape)
  - Display: Dimstyle, Text Height, Colors, Format

**Insertion Workflow (Catalog Mode)**:
1. User executes catalog command with entry name (e.g., "Socket 2x")
2. Script loads all properties from catalog: `setPropValuesFromCatalog(_kExecuteKey)`
3. Command line prompts for elevation override: `Elevation [350]:`
4. User can accept default or enter new value
5. Script prompts for panel/element selection
6. Script prompts for insertion point
7. Instance is created with catalog properties + user-specified elevation

**Elevation Override Logic**:
```tsl
String sInput = getString(T("|Elevation|") + " [" + dElevation + "]");
double dNewElevation = sInput.atof();
String sCheckInput = dNewElevation;
if (sInput != sCheckInput)
    dNewElevation = dElevation;  // Keep catalog value
dElevation.set(dNewElevation);
```

**Available via Context Menu**:
- All catalog entries (except `_LastInserted` and `_Default`) appear in the "Catalog Entries" submenu
- Selecting an entry applies catalog properties while preserving current elevation
- Triggers hardware regeneration

### Finished Floor Elevation Integration

**Submap Structure**:
- **Submap Name**: `FinishedFloor` (on the Sip panel)
- **Key**: `ElevationFinishedFloor`
- **Type**: Double (vertical offset in drawing units)

**Behavior**:
- If a panel has this submap, the elevation is added to the installation elevation
- Final position = `_Pt0 = ptRef + vecY * (dElevation + dFFE)`
- Changes to the finished floor elevation trigger automatic repositioning: `bFFEChanged = true`
- The finished floor value is cached in the instance map: `_Map.setDouble("ElevationFinishedFloor", dFFE)`
- When the cached value differs from the panel's current value, the instance recalculates

**Use Case**: Allows installations to be specified relative to the finished floor (e.g., "1200mm above finished floor") rather than panel bottom

---

## Hardware Components

### Automatic Generation

**Trigger Events**:
- Initial insertion: `_Map.setInt("AddHardware", true)` on insert
- Property changes: Shape, Quantity, Diameter, or Offset modifications
- Catalog entry selection

**Component Cleanup**:
- Before generating new components, all existing hardware with `repType == _kRTTsl` is removed
- This ensures only current installation-specific hardware remains
- Manually added hardware components (different repType) are preserved

### Socket Hardware Component

**Generated When**: `nQty > 0` (at least one socket)

**Properties**:
- **Name**:
  - Single socket (Quantity = 1, Shape = Drill): Shape name (e.g., "Drill")
  - Multiple or non-drill: Shape name + " x " + Quantity (e.g., "Slotted Hole x 2")
- **Article Number**: Same as Name (mandatory per HSB-7378)
- **Quantity**:
  - Single socket (Quantity = 1, Shape = Drill): Property Quantity value
  - Multiple or non-drill: 1 (quantity is incorporated into the name)
- **Dimensions**:
  - `DScaleX`: Diameter (Drill) or Total span (others) = `(nQty - 1) * dOffsetInstallation + dDiameter`
  - `DScaleY`: Diameter
  - `DScaleZ`: Depth
- **Group**: Element group name (if panel belongs to element) or first group of TSL instance
- **Category**: "Electrical" (`sCategoryOutput`)
- **Linked Entity**: The panel (Sip) that the installation is attached to
- **Representation Type**: `_kRTTsl` (indicates TSL-generated, subject to automatic cleanup)

### Wire Chase Hardware Component

**Generated When**: `nQty == 0` (wire-chase-only mode)

**Properties**:
- **Name**: "Wirechase" (translated via `T("|Wirechase|")`)
- **Article Number**: "Wirechase"
- **Quantity**: 1
- **Dimensions**:
  - `DScaleX`: Wire chase length (`dXBc`)
  - `DScaleY`: Wire chase width (`dYBc`)
  - `DScaleZ`: Wire chase depth doubled (`dZBc`)
- **Group**: Element group name or TSL instance group
- **Category**: "Electrical"
- **Linked Entity**: The panel (Sip)
- **Representation Type**: `_kRTTsl`

### Hardware Assignment to Panels

**Element-based Assignment**:
- If the installation is attached to an `ElementWall`, the hardware is linked to a specific panel within that element
- The panel is determined by searching for the first panel that has the TSL instance in its `eToolsConnected()` list
- The panel's element group name is used for the hardware group

**Panel-based Assignment**:
- If the installation is attached directly to a panel (no element), the panel is directly used as `sipLinked`
- The TSL instance's first group is used for the hardware group

**Group Name Logic**:
```tsl
Element elHW = sipLinked.element();
if (elHW.bIsValid())
    sHWGroupName = elHW.elementGroup().name();
else
{
    Group groups[] = _ThisInst.groups();
    if (groups.length() > 0)
        sHWGroupName = groups[0].name();
}
```

---

## Shop Drawing Integration

### Dimension Requests

The script publishes dimension requests (`DimRequest[]`) through its internal map for consumption by shop drawing scripts such as `sd_TslRequests`.

**Request Types**:

1. **Point Dimension Requests** (for non-rectangular shapes)
   - **Purpose**: Marks the location of each socket in element view
   - **Content**:
     - `ptLocation`: Center point of each socket
     - `AllowedView`: Panel Z-axis (element view direction)
     - `Color`: Element color
     - `Stereotype`: `"hsbCLT-ElectraDimNonrect"` (as of version 4.10)
   - **Quantity**: One request per socket (when Shape is Drill or Slotted Hole)

2. **Rectangular Socket Dimension Requests**
   - **Purpose**: Marks the diagonal corners of rectangular socket cutouts
   - **Content**:
     - Two requests per rectangular installation (bottom-left and top-right corners)
     - `ptLocation`: Corner points
     - `AllowedView`: Panel Z-axis
     - `Color`: Element color
     - `Stereotype`: `"hsbCLT-ElectraDimRect"` (as of version 4.10)
   - **Quantity**: 2 requests per rectangular installation

3. **Polyline Graphic Requests**
   - **Purpose**: Displays socket outlines, wire chase outlines, and guide lines in element view
   - **Content**:
     - `pline`: PLine geometry (circles, rectangles, mortise outlines, guide lines)
     - `DrawFilled`: 0 (outline) or `_kDrawFilled` (half-filled for element view)
     - `AllowedView`: Panel Z-axis
     - `Color`: Element color
     - `Stereotype`: `"hsbCLT-ElectraPl"` (as of version 4.10, for filled graphics)
   - **Quantity**: One request per graphic element (multiple per installation)

4. **Text Dimension Requests**
   - **Purpose**: Displays annotation text (elevation, quantity, dimensions) in element view
   - **Content**:
     - `ptLocation`: Text insertion point
     - `ptScale`: Reference point for scaling
     - `text`: Formatted text string (resolved from Format property)
     - `textHeight`: Text height property value
     - `vecX`, `vecY`: Text orientation vectors
     - `dXFlag`, `dYFlag`: Justification flags (positive or negative for alignment)
     - `dimStyle`: Dimension style name
     - `deviceMode`: `_kDevice` (screen display)
     - `AllowedView`: Panel Z-axis
     - `Color`: Element color
     - `Stereotype`: `"hsbCLT-ElectraTxt"` (as of version 4.10)
   - **Quantity**: 1-2 requests per installation (2 if multi-line display with `sTxtLine2`)

**Publication**:
```tsl
_Map.setMap("DimRequest[]", mapRequests);
```

**Consumption**:
- Shop drawing scripts (e.g., `sd_TslRequests`, `sd_CLT_Panel`) query `_Map.getMap("DimRequest[]")`
- Requests are filtered by `AllowedView` vector to match the drawing view direction
- Stereotypes (added in version 4.10) allow precise filtering and styling in shop drawing templates

### Protection Areas

**Purpose**: Prevent overlapping text labels from multiple hsbCLT-Electra instances on the same panel

**Published Data**:
```tsl
_Map.setPLine("plProtectPlan", plProtectPlan);      // Plan view protection
_Map.setPLine("plProtect", plProtect);              // General protection (socket area)
_Map.setPLine("plProtectElement", plProtectElement); // Element view text protection
```

**Interference Detection**:
- On creation, recalculation, or debug mode, the script collects all other hsbCLT-Electra instances on the same panel/element
- Protection areas are read from each instance: `map.getPLine("plProtectElement")`
- Protection polylines are unioned into a `PlaneProfile` for intersection testing
- The current instance's text label is repositioned to avoid collisions via iterative mirroring and offset transformations
- The collision-free offset is stored: `_Map.setVector3d("vecMoveElementView", vecMoveElementView)`
- Maximum 42 iterations to find a collision-free position

**Protection Area Sizing**:
- **Socket Area** (`plProtect`): Envelope of all socket graphics, expanded by 10 mm
- **Element View Text** (`plProtectElement`): Rectangle sized to fit the text, considering text height and multi-line layout
- **Plan View Text** (`plProtectPlan`): Rectangle sized to fit the plan view annotation

### Stereotypes (Version 4.10+)

**Purpose**: Enable precise filtering and styling in shop drawing templates

**Stereotype Values**:
- `hsbCLT-ElectraDimNonrect`: Point dimension requests for Drill and Slotted Hole sockets
- `hsbCLT-ElectraDimRect`: Corner dimension requests for Rectangular sockets
- `hsbCLT-ElectraPl`: Filled polyline graphics (half-filled socket outlines in element view)
- `hsbCLT-ElectraTxt`: Text annotation requests

**Usage in Shop Drawings**:
- Filter requests by stereotype to apply different symbology (e.g., filled circles for non-rectangular, empty rectangles for rectangular)
- Control visibility per stereotype (e.g., hide non-rectangular dimensions, show only rectangular)

---

## Technical Implementation Details

### Coordinate System and Side Detection

**Panel Coordinate System**:
- **vecX**: Panel width direction (horizontal)
- **vecY**: Panel height direction (vertical)
- **vecZ**: Panel thickness direction (perpendicular to face)

**Installation Side Determination**:
```tsl
Point3d ptMid = ppOutlineWall.extentInDir(vecX).ptMid();
int nSide = 1;  // Default to front face
if (vecZ.dotProduct(_Pt0 - ptMid) < 0)
    nSide *= -1;  // Switch to back face
```

**Tool Vectors**:
- `vecXE = nSide * vecX`: Element X-axis (accounts for front/back face)
- `vecYE = vecY`: Element Y-axis (always panel height direction)
- `vecZE = nSide * vecZ`: Element Z-axis (points outward from installation face)

### Automatic Snap and Constraint Logic

**Insertion Point Snap**:
1. User clicks a point near the panel
2. Script projects the point to the panel outline plane: `ptRef = ppOutlineWall.closestPointTo(_Pt0)`
3. Script snaps `_Pt0` to the same Z-coordinate (perpendicular to panel face): `_Pt0.transformBy(vecZ * vecZ.dotProduct(ptRef - _Pt0))`

**Envelope Constraint**:
- If `_Pt0` is outside the panel envelope: Move to closest point on envelope
- This prevents installations from being placed in void areas or beyond panel edges

**Elevation Synchronization**:
- Multiple property change events can trigger elevation recalculation:
  - `_kNameLastChangedProp == sElevationName`: User changed elevation property → Update `_Pt0`
  - `_kNameLastChangedProp == "_Pt0"`: User dragged grip → Update elevation property
  - Finished floor elevation change: Update `_Pt0`
  - On recalculation or debug: Validate elevation matches `_Pt0` position

### Tooling Operations

**Drill (Circular Socket)**:
```tsl
Drill dr(ptDrill + vecZE * dEps, ptDrill - vecZE * dDepth, 0.5 * dDiameter);
dr.addMeToGenBeamsIntersect(sips);
```
- **Start Point**: Slightly offset from the panel face (`dEps` prevents surface artifacts)
- **End Point**: `dDepth` inward from the panel face
- **Radius**: Half of the Diameter property
- **Direction**: Along `vecZE` (outward from installation face)
- **Target**: Applied to all intersecting panels in the `sips` array

**Slotted Hole (Mortise)**:
```tsl
double dX = dOffsetInstallation * (nQty - 1) + dDiameter;
double dY = dDiameter;
Mortise ms(ptMs, vecDistr, vecYDistr, -vecZE, dX, dY, dDepth * 2, 0, 0, 0);
ms.setEndType(_kFemaleSide);
ms.setRoundType(_kRound);
ms.addMeToGenBeamsIntersect(sips);
```
- **Length**: Total span from first to last socket
- **Width**: Diameter
- **Depth**: Doubled (actual = 2 × property value)
- **End Type**: Female side (both ends rounded)
- **Round Type**: Round (circular end caps)
- **Direction**: Along distribution vector (`vecDistr`)

**Rectangular (BeamCut)**:
```tsl
double dX = dOffsetInstallation * (nQty - 1) + dDiameter;
double dY = dDiameter;
BeamCut bc(pt, vecDistr, vecYDistr, vecZE, dX, dY, dDepth * 2, 1, 0, 0);
Map mapXtoolSocket;
mapXtoolSocket.setInt("bRectangularSocket", true);
bc.setSubMapX("ToolInfo", mapXtoolSocket);
bc.addMeToGenBeamsIntersect(sips);
```
- **Dimensions**: Same as slotted hole
- **Depth**: Doubled
- **Flag Offset**: `1, 0, 0` (centered on start edge)
- **Metadata**: `bRectangularSocket` flag added to `ToolInfo` submap (version 4.11)

**Wire Chase (Rectangular BeamCut)**:
```tsl
BeamCut bcWirechase(ptWirechase, vecYE, -vecXE, vecZE, dXBc, dYBc, dZBc, 1, 0, dZFlag);
bcWirechase.addMeToGenBeamsIntersect(sips);
```
- **Length**: Calculated from panel envelope and alignment settings
- **Width**: `dWcWidth` property
- **Depth**: Doubled internally (`dZBc = dWcDepth * 2`)
- **Direction**: Along panel height (`vecYE`)
- **Z-Offset**: If `dWirechaseOffsetZ != 0`, depth flag is set to -1 and depth is halved

**Wire Chase (Circular Drill)** (Version 4.3+):
```tsl
Drill drWirechase(ptWirechase, ptWirechase + vecYE * dXBc, 0.5 * dZBc);
drWirechase.addMeToGenBeamsIntersect(sips);
```
- **Start/End**: Endpoints of the chase channel
- **Radius**: Half of doubled wire chase depth (`0.5 * dZBc`)
- **Direction**: Along panel height (`vecYE`)

### Tool Tagging Logic (Version 4.4+)

**Prerequisites**:
- `Soligno-RiegelVerteilung` TSL attached to panels
- Raw beam geometry available: `tsl.map().getBody("bdRawReal")`
- Minimum raw beam volume: `> 125 mm³` (`pow(U(5), 3)`)

**Tagging Workflow**:
1. Script searches for `Soligno-RiegelVerteilung` instances attached to the same panels
2. Extracts `bdRawReal` body from each instance and unions them
3. Activates "Tag Tools" context menu command
4. User executes "Tag Tools"
5. Script performs intersection test:
   ```tsl
   Body bdIntersect = bdBcWirechase;
   if (!bdIntersect.intersectWith(bdRawBeams))
       bFlag = true;  // No intersection → Tag the tool
   if (bdIntersect.volume() < pow(U(5), 3))
       bFlag = true;  // Very small intersection → Tag the tool
   ```
6. If flagged, the beamcut receives a tag:
   ```tsl
   Map mapX;
   mapX.setString("Tag", "BearbeitungVerdeckterElektrokanal");
   bcWirechase.setSubMapX(_sTagKey, mapX);
   ```
7. The tag is stored in the instance map: `_Map.setMap("mapToolTags", mapToolTags)`

**Tag Persistence**:
- Tags are validated on each recalculation
- If raw beam geometry changes (panel modified, raw beams recalculated), the tag is automatically removed if the intersection becomes valid
- User can manually remove tags via "Tags bereinigen" context menu

**Export Handling**:
- Tagged beamcuts can be filtered during CNC export (e.g., by checking for `Hsb_Tag` submap with `Tag == "BearbeitungVerdeckterElektrokanal"`)
- The export script can skip these tools or flag them for manual review

### Display Modes and View Directions

**Plan View**:
- **View Direction**: `-_ZW` (looking down from above)
- **Display Object**: `dpPlan`
- **Hidden Directions**: `vecX, -vecX, vecZ, -vecZ` (hide plan view when looking from sides or element view)
- **Content**:
  - Socket center crosses
  - Socket outlines (circles, slotted holes, rectangles)
  - Text leader line from panel outline to text position
  - Text annotation at `_PtG[0]`

**Element View**:
- **View Direction**: `vecZE` or `-vecZE` (perpendicular to panel face)
- **Display Object**: `dpElement`
- **View Restrictions**: Only shown when `bShowPlan == true` (flat wall convention)
- **Content**:
  - Half-filled socket outlines (top half filled, bottom half outline)
  - Guide line from socket to text position
  - Text annotation with elevation and format expression
  - Wire chase outline

**Coordinate Transformation (Element to Plan)**:
```tsl
CoordSys cs2Plan;
cs2Plan.setToAlignCoordSys(_Pt0, vecXE, vecYE, vecZE,   // Source CS (element)
                          ptPlan, vecX * nSide, -vecZ * nSide, vecY);  // Target CS (plan)
plGraphic.transformBy(cs2Plan);  // Transform to plan view
```

---

## Workflow Examples

### Example 1: Simple Single Socket Installation

**Objective**: Install a single electrical socket at 1200mm height on a CLT wall panel

**Steps**:
1. Command: `TSLINSERT` → Select `hsbCLT-Electra`
2. Properties Dialog:
   - Quantity: 1
   - Elevation: 1200
   - Tooling Shape: Drill
   - Diameter: 70
   - Depth: 70
   - (Leave other settings at defaults)
3. Select: Click on the CLT wall panel
4. Click: Insertion point at the desired socket location
5. Result:
   - Circular drill (70mm diameter, 70mm deep)
   - Annotation shows "1200" in element view
   - No wire chase (width/depth can be 0 or very small)

### Example 2: Double Switch with Wire Chase

**Objective**: Install two switches 71mm apart at 1200mm height with a vertical wire chase to the floor

**Steps**:
1. Insert via Catalog: Select catalog entry "Socket 2x" (if available)
   - Elevation prompt: Enter `1200`
2. Or insert manually and set:
   - Quantity: 2
   - Elevation: 1200
   - Tooling Shape: Rectangular (for switches)
   - Diameter: 70
   - Depth: 50
   - Offset between Installations: 71
   - Alignment: Horizontal
3. Wire Chase settings:
   - Alignment Wirechase: bottom center
   - Depth Wirechase: 27
   - Width: 57
   - Overshoot: 20
4. Select: Click on the CLT wall panel
5. Click: Insertion point at the desired location
6. Result:
   - Two rectangular pockets (70mm × 70mm, 50mm deep) spaced 71mm apart
   - Vertical wire chase from sockets down to panel bottom
   - Annotation shows elevation and quantity

### Example 3: Flip Side for Interior/Exterior Configuration

**Objective**: Move sockets from exterior face to interior face after placement

**Steps**:
1. Install socket normally (exterior face)
2. Double-click the instance (or right-click → "Flip Side")
3. Result:
   - Sockets, wire chase, and annotation are mirrored to the opposite panel face
   - All geometry is recalculated for the new face

### Example 4: Wire-Chase-Only Installation

**Objective**: Create a vertical cable routing channel without any socket cutouts

**Steps**:
1. Insert `hsbCLT-Electra`
2. Set properties:
   - Quantity: 0 (no sockets)
   - Alignment Wirechase: both center (full height)
   - Depth Wirechase: 27
   - Width: 57
3. Select panel and insertion point
4. Result:
   - No socket cutouts
   - Full-height wire chase channel
   - Hardware component named "Wirechase"

### Example 5: Interactive Wire Chase Adjustment

**Objective**: Fine-tune wire chase length after placement using interactive grips

**Steps**:
1. Install socket with wire chase
2. Right-click instance → "Edit in Place"
3. Observe: Two triangular cyan grips appear at top and bottom of wire chase (element view)
4. Drag: Pull the bottom grip downward to extend the chase toward the floor
5. Drag: Pull the top grip upward to extend the chase toward the ceiling
6. Right-click → "Disable Edit in Place" when satisfied
7. Result: Wire chase length is adjusted without changing properties

### Example 6: Tag Tools for Hidden Conduit Channels

**Objective**: Flag wire chase channels that fall between raw beams (for special CNC handling)

**Prerequisites**: `Soligno-RiegelVerteilung` TSL attached to panels

**Steps**:
1. Install socket with wire chase
2. Right-click instance → "Tag Tools"
3. Script checks intersection with raw beams
4. Result:
   - If wire chase falls in a gap: Tool is tagged with "BearbeitungVerdeckterElektrokanal"
   - If wire chase intersects raw beams: No tag applied
   - Message confirms: "Tool was tagged" or "No tool was tagged"
5. Export: CNC export script can filter tagged tools for special handling

---

## Tips and Best Practices

### Installation Planning

1. **Use Catalog Entries for Repeated Installations**
   - Define standard socket types (single, double, triple) in the catalog
   - Catalog insertion is faster and ensures consistency
   - Elevation can still be overridden at the command line

2. **Element vs. Panel Assignment**
   - Prefer selecting the wall element over individual panels
   - Element-level assignment provides better behavior when panels are modified, split, or copied
   - The script automatically upgrades panel selection to element if a valid reference exists

3. **Finished Floor Elevation**
   - Use the panel's "FinishedFloor" submap to define the reference height
   - Allows installations to be specified relative to finished floor (more intuitive for electrical work)
   - Example: "1200mm above finished floor" instead of "1200mm above panel bottom"

### Wire Chase Configuration

4. **Wire Chase Depth and Z-Offset**
   - Be mindful of CNC tool limitations when setting Z-Offset
   - Deep offsets may require special tooling or multiple passes
   - Test on a sample panel before applying to production

5. **Alignment Combinations**
   - `both center`: Full-height vertical chase (common for main conduit runs)
   - `bottom left/right`: Downward chase with horizontal offset (for corner routing)
   - `top center`: Upward chase (for ceiling connections)

6. **Wire Chase Tool Shape**
   - `Rectangular`: More precise wire capacity, requires flat end mill
   - `Circular`: Faster machining, requires drill bit, slightly less precise for wire capacity

### Display and Annotation

7. **Format Expressions**
   - Use `@(PropertyName)` syntax for dynamic labels
   - Combine multiple properties with `\P` for multi-line text
   - Create a library of format expressions in the settings file for reuse
   - Examples:
     - Simple: `@(Elevation)` → "1200"
     - Detailed: `h=@(Elevation)\Pn=@(Quantity)` → "h=1200\nn=2"
     - Custom: `Elec: @(Quantity)x @ @(Elevation)mm` → "Elec: 2x @ 1200mm"

8. **Text Collision Avoidance**
   - The script automatically repositions labels to avoid overlaps
   - If labels are still too close, manually drag the text leader grip (`_PtG[0]`)
   - Maximum 42 automatic repositioning attempts; if still colliding, manual adjustment is required

9. **Color Coding**
   - Use the Colors property to differentiate installation types visually
   - Example: Green for standard sockets, red for special equipment
   - Plan view color is independent of element view colors

### Editing and Modification

10. **Quick Configuration Changes**
    - Use the "Catalog Entries" context menu to switch configurations without reinserting
    - Elevation is preserved when applying catalog entries
    - Hardware components are automatically regenerated

11. **Flip Side Shortcut**
    - Double-click is faster than right-click → "Flip Side"
    - All geometry (sockets, wire chase, annotation) is mirrored together

12. **Edit in Place Mode**
    - Activate for fine-tuning wire chase length without changing properties
    - Triangle grips are easier to grab than default grips
    - Constrained to vertical movement for precision

### Performance and Workflow

13. **Batch Placement**
    - Insert multiple instances sequentially using the same property settings
    - The last-used properties are retained for the next insertion
    - Use catalog entries to switch between configurations during batch placement

14. **Copy Behavior**
    - Element-assigned installations copy better than panel-assigned
    - When copying panels, element-assigned installations automatically reference the new element
    - Panel-assigned installations may require manual reassignment

15. **Recalculation Events**
    - Changing critical properties (Shape, Quantity, Diameter) triggers hardware regeneration
    - Large quantities of installations may slow down recalculation; consider using fewer instances with higher socket counts

### CNC Export Considerations

16. **Tool Tagging for Hidden Channels**
    - Use "Tag Tools" to flag wire chases that don't intersect raw beams
    - Review tagged tools before export to determine if they should be skipped or handled differently
    - Clear tags with "Tags bereinigen" if raw beam geometry changes

17. **Rectangular Socket Metadata**
    - Rectangular sockets are flagged with `bRectangularSocket` in the ToolInfo submap (version 4.11)
    - Export scripts can use this flag to apply different machining strategies

18. **Shop Drawing Stereotypes**
    - Use stereotypes (version 4.10+) to filter and style installations in shop drawings
    - Example: Show only rectangular dimensions, hide non-rectangular

---

## Version History (Summary)

| Version | Date | Key Changes |
|---------|------|-------------|
| **4.11** | May 22, 2025 | Write flag in mapX for rectangular sockets (`bRectangularSocket` in ToolInfo submap) |
| **4.10** | Apr 22, 2025 | Add stereotypes for shop drawing filtering (`hsbCLT-ElectraDim*`, `hsbCLT-ElectraPl`, `hsbCLT-ElectraTxt`) |
| **4.9** | Oct 25, 2024 | Use triangles for "Edit in Place" stretch grips (improved visual clarity) |
| **4.8** | Oct 9, 2024 | Use arrow grip shape for "Edit in Place" grips; color 4 for stretch indication |
| **4.7** | Oct 2, 2024 | Add "Edit in Place" / "Disable Edit in Place" context menu commands |
| **4.6** | May 3, 2024 | Fix when dragging grip point |
| **4.5** | May 2, 2024 | Show report notice if no tagging possible |
| **4.4** | Apr 23, 2024 | Add command to tag/untag wire chase conduit beamcuts ("Tag Tools", "Tags bereinigen") |
| **4.3** | Feb 16, 2024 | Add drill function for cable duct (circular wire chase tool shape) |
| **4.2** | Feb 8, 2024 | Fix property names to resolve formatting problems |
| **4.1** | Feb 7, 2024 | Add grip points as Grip (wire chase position grips in top view) |
| **4.0** | Apr 11, 2022 | Bugfix wire chase on beveled edges |
| **3.9** | Apr 9, 2021 | Tool references preserved when moved by base point and linked to element |
| **3.8** | Oct 26, 2020 | Resolve format issue (HSB-9190) |
| **3.7** | Sep 22, 2020 | Use translated property names |
| **3.6** | Sep 16, 2020 | Show "Offset between Installations" only if used (Quantity ≥ 2) |
| **3.5** | Aug 10, 2020 | Typo and description fixes |
| **3.4** | Jul 25, 2020 | New "Format" property and 3 context commands (Add/Edit/Remove Entry) |
| **3.3** | Jun 6, 2020 | Bugfix hardware components |
| **3.2** | Jun 3, 2020 | Elevation and assignment corrected if panel belongs to element and UCS ≠ WCS |
| **3.1** | Apr 27, 2020 | Bugfix mandatory article number (HSB-7378) |
| **3.0** | Mar 6, 2020 | Link sip to hardware, add instance to DXA export |
| **2.9** | Oct 20, 2017 | Auto-correction of invalid interdistance for multiple installations |
| **2.8** | Jul 26, 2017 | Bugfix tolerances |
| **2.7** | Jun 10, 2016 | Slotted hole tool corrected |
| **2.6** | May 23, 2016 | Hardware assignment changed, properties categorized |
| **2.5** | Jan 12, 2016 | Insertion via catalog entry supports elevation override in command line |
| **2.4** | Jan 12, 2016 | Bugfix and display enhancements for Quantity ≤ 0 (wire-chase-only mode) |
| **2.3** | Jun 3, 2015 | Behavior on copy and split enhanced, bugfix on panel deletion if element relation is set |
| **2.2** | May 11, 2015 | Automatic change to element assignment if selected panel has valid reference |
| **2.1** | Apr 24, 2015 | Automatic element assignment if selected panel has valid reference (enhances copy behavior) |
| **2.0** | Feb 19, 2015 | Supports finished floor elevation if defined in submap |
| **1.9** | Feb 9, 2015 | Assignment only to relevant panel's element fixed |
| **1.8** | Jan 30, 2015 | Rectangular shapes publish extreme dimensions for shop drawings, plan text alignment fixed |
| **1.7** | Jan 30, 2015 | New point dimension requests added for shop drawing framework (`sd_TslRequests`) |
| **1.6** | Jan 29, 2015 | Text in element view supports automatic interference test (collision avoidance) |
| **1.5** | Jan 27, 2015 | Supports BauBit export |
| **1.3** | Dec 2, 2014 | Element view text reorganized: Quantities > 1 show interdistance format |
| **1.2** | Dec 2, 2014 | Symbols and text of element view published as TSL-based dimension requests |
| **1.1** | Dec 1, 2014 | Initial hardware configuration corrected |
| **1.0** | Dec 1, 2014 | Initial release |

---

## Related Scripts and Integration

### Parent-Child Relationships

**This script is typically used standalone**, but integrates with:

- **Soligno-RiegelVerteilung**: Provides raw beam geometry for tool tagging functionality
- **sd_TslRequests**: Consumes dimension requests for shop drawing generation
- **sd_CLT_Panel**: May consume dimension requests for CLT panel fabrication drawings

### Common Workflow Scripts

- **hsbCLT-Drill**: Similar drilling functionality for other CLT machining operations
- **hsbCLT-Opening**: Creates larger openings (doors, windows) in CLT panels
- **hsbCLT-Slot**: Creates slots for other purposes (structural connections, etc.)
- **HSB_E-Electrical**: Alternative electrical installation script for stick-frame elements

### Export and BOM Scripts

- **hsbBOM**: Generates bill of materials including hardware components from hsbCLT-Electra
- **bauBIT-Exporter**: Exports installation data to bauBIT production system (supported since version 1.5)
- **hsbDXA**: DXA export for CNC machines (supported via #DxaOut 1)

---

## Troubleshooting

### Problem: Elevation not updating when changing property

**Cause**: Finished floor elevation in panel submap may be interfering

**Solution**:
1. Check if the panel has a "FinishedFloor" submap
2. If yes, the actual position = Elevation property + Finished floor value
3. Update the Elevation property to account for the finished floor offset

### Problem: Wire chase not visible

**Cause**: Wire chase parameters may be invalid or too small

**Solution**:
1. Check Depth Wirechase and Width properties (must be > 0)
2. Check Alignment Wirechase setting (ensure it's pointing in the desired direction)
3. Check panel envelope (wire chase is clipped to panel boundaries)
4. Verify that at least one socket exists OR Quantity is set to 0 (wire-chase-only mode)

### Problem: Text labels overlapping

**Cause**: Automatic collision avoidance may have failed (>42 iterations)

**Solution**:
1. Manually drag the text leader grip (`_PtG[0]`) to reposition the label
2. Reduce text height if labels are too large
3. Check that other hsbCLT-Electra instances are valid (invalid instances may not publish protection areas)

### Problem: Tools not appearing on CNC export

**Cause**: Tools may be tagged as hidden or not properly assigned to panels

**Solution**:
1. Check if "Tag Tools" was executed (tagged tools may be filtered in export)
2. Use "Tags bereinigen" to clear tags
3. Verify that the installation is assigned to a valid panel or element
4. Check that the panel is included in the export selection set

### Problem: Catalog insertion not working

**Cause**: Catalog entry name may not match expected format

**Solution**:
1. Verify that the catalog entry name is spelled correctly
2. Check that the catalog entry is defined for the `hsbCLT-Electra` script
3. Exclude `_LastInserted` and `_Default` entries (these are system entries)

### Problem: Hardware components not generated

**Cause**: AddHardware flag may not be set

**Solution**:
1. Change a critical property (Shape, Quantity, Diameter, or Offset) to trigger regeneration
2. Select a catalog entry from the context menu (forces hardware regeneration)
3. Check that the panel has a valid group assignment

### Problem: "Edit in Place" grips not visible

**Cause**: Edit mode may not be activated, or wire chase may be invalid

**Solution**:
1. Right-click instance → "Edit in Place" to activate
2. Ensure wire chase parameters are valid (Depth > 0, Width > 0)
3. Check that the view direction is perpendicular to the panel face (element view)

---

## Command Reference

### Insertion Commands

```
Command: TSLINSERT
Select: hsbCLT-Electra
```

```
(hsb_ScriptInsert "hsbCLT-Electra")
```

### Context Menu Commands (via Command Line)

```
(hsb_RecalcTslWithKey (T "../|Add Entry|") (T "|Select installation|"))
```

```
(hsb_RecalcTslWithKey (T "../|Edit Entry|") (T "|Select installation|"))
```

```
(hsb_RecalcTslWithKey (T "../|Remove Entry|") (T "|Select installation|"))
```

```
(hsb_RecalcTslWithKey (T "|Flip Side|") (T "|Select installation|"))
```

---

## Conclusion

**hsbCLT-Electra** is a comprehensive solution for electrical installations in CLT construction, offering:

- **Flexibility**: Three socket types, nine wire chase alignments, wire-chase-only mode
- **Automation**: Automatic hardware generation, shop drawing integration, collision avoidance
- **Precision**: Interactive grips, "Edit in Place" mode, automatic snap and constraint
- **Integration**: Catalog support, settings persistence, tool tagging for hidden conduits
- **Quality**: Stereotyped dimension requests, protection areas, finished floor elevation support

For advanced usage, consult the version history for feature availability and the related scripts section for workflow integration.
