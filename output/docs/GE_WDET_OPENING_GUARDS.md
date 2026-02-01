# GE_WDET_OPENING_GUARDS.mcr

## Overview
This script automatically generates guard rails and blocking for wall openings, such as doors and windows. It creates dimensional lumber elements based on the opening's dimensions and assigns properties (material, grade, etc.) from user settings or the project inventory.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Generates 3D model elements only. |

## Prerequisites
- **Required Entities**: Wall elements containing Openings.
- **Minimum Beam Count**: 0 (The script creates the beams).
- **Required Settings**:
  - `hsbFramingDefaults.Inventory.dll` (Must be present in the `Utilities\hsbFramingDefaultsEditor` folder).
  - Valid Inventory entries for lumber items.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_OPENING_GUARDS.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall elements (or window/floor containing walls) where you want to add opening guards. Press Enter to confirm.
```

### Step 3: Configure Properties
After selection, the Properties Palette (OPM) will open.
1.  **Lumber Item**: Select the desired lumber profile from the inventory (e.g., "Stud 2x4").
2.  **Beam Size**: Choose a specific nominal size (e.g., 2x4, 2x6) or select "From inventory" to use the size defined in the Lumber Item.
3.  **Blocking Color**: Choose "Copy from assembly" to match the wall studs or "Custom" to use a specific color.
4.  **Manual Properties**: Optionally override Name, Material, Grade, or Label information.

### Step 4: Generation
The script will automatically calculate the geometry for each opening and generate the guard rails.
- **Doors**: Adds a bottom rail and specific blocking heights.
- **Windows**: Adds a rail at 42" height.
- **Wide Openings**: Adds additional stiffeners or doublers if width exceeds thresholds.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Blocking info** | Text | (Header) | Section header. |
| **Auto** | Text | (Header) | Section header for automatic settings. |
| **Lumber item** | Dropdown | *Empty* | Select a lumber item from the Inventory to define dimensions/material. |
| **Manual** | Text | (Instructions) | Section header for manual overrides. |
| **Beam size** | Dropdown | From inventory | Select a nominal size (e.g., 2x4, 2x6). If "From inventory" is selected, it uses the Lumber Item's size. |
| **Blocking color** | Dropdown | Copy from assembly | Determines the color of the generated beams. |
| **Custom color** | Number | 2 | Sets the color index if "Blocking color" is set to "Custom". |
| **Name** | Text | *Empty* | Sets the "Name" property of the generated beams. |
| **Material** | Text | *Empty* | Overrides the "Material" property of the generated beams. |
| **Grade** | Text | *Empty* | Overrides the "Grade" property of the generated beams. |
| **Information** | Text | *Empty* | Sets the "Information" property for CAM/Production data. |
| **Label** | Text | *Empty* | Sets the "Label" property of the generated beams. |
| **Sublabel** | Text | *Empty* | Sets the "Sublabel" property of the generated beams. |
| **Sublabel2** | Text | *Empty* | Sets the "Sublabel2" property of the generated beams. |
| **Beam code** | Text | *Empty* | Sets the "Beam code" property of the generated beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *(None)* | This script does not add custom items to the right-click context menu. Modify parameters using the Properties Palette (OPM). |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `%_kPathHsbInstall%\Utilities\hsbFramingDefaultsEditor`
- **Purpose**: Provides the list of available Lumber Items (Names, Dimensions, Material) used by the "Auto" section of the properties.

## Tips
- **Dependency**: The script sets a dependency on the wall. If you modify the wall geometry (stretch or move an opening), the guard rails will update automatically.
- **Medical Cabins**: The script is designed to skip openings that contain 'CAB' or 'AP' in their module name (typically Medical Cabins).
- **Color Matching**: Use "Copy from assembly" for the Blocking Color to ensure the guards visually blend with the surrounding studs.
- **Updating**: If you manually change a guard beam in the model and want to regenerate it, delete the beam and run a recalculation on the wall.

## FAQ
- **Q: Why did the script not create a beam for a specific opening?**
  - A: Check if the opening is identified as a "Medical Cabin" (Name contains CAB or AP). Also, ensure the wall has valid side studs for the script to calculate the position.
- **Q: How do I change the height of the window guard?**
  - A: The script currently uses a fixed height logic (e.g., 42" for windows). To change this, you would need to modify the script code.
- **Q: Can I use this on curved walls?**
  - A: The script retrieves openings from the element. While it may work on some curved walls, it is primarily designed for standard straight wall applications.