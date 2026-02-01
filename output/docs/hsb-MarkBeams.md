# hsb-MarkBeams.mcr

## Overview
Automatically applies assembly marks to timber beams to indicate intersection points with connecting members, facilitating on-site assembly and factory production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in 3D model space to place marks on beam faces. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Marks are applied directly to the 3D model entities. |

## Prerequisites
- **Required Entities**: At least one `Element` containing `Beams` (GenBeams).
- **Minimum Beam Count**: 1 (within selected elements).
- **Required Settings/Dependencies**: The TSL script `HSB_G-FilterGenBeams` must be loaded in the drawing to use the filtering functionality.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `hsb-MarkBeams.mcr` from the list.

### Step 2: Configure Marking Settings
```
Command Line: N/A (Properties Dialog or Palette)
Action: A dialog or the Properties Palette appears. Choose the "Marking side" (e.g., Intersection Face) and "Marking options" (e.g., Left & Right).
```
*Note: You can also change these settings after insertion by selecting the element and checking the Properties Palette.*

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the Element(s) (e.g., a wall frame or roof assembly) that contain the beams you want to mark. Press Enter to confirm.
```
*The script will automatically process the beams within the selected elements and apply the marks.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Marking side | Dropdown | Intersection Face | Determines which face of the beam receives the mark. "Intersection Face" places it where beams meet; "Front/Back" uses the element's coordinate system. |
| Filter definition for beams to mark | Dropdown | (Empty) | Limits which beams receive marks based on properties defined in the `HSB_G-FilterGenBeams` script (e.g., only mark "Studs"). |
| Marking options | Dropdown | Left & Right | Sets the horizontal placement of the mark. "Left & Right" places marks on both edges; "Center" places one mark on the centerline. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the script instance from the element, which also deletes all generated marks. |
| (Standard hsbCAD context items) | Standard properties and modification commands available for the Element or TSL instance. |

## Settings Files
This script does not use specific external settings files, but relies on the **HSB_G-FilterGenBeams** TSL to provide filter definitions.

## Tips
- **Filtering Beams**: To avoid marking every beam (like blocking), use the "Filter definition" property. Ensure `HSB_G-FilterGenBeams` is loaded to populate the dropdown options.
- **Visualizing Marks**: Marks are applied as "Mark" tools. If they are not visible, check your layer visibility or display style in the 3D model.
- **Updating**: If you modify the geometry of the beams or move the element, the script will automatically recalculate and move the marks to the correct positions.

## FAQ
- **Q: I see a warning message about "Beams could not be filtered". What does this mean?**
- A: The required helper script `HSB_G-FilterGenBeams` is not loaded in your current drawing. Load it via the `TSLINSERT` command or your project template, and then run the script again.
- **Q: How do I remove the marks without deleting the beams?**
- A: Select the Element(s) that were marked, find the `hsb-MarkBeams` instance in the model or properties, and erase it. Alternatively, use the "Erase" command on the script instance.
- **Q: The marks appear on the wrong side of the beam.**
- A: Select the Element and change the "Marking side" property in the Properties Palette from "Intersection Face" to "Front Face" or "Back Face".