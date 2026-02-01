# HSB_E-ExtendBeam.mcr

## Overview
This script automatically extends the length of specific beams within selected elements to create overlength (excess material). It is typically used to ensure beams penetrate into connection points or allow extra material for subsequent machining operations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script modifies 3D beam geometry directly. |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | Not designed for layout generation. |

## Prerequisites
- **Required entities**: Element (e.g., Wall, Roof, Floor).
- **Minimum beam count**: 1 (inside the selected element).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` in the AutoCAD command line and select `HSB_E-ExtendBeam.mcr` from the file list.

### Step 2: Configure Properties
Once loaded, the Properties Palette (OPM) will display the script settings. Adjust the filters and extension values before proceeding.

**Configuration Guide:**
1.  **Filter Section**: Define which beams to target.
    *   You can filter by **Beam Code** (e.g., `ST*`), **Label**, or **Material**.
    *   **Filter Operation**: Choose "Exclude" to process everything *except* what matches your text filters, or "Include" to process *only* what matches.
2.  **Extend Beam Section**: Define the extension parameters.
    *   Select the **Beam Type** (e.g., Stud, Plate) if "Use props for filtering" is set to Yes.
    *   Set **Extend with** to the desired length in millimeters (e.g., `20` mm).

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Element(s) (Wall, Roof, etc.) containing the beams you wish to modify. Press Enter to confirm.
```

### Step 4: Execution
The script will automatically process the selected elements, apply the extensions to the matching beams, and then remove itself from the drawing.

## Properties Panel Parameters

### Filter Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beams with beamcode | Text | "" | Enter a beam code pattern (e.g., `ST*` for studs). Use semicolons `;` for multiple codes. |
| Filter beams and sheets with label | Text | "" | Enter a label pattern to target specific layers. |
| Filter beams and sheets with material | Text | "" | Enter a material code pattern (e.g., `C24`). |
| Filter operation | Dropdown | Exclude | **Exclude**: Processes all beams *except* those matching the filters above. **Include**: Processes *only* beams matching the filters. |

### Extend Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam type | Dropdown | *System Default* | The structural classification of beam to target (e.g., Stud, Rim beam). Only active if "Use props for filtering" is Yes. |
| Use props for filtering | Dropdown | Yes | **Yes**: Uses the "Beam type" setting. **No**: Ignores "Beam type" and relies only on Code/Label/Material filters. |
| Extend with | Number | 2 | The length in millimeters to add to **both ends** of the beam. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent right-click menu items to entities. |

## Settings Files
None required. This script operates entirely on input properties and selected geometry.

## Tips
- **Wildcards**: You can use `*` in the filter fields (e.g., `SCL*` to match all scl beams).
- **Double Extension**: The "Extend with" value applies to both the Start and End points of the beam. If you enter `20`, the total beam length increases by `40`.
- **Undo**: You can use the standard AutoCAD `UNDO` command (Ctrl+Z) immediately after running the script if the result is not as expected.
- **Exclude vs Include**: If you want to extend "Everything except plates", it is often easier to set the Filter Operation to "Exclude" and enter the Plate beam code in the filter.

## FAQ
- **Q: Why did nothing happen?**
  - A: Check your filters. If "Filter operation" is set to "Include" and your text fields are empty, or if your text filters do not match any beams, no changes will be made. Also ensure "Use props for filtering" is set correctly if you are relying on Beam Type.
  
- **Q: Can I extend beams by different amounts at the start and end?**
  - A: No, this script adds the same length (`dExtendWith`) to both ends of the beam.
  
- **Q: Does this script work on individual beams or elements?**
  - A: You must select the parent **Element** (e.g., the wall). The script will then find and modify the beams inside that element.