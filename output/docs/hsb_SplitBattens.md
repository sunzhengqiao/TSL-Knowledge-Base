# hsb_SplitBattens.mcr

## Overview
This script automatically splits long battens (e.g., sheathing or furring strips) within a wall or roof element into optimized lengths. It aligns cut locations with structural studs for fastening and staggers joints between rows to ensure structural stability.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto a Wall or Roof Element in the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Modifies the physical model, not drawing layouts. |

## Prerequisites
- **Required Entities**: A Wall or Roof Element containing generated beams (GenBeams) acting as battens.
- **Minimum Beam Count**: At least one batten beam in the specified Zone.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBattens.mcr`
*Alternatively, type the assigned command alias if configured.*

### Step 2: Configure Settings
A dialog will appear automatically upon first launch.
**Action**: Adjust the settings for Distribution location, Zone, Maximum/Minimum lengths, and Cut type. Click OK to confirm.

### Step 3: Select Element
```
Command Line: Select one, or more elements
Action: Click on the Wall or Roof element(s) containing the battens you wish to split.
```

### Step 4: Execution
The script will automatically process the selected elements, split the battens, and then delete its own instance. No further user input is required.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution location | dropdown | \|Top left\| | Determines the starting corner and direction for staggering rows (e.g., Top left, Top Right). |
| Zone to Redistribute the Battens | dropdown | 1 | The construction layer index (1-10) containing the battens to be processed. |
| Maximum batten length | number | 4800 | The maximum stock length (in mm) allowed for a single batten piece. |
| Minimum batten length | number | 100 | The shortest allowable length (in mm) for a cut piece; prevents tiny offcuts. |
| Trim waste length by | number | 4 | Deduction (in mm) applied to the carry-over waste to account for saw kerf or cutting margin. |
| Filter Material | text | | Filters beams by material name (e.g., "C24"). Leave empty to process all materials in the zone. |
| Cut orientation | dropdown | \|Angled cut\| | Determines the cut profile: "Angled cut" or "Straight cut". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance deletes itself immediately after execution. No right-click context menu options are available. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Re-running Risks**: Since this script permanently modifies the geometry and deletes itself, running it a second time on the same element may cause errors or unintended double splits. Use with caution.
- **Filtering**: If you have structural studs in the same zone as battens, use the **Filter Material** property to ensure only battens are split.
- **Stud Alignment**: Ensure your wall/roof has generated structural studs perpendicular to the battens; the script uses these studs to determine optimal cut locations.

## FAQ
- **Q: Why did nothing happen when I ran the script?**
- **A**: Check that the **Zone to Redistribute** parameter matches the actual zone where your battens are generated. Also, verify that the battens are longer than the **Maximum batten length** setting.
- **Q: Can I undo the changes?**
- **A**: Yes, you can use the standard AutoCAD `UNDO` command to revert the changes, provided you have not exceeded your undo history limit.
- **Q: How do I change the cut angle?**
- **A**: Modify the **Cut orientation** property in the Properties Palette before running the script.