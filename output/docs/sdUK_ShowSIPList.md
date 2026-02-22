# sdUK_ShowSIPList - SIP Panel List Generator

## Overview
The **sdUK_ShowSIPList** script generates a shop drawing list of SIP (Structural Insulated Panel) panels that share the same position number (Posnum). This tool is specifically designed for creating fabrication documentation in both model space and paper space environments.

**Script Location:** `TSL/sdUK_ShowSIPList.mcr`
**Author:** Chirag Sawjani
**Version:** 1.2 (as of 10.10.2018)

## Overview
Generates a text list of SIP (Structural Insulated Panel) panels that share the same position number for shop drawings. Designed for UK market workflows, this script helps fabricators quickly identify all panels with matching position numbers on a single drawing sheet. The panel names are displayed alphabetically for easy reference.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Directly select SIP entities from the model to generate a panel list. |
| Paper Space | Yes | Primary use case - works with ShopDrawView entities in shop drawing layouts. |
| Shop Drawing | Yes | Integrates with hsbCAD multipage shop drawing system via ViewData. |

## Prerequisites
- **Required entities**: SIP panels with assigned position numbers (posnum).
- **Minimum beam count**: 0 (operates on SIP entities, not beams).
- **Required settings files**: None.
- **Additional requirements**:
  - For shop drawing mode: A valid ShopDrawView entity containing SIP panel data.
  - Panels must have labels and sublabels properly assigned.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` -> Select `sdUK_ShowSIPList.mcr`

### Step 2: Configure Settings
```
Dialog: Script configuration dialog appears
Action: Adjust display color, dimension style, and heading text as needed.
```

### Step 3: Pick Insertion Point
```
Command Line: Pick a point for edge details
Action: Click to place the panel list location on your drawing. The list extends downward from this point.
```

### Step 4: Select Source
**For Model Mode:**
```
Command Line: Please select Elements
Action: Select one or more SIP panels directly from model space and press Enter.
```

**For Shopdraw Multipage Mode:**
```
Command Line: Select the view entity from which the module is taken
Action: Click on the ShopDrawView entity that contains the panels.
```

### Step 5: View Results
The script displays:
1. A heading line (customizable)
2. An alphabetically sorted list of all panels sharing the same position number
3. Each line shows the combined label + sublabel (e.g., "A1a", "A1b", "B2a")

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | PropString (dropdown) | Model | Choose "Model" for direct model space selection or "shopdraw multipage" for shop drawing viewport mode. |
| Dim Style | PropString (dropdown) | (Drawing default) | Select the dimension style to control text appearance, font, and height. |
| Color | PropInt | 1 (Red) | Set the display color for the list text using AutoCAD Color Index (ACI). |
| Panel list heading: | PropString | "Panel List:" | Customize the heading text displayed above the panel list. |

### Parameter Details

**Drawing space**
- **Model**: Prompts you to select SIP entities directly from the model.
- **shopdraw multipage**: Uses the linked ShopDrawView entity to find associated SIP panels automatically through the ViewData system.

**Dim Style**
The selected dimension style determines:
- Text height
- Font style
- Line spacing between entries (text height + 20mm)

**Color**
Standard AutoCAD Color Index values:
- 1 = Red (default)
- 2 = Yellow
- 3 = Green
- 7 = White/Black (depends on background)

## Right-Click Menu Options
This script does not define custom context menu items. Standard TSL context menu options apply.

## Settings Files
- **Filename**: None used.

## Tips
- **Position Number Grouping**: The script automatically finds all SIP panels sharing the same position number as the first selected/detected panel. This is useful for showing panel counts and identifying identical fabrication units.

- **Alphabetical Sorting**: Panel names are sorted alphabetically, making it easy to locate specific panels in large lists.

- **Text Spacing**: The list uses your dimension style's text height plus a 20mm gap between lines. Choose a dimension style with appropriate text height for your drawing scale.

- **Empty Collections**: If the selected panel has a unique position number (no other panels share it), only that single panel's label will be displayed.

- **Automatic Updates**: If panels are added or removed from the model, or if position numbers change, the list automatically updates when the drawing regenerates.

- **Label Format**: The displayed name combines the panel's main label with its sublabel (e.g., "A1" + "a" = "A1a"). Ensure your panels have proper labeling before generating the list.

- **Invalid ViewData**: In shop drawing mode, if no valid ViewData is found for the selected viewport, the script displays only the script name as a placeholder.

## FAQ
- **Q: Why is only the script name showing instead of my panel list?**
  - A: In shopdraw multipage mode, this occurs when the selected ShopDrawView has no valid ViewData. Ensure the view entity is properly linked to model data.

- **Q: How do I change the list heading?**
  - A: Select the script instance, open Properties (Ctrl+1), and modify the "Panel list heading:" parameter.

- **Q: Can I list panels from multiple position numbers?**
  - A: No, the script groups panels by a single position number. Run the script multiple times for different position number groups.

- **Q: Why are some panels missing from the list?**
  - A: The script only shows panels with matching position numbers. Verify that all expected panels have the same posnum value assigned.

- **Q: Why are there more panels in my list than I selected?**
  - A: The script is designed to group panels by their Position Number. If you select one panel from a group, the script finds and lists every panel in the current model that shares that Position Number.

- **Q: The text is too small to read.**
  - A: Change the **Dim Style** property to a style that uses a larger text height, or modify the text height in your AutoCAD dim style settings.
