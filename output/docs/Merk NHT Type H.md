# Merk NHT Type H.mcr

## Overview
This script inserts a Type H NHT steel hanger connection between two timber beams. It automatically generates the 3D representation of the steel plate, creates the necessary mortise (cutout) in the supporting beam, and adds drillings (holes) to the supported beam for a complete connection detail.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where beams are located. |
| Paper Space | No | Not designed for layout/views generation. |
| Shop Drawing | No | Not a multipage or detailing script for drawings. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities (beams).
- **Minimum Beam Count**: 2 (one supported beam and one supporting beam).
- **Required Settings**: None. The script uses internal logic to determine sizes.

## Usage Steps

### Step 1: Launch Script
Execute the insert command in the CAD environment.
```
Command: TSLINSERT
Action: Browse and select "Merk NHT Type H.mcr" from the script list.
```

### Step 2: Select Beams
The script requires two beams to define the connection geometry.
```
Command Line: Select the supported beam (joist/post).
Action: Click the beam that will be held by the hanger.
```
```
Command Line: Select the supporting beam (main beam).
Action: Click the beam that the hanger attaches to.
```
*Note: The script will insert the hanger based on default properties immediately after selection.*

### Step 3: Configure Properties
Once inserted, the script can be configured via the Properties Palette (OPM). Select the script instance in the model to see its properties. Adjust the **NHT Nr.** to resize the hanger.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Auto Select** | dropdown | Yes | If "Yes", filters the NHT Nr. list to show only hangers that fit the beam height. If "No", shows all available sizes. |
| **Drill Nailhole** | dropdown | No | If "Yes", creates an additional diagonal nail/screw hole in the supported beam. |
| **Diameter Nailhole** | number | 6.0 | Sets the diameter (in mm) for the optional nail hole. Only active if "Drill Nailhole" is Yes. |
| **Z-Offset** | number | 0.0 | Moves the hanger assembly vertically (up or down) relative to the beam center. |
| **Color** | number | 9 | Sets the display color index (0-255) for the hanger body and label. |
| **Dimstyle** | dropdown | *empty* | Selects the CAD dimension style to use for the text label indicating the hanger size. |
| **NHT Nr.** | dropdown | *Dynamic* | Selects the specific height (e.g., 120, 140... 240) of the hanger to generate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Standard Recalculate* | Refreshes the script geometry if beams are moved or properties are changed. (No specific custom menu items were detected). |

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Filtering Sizes**: Keep **Auto Select** set to "Yes" to prevent selecting a hanger that is physically taller than your timber beam.
- **Vertical Adjustment**: If the hanger clashes with another connection or hardware, use the **Z-Offset** to shift it up or down without changing the beam geometry.
- **Production Data**: The script automatically outputs BOM data (Screw count and Material name) to the element map. Ensure your export templates are set up to read this data.

## FAQ
- **Q: Why is the "NHT Nr." dropdown empty?**
  **A:** This usually happens if **Auto Select** is "Yes" and your beam height is outside the range of defined hangers (e.g., too small or too large). Switch **Auto Select** to "No" to see the full list of available sizes.
  
- **Q: How do I add a nail hole for additional fixing?**
  **A:** Select the script instance, go to the Properties Palette, set **Drill Nailhole** to "Yes", and ensure the **Diameter Nailhole** is set to the correct size (e.g., 6mm for a standard screw).

- **Q: The hanger is inserted in the wrong vertical position.**
  **A:** You do not need to move the script manually. Change the **Z-Offset** value in the Properties Palette to slide it into the correct position.