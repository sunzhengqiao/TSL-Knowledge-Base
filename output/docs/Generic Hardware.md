# Generic Hardware.mcr

## Overview
Inserts and manages generic hardware components within the 3D model. It allows users to place hardware items with specific metadata (Manufacturer, Model, etc.) and visualize them using various display modes (Series, Cylinder, Box, or Custom Blocks) distributed along a user-defined path.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script uses 3D coordinates and vector geometry. |
| Paper Space | No | Not designed for 2D layout or annotation. |
| Shop Drawing | No | Does not generate shop drawing views directly. |

## Prerequisites
- **Required Entities:** None (Optional selection of a timber element/GenBeam is allowed).
- **Minimum Beam Count:** 0.
- **Required Settings:** `TslUtilities.dll` must be loaded in the hsbCAD environment.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Generic Hardware.mcr`

### Step 2: Choose Display Representation
```
Command Line: Select Display Block ? [Yes/No]
Action: Type Y to open a dialog and pick a specific AutoCAD block, or N to use default geometry.
```
*Note: If you select Yes, a list of available blocks in the current drawing will appear.*

### Step 3: Set Location
```
Command Line: Select Location
Action: Click in the model to place the insertion point (Start Point).
```

### Step 4: Define Orientation
```
Command Line: Select point to determine orientation/distribution
Action: Click a second point to define the direction and length of the hardware placement.
```

### Step 5: Associate with Element (Optional)
```
Command Line: Select Element (optional)
Action: Click a timber beam if you wish to link the hardware to that specific element, or press Enter to skip.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Display Mode** | Dropdown | Series | Determines how the hardware is drawn: <br>• **Series**: Items distributed along a line with arrows.<br>• **Cylinder**: A single 3D cylinder body.<br>• **Single Insert**: Items distributed without the leader line.<br>• **Box**: A single 3D box body. |
| **Article Number** | Text | - | The unique identifier for the hardware. |
| **Description** | Text | - | A short description of the hardware item. |
| **Manufacturer** | Text | - | Name of the hardware manufacturer. |
| **Model** | Text | - | Specific model number or name. |
| **Material** | Text | - | Material specification (e.g., Steel, Stainless Steel). |
| **Category** | Text | - | Grouping category for lists/filters. |
| **Group** | Text | - | Sub-group for organization. |
| **Notes** | Text | - | Additional user comments. |
| **Quantity** | Number | 0 | Number of hardware items. (Auto-calculated if Spacing > 0). |
| **Spacing** | Number | 0 | Distance between items in Series/Single Insert mode. (Auto-calculates Quantity if > 0). |
| **Length** | Number | 12" | Physical length of the hardware or the distribution line. |
| **Width/Diameter** | Number | 1" | Width (for Box) or Diameter (for Cylinder/Circle). |
| **Height/Thickness** | Number | 1.5" | Height (for Box) or Thickness. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select Display Block** | Opens a dialog allowing you to change the visual block used for the hardware representation. Useful for switching between different screw or plate symbols. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. It utilizes standard `TslUtilities.dll` for dialogs and reads Block definitions directly from the current drawing.

## Tips
- **Grip Editing:** You can click the hardware instance to reveal **Start** and **End** grips. Drag these grips to resize the distribution length or change the angle.
- **Symmetric Resizing:** Changing the **Length** property in the palette will extend the hardware symmetrically from the center point.
- **Fast Spacing:** To layout screws along a beam, set **Display Mode** to "Series", set your desired **Spacing**, and adjust the **Length** grips to cover the area. The Quantity will update automatically.

## FAQ
- **Q: How do I show my own custom screw head instead of a circle?**
- **A:** Insert your custom block into the drawing first. Then, right-click the hardware instance and select "Select Display Block" to choose your block from the list.
- **Q: Why can't I change the Quantity manually?**
- **A:** If the **Spacing** property is set to a value greater than 0, the script automatically calculates the Quantity based on the Length. Set Spacing to 0 to manually control Quantity.