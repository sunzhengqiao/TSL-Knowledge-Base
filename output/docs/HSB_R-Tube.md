# HSB_R-Tube

## Overview
Inserts a ventilation or service tube (chimney/soil stack) through a roof element. It automatically generates structural framing trimmers, cuts holes in rafters/sheathing, and applies CNC tooling based on specified dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D beams, sheets, and bodies. |
| Paper Space | No | Not designed for 2D shop drawings. |
| Shop Drawing | No | Model-space script only. |

## Prerequisites
- **Required Entities**: A Roof Element (e.g., `Element` or flat roof).
- **Minimum Beam Count**: 1 (The element must contain structural beams to trim or drill).
- **Required Settings**: None strictly required, though a Joinery Catalog file is needed if using the integrated timber connections option.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-Tube.mcr` from the list.

### Step 2: Select Roof Element
```
Command Line: Select Roof Element:
Action: Click on the roof element (or the surface of the element) where you want to insert the tube.
```
The script will attach to the element and generate initial geometry at the origin (0,0) of that element's coordinate system.

### Step 3: Configure Position
1. Select the inserted script instance.
2. Open the **Properties Palette** (Ctrl+1).
3. Adjust the **Reference Position** (e.g., Eaves, Ridge) to align the insertion logic.
4. Set **OffsetFromLeft** and **OffsetFromRight** to move the tube to the desired location on the roof slope.

### Step 4: Adjust Geometry and Structure
1. Modify **Tube Diameter** to match your specific pipe size.
2. Toggle **Apply Horizontal Trimmers** and **Apply Vertical Trimmers** as needed for structural support.
3. Set **Split Rafters** to `Yes` to cut existing rafters and frame the opening, or `No` to simply drill holes through them.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **TubeDiameter** | Number | 100 mm | The outer diameter (or width if rectangular) of the tube. Defines cutout sizes. |
| **LengthExtension** | Number | 0 mm | Additional length added to the tube model beyond the roof surface (useful for insulation/flashings). |
| **AngleToVertical** | Number | 0° | Tilt of the tube. 0° = Plumb (vertical). Set to roof pitch to make tube perpendicular to the roof surface. |
| **ReferencePosition** | Dropdown | Eaves | Determines the reference line for calculating the tube's insertion point (e.g., Eaves, Ridge, Valley). |
| **OffsetFromLeft** | Number | 0 mm | Horizontal distance from the reference line to the tube center. |
| **OffsetFromRight** | Number | 0 mm | Horizontal offset from the right reference point. |
| **ApplyHorizontalTrimmers** | Boolean | Yes | Creates top and bottom trimmers parallel to the rafters. |
| **ApplyVerticalTrimmers** | Boolean | Yes | Creates side trimmers (studs) perpendicular to the rafters. |
| **dBmW** (Trimmer Width) | Number | 45 mm | The width/thickness of the generated trimmer beams. |
| **dHTrimmers** (Trimmer Height) | Number | -1 mm | The height of the trimmer beams. A value of -1 matches the parent rafter height. |
| **SplitRafters** | Boolean | No | If Yes, cuts existing rafters and creates new segments stopping at the trimmers. If No, drills holes through rafters. |
| **CreateTubeAsBeam** | Boolean | No | If Yes, creates the tube as a structural GenBeam (for BOM listing). If No, creates it as a graphical Hardware body. |
| **ApplySheet** | Boolean | Yes | If Yes, cuts the roof sheathing to accommodate the tube. |
| **SheetZone** | Integer | 5 | Specifies which layer of the roof sheathing (e.g., top layer) to cut. |
| **IntegratedTimberTslCatalog** | String | (Empty) | Name of a joinery catalog (e.g., dovetails) to apply auto-connections between trimmers and rafters. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Copy to Element** | Prompts you to select a different roof element and duplicates the current tube configuration to the new element. |
| **Recalculate** | Refreshes the script geometry based on current property values (useful if manual edits broke associations). |
| **Erase** | Deletes the script instance. If rafters were split, the script attempts to restore/merge them back into their original state. |

## Settings Files
- **Beam Filters**: `HSB_G-FilterGenBeams` (Optional)
  - Used if you need to filter which specific beams within the element are treated as rafters for trimming/drilling.
- **Joinery Catalogs**: User-defined catalogs (e.g., `.cat` or specific TSL catalogs).
  - Referenced by the `IntegratedTimberTslCatalog` property to add woodworking joints to the trimmers.

## Tips
- **Splitting vs. Drilling**: Use **Split Rafters** (`Yes`) for large openings that require structural headers. Use **Drill** (`No`) for small vents where keeping the rafter continuous is acceptable.
- **Vertical vs. Perpendicular**: Most ventilation pipes need to be plumb (`AngleToVertical` = 0). However, some flues must exit perpendicular to the roof surface; set `AngleToVertical` to your roof pitch angle in this case.
- **Mirroring Roofs**: If you mirror a roof element that contains this script, the script may self-delete if the new insertion point falls outside the element profile. Simply re-run the script on the mirrored element.
- **Oval Tubes**: You can create a rectangular or oval profile by setting the `TubeDiameter` (Width) and ensuring a secondary height dimension is active (if the script supports separate height inputs, otherwise it assumes circular based on available parameters).

## FAQ
- **Q: Why did my roof rafters disappear or get split unexpectedly?**
  - A: You likely have the **Split Rafters** property set to `Yes`. Change it to `No` if you only want a hole drilled through the rafters without cutting them into segments.
- **Q: The tube is not cutting through the roof sheathing.**
  - A: Check that **ApplySheet** is set to `Yes` and verify that the **SheetZone** number corresponds to the layer where your sheathing exists.
- **Q: I copied the script to another roof, but it positioned wrong.**
  - A: The position depends on the **Reference Position** and **Offsets**. Since different roof elements may have different lengths/widths, the same offset value might place the tube in a different relative spot. Adjust the **OffsetFromLeft** property for the new instance.