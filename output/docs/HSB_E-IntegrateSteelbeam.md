# HSB_E-IntegrateSteelbeam.mcr

## Overview
This script automatically generates pockets and cuts in timber elements (walls, floors) to accommodate intersecting steel beams. It handles the modification of internal timber studs, plates, and sheeting layers while allowing for specific clearance gaps and filtering of which beams are cut.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements only. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Machining logic is applied in the model. |

## Prerequisites
- **Required Entities**: 
  - At least one Steel Beam.
  - At least one Timber Element (e.g., Wall or Floor).
- **Minimum Beam Count**: 1 Steel Beam and 1 Timber Element.
- **Required Settings**: None required for basic operation, but Properties Panel parameters may need adjustment for specific tolerances.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `HSB_E-IntegrateSteelbeam.mcr` from the script directory.

### Step 2: Select Steel Beams
```
Command Line: Select a set of steelbeams
Action: Click on the steel beam(s) that pass through the timber structure. Press Enter to confirm selection.
```
*Note: The script filters out steel beams that are already part of another element or have a rectangular profile.*

### Step 3: Select Timber Elements
```
Command Line: Select a set of elements
Action: Click on the timber element(s) (walls/floors) that intersect or touch the steel beams. Press Enter to confirm.
```
*Note: The script will automatically spawn instances on these elements to handle the integration.*

### Step 4: Adjust Parameters (Optional)
**Action:** Select the newly created script instance (often found by selecting the element and looking for the script entity or via Quick Select). Open the **Properties Palette (Ctrl+1)** to adjust gaps or filters if the default cuts are not sufficient.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **\|Filter type\|** | Dropdown | \|Include\| | Determines how the Beam Code filter works. <br>**Include**: Only cuts beams matching the code.<br>**Exclude**: Cuts all beams EXCEPT those matching the code. |
| **Filter beams with beamcode** | Text | (Empty) | Enter beam codes to filter (e.g., `STUD;BLOCK`). Use semicolons for multiple codes. |
| **Gap** | Number | 5 mm | Horizontal clearance added on each side of the steel beam. Ensures easy fit or accounts for manufacturing tolerances. |
| **Gap under steel beam** | Number | 0 mm | Vertical clearance added below the bottom flange of the steel beam. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Protect Specific Beams:** If you want to cut studs but *not* the top or bottom plates, set **Filter type** to `|Exclude|` and enter the beam code for your plates in the filter field.
- **Tolerances:** If the timber is tight against the steel, increase the **Gap** property slightly (e.g., to 10mm) to ensure the assembly fits without forcing.
- **Dynamic Updates:** If you move the steel beam or change the element dimensions, the cuts will automatically recalculate and update to the new position.

## FAQ
- **Q: Why didn't my steel beam get selected?**
  **A:** The script ignores steel beams that are "Grouped" inside another Element or have a rectangular profile. Ensure your steel beam is a standalone free beam with a profile (like IPE or HEA).
  
- **Q: How do I add space for insulation or plasterboard below the steel beam?**
  **A:** Increase the **Gap under steel beam** property. This lowers the cut in the timber below the steel member.

- **Q: The cut is not appearing in the 3D model.**
  **A:** Ensure the steel beam actually physically intersects the timber element's volume. If the steel beam is just touching the edge or is completely outside, the script will report an "Invalid connection" warning and skip the cut.