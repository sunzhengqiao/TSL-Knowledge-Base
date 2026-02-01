# hsb_Element Code

## Overview
This script automatically generates and attaches text labels to wall elements. It displays the element's Model Code, Size, and Description directly in the 3D model based on the element's properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in 3D model space. |
| Paper Space | No | Not intended for Layout usage. |
| Shop Drawing | No | Not intended for Shop Drawing generation. |

## Prerequisites
- **Required entities**: ElementWallSF (Wall elements) must exist in the model.
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Element Code.mcr` from the file browser.

### Step 2: Configure Properties
Upon insertion, a properties dialog will appear automatically.
- **Action**: Adjust settings like the Dimension Style, Color, or Offsets if necessary. Click OK to proceed.

### Step 3: Select Elements
```
Command Line: Please select Elements
Action: Click on the Wall elements (ElementWallSF) you wish to label. Press Enter to confirm selection.
```

### Step 4: Automatic Generation
- **Action**: The script will automatically attach to the selected elements and generate the text labels based on their individual properties.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the text style (font, size) used for the label. |
| Color | number | 130 | Sets the AutoCAD color index for the text label. |
| Offset from Wall | number | 250 mm | Sets the distance from the wall surface where the label is placed for standard elements. |
| Offset btw Lines | number | 150 mm | Sets the distance used for elements with complex descriptions (containing a "/"). |
| Set Rotation | number | 0° | Rotates the text label around the element's vertical axis. |
| Disp Rep Header | text | [Empty] | Filters visibility by Display Representation (e.g., "_3D", "_Plan"). Leave empty to show in all views. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu items are added by this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Interactive Rotation**: After insertion, you can select the label and use the **graphical grip** (blue dot) to drag and rotate the text interactively in the model.
- **Smart Labeling**: If an element's name contains a "/" (indicating operation info, like a lintel), the script automatically switches to the "Offset btw Lines" distance to position the label correctly.
- **Updates**: If you modify the host wall element, the label will automatically update to reflect the new geometry or properties.

## FAQ
- **Q: Why is my label appearing inside the wall?**
  - A: Increase the "Offset from Wall" value in the Properties panel.
- **Q: How do I hide the text in Plan view but keep it in 3D?**
  - A: Enter the Display Representation code for the view you want (e.g., `_3D`) in the "Disp Rep Header" property.
- **Q: Can I change the text height?**
  - A: The text height is controlled by the "Dimstyle" setting. Select a different Dimstyle that defines a larger text height.