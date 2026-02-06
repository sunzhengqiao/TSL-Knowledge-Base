# hsbLayout-AssignPosnum.mcr

## Overview
Automatically assigns production position numbers (PosNum) to structural beams, sheets, panels, and TSL connections within a selected layout viewport. It filters elements by construction zones and allows independent numbering sequences for structural members and hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script instance is inserted here. |
| Paper Space | No | Although the script works on Viewports located in Layout tabs, the script itself must be inserted in Model Space. |
| Shop Drawing | Yes | Designed for numbering elements in production views. |

## Prerequisites
- **Required Entities**: A Layout Viewport that is linked to a valid structural Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: 0 (Required only if beam numbering is enabled).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayout-AssignPosnum.mcr`

### Step 2: Configure Properties
The Properties dialog may appear automatically, or you can configure settings later via the Properties Palette.
1.  Set **Number GenBeams** to "Yes" to number structural parts.
2.  Set **Number TSLs** to "Yes" to number connection scripts.
3.  (Optional) Enter specific **Start Numbers** for each category.
4.  (Optional) Define specific **Zone List** to filter which layers are numbered.

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on a layout viewport that displays the element you wish to number.
```

### Step 4: Place Script Marker
```
Command Line: Pick a point outside of paperspace
Action: Click anywhere in Model Space to place the script label.
```
*Note: This point determines where the text identifying the script is displayed. The numbering itself happens inside the viewport.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sNoYesGenBeam | dropdown | 1 (Yes) | Determines if structural members (beams, sheets, panels) are included in the numbering process. |
| nStartPosNumGenBeam | number | 1 | The starting integer for the PosNum sequence assigned to GenBeams. |
| sZone | text | "" | Specifies which construction zones to number. Leave empty for all zones, or enter semicolon-separated values (e.g., "1;0;-1"). |
| sNoYesTSL | dropdown | 1 (Yes) | Determines if TSL instances (connections/hardware) are included in the numbering process. |
| nStartPosNumTSL | number | 1 | The starting integer for the PosNum sequence assigned to TSLs. |
| dTextHeight | number | 10 | The height (in current drawing units) of the status text displayed at the insertion point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Select View Port | Re-prompts you to select a different viewport. The script will immediately update the numbering based on the new selection. |

## Settings Files
None. This script relies on direct property inputs.

## Tips
- **Auto-Update**: Changing the "Start number" properties in the Properties Palette automatically triggers the script to re-number the elements.
- **Zone Filtering**: Use the `sZone` property to target specific construction layers (e.g., only number the studs in zone 0).
- **Uniqueness**: This script ensures it is the only instance of its type in the current space. If you insert a second one, the first will be erased automatically.

## FAQ
- **Q: I get the error "no genBeam (beam, sheet or panel) found".**
  A: The script is set to number beams (`sNoYesGenBeam` = Yes), but the selected viewport contains no beams, or they are filtered out by the Zone setting. Either add beams to the viewport, adjust the `sZone` property, or set `sNoYesGenBeam` to "No".
- **Q: How do I renumber the elements after changing the design?**
  A: Simply double-click the script instance or right-click and select "Select View Port", then re-select the same viewport to force a refresh.
- **Q: Can I number beams and TSLs with the same sequence?**
  A: No, this script uses separate counters (`nStartPosNumGenBeam` and `nStartPosNumTSL`). You must manually set the start numbers to avoid overlap if desired.