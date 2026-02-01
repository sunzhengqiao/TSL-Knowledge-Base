# HSB_G-BillOfMaterial.mcr

## Overview
Generates a configurable Bill of Materials (BOM) table in Paper Space viewports. The script lists structural entities (beams, sheeting) with user-defined properties, dimensions, and quantities to create material lists and production summaries on drawing layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script is designed for 2D annotation. |
| Paper Space | Yes | The script must be added to a viewport. |
| Shop Drawing | No | This is a General (G-) script, not a Shop Drawing (sd-) script. |

## Prerequisites
- **Required Entities**: GenBeam, Sheeting, or other TSL instances visible in the viewport.
- **Minimum Beam Count**: 0 (Script will run and display headers or script name if empty).
- **Required Settings**: None (Uses hsbCAD internal Groups dynamically).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD Catalog)
Action: Browse and select `HSB_G-BillOfMaterial.mcr`.

### Step 2: Select Viewport and Insertion Point
```
Command Line: Select insertion point:
Action: Click inside the desired Paper Space viewport where you want the BOM table to appear.
```

### Step 3: Configure Table
Action: Press `Esc` to end the insertion command. Select the newly created script object and open the **Properties Palette** (Ctrl+1) to adjust filters, layout, and sorting options.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter Logic** |
| `sInExcludeFilters` | Enum | Include | Determines if filters select items to keep (Include) or remove (Exclude). |
| `sFilterBC` | String | *Empty* | Filters structural members by BeamCode (e.g., 'WAL', 'FLR'). Supports wildcards. |
| `sFilterLabel` | String | *Empty* | Filters entities based on a specific user-assigned label property. |
| `sFilterMaterial` | String | *Empty* | Filters entities by material grade (e.g., 'C24', 'GL24h'). |
| `sFilterName` | String | *Empty* | Filters entities based on their entity name property. |
| **Data Source** |
| `sUseGroupSelection` | Enum | No | Toggles between analyzing the whole viewport or a specific predefined Group. |
| `sGroupName` | String | *Empty* | Specifies the hsbCAD Group name to analyze when Group selection is Yes. |
| **Content Visibility** |
| `sShowBeams` | Enum | Show | Toggles the visibility of timber beams/columns in the list. |
| `sShowZn1` through `sShowZn9` | Enum | Show | Toggles visibility of sheathing/cladding elements for specific zones (1-9). |
| **Layout & Formatting** |
| `dTextSize` | Double | 2.5 mm | Sets the height of the text characters in the table. |
| `dMargin` | Double | 2.0 mm | Sets the padding space between text and cell borders. |
| `nPrecision` | Integer | 0 | Number of decimal places for dimension values (0-3). |
| `sTableTitle` | String | *Empty* | Custom header text displayed above the table grid. |
| `dRowHeight` | Double | 6.0 mm | Vertical distance between horizontal grid lines. |
| `sReferencePoint` | Enum | Top-Left | The corner of the table that locks to the insertion point (affects growth direction). |
| `dRotation` | Double | 0.0 deg | Rotation angle of the entire table. |
| **Sorting** |
| `sSortKey1` through `sSortKey4` | Enum | Number | Attributes (e.g., Length, Material, Name) used to order the list rows. |
| `sSortMode` | Enum | Ascending | Direction of the sorting logic (Ascending or Descending). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Reset Location** | Snaps the table reference point back to the original insertion coordinates. |
| **Recalculate** | Refreshes the table content based on current model data and property settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML files for configuration; it relies on hsbCAD internal Groups.

## Tips
- **Table Growth**: Use the `sReferencePoint` property (e.g., Bottom-Right) if you want the table to expand upwards or leftwards from your insertion point, preventing overlap with other drawings.
- **Empty Viewports**: If the viewport contains no hsbCAD data, the script will simply draw its filename (`HSB_G-BillOfMaterial.mcr`) as a placeholder.
- **Filtering**: Use `sFilterMaterial` set to "C24" and `sInExcludeFilters` set to "Include" to create a list of only C24 graded timber.
- **Sorting**: Set `sSortKey1` to *Length* and `sSortKey2` to *Material* to group similar materials together, ordered by size.

## FAQ
- **Q: Why is my table empty?**
  **A:** Check your Filters (`sFilterBC`, `sFilterMaterial`) and Visibility settings (`sShowBeams`). Ensure `sInExcludeFilters` is set correctly (Include vs Exclude). Also, verify that the viewport actually contains hsbCAD entities.
- **Q: How do I change the number of decimal places?**
  **A:** Modify the `nPrecision` property in the Properties Palette (0 = integers, 1 = one decimal place, etc.).
- **Q: Can I list only specific sheathing zones?**
  **A:** Yes. Set `sShowBeams` to Hide, and set the desired `sShowZn` (e.g., `sShowZn1`) to Show while setting others to Hide.
- **Q: The text is too small to read.**
  **A:** Increase the `dTextSize` property. You may also need to increase `dMargin` and `dRowHeight` to prevent text overlap.