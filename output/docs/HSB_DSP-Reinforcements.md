# HSB_DSP-Reinforcements.mcr

## Overview
This script automatically duplicates and mirrors reinforcement beams (hsbId 4110) across a detail line to the opposite side of a roof or floor element during construction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely within the 3D model. |
| Paper Space | No | Not applicable for layouts or shop drawings. |
| Shop Drawing | No | Does not process 2D shop drawings. |

## Prerequisites
- **Required Entities**: An Element (Roof or Floor) containing a valid DSP (Detail) definition with geometry points.
- **Required Beams**: The Element must contain beams assigned the catalog number (hsbId) **4110** (Reinforcement).
- **Setup**: The script must be assigned to a DSP Detail in the hsbCAD Catalog; it cannot be inserted manually via the command line.

## Usage Steps

### Step 1: Assign Script to Detail
This script is event-driven and cannot be run manually.
1.  Open the hsbCAD **Catalog**.
2.  Navigate to the **Details** or **DSP** section.
3.  Select the Detail entry associated with your reinforcement construction.
4.  Attach `HSB_DSP-Reinforcements.mcr` to the detail properties.

### Step 2: Apply Detail to Element
1.  In the drawing, select a **Roof** or **Floor** element.
2.  Open the **Properties** palette.
3.  Assign the Detail (configured in Step 1) to the element.

### Step 3: Construct or Update Element
1.  Construct the element or trigger a recalculation (e.g., by changing a dimension or using the refresh command).
2.  The script runs automatically, detects the reinforcement beams, and creates mirrored copies on the opposite side of the detail split line.

### System Notices (Errors)
If the script encounters an issue, it will display one of the following notices on the screen:
- **"This tsl must be attached to a DSP detail."**: Shown if you try to insert the script manually.
- **"No element selected."**: Shown if the script cannot find a parent element.
- **"The selected element is not a roof or a floor element."**: Shown if attached to a Wall or other element type.
- **"Invalid detail line, the split direction could not be determined."**: Shown if the detail geometry points are missing or invalid.

## Properties Panel Parameters
This script has no editable parameters in the Properties panel. It runs automatically based on geometry.

## Right-Click Menu Options
No custom context menu options are available for this script.

## Settings Files
No external settings files (XML) are used by this script.

## Tips
- **Beam Identification**: Only beams with the specific catalog ID **4110** will be mirrored. Standard joists or rafters will be ignored.
- **Script Life Cycle**: This script instance erases itself immediately after execution. You cannot select it later to edit it; changes must be made in the Catalog or by re-applying the Detail.
- **Geometry**: Ensure the element has valid geometry points defining the split line; otherwise, the script will fail to calculate the mirror position.

## FAQ
- **Q: Can I insert this script using the `TSLINSERT` command?**
  **A:** No. Attempting to do so will result in an error message stating it must be attached to a DSP detail.

- **Q: Why are my reinforcement beams not appearing on the other side?**
  **A:** Verify that the beams you want to duplicate are assigned the hsbId **4110** in the catalog. Also, ensure the element is defined as a Roof or Floor.

- **Q: How do I adjust the distance the beams are moved?**
  **A:** The script calculates the offset based on the element's beam height plus the reinforcement's own depth. This logic is hard-coded; to change it, the script code must be modified by a developer.