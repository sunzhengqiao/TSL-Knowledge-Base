# hsb_NailPlate.mcr

## Overview
Inserts a parametric or predefined metal nail plate onto a timber beam for structural reinforcement. It supports standard dimensional plates, specific manufacturer blocks (like SpaceStud), and BOM export for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where beams are located. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not supported for 2D drawings. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Timber Beam) must exist in the model.
- **Minimum Beam Count**: 1

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or use the hsbCAD insert menu)
Action: Browse and select `hsb_NailPlate.mcr`.

### Step 2: Configure Properties
```
Action: The Properties Palette (OPM) opens automatically upon first insertion.
```
Select the desired **Model Type** (e.g., NP-80-100 or SpaceStud) and adjust dimensions if necessary.

### Step 3: Pick Insertion Point
```
Command Line: Pick a Point
Action: Click on the beam location where you want to center the nail plate.
```

### Step 4: Select Host Beam
```
Command Line: Select a Beam
Action: Click on the timber beam that will hold the nail plate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Thickness | number | 2.0 | Sets the material gauge (thickness) of the plate. |
| Width | number | 36.0 | Sets the width of the plate (perpendicular to beam length). |
| Length | number | 100.0 | Sets the length of the plate (parallel to beam length). |
| Show in Disp Rep | text | [Empty] | Filter to hide the plate in specific display representations (leave empty to show always). |
| Model Type | dropdown | NP-80-100 | Select a standard preset, "Other Model Type", or a specific block (e.g., SpaceStud 80mm). |
| Other Nail Plate Type | text | **Other Type** | Enter a custom part number here if "Other Model Type" is selected (used for BOM). |
| Select the Face | dropdown | Face 1 | Chooses which side of the beam the plate attaches to (Face 1-4). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. Use grip edits to move. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal settings and does not require external XML files.

## Tips
- **Block vs. Parametric**: If you select specific **Model Types** like "SpaceStud 80mm" or "M20 Nailplate", the script ignores the manual Width/Length/Thickness inputs and draws a detailed 3D block instead.
- **Orientation**: Use the **Select the Face** property to flip the plate around the beam without needing to delete and reinsert it.
- **BOM Export**: To ensure your production lists (MIS) show the correct code, select "Other Model Type" and type your specific part code in the **Other Nail Plate Type** field.

## FAQ
- **Q: I changed the Width/Length, but the plate size didn't update. Why?**
  **A:** You likely have a specific **Model Type** selected (like a SpaceStud or A9). These use fixed 3D blocks. Change the Model Type to a standard "NP" option or "Other Model Type" to enable manual dimensions.
- **Q: How do I put the plate on the side of the beam instead of the top?**
  **A:** Select the plate in the model, open the Properties Palette, and change **Select the Face** to "Face 2", "Face 3", or "Face 4".