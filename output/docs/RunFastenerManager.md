# RunFastenerManager.mcr

## Overview
Launches the Fastener Manager utility, providing a graphical interface to manage and configure fasteners (such as screws, nails, and bolts) within your hsbCAD project.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for running this script. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: None
- **Minimum beam count**: 0
- **Required settings files**: `FastenerManager.dll` must be located in the `%hsbInstall%\Utilities\FastenerManager\` directory.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `RunFastenerManager.mcr`

### Step 2: Automatic Execution
```
Command Line: (Script starts automatically)
Action: No user input is required. The script will verify the installation of the Fastener Manager tool and launch the "Fastener Manager" dialog window immediately.
```

### Step 3: Script Termination
```
Action: The script instance automatically removes itself from the drawing after the dialog is launched (or if an error occurs).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not create persistent entities or expose editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not remain in the drawing to offer context menu options. |

## Settings Files
- **Filename**: `FastenerManager.dll`
- **Location**: `%hsbInstall%\Utilities\FastenerManager\`
- **Purpose**: External .NET Assembly containing the Fastener Manager user interface and logic.

## Tips
- **Automatic Cleanup**: This script is designed as a "launcher." It will erase itself from the model immediately after opening the dialog. Do not be alarmed if it disappears from the drawing immediately after insertion.
- **Error Handling**: If the script reports that it cannot find the file, ensure your hsbCAD installation is complete and that the `FastenerManager` folder has not been moved or deleted.

## FAQ
- **Q: Where did the script go after I ran it?**
  - A: The script calls `eraseInstance()` immediately upon execution. This is intended behavior; it acts purely as a button to open the external tool.
- **Q: I get an error saying "Could not find file".**
  - A: This means the `FastenerManager.dll` is missing from the expected directory. Please check your hsbCAD installation path or contact your IT administrator to ensure the Fastener Manager plugin is installed correctly.