# hsbT-Connection

## Overview
Automates the creation of structural T-connections between a male beam (stud/joist) and female beams (plates). It generates precise pocket cuts into the female beams and trims the male beam to length based on specified depth, gap, and rotation parameters.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D GenBeam entities. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Does not process 2D shop drawings. |

## Prerequisites
- **Required entities**: At least two `GenBeam` entities (beams).
- **Minimum beam count**: 2 (one Male beam, one or more Female beams).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbT-Connection.mcr`

### Step 2: Select Male Beam
```
Command Line: Select male beam:
Action: Click on the stud or joist that will connect into the other beams.
```

### Step 3: Select Female Beams
```
Command Line: Select female beams / <Enter> for search:
Action: Click the plate or beam(s) that need the pocket cut. Alternatively, press Enter to automatically search the model for intersecting beams.
```

### Step 4: Confirm and Generate
```
Command Line: 
Action: Press Enter to finish selection and generate the connection tools.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Depth/Distance | Number | 0 | **(+) Depth:** Cuts into the female beam by this amount.<br>**(-) Distance:** Creates a visual symbol only (no physical cut). |
| (B) Gap | Number | 0 | Defines the clearance tolerance around the male beam within the pocket cut. |
| Rotated Beam | Dropdown | No | If "Yes", the cut face aligns with the rotation of the male beam. If "No", the cut is perpendicular to the female beam. |
| (C) Max. Stud Length | Number | 0 | Filters male beams by length. Only beams shorter than this value are processed (0 = no limit). |
| (D) Element Rule | Dropdown | Disabled | Logical filter to exclude specific plates (e.g., bottom/top) or only connect studs against top plates. |
| (E) byColor/Beamtype | Text | | Filter male beams by color index or beam type. Separate entries with semicolons (e.g., "1;2"). |
| (F) byWidth | Text | | Filter male beams by width. Separate entries with semicolons (e.g., "60;45"). |
| byBeamCode/byFormat | Text | | Filter male beams by a specific token in their BeamCode or Format name. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reset + Erase | Applies a static cut to the male beam at the current location and erases the script instance, preventing further updates. (Also triggered by Double-Click). |

## Settings Files
None.

## Tips
- **Visual Mode**: Set **Depth/Distance** to `0` or a negative value to generate a graphical symbol without cutting the beams. This is useful for planning layouts without committing to geometry changes.
- **Bulk Processing**: If working with a framed wall, you can use the "Select female beams / <Enter> for search" option to automatically find all plates intersecting a single stud, rather than picking them manually.
- **Locking Connections**: If you want to prevent the script from updating if beams are moved later, double-click the script instance (or use Right-Click > Reset + Erase) to bake the cut into static geometry.

## FAQ
- **Q: Why did the script generate a symbol but not cut my beams?**
  A: Check the **(A) Depth/Distance** property. If the value is `0` or negative, the script creates a visual symbol only. Change it to a positive value (e.g., 50mm) to generate physical cuts.

- **Q: The script is missing some studs in my wall.**
  A: Check your filter settings. If **(C) Max. Stud Length** is set too low, or the **(E) byColor/Beamtype** filter excludes the color/type of your studs, they will be ignored.

- **Q: How do I undo the connection after using "Reset + Erase"?**
  A: You cannot "undo" this action via the script because the script instance is deleted. You must manually use the AutoCAD `UNDO` command to revert to the state before the script was erased.