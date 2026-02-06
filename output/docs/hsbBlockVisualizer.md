# hsbBlockVisualizer.mcr

## Overview
This script enables standard AutoCAD Block References to be visualized within the hsbCAD Display Composer. It is useful for displaying non-hsbCAD elements (such as imported architectural windows, furniture, or equipment) in 3D views and generated reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script functions in the model environment. |
| Paper Space | No | Not supported in Layouts. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: Standard AutoCAD Block References (`BlockRef`).
- **Minimum Beam Count**: 0 (This script works independently of beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsbBlockVisualizer.mcr` from the list.

### Step 2: Select Block References
```
Command Line: |Select blockref entities|
Action: Click on one or more standard AutoCAD blocks in your drawing that you wish to visualize in hsbCAD.
```

### Step 3: Complete Selection
```
Command Line: (Press Enter to finish selection)
Action: Press Enter or Right-click to confirm the selection.
```
*Note: The script will automatically attach itself to the selected blocks and make them visible in the hsbCAD 3D view.*

## Properties Panel Parameters

There are no user-editable properties in the AutoCAD Properties Palette for this script. All visualization data is derived directly from the selected Block Reference entity.

## Right-Click Menu Options

There are no specific custom right-click menu options added by this script.

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Scaling Support**: If you scale a Block Reference using AutoCAD grips or properties, the hsbCAD visualization will automatically update to match the new scale.
- **Element Assignment**: If you change the Element (Layer) of the original Block Reference, the visualization will update its assignment to match.
- **Visibility**: To hide the visualization in hsbCAD views, you can simply turn off the layer of the original Block Reference.

## FAQ

- **Q: Why do I see the warning "Block is not loaded in the drawing"?**
  **A**: The script cannot find the block definition in the current drawing's block table. You may need to insert the block definition into the drawing again or ensure it has not been purged.

- **Q: Can I use this on dynamic blocks?**
  **A**: This script is designed for standard Block References. While it may work on some dynamic blocks, results depend on how the dynamic block geometry is calculated by AutoCAD.

- **Q: What happens if I delete the original block?**
  **A**: The hsbCAD visualization instance detects that the linked entity is invalid and will automatically erase itself to prevent errors.