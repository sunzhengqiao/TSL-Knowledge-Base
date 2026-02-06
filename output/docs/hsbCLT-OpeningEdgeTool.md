# hsbCLT-OpeningEdgeTool.mcr

## Overview
This script creates machining tools (such as rabbets, slots, and cuts) along the straight edges of wall or floor openings in CLT and timber panels. It is typically used to add weather bar rebates to door openings or create connection details along window jambs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script works in 3D Model Space only. |
| Paper Space | No | Not supported in Layouts/Shop Drawings. |
| Shop Drawing | No | Not supported for 2D generation. |

## Prerequisites
- **Required Entities**: An Element (Wall or Floor panel) containing an Opening.
- **Minimum Beam Count**: 1 (Single panel or element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-OpeningEdgeTool.mcr` from the list.

### Step 2: Select Panel and Opening Edge
```
Command Line: Select Element:
Action: Hover over a Wall or Floor panel containing an opening. The script will automatically detect the closest straight edge segment of the opening.
```
### Step 3: Set Start Point (Origin)
```
Command Line: Specify insertion point:
Action: Click to place the start point of the tool on the desired opening edge.
```
### Step 4: Define Length (If Required)
```
Command Line: Specify end point / length:
Action: 
- If the "Length" property is set to 0: Move your cursor to visually define the length of the cut and click to set the end point.
- If the "Length" property is a specific number: The tool will insert immediately without this prompt.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool** | dropdown | Rabbet | Defines the type of machining operation. Options include Rabbet, Beamcut, Slot, Housing, Mortise, and Rabbet + Overshoot. |
| **Length** | number | 0 | Defines the length of the cut along the edge. Set to `0` to pick points graphically. |
| **Width** | number | 0 | Defines the width of the cut (perpendicular to the panel surface). |
| **Depth** | number | 0 | Defines the depth of the cut (horizontal penetration from the edge into the panel). |
| **Axis Offset** | number | 0 | Shifts the tool placement relative to the origin point along the panel's surface. |
| **Alignment** | dropdown | Horizontal | Controls orientation. "Extended" options (e.g., Horizontal extended left) will automatically calculate intersections with adjacent walls. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Properties** | Opens the Properties Palette to modify dimensions and tool type. |
| **Delete** | Removes the tool instance and the associated machining. |

*(Note: This script relies on standard AutoCAD interaction. Custom context menu items are not implemented.)*

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files.

## Tips
- **Dynamic Length**: Keep the **Length** property set to `0` when inserting. This allows you to click the exact start and end points visually on the model, which is useful for following irregular opening shapes.
- **Extended Alignments**: Use the **Alignment** options with "Extended" (e.g., *Horizontal extended left*) to automatically make the rabbet run past the opening edge and intersect with a perpendicular wall.
- **Tool Constraints**: If you select **Housing** or **Mortise**, the script checks for sufficient space. If the panel is too thick or the space is too tight, the tool will automatically downgrade to a standard **Beamcut**.

## FAQ
- **Q: Why did my tool change from "Housing" to "Beamcut" after I inserted it?**
  - A: Housing and Mortise tools require "free directions" (clearance) for the tool to access the cut. If the geometry does not allow this, the script automatically switches to a Beamcut to ensure validity.
  
- **Q: Can I change the alignment from Horizontal to Vertical using the Properties palette?**
  - A: No. The script prevents changing the fundamental orientation (Horizontal to Vertical) after insertion to prevent geometric conflicts. You must delete the instance and re-insert it with the correct orientation.

- **Q: What does "Rabbet + Overshoot" do?**
  - A: This creates a rabbet similar to the standard option but includes an overshoot calculation based on the specific geometry settings defined in the script logic.