# hsbPanelDrill.mcr

## Overview
This script creates cylindrical holes, through-drills, circular sinkholes (counterbores), or rectangular pockets (houses) in CLT and SIP panels. It is designed for creating MEP penetrations, bolt recesses, or connection detailing on timber wall or floor panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | This is a modeling tool, not a 2D detailing script. |

## Prerequisites
- **Required Entities**: Existing Sip (Structural Insulated Panel) or CLT elements in the drawing.
- **Minimum Selection**: At least one panel must be selected during insertion.
- **Required Settings**: Standard Dimension Styles (defined in the drawing) are used if labels are enabled.

## Usage Steps

### Step 1: Launch Script
Execute the command `TslInsert` (or click the assigned toolbar icon) and select `hsbPanelDrill.mcr` from the list.

### Step 2: Configure Parameters (Optional)
- **If inserting manually**: A dialog box may appear asking you to set the initial Diameter, Depth, and Sinkhole dimensions.
- **If inserting from a Catalog**: Parameters are pre-loaded based on the catalog entry selected.

### Step 3: Select Panel(s)
```
Command Line: Select panel(s)
Action: Click on the CLT or SIP panel(s) you wish to drill. Press Enter to confirm selection.
```

### Step 4: Select Insertion Point(s)
```
Command Line: Select point
Action: Click inside the selected panel to place the drill.
```
- You can click multiple points to insert multiple drills with the same settings.
- Press **Esc** or **Enter** to finish the command.

## Properties Panel Parameters

These parameters can be edited in the AutoCAD Properties palette (OPM) after selection.

### Drill Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Diameter | Number | 68 mm | The diameter of the main cylindrical hole. |
| (B) Depth | Number | 68 mm | The depth of the hole. Set to **0** for a through-drill (penetrates the entire panel thickness). |
| (C) Side | Dropdown | Bottom | The side of the panel from which the drill is measured (Top or Bottom). |

### Sinkhole / Pocket - Top Side
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (D) Diameter/dX | Number | 0 | Width (X) of the pocket or diameter of the counterbore on the Top. |
| (E) Depth | Number | 0 | Depth of the pocket/sink on the Top. |
| (F) Width | Number | 0 | Length (Y) of the pocket. **Value <= 0** creates a **Circle**. **Value > 0** creates a **Rectangle**. |
| (G) Rounding Type | Dropdown | not rounded | Defines corner geometry (Fillet/Relief) for rectangular pockets. |

### Sinkhole / Pocket - Bottom Side
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (H) Diameter/dX | Number | 0 | Width (X) of the pocket or diameter of the counterbore on the Bottom. |
| (I) Depth | Number | 0 | Depth of the pocket/sink on the Bottom. |
| (J) Width | Number | 0 | Length (Y) of the pocket. **Value <= 0** creates a **Circle**. **Value > 0** creates a **Rectangle**. |
| (K) Rounding Type | Dropdown | not rounded | Defines corner geometry (Fillet/Relief) for rectangular pockets. |

### Display
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (L) Description | Text | [Empty] | Custom text label to display next to the drill in the model. |
| (M) Dimension style | Dropdown | [Current] | The CAD dimension style used for the label text. |

## Right-Click Menu Options

Select the drill instance and right-click to access these options:

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the 'Side' property between Top and Bottom. (Can also be triggered by **Double-Clicking** the instance). |
| Add Panel | Adds newly selected panels to the existing drill instance (useful for drilling through stacked panels). |
| Add panel(s) exclusively | Replaces the currently linked panels with a new selection. If multiple drills are selected, applies the new panels to all of them. |
| Remove Panel | Removes a specific panel from the drill instance. (Only available if more than one panel is linked). |
| Draw Circles | Creates static 2D Polylines in the drawing representing the drill outlines (for annotation or export). |

## Settings Files
- **Filename**: None
- **Note**: This script relies on standard hsbCAD catalogs for parameter presets. It does not require a specific external XML settings file to function beyond standard installation files.

## Tips
- **Through Holes**: To drill completely through a panel, simply set the **Depth (B)** to `0`. The script will automatically calculate the required length based on panel thickness.
- **Rectangular Pockets**: To create a rectangular housing (e.g., for a steel plate), set the **Width (F or J)** to a value greater than 0.
- **Visual Selection**: When inserting, the insertion point must be inside the panel's "shadow" minus half the drill diameter. If the cursor doesn't snap or highlight, try moving closer to the center of the panel or reducing the drill diameter.
- **Grip Editing**: You can select the drill in the model and drag the circular grip to visually resize the diameter.

## FAQ
- **Q: How do I make a counterbore for a nut?**
  A: Set the main **Diameter (A)** for the bolt shaft, and set **Diameter (D or H)** and **Depth (E or I)** for the nut size. Ensure **Width (F/J)** remains 0 to keep it circular.
- **Q: Why did my drill disappear?**
  A: If the panel linked to the drill is deleted, or if the drill becomes unassociated, the script may automatically erase the instance to prevent errors. Re-insert the drill on the valid panel.
- **Q: Can I drill through multiple layers at once?**
  A: Yes. Use the **Add Panel** context menu option to select multiple panels, or select multiple panels during the initial insertion prompt.