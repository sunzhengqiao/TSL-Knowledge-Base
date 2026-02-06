# hsbElementCabling.mcr

## Overview
This script automates the creation of electrical and data cabling channels within timber elements. It generates round drills or rectangular chases (millings), defines protective "No-Nail" zones to prevent fastener conflicts, and adds relevant entries to the Bill of Materials (BOM).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where the timber elements exist. |
| Paper Space | No | Script operates on physical 3D geometry, not views. |
| Shop Drawing | No | Script modifies the 3D model, not 2D layouts. |

## Prerequisites
- **Required Entities**: An existing timber **Element**, **GenBeams**, or existing **Installation TSLs** (e.g., electrical box scripts).
- **Minimum Beam Count**: 1 (The element must contain structural material to cut into).
- **Required Settings**: None (Uses script properties or default catalog values).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `hsbElementCabling.mcr`.

### Step 2: Configure Properties (Optional)
If not using a pre-configured catalog entry, the properties palette may appear, or you can adjust settings after insertion. Ensure the **Direction** strategy matches your intent:
-   **Multisegment**: If you want to draw a custom path.
-   **Bottom/Top/Both**: If you want to connect existing installation points.

### Step 3: Select Parent Entities
```
Command Line: Select Element/GenBeam/TslInst
Action: Click on the timber Element, specific beams, or existing Installation Point TSLs you wish to connect.
```
*Note: If connecting installation points, select multiple points in the desired sequence of the cabling run.*

### Step 4: Define Path (Multisegment Mode Only)
If **Direction** is set to "Multisegment", you will enter a drawing mode:
```
Command Line: Pick point / [Undo]:
Action: Click points in the model to define the polyline path of the cable.
```
-   Click to place vertices.
-   Press **Enter** to finish the path and generate the geometry.
-   Type **U** or **Undo** to remove the last point if you make a mistake.

### Step 5: Inspection
-   If the generated geometry appears **Red**, the cabling channel does not intersect valid material (check your Zone/Offset settings).
-   If **Green/Standard Color**, the machining and No-Nail zones have been successfully applied.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Strategy** | Enum | Cut intersections | Determines how the path is calculated. "Cut intersections" limits the cut to actual beam volumes; "Full Path" creates a continuous slot through the entire element space. |
| **Diameter** | Double | 20 mm | The width of the cabling channel. If Depth is 0, this is the drill diameter. If Depth > 0, this is the width of the rectangular chase. |
| **Depth** | Double | 0 mm | Defines the channel type. **0** creates a Round Drill. **Any value > 0** creates a Rectangular Chase (milling). |
| **Direction** | Enum | Bottom | Sets the vertical reference and input mode. Select "Multisegment" to draw a path manually. Select "Top", "Bottom", or "Both" to auto-connect existing Installation Points. |
| **Zone** | Integer | 5 | Selects the structural layer (Zone index) within the element where the cabling is applied. |
| **Z Alignment** | Enum | Icon Side | Defines vertical alignment relative to the Zone (e.g., flush with surface, centered on axis, or aligned to installation points). |
| **Offset X** | Double | 0 mm | Shifts the cabling path horizontally along the beam/element length. |
| **Offset Z** | Double | 0 mm | Shifts the cabling path vertically relative to the alignment reference. |
| **Gap** | Double | 5 mm | Clearance added around the physical channel dimensions. This increases the cut size slightly and defines the safety buffer for "No Nail" zones. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Refresh** | Re-calculates the machining based on current properties and element geometry. Use this after moving beams or changing dimensions. |
| **Erase** | Removes the script instance and all associated machining (Drills/Cuts) and No-Nail zones. |
| **Select Parent** | Highlights the Element or beams associated with this cabling run. |

## Settings Files
- **Filename**: None (Standard configuration uses internal script properties).
- **Location**: N/A
- **Purpose**: N/A

## Tips
-   **Switching Shapes**: To switch from a round hole to a rectangular slot, simply change the **Depth** property from `0` to any positive value (e.g., `30`).
-   **Grip Editing**: If you created the path using "Multisegment" mode, you can select the cabling instance and drag the blue **Grips** in the model to adjust the path points dynamically.
-   **Material Savings**: Use the **Gap** parameter carefully. While a larger gap ensures easier wire pulling, it removes more structural wood material.
-   **Validation**: If your cabling disappears or turns red, check the **Zone** property. You may be trying to cut in a layer that does not exist in the current element construction.

## FAQ
-   **Q: How do I connect two electrical boxes automatically?**
    -   A: Set the **Direction** property to "Top", "Bottom", or "Both" (depending on where the boxes are located), then run the script and select the box (Installation TSL) instances.
-   **Q: What does the red preview color mean?**
    -   A: Red indicates that the calculated cabling body does not physically intersect the timber material of the element. Check your **Z Alignment** and **Offset Z** settings to ensure the channel is placed inside the beam volume.
-   **Q: Can I use this for round conduits?**
    -   A: Yes. Set **Depth** to `0` and set **Diameter** to the size of your conduit. The script will generate a cylindrical drill.