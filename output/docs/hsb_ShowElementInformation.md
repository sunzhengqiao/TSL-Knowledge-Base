# hsb_ShowElementInformation.mcr

## Overview
A tool to generate text labels displaying specific data (dimensions, codes, comments, or properties) from timber elements. It supports labeling directly on 3D models (Model Space) or on 2D drawing layouts (Paper Space).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select elements to attach labels directly to them. |
| Paper Space | Yes | Select a viewport and pick a point to place a label derived from the view. |
| Shop Drawing | No | Used for annotation within drawings. |

## Prerequisites
- **Required entities**: Timber Element (e.g., Wall).
- **Minimum beam count**: 0 (Script attaches to Element structure).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowElementInformation.mcr`

### Step 2: Configure Properties
Upon insertion, the Properties Palette (or a dialog) will appear.
1.  Set **Drawing space** to either `|Model space|` or `|Paper space|`.
2.  Select the **Type of data** you wish to display (e.g., Wall Height, Wall Number, Comments).
3.  (Optional) Adjust **Dim Style** or **Text Height**.

### Step 3: Select Elements / Viewport
*Depending on your selection in Step 2, follow the relevant flow below:*

**Option A: Model Space**
```
Command Line: Select Elements
Action: Click on the timber elements (walls) you want to label.
```
*Note: The script will automatically attach a separate label instance to each selected element.*

**Option B: Paper Space**
```
Command Line: Pick a point where the information is going to be shown
Action: Click on the drawing layout to place the text.
```
```
Command Line: Select the viewport from which the element is taken
Action: Click the boundary of the viewport that displays the element.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | \|Paper space\| | Determines if the label is placed in Model Space (3D) or Paper Space (2D Layout). |
| Type of data | dropdown | Wall Description | Selects the specific attribute to display (e.g., Wall Stud Spacing, Wall Code, Comments, Group Level). |
| Dim Style | dropdown | *Current* | Selects the dimension style to control text font and arrow appearance. |
| Text Height | number | 0 | Overrides the text height defined in the Dim Style. Set to 0 to use the Dim Style default. |
| Show | dropdown | \|All\| | Filters "Wall Comments". Use \|All\| to show everything, or \|No location\| to hide comments tagged with a specific location. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu items are defined. Use the Properties Palette (Ctrl+1) to modify parameters. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Labeling**: In Model Space, you can window-select multiple walls at once. The script will process the selection and attach a label to every wall picked.
- **Floorplan Numbering**: Use the **"Floorplan Element Numbers"** option in the Type of data dropdown. This automatically calculates and labels all elements within a specific group without needing to select them individually.
- **Quick Editing**: Select an existing label in the drawing and open the Properties Palette (Ctrl+1). You can change the "Type of data" to instantly update the text content (e.g., switch from "Wall Number" to "Wall Height") without deleting and re-inserting the script.
- **Viewport Scaling**: In Paper Space, ensure your selected **Dim Style** is configured for the correct scale (e.g., 1:50 or 1:100) so the text appears readable relative to your viewport.

## FAQ
- **Q: Can I label multiple walls at once in Model Space?**
  - A: Yes. When prompted to "Select Elements", you can drag a window to select multiple walls. The script will spawn an instance for each one.
- **Q: Why did the script disappear after I selected elements in Model Space?**
  - A: This is normal behavior. The original "launcher" script erases itself after spawning child instances attached to the selected elements. Look at the elements themselves to see the new labels.
- **Q: How do I filter out specific wall comments?**
  - A: Set **Type of data** to "Wall Comments". Then change the **Show** property to `\|No location\|` to hide comments that have specific location data assigned to them.