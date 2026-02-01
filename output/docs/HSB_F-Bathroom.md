# HSB_F-Bathroom.mcr

## Overview
This script automates the creation of a framed bathroom wet area within a floor element. It generates trimmer beams, internal floor joists, and a dedicated floor sheet based on a selected polyline, while automatically cutting openings in existing floor sheets and beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to generate structural framing. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Does not generate shop drawing views directly. |

## Prerequisites
- **Floor Element**: An existing hsbCAD floor element (Element) must exist in the model.
- **Bathroom Polyline**: A closed polyline (EntPLine) drawn in the model to define the exact boundary of the bathroom area.
- **Model Space**: The script must be run in the 3D CAD environment.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_F-Bathroom.mcr`.

### Step 2: Configure Properties
**Dialog:** Properties Palette
Action: A dialog appears allowing you to set initial parameters (e.g., joist spacing, material depths). You can accept defaults or modify them now. Click OK to proceed.

### Step 3: Select Floor Element
```
Command Line: |Select floor element|
Action: Click on the main floor element (e.g., a joisted floor slab) where the bathroom will be located.
```

### Step 4: Select Boundary Polyline
```
Command Line: |Select the poly line that describes the floor area.|
Action: Click on the polyline you have drawn that outlines the bathroom footprint.
```

### Step 5: Completion
Action: The script will generate the frame, internal joists, and floor sheet. Existing floor sheets within the boundary will be cut out to make room for the new bathroom structure.

## Properties Panel Parameters

### Bathroom Floor
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Floor depth | Number | 48 mm | Vertical height of the front and back trimmer beams (rim joists). |
| Thickness sheet bath room floor | Number | 12 mm | Thickness of the flooring material (OSB/Plywood) used for the bathroom sheet. |
| Color bathroom | Number | 90 | CAD color index for the bathroom floor sheet. |
| Description | Text | Bath room | Text label displayed in the model to identify the bathroom area. |
| Dimension style | Text | _DimStyles | The dimension style applied to display lines associated with the bathroom. |

### Frame
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width trimmer | Number | 48 mm | Width (plan view depth) of the front and back trimmer beams. |
| Width side trimmer | Number | 23 mm | Width (plan view depth) of the left and right side trimmer beams. |
| Height side trimmer | Number | 48 mm | Vertical height of the left and right side trimmer beams. |
| Color frame | Number | 40 | CAD color index for the trimmer frame beams. |
| Spacing floor joists | Number | 300 mm | On-center spacing between the internal floor joists. |
| Color joist | Number | 30 | CAD color index for the internal bathroom joists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate bathroom floor | Deletes the existing geometry and regenerates the frame, joists, and sheets based on the current polyline shape and property settings. Use this after modifying the polyline or changing dimensions. |

## Settings Files
- **None Required**: This script relies entirely on user inputs and OPM properties; no external XML settings files are used.

## Tips
- **Modifying the Shape**: You can change the bathroom size or shape by editing the vertices of the input polyline using standard AutoCAD grips (PEDIT/GRIPS). Right-click the script instance and select "Recalculate bathroom floor" to update the framing.
- **Automatic Cutting**: The script automatically cuts holes in existing floor sheets (Zone 1) and trims existing beams that fall inside the bathroom area. Ensure your main floor element is correct before inserting.
- **Asymmetric Framing**: You can use the `Height side trimmer` parameter to create different heights for the side trimmers compared to the front/back trimmers (defined by `Floor depth`).
- **Joist Stretching**: The internal joists are generated to stretch out and intersect with the existing main floor structure beyond the bathroom frame.

## FAQ
- **Q: Why did the script fail with "Invalid opening poly line selected"?**
  **A**: The polyline selected may be degenerate (zero length) or not a valid entity. Ensure the polyline is closed and has a distinct area.
- **Q: How do I change the joist spacing after insertion?**
  **A**: Select the script instance, open the Properties Palette (Ctrl+1), change the `Spacing floor joists` value, and then right-click the script to choose "Recalculate bathroom floor".
- **Q: Can I move the bathroom to a different location?**
  **A**: Yes. Move both the script instance and the reference polyline together to the new location, then recalculate. Alternatively, you can delete the script instance, move the polyline, and run the insertion process again.