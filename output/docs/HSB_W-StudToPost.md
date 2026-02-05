# HSB_W-StudToPost.mcr

## Overview
This script converts selected wall studs into structural posts with customizable dimensions and properties. It handles adjustments for width, height, positioning, and can automatically cut through top plates if required.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model geometry. |
| Paper Space | No | Not designed for 2D layout or drawing views. |
| Shop Drawing | No | Does not generate shop drawing views or labels. |

## Prerequisites
- **Required Entities**: Existing Beams (studs) in the model.
- **Minimum Beam Count**: At least 1 beam must be selected.
- **Required Settings**: No external settings files required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-StudToPost.mcr` from the list.

### Step 2: Configure Properties
The Properties Palette will open automatically upon launch.
Action: Adjust the parameters (Width, Height, Position, etc.) to your requirements before selecting beams.

### Step 3: Select Studs
```
Command Line: Select studs to convert
Action: Click on the studs you wish to convert into posts. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width post | Number | 105 | Sets the width of the posts. A positive value is required. |
| Height post | Number | 0 | Sets the height of the posts. If set to 0, the current height of the stud is maintained. |
| Post position | Dropdown | Front | Sets the alignment of the post relative to the structure (Front, Center, or Back). |
| Stretch above top plate | Dropdown | No | Specifies whether the post should stretch through and cut the top plate (Yes/No). |
| Beam type | Dropdown | *[Empty]* | Sets the beam type of the post from the available catalog types. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard hsbCAD Context) | This script typically runs as a "fire and forget" tool. Once executed, the script instance is erased. Right-click options apply primarily if the script is intercepted or if editing the resulting beams directly. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD catalogs for Beam Types and Materials; no specific external XML settings file is required.

## Tips
- **Maintaining Height**: To convert a stud to a post without changing its length, leave the `Height post` value set to 0.
- **Wall Integration**: If you select "Yes" for **Stretch above top plate**, ensure the studs are part of a valid wall element. The script will automatically identify and split the top plate to accommodate the post height.
- **Positioning**: Use the **Post position** property to quickly align the post flush with the outside (Front/Back) or center of the construction.

## FAQ
- **Q: Why did the script fail with an error?**
  **A:** Ensure you have entered a positive value greater than 0 for the `Width post` property. A width of 0 is not valid.
- **Q: Can I use this on a beam that is not part of a wall?**
  **A:** Yes. If the beam is standalone (not part of a wall element), the script will apply the width and height changes based on the beam's local coordinate system. The "Stretch above top plate" logic will only apply if the beam is within a recognized wall structure.