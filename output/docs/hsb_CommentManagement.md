# hsb_CommentManagement.mcr

## Overview
This script serves as a management tool for creating, editing, and organizing 3D annotations and comments attached to construction elements. It is typically used to add notes, markups, or quality check flags (e.g., "Check clearance", "Fix connection") directly onto specific 3D parts, areas, or points within the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates entirely within the 3D model environment. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not intended for generation within manufacturing drawings. |

## Prerequisites
- **Required Entities**: At least one Element (e.g., Beam, Wall) must be selected during the process.
- **Minimum Beam Count**: 1 (for Add mode with geometry); 0 (for Add mode with no location).
- **Required Settings**:
  - `Utilities\CadUtilities\hsbCommentManagement\hsbCommentManagementUI.dll`
  - `hsb_CommentDisplay.tsl` (Used to visualize the comment).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_CommentManagement.mcr` from the list.

### Step 2: Configure Properties
Before the command line prompts activate, the **Properties Palette** will appear.
- **Action**: Set the **Execution Mode** to "Add comment" (default) or "Edit comments".
- **Location**: Set **Location Geometry** (e.g., Point, Line segment, Area, Leader).
- **Visuals**: Adjust Color, Text Height, or Offsets as needed.
- *Tip:* If you select a **Comment Catalogue Entry**, standard text will be used automatically.

### Step 3: Add Comment Workflow (If Mode is set to Add)
The prompts vary based on the **Location Geometry** setting chosen in Step 2.

**Scenario A: Geometry is "Point"**
```
Command Line: Select an element
Action: Click on the beam or element you want to annotate.
```
```
Command Line: Select a position
Action: Click the specific point on the element where the comment should anchor.
```

**Scenario B: Geometry is "Line segment"**
```
Command Line: Select an element
Action: Click the target element.
```
```
Command Line: Select start of line segment
Action: Click the start point for the reference line.
```
```
Command Line: Select end point of line segment
Action: Click the end point. The text will align with this direction.
```

**Scenario C: Geometry is "Area"**
```
Command Line: Select an element
Action: Click the target element.
```
```
Command Line: Select a poly line, right click to select two points as a diagonal
Action: Either click an existing polyline in the drawing OR right-click to define a rectangle manually.
```
*(If right-clicked)*:
```
Command Line: Select start of diagonal
Action: Click one corner of the desired area.
```
```
Command Line: Select end of diagonal
Action: Click the opposite corner.
```

**Scenario D: Geometry is "Leader"**
```
Command Line: Select an element
Action: Click the target element.
```
```
Command Line: Select start of leader line
Action: Click where the arrow tip should touch.
```
```
Command Line: Select next point
Action: Click to define the path of the leader line. Continue clicking for vertices.
```
```
Command Line: Select next point
Action: Right-click or Enter to finish placing the leader.
```

**Scenario E: Geometry is "No location"**
```
Command Line: Select a set of elements
Action: Select one or multiple elements. The comment will be attached to the element data but may not have specific 3D geometry markers drawn.
```

### Step 4: Finish Input
- Once geometry is defined, the script creates an `hsb_CommentDisplay` instance in the model.
- If a **Comment Catalogue** was not used, a dialog box may appear asking for the text content.
- The script instance erases itself automatically, leaving only the comment display.

### Step 5: Edit Comments Workflow (If Mode is set to Edit)
```
Command Line: Select a set of elements
Action: Select the elements that have existing comments you wish to manage.
```
- An external interface window will open allowing you to view, modify, or delete comments associated with the selected elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Execution Mode | Dropdown | Add comment | Switches between creating new markup ("Add comment") or managing existing notes ("Edit comments"). |
| Show Edit After Adding | Dropdown | No | If set to "Yes", automatically opens the Edit Comments window immediately after placing a new comment. |
| Location Geometry | Dropdown | No location | Defines how the comment anchors: **Point**, **Line segment**, **Area**, **Leader**, or **No location**. |
| Text Orientation | Dropdown | Default | Controls text rotation. Options include Default (aligns to geometry), Horizontal, Vertical, or Perpendicular. |
| Comment Catalogue | String | (Empty) | Allows selection of pre-defined text templates from your company library to speed up entry. |
| Horizontal Offset | Number | 0 | Shifts the text horizontally (mm) from the anchor point to avoid overlap. |
| Vertical Offset | Number | 0 | Shifts the text vertically (mm) from the anchor point. |
| Color | Index | 1 | Sets the CAD color index for the comment text and leader lines. |
| Text Height | Number | 50 | Sets the physical height of the text in the model (mm). |
| Leader Size | Number | 1 | Scales the thickness and arrowhead size of the leader line. |
| Zone | Index | 5 | Assigns a construction zone or phase index to the comment for filtering purposes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Refresh (if applicable) | Recalculates the script if inserted in an interactive state (rare, as this script typically erases itself). |

## Settings Files
- **Filename**: `hsbCommentManagementUI.dll`
- **Location**: `Utilities\CadUtilities\hsbCommentManagement\`
- **Purpose**: Handles the database storage and user interface dialogs for entering and editing comment text.

## Tips
- **Use Zones**: If you work on large projects, utilize the **Zone** property to filter comments by floor or section when using the Edit mode.
- **Leader Lines**: For crowded areas, use the "Leader" geometry type to point to specific details without obscuring the model geometry.
- **Text Orientation**: If text appears upside down or unreadable after placement, change the **Text Orientation** property in the palette before clicking the insertion point.
- **Catalogues**: If your company has a list of standard remarks (e.g., "Check clearance"), configure the **Comment Catalogue** to avoid typing errors.

## FAQ
- **Q: I clicked to place the comment, but nothing appeared.**
  - **A:** Ensure you selected a valid Element. If you selected nothing or invalid geometry, the script silently erases itself. Also, check if `dTextHeight` is too small to see.
- **Q: How do I change the text of a comment I already placed?**
  - **A:** Run the script again, set **Execution Mode** to "Edit comments", and select the element(s) associated with the comment.
- **Q: The leader line has no arrow.**
  - **A:** Increase the **Leader Size** parameter (try `2.0` or `3.0`) in the properties palette before inserting.
- **Q: Can I move the text after placing it?**
  - **A:** Yes. Select the generated `hsb_CommentDisplay` entity in the model and use the AutoCAD `MOVE` command or adjust its **Origin** properties in the Properties Palette.