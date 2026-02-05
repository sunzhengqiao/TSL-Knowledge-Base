# HSB_G-ProductionDetails

## Overview
Automates the layout of production detail views (such as sections and joints) from a 3D model onto a 2D drawing sheet. It arranges these details in a customizable grid format in Paper Space, saving manual drawing time.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Paper Space only. |
| Paper Space | Yes | Requires an existing viewport linked to an Element. |
| Shop Drawing | Yes | Used to create overview sheets of manufacturing details. |

## Prerequisites
- **Required entities**: A Viewport in Paper Space that is linked to a valid hsbCAD Element.
- **Minimum beam count**: 0 (Depends entirely on the Element selected).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-ProductionDetails.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on a viewport in Paper Space that displays the model element you wish to detail.
```

### Step 3: Set Insertion Point
```
Command Line: Select a point for first detail
Action: Click in Paper Space to set the top-left (origin) point for the detail grid.
```

### Step 4: Configure Properties
```
Action: The Properties Palette will open. Adjust filters, grid spacing, and visual styles as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter** | | | |
| Show only those details | text | | Semicolon-separated list of detail names to include (e.g., "Wall;Floor"). Leaves empty to show all. |
| Hide those details | text | | Semicolon-separated list of detail names to exclude. |
| Filter beams with beamcode for section | text | | Semicolon-separated list of Beam Codes. Only sections on beams matching these codes will be generated. |
| **Layout Matrix** | | | |
| Number of columns | integer | 3 | Number of detail columns across the page. |
| Number of rows | integer | 3 | Number of detail rows down the page. |
| Distance to next detail (horizontal) | double | 100 | Horizontal spacing (mm) between detail bounding boxes. |
| Distance to next detail (vertical) | double | 100 | Vertical spacing (mm) between detail bounding boxes. |
| Distance to next viewport (horizontal) | double | 10 | Internal horizontal padding (mm) around the detail geometry. |
| Distance to next viewport (vertical) | double | 10 | Internal vertical padding (mm) around the detail geometry. |
| **Style** | | | |
| Representation type | dropdown | As drawn | Determines how details are drawn: "As drawn" (live geometry) or "As block" (inserts a predefined CAD block). |
| Prefix blockname | text | Detail- | Prefix used when constructing block names for the "As block" representation. |
| Horizontal alignment block | dropdown | Left | Horizontal alignment of the detail content within its frame (Left, Center, Right). |
| Vertical alignment block | dropdown | Bottom | Vertical alignment of the detail content within its frame (Bottom, Center, Top). |
| Scale | double | 1 | Scale factor for the generated details. |
| Dimension style | dropdown | | Dimension style to use for the details. |
| Dimension style position number | dropdown | | Dimension style specifically for position numbers. |
| Show position number | dropdown | Yes | Option to show or hide position numbers ("Yes" or "No"). |
| Viewport layer | text | Defpoints | Layer name for the created viewports. |
| Detailname layer | text | | Layer name for the detail labels/text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific context menu items. Use standard properties to edit. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Filtering**: Use the "Show only those details" field to create dedicated sheets for specific trades (e.g., only "Stairs" or only "Walls").
- **Overlap**: If text or dimensions overlap between details, increase the "Distance to next detail" properties.
- **Performance**: For complex models, using the "As block" representation type can significantly reduce drawing file size and regeneration time compared to "As drawn".
- **Beam Codes**: Use the "Filter beams with beamcode" to automatically generate sections only for specific structural members (like joists or posts) without manually filtering every detail.

## FAQ
- **Q: Why are no details appearing?**
- **A:** Check the "Number of columns/rows". If set too low, the grid might be full before finding relevant details. Also, verify that the selected Viewport is actually linked to an Element with TSL details attached.
- **Q: Can I change the order of the details?**
- **A:** The script processes details in alphabetical order. To reorder, you typically need to rename the details in the source model or adjust the Sort Order in the Element properties (depending on your hsbCAD version configuration).
- **Q: What is the difference between "Distance to next detail" and "Distance to next viewport"?**
- **A:** "Distance to next detail" controls the gap between the *frames* of different details. "Distance to next viewport" controls the padding *inside* the frame between the border and the actual drawing content.