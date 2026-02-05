# Layout_Plan_section.mcr

## Overview
This script creates a 2D schematic layout view in Paper Space by projecting beams from a selected 3D model viewport. It automatically overlays symbolic markers (such as crosses, circles, or text labels) on specific beams based on their `hsbId` property to indicate bracing directions or connection details.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script works via a Viewport selected in Paper Space. |
| Paper Space | Yes | The script must be inserted into a Layout tab containing a Viewport. |
| Shop Drawing | Yes | Used for creating simplified foundation plans or elevation schematics. |

## Prerequisites
- **Required Entities**: A Layout tab with at least one Viewport displaying a 3D Element containing GenBeams.
- **Minimum Beam Count**: 0 (However, beams are only marked if they match specific internal criteria).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout_Plan_section.mcr`

### Step 2: Select Source Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport in your Layout that displays the model structure you wish to diagram.
```
*Note: The script will automatically detect the element linked to this viewport and generate the projection.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | Dropdown | Horizontal | Switches the symbol logic between "Horizontal" (Plan view) and "Vertical" (Elevation view) modes. This changes which beams are marked based on their `hsbId`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: All logic and symbol mappings are contained within the script.

## Tips
- **Updating Symbols**: If you modify the 3D model (e.g., move beams or change their `hsbId`), run the `REGEN` command in AutoCAD to update the schematic symbols in Paper Space.
- **Symbol Visibility**: Not all beams will receive a symbol. The script specifically looks for beams with `hsbId` values that match its internal list (e.g., specific bracing or hardware codes). Other beams will appear as standard 2D projections.
- **Troubleshooting**: If you insert the script and see nothing, ensure the selected Viewport is actually linked to a valid Element in the Model Space.

## FAQ
- **Q: Why are some beams marked with an 'X' or 'O' while others are just plain lines?**
  - A: The script only applies specific markers to beams whose `hsbId` property matches the internal lookup tables of the script. Plain lines represent beams that do not match these specific IDs.
- **Q: How do I switch between a floor plan view and a side elevation view using this script?**
  - A: Select the script instance in Paper Space, open the Properties palette (Ctrl+1), and change the **Direction** property from "Horizontal" to "Vertical".
- **Q: I selected the wrong viewport. How do I fix it?**
  - A: Delete the script instance and insert it again to select the correct viewport.