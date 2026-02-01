# hsb_EraseNoTagBeams.mcr

## Overview
This script provides a safe way to batch delete beams from the model. It erases all selected beams except for those specifically marked with a 'NoErase' protection attribute, ensuring critical structural elements are not accidentally removed.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D beams in the model. |
| Paper Space | No | Not designed for layout views or 2D detailing. |
| Shop Drawing | No | Not designed for manufacturing views. |

## Prerequisites
- **Required entities**: GenBeams (Beams)
- **Minimum beam count**: 1 or more
- **Required settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_EraseNoTagBeams.mcr`

### Step 2: Select Beams
```
Command Line: Select beams
Action: Click on the beams you wish to delete. Press Enter to confirm the selection.
```

### Step 3: Processing
Once the selection is confirmed, the script automatically checks every selected beam.
- Beams **without** protection are deleted.
- Beams **with** the 'NoErase' attribute are kept.
- The script instance removes itself automatically from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | N/A | N/A | This script does not use editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No external settings files are used by this script.

## Tips
- **Protection**: This script looks for a "NoErase" string inside the beam's attributes (subMapXKeys). If you find a beam is refusing to delete, check its attributes to see if it has been protected by another process.
- **Self-Cleaning**: The script instance deletes itself automatically after running. You do not need to manually remove the script icon from the model.
- **Undo**: If you accidentally delete the wrong beams, use the standard AutoCAD `UNDO` command immediately to restore them.

## FAQ
- **Q: Why did some of the beams I selected not get deleted?**
  **A:** Those beams likely contain a 'NoErase' attribute. This attribute acts as a lock to prevent specific structural elements from being batch-erased.
- **Q: Do I need to remove the script instance from the drawing after I use it?**
  **A:** No. The script is programmed to delete itself immediately after it finishes processing the beams.
- **Q: Can I use this to delete other elements like walls or slabs?**
  **A:** No. This script is specifically designed to process GenBeam entities only.