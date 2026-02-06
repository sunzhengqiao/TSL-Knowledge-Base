# hsbMarkerLines.mcr

## Overview
This script automatically applies visual markings or machining operations (drills) to timber beams based on their intersection with other structural elements, such as walls, roof planes, or solids. It is used to indicate cut lines, alignment positions, or assembly points directly on the beam surface.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D GenBeams and intersections. |
| Paper Space | No | Not intended for 2D layout views. |
| Shop Drawing | No | Marks are generated in the model and may appear in derived views, but the script is run in Model Space. |

## Prerequisites
- **Required Entities**:
  - At least one **GenBeam** (the timber element to be marked).
  - At least one **Marking Entity** (Solid, Roof Plane, Roof Element, or Polyline used to define the intersection location).
- **Minimum Beams**: 1 GenBeam.
- **Required Settings**: None (Standard hsbCAD environment).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMarkerLines.mcr` from the list.

### Step 2: Select Marking Entity
```
Command Line: Select marking entity(s) (Solids, roof planes, roof elements or polylines)
Action: Click on the object(s) in the model that define where the mark should go (e.g., a wall sitting on top of beams). Press Enter to confirm selection.
```

### Step 3: Select GenBeams
```
Command Line: Select genbeams to be marked
Action: Click on the timber beams that you want to mark. Press Enter to confirm selection.
```

### Step 4: Configuration
After selection, the script calculates the intersections. You can adjust the marker appearance and behavior using the **Properties Palette** (Ctrl+1) while the script instance is selected.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Marker Length** | Number | 30 mm | Defines the physical length of the marker line. Overlapping segments are combined into longer continuous lines. |
| **Marker Offset** | Number | 0 mm | Shifts the marking inward from the exact intersection edge. Useful to ensure the mark is visible near cuts. |
| **Mark Boundings** | Dropdown | Yes | **Yes**: Uses the bounding box of the marking entity (Faster, Rectangular). **No**: Uses the real contour of the marking entity (Slower, Precise). |
| **Export as Mark** | Dropdown | No | If **Yes**, the mark is exported to production/CNC files (e.g., for inkjet printing). If **No**, it is visual only. |
| **Side** | Dropdown | Front | Determines which vertical face of the beam receives the mark: **Front**, **Back**, or **Both**. |
| **Color** | Number | 1 | Sets the AutoCAD color index for the marker display in the model. |
| **Type** | Dropdown | Corner | Select the tool type: **Corner** (Visual Line), **Drill** (Machined Hole), or **Midline**. |
| **Diameter Drill** | Number | 2 mm | Sets the diameter of the drill hole (Only active when Type is "Drill"). |
| **Depth Drill** | Number | 5 mm | Sets the depth of the drill hole (Only active when Type is "Drill"). |
| **Marking Face** | Dropdown | Contact | **Contact**: Marks the face physically touching the object. **Side**: Projects marks onto the vertical sides. |
| **Side Marking** | Dropdown | Left | Refines the lateral position of the mark: **Left**, **Right**, **Both**, or **Middle**. |

## Right-Click Menu Options
Select the script instance in the model and right-click to access the following options:

| Menu Item | Description |
|-----------|-------------|
| **Use envelope shape of marking entities** | Switches calculation mode to use the Bounding Box. Faster, but less accurate for complex shapes. |
| **Use realbody of marking entities** | Switches calculation mode to use the exact geometry. Slower, but accurate for slanted or complex objects. |

## Settings Files
- **Filename**: `hsbSettings`
- **Location**: Company or Install path (standard hsbCAD configuration)
- **Purpose**: This script references `hsbSettings` to determine default display colors for markers, though local properties can override them.

## Tips
- **Performance**: If working with many complex roof planes, set **Mark Boundings** to "Yes" (Bounding Box) initially to speed up calculations. Switch to "No" (Real Body) only for final precision.
- **Drill Safety**: Drills will not be placed if they are within 20mm of the beam edge (to prevent splitting). If a drill is missing, try increasing the **Marker Offset**.
- **Midline Fallback**: If you select "Midline" as the Type but the geometry does not support it, the script will automatically revert to "Corner" type.

## FAQ
- **Q: Why did the script instance disappear immediately after running?**
  - A: The script could not find any valid intersections between the selected Marking Entities and GenBeams. Ensure the objects physically touch or overlap in 3D space.
- **Q: My marks are rectangular, but the wall is slanted. How do I fix this?**
  - A: Change the **Mark Boundings** property to "No". This forces the script to follow the real contour of the slanted wall instead of its bounding box.
- **Q: Can I use this to print marks on the timber for assembly?**
  - A: Yes. Set **Export as Mark** to "Yes". This ensures the mark data is sent to production files (e.g., for inkjet markers or CNC labels).