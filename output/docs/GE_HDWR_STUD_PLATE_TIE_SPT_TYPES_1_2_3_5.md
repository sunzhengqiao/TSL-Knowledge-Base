# GE_HDWR_STUD_PLATE_TIE_SPT_TYPES_1_2_3_5.mcr

## Overview
This script generates 3D geometry for Simpson Strong-Tie style stud-to-plate tie straps (Types 1, 2, 3, and 5). It automatically places metal connectors on selected vertical studs where they intersect with top or bottom plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D bodies using GenBeam entities. |
| Paper Space | No | Not designed for 2D layouts or views. |
| Shop Drawing | No | Does not process shop drawing layouts. |

## Prerequisites
- **Required Entities**: 
  - GenBeams representing vertical studs.
  - GenBeams representing at least one Top Plate or Bottom Plate.
- **Minimum Beam Count**: 2 (1 Stud + 1 Plate).
- **Required Settings Files**:
  - `TSL_Read_Metalpart_Family_Props.dll` (Required for selecting hardware types).
  - `TSL_HARDWARE_FAMILY_LIST.dxx` (Catalog of available hardware families).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STUD_PLATE_TIE_SPT_TYPES_1_2_3_5.mcr` from the file browser.

### Step 2: Select Beams
```
Command Line: Select stud(s) and plate(s)
Action: Click to select the vertical studs and the top or bottom plates they connect to. Press Enter to confirm selection.
```

### Step 3: Select Hardware Type
```
Dialog: Select Hardware Family
Action: A DotNet dialog will appear. Browse or search for the desired Strap Type (e.g., SPT1, SPT2) and click OK.
```

### Step 4: Define Orientation
```
Command Line: Pick a point to define on what face of studs place hardware
Action: Click on the screen on the side of the stud where you want the metal strap to wrap (e.g., left side or right side of the stud).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | (Empty) | The specific model/part number of the tie strap (Read-Only). |
| Lenght | Double | 0 | Total vertical height of the strap (Read-Only). |
| Clear Width | Double | 0 | Horizontal width of the strap at the top section (Read-Only). |
| Base Width | Double | 0 | Horizontal width of the strap at the base/plate connection (Read-Only). |
| Plates Height | Double | 0 | Vertical height of the strap portion sitting against the stud relative to the plate (Read-Only). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens a dialog to select a different hardware family. This updates all dimensions (Length, Widths, etc.) based on the new selection. |
| Help | Displays a message box with usage instructions for the script. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `_kPathHsbCompany\TSL\Catalog\`
- **Purpose**: Contains the catalog of hardware families and their associated dimensions.

- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
- **Location**: `_kPathHsbInstall\Utilities\TslCustomSettings\`
- **Purpose**: Handles the reading of TXT catalog files and provides the user interface for selecting hardware types.

## Tips
- **Batch Processing**: You can select multiple studs and multiple plates in one go. The script will automatically generate connectors for every valid stud-to-plate intersection found.
- **Orientation**: The script determines the "face" of the stud based on the point you pick in Step 4. If the strap appears on the wrong side, delete it and pick a point on the opposite side when re-inserting.
- **Updating Dimensions**: Since the dimension properties are Read-Only, always use the "Change type" context menu option to switch to a different size rather than trying to type in numbers.

## FAQ
- **Q: Why did the script disappear after I selected the beams?**
  A: This usually happens if you did not select a valid combination of vertical studs and plates, or if you canceled the hardware selection dialog.
- **Q: Can I modify the Length or Width manually in the properties palette?**
  A: No, these values are locked to ensure they match the manufacturer's specifications for the selected Type. Use "Change type" to switch sizes.
- **Q: How do I update the hardware catalog if new parts are added?**
  A: Run the `GE_HDWR_RESET_CATALOG_ENTRY` script. This dependency forces the hardware script to reload its TXT source file and update the available options.