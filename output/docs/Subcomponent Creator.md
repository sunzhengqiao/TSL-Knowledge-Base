# Subcomponent Creator

## Overview
Creates a logical production grouping by assigning a shared Name and unique ID to a set of touching, aligned beams. It validates that selected beams form a single, contiguous physical assembly and visualizes the group with a bounding box and label.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model to validate beam geometry and write attributes. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Does not generate detailing views. |

## Prerequisites
- **Required Entities:** GenBeams (standard timber beams).
- **Minimum Beam Count:** 1 or more (practically used for groups).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Subcomponent Creator.mcr`

### Step 2: Configure Properties
```
Action: The Properties Palette (OPM) opens automatically.
Task: Enter a descriptive Name for the subcomponent (e.g., "Wall-Segment-A").
Optional: Adjust visual settings like text size or color.
```

### Step 3: Select Beams
```
Command Line: |Select beam(s)|
Action: Click on the beams that form the assembly.
Confirmation: Press Enter or Space to finish selection.
```
**Note:** The script will automatically verify if the beams are parallel and physically touching.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | Text | Unknown | The production name or label assigned to the assembly (e.g., 'Truss-Left'). This is written to the beam data. |
| textColour | Number | 3 | The display color of the label and outline (0-255 AutoCAD Color Index). |
| textSize | Number | 50 mm | The height of the text label in the model. |
| shrinkSize | Number | 5 mm | The amount to trim the visual outline so it sits neatly inside the beam profile. |
| transparencyPercent | Number | 50 % | The opacity of the filled polygon (0 = Opaque, 90 = Transparent). |
| vectorTolerance | Number | 0.01 mm | The allowable deviation for beam alignment. If beams deviate more than this from being perfectly parallel, the script will fail. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the right-click context menu. Edit properties via the Properties Palette. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Alignment Check:** Ensure all selected beams are running in the same direction (parallel). If beams are perpendicular or skewed, the script will abort and delete itself.
- **Connectivity:** Beams must be physically touching (end-to-end or side-by-side). Small gaps will cause the script to fail.
- **Dynamic Updates:** You can change the "Name" property at any time via the Properties Palette to update the label and data on the beams.
- **Modifying Geometry:** If you move or stretch the beams such that they no longer touch or align, the script instance will automatically delete itself to prevent invalid data.

## FAQ
- **Q: Why did the script disappear immediately after I selected the beams?**
  **A:** The validation checks failed. This usually happens because the selected beams were not perfectly parallel (within `vectorTolerance`) or were not physically touching each other.
- **Q: Can I group beams that are just close to each other but not touching?**
  **A:** No, this script requires physical contact. Use gaps or overlap scripts for non-touching assemblies.
- **Q: Where is the data stored?**
  **A:** The script writes the Name and a unique ID into the `Hsb_SubcomponentData` map attached to each selected beam. This data can be used in lists or labels.
- **Q: How do I change the text size later?**
  **A:** Select the subcomponent (the text or outline in the model), open the Properties Palette, and modify the `textSize` value. The visual will update immediately.