# HSB_I-ShowGenBeamsInModel.mcr

## Overview
This script allows users to visually filter, highlight, and identify specific General Beams (GenBeams) in the 3D model based on custom criteria. It creates visual envelopes and leader lines to verify the location and properties of filtered elements without modifying the actual beam geometry.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities**: GenBeams must exist in the model.
- **Minimum beam count**: At least 1 GenBeam must be selected during insertion to see results.
- **Required settings**: The script `HSB_G-FilterGenBeams` must be loaded and available to define filter criteria.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_I-ShowGenBeamsInModel.mcr` from the file list.

### Step 2: Select GenBeams
```
Command Line: Select genbeams to filter
Action: Click on the beams you wish to analyze or use a window selection. Press Enter to confirm.
```

### Step 3: Set Insertion Point
```
Command Line: Point insertion point
Action: Click in the model space to place the script's reference point (a crosshair).
```
*Note: If you did not select any beams in Step 2, the instance will erase itself automatically.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Color** | dropdown | Green | Sets the color for the highlighted beams and pointer lines. Options include Default, White, Red, Yellow, Green, Cyan, Blue, Magenta, Black, Gray, Dark brown, and Light brown. |
| **Show Envelope** | dropdown | Yes | Toggles the 3D solid representation of the filtered beams. If "No", only the insertion point and pointers are drawn. |
| **Show Pointer** | dropdown | Yes | Displays a leader line connecting the script insertion point to the center of each filtered beam. |
| **Show All GenBeams Selected** | dropdown | No | If "Yes", displays *all* beams originally selected during insertion (ignoring the filter). If "No", only beams matching the filter definition are shown. |
| **Filter definition for GenBeams** | dropdown | [Empty] | Selects the specific filter criteria to apply (e.g., filter by specific beam codes or lengths). Options are populated by the HSB_G-FilterGenBeams catalog. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add genBeams** | Prompts you to select additional GenBeams from the model to add to the current visualization list. |
| **Remove genBeams by selection** | Prompts you to select GenBeams currently in the list to remove them from the visualization. |
| **Remove all genBeams** | Clears the entire list of beams, effectively hiding all visualizations until new beams are added. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Location**: TSL Catalog / Script folder
- **Purpose**: This external script provides the logic and catalog entries for the "Filter definition for GenBeams" dropdown. It defines how beams are filtered (e.g., by name, length, or property).

## Tips
- **Visual Check**: Use the "Show All GenBeams Selected" property set to "Yes" to verify exactly which beams you initially picked before applying complex filters.
- **Filtering**: Ensure `HSB_G-FilterGenBeams` is loaded in the drawing; otherwise, the script will report that beams could not be filtered.
- **Organization**: Place the insertion point near the cluster of beams you are analyzing to make the pointer lines easier to read.

## FAQ
- **Q: Why do I see the error "Beams could not be filtered!"?**
  **A**: The script `HSB_G-FilterGenBeams` is likely not loaded or found in your TSL search path. Load this dependency script to enable filtering.
- **Q: The script disappeared immediately after I placed it.**
  **A**: You likely pressed Enter without selecting any beams during the "Select genbeams to filter" step. Run the command again and ensure you select at least one beam.
- **Q: Can I change the color of the beams after inserting the script?**
  **A**: Yes. Select the script instance, open the Properties palette (OPM), and change the "Color" parameter to update the display instantly.