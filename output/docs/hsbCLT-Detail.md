# hsbCLT-Detail.mcr

## Overview
This script creates a parametric detail section marker on CLT panels and generates the corresponding cross-section geometry for drawing production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be attached to a panel/element in 3D model. |
| Paper Space | No | Not supported in Paper Space. |
| Shop Drawing | No | This is a model-space script used to define details that appear in drawings. |

## Prerequisites
- **Required Entities**: GenBeam or Element (CLT Panel).
- **Minimum Beam Count**: 1.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Detail.mcr`

### Step 2: Select Panel
```
Command Line: Select element/beam
Action: Click on the CLT panel or beam where you want to create the detail.
```

### Step 3: Define Section Line Start
```
Command Line: Select first point of section line
Action: Click in the model to place the start point of the detail cut.
```

### Step 4: Define Section Line End
```
Command Line: Select second point of section line
Action: Click to place the end point. The detail view direction is automatically calculated based on which side of the panel the grips are located.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| View Number | Text | A | The identifier for the detail (e.g., "A", "B", "1"). Automatically increments if the chosen number is already used on the panel. |
| Section Full Range | Dropdown | No | Determines if the cut is infinite across the panel ("Yes") or limited to the space between the grips ("No"). |
| Text Height | Number | 1 | Controls the size of the text label and the scaling of the marker symbol. |
| Dimstyle | Dropdown | _DimStyles | The dimension style applied to the text label. |
| Line Type | Dropdown | _LineTypes | The linetype used for the section cutting line. |
| Color | Number | 145 | The color of the section line and marker elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Direction | Reverses the viewing direction of the detail section. Use this if the detail is looking at the wrong side of the panel. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Automatic Direction**: The script automatically determines the view direction by checking which grip is further from the panel profile.
- **Avoiding Duplicates**: If you set the View Number to "A" and it already exists on the same panel, the script will automatically change it to "B" (or the next available value).
- **Scaling**: Adjust the `Text Height` property if the detail callout is too small or too large on your plans.

## FAQ
- Q: How do I make the detail cut through the entire wall length?
- A: Set the `Section Full Range` property to "Yes".
- Q: The detail is pointing the wrong way. How do I fix it?
- A: Select the detail in the model, right-click, and choose `Flip Direction`.
- Q: Why did my view number change from "1" to "2"?
- A: The script detected that "1" was already used on this specific panel and automatically assigned the next available number.