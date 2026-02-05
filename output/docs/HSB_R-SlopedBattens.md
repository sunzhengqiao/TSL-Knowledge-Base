# HSB_R-SlopedBattens.mcr

## Overview
Generates sloping roof battens (tapered supports) on a flat roof structure to create a fall for drainage. It calculates batten heights based on a selected gutter and a distribution boundary, and can optionally generate sheeting layers like decking or insulation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for inserting the script and viewing 3D geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Gutter Entity:** An existing TSL Instance representing the gutter to which the roof must drain.
- **Distribution Area:** A closed Polyline defining the boundary of the roof area where battens are needed.
- **Structural Groups:** At least one structural group (e.g., a floor or phase) defined in the project to assign the entities to.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `HSB_R-SlopedBattens.mcr` from the file dialog or catalog.

### Step 2: Select the Gutter
```
Command Line: Select the gutter
Action: Click on the existing gutter TSL instance in the model. This determines the low point and direction of the roof slope.
```

### Step 3: Select the Distribution Area
```
Command Line: Select the distribution area
Action: Click on the closed Polyline that represents the roof surface where the battens should be generated.
```

### Step 4: Configure Properties
After selection, a Properties dialog may appear (depending on your catalog settings). You can adjust parameters such as Slope percentage, Batten Spacing, and Sheeting Thickness here or later via the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Gutter** | | | |
| Slope [%] | number | 1 | The required roof fall percentage towards the gutter. (e.g., 1.0 means a 1% fall). |
| **Sloped battens** | | | |
| Assign battens to group | dropdown | *Project Default* | Sets the structural group the generated beams and sheets belong to. |
| Width sloped battens | number | 50 mm | The width of an individual batten perpendicular to the slope direction. |
| Spacing sloped battens | number | 600 mm | The center-to-center distance between adjacent battens. |
| Offset from selected area | number | 5 mm | A clearance margin from the selected boundary polyline. |
| Color battens | number | 5 | The display color index for the battens. |
| Dimension style | dropdown | _DimStyles | The dimension style used for annotations. |
| Text size | number | -1 m | The height for text annotations. |
| **Zones (Sheeting)** | | | |
| Thickness first sheeting layer | number | 0 mm | Thickness of the primary decking (e.g., OSB). Set to 0 to disable. |
| Color first sheeting layer | number | 2 | Display color for the first layer. |
| Material first sheeting layer | text | OSB | Material name for the first layer. |
| Thickness second sheeting layer | number | 0 mm | Thickness of the secondary layer (e.g., Insulation). Set to 0 to disable. |
| Color second sheeting layer | number | 35 | Display color for the second layer. |
| Material second sheeting layer | text | Insulation | Material name for the second layer. |

## Right-Click Menu Options
No custom right-click menu options are defined for this script. Standard context options apply.

## Settings Files
No specific external settings files are required for this script.

## Tips
- **Dynamic Updates:** If you need to adjust the roof area, simply use grip edits to stretch or move the boundary polyline. The script will automatically detect the change and regenerate the battens to fit the new shape.
- **Adjusting Fall:** To change the steepness of the roof, select the script instance and modify the "Slope [%]" property in the Properties Palette.
- **Layering:** Use the "Zones" properties to quickly visualize and quantify board material or insulation thickness on top of the sloped battens.
- **Grouping:** Always ensure "Assign battens to group" is set correctly so the elements appear in the correct reports and views.

## FAQ
- **Q: Why didn't any battens generate?**
  A: Check that your "Spacing sloped battens" is smaller than the width of your distribution area. Also, ensure the polyline is closed and the gutter instance is valid.

- **Q: Can I create a flat roof with no fall?**
  A: Yes, set the "Slope [%]" to 0.

- **Q: How do I add insulation on top of the decking?**
  A: Set the "Thickness first sheeting layer" to your decking size (e.g., 18mm) and the "Thickness second sheeting layer" to your insulation size (e.g., 100mm). The script will stack them correctly.

- **Q: The battens are running the wrong way.**
  A: The script calculates direction based on the Gutter. Ensure you selected the correct Gutter entity relative to the distribution area.