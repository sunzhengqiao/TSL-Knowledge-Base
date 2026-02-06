# hsbPropertyComposer.mcr

## Overview
This script composes a new property value for selected beams by extracting, formatting, and combining existing attributes (like dimensions or labels). It acts as a data management utility to automate renaming or re-labeling elements based on their current properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to modify properties of General Beams. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities:** General Beams (GenBeams) must exist in the drawing.
- **Minimum beam count:** 1.
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPropertyComposer.mcr` from the list.

### Step 2: Select Execution Mode
The script will prompt: `Select entity(s) |<Enter> to insert setup instance|`

You have two options:
1.  **Batch Processing:** Select one or multiple beams using a window or crossing selection and press **Enter**. The script will apply the current settings to all selected beams immediately and finish.
2.  **Setup/Preview Mode:** Press **Enter** without selecting anything.
    - The script will prompt: `Pick a point` (Click anywhere in the model).
    - The script will prompt: `Select GenBeam` (Click on a single beam).
    - The script instance will remain in the drawing, showing a preview of the result.

### Step 3: Configure Parameters (Setup Mode Only)
If you entered Setup Mode, select the script instance and open the **Properties Palette** (Ctrl+1). Adjust the parameters (Format, Mode, Property, Replace) to see the preview update dynamically. Once satisfied, erase the script instance to commit the changes to the single beam, or use the settings to run a Batch Process.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | Text | @(Name) | The template used to construct the new value. <br>Examples: <br>• `@(Label)` <br>• `@(Width) x @(Height)` <br>• `@(Label:L2)` (First 2 chars) <br>• `@(Width:RL1)` (Rounded length) |
| Property(s) | Dropdown | Erase | Determines what happens to the source data used in the Format string. <br>• **Erase:** Removes the source properties after copying. <br>• **Keep:** Leaves the source properties intact. |
| Property | Dropdown | Name | The destination field where the composed string will be written (e.g., Name, Material, Information, Label). |
| Replace | Text | | Defines character replacements. Format: `Source;Target`. <br>Example: ` ;_` replaces all spaces with underscores. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Preview before Batch:** Always use "Setup/Preview Mode" (Step 2, option 2) on a single beam to verify your Format string is correct before running it on a large selection.
- **Data Cleaning:** Use the "Erase" mode to clean up your data structure by moving values from temporary fields (like Label) into the final Name field and removing the temporary data.
- **Advanced Formatting:** You can use mathematical rounding or token extraction in the Format field (e.g., extracting "AW" from "EG AW 2" using token logic).

## FAQ
- **Q: What happens if I select multiple beams?**
- **A:** The script enters "Batch Processing" mode. It applies the current property settings to all selected beams and then removes itself from the drawing immediately.
- **Q: How do I fix a mistake if I used "Erase" mode?**
- **A:** You cannot easily undo the erasure of source properties unless you use the standard AutoCAD Undo command immediately after execution.
- **Q: Can I change the order of text?**
- **A:** Yes, simply rearrange the tags in the Format string (e.g., change `@(Label) @(Width)` to `@(Width) @(Label)`).