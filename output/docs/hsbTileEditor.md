# hsbTileEditor

## Overview

The **hsbTileEditor** script is a utility launcher that opens the Roof Tile Editor interface within hsbCAD. This specialized tool provides a dedicated dialog window for configuring and managing roof tile layouts, textures, and mapping rules for timber roof constructions.

When executed, the script launches an external .NET dialog window (RoofTileInput.dll) that provides a comprehensive interface for defining and editing roof tile parameters. The script instance automatically removes itself after launching the editor, leaving no residual objects in the drawing.

> **Note:** This script is designated for hsbCAD internal use and may be called automatically by other roof tiling scripts in the hsbTile suite.

## Script Metadata

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Beams Required | 0 |
| Grip Points | 0 |
| Version | 1.1 |
| Insert Implementation | Yes |

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Standard environment for launching configuration utilities |
| Paper Space | No | Not intended for layout views |
| Shop Drawing | No | Not intended for production views |

## Prerequisites

- hsbCAD must be properly installed with the RoofTiles utility available
- The RoofTileInput.dll component must be present at:
  `[hsbCAD Install Path]\Utilities\RoofTiles\RoofTileInput.dll`
- No beams or elements need to be selected prior to running

## Usage

### Step 1: Launch the Script

**Command:** `TSLINSERT`

**Action:** Select `hsbTileEditor.mcr` from the TSL menu, toolbar, or file selection dialog.

### Step 2: Roof Tile Editor Opens

**Action:** The Roof Tile Editor dialog window opens automatically.

**Note:** The script instance erases itself immediately after launching the editor. This is normal behavior.

### Step 3: Configure Tile Settings

**Action:** Use the external interface to configure roof tile properties:
- Tile textures and materials
- Tile dimensions and overlaps
- Distribution patterns
- Mapping rules

### Step 4: Save and Exit

**Action:** Save your changes within the Roof Tile Editor and close the window. Your configuration is now updated for the current hsbCAD session.

## Parameters

This script does not expose any user-configurable OPM (Object Property Manager) parameters. All configuration is performed through the Roof Tile Editor dialog interface.

Since the script erases itself immediately after execution, there are no properties available in the Properties Palette for editing.

## Menu

This script does not include a right-click context menu. Since the script deletes itself upon running, it cannot be selected or right-clicked after execution. All interactions occur through the launched dialog window.

## Tips

- **Script Disappearance:** Do not be alarmed if the script seems to "disappear" immediately after insertion. This is intended behavior - the script only serves to open the external tool and then self-erases to keep your drawing clean.

- **Background Window:** If you run the script and nothing seems to happen, check your Windows taskbar. The Roof Tile Editor window may have opened in the background or behind other AutoCAD palettes. Use Alt+Tab to cycle through open windows.

- **Quick Access:** Add this script to your toolbar or ribbon for quick access when working on roof tile layouts.

- **Re-opening the Editor:** To edit settings after closing the window, simply run the script again. Each run creates a fresh instance that opens the editor.

- **Utility Location:** If you encounter issues launching the editor, verify that `RoofTileInput.dll` exists in the expected location under your hsbCAD installation at: `[InstallPath]\Utilities\RoofTiles\RoofTileInput.dll`

- **Integration with Roof Workflows:** This script is often called automatically by other hsbTile scripts (such as hsbTileMaster, hsbTileLath, hsbTileHipRidge). Manual invocation may not be necessary during normal roof tiling workflows.

## FAQ

**Q: I ran the script but nothing appeared.**

A: The script erases itself instantly. Check your taskbar for the "Roof Tile Input" application. If it is not there, ensure `RoofTileInput.dll` exists in your hsbCAD `Utilities\RoofTiles\` folder.

**Q: Can I edit the settings after I close the window?**

A: Yes, simply run the `hsbTileEditor.mcr` script again to reopen the utility.

**Q: Why does the script disappear from my drawing?**

A: This is by design. The script is a launcher utility only - it opens the Roof Tile Editor and then removes itself to keep your drawing clean.

## Technical Notes

- **.NET Integration:** The script uses `callDotNetFunction2()` to interface with the .NET RoofTileInput.dll assembly
- **Class Reference:** The editor is launched through the `hsbCad.Roof.TilingInput.Editor` class
- **Entry Point:** The function called is `LaunchRoofTileInput`
- **Self-Cleanup:** The script automatically calls `eraseInstance()` after the dialog closes
- **Insert Cycle Guard:** The script checks `insertCycleCount()` to prevent multiple executions during a single insert operation

## Related Scripts

The hsbTileEditor is part of the hsbCAD roof tiling suite. Related scripts include:

| Script | Purpose |
|--------|---------|
| hsbTileMaster | Master tile configuration and distribution |
| hsbTileLath | Tile lath/counter-batten layout |
| hsbTileHipRidge | Hip and ridge tile placement |
| hsbTileVerge | Verge tile configuration |
| hsbTileEdge | Edge tile settings |
| hsbTileStart | Start tile positioning |
| hsbTileSingle | Individual tile placement |
| hsbTileSpecial | Special tile configurations |

## Version History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.1 | 28 Sept 2016 | thorsten.huck@hsbcad.com | Adopted change of namespace |
| 1.0 | 24 Jun 2015 | thorsten.huck@hsbcad.com | Initial release |
