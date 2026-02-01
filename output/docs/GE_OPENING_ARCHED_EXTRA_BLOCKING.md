# GE_OPENING_ARCHED_EXTRA_BLOCKING.mcr

## Overview
This script generates extra blocking beams (cripples) at the corners of arched or angled stick frame openings. It automatically calculates the gap between the straight frame members (header/sill/jambs) and the arch curve to create structural supports and nailing surfaces for sheathing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script interacts directly with Wall Elements and Stick Frame Openings in the 3D model. |
| Paper Space | No | Not designed for use in layouts. |
| Shop Drawing | No | This is a modeling script, not a detailing tool. |

## Prerequisites
- **Required Entities**: A valid hsbCAD Wall (Element) containing a valid Stick Frame Opening (OpeningSF).
- **Minimum Beam Count**: 0 (The script analyzes existing framing but does not require pre-selected beams).
- **Required Settings Files**: `hsbFramingDefaults.Inventory.dll` (Used to populate the "Lumber item" dropdown with project-specific sizes and materials).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_OPENING_ARCHED_EXTRA_BLOCKING.mcr` from the list.

### Step 2: Select Opening
```
Command Line: Select opening
Action: Click on the arched or angled stick frame opening within a wall.
```

### Step 3: Configure Properties
```
Action: The Properties Palette (OPM) will appear automatically upon the first insertion.
Select a "Lumber item" from the Auto section or define a manual "Beam size".
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Auto** | | | |
| Lumber item | dropdown | (Empty) | Select a predefined profile from the project inventory. This automatically sets the size, material, and grade. |
| **Manual** | | | |
| Beam size | dropdown | \|From inventory\| | Select a specific nominal size (e.g., 2x4, 2x6). Width is fixed at 38.1mm (1.5"). Select "\|From inventory\|" to use the Lumber item size. |
| Material | text | (Empty) | Overrides the wood material type (e.g., SPF, Douglas Fir). |
| Grade | text | (Empty) | Overrides the structural grade (e.g., SS, No. 2). |
| Beam color | number | 2 | Sets the AutoCAD color index for the generated blocking beams. |
| Name | text | (Empty) | Assigns a name to the beams for identification in schedules. |
| Information | text | (Empty) | Adds specific metadata or instructions to the beam properties. |
| Label | text | (Empty) | Sets the primary label for tagging. |
| Sublabel | text | (Empty) | Sets a secondary label for categorization. |
| Sublabel2 | text | (Empty) | Sets a tertiary label for detailed categorization. |
| Beam code | text | (Empty) | Assigns a production or shop code. |
| **Opening Settings** | | | |
| Rout opening | dropdown | \|Yes\| | If "Yes", the script splits and cuts wall sheathing around the arch and blocking. If "No", sheathing is not modified by this script. |
| Square cut sheathing only | dropdown | \|No\| | If "Yes", simplifies the sheathing cutout to a square shape rather than following the complex arched profile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalc | Updates the blocking geometry if the opening size or wall frame changes. |
| Erase | Removes the script instance and the generated blocking beams. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbFramingDefaultsEditor\`
- **Purpose**: Provides the list of available Lumber Items, Material types, and Grades for the "Auto" property section.

## Tips
- **Gap Detection**: The script only generates blocking if the gap between the straight frame (jamb/header) and the arch curve is larger than the height of the blocking beam. If you don't see blocking at a corner, the arch is likely too tight to the frame.
- **Sheathing Updates**: If you modify the opening geometry (e.g., make the arch taller), ensure the script is set to "Rout opening: Yes" so the wall sheets are updated to match the new shape.
- **Inventory Priority**: If "Lumber item" is selected, it overrides the manual "Beam size". To use manual sizes, ensure "Beam size" is set to a specific dimension (e.g., 2x6) and not "\|From inventory\|".

## FAQ
- **Q: Why did my blocking disappear after I changed the opening shape?**
  A: The script recalculates the geometry automatically. If the arch was moved closer to the jambs or header, the gap may now be too small to fit the selected blocking beam size. Try reducing the beam height or moving the arch.
- **Q: How do I change the material of just the blocking without changing the rest of the wall?**
  A: Select the script instance, open the Properties Palette, and manually enter the desired Material and Grade in the "Manual" section. This overrides the inventory settings for these specific beams.
- **Q: The wall sheathing is not being cut around the arch.**
  A: Check the "Rout opening" property in the script and ensure it is set to \|Yes\|. If it is already Yes, try running a "Reframe" on the wall to force a full update.