# HSB_E-MachineDatum

## Overview
This script generates a visual Machine Datum (Zero Point) symbol for timber elements (walls or floors). It calculates the datum position based on the bounding box of filtered beams within an element and displays it in either Model Space or on a Layout Viewport, serving as a reference for CNC production alignment.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attach directly to Elements to show the datum in 3D model views. |
| Paper Space | Yes | Attach to a Viewport to project the datum into 2D drawings. |
| Shop Drawing | No | This is a standard insertion script, not an automatic shop drawing generation script. |

## Prerequisites
- **Required Entities**: An Element (Wall/Floor) containing GenBeams.
- **Minimum Beam Count**: 1 (Must have beams to calculate a bounding box).
- **Required Settings**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing to allow beam filtering.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-MachineDatum.mcr`
*   A properties dialog may appear automatically to configure initial settings.

### Step 2: Select Element or Viewport
```
Command Line: Select elements | <Enter> to select a viewport
Action: 
    - To place in Model Space: Click on the desired Element(s).
    - To place in Paper Space: Press Enter.
```

### Step 3: Select Viewport (If using Paper Space)
```
Command Line: Select a viewport
Action: Click inside the viewport frame where you want the datum visible.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Flip direction | dropdown | None | Mirrors the datum coordinate system relative to the element (e.g., Flip over X if machining from the back). |
| Rotation | dropdown | 0 | Rotates the symbol around the element's Z-axis (0, 90, 180, 270 degrees). |
| Filter definition | dropdown | [Dynamic] | Selects a specific subset of beams (e.g., "Structural only") to determine the datum position. |
| Machine name | text | [Blank] | Text label displayed next to the symbol (e.g., "WEINMANN"). |
| Symbol size | number | 1000 | Length of the axis lines (crosshair) in millimeters. |
| Text size | number | 100 | Height of the machine name text in millimeters. |
| Symbol color | number | 1 | AutoCAD color index for the symbol and text (Default: Red). |
| Zone index | dropdown | 0 | Assigns the output to a specific production zone index (0-10). |
| Layer | dropdown | Tooling | The CAD layer on which the symbol is drawn (Tooling, Information, Zone, Element). |
| Select a Block | dropdown | None | Allows choosing a custom CAD block (e.g., company logo) instead of the standard crosshair. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click menu. Use the Properties Palette to modify settings. |

## Settings Files
- **External Dependency**: `HSB_G-FilterGenBeams`
- **Purpose**: This script relies on catalogs defined in the Filter script to determine which beams are included in the bounding box calculation. Ensure the appropriate filter catalogs are available.

## Tips
- **Filtering**: Use the *Filter definition* to exclude cladding or sheathing if you only want the datum to reference the structural timber frame.
- **Logos**: You can replace the standard crosshair with your company logo by selecting the block name in the *Select a Block* property.
- **Visual Alignment**: If the datum appears on the wrong corner of the element, use the *Flip direction* or *Rotation* properties to adjust the orientation without moving the element.
- **Paper Space**: When inserting into a viewport, ensure the viewport is linked to a valid Element; otherwise, the script will not generate geometry.

## FAQ
- **Q: I get an error "Beams could not be filtered!"**
  A: Ensure the script `HSB_G-FilterGenBeams` is loaded in your drawing (via `TSLSCRIPTLOAD` or similar project loading routine). This script is required to find the beams.
- **Q: Can I move the datum manually?**
  A: No, the position is calculated parametrically based on the beams. To change the position, modify the *Filter definition* to include/exclude specific beams, or adjust the *Flip/Rotation* settings.
- **Q: Why did the script disappear after insertion?**
  A: This can happen if no valid vertices were found (e.g., the element was empty) or if the insertion was a duplicate. Check your command line history for warning messages.