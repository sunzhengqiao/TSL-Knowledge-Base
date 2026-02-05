# HSB_G-TimberpercentageReport.mcr

## Overview
This script generates a 2D graphical report in the drawing displaying timber percentage calculations, area breakdowns, and beam quantities for a selected assembly element. It reads data stored in Element and Beam Extended Properties and visualizes it as a formatted table at a user-selected location.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The report can be placed directly in the model. |
| Paper Space | Yes | The report can be placed on layout sheets. |
| Shop Drawing | No | This script does not generate shop drawings or layouts. |

## Prerequisites
- **Required Entities**: An Element (Assembly) containing Beams.
- **Minimum Beam Count**: 0, but data is required to generate a meaningful report.
- **Required Settings**:
  - The selected Element must have an Extended Property map named **`TIMBERPERCENTAGE`** containing calculation data.
  - The Beams within the Element must have Extended Properties named **`TimberPercentageArea`** and **`TotalArea`** (usually populated by a previous calculation script).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-TimberpercentageReport.mcr`

### Step 2: Configure Properties
- If the script is run manually (without a predefined execute key), the Properties Dialog will appear automatically.
- Select the appropriate **Dimension Styles** for the header and table content.
- Set the **Color** preference (default `-1` uses varying colors for different sections).

### Step 3: Select Assembly
```
Command Line: Select viewport (Element):
Action: Click on the Element (Assembly) in the drawing or 3D model for which you want to generate the report.
```

### Step 4: Place Report
```
Command Line: Insertion point:
Action: Click in the drawing (Model or Paper Space) to specify where the top-left of the report table should be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style Header | dropdown | (Empty) | Selects the text style for the main title "Timberpercentage Calculation". This controls font and text size. |
| Dimension Style | dropdown | (Empty) | Selects the text style for the table headers and data rows. |
| Color | number | -1 | Sets the color of the report entities. Use `-1` to automatically cycle colors for different area sections, or enter a specific AutoCAD Color Index (1-255). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific items to the context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on Extended Properties attached to the Element and Beams rather than external XML settings files.

## Tips
- **Data Preparation**: Ensure you have run your calculation scripts (e.g., for fire safety or thermal analysis) before running this report. If the Extended Properties (`TIMBERPERCENTAGE`, `TimberPercentageArea`) are missing, the report will be empty.
- **Visuals**: Use the `Color` property set to `-1` to easily distinguish between different area sections (e.g., different floors or zones) within the report.
- **Text Size**: To adjust the size of the text in the report, do not scale the script instance. Instead, create or select Dimension Styles in AutoCAD with the desired text height and assign them in the properties panel.

## FAQ
- **Q: Why is the report empty or missing data?**
  **A:** The script requires specific Extended Properties on the Element (`TIMBERPERCENTAGE`) and Beams (`TimberPercentageArea`, `TotalArea`). Verify that these have been calculated and assigned to the entities you selected.
- **Q: Can I update the report if the design changes?**
  **A:** Yes. If the underlying properties change, select the report instance and use the `TSLRECALC` command (or the Recalculate option) to refresh the table data.
- **Q: How do I change the font size?**
  **A:** Modify the text height in the Dimension Styles selected in the Properties Panel (`dimensionStyleHeader` and `dimensionStyle`).