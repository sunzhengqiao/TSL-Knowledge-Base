# hsb_DimensionWallLength

## Overview
Automatically labels the total length of a wall element in the 3D model view. The label updates dynamically if the wall geometry changes, is stretched, or is split.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script attaches to wall elements in the 3D model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required Entities:** ElementWallSF (Sandwich Wall)
- **Minimum Beam Count:** 0
- **Required Settings:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_DimensionWallLength.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall(s) you wish to label and press Enter.
```
*Note: The script will automatically create an instance on each selected wall and remove the initial "launcher" instance.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | dropdown | (From CAD Standards) | Selects the visual style (font, arrows, color) of the dimension text from your project standards. |
| Offset | number | 350 | Sets the distance in millimeters (mm) that the label is placed away from the arrow side of the wall face. |
| Show Dim in Disp Rep | text | (Empty) | Limits visibility to a specific Display Representation (e.g., "Model", "Sketch"). If left empty, the label is visible in all views. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific right-click menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Wall Splitting:** If you split a wall that has a label attached, this script will automatically detect the split and re-attach the label to the wall segment closest to its original position.
- **Dynamic Updates:** You do not need to re-run the script if you change the wall length (e.g., by stretching or moving the wall). The dimension text updates automatically.
- **Format:** The dimension text is displayed in parentheses with 0 decimal places (e.g., `(5000)`).
- **Visibility Control:** Use the "Show Dim in Disp Rep" property to hide length labels during specific detailing phases (e.g., hide in "Sketch" mode but show in "Presentation" mode).

## FAQ
- **Q: Why did my label disappear?**
  A: Check the "Show Dim in Disp Rep" property to ensure your current view mode matches the setting. Also, verify that the wall element has not been deleted.
- **Q: Can I use this on floors or roofs?**
  A: No, this script is designed specifically for `ElementWallSF` (Sandwich Wall) entities.
- **Q: How do I change the text size or arrow style?**
  A: Change the "Dimension Style" property in the Properties Palette to select a different standard style defined in your CAD template.