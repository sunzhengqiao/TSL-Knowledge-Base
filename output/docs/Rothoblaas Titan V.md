# Rothoblaas Titan V.mcr

## Overview
Inserts the Rothoblaas TITAN V angle bracket to connect two perpendicular timber panels (Sip). It generates the metal plate visualization and automatically associates the correct fasteners (nails and screws) based on the selected structural configuration.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. 3D context is necessary to detect panel intersections. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities:** Two `Sip` (timber panel) entities.
- **Geometry:** The two panels must be perpendicular (90 degrees) to each other.
- **Minimum Count:** Exactly 2 panels must be selected.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas Titan V.mcr` from the list.

### Step 2: Select Panels
```
Command Line: Select 2 panels for insertion at specified point
Action: Click on the first panel, then click on the second panel that forms the corner.
```

### Step 3: Specify Insertion Point
```
Command Line: [Click to specify insertion point]
Action: Click near the edge where the bracket should be placed. This point defines the location along the joint.
```

### Step 4: Configure Properties (If applicable)
If a catalog entry (Execute Key) was not used, a property dialog will appear. Adjust the Type, Offset, or Display settings as needed and click OK.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | F1 - Full nailing | Selects the structural configuration. Options include F1/F2/3 variants and Full/Partial nailing patterns. This determines the number of VGS screws and Anker nails added to the BOM. |
| Offset | Number | 50 | The distance in mm from the panel edge to the center of the metal bracket. You can slide the bracket along the edge by changing this value. |
| Display | Dropdown | Text | Controls the level of detail.<br>- **No nail info:** Hides fasteners.<br>- **Text:** Shows labels only.<br>- **Graphical:** Shows 2D symbols.<br>- **Realistic:** Creates actual 3D drill holes in the panels for CNC. |
| Dimstyle | Dropdown | *Current* | The dimension style used for text labels associated with the connector. |
| Scale | Number | 1 | A visual scaling factor for text height and graphical symbols. Does not change the physical size of the metal part. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Catalog Entries (Execute Key) | Allows you to load a pre-defined configuration from the catalog. If a specific key is active, it sets properties automatically; otherwise, it loads the last used settings. |

## Settings Files
No specific external settings files (XML) are required for this script.

## Tips
- **Perpendicularity Check:** Ensure your panels meet at a perfect 90-degree angle. If they are skewed, the script will display an error "Panels are not perpendicular" and exit.
- **CNC Preparation:** Only use the **Display: Realistic** mode if you need to see the physical drill holes in the model for machining or export. For general modeling, **Text** or **Graphical** modes improve performance.
- **Adjusting Position:** After insertion, you do not need to delete the script to move it. Simply select the script instance and change the **Offset** property in the Properties Palette to slide it along the wall.

## FAQ
- **Q: Why does the script disappear immediately after I select the point?**
  A: This usually happens if the selected panels are not exactly perpendicular. Check your geometry and try again.
- **Q: How do I reduce the number of nails shown in the BOM?**
  A: Change the **Type** property from "Full nailing" to "Partial nailing".
- **Q: What is the difference between F1 and F2/3 types?**
  A: These refer to different load capacities or geometric variants of the Titan V bracket. F2/3 typically uses fewer heavy-duty screws (VGS) compared to F1. Consult Rothoblaas technical documentation for structural implications.