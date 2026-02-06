# hsb_SplitBattensAtOpenings.mcr

## Overview
This script automatically cuts holes in sheeting or battening layers (zones) of wall elements to accommodate openings like windows and doors. It respects clearance gaps and can automatically detect specific layers or process user-specified construction zones.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script interacts directly with 3D Elements and Sheets. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required entities**: Wall Elements that contain both Openings and Sheets (battens/sheeting).
- **Minimum beam count**: 0 (Script works on Elements).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBattensAtOpenings.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to process and press Enter.
```
*The script will process these elements and then erase itself automatically once the sheets are split.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zones to split the Sheets | String | Empty | Specifies which construction zones to split. Enter numbers 1-10 separated by a semicolon (e.g., `1;5`). <br>**Note**: Inputs 1-5 map to positive zones (1 to 5), and 6-10 map to negative zones (-1 to -5). If left blank, the script automatically searches for zones with the distribution code `HSB-PL09`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Detection**: If your battens are defined with the distribution code `HSB-PL09`, you do not need to enter anything in the "Zones to split the Sheets" field; the script will find them automatically.
- **Negative Zones**: To split zones on the opposite side of the wall (e.g., Zone -1), enter `6` in the properties. (6=-1, 7=-2, 8=-3, 9=-4, 10=-5).
- **Gaps**: The script uses the gap properties defined in the Opening (Side, Top, Bottom) to calculate the cut-out size.
- **Re-running**: Since the script erases itself after execution, simply run `TSLINSERT` again if you need to re-process the walls after design changes.

## FAQ
- **Q: The script did not cut my battens.**
  **A:** Check the "Zones to split the Sheets" property. Ensure the zone index (1-10) matches the layer where your battens are located. If the property is empty, verify the material/layer of your battens uses the code `HSB-PL09`.
- **Q: What happens if a sheet is completely inside an opening?**
  **A:** Any resulting sheet piece with an area of 5mm² or less is removed and not replaced.
- **Q: Can I select multiple walls at once?**
  **A:** Yes, you can window select or pick multiple wall elements during the insertion prompt.