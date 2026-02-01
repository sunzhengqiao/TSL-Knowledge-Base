# HSB_E-DetailName

## Overview
This script places a detail marker (label or bubble) on timber elements in the 3D model. It allows you to tag specific locations with a detail name (e.g., "Detail 1"), control the graphical representation of the tag, and link it to external files for automated detailing workflows.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for use in layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: A single hsbCAD Element (Wall, Floor, or Roof).
- **Minimum Beams**: 1 (Element must exist).
- **Required Settings**: A valid Dimension Style (`_DimStyles` or similar) must exist in the drawing to determine default text appearance.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` and select `HSB_E-DetailName.mcr` from the list.

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the timber element (wall/floor) you wish to tag.
```

### Step 3: Select Base Position
```
Command Line: Select a position
Note: Points are projected to element, projection is done perpendicular to element XY plane
Action: Click near or on the element where you want the detail reference to be located. The point will snap to the element's surface plane.
```

### Step 4: Define Direction
```
Command Line: Select a point for the direction
Action: Click a second point to define the rotation/angle of the detail marker. This line acts as the local "X-axis" for the tag alignment.
```

## Properties Panel Parameters

### Detail Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | String | Empty | The primary identifier displayed in the model and used for data export (e.g., "1", "A"). |
| Description | String | Empty | Additional descriptive text stored in the element data (not currently drawn visually). |
| Size | Double | 500 | The physical width/height of the rectangular marker bubble in millimeters. |
| Depth | Double | 500 | Reserved parameter (currently does not affect geometry). |
| Detail filename prefix | String | Empty | Sets a file prefix. If set to "Det" and Name is "1", the system links to "Det1". |

### Position Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Detail position | Enum | On detail line | Constrains the anchor: **On detail line** (snaps to insertion line), **Element middle** (snaps to center of element), or **Free**. |
| Offset, perpendicular to detail | Double | 100 | Moves the marker along the local X-axis (perpendicular to the detail direction line). |
| Offset, along detail | Double | 500 | Moves the marker along the local Y-axis (parallel to the detail direction line). |
| Text Orientation | Enum | Aligned with detail | **Aligned** rotates text with the direction line; **Perpendicular** rotates it 90 degrees. |
| Readdirection | Enum | Top-Left | Ensures text is readable from a specific direction (e.g., Top-Left, Bottom-Right). Prevents upside-down text. |

### Text Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset X/Y | Double | 0 / 350 | Fine-tunes the text position relative to the marker center. |
| Text alignment X/Y | Enum | From text... / Above... | Sets the justification (Left/Center/Right or Top/Middle/Bottom) relative to the text position point. |
| Dimstyle Text | String | _DimStyles | Selects the Dimension Style to control font and arrow types. |
| Text Size | Double | -1 | Height of the text. Set to `-1` to use the DimStyle height; set >0 to override manually. |
| Color | Integer | 1 | CAD Color Index for the text label. |

### Visual Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Integer | 3 | CAD Color Index for the marker frame/line. |
| Show line | Enum | Yes | Toggles the visibility of the rectangular marker frame. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the detail marker instance. |
| Recalculate | Forces the script to redraw the geometry based on current element changes or property updates. |
| *(Standard Grip Edits)* | Clicking the square grip point (_Pt0) allows you to drag the marker to a new location. Behavior depends on the 'Detail position' property. |

## Settings Files
- **Dimension Styles**: Standard AutoCAD/hsbCAD Dimension Styles.
- **Location**: Current Drawing.
- **Purpose**: Controls the font, arrow style, and default text size (when `dTxtSize` is -1).

## Tips
- **File Linking**: Use the "Detail filename prefix" property to automatically associate the marker with specific drawing files (e.g., details or schedules).
- **Wall Length Changes**: If you expect the element (wall) to change length, set "Detail position" to **Element middle**. The marker will stay relatively centered as the wall resizes.
- **Text Readability**: If the text appears mirrored or upside down, change the "Readdirection" property to the cardinal direction (e.g., Top-Left) from which you are viewing the model.
- **Global Text Control**: Set `dTxtSize` to `-1` and manage all text heights via your selected `DimstyleText` to ensure consistency across the project.

## FAQ
- **Q: Why did my detail marker disappear?**
  - A: Check if the parent Element was deleted or if the `Show line` property is set to "No" and the Text color matches the background. The script also erases itself if it detects an invalid cycle count or invalid element geometry.

- **Q: Can I use this to tag beams?**
  - A: No, this script is designed for Elements (Walls/Floofs/Roofs). For beams, you would typically use a script prefixed with `HSB_B-`.

- **Q: How do I make the text always horizontal, regardless of the wall angle?**
  - A: Set "Text Orientation" as desired, and set "Readdirection" to **Keep horizontal**.