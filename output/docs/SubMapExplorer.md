# SubMapExplorer

## Overview
This script is a debugging utility that allows you to inspect internal data maps (SubMaps) stored within a specific timber element. It exports the selected data to a file and opens it in an external viewer tool for detailed analysis.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used primarily in the 3D model to inspect beam or element properties. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not used for generating manufacturing drawings. |

## Prerequisites
- **Required Entities**: Any valid hsbCAD Entity (e.g., GenBeam, Element).
- **Minimum Beam Count**: 1.
- **Required Settings**: The external tool `hsbMapExplorer.exe` must be present in the hsbCAD installation folder (`...\Utilities\hsbMapExplorer`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or your assigned shortcut) → Select `SubMapExplorer.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select entity
Action: Click on the beam or element in the model that you wish to inspect.
```
*Note: A list of available data maps (SubMaps) associated with this element will be printed in the command line history (e.g., 0, 1, 2...).*

### Step 3: Enter Map Number
```
Command Line: Enter Map Number
Action: Type the number (index) corresponding to the specific map you want to view and press Enter.
```
*If you wish to cancel, press Enter without typing a number.*

### Step 4: View Data
The script will automatically generate a temporary data file (`.dxx`) and launch the `hsbMapExplorer.exe` application to display the contents. The script instance will then remove itself from the drawing.

## Properties Panel Parameters
This script does not use Properties Panel parameters. It runs via command line input and erases itself upon completion.

## Right-Click Menu Options
This script does not add specific items to the right-click context menu.

## Settings Files
No specific settings files (XML) are required for this script. It relies on the internal logic of the selected element and the external executable.

## Tips
- **Check the Command Line**: After selecting an element, look at the text history (F2 if necessary) to see the list of available map numbers.
- **Automatic Cleanup**: Do not be alarmed if the script instance disappears immediately after running; this is intended behavior to keep the drawing clean.
- **Use Cases**: This is primarily used by developers or advanced users to troubleshoot script logic or verify calculated values hidden inside the element's data structure.

## FAQ
- **Q: Can I edit the data in the viewer?**
  - A: No, the `hsbMapExplorer` is typically a read-only viewer used for inspection and debugging.
- **Q: What happens if I enter a number that is not in the list?**
  - A: The script may fail to find the data or export an empty file. Ensure you select a valid index number displayed in the command line history.
- **Q: I selected an element but no maps were listed.**
  - A: This means the selected element does not currently contain any SubMap data structures to inspect. Try a different element.