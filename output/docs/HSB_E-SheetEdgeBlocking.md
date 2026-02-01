# HSB_E-SheetEdgeBlocking.mcr

## Overview
This script automates the creation of rigid blocking (e.g., OSB or timber strips) between rafters or cuts rafters to accommodate a sheet web. It operates on a specific sheet within a construction zone of an element, allowing you to either split the sheet into individual blocking pieces or use the sheet geometry to cut voids into intersecting beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model on Elements and their geometry. |
| Paper Space | No | Not applicable for 2D layouts or drawings. |
| Shop Drawing | No | Does not generate shop drawing views or dimensions. |

## Prerequisites
- **Required Entities:** An Element containing at least one Sheet in the target zone and intersecting Beams (e.g., rafters).
- **Minimum Beam count:** 0 (Required for cuts/blocking logic, but script starts with 0).
- **Required Settings Files:** 
  - `HSB_G-SheetToBeam.mcr` (Must be available to perform the final conversion if requested).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_E-SheetEdgeBlocking.mcr` from the file list.

### Step 2: Configure Parameters
```
Dialog: Properties Palette
Action: Set the desired operation mode (Beamcut or Blocking), adjust the offset distance, and specify the target Zone.
Note: If using an ExecuteKey (Catalog), these settings load automatically; otherwise, the dialog appears for manual entry.
```

### Step 3: Select Element
```
Command Line: Select Element:
Action: Click on the Element in the model that contains the target sheet and rafters.
```

### Step 4: Execution
Action: The script processes the geometry, updates the properties, and then self-destructs. The resulting blocking pieces or cuts remain in the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sheetBlocking** | Dropdown | "Beamcut on rafters" | **Mode Selection**: <br>- *Beamcut on rafters*: Uses the sheet volume to cut holes in intersecting beams.<br>- *Blocking between rafters*: Splits the sheet into smaller pieces to fit between the beams. |
| **offsetDistance** | Number | 0 | **Clearance (mm)**: The gap applied around the geometry. For blocking, this increases the gap between pieces. For cutting, this enlarges the cut volume (play). |
| **sheetZone** | Number | 3 | **Zone Index**: The construction zone number where the target sheet is located. |
| **createBeam** | Dropdown | "No" | **Convert to Beam**: If set to "Yes", the resulting sheet geometry is converted into a structural Beam using the HSB_G-SheetToBeam script. |
| **sName** | Text | " " | Sets the Name property of the resulting entities. |
| **sMaterial** | Text | "" | Assigns a specific material name to the resulting entities. |
| **sGrade** | Text | "" | Assigns a structural grade/timber class to the resulting entities. |
| **nColor** | Number | -1 | Sets the display color (Index) of the resulting entities (-1 = ByLayer). |
| **sBeamCode** | Text | "" | Assigns a production code for manufacturing/CAM output. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This is a generator script that erases itself after execution. There are no context-menu options available on the resulting geometry to modify the script parameters. |

## Settings Files
- **Filename**: `HSB_G-SheetToBeam.mcr`
- **Location**: Standard TSL script folder (Company or Install path).
- **Purpose**: Provides the logic to convert the processed sheet geometry into structural beams if the `createBeam` property is enabled.

## Tips
- **Zone Identification**: Ensure you correctly identify the `sheetZone`. The script looks for the sheet in this specific zone to drive the blocking or cutting logic.
- **Offset Usage**: Use the `offsetDistance` to account for saw kerf or tolerance. A small positive value (e.g., 2mm) ensures blocking pieces are not too tight to fit physically.
- **Undo Function**: Since the script deletes itself after running, use the AutoCAD `UNDO` command if you need to change parameters and run the script again.
- **Material Assignment**: If you choose to convert the blocking to beams (`createBeam` = Yes), ensure you fill in `sMaterial` and `sGrade` so the pieces behave correctly in reports and lists.

## FAQ
- **Q: What is the difference between "Beamcut" and "Blocking" modes?**
  **A:** "Beamcut" modifies the rafters by cutting holes where the sheet would be. "Blocking" keeps the rafters whole but cuts the sheet into smaller strips that fit *between* the rafters.
- **Q: Why did the script disappear after I ran it?**
  **A:** This is a "generator" script. It creates the geometry (blocking or cuts) and then removes itself from the drawing to prevent clutter. You cannot edit its settings later; you must Undo and re-insert.
- **Q: My blocking pieces are overlapping the rafters.**
  **A:** Increase the `offsetDistance` parameter. This adds a gap between the split pieces and the intersecting beams.