# NA_DIM_GENBEAMS_REFERENCED_TO_GENBEAM_STACK

## Overview

This script generates automatic dimensioning on shop drawings that measures beam and sheet positions relative to a reference beam stack. It detects groups of beams that form stacks (parallel beams connected end-to-end or side-by-side), then creates dimension lines showing how other framing members relate spatially to those stacks.

Typical use cases include dimensioning stud positions relative to top/bottom plates, measuring blocking locations relative to a header assembly, or showing joist spacing from a rim board stack.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Environment | Paper Space (Shop Drawings) |
| Requires Beams | No (uses viewport association) |
| Version | 0.19 |
| Language Support | English (en-US), French Canadian (fr-CA) |
| Unit System | Metric and Imperial (auto-detected) |

## Prerequisites

1. A Paper Space layout with a viewport displaying an hsbCAD Element (wall, floor, or roof)
2. The element must contain beams or sheets to dimension
3. Painter Definitions of type "GenBeam" (optional, for filtering specific beam types)
4. An appropriate AutoCAD dimension style loaded in the drawing (default: "NA Shopdrawing")

## Step-by-Step Usage

### Inserting the Script

1. Switch to a Paper Space layout tab
2. Run the script from the hsbCAD TSL menu or command line
3. When prompted, click on the viewport containing the element you want to dimension
4. A properties dialog opens with all dimension settings organized into four categories
5. Configure the settings and click OK to place the dimension
6. The script only allows one insertion cycle; repeated insertion attempts are blocked

### Editing After Placement

**Via Properties Dialog:**
Right-click the TSL instance and select "Edit dimension properties" to reopen the full settings dialog.

**Via Grip Points:**
Select the TSL instance and drag the grip point to reposition the dimension line. Each detected beam stack gets its own grip point. The dimension recalculates automatically when the grip is released.

## Properties Reference

### Dimension Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimensioned entities | Dropdown | Dimensioned beams/sheets in stack | Controls which entities appear in the dimension (see modes below) |
| Hatch pattern | Dropdown | None | Optional hatch applied to dimensioned and reference beams for visual clarity |
| Hatch scale | Number | 1.0 | Scale factor for the hatch pattern (automatically adjusted by viewport scale) |
| Hatch angle | Angle | 0 | Rotation angle for the hatch pattern |
| Hatch colour | Integer | -1 | AutoCAD color index; -1 uses the TSL instance color |
| Hatch transparency | Integer | 60 | Transparency percentage when hatch is set to SOLID |

**Dimensioned Entities Modes:**

| Mode | Behavior |
|------|----------|
| Dimensioned beams/sheets and stack | Dimensions filtered beams referenced to stack, plus stack overall dimensions |
| Stack only | Only the overall stack reference dimensions, no individual beam dimensions |
| Dimensioned beams/sheets in stack | Dimensions beams that belong to the stack, plus stack overall dimensions |
| Dimensioned beams/sheets in stack only | Dimensions beams that belong to the stack, without overall stack dimensions |
| Dimensioned beams/sheets touching stack | Dimensions beams that physically touch the stack |

### Beams/Sheets to Dimension

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element zone | Dropdown | Zone 0 | Zone filter: 0 = inside element container; 1-5 = front/top zones; -1 to -5 = back/bottom zones |
| Include filter | Dropdown | None | Painter Definition (GenBeam type) to include only matching beams |
| Exclude filter | Dropdown | None | Painter Definition (GenBeam type) to remove matching beams from the result |
| Points to dimension | Dropdown | Start point | Which points on each beam to measure: Start, Middle, End, Start and End, or All points |
| Beam/Sheet side | Dropdown | Closest edge | Which face of the beam to measure: Entire beam/sheet, Closest edge, or Furthest edge relative to the dimension line |

When both Include and Exclude filters are active, the script first collects beams matching the Include filter, then removes any that also match the Exclude filter.

### Stacked Beams/Sheets (Reference Stack)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element zone | Dropdown | Zone 0 | Zone filter for reference stack beams |
| Include filter | Dropdown | None | Painter Definition to include specific stack members |
| Exclude filter | Dropdown | None | Painter Definition to exclude specific stack members |
| Points to reference | Dropdown | Start and end points | Reference points on the stack: Start, End, Start and End, or All |
| Beam/Sheet side | Dropdown | Closest edge | Which face of the stack to use as reference |

### Dimension Style and Positioning

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension orientation | Dropdown | Top of stack | Place dimension at top/left or bottom/right of the stack |
| Dimension direction | Dropdown | Normal | Normal (left-to-right, bottom-to-top) or Reverse |
| Dimension type | Dropdown | Cumulative | Delta (incremental between adjacent points) or Cumulative (running from a baseline) |
| Dimension line offset | Length | 5/32" / 4mm | Distance from the offset reference to the dimension line, in paper space units |
| Offset type | Dropdown | Beam Stack | Offset reference: Beam Stack, Viewport edge, or Element framing edge |
| Project points | Dropdown | No | Whether to project dimensioned points perpendicular onto the dimension line |
| Dimension style | Dropdown | NA Shopdrawing | AutoCAD dimension style to use |
| Text height | Length | 0 | Override text height in paper space units; 0 uses the style default |
| Text side | Dropdown | Away from dimensioned points | Text position relative to the dimension line |
| Text orientation | Dropdown | Perpendicular | Text rotation: Parallel or Perpendicular to the dimension line |

## Right-Click Menu

| Menu Item | Description |
|-----------|-------------|
| Edit dimension properties | Opens the full properties dialog |
| Add properties override for current element | Creates element-specific settings that override the defaults for the current viewport element |
| Remove properties override for current element | Deletes the element-specific override, reverting to default settings |
| Reset grip points for current element | Resets dimension line positions to their automatic placement |

## How Stack Detection Works

The script automatically identifies beam stacks through a multi-step process:

1. **Parallel filtering** -- Only beams with parallel length axes are candidates for the same stack
2. **Row detection** -- Beams connected end-to-end (cut faces that overlap within 1mm tolerance and share cross-section area) form a row
3. **Stack assembly** -- Rows that are side-by-side (faces within 1mm tolerance with overlapping real bodies) are grouped into a single stack
4. **Overlap filtering** -- If two detected stacks overlap in the viewport projection, the overlapping one is removed

Each detected stack receives its own grip point and generates its own dimension.

## Settings Storage

All settings are stored within the TSL instance Map data under the key "Genbeams referenced to genbeam stack". There are no external XML files.

- **Global settings**: Stored as "UserSelectedValues" within the dimension properties map
- **Element overrides**: Stored with the element handle as suffix (e.g., "UserSelectedValues~[handle]")
- **Grip positions**: Stored per element under "VisualControls~[handle]"
- **Version tracking**: The settings map records the TSL version to trigger automatic updates when the script version changes

## Tips and Best Practices

1. **Zone selection**: Use Zone 0 for framing members inside the element container. Zones 1-5 target front/top sheeting layers; zones -1 to -5 target back/bottom layers.

2. **Painter Definitions**: Create GenBeam-type Painter Definitions to filter specific member types (e.g., "Studs", "Plates", "Blocking"). This is essential for targeting the correct beams when an element contains many different member types.

3. **Multiple instances**: For complex shop drawings, use separate script instances with different filter settings -- one for stud spacing, one for opening dimensions, one for plate-to-plate measurements.

4. **Delta vs Cumulative**: Use Cumulative dimensions when measuring from a baseline reference (e.g., plate end to each stud). Use Delta dimensions when showing spacing between adjacent members.

5. **Offset type**: Set to "Beam Stack" to position the dimension line relative to the stack itself. Use "Viewport" to align with the viewport edge, or "Element" to align with the overall framing boundary.

6. **Element overrides**: When the same TSL instance spans multiple viewports, use element-specific overrides (right-click menu) to customize settings per element without affecting other viewports.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| No dimensions appear | Verify the viewport contains a valid hsbCAD Element. Check that zone filters match your target beams. Ensure include/exclude filters are not excluding everything. |
| Wrong beams dimensioned | Review the zone setting (front vs back). Check the "Dimensioned entities" mode. Verify Painter Definition filters. |
| Dimension line misplaced | Drag the grip point to reposition. Check "Dimension orientation" (Top vs Bottom). Adjust "Offset type" if needed. |
| Dimension text overlaps | Increase "Dimension line offset". Change "Text side" setting. Switch from Cumulative to Delta. |
| Stack not detected correctly | Beams must be parallel and physically connected (end-to-end or side-by-side within 1mm). Isolated beams or beams with gaps form separate stacks. |
| Override not taking effect | Confirm you used "Add properties override for current element" from the right-click menu. The override message appears in the command line when active. |

## FAQ

**Q: Can I dimension beams across multiple zones in one instance?**
A: No. Each instance uses a single zone for dimensioned beams and a single zone for the reference stack. Use multiple instances for different zones.

**Q: How do I dimension to beam centers instead of edges?**
A: Set "Points to dimension" to "Middle point" and "Beam/Sheet side" to "Entire beam/sheet".

**Q: Does the dimension update when the element changes?**
A: Yes. The TSL recalculates automatically when the associated element is modified.

**Q: Can I use this for roof trusses or floor joists?**
A: Yes, as long as the members are GenBeam entities within an hsbCAD Element visible in a viewport.

**Q: What happens when I change the script version?**
A: The script detects version mismatches and forces a settings update, preserving your existing selections while adding any new parameters from the updated version.

---

*Script Version: 0.19 | Last Updated: June 24, 2024*
