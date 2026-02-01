# HSB_D-Module.mcr

## Overview
Automatically dimensions the width of timber modules (walls or floors) in Model Space, Paper Space, or Shop Drawings. It allows users to filter specific beams (e.g., studs only), handle openings, and customize dimension styles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select the Element directly. |
| Paper Space | Yes | Select the Viewport containing the element. |
| Shop Drawing | Yes | Select the ShopDrawView entity. |

## Prerequisites
- **Required Entities**: 
  - Model Space: An Element (wall/floor) containing GenBeams.
  - Paper Space: A Viewport displaying the element.
  - Shop Drawing: A ShopDrawView entity.
- **Minimum Beams**: 1 (typically requires a full module).
- **Required Settings**: `HSB_G-FilterGenBeams.mcr` (required if using advanced beam filtering).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Module.mcr`

### Step 2: Configure Properties
```
Action: The Properties Palette (OPM) will open.
Instruction: Adjust settings like Drawing Space, Beam Filters, and Dimension Style before proceeding.
```

### Step 3: Select Dimension Location
```
Command Line: |Select location of dim line|
Action: Click in the CAD drawing to specify where the dimension line should be placed.
```

### Step 4: Select Source Entity
The prompt here depends on the "Drawing space" property selected in Step 2.

**If "Model Space" is selected:**
```
Command Line: Select element
Action: Click on the timber wall or floor element to dimension.
```

**If "Paper Space" is selected:**
```
Command Line: |Select the viewport from which the element is taken|
Action: Click on the viewport frame that displays the element.
```

**If "Shopdraw multipage" is selected:**
```
Command Line: |Select the view entity from which the module is taken|
Action: Click on the specific drawing view (border) of the module.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | model space | Select where the dimension is created: Model Space, Paper Space, or Shopdraw multipage. |
| Filter Definition | text | [Empty] | Name of a filter preset from `HSB_G-FilterGenBeams.mcr` to select specific beams. |
| In/Exclude Filters | dropdown | Include | Set to "Include" to dimension only matching beams, or "Exclude" to ignore them. |
| Filter BC | text | [Empty] | Filter beams by their specific naming code (e.g., 'ST' for studs). |
| Filter Label | text | [Empty] | Filter beams based on their assigned label. |
| Filter Type | dropdown | [All] | Filter beams by functional type (e.g., Stud, Plate, Rafter). |
| Filter BmTypeID | text | [Empty] | Filter beams by their internal numeric Type ID (separate IDs with semicolons). |
| Width Smaller Than | number | 0 | Filter beams with a cross-section width smaller than this value (0 = disabled). |
| Show Opening | dropdown | yes | Controls if openings (windows/doors) are marked. Options: "Yes", "No", "Yes + dimension line", "No + dimension line". |
| Direction | dropdown | horizontal | Sets the dimension orientation: Horizontal (width) or Vertical (height). |
| Point Type | dropdown | left | Determines which part of the beam is dimensioned: Left, Center, Right, Left and Right, or Maximum extents. |
| Combine Touching Beams | dropdown | no | If "Yes", merges touching/overlapping beams into a single continuous dimension. |
| Dimension Style (s2) | dropdown | delta perpendicular | Sets the style: Delta (individual sizes) or Running (total accumulation). |
| Delta On Top | dropdown | no | If "Yes", places the dimension text above the dimension line. |
| Dim Style | text | <Standard> | The CAD Dimension Style to use for line type, arrows, and text font. |
| Dim Color | number | 92 | The CAD Color Index (0-255) for the dimension lines and text. |
| Reference Object | dropdown | No reference | Adds dimensions relative to a specific reference object (e.g., a specific beam type). |
| Reference Beam Type | dropdown | [All] | Specifies the beam type to use as the reference if "Reference Object" is active. |
| Point Type Reference | dropdown | left | Determines the point on the reference beam used for dimensioning. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-calculate | Updates the dimension geometry if the source element or properties have changed. |
| Remove | Deletes the script entity and associated dimensions. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: Company or hsbCAD Install path
- **Purpose**: Provides named filter configurations (e.g., "StudsOnly", "TopPlates") that can be selected in the "Filter Definition" property to quickly select which beams to dimension.

## Tips
- **Filtering**: Use the `Filter BC` or `Filter Type` properties to dimension only specific parts of a wall (e.g., only the studs) rather than the entire assembly.
- **Clean Drawings**: Enable `Combine Touching Beams` to reduce clutter. This is useful when you want the total length of a wall section rather than individual stud lengths.
- **Openings**: Use the `Show Opening` set to "Yes + dimension line" to automatically create a sub-dimension line for window and door widths.
- **Paper Space**: When working in Layouts, ensure you select the correct Viewport, as the script extracts the element linked to that view.

## FAQ
- **Q: I get "Error code: 1" or "Error code: 2".**
  A: This occurs in Shopdraw mode. It means the selected View entity is invalid or the View Data (Map) cannot be found. Try regenerating the Shop Drawing.
- **Q: I get "Error code: 3".**
  A: This occurs in Paper Space mode. You must select a valid Viewport entity.
- **Q: I get "Error code: 4".**
  A: This occurs in Model Space mode. You must select a valid Element (wall/floor).
- **Q: Why are my dimensions showing "0" or incorrect values?**
  A: Check your `Point Type` setting. If set to "Center" on narrow beams, or if the beam filter is excluding all beams, the dimensions may appear unexpected.
- **Q: Can I dimension vertical elements?**
  A: Yes, change the `Direction` property to "Vertical". This is useful for floor panels or height dimensions.