# CC.mcr

## Overview
This script automates the insertion and tooling of concealed shear connectors (specifically Knapp Walco Z-type brackets) to join two parallel timber wall panels. It calculates the required milling and drilling for precise on-site assembly using dovetail-like mechanisms.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script requires 3D context with two parallel beams (studs). |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script focuses on 3D model generation and CNC tooling. |

## Prerequisites
- **Required Entities:** Two GenBeams (e.g., wall studs) belonging to stick frame walls.
- **Minimum Beam Count:** 2 parallel beams.
- **Required Settings Files:** XML configuration files (e.g., `Z40.xml`, `Z32.xml`) must be present in the folder `_kPathHsbCompany\Block`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CC.mcr`

### Step 2: Select First Beam
```
Command Line: Select first beam
Action: Click on the first wall stud (principal beam) that will hold the connector.
```

### Step 3: Select Second Beam
```
Command Line: select second parallel beam
Action: Click on the parallel wall stud located on the adjacent wall panel.
```

*Note: The script will automatically validate that the beams are parallel and belong to valid wall elements before generating the connector and tooling.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insertion Mode | number | 0 | Determines the insertion logic (Mode 0 = Two Studs). |
| Manufacturer | text | Knapp Walco | The brand of the connector (must match XML folder name). |
| ConnectorType | text | Z40 | The specific model number (e.g., Z40, Z32). Loads specific geometry. |
| ConnectorOffsetX | number | 0.0 | Shifts the connector position along the length of the beam (mm). |
| ConnectorOffsetZ | number | 0.0 | Shifts the connector position vertically relative to the beam (mm). |
| Write to element | number | 0 | If set to 1, tooling data is written to the parent Wall Element. |
| GroupCode | text | (empty) | User-defined code for grouping in reports or BOMs. |
| DrillDiameter | number | -1.0 | Diameter of drill holes. Set to -1 to use XML default. |
| DrillDepth | number | -1.0 | Depth of drill holes. Set to -1 to use XML default. |
| MillingWidth | number | -1.0 | Width of the slot for the connector. Set to -1 to use XML default. |
| MillingDepth | number | -1.0 | Depth of the slot for the connector. Set to -1 to use XML default. |
| Marking | number | 0 | If set to 1, adds a visual marking/scribing on the timber. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Connectors | Swaps the male and female connector halves between the two beams. It also inverts the offset values (X and Z) to maintain the connector's relative position. |

## Settings Files
- **Filename**: `<ConnectorType>.xml` (e.g., `Z40.xml`)
- **Location**: `_kPathHsbCompany\Block`
- **Purpose**: Defines the 3D block geometry, default dimensions, and machining rules (drills/milling) for the specific connector model.

## Tips
- **Offset Adjustment**: Use `ConnectorOffsetX` and `ConnectorOffsetZ` to slide the connector along the beam or up/down without moving the beam itself.
- **Tooling Defaults**: Keep Drill and Milling dimensions set to `-1` to automatically use the manufacturer's recommended specifications found in the XML file.
- **Orientation**: If the connector is facing the wrong way for your assembly sequence, use the Right-Click "Swap Connectors" option instead of re-selecting beams.

## FAQ
- **Q: I get an error "2 beams not parallel".**
  A: Ensure the two studs you selected are perfectly parallel (or within a very small tolerance). They must belong to two separate wall panels intended to be connected.
  
- **Q: The connector geometry is missing.**
  A: Verify that the XML file matching your `ConnectorType` (e.g., `Z40.xml`) exists in your company block folder (`_kPathHsbCompany\Block`).

- **Q: How do I change the connector size after insertion?**
  A: Select the script instance in the model, open the Properties Palette, and change the `ConnectorType` property (e.g., from "Z40" to "Z32"). The script will reload the new geometry and tooling.