# HSB_D-MultiElement.mcr

## Overview
This script automatically generates dimensions and labels for Multi-Elements (such as wall panels or floors) directly in Paper Space. It reads the geometry from a selected viewport to create annotations for individual studs, part numbers, or openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script must be inserted in a Layout tab. |
| Paper Space | Yes | Requires a Layout with a viewport linked to an ElementMulti. |
| Shop Drawing | Yes | Used for creating production drawings and layouts. |

## Prerequisites
- **Required Entities**: An `ElementMulti` (e.g., a generated wall or floor) visible in a viewport.
- **Minimum Beam Count**: N/A (The script dimensions whatever is contained in the element).
- **Required Settings**: A Paper Space Layout containing at least one viewport showing the Multi-Element.

## Usage Steps

### Step 1: Launch Script
Command: Run `TSLINSERT` (or the hsbCAD insert command) and select `HSB_D-MultiElement.mcr`.

### Step 2: Select Viewport
```
Command Line: |Select a viewport|
Action: Click inside the viewport that displays the wall or floor you wish to dimension.
```

### Step 3: Select Position
```
Command Line: |Select a position|
Action: Click in Paper Space to define the location for the script's label/instance name.
```

## Properties Panel Parameters

These properties can be edited in the AutoCAD Properties Palette (Ctrl+1) after selecting the script object.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimension Object** | dropdown | |Single elements| | Choose what to dimension: 'Single elements' (studs/beams), 'Single elementnumbers' (Part Marks), or 'Openings' (windows/doors). |
| **Offset in paperspace units** | dropdown | |Yes| | If 'Yes', offsets are fixed in paper size (readable). If 'No', offsets scale with the model zoom. |
| **Offset dimension line** | number | 15.0 | Distance between the element edge and the dimension line. |
| **Offset description** | number | 2.0 | Distance between the dimension line and the description text. |
| **Position** | dropdown | |Horizontal Bottom| | Places dimensions at the 'Horizontal Bottom' or 'Horizontal Top' of the element. |
| **Dimension style** | dropdown | System Generated | The AutoCAD dimension style to use for the lines. |
| **Color** | number | 1 | The color index (1=Red, etc.) for the dimension lines. |
| **Description** | text | | Additional text annotation placed near the dimension line. |
| **Default name color** | number | -1 | Color for the script instance name label (-1 = ByLayer). |
| **Dimension style name** | dropdown | System Generated | The text style used for the script instance name label. |
| **Extra description** | text | | A suffix added to the script name label to distinguish this instance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None specific* | This script does not add custom items to the right-click context menu. Use standard AutoCAD/hsbCAD grip edits to move the instance label. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Consistent Text Size**: Keep **Offset in paperspace units** set to "Yes" to ensure your text and dimension gaps remain the same physical size on paper, regardless of the viewport scale.
- **Part Numbering**: Switch **Dimension Object** to "Single elementnumbers" to quickly generate a layout of Part Marks (e.g., S1, S2) for the wall components.
- **Updating**: If you modify the wall layout in Model Space (e.g., add a stud), select the script object in Paper Space and trigger a recalculation (e.g., change a property slightly or use the hsbCAD update command) to refresh the dimensions.

## FAQ
- **Q: The dimensions seem to be in the wrong location or disappear.**
  A: Ensure the viewport you selected during insertion still contains the ElementMulti. If the viewport has been moved or the element erased, the script may fail to find the geometry.
- **Q: Can I dimension the vertical height of the wall?**
  A: No, this script is specifically designed for horizontal dimensions (widths/spacing) along the bottom or top edge of the element.
- **Q: What does the "Extra description" do?**
  A: It appends text to the main label of the script instance. For example, if the script name is "HSB_D-MultiElement" and you type "Floor 1" here, the label in Paper Space will read "HSB_D-MultiElement - Floor 1".