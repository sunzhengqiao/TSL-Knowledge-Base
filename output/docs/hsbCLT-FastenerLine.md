# hsbCLT-FastenerLine

## Overview

**hsbCLT-FastenerLine** is an intelligent tool for defining and distributing fastener lines along panel-to-panel connections in CLT (Cross-Laminated Timber) and panel construction. This tool automatically detects connection zones between panels and creates parametric fastener distributions with customizable spacing, quantity, and hardware specifications.

**Version:** 1.9 (September 2024)
**Type:** Object Tool (O-Type)
**Environment:** Model Space
**Application:** CLT panels, SIP panels, wall-floor connections, wall-wall connections

---

## What It Does

This tool creates **fastener distribution lines** at connection zones between panels. Instead of manually placing individual fasteners, you:

1. Select connecting panels or define polyline paths
2. Choose a connection detail with predefined fastener rules
3. The tool automatically calculates connection zones and distributes fasteners according to your specifications

The tool generates:
- Visual fastener markers at calculated positions
- Hardware component lists (automatically added to panel BOM)
- Editable dimension text showing fastener specifications
- Interactive grips for adjusting line endpoints and label positions

---

## Key Features

### Intelligent Connection Detection

The tool automatically identifies different connection types:

| Connection Type | Description | When to Use |
|----------------|-------------|-------------|
| **Floor-Floor** | Coplanar horizontal panels | Multi-span floor systems |
| **Wall-Wall** | Vertical T-connections | Corner connections, partition junctions |
| **Wall-Floor** | Horizontal-to-vertical | Top plate to floor, bottom plate to foundation |
| **Beam-Floor** | Header beam to horizontal panel | Ridge beams, floor joists to CLT panels |

### Multiple Insertion Modes

**\<byLine>**: Manually define fastener lines using polylines
- Select panels, then select polylines
- Complete control over fastener placement
- Useful for non-standard connection zones

**\<Coplanar Connection>**: Floor-to-floor panel joints
- Automatically finds overlapping horizontal panels
- Distributes fasteners along joint centerlines
- Ideal for multi-span CLT floor systems

**\<Wall T-Connection>**: Vertical panel intersections
- Detects perpendicular wall panels meeting at T-joints
- Places fasteners along vertical edges
- Handles corner and partition connections

**\<Wall-Floor Connection>**: Panel edge to slab/foundation
- Finds horizontal panels connected to wall panel edges
- Places fasteners along top/bottom plate zones
- Supports header beams as male connectors

### Parametric Distribution Rules

Each **Detail** can contain multiple **Rules**, and each rule defines:

- **Fastener Type**: Hardware article numbers from your database
- **Interdistance**: Spacing between fasteners
- **Distribution Mode**:
  - **Fixed**: Uniform spacing, may leave gap at end
  - **Even**: Adjusts spacing to fill entire length evenly
  - **Fixed, last odd**: Uniform spacing + one additional at end
- **Start/End Offset**: Distance from connection edge to first/last fastener
- **Visualization**: Color, transparency, marker size

### Fastener Database Integration

If **FastenerManager.dll** is available, the tool integrates with the hsbCAD Fastener Database:
- Browse and select screws/nails from central database
- Automatic diameter, length, and load capacity lookup
- Consistent hardware specifications across projects

Otherwise, hardware can be manually entered using the standard **Hardware Component Dialog**.

---

## User Interface

### Properties Panel (AutoCAD OPM)

#### **Selection Category**

**Insert Mode**
Determines initial connection detection method. After insertion, the mode is set automatically based on panel geometry.

- `<byLine>` – Manual polyline definition
- `<Coplanar Connection>` – Horizontal panel joints
- `<Wall T-Connection>` – Vertical panel corners
- `<Wall-Floor Connection>` – Edge-to-slab connections

*Note: This property is only visible during insertion.*

#### **Fastener Category**

**Detail**
Selects which predefined fastener configuration to use. Details are stored in the tool's XML settings file and can be managed via context menu triggers.

Example details:
- "CLT Floor Edge"
- "Wall Top Plate"
- "Corner Connection Heavy"

#### **Display Category**

**Format**
Optional format string for displaying fastener information. Supports variables like:
- `@(articleNumber)` – Hardware part number
- `@(quantity)` – Total fastener count
- `@(Interdistance)` – Spacing value
- `@(description)` – Hardware description

Example: `@(quantity)x @(articleNumber) @ @(Interdistance)`

**Dimstyle**
AutoCAD dimension style for text appearance. Linear dimension style overrides ($0) are supported.

**Text Height**
Text size for fastener label. Set to `0` to use the dimension style's default height.

**Style**
Label background appearance:
- **Filled Box** – White filled rectangle behind text (default)
- **Box** – Outlined rectangle only
- **Text** – Text only, no background

**Color**
Text and marker color. Set to `-1` to use automatic color based on connection type:
- Mode 2 (Floor): Color 3
- Mode 3 (Wall-Wall): Color 4
- Mode 4 (Wall-Floor): Color 4
- Mode 8 (Beam-Floor): Color 8

---

## Workflow

### Method 1: Automatic Connection Detection (Recommended)

This is the fastest method for standard panel-to-panel connections.

**Step 1: Launch the Tool**
```
Command: TSLCONTENT
```
Or insert from hsbCAD toolbar: `hsbCLT > Fastener Line`

**Step 2: Select Insert Mode**
In the Properties dialog, choose your connection type:
- **\<Coplanar Connection>** for floor panels
- **\<Wall T-Connection>** for wall corners
- **\<Wall-Floor Connection>** for edge connections

**Step 3: Select Panels**
- For **Coplanar**: Select all horizontal panels to connect (2+)
- For **Wall T-Connection**: Select all wall panels at the junction (2+)
- For **Wall-Floor**: Select wall panels AND floor panels (or header beams)

The tool will:
- Analyze panel geometry and orientations
- Detect connection zones automatically
- Create one TSL instance per connection zone
- Self-delete the original insertion instance

**Step 4: Configure Fastener Detail**
After insertion, select any fastener line instance:
1. Open AutoCAD Properties (Ctrl+1)
2. Set **Detail** to your desired configuration
3. The fastener distribution updates automatically

---

### Method 2: Manual Polyline Definition

For non-standard connections or custom fastener paths.

**Step 1: Launch Tool**
Select **\<byLine>** as Insert Mode.

**Step 2: Select Panels and Polylines**
When prompted "Select panels and (optional) defining polylines":
1. Select the panel(s) to attach hardware to
2. Select polyline(s) defining the fastener path
3. Press Enter

Each polyline creates one fastener line instance.

**Step 3: Adjust Grips**
Blue arrow grips appear at polyline endpoints:
- Drag to adjust fastener line start/end points
- Grips snap to the original polyline direction
- Circle grip controls label position

---

### Method 3: Interactive Grip Editing

After insertion by any method, you can refine fastener lines:

**Endpoint Grips** (Blue arrows)
- Appear at each end of detected connection zones
- Drag along the connection axis to shorten/lengthen distribution
- Constrained to connection surface plane

**Label Grip** (Yellow circle)
- Controls text annotation position
- Drag to move label away from connection line
- Leader line appears automatically if moved far enough

---

## Managing Fastener Details

Fastener configurations are organized as **Details** (groups of connection types) containing **Rules** (individual fastener specifications).

### Adding a New Detail

1. Right-click any **hsbCLT-FastenerLine** instance
2. Select **Add Detail** from context menu
3. Enter a descriptive name (e.g., "Heavy Duty Floor Edge")
4. Dialog closes – now add rules to this detail

### Adding a Rule to a Detail

1. Ensure the desired **Detail** is selected in Properties
2. Right-click instance → **Add Rule**
3. Configure in the dialog:

**Rule Tab:**
- **Name**: Rule identifier (e.g., "Main Field", "Edge Zone")

**Distribution Tab:**
- **Offset**: Start/end distance from connection edge
- **Interdistance**: Spacing between fasteners (mm or inches)
- **Mode**: Fixed / Even / Fixed, last odd

**Display Tab:**
- **Color**: Marker color (1-255)
- **Transparency**: 0-100 (60 = semi-transparent)
- **Size**: Marker circle diameter

4. Click OK → **Hardware Dialog** appears
5. Add fasteners:
   - **Article Number**: Hardware part number
   - **Quantity**: Fasteners per distribution point
   - **Description**: Optional notes

6. Click OK to save

The rule is now part of the selected Detail and will be applied to all connection zones.

### Editing an Existing Rule

1. Right-click instance → **Edit Rule**
2. Select rule name from dropdown
3. Modify parameters and click OK
4. Hardware dialog appears → adjust hardware
5. Click OK to save changes

### Removing a Rule

1. Right-click instance → **Remove Rule**
2. Select rule to delete
3. Click OK to confirm

*Note: You cannot remove the last rule from a detail.*

### Deleting a Detail

1. Right-click instance → **Delete Detail**
2. Select detail name from dropdown
3. Click OK to confirm

All instances using this detail will revert to the first available detail.

---

## Fastener Distribution Calculations

### Distribution Modes Explained

Given a connection length **L**, offset **O**, and interdistance **D**:

**1. Fixed Mode**
```
Number of fasteners: N = floor((L - 2×O) / D) + 1
Actual spacing: D (constant)
Last gap: May be less than D
```
Example: L=1000mm, O=50mm, D=150mm
- Effective length: 1000 - 100 = 900mm
- N = 900/150 + 1 = 7 fasteners
- Positions: 50, 200, 350, 500, 650, 800, 950mm

**2. Even Mode**
```
Number of fasteners: N = round((L - 2×O) / D) + 1
Actual spacing: D_adjusted = (L - 2×O) / (N - 1)
Last gap: Equals all other gaps
```
Example: L=1000mm, O=50mm, D=150mm
- N = 7 fasteners (same as Fixed)
- D_adjusted = 900 / 6 = 150mm (no change needed)

But if L=1100mm:
- N = round(1000/150) + 1 = 8 fasteners
- D_adjusted = 1000 / 7 = 142.86mm
- Evenly distributed across entire length

**3. Fixed, last odd Mode**
```
Number of fasteners: N = floor((L - 2×O) / D) + 2
Actual spacing: D for all except last
Last fastener: Placed exactly at (L - O)
```
Example: L=1000mm, O=50mm, D=150mm
- N = 7 + 1 = 8 fasteners
- Positions: 50, 200, 350, 500, 650, 800, 950mm (Fixed)
- PLUS one at 950mm (end)
- Ensures fastener exactly at connection end

---

## Hardware Output

### Hardware Components List

All fastener instances automatically add hardware to the parent panel's Bill of Materials:

**Per Rule:** Each rule contributes its specified hardware × quantity × number of distribution points

Example:
- Rule specifies: 2× "Spax 5x60mm" per point
- Connection has 8 distribution points
- Total hardware: 16× "Spax 5x60mm"

**Multiple Rules:** If a Detail has 3 rules, all three are applied to each connection zone.

### Format String Variables

Available in the **Format** property:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `@(articleNumber)` | Hardware part number | "Spax-CLT-5x60" |
| `@(quantity)` | Total count | "16" |
| `@(name)` | Hardware name | "CLT Screw" |
| `@(description)` | Full description | "Spax CLT screw 5x60mm" |
| `@(manufacturer)` | Vendor name | "Spax" |
| `@(material)` | Material spec | "Hardened steel" |
| `@(category)` | Hardware category | "Screw" |
| `@(Interdistance)` | Spacing value | "150" |
| `@(Interdistance2)`, `@(Interdistance3)`, etc. | Spacing for rules 2, 3, etc. | "200", "300" |

Example format string:
```
@(quantity)x @(articleNumber)\P@(Interdistance)mm spacing
```
Output:
```
16x Spax-CLT-5x60
150mm spacing
```

*Note: `\P` creates a line break in AutoCAD mtext.*

---

## Settings Management

Fastener Details and Rules are stored in XML format for persistence and sharing.

### Storage Locations

**1. Company Path** (Preferred)
```
[hsbCompany]\TSL\Settings\hsbCLT-FastenerLine.xml
```
Project-specific settings, shared across team members.

**2. Installation Path** (Fallback)
```
[hsbInstall]\Content\General\TSL\Settings\hsbCLT-FastenerLine.xml
```
Default factory settings, used when no company settings exist.

### Import/Export Settings

**Export Current Settings:**
1. Right-click any instance → **Export Settings**
2. If settings file exists, confirm overwrite
3. Settings written to company path

**Import Settings:**
1. Place XML file in company settings folder
2. Right-click any instance → **Import Settings**
3. All details/rules loaded from file
4. Existing instances update automatically

**Use Case:** Share standardized fastener configurations across projects or offices.

---

## Advanced Features

### Fastener Database Manager

If **FastenerManager.dll** is installed, you can manage a central fastener database:

1. Right-click instance → **Show Fastener Manager**
2. Database manager window opens
3. Configure:
   - Fastener libraries
   - Material properties
   - Load capacities
   - Default selections

When adding rules, fastener data is pulled directly from the database, ensuring consistency.

### Revert Direction

Reverses the order of fastener distribution along the connection line.

**Trigger:** Right-click → **Revert Direction**

**Effect:**
- First fastener becomes last
- Last becomes first
- Useful for maintaining consistent numbering direction

### Adding/Removing Panels

For **Wall-Floor** and **Beam-Floor** modes, you can dynamically modify which panels are included:

**Add Floor Panels:**
1. Right-click instance → **Add Floor Panels**
2. Select additional horizontal panels
3. Press Enter
4. Connection recalculates with new panels

**Remove Floor Panels:**
1. Right-click instance → **Remove Floor Panels**
2. Select panels to exclude
3. Press Enter
4. Connection recalculates

*Minimum 2 panels required (1 male + 1 female).*

---

## Connection Type Details

### Mode 2: Coplanar Floor Connection

**Geometry:** Two or more horizontal panels (vecZ parallel to World Z)

**Detection Logic:**
1. Checks all selected panels for coplanarity
2. Computes envelope body intersection zones
3. Creates one-to-one connections between intersecting pairs

**Fastener Line Location:**
- Along the intersection zone centerline
- Projected to panel mid-thickness plane
- Split into separate segments if intersection has openings

**Typical Use:** CLT floor panel edges in multi-span systems

---

### Mode 3: Wall T-Connection

**Geometry:** Vertical panels (vecZ perpendicular to World Z)

**Detection Logic:**
1. Identifies "male" panel (reference)
2. Finds vertical edges of male panel
3. Tests which edges connect to "female" panels
4. Connection direction = horizontal, perpendicular to male panel face

**Fastener Line Location:**
- Along vertical edge where panels meet
- Positioned at contact face between panels
- One instance per connecting edge

**Typical Use:**
- Corner connections (exterior walls)
- T-junctions (partition to main wall)
- L-shaped wall assemblies

---

### Mode 4: Wall-Floor Connection

**Geometry:** Vertical panel (wall) connecting to horizontal panel (floor/ceiling)

**Detection Logic:**
1. Male = vertical panel edge
2. Female = horizontal panel(s)
3. Connection direction = World Z (vertical)
4. Tests for contact along top or bottom edge

**Fastener Line Location:**
- Horizontal line along top/bottom plate zone
- At contact face between wall edge and floor surface
- Supports beamcut edges (notched walls)

**Typical Use:**
- Wall bottom plate to foundation slab
- Wall top plate to floor/roof panel
- Partition walls to CLT floor

---

### Mode 8: Beam-Floor Connection

**Geometry:** Horizontal beam (header, ridge beam) connecting to horizontal panel

**Detection Logic:**
1. Male = Beam object
2. Female = horizontal panels
3. Connection direction = beam major axis (vecX)
4. Tests for contact along beam top/bottom face

**Fastener Line Location:**
- Along beam centerline, at contact face elevation
- Length = intersection zone with panels

**Typical Use:**
- Ridge beam to CLT roof panels
- Floor joists to CLT subfloor
- Header beams over openings

---

## Visualization

### Fastener Markers

Each distribution point shows a **colored circle** with configurable:
- **Diameter** = Size property
- **Color** = Color property (or auto-assigned by mode)
- **Transparency** = 0 (opaque) to 100 (invisible)

Markers are **view-dependent**:
- Only visible when viewing perpendicular to connection plane
- Hidden when viewing along connection axis
- Uses `addHideDirection()` for automatic visibility control

### Connection Zone Highlighting

The detected connection zone is filled with a **semi-transparent color patch**:
- Shows exact area where fasteners will distribute
- Color matches rule color
- 80% transparency (fixed)
- Hidden in perpendicular views

### Dimension Text

**Content:** Formatted string from Format property, or Detail name if no format

**Position:** Controlled by yellow circle grip

**Background:**
- **Filled Box**: White rectangle with border
- **Box**: Border only
- **Text**: No background

**Leader Line:**
- Appears when label moved >3× text height from connection
- Connects to nearest point on fastener line
- Automatically hidden if label close to line

---

## Technical Notes

### Panel Type Detection

The tool uses **World Z axis** to classify panels:

```c
Vector3d vecZ = panel.vecZ();

if (vecZ.isParallelTo(_ZW))
    // FLOOR panel (horizontal)

else if (vecZ.isPerpendicularTo(_ZW))
    // WALL panel (vertical)

else
    // ROOF/OTHER (sloped)
```

**Floor Panels:** Used in Mode 2, Mode 4 (female), Mode 8 (female)
**Wall Panels:** Used in Mode 3, Mode 4 (male)

### Contact Face Extraction

Connection zones are computed using **PlaneProfile intersection**:

```c
PlaneProfile pp0 = male.extractContactFaceInPlane(contactPlane);
PlaneProfile pp1 = female.extractContactFaceInPlane(contactPlane);
ppRange = pp1;
ppRange.intersectWith(pp0);
```

**Result:** Accurate connection area, even with complex panel shapes

**Fallback:** If `extractContactFaceInPlane` fails, uses `shadowProfile` projection

### Grip Constraints

**Endpoint Grips:**
- Constrained to infinite line along connection axis
- Cannot move perpendicular to connection
- Automatically snapped to connection plane
- Removed if connection geometry changes (panel edits)

**Label Grip:**
- Free movement in 2D connection plane
- Automatically repositioned if moved outside connection range
- Preserved across recalculations

---

## Troubleshooting

### "No intersection found"

**Cause:** Selected panels do not physically connect.

**Solutions:**
- Verify panels are close enough (within panel thickness tolerance)
- Check for beamcuts or edge modifications preventing contact
- Ensure panels are coplanar (for floor mode) or perpendicular (for wall mode)
- Use **Mode 5 (byLine)** to manually define connection zones

---

### "No segments found, purging tool"

**Cause:** Connection plane detected, but no valid fastener path extracted.

**Solutions:**
- Panels may be touching at corners only (point contact, not edge contact)
- Opening edges may be detected as connection edges
- Increase panel overlap distance
- Check for split edges or multiple rings in panel geometry

---

### Tool creates multiple instances instead of one

**Expected behavior** for multi-edge connections:

- **Wall T-Connection:** If a panel has 3 connecting edges, 3 instances are created
- **Wall-Floor:** If wall edge connects to 2 separate floor panels, 2 instances created

**To consolidate:**
1. Delete individual instances
2. Reinsert using **Coplanar Connection** mode
3. Tool will create one instance per pair of panels

---

### Grips disappear after panel modification

**Cause:** When parent panels are edited (beamcut, resize), the tool recalculates connection geometry.

**Behavior:**
- Endpoint grips are regenerated at new connection zone boundaries
- Custom grip positions are lost
- Label grip is preserved if still within connection range

**Recommendation:** Finalize panel geometry before fine-tuning fastener line grips.

---

### Hardware not appearing in BOM

**Check:**
1. Ensure **Detail** has at least one **Rule** with hardware defined
2. Verify hardware **quantity > 0** in rule configuration
3. Check if panels belong to an Element – hardware is grouped by Element
4. Run **Bill of Material** tool to refresh BOM output

---

### Format string shows literal text instead of values

**Cause:** Variable names are case-sensitive and must match exactly.

**Correct:** `@(articleNumber)`
**Wrong:** `@(ArticleNumber)`, `@(article_number)`

**Available variables:**
- articleNumber, quantity, name, description
- manufacturer, material, category
- Interdistance, Interdistance2, Interdistance3, etc.

---

## Examples

### Example 1: CLT Floor Edge Connection

**Scenario:** Two 3m × 6m CLT floor panels, 120mm thick, meeting along long edge.

**Setup:**
1. Launch tool, select **\<Coplanar Connection>**
2. Select both floor panels → Enter
3. Tool creates one instance along 6m joint

**Configure Detail:**
1. Set Detail = "CLT Floor Edge"
2. Add Rule:
   - Name: "Main Field"
   - Interdistance: 300mm
   - Offset: 50mm
   - Mode: Even
   - Hardware: 20× "Spax HBS 8x140mm"

**Result:**
- 6000mm - 100mm (offsets) = 5900mm effective length
- N = 5900 / 300 ≈ 20 fasteners
- Adjusted spacing = 5900 / 19 = 310.5mm
- Total hardware: 20 × 20 = 400 screws

---

### Example 2: Wall Corner T-Connection

**Scenario:** Two wall panels meeting at 90° corner, both 2.8m high.

**Setup:**
1. Launch tool, select **\<Wall T-Connection>**
2. Select both wall panels → Enter
3. Tool creates instance along vertical edge (2.8m)

**Configure Detail:**
1. Set Detail = "Wall Corner Heavy"
2. Add Rule #1:
   - Name: "Top Zone"
   - Interdistance: 100mm
   - Offset: 100mm (from ceiling)
   - Mode: Fixed
   - Hardware: 2× "SFS WT-T-8.2x100"

3. Add Rule #2:
   - Name: "Bottom Zone"
   - Interdistance: 100mm
   - Offset: 100mm (from floor)
   - Mode: Fixed
   - Hardware: 2× "SFS WT-T-8.2x100"

4. Add Rule #3:
   - Name: "Field"
   - Interdistance: 300mm
   - Offset: 300mm
   - Mode: Even
   - Hardware: 1× "SFS WT-T-8.2x100"

**Result:**
- **Top Zone**: 6 fasteners (600mm / 100mm + 1) × 2 = 12 screws
- **Bottom Zone**: 6 fasteners × 2 = 12 screws
- **Field**: 2200mm / 300mm ≈ 8 fasteners × 1 = 8 screws
- **Total**: 32 screws along one vertical edge

---

### Example 3: Wall Top Plate to CLT Ceiling

**Scenario:** 4m long wall panel, top edge connecting to CLT ceiling panel.

**Setup:**
1. Launch tool, select **\<Wall-Floor Connection>**
2. Select wall panel + ceiling panel → Enter
3. Tool creates instance along 4m top edge

**Configure Detail:**
1. Set Detail = "Top Plate Standard"
2. Add Rule:
   - Name: "Uniform"
   - Interdistance: 400mm
   - Offset: 200mm
   - Mode: Fixed, last odd
   - Hardware: 1× "Hilti X-ENP-19 L15"

**Result:**
- Effective length: 4000 - 400 = 3600mm
- N = 3600 / 400 + 2 = 11 fasteners
- Positions: 200, 600, 1000, 1400, 1800, 2200, 2600, 3000, 3400, 3800mm
- PLUS one at 3800mm (duplicate at end)
- Total: 11 anchor bolts

---

## Integration with hsbCAD Workflow

### Before Using This Tool

1. **Create panels** using:
   - `hsbCLT-MasterPanelManager` (CLT workflow)
   - `hsb_SIP-MPM` (SIP workflow)
   - Manual panel placement

2. **Position panels** accurately – connection detection relies on physical overlap

3. **Apply beamcuts** (optional) – tool respects edge modifications

### After Using This Tool

1. **Generate Element BOM:**
   - `HSB_G-BillOfMaterial` – Includes fastener hardware
   - Export to Excel for quantity takeoff

2. **Create Shop Drawings:**
   - `sd_ElementShopDrawing` – Shows fastener markers
   - `hsbLayoutDim` – Dimension fastener lines

3. **Export to Manufacturing:**
   - `hsbCNC` – Can output fastener hole coordinates (if configured)
   - `bauBIT-Exporter` – Includes hardware in export data

---

## Related Tools

| Tool | Purpose | Relationship |
|------|---------|--------------|
| **hsbCLT-Drill** | Individual drill holes | Use for non-linear fastener patterns |
| **hsbCLT-Drill-Distribution** | Grid-based hole arrays | Use for face fastening |
| **hsbNailing** | Sheet-to-beam nailing | Similar distribution logic for frame structures |
| **SimpleFastener** | Single fastener insertion | Manual placement alternative |
| **HSB_G-BillOfMaterial** | Hardware quantity takeoff | Reads hardware from this tool |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **1.9** | 2024-09-12 | Fixed quantity rule edit bug (HSB-22178) |
| **1.8** | 2024-07-22 | Fixed quantity rule edit initial bug |
| **1.7** | 2024-06-03 | Resolves interdistance by hardware (HSB-22179) |
| **1.6** | 2023-08-08 | Fixed duplicate creation, longest edge detection, interdistance format variable |
| **1.5** | 2023-07-17 | Added grips for wall/floor modes, beamcut edge support |
| **1.4** | 2023-07-11 | Fastener Database integration, new connection modes |
| **1.3** | 2023-07-07 | Prepared Fastener Database support |
| **1.2** | 2023-07-07 | New insertion methods, wall/wall mode |
| **1.1** | 2023-06-30 | Polyline support, extended display options |
| **1.0** | 2023-06-29 | Initial release |

---

## Tips and Best Practices

### Organizing Details

**Recommended naming convention:**
- `[Structure Type] - [Location] - [Load Level]`
- Examples:
  - "CLT Floor - Edge - Standard"
  - "CLT Floor - Edge - Heavy"
  - "Wall - Corner - Light"
  - "Wall - TopPlate - Code Min"

**Benefit:** Quick identification in project with many connection types

### Multi-Rule Details

**Strategy:** Use multiple rules to create **zoned distributions**

Example: "Wall Corner - Seismic"
- Rule 1: Top 600mm @ 100mm spacing
- Rule 2: Bottom 600mm @ 100mm spacing
- Rule 3: Field @ 300mm spacing

**Result:** Denser fastening at high-stress zones, economical in field

### Format Strings for Production

**For shop drawings:**
```
@(quantity)x @(articleNumber)\P@(Interdistance)mm O.C.
```
Shows count, part number, and spacing.

**For BOM export:**
```
@(description)
```
Simple description for quantity takeoff.

**For CNC:**
```
FASTENER: @(articleNumber) | QTY: @(quantity) | SPACING: @(Interdistance)
```
Structured data for parsing.

### Settings Backup

**Recommendation:** Export settings after configuring Details

**Workflow:**
1. Configure all project-specific Details/Rules
2. Right-click → **Export Settings**
3. Copy XML file to project archive folder
4. Share with team members

**Recovery:** If settings are lost, **Import Settings** from archive.

---

## Summary

**hsbCLT-FastenerLine** streamlines panel connection detailing by:
- **Automating** connection zone detection
- **Standardizing** fastener specifications via reusable Details
- **Calculating** hardware quantities automatically
- **Visualizing** fastener layouts directly in the model
- **Integrating** with BOM and shop drawing workflows

By defining Details once and reusing them across similar connections, you ensure consistency, save time, and reduce errors in panel connection design.

For advanced fastener management, integrate with the **Fastener Database** system for centralized hardware specifications and load capacity verification.
