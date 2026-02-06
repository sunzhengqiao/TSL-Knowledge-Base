# hsbHousing

## Overview
This script automatically generates a housing (pocket/mortise) connection between two timber beams. It cuts a pocket into the "female" beam to accommodate the profile of the intersecting "male" beam based on their 3D geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to modify beam geometry. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script modifies the model, not the drawing views directly. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities.
- **Minimum Beam Count**: 2 (One intersecting/male beam and one receiving/female beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbHousing.mcr` from the file list.

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click on the beam that will be inserted into the pocket (the intersecting beam).
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the beam that needs to be cut to receive the male beam.
```

### Step 4: Configure Properties
After selection, the script will attempt to calculate the connection. You can modify the connection properties via the **Properties Palette** (Ctrl+1) if the script is selected.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Rounding Type | dropdown | not rounded | Determines how the internal vertical corners of the housing are treated. Options include: `not rounded`, `round`, `relief`, `rounded with small diameter`, `relief with small diameter`, `rounded`. |
| Color | number | 254 | Sets the color of the debug/preview body visualizing the housing volume (AutoCAD Color Index). |
| Group, Layername or Zone Character | text | T | Assigns the script to a specific Layer or Group (e.g., 'T' for walls, 'I' for interior). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Debugging**: If the housing is not created, look for a **Red line**. This indicates the beams do not have a valid geometric overlap (intersection) based on the current calculation logic. Adjust the beam positions or the script insertion point to ensure they overlap in 3D space.
- **Corner Treatment**: Use the "Rounding Type" property to add radii or reliefs to the pocket corners. This is often required for stress relief in timber or to accommodate CNC milling tool diameters.
- **Dynamic Updates**: If you move the connected beams using the AutoCAD `Move` or `Rotate` commands, the housing will automatically recalculate and update to fit the new geometry.

## FAQ
- **Q: Why is my beam not being cut?**
  A: The script likely detected an invalid intersection. Check if a red line appears near the connection. Ensure the male beam physically passes through the female beam in the 3D model.
- **Q: How do I change the size of the pocket?**
  A: The pocket size is driven by the cross-section of the "Male" beam. To change the pocket size, change the size of the male beam in the Element or Catalog properties.
- **Q: What does the "Group, Layername or Zone Character" property do?**
  A: It organizes the script instance. If you enter "T", the script might inherit properties from the Wall group. If you enter a specific Layer Name, the script instance moves to that layer.