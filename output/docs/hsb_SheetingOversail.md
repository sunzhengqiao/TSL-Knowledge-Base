# hsb_SheetingOversail

## Overview
This script automatically annotates the oversail (overhang) or setback distance of sheeting material relative to the structural timber frame in a 2D drawing view. It is used to verify and document the positioning of roof or floor sheathing relative to the underlying beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed to annotate views. |
| Paper Space | Yes | This script must be run in Paper Space. |
| Shop Drawing | Yes | Specifically designed for production layout drawings. |

## Prerequisites
- **Required Entities**: A drawing layout containing a Viewport that displays an hsbCAD Element.
- **Minimum Content**: The Element must contain both Structural Beams and Sheeting ( Sheets ) assigned to a specific construction layer.
- **Zone Setup**: The sheeting materials must be assigned to a valid Zone index (e.g., Zone 5) for the script to detect them.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from your hsbCAD script toolbar)
Action: Browse and select `hsb_SheetingOversail.mcr`.

### Step 2: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the viewport in Paper Space that shows the element you wish to annotate.
```
*Note: Once selected, the script will automatically calculate the offsets and draw the dimensions.*

## Properties Panel Parameters
After insertion, select the script instance in AutoCAD to modify these parameters in the Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index | dropdown | 5 | Selects the construction layer (Zone) of the sheets to analyze. Range is -5 to 5. |
| Dimension Style | dropdown | *Current Standard* | Selects the AutoCAD Dimension Style to control text font and size. |
| Side of delta dimensioning | dropdown | Above | Places the dimension text either "Above" or "Below" the measurement line. |
| Offset From Element | number | 150 mm | The distance the text label is offset from the sheet edge to prevent overlap. |
| Delta text direction | dropdown | None | Controls text rotation: "None", "Parallel", or "Perpendicular" to the sheet edge. |
| Setback sufix | text | Setback | The text label added when the sheet is recessed (e.g., "50mm Setback"). |
| Overhang sufix | text | Overhang | The text label added when the sheet extends past the beam (e.g., "50mm Overhang"). |
| Color | number | 1 (Red) | The AutoCAD Color Index (ACI) for the generated dimension text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom right-click menu options are defined for this script. Use the Properties Palette to change settings. |

## Settings Files
- **Filename**: *None*
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Wrong Zone?** If the script runs but no dimensions appear, check the **Zone index** property. The sheets may be assigned to a different zone number (e.g., Zone 1 vs Zone 5).
- **Text Clashing:** If the dimension text overlaps with your drawing lines, increase the **Offset From Element** value.
- **View Orientation:** The script works best when viewing the element from "Top". If viewing a ceiling from underneath, the script automatically adjusts text orientation to remain readable.
- **Clean Drawings:** The script automatically skips small gaps (less than 1mm) and edges within openings to keep the drawing uncluttered.

## FAQ
- **Q: Why does the text say "Setback" instead of "Overhang"?**
  A: The script calculates the relative position of the sheet to the beam. If the sheet edge is inside the beam outline, it is a "Setback". If it is outside, it is an "Overhang". You can change these labels in the Properties panel.
- **Q: Can I change the color of the dimensions?**
  A: Yes, use the **Color** property in the Properties Palette to match your layer standards.
- **Q: Does this work on curved walls?**
  A: Yes, the script analyzes the outline profile regardless of complexity, calculating the perpendicular distance to the nearest beam edge.