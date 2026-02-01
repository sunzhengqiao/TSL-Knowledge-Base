# hsb-E-Combination

## Overview
This script inserts electrical installation combinations (such as sockets, switches, or junction boxes) into your timber model. It automatically generates 3D machining (drilling/milling) on structural elements and produces detailed 2D annotations, including elevation heights and custom text, for floor plans and element drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script is inserted and creates 3D machining here. |
| Paper Space | Yes | 2D symbols and annotations are rendered via Display Primitives. |
| Shop Drawing | No | This is a model-space script, though it annotates element views. |

## Prerequisites
- **Required Entities**: GenBeams, Elements, or Bodies to machine into.
- **Minimum Beams**: 0 (Script detects existing beams automatically).
- **Required Settings**:
  - Block definitions located in `<hsbCompany>\Block\Electrical`.
  - `hsbElectricalTsl.dll` located in `<hsbCAD>\custom\`.
  - `hsbInstallationPoint.mcr` (likely dependency).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select hsb-E-Combination.mcr from the file list.
```

### Step 2: Insert and Locate
```
Command Line: [Insertion point prompt varies based on hsbCAD configuration]
Action: Click in the drawing to place the electrical combination. The script will automatically detect intersecting structural elements (walls/floors) to apply machining.
```

### Step 3: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to adjust text descriptions and visibility settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **showLeader** | Boolean | 1 (True) | Toggles the visibility of the leader line connecting the text annotation to the insertion point. |
| **sDesc1** | String | "" | First line of custom description text (e.g., "Living Room"). |
| **sDesc2** | String | "" | Second line of custom description text (e.g., "Circuit A1"). |
| **ElevationTextMM** | String | Derived | The installation height relative to project zero, displayed in millimeters (e.g., "+1050"). |
| **ElevationTextM** | String | Derived | The installation height relative to project zero, displayed in meters (e.g., "+1.050"). |
| **nProjectSpecial** | Integer | 0 | Set to 1 to enable dual-unit annotations (showing both Millimeter and Meter heights simultaneously). |
| **mapSetting** | Map | Empty | Internal configuration container for block names, machining depths, and styles. This is primarily managed via Import/Export context menus. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Hide Leader / Show Leader** | Toggles the visibility of the leader line in the plan annotation without opening the properties palette. |
| **Import Settings** | Loads configuration data (blocks, text styles, dimensions) from an external XML file located in the company settings folder. |
| **Export Settings** | Saves the current instance configuration to an external XML file. Useful for backing up settings or sharing them with other users. |

## Settings Files
- **Filename**: `XML Configuration File` (Variable: `sFullPath`)
- **Location**: `<hsbCompany>\tsl\settings`
- **Purpose**: Stores the script configuration (MapObject `mapSetting`) including machining depths, block references, and text styles. This allows for standardizing electrical setups across a project.

## Tips
- **Standardization**: Configure one electrical combination exactly as needed (correct height, symbol, and text style), use the **Export Settings** context menu to save it, and then use **Import Settings** on other instances to ensure consistency.
- **Annotation Control**: Use the `nProjectSpecial` property if your architectural plans require elevations in both Meters and Millimeters.
- **Clarity**: If plan views become too cluttered, use the **Hide Leader** context menu option to remove the leader lines while keeping the text labels.

## FAQ
- **Q: The leader line is pointing in the wrong direction. How do I fix it?**
  **A:** Currently, this script toggles leader visibility but does not provide a grip to rotate the leader direction in the Properties Palette. You may need to adjust the insertion point or check the block definition behavior.
- **Q: Can I change the symbol used for the socket?**
  **A:** The symbol is determined by the `mapSetting`. You should configure the appropriate block reference within the settings or Import Settings from a preset configuration that uses the desired symbol.