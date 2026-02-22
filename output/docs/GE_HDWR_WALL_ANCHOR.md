# GE_HDWR_WALL_ANCHOR

## Overview

| Property | Value |
|----------|-------|
| Script Name | GE_HDWR_WALL_ANCHOR |
| Type | Object (O) |
| Version | 5.20 (January 16, 2023) |
| Category | Hardware - Wall Anchors / Tie Rods |
| Keywords | Wall, TieRod, Hardware, Anchor |
| Beams Required | 0 |

## Description

The GE_HDWR_WALL_ANCHOR script creates wall anchor bolts and tie rods for connecting timber frame walls to concrete foundations or for multi-story wall connections. It supports a wide variety of anchor types including all-thread rods, wedge anchors, J-bolts, screw anchors, and specialty hold-down hardware (Simpson Strong-Tie ATS series, PAB anchors, etc.).

This script automatically places anchor bolts with proper washers and nuts, creates drill holes in bottom/top plates, and handles multi-wall configurations for continuous rod systems spanning multiple floors.

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Creates 3D geometry (rods, washers, nuts) and modifies beam/element data |
| Paper Space | Limited | Display reference points available for shop drawing schedules |
| Element Required | Yes | Wall Element (Stick Frame) required |
| Automation Compatible | Yes | Designed for automated insertion workflows |

## Prerequisites

- **Required Entities**: A wall **Element** (Stick Frame Wall) to act as the host
- **No Beams Required**: Script locates plates automatically from the wall element

## Usage Workflow

### Step 1: Launch Script
Command: `TSLINSERT` or run `GE_HDWR_WALL_ANCHOR`
Action: Browse and select the script from the script list. A properties dialog will appear for initial configuration.

### Step 2: Select Host Wall(s)
Command Line: `Select a set of elements`
Action: Click on one or more wall Elements where anchors will be placed. Only Wall type entities are accepted.

### Step 3: Specify Anchor Locations
Command Line: `Select a set of Points`
Action: Click multiple points along the wall(s) where anchors should be placed. Press Enter or Esc when finished.

The script will:
- Automatically position anchors at valid locations
- Avoid stud locations based on minimum distance settings
- Resolve conflicts between overlapping anchors

### Step 4: Configure Properties
Action: With an anchor selected, open the **Properties Palette** (Ctrl+1) to adjust hardware type, washer sizes, and embedment settings. The 3D model and drill holes will update automatically.

### Step 5: Multi-Wall Connections (Optional)
Use the context menu option "Anchor to Upper Wall" to connect anchors across floor levels for continuous rod systems with couplers.

## Properties Panel Parameters

### General Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hardware Type | Dropdown | 1/2" All Thread | Selects the specific hardware catalog item. This determines diameter, drill size, and embedment logic. |
| Embedment | Dropdown | Concrete | Foundation type: "Concrete" or "Masonry" (affects embedment depth) |
| Drill Plates | Yes/No | Yes | Automatically drill holes through wall plates for the rod |
| Coupler Location | Dropdown | In Floor | Where to place rod couplers in multi-floor systems: "In floor" or "In Upper Wall" |
| Force Coupler At Base | Yes/No | No | Add a coupler at the base of the anchor (creates separate BOM line item) |
| Force Bottom Plate Nuts/Washers | Yes/No | No | Force nuts/washers at bottom plate even when attached to hold-down hardware |
| Top Washer | Dropdown | Default | Washer type at top: Default, 3"x3"x1/8", 2"x2"x1/8", 3"x3"x1/4", None, 1-1/2" Round, 3"x5"x1/4" |
| Bottom Washer | Dropdown | Default | Washer type at bottom (same options as Top Washer) |

### Placement Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Free Placement | Yes/No | No | If "No", anchor automatically positions to avoid studs and openings |
| Minimum Distance to Stud | Length | 2" | Minimum clearance from framing members |
| Minimum Distance to Rod | Length | 3" | Minimum spacing between adjacent anchors |

### Display Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hide Display | Yes/No | No | Hide the visual anchor symbol (magenta donut/square marker) |
| Flip Side | Yes/No | Yes | Display anchor symbol on opposite side of wall |

### Offset Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lateral Offset | Length | 0" | Horizontal offset from wall centerline |

### Automation Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Automation Insert | Integer | 0 | Internal flag for automated insertion (read-only) |

## Hardware Types Available (57+ Options)

### All Thread Rods
- 1/2", 5/8", 3/4", 7/8", 1", 1-1/8", 1-1/2" diameters

### Wedge Anchors
- 1/2", 5/8", 3/4" diameters

### Titen Screw Anchors
- 1/2" x 6", 5/8" x 6", 3/4" x 6"

### J-Bolts
- 1/2" x 6", 1/2" x 8", 1/2" x 10"
- 5/8" x 6", 5/8" x 8", 5/8" x 10"
- 3/4" x 6"

### Specialty Anchors
- SSTB16 (5/8" Simpson SSTB)
- PAB4, PAB5, PAB6, PAB7 (Simpson PAB series)

### ATS Series (Simpson Strong-Tie)
- ATS-RTUD4D, ATS-RTUD5D, ATS-RTUD6D
- ATUD5, ATUD6-2, ATUD9, ATUD9-2, ATUD14, TUD10
- ATS-R3 through ATS-R16
- ATS-HSR4 through ATS-HSR16

## Context Menu Options

| Option | Description |
|--------|-------------|
| Anchor to Upper Wall | Select an upper floor wall to create a continuous anchor system spanning multiple floors |
| Remove Wall | Remove an attached wall from the anchor system |

## Integration with Other Scripts

| Script | Integration |
|--------|-------------|
| GE_HDWR_WALL_HOLD_DOWN | Anchors automatically connect to hold-down hardware when placed nearby; inherits drill settings and positioning |
| GE_HDWR_ITW_TDS | Compatible with ITW tie-down straps; conflict detection prevents overlap |
| KT_XPORT_ELEMENT_DXF | Export data for DXF automation workflows |

## Output and Export

The script generates the following data for bills of materials:

- **Anchor/Rod**: Size and length calculated based on wall height and embedment
- **Couplers**: When applicable for multi-floor systems
- **Washers**: Top and bottom washers with dimensions
- **Nuts**: Hex nuts where applicable
- **Acrylic Tie Adhesive**: Calculated embedment length for adhesive anchors

### BOM Export Properties
- Element number assignment
- TH-Item codes for hardware tracking
- Hardware component data for scheduling

## Tips and Best Practices

1. **Placement Optimization**: Enable "Free Placement = No" to let the script automatically find optimal anchor locations avoiding studs and openings.

2. **Multi-Floor Systems**: Use the "Anchor to Upper Wall" context menu feature for continuous rod systems. The script automatically calculates coupler positions based on floor junctions.

3. **Hold-Down Integration**: When placed near a GE_HDWR_WALL_HOLD_DOWN, anchors automatically align and inherit drill settings. The hold-down determines the anchor position.

4. **Washer Selection**: The "Default" option automatically selects appropriate washers based on rod size. Override only when project specifications require different washers.

5. **Embedment Depth**: Choose "Concrete" or "Masonry" based on foundation type. Masonry typically requires deeper embedment (12" vs 4-6" for concrete).

6. **Display Symbols**: The magenta display symbols help identify anchor locations in 3D views. Different anchor types display with different symbols (circles, squares). Use "Hide Display" for clean production drawings.

7. **Conflict Resolution**: When anchors are too close together, the script uses a priority system. Hold-down connected anchors have highest priority (10).

8. **Drill Automation**: Enable "Drill Plates = Yes" to automatically create drill holes in bottom/top plates for manufacturing/CNC export. Holes are sized with 1/16" tolerance.

9. **Rod Length Calculation**: Rod lengths are automatically determined based on wall height and embedment requirements. Standard lengths are 12", 18", 24", 30", 36", and 8'-0" through 10'-0".

## FAQ

**Q: Why is my rod length longer than expected?**
A: Check the **Embedment** property. If set to "Masonry", the embedment depth is calculated deeper than standard concrete requirements.

**Q: The hole in the plate disappeared after I changed properties.**
A: Check the **Drill Plates** property. If set to "No", holes will not be machined. Switch it back to "Yes".

**Q: Can I move the anchor after placing it?**
A: Yes, if **Free Placement** is set to "Yes". If set to "No", the script constrains placement based on stud spacing logic.

**Q: Why did my anchor get deleted?**
A: The script has automatic conflict detection. If a higher-priority anchor (e.g., one connected to a hold-down) is placed too close, lower-priority anchors may be removed.

**Q: How do I create a continuous rod through multiple floors?**
A: Place the anchor on the lower floor wall, then right-click and select "Anchor to Upper Wall" to connect it to the upper floor wall. The script will create a continuous rod with couplers.

## Technical Notes

- **Units**: Imperial (inches)
- **Drill Tolerance**: 1/16" for automation compatibility
- **3D Geometry**: Creates solid bodies for visualization and clash detection
- **Hardware Grouping**: Anchors are organized in "X - Hardware" / "X-Anchor Export" groups
- **Display Types**: 0=No display, 1=Solid circle, 2=Sliced circle, 3=Solid square
- **Priority System**: Used for automatic conflict resolution (1-10 scale)
