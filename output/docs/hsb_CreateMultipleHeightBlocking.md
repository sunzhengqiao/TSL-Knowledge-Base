# hsb_CreateMultipleHeightBlocking.mcr

## Overview
Automatically generates rows of blocking (noggins) between wall studs at specified heights. The script intelligently fits blocking between studs, cuts around openings, and allows for staggering and length tolerances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates within the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: An existing Wall Element containing vertical beams (studs).
- **Minimum Beam Count**: At least 1 vertical stud and 2 horizontal points to define the blocking range.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select hsb_CreateMultipleHeightBlocking.mcr from the file list.
```

### Step 2: Select Wall Element
```
Command Line: Please select a Element
Action: Click on the Wall Element in the drawing where you want to add blocking.
```

### Step 3: Define Start Point
```
Command Line: Pick Starting Point
Action: Click a point to define where the blocking pattern begins (usually the bottom plate or a specific vertical location).
```

### Step 4: Define End Point
```
Command Line: Pick End Point
Action: Click a point to define where the blocking pattern ends (usually the top plate). This creates the vertical range for the blocking rows.
```

### Step 5: Configure Properties
After insertion, select the script instance and modify the heights in the Properties Palette (Ctrl+1) to specify where rows are created.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height Blocking Row 1 | Number | 600 mm | Vertical height for the first row of blocking. Set to `0` to disable this row. |
| Height Blocking Row 2 | Number | 1200 mm | Vertical height for the second row of blocking. Set to `0` to disable this row. |
| Height Blocking Row 3 | Number | 1800 mm | Vertical height for the third row of blocking. Set to `0` to disable this row. |
| Height Blocking Row 4 | Number | 2400 mm | Vertical height for the fourth row of blocking. Set to `0` to disable this row. |
| Stager the Blocking | Dropdown | No | If **Yes**, blocking pieces alternate positions for easier nailing. If **No**, they are centered. |
| |Tolerance|| | Number | 0 mm | Cuts back the length of the blocking by this amount to ensure a fit (accommodates lumber variation). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reapply Blocking | Regenerates all blocking based on the current wall geometry and property settings. Use this if you move studs, add openings, or change height properties. |

## Settings Files
None required.

## Tips
- **Removing Rows**: If you only need three rows of blocking, set the unused "Height Blocking Row" parameter to `0`.
- **Updating Geometry**: If you modify the wall (e.g., add a window or move a stud), the blocking will not update automatically. Right-click the script instance and select **Reapply Blocking** to sync the model.
- **Nailing Access**: Use the **Stager the Blocking** option set to **Yes**. This staggers the pieces so ends alternate, providing better access for nail guns.
- **Fit Tolerance**: If the blocking is consistently too tight or loose between studs, adjust the **Tolerance** value (e.g., 2mm) to create a slight gap.

## FAQ
- **Q: Why did some blocking pieces disappear?**
  **A:** The script automatically cuts blocking where it intersects with openings (windows/doors) or horizontal beams. If a bay is too small (less than 50mm), it also skips creating blocking there.

- **Q: How do I change the heights after inserting?**
  **A:** Select the script instance, open the Properties Palette (Ctrl+1), change the `Height Blocking Row` values, and then right-click the script and choose **Reapply Blocking**.

- **Q: Can I use this on curved walls?**
  **A:** This script is designed for planar walls defined by a start and end point. For complex curved geometry, results may vary.