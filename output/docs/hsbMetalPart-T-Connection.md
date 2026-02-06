# hsbMetalPart-T-Connection.mcr

## Overview
This script creates a logical T-connection between a main (female) beam and intersecting (male) beams using a specific metal hardware part (MassGroup). It validates the orientation of the metal part and optionally adjusts the length of the intersecting beams to fit the connection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for constructing assemblies in the 3D model. |
| Paper Space | No | Not designed for layout views or detailing. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities**:
  - **Female Beam**: The main girder or ledger beam.
  - **Male Beam(s)**: One or more intersecting beams (e.g., joists, purlins).
  - **Metal Part**: A MassGroup (hardware component) containing an **EcsMarker**.
- **Minimum Beam Count**: 2 (1 female, 1 male).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or select the script from the hsbCAD Catalog)
**Action**: Select `hsbMetalPart-T-Connection.mcr` from the file dialog or catalog list.

### Step 2: Select Male Beams
```
Command Line: Select male beams
Action: Click on the intersecting beams (e.g., joists) that connect into the main beam. Press Enter to confirm selection.
```
*Note: If no beams are selected, the script will exit and create nothing.*

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the main girder or ledger beam that the male beams connect to.
```

### Step 4: Select Metal Part
```
Command Line: Select metalpart(s)
Action: Click on the steel plate, bracket, or gusset (MassGroup) to be used for the connection.
```

### Step 5: Automatic Validation
The script automatically checks the selected metal part for a valid EcsMarker.
- **Success**: The script instance is created at the marker location.
- **Failure**: If the metal part's marker is perpendicular to the male beams, the script erases itself immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sSide | Enumeration | \|No\| | Determines if the male (intersecting) beams are automatically shortened or lengthened to fit the connection geometry. <br> - **\|No\|**: Beams retain their current length.<br> - **\|Yes\|**: Beams are adjusted to fit the connection. |

## Right-Click Menu Options
The script relies on standard hsbCAD behaviors and Properties Palette modifications. No specific custom context menu items were detected in the source analysis. Standard options like *Update* or *Delete* apply.

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **EcsMarker Orientation**: Ensure the `EcsMarker` inside your metal part catalog is aligned correctly. Its X-axis must run parallel to the male beam direction, not perpendicular. If it is perpendicular, the script will delete the connection to prevent errors.
- **Visual Feedback**: The script draws a small icon/glyph at the origin of the `EcsMarker` on the metal part to indicate a successful connection.
- **Auto-Trimming**: To automatically cut back the joists to accommodate the steel plate, select the connection in the model and change the `sSide` property to `|Yes|` in the Properties Palette.

## FAQ
- **Q: Why did the connection disappear immediately after I placed it?**
  - **A**: The script likely detected an invalid `EcsMarker` orientation. Ensure the X-axis of the marker inside the metal part is not perpendicular to the male beams.
- **Q: Can I use multiple male beams?**
  - **A**: Yes, you can select multiple intersecting beams during the "Select male beams" prompt to connect them all to the same female beam and metal part.
- **Q: How do I change the plate size after insertion?**
  - **A**: Use standard AutoCAD grips or commands to move/replace the metal part. The script will recalculate on the next update cycle. Ensure the new part also has a valid EcsMarker.