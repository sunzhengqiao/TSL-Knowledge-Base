# Hilti-Stockschraube

## Overview
This script automates the insertion of Hilti HSW hanger bolts (Stexons) to anchor wood structures. It calculates drill positions based on intersections between walls and joists or allows manual point placement, while also generating CNC export data for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script inserts drilling tools and BOM entries here. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Structural Elements (Walls/Floors) and Joists (GenBeams).
- **Minimum Beam Count**: 1.
- **Required Settings**:
  - Selected Joists must have **"Hilti"** in their Information field.
  - *Note for Baufritz projects*: Joists must contain **"Stexon"** in their Information field.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-Stockschraube.mcr`

### Step 2: Select Main Elements
```
Command Line: Select element(s), <Enter> to pick points
Action: Select the wall or main structural element the joists connect to.
        Press Enter if you only want to select joists and pick points manually.
```

### Step 3: Select Joists
```
Command Line: Select intersecting joist(s), <Enter> to pick points
OR
Command Line: Select joist(s)
Action: Select the timber beams where the screws will be inserted.
        Ensure these beams have "Hilti" (or "Stexon") in their properties.
```

### Step 4: Define Position (Manual Mode)
```
Command Line: Select point
Action: If the script detects a parallel scenario or you skipped element selection,
        click inside the highlighted intersection area to place the bolt.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| X-Axis Offset | Number | 0 mm | Moves the screw position along the length of the joist. |
| Y-Axis Offset | Number | 0 mm | Moves the screw laterally relative to the joist center. Automatically clamped to maintain safe edge distances. |
| Ausführung | Dropdown | Holzdolle | *Visible for Baufritz projects only.* Selects hardware type: "Holzdolle" (Ø15mm) or "Setzschraube" (Ø5mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Randabstand prüfen | Enables edge distance checking. The screw will turn red and offset will be clamped if too close to the edge. |
| Randabstand nicht prüfen | Disables edge distance checking. Allows manual overrides of safety limits. |
| Hilti Export | Exports production data (geometry and tool info) to a `HiltiExport.dxx` file. Can also be triggered by Double-Clicking the instance. |

## Settings Files
- **None**: This script relies on Project Specials (e.g., "BAUFRITZ") and entity Information fields rather than external XML files.

## Tips
- **Beam Preparation**: Before running the script, ensure your joists have "Hilti" in their Information field, or they will be ignored.
- **Visual Feedback**: If the screw circle turns **Red**, the placement violates the minimum edge distance. Adjust the Y-Axis Offset or disable edge checking via the right-click menu.
- **CNC Export**: Double-click any instance of this script in the model to quickly generate the export file for the entire project.

## FAQ
- **Q: Why are my joists being skipped?**
  A: Check the **Information** field of the beam. It must contain the keyword "Hilti" (or "Stexon" for Baufrix projects).
- **Q: How do I place a screw exactly on the edge?**
  A: By default, the script prevents this. Right-click the script instance and select "Randabstand nicht prüfen" to disable the safety clamp.
- **Q: Where does the export file save?**
  A: The `HiltiExport.dxx` file is saved in the parent folder of the current drawing.