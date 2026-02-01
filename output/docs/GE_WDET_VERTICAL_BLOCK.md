# GE_WDET_VERTICAL_BLOCK.mcr

## Overview
This script automatically generates vertical blocking (nogs) within wall frames, typically at structural connection points like T-junctions. It is designed to run exclusively via Construction Directives in the Defaults Editor to automate wall detailing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D Beam entities within the wall element. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | Not applicable for shop drawing layouts. |

## Prerequisites
- **Required Entities**: A valid Wall Element (`ElementWallSF`).
- **Minimum Beam Count**: 0 (Script operates on the wall element as a whole).
- **Required Settings**: 
    - `hsbFramingDefaults.Inventory.dll` (located in `hsbInstall\Utilities\hsbFramingDefaultsEditor`).
    - A Construction Directive configured in the Defaults Editor.

## Usage Steps

### Step 1: Configure via Defaults Editor (Primary Method)
```
Action: 
1. Open the hsbCAD Defaults Editor.
2. Select the desired Wall Element or Material Class.
3. Add or Edit a Construction Directive.
4. Select 'GE_WDET_VERTICAL_BLOCK.mcr' from the script list.
5. Adjust parameters (e.g., Lumber Item, Distribution, Spacing) in the Properties Panel.
6. Click OK to save the Defaults.
```

### Step 2: Generate or Recalculate the Wall
```
Action: 
1. Draw a new Wall Element using the configured Defaults, OR
2. Select an existing Wall Element and right-click -> 'Recalculate'.
Result: The script inserts vertical blocking based on the configuration and removes any obstructing parts of existing studs.
```

### Step 3: Manual Insertion (Blocked)
```
Command Line: TSLINSERT -> Select GE_WDET_VERTICAL_BLOCK.mcr
Result: A warning message appears stating: "This script cannot be manually inserted... It must be defined on the Defaults Editor."
Action: The script will immediately cancel and erase itself. You must use Step 1 to use this tool.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Lumber Item** | Dropdown | (First Inventory Item) | Selects the timber size from your inventory. Choose `|Manual size|` to enter dimensions manually. |
| **Distribution** | Int | 0 (Bottom of wall) | Sets the layout pattern: 0=Bottom-up, 1=Top-down, 2=Middle-out, 3=Evenly spaced with end blocks. |
| **Edge/Flat** | Int | 0 (Edge) | Orientation of the blocking: 0=Standing on narrow edge, 1=Laying flat on wide face. |
| **Spacing** | Double | U(800, 32) | Maximum distance allowed between blocks. |
| **Block Length** | Double | U(300, 12) | Vertical length of each individual blocking piece. |
| **Start Offset** | Double | 0 | Gap from the bottom of the wall before the first block starts. |
| **End Offset** | Double | 0 | Gap from the top of the wall after the last block ends. |
| **Block Width** | Double | U(35, 1.5) | Manual width (thickness) of the timber (Only active if 'Lumber Item' is set to Manual). |
| **Block Height** | Double | U(42, 3.5) | Manual height (depth) of the timber (Only active if 'Lumber Item' is set to Manual). |
| **Material** | String | (From Inventory) | Timber material designation (e.g., "C24"). Overrides Inventory if entered. |
| **Grade** | String | (From Inventory) | Structural grade of the timber. Overrides Inventory if entered. |
| **Name** | String | Empty | User-defined name for the blocking part (e.g., "VertBlock_T1"). |
| **Color** | Int | 2 | AutoCAD color index for the blocking elements. |
| **Information** | String | Empty | Additional metadata or comments for the part. |
| **Label** | String | Empty | Label text for shop drawings or CAM output. |

## Right-Click Menu Options
> **Note**: This script executes via the Defaults Editor and automatically erases its own instance (`_ThisInst`) after generating the blocking beams. Therefore, specific TSL right-click menu options (like "Show Dynamic Dialog") are not available on the final wall elements. To modify settings, update the Construction Directive in the Defaults Editor and Recalculate the wall.

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `hsbInstall\Utilities\hsbFramingDefaultsEditor`
- **Purpose**: Provides the database of available timber sizes (Width, Height, Material, Grade) used by the "Lumber Item" dropdown parameter.

## Tips
- **Clash Resolution**: This script automatically detects collisions with existing studs. It will erase the volume of the stud that intersects with the blocking to ensure a clean fit.
- **Full Coverage**: Use Distribution mode `3 (Evenly spaced with end blocks)` to ensure blocks are placed at both the very bottom and very top of the wall height, filling the gap evenly in between.
- **Orientation**: Changing "Edge/Flat" affects how the block sits relative to the wall face. "Flat" (1) creates a wider face against the wall sheathing, while "Edge" (0) provides more depth for nailing.

## FAQ
- **Q: Why do I get an error when trying to run this script?**
- **A**: This script is designed for automated wall generation only. If you try to insert it manually via `TSLINSERT`, it will warn you that it must be configured in the Defaults Editor.
- **Q: How do I change the size of the blocks?**
- **A**: You do not select the block and change properties. Instead, go to the Defaults Editor, find the Construction Directive using this script, change the "Lumber Item" or manual "Block Width/Height", and Recalculate the wall.
- **Q: Can I control exactly where the blocks go?**
- **A**: You can control the pattern (Bottom, Top, Middle, Even) and the spacing/offsets. For specific placement, use the "Start Offset" and "End Offset" to exclude areas (like for windows or doors).