# HSB_E-ChangeSheetSize

## Overview
This script optimizes the dimensions and orientation of sheets (such as sheathing or cladding) within a construction element. It aligns the sheet's coordinate system with the longest side of the envelope to minimize material waste and ensure the best fit from standard raw material sizes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Elements and Sheets within the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model generation/manufacturing script. |

## Prerequisites
- **Required Entities:** Elements (walls/floors) that contain Sheets.
- **Minimum Beams:** 0.
- **Required Settings:** None strictly required, though Element Filter catalogs can be utilized for filtering.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ChangeSheetSize.mcr` from the file dialog.

### Step 2: Configure Properties
If the script is run manually without a predefined execute key, the Properties Palette will appear.
- **Element filter catalog:** Select a specific filter (e.g., "External Walls") or leave as "Do not use an element filter" to apply to all selections.
- **Apply to zones:** Enter the zone indices (e.g., "1;2") if you only wish to resize sheets in specific layers of the element. Leave blank to apply to all.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Elements in the model or use a window selection. Press Enter to confirm.
```

### Step 4: Processing
The script will automatically process the selected elements. It creates a satellite instance for each, calculates the optimal sheet orientation based on the longest side of the sheet envelope, and replaces the existing sheets with the optimized versions.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Element filter catalog | Dropdown | \|Do not use an element filter\| | Filters the selected elements to only process those matching a specific catalog definition (e.g., specific wall types). |
| Sequence number | Number | 0 | Determines the order in which this script runs relative to other scripts during element generation. |
| Apply to zones | Text | (Empty) | Specifies the zone indices (e.g., "1;3;5") where the sheet resizing should be applied. If left empty, all zones are processed. |

## Right-Click Menu Options
There are no custom right-click menu options added by this script.

## Settings Files
- **Filename:** N/A (No specific settings files are referenced in the script configuration).
- **Catalogs:** Uses standard hsbCAD catalogs for `hsbElementFilter`.

## Tips
- **Zone Targeting:** Use the `Apply to zones` parameter to restrict changes to specific layers (like only the exterior sheathing) without affecting interior structural layers.
- **Optimization Logic:** The script prioritizes the "Longest Side" of the sheet envelope. This is particularly useful for elements that are rotated or have non-rectangular shapes to ensure efficient material usage.
- **Validation:** The script will automatically skip sheets where vertex points cannot be found or calculated, preventing errors on complex geometries.

## FAQ
- **Q: Why did my sheets remain unchanged after running the script?**
  A: Check the `Element filter catalog` setting to ensure it isn't filtering out your selected elements. Also, verify the `Apply to zones` string matches the zones where your sheets are actually located.
- **Q: Does this script change the material of the sheets?**
  A: No. The script preserves all attributes (material, labels, etc.) from the original sheet; it only modifies the geometric dimensions and orientation.
- **Q: Can I use this on an element that is currently being generated?**
  A: Yes, the script checks if the element is constructed (`_bOnElementConstructed`) and will run automatically during the generation process if configured in the execute list.