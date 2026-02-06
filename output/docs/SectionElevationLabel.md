# SectionElevationLabel.mcr

## Overview
This script automates the annotation of elevation points within shop drawings (Section or Elevation views). It calculates and displays the height difference relative to a reference level (e.g., Finished Floor Level), placing an arrow, the elevation value, and a custom note in the 2D view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for detailing views. |
| Paper Space | Yes | Must be used inside an active Layout or view. |
| Shop Drawing | Yes | Requires an active Section or Elevation entity (`Section2d`) to function. |

## Prerequisites
- **Required Entities**: An active Section or Elevation view (Section2d).
- **Minimum Beam Count**: 0 (This script annotates geometry points, not specific beams).
- **Required Settings**: None (Relies on standard AutoCAD/hsbCAD Dimstyles).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SectionElevationLabel.mcr` from the list.

### Step 2: Configure Properties (Optional)
Upon insertion, a dialog may appear allowing you to preset values (like the Note text or Reference Elevation). You can also change these later in the Properties Palette.

### Step 3: Select Point
```
Command Line: |Select Point|
Action: Click inside the Section or Elevation view where you want to mark the elevation.
```
*Note: The script automatically detects the Model Z-height based on where you click in the 2D view.*

### Step 4: Finalize
The script draws the elevation marker at the selected location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the visual style (font, color, line type) for the text and arrow from your drawing's dimension styles. |
| Text Height Override | number | 0 | Sets a specific text height. If set to `0`, the text height defined in the selected Dimstyle is used. |
| Arrow Scale | number | 1 | Adjusts the size of the arrow marker. (e.g., 1.5 makes the arrow 50% larger). |
| Note | text | T. O. Beam | A custom description label displayed with the elevation (e.g., "Sill Height", "T.O. Plate"). |
| Base/Reference Elevation | number | 0 | The Z-level from which the height is calculated. The displayed value is: `Point Height - Reference Elevation`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | Use the **Grips** (blue squares) to adjust the label position or text location graphically. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Text Height**: To keep your drawings consistent, leave the **Text Height Override** as `0` and manage text sizes through your **Dimstyle** settings.
- **Moving Labels**: Select the label to see two grips. Use the base grip (at the arrow tip) to move the marker to a different height (the value updates automatically). Use the secondary grip to drag the text/note to a clearer position without changing the elevation.
- **Negative Values**: If the calculated elevation is below the Reference Elevation, the script automatically prefixes the value with a minus sign (`-`).
- **Reference Levels**: If your project uses a non-zero reference (e.g., sea level or a specific floor offset), update the **Base/Reference Elevation** property to ensure the displayed levels are correct relative to that benchmark.

## FAQ
- **Q: How do I change the elevation from "3000" to "+3000"?**
  A: The script adds signs automatically. Ensure the math (Point Z minus Ref Elevation) results in a positive number.
- **Q: My text is too small to read.**
  A: You can either increase the **Text Height Override** property or modify the text size in the selected **Dimstyle** in AutoCAD.
- **Q: Can I use this in Model Space?**
  A: No, this script is specifically designed to calculate 3D coordinates based on 2D Section/Elevation views found in Paper Space or Shop Drawing contexts.