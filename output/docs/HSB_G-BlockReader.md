# HSB_G-BlockReader.mcr

## Overview
A diagnostic utility used to check if the internal global `_Map` variable contains data after specific operations. This script is primarily intended for developers or advanced users to verify that data is being written to and read from the global Map correctly during troubleshooting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates within the 3D model environment. |
| Paper Space | No | This script is not designed for use in Layouts. |
| Shop Drawing | No | This script does not generate shop drawings. |

## Prerequisites
- **Required entities**: None
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-BlockReader.mcr`

### Step 2: View Diagnostic Result
```
Command Line: [Script executes automatically]
Action: Observe the message log or command line output
```
The script will immediately check the internal system memory. A message will be displayed indicating one of two statuses:
- **"Map has Data!"**: The global `_Map` variable currently holds information.
- **"_Map does not contain Data!"**: The global `_Map` variable is empty.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any editable properties to the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- This is a "Read-Only" diagnostic tool. It does not create or modify any geometry in the drawing.
- Use this script after running other TSL scripts to confirm if they have successfully saved data to the global `_Map` variable.
- If the script reports "No Data," it implies that no prior operation has populated the global variable in the current session context.

## FAQ
- **Q: I inserted the script but nothing appeared on screen.**
  - A: This is expected behavior. The script generates no geometry. Check the AutoCAD command line or text window for the diagnostic message regarding the `_Map` status.
- **Q: Can I modify the data using this script?**
  - A: No, this script only reads and reports the status of the data; it cannot modify the contents of the `_Map`.