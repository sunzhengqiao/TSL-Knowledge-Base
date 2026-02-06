# hsb_RemoveInsulation.mcr

## Overview
Automates the removal of insulation materials and associated insulation scripts (TH_Insulation, hsb_Insulation) from selected wall elements within a designated sheet zone.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting wall elements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Wall Elements (ElementWallSF).
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RemoveInsulation.mcr`

### Step 2: Configure Sheet Zone
Before selecting elements, you may need to set the target layer.
```
Command Line: [N/A]
Action: If the Properties Palette does not open automatically, select the script instance in the model (if visible) or check the command line settings. In the Properties Palette, locate the "Sheet Zone" parameter and select the layer number (1-10) where the insulation is located.
```

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements from which you want to remove insulation. Press Enter to confirm selection.
```

### Step 4: Execution
```
Command Line: [N/A]
Action: The script automatically scans the selected walls, removes the insulation materials/scripts in the specified zone, and then deletes itself from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheet Zone | dropdown | 9 | Select the specific construction layer (Zone 1-10) within the wall assembly to scan for insulation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom right-click menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Material Name**: The script only removes sheets where the material name is exactly "Insulation" (case-sensitive). If your material is named "Insul" or "Mineral Wool", it will not be deleted.
- **Self-Deleting**: This script acts as a "command" rather than a permanent object. It will automatically remove itself from the drawing after it finishes processing to keep your project clean.
- **Zone Mapping**: The dropdown offers zones 1-10. These correspond to the construction layers defined in your wall catalogs (e.g., interior finish, framing, sheathing).

## FAQ
- **Q: I ran the script, but the insulation is still there. Why?**
- **A:** Check two things: 1) Ensure the "Sheet Zone" property matches the actual layer where the insulation sheet is placed. 2) Ensure the material name of the sheet is spelled exactly "Insulation".
- **Q: Where did the script icon go after I used it?**
- **A:** The script is designed to delete itself immediately after execution. This is normal behavior. You do not need to delete it manually.
- **Q: Does this work on beams?**
- **A:** No, this script is designed specifically for Wall Elements (`ElementWallSF`).