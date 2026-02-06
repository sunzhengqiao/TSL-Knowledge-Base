# hsb_ShowGenbeamInformation.mcr

## Overview
This script attaches customizable text labels to Generic Beams (GenBeams) directly in the 3D model. It displays various beam properties—such as dimensions, material, position number, and user labels—allowing you to visualize critical production data without generating 2D drawings.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. Labels are attached to 3D beam geometry. |
| Paper Space | No | Not supported for direct insertion. |
| Shop Drawing | No | Not designed for use within hsbCAD Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: Generic Beams (GenBeams) must exist in the model.
- **Minimum Beam Count**: 1 or more.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowGenbeamInformation.mcr` from the file list.

### Step 2: Configure Label Properties (Optional)
Upon running the command, the Properties Palette (OPM) will open. Before selecting beams, you can adjust default settings such as Text Height, Color, and which data fields to display.

### Step 3: Select Beams
```
Command Line: Please select Beams
Action: Click on the GenBeams you wish to label and press Enter.
```
*Note: You can select multiple beams at once. The script will automatically attach a separate label instance to each selected beam.*

### Step 4: Adjust Labels
After insertion, you can select the text labels to use **Grips** to fine-tune their position and rotation in the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | String | *(Empty)* | Select an existing Dimension Style name to control the font and appearance of the text. |
| Color | Number | 130 | Sets the color of the text (AutoCAD Color Index 0-255). |
| Enter Text Height | Number | 80 | Defines the height of the text label in millimeters. |
| Offset from Beam | Number | 250.0 | Sets the initial distance from the beam centroid to the text. (Note: This becomes read-only if you manually move the text). |
| Set Rotation | Number | 0.0 | Sets the initial rotation angle of the text in degrees. (Note: This becomes read-only if you manually rotate the text). |
| Disp Rep Header | String | *(Empty)* | Filters visibility so the label only appears in specific Display Representations (e.g., "Plan", "3D"). |
| Delimiters between properties | String | - | The character used to separate data points (e.g., " - "). You can separate multiple options with a semicolon (e.g., "-|;"). |
| Show Name | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show and define the **order** in the label (1 is first). |
| Show Material | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show Material and define the order. |
| Show Grade | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show Grade and define the order. |
| Show Information | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show the Information field and define the order. |
| Show Label | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show the Label field and define the order. |
| Show SubLabel | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show the SubLabel field and define the order. |
| Show SubLabel2 | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show the SubLabel2 field and define the order. |
| Show Width | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show beam Width and define the order. |
| Show Height | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show beam Height and define the order. |
| Show Length | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show beam Length and define the order. |
| Show Posnum | Dropdown | No | Set to "No" to hide. Set to a number (1-11) to show Position Number and define the order. |

## Right-Click Menu Options
This script does not add custom items to the right-click context menu. Standard hsbCAD options (Erase, Properties, etc.) are available when the label is selected.

## Settings Files
None required.

## Tips
- **Ordering Data**: Use the numbered options (1-11) in the "Show..." properties to sort your label string. For example, if you want the Position Number first, set "Show Posnum" to `1`. If you want Length second, set "Show Length" to `2`.
- **Moving Labels**: Use the square grip to move the text insertion point and the directional grip to rotate the text. Once moved manually, the "Offset from Beam" and "Set Rotation" properties in the palette will lock to avoid conflicts.
- **Updating Dimensions**: If you stretch or modify the beam length/width after the label is attached, the text will automatically update to reflect the new dimensions.
- **Visibility Control**: If the labels clutter your 3D view, use the "Disp Rep Header" property to assign them to a specific view style (like "Annotation"), or simply turn off the layer containing the labels.

## FAQ
- **Q: Why can't I change the "Offset from Beam" number in the properties?**
- **A:** This property locks after you manually move the text using on-screen grips. To use the offset setting again, erase the label and re-run the script on the beam, or edit the coordinate data directly in advanced properties.
- **Q: Can I use this to label elements other than GenBeams?**
- **A:** No, this script is designed specifically to read properties from Generic Beams (GenBeams).
- **Q: What does the "Delimiter" do?**
- **A:** It separates the different pieces of information in the label. If you set it to " | ", a label showing Name and Material would look like: `BeamName | Material`.