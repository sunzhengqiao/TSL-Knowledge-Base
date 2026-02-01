# GE_HDWR_WALL_ANCHOR_WAH.mcr

## Overview
This script inserts a Wall Anchor Hanger (WAH) onto timber studs to secure the wall structure to a foundation or floor. It automatically generates a vertical strap plate, lateral support flanges, and a drilled anchor plate with an associated anchor rod (e.g., J-Bolt).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D modeling of connections. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required entities**: Timber Beams (Studs).
- **Minimum beam count**: 1.
- **Required settings files**:
    - `TSL_HARDWARE_FAMILY_LIST.dxx`: Located in the company TSL Catalog folder.
    - `GE_HDWR_ANCHOR_J-BOLT.mcr` (or similar): Required for the anchor rod sub-component.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `GE_HDWR_WALL_ANCHOR_WAH.mcr`.

### Step 2: Select Studs
```
Command Line: Select stud(s)
Action: Click on the timber beam(s) where you want to install the anchor.
```

### Step 3: Select Reference Point
```
Command Line: Select reference point: hangers will be inserted at closest end and closer face of members
Action: Click near the top or bottom end of the selected stud. The script will automatically snap the anchor to the nearest end.
```

### Step 4: Select Hardware Type
Action: A DotNet dialog will appear. Select the specific Wall Anchor model (e.g., WAH16) from the list. This sets the default dimensions for the connection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | text | WAH16 | The specific model number or SKU of the wall anchor hardware. |
| Clear width | number | 70 | The horizontal width of the metal bracket (parallel to the wall face). |
| Overall depth | number | 560 | The vertical height of the main strap plate (parallel to the stud). |
| Overall height | number | 50 | The projection depth of the anchor plate (distance the hardware extends out from the wall face). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens the hardware catalog dialog to select a different model, which resets dimensions to the new catalog defaults. |
| Help | Displays a report with usage instructions and information. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `_kPathHsbCompany\TSL\Catalog\`
- **Purpose**: Contains the database of hardware families (WAH) that define available sizes, dimensions, and anchor types.

## Tips
- The script is smart enough to detect the closest end of the stud based on where you click. You do not need to zoom in perfectly to the endpoint; just click near the desired end (top or bottom).
- If you modify the width or depth manually but want to revert to the manufacturer's standard dimensions, simply right-click and select "Change type," then re-select the same model.
- This script creates a sub-component for the actual anchor rod (like a J-Bolt). Make sure the associated anchor script (e.g., `GE_HDWR_ANCHOR_J-BOLT.mcr`) is accessible in your search path.

## FAQ
- **Q: Can I use this script for multiple studs at once?**
  A: Yes, you can select multiple studs during the insertion prompt, and the anchor will be applied to all of them based on the reference point location relative to each stud.
- **Q: What happens if I change the "Type" property?**
  A: Changing the type updates the hardware configuration and resets the geometric parameters (Width, Depth, Height) to match the new catalog entry.
- **Q: How do I fix the issue where the metal part overlaps the beam incorrectly?**
  A: Ensure you are using version 1.5 or higher of the script, as this bug was fixed in that release.