# hsb_DimensionStuds

## Overview
This script automatically generates 2D shop drawing dimensions for stud spacing and specific beam locations within a wall panel. It is designed to annotate the position of studs, cripples, and blocking relative to the start or end of a wall panel directly on a Paper Space layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for 2D annotations only. |
| Paper Space | Yes | Script requires a selected Viewport to function. |
| Shop Drawing | Yes | Specifically designed for production drawings and layouts. |

## Prerequisites
- **Required Entities**: An Element (e.g., a Wall) must exist in the drawing.
- **Minimum Beams**: 1 (The script searches for beams within the selected element).
- **Required Settings**: The drawing must contain a Layout with an active Viewport displaying the element to be dimensioned.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select the `hsb_DimensionStuds.mcr` file from the script directory.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport on the layout that shows the wall/element you wish to dimension.
```
*Note: The viewport must contain an Element. If no viewport is selected, the script will terminate.*

### Step 3: Configure Properties
Action: Once inserted, select the script object in the drawing (or while it is running) and open the **Properties Palette** (Ctrl+1). Adjust the parameters listed below to change the dimension style, offset, and filter options.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show as | Dropdown | Line and Text | Determines the visual style. Choose **Line and Text** for individual labels with leaders, or **Dimension Line** for a standard continuous dimension chain. |
| Dim Style | Dropdown | *Current* | Selects the specific Dimension Style (from CAD standards) to control arrowheads, font, and precision. |
| Show Bottom Dimension | Dropdown | Start | Defines the reference point for dimensions: **Start** (left face), **End** (right face), **Center**, or **None** (disable). |
| Offset from element | Number | 100 | The distance (mm) from the bottom edge of the wall element to the dimension line. Increase this if dimensions overlap with other details. |
| Include Beam With BeamCode | Text | *Empty* | Filters specific "turned" beams (e.g., blocking/dwang) to include in the dimension. Enter Beam Codes separated by semicolons (e.g., `BLOCK;STRUT`). |
| Dimension Orientation | Dropdown | Parallel | Controls how dimension text is aligned. **Parallel** runs text horizontally with the line; **Perpendicular** rotates it vertically. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the dimensions if the wall geometry or stud positions have changed. |
| Erase | Removes the script and the generated dimensions from the drawing. |

## Settings Files
No external settings files are required for this script. It relies on standard hsbCAD Element data and AutoCAD Dimension Styles.

## Tips
- **Dimensioning Blocking**: By default, the script may ignore horizontal blocking (beams laid flat/turned). Use the **Include Beam With BeamCode** property and type the specific codes (e.g., `DWANG`) to force these to be dimensioned.
- **Avoiding Clutter**: If your drawing has notes or dimensions near the bottom plate, increase the **Offset from element** value to move the stud dimensions further down.
- **Appearance**: To change arrows or text size, do not change script properties; instead, modify the AutoCAD **Dim Style** selected in the properties and run **Recalculate**.

## FAQ
- **Q: Why are my studs not showing up in the dimension?**
  **A:** Ensure the selected viewport actually contains an Element. Also, check if the studs are part of that Element.
- **Q: Why are my blocking struts missing?**
  **A:** The script filters out "turned" beams (where width > height) unless specified. Add the Beam Code of your blocking to the **Include Beam With BeamCode** property.
- **Q: The dimension text is upside down.**
  **A:** Change the **Dimension Orientation** property to "Parallel" or "Perpendicular", or check your AutoCAD Dim Style text rotation settings.