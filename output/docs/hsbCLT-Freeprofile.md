# hsbCLT-Freeprofile

**Version:** 2.5 (Released: February 27, 2023)
**Category:** CLT (Cross-Laminated Timber) Tools
**Environment:** Model Space
**Type:** Object Script (O-Type)

---

## Overview

The **hsbCLT-Freeprofile** script creates custom CNC milling paths on CLT panels based on user-defined polylines. This tool bridges the gap between design intent and manufacturing, allowing you to define complex cutting operations (grooves, pockets, profile cuts) that extend beyond standard geometric tools like drills or slots.

Unlike simple geometric operations, this tool converts any 2D polyline—whether curved, angular, or irregular—into a production-ready CNC toolpath. It's essential for creating custom joinery, aesthetic features, service routing, or any non-standard milling operation on CLT panels.

### Key Capabilities

- **Freeform Milling Paths**: Convert any polyline into a CNC milling operation
- **Multiple Tool Modes**: From simple path following to complete area removal
- **Flexible Tool Specification**: Configure custom milling heads with diameter, length, and index
- **Multi-Panel Support**: Apply a single polyline to multiple intersecting panels
- **Smart Path Optimization**: Automatic corner cleanup, arc approximation, and overshoot correction
- **Hybrid Operations**: Combine freeprofile paths with beamcut replacements for efficiency

---

## When to Use This Tool

### Typical Use Cases

1. **Custom Joinery**: Create non-standard tongue-and-groove connections, lap joints, or decorative interlocking profiles
2. **Service Routing**: Mill channels for electrical conduit, plumbing, or HVAC ducts following irregular paths
3. **Aesthetic Features**: Cut decorative grooves, reveal patterns, or branding elements
4. **Drainage Channels**: Create water runoff paths on roof or wall panels
5. **Stiffener Pockets**: Mill recesses for metal plates or timber stiffeners with complex outlines
6. **Access Openings**: Cut irregular-shaped access panels or inspection hatches
7. **Assembly Aids**: Create alignment grooves or positioning channels for complex assemblies

### When NOT to Use This Tool

- **Standard Drills**: Use `hsbCLT-Drill` for simple round holes
- **Rectangular Slots**: Use `hsbCLT-Slot` for standard rectangular mortises
- **Dovetails**: Use `hsbCLT-Dovetail` for standardized dovetail connections
- **Straight Beamcuts**: For simple straight cuts, standard beamcut tools are more efficient

---

## Installation & Setup

### Initial Setup Steps

1. **Select Panels and Polylines**: During insertion, you must select at least one panel and one polyline
2. **Polyline Requirements**:
   - Must be drawn in the same drawing space as the panels
   - Can be open or closed
   - Can contain arcs and line segments
   - Must intersect or shadow the target panels
3. **Panel Requirements**:
   - Must be CLT panels (Sip entities)
   - Panel face normal cannot be perpendicular to polyline plane

### Tool Configuration

The script supports **two methods** for defining CNC tools:

#### Method 1: XML Settings File (Recommended for Production)

Create an XML file at: `{Company Path}\TSL\Settings\hsbCLT-Freeprofile.xml`

**Example XML Structure:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Tool[]">
    <lst nm="Tool">
      <str nm="Name" vl="Finger Mill 20"/>
      <dbl nm="Diameter" ut="L" vl="20"/>
      <dbl nm="Length" ut="L" vl="150"/>
      <int nm="ToolIndex" vl="0"/>
      <dbl nm="Accuracy" ut="L" vl="0.1"/>
    </lst>
    <lst nm="Tool">
      <str nm="Name" vl="Universal Mill 30"/>
      <dbl nm="Diameter" ut="L" vl="30"/>
      <dbl nm="Length" ut="L" vl="200"/>
      <int nm="ToolIndex" vl="1"/>
      <dbl nm="Accuracy" ut="L" vl="0.1"/>
    </lst>
  </lst>
  <lst nm="Display">
    <int nm="Color" vl="6"/>
    <int nm="ColorRef" vl="3"/>
    <int nm="Transparency" vl="50"/>
    <str nm="DimStyle" vl="ISO-25"/>
    <dbl nm="TextHeight" ut="L" vl="3.5"/>
  </lst>
  <lst nm="Extrusion">
    <int nm="Color" vl="7"/>
    <int nm="ColorRef" vl="5"/>
    <int nm="Transparency" vl="40"/>
  </lst>
  <lst nm="Contour">
    <int nm="Color" vl="8"/>
    <int nm="ColorRef" vl="4"/>
    <int nm="Transparency" vl="30"/>
  </lst>
  <lst nm="ToolMode[]">
    <lst nm="Mode4">
      <dbl nm="MinLengthStraight" ut="L" vl="500"/>
      <dbl nm="Overlap" ut="L" vl="100"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

**XML Parameter Reference:**

| Parameter | Type | Unit | Description | Default |
|-----------|------|------|-------------|---------|
| **Name** | String | - | Display name for the tool | Required |
| **Diameter** | Double | Length | Milling head diameter | Required |
| **Length** | Double | Length | Tool cutting length (0 = through panel) | Required |
| **ToolIndex** | Integer | - | CNC machine tool index (0-based) | Required |
| **Accuracy** | Double | Length | Arc-to-line approximation tolerance | 0.1 mm |
| **MinLengthStraight** | Double | Length | Minimum length for beamcut replacement (Mode 4 only) | 500 mm |
| **Overlap** | Double | Length | Overlap distance for path-beamcut transition (Mode 4 only) | 100 mm |

#### Method 2: OPM Catalog Entries

Use hsbCAD's Object Property Manager (OPM) catalog system to define tools:

1. Right-click the script in Model Space
2. Select **"Specify Tool"** from the context menu
3. Enter tool properties in the dialog
4. Save as a catalog entry for reuse

**Catalog Entry Fields:**

- **Toolname**: Descriptive name (e.g., "Finger Mill Ø20")
- **Diameter**: Tool diameter in current drawing units
- **Length**: Tool length (0 = full panel depth)
- **Toolindex**: Machine tool index number

**Note**: XML settings take precedence over OPM catalogs. If both exist, XML settings are used.

---

## User Interface

### Object Properties (OPM)

When you select an inserted freeprofile instance, the AutoCAD Properties Palette displays:

#### Alignment Category

| Property | Options | Description | Default |
|----------|---------|-------------|---------|
| **Side** | Reference Side / Opposite Side | Which panel face to mill from | Reference Side |
| **Alignment** | Left / Center / Right | Tool path alignment relative to polyline direction | Center |
| **Mode** | See below | Milling operation type | Polyline Path |

**Tool Modes Explained:**

1. **Polyline Path**: Tool follows the polyline centerline exactly
   - Best for: Grooves, channels, alignment marks
   - Path width = Tool diameter (or Width property if set)

2. **Extrusion Body**: Removes entire area inside closed polyline with rounded corners
   - Best for: Pockets, recesses, large openings
   - Automatically rounds internal corners to tool radius

3. **Extrusion Body (Corner Cleanup)**: Same as Extrusion Body plus sharp corner processing
   - Best for: Rectangular pockets requiring true 90° corners
   - Adds cleanup passes at corners less than 90°

4. **Polyline Extrusion Body**: Removes area without modifying polyline shape
   - Best for: When polyline already matches exact milling head profile
   - **Warning**: You must ensure polyline matches your tool geometry

5. **Polyline Path Tool Combination**: Hybrid mode combining paths and beamcuts
   - Best for: Long channels with straight sections
   - Straight segments longer than threshold become beamcuts
   - Curved/short segments remain freeprofile paths

#### Tool Category

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| **Tool** | Dropdown | Select from configured CNC tools | First available tool |
| **Depth** | Length | Milling depth (0 = through panel) | 20 mm |
| **Width** | Length | Path width for polyline modes (0 = use diameter) | 30 mm |

**Depth Behavior:**
- `Depth = 0`: Mills completely through the panel
- `Depth > 0`: Mills to specified depth from selected face
- Measured perpendicular to panel surface

**Width vs. Diameter:**
- When `Width = 0`: Uses tool diameter
- When `Width > Diameter`: In polyline path modes, creates wider path by offsetting
- When `Width > Diameter` in extrusion modes: Width is ignored, uses diameter
- When `Width < Diameter`: Script automatically corrects to diameter (with warning)

#### Display Category

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| **Format** | String | Label format string (see below) | R@(Radius) |

**Format String Variables:**

You can create custom labels using variable placeholders. Available variables:

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(Radius)` | Tool radius | R10 |
| `@(Diameter)` | Tool diameter | Ø20 |
| `@(Length)` | Path length | L1250.5 |
| `@(Area)` | Milled area (extrusion modes) | A15000 |
| `@(Depth)` | Milling depth | D30 |
| `@(Width)` | Path width | W40 |

**Format Examples:**

```
R@(Radius)          →  R15
Ø@(Diameter) D@(Depth)  →  Ø30 D20
@(Length)mm          →  1450.5mm
Area: @(Area)        →  Area: 25000
```

Use `\P` for multi-line labels:
```
Ø@(Diameter)\PD@(Depth)  →  Ø30
                             D20
```

### Context Menu Commands

Right-click an inserted freeprofile to access additional commands:

#### Add/Remove Panel

**Purpose**: Modify which panels the freeprofile affects

**Workflow:**
1. Right-click freeprofile → Select "Add/Remove Panel"
2. Select additional panels to add OR panels already linked to remove
3. Selection toggles: clicking a linked panel removes it, clicking a new panel adds it
4. Press Enter to complete

**Use Case**: When panel layout changes or you need to extend a groove across newly added panels

#### Flip Side

**Purpose**: Quickly switch milling face (Reference ↔ Opposite)

**Workflow:**
1. Right-click freeprofile → Select "Flip Side"
2. Tool operation instantly moves to the opposite panel face

**Use Case**: When you realize the groove should be on the interior rather than exterior face

**Shortcut**: Double-click the freeprofile entity (same as Flip Side)

#### Add Ecs

**Purpose**: Attach an ECS marker to control polyline orientation dynamically

**Workflow:**
1. Right-click freeprofile → Select "Add Ecs"
2. An ECS marker is created at the polyline start point
3. Moving/rotating the ECS marker transforms the polyline accordingly
4. Useful for parametric adjustments

**Use Case**: When you need to adjust the path angle or position parametrically through an external coordinate system

#### Add/Remove Format

**Purpose**: Interactively build the label format string

**Workflow:**
1. Right-click freeprofile → Select "Add/Remove Format"
2. Console displays numbered list of all available properties with current values
3. Enter the number corresponding to the property you want to add/remove
4. Selected properties are toggled in the format string
5. Enter -1 to exit

**Example Console Output:**
```
Select a property by index to add or to remove, -1 = Exit
    1   ✓   Radius........: 15
    2       Diameter......: 30
    3       Length........: 1450.5
    4   ✓   Area..........: 12500
    5       Depth.........: 20
```

Properties with ✓ are currently in the format string.

#### Specify Tool (OPM Catalog Mode Only)

**Purpose**: Define new tool specifications when using OPM catalog method

**Workflow:**
1. Right-click freeprofile → Select "Specify Tool"
2. Enter tool properties in the dialog
3. Save as new catalog entry

**Note**: This command only appears when XML settings are NOT configured.

#### Configure Display

**Purpose**: Customize visualization colors, transparency, and text styles

**Workflow:**
1. Right-click freeprofile → Select "Configure Display"
2. Dialog shows three display contexts:
   - **Display**: General visualization settings
   - **Extrusion**: Settings for extrusion body modes (1, 2, 3)
   - **Contour**: Settings for polyline path modes (0, 4)
3. Adjust settings per context
4. Settings are saved to XML and apply to all freeprofiles

**Configurable Parameters:**

| Parameter | Description | Default |
|-----------|-------------|---------|
| Color | Line/fill color index | 7 (White) |
| Color Reference Side | Color when on reference face | 6 (Magenta) |
| Transparency | Fill transparency (0-100) | 50% |
| DimStyle | Text style for labels | Drawing default |
| TextHeight | Label text height | Auto |

#### Configure Tool

**Purpose**: Edit tool specifications for the currently selected tool

**Workflow:**
1. Right-click freeprofile → Select "Configure Tool"
2. Modify tool parameters:
   - Diameter
   - Length
   - ToolIndex
   - Name
   - Accuracy (arc approximation tolerance)
3. Changes save to XML settings file

**Use Case**: When you need to adjust tool parameters after discovering machine limitations

#### Edit Toolmode (Mode 4 Only)

**Purpose**: Configure thresholds for Polyline Path Tool Combination mode

**Workflow:**
1. Right-click freeprofile in Mode 4 → Select "Edit Toolmode"
2. Adjust parameters:
   - **Min. Length**: Minimum straight segment length to convert to beamcut (default: 500mm)
   - **Overlap**: Overlap distance where freeprofile extends into beamcut area (default: 100mm)
3. Settings save to XML

**Validation Rules:**
- Min. Length must be > 0
- Overlap must be < Min. Length

#### Import Settings / Export Settings

**Purpose**: Share tool configurations between projects or backup settings

**Import Workflow:**
1. Right-click freeprofile → Select "Import Settings"
2. Imports from: `{Company Path}\TSL\Settings\hsbCLT-Freeprofile.xml`
3. All current settings are replaced with imported XML

**Export Workflow:**
1. Right-click freeprofile → Select "Export Settings"
2. If file exists, confirms overwrite
3. Saves current MapObject settings to XML file

**Use Case**: Standardizing tool libraries across multiple workstations or projects

---

## Workflow Guide

### Basic Workflow: Creating a Simple Groove

**Scenario**: Mill a 20mm deep drainage channel following a curved path on a wall panel

**Steps:**

1. **Draw the Path Polyline**
   - In AutoCAD, draw a polyline representing the desired groove centerline
   - Use arc segments for curves, line segments for straight sections
   - Polyline can be open (start/end points differ) or closed

2. **Insert the Script**
   - Command: Type script insertion command or use toolbar
   - Prompt: "Select panels and polylines"
   - Select: Click the wall panel(s)
   - Select: Click the polyline
   - Press Enter

3. **Configure in Dialog** (if dialog appears)
   - Tool: Select appropriate milling head (e.g., "Finger Mill Ø20")
   - Mode: "Polyline Path"
   - Side: "Reference Side" (exterior) or "Opposite Side" (interior)
   - Click OK

4. **Adjust Properties** (in OPM)
   - Depth: 20 mm
   - Width: 0 (uses tool diameter)
   - Alignment: Center

5. **Verify Visualization**
   - The groove path appears on the panel with transparency
   - Label shows tool radius or configured format
   - Check that path is on correct face

**Result**: A CNC-ready freeprofile tool is created, linked to the panel and polyline.

---

### Advanced Workflow: Pocket with Corner Cleanup

**Scenario**: Mill a rectangular pocket for a steel plate connection, requiring sharp 90° corners

**Steps:**

1. **Draw Pocket Outline**
   - Draw a closed rectangular polyline at the pocket location
   - Ensure polyline is planar and intersects the panel

2. **Insert Freeprofile**
   - Select panel and pocket polyline
   - In dialog, choose a tool with diameter smaller than the smallest corner radius needed

3. **Configure for Corner Cleanup**
   - Mode: "Extrusion Body (Corner Cleanup)"
   - Tool: Universal mill with appropriate diameter
   - Side: Select the panel face

4. **Set Depth**
   - Depth: Plate thickness + clearance (e.g., 12mm plate → 15mm depth)

5. **Verify Corner Treatment**
   - Zoom to corners in model space
   - Script automatically adds circular cleanup passes at corners < 90°
   - For corners ≥ 90°, standard filleting applies

6. **Check Visualization**
   - Pocket area shows with fill transparency
   - Corner cleanup circles visible at sharp angles
   - Label displays area and depth

**Technical Note**: Corner cleanup mode analyzes each vertex:
- Convex arcs: Adds fillet transitions
- Concave arcs: Maintains original geometry
- Straight-to-straight corners < 90°: Adds three-point arc cleanup with tool radius
- Straight-to-straight corners ≥ 90°: Adds two-point arc cleanup

---

### Advanced Workflow: Hybrid Path + Beamcut

**Scenario**: Create a long service channel with straight sections and curved corners

**Steps:**

1. **Draw Complete Path**
   - Draw polyline combining long straight segments with curved transitions
   - Example: 2000mm straight → 500mm radius curve → 3000mm straight → curve → 1500mm straight

2. **Insert Freeprofile**
   - Select panel and polyline
   - Choose tool (e.g., "Universal Mill Ø30")

3. **Configure for Hybrid Mode**
   - Mode: "Polyline Path Tool Combination"
   - This mode will analyze segments automatically

4. **Tune Thresholds** (via "Edit Toolmode")
   - Min. Length: 500mm (segments longer than this become beamcuts)
   - Overlap: 100mm (freeprofile extends into beamcut area)

5. **Verify Segment Analysis**
   - Script automatically classifies segments:
     - Arc segments → Freeprofile
     - Straight segments < 500mm → Freeprofile
     - Straight segments ≥ 500mm → Beamcut
   - Visualization shows different colors for each type

6. **Check Production Output**
   - Long straight sections appear as standard beamcuts (faster machining)
   - Curved sections remain as freeprofile paths
   - Overlaps ensure continuous material removal

**Benefits of Hybrid Mode:**
- Reduces CNC milling time (beamcuts are faster than freeprofile)
- Maintains accuracy in curved sections
- Optimizes tool usage

---

### Multi-Panel Workflow

**Scenario**: Create a continuous alignment groove across three adjacent wall panels

**Steps:**

1. **Draw Continuous Polyline**
   - Draw a single polyline that crosses all three panel locations
   - Polyline must intersect or shadow all target panels

2. **Insert Freeprofile**
   - When prompted, select all three panels
   - Select the single polyline
   - Press Enter

3. **Script Auto-Detection**
   - Script automatically determines which panels the polyline intersects
   - Creates individual freeprofile instances per panel
   - Each instance is linked to its panel and the shared polyline

4. **Linked Behavior**
   - If you edit the polyline (e.g., move a vertex), all freeprofiles update
   - If you delete one freeprofile, others remain independent
   - Panel-specific properties (Side, Depth) can differ per instance

5. **Adding Panels Later**
   - If you add a fourth panel in the polyline path:
     - Right-click any existing freeprofile
     - Select "Add/Remove Panel"
     - Click the new panel
     - Press Enter
   - A new freeprofile instance is created for the fourth panel

**Best Practice**: For multi-panel operations, use consistent tool and mode settings across all instances to ensure continuous machining.

---

## Technical Details

### Polyline Processing Logic

#### Path Validation

The script performs extensive validation before creating the tool:

1. **Polyline-Panel Intersection Check**
   - Projects polyline onto panel plane
   - Tests if path intersects panel envelope (boundary)
   - Accounts for panel openings (windows, doors)
   - Calculates actual path length within panel boundaries

2. **Minimum Path Length**
   - Validates that at least some portion of the polyline intersects the panel
   - If no intersection: Script erases itself with error message
   - Prevents creation of "empty" freeprofiles

3. **Normal Vector Alignment**
   - Polyline normal must not be perpendicular to panel face normal
   - If perpendicular: Panel is excluded from selection
   - Ensures tool can physically access the milling path

#### Path Transformation

The script transforms the input polyline through several stages:

**Stage 1: Projection**
- Polyline is projected onto a plane perpendicular to the tool normal
- Ensures path is properly oriented for CNC machining

**Stage 2: Alignment (Polyline Path Modes)**

When Mode = "Polyline Path" or "Polyline Path Tool Combination":

- **Left Alignment**: Offsets polyline by -0.5 × Width to the left (in path direction)
- **Center Alignment**: No offset, tool follows polyline centerline
- **Right Alignment**: Offsets polyline by +0.5 × Width to the right

When `Width > Diameter`:
- Additional offsetting creates a wider milled path
- Script converts to extrusion body mode internally for accurate area calculation

**Stage 3: Filleting (Extrusion Body Mode)**

When Mode = "Extrusion Body":

1. Offset inward by -0.5 × Diameter
2. Check if resulting area increased (indicates self-intersection)
3. If increased: Reverse offset direction and retry
4. Offset outward by Diameter to smooth corners
5. Offset inward by -0.5 × Diameter to achieve final size

**Result**: Smooth, machinable corners with radius equal to tool radius.

**Stage 4: Corner Cleanup (Corner Cleanup Mode)**

When Mode = "Extrusion Body (Corner Cleanup)":

For each vertex in the polyline:

1. **Analyze adjacent segments**:
   - Determine if segments are arcs or straight lines
   - Calculate if arcs are convex or concave

2. **Corner classification**:
   - **Convex arc**: Add smooth fillet transition
   - **Concave arc**: Keep original geometry
   - **Straight-to-straight, angle < 90°**: Three-point cleanup arc
   - **Straight-to-straight, angle ≥ 90°**: Two-point fillet arc

3. **Cleanup arc calculation** (for sharp corners):
   - Calculate bisector vector of corner angle
   - Find center point for cleanup circle (radius = tool radius)
   - Generate arc from approach tangent to exit tangent
   - Extend adjacent segments to meet cleanup arc

**Result**: Pockets with true sharp corners (within tool radius limits).

#### Arc Approximation

For CNC output, arcs may be converted to line segments:

- **Tolerance**: Controlled by `Accuracy` parameter (default: 0.1mm)
- **When Applied**:
  - `Accuracy > 0`: Arcs are approximated
  - `Accuracy = 0`: Arcs preserved (if CNC supports arc commands)
- **Method**: Chordal deviation algorithm
  - Maximum perpendicular distance from arc to line segment ≤ Accuracy

**Best Practice**: Use `Accuracy = 0.1mm` for most CNC machines. Increase to 0.5mm for faster processing on less critical features.

#### Open vs. Closed Polylines

**Open Polylines** (start ≠ end):

- Used for grooves, channels, edge details
- Tool follows path from start to end
- In Polyline Path modes: Creates path with width
- In Extrusion modes: **Not allowed** (script forces mode change with warning)

**Special Handling - Overshoot Correction**:

When an open polyline has `Length > Diameter` in Polyline Path mode:

1. **Start Point**: If inside panel, trim path by 0.5 × Diameter, add hemispherical cap
2. **End Point**: If inside panel, trim path by 0.5 × Diameter, add hemispherical cap
3. **Result**: Clean rounded ends instead of overshoot marks

**Closed Polylines** (start = end):

- Used for pockets, openings, enclosed features
- Tool follows complete loop
- Alignment forced to "Center" (Left/Right ignored)
- All modes supported

---

## Troubleshooting

### Common Issues & Solutions

#### Issue: "Tool will be deleted" error on insertion

**Possible Causes**:

1. **Polyline does not intersect panel**
   - **Check**: View polyline and panel in 3D
   - **Solution**: Move polyline to intersect panel, or select correct panel

2. **Duplicate polyline-panel link**
   - **Check**: Select panel, look for existing freeprofiles using same polyline
   - **Solution**: Delete old freeprofile, or use "Add/Remove Panel" to modify existing one

3. **Polyline perpendicular to panel face**
   - **Check**: Verify polyline plane orientation
   - **Solution**: Rotate polyline to be non-perpendicular, or select different panel face

4. **No valid tool definition found**
   - **Check**: Verify XML settings file exists and contains valid tools
   - **Solution**: Create settings file or define tools via OPM catalog

**Diagnostic Steps**:
```
1. Draw a simple test polyline (straight line, 1000mm long)
2. Ensure polyline clearly crosses panel center
3. Try inserting freeprofile
4. If successful: Original polyline geometry is the issue
5. If failed: Tool configuration or panel compatibility is the issue
```

---

#### Issue: Width automatically changes to Diameter

**Cause**: Width property set to less than tool diameter

**Explanation**:
- For polyline path modes, milled width cannot be narrower than the physical tool
- Script validates: `Width >= Diameter` OR `Width = 0`

**Solution**:
1. **Accept auto-correction**: Allow Width to equal Diameter
2. **Use smaller tool**: Select a tool with diameter ≤ desired width
3. **Set Width = 0**: Let script use tool diameter automatically

**Example**:
```
Desired width: 15mm
Current tool: Universal Mill Ø30
Problem: 15mm < 30mm (invalid)

Solutions:
A) Accept Width = 30mm (auto-corrected)
B) Switch to tool with Ø15 or smaller
C) Set Width = 0, accept 30mm result
```

---

#### Issue: Mode changes unexpectedly

**Scenario 1: Extrusion mode forced to Polyline Path**

**Cause**: Open polyline with `abs(Width - Diameter) < tolerance`

**Explanation**:
- Extrusion modes require closed polylines
- When Width ≈ Diameter on an open polyline, no area to extrude

**Solution**:
- Close the polyline: Connect start and end points
- OR: Set `Width > Diameter` to force extrusion-style operation
- OR: Accept Polyline Path mode

**Scenario 2: Polyline Path converts to Extrusion Body**

**Cause**: `Width > Diameter` on a path, triggers internal conversion

**Explanation**:
- To achieve width greater than tool diameter, script generates an area fill
- Internally treated as extrusion body for accurate geometry

**Solution**:
- This is intentional behavior, no action needed
- Result is correct machining geometry

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| **2.5** | Feb 27, 2023 | Invalid extrusion definitions convert to path mode (HSB-16803) |
| **2.4** | Oct 20, 2021 | Custom commands for properties, arc approximation accuracy setting (HSB-13565) |
| **2.3** | Jun 30, 2021 | Alignment fix when width > tool diameter (HSB-12442) |
| **2.2** | Jun 25, 2021 | Tooling fallback for cutting body failures (HSB-12409) |
| **2.1** | Jun 16, 2021 | Mode 4 added (Polyline Path Tool Combination), custom commands for settings (HSB-12246) |
| **2.0** | Jun 7, 2021 | Mode 3 added (Polyline Extrusion Body - no modification) (HSB-12143) |
| **1.9** | Oct 20, 2020 | Tolerance parameter added (HSB-9663) |
| **1.8** | Oct 20, 2020 | Internal naming bugfix (HSB-9338) |
| **1.7** | Jul 15, 2020 | Width correction when > diameter in circumference mode (HSB-7281) |
| **1.6** | May 7, 2020 | Performance improvement via segmentation, arc support in shop drawings (HSB-7491) |
| **1.5** | Apr 21, 2020 | Bugfix for beveled tools (HSB-7281) |
| **1.4** | Apr 15, 2020 | Overshoot correction on open contours (HSB-7266) |
| **1.3** | Apr 1, 2020 | Mode 2 added (Extrusion with cleanup), offset failure handling (HSB-7178) |
| **1.2** | Mar 9, 2020 | Bugfix for polylines on contour insertion (HSB-6916) |
| **1.1** | Mar 9, 2020 | Typo corrections (HSB-6700) |
| **1.0** | Feb 17, 2020 | Initial release |

---

## Support & Contact

**Important Note**: Machine specifications must be synchronized with hsbCAD parameters. Consult your CNC machine documentation and hsbCAD technical support to ensure ToolIndex, Diameter, and Length values match your production environment.

For technical support with hsbCLT-Freeprofile, contact hsbCAD support with:
- Script version number (check OPM or command line during insertion)
- Error messages (copy exact text from AutoCAD command line)
- Sample DWG file demonstrating the issue
- XML settings file (if using XML configuration method)

---

**End of Documentation**
