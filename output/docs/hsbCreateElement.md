# hsbCreateElement

## Description

**hsbCreateElement** is a tool that creates an Element (typically an ElementRoof type) from selected timber entities and automatically assigns them to detected zones. This tool is essential for organizing beams, sheets, panels, and trusses into a structured element hierarchy with proper building/floor grouping.

When you select multiple beams, panels, or collection entities, the script analyzes their positions relative to Zone 0 (the core layer) and automatically assigns each entity to the appropriate zone based on its Z-location. This makes it easy to convert loose geometry into a properly structured hsbCAD element.

## Script Type

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Beams Required | 0 |
| Version | 2.5 |
| Keywords | Element, Beam, Sandwich, Panel |

## Properties

The following properties are available in the AutoCAD Properties Palette (OPM) when the tool is selected:

### Grouping Category

| Property | Type | Default Value | Description |
|----------|------|---------------|-------------|
| Building Group | String | "Building" | Defines the main group name (top-level organization) |
| Storey Group | String | "Building" | Defines the floor/storey group name |
| Element Group | String | "EL_@(Number:PL3;0)" | Defines the naming of the element using format expressions. If no format expression is found, numbering will be incremental. Example: `@(Label)` will name the element with the label property of the source entity |

### Geometry Category

| Property | Type | Default Value | Options | Description |
|----------|------|---------------|---------|-------------|
| Reference Plane | String List | Default | Default, byPanel | Defines the reference plane and type of object. "Default" means the first selected entity defines type and reference plane. "byPanel" uses the first panel (Sip) as reference |
| Contour Mode | String List | Default | Default, Bounding Shadow, Purge Contour | Defines the default contour mode. "Default" allows interactive preview selection. "Bounding Shadow" creates a rectangular bounding box. "Purge Contour" applies blowup/shrink to close finger gaps |
| Blowup + Shrink Value | Double | 0 mm | - | If the appropriate option is chosen, the contour will be blown up and then shrunk by this value, which closes finger gaps in the outline |

### Behaviour Category

| Property | Type | Default Value | Options | Description |
|----------|------|---------------|---------|-------------|
| Add Exclusively | Yes/No | Yes | No, Yes | If "Yes", entities already assigned to another group will be exclusive to the new element. If "No", entities remain associated with existing groups as well |
| Turn off new element | Yes/No | No | No, Yes | If "Yes", the newly created element group will be turned off (hidden) after creation |
| Plugin TSLs | String | (empty) | - | Specifies TSLs to attach to the element. Separate multiple entries with semicolon (;). Each TSL may include a catalog entry using question mark (?). Example: `tslA?Fox ; tslB?Lion` |

## Usage Workflow

### Basic Usage

1. **Start the Command**
   - Run the hsbCreateElement tool from the TSL menu or command line

2. **Select Entities**
   - Select all beams, sheets, panels, and/or collection entities (trusses) that should belong to the new element
   - The first selected entity (unless "byPanel" is chosen) defines Zone 0 and the element's coordinate system

3. **Adjust Element Preview**
   - The tool displays an interactive preview showing:
     - The element contour (cyan/light blue)
     - The coordinate system axes (red=X, green=Y, blue=Z)
     - Zone 0 boundaries
   - Pick a datum point to position the element origin, or press Enter to accept the default

4. **Confirm Creation**
   - Press Enter to confirm and create the element
   - The element is created with automatic zone assignments based on entity positions

### Zone Assignment Logic

- **Zone 0**: Contains entities within the same Z-range as the defining entity (core layer)
- **Positive Zones (1, 2, 3...)**: Layers stacked in the positive Z direction from Zone 0
- **Negative Zones (-1, -2, -3...)**: Layers stacked in the negative Z direction from Zone 0

## Command Line Options

During the interactive preview phase, the following keyboard commands are available:

| Option | Key | Description |
|--------|-----|-------------|
| FlipSide | F | Reverses the Z-axis direction (flips element orientation) |
| Xrotate | X | Rotates the coordinate system 90 degrees around the X-axis |
| Yrotate | Y | Rotates the coordinate system 90 degrees around the Y-axis |
| Zrotate | Z | Rotates the coordinate system 90 degrees around the Z-axis |
| MainReference | M | Select a different reference entity (beam or collection) to define Zone 0 |
| BoundingShadow | B | Creates a rectangular contour from the bounding box of all entities |
| PurgeContour | P | Applies blowup/shrink to the contour to close gaps (prompts for value) |
| drawRectangularContour | R | Draws a rectangular contour by picking two corner points |
| DrawContour | D | Draws a custom polygon contour by picking multiple points |
| AddEntities | A | Add more entities to the selection |
| removeEntities | E | Remove entities from the selection |
| formatText | T | Change the element naming format |

## Practical Examples

### Example 1: Creating a Wall Element

1. Select all studs, plates, and sheathing panels of a wall section
2. The first stud selected becomes the Zone 0 reference
3. Accept the preview or use "F" to flip if the coordinate system is reversed
4. Press Enter to create the wall element

### Example 2: Creating a Roof Element from Trusses

1. Select the truss collection entities and any attached sheathing
2. The truss coordinate system is automatically converted for element use
3. Adjust the contour if needed using "B" for bounding shadow
4. Press Enter to finalize

### Example 3: Multi-Layer Panel with Plugin TSLs

1. Set "Plugin TSLs" property to attach automatic processing scripts
   - Example: `hsbAutoNailer?Standard ; hsbDrawingSetup?RoofPanel`
2. Select all panel layers
3. Create the element - the specified TSLs will be automatically attached

## Tips for Best Results

- **First Selection Matters**: The first entity you select determines Zone 0 and the coordinate system orientation, unless you specify "byPanel" in Reference Plane
- **Use Blowup + Shrink**: For complex outlines with finger joints or small gaps, set this value (e.g., 20mm) to create cleaner contours
- **Exclusive Assignment**: Enable "Add Exclusively" to ensure entities belong to only one element
- **Naming Convention**: Use format expressions like `@(Label)` or `@(Number:PL3;0)` to derive element names from source entity properties

## Related Scripts

- **hsbElementTools**: For modifying existing elements
- **hsbZoneEditor**: For manual zone assignment adjustments
- **hsbElementExport**: For exporting element data

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.5 | 10.01.2023 | Wording improved |
| 2.4 | 05.08.2022 | Major update - new properties for faster and more specific element creation |
| 2.3 | 15.03.2022 | Fixed translation issues for command options |
| 2.2 | 15.09.2021 | Fixed options at the prompt |
| 2.1 | 09.04.2021 | Zone 0 assignment corrected |
| 2.0 | 08.04.2021 | Added DrawContour and createRectangle command line options |
| 1.9 | 08.04.2021 | Added shape modification options during insert, enhanced zone assignment, new preview |
