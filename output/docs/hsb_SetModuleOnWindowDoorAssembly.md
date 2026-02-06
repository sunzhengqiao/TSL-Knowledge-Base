# hsb_SetModuleOnWindowDoorAssembly.mcr

## Overview
This script automatically detects adjacent window and door openings based on their proximity within wall elements. It assigns a unified "Module" name to all framing beams surrounding these groups, ensuring they are treated as a single pre-fabricated unit for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where the wall elements are located. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a model-space data management script. |

## Prerequisites
- **Required Entities:** Wall Elements (`ElementWallSF`) containing Openings and Beams.
- **Minimum Beam Count:** No strict limit, but the element must contain beams for the script to process data.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsb_SetModuleOnWindowDoorAssembly.mcr`

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the Wall Elements that contain the window/door assemblies you wish to group. Press Enter or Right-Click to confirm selection.
```

### Step 3: Automatic Processing
The script will automatically analyze the selected walls, identify openings close to each other (e.g., window triplets), and update the `Module` property on the surrounding beams. The script instance will delete itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add any items to the Right-Click context menu. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external settings files.

## Tips
- **Proximity Logic:** The script groups openings that are close together. Openings with a gap larger than approximately 80mm will likely be treated as separate units.
- **Pre-existing Names:** The script looks for an existing "Module" name on the beams surrounding the openings. Ensure at least one beam in the group already has the correct Module name before running this script, so it can propagate that name to the rest of the group.
- **Single Execution:** The script is designed to run once and then remove itself from the drawing. You do not need to manually delete the script instance.

## FAQ
- **Q: Why did my windows not group into a single module?**
  - **A:** The script groups openings based on geometric intersection after shrinking their profiles. If the gap between your windows is too wide (typically >80mm), they will not be recognized as a single assembly. Move the openings closer in the drawing and run the script again.
- **Q: What happens if none of the beams have a Module name?**
  - **A:** The script requires at least one beam in the assembly to already have a "Module" name assigned. If no names are found, the script will not modify the properties for that assembly.
- **Q: Can I use this on curved walls?**
  - **A:** The script works on standard `ElementWallSF` objects. As long as the geometry can be processed, it should function, though it is primarily designed for standard planar wall assemblies.