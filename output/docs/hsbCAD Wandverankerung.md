# hsbCAD Wandverankerung - Wall Anchoring Connector

## Overview

**hsbCAD Wandverankerung** (Wall Anchoring) is a specialized tool for creating wall-to-floor/ceiling connections using angle brackets and tie-down anchors. This script automatically generates metal connector hardware, creates the necessary machining operations (milling, sawing) in wall zones, and produces no-nail zones around the hardware to prevent interference with fasteners.

**Script Type**: Object (O-Type)
**Version**: 2.5
**Last Updated**: April 16, 2014
**Author**: th@hsbCAD.de

---

## Primary Function

This tool generates **wall anchoring hardware** at critical structural connection points, primarily used for:
- **Wall-to-floor anchoring** (securing bottom plates to concrete foundations)
- **Wall-to-ceiling connections** (securing top plates to upper floors)
- **Shear wall hold-down connections**
- **Multi-story construction tie-downs**

The script automatically creates:
1. **3D metal connector visualization** (angle brackets, tie-down anchors)
2. **Machining operations** in wall zones (mills/saws for recessing the hardware)
3. **No-nail zones** to prevent nail placement conflicts
4. **Fastener guidelines** for drilling anchor bolts
5. **Hardware bill of materials** (BOM) for purchasing and installation
6. **Export data** to manufacturing systems (DXA format)

---

## Application Scenarios

### When to Use This Tool

**Primary Applications:**
- **Shear wall design**: Installing hold-down anchors at shear wall ends
- **Multi-story framing**: Connecting walls between floor levels
- **Foundation anchoring**: Securing bottom plates to concrete slabs/footings
- **Wind/seismic resistance**: Meeting structural engineering requirements for lateral loads

**Typical Workflow Position:**
1. Design wall elements (stud frames, CLT panels, SIP panels)
2. **→ Apply wall anchoring hardware** (this tool)
3. Generate shop drawings and manufacturing files
4. Export to CNC machines for automated fabrication

---

## Supported Hardware Systems

The script includes **50 predefined hardware types** from two major manufacturers:

### BMF (Baumeister-Fertigung) - German Manufacturer
- **Angle Brackets**: 90°, 105° connectors (with/without ribs)
- **Tie-Down Anchors**: M12, M16, M20 threaded rod systems (2-part adjustable)
- **Common Models**:
  - BMF 90 R (90° right-angle bracket)
  - BMF Zuganker 340-M12 (340mm tie-down, M12 thread)
  - BMF Winkelverbinder 60/90, 70/90 series

### Simpson StrongTie - North American Manufacturer
- **Hold-Down Anchors**: LTT20, HTT16, HTT22 series
- **Strap Ties**: Heavy-duty tie-down straps

### Custom Zone Definitions (Z1, Z2)
Two user-definable connector types for custom hardware not in the catalog.

---

## User Interface & Parameters

### Main Hardware Selection

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| **Type** | Dropdown | Selects hardware model from 50 options | BMF-Winkel 90 R |
| **Article** | Text | Product article number/SKU | (empty) |
| **Material** | Text | Material specification | "Stahl, feuerverzinkt" (Galvanized steel) |
| **Metalpart Notes** | Text | Additional fabrication notes | (empty) |

### Display Settings

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| **Layer** | Dropdown | AutoCAD layer assignment | I-Layer, J-Layer, T-Layer, Z-Layer |
| **Show description** | Yes/No | Display hardware label with leader line | Yes |
| **X-flag** | Distance | Label horizontal offset from insertion point | 200mm |
| **Y-flag** | Distance | Label vertical offset from insertion point | 300mm |
| **Dimstyle** | Dropdown | Dimension style for text display | (current drawing style) |
| **Color** | Integer | AutoCAD color index for graphics | 171 |

### Machining Parameters - Zone 0 (Bottom/Top Plate)

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| **Depth Milling** | Distance | Recess depth for hardware into plate | 4mm |
| **Width Milling Zone 0** | Distance | Override milling width (0 = use hardware width) | 0mm (Auto) |
| **Z Offset** | Distance | Vertical adjustment from wall outline | 0mm |
| **Lower Milling-Line** | Yes/No | Close the milling contour at bottom edge | No |

### Machining Parameters - Zones 1-5 (Wall Zones)

Each zone has **identical parameter sets** for creating pockets/recesses in wall sheathing:

**Zone 1/-1 (First interior/exterior zone):**
- **Width Zone 1/-1**: Pocket width (default: 0mm = disabled)
- **Height Zone 1/-1**: Pocket height (default: 0mm = disabled)
- **Depth Zone 1/-1**: Machining depth (0 = through entire zone thickness)
- **Tool Zone 1/-1**: Select machining type (Saw / Mill / None)
- **Toolindex Zone 1/-1**: CNC tool index number (default: 1)
- **Overshoot Zone 1/-1**: Extend cut beyond pocket boundary (Yes/No)

**Zones 2/-2, 3/-3, 4/-4, 5/-5**: Identical parameter structure

*Default Settings:*
- **Zone 2/-2**: Width 170mm × Height 290mm (typical OSB sheathing pocket)
- **Zone 3/-3**: Width 210mm × Height 300mm (typical exterior sheathing pocket)
- **Other zones**: 0mm (disabled unless needed)

---

## Operation Workflow

### Step 1: Element Selection
When you first launch the script:

1. **Select Wall Element**: Click on the wall element (stick frame wall, CLT panel, or SIP panel)
2. **Select Insertion Point**: Click on the exact location for the anchor placement
   - Typical locations: Wall ends (shear walls), evenly spaced along wall length (tie-downs)
   - The script automatically **snaps to the wall outline** for precise alignment

### Step 2: Hardware Configuration

The configuration dialog appears automatically after insertion:

1. **Choose Hardware Type**: Select from 50 predefined connectors
   - For **shear walls**: Use heavy-duty hold-downs (HTT series, BMF M16/M20)
   - For **standard walls**: Use lighter anchors (BMF 90 R, LTT20)
   - Check structural engineering drawings for required model

2. **Configure Machining Zones**:
   - **Zone 0 (Plate)**: Set `Depth Milling` to recess hardware into wood (typically 4-6mm)
   - **Zone 2 (Interior Sheathing)**: Enable if OSB/plywood covers the connection
   - **Zone 3 (Exterior Sheathing)**: Enable for external cladding clearance

3. **Set Display Options**:
   - **Show description**: Turn ON to see hardware labels in drawings
   - Adjust **X-flag/Y-flag** if labels overlap with other elements

### Step 3: Result Verification

After clicking OK, the script generates:

**Visual Output:**
- Red 3D metal connector at insertion point
- Milling/sawing contours in affected wall zones
- Fastener guidelines showing anchor bolt locations
- Text label with hardware model name

**Manufacturing Output:**
- Pockets/recesses automatically subtracted from wall sheets
- CNC toolpaths generated for automated fabrication
- Hardware BOM entry created for material ordering

### Step 4: Adjustment (if needed)

**To modify after insertion:**
1. Select the connector instance in AutoCAD
2. Open **Properties Palette** (OPM)
3. Adjust any parameter - the connector **recalculates automatically**

**Common Adjustments:**
- Change `Type` to different hardware model
- Adjust `Width Zone 2/-2` if sheathing thickness differs from default
- Change `Z Offset` to raise/lower connector vertically
- Modify `Depth Milling` for different recess depths

---

## Technical Details

### Coordinate System & Positioning

The script operates in the **Element's Local Coordinate System**:
- **Origin**: Wall's insertion point (typically bottom-left corner)
- **X-axis**: Along wall length
- **Y-axis**: Along wall height
- **Z-axis**: Through wall thickness (iconside = positive, backside = negative)

**Automatic Alignment:**
- Insertion point is projected onto the **wall outline** (ignores clicks inside/outside the wall)
- `Z Offset` parameter moves the connector perpendicular to the wall face
- Icon side detection: Script automatically determines which side of the wall you're working on

### Machining Operations

**Zone-Based Processing:**
The script processes **5 independent zones** on each side of the wall:
- **Zone 0**: Bottom/top plate (horizontal framing member)
- **Zone ±1**: First wall layer (often structural studs)
- **Zone ±2**: Interior sheathing (OSB, plywood)
- **Zone ±3**: Exterior sheathing (OSB, plywood, foam)
- **Zone ±4, ±5**: Additional layers (rain screens, cladding)

**Tool Types:**
1. **Saw**: Clean straight cuts, used for through-cuts
2. **Mill**: Pockets and recesses, used for partial-depth operations
3. **None**: Disables machining for that zone

**No-Nail Zones:**
The script automatically creates **no-nail areas** around the hardware pocket to prevent:
- Nails interfering with anchor bolts
- Fasteners blocking hardware installation
- Structural conflicts during assembly

### Hardware Geometry

**Auto-Generated 3D Models:**
Each hardware type has predefined dimensions:
- **Width (W)**: Horizontal face dimension (40-220mm depending on model)
- **Height (H)**: Vertical length (88-559mm depending on model)
- **Depth (D)**: Material thickness (2-4mm steel plate)

Example dimensions:
- BMF 90 R: 90mm × 90mm × 4mm
- BMF Zuganker 340-M12: 182mm × 340mm × 2mm
- Simpson HTT22: 61mm × 559mm × 3mm

**Drill Holes:**
- Automatically generated for anchor bolts
- Ø8mm standard drill diameter
- 30mm offset from wall face for typical embedment depth
- Visible as **fastener guidelines** (red lines showing bolt path through hardware)

### Bill of Materials (BOM) Integration

The script publishes data to hsbCAD's BOM system:

**Exported Information:**
- Hardware model name and type
- Quantity (always 1 per instance)
- Dimensions (Width × Length × Thickness)
- Installation side (iconside +1 or -1)
- Material specification
- Article number

**BOM Grouping:**
Connectors are grouped by:
- Model type (ensures identical hardware is counted together)
- Installation side (allows separate material lists for each wall face)

### DXA Export (Manufacturing Integration)

When linked to a wall element, the script exports to DXA format:
- **DXA** = Data Exchange for Automated manufacturing
- Includes all machining operations (saws, mills, drills)
- Compatible with Hundegger, Weinmann, and other CNC machines
- Ensures accurate fabrication without manual data entry

---

## Best Practices

### Design Phase

**Hardware Selection:**
1. **Always consult structural engineering drawings** - do not select hardware based on visual appearance alone
2. **Match the exact model specified** - different anchors have vastly different load ratings
3. **Check local building codes** - some regions require specific hardware certifications
4. **For shear walls**: Typically require HTT16/HTT22 (North America) or BMF M16/M20 (Europe)
5. **For standard walls**: BMF 90 R or LTT20 may suffice

**Zone Configuration:**
1. **Enable only the zones that exist in your wall design**
   - If wall has no exterior sheathing, leave Zone 3 at 0mm
   - If wall is unsheathed (studs only), disable Zones 2 and 3

2. **Set realistic pocket sizes**:
   - Width should be ≥ hardware width + 10mm clearance
   - Height should be ≥ hardware height + 10mm clearance
   - Oversized pockets waste material and reduce wall strength

3. **Depth settings**:
   - **0mm depth** = cut through entire zone thickness (full penetration)
   - **Specific depth** = pocket depth from zone face (partial recess)
   - Use partial recesses for flush-mount hardware

### Manufacturing Phase

**CNC Tool Selection:**
1. **Saw vs Mill**:
   - **Saw**: Faster, cleaner edges, use for through-cuts
   - **Mill**: Required for pockets, use for partial-depth operations

2. **Tool Index Numbers**:
   - Must match your CNC machine's tool magazine
   - Typical: Tool 1 = saw blade, Tool 2 = router bit
   - Coordinate with machine operator before finalizing

3. **Overshoot Settings**:
   - **Yes**: Extends cut beyond pocket boundary (prevents material tear-out)
   - **No**: Stops exactly at pocket edge (cleaner appearance)
   - Use **Yes** for hidden pockets, **No** for visible surfaces

### Installation Phase

**On-Site Verification:**
1. **Check fastener guidelines** - ensure drill holes align with foundation anchor bolts
2. **Verify Z Offset** - ensure hardware doesn't protrude beyond wall face
3. **Review layer assignments** - ensure connectors appear on correct drawing sheets

---

## Common Issues & Solutions

### Issue: Hardware Model Not in List

**Problem**: Required connector is not among the 50 predefined types

**Solutions:**
1. **Use Z1 or Z2 custom types** - configure dimensions manually in properties
2. **Contact hsbCAD support** - request addition of new hardware to future versions
3. **Use similar model** - select closest match and note substitution in project documentation

### Issue: Pocket Doesn't Appear on Wall

**Problem**: Zone parameters set but no visible cutout in wall sheathing

**Possible Causes:**
1. **Zone doesn't exist** - wall design may not have that zone defined
   - *Solution*: Check wall element zone configuration

2. **Tool set to "None"** - machining disabled
   - *Solution*: Change Tool parameter to "Saw" or "Mill"

3. **Width or Height = 0mm** - pocket disabled
   - *Solution*: Set both dimensions > 0

### Issue: Connector on Wrong Side of Wall

**Problem**: Hardware appears on backside instead of iconside (or vice versa)

**Explanation:**
- The script auto-detects which side based on insertion point
- Clicking from different viewpoints can confuse the detection

**Solution:**
1. Use `Z Offset` parameter to "push" the connector through the wall
2. Set negative Z Offset to move connector to opposite face
3. Reinsert from a clear orthogonal view (plan view or elevation)

### Issue: Text Label Overlaps Other Elements

**Problem**: Hardware description text conflicts with dimensions or other labels

**Solutions:**
1. Adjust **X-flag** and **Y-flag** parameters to reposition label
2. Change **grip point** (blue square) by dragging in AutoCAD - label moves with it
3. Set **Show description = No** to hide label entirely

### Issue: Wrong Machining Depth

**Problem**: Pocket too shallow (hardware protrudes) or too deep (weakens wall)

**Solution:**
1. **Zone 0**: Adjust `Depth Milling` parameter (typical: 3-6mm for metal thickness)
2. **Other Zones**: Adjust `Depth Zone X` parameter
3. **Through-cut needed**: Set depth to 0mm (auto-calculates full zone thickness)

### Issue: No-Nail Zone Too Large

**Problem**: Cannot place required nails near connector

**Explanation:**
- No-nail zones are automatically sized to pocket dimensions
- This prevents structural conflicts but may limit nail placement

**Solutions:**
1. **Reduce pocket size** - make Width/Height just large enough for hardware
2. **Adjust fastener pattern** - use engineering-approved alternate nail layout
3. **Accept limitation** - some hardware requires significant clearance by design

---

## Advanced Features

### Multi-Zone Machining Strategy

For complex wall assemblies (e.g., 5-zone walls with rain screen, sheathing, vapor barrier):

**Recommended Approach:**
1. **Zone 1**: Usually disabled (studs - no machining needed)
2. **Zone 2**: Interior sheathing pocket (OSB/plywood)
   - Set dimensions to clear hardware + 10mm
   - Use **Mill** for clean pocket edges

3. **Zone 3**: Exterior sheathing pocket (OSB/plywood)
   - Set dimensions to match Zone 2 or slightly larger
   - Use **Saw** if through-cutting is acceptable

4. **Zone 4**: Exterior cladding clearance (siding, fiber-cement)
   - Only enable if hardware protrudes beyond sheathing
   - Use larger dimensions for ventilation gap

5. **Zone 5**: Rarely used (rain screen cavities)

### Custom Hardware Configuration (Z1, Z2 Types)

When using **Z1** or **Z2** custom connector types:

**Parameter Override:**
The predefined dimensions don't apply - you must configure:
1. Edit the script's dimension arrays (advanced users only)
2. Or use standard hardware and note "substitute with [model]" in project notes

**Typical Use Cases:**
- Regional hardware brands not in the standard library
- Prototype/custom-fabricated connectors
- Older hardware models from archived projects

### Fastener Guideline System

**What are Fastener Guidelines?**
Red lines visible in 3D views showing anchor bolt paths through the hardware

**Purpose:**
- Visualization for structural review
- Quality control during CNC programming
- Installation reference for field crews

**Configuration:**
- Automatically generated for Z1 and Z2 types
- Other hardware types: predefined drill patterns
- Drill diameter: Fixed at Ø8mm (standard anchor bolt clearance)
- Drill depth: 30mm beyond hardware face (typical embedment)

**Visibility:**
- Only visible when hardware is selected
- Can be toggled off in Display properties
- Not exported to 2D shop drawings (3D only)

### BOM Integration Details

**Hardware Grouping Logic:**
```
Compare Key = Hardware Type + Installation Side
Example: "BMF-Winkel 90 R Z1_+1" vs "BMF-Winkel 90 R Z1_-1"
```

This ensures:
- Identical hardware on same side = grouped into one BOM line
- Identical hardware on opposite sides = separate BOM lines
- Different hardware types = always separate lines

**Why Separate by Side?**
Installation efficiency - crews work one side of the wall at a time, need separate material lists.

---

## Technical Specifications

### System Requirements

**hsbCAD Version**: 17.2.0 or higher (for fastener guideline support)
**AutoCAD Version**: Compatible with all AutoCAD versions supported by hsbCAD
**Element Types**: Works with GenBeam walls, CLT panels, SIP panels, stick-frame walls

### Script Metadata

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Beams Required | 0 (attaches to Element, not Beams) |
| Grip Points | 1 (label position) |
| DXA Export | Enabled |
| Implicit Insert | Enabled (dialog auto-appears on insertion) |
| Major Version | 2 |
| Minor Version | 5 |

### Performance Characteristics

**Calculation Speed**: Very fast (< 0.1 seconds per instance)
**Geometry Complexity**: Low (simple box bodies, minimal Boolean operations)
**Memory Usage**: Minimal (small 3D geometry)
**Recommended Usage**: Up to 100+ instances per wall without performance impact

---

## Version History

### Version 2.5 (April 16, 2014)
- **Feature**: CNC tools can now be turned off (Tool = "None" option)
- **Use Case**: Allows visual hardware placement without generating machining operations

### Version 2.4 (January 24, 2012)
- **Feature**: Fastener guideline visualization added
- **Requirement**: hsbCAD 17.2.0 or higher

### Version 2.3 (November 30, 2009)
- **Update**: Content standardization improvements

### Version 2.2 (May 6, 2009)
- **Fix**: Milling geometry now passed to manufacturing system as inclined sheet (improved CNC compatibility)

### Version 2.1 (June 7, 2006)
- **Feature**: Added "Overshoot" option for each zone (extends cuts beyond pocket edges)

### Version 2.0 (April 11, 2006)
- **Feature**: Components with different icon orientations receive different position numbers
- **Purpose**: Enables zone-dependent BOM display in hsbBOM tool

### Version 1.9 (April 10, 2006)
- **Feature**: "Width Zone 0" parameter added - defines milling width in bottom/top plate
- **Behavior**: If 0mm, uses hardware width automatically

### Earlier Versions (1.0 - 1.8)
- Initial development: Basic hardware placement
- Added BMF angle brackets and tie-down anchors
- Added multi-line text labels with leader lines
- Added layer visibility controls (I, J, T, Z layers)
- Added DXA export integration

---

## Related Tools

**Complementary Scripts:**
- **hsbBOM**: Generates bill of materials including hardware from this script
- **HSB_G-BillOfMaterial**: Advanced BOM generation with grouping options
- **sd_MetalpartBOM**: Shop drawing BOM specifically for metal hardware

**Workflow Integration:**
- **Element creation tools**: HSB_W-* (wall tools), hsbCLT-* (CLT tools)
- **Layout tools**: hsbLayoutDim, hsbViewTag (dimensioning and labeling)
- **Export tools**: bauBIT-Exporter, hsbCNC (manufacturing data output)

**Hardware-Related Scripts:**
- **Simpson StrongTie** series: Specialized connectors from same manufacturer
- **Hilti** series: Alternative anchoring systems (concrete anchors, post bases)
- **BMF** series: Extended BMF hardware library (beam hangers, joist hangers)

---

## Summary

**hsbCAD Wandverankerung** is an essential tool for **structural wall connections** in timber construction projects. It bridges the gap between structural engineering requirements and manufacturing execution by:

1. **Automating hardware placement** - ensures correct positioning and orientation
2. **Generating machining operations** - prepares walls for hardware installation
3. **Creating no-nail zones** - prevents structural conflicts
4. **Integrating with BOM systems** - enables accurate material ordering
5. **Exporting to CNC machines** - ensures fabrication accuracy

**Key Benefits:**
- **Saves design time** - no manual pocket drawing or dimension calculation
- **Reduces errors** - automatic zone detection and alignment
- **Improves quality** - standardized hardware placement and machining
- **Streamlines workflow** - seamless integration from design to fabrication

**Best For:**
- Shear wall design in multi-story buildings
- Seismic/wind-resistant construction
- Foundation anchoring systems
- Structural hold-down applications

**When to Use:**
Apply this tool during the **detailed design phase** after wall elements are defined but before generating shop drawings and manufacturing files.

---

## Support & Resources

**Documentation Location**: This guide
**Sample Projects**: Check hsbCAD installation folder: `Content\General\TSL\Examples\`
**Technical Support**: th@hsbCAD.de
**Hardware Catalogs**:
- BMF: www.bmf-online.de
- Simpson StrongTie: www.strongtie.com

**Training Resources:**
- hsbCAD YouTube channel (search "wall anchoring")
- Regional dealer training sessions
- Online webinars (check hsbCAD website)

---

*Document Generated: 2026-02-21*
*Script Version: 2.5*
*Target Audience: CAD Operators, Timber Construction Designers*
*Skill Level: Intermediate (requires understanding of wall construction and structural hardware)*
