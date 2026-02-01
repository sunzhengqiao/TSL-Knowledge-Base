# HSB_E-ProfilingBeamCut

## Overview
This script applies a rectangular cut (BeamCut) to specific beams within a selected Element based on a predefined filter. It allows you to define the size of the cut and the specific side (Front/Back, Inside/Outside) relative to the element's geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | |
| Shop Drawing | No | This is a modeling script, not a detailing script. |

## Prerequisites
- **Entities:** An existing Element containing GenBeams.
- **Required Script:** The `HSB_G-FilterGenBeams` TSL script must be loaded in the drawing to define which beams are affected.
- **Filters:** You must have a beam filter defined in `HSB_G-FilterGenBeams` to select the target beams.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ProfilingBeamCut.mcr`

### Step 2: Configure Properties
A dialog will appear automatically (or you can set these in the Properties Palette before insertion).
- Set the **Filter definition** to match a filter created in `HSB_G-FilterGenBeams`.
- Set the **Width** and **Depth** of the cut.
- Select the **Milling side** (Front or Back).
- Select the **Side relative to element center** (Inside or Outside).

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Element(s) in the model that contain the beams you wish to modify. Press Enter to confirm selection.
```

### Step 4: Execution
The script will process the selected elements, apply the cuts to the filtered beams, and then automatically erase itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition beams | dropdown | (empty) | Select the beam filter to use. This must be defined using the HSB_G-FilterGenBeams script. |
| Milling side | dropdown | Front | Determines which side of the element the milling is applied to. **Front**: Zone 1 to 5, **Back**: Zone 6 to 10. |
| Side relative to element center | dropdown | Outside | Applies the tool to the inside or outside of the selected beams, relative to the element's center. |
| Width beam cut | number | 10 | Sets the width (Y-axis) of the beam cut. |
| Depth beam cut | number | 10 | Sets the depth (Z-axis) of the beam cut. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script runs once and erases itself; there are no persistent right-click options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files. Configuration is done via the Properties Palette.

## Tips
- **Prepare Filters First:** Ensure you have loaded `HSB_G-FilterGenBeams` and created a valid filter before running this script. If the filter cannot be found, the script will fail and erase itself.
- **Single-Use Script:** This is an "Execution" script. Once it runs, it deletes itself from the element tree. The cuts applied become permanent modifications to the beam geometry. To change the cuts later, you must undo the operation or manually edit the beam.
- **Understand Orientation:** "Inside" and "Outside" are calculated relative to the element's center profile. Check your element orientation if the cut appears on the wrong side.

## FAQ
- **Q: The script disappeared immediately after I ran it. Is that normal?**
  - A: Yes. This is a "fire and forget" script designed to apply a modification and then remove itself to keep the drawing clean.
- **Q: Why did I get an error "Beams could not be filtered!"?**
  - A: Ensure the script `HSB_G-FilterGenBeams` is loaded in your drawing and that the name you entered in "Filter definition beams" matches a filter defined in that script exactly.
- **Q: Can I edit the cut dimensions after inserting?**
  - A: No. Because the script erases itself after execution, you cannot simply double-click it to change dimensions. You must use the Undo command (Ctrl+Z) and run the script again with new values.