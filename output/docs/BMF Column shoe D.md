# BMF Column shoe D.mcr

## Overview
This script automatically generates a BMF Type D Column Shoe steel connection. It sizes the hardware (shank, base plate, and side plates) based on the column's width, creates the 3D visualization, and cuts the necessary slot in the timber beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D modeling. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: 1 GenBeam (Column)
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF Column shoe D.mcr`

### Step 2: Select Column
```
Action: Select the GenBeam representing the timber column.
Details: The script will automatically detect the beam's width to determine the correct shoe size.
```

### Step 3: Validation & Generation
```
Action: The script validates the beam width.
Outcome: 
- If the width matches a supported size, the shoe is created and the beam is cut.
- If the width is not supported, the script displays an error and removes itself.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Base Height | Number | 0 | The vertical offset (mm) between the bottom of the column and the base plate (e.g., for leveling shims). |
| Type of Fixing | Dropdown | Nails | Specifies the fastener method for the side plates. Options: Nails, Screws. This updates the Article number/BOM data. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. Use the Properties palette to modify parameters. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: All dimensions are calculated internally based on beam width.

## Tips
- **Supported Widths**: Ensure your column width matches one of the following sizes (mm): 48, 50, 73, 75, 80, 90, 98, 100, 115, 120, 140, 148. If the width does not match, the script will fail to insert.
- **Adjusting Offset**: Use the `Base Height` property if you need to account for grout or shims at the base of the column.
- **Visualization**: The script creates distinct 3D bodies for the shank, base plate, and side plates, making it easy to visualize in the model.

## FAQ
- **Q: Why did the script disappear immediately after I selected the beam?**
  A: The beam width you selected is not supported by this BMF shoe type. Check the column dimensions and try again.
- **Q: Does changing the 'Type of Fixing' change the geometry?**
  A: No, it only updates the Article number and Designation in the BOM (Bill of Materials) for production purposes.
- **Q: How do I move the shoe up or down?**
  A: Change the `Base Height` value in the Properties palette. Positive values move the shoe assembly down relative to the column end.