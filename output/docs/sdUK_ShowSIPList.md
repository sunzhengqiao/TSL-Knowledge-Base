# sdUK_ShowSIPList.mcr

## Overview
This script generates a sorted schedule of Structural Insulated Panel (SIP) labels. It allows you to create a list of panels either by manually selecting them in the model or by automatically extracting them from a specific shop drawing view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select panels directly using the "Model" mode. |
| Paper Space | Indirectly | Use "shopdraw multipage" mode to select a view frame. |
| Shop Drawing | Yes | Specifically supports "shopdraw multipage" environments. |

## Prerequisites
- **Required Entities**: Structural Insulated Panels (SIPs) must exist in the drawing. If using Shop Draw mode, a valid Shop Drawing View must be present.
- **Minimum Selection**: At least one SIP (Model mode) or one View (Shop Draw mode).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sdUK_ShowSIPList.mcr` from the list.

### Step 2: Configure Properties
Before insertion, the Properties Palette (OPM) will display.
1.  Set the **Drawing space** property to `|Model|` (for 3D model selection) or `|shopdraw multipage|` (for drawing views).
2.  Adjust the **Dim Style**, **Color**, and **Panel list heading** as desired.

### Step 3: Insertion Point
```
Command Line: Pick a point for edge details
Action: Click in the drawing where you want the top-left corner of the list to appear.
```

### Step 4: Select Source (Mode Dependent)
The next prompt depends on the **Drawing space** property selected in Step 2.

**If "|Model|" is selected:**
```
Command Line: Please select Elements
Action: Click on one or more SIP panels in the model and press Enter.
```
*Note: The script will use the first selected panel to find all other panels in the model with the same Position Number.*

**If "|shopdraw multipage|" is selected:**
```
Command Line: Select the view entity from which the module is taken
Action: Click on the border/frame of the Shop Drawing View containing the panels.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | *None* | Determines the selection method. Choose `|Model|` to pick panels directly, or `|shopdraw multipage|` to select a view frame. |
| Dim Style | dropdown | *Current* | Selects the dimension style (font, text height) to apply to the generated list text. |
| Color | number | 1 | Sets the AutoCAD color index (1-255) for the text. (1 = Red). |
| Panel list heading | text | Panel List: | The title text displayed at the very top of the generated list. |

## Right-Click Menu Options
No specific custom context menu options are defined for this script.

## Settings Files
No external settings files are required for this script.

## Tips
- **Smart Grouping**: You do not need to select every single individual panel if they belong to the same assembly. The script detects the Position Number of your selection and automatically includes all panels in the model that share that number.
- **Sorting**: The list is automatically sorted alphabetically to ensure consistency in your drawings.
- **Text Appearance**: Ensure your chosen **Dim Style** is sized appropriately for the scale of your drawing so the list is legible.

## FAQ
- **Q: Why are there more panels in my list than I selected?**
  **A**: The script is designed to group panels by their Position Number. If you select one panel from a group, the script finds and lists every panel in the current model that shares that Position Number.

- **Q: Can I use this in a layout (Paper Space) directly?**
  **A**: You should use the "shopdraw multipage" mode. This allows you to select a view frame, and the script will extract the relevant panel data from that view to generate the list.

- **Q: The text is too small to read.**
  **A**: Change the **Dim Style** property to a style that uses a larger text height, or modify the text height in your AutoCAD dim style settings.