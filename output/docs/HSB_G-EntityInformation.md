# HSB_G-EntityInformation.mcr

## Overview
Automatically generates a filtered list of timber entities (beams, sheets, or macros) visible through a selected viewport and creates 2D text labels in Paper Space. This is ideal for creating parts lists, position schedules, or material summaries for specific views without generating full shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Source | Entities must exist in Model Space, but the script is run from a Layout. |
| Paper Space | Yes | Primary execution space. User must select a viewport on a Layout tab. |
| Shop Drawing | No | This is a general annotation tool, not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: GenBeams, Elements, or TslInsts must exist in the model.
- **Minimum Beam Count**: 0.
- **Required Settings**: An active layout (Paper Space) with at least one viewport containing hsbCAD model data.
- **Optional Files**:
    - `Posnum.xml` (in `_kPathHsbCompany\Custom\`) for prefix definitions.
    - `HSB_G-FilterGenBeams` (Catalog TSL) for advanced filtering presets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_G-EntityInformation.mcr` from the file dialog.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport frame in your Layout tab where you want to generate the labels.
```

### Step 3: Configure Properties (Optional)
Action: Select the script instance (if it remains selected) or use the Properties Palette to adjust filters (e.g., filter by Material or Zone) if the initial result is not as desired.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| \|Include\|/\|Exclude\| | dropdown | \|Include\| | Determines if subsequent filters select entities to keep (Include) or ignore (Exclude). |
| \|Filter beams with beamcode\| | text | (empty) | Filters structural timber elements by their functional code (e.g., 'ST' for Studs). |
| \|Filter beams and sheets with name\| | text | (empty) | Filters entities based on their assigned name property. |
| \|Filter beams and sheets with label\| | text | (empty) | Filters entities by their main Position Number or Label. |
| \|Filter beams and sheets with material\| | text | (empty) | Filters elements by material grade or species (e.g., 'C24', 'GL28h'). |
| \|Filter beams and sheets with hsbID\| | text | (empty) | Filters entities by their unique internal database ID. |
| \|Filter beams and sheets with subLabel\| | text | (empty) | Filters entities by a secondary label (e.g., piece marks). |
| \|Filter beams and sheets with subLabel2\| | text | (empty) | Filters entities by a tertiary label field. |
| \|Filter zones\| | text | (empty) | Filters entities belonging to specific building zones or floors. |
| \|Filter tsl names\| | text | (empty) | Filters entities that have specific TSL scripts (macros) attached to them. |
| \|Filter definition for GenBeams\| | dropdown | (empty) | Select a pre-defined complex filter set from the 'HSB_G-FilterGenBeams' catalog. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: `Posnum.xml`
- **Location**: `_kPathHsbCompany\Custom\`
- **Purpose**: Defines prefixes based on Material and BeamCode to customize label generation.

- **Filename**: `HSB_G-FilterGenBeams` (Catalog Entry)
- **Location**: hsbCAD Catalog
- **Purpose**: Provides advanced, pre-saved filter definitions that can be selected via the Properties Panel.

## Tips
- **Filtering Logic**: Use the `|Include|` setting to list specific items (e.g., only 'ST' studs). Use `|Exclude|` to hide specific items (e.g., exclude all 'Dummy' beams).
- **Wildcards**: The text filters (like Name or Label) typically support wildcards (e.g., `ST*` to find all labels starting with ST).
- **Collision Handling**: The script attempts to automatically detect overlapping text and shift labels to clear spaces. If labels appear cluttered, check the underlying model or adjust your filters to reduce density.
- **Re-running**: You can select the script instance again in Paper Space and modify the filters in the Properties Palette to update the labels dynamically.

## FAQ
- **Q: Why is nothing appearing when I run the script?**
  A: Ensure the selected viewport contains hsbCAD entities. Also, check if your filters are too restrictive (e.g., looking for a Material that doesn't exist in that view).
- **Q: How do I list only wall elements?**
  A: Enter the appropriate BeamCode for walls (e.g., 'WL' or 'W') into the `|Filter beams with beamcode|` property.
- **Q: Can I save my filter settings for future use?**
  A: Yes, you can create a filter definition using the `HSB_G-FilterGenBeams` script/catalog and then select it using the `|Filter definition for GenBeams|` dropdown in this script.