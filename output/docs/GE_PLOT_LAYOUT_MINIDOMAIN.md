# GE_PLOT_LAYOUT_MINIDOMAIN

## Overview
This script inserts a 2D annotation symbol (resembling a chevron or arrow) into Paper Space that automatically aligns with a specific Wall element viewed through a viewport. It is used to mark directions or zones on drawings and updates dynamically if the wall geometry changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Layouts. |
| Paper Space | Yes | This is the primary environment for this script. |
| Shop Drawing | No | This is a general annotation tool. |

## Prerequisites
- **Required Entities**: A Layout tab containing at least one active Viewport.
- **Linked Entity**: The selected Viewport must be looking at a valid Wall element (`ElementWallSF`).
- **Minimum Beam Count**: 0.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `GE_PLOT_LAYOUT_MINIDOMAIN.mcr`.

### Step 2: Specify Insertion Point
```
Command Line: Select a point
Action: Click in the Paper Space area where you want to anchor the annotation.
```

### Step 3: Link to Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click on the border of the viewport that displays the Wall you wish to annotate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Size | Number | 2.0 | Scale factor for the annotation symbol. Increase this value to make the arrow/chevron larger on the drawing sheet. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visibility**: Ensure the viewport you select is currently active and displaying a Wall element. If the element is a beam or generic object, the specific symbol may not generate correctly.
- **Updates**: If you modify the Wall in Model Space, run the `REGEN` command in AutoCAD to update the symbol's position and orientation in Paper Space.
- **Scaling**: Adjust the **Size** property in the Properties Palette (Ctrl+1) if the symbol appears too small or too large for your plot scale.

## FAQ
- **Q: I inserted the script, but I don't see any lines?**
  **A:** Ensure the viewport you selected actually contains a valid Wall element (`ElementWallSF`). The script relies on the wall's geometry to calculate the symbol's location. Also, check that your Layer 0 is turned on.
- **Q: Can I move the symbol after inserting it?**
  **A:** No, the symbol's position is calculated mathematically based on the center of the wall in the linked viewport. Moving the wall in Model Space will move the symbol.
- **Q: What does the error "Select a viewport" mean?**
  **A:** This usually occurs if you clicked in empty space during Step 3. You must click directly on the frame border of an existing viewport.