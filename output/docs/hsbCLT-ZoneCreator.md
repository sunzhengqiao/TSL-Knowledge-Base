# hsbCLT-ZoneCreator.mcr

## Overview
Converts a specific construction layer (Zone) defined by beams into a solid CLT or SIP panel. It automatically calculates the panel shape, subtracts openings, and replaces the original beams.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D construction elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not a detailing script. |

## Prerequisites
- **Required entities**: An `Element` containing `GenBeams` defining the target zone.
- **Minimum beam count**: 0 (The script validates profiles dynamically).
- **Required settings**: Access to a `SipStyle` catalog to define material layers.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-ZoneCreator.mcr`

### Step 2: Configure Properties
```
Dialog: Properties Palette
Action: Configure the following settings before clicking OK:
- Zone: Select the index of the layer to convert (e.g., 5 for the outermost layer).
- Style: Choose "Auto Selection" to match the thickness, or pick a specific SipStyle.
- Merging: Set a tolerance value to merge gaps between beams (Default is 1).
```

### Step 3: Select Element
```
Command Line: Select elements
Action: Click on the Element in the model that contains the beams you wish to convert.
```

### Step 4: Completion
The script processes the geometry, generates the new panel(s), deletes the original beams in the specified zone, and then removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Dropdown | 5 | Defines the specific construction layer (Zone index) to be converted. Range is -5 to 5. |
| Style | Dropdown | Auto Selection | Defines the panel style. If "Auto Selection" is used, the script attempts to find a style matching the Zone's thickness; otherwise, it creates a new one. |
| Merging | Number | 1 | Defines the tolerance to merge gaps between beams. Set > 0 to catch solid tolerances, but smaller than actual structural gaps. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This is a non-resident script. It erases itself after execution and does not provide persistent context menu options. |

## Settings Files
- **Filename**: `SipStyle` Catalog entries
- **Location**: hsbCAD Company/Install path
- **Purpose**: Provides material definitions and layer makeups for the generated panels.

## Tips
- **Merging Tolerance**: If the resulting panel looks fragmented or has small slivers, try increasing the **Merging** value. If corners are being incorrectly cut off or rounded, decrease it.
- **Undo Function**: Since the script erases itself after running, use the AutoCAD `Undo` command to revert changes if the result is not as expected.
- **Style Management**: If the script creates a new style automatically, it will be named based on the height (e.g., "200"). Check your catalog if you wish to edit material properties later.

## FAQ

- **Q: Can I change the settings after I run the script?**
  **A**: No. This script is non-resident; it erases itself immediately after generating the panel. To change parameters, use Undo (Ctrl+Z) and re-insert the script.

- **Q: What happens to the original beams in the zone?**
  **A**: The script automatically deletes the `GenBeams` that were located in the target zone and replaces them with the solid `Sip` panel.

- **Q: Why did the script fail to create a panel?**
  **A**: Ensure the selected Element actually contains beams in the specified Zone. Also, check that the resulting profile area is large enough to generate a valid solid.