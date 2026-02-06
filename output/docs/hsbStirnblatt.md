# hsbStirnblatt.mcr

## Overview
This script automates the creation of a pocket and a square cut at the end of a timber beam to accommodate a front connection plate (Stirnblatt). It allows for precise configuration of the plate dimensions, positioning offsets, and corner relief geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in 3D Model Space. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a detailing/manufacturing script, not a drawing generator. |

## Prerequisites
- **Required Entities**: One `GenBeam` (General Beam) must exist in the drawing.
- **Minimum Beam Count**: 1
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbStirnblatt.mcr` from the file dialog.

### Step 2: Configure Properties
If you are running the script without a specific catalog entry, a Properties Dialog will appear immediately.
- Set the desired Width, Height, and Depth for the pocket.
- Configure any necessary Offsets or Relief options.
- Click **OK** to proceed.

### Step 3: Select Beam
```
Command Line: Select beam:
Action: Click on the timber beam you wish to modify.
```
*Note: If you cancel this selection, the script will stop.*

### Step 4: Define Insertion Point
```
Command Line: Give insertion point:
Action: Click on the beam's face or end where you want the center (or offset location) of the plate to be positioned.
```
The script will now calculate the geometry and apply the cut and pocket to the beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** (dY) | Number | 80 mm | The horizontal width of the plate pocket. |
| **Height** (dZ) | Number | 80 mm | The vertical height of the plate pocket. |
| **Depth** (dX) | Number | 9 mm | The depth of the cut into the beam (thickness of the plate). |
| **Offset** Y (dOffsetY) | Number | 0 mm | Moves the pocket center left or right from the insertion point. |
| **Offset** Z (dOffsetZ) | Number | 0 mm | Moves the pocket center up or down from the insertion point. |
| **Gap** (dGap) | Number | 0 mm | Adds clearance around the plate (Total Width/Height = Dimension + 2 * Gap). |
| **Relief** (sRelief) | Dropdown | not rounded | Defines the corner geometry of the pocket (e.g., sharp, rounded, or relieved). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu items are defined for this script. Standard AutoCAD/hsbCAD options apply. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal properties and does not require external XML settings files.

## Tips
- **Adjusting Tolerances**: If the physical plate fits too tightly, increase the **Gap** property in the palette rather than manually adjusting the Width/Height.
- **Stress Relief**: For structural connections or to prevent wood cracking, change the **Relief** property to "rounded" or "relief" to chamfer the internal corners of the pocket.
- **Quick Modifications**: After insertion, select the beam and open the **Properties** palette (Ctrl+1) to find the hsbStirnblatt entry. You can drag sliders or type new values to resize the pocket in real-time.
- **Moving the Connection**: Use the **Grip Edit** feature (select the beam, click the square grip at the insertion point) to slide the plate along the beam face.

## FAQ
- **Q: How do I change the plate size after I have already placed it?**
  A: Select the beam in the drawing. Open the Properties palette (OPM). Scroll down to the section named after this script (or look for the variables dY, dZ, dX) and change the values.
- **Q: Why is my pocket not centered on the beam face?**
  A: Check the **Offset** Y and Z values. If they are not 0, the pocket will be shifted from your clicked insertion point.
- **Q: What does the "Depth" property do?**
  A: It controls how far the machine cuts into the timber from the end face. This should match the thickness of the metal/wood plate you are inserting.