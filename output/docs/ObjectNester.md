# ObjectNester

## Description

The **ObjectNester** script creates an optimized nesting layout for ObjectClone instances within a defined rectangular master area. This tool is essential for material optimization in timber construction, particularly for arranging CLT panels, sheet materials, or other prefabricated components on raw material sheets for cutting.

The script automatically arranges selected clone objects to maximize material utilization (yield), displays collision detection for overlapping items, and can create additional nesting sheets when items do not fit within the current master area.

**Prerequisite**: This script requires the **ObjectClone** TSL script to be available in the drawing. ObjectClone instances represent the items to be nested.

## Script Type

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Beams Required | 0 |
| Version | 1.6 |

## Properties

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Number | Integer | 0 | Unique identifier for the nester. When set to 0, the next available number starting from 1 is automatically assigned. When changed to an existing number, affected nesters are renumbered to preserve the sequence. |
| Length | Double | 10000 mm | Defines the length (X-direction) of the master nesting area. |
| Width | Double | 3000 mm | Defines the width (Y-direction) of the master nesting area. |
| Oversize Format Cut | Double | 0 mm | Defines the outer offset (margin) of the raw master. Items are nested within the area reduced by this oversize value. |
| Nester | String | Rectangular Nester | Selects the nesting algorithm. Options: **Rectangular Nester** (uses hsbCAD's rectangular nesting engine) or **Object Nester** (custom row-based nesting for items of uniform height). |

### Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| X-Gap | Double | 0 mm | Defines the horizontal gap between individual nested objects. |
| Y-Gap | Double | 0 mm | Defines the vertical gap between individual nested objects. |
| Alignment | String | Unchanged | Controls the orientation of nested objects within the master. Options: **Unchanged**, **+Z**, **-Z**, **+Y**, **-Y**. Changing alignment transforms the ObjectClone instances accordingly. |

### Filter

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Filter | String | (Disabled) | Selects a Painter Definition to filter and order objects for nesting. Painter definitions from the "TSL\ObjectClone\" collection are available. |
| Sorting | String | Ascending | Determines the order of nested objects based on the filter. Options: **Ascending** or **Descending**. |

### Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Format | String | Yield @(Yield)\n@(Height) | Defines the text format displayed at the nester header. Supports formatting placeholders like @(Yield) and @(Height). |
| Dimstyle | String | (from drawing) | Selects the dimension style for text display. |
| Text Height | Double | 100 mm | Defines the text height for the header display. Set to 0 to use the dimension style default. |

### Nester Range (via Settings Dialog)

These properties are accessible through the **Settings** context menu command:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Min X-Range | Double | 6300 mm | Defines the required minimum X-range of the nester (for validation display). |
| Min Y-Range | Double | 860 mm | Defines the required minimum Y-range of the nester (for validation display). |
| Color | Integer | 150 | Defines the color of the minimum range indicator when objects do not fill the required area. |
| Transparency | Integer | 60 | Defines the transparency of the minimum range indicator. |

## Usage Workflow

### Inserting a New Nester

1. **Start the command**: Use the hsbCAD Script Insert command or type `hsb_ScriptInsert "ObjectNester"` at the command line.

2. **Configure properties**: A dialog appears allowing you to set the nester parameters (Length, Width, Nester type, etc.).

3. **Select clone objects**: When prompted with "Select clone objects", select the ObjectClone instances you want to nest. Only valid ObjectClone TSL instances will be accepted.

4. **Place the nester**: Click to specify the insertion point (origin) of the nesting area.

5. **Automatic nesting**: The script automatically arranges the selected objects within the master area. If items do not fit, additional nester instances are created automatically.

### Modifying an Existing Nester

- **Resize**: Use the grip points on the right edge (X-direction) and top edge (Y-direction) to interactively resize the nesting area.

- **Move**: Drag the circular grip at the lower-left corner to relocate the entire nester along with all nested objects.

- **Edit properties**: Select the nester and modify properties in the AutoCAD Properties Palette (OPM). Changes to Sorting, Filter, Gaps, or Alignment automatically trigger re-nesting.

- **Double-click**: Double-clicking on the nester triggers the nesting operation to recalculate.

### Understanding the Display

- **Yield percentage**: Displayed in the header, shows the material utilization (nested area / master area).

- **Height**: Displays the visible height of the nested objects (all objects in one nester must have the same height).

- **Red collision areas**: If nested objects overlap, the collision zones are highlighted in red.

- **Minimum range indicator**: A semi-transparent rectangle appears when nested content does not fill the required minimum range area.

## Context Menu Commands

Right-click on the ObjectNester to access these commands:

| Command | Description |
|---------|-------------|
| **Nesting** | Manually triggers the nesting calculation. Useful after making external changes to ObjectClone instances. |
| **Add Objects** | Prompts to select additional ObjectClone instances to include in this nester. |
| **Remove Objects** | Prompts to select ObjectClone instances to remove from this nester. After selection, prompts for a new location where removed objects will be placed. |
| **Settings** | Opens a dialog to configure the minimum range display settings (Min X-Range, Min Y-Range, Color, Transparency). |
| **Import Settings** | Loads nester settings from the XML configuration file located at `[Company Path]\TSL\Settings\ObjectClone.xml`. |
| **Export Settings** | Saves current settings to the XML configuration file. Prompts for confirmation if the file already exists. |

## Nesting Algorithms

### Rectangular Nester

Uses hsbCAD's built-in rectangular nesting engine. This algorithm:
- Attempts to fit all objects optimally within the master area
- Respects gap settings between objects
- Supports rotation allowance for objects
- Creates additional nester instances for leftover items that do not fit

### Object Nester

A row-based nesting approach that:
- Groups objects by their visible height (only objects with identical height are nested together)
- Arranges objects in rows, filling each row before starting the next
- Orders objects by length (longest first) for optimal packing
- Automatically creates separate nesters for objects with different heights
- Creates additional nesters for items that exceed the available space

## Tips for Timber Designers

1. **Material optimization**: Use the Yield percentage to evaluate material utilization. Adjust the master Length and Width to match your available raw material dimensions.

2. **Production planning**: The automatic numbering system helps track multiple nesting sheets. Numbers are preserved when copying nesters.

3. **Consistent heights**: When using the Object Nester algorithm, ensure your ObjectClone items have consistent visible heights for proper grouping.

4. **Gap settings**: Set appropriate X-Gap and Y-Gap values to account for saw blade kerf or material handling requirements.

5. **Filter and sorting**: Use Painter Definitions to filter specific object types or to control the nesting order based on material properties.

6. **Settings persistence**: Export your preferred settings to share across projects or team members.

## Related Scripts

- **ObjectClone**: Required companion script that creates the clonable objects to be nested.
- **Painter Definitions**: Configure filters in the "TSL\ObjectClone\" collection to control object selection and ordering.

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.6 | 30.10.2024 | Added settings for minimal range and new display of minimal range |
| 1.5 | 18.09.2023 | Adjust transformation when alignment changes |
| 1.4 | 01.08.2023 | Enhanced to accept uniform visible height and uniform width per row, supports grip-based dragging |
| 1.3 | 24.07.2023 | Polyline dependency removed, new grips to modify size, only one unique height per nesting |
| 1.2 | 07.07.2023 | Parent/child grouping fixed |
| 1.1 | 05.07.2023 | Supports parent/child grouping |
| 1.0 | 22.06.2023 | Initial version |
