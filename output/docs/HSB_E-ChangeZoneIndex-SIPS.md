# HSB_E-ChangeZoneIndex-SIPS

## Overview
A utility script to batch update the 'Zone Index' attribute for Structural Insulated Panels (SIPs) contained within selected Elements. It allows you to reassign SIPs to different manufacturing or logical zones (e.g., for scheduling or grouping) without needing to regenerate the entire element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements and their associated SIPs. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D detailing. |

## Prerequisites
- **Required entities**: Element (containing Sip entities).
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ChangeZoneIndex-SIPS.mcr`

### Step 2: Set Zone Index
```
Command Line: (Properties Palette opens)
Action: Locate the 'Zone index' field in the Properties Palette (OPM) and enter the desired numerical value.
```

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the Element(s) in the model that contain the SIPs you wish to update. Press Enter to confirm selection.
```

### Step 4: Execution
The script automatically processes the selected Elements, updates the Zone Index for all found SIPs, and then erases itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index | Number | -5 | The numerical identifier for the zone grouping. Valid range is -5 to 10. Note: Inputs 6 through 10 are automatically converted to -1 through -5 respectively. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific context menu options. |

## Settings Files
No specific settings files are required for this script.

## Tips
- **Zone Index Logic**: If you need to set a negative zone index (e.g., -1) but your input method or preference is positive, you can input `6`. The script automatically converts inputs 6-10 to negative values (-1 to -5).
- **Re-running the Script**: This script erases itself immediately after running to keep the drawing clean. If you need to change the zone again, simply re-run the script and select the elements again.
- **Selection**: Ensure you select the parent **Element**, not the individual Sips manually. The script finds the Sips inside the Element for you.

## FAQ
- **Q: Why did the script disappear after I pressed Enter?**
  - A: This is a "run-once" utility script. It updates the data in the background and then automatically removes its instance from the drawing to prevent clutter.
- **Q: I entered '7' as the zone, but it looks different in the report.**
  - A: The script logic converts any input from 6 to 10 into negative numbers. An input of 7 becomes -2.
- **Q: What happens if I select multiple elements?**
  - A: The script will create a temporary instance for each selected element and update the SIPs within all of them sequentially.