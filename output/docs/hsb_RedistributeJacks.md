# hsb_RedistributeJacks.mcr

## Overview
This script automatically recalculates and redistributes jack studs around wall openings (windows and doors) based on a specified spacing and alignment pattern. It removes existing jack studs and blocking within the affected area and regenerates them to match the new configuration.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements containing Openings. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation/editing script. |

## Prerequisites
- **Required entities**: Wall Elements (`ElementWallSF`) with existing Openings (windows/doors) and existing Jack Studs.
- **Minimum beam count**: The element must contain at least one existing Jack Stud (Top or Bottom) to copy properties from; otherwise, the opening is skipped.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RedistributeJacks.mcr`

### Step 2: Configure Properties (Optional)
Upon insertion, the Properties Palette will display.
- **Action**: Adjust the "Select Distribution" and "Spacing" parameters as needed.
- **Action**: Close the Properties Palette to proceed.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Elements (walls with openings) you wish to update. Press Enter to confirm selection.
```

### Step 4: Execution
- The script will automatically process the selected elements, delete the old jacks/blocking, and insert the new jack layout based on your settings. The script instance will then erase itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Select Distribution | dropdown | From Left | Determines the alignment of the jack studs relative to the opening. Options: <br> - **From Left**: Aligns the first jack to the left edge.<br> - **Even**: Centers the jacks around the opening.<br> - **From Right**: Aligns the first jack to the right edge. |
| Spacing | number | 0 | The center-to-center distance between jack studs in millimeters. If set to **0**, the script uses the default spacing defined in the Wall Element properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Existing Jacks Required**: The script copies width, height, material, and module information from existing jacks. Ensure there is at least one jack stud under or over the opening before running the script.
- **Default Spacing**: Leave the "Spacing" property as `0` to automatically match the new jacks to the wall's standard stud spacing.
- **Blocking Removal**: The script automatically removes blocking beams located between the jacks in the processing zone.
- **Extra Jacks**: If your opening settings (in hsbCAD) specify "Extra Jacks" (e.g., side trimmers), the script accounts for these by placing custom-sized beams at the inner edges and distributing standard jacks between them.

## FAQ
- **Q: Why did the script skip my opening?**
  **A**: The script requires existing Top or Bottom Jacks to determine the size and material of the new studs. If the opening has no jacks currently, the script will skip it.
  
- **Q: Can I use this to fix spacing in curved walls?**
  **A**: Yes, as long as the entity is a valid Wall Element (`ElementWallSF`) with an identifiable Coordinate System, the script will calculate positions correctly.

- **Q: What happens if my specified spacing is too large for the opening?**
  **A**: The script will calculate the maximum number of studs that fit based on the spacing. It may generate fewer studs than expected or just the edge jacks depending on the distribution logic selected.