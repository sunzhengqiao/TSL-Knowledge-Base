# hsb_NoToolArea.mcr

## Overview
This script defines "No Tool" areas on an element to prevent CNC machinery (such as nailing guns or glue applicators) from operating in specific regions. It is commonly used to protect areas around door openings, windows, or connection plates during manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be applied to a 3D Element (Wall, Floor, or Roof). |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawing views directly. |

## Prerequisites
- **Required Entities**: 1 Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: 0 (Operates on Elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_NoToolArea.mcr`

### Step 2: Configure Options
A dialog may appear upon insertion to set initial parameters (optional depending on execution method).

### Step 3: Select Element
```
Command Line: Select an Element
Action: Click on the wall, floor, or roof element you wish to modify.
```

### Step 4: Define Geometry
```
Command Line: Pick a polyline, or enter to pick a point
Action:
Option A: Click an existing closed polyline in the drawing to define the shape.
Option B: Press Enter, then click a point to act as the center of the area.
```

### Step 5: Edit Properties (Optional)
After insertion, select the script instance and press `Ctrl+1` to open the Properties Palette. Adjust dimensions or zones as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Exclusion Type | dropdown | No Nail | Determines the CNC operation to restrict: "No Nail", "No Glue", or "No Nail and No Glue". |
| Zones to apply no tool area | text | 1;2 | Specifies which element zones (faces) are affected. Separate zone numbers with a semicolon (e.g., 1;2). |
| Height | number | 100 | The vertical height of the exclusion area. Only applies if defined by Point. |
| Length | number | 100 | The horizontal length of the exclusion area. Only applies if defined by Point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu items are defined for this script. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Polyline vs. Point**: If you select a polyline during insertion, the "Height" and "Length" properties are ignored, as the shape is defined by the polyline. If you select a point, the script creates a rectangle based on the Height and Length properties centered on that point.
- **Zone Identification**: If you are unsure which zone number corresponds to which face of the element, check your element documentation or use the script's feedback to identify the correct face numbers.
- **Updating**: Changes made in the Properties Panel (like switching from "No Nail" to "No Glue") update the element immediately.

## FAQ
- **Q: How do I apply the "No Tool" area to both sides of a wall?**
  **A:** In the Properties Palette, set `Zones to apply no tool area` to `1;2` (assuming 1 and 2 are the inner and outer faces).
- **Q: Why can't I change the dimensions in the properties?**
  **A:** This happens if the area was originally created using a Polyline. The script uses the polyline geometry exclusively. To use dimensions, erase the instance and re-insert it using the "Point" selection method.
- **Q: What happens if I delete the element?**
  **A:** The script instance detects that the element is invalid and will erase itself automatically.