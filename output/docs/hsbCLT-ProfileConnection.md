# hsbCLT-ProfileConnection

**Version:** 1.5 (January 31, 2024)
**Category:** CLT (Cross-Laminated Timber)
**Type:** O-Type (Object Script)

---

## Overview

**hsbCLT-ProfileConnection** creates precise connection details between a steel beam (profile beam such as HEA, IPE, or U-channel) and CLT panels. This tool automatically stretches the panel edges to meet the beam and generates appropriate cutouts and chamfers to ensure proper fit and clearance around the steel profile.

This script is essential for hybrid timber-steel construction where CLT panels must connect to structural steel beams. It handles complex geometrical calculations to accommodate various steel profile shapes (I-beams, C-channels, double-T sections) and automatically creates the necessary panel modifications.

**Typical Applications:**
- CLT floor panels connecting to steel edge beams
- CLT wall panels joining to steel columns or beams
- Hybrid construction where CLT panels frame into steel structure
- Connection details requiring precise clearances and chamfers

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.5 | 31.01.2024 | Bug fix when facet offset ≤0 | Thorsten Huck |
| 1.4 | 24.07.2019 | Bug fix at calculation of vFacet1 and vFacet2 | Marsel Nakuci |
| 1.3 | 03.07.2019 | Support multiple panels - connection created for all panels and the beam | Marsel Nakuci |
| 1.2 | 21.03.2019 | TSL display at middle of edges | Marsel Nakuci |
| 1.1 | 21.03.2019 | Fix suggestions from Roman and Thorsten | Marsel Nakuci |
| 1.0 | 21.03.2019 | Initial version | Marsel Nakuci |

---

## Script Classification

- **Type:** O-Type (Object)
- **Beams Required:** 0 (selection-based)
- **Insertion Method:** Implicit Insert
- **Keywords:** panel, connection, beam, profile, HEA, IPE, U

---

## How It Works

### Insertion Process

1. **Launch the script** from the hsbCAD toolbar or command line
2. **Selection prompt:** "Select panel and beam"
   - Select one or more CLT panels (Sip entities)
   - Select one steel beam (Beam entity with profile)
   - Press Enter to confirm selection
3. **Property dialog** appears (if no catalog key specified)
   - Adjust gap parameters as needed
   - Click OK to proceed
4. **Automatic calculation:**
   - Script analyzes panel edges relative to beam position
   - Identifies edges that need to be stretched toward the beam
   - Detects steel profile shape (flanges, web)
   - Calculates required cutouts for top flange, bottom flange, and web
   - Creates chamfer/facet cuts for clean edges
   - Stretches panel edges to meet the beam wall

### Geometric Requirements

**Critical Design Rules:**

1. **Panel Orientation:** The panel's normal vector (perpendicular to panel face) **must be perpendicular** to the beam axis
   - ✓ Correct: Panel standing vertically, beam running horizontally
   - ✗ Incorrect: Panel skewed at an angle to the beam axis

2. **Intersection Capability:** The panel (or its extension) must be able to intersect the beam
   - Script will stretch panel edges toward the beam
   - If the panel cannot reach the beam even after stretching, calculation fails

3. **Beam-Panel Relationship:** The beam center should not coincide exactly with the panel center

### Edge Selection Logic

The script automatically determines which panel edges to modify:

1. **Identifies candidate edges:** All edges pointing toward the beam (not away from it)
2. **Excludes opening edges:** Edges belonging to door/window openings are excluded
3. **Selects closest edge:** The edge with midpoint closest to the beam axis
4. **Groups aligned edges:** All edges parallel and collinear with the closest edge are included
5. **Stretches edges:** Selected edges are stretched to the beam wall plane

### Cutout Generation

Based on the detected steel profile shape, the script creates:

**For I-Beams (HEA, IPE, etc.):**
- Top flange cutout (rectangular cut to clear the top flange)
- Bottom flange cutout (rectangular cut to clear the bottom flange)
- Web cutout (rectangular cut for the main vertical web)
- Chamfer/facet cuts (45° beveled edges at transitions)

**For C-Channels and other profiles:**
- Adaptive cutouts based on detected profile geometry
- Inner flange clearances for complex shapes
- Multiple cutouts if profile has internal features

All cutouts include the specified gap tolerances.

---

## User Properties (OPM)

All gap parameters are organized under the **"Gap values"** category in the AutoCAD Properties Palette.

### Gap Parameters

| Property | Default | Description | Typical Range |
|----------|---------|-------------|---------------|
| **Top Vertical** | 10 mm | Vertical gap above top flange | 5-20 mm |
| **Top Horizontal** | 10 mm | Horizontal gap at top flange edge | 5-20 mm |
| **Bottom Vertical** | 10 mm | Vertical gap below bottom flange | 5-20 mm |
| **Bottom Horizontal** | 0 mm | Horizontal gap at bottom flange edge | 0-15 mm |
| **Main Vertical** | 10 mm | Gap between panel edge and beam web | 5-20 mm |
| **Facet** | 15 mm | Depth of chamfer/facet cut (45° bevel) | 10-25 mm |
| **Beam** | 10 mm | Longitudinal gap at start and end of beam | 5-20 mm |

### Parameter Details

#### Top Vertical Gap
Controls the clearance above the top flange of the steel profile. Increase this value if you need more space for welding, fire protection, or tolerance.

#### Top Horizontal Gap
Controls how far the cutout extends horizontally beyond the top flange edge. This creates clearance for tolerances and installation.

#### Bottom Vertical Gap
Controls the clearance below the bottom flange. Important for ensuring the panel doesn't interfere with the steel during installation.

#### Bottom Horizontal Gap
Horizontal clearance at the bottom flange. Often set to 0 mm if the panel sits flush against the bottom flange edge.

#### Main Vertical Gap
The primary clearance between the stretched panel edge and the beam web (the vertical part of the I-beam). This gap determines how tightly the panel fits against the steel.

**Important:** The panel edge is stretched to this distance from the beam web. A value of 10 mm means the panel edge will be positioned 10 mm away from the steel web surface.

#### Facet Gap
Controls the depth of the 45° chamfer cut at the transitions between cutouts. The chamfer prevents sharp corners in the CLT panel and provides a cleaner transition between different cut depths.

The actual width of the facet cut is calculated as: `2 × √2 × Facet Gap`

**Setting to 0:** If you set Facet Gap to 0 or negative values, no chamfer will be created (rectangular cutouts only).

#### Beam Gap
Longitudinal clearance added at both ends of the beam. All cutouts extend by this amount beyond the beam start and end points to ensure full clearance along the beam length.

---

## Workflow Steps

### Step 1: Prepare Your Model

Before using this script:

1. **Create CLT panels** using hsbCLT panel tools
2. **Place steel beam** with appropriate profile (HEA, IPE, UPE, etc.)
3. **Position elements** so that:
   - Panel normal is perpendicular to beam axis
   - Panel can reach or nearly reach the beam
   - Beam intersects or is very close to the panel plane

### Step 2: Insert the Connection Script

**Method 1: Command Line**
```
Command: hsbCLT-ProfileConnection
```

**Method 2: Toolbar/Menu**
- Navigate to hsbCAD → CLT → Profile Connection
- Click the icon

### Step 3: Select Elements

When prompted **"Select panel and beam"**:

1. Click on one or more CLT panels (Sip entities)
2. Click on the steel beam (must be a Beam with a profile assigned)
3. Press Enter to complete selection

**Selection Notes:**
- You can select multiple panels - a separate connection instance will be created for each panel
- Only one beam is used (if you select multiple beams, only the first will be processed)
- Minimum requirement: 1 panel + 1 beam

### Step 4: Adjust Parameters (Optional)

If the property dialog appears:

1. Review the default gap values
2. Adjust any parameters based on your project requirements
3. Click OK to proceed

**Quick Settings:**
- For tight fit: Reduce Main Vertical to 5 mm
- For fire protection clearance: Increase all gaps to 15-20 mm
- For smooth edges: Increase Facet to 20-25 mm
- For no chamfer: Set Facet to 0 mm

### Step 5: Review Results

After calculation:

1. **Panel edges are stretched** to meet the beam
2. **Cutouts are created** in the panel around the steel profile
3. **Connection marker** appears at the middle of the affected edges
4. **Properties can be adjusted** - select the connection object and modify gaps in OPM
5. **Automatic recalculation** occurs when you change parameters

### Step 6: Make Adjustments

If the result is not satisfactory:

**Change the beam:**
- Right-click on the connection object
- Select "Select new profile beam" from context menu
- Click on a different beam
- Connection recalculates automatically

**Adjust gaps:**
- Select the connection object
- Open Properties (Ctrl+1)
- Find "Gap values" category
- Modify any gap parameter
- Press Enter - connection updates automatically

**Delete connection:**
- If panels are re-joined or merged, duplicate connections are automatically deleted
- You can also manually delete the connection object

---

## Context Menu Options

Right-click on the connection object to access:

| Menu Item | Function |
|-----------|----------|
| **Select new profile beam** | Change the associated steel beam - prompts for beam selection and recalculates |

---

## Important Design Considerations

### Geometric Constraints

**Panel Orientation (Critical):**
The script validates that the panel's Z-axis (normal vector) is perpendicular to the beam's X-axis (longitudinal direction). If this check fails, you'll see the error:
- "panel skew not accepted"
- "panel can only be rotated wrt beam axis"

**Solution:** Rotate the panel so its face is perpendicular to the beam direction.

**Intersection Requirement:**
The panel (or its extension) must be able to intersect the beam. The script projects both the panel and beam onto a common plane to verify intersection. If they cannot intersect:
- "beam and panel not intersecting"
- "extension of the panel still cannot intersect the beam"

**Solution:** Move the panel closer to the beam, or adjust the beam position.

### Profile Detection

The script automatically detects the steel profile shape by analyzing the beam's cross-section:

- **Top Flange Detection:** Looks for horizontal material at the top of the section
- **Bottom Flange Detection:** Looks for horizontal material at the bottom
- **Web Detection:** Identifies the vertical connecting element
- **Inner Flanges:** For complex profiles (C-channels, double-T), detects internal geometry

**Supported Profile Types:**
- I-beams (HEA, HEB, IPE, IPN)
- H-sections (HD, HL, HP)
- U-channels (UPE, UAP)
- T-sections
- Custom profiles (as long as they have detectable flanges/web)

### Edge Stretching Behavior

**How edges are stretched:**
1. Script identifies the edge closest to the beam axis
2. All edges parallel and collinear with this edge are selected
3. Edges are stretched perpendicular to their length toward the beam
4. Stretching stops at the "Main Vertical Gap" distance from the beam web

**Multiple edges:** If your panel has multiple aligned edges (e.g., a panel split by joints), all aligned edges are stretched simultaneously to maintain panel continuity.

**Opening edges excluded:** Edges that belong to door or window openings are never stretched, preserving the opening geometry.

---

## Troubleshooting

### Common Error Messages

| Error Message | Cause | Solution |
|--------------|-------|----------|
| "no panel in selection" | No Sip (panel) entity was selected | Select at least one CLT panel |
| "no beam in selection" | No Beam entity was selected | Select a steel beam with a profile |
| "there are needed at least a beam and a panel" | Selection doesn't include both required entities | Select both a panel and a beam |
| "panel skew not accepted" | Panel normal is not perpendicular to beam axis | Rotate panel to be perpendicular to beam |
| "beam and panel not intersecting" | Panel cannot reach beam even after stretching | Move panel closer to beam |
| "center of beam at the same position as center of panel" | Beam center coincides with panel center | Adjust beam or panel position slightly |
| "no edge for calculation" | No valid panel edges found pointing toward beam | Check panel position and orientation |
| "unexpected error..." | Internal calculation error | Contact hsbCAD support with model file |

### Common Issues

**Issue: Connection doesn't create cutouts**

*Possible causes:*
- Panel is too far from the beam
- Panel orientation is incorrect
- Beam doesn't have a profile assigned
- Gap parameters are set too large

*Solutions:*
- Verify beam has a profile (check beam properties)
- Ensure panel normal is perpendicular to beam axis
- Move panel closer to beam
- Check gap values are reasonable (5-20 mm range)

**Issue: Cutouts are too large or too small**

*Cause:* Gap parameters need adjustment

*Solution:*
- Select the connection object
- Adjust gap values in Properties palette
- For tighter fit: reduce gaps to 5 mm
- For looser fit: increase gaps to 15-20 mm
- Connection updates automatically

**Issue: Chamfer cuts are missing**

*Cause:* Facet Gap is set to 0 or negative value

*Solution:*
- Select the connection object
- Set Facet Gap to 15 mm or higher
- Connection recalculates with chamfers

**Issue: Connection duplicates when editing panels**

*Behavior:* This is normal - when a panel is split, the script creates a new connection instance for each resulting panel piece

*If not desired:*
- Delete duplicate connections manually after panel editing
- Or re-run the script after all panel modifications are complete

**Issue: Panel edge doesn't stretch to beam**

*Possible causes:*
- Selected edge belongs to an opening
- Edge is pointing away from beam
- Edge is perpendicular to beam direction

*Solutions:*
- Check that panel edges can physically reach the beam
- Verify no openings are interfering with edge selection
- Try repositioning the panel

---

## Technical Details

### Script Behavior

**Parametric Recalculation:**
- Connection is parametric and linked to the beam
- If beam moves, connection recalculates automatically
- If beam is deleted, connection is erased
- If panel is split, new connection instances are created for each piece

**Dependency Tracking:**
- Connection sets dependency on the selected beam
- Uses `setDependencyOnEntity()` to track beam
- Uses `setEraseAndCopyWithBeams()` to handle panel splitting

**Duplicate Prevention:**
- Script automatically searches for existing connections with the same beam-panel pair
- Deletes duplicates if panels are re-joined

### Coordinate Systems

The script operates in multiple coordinate systems:

1. **World Coordinate System (WCS):** Initial reference
2. **Beam Local Coordinate System:**
   - X-axis: Along beam length
   - Y-axis: Across beam width
   - Z-axis: Beam height
3. **Panel Local Coordinate System:**
   - X, Y: In panel plane
   - Z: Perpendicular to panel (normal)
4. **Profile Coordinate System:**
   - Aligned with beam Y-Z plane
   - Used for detecting flanges and web

### Cutout Calculation Algorithm

**Step-by-step process:**

1. **Project panel and beam** onto a common plane to verify intersection
2. **Identify beam wall** (the edge of the steel profile facing the panel)
3. **Detect profile features:**
   - Scan for top flange (horizontal section at top)
   - Scan for bottom flange (horizontal section at bottom)
   - Identify web (vertical connecting section)
   - Detect any inner flanges (for C-channels, complex shapes)
4. **Calculate cutout for each feature:**
   - Top flange: Rectangle based on flange dimensions + Top Vertical + Top Horizontal gaps
   - Bottom flange: Rectangle based on flange dimensions + Bottom Vertical + Bottom Horizontal gaps
   - Web: Rectangle based on web dimensions + Main Vertical gap
5. **Generate facet cuts:**
   - 45° chamfer between top flange and web
   - 45° chamfer between bottom flange and web
   - Depth = Facet Gap parameter
6. **Apply all cuts** as BeamCut tools to the panel

### Visualization

The script displays:
- Connection marker at the middle of affected edges
- Color 252 (light gray) for visual representation
- Simplified envelope body at the connection location
- Updates dynamically when parameters change

---

## Related Scripts

| Script Name | Relationship | Purpose |
|------------|--------------|---------|
| **hsbCLT-Opening** | Complementary | Create door/window openings in panels (edges excluded from this script) |
| **hsbCLT-JointBoard** | Alternative | For timber-to-timber connections (not steel) |
| **hsbCLT-Drill** | Complementary | Add bolt holes for mechanical fasteners at the connection |
| **hsbCLT-Slot** | Complementary | Create slots for steel plate connections |
| **HSB_G-BillOfMaterial** | Downstream | Generate material lists including modified panels |

---

## Best Practices

### Design Phase

1. **Plan steel-CLT interface early** in the design process
2. **Standardize gap values** across your project for consistency
3. **Check fabrication capabilities** - verify your CNC machine can execute the chamfer cuts
4. **Consider fire protection** - larger gaps may be needed if fire protection will be applied
5. **Document gap standards** in your project specifications

### Modeling Phase

1. **Model beam profiles accurately** - use standard profile libraries (HEA, IPE, etc.)
2. **Position panels perpendicular to beams** before running the script
3. **Create openings first** - door/window openings should exist before running connection script
4. **Run script after panel positioning is finalized** to minimize recalculations
5. **Use catalog entries** for standard connection types (if available)

### Shop Drawing Phase

1. **Verify cutout dimensions** in shop drawings match design intent
2. **Check chamfer depths** are within CNC tool capabilities
3. **Ensure gap tolerances** are achievable with your fabrication equipment
4. **Include connection details** in panel shop drawings
5. **Mark steel beam locations** clearly on panel drawings

### Quality Control

1. **Visual inspection:** Check that cutouts fully clear the steel profile
2. **Clash detection:** Verify no interference between panel and beam
3. **Gap verification:** Measure gaps in 3D model to confirm they meet specifications
4. **Fabrication review:** Consult with fabricator on complex profiles
5. **Test fit:** For critical connections, consider full-scale mockups

---

## Example Use Cases

### Case 1: CLT Floor Panel to Edge Beam

**Scenario:** CLT floor panels spanning between steel edge beams (HEA 200)

**Parameters:**
- Top Vertical: 15 mm (clearance for tolerance)
- Top Horizontal: 10 mm
- Bottom Vertical: 10 mm
- Bottom Horizontal: 0 mm (panel sits flush)
- Main Vertical: 10 mm (tight fit to web)
- Facet: 20 mm (smooth transitions)
- Beam: 10 mm (end clearance)

**Workflow:**
1. Create CLT floor panels (200 mm thick)
2. Place HEA 200 beams along panel edges
3. Run hsbCLT-ProfileConnection
4. Select floor panel and edge beam
5. Adjust parameters as above
6. Result: Panel edge stretched to beam, cutouts for top and bottom flanges

### Case 2: CLT Wall Panel to Steel Column

**Scenario:** CLT wall panel connecting to steel column (HEB 300)

**Parameters:**
- Top Vertical: 20 mm (fire protection clearance)
- Top Horizontal: 15 mm
- Bottom Vertical: 20 mm
- Bottom Horizontal: 15 mm
- Main Vertical: 15 mm (looser fit for vertical alignment)
- Facet: 25 mm (prominent chamfer for aesthetics)
- Beam: 15 mm

**Workflow:**
1. Position vertical CLT wall panel
2. Place HEB 300 column intersecting panel plane
3. Ensure panel face is perpendicular to column axis
4. Run hsbCLT-ProfileConnection
5. Select wall panel and column (as beam)
6. Set parameters for generous clearances
7. Result: Panel cut to accommodate column with fire protection gaps

### Case 3: Multiple Panels to Single Beam

**Scenario:** Three CLT panels meeting at a single steel beam

**Parameters:**
- Standard gaps (Top/Bottom: 10 mm, Main: 10 mm, Facet: 15 mm)

**Workflow:**
1. Position three CLT panels around the beam
2. Run hsbCLT-ProfileConnection once
3. Select all three panels and the beam in one selection
4. Press Enter
5. Result: Three separate connection instances created, one per panel

### Case 4: C-Channel Connection

**Scenario:** CLT panel connecting to steel C-channel (UPE 200)

**Parameters:**
- Top Vertical: 10 mm
- Top Horizontal: 10 mm
- Bottom Vertical: 10 mm
- Bottom Horizontal: 5 mm
- Main Vertical: 10 mm
- Facet: 15 mm
- Beam: 10 mm

**Workflow:**
1. Place UPE 200 C-channel with opening facing the panel
2. Position CLT panel to intersect channel
3. Run hsbCLT-ProfileConnection
4. Result: Cutouts created for top flange, bottom flange, and web; inner flange geometry detected and accommodated

---

## Advanced Topics

### Catalog Integration

You can create catalog entries for standard connection types:

**Using Execute Key:**
If you launch the script with an execute key (e.g., from a custom command), the script will:
1. Check if the key matches a catalog entry name
2. If found, automatically apply those parameter values
3. If not found, use the last inserted values
4. If key is empty, show the property dialog

**Creating Catalog Entries:**
(Catalog functionality requires hsbCAD system setup - consult hsbCAD documentation)

### Scripting and Automation

**Silent Insertion:**
```
// AutoCAD command to insert with a catalog key
^C^C(defun c:PCONN_STD() (hsb_ScriptInsert "hsbCLT-ProfileConnection" "STANDARD")) PCONN_STD
```

This creates a command `PCONN_STD` that inserts the connection using the "STANDARD" catalog entry.

**Batch Processing:**
For multiple connections with the same parameters:
1. Create a catalog entry with your standard gaps
2. Use the execute key method to insert connections rapidly
3. Select beam-panel pairs sequentially

### Custom Profile Support

The script works with any beam profile, including:
- Standard steel profiles (HEA, HEB, IPE, IPN, UPE, etc.)
- Custom profiles created via ExtrProfile
- Asymmetric profiles
- Complex multi-flange profiles

**Requirements for custom profiles:**
- Profile must be assigned to the beam via `beam.extrProfile()`
- Profile must be a valid PlaneProfile that can be projected
- Script detects flanges and web automatically based on geometry

### Performance Optimization

For large projects with many connections:

1. **Use catalog entries** to skip the property dialog
2. **Group similar connections** and process together
3. **Finalize panel positions** before creating connections to minimize recalculations
4. **Avoid frequent parameter changes** on many connections simultaneously
5. **Use envelope bodies** (automatic) for faster display

---

## Summary

**hsbCLT-ProfileConnection** is a powerful tool for creating precise CLT-to-steel connections. Key points:

✓ **Automatic edge stretching** - Panel edges extend to meet the beam
✓ **Intelligent profile detection** - Handles I-beams, channels, custom profiles
✓ **Parametric cutouts** - Adjustable gaps for all connection features
✓ **Chamfer generation** - Smooth 45° transitions for clean fabrication
✓ **Multiple panel support** - Create connections for multiple panels at once
✓ **Dynamic recalculation** - Updates automatically when beam moves or parameters change
✓ **Quality validation** - Checks geometric constraints and provides clear error messages

**When to use this script:**
- Hybrid timber-steel construction
- CLT panels connecting to steel edge beams
- Steel columns penetrating CLT walls or floors
- Any situation requiring precise CLT cutouts around steel profiles

**Prerequisites:**
- CLT panels (Sip entities) created in the model
- Steel beams with assigned profiles (HEA, IPE, UPE, custom)
- Panels positioned perpendicular to beam axis
- Panels within stretching distance of beam

**Typical gap settings:**
- Tight fit (5-10 mm gaps): Precision-machined panels, controlled environment
- Standard fit (10-15 mm gaps): Normal construction tolerances
- Loose fit (15-25 mm gaps): Fire protection clearances, rough tolerances

For questions or support, consult the hsbCAD documentation or contact technical support.

---

*This documentation was generated for hsbCAD TSL Script: hsbCLT-ProfileConnection.mcr (Version 1.5)*
