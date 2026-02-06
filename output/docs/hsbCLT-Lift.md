# hsbCLT-Lift.mcr

## Overview
This script inserts lifting hardware (loops, anchors, and sockets) into CLT panels to prepare them for crane lifting on site. It automatically generates the necessary drilling, milling, or slotting geometry and places shop drawing symbols based on the selected hardware type and panel orientation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D CLT Panel geometry. |
| Paper Space | No | Not applicable in Paper Space. |
| Shop Drawing | No | Generates DimRequests that appear in layouts, but insertion occurs in Model Space. |

## Prerequisites
- **Required Entities**: CLT Panels (Elements or GenBeams).
- **Minimum Beam Count**: 1.
- **Required Settings**: Catalog entries for lifting types (Hebeschlaufe, Rampa, Würth, Stahlanker) are recommended to utilize preset sizes and capacities.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Lift.mcr` from the file dialog.

### Step 2: Select Target
```
Command Line: Select CLT Panel
Action: Click on the CLT Wall or Floor/Roof panel you wish to add lifting hardware to.
```

### Step 3: Define Location
```
Command Line: Specify insertion point / [Options]
Action: Click on the face of the panel to place the lifting point.
Note: If the script is launched with a "Distribution" key, it may automatically calculate multiple points based on panel length.
```

### Step 4: Configure (Optional)
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to adjust the hardware type, dimensions, or orientation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Association** | String | Auto | Determines panel orientation. Options: `Auto`, `Wall`, `Roof/Floor`. This rotates the symbol and aligns the drill vector. |
| **Type (sChild)** | String | (Catalog) | Selects the specific hardware model (e.g., H1, R1, W4). This determines the default diameter, depth, and load capacity. |
| **Diameter Override** | Double | 0 | Overrides the drill hole diameter (mm). Set to `0` to use the default diameter from the selected Type. |
| **Depth** | Double | 0 | Sets the drilling depth or anchor embedment depth (mm). Set to `0` to use the default depth from the selected Type. |
| **Edge Offset** | Double | 200 | Distance from the panel edge to the center of the lifting point (mm). |
| **Interdistance** | Double | 0 | Distance between two drill holes for double lifting points (Roof/Floor). Set to `0` for a single point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change Family | Allows switching between different hardware systems (Loop, Rampa, Würth, Steel Anchor) without re-inserting the script. |
| Recalculate | Refreshes the geometry and symbol after property changes. |
| Move | Enables grip-edit mode to drag the lifting point along the panel surface. |

## Settings Files
- **Filename**: Catalog definitions (often company-specific XML or DB catalogs).
- **Location**: hsbCAD company or installation directory.
- **Purpose**: Provide default dimensions (Diameter, Depth) and Load Capacities for specific hardware subtypes (e.g., defining that "W4" has a specific slot size).

## Tips
- **Double Holes for Floors**: When lifting large floors, set **Association** to `Roof/Floor` and enter a value in **Interdistance** (e.g., 600mm) to automatically create a second drill hole for stability.
- **Visual Warnings**: If a red filled circle appears, the panel load exceeds the selected hardware's maximum capacity. If a red volume appears on a Würth wall anchor, the slot is cutting outside the panel geometry.
- **Grip Editing**: You can drag the lifting point grip directly in the model to adjust the position without manually typing the `Edge Offset`.
- **Steel Anchors**: Selecting the `Stahlanker` family automatically adds a secondary side drill (approx. 17mm x 400mm) required for anchor installation.

## FAQ
- **Q: How do I switch from a simple hole to a slot?**
  A: Change the **Type (sChild)** to a Würth variant (e.g., W4) and ensure **Association** is set to `Wall`.
- **Q: My drill hole is going the wrong way (through the thickness vs. from the side).**
  A: Change the **Association** property. `Wall` drills horizontal to the face; `Roof/Floor` drills vertical relative to the panel plane.
- **Q: Why does the drill disappear when I change the Type?**
  A: The new Type might have a default diameter of 0 or be incompatible with the current orientation. Check the **Diameter Override** and ensure the new Type is valid for your current Association setting.