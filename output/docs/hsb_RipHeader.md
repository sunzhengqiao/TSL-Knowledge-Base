# hsb_RipHeader.mcr

## Overview
This script automatically detects clashes between wall openings and header beams. It resizes ("rips") the headers to fit the height of door or window openings and removes any blocking or packers located below the header that interfere with the opening.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used in 3D model to modify wall/panel framing. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawings or views. |

## Prerequisites
- **Required Entities**: Elements (Walls/Panels) containing both Beams and Openings.
- **Minimum Beam Count**: 0 (Script simply skips elements without beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RipHeader.mcr`

### Step 2: Configure Properties (Optional)
Before selecting elements, you can adjust the script settings in the **Properties Palette** (Ctrl+1).
- **Only Show Report**: Set to `|Yes|` for a safe test run, or `|No|` to actually cut the headers.
- **Enter Minimum Depth of Header**: Ensure this is set to your structural requirement (default 140mm).
- **Include Beams with Code**: Add specific beam codes (e.g., `HDR;LVL`) if you want to rip beams that are not standard system headers.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall or Panel elements you wish to process. Press Enter to confirm selection.
```
*Note: Once the selection is confirmed, the script will process the elements and automatically erase itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Report of Ripped Headers | dropdown | \|Yes\| | If `|Yes|`, prints a list of modified headers to the command line. If `|No|`, runs silently. |
| Enter Minimum Depth of Header | number | 140 | The minimum height (in mm) a header must have. The script will not cut a header if it would go below this depth. |
| \|Include Beams with Code\| | text | | A list of custom beam codes to treat as headers (e.g., `HDR;Lintel`). Separate multiple codes with `| ;`. |
| Only Show Report | dropdown | \|Yes\| | **Safety Switch**. If `|Yes|`, the script only identifies clashes without modifying geometry. If `|No|`, it cuts headers and deletes packers. |

## Right-Click Menu Options
None. This script runs once upon insertion and does not attach persistent context menu items to the elements.

## Settings Files
None. This script operates independently of external XML or configuration files.

## Tips
- **Run a Test First**: Always run the script with **Only Show Report** set to `|Yes|` to preview which headers will be cut without changing your model.
- **Custom Headers**: If you use specific lumber for headers (like LVL) that isn't automatically detected, add the code in the **Include Beams with Code** field (e.g., `|LVL|`).
- **Packer Removal**: The script automatically looks for "SFPacker" or standard beams directly below the header and deletes them if they clash with the opening.
- **Self-Cleaning**: The script instance disappears from the drawing immediately after running. To run it again, you must insert it fresh via `TSLINSERT`.

## FAQ
- **Q: Why didn't my header get cut even though the report showed a clash?**
  - A: The calculated height of the header after the cut likely fell below the **Enter Minimum Depth of Header** value. Increase the minimum depth property or check if the header is too small for the opening.
- **Q: What does "Header already ripped" mean in the report?**
  - A: The script detected that the header is already within 0.5mm of the opening height, so no further modification was necessary.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as expected.