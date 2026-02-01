# HSB-Production details (MS)

## Overview
Inserts 3D production detail markers (tags) onto timber elements to identify specific section locations. This script links 3D model elements to external detail drawings using customizable naming conventions and supports both batch automatic placement and precise manual placement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates geometry in 3D model space on Element Zones. |
| Paper Space | No | Not intended for layout or paper space usage. |
| Shop Drawing | No | Used in the model to prepare data for drawings, not directly on drawing sheets. |

## Prerequisites
- **Required Entities**: Element (Wall, Floor, Roof).
- **Minimum Beams**: None (Operates on Elements).
- **Required Settings**: Dimension Styles (Default: `_DimStyles` must exist in drawing).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB-Production details (MS).mcr`.

### Step 2: Configure Properties (Dialog)
Upon insertion, a dynamic dialog appears (unless run from a specific catalog preset):
- **Detail Name**: Enter the unique ID (e.g., "A", "1").
- **Detail Prefix**: Enter the file prefix (e.g., "Det"). The final linked filename will be "Prefix + Name" (e.g., "DetA").
- **Auto Insert**: 
  - **Yes**: Automatically places markers on all detected corners/edges of selected elements.
  - **No**: Allows manual placement of a single marker.
- Set other properties like Size, Depth, and Colors as needed.
- Click **OK** or **Insert**.

### Step 3: Select Geometry
The command line prompt depends on the "Auto Insert" setting chosen in Step 2.

**Scenario A: Auto Insert Mode (Batch)**
```
Command Line: Select element(s)
Action: Click one or multiple Elements in the model.
Result: The script automatically scans the selected elements and inserts detail markers at calculated locations (corners, openings). The master instance is then erased.
```

**Scenario B: Manual Insert Mode (Single)**
```
Command Line: Select an element
Action: Click on the specific Element you want to tag.

Command Line: Select an insertion point
Action: Click on the face/profile of the selected element where you want the detail marker to appear.
Result: A single detail marker is placed at the picked location, aligned with the nearest element edge.
```

## Properties Panel Parameters

These properties can be edited via the AutoCAD Properties Palette (Ctrl+1) after insertion.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Detail name | String | A | The unique identifier displayed on the marker (e.g., 'A', '01'). |
| Detail filename prefix | String | (Empty) | Prefix added to the name to create the target drawing filename (e.g., Prefix 'Detail_' + Name 'A' links to file 'Detail_A'). |
| Detail description | String | (Empty) | Secondary text label displayed below the main name. |
| Size | Double | 500 mm | The graphical size (height/width) of the detail marker box. |
| Depth | Double | 500 mm | Metadata defining the depth of the section cut for downstream detailing. |
| Text offset | Double | 0 mm | Distance between the marker and the text. If set to 0, it defaults to 40% of the Size. |
| Dimension style | String | _DimStyles | The text style used for the labels. |
| Line color | Integer | 1 (Red) | CAD color index for the marker box/lines. |
| Text color | Integer | 7 (White) | CAD color index for the text labels. |
| Draw section line | String | Yes | Toggles visibility of the graphical section box (No = hides box, keeps text). |
| Apply details to | String | Zone 0 | The Element Zone (sub-layer) where the graphics are drawn. |
| Zone character | String | I | The layer type character (e.g., 'I' for Information) used to generate the layer name. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Toggle opening detail | Switches the logic flag indicating if the marker is associated with an opening or the main element outline. This may affect text positioning or visibility logic. |

## Settings Files
- **Dimension Styles**: Standard AutoCAD/hsbCAD dimension styles (defined by `sDimStyle`).
- **Purpose**: Controls font, height, and appearance of the detail text labels.

## Tips
- **Batch Processing**: Use "Auto Insert" mode to quickly tag all corners and openings of a complex wall frame.
- **Automatic Scaling**: Leave "Text offset" set to `0` to let the script automatically scale the text distance based on the "Size" parameter.
- **File Linking**: Ensure your "Prefix" and "Detail name" combine exactly to match your external drawing filenames (e.g., DWG or PDF files).
- **Grip Editing**: Select the marker and use the grip to move it to a different location on the element face.

## FAQ
- **Q: My detail markers disappeared, but the text is still there.**
- **A:** Check the "Draw section line" property in the Properties Palette. It might be set to "No".
- **Q: How do I link this to a specific drawing file?**
- **A:** Use the "Detail filename prefix" and "Detail name" properties. If your drawing is `Section_05.dwg`, set Prefix to `Section_` and Name to `05`.
- **Q: Can I tag multiple elements at once?**
- **A:** Yes. Enable "Auto insert" in the initial dialog or properties, then run the script and select multiple elements when prompted.
- **Q: The text is too small to read.**
- **A:** Increase the "Size" parameter, or change the "Dimension style" to a style with larger text height settings.