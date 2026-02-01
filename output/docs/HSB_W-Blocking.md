# HSB_W-Blocking

## Description

The HSB_W-Blocking script creates blocking (horizontal bracing members) between studs in a wall element. This tool allows you to insert blocking members between two positions within an element, with the option to create either standard blocking pieces or an integrated beam that cuts through the studs.

Blocking is essential in timber frame construction for providing lateral support, fire-stopping, and attachment points for fixtures.

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 3.01 |
| **Last Modified** | 31.03.2020 |
| **Author** | Robert Pol (support.nl@hsbcad.com) |

## Properties

The properties are organized into four categories in the Properties Palette.

### Filter Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Filter beams with beamcode | String | (empty) | Exclude beams with specific beamcodes from the blocking calculation |
| Filter definition | Dropdown | (empty) | Select a predefined filter definition from HSB_G-FilterGenBeams. Will be combined with custom filters |

### Blocking Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Beam width | Double | 45 mm | The width (thickness) of the blocking member |
| Beam height | Double | 170 mm | The height (depth) of the blocking member |
| Side | Dropdown | Front | Which side of the wall to place the blocking: **Front** or **Back** |
| Material | String | C14 | The material grade for the blocking member |
| Name | String | Blocking | The name assigned to the blocking members |
| Minimum blocking length | Double | 40 mm | Minimum length for a blocking piece to be created. Shorter gaps will be skipped |
| Gap | Double | 0 mm | Gap distance between the blocking and the adjacent studs |

### Positioning Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Reference point | Dropdown | Bottom (up) | The vertical reference for positioning: **Bottom (up)**, **Middle (up)**, or **Top (down)** |
| Offset from reference point | String | 0 | Vertical offset distance from the reference point. Multiple positions can be specified using semicolon (;) as separator |
| Rotation | Angle | 0 | Rotation angle of the blocking members |

### Style Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Type | Dropdown | Blocking | **Blocking** creates individual pieces between studs. **Integrated beam** creates a continuous beam that cuts through the studs |
| Draw line | Dropdown | Yes | Whether to draw a visual reference line showing the blocking position |
| Integrated tooling catalog | Dropdown | (empty) | When using Integrated beam type, select a catalog from HSB_T-IntegratedTooling for the cutting operations |

## Usage Workflow

### Step 1: Launch the Script
Run the HSB_W-Blocking script from your tool palette or command line.

### Step 2: Configure Parameters (Optional)
If no preset catalog is selected, a dialog appears allowing you to configure the blocking parameters before insertion.

### Step 3: Select the Element
Click on the wall element where you want to add blocking. The command line prompts: "Select an element"

### Step 4: Select Start Point
Click to define the starting point of the blocking line. The command line prompts: "Select start point"

### Step 5: Select End Point
Click to define the ending point of the blocking line. The command line prompts: "Select end point"

### Result
The script automatically:
- Finds all studs (zone 0 beams) that intersect with the line between your two points
- Creates blocking pieces between each pair of adjacent studs
- Applies the specified material, dimensions, and beam codes
- Optionally draws a reference line showing the blocking position
- For integrated beam type, creates cuts in the intersecting studs

## Tips and Notes

1. **Multiple Heights**: You can create blocking at multiple vertical positions in one operation by entering multiple offset values separated by semicolons (e.g., "500;1000;1500").

2. **Direction Matters**: The script automatically adjusts the rotation direction based on whether you select points from left to right or right to left.

3. **Beam Filtering**: Use the filter options to exclude specific studs from the blocking calculation (e.g., skip over door king studs).

4. **Minimum Length**: Gaps smaller than the minimum blocking length will be skipped, which is useful for avoiding tiny pieces near openings.

5. **Integrated Beam**: When using the "Integrated beam" type, the blocking runs continuously through the studs, with automatic cuts created in the intersecting members.

6. **Reference Point Options**:
   - **Bottom (up)**: Offset is measured upward from the bottom plate
   - **Middle (up)**: Offset is measured upward from the middle of the wall
   - **Top (down)**: Offset is measured downward from the top plate

7. **Beam Codes**: The script automatically assigns beam codes based on the side selection:
   - Front: BLF (Blocking Front)
   - Back: BLB (Blocking Back)

## Related Scripts

- **HSB_G-FilterGenBeams**: Used to define filter definitions for beam selection
- **HSB_T-IntegratedTooling**: Provides catalog options for integrated beam cutting operations
