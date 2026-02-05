# HSB_I-ShowProfiles

## Overview
This script visualizes the Netto (inner) and Brutto (outer) horizontal profiles of a construction zone (Element). It is used to extract 2D cross-sections at specific heights and offsets, allowing you to verify clearances, wall boundaries, and spatial intersections without generating physical 3D solids.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Element geometry in Model Space. |
| Paper Space | No | Not designed for use in Layout views. |
| Shop Drawing | Yes | Can be used to verify geometry contexts, though it generates 3D lines. |

## Prerequisites
- **Required Entities:** An existing hsbCAD Element (Zone) must be present in the drawing.
- **Minimum Beams:** 0 (This script operates on the Element level, not individual beams).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` (or `TSI`), select `HSB_I-ShowProfiles.mcr` from the list, and press Enter.

### Step 2: Configure Properties (Optional)
After insertion, the Properties Palette will automatically appear. You can pre-configure the **Zone Index**, **Offsets**, and **Colors** here before selecting the element, or adjust them afterwards.

### Step 3: Select Element
```
Command Line: Select element:
Action: Click on the desired hsbCAD Element (Zone) in your drawing.
```
*Note: If no element is selected, the script will display a "No element selected" message and erase itself.*

### Step 4: View Profiles
Once the element is selected, the script calculates the profiles based on the properties and draws the lines in the model.

### Step 5: Adjust Visualization (Post-Insertion)
Select the generated script object (or the element if it remains linked) and use the **Properties Palette** to dynamically change the Zone Index or move the lines up/down using the Offset parameters.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **nZoneIndex** | Integer | 0 | Selects the horizontal slice of the element to visualize.<br>• **0-5**: Zones above the element origin.<br>• **6-10**: Zones below the origin (maps 6 to -1, 10 to -5). |
| **sShowProfiles** | Dropdown | Both | Determines which profiles are drawn: **Both**, **Netto** (inner), or **Brutto** (outer). |
| **dOffsetNetto** | Double | 100 mm | The vertical distance to shift the Netto profile along the element's local Z-axis. |
| **dOffsetBrutto** | Double | 150 mm | The vertical distance to shift the Brutto profile along the element's local Z-axis. |
| **nColorNetto** | Integer | 1 | The AutoCAD Color Index (ACI) for the Netto (inner) profile line. |
| **nColorBrutto** | Integer | 3 | The AutoCAD Color Index (ACI) for the Brutto (outer) profile line. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the profile geometry based on the current Element state and script properties. |
| Erase | Removes the visualization script from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; all configuration is handled via the Properties Palette.

## Tips
- **Visual Separation:** Set the `dOffsetNetto` and `dOffsetBrutto` to different values (e.g., 100mm and 150mm) to prevent the inner and outer lines from overlapping, making it easier to distinguish wall thickness.
- **Checking Lower Levels:** To inspect the profile of a floor zone below the ground level (0), use `nZoneIndex` values 6 through 10.
- **Color Coding:** Change the `nColorNetto` and `nColorBrutto` values to colors that contrast with your current CAD background for better visibility.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: This usually happens if you canceled the element selection or did not click a valid hsbCAD Element. Re-run the script and ensure you select a valid Element when prompted.
- **Q: How do I check a profile 2000mm below the origin?**
  A: This script uses fixed zone indices. `nZoneIndex` 10 corresponds to the 5th zone below origin. If you need specific arbitrary heights, you may need to check if your element has specific zones defined at that height, or modify the script logic (if you have coding permissions).
- **Q: Can I use this on a single beam?**
  A: No, this script is designed to work on hsbCAD Elements (Zones/Walls), not individual GenBeams.