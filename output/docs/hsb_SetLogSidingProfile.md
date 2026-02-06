# hsb_SetLogSidingProfile.mcr

## Overview
This script automatically applies specific extrusion profiles, timber grades, and materials to the 'HSB-PL14' zone (Log Siding) within selected wall elements, ensuring consistent detailing for log siding layers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on selected `ElementWallSF` entities. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Intended for 3D model configuration. |

## Prerequisites
- **Required Entities**: Walls (`ElementWallSF`) must exist in the model.
- **Zone Requirement**: The selected walls must contain a zone with the code **'HSB-PL14'**. If this zone is missing, the script will delete itself from the wall.
- **Minimum Beams**: None (script targets specific zones within the wall).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_SetLogSidingProfile.mcr`

### Step 2: Select Walls
```
Command Line: Select a set of elements
Action: Click on the wall(s) you wish to configure and press Enter.
```
*Note: The script will attach itself to the selected walls and immediately update the 'HSB-PL14' zone if found.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extrusion profile name | Dropdown | (Empty) | Select the desired log profile shape from the catalog. This determines the geometry of the siding. |
| Grade | Text | (Empty) | Enter the structural grade of the timber (e.g., C24, GL24h). |
| Material | Text | (Empty) | Enter the wood species or material code (e.g., Spruce, Pine). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. Use the Properties Palette to make changes. |

## Settings Files
- **None required**: This script relies on the standard hsbCAD Extrusion Profile catalog and does not require external XML settings files.

## Tips
- **Zone Code is Critical**: Ensure your wall style or design includes a layer/zone explicitly named `HSB-PL14`. If you rename this zone in the wall properties, the script will stop working and remove itself.
- **Batch Updates**: You can select multiple walls during the insertion step to apply the same log siding settings to all of them simultaneously.
- **Post-Insertion Editing**: After insertion, you can select the wall, open the **Properties (Ctrl+1)** palette, and change the Profile or Material. The script will automatically update the beams in the 'HSB-PL14' zone to match the new values.

## FAQ
- **Q: I ran the script, but I cannot see it attached to the wall anymore.**
  - **A:** The script automatically removes itself if the selected wall does not contain the required zone code `HSB-PL14`. Check your wall layering/zone configuration.
- **Q: How do I change the shape of the logs after the script is already applied?**
  - **A:** Select the wall in the model, open the Properties Palette, find the "Extrusion profile name" property, and select a different profile from the dropdown list.
- **Q: Can I use this for other wall zones?**
  - **A:** No, this script is hard-coded to look specifically for the zone code `HSB-PL14`. For other zones, a different script or manual assignment is required.