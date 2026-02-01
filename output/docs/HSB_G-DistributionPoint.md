# HSB_G-DistributionPoint.mcr

## Overview
This script inserts a 3D graphical symbol into the model to represent a specific distribution point for logistics or planning. It displays a unique ID number and vertical elevation markers, helping to organize material placement or sheet distribution locations on site.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The symbol is placed in 3D world coordinates. |
| Paper Space | No | Not intended for layout sheets. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities**: None
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-DistributionPoint.mcr`

### Step 2: Select Position
```
Command Line: Select position
Action: Click in the drawing area to specify the location for the distribution point.
```
*Note: The script will project the point to the current construction plane height.*

### Step 3: Specify Distribution Number
```
Command Line: Specify distribution number <1>
Action: Type a unique number for this point and press Enter. If you press Enter without typing, the script defaults to 1.
```

### Step 4: Specify Height
```
Command Line: Specify height <0.0>
Action: Type a vertical offset value and press Enter. If you press Enter without typing, the script defaults to 0.0.
```
*Note: This value shifts the symbol vertically from the location selected in Step 2.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution number | Number | 0 | The unique identifier label displayed in the center of the symbol. |
| Symbol size | Number | 100 | The physical size (diameter) of the distribution marker. Increasing this scales the circle, arrows, and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Scaling**: Use the **Symbol size** property to ensure the text and markers are legible depending on the scale of your model views.
- **Planning**: Use these markers to indicate crane drop zones, material stacking areas, or specific sheet delivery locations on the construction site plan.
- **3D Movement**: You can use standard AutoCAD grips to drag the symbol to a different elevation or plan location if the site plan changes.

## FAQ
- **Q: How do I change the number after I have already placed the symbol?**
- **A**: Select the symbol in the model, open the Properties Palette (Ctrl+1), and change the value in the "Distribution number" field.
- **Q: Can I change the height after insertion?**
- **A**: Yes. You can select the symbol and use the standard Move command or drag the 3D grip to a new Z-height.
- **Q: What happens if I enter text instead of a number for the ID?**
- **A**: The script will default to 0 if it cannot parse the input as a number.