# hsb_RemoveNoNailCodeFromBeams.mcr

## Overview
This script automatically sets the "Nailing Code" (Beam Code position 9) to "YES" for all vertical studs within selected wall elements. It is used to ensure specific vertical members are marked for nailing hardware or sheathing attachment schedules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where wall elements exist. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script works on 3D model elements, not 2D drawings. |

## Prerequisites
- **Required entities**: Wall Elements (`ElementWallSF`) containing vertical beams/studs.
- **Minimum beam count**: 0 (The script processes any vertical beams found within the selected elements).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RemoveNoNailCodeFromBeams.mcr`

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the desired Wall Elements in the drawing and press Enter to confirm.
```
*Note: The script will automatically process all vertical beams within the selected elements and then delete itself.*

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not use persistent properties. It executes immediately upon insertion and does not remain in the drawing. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Cleanup**: The script instance is designed to erase itself immediately after processing. Do not be alarmed if it disappears from the drawing; this is normal behavior.
- **Vertical Only**: This tool specifically targets beams that are perpendicular to the wall's local X-axis (typically vertical studs). Horizontal plates or other members within the wall will not be modified.
- **Verification**: After running the script, you can verify the changes by selecting a stud and checking the Beam Code property in the Properties Palette (ensure the 9th segment/token is set to "YES").

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  **A:** This is a "command" script designed for one-time use. It automatically removes itself from the drawing after completing its task to keep your project clean.
  
- **Q: Does this work on single beams or only walls?**
  **A:** The prompt asks you to select Elements (`ElementWallSF`). You must select the main wall assembly, not individual beams, for the script to function correctly.

- **Q: Will this overwrite my existing beam codes?**
  **A:** It will specifically overwrite the Nailing Code position (Position 9) to "YES". Other parts of the beam code (Material, Grade, etc.) are preserved or filled in if empty.