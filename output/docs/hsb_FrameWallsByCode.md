# hsb_FrameWallsByCode.mcr

## Overview
Automatically filters selected wall elements based on their 'Code' property and initiates the construction generation process for only those matching walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not intended for manufacturing details. |

## Prerequisites
- **Required entities**: `Element` (Wall entities specifically).
- **Minimum beam count**: N/A (Selects Elements, not beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsb_FrameWallsByCode.mcr`

### Step 2: Configure Properties
**Action**: Before selecting elements, you may adjust the filter criteria in the Properties Palette (Ctrl+1) if necessary. By default, the script looks for the code "M;".

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements (ElementWallSF) you wish to process and press Enter.
```

**Result**: The script filters the selected walls based on the codes defined in the properties. Only walls with matching codes will have their construction generated. The script instance will then delete itself automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Code wall to generate | Text | M; | A list of wall classification codes used to filter elements. Separate multiple codes with a semicolon (e.g., `EXT;INT;FIRE;`). Only walls with a matching 'Code' property will be processed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Semicolons Matter**: When entering multiple codes in the "Code wall to generate" property, ensure you end with a semicolon or separate codes strictly with semicolons (e.g., `A;B;C`).
- **Verify Wall Codes**: Ensure your wall elements actually have the 'Code' property assigned in hsbCAD before running this script; otherwise, the filter will find no matches.
- **Script Deletion**: This script is designed to run once and remove itself from the drawing. Do not try to edit it after insertion; simply run the command again if you need to generate more walls.

## FAQ
- **Q: I selected walls, but nothing happened. Why?**
  A: Check the "Code wall to generate" property. It likely does not match the 'Code' property assigned to your specific walls. Also, ensure you selected `Element` entities, not raw beams or lines.
- **Q: Can I use this to generate floors or roofs?**
  A: No, this script is specifically designed to filter and process Wall elements (`ElementWallSF`).
- **Q: Do I need to run the "Generate Construction" command manually after this?**
  A: No, this script automatically pushes the "Generate Construction" command for the filtered walls.