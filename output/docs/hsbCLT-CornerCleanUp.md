# hsbCLT-CornerCleanUp.mcr

## Overview
Automatically creates corner relief (dogbone) drills at concave corners of CLT panels. This ensures CNC router bits can cut internal corners without over-cutting the material.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Tooling is applied in the model environment. |

## Prerequisites
- **Required Entities**: `GenBeam` (CLT Panels).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` and select `hsbCLT-CornerCleanUp.mcr`.

### Step 2: Configure Properties
A dynamic dialog will appear upon insertion.
- **Insert Mode**: Select how you want to apply the cleanup (e.g., all openings, outer contour, or a single custom drill).
- **Diameter**: Set the drill diameter (typically matching your tool diameter).
- **Side**: Select "Reference" or "Opposite" (Mainly for "Custom Single drill" mode).
- **Depth**: Set the drill depth (0 defaults to through-cut).

Click **OK** to confirm.

### Step 3: Select Panels
Depending on the **Insert Mode** chosen in Step 2, the selection prompt varies:

- **If "All Openings", "Outer Contour", or "All" is selected**:
  ```
  Command Line: Select CLT panels
  Action: Select one or multiple CLT panels in the model and press Enter.
  ```

- **If "Opening", "Single drill", or "Custom Single drill" is selected**:
  ```
  Command Line: Select panel
  Action: Click on a single CLT panel to process.
  ```

### Step 4: Pick Location (If Required)
If you selected a single-panel mode, you must specify the location:

- **If "Opening" mode**:
  ```
  Command Line: Pick point inside opening
  Action: Click inside the specific opening you wish to clean up.
  ```

- **If "Single drill" or "Custom Single drill" mode**:
  ```
  Command Line: Pick point
  Action: Click near the specific corner vertex where you want the dogbone drill.
  ```

The script will automatically calculate the corner position and add the drill geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Mode | dropdown | - | Sets the scope of the operation: **All Openings** (all openings in selected panels), **Opening** (specific opening in one panel), **Outer Contour** (panel edges), **Single drill** (pick specific corner), **All** (entire panel), or **Custom Single drill** (advanced single drill with depth control). |
| Diameter | Number | 40 mm | The diameter of the relief drill. This should match or exceed your CNC tool diameter. |
| Side | dropdown | - | Defines which face the drill originates from. Options are **Reference** or **Opposite**. Used primarily in "Custom Single drill" mode to determine direction. |
| Depth | Number | 0 mm | The depth of the drill. A value of 0 (default) creates a through-hole. In "Custom Single drill" mode, this defines a blind hole depth. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Switches the drill direction between the Reference side and the Opposite side. This is particularly useful for "Custom Single drill" instances. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Default Diameter**: Ensure the diameter is set correctly for your machinery (e.g., 12mm, 16mm, 25mm, or 40mm) before running the script on multiple panels.
- **Custom Single Drill**: Use the "Custom Single drill" mode if you have complex intersections or existing cuts; this mode analyzes the resulting profile including other tooling.
- **Visualization**: The script draws a preview of the drill. If the script erases itself immediately, it usually means no valid concave corners were found at the picked location.

## FAQ
- **Q: The script deleted itself after I picked a point. Why?**
  **A**: This usually happens if the point you picked was not near a valid concave (internal) corner, or if the corner angle does not require cleanup. Try picking closer to the vertex.
  
- **Q: What is the difference between "Single drill" and "Custom Single drill"?**
  **A**: "Single drill" calculates based on the raw panel geometry. "Custom Single drill" calculates based on the panel geometry *plus* any existing cuts or tooling, and allows you to set a specific depth and side.

- **Q: How do I change the drill size after insertion?**
  **A**: Select the script instance in the model, open the **Properties** palette (Ctrl+1), and modify the **Diameter** value. The script will update automatically.