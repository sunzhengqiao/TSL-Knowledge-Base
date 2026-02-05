# HSB_W-SingleLifting.mcr

## Overview
This script generates a single lifting anchor for timber wall panels. It automatically creates drill holes for lifting hardware (straps or bolts) through the main vertical stud, adjacent studs, and connecting members, while visualizing the lifting loop symbol.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Designed for 3D model interaction. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for 2D drawings. |

## Prerequisites
- **Required entities**: A vertical Beam (stud) that belongs to an Element.
- **Minimum beam count**: 1
- **Required settings**: None

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select HSB_W-SingleLifting.mcr from the catalog list.
```

### Step 2: Select Main Beam
```
Command Line: Select a vertical beam
Action: Click on the vertical stud (wall element) where you want to place the lifting anchor.
```
*Note: The script will automatically verify if the selected beam is vertical. If it is horizontal or angled, the script will abort.*

### Step 3: Define Position
```
Command Line: Select insertion point
Action: Click on the face of the selected beam to set the height and side for the lifting loop.
```
*Note: This point determines the center of the lifting anchor and helps the script detect which adjacent beams to drill.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Vertical offset** | Number | 80 mm | The vertical distance from the beam center to the top/bottom of the loop. Controls how "deep" the lifting eye extends. |
| **Horizontal offset** | Number | 80 mm | The horizontal distance from the center line to the side of the loop. Controls the width of the loop. |
| **Drill radius** | Number | 10 mm | The radius of the drill hole for the lifting hardware. (Note: This value sets the radius, not the diameter). |
| **Layer** | Dropdown | 1 | The CAD layer category (e.g., E for element tools, T for beam tools) used to organize the display. |
| **Zone index** | Number | 0 | The specific index number within the selected layer category. |
| **Color** | Number | 3 | The AutoCAD color index used to draw the visual lifting loop symbol. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **add Connecting Beams** | Opens a selection prompt to add beams to the drilling list. You can only select beams that were initially auto-detected by the script during insertion. |
| **remove ConnectingBeams** | Opens a selection prompt to remove beams from the current drilling list. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: No external settings files are required for this script.

## Tips
- **Beam Orientation**: Ensure the beam you select is perfectly vertical relative to the element's Y-axis. If the script disappears immediately after selection, check the beam's orientation.
- **Drill Size**: The property labeled "Drill radius" controls the size of the hole. If you need a 20mm hole, set this value to 10.
- **Modifying Members**: After insertion, use the right-click context menu to add or remove specific connecting beams (e.g., top or bottom plates) without deleting and re-inserting the anchor.

## FAQ
- **Q: Why did the script delete itself immediately after I picked the beam?**
- **A**: The selected beam was likely not vertical. The script only works on beams that are parallel to the Element's Y-axis.

- **Q: Can I add a beam that wasn't drilled initially?**
- **A**: Only if it was physically located within the auto-detection range during the initial insertion. The "add Connecting Beams" function allows you to select from a list of candidates found near the insertion point.

- **Q: How do I change the size of the loop visualization?**
- **A**: Adjust the "Vertical offset" and "Horizontal offset" properties in the AutoCAD Properties palette. This will resize the symbol and update the drill positions accordingly.