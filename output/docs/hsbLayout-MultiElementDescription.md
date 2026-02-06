# hsbLayout-MultiElementDescription.mcr

## Overview
This script automatically labels the individual component parts (such as studs or rafters) of a Multi-Element (e.g., a wall or roof panel) directly on the 2D Layout view. It is used to identify specific elements for assembly and logistics on production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Layout (Paper Space) only. |
| Paper Space | Yes | The script requires the selection of a Viewport. |
| Shop Drawing | Yes | Designed for annotating manufacturing drawings. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is linked to a Multi-Element (e.g., an hsbCAD Wall or Roof assembly).
- **Minimum beam count**: 0 (The script analyzes existing elements, it does not create them).
- **Required Settings**: At least one Dimension Style (Dimstyle) must be defined in the AutoCAD drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayout-MultiElementDescription.mcr`

### Step 2: Select Viewport
```
Command Line: |Select a viewport|
Action: Click on a viewport in your layout that displays a wall or roof panel.
```

### Step 3: Set Label Position
```
Command Line: [Point prompt]
Action: Click a location in the layout to define the insertion point. This point determines the alignment of the element numbers relative to the view.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | Dropdown | (Current Dimstyle) | Selects the drafting standard (Dimstyle) to define the visual appearance of the labels (font, color, line type). |
| Text Height | Number | 0 | Defines the physical height of the text labels. <br>• **0**: Uses the text size defined in the selected Dimstyle.<br>• **>0**: Uses this specific value (in mm) for the text size, overriding the Dimstyle. |

## Right-Click Menu Options
No custom context menu options are available for this script.

## Settings Files
No external settings files are required for this script.

## Tips
- **Consistency**: Keep the **Text Height** set to `0` to ensure your labels automatically match the text size settings of your chosen Dimension Style.
- **Readability**: If your plot scale is very small, manually setting a larger **Text Height** (e.g., 2.5mm or higher) can make element numbers easier to read on paper.
- **Updating Labels**: If you modify the source wall or roof in Model Space (e.g., add or remove studs), the labels in the Layout will automatically update to reflect the new geometry.

## FAQ
- **Q: Why does nothing appear when I run the script?**
  A: Ensure the Viewport you selected is linked to a valid **Multi-Element** (composite wall/roof). The script does not work on single beams or empty viewports.
  
- **Q: How do I change the font of the numbers?**
  A: Change the **Dimstyle** property in the Properties Palette to a Dimstyle that uses your desired font.

- **Q: Can I move the numbers after placing them?**
  A: The numbers are generated based on the geometry of the elements. To move the entire group, select the script instance in the layout and move the insertion point. To move individual numbers, you would need to explode or edit the generated text entities manually.