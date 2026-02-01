# GE_BEAM_CHANGE_COLOR_BY_TYPE.mcr

## Overview
This script batch-assigns specific visual colors to timber beams based on their functional type (e.g., Studs, Top Plates, King Studs). It is used to color-code structural elements to improve model verification and drawing clarity.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select existing beams directly from the model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Does not generate shop drawings. |

## Prerequisites
- **Required Entities:** Timber Beams (GenBeam).
- **Minimum Beam Count:** 1 (selected during execution).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the folder containing `GE_BEAM_CHANGE_COLOR_BY_TYPE.mcr`.
3. Select the file and click **Open**.

### Step 2: Configure Colors
1. The **Properties Palette** (OPM) will open automatically upon insertion.
2. Locate the various beam type parameters (e.g., Top Plate, Stud, King Stud).
3. Click the dropdown menu next to a parameter to select the desired color (e.g., Red, Yellow, Light Brown).

### Step 3: Select Beams
```
Command Line: Select beam(s)
Action: Click on the beams in the model you wish to update. You can select multiple beams at once.
```
1. After selecting the beams, press **Enter** or right-click to confirm.

### Step 4: Completion
The script will automatically detect the type of each selected beam, apply the configured color, and then delete itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Top Plate | Dropdown | Default brown (32) | Sets the color for horizontal Top Plate beams. |
| SF Top Plate | Dropdown | Default brown (32) | Sets the color for specific System Floor (SF) Top Plate variants. |
| SF Very Top Plate | Dropdown | Default brown (32) | Sets the color for the uppermost layer in double/triple plate configurations. |
| SF Bottom Plate | Dropdown | Default brown (32) | Sets the color for horizontal Bottom Plate (Sole Plate) beams. |
| Angled Top Plate Right | Dropdown | Default brown (32) | Sets the color for angled top plates (right side). |
| Angled Top Plate Left | Dropdown | Default brown (32) | Sets the color for angled top plates (left side). |
| Stud | Dropdown | Default brown (32) | Sets the color for standard vertical wall studs. |
| King Stud | Dropdown | Default brown (32) | Sets the color for King Studs (full-height studs framing openings). |
| Left Stud | Dropdown | Default brown (32) | Sets the color for left-side specific studs (end studs). |
| Right Stud | Dropdown | Default brown (32) | Sets the color for right-side specific studs (end studs). |
| Supporting Beam | Dropdown | Default brown (32) | Sets the color for structural supporting beams (rim beams/lintels). |
| Jack Over Opening | Dropdown | Default brown (32) | Sets the color for Jack Studs (Trimmers) located above an opening. |
| Jack Under Opening | Dropdown | Default brown (32) | Sets the color for Jack Studs (Trimmers) located below an opening. |
| Right Shim | Dropdown | Default brown (32) | Sets the color for packing/shim pieces on the right. |
| Left Shim | Dropdown | Default brown (32) | Sets the color for packing/shim pieces on the left. |
| Top Shim | Dropdown | Default brown (32) | Sets the color for packing/shim pieces on the top. |
| Bottom Shim | Dropdown | Default brown (32) | Sets the color for packing/shim pieces on the bottom. |
| Sill | Dropdown | Default brown (32) | Sets the color for Sill plates (bottom plates or window sills). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | The script instance deletes itself immediately after execution. There are no editable context menus available after running. |

## Settings Files
- **Filename:** None used.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Batch Processing:** You can select a large number of beams (e.g., an entire wall) at once. The script will filter them by type and apply the correct color to each one automatically.
- **Re-running:** Since the script deletes itself after use, simply run `TSLINSERT` again if you need to change colors for a different set of beams or adjust the color scheme.
- **Undo:** If you make a mistake, use the standard AutoCAD `UNDO` command to revert the color changes.

## FAQ
- **Q: I cannot find the script in the model after running it. Is that normal?**
  - A: Yes. This is a "command script" designed to perform an action and then clean up after itself. The beams keep their new colors, but the script instance is removed to keep the drawing clean.
- **Q: Why didn't my beam change color?**
  - A: Ensure the beam type in the hsbCAD properties matches one of the categories in the Properties Panel (e.g., "Stud" vs "King Stud"). If the type is generic or not listed, the script will not modify it.