# HSB_G-StackItem

## Overview
This script is used to define individual timber elements as items within a transport stack. It links selected elements to a parent stacking volume (created by `HSB_G-Stack`) for logistics and packing list generation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in Model Space to interact with 3D stack volumes. |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | Not used for detailing views. |

## Prerequisites
- **Required Entities**: At least one hsbCAD Element (e.g., a beam or wall).
- **Parent Script**: The parent script `HSB_G-Stack` must exist in the model to define the stacking volume.
- **Required Space**: Model Space only.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-StackItem.mcr`.

### Step 2: Configure Properties (If Prompted)
```
Command Line: [Dialog Appears]
Action: If the execute key is not set, the Properties Palette will open. Review the default settings (e.g., Stack Script Name) and click OK.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the timber elements (beams, walls, etc.) you want to include as stack items and press Enter.
```

### Step 4: Position Items
```
Action: The script will attach an instance to each selected element. 
Move these elements (or the script instances) so that they physically intersect with the parent Stack volume.
Note: The logical link is only established when the item intersects with the parent Stack body.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| stackScriptName | String | HSB_G-Stack | The name of the parent TSL script that defines the stack volume. This must match the filename of the parent script. |
| distanceBetweenStackingChilds | Double | 3000 mm | The spacing distance used when inserting multiple items in sequence via the command line. |
| stackingChildColor | Integer | 140 | The color index (0-255) used to display the stack item bounding box in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Double Click | Rotates the stack item instance 90 degrees around its local X-axis. Use this to orient the element correctly within the stack. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on the parent `HSB_G-Stack` script configuration rather than its own separate settings file.

## Tips
- **Establishing Links**: The script writes data to the Element only when it detects a collision with the parent Stack volume. If the element appears as an "orphaned box," move it closer or inside the stack volume.
- **Visualizing Orientation**: Use the **Double Click** feature to quickly rotate the element orientation if it is not lying flat or oriented correctly in the stack.
- **Color Coding**: Change the `stackingChildColor` property to visually distinguish between different types of items or layers in your stack.

## FAQ
- **Q: The script attached to my element, but it doesn't seem to be part of the stack.**
- **A:** Ensure the element (or the visualization box) physically overlaps with the parent `HSB_G-Stack` volume. The link is calculated based on 3D intersection.

- **Q: How do I change the orientation of the item inside the stack?**
- **A:** Simply double-click on the stack item instance. It will rotate 90 degrees around its X-axis.

- **Q: What happens if I delete the parent Stack?**
- **A:** The child items will remain in the model but will lose their logical connection (the relative position map will no longer update).