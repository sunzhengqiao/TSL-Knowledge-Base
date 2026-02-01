# HSB_E-ZoneProfiles.mcr

## Overview
This script allows you to visualize and interactively modify the contour profiles of specific material zones (layers) within an Element. It provides on-screen grips to stretch edges or move corners, updating the Element's geometry in real-time.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates within the 3D model to modify Element geometry. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a modeling tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: An existing Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: 0 (Operates on the Element level).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ZoneProfiles.mcr`
*(Alternatively, click the custom toolbar button assigned to this script.)*

### Step 2: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Element(s) you wish to modify and press Enter.
```
*The script will attach itself to the selected Element(s). If run multiple times on the same Element, old instances are automatically replaced.*

### Step 3: Configure Zone and Grips
Select the Element (or the script instance if visible) to open the **Properties Palette**.
1.  **Zone Index**: Set the dropdown to the specific material layer (1-10) you want to edit.
2.  **Active Grippoints**: Choose `|Edge|` to stretch walls or `|Corner|` to move specific vertices.

### Step 4: Modify Geometry
```
Action: Click and drag the blue square grips displayed on the Element profile.
```
*Moving a grip updates the shape of the selected Zone immediately.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Text | - | **(Read-only)** Visual category separator for Zone settings. |
| Zone index | Dropdown | 1 | Selects which material zone (layer) of the element to visualize and edit (Range 1-10). |
| Active grippoints | Dropdown | \|Edge\| | Determines how the profile is modified: <br> - `|Edge|`: Grips appear at edge midpoints to stretch the profile.<br> - `|Corner|`: Grips appear at vertices to move corners. |

## Right-Click Menu Options
None. The script is controlled via the Properties Palette and on-screen grips.

## Settings Files
None.

## Tips
- **Multiple Zones**: If your Element has multiple layers (e.g., Studs + Insulation), change the **Zone index** to switch between editing the Stud layer or the Insulation layer without re-inserting the script.
- **Switching Modes**: Changing the **Active grippoints** from `|Edge|` to `|Corner|` (or vice versa) will reset the grip positions to match the new logic.
- **Selection**: You can select multiple Elements during the insertion prompt to apply the tool to several parts at once.

## FAQ
- **Q: Why don't I see any grips?**
  A: Ensure you have selected the correct **Zone index**. If the selected zone has no geometry or is invalid, grips may not appear. Also, check if your Element is frozen or on a locked layer.
- **Q: Can I use this to create a complex shape from scratch?**
  A: This tool is designed to modify *existing* zone profiles (e.g., creating a notch or adjusting a diagonal cut). You generally start with a standard Element and deform it using the grips.
- **Q: What happens if I change the Zone index?**
  A: The script immediately clears the current grips and recalculates them based on the shape of the new Zone selected. The visual display updates to show the new profile.