# hsb_PocketPointLoad.mcr

## Overview
Inserts structural reinforcement (studs, sills, and transoms) into a timber wall to support point loads or create structural openings (pockets). This script also provides options to split top and bottom plates, transfer loads with cripple studs, and apply specific CNC machining profiles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary operating environment. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An existing `ElementWall` in the model.
- **Minimum Beam Count**: 0 (Script generates new beams).
- **Required Settings**:
    - `Materials.xml` file located at `_kPathHsbCompany\Abbund\` is required to populate material and grade dropdowns.
    - Reference to `hsbCNC` script for catalogue properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or assigned alias) → Select `hsb_PocketPointLoad.mcr`

### Step 2: Select Wall Element
```
Command Line: Please select Elements
Action: Click on the Wall Element where you want to insert the reinforcement or pocket.
```

### Step 3: Define Location and Reference
```
Command Line: Select a beam, enter to pick a point
Action: 
- Option A: Click on an existing beam in the wall to automatically inherit its width and use its location as a reference.
- Option B: Press Enter and click a point in the model space to manually define the insertion point.
```

### Step 4: Configure Properties
After insertion, select the generated element and open the **Properties Palette** (Ctrl+1) to adjust dimensions, materials, and structural settings.

## Properties Panel Parameters

### Geometry & Layout
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of beams (`nBmQty`) | Int | 0 | The number of vertical studs to insert. |
| Timber width, 0=auto (`dBmWidth`) | Double | 0 | Thickness of the timber members. Set to 0 to inherit width from the wall or selected beam. |
| Alignment (`sAlign`) | String | Left | Aligns the stud group relative to the insertion point (Left, Center, Right). |
| Pocket Base Height (`dPocketBaseHeight`) | Double | 1500 | Vertical height from the bottom of the wall to the bottom of the pocket/reinforcement. |

### Pocket Options (Openings)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pocket Width, 0=none (`dPocketWidth`) | Double | 0 | Width of the pocket. Set to 0 to create a point load (studs only); set > 0 to create a structural opening. |
| Pocket Height (`dPocketHeight`) | Double | 250 | Vertical height of the pocket opening. |
| Pocket Sill Width, 0=none (`dSillWidth`) | Double | 0 | Width of the bottom horizontal member (Sill). 0 means no sill is created. |
| Pocket Transom Width, 0=none (`dTransomWidth`) | Double | 0 | Width of the intermediate horizontal member (Transom). 0 means no transom is created. |
| Transom Top Gap (`dTransomGap`) | Double | 0 | Vertical gap between the top of the transom and the top plate. |

### Structural Logic
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Transfer Load with Cripples (`sTransferLoad`) | String | No | If "Yes", generates cripple/jack studs above/below the pocket to transfer load to plates. |
| Split Top Plate (`sSplitTopPlate`) | String | No | If "Yes", cuts the existing wall top plate to accommodate the reinforcement. |
| Split Bottom Plate (`sSplitBottomPlate`) | String | No | If "Yes", cuts the existing wall bottom plate. |

### Naming & Material
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name/Material/Code Stud (`sNameStud`, `sMaterialStud`, etc.) | String | STUD/C16/... | Defines the entity name, material, grade, and code for vertical studs. |
| Name/Material/Code Sill (`sNameSill`, etc.) | String | SILL/C16/... | Defines properties for the bottom horizontal member. |
| Name/Material/Code Transom (`sNameTransom`, etc.) | String | TRANSOM/C16/... | Defines properties for the intermediate horizontal member. |
| Angle Brackets (`sAngleBrackets`) | String | No | Inserts angle bracket hardware (Options: No, Bottom, Top, Both). |
| Angle Brackets Locations (`sAngleBracketsLocations`) | String | Both | Specifies which side receives brackets (Left, Right, Both). |

### Production & Output
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create Beams as Modules (`sCreateModule`) | String | No | Groups generated beams into a production module. |
| Apply cnc tool (`sCncCatalogue`) | String | None | Selects a CNC machining profile to apply to the new beams. |
| Select Dim Style (`sDimStyle`) | String | - | Selects the dimension style for annotations. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: This file is essential for the script to function. It populates the Material and Grade dropdown lists in the properties palette. If this file is missing, the script will display an error and halt execution.

## Tips
- **Point Load Mode**: To create a simple point load reinforcement (e.g., under a beam bearing) without creating a full opening, ensure `Pocket Width` is set to `0`. This will generate vertical studs only.
- **Pocket Mode**: Set `Pocket Width` to a value greater than `0` to create a framed opening. This automatically enables logic for Sills and Transoms if their widths are defined.
- **Interference Handling**: The script automatically detects and handles existing blocking in the wall. It will either erase blocking fully covered by the new insert or split/trim blocking that is partially covered.
- **Quick Setup**: Clicking an existing beam during insertion (Step 3) is the fastest way to ensure the new studs match the wall's timber width and align perfectly with existing geometry.

## FAQ
- **Q: Why did the script erase my instance immediately after insertion?**
  - A: This usually happens if the `Materials.xml` file cannot be found at the specified path (`_kPathHsbCompany\Abbund\`). Check your company folder structure.
- **Q: How do I cut the top plate to allow the new studs to pass through?**
  - A: Set the property `Split Top Plate` to "Yes". This will perform a boolean subtraction or split operation on the existing top plate beams.
- **Q: What is the difference between "Point Load" and "Pocket" in this script?**
  - A: The distinction is controlled by `Pocket Width`. If `0`, it acts as a point load (vertical reinforcement only). If `> 0`, it acts as a pocket (creating an opening with horizontal members like sills/headers).