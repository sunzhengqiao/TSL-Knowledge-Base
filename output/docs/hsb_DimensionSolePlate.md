# hsb_DimensionSolePlate.mcr

## Overview
This script automatically generates external plan-view dimension lines for timber frame walls. It allows you to dimension overall wall lengths based on either Sole Plates or full Wall Elements, with options to include details for openings and wall segments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in Model Space to generate dimensions. |
| Paper Space | No | Not designed for use in Paper Space layouts. |
| Shop Drawing | No | This is a utility script; it does not create Shop Drawing entities. |

## Prerequisites
- **Required Entities**: 
  - Beams (if using "SolePlate" mode)
  - ElementWalls (if using "FloorPlan" mode)
- **Connectivity**: In FloorPlan mode, walls must be connected to other walls. Isolated walls are skipped to prevent skewed dimensions.
- **Required Settings**: 
  - Valid AutoCAD Dimension Styles existing in the drawing.
  - `hsb_TSLDimensions2012.dll` or `hsb_TSLDimensions2013.dll` must be present in the `Content\UK\TSL\DLLs\Dimension\` folder.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_DimensionSolePlate.mcr`.

### Step 2: Configure Properties
Upon launching, the Properties Palette (OPM) will open automatically.
1. Set the **Dimension From** option (SolePlate or FloorPlan).
2. Select your desired **Dimension Styles** for outside and inside lines.
3. Adjust **Offsets** (distances from walls and between lines) as needed.
4. Configure **Grouping** names to organize the output layers.
5. Set **Floor plan options** (e.g., include openings or splits).
6. Close the Properties Palette when ready.

### Step 3: Select Elements
Depending on your configuration in Step 2, the command line will prompt you:

**If "SolePlate" mode:**
```
Command Line: Please select Soleplates
Action: Click on the bottom plate beams representing the walls. Press Enter to finish selection.
```

**If "FloorPlan" mode:**
```
Command Line: Please select Elements
Action: Click on the wall elements you wish to dimension. Press Enter to finish selection.
```

### Step 4: Generation
The script will calculate the geometry, create the dimension lines on the specified layers, and then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension From | dropdown | FloorPlan | Selects the source entity type: "SolePlate" uses bottom beams; "FloorPlan" uses full wall elements. |
| Dimension style outside elements | dropdown | *Empty* | Select the AutoCAD Dimension Style for the outer dimension line. |
| Dimension style inside elements | dropdown | *Empty* | Select the AutoCAD Dimension Style for inner/internal dimension lines. |
| Distance to the outside elements | number | 500.0 | The gap (in mm) between the outer face of the wall and the first dimension line. |
| Distance between dimension lines | number | 350.0 | The vertical distance (in mm) between parallel dimension lines. |
| Offset Dimline Internal Wall | number | 250.0 | The offset distance (in mm) for dimension lines measuring internal wall geometry. |
| House Level group name | text | *Empty* | Parent group name (e.g., House Name) used to organize layers. |
| Floor Level group name | text | *Empty* | Child group name (e.g., Floor Level) used to organize layers. |
| Dimension external openings | dropdown | Yes | If "Yes", individual widths of windows/doors are dimensioned. |
| Dimension external splits | dropdown | No | If "Yes", dimensions break at changes in wall direction or material splits. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs once and self-deletes. No context menu options are available for a persistent instance. |

## Settings Files
- **DLL Dependencies**: `hsb_TSLDimensions2012.dll` (for AutoCAD 2012) or `hsb_TSLDimensions2013.dll` (for AutoCAD 2013+).
- **Location**: `Content\UK\TSL\DLLs\Dimension\`
- **Purpose**: These .NET assemblies handle the actual creation of the AutoCAD dimension entities based on the calculated coordinates.

## Tips
- **Wall Connectivity**: Ensure external walls are properly joined. The script ignores standalone walls to prevent dimension errors.
- **Updating Dimensions**: Since the script erases itself after running, you cannot simply right-click to edit. To update dimensions, delete the existing dimensions and run the script again.
- **Layer Organization**: Use the *House Level* and *Floor Level* group name properties to automatically sort dimensions into the correct layer structure (e.g., `House1\Ground Floor`).

## FAQ
- **Q: Why did some walls not get dimensioned?**
  A: In FloorPlan mode, the script filters out isolated walls that are not connected to other walls to ensure the outer dimension line is continuous. Check your wall joins.
- **Q: The script reports "No Valid dll". What do I do?**
  A: Ensure your hsbCAD installation contains `hsb_TSLDimensions2012.dll` or `hsb_TSLDimensions2013.dll` in the correct directory path. The script checks your AutoCAD version to load the correct file.
- **Q: Can I modify the dimensions after they are created?**
  A: Yes. The script creates standard AutoCAD dimensions. You can use standard AutoCAD grip edits or the Properties palette to tweak them manually after generation.