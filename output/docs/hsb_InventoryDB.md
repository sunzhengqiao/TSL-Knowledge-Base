# hsb_InventoryDB.mcr

## Overview
This script serves as a utility launcher that opens the external "Loose Materials Inventory Editor." It allows you to manage and edit the database of non-timber construction items (such as screws, metal plates, and hardware) without creating any geometry in your drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in Model Space to function. |
| Paper Space | No | The script is not intended for use in Layouts or Paper Space. |
| Shop Drawing | No | This is a project management tool, not a detailing script. |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings**: 
  - The external DLL file `hsbLooseMaterialsUI.dll` must be present in your hsbCAD installation directory (`...\Utilities\hsbLooseMaterials\`).
  - Appropriate write permissions for the project catalog/database are recommended.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_InventoryDB.mcr`.
3. Click **Open**.

### Step 2: Open Inventory Editor
```
Command Line: [No prompts]
Action: The "Loose Materials Inventory Editor" window appears automatically.
```
*Note: You do not need to click a point in the drawing. The script runs immediately upon loading.*

### Step 3: Manage Database
1. Use the dialog window to search, add, or modify loose material items (e.g., changing dimensions or prices for specific bolts).
2. Make your desired changes to the inventory list.

### Step 4: Close and Finish
1. Click **OK** or **Close** in the Inventory Editor window.
2. The script automatically deletes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | This script executes immediately and does not expose parameters to the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | The script instance erases itself immediately after use, preventing persistent right-click menu interactions. |

## Settings Files
- **Filename**: None internal to the script.
- **Location**: N/A
- **Purpose**: This script relies on the external `hsbLooseMaterialsUI.dll` to access the project's existing material catalogs and databases.

## Tips
- **Self-Cleaning Tool**: Do not be alarmed if the script object disappears from the drawing immediately after you close the dialog. This is intended behavior to prevent drawing clutter.
- **Database Connection**: Ensure you are working in the correct project environment, as changes made in the editor will affect the project's available loose materials.

## FAQ
- **Q: I inserted the script, but nothing happened.**
  - A: This usually means the external `hsbLooseMaterialsUI.dll` is missing or not registered. Contact your IT support or hsbCAD administrator to verify the Utilities installation.

- **Q: Where is the script object in my model?**
  - A: The script automatically runs `eraseInstance()` after closing the dialog. It leaves no permanent trace in your drawing.

- **Q: Can I use this to edit timber beam sizes?**
  - A: No, this tool is specifically for "Loose Materials" (accessories, hardware, metal parts), not structural timber elements.