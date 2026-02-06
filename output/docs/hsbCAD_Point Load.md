# hsbCAD_Point Load.mcr

## Overview
This script automates the insertion of a reinforced stud pack (Point Load) into a timber wall element to support concentrated vertical loads. It replaces standard studs at the specified location with a user-defined number of reinforcement studs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model environment. |
| Paper Space | No | Not designed for 2D layouts or drawings. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: A Wall Element must already exist in the model.
- **Minimum Beam Count**: 0 (it generates new beams).
- **Required Settings**: 
  - System Extrusion Profiles (catalog of available timber sizes).
  - System Dimension/Text Styles (for labeling).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCAD_Point Load.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the Wall Element where the point load needs to be applied.
```
The script will calculate the insertion point based on where you clicked the wall and automatically insert the reinforcement studs.

## Properties Panel Parameters

Once the script is inserted and the element is selected, you can modify the following properties in the AutoCAD Properties Palette (Ctrl+1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of beams | Integer | 1 | The quantity of studs to generate as a pack. Increasing this widens the reinforcement area. |
| Extrusion profile name | Dropdown | System Default | Selects the cross-sectional profile (size and shape) of the reinforcement studs from the system catalog. |
| Text style | Dropdown | System Default | Selects the font style used for the visual label/annotation of the point load in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are assigned to this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on global system catalogs (Extrusion Profiles and DimStyles) rather than external XML settings files.

## Tips
- **Automatic Cleanup**: The script automatically deletes standard studs (HSB ID 114) that overlap with the new point load studs to avoid geometry conflicts.
- **SuperFrame Compatibility**: The script correctly handles walls with double bottom plates (such as SuperFrame walls).
- **Notching**: If the script encounters beams with Beamcode "H" (typically horizontal beams), it will automatically notch the point load studs around them.
- **Visual Marker**: A 3D box with an "X" is drawn to visually indicate the location and extent of the point load in the model.

## FAQ
- **Q: What happens if I change the "Number of beams" property?**
- **A:** The script will recalculate the width of the point load. If the new pack is wider, it may delete additional standard studs to make room.
  
- **Q: Can I use a specific timber size for the point load?**
- **A:** Yes. Use the "Extrusion profile name" property in the Properties Palette to select any profile available in your hsbCAD catalogs.

- **Q: The script didn't fit between my top and bottom plates.**
- **A:** Ensure the insertion click is within the wall bounds. The script attempts to find the nearest top and bottom plates; if the click is too close to the edge, it may fail to intersect properly.