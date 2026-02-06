# hsbCullenSt.mcr

## Overview
This script generates Cullen flat straps or bended straps (ST-PFS) for wind bracing or hold-down applications on wall studs. It automates the creation of 3D geometry and exports hardware data (Straps and Nails) to the Bill of Materials (BOM).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to create bodies and assign hardware. |
| Paper Space | No | Not designed for detailing views. |
| Shop Drawing | No | Does not generate 2D drawings. |

## Prerequisites
- **Required entities**: An `Element` (Wall) or a `GenBeam` (Stud).
- **Minimum beam count**: 1 (script filters for vertical studs within the selection).
- **Required settings**: `hsbSimpsonFB.xml` (Must be present in the Company or Install folder to load product data).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbCullenSt.mcr`.

### Step 2: Select Wall or Stud
```
Command Line: Select Element or GenBeam:
Action: Click on a wall element or a specific stud beam in the model.
```
### Step 3: Automatic Application
The script will automatically identify vertical studs within the selected Element (or the specific beam if selected) that match the current Zone (`sZone`) settings. It will then insert the strap onto the valid stud(s).

### Step 4: Adjust Properties (Optional)
Select the inserted strap instance and open the **Properties Palette** (OPM) to adjust dimensions, offsets, or change the product code as required.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sProductCode | Dropdown | ST-ST-PFS-800 | Selects the specific strap profile (Flat vs. Bended) and length. Changing this updates geometry and nail count (e.g., 4 or 6 nails). |
| dOffset | Number | 0 mm | Sets the standoff distance from the face of the stud. Use this to position the strap behind sheathing materials. |
| dOverhang | Number | 225 mm | Defines how far the strap extends past the end of the stud (top or bottom). |
| dSide | Number | 0 mm | Shifts the strap laterally (left/right) along the face of the stud. |
| sText | String | (Empty) | Custom text label to display on the strap body. If left empty, the Product Code is displayed. |
| dTextHeight | Number | 0 | Height of the text label on the strap. Set to > 0 to enable text; 0 uses default sizing. |
| sZone | Index | Dynamic | Sets the specific wall layer (zone) the strap is assigned to. Only beams in this zone will receive the strap. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties... | Opens the Properties Palette to edit parameters listed above. |
| Erase | Removes the strap instance and hardware assignments from the model. |
| Move | Allows moving the strap to a different location/host (requires re-selection of beam). |

## Settings Files
- **Filename**: `hsbSimpsonFB.xml`
- **Location**: Company or Install path
- **Purpose**: Provides the catalog definitions for the Cullen straps, including dimensions, geometry types (flat/bended), and nail patterns.

## Tips
- **Sheathing Clearance**: If you have sheathing on the wall, increase the `dOffset` property so the strap sits flush against the stud face behind the sheathing.
- **Switching Types**: You can toggle between a "Flat Strap" and a "Bended Strap" simply by changing the `sProductCode` dropdown. The geometry will update immediately.
- **Text Visibility**: If the text label is too large or small, adjust `dTextHeight`. If you want the default product code to show, ensure `sText` is cleared.

## FAQ
- **Q: Why didn't the strap appear on my selected beam?**
  - A: The script only applies to vertical studs. Ensure the beam is upright (Z-axis) and that it belongs to the `sZone` specified in the properties.
- **Q: How do I change the number of nails in the BOM?**
  - A: The nail quantity is determined by the `sProductCode`. Select a different product code (e.g., ST-PFS-50 vs ST-PFS-50-M) to change the nail count (4 vs 6).
- **Q: Can I apply this to multiple studs at once?**
  - A: Yes, if you select a Wall **Element**, the script will iterate through all valid vertical studs in the specified Zone and apply the strap to all of them.