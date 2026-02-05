# HSB_I-ShowElementInfo.mcr

## Overview
This script creates informational labels for timber elements (Walls, Roofs, and Floors) directly in the 3D model. It displays data such as Element Type, Code, Number, Dimensions, and user-defined custom notes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates within the 3D model environment. |
| Paper Space | No | Not intended for 2D layout sheets. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (Wall, Roof, or Floor).
- **Minimum Beam Count**: None (Script attaches to Elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `HSB_I-ShowElementInfo.mcr` from the list.

### Step 2: Configure Properties
1. The **Properties** dialog (or the AutoCAD Properties Palette) will appear.
2. Adjust settings such as **Text Size**, **Text Color**, and which information fields to display (Type, Code, Number).
3. Click **OK** to confirm.

### Step 3: Select Elements
1. The command line will prompt: `Select elements`
2. Click on the desired Wall, Roof, or Floor element in your drawing.
3. Press **Enter** to confirm selection.

### Step 4: Position Label
1. The script will generate the text label at the element's center.
2. Click the **Square Grip** (_PtG) on the text to drag it to a clear location.
3. (Optional) If **Show Pointer** is enabled, a leader line will connect the text to the element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element Type | String (Yes/No) | Yes | Shows the category (e.g., Wall, Roof). |
| Element Code | String (Yes/No) | Yes | Shows the unique Element Code. |
| Element Number | String (Yes/No) | Yes | Shows the Element Number (sorting index). |
| Custom Text | String | Empty | Allows user notes. Use a semicolon (;) to start a new line. |
| Show Definition | String (Yes/No) | No | Shows the internal construction definition name. |
| Show Quantity | String (Yes/No) | No | Shows the quantity of the element. |
| Show Envelope | String (Yes/No) | No | Draws the physical bounding box outline of the element. |
| Show Pointer | String (Yes/No) | No | Draws a leader line from the element to the text. |
| Visible On Top View Only | String (Yes/No) | No | If Yes, hides the label when viewing in 3D or elevation. |
| Invert Order | String (Yes/No) | No | Stacks text lines upwards instead of downwards. |
| Alignment | String (Centered/Right/Left) | Centered | Sets the justification of the text block. |
| DimStyle | String | Current | Selects the Dimension Style for font appearance. |
| Text Size | Double | 100 | Sets the height of the text in model units. |
| Text Color | Integer | 0 | Sets the CAD Color Index (0-255) for the text and lines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the label to reflect changes in the Element's geometry or updated properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not require external settings files. It remembers the last used settings automatically via the `_LastInserted` catalog.

## Tips
- **Multi-line Notes**: To write multiple lines in the **Custom Text** property, type a semicolon `;` where you want the line break (e.g., `Check height;Crane required`).
- **Moving Text**: Always use the square grip point on the text to move it. The leader line (if active) will automatically adjust.
- **Plan Labels**: Set **Visible On Top View Only** to **Yes** if you only want these labels cluttering your plan views and not your 3D presentation views.
- **Auto-Correction**: If you drag the text grip too close to the element center, the script will automatically push it away slightly to ensure readability.

## FAQ
- **Q: Why did my label disappear?**
  - A: The script erases itself automatically if it is not attached to exactly one valid Element. Check if you deleted the element or if the selection filter picked up multiple objects during insertion.

- **Q: How do I change the text size after inserting?**
  - A: Select the text label, open the **Properties Palette** (Ctrl+1), and modify the **Text Size** value. Then run **Recalculate** from the right-click menu.

- **Q: Can I use this for beams?**
  - A: No, this script is designed specifically for hsbCAD Elements (Wall/Roof/Floor entities).

- **Q: The text is too small in my plan view.**
  - A: Increase the **Text Size** parameter. If your plan view uses a detail scale (e.g., 1:50), you may need to increase the text size significantly (e.g., to 200 or 500) to appear legibly when plotted.