# GE_TRUSS_POINTLOAD.mcr

## Overview
This script generates a reinforced built-up post assembly within a wall to support heavy point loads, such as roof truss bearings or floor girders. It manages the creation of multiple studs packed together and handles blocking integration to distribute the load effectively.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the Model Space to generate physical framing within an Element. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawings or annotations. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (typically a Wall or Floor).
- **Minimum Beam Count**: 0 (The script creates its own beams).
- **Required Settings Files**:
  - `hsbFramingDefaults.Inventory.dll` (Must be present to access lumber grades and sizes).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_TRUSS_POINTLOAD.mcr`

### Step 2: Select Element
```
Command Line: Select element
Action: Click on the Wall or Floor Element in the model where the point load reinforcement needs to be generated.
```

### Step 3: Configure Properties
After selecting the element, the script inserts into the model. Open the **Properties Palette** (Ctrl+1) to adjust the settings.
1. Set **Execute** to `1`.
2. Select the desired **Lumber Item**.
3. Adjust **Studs Num** and **Girder Plies** as required for the load.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Execute | number | 0 | Master switch to generate the reinforcement. Set to `1` to create or update the beams. Set to `0` to disable regeneration. |
| Lumber Item | dropdown | | Select the material grade and size (e.g., "2x4 SPF No.2") from your project inventory. This determines the stud dimensions. |
| Studs Num | number | 2 | The number of studs placed side-by-side along the wall length. Increasing this creates a wider post. |
| Girder Plies | number | 1 | The number of layers stacked perpendicular to the wall plane. Increasing this creates a deeper/thicker column. |
| Use Studs Between Floors | number | 1 | Determines if studs run continuously through floor levels (`1`) or are cut off at the current floor's top plate (`0`). |
| Post Assembly Name | text | PointLoad | The name assigned to the generated beams for grouping, reporting, and material lists. |
| Color Name | dropdown | MAGENTA | The display color of the generated beams in Model Space for visual identification. |

## Right-Click Menu Options
This script does not add specific custom options to the right-click context menu. Use the Properties Palette to modify parameters.

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbFramingDefaultsEditor`
- **Purpose**: This file provides the list of available lumber materials (Species, Grade, Size) that populate the "Lumber Item" dropdown.

## Tips
- **Visual Verification**: The default color (Magenta) is chosen to stand out from standard framing. Check visually to ensure the new studs do not conflict with windows, doors, or other wall components.
- **Load Calculations**: Consult your structural engineer to determine the required "Studs Num" (width) and "Girder Plies" (depth) for the specific point load.
- **Updating**: After changing parameters in the Properties Palette, ensure **Execute** is set to `1`. The script will delete the old reinforcement and regenerate it based on the new settings.

## FAQ
- **Q: I changed the properties, but the model didn't update.**
  - A: Make sure the **Execute** property is set to `1`. If it is already `1`, toggle it to `0` and back to `1` to force a refresh.
- **Q: Can I use this for floor trusses?**
  - A: Yes, this script is designed for any point load transfer, including roof trusses, floor girders, or heavy structural loads.
- **Q: Why are my studs longer than the wall?**
  - A: Check the **Use Studs Between Floors** setting. If set to `1`, the studs may extend beyond the current top plate to connect to the structure above.