# hsbRP_Analysis

Roof Plane Analysis Tool - Analyzes roof planes to identify intersection lines (ridge, hip, valley, eave) and calculates roof/eave areas with comprehensive reporting.

---

## Overview

**hsbRP_Analysis** is a comprehensive roof plane analysis script that automatically detects and generates roof lines (ridges, hips, valleys, gable ends, eaves) from selected roof planes. It also calculates roof areas and canopy (eave) areas, presenting results in a formatted table with graphical previews. The script creates satellite TSL instances (hsbRP_Roofline and hsbRP_EaveArea) to represent the analyzed geometry.

**Version:** 3.5
**Type:** O (Object Script)
**Required Beams:** 0

---

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object Script) |
| Space | Model Space |
| Paper Space | Not Supported |
| Requires Selection | Yes - Roof planes for analysis |
| Creates Child TSLs | hsbRP_Roofline, hsbRP_EaveArea |

---

## Prerequisites

- One or more **ERoofPlane** entities in the drawing
- Optional: Closed polyline defining the wall/building outline (for eave area calculation)
- Optional: Roof plane openings (ERoofPlaneOpening) or closed polylines representing openings
- Valid dimension styles (DimStyles) loaded in the drawing
- Optional: Hatch patterns loaded for area visualization

---

## Usage

### Insertion Workflow

1. **Start the command** - Launch the hsbRP_Analysis script via `TSLINSERT`
2. **Configure settings** - A dialog appears to configure units, colors, and grouping options
3. **Select roof planes** - Select all ERoofPlane entities to analyze. You can also select existing hsbRP_Roofline or hsbRP_EaveArea TSLs to delete them during this step
4. **Select openings (optional)** - Select roof plane openings or closed polylines that represent openings (skylights, dormers, etc.)
5. **Select wall outline (optional)** - Select a closed polyline representing the building's wall outline. This enables eave area calculation for canopy/overhang regions
6. **Place the table** - Click to specify the insertion point for the analysis table

### What the Script Generates

Upon insertion, the script:
- Analyzes all selected roof planes for intersection geometry
- Creates **hsbRP_Roofline** instances for each detected roof line:
  - **Ridge** - Horizontal intersections at the top between two roof planes
  - **Hip** - Upward-sloping intersections (forming an external corner)
  - **Valley** - Downward-sloping intersections (forming an internal corner)
  - **Eave** - Horizontal edges at the bottom of roof planes
  - **Gable End** - Vertical or steeply sloped edges at building ends
  - **Rising Eave** - Other sloped edge conditions
  - **Opening edges** - Top, bottom, left, right, and sloped edges of openings
- Creates **hsbRP_EaveArea** instances for:
  - Roof area polygons (each roof plane surface with gross/net calculations)
  - Canopy/eave areas (overhang areas outside the wall outline)
- Displays a comprehensive analysis table with lengths, angles, and areas

---

## Parameters (Properties Palette)

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group analysis BOM | String | (empty) | Group name for the analysis table. Use backslash (\\) to create hierarchy levels (e.g., "Reporting\\Roof") |
| Unit | Dropdown | mm | Display unit for lengths and areas: mm, cm, m, inch, feet |
| Decimals | Integer | 0 | Number of decimal places for length values (0-4) |
| Decimals Area | Integer | 2 | Number of decimal places for area values (0-4) |
| Color of table | Integer | 143 | AutoCAD color index for the analysis table |
| Dimstyle | Dropdown | (from drawing) | Dimension style for table text |
| Dimstyle Shopdrawing | Dropdown | (from drawing) | Dimension style for section drawings in the table |

### Roofline Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group Roofline | String | (empty) | Group name for generated roofline objects. Use backslash (\\) to separate levels |
| Color | Integer | 9 | AutoCAD color index for rooflines (range: -1 to 255) |

### Eave Area Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group Eave Area | String | (empty) | Group name for generated eave area objects |
| Color | Integer | 93 | AutoCAD color index for eave areas |
| Material | String | (empty) | Material designation for eave areas (shown in BOM) |
| Hatch pattern | Dropdown | None | Hatch pattern for eave area display |
| Hatch scale | Double | 30 mm | Scale factor for the hatch pattern |

### Roof Area Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group Roof area | String | (empty) | Group name for generated roof area objects |
| Color | Integer | 7 | AutoCAD color index for roof areas |
| Hatch pattern | Dropdown | None | Hatch pattern for roof area display |
| Hatch scale | Double | 30 mm | Scale factor for the roof area hatch pattern |

---

## Context Menu Commands

Right-click on the hsbRP_Analysis object to access these commands:

| Command | Description |
|---------|-------------|
| **Delete Rooflines** | Select and delete specific hsbRP_Roofline instances from the analysis |
| **Delete Eave Areas** | Select and delete specific hsbRP_EaveArea instances from the analysis |
| **Delete All** | Select and delete both rooflines and eave areas at once |
| **Generate Rooflines** | Regenerate all rooflines based on current roof plane geometry |
| **Add individual Roofline** | Manually add a roofline by picking two points and selecting associated roof plane(s) |
| **Generate Eave Areas** | Regenerate eave areas (requires wall outline polyline to have been selected during insertion) |
| **Add Area by Polyline** | Add a custom area by selecting a polyline and projecting it onto roof planes |
| **Generate all** | Regenerate both rooflines and all area calculations |
| **Add opening** | Add roof openings by selecting ERoofPlaneOpening entities or closed polylines |

---

## Analysis Table Contents

The generated table includes multiple sections:

### Roofline Section
| Column | Description |
|--------|-------------|
| Name | Type of roofline (Ridge, Hip, Valley, Eave, Gable End, Rising Eave, Opening edges) |
| Pos | Position number of the roofline |
| Length | Total length in selected units (grouped by type and angle) |
| Base angle | Slope angle of the roof plane |
| Hip/valley | Hip or valley angle at intersections |
| Section | Cross-section drawing if a beam is linked to the roofline |
| Bend angle | Bend angle for flashing or other sheet materials (calculated as 180 minus hip/valley angle) |

### Area Section
| Column | Description |
|--------|-------------|
| Name/Material | Roof area name or eave area material designation |
| Brut | Gross area (before subtracting openings) |
| Net | Net area (after subtracting openings) |
| Diff. Area | Difference between gross and net area (opening area) |
| Preview | Scaled graphical preview of the area shape |

---

## Tips

1. **Preparing Roof Planes**: Ensure your ERoofPlane entities are correctly oriented before analysis. The script uses the roof plane normal vectors to determine hip vs. valley lines.

2. **Wall Outline Polyline**: For accurate eave/canopy area calculation, create a closed polyline at the same Z-level as the roof eave that represents the outer wall face. This polyline will be projected vertically to intersect with each roof plane.

3. **Opening Detection**: The script automatically detects:
   - ERoofPlaneOpening entities within selected roof planes
   - Closed polylines that fall within roof plane boundaries
   - Opening edges are labeled by position (top, bottom, left, right, sloped)

4. **Regenerating Analysis**: After modifying roof planes, use the context menu commands to regenerate specific elements rather than deleting and reinserting the entire analysis.

5. **Group Organization**: Use the backslash separator (\\) in group names to create hierarchical organization. For example: "Roof Analysis\\Lines" creates a nested group structure in the Project Browser.

6. **Single Roof Planes**: The script supports analysis of single roof planes (v3.2+). In this case, only eave and gable end lines are generated without intersection lines.

7. **Overlapping Rooflines**: Duplicate or overlapping rooflines are automatically removed during analysis (v3.1+).

8. **Linked Beams**: If hip or valley rafters are linked to rooflines, the table will display a cross-section view of the beam where it intersects the roofline, complete with dimensions.

9. **Units**: The script automatically converts values using `U()` to ensure compatibility with both metric and imperial templates.

10. **Table Placement**: The table grows downward and to the left from the insertion point. Choose a location with sufficient space for all the data rows.

11. **Updating Properties**: After insertion, you can modify any property in the Properties Palette and the analysis will automatically recalculate.

---

## Related Scripts

- **hsbRP_Roofline** - Child script representing individual rooflines with length, angle, and slope data
- **hsbRP_EaveArea** - Child script representing roof areas and eave/canopy areas with area calculations

---

## FAQ

**Q: Where does the report table appear?**
A: The report table is generated at the point you specify during insertion. If you cannot find it, use Zoom Extents to locate all generated geometry.

**Q: How do I change the units after insertion?**
A: Select the script instance in the model, open the Properties Palette (Ctrl+1), and change the "Unit" property. The table will update automatically.

**Q: Why are my hatches not displaying?**
A: Ensure the "Hatch pattern" is set to something other than "None" and that the pattern is loaded in your current drawing.

**Q: Can I analyze a single roof plane?**
A: Yes, since version 3.2 single roof planes are supported. The analysis will identify eave and gable end lines without requiring multiple intersecting planes.

**Q: How do I add an opening after initial analysis?**
A: Right-click the analysis object and select "Add opening" from the context menu, then select the opening geometry.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.5 | 19-May-2015 | Bugfix for sum calculation |
| 3.4 | 18-May-2015 | Duplicate row removed from table |
| 3.3 | 20-Apr-2015 | New column to display bend angle |
| 3.2 | 10-Apr-2014 | Single roof planes now supported |
| 3.1 | 03-Apr-2014 | Overlapping rooflines are automatically removed |
| 3.0 | 15-May-2013 | Tolerance for touching roof planes increased |
| 2.9 | 16-Feb-2012 | Bugfix canopy area total |
| 2.8 | 09-Jan-2012 | Bugfix ridge/hip roof line detection |
| 2.7 | 12-Dec-2011 | Bugfix canopy area total |
| 2.6 | 11-Feb-2011 | Bugfix in compliance with hsbRP_Roofline v2.3 |
| 2.5 | 04-Nov-2010 | Added context commands for special areas and individual rooflines |
| 2.4 | 20-Aug-2008 | Fixed units for area calculation in specific drawing units |
| 2.3 | 22-Jun-2007 | Added brut/net difference to table |
| 2.2 | 22-Jun-2007 | Compatibility with hsbCAD release 12.5 |
| 2.1 | 21-Jun-2007 | Bugfix for schedule data roof areas |
| 2.0 | 23-Mar-2007 | Bugfix roofplane detection; graphics column scales to max roof dimension |
| 1.9 | 22-Mar-2007 | Added roofplane openings, free openings support, brut/net areas |
| 1.8 | 26-Feb-2007 | Extended table with separate listings and previews |
| 1.7 | 20-Feb-2007 | Complete table revision with beam sections |
| 1.6 | 16-Jan-2007 | Added DXI export support |
| 1.5 | 04-Dec-2006 | Documentation clarification for group separators |
| 1.4 | 07-Nov-2006 | Added hatch pattern support |
| 1.0 | 28-Apr-2005 | Initial release |
