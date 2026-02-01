# HSB_G-CleanupPolyLine.mcr

## Overview
This script cleans up selected polylines by removing redundant vertices (collinear points) and very short segments. It is ideal for simplifying complex geometry imported from other CAD files or created via tracing, with an option to automatically close the loop.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary working environment. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** A single Polyline (PLine) must exist in the drawing.
- **Minimum Beam Count:** 0
- **Required Settings:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the script location and select `HSB_G-CleanupPolyLine.mcr`.

### Step 2: Configure Properties (Dialog)
When the script starts, a Properties dialog may appear depending on your hsbCAD configuration.
Action: Set the desired cleanup tolerance and whether the result should be closed. Click **OK** to proceed.

### Step 3: Select Polyline
```
Command Line: |Select a poly line|
Action: Click on the polyline in the drawing that you wish to simplify.
```

### Step 4: Review Result
Action: The script will generate a new, simplified polyline based on your settings and erase the temporary script instance. You may need to delete the original "messy" polyline manually if the script was set to preview rather than replace.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| CloseResult | Boolean (0/1) | 0 | Determines if the resulting polyline is closed (connecting the last point to the first). Set to **1** to close the loop (e.g., for a wall contour), or **0** to keep it open. |
| vectorTolerance | Number | Unit(0.01, 'mm') | Sets the sensitivity for detecting collinearity. Vertices lying on a straight line within this tolerance are removed. |

## Right-Click Menu Options
This script does not add specific items to the right-click context menu.

## Settings Files
None required.

## Tips
- **Imported Geometry:** This tool is excellent for cleaning up polylines imported from DXF/DWG files that often contain unnecessary break points.
- **Short Segments:** The script automatically ignores segments shorter than 0.5mm to prevent noise in the geometry.
- **Closing Walls:** If you are tracing a wall outline, enable **CloseResult** to ensure the final geometry is a closed loop, which is often required for generating wall panels.

## FAQ
- **Q: Does this script modify the original polyline?**
  A: No, it typically creates a new "cleaned up" polyline entity. You should delete the original polyline after verifying the result is correct.
- **Q: Why are some corners not removed even though they look straight?**
  A: The corner might deviate slightly outside the `vectorTolerance`. Try increasing the `vectorTolerance` value slightly to allow for more aggressive smoothing.
- **Q: What happens if I select nothing?**
  A: The script will terminate gracefully without creating geometry.