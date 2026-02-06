# sdMS_ShopDrawDetailView.mcr

## Overview
This script generates projected 2D detail views (Plan, Section, or Elevation) from a Multipage Shopdrawing or ViewGenerator entity in Paper Space. It allows you to create specific "blow-up" views with custom scales, tags, and boundary styling for detailed documentation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space (Layout) only. |
| Paper Space | Yes | This is the primary environment for inserting and editing this script. |
| Shop Drawing | Yes | Specifically requires a Multipage Shopdrawing or ViewGenerator element. |

## Prerequisites
- **Required Entities**: An existing Multipage Shopdrawing or ViewGenerator TSL already inserted in the drawing.
- **Minimum Beam Count**: 0 (Operates on existing drawing entities).
- **Required Settings**: None (Uses default internal settings if not specified).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or insert tool) → Select `sdMS_ShopDrawDetailView.mcr`.

### Step 2: Select Source Entity
```
Command Line: Select Multipage Shopdrawing or ViewGenerator TSL
Action: Click on the Shopdrawing or ViewGenerator element in the Model or Layout you wish to detail.
```

### Step 3: Define Source Boundary
```
Command Line: Select first defining point
Action: Click the first corner (or center for circles) of the area you want to detail.

Command Line: Select 2nd defining point
Action: Click to define the length or radius of the detail area.

Command Line: Select 3rd point or return
Action: Click a third point to define width/depth (for rectangles), or press Enter to accept default/square dimensions.
```

### Step 4: Place Detail View
```
Command Line: Select location for generated linework
Action: Click in the Paper Space layout where you want the detail view to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Mode** | | | |
| Type | dropdown | Rectangle Plan | Selects the view projection: "Rectangle Plan" (Top-down), "Sect/Elev Cut" (Vertical slice), or "Circle Plan" (Circular top-down). |
| Flipped Reverse View | dropdown | No | Mirrors the generated detail view 180 degrees. Useful for showing the reverse side of a connection. |
| Detail Level | dropdown | High | "High" draws outlines for every beam; "Low (Outline)" merges them into a single silhouette. |
| Scale | number | 1 | Sets the scale factor for the detail view (e.g., enter 10 for 1:10 scale). |
| Color | number | 4 | Sets the AutoCAD color index for visible lines in the detail. |
| **Hidden Linework** | | | |
| Color | number | 7 | Sets the color for hidden lines (geometry behind the cut plane). |
| Linetype | dropdown | [Empty] | Sets the linetype (e.g., Hidden) for hidden lines. |
| Linetype Scale | number | -1 | Adjusts the scale of the hidden linetype pattern (-1 uses system default). |
| **Title** | | | |
| Title | text | Enter Title | The descriptive text label (e.g., "Ridge Connection"). |
| Color | number | 6 | Sets the color of the title text. |
| Text Height | number | 15 | Sets the height of the title text in millimeters. |
| **Tag** | | | |
| Tag | text | A | The identifier code for the detail bubble (e.g., "A", "B1"). |
| Color | number | 6 | Sets the color of the tag text. |
| Text Height | number | 20 | Sets the height of the tag text in millimeters. |
| **General Linework** | | | |
| Cut-Line Color | number | 1 | Sets the color of the source boundary/cut line in the model. |
| Section Vertical Offset | number | 0 | Moves the section cut plane up or down. Only applies to Section/Elev mode. |
| Draw Connector | dropdown | No | If "Yes", draws a leader line connecting the source area to the detail view. |
| Draw Border | dropdown | No | If "Yes", draws a border around the generated detail view. |
| Border Color | number | 0 | Sets the color of the detail border. |
| Border Padding | number | 0 | Sets the clearance distance between the linework and the border. |
| Arrow Length | number | 60 | Sets the length of cut line arrows (Section/Elev mode). |
| Arrowhead Scale | number | 30 | Sets the size of the arrowheads. |

## Right-Click Menu Options
No specific custom context menu items are defined by this script. Modifications are handled via the Properties Palette (OPM) and direct grip editing.

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Resizing:** Use the **Grips** on the source boundary (in Model/Layout) to resize the detail area dynamically. The view will update automatically.
- **Relocating:** Drag the **View Location Grip** (where the detail is placed) to move the generated 2D view around your sheet without changing the source area.
- **Section Mode:** When using "Sect/Elev Cut", ensure you define the cut line direction carefully. The script automatically keeps the depth vector orthogonal to the cut line.
- **Performance:** Use "Low (Outline)" detail level for large assemblies to simplify the drawing and improve regeneration speed.

## FAQ
- **Q: How do I change the scale of the detail after inserting it?**
  A: Select the script entity, open the Properties Palette, and change the "Scale" value.
- **Q: Can I switch from a Plan view to a Section view later?**
  A: Yes, change the "Type" property in the Properties Palette from "Rectangle Plan" to "Sect/Elev Cut" (or vice versa).
- **Q: Why is my detail view blank?**
  A: Ensure the "Source Boundary" (defined in steps 3) actually intersects with 3D model geometry. You may need to move the source grips to encompass the timber elements.
- **Q: What does "Flipped Reverse View" do?**
  A: It mirrors the output. If you are drawing a section cut looking North, enabling this will make it look as if you are looking South, which can be useful for aligning details on a drawing sheet.