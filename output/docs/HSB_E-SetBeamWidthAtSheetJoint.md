# HSB_E-SetBeamWidthAtSheetJoint.mcr

## Overview
Automatically detects beams located behind sheet joints and modifies their width, color, and beam code. It also automatically adjusts intersecting blocking beams to prevent collisions after the width changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D construction elements |
| Paper Space | No | Not applicable for 2D drawings |
| Shop Drawing | No | Does not generate shop drawings |

## Prerequisites
- **Required Entities**: Elements containing Sheets and Beams.
- **Minimum Beam Count**: 0 (Script works on the geometry available).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
- Select `HSB_E-SetBeamWidthAtSheetJoint.mcr` from the file browser.

### Step 2: Configure Properties
The Properties Palette will appear automatically upon insertion.
- Set the **Zone index sheeting** to match the layer of sheets you are working with.
- Set the **New beam width** to the desired size (e.g., 36mm).
- Configure **Beam Zones** or **Painter Filter** if you only want to affect specific structural zones.

### Step 3: Select Elements
```
Command Line: Select element(s)
Action: Click on the Element(s) (walls/floors) in the model that contain the sheeting and beams you wish to process.
```
*Press Enter to confirm selection.*

### Step 4: Processing
The script attaches itself to the selected elements and immediately processes the beams. Any beams found behind sheet joints in the specified zone will be resized.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index sheeting | dropdown | 1 | Select the sheeting layer (Zone) to analyze. Only joints in this layer will trigger beam changes. |
| New beam width | number | 36 | The width (thickness) to apply to the beams located at sheet joints. |
| Beamcode | text | [empty] | Assigns a specific manufacturing code to the beams at the joints. Leave empty to keep existing codes. |
| Color | number | -2 | Sets the display color of the modified beams. Enter -2 to keep the original beam color. |
| Beam Zones | text | 0 | Filters beams by their structural zone (e.g., "1;2"). Leave empty to consider beams in all zones. |
| Painter Filter | dropdown | <Disabled> | Select a predefined Painter rule to filter specific types of beams (e.g., only structural studs). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses the internal Catalog system to store default settings; no external user settings file is required.

## Tips
- **Visual Verification**: Set the **Color** property to a distinct color (e.g., Red) during setup to visually confirm which beams are being modified before final production settings.
- **Blocking Beams**: The script automatically detects blocking beams (HSB ID 4109 or 4110) and shifts them along their axis if they intersect with the widened studs. You do not need to move these manually.
- **Updating**: To change the width after insertion, select the Element, open the Properties Palette, locate the **HSB_E-SetBeamWidthAtSheetJoint** instance, and modify the **New beam width** value.

## FAQ
- **Q: Why did the script not change any beams?**
- **A:** Check the **Zone index sheeting**. If the sheets in your model belong to Zone 2, but the script is set to Zone 1, no joints will be detected. Also, verify that the **Beam Zones** filter includes the zones where your beams are located.

- **Q: Can I use this to only change the color for identification without changing the size?**
- **A:** Yes. Set the **New beam width** to the current width of the studs (or leave it if it matches) and set the **Color** to your desired index. The script will update the color property only.

- **Q: What happens if I delete a sheet after running the script?**
- **A:** Since the script instance is attached to the Element, modifying the Element (like deleting a sheet) triggers a recalculation. The script will re-run, and beams that were previously at a joint may revert to their original size if the joint no longer exists.