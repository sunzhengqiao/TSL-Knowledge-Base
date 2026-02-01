# GE_WALL_INFO_ELEMENT_ZONE_LOCATION

## Overview
Visualizes the origin point (ptOrg) of specific vertical zones within a wall element. This script helps CAD operators identify and verify the exact vertical height of specific wall zones (such as floor levels) relative to a chosen reference point.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in 3D model space only. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: One Wall Element.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_INFO_ELEMENT_ZONE_LOCATION.mcr`

### Step 2: Select Wall Element
```
Command Line: Select Element
Action: Click on the desired Wall Element in the drawing.
```

### Step 3: Specify Reference Location
```
Command Line: Specify Location
Action: Click a point in the drawing to define the local coordinate system origin and placement location for the information.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index | dropdown | 5 | Selects which vertical zone number to highlight. Positive values usually indicate construction zones (stories), while negative values may indicate basements or extensions. |
| Offset | number | 30 | Sets the horizontal distance (in mm) that the indicator line is drawn away from the calculated origin point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No specific context menu options are added by this script. Use the Properties Palette to adjust settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Visual Context**: The script automatically draws vertical markers for all zones from index -5 to 5. This allows you to see the relative stack of all zones even if you are only highlighting one specific zone.
- **Dynamic Updates**: If you modify the geometry of the source Wall Element, the zone markers will automatically update to reflect the new heights.
- **Avoid Clutter**: If the label overlaps with other geometry, increase the **Offset** property to shift the leader line horizontally.

## FAQ
- **Q: What happens if I select a zone index that doesn't exist in my wall?**
- **A:** The marker will likely snap to the element's origin (0,0,0) or may not display the specific label correctly. Ensure the selected zone index corresponds to a valid zone defined in your wall properties.
- **Q: How do I change which zone is highlighted after insertion?**
- **A:** Select the script object in the model, open the Properties Palette (Ctrl+1), and change the value in the **Zone index** dropdown.