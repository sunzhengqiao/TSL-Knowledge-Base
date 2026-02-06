# hsb_ShowPOSNumSoleplate.mcr

## Overview
This script automatically annotates structural beams—specifically Soleplates and Headbinders—with their Position Numbers (POS). It draws the number inside a Circle (for Soleplates) or a Rectangle (for Headbinders) and allows for visual customization via the Properties Panel.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D beams in the model. |
| Paper Space | No | Not designed for use in Layout tabs. |
| Shop Drawing | No | Not intended for generation within shop drawing views. |

## Prerequisites
- **Required Entities**: Beams must exist in the model.
- **Naming Convention**: Beams must be named exactly `SOLEPLATE` or `HEADBINDER` (case-insensitive) to be recognized.
- **Position Numbers**: Selected beams must have a valid Position Number assigned (POS number cannot be -1).
- **Minimum Beams**: You must select at least one beam during insertion.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Select `hsb_ShowPOSNumSoleplate.mcr` from the file list.

### Step 2: Configure Initial Settings
1.  If no catalog preset is active, a dialog may appear to set initial properties (such as Offset, Color, etc.).
2.  Adjust values if necessary and click OK.

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: Click on the beams you wish to label (Soleplates or Headbinders) and press Enter.
```
*Note: The script will immediately filter the selection. Beams with incorrect names or missing POS numbers will be ignored.*

### Step 4: Adjust Visuals (Optional)
1.  Select the generated script instance in the drawing (if visible) or use Quick Select to find it.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Modify `X Offset`, `Y Offset`, `Dim Style`, or `Color` to adjust the label appearance and location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **X Offset** | Number | 2 mm | Moves the label along the length of the beam (longitudinal axis). |
| **Y Offset** | Number | 2 mm | Moves the label perpendicular to the beam. <br>• **Soleplate**: Moves in positive Z direction (up).<br>• **Headbinder**: Moves in negative Z direction (down). |
| **Show in Disp Rep** | Text | (Empty) | Limits label visibility to specific Display Representations (e.g., "Presentation"). Leave empty to show in all. |
| **Dim Style** | Dropdown | _DimStyles | Sets the text style (font and size). <br>*Note: The Circle or Rectangle size automatically scales to 1.2x the text height defined in this style.* |
| **Color** | Number | -1 | Sets the color of the text and outline shape. Use -1 for "ByBlock" (default layer color). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. Use the standard Properties Palette to modify parameters. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on internal logic and standard AutoCAD Dimension Styles rather than external XML settings files.

## Tips
- **Label Shape**: The script automatically chooses the shape based on the beam name: **SOLEPLATE** gets a Circle, **HEADBINDER** gets a Rectangle.
- **Sizing**: If the text looks too small or the surrounding shape is too tight, change the `Dim Style` property to a style with larger text height. The geometry will resize automatically.
- **Direction**: Remember that the `Y Offset` behaves differently depending on whether the beam is a Soleplate or a Headbinder (Up vs. Down).
- **Troubleshooting**: If the script seems to disappear immediately after running, it likely means no valid beams were found (wrong name or missing POS number).

## FAQ
- **Q: Why did the script not create any labels?**
  **A:** Check the beam names. They must be exactly "SOLEPLATE" or "HEADBINDER". Also, ensure the beams have a Position Number assigned (not -1).
- **Q: How do I change the size of the circle or rectangle?**
  **A:** You cannot resize the shape directly. Change the `Dim Style` property to a style with a different text height. The label and its bounding shape will scale together.
- **Q: The labels are appearing in the wrong view style.**
  **A:** Enter a valid Display Representation name (e.g., "Model" or "Presentation") in the `Show in Disp Rep` property to restrict visibility.