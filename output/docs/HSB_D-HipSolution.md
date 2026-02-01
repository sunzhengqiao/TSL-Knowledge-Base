# HSB_D-HipSolution

## Overview
This script automatically generates dimension lines for hip roof connections (rafters, trimmers, and hips) in Paper Space manufacturing drawings. It allows for flexible filtering of structural members and customizable positioning of dimension lines relative to the selected roof geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing views. |
| Paper Space | Yes | Must be run inside a layout viewport containing an Element. |
| Shop Drawing | Yes | Specifically designed for manufacturing drawings. |

## Prerequisites
- **Required Entities:** A Viewport linked to an Element containing structural GenBeams (Rafters, Trimmers, Hips).
- **Minimum Beam Count:** At least 2 beams (e.g., one rafter and one trimmer/hip).
- **Required Settings:** The script relies on `HSB_G-FilterGenBeams.mcr` for advanced filtering capabilities.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `HSB_D-HipSolution.mcr` from the file dialog.

### Step 2: Select Viewport
```
Command Line: Select the viewport
Action: Click inside the layout viewport where the hip roof is displayed.
```

### Step 3: Select Insertion Point
```
Command Line: Select a position
Action: Click a point in Paper Space to place the script label (this determines where the script instance name is displayed).
```

### Step 4: Configure Dimensions (Optional)
1.  Select the script instance (or the label) after insertion.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust **Beam Codes** (under "Selection") to match your model (e.g., ensure `Beamcode rafter` matches your actual rafter code).
4.  Adjust **Dimension Object** to choose whether to dimension Rafters, Trimmers, or the Hip.
5.  Modify **Offset** and **Layout** settings to position the dimension lines correctly.

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition for beams | dropdown | "" | Select a predefined filter configuration created in HSB_G-FilterGenBeams. |
| Filter beams with beamcode | text | "" | Manually filter beams by Beam Code (use semicolons for multiple codes). |
| Filter beams and sheets with label | text | "" | Filter beams based on assigned labels. |
| Filter zones | text | "" | Filter beams based on construction zones. |

### Hip Dimension Identification
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcode rafter | text | HK-R | The Beam Code identifying the common rafters. |
| Beamcode trimmer | text | HK-T | The Beam Code identifying the trimmer beam. |
| Beamcode hip | text | HK-01 | The Beam Code identifying the hip rafter. |

### Dimension Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension object | enum | Rafters | Selects the target: `Rafters`, `Trimmer`, or `Hip`. |
| Dimension side | enum | Left | Which side of the beam to measure from (`Left`, `Center`, `Right`, `Left & Right`). |
| Dimension layout | enum | Delta perpendicular | Style of dimensions (`Delta`/`Cumulative` + `Perpendicular`/`Parallel`). |
| Delta on top | enum | Above | Placement of text relative to the dimension line (`Above`, `Below`). |
| Dim line offset | number | 15 | Distance between the dimension line and the beam geometry. |
| Use PS units | enum | No | If `Yes`, the offset is in Paper Space mm (scales with viewport zoom). |
| Dim style | text | HSB | The AutoCAD dimension style to use for the generated lines. |

### Display & Script Control
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Disable Tsl | enum | No | If `Yes`, stops the script from generating dimensions without deleting the instance. |
| Instance description | text | "" | Additional text displayed next to the script name. |
| Show viewport outline | enum | No | If `Yes`, draws a rectangle around the viewport boundary. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Stores the current element handle. The script will stop dimensioning this element and show a red "Active filter" label. |
| Remove filter for this element | Clears the filter for the specific element, resuming dimensioning. |
| Remove filter for all elements | Clears all stored filters, resetting the script for all instances. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: This script allows you to create and save complex filter definitions that can be referenced in the `Filter definition for beams` property.

## Tips
- **Verify Beam Codes:** Ensure the `Beamcode` properties in the script match the codes assigned to your beams in the model. If dimensions do not appear, check these codes first.
- **Use PS Units:** For consistent drawing appearance, set `Use PS units` to "Yes". This ensures the dimension offset stays constant on the printed drawing regardless of the viewport zoom level.
- **Filtering:** If you only want to dimension a specific section of a large roof, use the `Filter zones` or `Filter definition` properties rather than changing the global beam codes.
- **Visual Feedback:** If the script label appears in Red, a filter is actively blocking dimensioning for that element. If it appears in Orange, a filter is active on a different element.

## FAQ
- **Q: I inserted the script, but no dimensions are showing up.**
  **A:** Check your Properties Palette. Ensure `Disable Tsl` is set to "No" and that the `Beamcode` properties (Rafter/Trimmer/Hip) exactly match the codes used in your 3D model.
- **Q: How do I move the dimension line further away from the beams?**
  **A:** Increase the `Dim line offset` value. If you want the offset to stay visually consistent when you zoom in/out, change `Use PS units` to "Yes".
- **Q: Can I dimension the distance between the Hip and the Rafter instead of the rafters themselves?**
  **A:** Yes. Change the `Dimension object` property to "Hip" and ensure the `Beamcode hip` is correctly identified.
- **Q: What does the "Active filter" label mean?**
  **A:** It means you have used the right-click menu option "Filter this element". The script is paused for that specific element. Right-click the script instance and select "Remove filter for this element" to resume.