# hsb_Restraint.mcr

## Overview
Inserts a parametric L-shaped metal restraint or bracket (generic folded plate) attached to a selected timber element. It allows for the definition of dimensions, product codes, and quantities for BOM export and visualization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Generates 3D bodies only. |

## Prerequisites
- **Required entities**: At least one Timber Beam (GenBeam).
- **Minimum beam count**: 1
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Restraint.mcr`

### Step 2: Configure Initial Settings
```
Dialog: Initial Configuration (if applicable)
Action: Verify or modify default settings in the dialog, then click OK.
```

### Step 3: Define Insertion Point
```
Command Line: Pick a Point
Action: Click in the model space to specify the location where the restraint will be anchored.
```

### Step 4: Select Host Element
```
Command Line: Select a Beam
Action: Click on the timber beam to which the restraint will be attached.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Thickness | Number | 2 mm | Material thickness of the metal plate. |
| Width | Number | 36 mm | The lateral dimension (width) of the bracket legs. |
| Length | Number | 100 mm | The length of the bracket legs extending from the insertion point. |
| Quantity | Number | 1 | The count of this restraint instance for material lists/BOM. |
| Show in Disp Rep | Text | [Empty] | Specifies in which Display Representation (e.g., 3D, Plan) the object is visible. |
| Model Type | Dropdown | ST-PFS-50 | The catalog product model code (e.g., ST-PFS-50, RE240). |
| Other Restraint Type | Text | **Other Type** | Custom product code used only when "Other Model Type" is selected above. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom right-click menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Quick Editing**: After insertion, select the restraint and use the Properties Palette (Ctrl+1) to quickly adjust dimensions (Thickness, Width, Length) without re-running the script.
- **Visibility Control**: Use the **Show in Disp Rep** property to hide the restraint in specific views (like floor plans) while keeping it visible in 3D views.
- **Custom Products**: If your specific bracket is not in the "Model Type" dropdown, select "Other Model Type" and enter your product code in the "Other Restraint Type" field.

## FAQ
- **Q: How do I change the quantity for the BOM without drawing multiple brackets?**
  - A: Select the single bracket instance and change the "Quantity" property in the Properties Palette. This updates the BOM export without adding extra geometry.
- **Q: Can I rotate the bracket after inserting it?**
  - A: The orientation is locked to the beam's local axes at the moment of insertion. To change orientation, you typically must delete and reinsert the script, or adjust the rotation of the host beam if applicable.
- **Q: Why did my bracket disappear?**
  - A: Check the "Show in Disp Rep" property. It may be set to a display representation that is currently not active (e.g., set to "Elevation" while you are in "3D" view).