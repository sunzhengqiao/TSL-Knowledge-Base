# HSB_E-ToolPath.mcr

## Overview
This script applies CNC machining operations (Sawing or Milling) to a specific material zone of a timber element based on user-defined geometry (Polylines, Circles, or Beams). It is used to create custom cuts, slots, or drill paths while offering options to exclude openings and define "No Nail" areas to prevent fastener conflicts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D Elements in the model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This generates production data (CNC), not drawing views. |

## Prerequisites
- **Required Entities**: An `Element` (e.g., Wall or Floor) containing `Sheet` entities.
- **Minimum Beam Count**: 0.
- **Required Settings/Scripts**: The script `HSB_G-CleanupPolyLine.mcr` must be loaded in the drawing to handle geometry filtering.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_E-ToolPath.mcr`.

### Step 2: Select Target Element
```
Command Line: Select Element:
Action: Click on the timber element (wall or floor) you wish to machine.
```

### Step 3: Define Tool Path
```
Command Line: Select entities for tool path [Polylines/Circles/GenBeams]:
Action: Select the geometry in the drawing that represents the desired cut path.
Note: You can select Polylines, Circles, or existing Beams to define the shape.
```

### Step 4: Configuration
After insertion, the script processes the geometry. You can now adjust the machining parameters via the Properties Palette (Ctrl+1) while the script instance is selected.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Sequence number | Integer | 0 | Determines the execution order relative to other TSLs during "Generate Construction". |
| **Tooling** | | | |
| Tool type | Dropdown | Saw | Choose between `Saw` (linear cutting) or `Mill` (pathed/contouring). |
| Zone index | Integer | 1 | The material layer to machine (e.g., 0 = structural layer, 1 = sheathing). |
| Tool index | Integer | 1 | The specific tool/bit number from the machine catalog to use. |
| Path direction | Dropdown | Manual | Sets the cutting direction: `Manual`, `Clockwise`, or `Anticlockwise`. |
| Tool side | Dropdown | Right | Determines which side of the line the tool cuts. `Auto` calculates this based on path direction. |
| Turning direction tool | Dropdown | Against course | Spindle rotation direction relative to travel (Upcut/Downcut). |
| Overshoot | Dropdown | Yes | Extends the cut slightly beyond the start/end points to ensure a clean cut. |
| Extra depth | Double | 1 mm | Additional depth added to the cut to ensure penetration through the material. |
| Saw angle | Double | 0 deg | The bevel angle of the saw blade relative to vertical. |
| Exclude openings | Dropdown | No | If `Yes`, tooling will not occur over window or door openings. |
| Exclude outter contours | Dropdown | No | If `Yes`, tooling will be suppressed near the outer edges of the element. |
| Left | Double | 0 mm | Defines a "keep-out" margin on the left side of the element (no tooling). |
| Right | Double | 0 mm | Defines a "keep-out" margin on the right side of the element. |
| Bottom | Double | 0 mm | Defines a "keep-out" margin on the bottom side of the element. |
| Top | Double | 0 mm | Defines a "keep-out" margin on the top side of the element. |
| **No nail area** | | | |
| With no nail area | Dropdown | No | If `Yes`, creates a zone where nails/screws are prohibited along the tool path. |
| Offset left | Double | 5 mm | Width of the no-nail zone to the left of the path. |
| Offset right | Double | 5 mm | Width of the no-nail zone to the right of the path. |
| Offset start | Double | 5 mm | Length of the no-nail zone before the cut start. |
| Offset end | Double | 5 mm | Length of the no-nail zone after the cut end. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Delete | Removes the script instance and the associated CNC tooling from the element. |
| Recalculate | Re-runs the script to update tooling based on property changes or element modifications. |

## Settings Files
- **Filename**: None specific (XML).
- **Dependency**: Requires `HSB_G-CleanupPolyLine.mcr`.
- **Purpose**: The dependency script is used to filter and clean up the geometry defining the tool path.

## Tips
- **Closed Loops**: When using a closed polyline (e.g., a rectangle), set **Path direction** to `Clockwise` or `Anticlockwise` and set **Tool side** to `Auto`. This ensures the tool stays on the correct side of the material (inside or outside).
- **Through Cuts**: Always add a small **Extra depth** (e.g., 1-5 mm) to guarantee the saw cuts completely through the material thickness, accounting for swelling or calibration errors.
- **Avoiding Fasteners**: Enable **With no nail area** `Yes` when cutting near edges where nails might be located. This prevents the CNC machine from hitting a nail and damaging the tool.
- **Modifying Paths**: You can grip-edit the visualization (the 'S' symbol and path) in the model to adjust the cut location without re-inserting the script.

## FAQ
- **Q: Why did the script disappear immediately after I selected the geometry?**
  **A:** The tool path was likely too short or invalid, or the required Zone Index had no thickness (no sheets found). Check your element structure and ensure the `HSB_G-CleanupPolyLine` script is loaded.
- **Q: What does "Zone index" mean?**
  **A:** This refers to the material layers in your element. Index `0` is usually the main structural timber, while `1`, `2`, etc., refer to cladding or sheathing layers added in the element composition.
- **Q: Can I use this to cut a window opening?**
  **A:** While technically possible, this script is designed for custom paths. For standard window openings, use the dedicated Opening tools. However, you can use this to trim sheathing around an opening by using the **Exclude openings** property smartly.