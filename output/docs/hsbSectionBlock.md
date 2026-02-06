# hsbSectionBlock.mcr

## Overview
Defines a section cut line and viewing direction in the 3D model to generate labeled section markers (arrows/circles) and prepare calculation data for 2D Shop Drawing views.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to define section lines and visualize cut geometry on solids. |
| Paper Space | Yes | Generates and updates views within the Shop Drawing environment. |
| Shop Drawing | Yes | Fully compatible with ShopDrawing generation events. |

## Prerequisites
- **Required Entities**: `GenBeam` (Solids) or `ShopDrawView`.
- **Minimum beam count**: 0 (Can operate on generic solids).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSectionBlock.mcr`

### Step 2: Select Entities
```
Command Line: Select Entities (Solids or shopdraw views)
Action: Click on the 3D solids/beams you want to section, OR select an existing ShopDrawView entity to link to it.
```

### Step 3a: Define Section Cut (If Solids selected)
```
Command Line: Select first point of section line
Action: Click in Model Space to set the start of the cut line.

Command Line: Select second point of section line
Action: Click to set the end of the cut line.

Command Line: Select direction
Action: Click on one side of the line to indicate which direction the "camera" is looking.
```

### Step 4a: Complete Insertion
The script will generate the section cut geometry and draw the section symbol (arrows and circle) at the cut line endpoints.

### Step 3b: Define Link Origin (If ShopDrawView selected)
```
Command Line: 
Action: Click to place the origin point for the link in the model.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scale of Symbol | number | 1 | Adjusts the global size of the section markers (arrows and circles). Increase to make symbols larger. |
| Dimstyle | dropdown | (Current) | Selects the dimension style used for the View Number text. Changing this affects font and text height. |
| Color | number | 145 | Sets the AutoCAD color index for the section lines, arrows, and text labels. |
| View Number | text | A | The label text displayed inside the section marker circle (e.g., A, B, 1, 2). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ShopDraw Event | Regenerates the 2D Shop Drawing view data associated with this section block. Use this after moving the section line or changing model geometry. |

## Settings Files
None required.

## Tips
- **Grip Editing**: Select the section block in Model Space to use grips. Move the line endpoints to adjust the cut location, or move the direction arrow to change the view side.
- **Text Size**: If the View Number text is too large for the circle, change the **Dimstyle** property to a style with smaller text height, or decrease the **Scale of Symbol**.
- **Updating Views**: After moving the section line grips, always right-click and select **ShopDraw Event** to update the corresponding 2D detail view on your layout sheets.

## FAQ
- **Q: Why did my section block disappear after inserting it?**
  **A:** The script requires a minimum of 2 points to define a line. If the prompts are cancelled or points are invalid, the instance is automatically erased. Try inserting again and ensure you click valid points.
- **Q: How do I change the size of the circle around the letter?**
  **A:** The circle size is calculated based on the text width and the **Scale of Symbol** property. Increase the `Scale of Symbol` value in the properties panel.
- **Q: Can I section multiple beams at once?**
  **A:** Yes. Use a window selection at the "Select Entities" prompt to choose multiple beams or solids. The section cut will apply to all selected entities.