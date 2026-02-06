# hsbMitreCorner.mcr

## Overview
This script generates a mitre (angled) or corner (90-degree) connection between two intersecting timber beams. It supports an optional expansion gap to accommodate manufacturing tolerances or sealant.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for generating shop drawing views directly. |

## Prerequisites
- **Required Entities:** Two (2) Beams.
- **Minimum Beam Count:** 2 beams must be selected during insertion.
- **Required Settings:** None specified; standard hsbCAD environment required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMitreCorner.mcr` from the file dialog.

### Step 2: Select First Beam
```
Command Line: Select 2 beams
Action: Click on the first beam you wish to connect.
```

### Step 3: Select Second Beam
```
Command Line: Select second beam
Action: Click on the intersecting beam.
```
*Note: The beams cannot be parallel to each other, and you cannot select the same beam twice.*

### Step 4: Configure Joint (Optional)
Once inserted, select the script instance in the drawing to modify its properties in the Properties Palette (OPM).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Type | dropdown | | Defines the geometry of the joint. Select **Mitre** for a bisected angle cut or **Corner** for a 90-degree intersection. |
| Gap | number | 0 | Defines the distance (gap) between the two cut faces. Enter 0 for a tight fit or a specific value for expansion tolerance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TslDoubleClick (Double Click) | Swaps Beam 1 and Beam 2. This changes the reference point for the cut, which is particularly useful in **Corner** mode to ensure the correct side is cut. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No specific external settings file is required. The script may use standard catalog entries if invoked with specific execution keys (MITRE or CORNER).

## Tips
- **Correcting Cut Direction:** If a Corner connection cuts the wrong side of the beam, simply double-click the script instance in the model to swap the beam references.
- **Avoid Errors:** Ensure the two beams are not parallel; the script will refuse to process parallel beams.
- **Expansion:** Use the `Gap` property to leave room for glue, sealant, or wood movement.

## FAQ
- **Q: Why does the script fail when I select the beams?**
  **A:** Ensure you are selecting two different beams and that they are not parallel to each other.
- **Q: How do I change a joint from a straight cut to a 45-degree mitre?**
  **A:** Select the script instance, open the Properties Palette, and change the "Tool Type" from "Corner" to "Mitre".
- **Q: What happens if I double-click the script?**
  **A:** It swaps the order of the selected beams. In "Corner" mode, this changes which beam dictates the perpendicular cut direction.