# hsbCLT-CoreDrill

## Overview
This script creates core drilling geometry and associated hardware in CLT (Sip) panels. It supports both manual insertion by picking a point and batch insertion based on existing compatible TSL tools.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model and attaches to Sip panels. |
| Paper Space | No | |
| Shop Drawing | No | Generates map requests for annotations but runs in Model Space. |

## Prerequisites
- **Required Entities**: A Sip Panel (or a compatible tool attached to a Sip panel).
- **Minimum Beam Count**: 1 Panel.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-CoreDrill.mcr`

### Step 2: Configuration
If the script is not loaded with a specific catalog key, the **Properties Dialog** appears.
1. Adjust the desired **Diameter** and **Max Depth**.
2. Select **Alignment** (Vertical or Horizontal) and **Direction** (Bottom/Left, Top/Right, or Both).
3. Click **OK** to proceed.

### Step 3: Select Panel or Tools
The command line will prompt:
```
Select panel, <Enter> to select supported tools
```
**Option A (Single Insertion):**
- Click on a Sip panel in the drawing.
- The command line will then prompt: `Pick point at depth`.
- Click on the panel to define the insertion location and depth.

**Option B (Batch Insertion):**
- Press **Enter** without selecting a panel.
- The command line will prompt: `Select supported tsl tools`.
- Select existing TSL tools in the drawing that have the `AllowsEdgeDrill` attribute.
- The script will automatically generate core drills for each selected tool based on their reference points.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Geometry** | | | |
| Diameter | Number | 30 | Defines the diameter of the core drill. |
| Max Depth | Number | 0 | Defines the maximum depth from the edge of the panel. (Depth is also controlled by the insertion point). |
| **Alignment** | | | |
| Alignment | Dropdown | Vertical | Sets the alignment relative to the panel coordinate system. Options: Vertical, Horizontal. |
| Direction | Dropdown | Bottom (Left) | Defines the reference edge from which the drill enters. Options: Bottom (Left), Top (Right), Both. |
| Z-Offset | Number | 0 | Defines the vertical (Z) offset of the drill position. |
| **Display** | | | |
| Format | Text | R@(Radius) | Defines the format string used for the text description. |
| Color | Number | 6 | Sets the color of the visual symbol (AutoCAD color index). |
| Text Height | Number | 0 | Defines the height of the annotation text (0 = auto/default). |
| Allow Overwrite | Dropdown | No | Allows external style settings (e.g., `sd_EntitySymbolDisplay`) to overwrite the text color and height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Set Drill Direction** | Opens a dialog to change the drill direction options (Vertical/Horizontal/Top/Bottom/Both). This also resets the script's grip point to the center of the drill. |

## Settings Files
- **Filename**: None specific to this script.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Processing**: If you have multiple connections or tools that require a core drill in the same location, use Option B (Press Enter) and select the tools to generate all holes simultaneously.
- **Depth Control**: While `Max Depth` limits the drill, the actual start position is determined by where you click on the panel edge.
- **Grip Edit**: After insertion, you can drag the grip point to move the drill along its axis.

## FAQ
- **Q: How do I change the drill from vertical to horizontal?**
  - A: Select the drill and change the **Alignment** property in the Properties Palette, or right-click and choose **Set Drill Direction**.
- **Q: The drill isn't going all the way through the panel.**
  - A: Check the **Max Depth** property. If it is set to 0 or a value smaller than the panel thickness, the drill will be partial. Increase the value or check your insertion point.
- **Q: Can I use this on standard timber beams?**
  - A: No, this script is designed specifically for **Sip** panels (typically used for CLT construction). It will not function on standard GenBeams unless they are Sip entities.