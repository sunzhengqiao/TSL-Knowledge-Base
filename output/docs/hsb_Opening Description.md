# hsb_Opening Description.mcr

## Overview
This script automates the labeling of wall openings (windows and doors) by creating text annotations in the model. It displays the opening code, dimensions (Width x Height), and header/lintel details based on the wall and opening properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script attaches to Wall Elements and draws labels in 3D model space. |
| Paper Space | No | Not intended for layout sheets. |
| Shop Drawing | No | This is a model annotation tool. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) that contain Opening entities (`OpeningSF` or `OpeningLog`).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Opening Description.mcr` from the file browser.

### Step 2: Select Walls
```
Command Line: Please select Elements
Action: Click on one or more Wall Elements that contain the openings you wish to label. Press Enter to confirm selection.
```
*Note: The script will automatically detect all openings inside the selected walls and place a label on each one.*

### Step 3: Adjust Properties (Optional)
After insertion, select a wall with the script attached to view and modify the label settings in the AutoCAD Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Determines the text style (font, size) used for the opening description and size lines. |
| Color | number | 130 | Sets the AutoCAD color index (1-255) for the text. |
| Offset from Window | number | 250 | Distance the text block is placed away from the wall face (normal direction). |
| Lateral Offset | number | 0 | Shifts the text left or right along the length of the wall relative to the opening center. |
| Distance Between Lines | number | 100 | Vertical spacing between the three lines of text (Description, Size, Header). |
| Set Rotation | number | 0 | Rotation angle applied to the entire text block. |
| Dimstyle Header | dropdown | _DimStyles | Determines the text style specifically for the Header/Lintel line (Line 3). |
| Disp Rep Header | text | (Empty) | Filters the Header line visibility. If empty, it shows in all views. If a Display Rep name is entered (e.g., "Plan"), the header only appears in that view. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. Use the Properties palette to make changes. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Smart Header Text**: The script attempts to find "Element Text" inside your wall where the Code is `WINDOW` and SubCode is `HEADER`. If these exist in your wall data, the script will automatically use that text for the third line of the label instead of generic construction details.
- **Dynamic Updates**: If you stretch or move a wall, the labels will automatically update their position to stay relative to the opening center.
- **View Control**: Use the **Disp Rep Header** property to hide clutter (like lintel sizes) in elevation views while keeping them visible in floor plans.

## FAQ
- **Q: Can I use this on individual windows without selecting the whole wall?**
  A: No. The script operates by selecting the Wall Element (`ElementWallSF`). It will process all openings found within that specific wall.
- **Q: Why is my text appearing in the wrong size?**
  A: The text size is controlled by the Dimension Style selected in the **Dimstyle** property. Change this to a dimension style with larger text settings in your CAD template.
- **Q: The text is overlapping my window.**
  A: Increase the value of **Offset from Window** in the properties palette to push the label further out from the wall face.