# hsbLayoutDim.mcr

## Overview
This script automatically generates 2D offset dimensions in Paper Space for specific construction zones (such as sheathing or framing) relative to a reference contour. It intelligently ensures dimension lines are placed outside the viewport boundary to maintain drawing readability.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script reads geometry from Model Space but writes dimensions to Paper Space. |
| Paper Space | Yes | This is the primary environment for script insertion and execution. |
| Shop Drawing | No | Used for detailing layout views and sections within standard CAD layouts. |

## Prerequisites
- **Required Entities**: The drawing must contain `GenBeams`, `Sheets`, `SIPs`, or `Elements` visible through the viewport.
- **Minimum Beam Count**: 0 (Script dimensions cladding/materials, not just beams).
- **Required Settings**: An active Viewport in Paper Space and a valid AutoCAD DimStyle configured in the drawing.

## Usage Steps

### Step 1: Launch Script
1. Open your drawing and switch to a **Paper Space** Layout tab.
2. Ensure a Viewport is active and displaying the model geometry you wish to dimension.
3. Type `TSLINSERT` in the command line and select `hsbLayoutDim.mcr`.
4. Click in the Paper Space to insert the script instance (usually near the viewport you are detailing).

### Step 2: Configure Dimensions
1. Select the inserted script object.
2. Open the **Properties Palette** (Ctrl+1).
3. Adjust parameters (see below) to define which material zone to dimension and the display style.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone Index** (`nZoneIndex`) | Number | 0 | Selects the construction layer to dimension (e.g., 0 for Frame, 1 for Inner Cladding). |
| **Reference Mode** (`nShowOffsetsAngles`) | Number | 0 | Determines the reference geometry: <br>0/1 = Offset from the Frame.<br>2 = Offset from the overall Element Outline. |
| **Display Delta** (`nDispDelta`) | Number | 0 | Offset distance (in mm) to shift the dimension text or leader away from the geometry point to prevent clutter. |
| **Auto Scale** (`bAutoscale`) | Boolean | 1 | If **On** (1), automatically scales text height and arrows to match the Viewport zoom level. |
| **Object to Dim** (`nObjectToDim`) | Number | 0 | Specifies which entity types to collect for dimensioning (e.g., Beams only, Sheets only, or all). |
| **Exclude Color** (`sExcludeColor`) | String | "" | A list of AutoCAD color indices to ignore (e.g., "1;5"). Entities with these colors will not be dimensioned. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Updates the dimension positions if the model geometry changes or the viewport is panned/zoomed. |

## Settings Files
- **Filename**: `DimStyle` (AutoCAD Standard)
- **Location**: Current Drawing Database
- **Purpose**: Determines the visual appearance (arrow style, text size, precision) of the generated dimensions.

## Tips
- **Viewport Visibility**: This script specifically ensures dimensions do not overlap the model drawing. If you pan the viewport, run **Recalculate** to push the dimensions back outside the boundary.
- **Layer Switching**: You can quickly switch between dimensioning the structural frame and the outer sheathing by changing the **Zone Index** property in the palette.
- **Readability**: Enable **Auto Scale** (default) so that your dimensions remain legible even if you have detail viewports at different scales on the same sheet.

## FAQ
- **Q: Why are no dimensions appearing when I insert the script?**
  - A: Ensure the **Zone Index** you selected actually contains material in your model. If you select Zone 1 but only have a structural frame (Zone 0), nothing will be drawn.
- **Q: My dimension text is tiny compared to the viewport.**
  - A: Check the **Auto Scale** property. If it is set to 0 (Off), the script uses a fixed scale factor that may not match your current zoom level. Set it to 1 (On).
- **Q: Can I dimension specific colored beams only?**
  - A: Yes. Use the **Exclude Color** property to list colors you want to ignore (e.g., enter "red" or the color index number) to filter out specific entities.