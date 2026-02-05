# NA_WALL_TAG.mcr

## Overview
This script automatically creates 3D annotation tags for selected walls in the model. It displays user-configurable wall information (such as Code, Number, or Description) and draws a visual projection of the wall outline directly in the 3D view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment and attaches to ElementWall objects. |
| Paper Space | No | Not intended for 2D drawings or layouts. |
| Shop Drawing | No | This is a modeling tool, not a manufacturing detailing script. |

## Prerequisites
- **Required Entities:** `ElementWall` entities must exist in the model.
- **Minimum Beam Count:** 0 (This script is not beam-dependent).
- **Required Settings:** A DimStyle named 'ARIAL' is recommended by default, though any available DimStyle can be selected.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_WALL_TAG.mcr`

### Step 2: Configure Tag Settings
```
Dialog: Dynamic Properties Dialog
Action: A dialog will appear automatically. Configure the visual style, text content (Info Left/Right), and DimStyle.
```
*Note: You can change these settings later via the Properties Palette.*

### Step 3: Select Walls
```
Command Line: Select a set of elements
Action: Click on the walls in the model you wish to tag. Press Enter to confirm selection.
```
*The script will automatically generate a tag for each selected wall and erase the original command instance.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | ARIAL | Selects the CAD text style (font) used for the label. |
| Text Height. If 0 uses DimStyle | number | 3.75 | Sets the height of the text in inches. If set to 0, the height is defined by the selected DimStyle. |
| Style | dropdown | 1 | Selects the visual appearance of the tag (border shape and arrow type). Options are `1` or `2`. |
| Info Left | dropdown | Code | Selects the wall property to display on the left side of the tag (e.g., Code, Number, Description). |
| Info Right | dropdown | Number | Selects the wall property to display on the right side of the tag. |
| Seperator | text | [empty] | Enter a character or string to separate the Left and Right information (e.g., " - ", "/"). |

## Right-Click Menu Options
*Note: This script does not add custom items to the right-click context menu. All modifications are handled via the Properties Palette and Grip Points.*

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external settings files; all configuration is stored in the script instance properties.

## Tips
- **Moving Tags:** Click the tag to select it. Use the blue **Grip Point** to drag the label. The label will automatically snap to the nearest "Zone" projection line relative to the wall.
- **Xref Handling:** If you tag a wall inside an Xref, the script automatically manages the group assignment to ensure the tag displays correctly with the external reference.
- **Quick Updates:** To change the label content (e.g., switch from displaying "Code" to "Description"), select the tag and change the **Info Left** or **Info Right** properties in the Properties Palette. The text updates immediately.
- **Visual Styles:** Use **Style 1** for a polygon border or **Style 2** for a rectangular border with a chevron arrow.

## FAQ
- **Q: What happens if I delete the wall?**
  - **A:** The tag is linked to the wall. If the wall is deleted, the script instance will automatically erase itself.
- **Q: Why is my text too small or too large?**
  - **A:** Check the **Text Height** property. If it is set to 0, the script uses the text height defined in the selected **DimStyle**. Adjust either the property value or the DimStyle settings in the CAD standard manager.
- **Q: Can I tag multiple walls at once?**
  - **A:** Yes. During the insertion step, you can window-select or click multiple walls. The script generates a separate tag instance for each selected wall.