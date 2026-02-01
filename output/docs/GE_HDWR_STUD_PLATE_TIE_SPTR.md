# GE_HDWR_STUD_PLATE_TIE_SPTR.mcr

## Overview
Generates a 3D model of a Stud Plate Tie (SPTR) metal connector, securing vertical studs to horizontal top or bottom plates in timber framing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Use in the 3D model to generate hardware bodies. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** GenBeam (Studs and Plates).
- **Minimum Beam Count:** 2 (1 Stud and 1 Plate).
- **Required Settings Files:**
  - `TSL_Read_Metalpart_Family_Props.dll` (Located in `..\Utilities\TslCustomSettings`)
  - TXT file containing SPTR families details.
  - `TSL_HARDWARE_FAMILY_LIST.dxx` catalog file.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STUD_PLATE_TIE_SPTR.mcr`

### Step 2: Select Structural Elements
```
Command Line: Select stud(s) and plate(s)
Action: Click to select the vertical stud(s) and the horizontal bottom or top plate beam(s) they connect to. Press Enter to confirm selection.
```

### Step 3: Define Orientation
```
Command Line: Pick a point to define on what face of studs place hardware
Action: Click in the 3D model on the side of the wall where the metal strap should be applied (e.g., left face, right face, interior, or exterior).
```

### Step 4: Configure Type (Optional)
After insertion, the script attempts to load dimensions from the catalog. If the Type is empty, use the **Properties** palette to select a code or use the Right-Click menu.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Text | "" | The specific manufacturer model or catalog code (e.g., 'SPTR38'). Determines initial dimensions. |
| Lenght | Number | 0 | The total length of the metal tie strap. |
| Major Width | Number | 0 | The width of the main plate section sitting flush against the stud face. |
| Minor Width | Number | 0 | The width of the narrower strap sections wrapping around the sides. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens a dialog to select a new hardware family type from the catalog, automatically updating dimensions. |
| Help | Displays a report notice with script usage information. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `_kPathHsbCompany\TSL\Catalog\`
- **Purpose**: Catalog file listing available hardware families.

- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
- **Location**: `_kPathHsbInstall\Utilities\TslCustomSettings\`
- **Purpose**: Handles reading family properties from TXT source files and displaying selection dialogs.

## Tips
- **Batch Processing:** You can select multiple studs and plates in a single operation during Step 2. The script will automatically detect intersections and create an instance for each relevant connection.
- **Double Plates:** The script automatically detects double top plates or rim joists ("Extra Plates") and adjusts the tie offset accordingly.
- **Visual Warnings:** If the generated hardware body appears **Red**, it indicates the catalog data could not be read. Check that your TXT source files are correctly configured in the Company Catalog path.

## FAQ
- **Q: Why does my connector show up as a red block?**
  **A:** This means the script could not find valid dimensions (Length, Major Width, Minor Width) in the loaded catalog map. Ensure the selected "Type" exists in your hardware TXT files and the DLL is accessible.
- **Q: Can I use this for both top and bottom plates?**
  **A:** Yes. Select both top and bottom plates along with the studs during the selection prompt. The script will identify valid intersections for both locations.