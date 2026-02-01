# HSB_E-LinePattern.mcr

## Overview
This script inserts a visual pattern of parallel lines onto a specific zone of a structural element. It is used primarily to visualize layout spacing (such as studs or rafters) and automatically adjusts the pattern direction if the element width does not match the spacing perfectly, ensuring a clean connection with neighboring elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted and attached to elements in the 3D model. |
| Paper Space | No | Not designed for use in 2D layouts. |
| Shop Drawing | No | Does not generate annotations in shop drawings. |

## Prerequisites
- **Required Entities**: Element (e.g., Wall, Roof, or Floor elements).
- **Minimum Beam Count**: 0
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-LinePattern.mcr`

### Step 2: Configure Properties (Dialog)
If running the script manually (without a specific execute key), a properties dialog will appear first.
```
Dialog: Property Dialog
Action: Set the Zone Index, Spacing, and Line Color as desired. Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Element(s) in the model where you want the line pattern to appear. Press Enter to confirm selection.
```
*Note: The script will automatically attach itself to the selected elements and generate the lines immediately.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index | dropdown | 6 | Selects the specific side or zone (e.g., inside face, outside face, edges) of the element where the lines are drawn. |
| Spacing | number | 122 mm | The center-to-center distance between the layout lines. |
| Line color | number | 1 (Red) | The AutoCAD Color Index (ACI) used for the generated lines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| MasterToSatellite | Updates the properties on the satellite instances attached to the elements (typically triggered automatically). |

## Settings Files
No specific settings files are required for this script.

## Tips
- **Odd Elements**: If the width of the element is not an exact multiple of the spacing, the script detects "Odd" elements. It will check for intersecting neighbors and automatically swap the layout direction to avoid a small off-cut at the connection.
- **Modifying Layout**: You can change the density or position of the lines at any time by selecting the script instance in the model and adjusting the "Spacing" or "Zone index" in the Properties Palette.
- **Visual Feedback**: If the layout direction is swapped due to a neighbor connection, a directional arrow may be drawn to indicate the change.

## FAQ
- **Q: Why are my lines appearing on the wrong face of the wall?**
  - A: Check the **Zone index** property in the Properties Palette. Changing this number (0-10) moves the pattern to different faces or zones of the element.
- **Q: The pattern doesn't start at the edge of the element. Why?**
  - A: The script likely detected a neighboring element and swapped the distribution direction to ensure the spacing aligns better across the connection.
- **Q: Can I use this to generate actual framing?**
  - A: No, this script is for visualization purposes only (layout lines), not for generating structural beams.