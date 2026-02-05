# I-joist Hanger Display

## Overview
Generates 3D symbolic representations of various I-joist hanger types at beam intersections. This script is used to visually identify hardware and export BOM data, but it does not generate CNC machining data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D visualization. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Two GenBeams (beams).
- **Minimum Beam Count**: 2 (One supporting/carrier beam and one supported/joist beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `I-joist Hanger Display.mcr`

### Step 2: Select Supporting Beam
```
Command Line: Select beam
Action: Click on the beam that will carry the load (the main beam or ledger).
```

### Step 3: Select Supported Beam
```
Command Line: Select beam
Action: Click on the beam that will be supported (the joist or secondary beam).
```

### Step 4: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to set the specific Hanger Type and enter Manufacturer Codes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hanger Type | Dropdown | Face Hanger | Select the geometry type: Heavy Universal, Mini Hanger, Face Hanger, or Top Fix. |
| Hanger Code | Text | [Blank] | Enter the specific manufacturer part number (e.g., "LUS26") for BOM reports. |
| Hanger Model | Text | [Blank] | Enter the manufacturer name or series (e.g., "Simpson Strong-Tie") for labeling. |
| PosNum | Number | 0 | Read-only position number inherited from the project. |
| Display Model | Dropdown | No | Set to "Yes" to show the Hanger Model text as a 3D label in the drawing. |
| DimStyle | Text | Current Dimstyle | Select the dimension style to control the font and height of the 3D text label. |
| Offset | Number | 0 | Adjusts the distance of the text label from the hanger to avoid overlapping other elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change orientation | Rotates the hanger 90 degrees around the beam axis, swapping the vertical and horizontal orientation. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- Use the **Properties Palette** to quickly switch between hanger types (e.g., from "Face Hanger" to "Top Fix") without re-inserting the script.
- Enable **Display Model** set to "Yes" during design reviews to visualize exactly which hardware model is specified.
- The script automatically updates if you move the connected beams, as it links to the first selected beam (carrier).

## FAQ
- **Q: Does this script cut holes or rout the beams?**
  - A: No, this script creates a visual representation (Sheet metal part) and BOM data only. It does not modify the beam geometry for manufacturing.
- **Q: Why is my text label not showing up?**
  - A: Ensure the "Display Model" property is set to "Yes" and that the "Hanger Model" field contains text. Check your DimStyle if the text is too small to see.
- **Q: How do I fix the hanger if it is facing the wrong direction?**
  - A: Select the hanger, right-click, and choose "Change orientation" from the context menu.