# NA_WallSheathing.mcr

## Overview
Generates and applies structural sheathing panels (such as OSB or Plywood) to wood-framed walls. It optimizes the layout to minimize waste, calculates cut sizes, and automatically defines edge blocking or stud requirements at seams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements. |
| Paper Space | No | Does not function in 2D drawing layouts. |
| Shop Drawing | No | Not intended for creating view labels or dimensions. |

## Prerequisites
- **Required Entities**: hsbCAD Wall Elements (Stickframe type).
- **Minimum Beams**: None (Script selects Wall Elements).
- **Required Settings**:
    - `hsbFramingDefaults.Inventory.dll` (For material catalog and dimensions).
    - `hsbCadNA.Wall.Sheathing.dll` (For calculation rules).
    - `NA_SheetBreakBacking.mcr` (Slave script for generating backing/framing).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `NA_WallSheathing.mcr`.

### Step 2: Configure Parameters
Action: The Properties Palette will appear automatically upon insertion. Adjust settings such as **Sheathing Material**, **Split Rule**, and **Offsets** if necessary before selecting walls.

### Step 3: Select Walls
```
Command Line: Select a set of elements
Action: Click on the Wall Elements in the model you wish to apply sheathing to. Press Enter when finished.
```

### Step 4: Resolve Missing Zones
If selected walls do not have a sheathing layer defined in their construction:
```
Command Line: Some walls do not have sheathing defined. Would you like to add sheathing to them? [Yes/No]
Action: Type 'Yes' to automatically create the sheathing zone with default settings, or 'No' to skip those walls.
```

## Properties Panel Parameters

### MATERIAL PROPERTIES
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheathing Zone | Integer | 1 | Selects which layer of the wall assembly to apply sheathing to (Index 1-10). |
| Sheathing Material | String | **Unchanged** | Select the specific material grade (e.g., 7/16 OSB) from the inventory. Set to "**Unchanged**" to use existing settings. |

### DISTRIBUTION PROPERTIES
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum Width | Double | 8 inch | The smallest allowable width for a cut piece (rip). The layout will shift to avoid creating pieces smaller than this. |
| Sheathing Split Rule | String | Full Sheets... | Strategy for layout: "Full Sheets (Add Studs Where Needed)", "Use Existing Studs Only", or "Vertical Sheathing". |
| Distribution Origin | String | Top Left | The corner of the wall where the sheathing layout starts (Top Left, Top Right, Bottom Left, Bottom Right). |
| Keep First Sheet Full | String | Yes | Forces the first sheet in the row to be a full-size panel (4x8) rather than a cut piece. |
| Keep Last Sheet Full | String | Yes | Forces the last sheet in the row to be a full-size panel rather than a cut piece. |

### EDGE OFFSET PROPERTIES
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply Custom Offsets | String | No | Global toggle to enable custom edge setbacks. |
| Top Offset | Double | 0 | Distance from the top of the wall to the top edge of the sheathing. |
| Bottom Offset | Double | 0 | Distance from the bottom of the wall to the bottom edge of the sheathing. |
| Left Offset | Double | 0 | Distance from the left edge of the wall to the sheathing. |
| Right Offset | Double | 0 | Distance from the right edge of the wall to the sheathing. |

### FRAMING PROPERTIES
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Stud Distribution Control | String | Auto | Controls if the script adds/moves studs to support sheathing seams ("Auto", "None", or "Warn"). |
| Break Framing Actions | String | 2 Ply | Configures blocking/studs at horizontal seams (e.g., "2 Ply" adds two studs back-to-back). |
| Apply to Blocking | String | Yes | Applies the Break Action configuration to wall blocking entities as well as studs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update sheathing selection from defaults editor | Reloads the available sheathing materials and properties from the company defaults configuration file. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: Company or Install path (defined in hsbCAD configuration).
- **Purpose**: Provides the catalog of available sheathing materials, their dimensions (Width/Height), and thickness.

- **Filename**: `NA_SheetBreakBacking.mcr`
- **Location**: TSL Scripts folder.
- **Purpose**: A dependency script that inserts the actual framing members (studs/blocking) required at sheathing seams based on the "Break Framing Actions" setting.

## Tips
- **Avoiding Waste**: Enable "Keep First Sheet Full" and "Keep Last Sheet Full" to prevent small, unusable rip cuts at the ends of walls. This is useful for shipping full panels to the job site.
- **Handling Ledges**: If you have a brick ledge at the bottom of the wall, use "Apply Custom Offsets" -> "Yes" and set the "Bottom Offset" to the height of the ledge (e.g., 10.5 inches).
- **Vertical vs. Horizontal**: If sheathing needs to run vertically (e.g., for specific nailing patterns or aesthetic lines), change the "Sheathing Split Rule" to "Vertical Sheathing".

## FAQ
- **Q: Why did the script instance disappear immediately after I selected the walls?**
  A: The script likely detected that the selected element was not a valid Stickframe Wall or the Element Zone thickness was invalid. Check that you are selecting standard wood frame walls.

- **Q: How do I change the standard sheet size (e.g., from 4x8 to 4x9)?**
  A: This is controlled by the material definition in the Inventory (`hsbFramingDefaults.Inventory.dll`). Select "Dynamic from Inventory" in the Sheathing Material property and choose a material code that corresponds to the 4x9 size.

- **Q: The script is adding extra studs I don't want.**
  A: Change the "Stud Distribution Control" property to "None" or "Warn". Ensure "Sheathing Split Rule" is set to "Use Existing Studs Only" if you do not want the layout to drive framing changes.