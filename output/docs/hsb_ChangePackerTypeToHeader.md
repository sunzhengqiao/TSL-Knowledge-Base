# hsb_ChangePackerTypeToHeader.mcr

## Overview
This script automatically converts Top Plate beams into Header beams within Shear Walls wherever they intersect with Packer beams. It is used to ensure that top plates situated above packers (typically over openings or specific structural junctions) are correctly classified as Headers to meet structural requirements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model where Shear Wall elements are located. |
| Paper Space | No | Not designed for use in layout views. |
| Shop Drawing | No | Does not generate drawings or details. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Shear Wall elements) that contain generated beams.
- **Minimum Beam Count**: The selected wall must contain at least one Top Plate beam and one Packer beam.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ChangePackerTypeToHeader.mcr` from the file dialog, or use the assigned macro button/icon.

### Step 2: Select Shear Walls
```
Command Line: Select a set of elements
Action: Click on one or more Shear Wall elements in the model and press Enter.
```
The script will automatically process the selected walls, check for intersections between Top Plates and Packers, and convert the beam types. The script instance will remove itself from the project automatically after completion.

## Properties Panel Parameters
This script has no configurable properties in the Properties Palette (OPM). It runs based on the geometry of the selected elements.

## Right-Click Menu Options
This script does not add specific options to the right-click context menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Batch Processing**: You can select multiple Shear Walls at once during the prompt; the script will iterate through all of them.
- **Automatic Cleanup**: The script creates temporary instances to process the walls and deletes them automatically. You do not need to manually remove the script from the element after it runs.
- **Visual Verification**: After running, use the `List` command or select the beams to verify that the beam type has changed to "Header" in the properties.

## FAQ
- **Q: Why didn't the script change my top plate to a header?**
  **A:** Ensure that the Top Plate beam physically intersects with a Packer beam that is aligned to the wall's X-axis. If there is no geometric intersection, the type will not change.
  
- **Q: Can I use this on standard walls (not Shear Walls)?**
  **A:** No, this script is designed specifically for `ElementWallSF` entities.

- **Q: Do I need to regenerate the wall for the changes to take effect?**
  **A:** No, the script modifies the existing beam entities directly. No regeneration is required.