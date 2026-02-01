# GE_PLOT_LOAD_BEARING_WALL

## Overview
Generates 2D graphical representations in Paper Space or Shop Drawings to highlight load-bearing walls and structural headers. It applies specific hatching and colors to differentiate structural elements on floor plans.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script generates 2D output specifically for layouts. |
| Paper Space | Yes | Select a Viewport to map the structural data. |
| Shop Drawing | Yes | Select a ShopDrawView for multi-page layouts. |

## Prerequisites
- **Required Entities**: A Viewport (for Paper Space) or a ShopDrawView (for Shop Drawings) linked to an hsbCAD Element.
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_LOAD_BEARING_WALL.mcr`

### Step 2: Configure Properties
1.  Open the **Properties Palette** (Ctrl+1).
2.  Locate the **Drawing space** parameter.
3.  Choose either `|paper space|` or `|shopdraw multipage|` depending on your current layout.

### Step 3: Select Target View
**If using Paper Space:**
```
Command Line: Select viewport
Action: Click on the layout viewport that displays the model you wish to annotate.
```

**If using Shop Drawings:**
```
Command Line: Select ShopDrawView
Action: Click on the ShopDrawView entity in the drawing.
```

### Step 4: Trigger Generation
```
Command Line: Go to your hsbConsole and select any element in the target group
Action: 
1. Open the hsbCAD Console (Project Tree).
2. Select any Element (e.g., a wall or floor) belonging to the house or group you want to process.
```
*Note: The script will automatically recalculate and draw the load bearing elements once you select an item in the console.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | \|paper space\| | Selects the target environment: Viewport (Paper Space) or ShopDrawView (Shop Drawings). |
| Load bearing walls display | dropdown | \|solid hatch\| | Visual style for walls: Solid fill, Cross hatch, or hidden. |
| Load bearing walls pattern | number | U(25,1) | Scale/density of the wall hatch pattern. |
| Load bearing walls color | number | 1 | AutoCAD Color Index (ACI) for wall outlines and hatch. |
| Structural wood beam display | dropdown | \|single line hatch\| | Visual style for headers (beams): Single line hatch or hidden. |
| Structural wood beam pattern | number | U(25,1) | Scale/density of the beam hatch pattern. |
| Structural wood beam color | number | 3 | AutoCAD Color Index (ACI) for beam outlines and hatch. |

## Right-Click Menu Options
None. The script updates automatically when properties change or a new element is selected in the hsbCAD Console.

## Settings Files
None required.

## Tips
- **Quick Toggle:** To temporarily hide the structural layer without deleting the script, set the **Load bearing walls display** and **Structural wood beam display** properties to `|no display|`.
- **Color Coding:** Use distinct colors (e.g., Red for walls, Green for beams) to make the structural plan easier to read at a glance.
- **Console Trigger:** If you modify the model walls, simply re-select the element in the hsbCAD Console to refresh the overlay.

## FAQ
- **Q: I inserted the script, but nothing happened.**
- **A:** You must complete the workflow by selecting an element in the **hsbCAD Console** (Project Tree). This selection triggers the calculation and drawing of the walls.
- **Q: Can I use this in Model Space to see the walls in 3D?**
- **A:** No, this script is designed specifically for generating 2D annotations in Paper Space or Shop Drawings.
- **Q: Why are some walls not showing up?**
- **A:** The script filters walls based on the `loadBearing` property assigned in the ElementWallSF. Ensure the walls are defined as "Load Bearing" in the wall settings.