# hsbFA_Add2MassElement - Fastener Assembly for Cylindrical Mass Elements

## Overview

**hsbFA_Add2MassElement** is an intelligent fastener placement tool that creates parametric fastener assemblies for cylindrical mass elements (like dowels, rods, or bolts). The script automatically generates fastener assembly guidelines based on the mass element geometry and optionally creates drill holes in intersecting timber beams.

This tool is essential for modeling mechanical connections such as threaded rods, dowels, bolts, and anchor systems that pass through timber members. It automatically handles the complex geometry calculations needed to position and orient fasteners correctly.

**Version:** 1.5 (January 25, 2012)
**Script Type:** Object (O-Type)
**Category:** Manufacturing / Fastener / Assembly

---

## Key Features

- **Automatic Guideline Creation**: Generates fastener assembly guidelines along cylindrical mass elements
- **Beam Intersection Drilling**: Automatically creates drill holes in GenBeams that intersect the fastener
- **Flexible Length Control**: Define fastener length automatically from beam intersections or manually with grip points
- **Visual Feedback**: Hidden line display shows fastener path and drilling symbol
- **Group Labeling**: Assigns group keys for coordinated labeling in shop drawings
- **Flip Side Control**: Reverse drilling direction with context menu
- **In-Place Editing**: Adjust fastener endpoints interactively

---

## Application Scenarios

### Typical Use Cases

1. **Threaded Rod Connections**: Model threaded rods passing through multiple timber members with washers and nuts
2. **Dowel Connections**: Create dowel fasteners in beam-to-beam or beam-to-column connections
3. **Anchor Bolts**: Model foundation anchor bolts passing through sill plates
4. **Hold-Down Systems**: Vertical threaded rods for shear wall hold-downs
5. **Through-Bolt Connections**: Any connection requiring a cylindrical fastener passing through timber

### Structure Types

- Stick-frame construction (wall hold-downs, post bases)
- Heavy timber frames (beam-to-beam connections)
- CLT panels (wall-to-floor connections, anchoring)
- Foundation connections (sill plate anchoring)

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Grip Points | 0 (customizable in v1.5+) |
| Version | 1.5 |
| Environment | Model Space |
| Implicit Insert | Yes |

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for inserting and interacting with 3D beams and mass elements |
| Paper Space | No | Not applicable |
| Shop Drawing | Integration | Creates grouping data used by shop drawing scripts |

---

## Prerequisites

Before using this script, ensure:

1. **Cylindrical Mass Elements exist** - The script only works with Mass Elements that have a cylindrical shape type
2. **Fastener Assembly Definitions are configured** - At least one FastenerAssemblyDef style must be defined in the system catalog
3. **Optional: GenBeams are present** - If you want to create drill holes in timber members, GenBeams must be placed in the model

---

## Parameters & Properties

### Core Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Fastener Style** | Selection | _(varies)_ | Selects the fastener assembly definition (rod diameter, material, washers, nuts) from available catalogs |
| **Delta Diameter** | Length | -1 mm | Diameter adjustment for drill holes (negative = smaller than fastener, positive = larger). Typically -1mm for clearance. |
| **Depth (0=complete)** | Length | 0 mm | Drilling depth into GenBeam. **0 = through hole**, positive value = partial depth from entry side |
| **Flip Side** | Yes/No | No | Reverses the drilling direction when depth > 0 (drills from opposite end) |

### Advanced Properties

**Grip Points Mode**: When you provide start/end points during insertion or via "Edit in place", the script uses these exact points instead of automatic beam detection. This allows manual control over fastener length.

---

## User Interface Elements

### Initial Insertion Dialog

When inserting without a catalog preset, you'll see:

```
┌─────────────────────────────────────┐
│  Fastener Assembly Properties       │
├─────────────────────────────────────┤
│  Fastener Style:     [Select... ▼]  │
│  Flip Side:          [No ▼]         │
│  Delta Diameter:     [-1.00 mm]     │
│  Depth (0=complete): [0.00 mm]      │
│                                     │
│           [OK]  [Cancel]            │
└─────────────────────────────────────┘
```

**Fastener Style Dropdown**: Shows all available FastenerAssemblyDef entries from your library (typically threaded rod systems with specific diameters, materials, and hardware components).

### Command Prompts During Insertion

The script guides you through a multi-step selection process:

```
1. "Select Mass Element(s)"
   → Select one or more cylindrical mass elements
   → Multiple selection creates batch instances with shared group key

2. "Select GenBeam(s) (optional)"
   → Select timber beams that the fastener passes through
   → Script automatically calculates drill positions and lengths
   → Optional: Skip for visual-only fasteners

3. "Select start and end point (optional)"
   → Click two points to manually define fastener length
   → Overrides automatic beam detection
   → "Select end point" (second prompt if you provided first point)
```

### Context Menu Commands

Right-click on an existing instance for:

| Command | Action |
|---------|--------|
| **Add GenBeam** | Prompts to select additional GenBeam for drilling |
| **Remove GenBeam** | Prompts to select GenBeam to remove from drill list |
| **Flip Side** | Reverses drilling direction (when depth > 0) |
| **Edit in place** | Allows interactive repositioning of fastener endpoints with grip points |

---

## Step-by-Step Usage Guide

### Standard Workflow: Automatic Beam Detection

**Step 1: Insert the Script**
- Launch `hsbFA_Add2MassElement` from the tool palette or command line
- The properties dialog appears (if no catalog preset is active)

**Step 2: Configure Properties**
- **Fastener Style**: Select your threaded rod or dowel definition (e.g., "M20 Threaded Rod with Washers")
- **Delta Diameter**: Leave at -1 mm for standard clearance (drill diameter = fastener diameter - 1mm)
- **Depth**:
  - Set to `0` for **through holes** (fastener passes completely through all beams)
  - Set to positive value (e.g., `150 mm`) for **partial depth** drilling
- **Flip Side**: Leave at "No" initially (can change later via context menu)
- Click **OK**

**Step 3: Select Mass Elements**
- Command prompt: `"Select Mass Element(s)"`
- Click on cylindrical mass elements (one or multiple)
- These must be `MassElement` entities with `cylinder` shape type
- Press **Enter** to confirm selection

**Step 4: Select GenBeams (Optional)**
- Command prompt: `"Select GenBeam(s) (optional)"`
- Click on timber beams that the fastener should drill through
- The script will:
  - Calculate intersection points between mass element axis and beam profiles
  - Create drill holes automatically
  - Set drill start/end based on depth setting
- Press **Enter** to confirm (or skip if no drilling needed)

**Step 5: Manual Length Control (Optional)**
- Command prompt: `"Select start and end point (optional)"`
- Press **Enter** to skip (use automatic detection)
- **OR** Click two points to manually define fastener extent
  - First click: Start point of fastener
  - Second click: End point of fastener
  - Overrides automatic beam-based length calculation

**Step 6: Verify Result**
- Fastener guideline appears as hidden line along cylinder axis
- Drill symbol (radiating lines and circle) shows at drilling end
- Drill holes are created in selected GenBeams
- All selected mass elements share a group key for coordinated shop drawing labeling

---

### Advanced Workflow: Manual Grip Points

Use this when beam automatic detection doesn't match your design intent:

1. **Insert normally** (Steps 1-4 above)
2. **Right-click** on the fastener instance
3. Select **"Edit in place"** from context menu
4. Command prompt: `"Select start and end point (optional)"`
5. Click **two points** to redefine fastener extent:
   - Points are projected onto cylinder axis
   - Drilling is recalculated based on new endpoints
6. Press **Enter** twice to finish

---

### Flipping Drilling Direction

When using **Depth > 0** (partial depth drilling):

**Initial State:**
- Drill enters from the first beam intersection
- Extends inward by specified depth

**After Flip:**
1. Right-click the instance
2. Select **"Flip Side"**
3. Drill now enters from the opposite beam intersection
4. Extends inward by specified depth

**Use Case**: When you need to drill from the bottom of a connection instead of the top.

---

### Insertion Without GenBeam Option

When the script is executed with the key `NOGENBEAM`:
- The dialog will not show drill-related properties
- You will not be prompted for GenBeam selection
- This mode is useful when you only need the Fastener Assembly visualization without drilling

---

## Technical Details

### Geometry Calculation Logic

#### Automatic Length Detection

When GenBeams are selected and no grip points provided:

1. **Cylinder Axis**: Script extracts the Z-axis of the mass element's coordinate system as the fastener centerline
2. **Shadow Profiles**: For each GenBeam, script calculates a 2D shadow profile perpendicular to the beam's X-axis
3. **Intersection Points**: Finds where cylinder axis intersects beam shadow profiles
4. **Ordering**: Points are sorted along the cylinder axis
5. **Start/End Assignment**:
   - **Depth = 0**: Start = first intersection, End = last intersection (through hole)
   - **Depth > 0, No Flip**: Start = first intersection, End = Start + Depth along axis
   - **Depth > 0, Flip**: Start = last intersection, End = Start - Depth along axis

#### Drill Creation

**Drill Diameter**: `Drill Radius = Mass Element Radius + (Delta Diameter / 2)`

For example:
- Mass Element = M20 threaded rod (20mm diameter → 10mm radius)
- Delta Diameter = -1mm
- Drill Radius = 10mm + (-1mm / 2) = 9.5mm → **19mm drill diameter**

This creates clearance for installation.

**Drill Application**:
```
Drill(start_point, end_point, radius).addMeToGenBeamsIntersect(GenBeamArray)
```
The `addMeToGenBeamsIntersect()` method automatically determines which beams are actually intersected and applies the drill only to those.

---

### Group Labeling for Shop Drawings

**Group Key Assignment**: The script assigns the **handle** (unique ID) of the **first selected mass element** as a group key to **all selected mass elements**.

**Property Set**: `hsbDimGroup` with property `Group`

**Purpose**: In shop drawings, all fasteners with the same group key will be:
- Labeled together (e.g., "4x M20 Anchor Bolts")
- Dimensioned as a set rather than individually
- Shown with shared callouts

**Example Scenario**:
- User selects 4 anchor bolt mass elements for a post base
- Script assigns first bolt's handle to all 4 bolts
- Shop drawing shows "4x M20 x 450mm" instead of 4 separate labels

---

### Visual Display Elements

#### Hidden Line Display
- **Color**: 136 (typically gray)
- **Line Type**: Hidden (dashed)
- **Geometry**: Straight line from start to end point along cylinder axis

#### Drill Symbol (When GenBeams Present)
Displayed at drilling endpoint:
- **Radiating Lines**: 8 lines at 45° intervals extending from drill end
- **Circle**: At drill endpoint showing drill diameter
- **Offset**: Symbol positioned 2 × radius from endpoint (or closer if space limited)
- **Direction**: Points along drilling direction (flips with "Flip Side")

---

## Parameter Interaction & Dependencies

### Delta Diameter

**Typical Values**:
- `-1 mm`: Standard clearance for metric threads (19mm drill for M20 bolt)
- `0 mm`: Exact fit (20mm drill for 20mm dowel)
- `+1 mm`: Extra clearance for adjustment during installation

**Effect**: Directly affects drill hole diameter applied to GenBeams.

### Depth Setting

| Depth Value | Drilling Behavior | Use Case |
|-------------|-------------------|----------|
| **0 mm** | Complete through hole | Fastener passes entirely through all members |
| **> 0 mm** | Partial depth from entry side | Countersunk holes, partial embedment |

**With GenBeam Selection**:
- Depth = 0: Drilling from first intersection to last intersection
- Depth > 0: Drilling from first (or last if flipped) intersection inward by specified depth

**Without GenBeam Selection**:
- Depth setting has no effect (no drilling occurs)

### Flip Side Interaction

**Only Active When**: Depth > 0 and GenBeams selected

**Effect Table**:

| Flip Side | Depth = 0 | Depth > 0 |
|-----------|-----------|-----------|
| No | Through hole | Drills from first beam inward |
| Yes | Through hole (no change) | Drills from last beam inward |

---

## Execution Modes

### Catalog Mode (`_kExecuteKey` Set)

When launched from a catalog or preset command:
- Properties are loaded from catalog entry
- Dialog is skipped (direct to selection prompts)
- User immediately prompted for mass elements

**Exception**: `_kExecuteKey == "NOGENBEAM"`
- Shows dialog for property configuration
- Skips GenBeam selection prompt
- Creates visual-only fastener guidelines (no drilling)

**Use Case**: Design intent display without actual fabrication drilling.

---

### Interactive Mode (No ExecuteKey)

Default insertion:
- Full dialog shown for all properties
- User prompted for mass elements, then GenBeams, then optional grip points
- Maximum flexibility for custom configurations

---

## Settings Files

- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on the standard hsbCAD FastenerAssemblyDef catalogs rather than external XML settings files

When called with an execution key (other than empty or "NOGENBEAM"), the script reads property values from the specified catalog entry using `setPropValuesFromCatalog()`.

---

## Related Tools & Workflow Integration

### Upstream Tools (Create These First)

| Tool | Purpose |
|------|---------|
| **MassElement Creation** | Create cylindrical mass elements to represent threaded rods, dowels, or bolts |
| **GenBeam Creation** | Model timber members that fasteners pass through |
| **FastenerAssemblyDef Library** | Define fastener types (rod diameter, material, hardware) in company library |

### Downstream Tools (Use After This)

| Tool | Purpose |
|------|---------|
| **Shop Drawing Scripts** (`sd_*`) | Generate fabrication drawings showing grouped drill holes |
| **hsbBOM / Bill of Material** | Extract fastener quantities and specifications |
| **CNC Export** (`hsbCNC`) | Export drill hole coordinates for CNC processing |
| **Layout Dimension Tools** | Add dimensions to fastener groups in layout views |

### Complementary Tools

| Tool | Relationship |
|------|-------------|
| **hsbCLT-Drill** | Alternative for direct drill placement in CLT panels (not mass-element-based) |
| **DrillDistribution** | For creating arrays of drills on beam faces (not fastener-guideline-based) |
| **FastenerEditor** | Edit existing fastener assemblies created by this script |
| **hsbMetalPart** | Model metal plates and brackets that may use these fasteners |

---

## Practical Examples

### Example 1: Post Base Hold-Down with M20 Threaded Rods

**Scenario**: 4 vertical threaded rods passing through bottom plate and connecting to concrete foundation.

**Setup**:
- 4 cylindrical mass elements (M20 rods, 450mm long)
- 1 GenBeam (bottom plate, 140 × 38mm)
- Fastener style: "M20 Threaded Rod with Washers and Nuts"

**Steps**:
1. Launch `hsbFA_Add2MassElement`
2. Select "M20 Threaded Rod..." from Fastener Style
3. Delta Diameter: -1 mm
4. Depth: 0 (through hole)
5. Select all 4 mass elements
6. Select the bottom plate GenBeam
7. Press Enter (skip grip points)

**Result**:
- 4 fastener guidelines created
- 4 drill holes (Ø19mm) in bottom plate at rod positions
- All 4 rods share group key → shop drawing shows "4x M20 x 450mm Anchor Rods"

---

### Example 2: Beam-to-Beam Dowel Connection (Partial Depth)

**Scenario**: Two 12mm dowels connecting face of beam 1 to end grain of beam 2, 80mm embedment in each.

**Setup**:
- 2 cylindrical mass elements (Ø12mm dowels)
- 2 GenBeams (beam 1 and beam 2)
- Fastener style: "12mm Hardwood Dowel"

**Steps**:
1. Launch `hsbFA_Add2MassElement`
2. Select "12mm Hardwood Dowel"
3. Delta Diameter: -0.5 mm (tight fit)
4. **Depth: 80 mm** (partial depth)
5. Select both dowel mass elements
6. Select both GenBeams
7. Press Enter

**Result**:
- Dowels drill 80mm into first beam from entry point
- To drill 80mm into second beam from opposite end:
  - Right-click → "Flip Side" → drills 80mm from other intersection

---

### Example 3: Manual Grip Point Control

**Scenario**: Threaded rod doesn't extend full length between beams (needs specific start/end for washer positions).

**Steps**:
1. Insert normally with GenBeam selection
2. Right-click instance → "Edit in place"
3. At prompt, click desired start point (washer position)
4. Click desired end point (opposite washer position)
5. Press Enter

**Result**:
- Fastener length controlled precisely
- Drilling still occurs at beam intersections
- Visual representation matches exact assembly

---

## Troubleshooting & Common Issues

### Issue: Script Immediately Erases After Insertion

**Cause**: Selected entity is not a valid cylindrical MassElement.

**Solution**:
- Ensure you selected a `MassElement` entity (not a 3D solid or GenBeam)
- Verify mass element shape type is cylinder (not box, cone, sphere, etc.)
- Check mass element is valid (`bIsValid()` returns true)

---

### Issue: No Drill Holes Created in GenBeams

**Possible Causes**:
1. **No GenBeams Selected**: GenBeam selection is optional; press Enter to skip if not needed
2. **GenBeams Don't Intersect**: Beams must physically intersect the cylinder axis
3. **NoGenBeam Execute Key**: Script launched with "NOGENBEAM" catalog key

**Solution**:
- Use context menu → "Add GenBeam" to add drilling after insertion
- Verify beam geometry actually crosses the fastener path
- Check if catalog entry has "NOGENBEAM" key (prevents drilling)

---

### Issue: Drilling Direction is Backwards

**Cause**: Flip Side setting or mass element Z-axis orientation.

**Solution**:
- Right-click → "Flip Side" to reverse direction
- Check mass element coordinate system Z-axis (defines default direction)
- Adjust Depth setting and Flip combination

---

### Issue: Drill Diameter Too Large/Small

**Cause**: Delta Diameter parameter.

**Solution**:
- **Too Large**: Increase Delta Diameter (make it more negative)
  - Example: -2 mm instead of -1 mm → 18mm drill for M20 rod
- **Too Small**: Decrease Delta Diameter (make it less negative or positive)
  - Example: 0 mm → 20mm drill for M20 rod (exact size)

**Formula**: `Drill Diameter = Mass Element Diameter + Delta Diameter`

---

### Issue: Cannot Group Fasteners in Shop Drawing

**Cause**: Property set `hsbDimGroup` not available in drawing template.

**Solution**:
- Ensure hsbCAD property set definitions are loaded
- Verify template includes `hsbDimGroup` property set definition
- Check if all mass elements have same group key value
  - Select mass element → Properties → Custom tab → hsbDimGroup → Group property

---

### Issue: Fastener Assembly Not Created Automatically

**Cause**: Script creates FastenerAssemblyEnt only once, during `_bOnDbCreated` event.

**Solution**:
- Fastener assembly should appear immediately after insertion
- If missing, check if FastenerAssemblyDef style name is valid
- Verify style exists in FastenerAssemblyDef library
- Check coordinate system of mass element (used for fastener orientation)

---

## Best Practices

### Design Phase

1. **Model Mass Elements First**: Create all cylindrical mass elements representing fasteners before running script
2. **Verify Geometry**: Ensure mass elements are truly cylindrical (not cones, frustums, etc.)
3. **Group Related Fasteners**: Select multiple mass elements together to assign shared group key
4. **Standard Clearances**: Use -1 mm Delta Diameter for metric threads, -1/16" for imperial

### Production Phase

1. **Through Holes First**: Use Depth = 0 for all through-fastener connections
2. **Flip for Countersinking**: When one end needs countersink/washer clearance, use Depth + Flip
3. **Manual Override When Needed**: Use grip points for non-standard situations
4. **Coordinate System Consistency**: Orient mass elements with Z-axis pointing in logical direction (e.g., gravity direction for vertical rods)

### Shop Drawing Phase

1. **Batch Selection**: Always select related fasteners together to share group key
2. **Verify Group Assignment**: Check Properties → hsbDimGroup → Group value matches for all related elements
3. **Label Strategy**: Use group keys to consolidate callouts (4x M20 instead of 4 separate labels)

---

## Tips

- **Through Holes**: Leave **Depth** set to `0` to ensure the drill goes all the way through the selected beams
- **Clearance Holes**: If your rod is 20mm diameter and you want a 22mm hole, ensure your MassElement radius is 10mm and set **Delta Diameter** to `2.0`
- **Direction Control**: The Z-axis of the MassElement defines the default drilling direction. Use **Flip Side** if the drill is going the wrong way
- **Custom Positioning**: Use "Edit in place" when automatic detection does not give the desired result
- **Batch Operations**: Select multiple Mass Elements at once to create multiple Fastener Assemblies with consistent settings and grouping

---

## FAQ

**Q: Why does the script erase itself immediately after insertion?**
A: This script uses a cloning pattern - it creates individual instances for each selected Mass Element and then erases the original caller instance. This is normal behavior.

**Q: The drill hole appears on the wrong side of the beam. How do I fix this?**
A: Right-click the Fastener Assembly instance and select "Flip Side" to reverse the drill direction.

**Q: Can I use this script with non-cylindrical Mass Elements?**
A: No, the script validates that the Mass Element must be a cylinder. Non-cylindrical shapes will cause the instance to be erased.

**Q: Why is no drill appearing in my beam?**
A: Check if you selected the correct GenBeam in Step 4 or used "Add GenBeam" from the right-click menu. Also ensure the cylinder actually intersects with the timber.

**Q: How do I make the hole larger than the rod?**
A: Increase the **Delta Diameter** value. For example, `2.0` will add 1mm to the radius (2mm to the total diameter).

**Q: Can I change the length of the rod visually?**
A: Yes, use the "Edit in place" right-click option to select new start and end points, or grip-edit the guideline points if enabled (version 1.5+).

**Q: How do I create drill holes in multiple beams?**
A: Select multiple GenBeams during the initial insertion, or use the "Add GenBeam" context menu option after insertion to link additional beams.

**Q: What happens if I change the Depth property after insertion?**
A: The script recalculates the drill geometry when properties change. The contour detection runs again to determine new intersection points based on the updated depth setting.

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.5 | 25 Jan 2012 | th@hsbCAD.de | New option to set length by grip points |
| 1.4 | 02 Sep 2011 | th@hsbCAD.de | Bugfix |
| 1.3 | 02 Sep 2011 | th@hsbCAD.de | Insert dialog varies from execute key; NOGENBEAM mode added |
| 1.2 | 30 Aug 2011 | th@hsbCAD.de | Bugfix drill diameter |
| 1.1 | 29 Aug 2011 | th@hsbCAD.de | GenBeam linking, drill properties, context commands, flip side |
| 1.0 | 28 Aug 2011 | th@hsbCAD.de | Initial release |

---

## Technical Notes

### Script Classification

- **Category**: Manufacturing / Fastener / Assembly
- **Type**: O-Type (Object script creating persistent parametric entity)
- **Dependencies**: Requires FastenerAssemblyDef library
- **Target Environment**: Model Space

### Dependencies & Requirements

**Required Property Sets**:
- `hsbDimGroup` (for group labeling functionality)

**Required Libraries**:
- FastenerAssemblyDef (fastener catalog definitions)
- Core hsbCAD TSL utilities

**Coordinate System Requirements**:
- Mass element must have valid coordinate system
- Z-axis defines fastener direction
- Origin defines default start point

---

## See Also

### Related Scripts

- **FastenerEditor**: Edit existing fastener assemblies
- **FastenerInspector**: Inspect and validate fastener properties
- **hsbCLT-Drill**: Alternative for CLT panel drilling
- **Drill**: Basic drilling tool without fastener assembly
- **DrillDistribution**: Array-based drilling patterns

### Documentation References

- FastenerAssemblyDef catalog structure
- hsbDimGroup property set configuration
- MassElement entity type specifications
- GenBeam drilling methods reference

---

## Summary

**hsbFA_Add2MassElement** is a specialized tool for creating parametric fastener assemblies along cylindrical mass elements with automatic drill hole generation in intersecting timber beams. Its key strength is the combination of:

1. **Intelligent geometry detection** (automatic beam intersection and drilling)
2. **Flexible control** (automatic or manual grip point modes)
3. **Shop drawing integration** (group key assignment)
4. **Visual feedback** (drill symbols and hidden line display)

This tool is essential for modern timber construction workflows where mechanical fasteners must be precisely coordinated between 3D modeling, fabrication drawings, and CNC production.

**Target Users**: CAD operators, timber structure designers, fabrication engineers working with threaded rod connections, dowel joints, anchor bolts, or any cylindrical fastener system requiring drill holes in timber members.

**When to Use**: Whenever you need to model a cylindrical mechanical fastener (rod, bolt, dowel) that passes through one or more timber members and requires automatic drill hole creation with shop drawing coordination.
