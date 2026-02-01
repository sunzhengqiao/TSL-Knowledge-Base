# HSB_E-SplitSheetOnZoneMaterial.mcr

## Overview
This script automatically splits structural sheathing sheets (such as OSB) within a specific construction zone of an Element. It cuts the sheathing around other sheet materials in the same zone to create a defined gap, effectively isolating the structural layer from other layers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Elements in the 3D model. |
| Paper Space | No | Not for use in layout views or 2D drawings. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: An Element (Wall or Floor) must exist in the model.
- **Minimum Sheets**: The selected Element must have sheets assigned to the construction layers.
- **Construction State**: The Element should have its construction generated (with sheets) before running this script, or the Sequence Number should be set to ensure this runs after sheets are created.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_E-SplitSheetOnZoneMaterial.mcr`

### Step 2: Configure Properties
Upon insertion, if required, the Properties Palette will open.
Action: Set the **Zone index** to the layer you wish to process (e.g., the layer containing OSB) and define the **Gap** size.

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the Wall or Floor elements you wish to process. Press Enter to confirm selection.
```
*Note: The script will attach itself to the selected elements and process the sheets based on the properties defined.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence number | Integer | 0 | Determines the execution order during automatic construction generation. Set a higher number to ensure this runs after sheets are created. |
| Zone index | Dropdown | 1 | Selects the construction layer (zone) to process. (Options 1-10). The script looks for sheets in this specific layer. |
| Sheet color | Integer | -1 | Sets the color for the newly created split sheets. Use -1 to keep the original sheet color. |
| Sheet material | String | (Empty) | Enter a material name (e.g., "OSB 18mm") to assign to the resulting split sheets. If left empty, it may use default or original properties. |
| Gap | Double | 1 | The distance (in mm) of the gap to create between the target sheathing and other sheet materials in the zone. |

## Right-Click Menu Options
None. This script does not add specific options to the entity context menu.

## Settings Files
None. This script operates using internal logic and standard hsbCAD catalogs.

## Tips
- **Execution Order**: Ensure the **Sequence number** is higher than the scripts that generate the initial sheets. If it runs too early, there will be no sheets to split.
- **Target Identification**: The script specifically identifies "OSB" materials (based on internal naming conventions like "OSB", "OSB-KLEMLEKT") as the targets to cut. Other materials in the same zone are treated as obstacles.
- **Visualizing Results**: If you want to clearly see the new split pieces, change the **Sheet color** to a distinct color (e.g., Red) temporarily.

## FAQ
- **Q: Why did my sheets disappear?**
  A: The script deletes the original target sheets (OSB) and replaces them with the newly split geometry. If the calculation resulted in zero geometry (e.g., the gap was too large for the sheet), the sheet will be removed.
- **Q: What happens if I set the Zone Index to a layer with no sheets?**
  A: The script will report a warning and skip processing that element, leaving it unchanged.
- **Q: How does the Gap parameter work?**
  A: The script takes the profile of "obstacle" sheets, expands it by the Gap amount, and subtracts that area from the "OSB" sheets. A larger gap means the OSB sheets will be cut back further from the obstacles.