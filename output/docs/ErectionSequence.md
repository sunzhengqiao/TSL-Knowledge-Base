# ErectionSequence.mcr

## Overview
Automatically assigns and manages erection sequence numbers to timber elements (panels, beams, sheets) based on building phases. This tool facilitates on-site assembly logistics by creating a numbered list or text labels (e.g., 0001, 0002) to indicate the order of installation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting and numbering entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: At least one structural element (Panel, Beam, Sheet, or Element/Wall-Floor-Roof) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `ErectionSequence.mcr`.
3.  Press **Enter** to insert the script instance into the drawing.

### Step 2: Configure Operation Properties
1.  Select the inserted script instance in the model.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Configure the parameters as follows:
    *   **Mode**: Choose `|Add to sequence|` to assign numbers or `|Remove sequence...|` to delete them.
    *   **Building Phase**: Select an existing phase (e.g., "Ground Floor") or choose `|New|` to create one.
    *   **EntityType**: Set to `|Any|` or specific types (Panel, Beam, etc.) to filter your selection.
    *   **Start Number**: Set to `-1` for automatic numbering or enter a specific integer (e.g., 100) to start from that number.
    *   **Keep existing**: Set to `|No|` to renumber the whole phase continuously, or `|Yes|` to preserve existing numbers and fill gaps only.

### Step 3: Execute the Command
1.  **If you selected `|New|` for Building Phase:**
    *   Look at the command line.
    *   Type the name for the new phase (e.g., "Phase 1") and press **Enter**.
2.  **Selection Phase:**
    *   If Mode is **Add**: The prompt will ask to "Select panel/beam/sheet/elem". Click the objects you want to number and press **Enter**.
    *   If Mode is **Remove**: The prompt will ask to "Select objects to remove". Click the objects and press **Enter**.
3.  The script will process the selection, assign or remove the metadata, and then erase the script instance from the drawing (leaving only the data attached to the elements).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Mode** | dropdown | \|Add to sequence\| | Determines the operation. Choose to add numbers or remove them by selection, type, or phase. |
| **Building Phase** | dropdown | <Empty> | Defines the construction phase. Choosing `|New|` triggers a prompt to create a new phase name. |
| **EntityType** | dropdown | \|Any\| | Filters which types of elements can be selected (Panels, Beams, Sheets, or Elements). |
| **Start Number** | number | -1 | Sets the starting number. `-1` finds the next available number automatically. Any positive integer starts numbering from that value. |
| **Keep existing** | dropdown | \|No\| | If `|No|`, the script re-sequences all elements in the phase for a continuous list (1, 2, 3...). If `|Yes|`, it keeps current numbers and only assigns numbers to new items. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Interaction is handled via the Properties Palette during insertion. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Sorting Lists**: The script creates a property called `SequenceNumberText` (e.g., "0001", "0011"). Use this property instead of the standard number when exporting to lists or Excel to ensure correct alphanumeric sorting.
- **Visual Verification**: To see the erection numbers drawn in the 3D model as text labels, you must enable Debug mode (usually via `hsbDebugController` or setting `bDebug` to true) before running the script. Otherwise, the numbers are stored as hidden data only.
- **Renumbering Phases**: If you add elements to an existing phase and want them to be the last numbers, set **Keep existing** to `|Yes|`. If you want to shuffle the order so new elements are mixed in or simply want a clean 1-100 sequence, set **Keep existing** to `|No|`.

## FAQ
- **Q: I ran the script but nothing happened.**
- **A:** Check the command line. Did you select objects? If you pressed Enter without selecting objects, the script exits silently. Also, ensure **EntityType** allows the type of object you are trying to click.
- **Q: How do I change the number of an existing element?**
- **A:** You cannot manually edit the number directly on the element. You must run the script again, select the phase, set **Keep existing** to `|No|`, and select the elements again. The script will re-calculate the sequence based on the order of selection or existing data.
- **Q: What does "Start Number = -1" do?**
- **A:** It tells the script to look at all existing elements in that phase, find the highest number currently used, and start numbering the newly selected elements from the next number (e.g., if highest is 10, new ones start at 11).