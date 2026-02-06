# sd_ModelTslCreator.mcr

## Overview
This script serves as a configuration anchor within a multipage layout block. It automatically generates specified TSL instances (such as drill pattern dimensions) in Model Space whenever a shop drawing is generated.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No (Output Only) | The script inserts into Paper Space but generates geometry into Model Space. |
| Paper Space | Yes | Specifically inside the block definition of a Multipage. |
| Shop Drawing | Yes | The script triggers specifically during shop drawing generation. |

## Prerequisites
- **Required Entities:** The multipage block must contain at least one `ShopDrawView` (shopdrawing viewport).
- **Minimum Beam Count:** 0.
- **Required Settings:** A valid Catalog entry for the selected target script.

## Usage Steps

### Step 1: Enter Multipage Block
Action: Right-click on the multipage layout border and select "Block Editor" or use the `BEDIT` command to open the block definition containing the shop drawing viewports.

### Step 2: Insert Script
Command: `TSLINSERT` → Select `sd_ModelTslCreator.mcr`

### Step 3: Select Placement Point
```
Command Line: |Pick point to place setup info|
Action: Click a location in the layout to place the configuration label.
```
*Note: This point defines where the setup text is displayed in the layout.*

### Step 4: Configure Properties
Action: With the script instance selected, open the **Properties Palette** (Ctrl+1).
1.  **Script**: Select the tool you want to run (e.g., `DrillPatternDimension`).
2.  **Catalog Entry**: Select the specific preset configuration for that tool.

### Step 5: Generate Shop Drawing
Action: Close the block editor and generate the shop drawing. The script will automatically create the selected geometry (e.g., dimensions) in the 3D model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Script | Dropdown | (First available) | Selects the TSL tool to execute in the model (e.g., DrillPatternDimension). Options include scripts starting with 'sdMS_'. |
| Catalog Entry | Dropdown | _Default | Selects the preset configuration from the catalog that defines the properties (size, layer, etc.) for the selected script. |

## Right-Click Menu Options
*(No custom context menu options defined for this script)*

## Settings Files
*(No specific settings file defined for this script; it relies on catalogs associated with the target scripts)*

## Tips
- **Error Handling:** If you see a message "Tool will not be inserted," ensure you are editing the block definition of a multipage that contains shop drawing viewports.
- **Visual Feedback:** A text label appears in the layout showing the selected Script and Entry. You can move this label using its grip point.
- **Updates:** You can change the 'Script' or 'Catalog Entry' properties at any time. The changes will apply the next time the shop drawing is generated.

## FAQ
- **Q: I inserted the script, but I don't see any dimensions in the model?**
  **A:** This script works during the shop drawing generation process. You must generate the shop drawing for the script to create the model space entities.
- **Q: Where should I insert this script?**
  **A:** It must be inserted inside the block definition of the multipage layout, not directly in the main drawing Paper Space.
- **Q: What does the "Pick point" do?**
  **A:** It determines where the text label is drawn in your layout to show you which configuration is active.