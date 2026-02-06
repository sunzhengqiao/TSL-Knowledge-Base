# hsb_SetDynamicCustomDetail.mcr

## Overview
This script automatically assigns specific construction details to the left and right ends of wall elements based on the sheet thickness (cladding depth) of intersecting walls. It ensures that the correct junction detail codes (e.g., for sheeting overlap or recesses) are applied dynamically without manual calculation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D model modification and detailing. |
| Paper Space | No | Not designed for layout views or 2D drawings. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required entities:** Wall elements (`ElementWallSF`).
- **Minimum beam count:** 0 (User selects a set of elements).
- **Required settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetDynamicCustomDetail.mcr` from the file dialog.

### Step 2: Select Walls
```
Command Line: Select a set of elements
Action: Click on the wall elements in the model that require their end details to be updated. Press Enter to confirm selection.
```

*Note: Upon confirmation, the script attaches itself to the selected walls and immediately calculates the required details based on current connections. The initial script instance will disappear, but the logic remains active on the selected walls.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose user-editable properties in the Properties Palette. It uses a predefined internal lookup table for thicknesses and detail codes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: The script relies on hardcoded lookup tables for thicknesses (9, 12, 15... 92mm) and detail suffixes ("6" through "16").

## Tips
- **Thickness Matching:** The script only recognizes specific sheet thicknesses: **9, 12, 15, 18, 19, 22, 28, 30, 35, 60, and 92 mm**. If your connecting wall cladding falls outside these values, the detail will not be set.
- **Junction Location:** The connection must be physically located within **5mm** of the wall's Start (Left) or End (Right) point. Mid-span connections are ignored.
- **Dynamic Updates:** If you modify the geometry or material thickness of a *connected* wall, this script will automatically recalculate and update the detail code on the main wall the next time the model updates.
- **Removing the Script:** To stop the walls from updating automatically, select the wall, open the TSL Instance list (element properties), and delete this script instance.

## FAQ
- **Q: Why did the detail not update on my wall?**
  **A:** Check two things: 1) Ensure the connecting wall's total sheet thickness matches one of the supported values (e.g., 12mm, 15mm). 2) Ensure the intersecting wall is actually touching the very end of the main wall (within 5mm).
- **Q: How does it calculate the thickness?**
  **A:** It sums up the thickness of Construction Zones 1 through 5 (Front side) or Zones -1 through -5 (Back side) of the *connecting* wall.
- **Q: Can I change the detail codes it assigns?**
  **A:** Not through the interface. The mapping codes (O6, O7, etc.) and thickness values are defined inside the script code.