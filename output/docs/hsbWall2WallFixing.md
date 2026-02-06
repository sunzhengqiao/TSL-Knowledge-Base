# hsbWall2WallFixing.mcr

## Overview
This script automates the placement and calculation of nailing patterns for connecting stick-frame walls (such as Corner, T, or E connections). It generates visual representations of nail locations and exports CNC data for nail guns based on specified spacing or quantities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting wall elements and viewing geometry. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Operates in the 3D model context to generate manufacturing data. |

## Prerequisites
- **Required Entities:** At least two `ElementWallSF` (Stick Frame Walls) that intersect or overlap vertically.
- **Minimum Beam Count:** 2 (The script requires two wall elements to establish a connection).
- **Required Settings:** None (uses internal properties and standard CNC tool definitions).

## Usage Steps

### Step 1: Launch Script
**Command:** Type `TSLINSERT` in the command line (or select from the hsbCAD menu) and choose `hsbWall2WallFixing.mcr` from the file list.

### Step 2: Configure Properties
A properties dialog will appear automatically upon insertion.
- **Action:** Review default settings for Nail Index, Spacing, and Offsets. Click "OK" to proceed.

### Step 3: Select Walls
```
Command Line: Select stick frame walls
Action: Click on the first wall, then click on the second wall to create the connection.
```

### Step 4: Validation
- The script automatically calculates the vertical overlap between the selected walls.
- If the overlap is insufficient or walls do not intersect, the script will display an error ("no common range") and delete itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nail Index (nNailIndex) | Integer | 1 | Selects the specific nail gun tool (1-99) from the CNC machinery library to be used for this connection. |
| Direction (sDirection) | Dropdown | Inner | Determines which wall acts as the primary element (Inner vs. Outer). Affects the calculation direction and element assignment. |
| Distribution Mode (sModeDistribution) | Dropdown | Even | **Even:** Optimizes spacing to fill the area evenly.<br>**Fixed:** Uses the exact spacing defined in 'Distance Between', potentially leaving a remainder gap. |
| Distance Bottom (dDistanceBottom) | Double | 0 mm | The offset distance from the bottom of the wall overlap to the center of the first nail. |
| Distance Top (dDistanceTop) | Double | 0 mm | The offset distance from the top of the wall overlap to the center of the last nail. |
| Distance Between (dDistanceBetween) | Double | 10 | **Positive Value:** The desired physical spacing between nails in mm.<br>**Negative Value (e.g., -5):** Forces a specific *count* of nails (e.g., 5 nails total). |
| Wall Code Filter (sCode) | String | (empty) | Filters connections based on wall codes (e.g., "INT;EXT"). If set, nails are only generated if the connected wall code matches the list. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Direction | Toggles the `sDirection` property (Inner <-> Outer). This swaps which wall the nails are assigned to and recalculates the vector. |
| Recalculate | Refreshes the nailing pattern based on current geometry and properties. |

## Settings Files
- **Filename:** N/A (Relies on System CNC Database)
- **Location:** hsbCAD System Configuration
- **Purpose:** The `nNailIndex` parameter references tool definitions stored in your hsbCAD CNC export configuration, not a local XML file for this specific script.

## Tips
- **Quick Quantity Control:** To place exactly 10 nails between two plates, simply type `-10` into the `Distance Between` property. The script will automatically calculate the required spacing.
- **Visualizing Direction:** If the nail vectors point the wrong way (e.g., through the wrong plate), use the "Swap Direction" right-click option to flip them instantly.
- **Code Filtering:** Use the `sCode` property to automate detailing. For example, set it to `EXT` to ensure the script only generates nails when an interior wall intersects an exterior wall, ignoring interior-to-interior intersections.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  A: The script deletes itself if it detects "no common range" (overlap). Ensure the two walls actually intersect vertically.
- **Q: How do I specify a fixed spacing of 150mm regardless of the wall height?**
  A: Set `sModeDistribution` to "Fixed" and set `dDistanceBetween` to `150`.
- **Q: Can I use this for non-rectangular walls?**
  A: The script is designed for standard stick-frame wall intersections. It looks for vertical overlap ranges; complex non-planar intersections may not calculate correctly.