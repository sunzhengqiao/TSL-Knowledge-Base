# hsbCenterOfGravity_setOpeningWeight.mcr

## Overview
This script allows you to assign a specific weight to openings (windows, doors, or assemblies) to improve the accuracy of structural weight calculations. It stores the weight data on the opening so that the `hsbCenterOfGravity` script can include it in the overall building mass calculation.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Opening entities. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Does not generate 2D drawing views. |

## Prerequisites
- **Required entities**: At least one Opening (Window, Door, or Assembly).
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsbCenterOfGravity_setOpeningWeight.mcr`.
3.  Press **Enter**.

### Step 2: Configure Weight
1.  The Properties palette will appear automatically.
2.  Locate the **Weight** parameter.
3.  Enter the total weight of the opening unit in Kilograms (kg).
    *   *Note: If you enter 0, the opening will be ignored in weight calculations.*

### Step 3: Select Openings
1.  The command line will prompt: `Select openings`
2.  Click on the opening(s) in the model to which you want to apply this weight.
3.  Press **Enter** to confirm selection.
4.  **Constraint**: You must select openings that share the **same Style, Width, and Height**. If you select mixed sizes, the script will display an error ("Different openings were selected") and abort the action.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Weight | Number | 0 | Defines the total weight of the opening assembly in Kilograms (Kg). If set to 0, the weight calculation for this opening is disabled. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Batch Assignment**: You can select multiple openings at once, but ensure they are identical in size and type.
- **Editing Weight**: The script instance automatically deletes itself after processing. To change the weight later, simply re-run the `TSLINSERT` command on the same opening and update the value.
- **Data Storage**: The script calculates a "pseudo-density" based on the opening's volume and saves it into the entity's attributes (MapX). This data is read by the `hsbCenterOfGravity` script.
- **Volume Calculation**: If the opening has no solid geometry volume, the script attempts to calculate the volume using the polyline shape and frame width defined in the ModelMap.

## FAQ
- **Q: What happens if I set the Weight to 0?**
  - A: The script will effectively disable weight tracking for that specific opening. The `hsbCenterOfGravity` script will treat it as having no mass or ignore it.
- **Q: Can I select different window sizes at the same time?**
  - A: No. The script requires all selected openings in a single command execution to have the same Style, Width, and Height. Group them by size before running the script.
- **Q: Where is the weight data stored?**
  - A: It is stored as non-geometric data (MapX) directly on the Opening entity under the name `OpeningCOG`.