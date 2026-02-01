# GE_FLOOR_CENTER_OF_GRAVITY

## Overview
This script calculates the Center of Gravity (CG) for floor or roof elements based on material weights and automatically generates lift holes at optimal structural locations. It helps identify the balance point for crane lifting and ensures hardware is placed safely.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space on a valid Element. |
| Paper Space | No | Not designed for Paper Space or Viewports. |
| Shop Drawing | No | This is a production/modeling script, not a layout detailing script. |

## Prerequisites
- **Required Entities**: An Element (e.g., Floor or Roof assembly) containing internal entities such as GenBeams, Sheets, or TrussEntities.
- **Minimum Beam Count**: 0 (The script calculates weight based on volume, but requires an Element with geometry).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_FLOOR_CENTER_OF_GRAVITY.mcr`

### Step 2: Select Element
```
Command Line: Select a set of elements
Action: Click on the Floor or Roof element in the model to calculate its Center of Gravity.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length Factor | dropdown | 1/2 Length In | Determines the radius of the visual "clearance zone" circle around the Center of Gravity. Options include 1/2, 1/4, or 1/3 of the length to indicate safe lifting areas. |
| Show Circle | dropdown | No | Toggles the visibility of the lifting zone circle in the model. Select "Yes" to visualize the area. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Visualizing the Safe Zone**: Set the **Show Circle** property to "Yes" to see the recommended clearance area around the Center of Gravity.
- **Ensuring Accuracy**: The script requires the Element to be fully populated with beams and sheets to calculate an accurate weight-based Center of Gravity.
- **Hole Generation**: This script automatically triggers the `GE_FLOOR_HOLES` sub-script to drill holes. Ensure that script is available in your TSL search path if machining is required.

## FAQ
- Q: Why is the circle not appearing?
  A: Check the Properties Palette. Ensure **Show Circle** is set to "Yes". If it is set to "No", only the CG point and crosshairs will be displayed.
- Q: How are the lift holes positioned?
  A: The script attempts to place holes on the main structural members (joists or trusses) nearest to the calculated Center of Gravity, automatically avoiding steel plates and sheet overlaps.