# GE_HDWR_STUD_PLATE_TIE_SPTS.mcr

## Overview
Automates the insertion of Stud Plate Tie (SPTS) hardware to connect vertical studs to horizontal top or bottom plates, ensuring correct orientation and attachment based on your selection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates 3D solid representations attached to beams. |
| Paper Space | No | Not supported for 2D views. |
| Shop Drawing | No | Not designed for shop drawing layouts. |

## Prerequisites
- **Required Entities**: `GenBeam` (Vertical Studs and Top/Bottom Plates).
- **Minimum Beams**: At least 1 Vertical Stud and 1 Horizontal Plate.
- **Required Settings**:
  - `TSL_Read_Metalpart_Family_Props.dll` located in `installation folder\Utilities\TslCustomSettings`.
  - `TSL_HARDWARE_FAMILY_LIST.dxx` located in the Company TSL Catalog path.
  - A TXT file containing SPTS family dimensions (referenced by the list above).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from TSL Catalog) → Select `GE_HDWR_STUD_PLATE_TIE_SPTS.mcr`

### Step 2: Select Beams
```
Command Line: Select beams (Studs and Plates):
Action: Select the vertical studs AND the horizontal plates (Top or Bottom) you wish to connect. Press Enter to confirm.
```

### Step 3: Define Reference Point
```
Command Line: Pick a point on the face:
Action: Click on the face of the stud or plate intersection where you want the tie to be installed. This defines the side of the beam the hardware will attach to.
```

### Step 4: Automatic Generation
The script will automatically detect the configuration (Top Plate, Bottom Plate, or both) and generate the hardware instances on all selected valid studs.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | Text | (Empty) | The product code of the tie (e.g., SPTS20). This is read-only. |
| dLength | Number | 170 mm | The vertical height of the tie. Read-only (determined by sType). |
| dWidth | Number | 35 mm | The width of the tie. Read-only (determined by sType). |

*Note: Dimension values are controlled by the selected product catalog entry. Do not attempt to modify these numbers directly in the palette.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Change type** | Opens a dialog to select a different product code from the catalog. This updates the Length and Width automatically. |
| **Help** | Displays a help report with usage instructions. |
| **Erase** | Removes the hardware instance. |
| **Move / Grip Edit** | Dragging the hardware grips or moving the stud triggers a recalculation. The tie will snap to the new position and flip orientation if moved to the other side of the stud. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx` (and referenced TXT files)
- **Location**: Company TSL Catalog path or Utility folder.
- **Purpose**: These files store the database of available SPTS models and their corresponding dimensions (Length/Width). The DotNet utility reads these to populate the "Change type" menu.

## Tips
- **Batch Processing**: You can select multiple studs and multiple plates at once. The script will intelligently match studs to the intersecting plates.
- **Dual Application**: If you select both Top and Bottom plates in the same command, the script will generate ties at both the top and bottom of the studs automatically.
- **Orientation**: If the tie generates on the wrong side of the wall, simply use the AutoCAD `Move` command or grip-edit the tie to flip it to the other face.

## FAQ
- **Q: Why can't I type a new length in the Properties palette?**
  A: The dimensions are locked to the specific manufacturer part number (`sType`). To change dimensions, use the Right-Click -> **Change type** option and select a different catalog entry.
- **Q: The script failed to generate hardware. Why?**
  A: Ensure you selected at least one vertical stud (parallel to World Z) and at least one horizontal plate. The script requires both to calculate the intersection.
- **Q: How do I reset the link to the catalog file?**
  A: Run the external script `GE_HDWR_RESET_CATALOG_ENTRY` to clear the stored path and force the script to ask for the file location again.