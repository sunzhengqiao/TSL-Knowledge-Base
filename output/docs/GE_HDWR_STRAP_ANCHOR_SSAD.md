# GE_HDWR_STRAP_ANCHOR_SSAD.mcr

## Overview
This script inserts a steel Strap Anchor (SSAD family, similar to Simpson Strong-Tie STHD) that wraps over top and bottom plates to secure wall studs. It is designed for anchoring shear walls to foundations or ledgers where high tension (uplift) and shear loads are present.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D Body geometry for hardware. |
| Paper Space | No | Not applicable for drawing views. |
| Shop Drawing | No | Not applicable for 2D generation. |

## Prerequisites
- **Required Entities**: 
  - `GenBeam` entities representing Studs (vertical).
  - `GenBeam` entities representing Plates (Top, Bottom, or VeryTop/VeryBottom).
- **Minimum Beam Count**: At least 1 Stud and 1 Plate.
- **Required Settings**:
  - `TSL_Read_Metalpart_Family_Props.dll` must be available.
  - A TXT file containing SSAD family specifications located in the Company TSL Catalog path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STRAP_ANCHOR_SSAD.mcr`

### Step 2: Select Studs and Plates
```
Command Line: Select stud(s) and plate(s)
Action: Click to select the wall studs and the plates (top/bottom) they connect to. Press Enter to confirm selection.
```

### Step 3: Define Hardware Face
```
Command Line: Pick a point to define on what face of studs place hardware
Action: Click a point on the desired side of the wall (e.g., left exterior face) to determine where the strap anchor will be generated.
```

### Step 4: Select Model
- A dialog window will appear prompting you to select the specific hardware model (e.g., STHD10, STHD14) from the catalog.
- Select the desired model and click OK.

*(Note: The script will automatically generate connectors for every valid stud/plate combination found in your selection and erase the original "Master" instance.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | (Catalog Selection) | The manufacturer model code (e.g., "STHD10"). Read-only; change via the right-click menu "Change type". |
| Lenght | Number | 0 | The vertical height of the strap anchor leg. Updated automatically based on the Type selection. |
| Embedment | Number | 0 | The length of the horizontal anchor leg extending into the foundation. This can be manually edited. |
| Width | Number | 0 | The width (gauge breadth) of the steel strap material. Updated automatically based on the Type selection. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens a dialog to re-select the hardware model from the catalog. This automatically updates Length, Width, and Embedment properties. |
| Help | Displays a message box with a brief description of the script (SSAD Strap Anchor). |
| Reset TXT source | Reloads the catalog data from the source TXT file (useful if catalog definitions have changed). |

## Settings Files
- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
- **Location**: hsbCAD application folder (DLLs)
- **Purpose**: Handles the loading and parsing of metalwork family properties.
- **Filename**: `*.txt` (Catalog files)
- **Location**: Company TSL Catalog path
- **Purpose**: Contains the dimensional data (Length, Width, Embedment) for specific hardware models.

## Tips
- **Bulk Insertion**: You can select multiple studs and multiple plates in one go. The script calculates all intersections and creates a connector for each stud relative to the top and bottom plates separately.
- **Double Plates**: The script automatically detects "VeryTop" or "VeryBottom" plates and calculates the correct offset so the strap sits flush against the stud face, accounting for the extra plate thickness.
- **Moving Walls**: Because the script uses `setDependencyOnEntity`, if you move or modify the studs/plates using standard AutoCAD commands, the strap anchors will automatically update to the new position.

## FAQ
- **Q: Why does the script instance seem to disappear immediately after I run it?**
  - A: This is normal behavior. The script acts as a "Master" that spawns individual child instances for every stud/plate connection and then erases itself to avoid duplicates.
- **Q: Can I modify the dimensions manually?**
  - A: While you can manually edit the "Embedment" value in the properties palette, the "Length" and "Width" are strictly controlled by the selected Catalog Type. Use the "Change type" menu option to switch to a different size.
- **Q: What happens if I only select studs and no plates?**
  - A: The script will display an error "Not valid top or bottom plates provided" and abort the insertion. You must select at least one plate.