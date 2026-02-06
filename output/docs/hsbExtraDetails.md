# hsbExtraDetails.mcr

## Overview
Batch assigns construction layer details (such as sheathing, cladding, or insulation) to specific sides of multiple selected wall elements simultaneously.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D wall elements. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model modification tool, not a drawing generator. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (hsbCAD Wall Elements)
- **Minimum Beams**: 1 (Recommended to select multiple for batch processing)
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbExtraDetails.mcr`

### Step 2: Configure Details
```
Interface: Dynamic Dialog
Action: A dialog window appears upon insertion. Enter the names of the construction details you wish to apply (e.g., "OSB_18mm", "Plasterboard") into the relevant fields (Left, Right, Top, Bottom, etc.).
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click to select the desired wall elements in the model. Press Enter to confirm the selection.
```

*(Note: After processing, the script instance will automatically erase itself from the drawing.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Level | number | 0 | Specifies the index of the construction layer (0-10) to which the details should be applied within the wall's build-up. |
| Detail Left | text | "" | The name of the construction detail to apply to the left side of the wall. |
| Detail Right | text | "" | The name of the construction detail to apply to the right side of the wall. |
| Detail Top | text | "" | The name of the construction detail to apply to the top side of the wall. |
| Detail Bottom | text | "" | The name of the construction detail to apply to the bottom side of the wall. |
| Detail Left Top | text | "" | The name of the construction detail to apply to the top-left corner area. |
| Detail Right Top | text | "" | The name of the construction detail to apply to the top-right corner area. |
| Overwrite existing details | dropdown | No | If set to "Yes", empty input fields will remove existing details from the element sides. If "No", existing details are preserved. |
| Add Elementcode to Detailname | dropdown | No | If set to "Yes", the Element Code of the wall is automatically prefixed to the detail name (e.g., "W1_OSB"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific right-click context menu items. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; it uses OPM properties for configuration.

## Tips
- **Batch Processing**: This script is designed to handle multiple elements at once. Use a window selection to update all external walls in a floor quickly.
- **Preserving Details**: By default, the "Overwrite existing details" option is set to "No". This means if you only fill in the "Detail Left" field, the script will only update the left side and leave the Right, Top, and Bottom details untouched.
- **Removing Details**: To strip a detail (e.g., remove sheathing) from a side, set "Overwrite existing details" to "Yes" and leave the specific side's field empty.
- **Self-Destructing**: Do not be alarmed if the script instance disappears from the drawing after running; this is intentional behavior.

## FAQ
- **Q: Can I use this on individual beams?**
  - A: No, this script is specifically designed for `ElementWallSF` entities and will not work on standard beams or columns.
- **Q: What happens if I enter a detail name that doesn't exist?**
  - A: The script will attempt to assign the name provided. If the construction detail does not exist in your hsbCAD catalog, the wall element may not generate the expected geometry or may show an error.
- **Q: Why did my existing details disappear?**
  - A: You likely had "Overwrite existing details" set to "Yes". When this is active, any empty field in the dialog acts as a command to clear that detail on the element. Change it to "No" to preserve existing details.