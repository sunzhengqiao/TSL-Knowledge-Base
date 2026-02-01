# hsb_CleanupSpandrelApex.mcr

## Overview
This script automates the detailing of wall apexes for stud frame walls in spandrel or gable conditions. It trims angled plates, removes redundant studs at overlaps, and inserts structural blocking where angled top plates meet bottom plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Intended for model detailing only. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Stud Frame Walls).
- **Minimum Beam Count**: 0 (Selects entire wall elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CleanupSpandrelApex.mcr` from the file dialog.

### Step 2: Configure Properties (Optional)
If the script is not launched via a specific execute key, a properties dialog may appear automatically.
```
Action: Adjust the Beam Length, Name, Material, or Grade if needed, then click OK.
```

### Step 3: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the Stud Frame Wall (ElementWallSF) entities you wish to process. Press Enter to confirm selection.
```

### Step 4: Execution
The script will automatically process the selected walls, trim plates, remove conflicting studs, and insert blocking if configured. The script instance will delete itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam Length** | number | 300 | The length (in mm) of the blocking beam to insert at the apex. Set to 0 to perform cleanup only without adding blocking. |
| **Beam Name** | text | Blocking | The catalog name assigned to the blocking beam (used in lists and labels). |
| **Beam Material** | text | CLS | The material code for the blocking beam (e.g., CLS). |
| **Beam Grade** | text | C16 | The structural grade of the timber for the blocking beam. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent context menu items as the instance erases itself after execution. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: No external settings files are required.

## Tips
- **Cleanup Only Mode**: If you only want to trim plates and remove overlapping studs without adding a new blocking beam, set the **Beam Length** property to `0` before running the script.
- **Re-running**: The script instance erases itself after running. If you modify the wall geometry later, you must manually re-run the script on the elements to update the details.
- **Large Overlaps**: The script detects if the overlap between the top and bottom plates is too large. In these cases, it performs cuts and stud removal but skips the blocking insertion to prevent errors.

## FAQ
- **Q: What happens if I change the wall geometry after running the script?**
  - A: The blocking and cuts are not dynamically linked. You must select the wall elements and run the script again to recalculate the apex details.
- **Q: Why didn't the script insert a blocking beam?**
  - A: This usually happens for one of two reasons: 1) The **Beam Length** property is set to `0`, or 2) The script detected a large area of overlap between the plates where a single block isn't appropriate, so it performed a cleanup cut instead.
- **Q: Can I process multiple walls at once?**
  - A: Yes, you can select multiple `ElementWallSF` entities during the selection prompt, and the script will process all of them.