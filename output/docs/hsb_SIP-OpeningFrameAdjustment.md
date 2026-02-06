# hsb_SIP-OpeningFrameAdjustment

## Overview
This script automates the adjustment of wall framing around openings for SIP (Structural Insulated Panel) construction. It resizes trimmer and king studs to match the full panel thickness and splits top and bottom plates to accommodate the wider framing, ensuring a proper fit for high-performance building envelopes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run on 3D wall elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Script modifies the 3D model, not drawing views. |

## Prerequisites
- **Required Entities**: ElementWall entities containing structural Beams and SIP panels.
- **Minimum Beam Count**: 0 (However, walls must contain openings with framing to have a visible effect).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SIP-OpeningFrameAdjustment.mcr` from the file browser.

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the ElementWall entities in the model that you wish to process. Press Enter to confirm selection.
```

### Step 3: Completion
The script will automatically process the selected elements, resize the studs, split the plates, and then delete itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-configurable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are provided. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Double Stud Requirement**: The script specifically looks for "stud banks" (groups of studs) on the left and right sides of openings. It only processes openings where there is more than one stud (e.g., a King stud and a Trimmer stud). Single studs at openings will be ignored.
- **Execution Order**: Run this script after generating the SIP walls but before creating final shop drawings or exports.
- **Self-Cleaning**: This is a "one-shot" script. It will automatically erase its own instance from the drawing immediately after modifying the wall geometry.

## FAQ
- **Q: Why did my studs not resize?**
  - **A:** The script logic requires at least two studs adjacent to each other at the opening jamb (a bank size > 1). If you only have a single trimmer or king stud, the script will skip that opening to avoid errors.
- **Q: How does the script know what thickness to use?**
  - **A:** It calculates the required thickness based on the height (`dH`) of the first SIP panel found within the selected Element.
- **Q: Can I undo the changes?**
  - **A:** Yes, you can use the standard AutoCAD `UNDO` command to revert the geometry changes, though you will need to re-insert the script to run it again.