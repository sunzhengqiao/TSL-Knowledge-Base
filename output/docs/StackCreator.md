# StackCreator.mcr

## Overview
Automates the assignment of timber elements to transport stacks. It calculates the next available Stack ID, assigns sequential loading numbers to selected elements, and triggers the physical stacking arrangement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model where elements exist. |
| Paper Space | No | Not designed for layout views or drawings. |
| Shop Drawing | No | Not intended for manufacturing detailing views. |

## Prerequisites
- **Required Entities:** Elements (Walls, Roofs, Floors) must exist in the model.
- **Minimum Beams:** 0 (Script runs, but requires selection of at least 1 Element to function).
- **Required Settings/Scripts:** 
    - `StackSequencer` (Required to visualize/process the stack).
    - `HSB_I-ShowGroupingInformation` (Optional, for displaying labels).
    - `Batch & Stack Info` (Optional, for displaying labels).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `StackCreator.mcr` from the file browser.

### Step 2: Select Elements
```
Command Line: Select elements
Action: Click on the timber elements (Walls, Roofs, Floors) you wish to group into a stack.
```
*Note: The order in which you click the elements determines their loading sequence (0, 1, 2...). Press Enter to confirm selection.*

### Step 3: Automatic Processing
Upon confirmation, the script will:
1. Calculate the new Stack ID (based on existing stacks in the model + 1).
2. Assign this Stack ID and a Sequence Number to the selected elements.
3. Trigger the `StackSequencer` to update the model.
4. Remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not have editable properties. It runs as a single-use command and deletes itself upon completion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are available. |

## Settings Files
This script does not use external settings files (`.xml`). It relies on data existing within the model entities and the presence of other TSL scripts (Dependencies) to function.

## Tips
- **Selection Order Matters:** The first element you click becomes position 0 (usually the bottom layer), the next becomes position 1, and so on. Select elements in the exact order you want them loaded onto the truck.
- **Auto-Increment:** You do not need to manually type in the Stack Number. The script scans the model, finds the highest existing number, and assigns the next number in sequence to your new selection.
- **Visual Feedback:** Ensure the `StackSequencer` and/or `HSB_I-ShowGroupingInformation` scripts are active in your project to visualize the changes immediately after running `StackCreator`.

## FAQ
- **Q: Why did the script disappear after I used it?**
- **A:** `StackCreator` is a "command script" designed to perform a specific task and then clean up after itself. It modifies the element data and removes its instance from the model to keep your project clean.

- **Q: How do I change the Stack ID number it generated?**
- **A:** The script automatically finds the next available number. To change a specific ID, you would typically need to edit the map data properties of the elements or manually adjust existing stack numbers in the model so the auto-calculation picks up your desired number.

- **Q: What happens if I select no elements?**
- **A:** The script will cancel the operation, assign no data, and erase itself without making changes to the model.