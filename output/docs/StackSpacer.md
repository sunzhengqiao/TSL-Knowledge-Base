# StackSpacer.mcr

## Overview
This script automatically calculates and generates 3D wooden spacer sticks to separate timber packs or items within a transport stack configuration. It ensures proper spacing for ventilation, stability, and strapping access during logistics.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D geometry and Hardware components. |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | Not designed for manufacturing views. |

## Prerequisites
- **Required Entities**: Existing Stack entities or Packs (TslInst type) must be present in the model.
- **Minimum Beams**: 0 (Script operates on TSL instances representing stacks/packs).
- **Required Settings**: `TslUtilities.dll` must be installed in the hsbCAD path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `StackSpacer.mcr`

### Step 2: Initial Insertion
```
Command Line: Insertion point:
Action: Click in the model space to place the script instance. Initially, no geometry may be visible until entities are linked.
```

### Step 3: Link Stack or Packs
```
Action: Right-click the script instance and select "|Add Stack and/or Packs|".
Command Line: Select stack and/or packs:
Action: Select the desired TslInst stack entities or packs from the model window and press Enter.
```

### Step 4: Adjust Configuration
```
Action: Select the script instance and open the Properties (OPM) palette.
Action: Modify the "Relation" (e.g., Items in Pack vs Pack to Pack) and "Alignments" (Horizontal/Vertical) to match your stacking needs.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sRelation | Selection List | Items in Pack | Defines what the spacers separate: individual items within a pack, separate packs from each other, or span the entire stack. |
| sAlignments | Selection List | Horizontal | Sets the orientation of the spacer sticks relative to the stack (Horizontal or Vertical). |
| tSpacerHeightName | String | \|Spacer Height\| | The property name used to look up the thickness/height of the spacer material. |
| dWidth | Number | ~100mm | The width (cross-grain depth) of the spacer stick. |
| dLength | Number | ~1200mm | The length of the spacer stick. |
| vecX / vecY / vecZ | Vector | View/Stack Coord. | The local coordinate axes determining the rotation of the spacers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| \|Add Stack and/or Packs\| | Prompts you to select additional stack entities or packs to include in the spacer calculation. |
| \|Remove Packs\| | Prompts you to select specific packs to remove from the calculation (only visible if multiple packs are linked). |
| \|Remove Stack\| | Removes the currently referenced stack entity from the calculation. |

## Settings Files
No specific settings files are required for this script.

## Tips
- **Use Grips**: You can drag the spacers interactively using the graphical grips to fine-tune their position along the stack axes.
- **Orientation Switching**: Changing the `sAlignments` property between Horizontal and Vertical will recalculate the geometry and swap the length/width logic automatically.
- **Hardware Generation**: The script automatically creates Hardware components (HardWrComp) based on the spacer dimensions for BOM export.
- **Visual Feedback**: Center lines and cross-section markers are drawn to help visualize the exact placement of the spacers.

## FAQ
- **Q: Why did my script instance disappear after I changed a property?**
  **A:** The script performs a validation check. If the configuration results in zero valid spacers (e.g., gaps are too small or no entities are linked), the instance automatically erases itself. Re-insert the script and check your entity selections.
- **Q: How do I space items inside a single pack versus spacing whole packs?**
  **A:** Change the `sRelation` property in the Properties palette. Select "Items in Pack" for internal spacing or "Pack to Pack" for spacing between different stack units.
- **Q: Can I adjust the position without typing numbers?**
  **A:** Yes, select the script instance and use the blue interactive grips to drag the spacer reference point.