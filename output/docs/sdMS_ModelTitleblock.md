# sdMS_ModelTitleblock.mcr

## Overview
This script creates a dynamic title block in Model Space that displays project information (such as scale, date, or project number) linked to a specific Multipage Shop Drawing. It reads property placeholders from a user-defined block definition to generate the layout automatically.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is intended for use in Model Space. |
| Paper Space | No | Not supported for Paper Space usage. |
| Shop Drawing | Yes | Extracts data from `HSBCAD_MULTIPAGE` entities. |

## Prerequisites
- **Required Entities**: A `HSBCAD_MULTIPAGE` entity must exist in the drawing.
- **Block Definition**: A Block must exist containing `sd_PropertySetDisplay` instances configured for **Model Title Block** mode.
- **Minimum Beam Count**: 0 (This script is annotation-based).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or via hsbCAD menu) → Select `sdMS_ModelTitleblock.mcr`

### Step 2: Select Multipage
```
Command Line: Select multipage
Action: Click on the desired HSBCAD_MULTIPAGE entity in the drawing.
```
*Note: If you select an invalid entity or nothing, the script will display a warning and cancel the insertion.*

### Step 3: Verify Placement
The script will automatically generate the title block at the origin of the selected multipage. It reads the settings from the block defined in the properties panel to determine which text to display.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Block | text | _BlockNames | The name of the block definition that serves as the title block template. This block must contain `sd_PropertySetDisplay` scripts set to "Model Title Block" mode. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard) | No specific custom menu items are added by this script. Standard recalculation options apply. |

## Settings Files
- **None**: This script does not rely on external settings files.

## Tips
- **Update Data**: If you modify the shop drawing or the elements within it, the title block will update automatically to reflect changes (e.g., updated dates or dimensions).
- **Custom Layout**: To change the look of your title block, do not edit the script instance directly. Instead, use the AutoCAD `BEDIT` command to modify the block definition specified in the "Block" property.
- **Placement**: Ensure the `sd_PropertySetDisplay` scripts inside your title block are set to **DisplayMode: Model Title Block**. If they are set to "Multipage" mode, this script will ignore them.

## FAQ
- **Q: Why did the script disappear immediately after I selected the multipage?**
  A: The script will erase itself if the Block specified in the properties does not exist, or if that block does not contain any `sd_PropertySetDisplay` instances set to "Model Title Block" mode. Check your block definition and property settings.

- **Q: Can I move the title block after inserting it?**
  A: Yes, you can move the script instance using standard AutoCAD move commands. However, the content is generated relative to the block definition's geometry.

- **Q: How do I change which project properties are shown?**
  A: You need to edit the Block Definition (e.g., using `BEDIT`). Inside the block, select the `sd_PropertySetDisplay` instances and change their property mappings via the Properties Palette.