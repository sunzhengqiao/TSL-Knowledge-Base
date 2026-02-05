# NA_FLOOR_CENTER_OF_GRAVITY.mcr

## Overview
This script automatically calculates the Center of Gravity (CoG) for floor or roof panels and generates lift holes at optimal balance points. It ensures that panels are balanced during crane lifting by accounting for the weight of beams, trusses, and sheathing materials.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for calculation and geometry generation. |
| Paper Space | Yes | Visual reference (CG Text and Circle) appears in layout displays. |
| Shop Drawing | No | This is a model generation tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: An Element (Floor or Roof) containing GenBeams, Trusses, or Sheets.
- **Minimum Beam Count**: 0 (Calculates based on available geometry).
- **Required Settings Files**:
  - `NA_FLOOR_HOLES.mcr` (Must be available for the script to generate hole geometry).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_FLOOR_CENTER_OF_GRAVITY.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on one or more floor/roof elements in the model and press Enter.
```
The script will automatically attach itself to the selected elements and calculate the Center of Gravity.

### Step 3: Configure Properties
After insertion, select an element with the script attached to open the **Properties Palette**.
1. Locate the *Script Parameters* or *Object Data* section.
2. Adjust the **Length Factor**, **Show Circle**, or **Sheathing Hole** options as desired.
3. The script will automatically update the geometry and hole placement when properties are changed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length Factor | dropdown | 1/2 Length In | Determines the size of the visual reference circle drawn at the Center of Gravity. Options include 1/2, 1/3, or 1/4 of the element's length. |
| Show Circle | dropdown | Yes | Toggles the visibility of the reference circle around the Center of Gravity. Set to "No" to hide the circle. |
| Sheathing Hole | dropdown | 2-1"Drills Spaced at 3-3/4" | Selects the specific hole pattern or profile to be machined at the lift points. Includes options for circular holes, rectangles, ellipses, and drill patterns. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: `NA_FLOOR_HOLES.mcr`
- **Location**: TSL Scripts folder (Company or hsbCAD Install path)
- **Purpose**: This sub-script is responsible for actually creating the machining operations (holes) based on the configuration selected in the main script.

## Tips
- **Visualizing the Lift Zone**: Use the **Length Factor** property to draw a large circle around the CoG. This helps riggers understand the spread of the lifting gear.
- **Automatic Updates**: If you modify the floor structure (e.g., add heavy beams or change sheathing), select the element and press Enter to trigger a recalculation. The CoG and lift points will move to the new balanced position.
- **Collision Detection**: The script attempts to avoid placing holes on Truss Plates or in gaps between sheathing. If it cannot find a suitable spot, it will shift the lift point inward and retry.
- **Loose Material**: Beams marked as "LOOSE" or dummy beams are automatically excluded from the weight calculation.

## FAQ
- **Q: Why did the script not generate any holes?**
  **A:** The script searches for internal structural members (beams/trusses) near the CoG to place holes. If no valid member is found (e.g., the CoG falls in a large open gap or directly on a truss plate that cannot be avoided), holes may not be generated.
- **Q: Can I change the hole size after insertion?**
  **A:** Yes. Select the element, open the Properties Palette, and change the **Sheathing Hole** dropdown to a different profile (e.g., "Circular Hole 6"). The script will regenerate the holes immediately.
- **Q: Does this include the weight of the sheathing?**
  **A:** Yes, the script collects Sheets, GenBeams, and TrussEntities to calculate the true volumetric Center of Gravity.
- **Q: What does the "CG" text indicate?**
  **A:** This marks the exact calculated Center of Gravity for the panel. Lifting hooks should theoretically align vertically above this point for a balanced lift.