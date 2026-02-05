# HSB_G-JoinSheets.mcr

## Overview
This script merges adjacent Sheet entities (such as CLT panels or sheathing) into single entities. It is used to close small gaps and unify production data for floor or wall assemblies.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D construction entities. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Not designed for detailing views. |

## Prerequisites
- **Required Entities**: At least two Sheet entities selected.
- **Minimum Count**: 2 Sheets.
- **Required Settings**: None (uses internal tolerance parameters).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-JoinSheets.mcr`

### Step 2: Set Properties (If applicable)
```
Dialog: Properties Palette (or Insert Dialog)
Action: Set the 'Tolerance' value if you need to bridge gaps larger than 1mm.
```

### Step 3: Select Sheets
```
Command Line: |Select sheets|
Action: Select the sheets you wish to merge and press Enter.
```

### Step 4: Automatic Processing
The script will automatically detect which sheets are parallel, coplanar, and within the specified tolerance distance. It will then merge them into single entities. The script instance will erase itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tolerance | Number | 1 mm | The maximum permissible distance between sheet edges for them to be considered joined. The script virtually expands the sheet profiles by this amount to bridge gaps. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
None required. This script operates using standard instance properties.

## Tips
- **Check Thickness**: Ensure that the sheets you want to join have the same thickness. The script will not join sheets of different depths.
- **Alignment**: Sheets must be parallel and lie in the same plane (flush) for the join to work.
- **Tolerance Adjustment**: If you have small modeling gaps (e.g., 2mm gaps between panels), increase the `Tolerance` parameter to slightly more than the gap size before running the script.
- **Selection Order**: The script iterates through selected pairs. It is generally best to select all sheets in the specific area you want to merge at once.

## FAQ
- **Q: Why did my sheets not merge?**
  **A:** Check that the sheets are the same thickness, that their surfaces are flush (coplanar), and that the gap between them is smaller than the `Tolerance` setting.
- **Q: What happens to the original sheets?**
  **A:** The geometry of the second sheet is absorbed into the first sheet. The script instance deletes itself after running.
- **Q: Can I use this to join floor panels to wall panels?**
  **A:** No, the sheets must be parallel and coplanar (in the same plane).