# GE_HDWR_STUD_PLATE_TIE_SPTH.mcr

## Overview
Generates 3D geometry for "Stud Plate Tie" hardware (SPTH family), which connects vertical studs to horizontal top or bottom plates in timber framing to resist uplift or shear forces.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D modeling in Model Space. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for generating 2D shop drawings directly. |

## Prerequisites
- **Required Entities**: 
  - GenBeam entities representing vertical studs.
  - GenBeam entities representing Top or Bottom plates.
- **Minimum Beam Count**: 2 (1 Stud + 1 Plate).
- **Required Settings**:
  - `TSL_Read_Metalpart_Family_Props.dll` (located in `Utilities\TslCustomSettings`)
  - A TXT file containing SPTH family details (dimensions and properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STUD_PLATE_TIE_SPTH.mcr`

### Step 2: Select Structural Members
```
Command Line: Select stud(s) and plate(s)
Action: Use a window or select individual beams to pick the vertical studs and the horizontal plates (Top or Bottom) you wish to connect.
```

### Step 3: Define Placement Face
```
Command Line: Pick a point to define on what face of studs place hardware
Action: Click on or near the face of a stud where you want the hardware strap to be located.
```

### Step 4: Select Hardware Type
```
Dialog: Select Hardware Type
Action: A dialog box will appear listing available SPTH types. Search or select the desired model code (e.g., SPH44) and confirm.
```
*(Note: This step may be skipped if the script detects existing catalog properties).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Text | "" | The specific model code of the hardware (e.g., 'SPH44'). Changing this reloads dimensions from the catalog. |
| Beam Width | Number | 0 | The depth/thickness of the stud (or combined width) that the hardware wraps around. |
| Height from base | Number | 0 | The vertical height of the hardware plate measured from the plate connection point. |
| Width | Number | 0 | The width of the hardware strap perpendicular to the wall face (heel width). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens the selection interface to choose a different hardware model from the SPTH catalog. |
| Help | Displays a description of the SPTH Stud Tie Hardware Family functionality. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Catalog listing available hardware families.

- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
  - **Location**: `_kPathHsbInstall\Utilities\TslCustomSettings`
  - **Purpose**: External library used to read hardware properties from TXT files.

- **Filename**: TXT File (User defined)
  - **Location**: Any folder (Prompted if not found)
  - **Purpose**: Contains specific dimension and property data for the hardware types.

## Tips
- **Batch Processing**: You can select multiple studs and multiple plates in Step 2. The script will automatically calculate valid intersections and create hardware for all of them.
- **Visual Error Handling**: If the hardware geometry appears **Red**, it means the script could not load the correct dimensions from the catalog. Use the "Change type" context menu to select a valid type.
- **Moving Hardware**: You can use standard AutoCAD move grips on the element to reposition the hardware along the stud or plate. The script will attempt to maintain orientation relative to the beams.

## FAQ
- **Q: Can I use this to connect studs to both top and bottom plates simultaneously?**
  - A: Yes. If you select studs along with both top and bottom plates in Step 2, the script will generate separate instances for every valid connection (stud-to-bottom and stud-to-top).

- **Q: What happens if the path to the TXT catalog file is lost?**
  - A: You can use the `GE_HDWR_RESET_CATALOG_ENTRY` script to reset the source file path for this hardware family.

- **Q: Why did my hardware disappear?**
  - A: This usually happens if the associated Stud or Plate beam is deleted or if the intersection between them is no longer valid. Check that your structural members are still present and intersecting correctly.