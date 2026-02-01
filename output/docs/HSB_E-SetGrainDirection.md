# HSB_E-SetGrainDirection.mcr

## Overview
This script assigns a grain direction property to sheet materials (such as CLT or plywood) based on their alignment to elements or local axes. It also provides an option to flip the sheet's Z-axis orientation to match the element's view direction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements and sheets. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Not designed for manufacturing drawings directly. |

## Prerequisites
- **Required Entities**: Elements (e.g., walls, floors) or individual Sheets.
- **Minimum Beam Count**: 0.
- **Required Settings**: Access to the `HSB_G-FilterGenBeams` catalog to use filtering options.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-SetGrainDirection.mcr` from the list.

### Step 2: Select Elements or Switch to Sheet Selection
```
Command Line: Select one or more elements <Right click to select sheets>
Action: 
- Click on one or more Elements in the model if you want to process all sheets within them.
- OR Right-click immediately if you prefer to select specific individual sheets.
```

### Step 3: Select Sheets (If applicable)
```
Command Line: Select sheets
Action: Click on the specific sheets you wish to modify. Press Enter or Right-click to confirm selection.
```

### Step 4: Configure Properties
After selection, the script inserts an instance. Open the **Properties Palette** (Ctrl+1) to configure the grain direction and alignment settings for the selected sheets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter definition sheets** | dropdown | (Empty) | Select a preset filter to determine which specific sheets within the element are processed. This relies on entries from the `HSB_G-FilterGenBeams` catalog. |
| **Align grain direction** | dropdown | None | Determines the vector used for the grain direction. Options include alignment with the Element's X or Y axis, or the Sheet's local X or Y axis. |
| **Set Z axis from Element** | dropdown | No | If set to "Yes", the sheet geometry is recreated so its Z-axis (normal vector) aligns with the Element's Z-axis (view side). |

## Right-Click Menu Options
No specific custom context menu options are defined for this script. Standard hsbCAD update options apply.

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams` (Catalog)
- **Location**: hsbCAD Company or Installation path
- **Purpose**: Provides the list of filter definitions available in the "Filter definition sheets" property, allowing users to target specific sheet types or layers.

## Tips
- **Element vs. Sheet Alignment**: Use "Element X/Y" if the grain direction depends on the main wall or floor axis. Use "Sheet X/Y" if it depends on the specific rotation of the sheet panel itself.
- **Flipping Sheets**: The "Set Z axis from Element" option is useful for ensuring machining sides or textures face the correct way relative to the element definition. Note that this physically recreates the sheet entity, which may affect handles or linked data.

## FAQ
- **Q: Can I run this on a single sheet without selecting the whole wall?**
  **A:** Yes. During the insertion prompts, Right-click to skip element selection, and then manually pick the specific sheets you want to modify.

- **Q: What does the "None" option do for grain direction?**
  **A:** It leaves the grain direction property unset or unchanged, effectively skipping that specific update logic while still processing other settings like the Z-axis.