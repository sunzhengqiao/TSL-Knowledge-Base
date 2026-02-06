# hsb_SetHeaderDescriptionOnPropSet

## Overview
Automatically extracts header descriptions from specific text labels placed near wall openings and writes them into the 'Door Schedule' PropertySet for scheduling and tagging purposes.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the Model Space where the wall elements and text labels exist. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This script operates on the 3D model structure, not 2D drawings. |

## Prerequisites
- **Required Entities**:
  - Wall Elements containing Openings.
  - **ElemText** entities must exist near the openings to serve as the source data.
- **Specific Text Settings**:
  - The ElemText entities must have `Text Code` set to `WINDOW`.
  - The ElemText entities must have `Text SubCode` set to `HEADER`.
- **Property Sets**:
  - The script targets a PropertySet named `Door Schedule`. It will create or update the field `Header_Description` within this set on the Opening entities.

## Usage Steps

### Step 1: Launch Script
**Command**: Type `TSLINSERT` in the command line or run via your custom toolbar icon.
**Action**: Select `hsb_SetHeaderDescriptionOnPropSet.mcr` from the file dialog.

### Step 2: Select Walls
```
Command Line: Select an Elements
Action: Click on the Wall Elements that contain the openings you wish to update. You can select multiple walls.
```

### Step 3: Confirm Selection
```
Action: Press Enter or Right-click to confirm the selection.
```
*Note: Once confirmed, the script will automatically find the closest 'Header' text to every opening in the selected walls, update the properties, and then erase itself.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any parameters to the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add any options to the right-click context menu. |

## Settings Files
- None. This script relies on the geometry and existing text entities in the drawing rather than external settings files.

## Tips
- **Placement Matters**: The script calculates the distance between the text and the opening along the X-axis. Ensure your "Header" text is physically closer to the intended opening than any other header text to ensure correct association.
- **Verification**: After running the script, select an opening and check its Properties Palette under the "Door Schedule" category to verify the `Header_Description` field has been populated.
- **Cleanup**: The script instance automatically deletes itself after running, so you do not need to manually remove it from the drawing.

## FAQ
- **Q: I ran the script, but the properties didn't update. Why?**
  - **A**: Check that your ElemText entities have the exact codes `WINDOW` (Code) and `HEADER` (SubCode). Also, ensure the text is close enough to the opening.
- **Q: Does this script work on curved walls?**
  - **A**: Yes, it works on any ElementWall. It uses the opening's origin point to find the closest text.
- **Q: Can I use this for Door headers as well?**
  - **A**: Yes, provided the text label uses the required `WINDOW` and `HEADER` codes and is located near the door opening.