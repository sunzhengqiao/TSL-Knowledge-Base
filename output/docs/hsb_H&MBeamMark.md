# hsb_H&MBeamMark.mcr

## Overview
This script automatically generates layout lines (marks) on beams within wall elements to indicate precise intersection points of T-connections. It is used to create assembly guides or CNC marks, ensuring installers or machines know exactly where intersecting members meet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run on 3D wall elements. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model detailing tool. |

## Prerequisites
- **Required Entities**: An existing Element (Wall) containing structural beams (GenBeams).
- **Minimum Beam Count**: At least 1 beam in the selected element.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or insert from Catalog)
- Select `hsb_H&MBeamMark.mcr` from the list of available scripts.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Elements (ElementWall) you wish to process. Press Enter to confirm selection.
```

### Step 3: Configure Properties (First Run Only)
- If this is the first time the script is run, a properties dialog will appear automatically.
- Adjust the **Marking Side** and configure which beam types to **Exclude**.
- Click OK to generate the marks.

## Properties Panel Parameters

These parameters can be edited in the AutoCAD Properties palette (Ctrl+1) after selection.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Marking Side** | Dropdown | Left | Determines where the mark is drawn relative to the intersecting beam. Options: `Left`, `Right`, or `Both` (full width). |
| **Types to exclude when marking** | Text | ---------- | A header label for the exclusion settings below. |
| **Jack Over Opening** | Dropdown | No | Set to `Yes` to prevent marks from being placed on Jack Studs over openings. |
| **Jack Under Opening** | Dropdown | No | Set to `Yes` to prevent marks from being placed on Jack Studs under openings. |
| **Cripple Stud** | Dropdown | No | Set to `Yes` to prevent marks from being placed on Cripple Studs. |
| **Transom** | Dropdown | No | Set to `Yes` to prevent marks from being placed on Transoms. |
| **King Stud** | Dropdown | No | Set to `Yes` to prevent marks from being placed on King Studs. |
| **Sill** | Dropdown | No | Set to `Yes` to prevent marks from being placed on Sills. |
| **Angled TopPlate Left** | Dropdown | No | Set to `Yes` to prevent marks on left-angled top plates. |
| **Angled TopPlate Right** | Dropdown | No | Set to `Yes` to prevent marks on right-angled top plates. |
| **TopPlate** | Dropdown | No | Set to `Yes` to prevent marks on standard top plates. |
| **Bottom Plate** | Dropdown | No | Set to `Yes` to prevent marks on bottom/sole plates. |
| **Blocking** | Dropdown | No | Set to `Yes` to prevent marks on blocking members. |
| **Supporting Beam** | Dropdown | No | Set to `Yes` to prevent marks on supporting beams. |
| **Stud** | Dropdown | No | Set to `Yes` to prevent marks on standard studs. |
| **Stud Left** | Dropdown | No | Set to `Yes` to prevent marks on left studs. |
| **Stud Right** | Dropdown | No | Set to `Yes` to prevent marks on right studs. |
| **Header** | Dropdown | No | Set to `Yes` to prevent marks on headers. |
| **Brace** | Dropdown | No | Set to `Yes` to prevent marks on braces. |
| **Locating Plate** | Dropdown | No | Set to `Yes` to prevent marks on locating plates. |
| **Packer** | Dropdown | No | Set to `Yes` to prevent marks on packers. |
| **SolePlate** | Dropdown | No | Set to `Yes` to prevent marks on sole plates. |
| **HeadBinder/Very Top Plate** | Dropdown | No | Set to `Yes` to prevent marks on head binders or very top plates. |

*Note: For the beam types listed above, setting the option to `Yes` excludes that specific beam type from receiving marks.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Updates the marks based on the current geometry and property settings. Use this after changing any properties in the palette. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Cleanup**: Use the exclusion list to prevent "clutter" on common members like Top Plates if you only need to mark studs, or vice-versa.
- **Full Width Marks**: Setting **Marking Side** to `Both` is useful for CNC operations where a full cut line across the face of the beam is required.
- **Modification**: If you modify the wall geometry (e.g., move a window), simply right-click the element and select **Recalculate** to update all mark positions.

## FAQ
- **Q: Why are no marks appearing on my beams?**
  **A:** Check the **Types to exclude** section in the properties. You may have accidentally set the beam type you are looking at to `Yes` (Exclude).
- **Q: Can I change the side of the mark after insertion?**
  **A:** Yes. Select the script instance or the element, change the **Marking Side** property in the Properties Palette, and right-click to **Recalculate**.
- **Q: Does this work on single beams not in a wall?**
  **A:** No, the script is designed to work with ElementWall entities.