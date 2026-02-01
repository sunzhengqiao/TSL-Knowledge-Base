# HSB_E-IntegratedTooling.mcr

## Overview
This script automates the application of integrated tooling connections (such as cuts, pockets, or machining) between "Male" and "Female" beams within a selected construction element (e.g., a wall or floor panel). It allows for complex geometric adjustments and supports variable overrides from production data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Elements in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities**: At least one `Element` containing `GenBeams`.
- **Minimum Beam Count**: 2 (requires intersecting beams to function effectively).
- **Required Settings**: The helper script `HSB_G-FilterGenBeams` must be loaded in the drawing to filter beams correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-IntegratedTooling.mcr` from the list.

### Step 2: Configure Initial Properties
```
Dialog: Properties Palette / Initial Dialog
Action: Set initial dimensions (Width, Height), offsets, and filter definitions.
Note: If a specific catalog preset is used, these steps may be skipped.
```

### Step 3: Select Element
```
Command Line: Select element(s)
Action: Click on the construction element (e.g., a wall or roof panel) that contains the beams you wish to process.
```

### Step 4: Processing
```
System: Automatically filters beams, finds intersections, and applies tooling.
Action: The script runs and then erases itself, leaving the individual tooling instances applied to the beams.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Geometry** | | | |
| Additional width | Number | 0 | Extra width added to the cut/tooling perpendicular to the beam axis. |
| Additional height | Number | 0 | Extra height added to the cut/tooling. |
| Justification point | Dropdown | Center | Anchor point for the additional size (e.g., Center, Top, Left). |
| Offset in X direction | Number | 0 | Moves the tooling geometry along the global X axis. |
| Offset in Y direction | Number | 0 | Moves the tooling geometry along the global Y axis. |
| Offset in Z direction | Number | 0 | Moves the tooling geometry along the global Z axis. |
| Negative front offset | Number | 0 | Extends the tooling length backwards from the intersection point. |
| Positive front offset | Number | 0 | Extends the tooling length forwards from the intersection point. |
| **DSP Overrides** | | | |
| Additional width variable override | Integer | -1 | DSP variable index to override 'Additional width' (-1 disables). |
| Additional height variable override | Integer | -1 | DSP variable index to override 'Additional height' (-1 disables). |
| Additional offset X axis variable override | Integer | -1 | DSP variable index to override X offset (-1 disables). |
| Additional offset Y axis variable override | Integer | -1 | DSP variable index to override Y offset (-1 disables). |
| Additional offset Z axis variable override | Integer | -1 | DSP variable index to override Z offset (-1 disables). |
| Additional negative front offset override | Integer | -1 | DSP variable index to override negative length offset (-1 disables). |
| Additional positive front offset override | Integer | -1 | DSP variable index to override positive length offset (-1 disables). |
| **Processing Options** | | | |
| Modify section for CNC | Dropdown | No | Adds specific geometry (e.g. fillets) required for CNC machining. |
| Convert to Dummy | Dropdown | No | Changes the cut beam to a dummy beam (excluded from BOMs). |
| Convert to static tool | Dropdown | No | Removes the beam and replaces it with a static solid (non-parametric). |
| Make beamcut square | Dropdown | No | Forces a 90-degree square cut at the intersection. |
| **Filters** | | | |
| Filter definition for male beams | Dropdown | [Empty] | Selects which beams are modified (targets). |
| Filter definition for female beams | Dropdown | [Empty] | Selects which beams drive the cut shape (references). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the tooling geometry based on current property settings or changes in the model structure. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: hsbCAD standard library
- **Purpose**: Used to categorize and select "Male" and "Female" beams based on name, code, or other properties.

## Tips
- **Filtering is Key**: Ensure your Filter Definitions for Male and Female beams correctly target the intended parts (e.g., set "Male" to Studs and "Female" to Plates).
- **Variable Overrides**: If using production data (DSP), ensure the variable indices (e.g., variableAdditionalWidth) match your database setup to automate sizing.
- **Static Tools**: Use "Convert to static tool" only when you no longer need parametric updates, as this breaks the link to the original beam logic.

## FAQ
- Q: Why did the script run but not create any cuts?
  A: Check your Filter Definitions. If the filters do not select any beams, or if the selected Male and Female beams do not physically intersect, no tooling will be generated.
- Q: Can I change the cut size after inserting?
  A: Yes. Select the generated tooling instance (or re-run the generator on the element) and adjust the "Additional width/height" or "Offset" properties in the palette, then Recalculate.
- Q: What does "Convert to Dummy" do?
  A: It marks the beam as a dummy. It remains visible in the model but will not appear in material lists or reports, useful for visualization only.