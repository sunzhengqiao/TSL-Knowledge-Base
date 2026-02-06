# hsb_SIP-SetPanelMaterial

## Overview
This script allows you to batch-update the material assignment for all Structural Insulated Panels (SIPs) contained within a selected building element. It is useful for quickly changing material specifications (e.g., from OSB to Magnesium Oxide) for an entire wall or roof assembly without editing individual panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where Elements exist. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script edits model data, not drawing views. |

## Prerequisites
- **Required Entities**: An Element (e.g., a wall or roof) that contains Sip entities.
- **Minimum Beam Count**: 0.
- **Required Settings**: None.
- **Material Database**: The Material Name you enter must exist in your hsbCAD material catalog.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to and select `hsb_SIP-SetPanelMaterial.mcr`.

### Step 2: Configure Material
The script properties dialog will appear automatically upon insertion.
```
Dialog: hsbCAD Properties
Action: Enter the desired Material Name (e.g., "SIP_MgO") in the "Material Name" field.
```
*Note: Ensure this name matches exactly with a material defined in your project material list.*

### Step 3: Select Element
```
Command Line: Select Element
Action: Click on the building element (Wall/Roof) that contains the SIP panels you wish to update.
```
The script will immediately process the element, update the materials, and then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material Name | text | SIP | The name of the material to assign to all SIPs in the selected element. This must match an existing material in the hsbCAD database. |

## Right-Click Menu Options
*None. This script is a "fire-and-forget" utility that erases itself immediately after running to avoid cluttering the drawing.*

## Settings Files
*No external settings files are used by this script.*

## Tips
- **Verification**: After running the script, select a Sip panel within the element and check the AutoCAD Properties Palette to verify the "Material" field has updated.
- **Batching**: To apply different materials to different walls, simply run the script multiple times.
- **Case Sensitivity**: Ensure the material name spelling matches your catalog exactly (check via the hsbCAD Material Manager if unsure).

## FAQ
- **Q: The script disappeared after I selected the element. Did it fail?**
  - A: No. This is normal behavior. The script automatically erases itself after completing the update to keep your drawing clean.
- **Q: Nothing happened when I ran the script.**
  - A: Check that you selected an Element which actually contains Sip entities. If the element is empty or contains only beams, the script will exit silently.
- **Q: Can I undo this?**
  - A: Yes, use the standard AutoCAD `UNDO` command to revert the changes if the script produced unwanted results.