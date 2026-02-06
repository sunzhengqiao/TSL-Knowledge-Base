# hsb_RemoveSheetsFromWalls.mcr

## Overview
This script removes specific sheathing or sheeting layers (Sheet entities) from selected wall elements based on their wall codes and construction zones. It is designed to quickly clear areas for windows, doors, or mechanical chases without manually editing each wall's composition.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment where Walls (ElementWallSF) are located. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the 3D model, not drawing views. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Standard Walls).
- **Minimum Beam Count**: 0 (This script operates on Wall elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_RemoveSheetsFromWalls.mcr`

### Step 2: Select Walls
```
Command Line: Select one or More Elements
Action: Click on the wall elements in the model you wish to process. Press Enter to confirm selection.
```

### Step 3: Configure Properties
After selection, the Properties Palette will appear. Enter the Wall Codes and corresponding Zones for up to 4 different groups.
```
Action: In the Properties Palette, type the Wall Codes (matching the Element Code in hsbCAD) and the Zone numbers you wish to remove. Press Enter to apply changes.
Note: Separate multiple entries with a semicolon (;).
```

### Step 4: Execution
Once the properties are entered, the script will automatically process the selected walls and remove the specified sheets. The script instance will then delete itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall 1 Codes | Text | | Enter the Element Codes (names) of the first group of walls (e.g., `W_EXT_01;W_EXT_02`). |
| Zones to Remove for Wall 1 | Text | | Enter the zone numbers (1-10) to remove for Group 1, separated by `;` (e.g., `1;3`). |
| Wall 2 Codes | Text | | Enter the Element Codes for the second group of walls. |
| Zones to Remove for Wall 2 | Text | | Enter the zone numbers (1-10) to remove for Group 2, separated by `;`. |
| Wall 3 Codes | Text | | Enter the Element Codes for the third group of walls. |
| Zones to Remove for Wall 3 | Text | | Enter the zone numbers (1-10) to remove for Group 3, separated by `;`. |
| Wall 4 Codes | Text | | Enter the Element Codes for the fourth group of walls. |
| Zones to Remove for Wall 4 | Text | | Enter the zone numbers (1-10) to remove for Group 4, separated by `;`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the entity context menu. |

## Settings Files
- None required.

## Tips
- **Zone Mapping**: Zones 1-5 typically refer to layer indices on one side of the wall, while 6-10 typically refer to the opposite side (negative indices). Consult your wall construction setup if you are unsure which number corresponds to which sheathing layer.
- **Exact Spelling**: Ensure the Wall Codes entered in the properties match the **Element Code** exactly as it appears in the wall's properties. The script is case-sensitive.
- **Semicolon Separator**: Do not use spaces after semicolons if the script does not seem to recognize the codes (e.g., use `A;B` instead of `A; B`).
- **Run Once**: This script erases itself after running. If you make a mistake, use the AutoCAD `UNDO` command immediately to revert the changes.

## FAQ
- **Q: What happens if I enter a Zone number that doesn't exist?**
  - A: The script will simply ignore that number. Only valid zones found on the wall will be processed.
- **Q: Can I modify the settings after the script has run?**
  - A: No. The script instance deletes itself automatically after execution. You must insert the script again to perform new operations.
- **Q: How do I know what my Wall Code is?**
  - A: Select a wall in your model and look at the **Properties Palette** (or use `LIST` command). The code is usually found under "Element" or "Identification" fields.