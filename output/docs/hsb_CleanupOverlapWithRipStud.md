# hsb_CleanupOverlapWithRipStud.mcr

## Overview
This script automatically cleans up King Studs within Wall Elements by trimming overlaps and removing studs that protrude outside the wall profile. It is particularly useful for correcting framing when wall openings are positioned close to the wall ends.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where wall elements are located. |
| Paper Space | No | Not supported for layouts or viewports. |
| Shop Drawing | No | This script works on 3D model elements, not 2D drawings. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) containing King Studs.
- **Minimum beam count**: 0 (The script scans entire elements, not specific collections of beams).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsb_CleanupOverlapWithRipStud.mcr`

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements in the drawing that need cleanup. Press Enter when selection is complete.
```

### Step 3: Automatic Processing
Once the elements are selected, the script will automatically:
1. Identify King Studs (Modules) within the walls.
2. Check if King Studs intersect with standard wall members (Valids).
3. Trim or shift standard members to resolve overlaps.
4. Check if King Studs protrude beyond the wall ends.
5. **Remove** King Studs that are completely outside the wall.
6. **Rip/Trim** King Studs that are partially outside, shortening them and centering them within the wall boundary.

*Note: The script instance will automatically erase itself from the drawing after processing is finished.*

## Properties Panel Parameters
This script does not expose any editable parameters in the Properties Palette.

## Right-Click Menu Options
This script does not add specific options to the entity right-click menu.

## Settings Files
No external settings files are used by this script.

## Tips
- **Run after Wall Generation:** Use this script immediately after generating walls with openings to ensure framing is clean before detailing.
- **King Stud Specifics:** The script specifically targets King Studs. It does not trim or remove cripple studs.
- **Re-running:** Since the script deletes itself after running, simply run the command again if you modify wall geometry and need to re-apply the cleanup.
- **Visual Check:** After running, visually inspect wall ends near openings to ensure the King Studs have been trimmed correctly to the wall boundary.

## FAQ
- **Q: Can I use this on roof beams or floors?**
  - A: No, this script is designed specifically for Wall Elements (`ElementWallSF`).

- **Q: Why did the script disappear after I used it?**
  - A: This is normal behavior. The script is designed to run once, modify the geometry, and then delete itself to keep the drawing clean.

- **Q: Will this delete cripple studs?**
  - A: No, the logic specifically excludes cripples. It only acts on King Studs that overlap or protrude.

- **Q: What happens if a King Stud overlaps a regular stud?**
  - A: The regular stud will be moved (transformed) and shortened to resolve the conflict with the King Stud.