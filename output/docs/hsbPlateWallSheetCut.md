# hsbPlateWallSheetCut.mcr

## Overview
Automatically creates cutouts (openings) in wall sheeting or structural plates where horizontal beams (such as roof purlins or floor joists) penetrate the wall. This ensures proper structural clearance without manual drafting.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model geometry. |
| Paper Space | No | Not applicable for 2D drawings or viewports. |
| Shop Drawing | No | This is a detailing script, not a drawing generator. |

## Prerequisites
- **Required Entities**: You must have existing Wall entities (`ElementWallSF`) and Beam entities (`GenBeam`) in the model.
- **Minimum Beams**: At least 1 beam intersecting the wall.
- **Required Settings**: None strictly required, but `hsbPlateWallSheetCut.xml` is recommended for default dimensions.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsbPlateWallSheetCut.mcr`.

### Step 2: Select Intersecting Beams
```
Command Line: Select intersecting beams
Action: Click on the beam(s) (e.g., purlins) that pass through the wall. Press Enter to confirm.
```

### Step 3: Select Wall Elements
```
Command Line: Select walls or entities belonging to a wall
Action: Click on the wall outline, the wall sheeting, or any entity belonging to the specific wall where the cutouts are needed. Press Enter to confirm.
```

### Step 4: Adjust Parameters (Optional)
After insertion, select the script instance and modify the dimensions in the **Properties Palette** if the defaults are not suitable.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| X1 | Number | 0 | Horizontal clearance added to the cutout at the bottom edge (widens the hole left/right at the bottom). |
| Y1 | Number | 0 | Vertical clearance added downwards from the beam at the bottom edge. |
| X2 | Number | 0 | Horizontal clearance added to the cutout at the top edge (widens the hole left/right at the top). |
| Y2 | Number | 0 | Vertical clearance added upwards from the beam at the top edge. |
| Y3 | Number | 0 | Additional vertical offset applied to fine-tune the bottom start position of the cut. |
| Zone | Dropdown | 5 | Selects the specific wall layer (zone) to cut. (e.g., -5 to 5). Check your wall setup to identify the correct layer index. |
| Subsequent Zones | Dropdown | \|No\| | Set to \|Yes\| to automatically apply the cut to adjacent wall layers as well. |
| Offset | Number | 0 | If "Subsequent Zones" is Yes, this value adjusts the size of the cut for each additional layer (creating a stepped effect). |

## Right-Click Menu Options
This script does not add specific custom options to the right-click context menu. Use the standard AutoCAD properties to modify parameters.

## Settings Files
- **Filename**: `hsbPlateWallSheetCut.xml`
- **Location**: 
  - `_kPathHsbCompany\TSL\Settings`
  - `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: If the properties (X1, Y1, etc.) are left at 0, the script attempts to read default dimensions from this XML file. This allows you to set company-wide standard cutout sizes without manually typing them every time.

## Tips
- **Zero Dimensions**: If you run the script and see no cutout (or a tiny line), check if your Property values are 0. If they are, the script is looking for the XML file. Either configure the XML file or manually type dimensions in the Properties palette.
- **Zones**: Walls are often built of multiple layers (e.g., framing, sheathing, cladding). Use the **Zone** property to target exactly which layer needs the hole.
- **Visualizing**: It is often easier to insert the script with standard dimensions first, then use the Properties Palette to fine-tune the clearances until they look correct in the 3D model.

## FAQ
- **Q: Why is my cutout size 0?**
  A: The script properties default to 0, expecting an XML settings file to provide the dimensions. Ensure `hsbPlateWallSheetCut.xml` exists in your settings folder, or manually enter values for X1, Y1, X2, and Y2 in the properties.
- **Q: Can I cut through the entire wall thickness at once?**
  A: Yes. Set **Subsequent Zones** to `|Yes|` and select the starting Zone. The script will propagate the cut through adjacent layers.
- **Q: What does the Offset parameter do?**
  A: It adds (or subtracts) from the cut dimensions for every layer away from the selected Zone. This is useful for creating clearance for tapered insulation or allowing for play in the structure.