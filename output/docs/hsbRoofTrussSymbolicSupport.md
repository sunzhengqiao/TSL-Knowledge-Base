# hsbRoofTrussSymbolicSupport.mcr

## Overview
This script establishes a symbolic structural link between a roof truss and a supporting element (such as a wall or beam). It validates the geometric connection and load-bearing status to ensure the truss is properly supported for structural analysis and drawing generation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for layout or paper space usage. |
| Shop Drawing | No | Not a shop drawing sub-script. |

## Prerequisites
- **Required Entities:** One Roof Truss (`TrussEntity`) and one supporting element (Wall or Beam).
- **Minimum Beam Count:** None (entities are selected interactively).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRoofTrussSymbolicSupport.mcr`

### Step 2: Select Truss
```
Command Line: Select truss
Action: Click on the roof truss entity in the model that needs to be supported.
```

### Step 3: Select Supporting Object
```
Command Line: Select supporting object
Action: Click on the wall or beam that will bear the truss.
```

### Step 4: Verify Connection
Once selected, the script will draw symbolic lines connecting the truss to the support.
- **Green/Red lines:** The support is active and valid.
- **Grey lines:** The support is inactive (e.g., geometry is out of tolerance or the support is non-load-bearing).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Active | dropdown | Yes | Enables or disables the structural support link. If the supporting object is non-load-bearing, this will lock to "No". |
| Vertical tolerance | number | 50 (mm) | The maximum allowed gap (in mm) between the bottom of the truss and the top of the support object. If the gap exceeds this, the support becomes invalid. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Feedback:** Pay attention to the color of the connecting lines. If they turn grey, check the "Active" property or the vertical gap between the truss and the wall.
- **Load-Bearing Check:** Ensure the supporting wall or beam is marked as "Load-bearing" in its own properties; otherwise, this script will force the support to be inactive.
- **Automatic Updates:** If you move the truss or the supporting wall using standard AutoCAD grips or move commands, the script will automatically recalculate and update the visual link.
- **Duplicate Links:** If you try to place a second support link on the exact same connection, the script will delete itself to prevent duplicates.

## FAQ
- **Q: Why did the script disappear immediately after I selected the objects?**
  **A:** This usually happens if a support link already exists between these two specific entities. It can also happen if the entities selected were not valid (e.g., selecting a non-structural element).

- **Q: Why is the "Active" property greyed out and set to "No"?**
  **A:** This occurs when the supporting object (the wall or beam) is defined as non-load-bearing. To fix this, modify the properties of the wall/beam to be load-bearing.

- **Q: The lines are grey even though "Active" is set to "Yes". Why?**
  **A:** The geometry likely fails the validation check. Check the "Vertical tolerance" setting; the gap between the truss and the support might be too large.