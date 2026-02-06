# hsb_RenameElements.mcr

## Overview
This script provides a user-friendly utility window to batch rename hsbCAD Elements within the Model Space. It organizes elements by their Floor or Group assignments, allowing for efficient renaming and renumbering.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script only processes entities located in the Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: hsbCAD Elements must exist in the drawing.
- **Minimum Beam Count**: 0 (This script targets Elements, not beams).
- **Required Settings**: The external file `hsb_ElementRenameUtility.dll` must be present in the specified TSL DLLs folder.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Select `hsb_RenameElements.mcr` from the file dialog.
3. Place the script instance in the drawing (the specific location does not matter).

### Step 2: Automatic Execution
- The script will automatically initialize and erase its own instance from the drawing immediately.
- The **Element Rename Utility** dialog window will appear.

### Step 3: Use the Rename Utility
1. **Review Elements**: The dialog displays all Elements found in the Model Space, organized by their Group/Floor names.
2. **Search/Filter**: Use the search functionality to locate specific Elements or Groups if needed.
3. **Select Elements**: Click on Elements or select multiple items as required.
4. **Define New Names**: Enter the new Element names or numbers directly in the interface.

### Step 4: Apply Changes
1. Click the **OK** or **Apply** button in the utility window.
2. The script updates the Element names in the background.
3. The utility window closes.

## Properties Panel Parameters

This script does not expose any parameters to the Properties Palette (OPM). All interaction is handled through the external utility window.

## Right-Click Menu Options

This script does not add specific items to the right-click context menu. It runs automatically upon insertion.

## Settings Files
- **Filename**: `hsb_ElementRenameUtility.dll`
- **Location**: `%hsbInstall%\Content\UK\TSL\DLLs\ElementRenameUtility`
- **Purpose**: This DotNet DLL provides the user interface form and logic required to search, select, and rename the Elements.

## Tips
- **Organization**: The tool automatically sorts elements by their Group or Floor names, making it easier to rename specific sections of a building.
- **Safety**: The script uses a temporary naming convention during the update process to prevent naming conflicts before applying the final names.
- **Clean Up**: The script instance erases itself automatically after running. You do not need to manually delete it from the drawing.

## FAQ
- **Q: The script disappeared immediately after I inserted it. Is that normal?**
  - **A:** Yes. This is intentional behavior. The script runs once to open the rename utility and then removes itself from the drawing to keep your model clean.
  
- **Q: Can I use this to rename individual beams?**
  - **A:** No. This script is designed specifically to rename hsbCAD **Elements**. It will not affect standard beams or other entity types.

- **Q: What happens if the dialog does not appear?**
  - **A:** Ensure that `hsb_ElementRenameUtility.dll` is located in the correct directory specified in the Settings Files section above.