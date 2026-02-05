# HSB_R-ChangeInternalSheeting.mcr

## Overview
This script modifies the properties of internal sheeting layers (such as insulation or boarding) within roof elements based on their spatial relationship to specific structural beams (e.g., knee walls, purlins, or floor beams). It allows you to automatically change materials, thickness, colors, and names for sheets located below, above, or between defined support beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted into the model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities**: At least one Element (e.g., Roof or Wall) containing internal sheeting layers.
- **Supporting Beams**: Structural beams with specific BeamCodes assigned to act as references (if using "Below" or "Above" logic).
- **Settings**: Standard hsbCAD catalogs must contain the materials you wish to assign.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `HSB_R-ChangeInternalSheeting.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select elements
Action: Click on the Element(s) in the model that contain the sheeting you wish to modify and press Enter.
```

### Step 3: Configure Properties
**Action:** After insertion, select the Element and open the **Properties Palette** (Ctrl+1). Scroll down to the "TSL" or "Script" section to configure the parameters (Zone Index, BeamCodes, Materials, etc.).

### Step 4: Apply Changes
**Action:** Change a property value (e.g., Material or Thickness) in the palette. The script will automatically update the sheets in the model. If automatic updates are disabled, right-click the Element and select **Recalculate**.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone index** | dropdown | 6 | Selects which specific sheeting layer (zone) within the construction to modify. Options: 6, 7, 8, 9, 10. |
| **Beamcode of lower supporting beam** | text | (Empty) | Enter the BeamCode of the beam acting as the lower boundary (e.g., "FLOOR_BEAM"). |
| **Material below supporting beam** | text | (Empty) | Sets the material name for sheets located below the lower beam. |
| **Thickness below supporting beam** | number | 11 mm | Sets the geometric thickness for sheets below the lower beam. |
| **Color below supporting beam** | integer | 52 | Sets the display color index (0-255) for sheets below the lower beam. |
| **Name below supporting beam** | text | (Empty) | Assigns a custom name to the sheet entity below the lower beam. |
| **Beamcode of upper supporting beam** | text | (Empty) | Enter the BeamCode of the beam acting as the upper boundary. |
| **Material above supporting beam** | text | (Empty) | Sets the material name for sheets located above the upper beam. |
| **Thickness above supporting beam** | number | 11 mm | Sets the geometric thickness for sheets above the upper beam. |
| **Color above supporting beam** | integer | 52 | Sets the display color index for sheets above the upper beam. |
| **Name above supporting beam** | text | (Empty) | Assigns a custom name to the sheet entity above the upper beam. |
| **Apply Between Supporting Beams** | dropdown | No | If "Yes", applies the "Between" properties to sheets between the defined beams. |
| **Material between supporting beam** | text | (Empty) | Sets the material for sheets between the beams (when Apply Between is Yes). |
| **Thickness between supporting beam** | number | 11 mm | Sets the thickness for sheets between the beams. |
| **Color between supporting beam** | integer | 52 | Sets the color for sheets between the beams. |
| **Name between supporting beam** | text | (Empty) | Assigns a name for sheets between the beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic. Use this if you have manually changed BeamCodes in the model or modified the Element geometry. |
| Erase | Removes the script instance from the Element (does not delete the sheets themselves). |

## Settings Files
- **Catalog Name**: `_LastInserted`
- **Location**: Internal hsbCAD Catalog
- **Purpose**: Stores the last used configuration (Material, Thickness, Codes) so that the next time you insert the script, it remembers your previous settings.

## Tips
- **Thickness Update Behavior**: When you change the thickness, the script shifts the sheet geometry to maintain the correct face alignment (usually the interior face), rather than expanding equally in both directions.
- **Beam Orientation**: The script logic works best when the supporting beams are perpendicular to the Element's Y-axis. Beams running parallel to the main element axis are ignored as height references.
- **Zone Selection**: Ensure the "Zone index" matches the actual sheeting layer index generated by your wall/roof construction preset. (e.g., If your exterior sheathing is layer 0 and your interior lining is layer 1, select the appropriate index from the list).
- **Finding BeamCodes**: If you don't know the BeamCode of your support beam, select the beam in the model and check its Properties under "General" or "Identification" properties.

## FAQ
- **Q: Why didn't my sheets change color or material?**
- **A:** Check that the **Zone index** corresponds to the sheet layer you intend to change. Also, verify that the **Beamcode** entered exactly matches the code of the supporting beams in your model (case-sensitive).
- **Q: What happens if I leave the Beamcode fields empty?**
- **A:** The script will skip the logic for "Above" and "Below" modifications. It will only process the "Between" logic if that option is enabled.
- **Q: How does the script define "Below" or "Above"?**
- **A:** It calculates the center point of the sheet and compares it to the center point of the supporting beam along the Element's Y-axis (vertical/horizontal orientation).