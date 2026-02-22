# hsbRoofData

Calculates and displays eave, inner, and roof areas for roof planes, with automatic schedule table generation.

---

## Overview

**hsbRoofData** is a comprehensive roof area calculation tool that analyzes roof planes and generates area measurements for different zones: eave areas (the overhang portion), inner areas (within wall boundaries), and total roof areas. Results can be displayed individually on each roof plane or consolidated into a schedule table for quantity takeoffs and reporting.

The script creates separate instances for each area type, allowing independent styling and cataloging. All calculated areas are linked to a central schedule table that automatically updates when roof geometry changes.

---

## Environment

| Property | Value |
|----------|-------|
| Type | O-Type (Object) |
| Space | Model Space only |
| Version | 3.9 |
| Beams Required | 0 |

---

## Prerequisites

Before using this script, ensure:

1. **Roof planes exist** - At least one ERoofPlane must be present in the drawing
2. **Walls defined (optional)** - For eave area calculations, wall elements or polylines help define the boundary between eave and inner areas
3. **Catalog entries configured (optional)** - Create catalog presets for quick, consistent application

---

## Usage

### Insertion Workflow

1. **Run the Script**
   - Execute `hsbRoofData` from the TSL command line or menu

2. **Configure Catalog Entries (Dialog)**
   - **Eave Area**: Select a catalog preset or use default (set to Disabled to skip)
   - **Inner Area**: Select a catalog preset or use default (set to Disabled to skip)
   - **Roof Area**: Select a catalog preset or use default (set to Disabled to skip)
   - **Schedule Table**: Select a catalog preset or use default (set to Disabled to skip)
   - **Roof Edges**: Optionally enable roof edge data calculation
   - **Group**: Assign to a group hierarchy (use `\` to separate levels)

3. **Select Roof Planes**
   - When prompted: "Select roofplane(s)"
   - Select one or more roof planes to analyze

4. **Define Eave Boundary** (if Eave Area enabled)
   - Prompt: "Eave Area: Select walls or <Enter> to select Polylines"
   - Select walls that define the eave/inner boundary, OR
   - Press Enter and select polylines that define the boundary

5. **Define Inner Area Boundary** (if Inner Area enabled)
   - Prompt: "Select polyline for the inner area or <Enter> to accept the previous selection"
   - Select polylines that define the inner area, OR
   - Press Enter to use the same selection as the eave area boundary

6. **Place Schedule Table** (if Schedule enabled)
   - Prompt: "Insertion point schedule"
   - Click to specify the insertion point for the schedule table

The script creates separate TSL instances for each area type on each roof plane, plus a master schedule table that links them all together.

---

## Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | String | (empty) | Name or label for the roof area (appears in schedule) |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Unit | Dropdown | mm | Display unit for area values: mm, cm, m, inch, feet |
| Decimals | Integer | 0 | Number of decimal places (0-4) |
| Dimstyle | Dropdown | (current) | Text dimension style |
| Text Height | Double | 30 mm | Height of label text |
| Color | Integer | 1 | Display color for area outlines and labels |

### Hatch Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pattern | Dropdown | None | Hatch pattern to fill area |
| Scale | Double | 30 | Scale factor for hatch pattern |

### Catalog Entries Category (Insertion Only)

| Parameter | Type | Description |
|-----------|------|-------------|
| Eave Area | Dropdown | Catalog preset for eave area styling |
| Inner Area | Dropdown | Catalog preset for inner area styling |
| Roof Area | Dropdown | Catalog preset for total roof area styling |
| Schedule Table | Dropdown | Catalog preset for schedule table formatting |
| Roof Edges | Dropdown | Enable/disable roof edge length calculation |

### Schedule Table Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Schedule Header | String | Schedule Table | Title displayed at top of table |
| Dimstyle | Dropdown | (current) | Text style for table |
| Text Height | Double | 30 mm | Row text height |
| Color | Integer | 1 | Table border and text color |
| Decimals | Integer | 0 | Decimal places for area values |

---

## Context Menu Actions

### For Eave/Inner Area Instances

| Command | Description |
|---------|-------------|
| Add subtractive Polyline(s) | Select additional polylines to subtract from the calculated area |
| Add additive Polyline(s) | Select polylines to add to the calculated area |
| Remove Polyline(s) | Remove previously linked polylines |
| Edit in Place | Enable grip editing mode - converts boundary to editable grip points |
| Disable Edit in Place | Exit grip editing mode |
| Add Grip(s) | Add new grip points to the boundary (in Edit in Place mode) |
| Remove Grip(s) | Remove grip points from the boundary (in Edit in Place mode) |

### For Roof Area Instances

| Command | Description |
|---------|-------------|
| Add additive Polyline(s) | Add polylines to include additional areas |
| Remove Polyline(s) | Remove previously linked polylines |

### For Schedule Table

| Command | Description |
|---------|-------------|
| Add Dependency | Link additional area instances to this schedule |
| Remove Dependency | Unlink area instances from this schedule |

---

## Area Calculation Modes

### Eave Area
Calculates the roof overhang area - the portion of the roof that extends beyond the wall boundary. The script subtracts the wall footprint from the total roof envelope to determine the eave zone.

### Inner Area
Calculates the roof area within the building footprint. This is typically the intersection of the roof plane with the wall boundary polyline.

### Roof Area
Calculates the total roof plane area, including both eave and inner zones. Dormer openings and other roof plane openings are automatically subtracted.

### Schedule Mode
Collects and summarizes all linked area instances into a formatted table. The schedule displays:
- Material name
- Calculated areas (in selected units)
- Subtotals by material type
- Optional roof edge data (lengths and angles)
- Preview graphics showing each area on a roof diagram

---

## Tips

### Best Practices

1. **Use Catalog Presets**: Create catalog entries for each area type with predefined colors and settings for consistent documentation

2. **Group Organization**: Use the Group parameter to organize roof data by building level or zone (e.g., `Building A\Level 2`)

3. **Automatic Numbering**: Roof planes without numbers are automatically assigned sequential numbers during insertion

4. **Edit in Place**: Use grip editing for fine-tuning area boundaries after initial creation - grips are constrained to stay within the roof plane

5. **Schedule Updates**: The schedule table automatically recalculates when linked area instances change or are modified

### Special Features

- **Hardware Export**: Area data is exported as hardware components for quantity takeoff integration
- **Silent Insert**: Call the script with a catalog entry name to insert with preset values without dialog prompts

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Instance deleted on insert | Area calculation resulted in zero - verify roof plane geometry is valid |
| Invalid roof plane message | Ensure the roof plane polyline has minimum 3 vertices and positive area |
| Overlapping labels | Schedule table automatically repositions labels to avoid overlap |
| Missing schedule data | Verify area instances are linked using "Add Dependency" context menu |

---

## Related Scripts

- **hsbRoofDataEdge** - Companion script for roof edge length and angle calculations
