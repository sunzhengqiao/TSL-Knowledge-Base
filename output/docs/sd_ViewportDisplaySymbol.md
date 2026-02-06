# sd_ViewportDisplaySymbol.mcr

## Overview
This script automates the annotation of shop drawings by displaying 2D symbols for hardware (connectors, plates) and labels for perpendicular drill holes within a selected viewport. It ensures that necessary connection details are clearly visible on the layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for layout generation. |
| Paper Space | Yes | Must be run within a layout tab. |
| Shop Drawing | Yes | Specifically designed to work with `ShopDrawView` entities. |

## Prerequisites
- **Required Entities:** A `ShopDrawView` (Viewport) must exist in the Paper Space layout.
- **Content:** The model view associated with the viewport must contain beams, metal parts, or TSL instances that have symbol maps or perpendicular drill tools defined.
- **Setting:** A valid Dimension Style (`DimStyle`) must exist in the drawing if you wish to customize text appearance.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `sd_ViewportDisplaySymbol.mcr`.

### Step 2: Select Viewport
```
Command Line: Select a shopdrawview
Action: Click on the Viewport frame or the boundary of the shop drawing view you wish to annotate.
```

### Step 3: Select Insertion Point
```
Command Line: (Select Point)
Action: Click anywhere in the Paper Space.
Note: This point is used as a fallback location. If the script cannot find data or hardware in the view, it will display the script name and scale at this location.
```

### Step 4: Configure Properties
After insertion, a dialog appears (or use the Properties Palette) to set the scale, color, and dimension style.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scale | Number | 1.0 | Determines the size of the symbols and text labels. Increase this value to make annotations larger in Paper Space. |
| Color -1 = byBlock | Number | 164 | Sets the color for the drawn lines and text. Enter `-1` to use the original colors defined in the component symbol map. |
| Dimstyle | Dropdown/String | _DimStyles | Specifies the text style used for hardware labels (e.g., "2x M12"). The style must exist in the current drawing. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files. It reads configuration from the Properties Palette and the instance map.

## Tips
- **Visibility:** Symbols are only drawn if their internal "View Vector" is parallel to the Viewport's Z-axis. This ensures you only see hardware symbols that are facing "out" towards the viewer in 2D.
- **Troubleshooting:** If you see only the script name and scale number at your selected point, the script likely could not find any entities or hardware data associated with that specific viewport.
- **Organization:** The script automatically groups perpendicular drills by diameter and creates a single label (e.g., "4x M12") for them.

## FAQ
- **Q: Why are some of my connector symbols missing?**
  A: The script filters symbols based on orientation. A symbol will only appear if it is defined to be visible from the current viewing direction of the selected viewport.
- **Q: Can I change the size of the text without changing the lines?**
  A: No, the `Scale` property acts as a global multiplier for all generated geometry (symbols, hatches, and text).
- **Q: What does setting Color to -1 do?**
  A: It respects the colors assigned to the specific hardware in your catalog or sub-scripts. If you set a specific number (e.g., Red), it overrides the catalog colors.