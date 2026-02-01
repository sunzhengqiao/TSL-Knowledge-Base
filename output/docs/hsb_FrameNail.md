# hsb_FrameNail.mcr

## Overview
This script defines the connection point for a framing nail (nailing bridge) between a wall plate and a stud. It automatically calculates the geometric offsets required for L-shaped studs to ensure correct positioning for manufacturing data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to attach data to elements. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Script is for 3D model detailing only. |

## Prerequisites
- **Required Entities:** 
  - One Wall Plate or Header (Female Beam)
  - One Stud (Male Beam)
  - A parent Wall Element containing these beams
- **Minimum Beam Count:** 2 (One Female, One Male)
- **Required Settings:** 
  - A Catalog entry must exist to initialize default properties (referenced by `_kExecuteKey`).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `hsb_FrameNail.mcr` from the script list.

### Step 2: Configuration
**Interface:** Catalog / Defaults Dialog
**Action:** Confirm the default configuration settings loaded from the catalog (sets the initial Index values).

### Step 3: Define Location
```
Command Line: Pick a Point
Action: Click in the drawing to specify the desired location for the nail connection.
```

### Step 4: Select Wall Plate
```
Command Line: Select Female Beam
Action: Click on the wall plate or header beam that will receive the nail.
```

### Step 5: Select Stud
```
Command Line: Select Male Beam
Action: Click on the stud that the connection references. The script will automatically detect if this is an L-stud to calculate the correct offset.
```

### Step 6: Completion
The script will draw a crosshair and vertical vector at the calculated location in Model Space and attach the necessary data to the wall element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nail Indexes | Number | 0 | An identifier code for the nail connection used in manufacturing exports (e.g., BTL) to link the 3D location to specific tooling or machine instructions. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu items are defined. The script updates automatically when geometry changes. |

## Settings Files
- **Filename:** Catalog Entry (referenced by `_kExecuteKey`)
- **Location:** Defined in your hsbCAD Catalog paths
- **Purpose:** Initializes property values (such as the default Nail Index) when the script is first inserted.

## Tips
- **Visual Indicators:** Look for the crosshair and vertical line drawn in the 3D model; this indicates exactly where the nail point is calculated.
- **L-Studs:** You do not need to manually calculate offsets for L-shaped studs. The script analyzes the stud geometry and adjusts the reference point to the correct face (Left or Right) automatically.
- **Updates:** If you move the wall or adjust the beam sizes using grips, the nail position and data will update automatically to match the new geometry.
- **Export Data:** Remember to set the "Nail Indexes" property correctly if your downstream machinery requires specific codes for different nail types.

## FAQ
- **Q: What happens if I delete the wall plate or stud?**
  - A: The script detects that the required beams are missing and automatically deletes itself to prevent errors.
- **Q: Can I move the nail point after insertion?**
  - A: The script calculates the position based on the beam geometry. To move the nail, you should modify the beam positions or sizes. The script will then recalculate the location.
- **Q: I don't see the nail point in my drawings.**
  - A: The script draws indicators in Model Space. Ensure you are looking at the correct location in 3D and that layers are turned on. The primary output is data attached to the element for manufacturing, rather than a 2D linework symbol.