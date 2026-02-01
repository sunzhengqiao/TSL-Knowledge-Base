# hsb_CreateMidHeightBlocking.mcr

## Overview
This script automates the generation of horizontal blocking (noggins) within timber wall elements. It provides options for placing blocking between studs, running full wall lengths, or setting specific heights for structural stiffening or cladding backing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted into the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawing views directly. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Wall Element.
- **Minimum Beam Count**: 0 (It works on the element structure itself).
- **Required Settings**: None required to run, though defaults are set.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateMidHeightBlocking.mcr`

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the desired wall element(s) in the model and press Enter.
```

### Step 3: Configure Properties
```
Action: After selection, the script attaches to the element. Select the element and open the Properties Palette (Ctrl+1) to adjust blocking settings (Type, Height, Size, etc.).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type of blocking** | dropdown | Between studs | Determines if blocking is placed between individual studs or runs the full length of the wall. |
| **Height of Blockings** | dropdown | Mid height | Sets the vertical position: Mid height, Mid height of Studs, Zone 0 mid-height, a specific selected height, or two rows at 1/3 heights. |
| **Enter the height for blockings** | number | 1200 | The absolute height (mm) to place blocking if "Height of Blockings" is set to "Selected height". |
| **Minimum blocking length** | number | 50 | The shortest length (mm) allowed for a blocking piece; smaller pieces are skipped. |
| **Cut tolerance** | number | 0 | A small offset (mm) applied to cuts to adjust fit (can be negative or positive). |
| **Cut the blocking flush to flat studs** | dropdown | No | If "Yes", cuts blocking ends perfectly flush against flat studs. |
| **Rotate the blocking to flat studs** | dropdown | No | If "Yes", rotates the blocking orientation to align with flat studs. |
| **Stager the Blocking** | dropdown | No | If "Yes", staggers the blocking pieces so joints do not line up across bays. |
| **Delete above opening** | dropdown | No | If "Yes", automatically removes blocking geometry located above door or window openings. |
| **Set Blocking as NO Nail** | dropdown | No | If "Yes", marks the blocking as "No Nail" for production/CNC outputs. |
| **Beam Color** | number | 32 | Sets the AutoCAD color index for the blocking beams. |
| **Justification** | dropdown | Centre | Aligns the blocking depth to the Front, Centre, or Back of the wall. |
| **Rotate all blocking** | dropdown | No | Rotates the entire blocking member 90 degrees around its longitudinal axis. |
| **Size option** | dropdown | Element timber size | Choose to use the wall's default timber size or specify custom dimensions. |
| **Blocking width** | number | 38 | Custom thickness (depth into wall) when using "Specify size". |
| **Blocking height** | number | 140 | Custom vertical height when using "Specify size". |
| **Length of blocking depends on** | dropdown | Element length | Determines if continuous blocking spans the total element length or just "Zone 0". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the script instance and all associated blocking beams. |
| Properties | Opens the Properties Palette to modify the parameters listed above. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; all configuration is managed via the Properties Palette.

## Tips
- **Full Length Backing**: Use "Type of blocking" set to "Full length of wall" if you need continuous backing for plasterboard or cladding, rather than individual noggins.
- **Openings**: If blocking appears in unwanted areas above windows, switch "Delete above opening" to "Yes".
- **Recalculation**: The script reacts automatically to changes in the wall (e.g., moving studs or changing height). Simply update the wall geometry, and the blocking will adjust.

## FAQ
- **Q: Why are some gaps between studs missing blocking?**
  **A:** Check the "Minimum blocking length" property. If the gap between studs is smaller than this value, the script will skip it to avoid creating tiny, unusable pieces.
- **Q: How do I place blocking at a specific height, like 1000mm from the floor?**
  **A:** Set "Height of Blockings" to "Selected height", and then enter "1000" in the "Enter the height for blockings" field.
- **Q: Can I use different timber sizes for the blocking than the wall studs?**
  **A:** Yes. Change "Size option" to "Specify size" and input the desired dimensions for "Blocking width" and "Blocking height".