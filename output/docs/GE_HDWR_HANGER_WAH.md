# GE_HDWR_HANGER_WAH.mcr

## Overview
Inserts a Wide-Angle Hanger (WAH) hardware family, generating a custom metal hanger with seat flanges, a back plate, and a stiffener web, along with optional anchor connections. It is typically used to support floor joists or beams on the face of vertical studs or wall plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D geometry. |
| Paper Space | No | Not designed for 2D layout or detailing. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: Beams (GenBeam) and Elements must exist in the model.
- **Minimum Beam Count**: At least 1 beam (usually multiple vertical studs) must be selected during insertion.
- **Required Settings**:
  - Catalog file: `TSL_HARDWARE_FAMILY_LIST.dxx` (Located in `Company TSL\Catalog`).
  - DLL file: `TSL_Read_Metalpart_Family_Props.dll` (Located in hsbCAD Utilities folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_HANGER_WAH.mcr`

### Step 2: Select Studs
```
Command Line: Select beams
Action: Click on the vertical stud(s) or support beams where you want to install the hangers. Press Enter to confirm selection.
```

### Step 3: Define Reference Point
```
Command Line: Give point
Action: Click a point near the selected beams to define the side or face where the hangers should be attached. The script will detect the direction based on this point relative to the beams.
```

### Step 4: Automatic Generation
**Action**: The script automatically calculates the insertion points on the selected beams and creates individual hanger instances. The initial "helper" instance will disappear, leaving the actual hardware components on the beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | Text | WAH16 | The specific model number of the hanger (e.g., WAH16). This loads the standard dimensions from the catalog. |
| dClearWidth | Number | 70 | The internal gap between the side flanges (width of the joist being supported). |
| dOverallDepth | Number | 560 | The horizontal depth of the hanger from back to front (bearing length). |
| dOverallHeight | Number | 50 | The total vertical height of the hanger assembly. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens a dialog to select a different hanger model from the catalog. This updates dimensions (Width, Depth, Height) automatically. |
| Help | Displays usage instructions and feature details in the command line/report window. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `Company TSL\Catalog`
- **Purpose**: Stores the standard dimensions and properties for various WAH hardware models (e.g., WAH16, WAH20). Without this file, the script cannot load default dimensions.

## Tips
- **Batch Installation**: You can select multiple vertical studs at once during the "Select beams" prompt. The script will array the hangers along all selected beams based on the reference point.
- **Grip Editing**: If you need to move a hanger after insertion, use the grip edit point to move it. The script will automatically snap it to the nearest end or face of the attached beam.
- **Vertical Detection**: Ensure the beams selected are vertical (studs). The script is optimized to detect vertical beams relative to the world Z-axis.

## FAQ
- **Q: Why did the script disappear immediately after I ran it?**
  **A**: This usually happens if the script cannot find the catalog file (`TSL_HARDWARE_FAMILY_LIST.dxx`) or if no valid beams were selected. Check your file paths and ensure you selected valid beams.

- **Q: How do I change the size of an existing hanger?**
  **A**: Select the hanger, right-click, and choose **Change type**. Select the new model from the list, and the dimensions will update automatically.

- **Q: Can I use this on horizontal beams?**
  **A**: The script is designed to detect vertical beams to act as supports. Using it on horizontal beams may result in incorrect orientation or failure to attach.