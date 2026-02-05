# HSB_L-LogCourseNumbering.mcr

## Overview
This script automatically generates numerical labels (1, 2, 3...) for each log course in a log wall. It projects these numbers onto a 2D layout view to assist with assembly planning and manufacturing lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for annotations in layouts. |
| Paper Space | Yes | Must be inserted in a Layout tab. |
| Shop Drawing | Yes | Specifically used for creating production drawings. |

## Prerequisites
- **Required Entities**: A valid `ElementLog` (Log Wall) must exist in the model.
- **Minimum Beam Count**: N/A (The script reads the entire log wall element, not individual beams).
- **Required Settings**: A Layout (Paper Space) containing a viewport that is linked to the log wall element.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_L-LogCourseNumbering.mcr`.
3. Click **Open**.

### Step 2: Configure Initial Settings
A dialog may appear to set the initial Dimension Style. Configure as needed and confirm.

### Step 3: Set Insertion Point
```
Command Line: Select a position
Action: Click in the Paper Space layout where you want the column of numbers to start (usually aligned with the top or bottom of the wall).
```

### Step 4: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border (frame) of the viewport that displays the log wall you wish to number.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | Dropdown | (Current) | Selects the text style and height from the drawing's available dimension styles. |
| Color text | Integer | -1 | Sets the color of the numbers. (-1 = ByLayer, 1-255 = Specific AutoCAD color). |
| Offset text | Number | 2mm | The distance between the log wall and the number labels. |
| Position | Dropdown | Vertical left | Determines which side of the wall the numbers are placed (Vertical left or Vertical right). |
| Offset in paperspace units | Dropdown | Yes | If "Yes", the offset is a fixed distance on the printed paper. If "No", the offset is a real-world Model Space distance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD dimension styles and does not require external XML configuration files.

## Tips
- **Consistent Offsets**: Keep "Offset in paperspace units" set to **Yes** if you want the gap between the wall and the text to look the same on paper, regardless of the viewport zoom scale.
- **Moving Labels**: If you need to shift the entire column of numbers horizontally, select the script instance and drag the grip point (the insertion point).
- **Visibility**: If the numbers do not appear, ensure the selected viewport is actually attached to a valid log wall element (`ElementLog`). If the viewport is empty, the script will erase itself.

## FAQ
- **Q: Why are my numbers huge or tiny?**
- A: Check the **Dimension Style** property. Ensure the text height defined in that style is appropriate for your drawing scale.
- **Q: I moved the viewport, but the numbers stayed in the same place.**
- A: The numbers are created in Paper Space, while the wall is in Model Space. You must move the script insertion point (the grip) or re-select the viewport to update the association.
- **Q: What does "Color text -1" mean?**
- A: It means the color is controlled by the Layer color property. Change the script's layer color to change the number color.