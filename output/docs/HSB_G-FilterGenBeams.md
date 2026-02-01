# HSB_G-FilterGenBeams.mcr

## Overview
This script filters a selection of timber beams (GenBeams) based on specific properties such as material, zone, beam code, or custom attributes. It creates a subset of elements for further processing, reporting, or export operations.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively on 3D GenBeam entities. |
| Paper Space | No | 2D layout and viewports are not supported. |
| Shop Drawing | No | This is a model filtering tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: GenBeam entities must exist in the model.
- **Minimum Beam Count**: 0 (Script can run on an empty selection, though no output will be generated).
- **Required Settings**: The script `HSB_G-ContentFormat.mcr` must be loaded in the drawing if you intend to use the "Custom Property" filter.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or insert via hsbCAD toolbar)
**Action**: Select `HSB_G-FilterGenBeams.mcr` from the available scripts list.

### Step 2: Select GenBeams
```
Command Line: Select genbeams to filter
Action: Click to select beams or use a window selection in the model. Press Enter to confirm selection.
```

### Step 3: Configure Filter Properties
**Action**: Before the script finalizes (or if used in a Map configuration), set the desired filter criteria in the Properties Palette (OPM).
- Fill in the relevant fields (e.g., Materials, Zones).
- Choose whether to "Include" or "Exclude" matching items.
- Decide if the operator should be "Any" (match one criteria) or "All" (match all criteria).

### Step 4: Processing
**Action**: The script processes the selection and updates the internal Map with the filtered list of beams.
- **Note**: If run manually, the script instance will erase itself automatically after processing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Operation filter | Dropdown | \|Exclude\| | Determines how matches are handled. **Exclude** removes matching beams; **Include** keeps only matching beams. |
| Operator | Dropdown | \|Any\| | Logic operator. **Any** keeps beams that match at least one filter field. **All** keeps beams that match every active filter field. |
| Beam codes | Text | Empty | Filter by beam code profile. Use wildcards (e.g., `*240*`) or semicolons for lists. |
| Materials | Text | Empty | Filter by material grade (e.g., `C24`, `GL24h`). |
| Labels | Text | Empty | Filter by user-assigned labels. |
| Hsb Id's | Text | Empty | Filter by unique HSB identifier numbers. |
| Zones | Text | Empty | Filter by construction zone names or indices (e.g., `1`, `Roof`). |
| Names | Text | Empty | Filter by the specific entity name. |
| Custom Property | Text | Empty | Define a custom property to check (e.g., `@(Material)`). Requires `HSB_G-ContentFormat`. |
| Custom Values | Text | Empty | Define the value to match for the Custom Property. Use `*` as a wildcard or `;` as a delimiter. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalc | Re-runs the filtering logic on the currently stored selection using the current property settings. |

## Settings Files
- **Dependency**: `HSB_G-ContentFormat.mcr`
- **Location**: Must be loaded in the current drawing.
- **Purpose**: Provides the parsing logic for the Custom Property filter functionality.

## Tips
- **Wildcards**: You can use `*` in text fields to match parts of a string. For example, entering `Wall*` in the "Names" field will match "Wall1", "Wall Exterior", etc.
- **Multiple Values**: Use a semicolon `;` to separate multiple values in a single field (e.g., `C24;C18`).
- **Logic Strategy**:
  - Use **Operator: Any** to gather broad groups (e.g., all beams made of Oak OR Pine).
  - Use **Operator: All** to find specific items (e.g., Beams that are in Zone 1 AND are labeled "Structural").
- **Case Insensitivity**: The script converts all inputs to uppercase, so you do not need to worry about capitalization (e.g., "c24" works the same as "C24").

## FAQ
- **Q: Why did the script disappear immediately after I selected the beams?**
  **A**: This is normal behavior for manual insertion. The script runs once to process the filter, saves the result to the system memory (Map), and then self-destructs to keep your drawing clean.

- **Q: Can I filter by length or height?**
  **A**: Not directly with this specific script. It focuses on data properties (Material, Zone, Name) rather than geometric dimensions. You would need to use a different script or pre-filter your selection manually.

- **Q: I entered a value in "Custom Values" but nothing happened.**
  **A**: Ensure that the "Custom Property" field is also correctly filled out (e.g., `@(Material)`). Additionally, verify that the `HSB_G-ContentFormat` script is loaded in your drawing.