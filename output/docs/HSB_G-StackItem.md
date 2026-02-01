# HSB_G-StackItem

A TSL script that defines a stack item for organizing and visualizing timber elements in a stacking arrangement. This script creates child items that can be associated with a parent stack (HSB_G-Stack) for prefabrication and logistics planning.

## Script Metadata

| Property | Value |
|----------|-------|
| Version | 1.01 |
| Last Modified | 21.10.2019 |
| Author | Anno Sportel (support.nl@hsbcad.com) |
| Type | O (Object) |
| Beams Required | 0 |

## Script Type

**O-Type (Object)**: This is a standalone object script that creates a visual representation of elements within a stacking system. It does not require beam selection and operates on Element entities instead.

## Description

This script creates a "Hsb_StackingChild" object that:
- Represents an element's position within a stack configuration
- Provides visual feedback showing the element's orientation and position
- Automatically links to a parent stack (HSB_G-Stack) when placed within its boundaries
- Stores relative positioning data for use by MultiElementTools, MapExplorer, and hsbShare

## User Properties

This script uses catalog-based property management. Properties can be loaded from predefined catalogs using the execute key mechanism.

| Property | Type | Description |
|----------|------|-------------|
| Catalog Selection | Dialog | Properties are set via dialog or catalog presets |

Note: The script uses `setPropValuesFromCatalog()` and `setCatalogFromPropValues()` for property management, allowing users to save and recall property configurations.

## Usage Workflow

### Step 1: Insert the Script
1. Run the HSB_G-StackItem command in hsbCAD
2. If no catalog preset is specified, a dialog will appear for configuration

### Step 2: Select Elements
1. When prompted with "Select a set of elements", select one or more Element entities (walls, floors, roofs)
2. The script will create a stacking child instance for each selected element

### Step 3: Position the Stack Items
1. Each stack item is created at a world coordinate position
2. Items are automatically spaced 3000mm apart along the negative Y-axis
3. The visual representation shows the element's bounding box dimensions

### Step 4: Link to Parent Stack
1. If an HSB_G-Stack instance exists in the model, the stack item will automatically detect it
2. When the stack item's origin intersects with a stack body, it becomes a child of that stack
3. The element receives "Hsb_StackingChild" metadata containing:
   - Parent stack UID
   - Relative origin point
   - Relative orientation vectors (X, Y, Z)

### Step 5: Rotate Stack Items (Optional)
1. Double-click on a stack item to rotate it 90 degrees around its X-axis
2. This allows adjusting the stacking orientation of individual elements

## Visual Feedback

The script provides visual indicators:
- **Red axis (Color 1)**: X-direction of the stack item
- **Green axis (Color 3)**: Y-direction of the stack item
- **Blue axis (Color 150)**: Z-direction of the stack item
- **Stacking child body (Color 140)**: Represents the element's volume
- **Element number**: Displayed at the origin point with text height 250mm

## Integration with HSB_G-Stack

This script is designed to work with HSB_G-Stack (the parent stacking script):
- Automatically detects existing stack instances in the model
- Writes "Hsb_StackingChild" submapX data to the element when linked
- Stores coordinate transformation data for export and fabrication workflows

## Context Menu Commands

This script supports the following interaction:

| Command | Trigger | Action |
|---------|---------|--------|
| TslDoubleClick | Double-click on instance | Rotates the stack item 90 degrees around the X-axis |

## Technical Notes

1. **Coordinate System**: The script maintains relative coordinates between the stack item and its parent stack, enabling proper positioning during export
2. **Element Data**: When linked to a stack, the element receives metadata in the "Hsb_StackingChild" submapX including parent UID and relative position/orientation
3. **Catalog System**: Properties can be saved to "_LastInserted" catalog for quick re-use of recent settings
4. **Cleanup**: Any existing "Hsb_StackingChild" data is removed from elements before creating new stack items

## Related Scripts

- **HSB_G-Stack**: Parent stacking script that defines the stack location and boundaries
- **MultiElementTools**: Uses the Hsb_StackingChild format for element organization
- **MapExplorer**: Can read and display stacking child data
- **hsbShare**: Exports stacking information for collaboration

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.00 | 04.04.2019 | First revision |
| 1.01 | 21.10.2019 | Correct name of stack TSL |
