# NA_WALL_SHOP_DRAWING

## Overview

**NA_WALL_SHOP_DRAWING** is a comprehensive shop drawing generation tool for North American stick-frame wall elements. It consolidates what previously required multiple separate TSL scripts into a single, unified tool that automatically produces complete fabrication documentation from a wall element.

When placed on a Paper Space layout containing a wall elevation viewport, this script generates:

- **Top View**: A section cut through the top plate region, showing framing member outlines, sheathing profiles, and dimension lines
- **Bottom View**: A section cut through the bottom plate region with framing outlines, anchor positions, and dimension lines
- **Elevation View Annotations**: Wall height dimensions, sheathing overhang dimensions, hold-down locations, and opening dimensions
- **Framing Cut List**: A tabular schedule of all lumber in the wall, sorted alphabetically by type with labels, quantities, sizes, and lengths
- **Opening Tags**: Hexagonal labels at each opening with rough opening dimensions, head height, sill height, and optional assembly numbers
- **Sheathing Schedule**: A list of sheet materials with quantities, widths, heights, and zone indicators
- **Hardware Schedule**: An itemized list of connectors, hold-downs, anchors, and other hardware with model names and quantities
- **Electrical Schedule**: A list of electrical boxes with wall face, model name, and height from the bottom plate
- **Plumbing Schedule**: Pipe and fitting items with diameters, lengths, and stud-bay location references
- **Penetrations Schedule**: Drill holes in framing members listed with diameters and ordinal positions
- **Hatching Legend**: A visual key distinguishing front-face and back-face blocking/studs using configurable hatch patterns

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) -- Paper Space annotation |
| Environment | Paper Space (Shop Drawings) |
| Required Beams | 0 (operates on viewport element) |
| DXA Output | Yes (exportable for fabrication) |
| Implicit Insert | Yes |
| Version | 0.81 (October 2024) |

---

## Prerequisites

Before using this script, ensure the following conditions are met:

1. **Complete Wall Element in Model Space**
   - The wall must contain fully placed framing: top plates, bottom plates, studs, headers, sills, blocking, and cripples as needed.
   - Openings (doors and windows) should be defined with proper rough opening geometry.

2. **Elevation Viewport in Paper Space**
   - An elevation viewport of the target wall must already exist on the Paper Space layout sheet. The script reads framing and geometry data through this viewport.

3. **Dimension Style**
   - The drawing must contain a dimension style named **"Wall Shopdrawing"**. This style controls text height, arrow size, and unit formatting for all generated annotations.
   - Optionally, a style named **"Wall Shopdrawing Italic"** can be defined. When present, back-face sheathing labels and back-face legend text render in italic for visual distinction.

4. **Companion TSLs (Optional)**
   - **Electrical box TSLs**: Scripts that populate the `"ElectricalItems"` MapObject dictionary entry. Without these, the electrical schedule will be empty.
   - **Plumbing TSLs**: Scripts that populate the `"PlumbingItems"` MapObject dictionary entry. Without these, the plumbing schedule will be empty.
   - **Window KPN assignment TSLs** (`KT_PRJ_ASSIGN_WINDOW_KPN`): Provides assembly numbers for openings. Without this, assembly numbers will fall back to the opening description field.
   - **Hold-down TSLs** (`GE_HDWR_WALL_HOLD_DOWN`): Provides hold-down positions for left/right elevation dimensioning.
   - **Blocking area TSLs** (`KT_WALL_NO_STUD_AREA_BLOCKING`): Provides special MASA blocking positions for hardware dimensioning.

---

## Step-by-Step Usage Guide

### Inserting the Script

1. Switch to **Paper Space** on the layout sheet where the wall shop drawing is being assembled.
2. Confirm that an **elevation viewport** of the target wall is already placed on this layout.
3. Launch the **NA_WALL_SHOP_DRAWING** script.
4. Respond to the three command-line prompts in order:
   - **"Select top left corner of a drawing"** -- Click the point where the framing cut list table header should begin. All schedule tables are positioned relative to this point.
   - **"Select elevation viewport"** -- Click on the elevation viewport that shows the front face of the wall.
   - **"Select grip point for hatching legend"** -- Click where you want the front/back face hatching legend box to appear.
5. The script immediately generates all drawing components: views, schedules, tags, dimensions, and legend.

### Repositioning Drawing Elements After Placement

Each schedule list has a dedicated **grip point** that can be dragged to a new location:

| Grip Index | Controls |
|------------|----------|
| 0 | Opening Tags list position |
| 1 | Sheathing Schedule position |
| 2 | Hardware Schedule position |
| 3 | Electrical Schedule position |
| 4 | Plumbing Schedule position |
| 5 | Penetrations Schedule position |

To reposition a schedule, select the TSL instance, then drag the corresponding grip point.

The **Hatching Legend** is repositioned through the right-click context menu (see Right-Click Menu Options below).

### Modifying Properties

1. Select the TSL instance in Paper Space.
2. Open the **Properties Palette** (Ctrl+1).
3. Adjust parameters as needed. The drawing regenerates automatically when any property value changes.

---

## Properties Panel Parameters

### General Settings

| Parameter | Default | Description |
|-----------|---------|-------------|
| Section line offset Bottom view | 1.5" | Distance from the bottom plate face at which the bottom section cut is taken. Increasing this value moves the cut line further into the wall, potentially capturing more framing detail. |
| Section line offset Top view | 1.5" | Distance from the top plate face at which the top section cut is taken. |
| Max Cut List rows | 19 | Maximum number of rows in the primary cut list column before overflow items wrap to a second column. Minimum enforced value is 14. Reduce this if the cut list table overlaps other drawing elements. |
| Max blocking positions until new line | 2 | Maximum number of blocking height positions shown on a single cut list row before wrapping to a new line. Set to 0 to keep all positions on one line. |
| Adjust Electrical list position | Yes | When "Yes", the electrical schedule is positioned to the right of the cut list instead of below the hardware list. When "No" (forced when a second cut list column exists), it stacks below the hardware schedule. |
| Show Trimmers | Yes | When "Yes", trimmer studs flanking openings are drawn in the top view. |
| Show Vt Non-Touching Beams | Yes | When "Yes", vertical framing members that do not contact either the top or bottom plates are shown and dimensioned in the elevation view. |
| Top view offset | 1.25" | Vertical gap between the top of the elevation viewport and the bottom edge of the top section view. |
| Top view dim offset | 0.2" | Offset of dimension lines from framing outlines in the top section view. |
| Bottom view offset | 1" | Vertical gap between the bottom of the elevation viewport and the top edge of the bottom section view. |
| Bottom view dim offset | 0.2" | Offset of dimension lines from framing outlines in the bottom section view. |
| Use Posnum | No | When "Yes", beams are sorted and labeled using their hsbCAD position number instead of automatic alphabetic assignment. The position number also appears as a column in the cut list. |

### Front Face Hatch Category

These settings control the hatch pattern applied to blocking and studs on the **front face** (zone 1) of the wall, both in the elevation view and in the legend.

| Parameter | Default | Description |
|-----------|---------|-------------|
| Pattern | ANSI31 | The AutoCAD hatch pattern name used for front-face elements. Select from available patterns in the drawing. |
| Angle | 180 | Rotation angle in degrees for the front-face hatch pattern. |
| Scale | 0.25 | Scale factor for the front-face hatch pattern (unitless). Adjust to make pattern denser or sparser. |

### Back Face Hatch Category

These settings control the hatch pattern applied to blocking and studs on the **back face** (zone -1) of the wall.

| Parameter | Default | Description |
|-----------|---------|-------------|
| Pattern | ANSI31 | The AutoCAD hatch pattern name used for back-face elements. |
| Angle | 90 | Rotation angle in degrees for the back-face hatch pattern. Using a different angle from the front face helps distinguish the two visually. |
| Scale | 0.25 | Scale factor for the back-face hatch pattern (unitless). |

### Blocking Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| Measure up to | Center | Reference point for reporting blocking height in the cut list. Options: **Bottom** (bottom edge of blocking), **Center** (midpoint), **Top** (top edge). |
| Do dimensions | No | When "Yes", adds dimension lines in the elevation view from the bottom plate to each blocking row. |
| Do horizontal dimline | No | When "Yes" (and "Do dimensions" is also "Yes"), draws a horizontal reference line at each blocking height. |

### Sheathing Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| Filter sheets by | Front and Back | Controls which sheathing zones appear in the schedule. **"Front and Back"**: shows zones 1 and -1. **"Use zone index"**: shows only the zone specified by the Zone index parameter. **"All zones"**: shows every zone. |
| Zone index | 1 | The specific zone number to display when "Filter sheets by" is set to "Use zone index". Valid values: 1 through 5 and -1 through -5. |
| Dash line color | 8 | AutoCAD color index used for dashed-line representation of filler outlines and non-primary zone sheets. Color 8 is dark gray by default. |
| Draw other sheet zones | Yes | When "Yes", sheets from zones not selected by the filter are still drawn in the top and bottom views but are dimmed and use italic text labels. When "No", non-selected zone sheets are hidden entirely. This option is hidden when "Filter sheets by" is set to "All zones". |

### Openings Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| Show full tag at opening | No | When "Yes", the complete tag information (RO dimensions, head/sill heights) is displayed directly at the opening center in the elevation view. When "No", tags appear in a separate list at the Opening Tags grip point. |
| Show assembly number | No | When "Yes", the opening assembly/KPN number is displayed in the tag. Items not shop-installed are annotated "FIELD INSTALLED". Shop-installed items with a recorded weight display "Weight: X.XX lbs". |
| Tag label format | (empty) | A comma-separated list of format codes applied to openings. If a format produces a valid result, it becomes the tag label. If left empty, the script assigns automatic alphabetic labels (A, B, C, ..., Z, AA, AB, ...) based on left-to-right, top-to-bottom sorting. |

### Legend Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| Hatch scale overall | 1.0 | A multiplier applied to the hatching legend display. Values greater than 1.0 enlarge the legend; values less than 1.0 shrink it. The legend includes two sample boxes: one with the front-face hatch labeled "front face" and one with the back-face hatch labeled "back face", each showing the text "BA" (for Blocking Area). |

### Floating Members Settings

| Parameter | Default | Description |
|-----------|---------|-------------|
| Floating Verticals Definition | #None | A Painter Definition name that identifies floating vertical members (members not attached to standard framing). When set to a valid definition, matching members are highlighted in the views. Select "#None" to disable. |
| Dimension Floating Verticals at Top & Bottom Views | No | When "Yes", adds dimension annotations for floating vertical members in both the top and bottom section views. |

---

## Right-Click Menu Options

Right-click the TSL instance to access the following context menu commands:

### Set Grip Override for All Walls

Applies the current grip position of a specific schedule to **every** NA_WALL_SHOP_DRAWING instance in the project. This is useful for ensuring consistent schedule placement across all wall shop drawing sheets.

Available override commands:
- Set grip override for all walls: Opening Tags
- Set grip override for all walls: Sheathing List
- Set grip override for all walls: Hardware List
- Set grip override for all walls: Electrical List
- Set grip override for all walls: Plumbing List
- Set grip override for all walls: Penetrations List

### Remove Grip Override for All Walls

Removes a previously set global grip override, returning each instance to its default auto-positioned or locally adjusted location.

Available removal commands:
- Remove grip override for all walls: Opening Tags
- Remove grip override for all walls: Sheathing List
- Remove grip override for all walls: Hardware List
- Remove grip override for all walls: Electrical List
- Remove grip override for all walls: Plumbing List
- Remove grip override for all walls: Penetrations List

### Move Hatching Legend

Opens an interactive prompt: **"Select point for hatching legend"**. Click a new location to reposition the front/back face hatching legend. The penetrations schedule position is also calculated relative to the legend, so moving the legend may shift the penetrations schedule.

---

## Generated Output Components

### Framing Cut List

The cut list is a table positioned at the insertion point (`_Pt0`) with the following columns:

| Column | Content |
|--------|---------|
| Timber | Beam type name (Stud, Top Plate, Bottom Plate, VTP, VBP, Header, Sill, Cripple, Filler, Blocking, MASA Blocking, etc.) |
| Size | Lumber cross-section and grade (e.g., "2x6 SPF"). Engineered products (OSB, ZIP, PLY, GYP, LSL, LVL, GLB, PSL) display actual measured dimensions. |
| Lab. | Alphabetic label assigned to each unique beam (A, B, C, ... Z, AA, AB, ...) |
| Qty | Count of identical pieces sharing the same type, size, and length |
| No | Position number (from hsbCAD posnum) |
| Length | Cut length of the member |
| Blocking Pos. | Height position(s) of blocking rows, measured to Bottom, Center, or Top per the "Measure up to" setting |

Sorting logic:
- Blocking entries are listed first (sorted alphabetically by type/size/length).
- All other beams follow (also sorted alphabetically).
- When the row count exceeds "Max Cut List rows", overflow rows are drawn in a second column to the right.

Beam type simplification rules:
- "Left stud" and "Right stud" are both displayed as **Stud**.
- "Cripple stud", "Jack over opening", and "Jack under opening" are all displayed as **Cripple**.
- Beams with "MASA" in their hsbId are prefixed with **MASA** (e.g., "MASA Blocking").
- Very Top Plates are labeled **VTP**; Very Bottom Plates are labeled **VBP**.
- Filler beams (types 20, 37, 125, 126 or beams whose grade/material/name contains OSB, ZIP, or GYP) are labeled **Filler**.

### Opening Tags

Each opening receives a hexagonal tag at its center in the elevation view. If "Show full tag at opening" is "No", a duplicate tag is placed at the Opening Tags grip point with detailed information stacked below it:

- **RO**: Rough opening width x height (measured from framing faces, not opening definition geometry)
- **Head**: Height from bottom plate to underside of header
- **Sill**: Height from bottom plate to top of sill member (displayed as 0 if under 3 inches)
- **Assembly #**: The KPN assignment (if enabled and available), with "FIELD INSTALLED" for non-shop items
- **Weight**: Window weight in pounds (for shop-installed items with recorded weight)

Openings are sorted left-to-right and then top-to-bottom before label assignment.

### Sheathing Schedule

A table with columns: Material, Qty, Width, Height, Num (position number). Identical sheets (same material, dimensions, and posnum) are grouped and counted. Labels appear as circled position numbers in the elevation view. Zone 1 labels are drawn in color 1 (red); other zone labels are drawn in color 4 (cyan) with italic text (if the italic dimension style exists).

### Hardware Schedule

A table with columns: Lab., Qty, Model. Each unique hardware item receives a label (H1, H2, H3, ...) with a leader line from the hardware location in the elevation view to the label. The schedule excludes nails, electrical items, and plumbing items. Hardware data is also recorded into the element's SubMapX for export and downstream processing.

Special handling:
- Beam pockets (beams hosted in other beams) are detected and dimensioned in the elevation view.
- ATS (All-Thread System) hardware items are identified and labeled separately.
- Hold-down hardware (`GE_HDWR_WALL_HOLD_DOWN`) contributes to left/right elevation dimension chains.

### Electrical Schedule

A table with columns: Lab., Qty, Model, Height. Electrical box data is read from the `"ElectricalItems"` MapObject dictionary. Each box is labeled (E1, E2, ...) and its display geometry is drawn in the elevation view. The height column shows the distance from the bottom plate to the box origin. The model column includes the wall face (Front/Back) and box name/KPN.

### Plumbing Schedule

A table with columns: Lab., Qty, Type, Model, Diameter, Length, Stud Bay. Plumbing data comes from the `"PlumbingItems"` MapObject. Pipes are drawn in the elevation view with incrementing colors. Each pipe also includes a stud-bay reference identifying which stud bay the pipe passes through. Fittings are listed without a length value.

### Penetrations Schedule

A table with columns: Lab., Diam., No. (beam label), Ordinal pos. (horizontal or vertical position). Drill holes are scanned from:
1. **Bottom plates** -- labeled o1, o2, ... with markers in the bottom view. Position reported as "H: distance" (horizontal from wall start).
2. **Top plates** -- continuing the numbering, with markers in the top view.
3. **Vertical studs** -- with markers in the elevation view. Position reported as "V: height" (vertical from bottom plate).
4. **Other members** (GenBeams, sheets) -- remaining drill holes from non-plate, non-stud members.

---

## Automatic Layout Adjustments

The script performs several automatic layout adjustments to avoid overlapping:

1. **Long walls (over 17 feet)**: The opening tag list is moved to align with the left edge of the layout border. The sheathing and hardware schedules are shifted to the right to avoid overlapping the elevation view.

2. **Cut list overflow**: When the cut list exceeds "Max Cut List rows", a second column is created to the right of the first. The electrical list position is adjusted accordingly.

3. **Overlap detection**: The script computes bounding regions (PlaneProfiles) for the elevation view, top view, and bottom view. If the sheathing or hardware schedule would overlap with a view, it is automatically repositioned.

4. **Reversed elevation viewports**: The script detects when the elevation viewport has a reversed X-axis (mirrored view) and adjusts dimension text direction, left/right elevation dimension placement, and sheathing overhang calculations accordingly.

---

## Data Export and Integration

The script records framing and hardware data into shared data structures for use by other TSLs and export processes:

- **Beam labels and type overrides**: Stored in the `"moEntityInfo"` MapObject under a map keyed by the element handle. When the element is in an Xref, data is stored under the Xref block reference handle.
- **Hardware schedule data**: Stored in the element's SubMapX under the key `"Hardware"`, or in the `"moEntityInfo"` MapObject for Xref scenarios.

This data enables downstream tools such as element BOM generators and info panels to access beam labeling and hardware information without re-parsing the framing.

---

## Tips and Best Practices

1. **Dimension Style Setup**: Create the "Wall Shopdrawing" dimension style before inserting this TSL. Configure text height, arrow style, and unit precision to suit your sheet scale. For back-face distinction, also create "Wall Shopdrawing Italic" as an italic variant.

2. **Large Walls**: For walls exceeding 17 feet in length, the script automatically adjusts schedule positions, but manual grip adjustments may still be needed for optimal appearance.

3. **Consistent Layouts**: Use the "Set grip override for all walls" context menu to apply a schedule position across all wall shop drawings in the project. This ensures a uniform look when printing multiple sheets.

4. **Actual vs. Nominal Sizes**: Materials with grades or names containing OSB, ZIP, PLY, GYP, LSL, LVL, GLB, or PSL are displayed with actual measured dimensions rather than nominal lumber sizes.

5. **Cut List Management**: If the cut list is too tall, reduce "Max Cut List rows" to force an earlier split into two columns. If blocking positions cause excessive row wrapping, adjust "Max blocking positions until new line".

6. **Sheathing Visibility**: If sheets are missing from the schedule, check the "Filter sheets by" setting. Try "All zones" to confirm the sheets exist. Sheets on zone index 0 are always excluded.

7. **Forcing Recalculation**: The drawing updates automatically when properties change, grip points move, or the source wall element is modified. To force a manual recalculation, change any property value or issue the REGEN command.

8. **Metric Projects**: The script defaults to inches (`U(1, "inch")`) but respects the drawing unit system through the `U()` function. All dimensions are formatted using the dimension style unit settings.

---

## Frequently Asked Questions

### Why are some beams missing from the cut list?

The script categorizes beams by their hsbCAD beam type. Non-standard or unrecognized beam types may not appear in the expected category. Verify beam type assignments in hsbCAD. Also, dummy beams (`_kDummyBeam`) are excluded from all schedules.

### How do I change the opening label format?

Set the **"Tag label format"** property to a comma-separated list of format codes. The script tries each format in order using the opening's `formatObject()` method. The first format that produces a valid (non-identical-to-format) result becomes the label. If all formats fail, the label shows "N/A". If the property is left empty, automatic alphabetic labeling is used.

### Why is my sheathing not showing?

Check these settings in order:
1. **"Filter sheets by"** -- If set to "Use zone index", the "Zone index" must match your sheet's actual zone assignment.
2. **"Draw other sheet zones"** -- If "No", non-matching zone sheets are completely hidden.
3. Sheets on **zone index 0** are always excluded regardless of filter settings.

### The schedules overlap with my views. How do I fix this?

- Reduce **"Max Cut List rows"** to make the primary cut list shorter.
- Drag individual schedule grip points to new positions.
- Use the "Set grip override for all walls" context menu to lock positions consistently.
- For walls over 17 feet, the script auto-adjusts, but manual refinement may be needed.

### How do I dimension blocking positions?

Enable **"Do dimensions"** in the Blocking category. Set **"Measure up to"** to specify whether blocking height is measured to the bottom edge, center, or top edge of the blocking member. Optionally enable **"Do horizontal dimline"** to draw a reference line at each blocking elevation.

### Why are penetrations not showing?

The penetrations schedule reads drill tool data from `AnalysedDrill` on each framing member. Ensure drills are applied as proper hsbCAD drill tools (not just geometric cuts or boolean subtractions). Only drills with valid diameter and position data appear in the schedule.

### How do I get electrical/plumbing items to appear?

These schedules read from shared MapObject dictionaries (`"ElectricalItems"` and `"PlumbingItems"`). The corresponding companion TSLs must be active on the wall element and must have populated these dictionaries before this shop drawing script recalculates.

### Can I export the shop drawing data?

Yes. The script has DXA output enabled (`#DxaOut 1`). Beam labels, type overrides, and hardware schedules are recorded into MapObject and SubMapX structures that downstream export tools can read.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| V0.81 | Oct 2024 | Added property to draw and dimension floating members on bottom and top views |
| V0.80 | Jul 2023 | Added property to specify custom formats for opening tags |
| V0.79 | Apr 2023 | Added property to use posnum during sorting and labeling |
| V0.78 | Oct 2022 | Added max blocking positions per line setting |
| V0.77 | May 2022 | Added PLY to actual size grades |
| V0.76 | May 2022 | Added PSL to actual size grades |
| V0.75 | Apr 2022 | Corrected dimline text direction for reversed elevation viewports |
| V0.74 | Apr 2022 | Corrected left/right elevation dims and sheathing overhangs for reversed viewports |
| V0.71 | Feb 2022 | Added option to show vertical dimension of non-touching beams |
| V0.70 | Oct 2021 | Added support for angled headers |
| V0.68 | Oct 2021 | Added show full tag at opening, show assembly number, and legend scale options |
| V0.67 | Sep 2021 | Added option to hide non-selected zone sheathing |
| V0.66 | Sep 2021 | Added configurable front/back hatch patterns and blocking dimension options |
| V0.65 | Aug 2021 | Hatching legend with control point and right-click repositioning |
| V0.54 | Oct 2020 | Added hatching legend |
| V0.52 | Oct 2020 | Flat stud hatching, alphabetical cut list sorting |
| V0.50 | Sep 2020 | Auto-reposition schedules for walls over 17 feet |
| V0.47 | Sep 2020 | Penetration schedule completed |
| V0.43 | Aug 2020 | Top and bottom views drawn without separate viewports |
| V0.1 | Dec 2018 | Initial release consolidating wall shop drawing functionality |
