# Layout_Dim_Beam.mcr

## Overview
This script automatically creates associative dimension lines in Paper Space (Layouts). It dimensions structural elements like beams, trusses, and sheets that are visible through a selected Viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is inserted in Paper Space but reads geometry from Model Space via the Viewport. |
| Paper Space | Yes | This is the primary environment for inserting this script. |
| Shop Drawing | Yes | Designed for creating production drawings. |

## Prerequisites
- A Layout (Paper Space) tab containing at least one Viewport.
- The Viewport must be linked to a valid hsbCAD Element (Model Space construction).
- Structural elements (Beams, Trusses, or Sheets) must exist within the Viewport's view.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout_Dim_Beam.mcr`

### Step 2: Specify Insertion Point
```
Command Line: 
Action: Click anywhere in the Paper Space to set the start point (origin) for the dimension line.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click on the border of the Viewport that displays the model you wish to dimension.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension line (Horizontal or Vertical). |
| Dim from | dropdown | Left | Defines the reading direction and origin (Left-to-Right or Right-to-Left). |
| Side of beams/sheets | dropdown | Left | Specifies which face of the elements to snap the dimension to (Left, Center, Right, or Both sides). |
| Zones to use | dropdown | Use zone index | Filters elements to dimension. Select "All" for everything or "Use zone index" for specific layers. |
| Zone index | number | 5 | The specific construction layer (Zone) index to dimension (e.g., framing, sheathing). |
| Delta text direction | dropdown | None | Controls rotation of the individual segment text (the numbers between ticks). |
| Cumm text direction | dropdown | Parallel | Controls rotation of the cumulative (total) dimension text. |
| Dim Style | dropdown | *[DimStyles]* | Selects the visual style (arrows, text size, scale) from the drawing's standard dimension styles. |
| Color | number | 1 | Sets the CAD color index for the dimension lines and text (1 = Red, etc.). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not use custom right-click menu options. Use the Properties Panel to adjust settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not require external settings files.

## Tips
- **Moving Dimensions:** To move the dimension line, simply click and drag the script's insertion grip in Paper Space.
- **Zone Filtering:** If you only want to dimension the outer sheathing and not the internal studs, set "Zones to use" to "Use zone index" and enter the specific Zone index number for your sheathing layer.
- **Bottom Plates:** The script automatically detects bottom plates to determine the start and end points of the wall dimension.

## FAQ
- **Q: Why did my dimension disappear?**
  A: Ensure the selected Viewport is still linked to a valid Element. If the link is broken or the Element is empty, the dimension will not generate.
- **Q: How do I switch between horizontal and vertical dimensions?**
  A: Select the script instance, open the Properties (OPM) palette, and change the "Direction" property from Horizontal to Vertical.
- **Q: Can I dimension specific layers (e.g., only the studs)?**
  A: Yes. Set "Zones to use" to "Use zone index" and define the "Zone index" that corresponds to your stud layer.