# hsbDefineShopdrawShowSetMetalpart.mcr

## Overview
Automates the visibility of metal parts and connected tools in shop drawings. It filters the 'Show Set' so that only metal parts and detailing scripts associated with specific assembly beams are displayed in the selected views, reducing clutter in the final drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for layout and drawing generation. |
| Paper Space | Yes | Must be inserted in the layout environment to link to ShopDrawViews. |
| Shop Drawing | Yes | Automatically executes during shop drawing generation events. |

## Prerequisites
- **Required Entities**: ShopDrawViews, GenBeams (Assemblies), Metal Parts, or TSL Instances.
- **Minimum Beam Count**: 0 (The script allows selection of views directly if no beams are selected).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDefineShopdrawShowSetMetalpart.mcr`

### Step 2: Select Definition Method
```
Command Line: Select a set of dummy beams with tools which define the link to the assembly | <Enter> to select shopdraw views
Action: 
    - Option A: Select one or more dummy beams in the drawing that are linked to the tools/metal parts you want to control.
    - Option B: Press Enter to skip beam selection and directly select views.
```

### Step 3: Select Views (If Option B was chosen)
```
Command Line: Select a set of shopdraw views
Action: Click on the ShopDrawView entities (viewports) where you want to apply the visibility filtering.
```

### Step 4: Place Script
```
Command Line: [Point Location]
Action: Click in the Paper Space to define the insertion point for the script label.
```
*Result: Visual lines and text will appear connecting the script insertion point to the selected views or beams.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Number | 132 | Controls the color of the visual connecting lines and label text drawn in Paper Space (1-255). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ShopDrawViewDataShowSet | Manually triggers the calculation to update which metal parts and tools are visible in the linked shop drawing views. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files. It uses internal mapping logic during generation.

## Tips
- **Visual Verification**: After insertion, check the connecting lines drawn by the script to ensure you have linked the correct views to the correct assemblies.
- **Mode 1 (Dummy Beams)**: Use this mode if you have specific dummy beams set up to represent different logical groups of metal parts.
- **Mode 0 (Views)**: Use this mode for general control by selecting the viewports directly.
- **Updating Visibility**: If you change the model (add/remove metal parts), simply right-click the script and select **ShopDrawViewDataShowSet** to refresh the view settings without re-inserting.
- **Color Coding**: Use the **Color** property in the Properties Palette to organize multiple scripts in the same layout (e.g., different colors for different wall types).

## FAQ
- **Q: Why did the script disappear immediately after I placed it?**
  **A:** You likely pressed Enter without selecting beams, and then pressed Enter again without selecting any ShopDrawViews. The script erases itself if no links are created.
- **Q: Does the "Color" parameter change the color of the metal parts in the final plot?**
  **A:** No. The Color parameter only changes the color of the visual guide lines in Paper Space to help you organize your drawings.
- **Q: What happens if the linked GenBeam is deleted?**
  **A:** The script will report an error "define set entity is not a genbeam" during generation and fail to filter that specific view. Ensure the assembly (GenBeam) referenced exists in the model.