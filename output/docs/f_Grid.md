# f_Grid.mcr

## Overview
This script generates a visual bedding grid for stacked timber packages on a truck or trailer. It is used to calculate and visualize the optimal placement of support beams (beddings) to ensure load stability during transport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used in the 3D model to visualize load planning. |
| Paper Space | No | Not applicable for drawing views. |
| Shop Drawing | No | Not applicable for manufacturing drawings. |

## Prerequisites
- **Required Entities**: A valid "Truck Grid" TslInst entity with the `isGrid` map flag must already exist in the model.
- **Required Settings**: The `hsbTSL` dictionary must contain configuration data (specifically `f_Stacking` settings under `Truck.BeddingGrid`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Grid.mcr` from the catalog.

### Step 2: Select Parent Entity
```
Command Line: Select item(s)
Action: Click on the existing Truck Grid entity in the model to which you want to attach the bedding grid.
```

### Step 3: Configure Properties
After insertion, select the newly created grid instance and open the **Properties Palette** (Ctrl+1) to adjust the bedding layout (e.g., Grid Size, Mode, Width).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Grid Size** | dropdown | 2x Grid | Defines the number of bays for the bedding along the load length. Options range from 2x to 13x. |
| **Mode** | dropdown | Center of Gravity | Determines how the grid is aligned. Options: *Center of Gravity* (aligns to weight center), *Stack Extents* (aligns to package length), or *Truck Extents* (aligns to full vehicle length). |
| **Edge Offset** | number | 300 | The distance (in mm) from the outer edge of the load to the center of the first bedding. |
| **Width** | number | 60 | The physical width (in mm) of the bedding block. If set to 0, only the center axis line is drawn. |
| **Height** | number | 80 | The height (in mm) of the bedding block, used for size reference and material lists. |

## Right-Click Menu Options
This script relies primarily on the Properties Palette for configuration. Standard TSL context menu options for recalculating or deleting the instance apply.

## Settings Files
- **Location**: hsbTSL Dictionary (`f_Stacking` map)
- **Key**: `Truck.BeddingGrid`
- **Purpose**: Stores default settings and mapping data required for the script to interpret truck and stack dimensions correctly.

## Tips
- **Visualizing Layout**: Set the **Width** property to `0` if you only want to see the centerline positions of the supports without the physical blocks obscuring the view.
- **Stability Check**: Use the **Mode: Center of Gravity** setting to ensure your beddings align correctly with the heaviest part of the load.
- **Collision Handling**: If the calculated spacing between beddings is smaller than the **Width**, the script will automatically shift the positions to prevent overlap and switch the dimensioning style to show individual distances.

## FAQ
- **Q: Why did the grid not appear after I ran the script?**
  A: Ensure you selected a valid Truck Grid entity during the insertion prompt. The script requires a parent entity with specific map data to function.
- **Q: What does "2x Grid" mean?**
  A: A "2x Grid" typically divides the load length into 2 equal sections, resulting in 3 bedding positions (one at each end and one in the middle).
- **Q: How do I change the number of supports?**
  A: Select the grid in the model, open the Properties Palette, and change the **Grid Size** dropdown to a higher value (e.g., "4x Grid").