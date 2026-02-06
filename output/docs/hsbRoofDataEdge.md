# hsbRoofDataEdge.mcr

## Overview
This script automatically calculates, labels, and lists roof edge dimensions and types (such as eave, ridge, hip, and valley) for selected roof planes. It generates visual text labels in the model and creates a hardware list for scheduling or manufacturing reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script requires 3D roof planes to analyze. |
| Paper Space | No | |
| Shop Drawing | No | Generates data in Model Space used for reports. |

## Prerequisites
- **Required entities**: `ERoofPlane` (hsbCAD Roof Planes).
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** Type `TSLINSERT` in the command line (or select from the hsbCAD toolbar) and choose `hsbRoofDataEdge.mcr`.

### Step 2: Select Roofplanes
```
Command Line: Select roofplane(s)
Action: Click on one or multiple roof planes in the model, then press Enter.
```
*Note: Selecting multiple adjacent planes allows the script to identify internal connections (valleys/ridges) between them.*

### Step 3: Configure Properties (Optional)
After insertion, select the TSL instance and open the **Properties Palette** (Ctrl+1) to adjust text height, units, or dimension styles.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | Dropdown | _Default | Sets the visual style (font, arrows, color) for the dimension lines and text. |
| Text Height | Number | U(30) | Sets the physical height of the text labels displaying the roof edge lengths. |
| Unit | Dropdown | 2 (m) | Defines the measurement unit for the displayed length values (mm, cm, m, inch). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom items to the right-click menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Label Overlap**: The script automatically detects if labels overlap. It attempts to move them to a clear space. If labels are still crowded, try reducing the **Text Height** in the properties.
- **Data Export**: The script writes logical data to a "Hardware" list. You can generate a report (e.g., CSV or Excel) to see a table of all calculated edge lengths and types.
- **Project Specifics**: If the project variable is set to 'BAUFRITZ', the script will additionally calculate and draw angular dimensions for valleys.

## FAQ
- **Q: Where do I find the calculated lengths for my cut list?**
  - A: The script adds entries to the Hardware list categorized under 'RoofEdge'. Run a hardware report to export this data to Excel.
- **Q: Can I label just one edge of a roof?**
  - A: The script is designed to process all edges of the selected roof planes. While it supports "In-Place" editing (double-click), the primary function is to label the entire perimeter and internal intersections.
- **Q: Why did the script disappear after I inserted it?**
  - A: This happens if the script detects a duplicate insertion or if no valid roof planes were found. Ensure you select valid `ERoofPlane` entities when prompted.