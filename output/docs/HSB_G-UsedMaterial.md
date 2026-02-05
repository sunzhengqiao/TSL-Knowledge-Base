# HSB_G-UsedMaterial.mcr

## Overview
This script generates a material schedule (Bill of Materials) directly in the Model Space by analyzing selected timber beams and sheets. It lists items grouped by material grade and dimensions, calculates total quantities (length for timber, area for sheets), and links the physical parts to the report via the "Grade" property.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. |
| Paper Space | No | Not supported for layout viewports. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities**: `GenBeam`, `Beam`, or `Sheet` entities must exist in the drawing.
- **Minimum beam count**: At least 1 valid timber or sheet must be selected to generate a report.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_G-UsedMaterial.mcr`.

### Step 2: Select Entities
```
Command Line: Select a set of timbers and sheets
Action: Use a crossing window or select individual beams/sheets you wish to include in the report. Press Enter when finished.
```

### Step 3: Position Report
```
Command Line: Select a position for the report
Action: Click in the Model Space to define the top-left corner of the material list.
```

## Properties Panel Parameters

Configure these settings in the AutoCAD Properties Palette (Ctrl+1) after selecting the script instance.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection** | | | |
| Selection method | dropdown | Manual (cross-select) | Defines how elements are selected (Currently fixed to manual). |
| **Filters** | | | |
| Filter mode | dropdown | Include | Determines if filters keep matching items ("Include") or remove them ("Exclude"). |
| Case sensitive | dropdown | No | Defines if text filters (Name, Material) require exact casing. |
| Name | text | | Filters elements by their entity name (supports wildcards like `*`). |
| Beamcode | text | | Filters elements by their Beam Code property. |
| Material | text | | Filters elements by their material grade (e.g., C24, GL24h). |
| Label | text | | Filters elements by their Label property. |
| Hsb ID | text | | Filters elements by their unique hsbCAD ID. |
| Zone | text | | Filters elements by their assigned Zone index. |
| **Style** | | | |
| Dimension style groups | dropdown | | Sets the text style for the group summary headers. |
| Dimension style content | dropdown | | Sets the text style for the individual item lines. |
| Color groups | number | 1 | Sets the AutoCAD color index for group headers. |
| Color content | number | -1 | Sets the AutoCAD color index for content text (-1 = ByBlock). |
| Color lines | number | -1 | Sets the AutoCAD color index for grid lines (-1 = ByBlock). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom commands to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on internal logic and Properties Palette inputs.

## Tips
- **Filter Logic**: If "Filter mode" is set to "Include", you must populate at least one filter field (e.g., Material), otherwise the report may remain empty or show everything depending on the version.
- **Linking Parts**: The script automatically writes an ID to the "Grade" property of the beams and sheets. You can select a physical beam in the drawing and check its properties to see which line item in the report it corresponds to.
- **Updating**: If you modify the geometry of the beams, select the report instance and use the `REGEN` command or right-click -> "Reload" (if available in your hsbCAD version) to update the quantities.
- **Moving**: Select the text report to move the entire schedule. The text and grid lines are grouped together.

## FAQ
- **Q: Why is my report empty?**
  A: Ensure you selected valid GenBeam or Sheet entities. If using "Include" filter mode, check that at least one filter field (like Material or Name) is actually filled in and matches your elements.
  
- **Q: How do I change the text size of the report?**
  A: Use the "Dimension style groups" and "Dimension style content" parameters in the Properties Palette to select different pre-defined text styles from your drawing.

- **Q: Can I separate timbers from sheets?**
  A: Yes, the script automatically detects the entity type. Timbers are sorted by width and length; Sheets are sorted by size and thickness.

- **Q: What happens if I delete the report?**
  A: The report instance is removed. However, the "Grade" property modifications on the individual beams and sheets will remain until manually overwritten.