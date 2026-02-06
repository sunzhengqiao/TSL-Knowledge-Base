# hsb_SetWallConstructionDirectives.mcr

## Overview
This utility script modifies the vertical positioning (Base Height) of multiple selected wall elements simultaneously within the 3D model. It is typically used to adjust the elevation of walls to a specific floor level or foundation plate after the initial structural layout is generated.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Not intended for manufacturing output generation. |

## Prerequisites
- **Required entities**: Existing Wall elements (`ElementWall`) in the model.
- **Minimum beam count**: 1 (at least one wall must be selected).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or assign to a toolbar button) → Select `hsb_SetWallConstructionDirectives.mcr`

### Step 2: Configure Base Height
```
Command Line: (Property Palette or Dialog appears)
Action: Before selecting elements, locate the "Base Height" property in the Properties Palette (or dialog). Enter the desired elevation value (Z-coordinate) for the bottom of the walls.
```

### Step 3: Select Wall Elements
```
Command Line: Please select Elements
Action: Click on the wall elements you wish to modify. You can select multiple walls at once.
```

### Step 4: Confirm Selection
```
Command Line: (Press Enter to confirm)
Action: Press Enter or Right-click to confirm your selection. The script will update the base height of the selected walls and then close automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Base Height | number | 0 | The absolute Z-coordinate (elevation) for the bottom surface of the selected walls. This determines the vertical starting point of the wall structure. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script executes as a one-time command and erases itself immediately after use. It does not remain in the model for right-click context menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Processing**: You can select as many walls as needed in a single operation to align them all to the same elevation level.
- **Unit Awareness**: Ensure your `Base Height` value is entered in the current project units (typically millimeters).
- **Shift vs. Resize**: This tool moves the entire wall assembly up or down. It does not change the physical height of the wall (e.g., a 3000mm wall moved 100mm up is still 3000mm tall, just starting higher).
- **Integration**: This script can also be triggered from wall details during generation to automate height settings based on specific wall types.

## FAQ
- **Q: I ran the script but nothing happened.**
  A: Make sure you actually selected Wall entities before pressing Enter. If you select nothing, the script exits silently.
- **Q: Can I use this to raise the roof?**
  A: No, this script only affects Wall elements (`ElementWall`). It will ignore beams or other roof components.
- **Q: Does this work on walls in a group?**
  A: Yes, you can select grouped walls; the script will attempt to apply the new base height to any valid wall entities found in your selection.