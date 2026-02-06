# hsbElementDetails.mcr

## Overview
This script allows you to define specific detail areas (zoom regions) on timber elements in the 3D model and automatically link them to viewports in 2D drawings. It bridges the gap between the 3D model and production layouts by allowing you to label and zoom into complex connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to draw the detail boundary box and assign it to the element. |
| Paper Space | Yes | Used to link a viewport to a defined detail box. |
| Shop Drawing | No | Used for general drafting and layout views. |

## Prerequisites
- **Required Entities**: 
  - **Model Space Mode**: An Element (ElementWall or ElementRoof).
  - **Paper Space Mode**: A Viewport that is already linked to an hsbCAD Element.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbElementDetails.mcr` from the list.

### Step 2: Choose Mode
The script supports two workflows based on your initial selection:

**Option A: Define a Detail in Model Space (3D)**
```
Command Line: Select elements (Enter to select a viewport)
Action: Select a Wall or Roof element in the 3D model.
```
1.  Select the desired timber element.
2.  The Properties Palette will open. Set the **Detail Name** (e.g., "Detail A") and **Detail Index**.
3.  **Prompt:** `Select lower left corner`
    *   Click the point in the model where the detail box should start.
4.  **Prompt:** `Select upper right corner`
    *   Click the point to define the opposite corner of the box.
5.  **Prompt:** `Select a set of detail entities (Optional)`
    *   Select specific beams or entities if you wish to group them with this detail, or press Enter to skip.

**Option B: Link a Viewport in Paper Space (2D)**
```
Command Line: Select elements (Enter to select a viewport)
Action: Press Enter on your keyboard.
```
1.  Press **Enter** to switch to Viewport selection mode.
2.  **Prompt:** Implicit selection
    *   Click a Viewport on your layout sheet.
    *   *Note: The Viewport must have hsbData attached (linked to an element).*
3.  **Prompt:** `Pick point`
    *   Click where you want the Detail Label (e.g., "Detail A") to appear on the sheet.
4.  Ensure the **Detail Index** property matches the index of the detail you created in Model Space.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Detail Name | Text | "Detail" | The label text displayed on the drawing (e.g., "Section A"). If a duplicate name exists, a number is appended automatically. |
| Detail Index | Integer (1-20) | 1 | The unique ID linking the 3D definition to the 2D viewport. Both must have the same index to work together. |
| DimStyle | Text | Current DimStyle | The dimension style applied to the label text (controls font and appearance). |
| Text Height | Number | Varies by space | The height of the label text. Set to `0` to hide the text. |
| Color | Integer (0-255) | 170 | The color of the detail boundary rectangle drawn in Model Space. |
| Scale Factor | Number | 1.0 | Adjusts the zoom level inside the viewport. Values > 1 zoom in; values < 1 zoom out. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Entity Menus) | Modifications are primarily handled via the Properties Palette and Grip Points. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Unique Names**: The script automatically checks for duplicate names. If you name a detail "Corner" and it already exists, the script will rename the new one to "Corner 1".
- **Resizing Details**: In Model Space, select the detail script and use the **Grip Points** to resize the rectangle. The script will automatically recalculate the geometry.
- **Hiding Labels**: If you only want the viewport zoom effect but don't want text cluttering the view, set the **Text Height** to `0` in the properties.
- **Updating Views**: If you change the **Detail Index** in Paper Space, the viewport will immediately search for the new detail definition and update the zoom target.

## FAQ
- **Q: Why does the viewport show the wrong location or nothing?**
  - A: Ensure the selected Viewport is linked to the correct Element and that the **Detail Index** in the Paper Space script matches the index of the detail box in the Model Space script.
- **Q: Can I use this on multiple elements?**
  - A: Yes, but each detail instance is attached to a specific element. Ensure you select the correct element during the Model Space setup.