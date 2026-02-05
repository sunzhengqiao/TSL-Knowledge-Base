# HSB_T-GrainDirection

## Overview
This script visualizes the grain direction (fiber orientation) and marks the visible "view side" (Z-side) of timber sheets in the 3D model. It is used to ensure panels are manufactured and installed with the correct orientation and surface finish.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates visual overlays (PLine and Mark) on Sheet entities in the 3D model. |
| Paper Space | No | This script does not function in Layout views. |
| Shop Drawing | No | This is for detailing the 3D model, not generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: An existing **Sheet** entity (e.g., CLT panel or timber wall).
- **Minimum Beam Count**: 0 (This script operates on Sheets, not Beams).
- **Required Settings**: The Sheet must have the property set `hsbGeometryData` attached (standard in hsbCAD).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `HSB_T-GrainDirection.mcr` from the file browser.

### Step 2: Configure Properties (Optional)
A dialog may appear upon insertion. You can modify:
- **Color grain direction**: The color index for the arrow (Default: 1/Red).
- **Mark view side**: Set to "Yes" to show the text label (Default: Yes).
- **Mark text**: The character to display (Default: Z).

### Step 3: Select Sheets
```
Command Line: |Select sheets|
Action: Click on one or more Sheet entities in the model, then press Enter.
```
*The script will automatically attach a visual arrow and text label to each selected sheet.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color grain direction | Number | 1 | Sets the CAD color (Index 1-255) of the grain direction arrow. |
| Mark view side | Dropdown | Yes | Determines if the "View Side" text label (e.g., "Z") is displayed on the sheet. Options: Yes / No. |
| Mark text | Text | Z | The text content for the view side label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap grain direction | Toggles the grain orientation (e.g., switching between major and minor strength axes). Can also be triggered by double-clicking the script instance. |
| Swap view side | Flips the visual arrow and text to the opposite face of the sheet. |
| Remove grain direction | Removes the visual symbols and resets the grain direction property on the Sheet. |

## Settings Files
- **None required**: This script does not rely on external XML or configuration files.

## Tips
- **Quick Swap**: You can double-click the grain direction arrow in the model to quickly toggle the grain direction without opening the right-click menu.
- **Visibility**: If the arrow is hard to see against the sheet material, select the script instance and change the "Color grain direction" property in the Properties Palette to a contrasting color (e.g., Yellow or Magenta).
- **Facing**: Use the "Swap view side" option if the arrow is pointing into the wall rather than outwards.

## FAQ
- **Q: The arrow is pointing to the wrong face of the panel.**
  - A: Right-click the script instance and select "|Swap view side|". This flips the normal vector so the arrow moves to the other side.
- **Q: I don't want to see the text label, only the arrow.**
  - A: Select the instance in the model, open the Properties Palette (Ctrl+1), and change "Mark view side" to "|No|".
- **Q: How does this affect manufacturing/CNC?**
  - A: This script updates the `hsbGeometryData` property set. The grain direction setting is often used by CAM modules to determine how a panel should be nested or processed.