# HSB_I-ShowElementQuantity.mcr

## Overview
This script creates a text annotation in the 3D model that displays the quantity count of a selected construction element (such as a wall or floor panel). It helps visualize how many times a specific element is used in the project directly in the model view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not supported for 2D drawings. |
| Shop Drawing | No | Not supported for shop drawings. |

## Prerequisites
- **Required Entities**: An existing Element (Wall, Floor, or Roof) in the model.
- **Minimum Beam Count**: 0 (This script works on Elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_I-ShowElementQuantity.mcr` from the list.

### Step 2: Configure Properties
- **Action**: If you are not using a pre-set catalog entry, a dialog will appear.
- **Settings**:
  - Enter a **Prefix** if desired (e.g., "Qty: " or "No. ").
  - Select a **Dimension style** to control the text appearance.
  - Set specific **Text size** and **Text color** if you want to override the dimension style defaults (leave as -1 to use defaults).
- Click **OK** to proceed.

### Step 3: Select Element
```
Command Line: Select elements
Action: Click on the desired Wall, Floor, or Roof element in the drawing area.
```
- Select one or multiple elements to label.
- Press **Enter** or **Right-Click** to confirm selection.

### Step 4: Placement
- The script will automatically generate a text label at the origin (insertion point) of the selected element(s).
- The label will display the element's quantity (e.g., "Qty: 2").

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Prefix | text | | Custom text added before the quantity number (e.g., "Qty: "). |
| Dimension style | dropdown | _DimStyles | The CAD standard style that defines the font and line type for the text. |
| Text size | number | -1 | The height of the text. Enter a value in mm, or leave as -1 to use the Dimension style default. |
| Text color | number | -1 | The color of the text (AutoCAD Color Index). Leave as -1 to use the Dimension style default. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom options to the right-click menu. Use the Properties palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (This script relies on standard CAD Dimension Styles).

## Tips
- **Prefix Usage**: Use the "Prefix" property to distinguish between different types of labels in the same model (e.g., "Walls: " vs "Floors: ").
- **Visibility**: If the text is too small to see, increase the **Text size** property or check your current view zoom level.
- **Movement**: The label is assigned to the Element. If you move the element using grips or the Move command, the label will move with it automatically.
- **Style Consistency**: Keep **Text size** and **Text color** set to -1 to ensure your labels automatically update if you change your project's global Dimension style.

## FAQ
- **Q: Where exactly is the label placed?**
  A: The label is placed at the element's origin (elOrg), which is usually the insertion point defined when the element was created or drawn.
- **Q: Can I change the text after inserting it?**
  A: Yes. Select the label in the model, open the **Properties (OPM)** palette, and modify the "Prefix" or other style settings. The label will update immediately.
- **Q: What does "-1" mean for size and color?**
  A: A value of -1 tells the script to ignore the manual setting and use whatever is defined in the selected "Dimension style". This is useful for maintaining consistent drafting standards.
- **Q: The number is wrong. How do I fix it?**
  A: The script displays the internal quantity of the Element. You must modify the Element properties (e.g., in hsbCAD Element Manager) to change the actual quantity; the label will update automatically.