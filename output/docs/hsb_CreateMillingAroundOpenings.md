# hsb_CreateMillingAroundOpenings.mcr

## Overview
Automatically generates CNC milling operations (cutouts or recesses) around window and door openings in timber wall and roof elements. It supports both simple rectangular cutouts and complex shapes based on sheet intersections for precise manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Use in 3D model to create tooling on elements. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This is a manufacturing/modeling script. |

## Prerequisites
- **Required Entities**: Element (Wall or Roof) and at least one Opening (Window or Door) inside that element.
- **Minimum Beam Count**: 0 (This script operates on Elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateMillingAroundOpenings.mcr`

### Step 2: Configure Settings
```
Dialog Box: Configure Milling Settings
Action: Set the desired Milling Mode, Target Zone, Offsets, and CNC attributes in the dialog window. Click OK.
```

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the Wall or Roof elements that contain the openings you want to mill. Press Enter to confirm selection.
```

### Step 4: Generation
The script will automatically detect all valid openings within the selected elements and attach milling operations to them. The initial script instance is removed, leaving only the tooling attached to the openings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling mode | Dropdown | Opening | **Opening**: Creates a simple rectangular milling around the opening.<br>**Opening where sheets intersect**: Creates a complex milling path based on the actual geometry of sheets in the selected layer. |
| Zone to mill | Dropdown | Specified zone | Determines which construction layer to mill.<br>**Specified zone**: Uses the index defined below.<br>**Outermost zone**: The exterior layer.<br>**Innermost zone**: The interior layer. |
| Specified zone | Number | 1 | The index number of the layer to mill (when "Specified zone" is selected). |
| Milling Depth '0=Zone depth' | Number | 0 | Depth of the cut. **0** = Cut completely through the selected zone. Any value >0 creates a blind pocket of that depth. |
| Tooling index | Number | 1 | The CNC tool number to be used for this operation. |
| Side | Dropdown | Left | Tool offset side relative to the contour path (Left or Right). |
| Turning direction | Dropdown | Against course | CNC cutting direction (Climb vs. Conventional milling). |
| Overshoot | Dropdown | No | If **Yes**, the toolpath extends tangentially beyond the start/end points to prevent dwell marks. |
| Vacuum | Dropdown | Yes | If **Yes**, vacuum zones are preserved over the milled area for the CNC bed. |
| Offset milling opening top | Number | 0 | Vertical offset from the top of the window frame (positive = larger cut, negative = reveal). |
| Offset milling opening bottom | Number | 0 | Vertical offset from the bottom of the window frame. |
| Offset milling opening left | Number | 0 | Horizontal offset from the left side of the window frame. |
| Offset milling opening right | Number | 0 | Horizontal offset from the right side of the window frame. |
| Offset milling door top | Number | 0 | Vertical offset from the top of the door frame. |
| Offset milling door bottom | Number | 0 | Vertical offset from the bottom of the door frame. |
| Offset milling door left | Number | 0 | Horizontal offset from the left side of the door frame. |
| Offset milling door right | Number | 0 | Horizontal offset from the right side of the door frame. |
| Offset from hole edge | Number | 0 | Additional clearance applied specifically when using "Opening where sheets intersect" mode. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Delete | Removes the milling operation from the opening. |
| Recalculate | Updates the milling geometry if parameters or the opening size have changed. |

## Settings Files
- None used.

## Tips
- **Complex Geometry**: Use the **"Opening where sheets intersect"** mode when your wall has cladding sheets with overlaps. This ensures the milling only cuts the specific sheet areas rather than a generic rectangle that might cut into air or other layers.
- **Reveals**: To create a reveal where the finish material overlaps the frame, enter **negative values** for the window/door offsets (e.g., -10 mm).
- **Editing**: You can modify the milling parameters at any time by selecting the Element (or the Opening instance) and changing values in the Properties Palette. The milling will update automatically.
- **Through Cuts**: To cut entirely through a layer (like sheathing), ensure **Milling Depth** is set to **0**.

## FAQ
- **Q: Why did the milling not appear?**
  A: Ensure the selected Element has a valid Opening sub-entity and that the "Specified zone" index actually exists in the element's layer build-up.
- **Q: Can I use this on curved walls?**
  A: Yes, the script works on ElementWallSF entities, but the milling result depends on the specific geometry and the selected mode (Sheet intersection mode handles complex geometry better).
- **Q: How do I change the tool used for the cut?**
  A: Select the milling instance in the model or via the element structure and change the **Tooling index** property to match your CNC machine's tool database.