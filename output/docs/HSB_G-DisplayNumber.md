# HSB_G-DisplayNumber.mcr

## Overview
This script labels selected elements in the 3D model with their unique Element Number. It allows for customizable text positioning and styling to clearly identify walls, floors, or roof panels directly in Model Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D to place labels on elements. |
| Paper Space | No | Not designed for 2D layout sheets. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: 0 (Attaches to the Element entity, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
- Browse and select `HSB_G-DisplayNumber.mcr`.

### Step 2: Configure Properties
- A properties dialog appears automatically upon insertion.
- Set the **Display positioning** (e.g., "Center", "Top left").
- Adjust **Text height** and **Display color** as needed.
- Click **OK** to confirm.

### Step 3: Select Elements
```
Command Line: Select elements
Action:
1. Click on the desired Wall, Floor, or Roof elements in the 3D model.
2. Press Enter to finalize the selection.
```
The script will attach to each selected element and display the number.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Display positioning| |dropdown| |No display| |Select the anchor point for the text on the element (e.g., Bottom left, Center, Top right). |
| |Display color| |number| |0| |Sets the color index of the text (0 = ByBlock). |
| |Text height| |number| |U(10)| |Defines the height of the text characters in model units (typically mm). |
| |Dimension style| |dropdown| |_DimStyles| |Selects the text style/ font to be used from the project standards. |
| |Horizontal offset| |number| |0| |Shifts the text position along the element's length (X-axis). |
| |Vertical offset| |number| |0| |Shifts the text position across the element's width (Y-axis). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. Use the Properties palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visibility**: The default setting is "No display". If you insert the script and see no change, open the Element properties and change "Display positioning" to a location like "Center".
- **Updates**: If you renumber your elements using a numbering command, the labels on the elements will automatically update to the new numbers.
- **Adjustment**: You can select the element, open the Properties palette (Ctrl+1), and tweak the Horizontal/Vertical offsets to fine-tune the label position without re-running the script.

## FAQ
- **Q: Why didn't text appear when I inserted the script?**
  **A:** The default setting for "Display positioning" is "No display". Select the element, open Properties, and change the positioning option (e.g., to "Center").
- **Q: How do I change the font size?**
  **A:** Select the element, open the Properties palette, and modify the "Text height" parameter.
- **Q: Can I use this on individual beams?**
  **A:** No, this script is designed to attach to Element entities (Walls/Floors). For beams, use a beam-specific label script.