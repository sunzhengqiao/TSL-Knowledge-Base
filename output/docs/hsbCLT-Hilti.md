# hsbCLT-Hilti.mcr

## Overview
Automates the layout and insertion of Hilti HCWL connectors for connecting perpendicular CLT or SIP panels. It calculates connector positions, generates drilling tooling, and manages hardware data for BOMs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D operations and panel selection. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Sip (Structural Insulated Panel) entities.
- **Minimum Beam Count**: 
    - **Connect all panels mode**: At least 2 panels.
    - **Connect single mode**: 1 panel.
- **Required Settings**: 
    - Block file `HCWL.dwg` must exist in the Company Block folder (`_kPathHsbCompany\Block`).
    - Valid Hilti Hardware definitions (HSW).

## Usage Steps

### Step 1: Launch Script
Command: Run the script via the `TSLINSERT` command or the hsbCAD toolbar.

### Step 2: Configure Connection Type
Before or after selecting entities, open the **Properties Palette (Ctrl+1)**. Set the **Connection Type** property to one of the following:
- **Connect all panels**: Automatically finds perpendicular intersections between selected panels.
- **Connect single**: Allows manual placement of a single connector at a specific point.

### Step 3: Select Panels and Place
Depending on the Connection Type selected:

**If "Connect all panels" is selected:**
```
Command Line: Select Sip entities:
Action: Select all Sip panels that form perpendicular connections (e.g., wall-to-floor). Press Enter to confirm.
```

**If "Connect single" is selected:**
```
Command Line: Select Sip entity:
Action: Click on the single Sip panel where the connector should be applied.
Command Line: Specify insertion point:
Action: Click on the edge of the panel where you want the connector to be placed.
```

### Step 4: Adjust Distribution (If applicable)
If using "Connect all panels" mode, adjust the **Distribution** property (Center, Ends, or Equidistant) in the Properties Palette to update the layout automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connection Type | dropdown | Connect all panels | Determines if the script connects all selected panel intersections or places a single connector manually. |
| Distribution | dropdown | Center | Defines the pattern for arranging multiple connectors (Center, Ends, Equidistant). Only used in "Connect all panels" mode. |
| Offset Bottom | number | 500 | Minimum distance from the bottom of the panel to the first connector. |
| Offset Top | number | 500 | Minimum distance from the top of the panel to the last connector. |
| Offset Between | number | 600 | Maximum spacing between connectors when using the "Equidistant" distribution pattern. |
| Fastener Type | number | 1 | Index to select the specific Hilti fastener catalog entry. |
| Fastener | text | | The catalog name or article number of the fastener (e.g., 'SMD-FR 8x80'). |
| OffsetY | number | 0 | Adjusts the connector position along the width of the panel (perpendicular to the edge). |
| OffsetZ | number | 0 | Vertical adjustment applied to the calculated insertion point. |
| Depth | number | 0 | Controls the drilling depth for the fastener hole (0 = automatic/through). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Switches the connector to the opposite side of the panel. Useful if the connector is initially pointing in the wrong direction. |

## Settings Files
- **Filename**: `HCWL.dwg`
- **Location**: `_kPathHsbCompany\Block` (Company Folder)
- **Purpose**: Provides the 3D block geometry used to visually represent the Hilti connector in the model.

## Tips
- Use the **Flip Side** context menu option if the connector generates on the interior face instead of the exterior face (or vice versa).
- When using **Equidistant** distribution, the script calculates the number of connectors based on the panel height minus the top and bottom offsets.
- Ensure your Sip panels are perfectly perpendicular (90 degrees) to each other for the "Connect all panels" mode to detect the connection correctly.

## FAQ
- **Q: Why are the Offset properties grayed out?**
  - A: These properties are only active when "Connection Type" is set to "Connect all panels". In "Connect single" mode, the position is determined by the clicked point and the OffsetY/OffsetZ values.
- **Q: The script says "No male panel found" in single mode.**
  - A: Ensure you have selected a valid Sip panel entity before picking the insertion point.
- **Q: How do I update the fastener size after insertion?**
  - A: Select the connector instance, open the Properties Palette, and change the "Fastener Type" index or "Fastener" string to update the BOM data.