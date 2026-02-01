# BMF-Winkelverbinder _ T

## Overview
Generates and places steel angle connectors (L-plates) and tension ties at right-angle connections between two timber beams. It supports various manufacturer profiles (like BMF or Simpson Strong-Tie) and creates the necessary 3D geometry, cuts, and material lists for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in 3D model space. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a detailing script, not a drawing generator. |

## Prerequisites
- **Required Entities**: Two timber beams (GenBeams) intersecting each other.
- **Minimum Beam Count**: 2.
- **Required Settings**: None (Internal parameter tables are used).
- **Geometry Requirement**: The two selected beams **must** intersect at a **90-degree angle**. If the angle is not 90 degrees, the script will abort and delete the instance.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF-Winkelverbinder _ T.mcr`

### Step 2: Select Primary Beam
```
Command Line: Select beam:
Action: Click on the main timber beam (Beam 0) that will receive the cut and the hardware.
```

### Step 3: Select Secondary Beam
```
Command Line: Select intersecting beam:
Action: Click on the second timber beam (Beam 1) that intersects the first beam.
```

### Step 4: Configure Hardware
```
Action: A dialog window will appear automatically.
1. Select the Type (sType) from the list (e.g., BMF-Winkel 100, Simpson HTT22).
2. Set the Quantity (sNum) to "One" or "Two".
3. If "One", select the Side (sSide) as "Left" or "Right".
4. (Optional) Enable Switch (sSwitch) to rotate the bracket dimensions 90 degrees.
5. Click OK to generate.
```

## Properties Panel Parameters
After insertion, select the script instance in the model to edit these parameters in the AutoCAD Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sType** | Dropdown | Selected | The specific hardware model (e.g., BMF, Simpson). Changing this automatically updates dimensions (Height, Length, Thickness). |
| **sNum** | Dropdown | Two | Quantity of plates. Options: "One" or "Two". If set to "Two", plates are placed on both sides. |
| **sSide** | Dropdown | Left | Side of the beam for the plate. Options: "Left" or "Right". Disabled if `sNum` is "Two". |
| **sSwitch** | Dropdown | No | Swaps the Height and Length dimensions of the bracket (90-degree rotation). Options: "Yes", "No". |
| **sArt1** | String | *Empty* | Commercial Article number for the bracket (appears in BOM). |
| **sMat1** | String | Stahl... | Material description (e.g., "Galvanized Steel"). |
| **sMod2** | String | Kammnagel | Model/Type of the fastener (nail) used. |
| **dDia** | Number | 4 | Diameter of the nails (mm). |
| **dLen2** | Number | 40 | Length of the nails (mm). |
| **nNail1** | Integer | 0 | Quantity of nails per plate. Total count doubles if `sNum` is "Two". |
| **sLayer** | Dropdown | I-Layer | Assigns the hardware to a specific element layer (I, J, T, Z) for exporting/filtering. |
| **sNY** | Dropdown | Yes | Visibility of the text label/leader line. Options: "Yes", "No". |
| **nColor** | Integer | 171 | Color index (0-255) for the 3D body display. |

## Right-Click Menu Options
This script primarily uses standard TSL functionality. Context menu options may include:
| Menu Item | Description |
|-----------|-------------|
| **Erase** | Removes the script instance and generated geometry from the drawing. |
| **Re-calculate** | Forces the script to regenerate the geometry based on current properties (usually automatic). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal arrays for hardware dimensions and does not require external XML settings files.

## Tips
- **90 Degree Constraint**: Ensure your beams are perfectly perpendicular. Use AutoCAD's ortho constraints or rotate commands if the script fails to insert.
- **Double-Sided Connections**: When using `sNum` = "Two", you do not need to specify a Side; the script automatically mirrors the hardware.
- **Visual Confirmation**: The script displays a text label (Type and Sub-type) connected by a leader line. You can move the text by dragging the grip point (`_PtG`) in the model.
- **Dimension Switch**: If the bracket looks "wrong" (e.g., too tall but not wide enough), try changing `sSwitch` to "Yes" to swap the dimensions.

## FAQ
- **Q: The script disappeared immediately after I selected the second beam. Why?**
  - A: The beams likely did not form a perfect 90-degree angle. Check the angle between your two beams and try again.

- **Q: I cannot change the "Side" property in the list.**
  - A: This happens when `sNum` (Number of plates) is set to "Two". Change `sNum` to "One" to unlock the Side selection.

- **Q: How do I rotate the bracket 90 degrees?**
  - A: Change the `sSwitch` property to "Yes". This swaps the Height and Length values defined for the hardware type.