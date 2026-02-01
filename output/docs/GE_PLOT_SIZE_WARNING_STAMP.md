# GE_PLOT_SIZE_WARNING_STAMP.mcr

## Overview
This script automatically creates a warning stamp (e.g., "WIDE LOAD") in Paper Space. It detects if an element viewed through a specific viewport exceeds a defined size limit and displays the warning text only when the limit is surpassed.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script functions specifically in Layouts (Paper Space). |
| Paper Space | Yes | Script must be inserted on a layout page containing an hsbCAD viewport. |
| Shop Drawing | No | Designed for production layouts to flag oversized elements. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) with an active hsbCAD Viewport displaying an Element (Wall/Beam).
- **Minimum beam count**: 0 (Checks the entire Element geometry).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_SIZE_WARNING_STAMP.mcr`

### Step 2: Configure Warning Properties
A dialog appears automatically upon insertion.
- **Action**: Adjust settings such as the text message ("WIDE LOAD"), maximum size limit, and rotation angle. Click OK to confirm.

### Step 3: Select Location
```
Command Line: Select location
Action: Click in the Paper Space layout where you want the warning text to appear (usually near the element).
```

### Step 4: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click the border of the viewport that shows the element you want to monitor.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | (Current) | Selects the CAD dimension style to control font and layer properties. |
| Text Height (0 Uses DimStyle) | number | 0 | Sets the text height in drawing units. Enter 0 to use the height defined in the DimStyle. |
| Max Size | number | 102.25 | The maximum size allowed in inches. If the element is larger than this, the warning appears. |
| Angle for Text | number | 15 | The rotation angle of the text stamp in degrees. |
| Direction To Check | dropdown | Element Y(Height) | Determines which dimension to check: Height, Width, or Both. |
| Text to Draw | text | WIDE LOAD | The specific message displayed on the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu items are added. Use the Properties Palette to modify parameters. |

## Settings Files
- No external settings files are used for this script.

## Tips
- **Moving the Stamp**: Select the script instance in Paper Space and use the grip point to drag the text to a new location without losing settings.
- **Dynamic Updates**: If you modify the Element in Model Space (e.g., make it smaller), the script will automatically re-evaluate and may hide the warning text if it no longer exceeds the limit.
- **Transport Limits**: The default Max Size (102.25 inches) approximates the standard US transport width limit. Adjust this value based on local regulations.

## FAQ
- **Q: Why is the text not showing up?**
  **A**: The element in the selected viewport might be smaller than the "Max Size" threshold. Try lowering the "Max Size" parameter in the Properties Palette or check if the "Direction To Check" matches the element's orientation.
- **Q: Can I change the text color?**
  **A**: The script hardcodes the color to Red to act as a warning. You can change the layer color in the AutoCAD Layer Properties Manager if necessary.
- **Q: The text is too small.**
  **A**: Increase the "Text Height" value in the Properties Palette. If it is set to 0, change the Text Height setting in the selected "DimStyle" or set a specific number in the script properties.

---