# SimpleFastener.mcr

## Overview
This script creates fasteners (drills/screws) in a set of intersecting beams (GenBeams). It provides an interactive 3D rotation system for precise placement and includes tools to manage fastener assembly definitions and select hardware from a database.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D modeling. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Structural Beam).
- **Minimum Beam Count**: 1 (designed for intersecting beams).
- **Required Settings**:
  - `FastenerManager.dll` (must be present in the hsbCAD Utilities folder).
  - `TslUtilities.dll` (must be present in the hsbCAD Utilities folder).
  - A valid **Fastener Database** file (configured in the FastenerManager).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SimpleFastener.mcr`

### Step 2: Select Rotation Axis
**Visual Prompt:** Three circles will appear near the insertion point representing the X, Y, and Z axes.
**Action:** Click near the circle perpendicular to the axis you want to rotate around. 
- Click the circle on the **X-axis** to rotate in the Y-Z plane.
- Click the circle on the **Y-axis** to rotate in the X-Z plane.
- Click the circle on the **Z-axis** to rotate in the X-Y plane.

### Step 3: Set Rotation Angle
```
Command Line: |Pick point to rotate [Angle/Basepoint/ReferenceLine]|
Action: Move your cursor to dynamically rotate the fastener. Click to set the angle.
```
**Keyword Options:**
- **Angle**: Type `Angle` and press Enter to input a specific numerical value for the rotation.
- **Basepoint**: Type `Basepoint` and press Enter to select a new center point for the rotation.
- **ReferenceLine**: Type `ReferenceLine` and press Enter to align the fastener's X-axis with a specific line in your drawing.

### Step 4: Select Fastener
Once positioned, the script will invoke the FastenerManager dialogs.
**Action:** Select the Manufacturer, Family, and specific Screw article from the filtered lists provided.

## Properties Panel Parameters
*Note: The script scan did not detect static user-editable properties (OPM). Configuration is primarily handled via the interactive dialogs and Context Menu options described below.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Face** | Rotates the fastener 180 degrees around the local Y-axis. Useful for mirroring the fastener orientation. |
| **Show StyleManager** | Opens the Style Manager to create or modify fastener assembly definitions (styles). |
| **Load Graphical Ruleset** | Imports a graphical ruleset for the fastener display. |
| **Change Database** | Opens the Database Manager dialog to switch to a different fastener database file. |

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: `_kPathHsbInstall + "\Utilities\DialogService\"`
- **Purpose**: Provides the user interface dialogs (Selection lists, Input boxes).

- **Filename**: `FastenerManager.dll`
- **Location**: `_kPathHsbInstall + "\Utilities\FastenerManager\"`
- **Purpose**: Manages connection to the fastener database and filters available articles.

- **Filename**: `Fastener Database` (e.g., .mdb or .xlsx)
- **Location**: Defined dynamically via the FastenerManager settings.
- **Purpose**: Contains the technical data (dimensions, material, codes) for the screws and fasteners.

## Tips
- **Precise Alignment**: Use the **ReferenceLine** option during the rotation jig to align your fastener perfectly with the edge of a beam or a construction line.
- **Quick Re-orientation**: If you insert a fastener and it is facing the wrong way, use the **Flip Face** context menu option instead of re-inserting.
- **Grid Snapping**: The rotation jig automatically adjusts snapping precision (from 45 degrees down to 1 degree) based on how close your cursor is to the insertion point. Move the cursor closer for fine-tuning.

## FAQ
- **Q: Why don't I see any screws to select?**
  - A: The script relies on the Fastener Database. Ensure the database path is correct by right-clicking the script and selecting **Change Database**.
  
- **Q: How do I rotate the fastener after I have inserted it?**
  - A: Use the AutoCAD `PROPERTIES` palette (if available) or delete and re-insert to use the interactive rotation jig. Alternatively, check if the specific style you are using has parameters that allow angle adjustment. For 180-degree flips, use the **Flip Face** context menu option.

- **Q: What does the "StyleManager" do?**
  - A: It allows you to group specific fastener configurations (e.g., "M12 x 100mm with Washer") into a named Style. This allows for quick reuse without manually selecting parameters every time.