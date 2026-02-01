# HSB_E-EdgeDetails.mcr

## Overview
This script automates the creation of cross-section details for hsbCAD Roof Elements directly in Paper Space. It visualizes the element's profile and automatically generates detailed section views for every roof edge associated with a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script must be run in a Layout tab. |
| Paper Space | Yes | This is the primary environment for the script. |
| Shop Drawing | No | It functions as a detailing utility in Paper Space. |

## Prerequisites
- A layout tab (Paper Space) containing at least one viewport.
- A viewport that is currently linked to a valid hsbCAD Roof Element (`ElementRoof`).
- The hsbCAD Roof Element must contain valid geometry (beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_E-EdgeDetails.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in Paper Space that displays the Roof Element you wish to detail.
```

### Step 3: Automatic Generation
Once the viewport is selected, the script will automatically:
1. Draw a red outline indicating the Element's Brutto profile.
2. Draw a green outline indicating the Element's Envelope.
3. Draw blue lines representing the Roof Edges.
4. Generate cross-section detail views for each edge, showing the intersected beam geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *N/A* | *N/A* | *N/A* | This script does not expose any user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *N/A* | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Updating Details**: If you modify the Roof Element in Model Space (e.g., change beam sizes or pitches), return to Paper Space and run a recalculation (or reopen the drawing) to update the edge details automatically.
- **Selecting the Correct Viewport**: Ensure you select a viewport that actually displays a Roof Element. If the script cannot find valid roof data, it will erase itself silently.
- **Detail Size**: The size of the cross-section detail views is fixed by the script code. If you need larger or smaller detail views, this must be adjusted by a script administrator in the code variable `detail_size`.

## FAQ
- **Q: Why did the script disappear immediately after I selected a viewport?**
- **A:** The selected viewport likely does not contain a valid hsbCAD Roof Element, or the element data is missing. The script automatically erases itself if it cannot find valid data to process.
  
- **Q: How do I change which roof is detailed after the script is already inserted?**
- **A:** Currently, you cannot dynamically switch the viewport link after insertion. You must erase the script instance and re-insert it, selecting the correct viewport.
  
- **Q: Can I move the generated detail views?**
- **A:** Yes, once the script generates the geometry in Paper Space, the lines and polylines are standard CAD objects and can be moved or copied using standard AutoCAD commands. However, they will not update dynamically if moved; updates are based on the original insertion logic.