# hsbCLT-ElementSplit

## Overview
This script splits a selected wall element (composed of CLT or SIP panels) into two separate segments at a user-defined location along its length. It allows for the creation of a gap (clearance) between the resulting segments to accommodate connections or tolerances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script interacts directly with 3D wall elements. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**: An existing Wall Element (ElementWall) composed of Sip/GenBeam layers (e.g., CLT or SIP panels).
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-ElementSplit.mcr` from the list, or use the assigned custom command/button.

### Step 2: Configure Gap (if not using a Catalog)
```
Dialog: TSL Properties
Action: Enter the desired Gap value (in mm) between the split elements. Click OK to proceed.
```
*(Note: If the script is inserted via a Catalog Key, this step may be skipped, and the gap will be preset.)*

### Step 3: Select Wall Element
```
Command Line: Select Element
Action: Click on the Wall Element in the model that you wish to split.
```

### Step 4: Define Split Location
```
Command Line: Select point
Action: Click near the wall to define the location where the split should occur. The point will automatically snap to the wall's axis.
```

### Step 5: Completion
The script will process the geometry and split the wall into two distinct elements. If the split cannot be performed (e.g., no panels found), a symbol may be drawn, but the physical split will not occur.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap | Number | 0 | Defines the clearance distance (tolerance) created between the two resulting wall segments after the split. Enter 0 for a butt joint. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Snapping**: You do not need to click exactly on the wall line; the script calculates the closest point on the wall axis to your click.
- **Gap Usage**: Use the `Gap` property when you need space for connection plates, sealants, or construction tolerances.
- **Validation**: Ensure you select a valid Wall Element. If you select a beam or other object, the script will abort with an error message and erase itself.

## FAQ
- Q: What happens if I get the error "ScriptName could not find reference to element"?
  A: This means the object you selected is not a recognized Wall Element (ElementWall). Ensure you are selecting a wall generated in hsbCAD and click to retry.
- Q: Can I undo the split?
  A: Yes, use the standard AutoCAD `UNDO` command to revert the split operation.
- Q: Why did my wall not split physically?
  A: The script requires the wall to have Sip or GenBeam layers (CLT/SIP panels). If the wall consists only of basic lines or has no internal structure detected, the split may only draw a visual symbol.