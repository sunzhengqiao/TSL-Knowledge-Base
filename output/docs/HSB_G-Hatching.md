# HSB_G-Hatching

## Overview
Applies 2D hatching patterns to specific timber beams in Paper Space layouts to visually highlight structural elements (e.g., columns) or differentiate wall layers based on filters or location.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script generates 2D output only. |
| Paper Space | Yes | This is the primary environment for this script. |
| Shop Drawing | Yes | Used to enhance production drawings. |

## Prerequisites
- **Required Entities:** A Layout Viewport containing a valid hsbCAD Element.
- **Minimum Beam Count:** 0 (The element itself is the primary target).
- **Required Settings:** The script `HSB_G-FilterGenBeams.mcr` must be loaded in the drawing if you intend to use the "Result from filter" selection method.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Hatching.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in the layout that displays the element you wish to hatch.
```

### Step 3: Place Label
```
Command Line: Select a point
Action: Click in the Paper Space to define the location for the script name/status label.
```

### Step 4: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to configure the hatching criteria, pattern, and style. Press **Esc** or click elsewhere to recalc and generate the hatch.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition | Catalog | First entry | Selects the rule set (from HSB_G-FilterGenBeams) used to identify which beams to hatch. |
| Hatch objects | Enum | Result from filter | Determines selection method: <br>- *Result from filter*: Uses the selected filter definition.<br>- *GenBeams at arrow side*: Hatches beams on the element's arrow side.<br>- *GenBeams at non-arrow side*: Hatches beams on the opposite side. |
| Hatch pattern | String | HSB- Single diagonal line | The visual style of the shading (e.g., ANSI31, SOLID). |
| Hatch mode | Enum | Body | Defines what part of the beam to hatch:<br>- *Body*: The solid timber profile.<br>- *Tools*: Only the machining/void areas.<br>- *Face*: The elevation outline. |
| Face type | Enum | Front | If Hatch mode is *Face*, selects which side to hatch (Front, Back, or Both). |
| Hatch scale | Number | 1.0 | Adjusts the density/spacing of the hatch pattern. |
| Hatch color | Number | -1 (ByLayer) | Sets the color of the hatch pattern (AutoCAD Color Index). |
| DimStyle name | String | Current DimStyle | The text style used for the label. |
| Name color | Number | 1 (Red) | Color of the script name text label. |
| Name height | Number | 5.0 mm | Height of the text label in Paper Space. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Disables hatching for the current element instance and displays "Active filter" text in red. |
| Remove filter for this element | Re-enables hatching for the current element instance if it was previously filtered. |
| Remove filter for all elements | Clears the filter status for all layout instances associated with this script. |
| Recalculate | Updates the hatching based on current geometry or property changes. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: This external script provides the logic required when "Hatch objects" is set to "Result from filter". Ensure it is loaded in the drawing to avoid errors.

## Tips
- **Text Label Position:** You can move the script name/text label by clicking and dragging its grip point after insertion.
- **Filtering:** If the hatching does not appear but the text does, check if "Filter this element" was accidentally activated via the right-click menu.
- **Void Hatching:** Use the "Tools" mode in Hatch properties to graphically highlight where machining or cutouts occur within the beams.
- **Arrow Side:** Ensure your element's local coordinate system (arrow direction) is correct before using the "GenBeams at arrow side" option.

## FAQ
- **Q: I see a warning "Beams could not be filtered!"**
- **A: The script `HSB_G-FilterGenBeams` is not loaded. Load it using `TSLLOAD` or change the "Hatch objects" property to a side-based selection (e.g., "GenBeams at arrow side").

- **Q: The hatch pattern is too dense or too sparse.**
- **A: Adjust the "Hatch scale" property in the Properties Palette. Lower values make it denser; higher values make it sparser.

- **Q: Can I hatch only the cutouts and holes?**
- **A: Yes. Set "Hatch mode" to "Tools" in the Properties Palette. This will hatch only the void areas created by machining.