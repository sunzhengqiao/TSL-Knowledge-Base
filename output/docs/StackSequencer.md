# StackSequencer.mcr

## Overview
This script generates visual production sequence indicators (arrows and lines) to define the assembly order of timber elements in the 3D model. It allows users to group elements into stacks and manage their processing sequence through right-click context menu actions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is where the script draws the sequence geometry and interacts with Elements. |
| Paper Space | No | Not designed for Paper Space or shop drawings. |
| Shop Drawing | No | Not designed for Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: Timber Elements (walls, floors, etc.) must exist in the model.
- **Minimum Beam Count**: 0 (The script can be inserted into an empty model to prepare for sequencing).
- **Required Settings**: None.

## Usage Steps

### Step 1: Insert the Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `StackSequencer.mcr`.
3.  The script will initialize. You do not need to click a specific point; it manages data based on existing elements.

### Step 2: Add Elements to a Sequence
1.  Select the `StackSequencer` instance in the model.
2.  Right-click and choose **Add elements**.
3.  **Command Line Prompt**: `Select elements to add`
4.  Click on the timber elements you want to include in this production stack.
5.  Press **Enter** to confirm.
6.  The script will draw a line connecting these elements with circles and arrows indicating the flow.

### Step 3: Resequence Elements (Optional)
1.  Select the `StackSequencer` instance.
2.  Right-click and choose **Resequence elements**.
3.  **Command Line Prompt**: `Select elements to resequence`
4.  Click the elements in the *exact order* you want them to be processed/assembled.
5.  Press **Enter** to confirm.
6.  The visual arrows and lines will update to reflect the new path.

### Step 4: Resequence Stacks (Optional)
1.  If you have multiple stack sequences in the model, select the `StackSequencer` instance belonging to the stack you want to prioritize.
2.  Right-click and choose **Resequence stacks**.
3.  **Command Line Prompt**: `Select stacks to resequence`
4.  Select the stack instances in the order of priority (e.g., select Stack A, then Stack B to make A #1 and B #2).
5.  Press **Enter** to confirm.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not have editable properties in the Properties Palette (OPM). All interaction is performed via the Right-Click Context Menu. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add elements** | Prompts you to select timber elements to append to the end of the current stack sequence. |
| **Remove elements** | Prompts you to select elements currently in the sequence to remove them from the stack. |
| **Resequence elements** | Allows you to change the order of elements within the stack by selecting them in the new desired order. |
| **Resequence stacks** | Changes the global sequence number of the stack parent (e.g., renaming Stack 5 to Stack 1) relative to other stacks. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files.

## Tips
- **Layer Assignment**: The script automatically assigns the drawn lines and arrows to the Tooling layer associated with the floor group of the reference element.
- **Visual Feedback**: The script draws circles at element positions and lines with arrows connecting them to visually guide the production flow.
- **Batch Info**: Changing the stack sequence ("Resequence stacks") updates internal data used by labeling or other production management scripts.

## FAQ
- **Q: How do I change the assembly order of the elements?**
  A: Use the **Resequence elements** option in the right-click menu. Select the elements one by one in the specific order you want them to be assembled.
- **Q: What happens if I delete an element that is part of a sequence?**
  A: The visual line will break. You should use the **Remove elements** command to cleanly detach the element from the sequence data before deleting it, or simply update the sequence afterwards.
- **Q: Can I use this in a 2D layout?**
  A: No, this script is designed for the 3D Model Space only.