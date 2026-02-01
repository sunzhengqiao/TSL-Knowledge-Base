# GE_WALL_INFO_COLOR_ID_MODULES.mcr

## Overview
This script visualizes the composition of wall modules by displaying their names at the center of each beam. It also applies unique colors to different module groups within a 3D model, making it easy to distinguish between specific prefabrication sections (e.g., different wall types) visually.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be attached to an Element in the Model Space. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for 2D shop drawing generation. |

## Prerequisites
- **Required entities**: An existing Element (e.g., a wall assembly) containing Beams.
- **Minimum beam count**: 0 (The script handles empty elements by displaying a placeholder at the element origin).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_INFO_COLOR_ID_MODULES.mcr` from the list.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the desired Element (wall assembly) in your 3D model to which you want to attach the visualization.
```

### Step 3: Automatic Generation
Once the Element is selected, the script will automatically:
1. Attach itself to the Element.
2. Scan all beams within the Element.
3. Display the "Module" property name as text at the center of each beam.
4. Assign a specific color to all beams belonging to the same Module group.

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable parameters in the Properties Palette. It uses internal logic to determine text size and colors. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently without requiring external settings files.

## Tips
- **Automatic Updates**: If you modify the Element (add/remove beams) or change the "Module" names of the beams, the visualization (text and colors) will update automatically the next time the view is refreshed.
- **Troubleshooting**: If you only see the script name appearing in the model but no text or colors on beams, the selected Element may be empty (contains 0 beams).
- **Clarity**: Use this tool during the design phase to quickly verify if your wall modules are assigned correctly before manufacturing.

## FAQ
- **Q: How do I remove the colors and text labels?**
  - A: Select the script instance attached to the Element and delete it.
- **Q: Can I change the text height of the module labels?**
  - A: The text height is hardcoded within the script logic and cannot be changed via the properties panel.
- **Q: Why are beams colored differently?**
  - A: The script assigns a unique color to every unique "Module" name found within the Element. Beams sharing the same Module name will share the same color.