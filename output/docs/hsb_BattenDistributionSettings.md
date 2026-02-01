# hsb_BattenDistributionSettings.mcr

## Overview
This script allows you to configure and save batten distribution parameters (such as sizes, offsets, and materials) directly onto selected Wall elements. It acts as a setup tool, injecting configuration data into the wall's properties to prepare it for automated batten generation processes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where Wall elements exist. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not a shop drawing detailing script. |

## Prerequisites
- **Required entities**: ElementWall (Wall) entities must exist in the drawing.
- **Minimum beam count**: 0 (This script works on Wall elements, not individual beams).
- **Required settings**: None required.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_BattenDistributionSettings.mcr`.

### Step 2: Configure Settings
1. Upon launching, the script parameters will appear in the **Properties Palette** (or a dynamic dialog).
2. Adjust the batten dimensions, offsets, and material codes to match your design requirements.
3. Set the **Zone to apply battens to (`nZoneCount`)** to target the specific construction layer of the wall.

### Step 3: Select Walls
```
Command Line: Select ElementWall entities:
Action: Click on the Wall elements you wish to apply the batten settings to. Press Enter to confirm selection.
```
*Note: You can select multiple walls at once to apply the same settings to all of them.*

### Step 4: Execution
1. Once selected, the script automatically writes the configuration data to the selected walls.
2. The script instance will automatically erase itself from the drawing upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to apply battens to | Integer | 0 | Selects the construction layer (Zone) on the wall (Range 1-10). |
| Colour | Integer | 1 | The display color index (1-255) for the battens/zone. |
| Material | String | CLS | Defines the material code (e.g., CLS) for the battens. |
| Zone Thickness | Double | 10 mm | The thickness (depth) of the construction zone perpendicular to the wall face. |
| Batten Width | Double | 38 mm | The width (cross-section size) of the vertical battens. |
| Top Batten Width | Double | 38 mm | Width of the top horizontal plate (Set to 0 to disable). |
| Bottom Batten Width | Double | 38 mm | Width of the bottom horizontal plate (Set to 0 to disable). |
| Left Offset | Double | 0 mm | Distance from the left wall edge to the start of the layout. |
| Right Offset | Double | 0 mm | Distance from the right wall edge to the end of the layout. |
| Top Offset | Double | 0 mm | Distance from the top of the wall zone to the top of vertical battens. |
| Bottom Offset | Double | 0 mm | Distance from the bottom of the wall zone to the bottom of vertical battens. |
| Top Gap | Double | 0 mm | Gap between the top plate and the vertical battens. |
| Bottom Gap | Double | 0 mm | Gap between the bottom plate and the vertical battens. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance removes itself immediately after execution, so no persistent right-click options are available. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; all configuration is handled via Properties Panel parameters.

## Tips
- **Batch Processing**: You can select multiple walls in a single command to apply standard batten settings across an entire floor plan.
- **Plate Control**: If you do not require a top or bottom horizontal plate, simply set the **Top Batten Width** or **Bottom Batten Width** to `0`.
- **Re-running**: If you need to change settings, simply run the script again, adjust the parameters in the Properties Palette, and select the walls again. The new settings will overwrite the old ones.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  **A:** This is a configuration script. Its job is to write data to the wall elements and then clean up by removing itself from the drawing.
- **Q: I don't see any battens drawn in the model.**
  **A:** This script only sets the *parameters* for battens. You must run your batten generation/construction plugin afterwards to visualize and create the actual timber elements based on these settings.
- **Q: How do I apply settings to a different layer of the wall?**
  **A:** Change the **Zone to apply battens to** parameter to the desired zone index (e.g., 1, 2, 3) before selecting the walls.