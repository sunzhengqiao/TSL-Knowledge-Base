# ToolTag.mcr

## Overview
This script automatically identifies, groups, and labels machining tools (such as Drills, Beamcuts, and Mortises) on timber beams. It works both in Model Space for direct beam selection and in Paper Space for Multipage layouts.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select GenBeams directly. |
| Paper Space | Yes | Select a Multipage element to tag tools within viewports. |
| Shop Drawing | Yes | Optimized for orthogonal shop drawing viewports. |

## Prerequisites
- **Required Entities**: GenBeams (in Model Space) or Multipage/Element (in Paper Space).
- **Minimum Beam Count**: 0.
- **Required Settings**: `TslUtilities.dll` (must be loaded for dialogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ToolTag.mcr` from the list.

### Step 2: Select Elements
```
Command Line: Select element:
Action: Click on the GenBeams you wish to process in Model Space, OR click on a Multipage border in Paper Space.
```

### Step 3: Select Tool Types
```
Dialog: Select Tool Types
Action: A dialog appears listing available tool types (e.g., Drill, Beamcut, Mortise, Slot, FreeProfile). Check the boxes for the tools you want to tag and click OK.
```

### Step 4: Adjust Tags (Optional)
After generation, you can click the script to modify properties in the Properties Palette (OPM) or drag the "Tag" grip to reposition the text.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool Type** | dropdown | _Default | Opens dialog to select which tool types to include in the tag. |
| **Filter Mode** | dropdown | All | Determines which tools to tag based on location/orientation (All, Side, Top/Bottom, End, Visible, or By Location). |
| **Location Tol.** | number | 50 | Tolerance distance for the "By Location" filter mode. |
| **Grouping** | dropdown | None | Groups tools by criteria (None, Type, Subtype, Diameter, Diameter x Length). Useful for summarizing quantities. |
| **DimStyle** | dropdown | _LastInserted | Specifies the dimension style to use for the tag text. |
| **Text Height** | number | 0 | Height of the tag text. |
| **Leader Style** | dropdown | All | Controls leader lines: None, All, or Primary. |
| **Tag Style** | dropdown | Text Filled + Shape | Visual appearance: Text Filled, Text Only, Text Filled + Shape, Text Only + Shape, or Shape Only. |
| **Quantity** | dropdown | Yes | Adds a quantity prefix to the tag (e.g., "4x"). |
| **Format** | text | @(Name) @(Diameter) x @(Length) | Custom string format for the tag content using tokens. |
| **Show Tags** | dropdown | Yes | Toggles the visibility of the tags on/off. |
| **Tag Order** | dropdown | Unsorted | Sorting order for multiple tags: Unsorted, X, or Y. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Tool Settings** | Opens the multi-select dialog to change which tool types are currently tagged. |
| **UserPrompt** | Opens the multi-select dialog to change which tool types are currently tagged. |
| **TslDoubleClick** | Double-clicking the script instance opens the Tool Settings dialog. |

## Settings Files
No specific external XML settings file is required. The script relies on the `TslUtilities.dll` for dialog functionality.

## Tips
- **Grip Editing**: Select the tag and drag the square grip to move the text. If you move the text far away from the tool shape, a leader line will automatically appear.
- **Paper Space Workflow**: When working on a layout, simply select the Multipage border. The script will detect the viewports and project the 3D tool locations onto the 2D drawing.
- **Grouping**: Use the "Grouping" property set to "Diameter x Length" to combine identical cuts into a single label (e.g., "2x D24 x 50").
- **Filtering**: Use "Filter Mode: Visible" to only tag tools that are currently visible in the specific view direction.

## FAQ

- **Q: Why does my tag show "Shape Only" with no text?**
  - A: Check the **Tag Style** property in the Properties Palette. It might be set to "Shape Only". Change it to "Text Filled" or "Text Filled + Shape".

- **Q: Can I tag only holes on the top face of a beam?**
  - A: Yes. Select the script, go to Properties, and set **Filter Mode** to "Top/Bottom".

- **Q: How do I tag tools in a specific area of a large beam?**
  - A: Set **Filter Mode** to "By Location" and adjust the **Location Tol.** value. The script will filter tools based on their proximity to the insertion point or viewport logic.

- **Q: The text is too small to read.**
  - A: Select the script and increase the **Text Height** property value.