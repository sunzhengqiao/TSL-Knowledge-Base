# SimpsonStrongTieNP.mcr

## Overview
Inserts Simpson Strong-Tie 'NP' series metal nail plates (perforated plates) to connect 2 or 3 timber beams. It supports both standard manufacturer catalog types and custom plate dimensions, including options for double plating and automatic beam trimming.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D modeling and detailing. |
| Paper Space | No | Does not support 2D layout or viewport interaction. |
| Shop Drawing | No | Does not generate shop drawing views or labels directly. |

## Prerequisites
- **Required Entities**: 2 or 3 Timber Beams (`GenBeam`).
- **Minimum Beam Count**: 2 (A third beam is optional).
- **Required Settings**: None (uses internal catalog data).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SimpsonStrongTieNP.mcr` from the file browser.

### Step 2: Select Primary Beam
```
Command Line: Select first beam:
Action: Click on the primary timber beam (Beam 1) that the plate will align with.
```

### Step 3: Select Secondary Beam
```
Command Line: Select second beam:
Action: Click on the secondary timber beam (Beam 2) intersecting or meeting the first beam.
```

### Step 4: Select Optional Third Beam
```
Command Line: Select third beam (press Enter to skip):
Action: Click a third beam if connecting three members, or press Enter to proceed with only two.
```

### Step 5: Specify Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the 3D model to define where the center of the plate will be located.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Geometry & Type** |
| sType | Dropdown | NP15/40/120 | Selects the standard Simpson Strong-Tie product code (e.g., NP15/40/120). |
| sFreeSteelPlate | Dropdown | No | Set to **Yes** to input custom dimensions; **No** uses the standard catalog. |
| dLength | Number | 3000.0 | **Custom Mode Only**: Length of the plate (along the beam axis). |
| dWidth | Number | 1300.0 | **Custom Mode Only**: Width of the plate (perpendicular to beam axis). |
| dThickness | Number | 1.5 | Thickness of the steel plate (mm). |
| **Placement** |
| sSide | Dropdown | Left | Places the plate on the Left or Right side relative to the secondary beam. (Locked if Duplex is Yes). |
| sDuplex | Dropdown | No | Set to **Yes** to create double plates (sandwiching the beams). Locks the Side property. |
| dOffset | Number | 0.0 | Moves the plate along the main beam axis (+/-). |
| **Function** |
| bStretch | Boolean | Yes | If **Yes**, cuts a recess into the timber beams to fit the plate thickness. If **No**, beams remain solid. |
| **Material & BOM** |
| sArticle1 | String | *empty* | ERP Article number for the metal plate. |
| sMaterial1 | String | *empty* | Material specification (e.g., Galvanized). |
| sMod2 | String | *empty* | Model/Type code for the nails. |
| sArticle2 | String | *empty* | ERP Article number for the nails. |
| dLength2 | Number | 0.0 | Length of the nails (mm). |
| dDiameter | Number | 0.0 | Diameter of the nails (mm). |
| nNumNail | Integer | 0 | Total quantity of nails (doubled automatically if Duplex is Yes). |
| **Display** |
| sDescription | Boolean | No | Shows text labels (Name and Dimensions) in the 3D model. |
| nColor | Integer | 0 | CAD Color Index for the plate body. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette (OPM) to modify all parameters listed above. |
| Recalculate | Refreshes the script geometry if manual parameter changes do not update automatically. |

## Settings Files
- **Internal Catalog**: The script contains an internal list of approximately 109 Simpson Strong-Tie NP types. No external XML file is required for standard operation.

## Tips
- **Switching Modes**: To create a custom size not in the catalog, set `sFreeSteelPlate` to **Yes**. This unlocks the `dLength`, `dWidth`, and `dThickness` fields.
- **Double Plating**: Use `sDuplex` = **Yes** to automatically generate mirrored plates on both sides of the connection. This automatically calculates double the amount of nails in your BOM.
- **Visual Clarity**: If the plate is obscuring your view of the beam joinery, set `bStretch` to **No**. This prevents the script from cutting holes in the beams, keeping them solid while the plate sits on top.

## FAQ
- **Q: How do I resize the plate to a non-standard size?**
  - A: Change `sFreeSteelPlate` to **Yes** in the properties palette. Then enter your desired dimensions in `dLength`, `dWidth`, and `dThickness`.
- **Q: Why are my beams being cut/notched when I insert the plate?**
  - A: This is controlled by the `bStretch` property. Set it to **No** to stop the beams from being cut.
- **Q: Can I use this for 3 beams?**
  - A: Yes. During insertion, select a third beam when prompted. The script will calculate the intersection for all three members.
- **Q: The "Side" option is greyed out.**
  - A: This happens when `sDuplex` is set to **Yes**. Since plates are generated on both sides, a specific side selection is not applicable.