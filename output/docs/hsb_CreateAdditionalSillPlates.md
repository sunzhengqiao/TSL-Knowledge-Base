# hsb_CreateAdditionalSillPlates.mcr

## Overview
This script adds extra sill plates beneath existing window or door sills in timber frame walls. It automatically adjusts the height of jack studs to accommodate the new stack of sills.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model environment. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This script modifies the physical model, not drawing views. |

## Prerequisites
- **Required Entities**: Wall Elements (ElementWallSF) containing openings (windows/doors) with existing sill and bottom plate structures.
- **Minimum Beam Count**: 0 (The script scans existing elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateAdditionalSillPlates.mcr`

### Step 2: Configure Properties (Optional)
Action: Before selecting elements, you can adjust the "Number of sills to create" in the Properties Palette (usually accessed by pressing `Ctrl`+`1` if the script is active).

### Step 3: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the Wall Elements containing the openings you wish to modify. Press Enter to confirm selection.
```

### Step 4: Processing
Action: The script automatically analyzes the selected walls, identifies openings with sufficient vertical space, copies the bottom sill, stacks the new sills downwards, and stretches the jack studs to reach the new height. The script instance will then remove itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of sills to create | number | 1 | Enter the quantity of additional sill plates to stack vertically beneath the existing bottom sill. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and selection; there are no custom right-click context menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Space Check**: The script checks the vertical gap between the existing sill and the bottom plate. If the gap is too small for the requested number of sills, no changes will be made to that specific opening.
- **Jack Studs**: You do not need to manually trim the jack studs; the script automatically stretches them down to the bottom of the new sill stack.
- **Run-Once**: This script is designed to run once and then deletes itself from the project tree to avoid clutter.

## FAQ
- **Q: Why didn't the script add sills to my opening?**
  **A:** The vertical distance between your current sill and the bottom plate might be too small to fit the requested number of additional sills. Try reducing the "Number of sills to create" property.
- **Q: Does this work on all wall types?**
  **A:** This script is designed specifically for ElementWallSF (Stick Frame) entities that contain generated beams.
- **Q: What happens to the original sill?**
  **A:** The original sill remains in place. The script copies it and places the new copies underneath it.