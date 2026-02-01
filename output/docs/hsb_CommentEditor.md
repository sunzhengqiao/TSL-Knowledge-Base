# hsb_CommentEditor.mcr

## Overview
This script provides a batch-editing interface for managing comments (annotations) attached to structural elements. It allows you to select either raw construction elements or existing comment markers to update their text data via an external editor.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model to modify element data. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for drawings. |

## Prerequisites
- **Required Entities**: Structural Elements (Beams, Walls) or existing TSL Instances (Comment Displays).
- **Minimum Beam Count**: 0 (Can be used on any valid element).
- **Required Settings**:
  - `hsbCommentManagementUI.dll` (Must be available for the user interface to appear).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_CommentEditor.mcr` from the file list.

### Step 2: Select Items
Depending on how the script is configured (via your company's toolbar), you will see one of the following prompts:

**Option A: Direct Element Mode**
```
Command Line: Select a set of elements
Action: Click on beams, walls, or panels in the model you wish to comment on. Press Enter to confirm.
```

**Option B: Comment Display Mode**
```
Command Line: Select a set of comment displays
Action: Click on existing visual comment markers (created by hsb_CommentDisplay) in the model. Press Enter to confirm.
```

### Step 3: Edit Comments
1. After selection, the **Comment Manager** (.NET interface) window will appear automatically.
2. Use the interface to search, add, edit, or delete comments for the selected elements.

### Step 4: Finish
1. Click **OK** or **Save** in the Comment Manager window.
2. The script will update the element data in the background and immediately remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This is a utility script that runs once and deletes itself. It does not have persistent properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the Right-Click context menu. |

## Settings Files
- **Dependency**: `hsbCommentManagementUI.dll`
- **Purpose**: Provides the graphical user interface (Dialog) required to view and edit the comment strings.

## Tips
- **Script Behavior**: This script deletes itself immediately after running. Do not look for it in the model after you finish your edits.
- **Selection Speed**: You can use standard AutoCAD selection methods (e.g., Window Selection) to quickly pick multiple elements or comment markers at once.
- **Data Safety**: The script updates data in the model map. Ensure you have a backup if you are batch-editing critical production information.

## FAQ
- **Q: The script ran, but I don't see it in my drawing anymore. Did it fail?**
  - A: No. This is a "launcher" script designed to open the editor and then erase itself. If the Comment Manager window appeared and you saved your changes, the operation was successful.
- **Q: I selected a comment marker, but the editor didn't show the text I expected.**
  - A: Ensure you selected a marker created by `hsb_CommentDisplay`. Other TSL instances will be ignored by this script.
- **Q: Can I undo changes made with this script?**
  - A: Yes, you can use the standard AutoCAD `UNDO` command to revert the data changes made by the script.