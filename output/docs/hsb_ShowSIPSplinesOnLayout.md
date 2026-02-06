# hsb_ShowSIPSplinesOnLayout

## Overview
This script automates the labeling of structural members (such as splines or studs) on a 2D layout. It projects the names of specific beams found in a Viewport onto the Paper Space, creating clear annotations for shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for 2D Layouts. |
| Paper Space | Yes | The script must be run on a Layout tab containing a Viewport. |
| Shop Drawing | Yes | Designed for annotating production drawings. |

## Prerequisites
- **Required Entities**: A Layout Viewport that is linked to a valid hsbCAD Element.
- **Minimum Beams**: The Element within the Viewport must contain at least one beam.
- **Required Settings**: None (Standard AutoCAD Dimension Styles are recommended).

## Usage Steps

### Step 1: Launch Script
1. Open the target Layout tab in AutoCAD.
2. Type `TSLINSERT` in the command line.
3. Select `hsb_ShowSIPSplinesOnLayout.mcr` from the file list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the Viewport displaying the Element you wish to annotate.
```
*Note: If you cancel or select an invalid viewport, the script instance will automatically delete itself.*

### Step 3: Configure Properties
1. After selecting the viewport, the script instance is created.
2. Select the script instance (it may appear as a small cross or marker near the viewport).
3. Open the **Properties Palette** (Ctrl+1).
4. Adjust the **Dim Style** and **Offset From Element** as needed (see Parameters below).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | Text | "" | Select a Dimension Style name from the drawing to control the font, size, and layer of the text labels. |
| Offset From Element | Number | 50 | The distance (in mm) to shift the label away from the beam's center line. Increase this value if labels overlap the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click menu. Updates happen automatically via the Properties Palette. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Avoid Overlap**: If labels are crossing over beams or other text, increase the "Offset From Element" value in the Properties Palette.
- **Consistent Styling**: Ensure your chosen "Dim Style" uses a text height appropriate for your plot scale.
- **Filtered Beams**: The script specifically labels beams that are perpendicular to the Element's local X-axis. Beams running parallel to the main direction will be ignored.
- **Small Elements**: Very small beams or filler pieces (with a projection area less than 4mm²) are automatically ignored to keep the drawing clean.

## FAQ
- **Q: Why did the script disappear immediately after I selected the viewport?**
  **A:** This happens if the selected Viewport is not linked to a valid hsbCAD Element or if the Element contains no valid data. Ensure you select a viewport showing a 3D model.
- **Q: Why are some beams not showing labels?**
  **A:** The script only labels beams perpendicular to the Element's X-axis and ignores beams smaller than 4mm² in area.
- **Q: How do I update the labels if I change the 3D model?**
  **A:** The script listens for model updates. If you modify the beams in the Element, save or refresh the drawing, and the labels will recalculate automatically. You can also manually trigger an update by changing the "Offset From Element" value.