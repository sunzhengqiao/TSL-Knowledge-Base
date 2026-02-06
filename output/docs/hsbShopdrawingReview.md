# hsbShopdrawingReview.mcr

## Overview
This script exports selected 3D Elements and their associated manufacturing data (geometry, tools, and hardware) to the external hsbMakeLite system. It is used to validate data or generate review reports without modifying the CAD drawing itself.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Elements must be selected from the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** hsbCAD Elements (Walls, Roofs, or Floors) present in the Model Space.
- **Minimum Count:** At least one Element must be selected for the function to execute.
- **Required Settings:** The external file `hsbMakeLiteConnector.dll` must be located in your hsbCAD Utilities folder.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsbShopdrawingReview.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select elements to be exported
Action: Click on the desired Elements (Walls/Roofs) in the 3D model to include them in the review.
```
3. Press **Enter** to confirm your selection.
   - *Note:* The script will automatically process the data, send it to the external tool, and then delete itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script has no custom right-click menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on the external DLL `hsbMakeLiteConnector.dll` rather than internal XML settings files.

## Tips
- **Transient Behavior:** This script is designed to run once and then remove itself from the drawing. Do not be alarmed if it disappears immediately after running; this is normal behavior.
- **Selection Scope:** You can select multiple elements at once. The script will aggregate all data from the selected elements before sending the review package.
- **Validation:** If the external review window does not appear, ensure that `hsbMakeLiteConnector.dll` is correctly installed and that no firewall rules are blocking the connection.

## FAQ
- **Q: I ran the script, but nothing happened in AutoCAD. Did it fail?**
  - A: Not necessarily. The script sends data to an external application (hsbMakeLite). Check your taskbar or desktop for a popup window from that application.
- **Q: Can I run this on a single beam?**
  - A: No, this script is designed to process entire hsbCAD Elements (which contain beams), not individual GenBeams.
- **Q: Why did the script erase itself?**
  - A: The script acts as a "command" rather than a permanent object. It cleans up after itself to keep your drawing database clean.