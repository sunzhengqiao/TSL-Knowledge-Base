# HSB_S-CorrectOrientation

## Overview
Automatically corrects the orientation of Structural Insulated Panels (SIPs) within selected elements. The script rotates the local X-axis of the panel by 90 degrees if the panel's width is greater than its length, ensuring the X-axis aligns with the longest side.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Elements within the Model Space. |
| Paper Space | No | Not designed for use in Paper Space. |
| Shop Drawing | No | Not designed for use in Shop Drawings. |

## Prerequisites
- **Required Entities**: Elements (containing SIPS).
- **Minimum Beam Count**: N/A (Processes Elements, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_S-CorrectOrientation.mcr`

### Step 2: Select Elements
```
Command Line: |Select elements|
Action: Click on the desired Elements in the model that contain the SIPs you wish to check. Press Enter to confirm selection.
```

*(Note: The script will automatically process the selected elements and erase itself upon completion.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script does not expose any user-configurable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Best for Imported Data**: This script is particularly useful for correcting elements imported from other formats where the local coordinate system of the SIPs may not align with the panel length.
- **Automatic Cleanup**: The script instance is removed from the drawing automatically after the correction is applied, keeping your drawing clean.
- **Selection**: You can select multiple elements at once to batch-process orientation corrections.

## FAQ

- **Q: How do I know if a panel has been corrected?**
  A: The script only modifies panels where the Width is strictly greater than the Length. You can check the orientation of the local X-axis (often indicated by the UCS icon or material direction) of the SIP before and after running the script.

- **Q: Why did the script disappear after I ran it?**
  A: The script is designed as a "command" script. It performs the check, updates the geometry, and then removes its own instance from the model automatically.

- **Q: Can I use this on individual beams without an Element?**
  A: No, this script requires an Element entity to function. It searches for SIPS contained within the selected Elements.