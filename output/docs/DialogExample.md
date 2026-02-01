# DialogExample.mcr

## Overview
This script is a developer utility designed to demonstrate and test the various User Interface (UI) dialog capabilities provided by the `TslUtilities.dll`. It allows users to preview different dialog types—such as selection lists, text inputs, and dynamic data grids—without generating any geometric elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**: The script requires `TslUtilities.dll` to be located at `_kPathHsbInstall + "\Utilities\DialogService\TslUtilities.dll"`.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Select `DialogExample.mcr` from the catalog list.

### Step 2: Configure Dialog Options
Before placing the script in the drawing:
1.  Open the **Properties Palette** (Ctrl+1) if not already open.
2.  With the script command active, look for the "Parameters" section in the Properties Palette.
3.  By default, only `bDynamic` is set to `1` (True). Change the values of the parameters below to `1` to enable specific dialog demonstrations.
    *   *Note: The script will erase itself immediately after execution, so parameters must be set before the script finishes running.*

### Step 3: Execute Script
1.  Click in the Model Space to insert the script instance.
2.  The selected dialog(s) will appear on the screen.
3.  Interact with the dialog (select items, enter text, or click options).
4.  Click OK or Cancel on the dialog.
5.  The script instance will automatically erase itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| bListSelector | Boolean (0/1) | 0 | If set to 1, displays a searchable, multi-selection list dialog. |
| bOptions | Boolean (0/1) | 0 | If set to 1, displays a radio-button style selection dialog. |
| bText | Boolean (0/1) | 0 | If set to 1, displays a simple text input dialog. |
| bNotice | Boolean (0/1) | 0 | If set to 1, displays a simple notification message. If `bListSelector` is also active, this notice will show the results of the list selection. |
| bMultiNotice | Boolean (0/1) | 0 | If set to 1, displays a multi-line notice dialog capable of showing different data types (String, Number, Coordinates). |
| bAsk | Boolean (0/1) | 0 | If set to 1, displays a standard Yes/No question dialog ("Do you like Jimmy?"). |
| bYesNo | Boolean (0/1) | 0 | If set to 1, displays a custom Yes/No dialog with specific button labels ("He's Awesome" / "Bad Jimmy"). |
| bDynamic | Boolean (0/1) | 1 | If set to 1, displays a complex dynamic data grid dialog with various input types (labels, text boxes, checkboxes, etc.). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None (XML configuration not used).
- **Dependency**: `TslUtilities.dll` (Required for UI functions).

## Tips
- **Parameter Speed**: Since the script erases itself instantly, it is often easier to modify the parameters by selecting the script name in the insert dialog *before* clicking into the drawing, or by having the Properties Palette active and ready.
- **Debugging**: If dialogs do not appear, ensure the `TslUtilities.dll` is present in the correct `Utilities\DialogService` folder of your hsbCAD installation.
- **Data Grid**: The `bDynamic` parameter demonstrates the most complex UI element, showing how data grids are constructed programmatically.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
- A: This is intended behavior. The script is designed to demonstrate the UI logic and then execute `eraseInstance()` to clean up the drawing.
- **Q: How can I see multiple dialogs at once?**
- A: Set multiple parameters (e.g., `bListSelector` and `bAsk`) to `1` in the Properties Palette before inserting. They will appear sequentially.
- **Q: I changed a parameter to 1, but the dialog didn't show up.**
- A: Ensure you changed the parameter *before* the script finished inserting. If the script disappears before you can change the setting, re-insert it and change the setting in the Properties Palette immediately after selecting the script from the catalog but before clicking in the drawing space.