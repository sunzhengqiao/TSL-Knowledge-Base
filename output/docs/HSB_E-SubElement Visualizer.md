# HSB_E-SubElement Visualizer

## Overview
This script visualizes 3D sub-elements (such as window/door assemblies or modular wall sections) on a 2D layout sheet. It creates a 2D projection of the detailed timber structure found within a selected model viewport, allowing for clear documentation of sub-components in production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script runs in Layouts and reads data from Model Space via a Viewport. |
| Paper Space | Yes | This is the primary workspace for this script. It draws directly on the layout sheet. |
| Shop Drawing | Yes | Used to generate detailed views of specific sub-assemblies on production sheets. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) containing at least one Viewport that is linked to an Element with SubElements (e.g., a wall containing a window sub-assembly).
- **Minimum Beam Count**: 0.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-SubElement Visualizer.mcr`

### Step 2: Select Viewport
```
Command Line: Select viewport:
Action: Click on the viewport window in your layout that displays the element (e.g., a wall or floor) containing the sub-elements you wish to visualize.
```

### Step 3: Set Insertion Point
```
Command Line: Insertion point:
Action: Click anywhere on the Paper Space layout to define where the sub-element visualization and label should be placed.
```

### Step 4: Automatic Execution
Once the point is clicked, the script will immediately project the sub-elements from the selected viewport onto the sheet at the chosen location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| _Viewport | Entity (Viewport) | *Null* (User Selected) | The specific layout viewport that references the model element containing the sub-elements. Changing this updates the visualization to show a different element. |
| _Pt0 | Point (Coords) | *User Clicked* | The anchor point on the 2D sheet where the visualization is drawn. Modifying the X, Y, Z values moves the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the visualization based on the current state of the model or updated properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Quick Updates**: To visualize sub-elements from a different wall or view, simply select the script instance, open the **Properties Palette (Ctrl+1)**, click the `_Viewport` property, and select a different viewport on the screen.
- **Moving the View**: You can drag the script grip (the insertion point) to move the entire visualization to a cleaner spot on the drawing.
- **Validation**: If the script deletes itself immediately after insertion, it means the selected viewport did not contain a valid Element or the selection was cancelled. Re-run the script and ensure you click a viewport that is actively viewing a 3D building part.

## FAQ
- **Q: Why does the script disappear after I place it?**
  A: The script automatically deletes itself if it detects an invalid Viewport selection or if the selected Viewport does not contain a valid Element. Ensure you select a Viewport that is currently viewing a model element.
- **Q: Can I use this in Model Space?**
  A: No, this script is designed specifically for Paper Space (Layouts) to create 2D projections of 3D sub-elements.
- **Q: Nothing is drawn even though the script exists. Why?**
  A: The Element inside the selected Viewport may be invalid, or it may not contain any SubElements (e.g., a plain wall without windows or specific sub-modules). Try selecting a Viewport that shows a more complex assembly.