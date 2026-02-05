# Layout Minidomain.mcr

## Overview
This script creates a directional indicator (arrow or triangle) in Paper Space to visualize the orientation of an element within a selected Viewport. It optionally draws the element's outline and performs automated checks for length limits and naming conventions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Must be inserted in Paper Space. |
| Paper Space | Yes | Intended for use on Layouts containing Viewports. |
| Shop Drawing | No | This is a layout annotation tool. |

## Prerequisites
- **Required Entities**: A Viewport on the current Layout that is linked to a valid hsbCAD Element (Wall or Roof).
- **Minimum Beam Count**: 0 (Script reads the Element inside the Viewport).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout Minidomain.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame in Paper Space that displays the element you wish to annotate.
```

### Step 3: Configure Properties
After insertion, the script will calculate the position and draw the symbol. You can immediately adjust the appearance by selecting the newly inserted script object and modifying properties in the Properties Palette (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scale | Number | 2 | Controls the size of the directional arrow/triangle symbol. Increase if the symbol is too small to see. |
| max. Length | Number | 0 | Sets a length limit in mm. If set to > 0, the script reports a warning if the element length exceeds this value (e.g., transport length check). |
| Check wall number | Dropdown | No | If set to "Yes", the script validates that the Element Name has at least 3 characters and reports a warning if invalid. |
| Highlight Element | Dropdown | No | If set to "Yes", draws the full 2D outline of the element in Paper Space instead of just a simple symbol. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific custom items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visibility**: If you cannot see the arrow after insertion, check if the layer is frozen or increase the **Scale** property (d0).
- **Detail View**: Use the **Highlight Element** property set to "Yes" to quickly project a "clean" view of a single wall or roof element onto your layout without other model clutter.
- **Quality Control**: Set **max. Length** (d1) to your maximum transport size (e.g., 13000 mm). The script will automatically flag elements in the viewport that are too long for transport via the command line.
- **Wall vs. Roof**: The script automatically detects the element type. It draws an Arrow for Walls and a Triangle for Roofs/Other elements to indicate direction.

## FAQ
- **Q: Why did the script not draw anything?**
  - A: Ensure the selected Viewport actually contains a valid hsbCAD Element. If the viewport is empty or looking at empty space, the script will terminate silently.

- **Q: How do I check if my walls are too long for the truck?**
  - A: Select the script instance in Paper Space. In the Properties palette, set **max. Length** to your limit (e.g., 14000). Look at the AutoCAD command line (F2) to see warnings for any elements that exceed this length.

- **Q: Can I change the element after placing the symbol?**
  - A: Yes. If you change the model (geometry or name) or pan/zoom the viewport, the script will update automatically to reflect the new state.