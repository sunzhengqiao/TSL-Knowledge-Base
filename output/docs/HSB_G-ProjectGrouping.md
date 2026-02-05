# HSB_G-ProjectGrouping.mcr

## Overview
This script allows you to assign logical production groups (such as Batches, Stacks, or Trucks) to selected Elements in the 3D model. It writes metadata to the elements, enabling better organization for production lists and drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting Elements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Element (e.g., walls, roofs).
- **Minimum beam count**: 0 (Selects Elements, not single beams).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
- Browse and select `HSB_G-ProjectGrouping.mcr`.

### Step 2: Configure Properties
- **Action**: The Properties Palette (OPM) will display the script parameters. Set your desired Group Type and Group Name before proceeding.

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the Elements you wish to group, then press Enter.
```
- The script will immediately apply the grouping data to the selected elements and refresh any visible grouping labels.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group type | Dropdown | Batch | Select the standard production category (Batch, Stacking, Truck). This defines the context for the group (e.g., logistics vs. assembly). |
| Custom group type | Dropdown | [Empty] | Select an alternative category if the standard types do not fit (e.g., SalesOrder). **Note:** If a value is selected here, it overrides "Group type". |
| Group name | Text | [Empty] | Enter the specific identifier for this group (e.g., "Batch-101", "Truck-A", "Order-500"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None.
- **Location**: N/A
- **Purpose**: This script does not require external settings files.

## Tips
- **Visual Feedback**: If you have the "HSB_I-ShowGroupingInformation" or "Batch & Stack Info" scripts loaded in your model, they will automatically update to show the new group names immediately.
- **Overwriting**: Running the script again on the same elements with a different "Group name" will overwrite the previous data.
- **Custom vs Standard**: Use the "Custom group type" dropdown for non-physical groupings (like Sales Orders). If left empty, the script uses the "Group type" setting.

## FAQ
- **Q: Can I group beams individually?**
  - A: No, this script is designed to group Elements (walls/roofs) as whole units.
- **Q: Why didn't the group name appear?**
  - A: Ensure you have entered text in the "Group name" property in the Properties Palette before selecting the elements.
- **Q: Can I undo this action?**
  - A: Yes, you can use the standard AutoCAD Undo command (Ctrl+Z) immediately after running the script.