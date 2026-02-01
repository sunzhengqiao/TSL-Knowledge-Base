# GE_HDWR_HGA10.mcr

## Overview
Generates a 3D parametric model and CNC data for the Simpson Strong-Tie HGA10 hurricane tie connector. It joins two perpendicular beams, automatically creating the metal part geometry and assigning material data for manufacturing lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script constructs 3D geometry and requires beam selection. |
| Paper Space | No | This script is for 3D modeling only. |
| Shop Drawing | No | However, coordinate and nail info data is exported for potential use in layouts. |

## Prerequisites
- **Required Entities**: 2 `GenBeam` entities positioned perpendicularly (e.g., a rim joist and a floor joist).
- **Minimum Beam Count**: 2.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Browse to the script location, select GE_HDWR_HGA10.mcr, and click Open.
```

### Step 2: Select Back Beam
```
Command Line: Select beam for back of connector.
Action: Click on the beam that will serve as the vertical backing (e.g., the rim joist or header).
```

### Step 3: Select Bottom Beam
```
Command Line: Select beam for bottom of connector.
Action: Click on the beam that will serve as the horizontal bottom support (e.g., the ledger or joist).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connector Face | Dropdown | Front | Determines the orientation of the bracket relative to the beams. Select "Back" to flip the connector to the opposite side of the corner. |
| Nail Info | Text | [Empty] | Allows entry of custom text for shop drawings (e.g., "10d Common @ 6\" o.c."). This text is exported to the element Map for labels. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. Modify parameters via the Properties Palette. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: N/A (The script uses internal dimensions and standard catalog mapping for the Simpson HGA10).

## Tips
- **Flipping the Bracket**: If the connector appears on the wrong side of the connection, select the script instance and change the **Connector Face** property in the Properties Palette from "Front" to "Back".
- **Moving the Connector**: Click and drag the insertion point grip to slide the connector along the beam. The movement is constrained to the beam's axis.
- **Dynamic Updates**: If you move or stretch the connected beams in Model Space, the connector geometry will automatically update to follow the new beam positions.

## FAQ
- **Q: Can I use this on non-perpendicular beams?**
  - A: The script is designed for perpendicular connections (90 degrees). Using it on acute or obtuse angles may result in incorrect geometry.
- **Q: How do I specify nails for the Bill of Materials (BOM)?**
  - A: The script generates the hardware part (HGA10) automatically. Use the **Nail Info** property to add text notes for the shop drawings, but ensure your BOM settings handle hardware quantities separately.
- **Q: The script erased itself immediately after running. Why?**
  - A: This likely happened because you did not select two valid beams. Ensure you click two distinct `GenBeam` entities during the prompts.