# IdeFix.mcr

## Overview
Automates the insertion, configuration, and CNC machining for EuroTec Ideefix self-tapping timber connectors. This script connects multiple male beams (e.g., floor joists or posts) to a single female beam (e.g., main girder or column) with parametric control over layout and hardware size.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D model context. |
| Paper Space | No | |
| Shop Drawing | No | Generates 3D machining and visual data only. |

## Prerequisites
- **Required entities:** `GenBeam` (or equivalent structural timber elements).
- **Minimum beam count:** 2 (One or more "male" beams and one "female" beam).
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `IdeFix.mcr` from the file list.

### Step 2: Select Male Beams
```
Command Line: Select male beam(s)
Action: Click on the beam(s) that will be receiving the connector head (e.g., the joists or posts). You can select multiple beams.
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the main beam or column that the male beams connect into. This beam will receive the through-screw machining.
```

### Step 4: Configure Properties
After selection, the script attaches to the beams. Use the **Properties Palette** (Ctrl+1) to configure:
1.  Select the Connector **Type** (Post, Floor, or Rotation Lock).
2.  Adjust the **Diameter** (30, 40, or 50 mm).
3.  Set the grid layout using **Rows** (nRow) and **Columns** (nCol).
4.  Adjust **Offsets** (dOffY, dOffZ) to position the group correctly on the beam face.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | Post connector | Selects the application mode: Post connector, Floor Connector, or Rotation Lock. Determines drill depth and screw configuration. |
| Diam | Number | 30 | Nominal diameter of the Ideefix connector (30, 40, or 50 mm). Adjusts screw sizes and spacing automatically. |
| nRow | Number | 1 | Number of connectors stacked vertically. |
| nCol | Number | 1 | Number of connectors arranged horizontally. |
| OffY | Number | 0 | Lateral offset of the connection group from the insertion point (along the beam width). |
| OffZ | Number | 0 | Vertical offset of the connection group from the insertion point (along the beam height). |
| ShowPlan | Dropdown | No | Toggles visibility of the label and leader line in plan view. |
| DimStyle | String | _DimStyles | Sets the dimension style for the plan view label (controls text size and font). |
| Color | Integer | 94 | Sets the color index for the 3D representation and labels. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the machining and visuals after changing properties in the palette. |
| Erase | Removes the script instance and associated machining. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on hardcoded logic and user properties; no external XML settings are required.

## Tips
- **Rotation Lock Constraints:** If you select **Rotation Lock** as the type, you cannot use more than 2 Rows and 1 Column simultaneously. If you try, the script will automatically switch the Type to "Floor Connector" and display a warning in the command line.
- **Skewed Connections:** The script automatically calculates the correct intersection geometry if the male beam meets the female beam at an angle (non-perpendicular), ensuring the sinkhole fits flush.
- **Plan View Labels:** Use the **ShowPlan** property to create clean 2D drawings. The label includes a count and size (e.g., "2x IF40"). You can move the text by dragging the grip point.

## FAQ
- **Q: Why did my connector type change to "Floor Connector" automatically?**
  **A:** You likely selected "Rotation Lock" but configured a grid with Rows > 2 AND Columns > 1. This geometry is incompatible with the Rotation Lock function, so the script corrected it to "Floor Connector" to prevent errors.
- **Q: Can I connect a joist that is not perpendicular to the main beam?**
  **A:** Yes. The script calculates the intersection volume for non-90-degree connections and adjusts the sinkhole machining accordingly.
- **Q: How do I change the size of the screws?**
  **A:** Change the **Diam** property. The script automatically updates the screw lengths and drill depths based on the selected hardware size (30/40/50).