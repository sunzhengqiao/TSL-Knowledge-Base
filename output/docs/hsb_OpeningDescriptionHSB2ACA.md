# hsb_OpeningDescriptionHSB2ACA.mcr

## Overview
This script updates the "Description" property of selected door or window openings to match the internal calculation data from hsbCAD. It ensures that opening tags and schedules in AutoCAD Architecture display the correct size and type information.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the model where the openings are located. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model-level data utility. |

## Prerequisites
- **Required Entities**: At least one `OpeningSF` (opening) entity must exist in the model.
- **Minimum Beam Count**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_OpeningDescriptionHSB2ACA.mcr`.

### Step 2: Select Openings
```
Command Line: Select openings
Action: Click on the door or window symbols (OpeningSF entities) you wish to update. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script does not expose parameters in the Properties palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | N/A |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- Run this script immediately before generating schedules or exporting to AutoCAD Architecture to ensure your tags reflect the latest hsbCAD calculations.
- The script instance is automatically removed from the drawing after execution to keep your project clean.

## FAQ
- **Q: Why would I need to run this?**
  **A**: If the standard AutoCAD description property does not match the specific timber size or type calculated by hsbCAD, this script forces them to match.
- **Q: Did the script work? It disappeared immediately.**
  **A**: Yes, this is expected behavior. The script updates the selected openings and then deletes itself automatically.