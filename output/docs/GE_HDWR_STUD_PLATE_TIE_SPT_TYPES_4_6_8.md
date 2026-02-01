# GE_HDWR_STUD_PLATE_TIE_SPT_TYPES_4_6_8.mcr

## Overview
This script generates 3D models of SPT (Stud Plate Tie) hardware, connecting vertical wall studs to top or bottom plates to resist uplift forces. It is designed to create structural hold-downs automatically based on a selectable catalog of types.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D Body geometry. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D shop drawings directly. |

## Prerequisites
- **Required Entities**: 
  - GenBeam entities representing Vertical Studs.
  - GenBeam entities representing Bottom or Top Plates.
- **Minimum Beam Count**: At least 1 Stud and 1 Plate must be selected.
- **Required Settings Files**: 
  - `TSL_Read_Metalpart_Family_Props.dll` (located in `Utilities\TslCustomSettings`).
  - A TXT source file containing dimensions for the SPT_TYPES_4_6_8 family.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `GE_HDWR_STUD_PLATE_TIE_SPT_TYPES_4_6_8.mcr`.

### Step 2: Select Hardware Type
**Command Line**: `Select Type from Family`
**Action**: A dialog box will appear. Search for and select the specific hardware model (e.g., SPT4, SPT6) you wish to use. Click OK.

### Step 3: Select Structural Elements
**Command Line**: `Select stud(s) and plate(s)`
**Action**: Click on the vertical studs and the top/bottom plates you want to connect. Press Enter when finished.

### Step 4: Define Location
**Command Line**: `Pick a point to define on what face of studs place hardware`
**Action**: Click on the side face of a stud where you want the tie to be installed. The script will calculate connections for all selected studs relative to this face.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Text | *From Catalog* | The manufacturer model or catalog code (e.g., 'SPT6'). Changing this reloads dimensions from the catalog. |
| Beam Width | Number | 115mm | The depth of the timber stud (throat depth). If this defaults to red, check your catalog data. |
| Height from base | Number | 29mm | The vertical height of the tie's legs extending from the plate. |
| Width | Number | 35mm | The horizontal width of the hardware strap. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Re-opens the hardware selection dialog, allowing you to switch to a different model code without re-inserting the script. |
| Help | Displays a brief usage report in the command line. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Defines the master list of available hardware families.
- **Filename**: TXT Source File (Specific to SPT family)
  - **Location**: Prompted if not found in standard paths.
  - **Purpose**: Contains the specific dimensions (width, height, thickness) for the different SPT types (4, 6, 8, etc.).

## Tips
- **Visual Warnings**: If the generated hardware appears in **Red**, the script could not find the specific dimension for the Beam Width in the catalog and used a default value (115mm). Update the `dBeamWidth` property manually or ensure the TXT catalog is correct.
- **Double Plates**: The script automatically detects "Very" plates (double top/bottom plates) and adjusts the hardware offset accordingly.
- **Automatic Updates**: If you move a stud or plate connected to the hardware, the tie will automatically update its position to maintain the connection.

## FAQ
- **Q: Why did the script fail to insert?**
  - A: Ensure you selected at least one vertical stud and one plate (top or bottom). The script requires both to calculate the connection.
- **Q: Can I update multiple existing connections at once?**
  - A: No, the "Change type" option updates the specific instance you right-clicked. Use standard AutoCAD selection methods if you need to delete and regenerate multiple instances.
- **Q: How do I fix the path if the TXT file is missing?**
  - A: Use the `GE_HDWR_RESET_CATALOG_ENTRY` script to reset the file path to the correct TXT source location.