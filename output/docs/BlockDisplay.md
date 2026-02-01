# BlockDisplay.mcr

## Overview
This script allows you to insert graphical blocks (DWG details or symbols) into your model. It dynamically lists blocks found in the `C:\Temp\Blocks` folder and internal CAD definitions, letting you place them at a specific point in Model Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Blocks are inserted at coordinates selected by the user. |
| Paper Space | No | This script is not designed for layout views. |
| Shop Drawing | No | This script does not generate manufacturing views. |

## Prerequisites
- **Directory:** A folder named `Blocks` must exist at `C:\Temp\Blocks`.
- **Content:** The folder must contain `.dwg` files you wish to use as blocks.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `BlockDisplay.mcr` from the file list.

### Step 2: Select Block Type
```
Interface: Properties Palette (OPM)
Action: Locate the "Block names" parameter. Click the dropdown menu and select the desired block from the list.
```
*Note: The list is generated from files found in `C:\Temp\Blocks` and internal CAD definitions.*

### Step 3: Place Block
```
Command Line: Select insertion point
Action: Click in the Model Space to set the location for the block's origin.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Block names | Dropdown | (First available) | Selects the specific DWG file or definition to display. Changing this swaps the geometry at the current location. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom options are added to the context menu. |

## Settings Files
- **Filename**: `*.dwg` (Any DWG file)
- **Location**: `C:\Temp\Blocks`
- **Purpose**: Provides the list of available graphical blocks to insert. Ensure your library files are stored here.

## Tips
- **Swapping Blocks:** You can change the displayed block after insertion by selecting the object, opening the Properties palette, and choosing a different name from the "Block names" dropdown.
- **Internal Blocks:** If a block name exists both inside the drawing and in the `C:\Temp\Blocks` folder, the script prioritizes the internal drawing definition.
- **Moving:** Use the grip point at the insertion location to move the block around the model.

## FAQ
- **Q: I don't see my blocks in the list.**
- **A:** Ensure the folder `C:\Temp\Blocks` exists on your computer and contains valid `.dwg` files. If the folder is missing, only internal definitions will appear.
- **Q: Can I type a custom block name?**
- **A:** No. You must select from the dropdown list to ensure the script can find the corresponding file path.
- **Q: How do I rotate the block?**
- **A:** Use standard AutoCAD rotation commands (e.g., `ROTATE`) on the inserted object, or rotate your UCS (User Coordinate System) before insertion.