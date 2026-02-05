# HSB_W-OpeningPositions

## Overview
This script automatically creates dimension text labels for wall segments located between window or door openings directly in the 3D model. It is used to quickly verify the widths of solid wall panels or stud bays during the design phase without generating full 2D shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Dimensions are drawn directly on the wall element in 3D. |
| Paper Space | No | This script does not function in Layout viewports. |
| Shop Drawing | No | This is for model visualization only, not production drawings. |

## Prerequisites
- **Required Entities**: An existing Wall Element must be present in the model.
- **Minimum Beams**: 1 (One Wall Element).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-OpeningPositions.mcr`

### Step 2: Select Wall Element
```
Command Line: Select an element
Action: Click on the desired Wall element in the drawing that contains openings.
```

### Step 3: View Results
The script will immediately attach to the element and draw text labels on the wall face, showing the length of every solid section between openings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Precision | Number | 0 | Sets the number of decimal places for the dimension text (e.g., 0 displays "2500", 2 displays "2500.00"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently without external settings files.

## Tips
- **Auto-Update**: The dimensions are associative. If you move the wall, resize it, or modify the size/position of the openings, the text labels will automatically update to reflect the new dimensions.
- **Precision**: If you need to see millimeter or fractional precision, select the script instance (it is usually attached near the wall) and change the "Precision" value in the Properties palette.
- **Cleanup**: The script automatically removes old instances of itself from the same wall to prevent duplicate labels.

## FAQ
- **Q: I see the script in the selection, but no text is appearing.**
  - **A:** Ensure the selected element is a valid Wall Element with a calculable outline. If the wall has no geometry or is an empty reference, the script cannot calculate dimensions.
- **Q: Can I use this on floor or roof elements?**
  - **A:** No, this script is specifically designed to calculate segments between wall openings (windows/doors).
- **Q: How do I remove the dimensions?**
  - **A:** Select the dimension text or the script instance and press `Delete`. Since the script is linked to the wall, deleting the wall will also remove the dimensions.