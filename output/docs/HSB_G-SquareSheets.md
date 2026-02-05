# HSB_G-SquareSheets.mcr

## Overview
This script analyzes sheet entities in your model, groups them by rounded dimensions, color, and material, and assigns a position number to each group. It is used to organize panel data for production listings or optimization processes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: Sheets (Elements).
- **Minimum Beam Count**: 0 (This script processes Sheets, not beams).
- **Required Settings**: The script **HSB_G-FilterGenBeams** must be loaded in the drawing, and a filter definition must be configured within it to select the relevant sheets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
- Browse to the script location and select `HSB_G-SquareSheets.mcr`.

### Step 2: Select Position
```
Command Line: |Select a position|
Action: Click in the Model Space to place the text report indicating the analysis results.
```

### Step 3: Configure and Analyze
1. Select the inserted script instance.
2. In the **Properties Palette**, set the **Sheet filter** to select the desired group of sheets.
3. Right-click the script instance and select **Analyse sheets** (or Double-click the script instance) to run the calculation and tag the sheets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheet filter | dropdown | (Empty) | Determines which sheets are analyzed. Select a filter name defined in the HSB_G-FilterGenBeams catalog. |
| Dimension style | dropdown | (Standard) | Sets the visual style (font, arrows, etc.) for the on-screen text report. |
| Text color | number | -1 | Sets the color of the text report. -1 uses the default color (ByBlock). |
| Text size | number | -1 | Sets the height of the text report. A value of 0 or negative uses the size defined in the Dimension Style. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Analyse sheets | Runs the logic to collect sheets based on the filter, calculates their grouping, and assigns position numbers to the entities. |
| Clear data | Removes the position number data and labels from all collected sheet entities. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams`
- **Purpose**: This external script provides the filtering logic required to define which specific sheets in the model should be processed by this script.

## Tips
- **Initial State**: When first inserted, the script only displays a text cursor. You must run the "Analyse sheets" command to generate data.
- **Filtering**: If no sheets are tagged, check your **Sheet filter** property. Ensure the corresponding filter exists and is active in the HSB_G-FilterGenBeams tool.
- **Visual Feedback**: The text displayed in Model Space is just a report showing how many entities were analyzed. The actual data is stored invisibly on the sheets for use in lists or reports.

## FAQ
- **Q: I inserted the script, but nothing happened.**
- **A:** You must right-click the script instance and select **Analyse sheets** (or double-click it) to trigger the calculation and tagging.
- **Q: How does the script determine which sheets are identical?**
- **A:** It compares sheets based on their rounded dimensions, color, and material properties to assign the same position number to identical items.
- **Q: Can I change the text size of the report?**
- **A:** Yes, use the **Text size** property in the palette, or set it to -1 to inherit the size from your chosen **Dimension style**.