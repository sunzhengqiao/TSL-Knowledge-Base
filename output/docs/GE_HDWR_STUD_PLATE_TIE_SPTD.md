# GE_HDWR_STUD_PLATE_TIE_SPTD.mcr

## Overview
This script automatically inserts SPTD Stud Tie hardware to connect vertical studs with horizontal top and bottom plates. It detects intersections between selected elements and generates the corresponding 3D hardware geometry.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation script, not a detailing tool. |

## Prerequisites
- **Required Entities**: Structural GenBeams representing Vertical Studs, Bottom Plates, and Top Plates must exist in the model.
- **Minimum Selection**: At least one vertical stud and one horizontal plate must be selected.
- **Required Settings**:
  - Catalog files (TXT format) for SPTD families must be present in `_kPathHsbCompany\TSL\Catalog\`.
  - `TSL_HARDWARE_FAMILY_LIST.dxx` must exist in the company catalog folder.
  - `TSL_Read_Metalpart_Family_Props.dll` must be located in the hsbCAD installation `Utilities\TslCustomSettings` folder.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the script location and select `GE_HDWR_STUD_PLATE_TIE_SPTD.mcr`.

### Step 2: Select Beams
```
Command Line: Select stud(s) and plate(s)
Action: Use a window or click selection to pick the vertical studs and the horizontal plates (both top and bottom) you wish to connect. Press Enter when finished.
```

### Step 3: Define Installation Side
```
Command Line: Pick a point to define on what face of studs place hardware
Action: Click on the specific face (side) of a stud. The script will place the hardware on this side of the wall for all valid intersections.
```

### Step 4: Select Hardware Type (If required)
- If the script prompts, a dialog will appear allowing you to search and select the specific SPTD hardware type from the catalog list.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | (From Catalog) | The identifier for the specific SPTD hardware family selected. |
| Lenght | Number | 0 | The length of the hardware piece (usually populated by catalog). |
| Width | Number | 0 | The width of the hardware piece (usually populated by catalog). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens a dialog to select a different hardware configuration from the SPTD catalog. Updates dimensions and redraws the geometry. |
| Help | Displays a report notice with instructions and details regarding the SPTD Stud Tie Hardware Family. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Defines the list of available hardware families.
- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
  - **Location**: `_kPathHsbInstall\Utilities\TslCustomSettings\`
  - **Purpose**: Reads the properties from the TXT catalog files.
- **Filename**: `[SPTD_Family].txt`
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Contains specific geometric dimensions for the hardware types.

## Tips
- Ensure your structural studs and plates physically intersect (touch) in the 3D model. The script uses these intersections to calculate placement.
- You can select a large group of studs and plates at once; the script will filter them and generate hardware for every valid pair.
- If the hardware is drawn in **Red**, it indicates that the specific catalog data could not be found or was invalid, and default dimensions were used instead.

## FAQ
- **Q: Why did the script not generate any hardware?**
  - A: Ensure you selected at least one vertical stud and one horizontal plate. Also, verify that the beams actually intersect each other in the model.
- **Q: Can I change the hardware size after inserting?**
  - A: Yes, select the inserted hardware instance, right-click, and choose **Change type** to select a different size from the catalog.
- **Q: What does the "Reset TXT source file" feature mentioned in the version history do?**
  - A: It allows advanced users to reload catalog data if the TXT file has been modified externally, usually triggered by another utility script.