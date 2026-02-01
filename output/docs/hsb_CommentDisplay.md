# hsb_CommentDisplay.mcr

## Overview
This script visualizes and manages annotation comments attached to timber elements in the 3D model. It reads comment data from element metadata to display text, leader lines, and area markers, providing tools to edit geometry, adjust styles, and organize comments by zone.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for viewing and editing 3D element comments. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Element (e.g., Walls, Beams) that already contain comment metadata (key `Hsb_Comment`).
- **Minimum beam count**: 0 (Requires selection of at least one Element).
- **Required settings**: Elements must have existing comment data stored in their ModelMap/Comment properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CommentDisplay.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the timber elements (walls/beams) that contain the comments you wish to visualize or manage.
```
*Note: Upon selection, the script will scan the elements. If comments exist, a display instance is created for each comment, and the master script instance will automatically erase itself.*

### Step 3: Edit Comment Geometry (Optional)
```
Action: Select a displayed comment in the model.
Right-Click Menu: Select "Edit comment"
Command Line: Specify next point or [Undo/cOnfirm/eXit]:
Action:
 - Click to add points to the leader line.
 - Type "U" to undo the last point.
 - Hover over the text and type "C" (cOnfirm) or "X" (eXit) to finish editing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Comment style** | | | |
| Colour | Number | 1 | Sets the color of the comment text and leader lines (AutoCAD Color Index 1-255). |
| Text height | Number | 50.0 | Sets the physical height of the comment text in the model (mm). |
| Leader Size | Number | 1.0 | Scale multiplier for the leader line arrow/segment length. |
| **Position & Orientation** | | | |
| Horizontal offset | Number | 0.0 | Moves the text along the element's length (local X-axis). |
| Vertical offset | Number | 0.0 | Moves the text along the element's width/height (local Y-axis). |
| Text orientation | Dropdown | Unchanged | Controls text rotation: Unchanged, Default (Element X), Horizontal, Vertical, or Perpendicular. |
| **Area profile** | | | |
| Active grippoints | Dropdown | Edge | Determines if resizing handles appear on Edge midpoints or Corners (for Area comments). |
| Draw area filled | Dropdown | No | If "Yes", draws a solid background fill for area comments. |
| Transparency | Number | 50 | Sets opacity of the area fill (0 = Transparent, 100 = Opaque). |
| **Assignment** | | | |
| Zone | Dropdown | 0 | Assigns the comment to a logical zone (-5 to 5) for organization or filtering. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Copy comment to Element(s) | Copies the specific selected comment to other selected elements. |
| Copy all comments to Element(s) | Copies all comments from the source element to other selected elements. |
| Edit comment | Enters an interactive mode to add, remove, or modify points in the comment leader line. |
| Erase comment from Element | Removes the specific comment from the element and deletes the display instance. |

## Settings Files
- **Filename**: None (External XML)
- **Location**: N/A
- **Purpose**: This script relies entirely on **Element Metadata** (`Hsb_Comment` key) for configuration. No external settings file is required; properties are managed via the Properties Palette (OPM).

## Tips
- **Moving Text**: You can drag the text grip (the square handle on the text) in the model. The script will automatically calculate and update the "Horizontal offset" and "Vertical offset" properties in the palette.
- **Zone Filtering**: Use the "Zone" property to group comments (e.g., "Zone 1" for framing, "Zone 2" for finishing). This is useful for generating filtered reports or lists later.
- **Editing Leaders**: While in "Edit comment" mode, you can hover over the text anchor point and type `cOnfirm` to finish the shape without adding extra points.
- **Visibility**: If an element has comment data but nothing displays, check if the "Visualisation" mode in the element's metadata is set to "None".

## FAQ
- **Q: Why did the script disappear immediately after I selected the elements?**
- **A: This is normal behavior. The script acts as a generator; it reads the element data, spawns the visual comment instances, and then erases the "master" script instance to leave only the annotations behind.
  
- **Q: How do I create a new comment on an element?**
- **A: This script *displays* existing comments. To create new comments, you typically need to use the data entry tools (like hsbCAD's Comment input commands or catalog tools) that write the `Hsb_Comment` metadata to the element first. Once the data exists, run this script to see it.

- **Q: What is the difference between "Default" and "Horizontal" text orientation?**
- **A: "Default" aligns the text relative to the element's local X-axis (e.g., along the length of a beam). "Horizontal" aligns the text to the World coordinate system, keeping it flat regardless of the beam's rotation.