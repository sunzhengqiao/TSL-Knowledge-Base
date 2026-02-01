# HSB_D-Brace.mcr

## Overview
Automatically creates detailed 2D shop drawings of diagonal wind bracing in Paper Space. It generates dimensions for the brace length, intersecting beams (studs/rafters), sheet profiles, and the brace angle based on your model data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing in layouts. |
| Paper Space | Yes | Primary usage. Requires a viewport with a model. |
| Shop Drawing | Yes | Used for manufacturing or installation drawings. |

## Prerequisites
- **Required Entities:** A Paper Space Layout containing a Viewport with a valid hsbCAD Element. The Element must contain GenBeams and/or Sheets.
- **Minimum Beam Count:** 0
- **Required Settings:**
  - `HSB_G-FilterGenBeams` Catalog entry.
  - Standard hsbCAD Dimension Styles.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Brace.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport on the layout tab that displays the wall or panel containing the diagonal bracing you wish to detail.
```

### Step 3: Select Label Position
```
Command Line: Select a position
Action: Click in Paper Space where you want the Name/Description label for the bracing detail to be placed.
```

### Step 4: Configure (Optional)
If not executed via a catalog key, a configuration dialog may appear allowing you to preset filters (Section Name, Beam Codes). Otherwise, use the Properties Panel to adjust settings after insertion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sSectionName | Dropdown | (Empty) | Selects the specific TSL script instance (section) defining the bracing configuration to dimension. |
| genBeamFilterDefinition | Text | (Empty) | Applies a catalog-based filter to select specific structural beams (e.g., studs) to dimension. |
| sFilterBC | Text | (Empty) | Filters elements by their Beam Code (e.g., specific material grades). Use semicolons for multiple codes (e.g., "C24;KSTL-01"). |
| sFilterLabel | Text | (Empty) | Filters elements by their label or material name. |
| sFilterZone | Text | 1;7 | Filters elements based on construction zones or phases. Use semicolon-separated integers. |
| sDimStartBrace | Yes/No | No | Enables dimensioning of the diagonal brace itself (length and offsets). |
| sDimEndRafter | Yes/No | No | Enables dimensioning of the end rafter (horizontal beam at the brace's end). |
| bDimBeams | Yes/No | (Varies) | Controls the visibility of dimensions for the intersecting vertical/horizontal beams. |
| bShowPosNum | Yes/No | (Varies) | Toggles the display of position numbers with leader lines for beams. |
| bDimSheets | Yes/No | (Varies) | Enables dimensioning of sheet profiles within the braced panel. |
| bShowArc | Yes/No | (Varies) | Toggles the display of the angle arc and degree measurement for the brace. |
| dDimBeamsOffset | Number | (Varies) | Sets the offset distance for beam dimensions to avoid overlap. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Restricts the script to only process the currently selected element, hiding dimensions for other elements. |
| Remove filter | Clears the element filter, restoring visibility of dimensions for all valid elements in the set. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams` (Catalog)
- **Location**: Company or Install path
- **Purpose**: Provides saved filter definitions to quickly select specific groups of beams for dimensioning.

## Tips
- **Moving the Label:** Click the label grip inserted in Step 3 to drag the Name/Description to a new location without affecting dimensions.
- **Avoiding Overlap:** If beam dimensions are too crowded, the script automatically alternates offsets. You can manually increase `dDimBeamsOffset` in the properties if they still clash.
- **Missing Dimensions:** If expected dimensions do not appear, check the `sFilterBC` (Beam Code) and `sFilterLabel` properties to ensure they match the actual properties of the beams in your model.

## FAQ
- **Q: Why did the script disappear immediately after I ran it?**
  **A:** This usually happens if you canceled the "Select a viewport" prompt or if the selected viewport does not contain a valid hsbCAD Element. Run the command again and ensure you click inside an active viewport with model data.
- **Q: The angle dimensions are not showing up.**
  **A:** Check the Properties Palette for the `bShowArc` (or similar "Show arc") parameter and ensure it is set to "Yes".
- **Q: How do I dimension only specific studs?**
  **A:** Use the `sFilterLabel` or `genBeamFilterDefinition` properties to narrow down the selection to the specific group of studs you want to dimension.