# HSB_E-RecalculateSheetOrientation

## Overview
This script automatically optimizes the orientation of sheeting materials (like OSB or Plywood) within your model. It analyzes the geometry of selected sheets and rotates them so the X-axis aligns with the longest edge, optimizing the bounding box area.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for running the script. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**: Existing Sheets (either individually or contained within Wall/Floor Elements).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select the file 'HSB_E-RecalculateSheetOrientation.mcr' from the file dialog.
```

### Step 2: Configure Filters
Once inserted, the **Properties Palette** (OPM) will display the script settings. Adjust these before proceeding to selection.
- **Selection mode**: Choose whether to select structural Elements (Walls/Floors) or individual Sheets.
- **Material to recalculate**: (Optional) Type a specific material name (e.g., "OSB18") to only process that material. Leave empty to process all.
- **Zone to recalculate**: (Optional) Set a specific zone index number. Keep as `-100` to process all zones.

### Step 3: Select Entities
The command line prompt will change based on your "Selection mode" setting:

**If Mode = Elements:**
```
Command Line: Select a set of elements
Action: Click on the Wall or Floor elements that contain the sheeting you want to optimize. Press Enter to confirm.
```
*Note: The script will automatically attach itself to these elements, process all internal sheets, and then self-delete.*

**If Mode = Sheets:**
```
Command Line: Select a set of sheets
Action: Click directly on the specific sheet entities in the model. Press Enter to confirm.
```

### Step 4: Execution
- The script will iterate through the sheets, applying the Material and Zone filters.
- It calculates the optimal rotation for each valid sheet.
- The sheet local coordinate system is updated.
- The script instance erases itself automatically from the drawing once processing is complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter** | Group | - | Visual separator for filter settings. |
| Material to recalculate | Text | Empty | Enter a material name to filter which sheets are processed (e.g., "PLY22"). If left empty, all materials are included. |
| Zone to recalculate | Integer | -100 | Enter a specific zone index to process only sheets in that zone. Use `-100` to ignore zone filtering. |
| **Selection** | Group | - | Visual separator for selection settings. |
| Selection mode | Dropdown | Elements | Choose how you select objects in the model.<br>**Elements**: Select Walls/Floors (processes all sheets inside them).<br>**Sheets**: Select individual sheet entities. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the optimization logic based on the currently selected sheets and property settings. (Note: This script is designed to erase itself after running, so this option is primarily relevant if the script is interrupted or attached as a satellite). |

## Settings Files
- None required.

## Tips
- **Bulk Processing**: Use the **Elements** selection mode to quickly optimize all sheathing on an entire floor or wall assembly without picking every single panel.
- **Targeted Fixes**: If you only need to fix specific rotated panels, switch to **Sheets** mode and select only the problematic panels.
- **Triangle Handling**: The script includes special logic to detect right-angled corners on triangular sheets to ensure logical orientation.
- **Cleanup**: Don't worry if the script "disappears" after you run it; this is intended behavior to keep your drawing clean.

## FAQ
- **Q: Why didn't my sheet rotate?**
  - **A**: Check your **Material** and **Zone** filters. If a sheet does not match the specific material name or zone index entered in the properties, it will be skipped silently.
- **Q: Can I undo the changes?**
  - **A**: Yes, use the standard AutoCAD `UNDO` command immediately after running the script if you are unhappy with the new orientations.
- **Q: The script reported an error "Sheet could not be analysed".**
  - **A**: This indicates the sheet geometry is invalid or has zero area. You may need to check the source element or redraw the sheet manually.