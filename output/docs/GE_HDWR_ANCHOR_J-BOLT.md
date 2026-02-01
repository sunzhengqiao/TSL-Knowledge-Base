# GE_HDWR_ANCHOR_J-BOLT.mcr

## Overview
This script generates the 3D representation of a J-Bolt concrete anchor, including the threaded rod, J-hook, nut, and square plate washer. It is intended to be inserted programmatically by other hardware systems (such as column bases or beam end macros) rather than manually by the user.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the 3D hardware model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: None (typically controlled by a parent script).
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Manual Insertion Attempt
```
Command Line: TSLINSERT
Action: Selecting GE_HDWR_ANCHOR_J-BOLT.mcr manually will trigger an error message.
Result: The script will display a warning ("This TSL has not yet a manual insertion defined...") and automatically erase itself.
```
**Note**: This script is designed to be launched by other scripts using Map Directives. To use this component, run the parent script (e.g., a column base or connector macro) that calls this anchor.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Anchor type | dropdown | 1/2 J_Bolt | Selects the nominal diameter of the J-Bolt. Options: 1/2 J_Bolt, 5/8 J_Bolt, 7/8 J_Bolt. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None available) | This script does not define custom right-click context menu options. |

## Settings Files
(None defined in the source analysis)

## Tips
- **Programmatic Use**: Do not attempt to insert this script directly via the command line. It functions as a sub-component for other hsbCAD elements.
- **Editing Properties**: If the script is inserted by a parent system that allows configuration, you can select the anchor in the model and change the "Anchor type" via the Properties Palette (Ctrl+1).
- **Visibility**: Depending on the parent script settings, the nut and washer may be hidden, showing only the rod.

## FAQ
- **Q: Why does the script disappear immediately when I try to insert it?**
  - A: This script does not support manual insertion. It is designed to be called automatically by other macros to ensure correct positioning and data linkage.

- **Q: How do I change the bolt size?**
  - A: Select the J-Bolt object in the drawing, open the Properties Palette, and select a different size from the "Anchor type" dropdown list, provided it is not locked by the parent script.