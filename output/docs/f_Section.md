# f_Section

## Overview
This script generates a 2D cross-sectional view of timber elements loaded onto truck grids. It is used to visualize and verify how the load is packaged at specific longitudinal positions on the transport vehicle.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates exclusively in the 3D model environment. |
| Paper Space | No | Cannot be inserted directly into Layout tabs. |
| Shop Drawing | No | Not intended for generating manufacturing drawings. |

## Prerequisites
- **Required Entities**: `f_truck` TSL instances (specifically those configured as grids).
- **Minimum Beam Count**: N/A (Selects TSL instances, not raw beams).
- **Required Settings**: `f_Stacking.xml` (Must be present in Company or Install TSL settings folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Section.mcr`

### Step 2: Select Trucks
```
Command Line: Select stacked trucks
Action: Click on the truck grid instances (f_truck) that you want to inspect. Press Enter when finished.
```

### Step 3: Define Section Cut Position
```
Command Line: Select point on section line
Action: Click a point along the length of the truck. This defines where the "slice" will be taken.
```

### Step 4: Define View Location
```
Command Line: Select section location
Action: Click in the open space where you want the resulting cross-section drawing to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dTextHeight | Double | U(0) | Controls the height of the section labels (e.g., '# 1'). Set to 0 to use the current Dimension Style text height, or enter a specific value in millimeters. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None specific) | This script relies on standard TSL options and interactive grips rather than custom context menu entries. |

## Settings Files
- **Filename**: `f_Stacking.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Defines the sequential colors used to highlight different layers or elements within the cross-section view.

## Tips
- **Dynamic Adjustment**: After insertion, use the **Grips** to adjust the section.
  - **Grip on the Truck**: Drag this to slide the section cut line along the length of the truck. The section view updates automatically to show the load at the new position.
  - **Grip on the View**: Drag this to move the generated cross-section drawing to a cleaner area of the model without recalculating the cut.
- **Visibility Check**: Use this tool to ensure that tall timber elements do not exceed the truck's profile height at specific points.
- **Automatic Numbering**: If you create multiple sections on the same truck, the script automatically assigns sequence numbers (# 1, # 2, etc.) based on the order of creation.

## FAQ
- Q: Why is my section text huge or tiny?
- A: Check the `dTextHeight` property in the AutoCAD Properties palette. If it is set to 0, it follows your Dimension Style settings. Change it to a fixed value (e.g., 100) for consistent sizing.

- Q: Can I section multiple trucks at once?
- A: Yes, during Step 2, you can select multiple truck grids. The section will visualize the combined load profile at the specified cut location.