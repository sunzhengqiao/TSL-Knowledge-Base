# hsb_HatchSheets.mcr

## Overview
This script automates the hatching of sheeting or cladding layers on your Layout (Paper Space). It allows you to visually highlight specific construction zones (like external sheathing or flooring) by projecting their outlines from the model view and applying a customizable hatch pattern directly on the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed to work on Layout tabs. |
| Paper Space | Yes | Requires a Viewport displaying an hsbCAD Element. |
| Shop Drawing | No | This is an annotation tool for Layouts. |

## Prerequisites
- **Required Entities**: An hsbCAD Element containing sheets/cladding.
- **Viewport**: A Viewport on a Layout tab that is currently displaying the Element you wish to annotate.
- **Minimum Beam Count**: None (script checks if element contains geometry).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_HatchSheats.mcr`.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the viewport in Paper Space that contains the model you want to hatch.
```

### Step 3: Configure Hatch
Action: After selecting the viewport, the script will run. Press `Esc` once to deselect the script if it is highlighted, then select the script instance (or ensure it is selected) to open the **Properties Palette**. Adjust the settings (Zone, Pattern, Color) as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hatch pattern | dropdown | (Current) | Select the visual style of the hatch (e.g., ANSI31, SOLID). |
| Hatch Angle | number | 0 | Sets the rotation angle of the hatch pattern (0-360 degrees). |
| Hatch Scale | number | 20 | Controls the density/size of the hatch pattern. |
| Hatch Color | number | 1 | Sets the AutoCAD Color Index (ACI) for the hatch lines. |
| Zone to hatch | dropdown | 1 | Selects the construction layer to hatch. <br>**0-5**: Standard zones.<br>**6-10**: Logical zones (maps to -1 to -5, e.g., for floor cladding). |
| Filter Sheet with SubLabel | text | (Empty) | Enter a SubLabel (e.g., "OSB", "PLY") to only hatch sheets with that specific label. Leave empty to hatch all sheets in the zone. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom right-click menu items. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Filtering Materials**: Use the *Filter Sheet with SubLabel* property if you only want to hatch specific types of sheets within a zone (e.g., hatch only the plywood sheathing, ignoring the rigid insulation in the same zone).
- **Visual Clarity**: If your hatch looks too solid or too busy, increase the *Hatch Scale* value.
- **Updating Layouts**: If you move or scale the Viewport after inserting the script, you may need to select the script and toggle a property (like *Hatch Scale*) or use the "Recalculate" option to force the hatch to update its position to match the new view.
- **Zone Mapping**: If you are looking for floor finishes or specific logical layers that don't appear in standard zones, try selecting options 6 through 10 in the *Zone to hatch* dropdown.

## FAQ
- **Q: I selected the viewport, but no hatch appeared.**
- A: Check that the selected Element actually contains sheets in the *Zone to hatch* you selected. Also, verify that the *Filter Sheet with SubLabel* isn't filtering out all sheets (try clearing the text).
- **Q: The hatch pattern is rotated the wrong way.**
- A: Change the *Hatch Angle* property in the Properties Palette to rotate the pattern lines.
- **Q: Why is the hatch not perfectly aligned with the sheet edges?**
- A: The script automatically shrinks the hatch outline by 1mm internally to prevent edge overlap and display issues. This is intentional behavior to ensure drawing cleanliness.