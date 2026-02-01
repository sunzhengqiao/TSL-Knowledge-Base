# GE_AB_DIMS

## Overview
This script automates the creation and management of dimension markers for anchor bolts or hardware on wall panels. It allows you to define a rectangular layout zone and automatically detects, dimensions, and aligns anchors found within that area on selected elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the 3D model. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: Walls or Elements (`Element`, `ElementWall`).
- **Minimum Beam Count**: None (Script operates on Elements).
- **Required Scripts**: `GE_AB_DIM` (This child script must be present in the search path to generate the actual markers).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_AB_DIMS.mcr` from the catalog.

### Step 2: Select Walls
```
Command Line: |Select walls|
Action: Select the wall elements in the model that contain the anchors you wish to dimension. Press ENTER to confirm selection.
```

### Step 3: Define Start Point
```
Command Line: Select start point
Action: Click in the model to set the first corner of the rectangular dimension area.
```

### Step 4: Define End Point
```
Command Line: Select end point
Action: Click to set the opposite corner of the rectangular area. The script will now scan the selected walls for anchors inside this box.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Alignment | Dropdown | Horizontal | Sets the orientation of the dimension lines. <br>• **Horizontal**: Measures along the World X-axis (Layer: SNAP HOR).<br>• **Vertical**: Measures along the World Y-axis (Layer: SNAP VER). |
| Dimstyle | Dropdown | *Project Default* | Selects the specific CAD dimension style (text size, arrows, units) to apply to all generated anchor markers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ../Reload | Prompts you to select additional elements. Use this to add new walls to the current dimension group without deleting the script. |
| ../Hide Missing Anchors | Hides dimension markers for anchors that were previously found but are no longer detected in the model (e.g., deleted or moved outside the zone). |
| ../Show Missing Anchors | Makes dimension markers visible for "missing" anchors, allowing you to see which hardware has been moved or deleted. |
| ../Reset | Resets the internal state of the script. |
| ../Delete | Removes the script instance and all associated generated markers from the model. |

## Settings Files
None. This script relies on standard CAD properties and the `GE_AB_DIM` dependency script.

## Tips
- **Defining the Zone**: Ensure the rectangle created by your Start and End points fully encompasses the anchors you want to dimension. Anchors outside this box are ignored.
- **Workflow**: If you add new walls to your design after inserting the script, simply right-click the script instance and select `../Reload` to include the new walls in the scan.
- **Troubleshooting**: If anchors are not appearing, verify that the specific TSL script used for the anchor has the word "ANCHOR" in its filename, as the script searches for this keyword.

## FAQ
- **Q: Why are some of my anchors not being dimensioned?**
  **A**: Check if they fall within the rectangular area defined by your start and end points. Also, ensure the anchor elements are selected during the initial wall selection or added via the `../Reload` command.
- **Q: What happens if I move a wall?**
  **A**: The script will recalculate on the next model update. It will update the position of the anchor markers. If an anchor moves outside the defined rectangle, it will be marked as "Missing" (depending on your visibility settings).
- **Q: Can I change the arrow size or text style?**
  **A**: Yes. Change the **Dimstyle** property in the Properties Palette to any dimension style defined in your current CAD drawing.