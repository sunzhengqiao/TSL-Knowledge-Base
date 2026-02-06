# SIP_Element_Dimensions_PS.mcr

## Overview
This script automatically generates detailed 2D dimension drawings for Structural Insulated Panel (SIP) elements directly in Paper Space. It calculates and labels overall dimensions, individual panel sizes, openings, and bevel angles based on a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Paper Space only. |
| Paper Space | Yes | Script must be inserted into a Layout tab. |
| Shop Drawing | N/A | This is a dimensioning tool for production layouts. |

## Prerequisites
- **Required Entities**: A Viewport in a Paper Space layout that is displaying a valid hsbCAD Element (containing SIPs).
- **Minimum Beam Count**: 0 (Works with SIP geometry).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `SIP_Element_Dimensions_PS.mcr`.

### Step 2: Pick Insertion Point
```
Command Line: Pick a point
Action: Click anywhere in the Paper Space layout where you want the script anchor to be located.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame that shows the Element/Model you wish to dimension.
```
*Note: Once the viewport is selected, the script will immediately generate the dimensions.*

## Properties Panel Parameters
Select the script instance in Paper Space and press `Ctrl+1` to open the Properties Palette and adjust these parameters.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dim Pressure Plate** | dropdown | Yes | Includes the bottom timber plate in the vertical overall dimension. |
| **Show Diagonal** | dropdown | Yes | Shows the diagonal length measurement of the element. |
| **Show Dim Description** | dropdown | Yes | Adds text labels (e.g., "Panel", "Opening") above dimension lines. |
| **Offset of the DimLines** | number | 1000 | Distance (mm) from the element to the first dimension line. |
| **Offset of the Text Description** | number | 100 | Vertical gap (mm) between the dimension line and the label text. |
| **Offset for Splay Angles** | number | 0 | Radial offset (mm) for edge labels/angles from the panel edge. |
| **Dimstyle** | dropdown | [Empty] | Select an AutoCAD Dimension Style to apply to the generated lines. |
| **Dim Panel Color** | number | 1 | AutoCAD Color Index (ACI) for panel dimensions. |
| **Dim Opening Color** | number | 2 | AutoCAD Color Index (ACI) for opening dimensions. |
| **Dim Element Color** | number | 0 | AutoCAD Color Index (ACI) for overall element dimensions. |
| **Text Color** | number | 3 | AutoCAD Color Index (ACI) for all text labels. |
| **Panel Text Height** | number | 20 | Text height for panel descriptions (mm). |
| **Splay Text Height** | number | 20 | Text height for bevel angle labels (mm). |
| **Show Text** | dropdown | Yes | Master toggle to hide/show all text labels. |
| **Display mode Delta** | dropdown | Parallel | Sets orientation of delta dimensions (Parallel, Perpendicular, or None). |
| **Display mode Chain** | dropdown | Parallel | Sets orientation of chain dimensions (Parallel, Perpendicular, or None). |

## Right-Click Menu Options
None defined. All interactions are handled via the Properties Palette.

## Settings Files
None required.

## Tips
- **Adjusting Scale**: If dimension lines overlap the drawing, increase the **Offset of the DimLines**. If they are too far away, decrease it.
- **Cleaning Up**: If the drawing looks too cluttered, set **Show Dim Description** to "No" to remove the text labels, or set **Show Diagonal** to "No".
- **Edge Labels**: If bevel angle text overlaps the panel geometry, increase the **Offset for Splay Angles** to push the labels outward.
- **Organization**: Use different **Dim Color** settings to visually separate Panel dimensions from Opening dimensions for easier reading.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  - A: The script will automatically erase itself if it detects an invalid viewport or if the viewport is not linked to an hsbCAD Element. Ensure you select a viewport with an active model.
- **Q: How do I exclude the bottom plate from the height dimension?**
  - A: Change the **Dim Pressure Plate** property to "No" in the Properties Palette.
- **Q: The text size is wrong for my plot scale.**
  - A: Adjust the **Panel Text Height** and **Splay Text Height** values in the Properties Palette. These are typically in model units (mm).