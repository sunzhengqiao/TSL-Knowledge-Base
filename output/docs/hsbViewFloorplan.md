# hsbViewFloorplan.mcr

## Overview
This script generates a 2D floor plan view in a Paper Space layout by creating solid hatches and labels for walls and roofs visible in a selected Viewport. It is used to create architectural presentation drawings or installation plans where specific elements need to be tagged and highlighted directly on the drawing sheet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script reads elements from Model Space but must be inserted into Paper Space. |
| Paper Space | Yes | This is the primary working environment. You must have a layout with an active Viewport. |
| Shop Drawing | No | This is a standalone script for creating presentation views. |

## Prerequisites
- **Required Entities**: A `Viewport` in Paper Space that is viewing the model. The Model Space must contain `ElementWall` or `ElementRoof` entities.
- **Minimum Beam Count**: 0 (This script works with architectural elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` and select `hsbViewFloorplan.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in your layout that displays the floor level you want to document.
```

### Step 3: Select Level
```
Dialog: Select Level
Action: The script scans the model for elements and groups them by level. Select the specific level (elevation) you wish to generate the view for from the list.
```

### Step 4: Define Location and Scale
```
Command Line: Pick insertion point
Action: Click in the Paper Space to place the top-left corner of the floor plan view.

Command Line: Pick reference point / Define scale
Action: Click a second point to define the scale and size of the view (dragging away enlarges it, dragging closer shrinks it).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | Dropdown | *(Current Style)* | Selects the text style (font, line characteristics) used for the element labels. |
| Text Height | Number | 0 | Sets the plotted height of the text labels. **0** means the text scales automatically based on the Viewport scale. |
| Color | Number | 0 | Defines the color index (0-255) for the solid fill hatches representing the walls/roofs. |
| Format | String | @(ElementNumber) | Defines the text displayed inside each element. You can use attributes like `@(ElementNumber)`, `@(Length)`, etc. Separate multiple lines with a backslash `\`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard TSL Menu) | Use the Properties Palette to modify parameters. Standard context options for moving/grip-editing the view are available. |

## Settings Files
- None.

## Tips
- **Automatic Text Scaling**: Leave the **Text Height** set to `0` to ensure your labels remain readable regardless of the viewport zoom level. The script calculates the appropriate size based on your Dim Style settings.
- **Custom Labels**: Use the **Format** property to add more data to your floor plan. For example, change it to `@(ElementNumber)\n@(Length)` to display the element number on one line and its length on the next.
- **Color Coding**: Change the **Color** property to different values (e.g., standard Red for walls, Blue for roofs) to visually distinguish different types of elements in your plan.

## FAQ
- **Q: Why does the script disappear after I select a viewport?**
  **A:** The script erases itself if it cannot find any valid ElementWall or ElementRoof entities inside the selected viewport's model space view. Ensure your model has walls or roofs and that they are visible within the viewport boundaries.

- **Q: Can I move the floor plan after inserting it?**
  **A:** Yes, you can use standard AutoCAD grip editing or the Move command to reposition the generated view in Paper Space.

- **Q: How do I change the information shown in the labels?**
  **A:** Select the script instance, open the Properties Palette (Ctrl+1), and edit the **Format** string. You can use any hsbCAD attribute token available for the elements.