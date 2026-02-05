# HSB_W-DripRail

## Overview
This script automatically generates a parametric metal drip rail (flashing) over or below wall openings. It also creates the necessary voids (cuts) in the wall sheeting to ensure a proper fit.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Manufacturing data is handled via the 3D model and Element properties. |

## Prerequisites
- **Required Entities:** An existing `OpeningSF` (Opening) attached to a valid `Element` (Wall).
- **Minimum Beam Count:** 0 (This is a detailing accessory, not a beam generator).
- **Required Settings:** None required; uses internal defaults.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `HSB_W-DripRail.mcr`.

### Step 2: Configure Properties (Optional)
*   If the script is run manually (not via a specific Catalog execute key), a properties dialog may appear automatically.
*   You can adjust parameters like dimensions, offsets, and which zones to cut.
*   Click **OK** to confirm.

### Step 3: Select Openings
```
Command Line: Select one or more openings
Action: Click on one or more window or door openings in your drawing.
```
*   Press **Enter** to complete selection.

### Step 4: Verification
The script will generate the drip rail solid and apply cuts to the specified layers (zones) of the wall. If the opening geometry is invalid, the script instance will erase itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Offset from top opening** | Number | 0 | Sets the vertical offset from the top of the opening outline. |
| **Offset from outside** | Number | 10 | Defines the offset from the outside face of the wall. |
| **Place drip rail on top of zone** | Dropdown | 1 | Sets the specific zone (layer) to use as the reference for mounting (1-9). |
| **Orientation** | Dropdown | Opposite side | Defines the side of the wall: "Icon side" or "Opposite side". |
| **Position** | Dropdown | Bottom | Defines the position relative to the opening: "Top" or "Bottom". |
| **Thickness drip rail** | Number | 8 | Sets the material thickness of the drip rail. |
| **Extend to side of opening** | Number | 98 | Sets how far the drip rail extends horizontally past the opening sides. |
| **Height mounting face** | Number | 80 | Sets the vertical height of the mounting face. |
| **Angle angled part** | Number | 15 | Sets the angle of the angled section (in degrees). |
| **Height angled part** | Number | 60 | Sets the height of the angled section. |
| **Height front part** | Number | 60 | Sets the height of the front vertical face. |
| **Color drip rail** | Number | 8 | Sets the CAD color index for the drip rail. |
| **Article number** | Text | DR-012345 | Sets the article number for reporting/bills of materials. |
| **Zones to cut** | Text | 3 | Specifies which wall zones (layers) to cut. Separate multiple zones with a semicolon (e.g., "1;3"). |
| **Gap bottom** | Number | 2 | Clearance gap at the bottom of the cut in the sheeting. |
| **Gap top** | Number | 2 | Clearance gap at the top of the cut in the sheeting. |
| **Gap side** | Number | 2 | Clearance gap at the sides of the cut in the sheeting. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script uses standard AutoCAD/hsbCAD interaction (Properties Palette) for modifications. No custom context menu items are added. |

## Settings Files
No external settings files are required. All configuration is handled via the Properties Palette (OPM).

## Tips
- **Multiple Openings:** You can select multiple openings at once during the insertion prompt to apply the same drip rail configuration to all of them.
- **Positioning:** Use the **Position** property to quickly toggle between installing the rail above the window (Top) or below the window (Bottom).
- **Cutting Zones:** Ensure the **Zones to cut** property matches the actual sheeting layer numbers in your wall composition (e.g., Zone 3 might be the outer sheathing).
- **Article Numbers:** Update the **Article number** property to ensure accurate material lists and production reports.

## FAQ
- **Q: The drip rail disappeared after I selected the opening. Why?**
  **A:** The script erases itself if the selected OpeningSF does not have a valid geometry outline or if it is not attached to a valid wall Element. Check your wall and opening definitions.
- **Q: The visual is there, but the sheeting isn't cut out.**
  **A:** Check the **Zones to cut** property. You may have entered a zone index that does not exist in the element (e.g., Zone 0 or a zone higher than the total layers). Also, ensure the **Height mounting face** combined with gaps is not zero.
- **Q: How do I flip the drip rail to the inside of the wall?**
  **A:** Change the **Orientation** property to "Opposite side" or "Icon side" to rotate the component 180 degrees around the wall's Y-axis.