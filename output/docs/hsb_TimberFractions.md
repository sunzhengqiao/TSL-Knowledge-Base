# hsb_TimberFractions.mcr

## Overview
Calculates the percentage of timber volume relative to the total element volume for selected walls. It allows you to exclude specific sheathing materials (like OSB or Gypsum) to determine the structural timber fraction, often used for fire calculations or environmental reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not supported for manufacturing drawings. |

## Prerequisites
- **Required Entities**: Element or ElementWall entities must exist in the model.
- **Minimum Beam Count**: 0 (This script analyzes Wall elements, not individual beams directly).
- **Required Settings**: None required to run, but properties should be configured for accurate results.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `hsb_TimberFractions` if mapped)
Action: Select the script file `hsb_TimberFractions.mcr` from the file dialog.

### Step 2: Pick Result Location
```
Command Line: Pick a Point to show result.
Action: Click in the Model Space where you want the text label displaying the percentage to appear.
```

### Step 3: Select Elements
```
Command Line: Please select elements
Action: Select the Wall elements (ElementWalls) you wish to analyze and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall codes for calculation | text | EA;EB; | The Element Codes of the walls to include. Separate multiple codes with a semicolon (;). Walls matching these codes are calculated. |
| Soleplate thickness | number | 38 | The thickness (height) used to calculate the bottom plate volume. |
| Headbinder height | number | 38 | The thickness (height) used to calculate the top plate volume. |
| Minimum insulation depth | number | 50 | The distance from the bottom of the wall to measure the stud cross-section. Ensure this is set to hit the studs, avoiding plates or large voids. |
| Exclude sheets by material | text | | Material names to exclude from the *total* volume calculation (e.g., OSB;Gypsum;). This isolates the timber fraction. Separate multiple materials with a semicolon. |
| |Text Color| | number | 7 | The AutoCAD color index for the result text. |
| Output Key | text | TimberFraction | Identifier for catalog presets. |
| |Dimstyle| | text | _DimStyles | The dimension style used for the text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently of external settings files.

## Tips
- **Filtering Walls**: If the script calculates 0% or erases itself immediately, check the **Wall codes for calculation** property. Ensure the codes match the Element Codes of the walls you selected (e.g., "EA", "IN").
- **Accurate Volumes**: To calculate the "Structural Timber Fraction" (ignoring sheathing), add your sheathing material names to the **Exclude sheets by material** property. This reduces the total volume denominator, resulting in a higher timber percentage.
- **Cutting Plane**: If your walls have unusual construction, adjust the **Minimum insulation depth**. The script takes a horizontal slice of the wall at this height to determine the stud area.
- **Updating**: Change any property in the Properties Palette to trigger an automatic recalculation of the text label.
- **Copying**: If you copy and paste this script, the duplicate instance will automatically erase itself to prevent calculation errors. Re-run the command to create a new analysis.

## FAQ
- **Q: Why did the text label disappear after I inserted it?**
  A: This usually happens if the script detected no valid walls matching your codes, or if the calculated volume was too small (near zero). Check your **Wall codes for calculation** and ensure you selected valid ElementWall entities.

- **Q: How do I include multiple wall types?**
  A: In the **Wall codes for calculation** property, enter them separated by semicolons. For example: `EA;EB;INT;`.

- **Q: The percentage seems too low. How do I fix it?**
  A: You likely need to exclude sheathing materials. Add materials like `OSB` or `PLYWOOD` to the **Exclude sheets by material** property. This ensures the calculation is Timber vs. (Timber + Insulation) rather than Timber vs. Total Wall Volume.

- **Q: Can I move the text label?**
  A: Yes. Select the script instance in AutoCAD and use the standard grip point to drag the text to a new location.