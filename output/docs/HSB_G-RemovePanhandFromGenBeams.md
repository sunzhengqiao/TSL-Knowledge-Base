# HSB_G-RemovePanhandFromGenBeams

## Overview
This script removes the panhandling (connection and joinery) data from selected General Beams (GenBeams). It effectively resets the connection logic for the selected beams, detaching them from their current joinery assignments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where the GenBeams are located. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for use within Shop Drawing contexts. |

## Prerequisites
- **Required Entities**: General Beams (GenBeams).
- **Minimum Beam Count**: 1 (The script requires at least one valid beam to function).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `HSB_G-RemovePanhandFromGenBeams.mcr`

### Step 2: Select GenBeams
```
Command Line: select genBeams
Action: Click on the General Beams you wish to reset, then press Enter or right-click to confirm selection.
```

### Step 3: View Report
```
Action: The script will display a report notice indicating how many beams were successfully processed.
Action: The script instance will automatically erase itself from the drawing upon completion.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not use Properties Panel parameters. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Re-joining Beams**: Use this script when you need to completely remove existing connection logic (panhands) before applying new joints or if the current connections are causing errors.
- **Clean Up**: The script is designed to run once and then delete itself automatically. You do not need to manually select and delete the script instance after use.
- **Selection**: You can select multiple beams at once using a window selection, provided they are all valid GenBeam objects.

## FAQ
- **Q: Can I use this on standard timber beams?**
  - A: No, this script is designed specifically for **General Beams** (GenBeams). It will not affect standard element beams.
- **Q: The script disappeared immediately without doing anything.**
  - A: This usually happens if no entities were selected or if the selected entities were not valid GenBeams. Ensure you have selected the correct object type before confirming.
- **Q: Will this delete my beams?**
  - A: No, it only removes the connection/joinery data associated with the beams. The geometry of the beams remains in the drawing.