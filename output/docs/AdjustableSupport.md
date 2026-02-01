# AdjustableSupport

## Overview
This script automatically generates a layout of adjustable support feet (screw jacks) within a floor contour. It calculates placement based on configurable primary and secondary grids, allows for manual adjustments, and visualizes the support structure.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in the 3D model environment. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** The script relies on underlying "RUB-Raum" instances to define the outer boundary/contour of the floor.
- **Minimum Beams:** None.
- **Required Settings:** `AdjustableSupport.xml` (must be present in the Company or Install path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `AdjustableSupport.mcr`

### Step 2: Define Origin
```
Command Line: Insertion point:
Action: Click in the drawing to place the script instance. 
Note: The script will attempt to detect the floor contour based on the location relative to "RUB-Raum" instances.
```

### Step 3: Configure Grid
```
Action: Select the script instance and open the Properties Palette (Ctrl+1).
Action: Adjust `Grid Spacing X` and `Grid Spacing Y` to define the main layout of the supports.
Result: The script automatically populates the area with support points based on the grid.
```

### Step 4: Manual Adjustments (Optional)
```
Action: Right-click the script instance.
Action: Select "Add Point" to manually place extra supports or "Delete Point" to remove specific ones.
Action: Follow the command line prompts to select locations.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Floor Construction** | | | |
| dLevel | Number | 300 | The total vertical construction height (Z-level) of the floor system. |
| dThicknessTop | Number | 20 | Thickness of the top insulation layer within the floor assembly. |
| dThicknessSeal | Number | 10 | Thickness of the sealing layer (e.g., bitumen sheet). |
| **Primary Grid** | | | |
| dGridX | Number | 600 | Spacing between support feet along the X-axis (Main Grid). |
| dGridY | Number | 600 | Spacing between support feet along the Y-axis (Main Grid). |
| dOffsetX | Number | 0 | Horizontal offset for the start of the grid along the X-axis. |
| dOffsetY | Number | 0 | Horizontal offset for the start of the grid along the Y-axis. |
| **Secondary (Helper) Grid** | | | |
| dGridXhelp | Number | 300 | Spacing for the secondary grid along the X-axis. |
| dGridYhelp | Number | 300 | Spacing for the secondary grid along the Y-axis. |
| dOffsetXhelp | Number | 0 | Horizontal offset for the secondary grid along the X-axis. |
| dOffsetYhelp | Number | 0 | Horizontal offset for the secondary grid along the Y-axis. |
| sDisplayGridHelp | Yes/No | No | Toggle visibility of the secondary grid lines/points. |
| sFootCreateHelp | Yes/No | No | If "Yes", creates physical support feet at the secondary grid locations. |
| **Visual Settings** | | | |
| sSymbolFoot | Yes/No | No | Toggle the display of the support foot symbol. |
| sTextFoot | Yes/No | No | Toggle the display of text labels (e.g., height/ID) next to feet. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Point** | Enters a mode where you can click anywhere in the contour to add a single support foot. |
| **Delete Point** | Enters a mode where you can click on existing support points to remove them. |
| **Reset Points** | Clears all manual additions and deletions, reverting the layout to the standard grid defined in the properties. |

## Settings Files
- **Filename**: `AdjustableSupport.xml`
- **Location**: Company or Install path
- **Purpose**: Stores default values and configuration data for the script parameters.

## Tips
- **Resetting Layout:** Changing Primary Grid properties (Grid X/Y or Offsets) in the Properties Palette will automatically reset all points, deleting any manual additions or deletions you have made. Adjust the grid first, then add points manually.
- **Contour Detection:** Ensure "RUB-Raum" instances are drawn correctly. If the script displays "Unexpected: No vertex points," check that the room boundary exists at the insertion location.
- **Secondary Grid:** Use the Secondary Grid (Helper) for tighter spacing at edges or specific zones without changing the overall main layout.
- **Visuals:** Turn off `sSymbolFoot` and `sTextFoot` if you only need to see the grid layout for planning purposes, to reduce screen clutter.

## FAQ
- **Q: Why did my manually added points disappear?**
  **A:** You likely changed a Primary Grid parameter (like `dGridX` or `dGridY`). Modifying these forces a full recalculation of the grid, which overrides manual edits. Use the "Reset Points" command first to clear the grid, change settings, and then re-add points.
- **Q: Can I place a point outside the room contour?**
  **A:** No, the script restricts point placement to the inside of the detected contour. If you click outside, the script will attempt to snap the point to the nearest contour edge vertex.
- **Q: What is the Secondary Grid used for?**
  **A:** It is used for additional support requirements, such as smaller areas under the floor or edge reinforcement. Enable `sFootCreateHelp` to actually generate supports at these locations, otherwise they may just act as visual guides if `sDisplayGridHelp` is on.