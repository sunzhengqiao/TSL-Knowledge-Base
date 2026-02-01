# GE_FLOOR_CASSETTE_SHEATHING.mcr

## Overview
Generates structural floor sheathing (decking) for prefabricated floor cassettes. It automates the layout, cutting, and staggering of sheet materials like OSB or Plywood, splitting them at internal beam locations and applying edge hold-backs.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. Operates on Floor Cassette entities (`ElementRoof`). |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: `ElementRoof` (Floor Cassette).
- **Minimum Beams**: 0 (Internal beams are used for splitting but not strictly required for insertion).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `GE_FLOOR_CASSETTE_SHEATHING.mcr` from the list.

### Step 2: Configure Properties
1.  The **Insert Properties** dialog appears automatically.
2.  Select the **Material** (e.g., 4x8 T&G), **Distribution** origin, and **Stagger** settings.
3.  Click OK to confirm.

### Step 3: Select Cassettes
```
Command Line: Select a set of cassettes
Action: Click on the Floor Cassette (ElementRoof) entities you wish to sheath.
```
*   The script will automatically clone itself to the selected cassettes and generate the sheets.

## Properties Panel Parameters

### Sheathing Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | dropdown | 4x8 T&G | Select the size, thickness, and profile of the sheathing material (e.g., 4x8, 4x10). |
| Distribution from | dropdown | Bottom Left | Sets the origin corner for the sheathing layout (Bottom Left, Bottom Right, Top Left, Top Right). |
| Minimum Staggered Offset | number | 12.0 | The minimum distance in inches between end joints of adjacent rows to ensure structural strength. |

### Left Edge Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Min. Hold Value | number | 0.0 | The distance in inches to hold back the sheathing from the left edge of the cassette. |
| Rows to Hold | dropdown | None | Applies the hold value to specific rows: None, Even Rows, Odd Rows, or All Rows. |

### Right Edge Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Min. Hold Value | number | 0.0 | The distance in inches to hold back the sheathing from the right edge of the cassette. |
| Rows to Hold | dropdown | None | Applies the hold value to specific rows: None, Even Rows, Odd Rows, or All Rows. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set sheathed area from polyline | Prompts you to select a closed polyline to define a custom sheathing boundary (e.g., to create a complex shape or cutout). |
| Remove polyline area | Removes the custom polyline boundary and reverts the sheathing area to the full cassette shape. |
| Re-distribute sheathing on floor | Forces the script to recalculate and regenerate all sheets based on current properties without needing to change a value. |

## Settings Files
None. This script relies entirely on Properties and entity geometry.

## Tips
- **Beam Splitting**: The script automatically detects internal beams and splits the sheathing sheets at those locations.
- **Openings**: Ensure `OpeningRoof` entities are present in the cassette; the script will automatically cut holes in the sheathing to match them.
- **Staggering**: If joints are aligning too closely vertically, increase the "Minimum Staggered Offset" value.
- **Edge Conditions**: Use the "Rows to Hold" feature to create specific patterns where the sheathing stops short of the edge only on alternating rows (e.g., for ledger connections).

## FAQ
- **Q: Why did the sheets not generate?**
  - A: Ensure you selected an `ElementRoof` (Floor Cassette). The script filters out other element types.
- **Q: How do I handle a floor shape that isn't a simple rectangle?**
  - A: Use the "Set sheathed area from polyline" context menu option. Draw a closed polyline representing the exact area you want sheathed, and run the command.
- **Q: What happens if I change the material size?**
  - A: The script will automatically recalculate the layout grid to accommodate the new sheet dimensions (width/height).
- **Q: I see an error "Sheathing area off element".**
  - A: This occurs if you selected a polyline for the sheathing area that does not physically overlap the floor cassette element. Select a polyline within the cassette bounds.