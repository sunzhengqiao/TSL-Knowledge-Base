# HSB_G-RemoveModuleData

## Overview
This utility script clears the "Module" property assignment from selected timber beams (GenBeams). It is used to dissociate specific beams from their current logical manufacturing or export groups.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D model elements. |
| Paper Space | No | Not designed for layout views or annotations. |
| Shop Drawing | No | Not designed for use within drawing views. |

## Prerequisites
- **Required entities:** At least one GenBeam (Timber Beam) currently existing in the drawing.
- **Minimum beam count:** 1
- **Required settings files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-RemoveModuleData.mcr`

### Step 2: Select Entities
```
Command Line: Select entities
Action: Click on the timber beams you wish to remove from the current module group. You may select multiple beams.
         Press Enter to confirm the selection.
```
*(Note: The script will automatically filter for valid timber beams. Once confirmed, the script updates the properties and closes.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs immediately upon insertion and does not have editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are available. The script instance is removed immediately after execution. |

## Settings Files
None required.

## Tips
- **Re-grouping:** Use this script when you have accidentally assigned beams to the wrong Module ID or if you need to re-organize your export groups before generating production data.
- **No Cleanup Needed:** The script object deletes itself automatically from the drawing after processing, so you do not need to manually erase the script instance.

## FAQ
- **Q: Will this delete my beams?**
  A: No, this script only clears the internal "Module" name property. It does not delete or modify the geometry of the beams.
- **Q: Can I use this on walls or other elements?**
  A: No, this script is specifically designed to work on GenBeam entities. It will ignore other element types.
- **Q: How do I know it worked?**
  A: Select a processed beam and look at its properties (or use a script that reports the Module name); the Module field should now be empty.