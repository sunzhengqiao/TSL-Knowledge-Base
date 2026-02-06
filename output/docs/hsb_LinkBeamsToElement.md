# hsb_LinkBeamsToElement.mcr

## Overview
This script allows you to link loose timber beams (such as purlins or studs) to a specific construction zone within a target Element. It optionally updates the beams' display color to match the Element's zone settings for better visual organization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model editing tool and does not generate shop drawings. |

## Prerequisites
- **Required Entities**: You must have at least one GenBeam and one Element (e.g., a wall, floor, or roof) existing in the model.
- **Minimum Beam Count**: You must select at least one beam to link.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_LinkBeamsToElement.mcr` from the list.

### Step 2: Select Beams
```
Command Line: Select beams
Action: Click on one or more beams in the model that you wish to assign to an element.
         Press Enter to confirm your selection.
```

### Step 3: Select Target Element
```
Command Line: Select element to attach the beams
Action: Click on the main Element (Wall/Floor/Roof) that you want to take ownership of the selected beams.
```

### Step 4: Completion
The script automatically assigns the beams to the specified zone and updates their color (if configured). The script instance will then automatically erase itself from the drawing.

## Properties Panel Parameters
You can adjust these settings in the AutoCAD Properties Palette (Ctrl+1) before selecting the entities if desired.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to Assign the Beams | dropdown | 0 | Determines which construction layer/zone inside the element the beams belong to. Options 6–10 correspond to negative zones (-1 to -5). |
| Use Sheeting Zone Colour? | dropdown | No | If set to "Yes", the script changes the beams' color to match the color defined for the selected zone in the Element's properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Organization**: If you are struggling to see which beams belong to which element, set "Use Sheeting Zone Colour?" to "Yes". The beams will change color to match the element's layer coding.
- **Negative Zones**: If your element uses negative zones (often used for exterior layers or cladding), select values 6 through 10 in the Zone list (6 = -1, 10 = -5).
- **Re-running**: If you make a mistake, simply select the beams again and run the script to re-assign them to the correct element.

## FAQ
- **Q: Why did the script disappear from my drawing after I used it?**
  **A:** This is a "utility" script designed to perform an action once. It automatically erases itself after linking the beams to keep your drawing clean. The link you created remains.
- **Q: What happens if I don't select any beams?**
  **A:** The script will exit silently without making changes. Ensure you have selected beams and an element before proceeding.