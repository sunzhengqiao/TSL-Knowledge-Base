# hsb_EraseShortBeams

## Overview
Identifies and processes beams within selected elements that are shorter than a specified length threshold. It allows you to either delete these small offcuts (waste) or highlight them by changing their color for manual verification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D model elements. |
| Paper Space | No | Not designed for layout or drawing views. |
| Shop Drawing | No | Not intended for generating manufacturing drawings. |

## Prerequisites
- **Required Entities**: Elements (e.g., walls, roofs) containing Beams must exist in the model.
- **Minimum Beam Count**: None required (script processes all beams found in selected elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse and select `hsb_EraseShortBeams.mcr`.

### Step 2: Configure Settings
Upon launching, a properties dialog will appear automatically. Set your desired criteria:
- **Action**: Choose whether to delete the beams or just change their color.
- **Minimum beam length**: Enter the cutoff length (in mm). Any beam shorter than this will be affected.
- **Color**: If "Change Color" is selected, pick the color index to use (e.g., 1 for Red).
*Click OK to proceed.*

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the desired Elements (Walls, Roofs, etc.) in the model view. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically scan the selected elements. It will either delete the short beams or change their color based on your settings. The script instance will then remove itself from the drawing automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Action | dropdown | Delete | Determines what happens to short beams. Choose "Delete" to remove them, or "Change Color" to flag them visually. |
| Minimum beam length | number | 50.0 | The length threshold (in mm). Beams with a solid length shorter than this value are targeted. |
| Color | number | 1 | The AutoCAD color index applied to short beams when the Action is set to "Change Color". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Verify Before Deleting**: If you are unsure which beams will be affected, set the **Action** to "Change Color" (e.g., Red) first. Run the script to visually identify the offcuts, then undo and run again with "Delete" if the results are correct.
- **Undo Function**: You can use the standard AutoCAD `UNDO` command immediately after running the script to restore beams if you accidentally delete too much.
- **Unit System**: The script calculates length based on the internal model units (typically mm). Ensure your `dMinLength` value is appropriate for your project scale.

## FAQ
- **Q: Can I select individual beams instead of whole Elements?**
- A: No, this script requires you to select the parent Element (like a wall). It will then check every beam inside that element.
- **Q: What happens if I select an element with no short beams?**
- A: The script will simply process the element, find no beams matching the criteria, and finish without making changes.
- **Q: Why did the script disappear from my drawing after running?**
- A: This is intended behavior. The script instance automatically erases itself once it has finished processing the selected elements to keep your drawing clean.