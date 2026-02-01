# GE_HDWR_WALL_HOLD_DOWN_ADG

## Overview
This script inserts an ADG series steel hold-down bracket onto wall studs to resist uplift forces. It automatically generates the metal bracket geometry and inserts the appropriate concrete anchor sub-component (such as a J-Bolt or Adhesive anchor) based on catalog selections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D geometry and requires interaction with beams. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Not a layout generation script. |

## Prerequisites
- **Required Entities**: GenBeam (typically vertical wall studs).
- **Minimum Beam Count**: 1.
- **Required Settings Files**:
  - `TSL_HARDWARE_FAMILY_LIST.dxx` (Catalog defining dimensions and types).
  - `TSL_Read_Metalpart_Family_Props.dll` (Utility for reading catalog data).
- **Dependencies**: Sub-scripts for anchors (e.g., `GE_HDWR_ANCHOR_J-BOLT.mcr`, `GE_HDWR_ANCHOR_ADHESIVE.mcr`) must be accessible in the TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_WALL_HOLD_DOWN_ADG.mcr`

### Step 2: Select Hardware
*If running for the first time or using the "Change type" command:*
```
Dialog Box: Select Hardware Family/Type
Action: Select the desired model (e.g., ADG) and configuration from the DotNet dialog. Click OK.
```

### Step 3: Select Beams
```
Command Line: Select beams
Action: Click on the wall stud(s) where you want to install the hold-down. Press Enter to confirm selection.
```

### Step 4: Specify Reference Point
```
Command Line: Specify reference point
Action: Click in the 3D model to indicate the location for the bracket. The script will snap the bracket to the corner of the stud closest to this point.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | String | Catalog Dependent | The specific model identifier of the hold-down hardware (e.g., 'ADG'). |
| dClearWidth | Number | 70mm | The internal width (gap) between the side plates of the bracket. Ensure this matches or exceeds your stud width. |
| dOverallDepth | Number | 560mm | The projection length of the bracket extending perpendicular to the wall (the "leg" reaching the anchor point). |
| dOverallHeight | Number | 50mm | The vertical height of the steel plates. |
| ANCHORMODEL | String | Catalog Dependent | The category of the concrete anchor (e.g., J-Bolt, Adhesive Anchor, Screw Anchor). |
| ANCHORTYPE | String | Catalog Dependent | The specific size or grade of the anchor (passed to the anchor sub-script). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Re-opens the hardware selection dialog. Allows you to switch to a different catalog entry, which automatically updates dimensions and anchor types. |
| Help | Displays a brief usage report and version information in the command line. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `_kPathHsbCompany/TSL/Catalog`
- **Purpose**: Contains the database of available hardware families, dimensions, and default properties for the ADG series.

## Tips
- **Reference Point Logic**: The script calculates the insertion position based on the corner of the stud closest to the point you click. If the bracket lands on the wrong face or end, delete it and click closer to the desired corner.
- **Vertical Beams Only**: The script automatically filters beams; it will generally only attach to elements oriented vertically (studs).
- **Modifying Dimensions**: While you can type numbers directly into the Properties palette, using the **Change type** context menu is recommended to ensure all parameters (width, depth, height, and anchor settings) remain compatible with the hardware catalog.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This usually happens if no beams were selected or if the script failed to find valid catalog data. Ensure `TSL_HARDWARE_FAMILY_LIST.dxx` exists and that you selected a GenBeam before placing the point.
- **Q: How do I switch from a J-Bolt to an Adhesive anchor?**
  **A:** Right-click the installed hardware and select **Change type**. Select the desired configuration from the dialog, which will update the `ANCHORMODEL` and insert the correct anchor sub-component.
- **Q: Can I use this on horizontal beams (plates/headers)?**
  **A:** The script is designed for hold-downs on wall studs and filters for vertical orientation. It may not function correctly on horizontal beams.