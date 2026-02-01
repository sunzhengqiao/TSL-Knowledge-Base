# hsb_DisplayYield.mcr

## Overview
This script calculates the average cutting yield percentage of selected MasterPanels and displays the result as a text label at a specific location in the 3D model. It helps users quickly assess material efficiency for a group of wall or floor panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model to select panels and place annotations. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: MasterPanel (Wall or Floor panels)
- **Minimum beam count**: 1
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_DisplayYield.mcr` from the script list.

### Step 2: Specify Location
```
Command Line: Select insertion point
Action: Click in the model space where you want the yield percentage text to appear.
```

### Step 3: Select Panels
```
Command Line: Select Master Panels
Action: Click on the MasterPanels (walls/floors) you wish to analyze. Press Enter to confirm the selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text height | Number | U(1000) | Sets the height of the text characters for the yield label. Increase this value if the text is too small to read in the model view. |
| Dim style | Dropdown | _DimStyles | Selects the drafting standard (font, color, layer) for the text label. Options are based on Dimension Styles currently loaded in the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Use standard AutoCAD functions to Delete or view Properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Moving the Label**: If you need to move the text after placing it, simply select the text object and use the grip point to drag it to a new location.
- **Visibility**: If the text is difficult to see, select the object and press `Ctrl+1` to open the Properties Palette. Increase the "Text height" or change the "Dim style" to a style with a contrasting color.
- **Data Accuracy**: The yield calculation updates automatically. If the geometry of the selected panels changes, the script will recalculate the average yield the next time the model updates.

## FAQ
- Q: The text displays 0% or an unexpected value. Why?
- A: Ensure you selected valid MasterPanel entities during the insertion step. The script ignores non-panel entities. If panels were deleted after the script was inserted, the yield may not calculate correctly; delete the script instance and re-insert it.

- Q: How do I change the font of the yield text?
- A: You cannot change the font directly in the script properties. Instead, select the script instance, open the Properties Palette (`Ctrl+1`), and change the "Dim style" to a style that uses your desired font.

- Q: Can I add more panels to an existing calculation?
- A: No, you must delete the existing script instance and run the command again, selecting all desired panels at once.