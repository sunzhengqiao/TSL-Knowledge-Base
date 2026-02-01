# Alpine-Fixing.mcr

## Overview
This script generates 3D models of specific steel joist hangers (such as SST IUB or Cullen KM series) or generic placeholders. It is designed to align these metalwork components relative to a timber truss or beam assembly based on coordinate vectors and dimensions passed from a parent macro or Model Map.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D geometry for the model. |
| Paper Space | No | Not intended for 2D detailing or layout views. |
| Shop Drawing | No | Does not generate shop drawing views or lists. |

## Prerequisites
- **Parent Script/Macro**: Typically, this script is not run in isolation but is called by a larger timber generation macro that feeds it data.
- **Map Data**: If inserting manually, the following data keys must be present in the Model Map for the script to function correctly:
  - Orientation vectors (`XV_X`, `XV_Y`, `XV_Z`, `YV_X`, `YV_Y`, `YV_Z`)
  - Dimensions (`PlyWidth`, `Plies`)
  - Configuration (`IsHanger`, `HangerSide`, `FixingName`)

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Browse and select Alpine-Fixing.mcr
```

### Step 2: Place Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the Model Space to define the origin (usually the connection point on the timber).
```

### Step 3: Configure Map Data (if required)
Since this script relies on Map data rather than interactive prompts, you must configure the Map properties manually if not provided by a parent macro.

1. Select the inserted script instance.
2. Open the **Properties Palette** (Ctrl+1).
3. Edit the **Model Map** entries:
   - Set `IsHanger` to `1`.
   - Set `FixingName` to a valid code (e.g., `IUB190_75`, `KM38`) or `DEFAULT`.
   - Set `PlyWidth` and `Plies` to match your timber dimensions (if using `DEFAULT` fixing).
   - Ensure Orientation Vectors (`XV_...`, `YV_...`) are set to align with your beam (set to 0 to use the current UCS/Instance CS).

## Properties Panel Parameters

These parameters are typically stored in the Model Map. To edit them, select the element and modify the Map values in the Properties panel or the "Edit Map" context menu.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| FixingName | String | Empty | The commercial product code (e.g., "IUB190_75"). If "DEFAULT", dimensions are calculated from timber width. |
| IsHanger | Boolean | 0 | Toggles the visibility of the hanger. Set to 1 to draw, 0 to hide. |
| HangerSide | Enum | "LEFT" | Orientation of the hanger. Options are "LEFT" or "RIGHT". |
| PlyWidth | Double | 0.0 | Width of a single timber ply in millimeters. |
| Plies | Integer | 1 | Number of timber plies. Used with PlyWidth to calculate total width. |
| XV_X/Y/Z | Vector | 0.0 | X-axis direction vector of the parent timber. |
| YV_X/Y/Z | Vector | 0.0 | Y-axis direction vector of the parent timber. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Calculate | Recalculates the script geometry based on current Map data. |
| Erase | Removes the script instance from the drawing. |
| Edit Map | Opens a dialog to manually view and edit the Model Map entries (Orientation, Dimensions, etc.). |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script does not use external settings files. All configuration is handled via the Model Map.

## Tips
- **Orientation**: If the hanger appears rotated incorrectly, check the `XV_...` and `YV_...` vectors in the Map. If you set them all to `0.0`, the script will automatically align to the TSL Instance's coordinate system.
- **Fallback Geometry**: If you enter a `FixingName` that is not recognized, the script will not crash; instead, it will draw simple 3D placeholder lines to indicate where a hanger is located.
- **Flipping**: Use the `HangerSide` parameter to flip the hanger from left to right without needing to rotate the entire coordinate system.
- **Dynamic Sizing**: If you want the hanger to automatically adjust to the timber width, leave `FixingName` as `DEFAULT` (or empty) and ensure `PlyWidth` and `Plies` are accurate.

## FAQ
- **Q: I inserted the script but nothing is visible.**
  - A: Check the `IsHanger` property in the Map. It must be set to `1`. Also, verify that your `FixingName` is a valid code supported by the script.
- **Q: How do I rotate the hanger to match my sloped roof?**
  - A: Update the `XV_...` and `YV_...` Map vectors to match the direction of the beam. Alternatively, set these to `0` and rotate the TSL Instance itself using the AutoCAD Rotate or 3D Rotate tools.
- **Q: Can I add new hanger types?**
  - A: New types must be hard-coded into the script's internal catalog arrays by a developer. You cannot add new product codes simply via the Map.