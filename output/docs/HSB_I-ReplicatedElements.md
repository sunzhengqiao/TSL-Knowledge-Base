# HSB_I-ReplicatedElements

## Overview
This script identifies and displays a comma-separated list of Element numbers that are replicas of the element shown in a selected viewport. It places this text annotation directly on your drawing layout at a location of your choice.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for use on layouts. |
| Paper Space | Yes | The script must be inserted on a layout with a viewport. |
| Shop Drawing | No | This is a generic TSL script, not a specific shop drawing generator. |

## Prerequisites
- **Required Entities**: A layout containing at least one viewport that is linked to an Element (Model Space entity).
- **Minimum Beam Count**: 0 (Scans all elements in the model).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse to select 'HSB_I-ReplicatedElements.mcr' and click Open.
```

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the viewport on your layout that displays the element you want to analyze.
```

### Step 3: Select Position
```
Command Line: Select a position
Action: Click anywhere on the Paper Space layout where you want the list of element numbers to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | Dropdown | _DimStyles | Select the graphical style (font, color, arrows) to be applied to the text annotation. |
| Text size | Number | -1 | Sets the height of the text. If set to 0 or a negative number, the default height defined in the selected Dimension style is used. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Moving the Text**: After insertion, you can click the text and use the grip point to drag it to a new location without re-inserting the script.
- **Updating the List**: If elements are added or modified in the model, the text will automatically update to reflect the current replication status when the drawing or project is recalculated.
- **Text Sizing**: For best results, set the **Text size** to `0` initially to match your standard drafting dimensions. Adjust only if the specific label needs to be larger or smaller than the standard dimensions.

## FAQ
- **Q: Why did the script disappear immediately after I selected the position?**
  - **A:** This usually happens if the selected viewport does not contain a valid Element or if no viewport was selected. Ensure you click a viewport that is linked to a model element.
- **Q: The list of numbers is too small to read.**
  - **A:** Select the script instance in the drawing, open the Properties palette (Ctrl+1), and increase the **Text size** value to a positive number (e.g., 2.5 or 5.0 mm).
- **Q: How are "Replicas" determined?**
  - **A:** The script finds all elements in the model that share the same geometry subtype (or definition) as the element currently inside the selected viewport.