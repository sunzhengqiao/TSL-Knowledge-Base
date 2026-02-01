# f_Tag.mcr

## Overview
This script automatically generates descriptive labels for timber elements stacked on a truck or within a package. It intelligently positions tags to identify parts during assembly planning and creates visual labels for transport load lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is not a shop drawing detailing script. |

## Prerequisites
- **Required Entities**: `Hsb_TruckParent` (Truck) or stacked `GenBeam`/`Body` entities must exist in the model.
- **Minimum Beam Count**: 0 (Script detects existing stacks).
- **Required Settings**: 
    - `f_Stacking.xml` (Optional; defaults are used if not found).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Tag.mcr` from the list.

### Step 2: Select Target
```
Action: Select the Truck entity or the location of the stacked items.
Note: The script automatically detects 'stackTruckMembers' associated with the selection.
```

### Step 3: Configuration
```
Action: With the script selected, open the Properties Palette (Ctrl+1) to adjust tag appearance and content.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Hide Linework| | dropdown | |No| | Toggles the visibility of guide lines connecting the tag to the timber element. |
| |Color| | number | 7 | Sets the background fill color of the tag. Enter 16777214 for a near-white true color. |
| |Transparency| | number | 1 | Controls the opacity of the tag background (0 = Solid, 90 = Highly Transparent). |
| |LineType| | dropdown | *Continuous* | Defines the dash-dot pattern style of the guide lines (e.g., Hidden, Center). |
| |Linetype Scale| | number | 1.0 | Scales the density of the linetype pattern (makes dashes longer or shorter). |
| |Format| | text | @(Posnum) | Defines the text content using attribute macros (e.g., @(Posnum), @(Length)). Use backslash '\\' for multiple lines. |
| |Style| | dropdown | *Standard* | Selects the Text Style (defining font and height) used for the tag text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces a full re-evaluation of the stack layout, grid positions, and collision detection. |

## Settings Files
- **Filename**: `f_Stacking.xml`
- **Location**: Searches `[Company Path]\TSL\Settings\` first, then `[Install Path]\Content\General\TSL\Settings\`
- **Purpose**: Provides general default settings and version control. If the MapObject version differs, a notice is reported.

## Tips
- **Multi-line Tags**: To display information on multiple lines, separate your attributes in the `Format` property with a backslash (e.g., `@(Posnum)\@(Length)`).
- **Readability**: If your tags are hard to read over complex geometry, set `|Color|` to `16777214` (Near White) and increase `|Transparency|` to mask the background elements effectively.
- **Placement**: The script automatically handles collision detection for "Prime" (main) items to prevent overlapping tags. For other items, it arranges them in a grid layout based on the truck width.

## FAQ
- **Q: Why did my guide lines disappear?**
  **A:** Check the `|Hide Linework|` property in the Properties Palette. If it is set to `|No|`, ensure that a valid `|LineType|` is selected and loaded in your drawing.
- **Q: How do I show the Position Number and Material on the same tag?**
  **A:** In the `|Format|` property, enter: `@(Posnum)\@(Material)`. The backslash forces a new line.
- **Q: The background color isn't changing.**
  **A:** Ensure the script style (internal logic) is set to utilize the background fill. You may need to recalculate the script after changing the color property.