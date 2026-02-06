# hsb_LiftHolesOnStuds.mcr

## Overview
This script automates the creation of lifting holes for crane operations on timber wall panels. It drills a vertical lifting hole in specific wall studs and adds two matching clearance holes in the top plate to allow lifting straps or chains to pass through.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the model where wall panels (Elements) are located. |
| Paper Space | No | Not designed for Shop Drawings or layout views. |
| Shop Drawing | No | Does not generate 2D annotations or view-specific details. |

## Prerequisites
- **Required Entities**: You must have **Elements** (wall panels) present in the drawing containing beams classified as **Top Plates** (e.g., `_kSFTopPlate`) and **Studs** (e.g., `_kStud`).
- **Minimum Requirements**: The script processes elements based on their internal beam structure. Select at least one valid wall element during execution.
- **Required Settings**: None. The script uses internal defaults that can be adjusted via the Properties Palette before execution.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to select `hsb_LiftHolesOnStuds.mcr` and click **Open**.

### Step 2: Configure Properties
*   A dialog will appear automatically upon first insertion.
*   **Action**: Adjust the drilling dimensions (Diameter, Offset, Spacing) if the default values do not suit your lifting hardware. Click **OK** to confirm.

### Step 3: Select Wall Panels
```
Command Line: Please select Elements
Action: Click on the wall panels (Elements) you wish to modify. Press Enter to confirm selection.
```
*   *Note*: The script will analyze the selected panels and automatically identify the correct studs based on panel length (end studs for long panels, first stud for short panels).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drill Diameter | Number | 25 | Diameter of the vertical hole drilled through the stud (mm). Ensure this matches your lifting pin diameter. |
| Offset from Top of the panel | Number | 276 | Vertical distance from the top surface of the wall panel down to the center of the lifting hole (mm). Adjust based on lifting hardware geometry. |
| Distance between Drills on Top | Number | 74 | Horizontal spacing between the two clearance holes drilled into the top plate (mm). Increase this if using wide slings or shackles. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs once and erases its instance. It does not attach a persistent context menu to the elements. |

## Settings Files
- None used.

## Tips
- **Panel Length Logic**:
    - **Long Panels (>1000mm)**: The script places holes only in the end studs (studs within 700mm of the left/right edges). Intermediate studs are ignored.
    - **Short Panels (<=1000mm)**: The script automatically selects the first vertical stud found in the element.
- **Stud Orientation**: The script only processes studs that are perpendicular to the wall's main axis (Element X-axis). Ensure your wall elements are constructed correctly.
- **Re-running**: The script deletes its own reference block after running. To change hole locations or sizes, you must delete the existing drills manually and run the script again.

## FAQ
- **Q: Why didn't the script drill holes in the middle of my long wall?**
  - A: For structural balance and typical lifting setups, the script is designed to lift long panels from the ends only. It ignores studs that are more than 700mm away from the left or right boundaries.
- **Q: What happens if my drill diameter is too large for the spacing?**
  - A: The two clearance holes in the top plate might merge into one large slot or weaken the plate. If using a large diameter (e.g., 50mm), ensure you increase the **Distance between Drills on Top** parameter accordingly.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD **Undo** command immediately after running the script, or manually select and delete the generated drill holes.