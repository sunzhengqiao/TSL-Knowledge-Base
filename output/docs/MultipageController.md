# MultipageController.mcr

## Overview
This script automatically cleans up and organizes dimension lines within MultiPage layouts. It can remove redundant dimensions and realign remaining lines with consistent spacing to ensure drawings are clean and readable.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to batch process existing Multipage layouts. |
| Paper Space | No | Script runs in the block definition of Shop Drawings. |
| Shop Drawing | Yes | Can be embedded in templates for automatic cleanup during generation. |

## Prerequisites
- **Required Entities**: MultiPage entity (for Model Space execution) or existing ShopDrawViews.
- **Minimum Beams**: None.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `MultipageController.mcr`

### Step 2: Place Script and Select Layouts
```
Command Line: Insertion point:
Action: Click anywhere in the drawing to place the script instance temporarily.
```
```
Command Line: Select Multipage entities:
Action: Select one or more Multipage layouts from the Model Space and press Enter.
```
*Note: After processing, the script instance will automatically delete itself.*

### Step 3: Configure Properties (Optional)
If you wish to configure the script for automatic use within a Shop Drawing template:
1. Insert the script into the desired Shopdrawing block or template.
2. Select the script instance.
3. Adjust parameters in the Properties Panel (see below).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sPurge | Dropdown | No | If set to **Yes**, removes overlapping or duplicate dimension lines. |
| sAlign | Dropdown | No | If set to **Yes**, realigns dimension lines using the offset settings below. **Note:** Offset settings are only visible when this is Yes. |
| sFilter | Dropdown | Any | Filters which dimension lines are processed based on orientation. Options: Any, Horizontal, Vertical, Aligned, Bottom, Top, Left, Right. |
| dBaselineOffset | Number | 10 mm | The distance from the model geometry to the first dimension line. |
| dIntermediateOffset | Number | 8 mm | The spacing between subsequent stacked dimension lines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add View | Prompts you to select an additional ShopDrawView to include in the calculation. |
| Remove View | Prompts you to select a ShopDrawView to remove from the calculation. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Selective Alignment**: Use the `sFilter` property to align only specific types of dimensions (e.g., only Horizontal) without affecting others.
- **Visibility Trick**: You must set `sAlign` to **Yes** in the properties palette to see and edit the `dBaselineOffset` and `dIntermediateOffset` values.
- **Model Space Cleanup**: When running this in Model Space on existing layouts, the script performs the cleanup once and then automatically removes itself from the drawing to prevent clutter.

## FAQ
- Q: Why did the script disappear immediately after I selected the Multipage?
- A: This is normal behavior for Model Space execution. The script performs the cleanup task once and erases itself to keep your drawing clean.

- Q: I cannot see the Baseline Offset or Intermediate Offset properties. Where are they?
- A: These properties are hidden unless alignment is active. Change the `sAlign` property to **Yes**, and the offset properties will appear.

- Q: Can I use this to fix dimensions in a single view only?
- A: Yes. Use the **Remove View** right-click option to isolate only the specific ShopDrawView you wish to correct, then update your properties.