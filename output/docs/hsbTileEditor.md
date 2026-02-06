# hsbTileEditor.mcr

## Overview
This script serves as a utility launcher that opens the external "Roof Tile Editor" application. It allows you to configure roof tile definitions, textures, and mapping rules directly within the hsbCAD environment without navigating through file folders.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the standard environment for launching configuration utilities. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for generating production views. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings:** The external application file `RoofTileInput.dll` must be present in the `Utilities\RoofTiles\` folder of your hsbCAD installation.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `hsbTileEditor.mcr` from the file selection dialog and click Open.

### Step 2: External Editor Launch
**Action:** The script will immediately launch the "Roof Tile Input" (Roof Tile Editor) window.
**Note:** The script instance will automatically erase itself from the drawing immediately after launching the window.

### Step 3: Configure Settings
**Action:** Use the external interface to edit roof tile properties (e.g., textures, dimensions, overlaps).

### Step 4: Save and Exit
**Action:** Save your changes within the external utility and close the window. Your configuration is now updated for the hsbCAD session.

## Properties Panel Parameters
This script erases itself immediately after execution. Therefore, there are no properties available in the Properties Palette for editing.

## Right-Click Menu Options
None. Since the script deletes itself upon running, it cannot be selected or right-clicked after execution.

## Settings Files
- **Filename**: `RoofTileInput.dll`
- **Location**: `%hsbInstall%\Utilities\RoofTiles\`
- **Purpose**: This is the external application file that contains the Roof Tile Editor interface and logic.

## Tips
- **Script Disappearance:** Do not be alarmed if the script seems to "disappear" immediately after insertion. This is intended behavior; it only serves to open the tool.
- **Background Window:** If you run the script and nothing seems to happen, check your Windows taskbar to see if the Roof Tile Editor window opened in the background or behind other AutoCAD palettes.

## FAQ
- **Q: I ran the script but nothing appeared.**
  **A:** The script erases itself instantly. Check your taskbar for the "Roof Tile Input" application. If it is not there, ensure `RoofTileInput.dll` exists in your hsbCAD Utilities folder.

- **Q: Can I edit the settings after I close the window?**
  **A:** Yes, simply run the `hsbTileEditor.mcr` script again to reopen the utility.