# HSB_I-ShowGroupingInformation

Display grouping relationships and hierarchy information for grouped entities in the current drawing.

## Script Type

**O-Type (Object Script)**

This is a standalone object script that does not require any beams or elements to be pre-selected. It operates on the entire model space to collect and display grouping information.

## Description

This script scans all entities in the current drawing's model space and displays a visual report of grouping relationships. It identifies parent-child relationships between entities that have been grouped using hsbCAD's grouping system (such as Stacking groups).

The script:
1. Collects all entities from the model space
2. Identifies entities marked as "children" in various grouping types (e.g., Stacking)
3. Identifies entities marked as "parents" in grouping hierarchies
4. Sorts children by sequence number and parent UID
5. Displays a formatted text report at the user-selected location

## User Properties

This script has no user-configurable properties in the Properties Palette.

## Usage Workflow

### Step 1: Insert the Script

1. Open the hsbCAD TSL browser or command line
2. Run the script `HSB_I-ShowGroupingInformation`
3. When prompted, click a point in model space where you want the grouping report to appear

### Step 2: Review the Output

The script generates a visual text report at the selected location containing:

- **Header**: "PROJECT GROUPS" title
- **Group Sections**: Each grouping type (e.g., "Stack") with its unique identifier and sequence number
- **Child Entities**: Listed under each group, showing either:
  - Element numbers (for Element entities)
  - Entity handles (for other entity types)

### Step 3: Interpreting Results

The report displays:
- **Grouping Type**: Such as "Stack" for stacking groups
- **Parent UID**: Unique identifier for each group
- **Sequence**: The order/position of the group
- **Child Entities**: Members belonging to each group, displayed in sequence order

## Display Format

The output uses:
- Text height of 100 units (drawing units)
- Row height of 125 units (1.25 x text height)
- Column width of 1000 units (10 x text height)
- Red color (color 1) for group headers
- Default color for child entity names

## Technical Notes

### Grouping Data Structure

The script reads grouping information from entity MapX data:
- **Child markers**: Keys matching pattern `HSB_*CHILD` (e.g., `HSB_StackingCHILD`)
- **Parent markers**: Keys matching pattern `HSB_*PARENT` (e.g., `HSB_StackingPARENT`)

### Supported Grouping Types

The script automatically detects any grouping type that follows the hsbCAD naming convention. The most common type is:
- **Stacking**: Groups of stacked elements (displayed as "Stack" in the report)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.00 | 03.04.2019 | First revision |
| 1.01 | 30.10.2019 | Display sequence |
| 1.02 | 14.09.2020 | Show children in the correct sequence |

## Context Menu Commands

This script has no context menu commands.

## Related Scripts

This script is useful for debugging and understanding grouping relationships created by other hsbCAD tools and scripts that use the grouping system.
