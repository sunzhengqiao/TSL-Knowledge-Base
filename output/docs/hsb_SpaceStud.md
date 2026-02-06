# hsb_SpaceStud.mcr

## Overview
This script converts standard timber studs within selected walls into "Space Studs" by splitting them longitudinally and applying nail plates or metal clips. It allows for detailed filtering based on beam types, codes, and lengths to automate the creation of insulation spacing in timber frame walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for processing ElementWallSF and GenBeam entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** ElementWallSF (Wall entities).
- **Minimum Beam Count:** 0 (Processes existing beams within selected walls).
- **Required Settings Files:**
  - `hsb_SpaceStudAssembly.tsl` (Sub-script for generating the assembly).
  - Catalog entries for Space Stud sizes (e.g., 80mm, 55mm).
  - Nail plate definitions loaded in the catalog.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SpaceStud.mcr`

### Step 2: Configure Properties (Optional)
Before insertion, you may adjust the parameters in the **Properties Palette** to define which beams should be processed (e.g., set Wall Codes, Minimum Length, or Toggle specific beam types).

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall elements (ElementWallSF) you wish to process and press Enter.
```
*Note: The script will filter the selected entities to find valid walls matching the "Code SpaceStud Wall" property.*

### Step 4: Automatic Processing
Once selected, the script automatically:
1. Iterates through beams in the selected walls.
2. Filters beams based on your configuration (Code, Type, Length).
3. Splits valid studs into two separate beams.
4. Inserts Nail Plates (for standard studs) or Clips (for short studs).
5. Groups the components into an `hsb_SpaceStudInstance`.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Code SpaceStud Wall** | Text | `M;` | The code assigned to the wall elements that should be processed. Only walls with this code (in their name or properties) will be affected. |
| **Beams NOT to plate** | Text | `----------` | A string identifier for beams that should not receive plating (Legacy/Internal filter). |
| **Jacks Above/Below Opening** | Dropdown | `No` | Determines if Jack studs are processed or ignored. |
| **Blocking** | Dropdown | `No` | Determines if Blocking members are processed or ignored. |
| **Top Plate** | Dropdown | `No` | Determines if the Top Plate is processed or ignored. |
| **Bottom Plate** | Dropdown | `No` | Determines if the Bottom Plate is processed or ignored. |
| **Transom** | Dropdown | `No` | Determines if Transom beams are processed or ignored. |
| **Beams to Ignore** | Text | `----------` | A string identifier for beams to be skipped completely. |
| **Ignore all opening beams** | Dropdown | `No` | If `Yes`, ignores cripples, king studs, sills, transoms, and jacks. |
| **First Cripple** | Dropdown | `No` | Determines if the first cripple stud is processed. |
| **All Cripples** | Dropdown | `No` | Determines if all cripple studs are processed. |
| **King Studs** | Dropdown | `No` | Determines if King Studs are processed. |
| **Jacks Above/Below Opening** | Dropdown | `No` | Duplicate parameter for Jacks control. |
| **Left/Right Studs** | Dropdown | `No` | Determines if standard Left/Right studs are processed. |
| **Sill/Transom** | Dropdown | `No` | Determines if Sill/Transom beams are processed. |
| **Packer** | Dropdown | `No` | Determines if Packer beams are processed. |
| **Apply only one clip** | Dropdown | `No` | If `Yes`, applies a single clip instead of standard configuration. |
| **Exclude Beams with Code** | Text | | List of beam codes to exclude (separate multiple codes with `;`). |
| **Minimum length for space stud** | Number | `600` | Beams shorter than this length (in mm) may be treated differently (e.g., clipped instead of plated). Set to 0 to disable. |
| **Only clip beams smaller than minimum length** | Dropdown | `No` | If `Yes`, beams smaller than the minimum length will be clipped; larger beams will follow standard plating logic. |

## Right-Click Menu Options
No specific right-click context menu options are defined for this script instance.

## Settings Files
- **Filename**: `hsb_SpaceStudAssembly.tsl`
- **Location**: hsbCAD application path (TSL folder).
- **Purpose**: This sub-script is called to generate the actual geometry and assembly of the split studs and connecting hardware.

## Tips
- **Wall Codes**: Ensure the walls you select have the "Code SpaceStud Wall" (default `M;`) correctly assigned in their properties, or update the script property to match your project's wall naming convention.
- **Length Filtering**: Use the "Minimum length" and "Only clip beams..." settings to handle short cripple studs differently from full-height studs, ensuring optimal fabrication details.
- **Beam Exclusion**: Use the "Exclude Beams with Code" property to prevent specific structural beams (like posts or beams with specific codes) from being split.

## FAQ
- **Q: Why didn't the script process my studs?**
- **A:** Check that the selected Wall entity matches the "Code SpaceStud Wall" property. Also, verify that the studs are not excluded by the "Exclude Beams with Code" or specific type filters (e.g., if "Left/Right Studs" is set to "No").
- **Q: What happens to the original studs?**
- **A:** The original studs are deleted and replaced by the new "Space Stud" assembly containing the split beams and plates.
- **Q: Can I use this on existing walls?**
- **A:** Yes, simply select the existing `ElementWallSF` entities when prompted by the script.