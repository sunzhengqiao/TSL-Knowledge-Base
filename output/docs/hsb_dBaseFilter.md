# hsb_dBaseFilter.mcr

## Overview
This script automatically classifies selected Wall Elements into production categories ('Shaped', 'Special', or 'Square') based on their geometry and dimensions. It updates the "Element Information" field to help filter lists for manufacturing or engineering reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Wall Elements in the model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Does not process drawing views. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`).
- **Minimum Beams**: 1 Wall Element must be selected.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_dBaseFilter.mcr` from the file dialog.

### Step 2: Configure Properties (Optional)
1. Upon insertion, the Properties palette may open automatically.
2. Adjust the filtering rules (e.g., height limits) if the default values do not match your project requirements.

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the Wall Elements you wish to classify and press Enter.
```
*Note: The script instance will disappear automatically after processing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Set Special Rules | dropdown | No | Master switch to enable dimensional filtering. If 'No', only geometry (Shaped vs. Square) is checked. |
| Special if wall is higher than: | number | 3200mm (125") | Walls taller than this value are marked 'Special'. Set to 0 to disable. |
| Special if wall is lower than: | number | 1500mm (60") | Walls shorter than this value are marked 'Special'. Set to 0 to disable. |
| Special if wall is shorter than: | number | 1500mm (60") | Walls with a length shorter than this value are marked 'Special'. Set to 0 to disable. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Geometry Priority**: If a wall contains a gable, angled top plate, or complex geometry, it is always marked as **"Shaped"**, regardless of its height or length settings.
- **Disabling Checks**: To ignore a specific dimension rule (e.g., you don't care about wall height), set that specific property value to `0`.
- **Re-running**: To re-classify walls after changing parameters, simply run the script again and select the same elements.
- **Data Location**: The result is written to the element's data fields. You can check the classification by selecting a wall and looking at its Element Information or generating a listing report.

## FAQ
- **Q: The script disappeared after I selected the walls. Did it work?**
  - A: Yes. This is a "transient" script designed to run once and delete itself. Check the properties of the selected walls to see the updated "Element Information."
  
- **Q: What is the difference between "Shaped" and "Special"?**
  - A: "Shaped" refers to complex geometry (gables, dormers, non-rectangular shapes). "Special" refers to standard rectangular walls that fall outside your defined height or length thresholds (e.g., very tall or very short walls).

- **Q: How do I see the results for all walls?**
  - A: Use the hsbCAD listing or reporting tools to filter/export based on the "Element Information" field.