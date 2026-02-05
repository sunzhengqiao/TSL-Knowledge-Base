# NA_BUNDLE_PANEL_BLANK.mcr

## Overview
Creates a parametric representation of a raw timber panel blank used for stacker lists and production reports. It automatically generates a unique Stack ID based on your project location settings and allows for quick resizing using on-screen grips or the Properties panel.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D geometry and 2D outlines directly in the model. |
| Paper Space | No | Not designed for Paper Space or layout views. |
| Shop Drawing | No | This is a modeling/production script, not a detailing tool. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings:**
  - **mpStackLocation (Map):** Optional but recommended. This project map stores the Prefix, Stack Number, Row, and Place information. If present, the script uses this to auto-generate the "Stack Id" property. If missing, the ID defaults to "X-999-999-999".

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_BUNDLE_PANEL_BLANK.mcr` from the list.

### Step 2: Select Insertion Point
```
Command Line: Select an insertion point
Action: Click in the Model Space to place the panel.
```
*Once placed, the panel is initialized with default dimensions and added to the "X - STACKER" group.*

### Step 3: Adjust Dimensions
You can now modify the panel using either the on-screen Grips or the Properties panel.
- **Grips:** Select the panel to see blue square grips.
    - **Corner Grips (0-4):** Drag to move the panel or adjust its length/position.
    - **Side Grip (5):** Drag to visually adjust the panel thickness.
- **Properties:** Select the panel and press `Ctrl+1` to open the Properties Palette. Enter exact values for Length, Thickness, and Depth.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | _DimStyles | Selects the dimension style format (e.g., decimal, architectural) used for the panel label. |
| Stack Id | text | X-999-999-999 | **Read-Only.** Displays the generated ID. If "X-999-999-999" appears, check your `mpStackLocation` map settings. |
| Show Panel Sizes | dropdown | Yes | Toggles the visibility of the text label displaying the panel length on the model. |
| Thickness | number | 127.5 mm | The width of the panel (cross-section). Changing this also scales the label text height. |
| Length | number | 1000.48 mm | The horizontal length of the panel. |
| Depth (Solid) | number | 3000.108 mm | The vertical height/extrusion of the panel. Set to `0` if you only require a 2D representation. |

## Right-Click Menu Options
This script does not add custom items to the right-click context menu. Use standard AutoCAD grips and the Properties palette for modifications.

## Settings Files
- **Filename:** `mpStackLocation` (Project Map)
- **Location:** Project Data / Model Space
- **Purpose:** Stores the logical location data (Prefix, Stack, Row, Place) to automatically generate unique Stack IDs for production lists.

## Tips
- **Quick Thickness Adjust:** Use Grip Point 5 to quickly drag the thickness to match another element visually.
- **2D Mode:** For large floor plans where 3D solids slow down performance, set the **Depth (Solid)** property to `0`. The script will draw only the 2D outline and cross-lines.
- **Text Scaling:** The size of the dimension label is automatically tied to the panel Thickness (50% of thickness, capped at 4mm). If the text is too small, increase the panel thickness.

## FAQ
- **Q: Why is my Stack ID "X-999-999-999"?**
  **A:** The script cannot find the `mpStackLocation` map in your project, or the map is missing the required keys. Check with your project manager to ensure the stack location setup has been run.
- **Q: Can I change the Stack ID manually?**
  **A:** No, this property is Read-Only to maintain data integrity with the production lists. You must update the project Map or use a different location to change the ID.
- **Q: How do I hide the dimension text?**
  **A:** Select the panel, open the Properties palette (`Ctrl+1`), and change **Show Panel Sizes** to "No".