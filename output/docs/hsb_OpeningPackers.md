# hsb_OpeningPackers

## Description

This script creates sheeting (reveal boards) at the inside of openings in timber frame walls. The script provides flexible positioning options allowing you to define which sides of the opening receive boards and where they align within the wall zones.

Since version 1.3, the script can also create covering boards that sit in front of the opening rather than inside the reveal.

The script can be used in two ways:
1. **Manually** - by selecting openings directly in the drawing
2. **Automatically** - by attaching it to elements or openings through wall details

## Script Type

- **Type**: O (Object)
- **Version**: 1.8
- **Beams Required**: 0

## Properties

### Sheet Definition

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Insert as | String | Packer | Defines the position of the boards. **Packers** are placed inside the opening reveal. **Covering boards** cover the opening from the outside. |
| Width | String | 100 | Defines the width of the board in mm. Use a single value for all boards, or use semicolon-separated values (top;bottom;right;left) for independent widths per side. |
| Thickness | String | 20 | Defines the thickness of the board in mm. Use a single value for all boards, or use semicolon-separated values (top;bottom;right;left) for independent thicknesses per side. |
| Gap at the ends | String | (empty) | Defines the gap at the end of each sheet in mm. Use a single value for all ends, or use semicolon-separated values (top;bottom;right;left) for individual gaps. |
| Gap to opening | String | (empty) | Defines the gap between the sheet and the opening edge in mm. Use a single value for all sides, or use semicolon-separated values (top;bottom;right;left) for individual gaps. |
| Sheet properties | String | (empty) | Sets sheet properties using semicolon-separated values: ColourIndex;Name;Material;Grade;Information;Label;SubLabel;Beamcode. Example: `2;Packer;OSB; ;on site` |
| Assign to zone | Integer | 0 | Defines the zone where the sheets are assigned to (range: -5 to 5). |

### Sheet Position

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Zone to align sheet to | Integer | 0 | Defines the zone the sheet aligns to. Negative zones align to outside, positive zones align to inside. Zone 6 is a special value for the furthest inside position. Range: -5 to 6. |
| Offset to zone | Double | 0 | Defines the offset from the alignment zone in wall Z direction (positive = towards outside). |
| Create a vertical sheet(s) | String | Both | Controls which vertical sheets to create: None, Left, Right, or Both. |
| Create a horizontal sheet(s) | String | Both | Controls which horizontal sheets to create: None, Bottom, Top, or Both. |
| Reference | String | Construction | Defines the reference for packer positioning. **Construction** uses the closest beams to the opening. **Opening** uses the outside of the opening itself. |
| Ignore parallel beams | String | No | When Reference is set to Construction, determines whether parallel beams should be considered when finding reference points. |

### Behavior of TSL Instance

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Delete TSL after insertion | String | No | Defines whether the TSL instance stays in the drawing after creating the sheets, or is deleted afterwards. |

## Usage Workflow

### Manual Insertion

1. Run the script command to start the insertion process
2. A dialog appears allowing you to configure all properties or select a saved catalog entry
3. Click OK to confirm the settings
4. Select one or more openings in your drawing
5. The script creates packer/covering boards on each selected opening based on your settings
6. If "Delete TSL after insertion" is set to Yes, the script instance is removed; otherwise it remains linked to the opening

### Automatic Application via Element Details

1. Attach the script to elements or openings using wall details in hsbCAD
2. When the element is calculated, the script automatically runs and creates sheets on all openings
3. If an element contains multiple openings, the script clones itself to handle each opening separately

### Editing Existing Packers

1. Select an existing hsb_OpeningPackers instance in the drawing
2. Modify properties in the AutoCAD Properties Palette (OPM)
3. The sheets update automatically when the element recalculates

## Property Value Formats

### Semicolon-Separated Values

For Width, Thickness, Gap at the ends, and Gap to opening properties, you can specify individual values for each side:

- **Single value**: `100` - applies to all sides
- **Four values**: `80;100;80;100` - applies as top;bottom;right;left

### Sheet Properties Format

The Sheet properties field accepts semicolon-separated values in this order:

```
ColourIndex;Name;Material;Grade;Information;Label;SubLabel;Beamcode
```

Example: `2;Packer;OSB; ;on site;;`

- Use a blank space ` ` for empty values that need to be skipped
- Trailing empty values can be omitted

## Tips

- Use the **Reference** property to control whether packers align to the framing members (Construction) or the opening geometry (Opening)
- When using Construction reference with complex framing, enable **Ignore parallel beams** to skip studs or blocking that run parallel to the opening edge
- Zone 6 is useful when you need sheets aligned to the furthest inside position regardless of element configuration
- The script displays a text label and connection line in the drawing to help identify the associated opening

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.8 | 21.02.2023 | Bugfix: ignore parallel beams |
| 1.7 | 16.02.2023 | Bugfix: wait for genBeam of elements |
| 1.6 | 12.02.2023 | Await element construction and add properties to define base points |
| 1.5 | 22.06.2021 | Assign text to layer "T" (not printable) |
| 1.4 | 15.01.2021 | Add mapIo support |
| 1.3 | 21.06.2020 | Add option for covering boards |

## Keywords

opening, packer, reveal board, covering board
