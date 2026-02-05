# HSB_G-ToolingInformation.mcr

## Overview
This script generates a 2D schedule (table) summarizing the total count and types of nails (tooling) used in your project. It calculates quantities based on NailLines found in your Elements and displays the results either broken down by each Element or as a single summary for the entire project.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted into the Model Space to collect Element data. |
| Paper Space | No | This script does not function in Paper Space. |
| Shop Drawing | No | This is not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: Elements (Walls/Floors) containing NailLines.
- **Minimum Beam Count**: 0 (Based on Element data).
- **Required Settings**: Dimension Styles (must exist in the drawing to use the `sDimStyle` parameter effectively).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `HSB_G-ToolingInformation.mcr`.
3.  Click in the Model Space to set the insertion point (`_Pt0`) for the top-left corner of the table.

### Step 2: Configure Properties
1.  Select the script object in the drawing.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust parameters (see below) to change the report scope (Per element vs. Entire project) and visual styles.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Content | Dropdown | Per element | Determines the report structure. Choose **"Per element"** for a detailed list for each wall/floor, or **"Entire project"** for a single aggregated total. |
| Dimension style | Dropdown | (Current) | Selects the CAD Dimension Style to control text font and formatting standards. |
| Text size | Number | -1 | Sets the text height. If set to 0 or negative (default), the height defined in the selected Dimension Style is used. |
| Line color | Number | 1 | Sets the CAD Color Index (1-255) for the table grid lines. |
| Text color | Number | 1 | Sets the CAD Color Index (1-255) for the table text content. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the table data if the model (NailLines/Elements) has changed. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal logic and standard CAD Dimension Styles; no external settings files are required.

## Tips
- **Formatting Control**: To ensure the table matches your drawing standards, create a specific Dimension Style (e.g., "Annotation") before inserting the script, then select it in the `Dimension style` property.
- **Scaling**: If the text appears too small or too large, adjust the `Text size` property. Set it to `0` to revert to the Dimension Style's default text height.
- **Data Accuracy**: Ensure your NailLines are correctly assigned to Elements (typically on layers -5 to 5). If a nail type shows as "Unknown," the tool index used in the NailLine is not defined in the script's internal lookup list.
- **Placement**: Place the script in an open area of Model Space, as the table height will grow depending on the number of nails found.

## FAQ
- **Q: Why is my table empty?**
  **A:** The script searches for NailLines within Elements. Ensure Elements exist in the model and that NailLines are generated/visible on the correct layers.
- **Q: How do I switch between a detailed list and a summary?**
  **A:** Select the table, open the Properties Palette, and change the **Content** dropdown from "Per element" to "Entire project".
- **Q: What does the default Text size of -1 do?**
  **A:** It tells the script to ignore the manual size setting and instead use the text height defined inside the selected Dimension Style.