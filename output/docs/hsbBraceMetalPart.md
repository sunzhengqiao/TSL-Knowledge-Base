# hsbBraceMetalPart.mcr

## Overview
This script generates a diagonal brace metal part connection between two perpendicular timber beams. It creates the physical representation (plates and diagonal volume) and assigns hardware properties for BOMs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script calculates 3D geometry based on beam intersections. |
| Paper Space | No | Not designed for 2D detailing layouts. |
| Shop Drawing | No | Model space insertion only. |

## Prerequisites
- **Required Entities**: 2 Timber Beams.
- **Minimum Beam Count**: 2 beams must be selected.
- **Configuration**: The two beams must be perpendicular (90 degrees) and physically intersect in 3D space.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBraceMetalPart.mcr`

### Step 2: Select Beams
```
Command Line: Select 2 perpendicular beam(s)
Action: Click on the first beam, then click on the second beam.
```

### Step 3: Select Location (If Required)
```
Command Line: Select location
Action: If there are multiple valid quadrants around the beam intersection, click in the desired area to place the brace. If only one valid placement exists, this step is skipped automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Size | Number | 600 mm | Defines the length/size of the diagonal brace metal part. Updates geometry and hardware scale. |
| Maker | Text | (Empty) | Defines the Manufacturer name (e.g., "Simpson", "MiTek"). Used for BOM reporting. |
| Product Name | Text | (Empty) | Defines the specific Product Name or model code. Used for BOM reporting. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None defined | This script does not add specific items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: This script operates independently without external settings files.

## Tips
- **Beam Intersection**: Ensure your beams actually cross each other in the 3D model. If they just touch at corners or miss each other slightly, the script may fail.
- **Perpendicularity**: The script strictly checks for 90-degree angles. If you receive a "beams are not perpendicular" error, check your beam rotations in the model.
- **Adjusting Size**: After insertion, you can select the generated brace and simply type a new value in the "Size" field in the Properties palette (Ctrl+1) to lengthen or shorten the brace without re-inserting.

## FAQ
- **Q: Why does the command fail saying "wrong number of selected beams"?**
  - A: You must select exactly two beams. If you pre-selected more or fewer than two before running the command, or if you clicked the same beam twice, it will error.
- **Q: The script runs but then disappears immediately.**
  - A: This usually happens if the selected point for location falls outside a valid region (e.g., you clicked too far from the intersection) or if the beams do not actually intersect. Try picking a point closer to where the beams cross.
- **Q: How do I get the brace to show up in my Material List?**
  - A: Ensure you fill in the "Maker" and "Product Name" fields in the Properties Palette after insertion. These fields link the visual part to the BOM data.