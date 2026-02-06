# hsb_ManageLooseGroupEntities.mcr

## Overview
This script attaches to selected construction elements (like walls or floors) to manage "loose" sub-entities (such as gable studs). It ensures that these associated parts are automatically deleted or cleaned up when the parent element is modified or removed.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements in the model. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | Not intended for manufacturing outputs. |

## Prerequisites
- **Required Entities**: At least one Element (e.g., Wall or Floor) must exist in the model.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ManageLooseGroupEntities.mcr` from the file browser.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the elements (Walls/Floors) that contain or will contain loose entities you wish to manage. Press Enter when selection is complete.
```

### Step 3: Completion
After selection, the script automatically attaches an instance of itself to the chosen elements. The initial script instance disappears, and the management logic runs in the background on those elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | - | - | This script does not expose user-editable parameters in the Properties Panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Cleanup**: This script is particularly useful for secondary framing members (like gable studs) that are generated separately but should logically disappear if the main wall is deleted.
- **Grouping**: The script logically organizes entities by looking for a "Loose" subgroup within the element's group structure.
- **Copying**: If you copy an element that has this script attached, the script will automatically detect the copy and ensure duplicate management instances are removed, keeping the model clean.

## FAQ
- **Q: How do I know if the script is working?**
  - A: The script runs automatically in the background. You will notice its effect when you delete a managed element; any linked loose parts in the "Loose" subgroup will be deleted along with it.
- **Q: Can I use this on beams?**
  - A: No, this script is designed specifically for Elements (Walls/Floors).
- **Q: What happens if I modify the element geometry?**
  - A: The script triggers on modification events to ensure the loose entities are still valid, performing a cleanup check to maintain model integrity.
- **Q: I inserted the script but nothing happened.**
  - A: The script is designed to attach itself to elements and then erase the "master" instance. If you successfully selected elements, the script is now active on those elements. If no elements were selected, the script erased itself to prevent errors.