# hsbDebugController

## Overview
This is a development utility tool that allows users to dynamically activate "Debug Mode" for specific TSL scripts within the project. It creates a visual controller in the model that links to target scripts, enabling trace execution and message reporting without editing source code.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in Model Space to function. |
| Paper Space | No | Not designed for Paper Space usage. |
| Shop Drawing | No | Not designed for Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: None required to run. However, existing TSL instances (timber scripts) are needed to be targeted for debugging.
- **Minimum Beam Count**: 0
- **Required Settings**: The script automatically creates/updates a project setting entry (`hsbTSLDebugController`) in the background to store the list of active scripts.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDebugController.mcr` from the catalog.

### Step 2: Select Target Scripts
```
Command Line: Select tsl(s)
Action: Do one of the following:
1. Pick one or more existing TSL instances (scripts) in your drawing to add them to the debug list.
2. Press Enter to open the Properties Palette and select a script name from the full project catalog.
```

### Step 3: Place Controller
```
Command Line: Specify insertion point
Action: Click in the Model Space to place the Debug Controller symbol.
```
*(Note: If you selected scripts via the Properties Palette, the script will automatically refresh itself at this point.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Script Name | Dropdown | *(empty)* | A list of all TSL scripts currently loaded in the catalog. Select the script you wish to debug. This is primarily used if you pressed Enter during the "Select tsl(s)" prompt. |
| Show Relation | Boolean | False | When set to **True**, draws 3D lines connecting the controller to the origin of every instance currently being debugged. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove ByEntity | Prompts you to pick TSL instances in the model. If picked, they are added to the debug list; if picked again, they are removed. |
| Add/Remove ByIndex | Displays a numbered list of all loaded scripts on the command line. Type the index number to toggle that script in the debug list. |
| Show Relation | Toggles the visual 3D lines (connectors) between the controller and the active script instances on or off. |
| Erase All Instances of [ScriptName] | (Dynamic Item) Deletes all instances of a specific script currently listed in the debug menu from the model. |
| Reset + Erase | Clears the debug list from the project settings and deletes the controller instance. |

## Settings Files
- **Internal Storage**: `hsbTSLDev/hsbTSLDebugController`
- **Location**: Project Data / MapObject
- **Purpose**: Stores the list of script names currently active for debugging so the setting persists across CAD sessions.

## Tips
- **Visual Troubleshooting**: Enable **Show Relation** to quickly see where all instances of a specific script are located in your 3D model. The lines point from the controller to the origin of each debugged instance.
- **Batch Cleanup**: Use the **Erase All Instances** right-click option to quickly delete all occurrences of a specific test script (e.g., temporary wall layouts) without selecting them manually.
- **Double-Click**: Double-clicking the controller acts as a shortcut for the "Reset + Erase" function.

## FAQ
- **Q: Can I debug multiple scripts at once?**
  A: Yes. You can either select multiple entities during insertion or use the "Add/Remove" context menu options repeatedly to build a list of active scripts.
- **Q: How do I stop the debugging messages?**
  A: Either use the "Reset + Erase" option on the controller to remove it entirely, or use "Add/Remove" options to remove specific scripts from the list while keeping the controller.
- **Q: What happens if I move the controller?**
  A: The controller is just a visual marker and data container. Moving it will move the text label and the anchor point for the visual relation lines, but it will not break the debug functionality.