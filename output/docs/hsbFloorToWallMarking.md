# hsbFloorToWallMarking.mcr

## Overview
This script automates the creation of layout markings on wall top plates to indicate where floor elements (joists or floor planes) intersect. It generates physical markers and dimension information on walls based on their relationship with selected floor elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | The script runs in Model Space to generate data used in shop drawings. |

## Prerequisites
- **Required Entities**:
  - `ElementRoof`: The floor element to be used as a reference.
  - `ElementWall`: Walls intersecting the floor.
  - `Beam`: Top plates on walls and joists on the floor.
- **Minimum Beams**: None (Script detects geometry from existing elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbFloorToWallMarking.mcr`

### Step 2: Configure Properties (Dialog)
```
Dialog: hsbFloorToWallMarking
Action: Set filters for the type of walls and joists to be marked.
- Wall Filter: Select "Any", "Exterior Walls", or "Interior Walls".
- Joist Filter: (Optional) Enter a text string to filter joists by their "Information" field.
```

### Step 3: Select Floor Elements
```
Command Line: |Select element(s)|
Action: Click on the floor element(s) (ElementRoof) that intersect the walls you want to mark. Press Enter to confirm.
```
*Note: After selection, the script automatically calculates intersections and creates the necessary markers on the relevant wall top plates. The original script instance is removed after processing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall Filter | dropdown | Any | Defines which walls are marked based on their exposed state. Options: "Any", "Exterior Walls", "Interior Walls". |
| Joist Filter | text | (Empty) | Defines a filter for floor joists. If specified, only joists containing this text in their "Information" property will be marked. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Options) | No custom context menu items are added. Use standard TSL recalculate options to update marks after geometry changes. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Updates**: If you modify the geometry of the wall or floor (e.g., move a wall, change a joist angle), the marks will automatically update during the next recalculation.
- **Targeting Specific Joists**: Use the "Joist Filter" property to mark only specific types of joists. For example, enter "Cantilever" to only mark joists that have that word in their information field.
- **Filtering Walls**: Use the "Wall Filter" to quickly ignore interior partitions if you only need markings for exterior connections.

## FAQ
- **Q: I ran the script, but no marks appeared.**
  **A**: Ensure the selected floor element actually intersects with wall top plates. Also, check the "Wall Filter" property to ensure it isn't excluding the walls you are looking at (e.g., set to "Exterior" but trying to mark an interior wall).
  
- **Q: What happens if I delete a floor element that was used to create marks?**
  **A**: The script instances attached to the walls will detect the missing reference and automatically delete themselves to prevent errors.

- **Q: Can I use this for ceiling markings?**
  **A**: Yes, the script logic treats `ElementRoof` entities as horizontal planes. It can be used for floors or ceilings depending on how your elements are modeled.