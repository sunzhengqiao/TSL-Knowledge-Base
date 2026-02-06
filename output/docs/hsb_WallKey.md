# hsb_WallKey.mcr

## Overview
This script creates a 2D "key plan" or location indicator on drawings to show the position of the current element within the context of the entire house or floor layout. It automatically projects and scales the relevant wall outlines to fit a user-defined area on the sheet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Reads data from Model Space, but output is placed in other contexts. |
| Paper Space | Yes | Selects a Viewport to link the 2D key to the 3D model. |
| Shop Drawing | Yes | Selects a ShopDrawView to generate the key within a multipage layout. |

## Prerequisites
- **Required Entities**: An existing Element in the model containing `ElementWall` entities.
- **Minimum Beam Count**: 0
- **Required Settings**: None
- **Setup**: The drawing must contain a Viewport (Paper Space) or a ShopDrawView (Shopdrawing) that is linked to a valid element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_WallKey.mcr`

### Step 2: Configure Properties (Optional)
Before inserting, you can change the **Drawing Space** and **Draw elements in group** options in the Properties palette (Ctrl+1) if the defaults do not match your current task.

### Step 3: Select Source View
Depending on your **Drawing Space** property:

*If using Paper Space:*
```
Command Line: Select the viewport from which the element is taken
Action: Click on the viewport in your layout that displays the 3D element you want to locate.
```

*If using Shopdraw Multipage:*
```
Command Line: Select the view entity from which the module is taken
Action: Click on the ShopDrawView entity associated with the element.
```

### Step 4: Define Key Plan Location
```
Command Line: Pick Bottom Left Point of Key
Action: Click on the sheet to place the bottom-left corner of the key plan frame.
```

### Step 5: Define Key Plan Size
```
Command Line: Pick Top Right Point of the Key
Action: Click to place the top-right corner of the frame. The script will automatically scale the plan to fit inside this box.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | paper space | Determines the working environment. Choose between "paper space" or "shopdraw multipage". |
| Draw elements in group | dropdown | House | Sets the scope of the key plan. Choose "House" to show all walls, or "Floor" to show only walls on the current level. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Scaling Accuracy**: The size of your key plan is determined entirely by the box you draw in Steps 4 and 5. Draw a larger box for a more detailed view, or a smaller box for a compact indicator.
- **Context Switching**: If you are detailing a specific wall but need to show where it sits on the entire floor plan, set **Draw elements in group** to "Floor". If you need to show its location within the full building project, set it to "House".

## FAQ
- **Q: Why did the script fail to find walls?**
  **A:** Ensure the Viewport or ShopDrawView you selected is actually linked to a valid Element in the model that contains wall data.
- **Q: Can I change the scale of the key plan manually?**
  **A:** No, the scale is calculated automatically based on the two points you pick to define the frame. To change the scale, erase the key and pick the points again at a different distance.
- **Q: What does the "arrow" in the drawing represent?**
  **A:** The script generates a hatched symbol indicating the specific location of the selected element within the larger floor plan.