# HSB_R-OptimizeBattens.mcr

## Overview
This script optimizes counter battens (Zone 4 sheets) by straightening their axis alignment, squaring off the ends to be perpendicular, and cutting them to standardized lengths to minimize material waste and simplify assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs explicitly in 3D Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required entities**: Elements (walls or roofs) that contain Zone 4 sheet elements (e.g., counter battens or sub-purlins).
- **Minimum beam count**: N/A (Requires Elements, not specific beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-OptimizeBattens.mcr` from the file dialog or ToolPalette.

### Step 2: Configure Properties
Before selecting elements, you can adjust the optimization settings.
- If executed from the ToolPalette, the properties may default to the last used values.
- You can select the script instance (if visible) or use the AutoCAD Properties Palette to change settings like orientation, squaring, and target lengths before proceeding to selection.

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Elements (Roofs or Walls) in the model that contain the battens you wish to optimize. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically process the selected elements. It will modify the geometry of the battens and then delete itself from the model upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Oriëntation** (Group Header) | Text | - | Visual separator for orientation settings. |
| Correct orientation | Dropdown | No | If Yes, aligns the batten axis to the straightest possible line based on its longest edge. |
| **Square off** (Group Header) | Text | - | Visual separator for squaring settings. |
| Make battens squared | Dropdown | No | If Yes, cuts the ends of the battens perpendicular (90°) to their axis. |
| **Optimize length** (Group Header) | Text | - | Visual separator for length optimization settings. |
| Optimize length | Dropdown | Yes | If Yes, cuts long battens into multiple pieces of the target optimized length. |
| Optimized length | Number | 10000 mm | The target length for the cut pieces (e.g., 10000 mm). |
| Gap | Number | 0 mm | The gap between cut pieces (e.g., for saw blade kerf or spacing). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files.

## Tips
- **Self-Deleting Script**: The script instance erases itself after running. If you need to change the optimization settings (e.g., different lengths or squaring), you must run the script again on the elements; you cannot simply edit the properties of an old script instance.
- **Roof Planes**: The script automatically detects and skips RoofPlane elements. It is intended for standard wall or roof elements containing battens.
- **Kerf Allowance**: Remember to set the `Gap` parameter if you need to account for saw blade thickness when cutting the optimized lengths.
- **Straightening**: Use "Correct orientation" if your generated battens are slightly skewed along a complex roof slope and you need them perfectly straight for fabrication.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: This is normal behavior. The script is designed as a "one-time" operation. It modifies the batten geometry, applies the changes, and then removes itself to keep the drawing clean.
  
- **Q: Can I undo the changes?**
  A: Yes, you can use the standard AutoCAD `UNDO` command to revert the geometry changes if the script result is not as expected.

- **Q: The script didn't modify my battens. Why?**
  A: Ensure the selected elements actually have "Zone 4" Sheets assigned to them. Also, verify that the `Optimize length` is set to a value smaller than the current batten length, or that `Correct orientation`/`Make battens squared` are set to "Yes" if those modifications are needed.