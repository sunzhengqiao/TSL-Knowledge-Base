# hsbDetailDefinition

## Overview
This script creates a definition object in the 3D model to isolate specific timber elements for detailing. It allows you to define a 3D bounding box or a vertical section line, which serves as the clipping volume for generating separate detail views, elevations, or cross-sections in shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely within the 3D model to define cut regions. |
| Paper Space | No | Not applicable for Paper Space. |
| Shop Drawing | No | This script prepares data *for* shop drawings but is inserted in the model. |

## Prerequisites
- **Required Entities**: None required to insert the script, but beams or elements should be selected during insertion to utilize auto-fitting features.
- **Minimum Beam Count**: 0.
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or `tsl` alias) → Select `hsbDetailDefinition.mcr` from the catalog.

### Step 2: Define Base Rectangle
```
Command Line: Give lower left point
Action: Click in the Model Space to set the start corner of the detail's base.
```
```
Command Line: Give upper right point
Action: Click to set the opposite corner. This defines the length (dX) and width (dY) of the detail.
```

### Step 3: Select Entities
```
Command Line: Select entities
Action: Select the beams, elements, or solids you wish to include in the detail. Press Enter to confirm.
```

### Step 4: Configure Properties
After selection, the Properties Palette will display the script parameters.
- If `dZ` (Height) is left at **0**, the script automatically calculates the height to fit all selected entities.
- Adjust the **Detail Name** to ensure it is unique.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sDetailName** | String | \|Detail\| | The unique identifier for this detail. It is used to link the 3D definition to the 2D drawing label. |
| **sType** | List | Detail Definition | Sets the visualization type: <br>• *Detail Definition*: 3D Bounding Box<br>• *Vertical View Definition*: Section line with hollow arrows<br>• *Vertical Section*: Section line with filled arrows |
| **dX** | Double | 500 mm | The length of the detail box along the local X-axis. |
| **dY** | Double | 500 mm | The width of the detail box along the local Y-axis. |
| **dZ** | Double | 0 mm | The height of the detail box. A value of **0** automatically stretches the box to fit the height of selected entities. |
| **sDimStyle** | String | _DimStyles | The text style used for the detail label and markers. |
| **dTxtH** | Double | 150 mm | The height of the text label. |
| **nColor** | Index | 170 | The color of the bounding box/lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Entity** | Prompts you to select additional entities from the model to be included inside the current detail volume. |
| **Remove Entity** | Prompts you to select entities currently inside the detail to remove them from the definition. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal properties and does not rely on external XML settings files.

## Tips
- **Auto-Fit Height**: Leave the `dZ` property set to 0 during insertion. The script will automatically snap the top of the box to the highest point of the selected elements.
- **Visual Editing**: Use the grips in the model view to resize the box dynamically.
    - Drag the **X/Y grips** to resize the base.
    - Drag the **Z grip** (top center) to adjust height. Dragging it below the base will flip the vertical orientation of the detail.
- **Renaming**: If you change the `sDetailName`, the script automatically checks for duplicates. If a name already exists, it will append a counter (e.g., "Detail (1)") to ensure uniqueness.

## FAQ
- **Q: Why is my detail box not showing anything inside it?**
- **A**: Ensure you have actually linked entities to the definition. Use the right-click menu **Add Entity** to select the beams you want to clip. Alternatively, check if your `dX`, `dY`, or `dZ` dimensions are too small to intersect the beams.

- **Q: What is the difference between "Vertical View" and "Vertical Section"?**
- **A**: Both display a section line in the model. "Vertical View" uses hollow arrows, typically used for elevation views, while "Vertical Section" uses filled arrows, typically used for cross-sections.

- **Q: Can I change the type from a Box to a Section Line later?**
- **A**: Yes. Simply select the detail object and change the `sType` property in the Properties Palette. The visualization will update immediately.