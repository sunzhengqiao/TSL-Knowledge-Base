# SetSquareContour

## Overview
This script squares off the ends of beams within selected Elements, reducing them to their minimal rectangular length. It effectively removes complex or angled cuts from specific beams based on a Painter or Zone filter.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Elements and Beams in the 3D model. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not process shop drawing entities. |

## Prerequisites
- **Required Entities:** Elements containing Beams (e.g., walls, roofs).
- **Minimum Beam Count:** 1 Element containing at least 1 beam.
- **Required Settings:** None (Optional Painter files can be placed in `TSL\SetSquareContour` for custom lists).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SetSquareContour.mcr`

### Step 2: Configure Properties (Dialog)
Upon launching, a properties dialog or palette appears.
```
Action: Select a 'Painter' from the dropdown list.
Options: Choose a specific construction part (e.g., "Stud", "Plate") or a logical Zone (e.g., "Zone 0").
Note: This selection determines which beams inside the element will be squared off.
```

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Elements in the Model Space that you wish to process.
Press Enter to confirm selection.
```

### Step 4: Automatic Processing
The script calculates the minimal bounding box for the filtered beams, applies static saw cuts to square the ends, and then automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Painter | dropdown | First available Painter / Zone 0 | Defines the filter criteria to select which beams will be cut square. You can select specific Painters (e.g., Rim Joist) or use Zones (-5 to 5) to filter beams by their construction index. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Folder**: `TSL\SetSquareContour` (or `SetSquareContour`)
- **Purpose**: If you place custom Painter definition files in this folder, they will appear in the 'Painter' dropdown list. If the folder is empty or missing, the script defaults to listing all available Painters plus generic Zones.

## Tips
- **Self-Deleting Script:** The script instance is automatically erased from your drawing immediately after processing. Do not look for it in the model afterwards; only the modified beams will remain.
- **Zone Filtering:** If you haven't created specific Painter files, use the "Zone X" options (e.g., "Zone -1", "Zone 0") to quickly target beams based on their zone index without needing configuration files.
- **Undo:** You can use the standard AutoCAD `UNDO` command to revert the cuts if the result is not as expected.
- **Performance:** Beams that are already perfectly square are automatically skipped by the script to save processing time.

## FAQ
- **Q: Why didn't the script cut all the beams in my wall?**
  A: Check the **Painter** property you selected. The script only processes beams that match the selected Painter or Zone. Ensure the beams you want to modify are assigned to that specific category.
- **Q: Can I use this script on a single beam?**
  A: The script requires selecting an **Element**. If you need to square a single beam, ensure it is part of an element or select the element containing it.
- **Q: Where do the "Zone" options come from?**
  A: These are built-in logical filters provided by the script (Zone -5 to Zone 5). They allow you to filter beams by their internal zone index without needing external Painter files.