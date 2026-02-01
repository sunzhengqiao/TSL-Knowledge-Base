# GE_HDWR_STUD_PLATE_TIE.mcr

## Overview
This script automates the insertion of metal stud plate ties (straps), such as Simpson SP or SPH series, connecting wall studs or headers to top or bottom plates. It generates parametric 3D bodies, assigns BOM data, and handles shop or site installation settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model context. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a modeling script, though it controls shop drawing visibility via properties. |

## Prerequisites
- **Required Entities**: An existing Wall Element containing Stud or Header beams.
- **Minimum Beam Count**: 1 (The script can process multiple beams in one session).
- **Required Settings**: None (Uses internal logic to map wall widths to strap codes).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STUD_PLATE_TIE.mcr` from the catalog.

### Step 2: Select Studs or Headers
```
Command Line: Select a Stud or Header
Action: Click on one or multiple studs/headers within your wall assembly.
```
*Note: If you select beams belonging to different wall sizes (e.g., 2x4 and 2x6 walls), the script will group them by size.*

### Step 3: Specify Tie Size (Looped)
```
Command Line: Select a size for the '2x4' wall [SP1/SP4/SPH4/SPH4R]
Action: Type the desired code (e.g., SP4) and press Enter.
```
*Note: If you selected beams from multiple wall sizes, this prompt repeats for each unique wall width.*

### Step 4: Select Insertion Location
```
Command Line: Insert Location [Top/BOttom/Both]
Action: Type T, B, or select Both and press Enter.
```
*Note: Selecting "Both" will generate two separate hardware instances (one top, one bottom) for every stud selected.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| SP Tie | Dropdown | SP4 (Example) | Selects the specific hardware model number. Options are filtered automatically based on the width of the wall (e.g., 2x4 walls show SP4/SPH4 options). |
| Location | Dropdown | Top | Sets the vertical position of the tie. Options: **Top** (flange on top plate, legs down) or **Bottom** (flange on bottom plate, legs up). |
| Installation | Dropdown | Shop Installed | Determines logistics and representation. **Shop Installed** sets color to Yellow and assigns Element Group 'Z'. **Site Installed** uses default color and Element Group 'I'. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Dimensions are embedded in the script logic).

## Tips
- **Batch Processing**: You can window select an entire row of studs. The script will calculate the correct quantity and placement for all selected beams.
- **Dynamic Snapping**: If you use the grip to move the hardware after insertion, the script will automatically snap to the nearest perpendicular stud within an 8-inch range.
- **Color Coding**: Shop installed ties appear **Yellow** by default, making them easy to distinguish from field installed hardware in the model.
- **Troubleshooting**: If you see a **Red Circle with a Cross** at the insertion point, the tie could not find a valid intersection with the wall plates. Move the grip closer to the plate or check the wall geometry.

## FAQ
- **Q: Why did the script ask me for the size twice?**
  **A**: You likely selected studs from two different wall types (e.g., a 2x4 partition and a 2x6 exterior wall). The script prompts you separately for each wall width to ensure the correct strap length is used.
- **Q: Can I change the strap size after inserting it?**
  **A**: Yes. Select the strap, open the Properties Palette (Ctrl+1), and change the "SP Tie" dropdown to the desired model.
- **Q: What happens if I change the wall width after the ties are placed?**
  **A**: The ties are intelligent. If the wall geometry changes, the script attempts to re-associate with the wall. If the new wall size is incompatible with the selected tie code, you may need to manually update the "SP Tie" property.