# HSB_W-SetWidthTopPlate.mcr

## Overview
This script modifies the width of the top plate beam within a selected wall element. It automatically identifies the top-most beam based on the element's orientation and adjusts its dimensions to your specification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Use in the 3D model to modify wall geometry. |
| Paper Space | No | Not supported in 2D layouts. |
| Shop Drawing | No | This is a modeling script, not a detailing script. |

## Prerequisites
- **Required entities**: A wall Element containing Beams.
- **Minimum beam count**: At least one beam running parallel to the element's X-axis.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-SetWidthTopPlate.mcr` from the file dialog.

### Step 2: Specify New Width
```
Dialog Box: Enter the new width.
Action: Type the desired width value (e.g., 45) and click OK.
```
*Note: A default value is provided in the properties or dialog.*

### Step 3: Select Wall Element
```
Command Line: Select elements
Action: Click on the wall element that contains the top plate you want to resize.
```
*Note: The script will automatically attach, process the wall, update the beam, and then detach itself.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New beam width | Number | 19mm | Sets the new width for the top plate beam. |

## Right-Click Menu Options
None. This script executes immediately upon insertion and does not remain attached to the element for future right-click interactions.

## Settings Files
None required.

## Tips
- **Orientation matters**: The script calculates the "top" based on the element's local Y-axis. Ensure your element is correctly rotated in the model before running the script.
- **Beam alignment**: The script specifically looks for beams whose length vector is orthogonal to the Element Y-axis (effectively parallel to the wall plates).
- **Positioning**: When the width changes, the script automatically shifts the beam position along the Y-axis to keep the modification centered relative to the original position.

## FAQ
- **Q: Why didn't my beam change?**
  **A**: Ensure the beam you want to modify is actually the top-most beam in the element's local Y-direction and that it runs parallel to the element's X-axis.
- **Q: Does this work on multiple walls at once?**
  **A**: You can select multiple elements during the "Select elements" prompt, and the script will attempt to apply the change to all of them.