# hsbOpeningBattens.mcr

## Overview
This script automatically generates timber battens (framing members) around wall openings (windows and doors) in a specific construction zone. It also handles splitting existing sheets or beams at the top of the opening to accommodate the new framing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D model detailing. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the 3D model geometry. |

## Prerequisites
- **Required Entities**: At least one Wall Element (`ElementWallSF`) or Opening (`OpeningSF`) must exist in the model.
- **Minimum Beam Count**: 0
- **Required Settings**: A Painter Definition collection named 'OpeningBattens' is expected. The script will create default entries if this collection is missing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsbOpeningBattens.mcr`

### Step 2: Select Openings/Elements
```
Command Line: Select openings and/or elements
Action: Click on the wall openings or the wall elements themselves where you want to install battens. Press Enter to confirm selection.
```

### Step 3: Configure Properties
After selection, the Properties palette will appear. Adjust the parameters (see below) to define the size, position, and filtering logic for the battens. The script will update automatically as you change values.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 6 | Select the construction layer (Zone index from -5 to 5) where the battens will be placed. This determines height and default material. |
| Width | number | 0 | Defines the thickness of the batten. Enter `0` to use the default width of the selected Zone. |
| Offset | number | 0 | Defines the clearance gap between the opening edge and the batten. Use positive values for a gap and negative values for overlap. |
| Opening Painter | dropdown | `<Disabled>` | Select a Painter Definition to filter which openings receive battens (e.g., only apply to "Windows"). |
| Painter Definition | text | *Hidden* | Internal storage for the painter configuration (used for catalogs). |

## Right-Click Menu Options
This script does not add specific custom options to the right-click context menu.

## Settings Files
- **Filename**: N/A (Uses internal defaults)
- **Location**: N/A
- **Purpose**: The script interacts with the hsbCAD Painter Definitions named "OpeningBattens". If these do not exist in your catalog, the script will generate them automatically.

## Tips
- **Zone Width**: If you want the battens to match the exact thickness of the wall layer (Zone), leave the **Width** property as `0`.
- **Filtering**: Use the **Opening Painter** property to apply battens only to specific types of openings (e.g., apply to windows but skip doors) without selecting them individually.
- **Splitting**: The script automatically calculates where the top batten sits and splits any existing structural beams or sheets in that zone, ensuring clean connections without manual interference.

## FAQ
- **Q: Why are no battens appearing even though I selected an opening?**
- **A: Check the **Zone** setting. If the selected zone does not exist in the wall element, or if the **Opening Painter** is set to a rule that excludes your specific opening, no battens will be generated. Try setting **Opening Painter** to `<Disabled>` to see all openings.
- **Q: How do I make the battens overlap the frame?**
- **A: Enter a negative value in the **Offset** property (e.g., `-10` to move the batten 10mm into the opening).