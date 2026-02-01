# GE_WDET_DISPLAY_LENGTH

## Overview
Automatically labels the horizontal length of Wall Elements in the 3D model. It is primarily used for verification or pre-detailing visualization to display dimensions without generating full 2D shop drawings.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script attaches to Wall Elements in the 3D model. |
| Paper Space | No | Not intended for layout sheets or viewports. |
| Shop Drawing | No | This is a model annotation tool, not a generation script. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWall`).
- **Minimum Beam Count**: 0 (The script works on the Element itself, but searches for Bottom Plates if present).
- **Required Settings**: A valid Dimension Style (DimStyle) loaded in the drawing (Default: "Brockport").

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_DISPLAY_LENGTH.mcr`

### Step 2: Select Wall Elements
```
Command Line: Select a set of elements
Action: Click on one or more Wall Elements in the model view, then press Enter.
```
*Note: The script will filter out non-wall entities automatically.*

### Step 3: Automatic Placement
The script will automatically clone itself onto each selected wall, calculate the length based on bottom plates or the wall envelope, and place the text label.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | Brockport | Selects the CAD Dimension Style used to format the text (font, arrows, precision). Uses the list of DimStyles currently loaded in the drawing. |
| Text Height. If 0 uses DimStyle | number | 0 | Sets the height of the text label. A value of 0 means the text height is inherited from the selected DimStyle. |
| Offset from Wall | number | 14 | The distance the label is placed away from the wall surface to ensure it does not overlap the geometry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific custom actions to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Updates**: If you edit the wall geometry (e.g., stretch it or modify plates), the label will automatically recalculate the length and update its position.
- **Avoiding Duplicates**: The script automatically detects if it is already attached to a wall. If you run the script on the same wall twice, it will not create duplicate labels.
- **Visibility**: If the text seems too small, try setting the `Text Height` property to a specific value (e.g., 50 or 100) instead of 0, or increase the `Offset from Wall` if it is buried inside the wall geometry.
- **Source Geometry**: The script prioritizes measuring "Bottom Plates" if they exist in the element. If no bottom plates are found, it measures the overall bounding box (Envelope) of the wall.

## FAQ
- **Q: Why did nothing happen when I ran the script?**
  - A: You likely selected entities that are not valid Wall Elements (`ElementWall`), or the script detected an existing instance on the wall and exited to prevent duplicates.
- **Q: How can I change the font of the label?**
  - A: Change the `DimStyle` property in the Properties Palette to a style that uses your desired font. Alternatively, you can manually create a DimStyle in AutoCAD with the specific font you want before running the script.
- **Q: The text is upside down.**
  - A: The script attempts to calculate text rotation based on wall orientation. If it appears incorrect, you may need to check the coordinate system of the wall or the specific DimStyle text settings.