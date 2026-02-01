# GE_WALL_SET_EXPOSURE_TO_BEAMS.mcr

## Overview
This utility script synchronizes the exposure setting (Interior/Exterior) of selected Wall Elements to the SubLabel of all beams contained within those walls. It is designed to quickly tag beams for reports or export filters without needing to edit each beam individually.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Wall Elements and their beams in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate drawing views. |

## Prerequisites
- **Required Entities**: Wall Elements that contain beams.
- **Minimum Beam Count**: 0 (The script processes walls regardless of beam count, though it updates beams if present).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_SET_EXPOSURE_TO_BEAMS.mcr` from the file dialog.

### Step 2: Select Wall Elements
```
Command Line: |Select element(s)|
Action: Click on one or more Wall Elements in the drawing area. Press Enter to confirm selection.
```

*Note: The script will automatically process the selection, update the beam properties, and then remove itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the entity context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Verify Wall Settings**: Ensure your Wall Elements have the correct "Exposure" (or "Exposed") property set (0 for Interior, 1 for Exterior) before running the script, as this determines what text is written to the beams.
- **Batch Processing**: You can select multiple walls at once to speed up the tagging process for an entire floor or project.
- **Data Export**: Use this script to prepare your model for data export. The "Interior" and "Exterior" labels applied to beam SubLabels can be used to filter lists or CNC exports.

## FAQ
- **Q: What text does the script write to the beams?**
  - **A**: It writes "Interior" if the wall exposure is 0, or "Exterior" if the wall exposure is 1.
- **Q: Do I need to delete the script instance after running it?**
  - **A**: No, the script automatically cleans up and erases itself from the drawing immediately after processing.
- **Q: Can I use this on single beams?**
  - **A**: No, this script is designed specifically to read Wall Elements and update the beams inside them. It does not work on single beams selected outside of a wall composition.