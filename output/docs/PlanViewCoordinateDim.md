# PlanViewCoordinateDim.mcr

## Overview
This script automates the placement of coordinate dimension tags within plan view layouts. It annotates construction elements (such as walls, beams, or stickframes) with their X/Y coordinates or custom attributes based on a chosen strategy.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for 2D output generation. |
| Paper Space | Yes | It operates specifically within Plan View viewports on layouts. |
| Shop Drawing | Yes | Used to create production drawings with coordinate references. |

## Prerequisites
- A valid Shop Drawing layout with an active Plan View viewport.
- Model entities (Walls, Beams, etc.) visible in the plan view.
- (Optional) Pre-defined "Painter" selection sets in the catalog if using automatic selection modes.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `PlanViewCoordinateDim.mcr` from the list and click **OK**. The script instance will appear in the drawing tree or viewport.

### Step 2: Configure Reference Source
**Action:** Select the script instance and open the **Properties Palette** (Ctrl+1).
**Property:** Locate the `sReference` property.
**Selection:**
- Choose **bySelection** to manually pick elements.
- Choose a specific **Painter** name to automatically filter and tag all matching elements in the view.

### Step 3: Select Elements (If "bySelection")
**Action:** Right-click on the script instance in the drawing or Project Browser.
**Command Line:** Select **Add Walls**, **Add beams**, or **Add TSLs**.
**Prompt:** `Select entities:`
**Action:** Click on the desired elements in the viewport. Press **Enter** to confirm.
*Note: Tags will generate immediately based on the default settings.*

### Step 4: Adjust Placement and Style
**Action:** Modify the following properties in the Properties Palette to fine-tune the output:
- `sStrategy`: Change to **Start**, **End**, **Center**, or **Start+End** to determine where tags appear on the elements.
- `dOffset`: Increase the value (e.g., 1500) if tags are clipping into the geometry.
- `sFormat`: Customize the text string (e.g., `X: @(ChoordX) Y: @(ChoordY)`).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sFormat** | String | X: @(ChoordX) \PY: @(ChoordY) | Determines the text content of the tag. Use keys like `@(ChoordX)`, `@(Name)`, or `@(Elevation)`. |
| **sStrategy** | Dropdown | Default | Logic for tag placement: *Default, Start, End, Start+End, Center*. |
| **sReference** | Dropdown | bySelection | Defines the source of elements. Choose *bySelection* or a specific Painter definition. |
| **sDimStyle** | String | (Current) | The CAD dimension style used for text font, color, and arrows. |
| **dTextHeight** | Double | 0 | Height of the text. If set to 0, the height defined in the DimStyle is used. |
| **dOffset** | Double | 1000 | Distance in mm from the referenced entity to the tag location. |
| **nSequence** | Integer | 0 | Drawing priority (layer order). Higher numbers draw on top of lower numbers. |
| **vecMoveX** | Double | 0 | Manual X-axis adjustment for tags (usually set via "Move Tag" command). |
| **vecMoveY** | Double | 0 | Manual Y-axis adjustment for tags (usually set via "Move Tag" command). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Move Tag** | Enters a visual mode where you can click and drag individual tags to a new location. The new offset is saved. |
| **Reset Locations** | Deletes all manual move adjustments, returning all tags to their calculated positions. |
| **Add/Remove Format** | Opens a prompt list allowing you to toggle available data points (like Name, Elevation, Length) on/off for the tag text. |
| **Add Walls** | Filters the selection to only include Wall elements. |
| **Add beams** | Filters the selection to only include Beam elements. |
| **Add openings** | Adds openings to the list of entities to dimension. |
| **Add TSLs** | Adds other TSL instances to the list. |
| **Remove entities** | Clears the current list of selected entities. |
| **Set datum** | Allows you to specify a coordinate origin point (0,0) for the calculations. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** This script uses embedded "Painter" streams or catalog entries; no external XML file is strictly required for basic operation.

## Tips
- **Use Painters for Speed:** If you need to tag every wall in a large project, define a "Painter" in your catalog and select it via the `sReference` property. This ensures new walls added to the model are automatically tagged in the drawing.
- **Resolving Overlaps:** If two tags overlap, use the **Move Tag** RMC command to drag them apart rather than changing the global `dOffset`.
- **Custom Text:** Use the **Add/Remove Format** RMC command to see exactly which variables (like `Material` or `Length`) are available for your specific selected elements without needing to memorize the syntax.

## FAQ
- **Q: Why don't I see any tags after inserting?**
  **A:** Check if `sReference` is set to `bySelection`. If so, you must use the Right-Click menu commands (e.g., "Add Walls") to select entities. Also ensure the elements are actually visible within the Plan View viewport clipping boundary.
- **Q: How do I show Elevation instead of Coordinates?**
  **A:** Change the `sFormat` property to `@(Elevation)` or use the **Add/Remove Format** RMC command to toggle Elevation on.
- **Q: My text is too small to read.**
  **A:** Set `dTextHeight` to a specific value (e.g., 2.5 or 3.5 mm for paper space) or check that your selected `sDimStyle` has a usable text height defined.