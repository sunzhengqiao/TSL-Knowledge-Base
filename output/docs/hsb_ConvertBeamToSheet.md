# hsb_ConvertBeamToSheet.mcr

## Overview
Converts existing structural beams into sheet materials (such as plywood or OSB) based on specific beam codes or construction zones. It creates new sheet entities, copies properties from the original beams, and deletes the old beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements and Beams. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Elements containing Beams.
- **Minimum beam count**: 0 (Script functions, but requires beams to perform conversion).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ConvertBeamToSheet.mcr` from the file list.

### Step 2: Configure Properties
After insertion, the **Properties Palette** (usually accessible by pressing `Ctrl+1`) will display the script parameters. Adjust the **Convert Type**, **Filter Codes**, **Zone**, or **Color** as needed before proceeding to selection.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements (e.g., walls, floors) containing the beams you wish to convert and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Convert Type | dropdown | \|By Beam Code\| | Determines how the script selects beams for conversion. Choose between "By Beam Code" or "By Zone". |
| Convert Beams with Code | text | | A list of beam codes to filter. Separate multiple codes with a semicolon (;). Only used if "By Beam Code" is selected. |
| Zone to Select or Assign | dropdown | 0 | The construction zone index to use for filtering (if "By Zone" is selected) or to assign the new sheets to. |
| Color for the new sheet | number | 6 | The display color for the generated sheets. Enter `-1` to keep the original beam's color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script runs immediately upon element selection and erases itself from the drawing afterwards. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Multiple Codes**: When using "By Beam Code", you can target multiple types of beams at once (e.g., `STUD;RIB;BATTEN`).
- **Color Inheritance**: Setting the color to `-1` is useful if you want the new sheets to visually match the specific materials or layer colors of the beams they are replacing.
- **Undo**: The conversion modifies the database (creating sheets and erasing beams). Use the standard AutoCAD `UNDO` command if you make a mistake.

## FAQ
- **Q: What happens to the original beams?**
- **A: The original beams are deleted from the model and replaced by the new sheet entities. Ensure you have a backup or use Undo if needed.
- **Q: Can I use this to convert sheathing applied to a wall?**
- **A: Yes. If your sheathing is modeled as individual beams (like "Ribs"), this script can convert them into single sheet elements if they match the specified filter.
- **Q: Why did nothing happen?**
- **A: Check that your filter codes (if using Code mode) exactly match the beam codes in the model, or that the selected elements actually contain beams in the specified Zone (if using Zone mode).