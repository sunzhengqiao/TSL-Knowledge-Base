# Hilti-Einzeln.mcr

## Overview
Automates the connection of two timber beams using Hilti Stexon hardware (HCW/HCWL wood couplers and HSW hanger bolts). It calculates drilling, milling, and hardware placement for both parallel (distributed) and crossing (single) beam configurations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D beam selection and machining. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Two `GenBeam` elements.
- **Minimum Beam Count**: 2.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-Einzeln.mcr` from the catalog.

### Step 2: Select First Beam
```
Command Line: Select beam 1:
Action: Click on the first timber beam in the 3D model.
```

### Step 3: Select Second Beam
```
Command Line: Select beam 2:
Action: Click on the second timber beam (either crossing or parallel to the first).
```

### Step 4: Configure Connection
Once inserted, the script automatically detects if beams are crossing (places one connector) or parallel (distributes connectors). Use the **Properties Palette** to adjust spacing, offsets, and drill sizes as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Distribution** | | | |
| Mode of Distribution | dropdown | Even | Defines if spacing is calculated evenly ('Even') or fixed at a specific step ('Fixed'). |
| Start Distance | number | 0 | Distance from the start of the overlap to the first connector. |
| End Distance | number | 0 | Distance from the end of the overlap to the last connector. |
| Max. Distance between / Quantity | number | 500 | Positive value = Max spacing (mm). Negative value = Exact number of connectors. |
| Real Distance between | number | 0 | (Read-Only) Calculated center-to-center distance. |
| Nr. | number | 0 | (Read-Only) Total quantity of connectors generated. |
| **Version** | | | |
| Version | dropdown | Custom | Selects Hilti product type (HCW, HCWL) or Custom settings. |
| **Position** | | | |
| Offset | number | 0 | Lateral shift of the connector perpendicular to the beam axis. |
| Offset Start | number | 0 | Lateral offset at the start of the beam (for tapered distribution). |
| Offset End | number | 0 | Lateral offset at the end of the beam (for tapered distribution). |
| Rotation | number | 0 | Rotational angle of the connector/drill pattern (degrees). |
| **Drill** | | | |
| Diameter | number | 30 | Diameter of the primary vertical drill hole. |
| Depth | number | 250 | Depth of the primary drill hole. |
| **2. Bohrung (Counterbore)** | | | |
| Diameter | number | 0 | Diameter of the counterbore. If > Main Diameter, it creates a pocket; otherwise, it adjusts the top section. |
| Depth | number | 0 | Depth of the counterbore. |
| **Milling** | | | |
| Width | number | 0 | Width of the rectangular milling slot. |
| Depth | number | 0 | Depth of the rectangular milling slot. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Beams | Swaps the roles of the two connected beams (e.g., top becomes bottom). |
| Generate Single Instances | Dissolves a distributed connection into individual TSL instances for each connector. |
| Stexon Export | Exports selected connector data to a `.dxx` file for Hilti software. |
| save Beam Body | Saves the current beam body geometry to the map. |

## Settings Files
None required.

## Tips
- **Setting Quantity**: To specify an exact number of connectors for parallel beams, enter a **negative number** in the "Max. Distance between / Quantity" property (e.g., enter `-5` for 5 connectors).
- **Orientation**: If the hardware is applied to the wrong beam (e.g., the bolt is on the top instead of the bottom), use the **Swap Beams** right-click option.
- **Crossing Beams**: When beams cross, the script places a single instance at the intersection point regardless of the distribution settings.
- **Rotation**: Use the **Rotation** property if the connector orientation needs to be aligned differently relative to the beam surface.

## FAQ
- Q: How do I distribute connectors evenly along the entire overlap?
- A: Set "Mode of Distribution" to `Even`, ensure "Start Distance" and "End Distance" are `0`, and set "Max. Distance between" to your desired maximum spacing.

- Q: My beams are crossing, but I don't see any connectors.
- A: Ensure you have selected two distinct beams. If they cross at a very sharp angle or barely touch, check that the intersection calculation is finding a valid common area.

- Q: What is the difference between "Even" and "Fixed" distribution?
- A: `Even` calculates the spacing required to fit the maximum number of connectors within the limit. `Fixed` places connectors at exact intervals (step size) defined by the "Max. Distance between" value, potentially leaving a gap at the end.