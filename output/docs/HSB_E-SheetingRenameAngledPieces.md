# HSB_E-SheetingRenameAngledPieces.mcr

## Overview
This script identifies rectangular sheeting panels within a specific construction zone that are installed at an angle (non-orthogonal). It automatically renames these angled panels and updates their material properties, labels, and visual color to distinguish them from standard sheeting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script processes 3D Element entities and their sheets. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: An Element (e.g., a wall or roof) containing sheeting.
- **Minimum Beam Count**: 0 (Script acts on sheets attached to elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_E-SheetingRenameAngledPieces.mcr`.

### Step 2: Configure Properties
1. The **Properties** dialog (or palette) will appear automatically.
2. Set the **Zone** number to match the layer index where your sheeting is located (default is 5).
3. Enter the desired **Name**, **Material**, **Grade**, and **Labels** you want applied to the angled pieces.
4. (Optional) Change the **Color** to make modified pieces visually distinct.
5. Click **OK** to proceed.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Element(s) (e.g., Roof or Wall) containing the sheeting you wish to process. Press Enter to confirm selection.
```
*The script will automatically scan the chosen zone of the selected elements, identify angled panels, and update their properties.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 5 | The construction zone index within the element to search for sheeting (Range 0-10). |
| Name | text | | The new Name attribute assigned to angled sheets. |
| Material | text | | The material designation (e.g., 'OSB', 'PLYWOOD'). |
| Grade | text | | The structural grade or quality class of the sheeting. |
| Information | text | | Additional descriptive text or comments. |
| Label | text | | The primary label text for drawings. |
| SubLabel | text | | The secondary label text. |
| SubLabel2 | text | | The tertiary label text. |
| Beam code | text | PANLATS | A code for production lists. **Note:** This value is hardcoded to "PANLATS" by the script logic, regardless of user input. |
| Color | number | 82 | The CAD display color index (0-255) used to visually highlight angled sheets. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu items are added by this script. Standard TSL recalculation applies. |

## Settings Files
- None required.

## Tips
- **Zone Selection**: If the script seems to do nothing, verify that your sheeting is actually in the **Zone** specified in the properties. Many elements use Zone 0 or Zone 5 by default.
- **Visual Verification**: Set the **Color** to a bright color (like Red or Magenta) initially. This allows you to instantly see which panels were identified as "angled" in the 3D model.
- **Beam Code Limitation**: Do not rely on the **Beam code** property to change the code; the script is designed to force the code "PANLATS" for all detected angled pieces.

## FAQ
- **Q: Why didn't my standard rectangular sheets get renamed?**
  A: The script specifically targets "angled" pieces. It calculates the internal angles of the sheets; if all corners are 90 degrees, the sheet is considered standard and ignored.
- **Q: Why is the Beam Code always "PANLATS" even if I type something else?**
  A: The script logic contains a hardcoded command to set the Beam Code to "PANLATS" for any piece it identifies as angled. This overrides any value you type in the properties panel.