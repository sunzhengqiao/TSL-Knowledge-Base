# Electrical Circuit

## Overview
This script adds an electrical circuit representation to an hsbCAD Element (Wall or Floor). It automatically drills holes through vertical studs at a specified height and draws a visual circuit line which can be trimmed automatically based on the location of electrical fixtures.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be attached to a 3D Element. |
| Paper Space | No | This script does not generate 2D shop drawings. |
| Shop Drawing | No | This script does not process layout views. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (e.g., a timber frame wall).
- **Minimum Beam Count**: The Element must contain vertical studs and top/bottom plates.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCAD_Electrical Circuit.mcr`

### Step 2: Select Element
```
Command Line: Element
Action: Click on the desired Wall or Floor element in the 3D model.
```
*Note: If no element is selected, the script will display an error "Element must be selected." and terminate.*

### Step 3: Configure Properties
Once inserted, the script runs with default settings. To customize the circuit, select the script instance and open the **Properties Palette** (Ctrl+1). Adjust parameters such as Height, Name, Color, and Trim options. The model updates automatically when properties change.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Circuit Height | Number | 1500 | The vertical height (in current document units) where the circuit runs through the wall. |
| Circuit Name | Text | Circuit | A unique identifier used to link this circuit to specific electrical fixtures. |
| Trim | Dropdown | None | Determines how the circuit line reacts to fixtures. <br>Options: <br>• **None**: Full span between outer studs.<br>• **Left**: Trims to the first fixture on the left.<br>• **Right**: Trims to the first fixture on the right.<br>• **Both**: Trims between the furthest left and right fixtures. |
| Colour | Dropdown | Green | The visual color of the circuit line in the model. <br>Options: Red, Yellow, Green, Cyan, Blue, Magenta. |

## Right-Click Menu Options
This script does not add specific items to the right-click context menu. Use the Properties Palette to modify parameters.

## Settings Files
No external settings files (XML) are required for this script.

## Tips
- **Avoid Obstructions**: Ensure there are no horizontal beams (e.g., noggings, bracing) at the exact `Circuit Height`. If a beam blocks the path, the script will report "Beam in the way of circuit path" and delete itself.
- **Color Coding**: Use different colors and names (e.g., "Lights" vs. "Sockets") to distinguish between multiple circuit types in the same wall.
- **Automatic Trimming**: To use the auto-trim feature, ensure you have placed `hsbCAD_Electrical Fixture` instances in the wall and set their "Circuit" property to match the `Circuit Name` defined in this script.

## FAQ
- **Q: Why did the script disappear after I selected the element?**
  - A: The script likely detected a collision. Check the command line history for the error "Beam in the way of circuit path". You must remove the horizontal member blocking the path or adjust the `Circuit Height`.

- **Q: The holes are drilled, but the line goes all the way through the wall ignoring my lights.**
  - A: Check your `Circuit Name` property. It must match exactly with the `Circuit` property assigned to your electrical fixtures. Additionally, ensure the `Trim` property is not set to "None".

- **Q: Can I use this on curved walls?**
  - A: This script is designed for standard elements with vertical studs. It relies on linear calculations along the Element's X-axis. Highly curved geometry may produce unexpected results.