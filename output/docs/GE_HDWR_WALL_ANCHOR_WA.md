# GE_HDWR_WALL_ANCHOR_WA.mcr

## Overview
This script inserts Wall Anchor (WA) hardware onto vertical timber studs. It allows you to select a hardware configuration from a catalog, automatically generates the required plate geometry and drill holes, and attaches the appropriate anchor bolts based on the selected type.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | 3D insertion only. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: GenBeam (Vertical studs).
- **Minimum Beam Count**: 1.
- **Required Settings**:
  - `\TSL\Catalog\TSL_HARDWARE_FAMILY_LIST.dxx` (Master catalog list).
  - `TSL_Read_Metalpart_Family_Props.dll` (Required for reading catalog data).
  - Family catalog TXT files for the 'WA' family.
  - Anchor sub-scripts (e.g., GE_HDWR_ANCHOR_J-BOLT.mcr).

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` and select `GE_HDWR_WALL_ANCHOR_WA.mcr`.

### Step 2: Select Hardware Type
```
Dialog: Wall Anchor Selection
Action: A dialog box appears automatically. Search or select the specific Wall Anchor configuration (e.g., dimensions and load capacity) from the list and click OK.
```

### Step 3: Select Studs
```
Command Line: Select stud(s)
Action: Click on the vertical timber beams (studs) in the model where you want to install the anchors. Press Enter to confirm selection.
```

### Step 4: Select Reference Point
```
Command Line: Select reference point: hangers will be inserted at closest end and closer face of members
Action: Click in the drawing area near the selected studs. The script will calculate the position based on this point relative to the beams.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Text | WA | The hardware family or type identifier. |
| Clear width | Number | 70 (2.625") | The clear opening width of the hardware. |
| Overall depth | Number | 560 (22") | The total length/depth of the anchor plate. |
| Overall height | Number | 50 (2") | The vertical height/thickness of the plate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Re-opens the hardware catalog dialog, allowing you to swap the current anchor for a different size or configuration. |
| Help | Displays a brief usage message on the command line. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Defines the list of available hardware families (ensures 'WA' is available).

- **Filename**: `TSL_Read_Metalpart_Family_Props.dll`
  - **Location**: hsbCAD Utilities folder
  - **Purpose**: Handles the logic to read specific dimensions and properties from the catalog text files.

- **Filename**: `*.txt` (Family Catalogs)
  - **Location**: `_kPathHsbCompany\TSL\Catalog\`
  - **Purpose**: Contains the specific geometric data (drill patterns, plate sizes) for the selected Wall Anchor.

## Tips
- **Vertical Beams Only**: The script automatically filters and only processes beams that are vertical (parallel to the Z-axis). Horizontal beams selected in Step 3 will be ignored.
- **Positioning**: The "Reference Point" determines which end of the stud the anchor attaches to. Click closer to the top or bottom of the stud to control placement.
- **Modification**: You can move the anchor by dragging its grip point. It will automatically snap to the nearest face of the beam.
- **Beam Deletion**: If you delete the host stud, the anchor hardware will also be automatically removed.

## FAQ
- **Q: Why didn't the anchor appear on my selected beam?**
  **A**: Ensure the beam is strictly vertical. This script is designed for wall studs and ignores horizontal or inclined members.
- **Q: Can I change the anchor size after inserting it?**
  **A**: Yes. Select the anchor, right-click, and choose "Change type" to select a different model from the catalog, or manually edit the dimension properties in the Properties Palette if not locked by the catalog.
- **Q: What happens if I select multiple studs?**
  **A**: The script will insert an instance of the anchor on each valid vertical stud selected, positioning them individually based on their geometry relative to your reference point.