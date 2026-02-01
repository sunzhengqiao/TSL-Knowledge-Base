# BMF-Gerbervervinder.mcr

## Overview
This script inserts a BMF Gerberverbinder (metal hinged connector) to join timber beams end-to-end or side-by-side. It automatically generates the 3D steel plate geometry and corresponding hardware listings based on the beam dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on 3D beams in the model. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Does not generate 2D views directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1 (If only one beam is selected, the script will automatically split it at the insertion point).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF-Gerbervervinder.mcr`

### Step 2: Select Primary Beam
```
Command Line: select one beam
Action: Click on the first timber beam you wish to connect.
```

### Step 3: Select Secondary Beam (Optional)
```
Command Line: select additional beam (optional)
Action: Click a second beam if connecting two existing beams. 
Alternatively, press Enter to skip if you are splitting a single beam.
```

### Step 4: Define Insertion Point
```
Command Line: Select insertion point
Action: If you skipped Step 3, click on the single beam where you want the split and connector to occur. 
If two beams were selected, this step is skipped automatically (insertion point is calculated).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connector | dropdown | Dynamic | Selects the specific connector profile (e.g., B 125, W 160). Options are filtered by beam height. |
| Orientation | dropdown | Z-Axis | Determines which beam dimension drives the connector size. "Z-Axis" uses Height; "Y-Axis" uses Width. |
| Switch Connector | dropdown | No | Mirrors the connector geometry 180 degrees. Set to "Yes" to flip the plate orientation. |
| Show description | dropdown | Yes | Toggles the visibility of the text label (Type and Size) in the model. |
| Dimstyle | dropdown | _DimStyles | Selects the dimension style for the text label. |
| Nail Diameter | number | 4 | Diameter of the nails/fasteners used. |
| Number of nails | number | 0 | Total quantity of nails required for the connection. |
| Nail Length | number | 40 | Length of the nails/fasteners. |
| Color | number | 171 | Visual color index of the connector in the CAD model. |
| X-flag | number | 200 | Horizontal offset distance for the text label leader line. |
| Y-flag | number | 300 | Vertical offset distance for the text label leader line. |
| Nail Model | text | Kammnagel | Commercial name/type of the nail model. |
| Article (Nail) | text | | Article number or SKU for the nails. |
| Material (Nail) | text | Stahl, verzinkt | Material specification for the nails. |
| Metalpart Notes (Nail) | text | | Additional notes for the fasteners. |
| Article (Plate) | text | | Article number or SKU for the connector plate. |
| Material (Plate) | text | Stahl, feuerverzinkt | Material specification for the connector plate. |
| Metalpart Notes (Plate) | text | | Additional notes for the connector plate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the connector geometry if beam properties change. |
| Erase | Removes the connector instance. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A (All dimensions are calculated internally).

## Tips
- **Splitting Beams**: If you only select one beam, the script automatically splits it into two separate beams at the clicked insertion point and applies the connector.
- **Alignment**: Ensure that when connecting two beams, they are aligned (codirectional) along their length; otherwise, the script will fail to insert.
- **Sizing**: The connector is designed for standard beam heights/widths between 110mm and 280mm. If your beam is outside this range, the connector will not generate.
- **Text Position**: Use the `X-flag` and `Y-flag` properties to adjust the text label position if it clashes with other model elements.

## FAQ
- **Q: Why do I get the error "The cross Section of the beam has not the right size"?**
  A: The selected beam's height (or width if Orientation is set to Y-Axis) does not match the available connector sizes in the catalog (valid ranges are 110, 125, 140, 150, 160, 175, 180, 200, 220, 240, 260, 280 mm).
- **Q: How do I flip the connector to the other side of the joint?**
  A: Select the connector, open the Properties Palette, and change the "Switch Connector" property to "Yes".
- **Q: Can I use this on the wide face of a beam?**
  A: Yes. Change the "Orientation" property from "Z-Axis" to "Y-Axis". This will use the beam's width to select the appropriate connector size.