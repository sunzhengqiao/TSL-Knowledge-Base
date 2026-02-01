# HSB_E-InstallationPoint.mcr

## Overview
This script inserts electrical installation points (such as outlets, switches, and water connections) into timber wall elements. It automatically generates the required 2D symbols for drawings, cutouts for sheeting, and drilling operations for structural timber based on your specifications.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model on valid wall or floor elements. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Operations are applied to the model, not drawing views. |

## Prerequisites
- **Required Entities**: At least one hsbCAD Element (Wall or Floor).
- **Minimum Beam Count**: 1
- **Required Settings**: None specific (uses internal catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_E-InstallationPoint.mcr`.

### Step 2: Select Element
```
Command Line: Select element
Action: Click on the timber wall or floor element where you want to place the installation.
```

### Step 3: Select Insertion Point
```
Command Line: Select a point on the element
Action: Click the specific location on the element face where the outlet/switch should be located.
```

### Step 4: Configure Properties
After insertion, the script generates the standard symbol and cutout. Select the newly created instance and open the **Properties Palette** (Ctrl+1) to adjust the object type, box dimensions, or side settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Object | dropdown | Outlet | Select the type of fixture (e.g., Switch, Water, Light connection). This updates the symbol and default settings. |
| Description | text | | User-defined label (e.g., "Kitchen") displayed next to the symbol. |
| Side | dropdown | Front | Choose which side of the wall the installation applies to: Front, Back, or Front and Back. |
| Orientation | dropdown | Horizontal | Rotates the symbol and cutout (Horizontal or Vertical). |
| Flip | dropdown | Yes | Mirrors the direction of the arrow on the symbol. |
| Box size | number | 86.0 | The physical width of the installation box in mm (e.g., 86mm for standard European boxes). |
| Number of boxes | number | 1 | The gang size (e.g., 2 for a double socket). Increases the cutout width. |
| Number of symbols | number | 1 | The quantity of graphical icons to display. |
| Apply all zones | dropdown | No | If Yes, forces tooling to pass through all material layers of the element. |
| Auto insert tubes | dropdown | No | If Yes, automatically generates conduit/tube entities for cable routing. |
| Extend tubes | dropdown | Yes | If Yes, extends the generated tubes to connect with the main floor/ceiling runs. |
| Overrule description | text | | An alternative description used for data exports/BOM without changing the on-screen label. |
| Reverse toolpath | dropdown | No | Changes the CNC milling direction (Clockwise vs Counter-Clockwise). |
| Use custom block | dropdown | No | Enables the use of a specific CAD block to define the cutout shape instead of a rectangle. |
| Custom block name | text | | The name of the AutoCAD block to use if 'Use custom block' is Yes. |
| Beamcut behind | dropdown | No | If Yes, creates a through-cut or slot in the structural timber behind the sheeting. |
| Offset | number | 0.0 | Shifts the position of the symbol and cutout relative to the clicked point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reset Tube Properties | Forces associated tube entities (if auto-generated) to re-read their properties from this installation point. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on internal geometry logic and standard AutoCAD blocks (if custom blocks are used).

## Tips
- **Double Sockets**: Set **Number of boxes** to `2` to create the correct wide cutout for a double gang box without creating two separate instances.
- **Cable Routing**: Enable **Auto insert tubes** to quickly visualize conduit paths. Use **Reset Tube Properties** from the right-click menu if you move the point after tubes are created.
- **Deep Walls**: If your installation is deep within a sandwich element, enable **Apply all zones** to ensure the drill passes through every layer.
- **CNC Optimization**: If you notice rough edges on milled cutouts, try toggling **Reverse toolpath** to alter the cut direction.

## FAQ
- **Q: The symbol appeared, but there is no hole in my timber.**
  - A: Check the **Beamcut behind** property. It defaults to `No`. Set it to `Yes` to cut through the structural beam.
- **Q: How do I place a switch and an outlet at the exact same spot?**
  - A: You can either insert two separate Installation Points, or increase the **Number of symbols** and manually edit the Description to represent multiple items, though creating separate instances is usually recommended for clarity.
- **Q: Can I use a non-rectangular shape for the cutout?**
  - A: Yes. Set **Use custom block** to `Yes` and enter the name of a block defined in your drawing that matches the desired profile.