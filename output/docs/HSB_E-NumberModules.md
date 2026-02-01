# HSB_E-NumberModules.mcr

## Overview
This script automatically renumbers modules within a selected Element based on their spatial position from left to right. It updates the 'Module' property for all beams in the element and creates visual indicators (diagonal lines and text labels) to display the new numbering.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not intended for 2D layout or detailing views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities**: An `Element` entity containing beams.
- **Minimum beam count**: 0 (Note: Beams must have an existing 'Module' property assigned to be processed; beams with empty module names are ignored).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-NumberModules.mcr` from the file browser.

### Step 2: Configure Options (Optional)
If a specific preset (Execute Key) is not selected, the Properties Palette may open, or you can adjust settings immediately after insertion.
- Set visual preferences like **Textheight** or toggle **Show diagonal line**.
- Press **Esc** or click in the drawing area to proceed.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Element(s) you wish to process. Press Enter to confirm selection.
```
The script will automatically process the selected elements, renumbering the modules and attaching a satellite instance to each element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Show diagonal line** | dropdown | Yes | Toggles the visibility of a diagonal line drawn across the bounding box of each module. |
| **Show module number** | dropdown | Yes | Toggles the visibility of the text label displaying the new module number at the module's center. |
| **Textheight** | number | U(20) | Sets the font size (height) for the module number text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. Use the Properties Palette (OPM) to modify settings. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Pre-requisite Check**: Ensure your beams actually have a value in the "Module" property before running this script. Beams with empty module fields are ignored and will not be renumbered.
- **Visualization**: The diagonal line connects the lower-left and upper-right corners of the module's calculated bounding box, helping you visually verify the grouping.
- **Renaming Logic**: The script renames modules sequentially based on their position (Left to Right) using the format `ElementNumber-Index` (e.g., 100-1, 100-2).
- **Adjusting Visuals**: You can change the text height or toggle lines after insertion by selecting the Element or the TSL instance and changing the properties in the OPM.

## FAQ
- **Q: I ran the script, but no numbers appeared.**
  - A: Check if the **Show module number** property is set to "Yes". Also, ensure the beams inside the element actually had a "Module" name assigned prior to running the script.
- **Q: How do I update the numbering if I add new beams to the element?**
  - A: Delete the existing TSL instance associated with the element and re-run the insert command to recalculate positions and names.
- **Q: What happens to beams that have no Module name?**
  - A: They are ignored by the script. Only beams grouped under an existing module name are sorted and renumbered.