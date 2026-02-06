# StackHatch.mcr

## Overview
Automates the creation of 2D hatching and shading for stacked timber elements (packages, pallets) on shop drawings, handling hidden line removal to correctly display overlapping stacks.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script operates on PaperSpace views. |
| Paper Space | Yes | Specifically for Shop Drawings. |
| Shop Drawing | Yes | Requires a MultiPage context. |

## Prerequisites
- **Required Entities**: `ShopDrawView`, `StackEntity`, `StackPack`, `StackItem`, `StackSpacer`.
- **Minimum Beams**: 0 (This script processes stacking entities, not standard beams).
- **Required Settings**: Must be run within a MultiPage (Shopdrawing) context where views exist.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `StackHatch.mcr`

### Step 2: Select Origin Point
```
Command Line: |_Origin of hatchings|
Action: Click a point in the PaperSpace layout near the view you wish to process.
Note: The script will automatically snap this origin to the center of the selected view.
```

### Step 3: Select View
```
Command Line: |_Select MultiPage view or single view for hatchings|
Action: Click on the border of the Shopdrawing View you want to hatch.
Note: You can also select the view element from the model tree if preferred.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| _Pt0 | Point | Current | Origin point of the script. If this property is modified, it automatically snaps to the center of the selected view. |
| DisplaySet | dropdown | Default | Determines which elements are hatched. <br>• **Default**: Hatches only individual items (StackItem, StackSpacer). <br>• **All Solids**: Hatches everything including containers (StackEntity, StackPack). |
| Color | dropdown | Entity Color | Sets the coloring rule for the hatch. <br>• **Entity Color**: Uses the native color of the element. <br>• **By Parent**: Inherits the color of the parent package/pallet. <br>• **By Index**: Uses a fixed color index. |
| Color Index | number | 7 | The specific CAD color index (0-255) used when 'Color' is set to 'By Index'. |
| Transparency | number | 0 | Controls opacity. 0 is solid/opaque; higher values increase transparency to help visualize overlapping layers. |
| Draw Edge | dropdown | Yes | Toggles the drawing of boundary polylines around the hatched areas. |
| Edge Color | number | -1 | Color of the boundary lines. A value of -1 matches the edge color to the hatch fill color. |
| View All | dropdown | No | If set to 'Yes', applies hatching to all views on the current page, not just the one selected during insertion. |
| View Ortho | dropdown | Yes | If set to 'Yes', only Orthogonal (2D) views are processed. Isometric/3D views are skipped. |

## Right-Click Menu Options
No specific custom menu options defined. Standard hsbCAD context options (Recalculate, Delete, etc.) apply.

## Settings Files
No external settings files required.

## Tips
- **Visual Grouping**: Use the **Color** property set to **"By Parent"** to visually distinguish different packages or pallets within the same stack.
- **Complex Overlaps**: Increase the **Transparency** value if you have complex stacks where items obscure one another; this allows you to see the volume of items hidden behind others.
- **Batch Processing**: To hatch an entire layout quickly, set **View All** to "Yes" after inserting the script on the first view.
- **Origin Snapping**: If you move the script instance manually, simply click the `_Pt0` property in the properties palette and reset it to snap it back to the view center automatically.

## FAQ
- **Q: Why do I see the text "no solids found" in my drawing?**
  **A**: This warning appears if the selected view does not contain any StackItem, StackSpacer, or related stack entities, or if the **DisplaySet** filter is excluding the available entities.
- **Q: The script works in my plan view but not my ISO view. Why?**
  **A**: By default, the **View Ortho** property is set to "Yes". Change this to "No" to allow the script to process Isometric or 3D views.
- **Q: How can I make the hatch look like a solid solid wood fill?**
  **A**: Set **Transparency** to 0, **Color** to "Entity Color" (or a specific Index), and **Draw Edge** to "No".