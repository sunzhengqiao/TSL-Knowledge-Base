# hsb_ShowWallInformation.mcr

## Overview
Automatically labels a wall frame on a layout sheet with its definition, nominal dimensions, and calculated total weight based on timber volume.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for Layouts/Sheets. |
| Paper Space | Yes | The script must be run on an active layout containing a viewport. |
| Shop Drawing | No | This is an annotation tool for drawings. |

## Prerequisites
- **Required Entities**: A Viewport containing a hsb Element (Wall).
- **Minimum Beam Count**: 1 (The Element must contain construction beams to calculate volume).
- **Required Settings**: None required, though a Dim Style should exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowWallInformation.mcr`

### Step 2: Pick Location
```
Command Line: Pick a point where the the information is going to be shown
Action: Click anywhere in the Paper Space layout where you want the wall label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border that displays the wall you wish to label.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | Current Dim Styles | Selects the dimension style to control the text height, font, and appearance of the label to match your drawing standards. |
| Timber density (kg/m3) | number | 450 | Enter the density of the wood material (e.g., 450 for Spruce/Pine). This is used to calculate the total frame weight. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom context menu items. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Updating Weight**: If you change the wall geometry (e.g., add studs or change height) in Model Space, the label will automatically update the dimensions and weight.
- **Material Types**: Adjust the `Timber density` property in the Properties palette if you are calculating weight for hardwoods (e.g., 600-700 kg/m³) or engineered timber like LVL.
- **Text Style**: To change the size of the text, either change the `Dim Style` property in the script settings or modify the text height in the selected Dimension Style within AutoCAD.

## FAQ
- **Q: Why does the label disappear?**
  A: The script is linked to a specific viewport. If you delete the viewport, the label will also be deleted.
- **Q: The weight shows as 0.**
  A: Ensure the Element inside the viewport actually contains beams and that the `Timber density` property is not set to 0.
- **Q: How do I move the text?**
  A: Select the script entity in Paper Space and use the grip point to drag it to a new location.