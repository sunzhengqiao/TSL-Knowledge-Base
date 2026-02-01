# HSB_D-GutterHeights

## Overview
This script automatically annotates the vertical Z-heights (gutter levels) of roof sheets or slopes on a 2D drawing layout. It places dimension labels at the highest and lowest points of sheet profiles relative to the element origin, facilitating accurate detailing in Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for 2D layouts only. |
| Paper Space | Yes | Script must be inserted on a Layout tab containing a Viewport. |
| Shop Drawing | No | Works with standard Elements and Sheets. |

## Prerequisites
- **Required Entities**: An hsbCAD Element containing Sheets (e.g., roof gutter parts) visible in a Viewport.
- **Minimum Beams**: N/A (Script works with Element/Sheet geometry).
- **Required Settings**:
  - Target Sheets must have a SubMap named 'Rotation' OR a SubLabel matching the `sManualRotation` property.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `Run TSL` depending on your environment configuration)
Action: Browse and select `HSB_D-GutterHeights.mcr`.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport on your layout that displays the Element (e.g., roof) you wish to annotate.
```

### Step 3: Place Script Instance
```
Command Line: Select a point
Action: Click anywhere in the Paper Space to place the script instance marker.
Note: This point determines where the script object is stored; it does not determine the position of the text labels.
```

### Step 4: Configure Properties (Optional)
Action: The Properties Palette will open automatically upon insertion. Adjust settings like text prefix or offset distance if the default placement is not ideal.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **\|Gutter dimension\|** | PropString | | Visual separator/header. |
| Prefix | Text | "Gooth = " | The text label appearing before the height value (e.g., "Height = ", "Z = "). |
| Offset | Number | 10.0 | The distance (in mm) from the sheet edge to the dimension text in Paper Space. Increase if text overlaps geometry. |
| **\|Style\|** | PropString | | Visual separator/header. |
| Dimension style | Dropdown | _DimStyles | The CAD dimension style (font, size, arrow) applied to the labels. |
| Sublabel manual rotated sheets | Text | "Helling" | Filter used to identify manually rotated sheets if they do not have a standard 'Rotation' SubMap. |

## Right-Click Menu Options
This script does not add specific custom actions to the right-click context menu.

## Settings Files
No external settings files (XML/INI) are required for this script. All configuration is handled via the Properties Panel.

## Tips
- **Adjusting Text Position**: If the dimension text is too close to or overlapping the sheet, increase the `Offset` property value in the Properties Palette.
- **Filtering Sheets**: If the script does not dimension specific gutter sheets, check the SubLabel of those sheets in the Model. Ensure the `sManualRotation` property matches that SubLabel.
- **Script Placement**: The point you click in Step 3 merely saves the script instance in the drawing. The actual dimension labels are locked to the sheet geometry inside the viewport. Moving the script instance point will not move the text.

## FAQ
- **Q: Why did the script disappear immediately after insertion?**
  A: The script requires a valid Viewport containing an Element. If the selected viewport is empty or invalid, the script erases itself automatically. Select a valid viewport and try again.
- **Q: No height labels appeared on my drawing.**
  A: Ensure the sheets inside the viewport match the criteria. They must either have a 'Rotation' SubMap or a SubLabel matching the `sManualRotation` property (default: "Helling").
- **Q: Can I change the text from "Gooth =" to "Height ="?**
  A: Yes. Select the script instance, open the Properties Palette, and change the `Prefix` text.