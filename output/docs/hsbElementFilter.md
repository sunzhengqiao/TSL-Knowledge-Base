# hsbElementFilter

## Description

The **hsbElementFilter** script is used to set up element filters in hsbCAD. These filters allow you to include or exclude specific elements (walls, floors, roofs, etc.) based on their type. The filtered results can then be used by other TSL scripts that rely on element selections.

This is a utility script designed to streamline workflows when working with multiple elements of different types, allowing you to quickly filter down to only the elements you need.

## Script Information

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 1.01 |
| Last Modified | 21.10.2015 |
| Author | Anno Sportel |

## Properties

The following properties are available in the AutoCAD Properties Palette when this script is active:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Enabled** | String (True/False) | True | Specifies whether the filter is enabled. When set to False, the script will not apply any filtering. |
| **Operation element filter** | String (Exclude/Include) | Exclude | Determines the filter behavior: **Exclude** removes elements matching the filter criteria from your selection; **Include** keeps only elements matching the filter criteria. |
| **Filter element types** | String (Dropdown) | None | The element type criteria used to filter elements. Options are populated from the ElementTypes dictionary and may include single types or combinations (e.g., "Wall", "Wall;Floor"). |

## How It Works

### Filter Operations

- **Exclude Mode**: Removes all elements that match the selected element type(s) from your selection. Use this when you want to work with everything except certain element types.

- **Include Mode**: Keeps only the elements that match the selected element type(s). Use this when you want to work with specific element types only.

### Element Types

The available element types are loaded from a system dictionary called "ElementTypes". The script automatically generates all possible combinations of these types, allowing you to filter by multiple element types at once (e.g., filter for both Walls and Floors simultaneously).

## Usage Workflow

### Interactive Selection Mode

1. **Start the script**: Run the hsbElementFilter command or insert the script into your drawing.

2. **Configure filter settings**: A dialog will appear where you can set:
   - Whether the filter is enabled
   - The operation mode (Include or Exclude)
   - Which element type(s) to filter by

3. **Select elements**: After configuring the filter, you will be prompted to select elements in your drawing.

4. **Filter applied**: The script automatically filters your selection based on your settings and passes the valid elements to the `_Element` array for use by other scripts.

### Map IO Mode (Script-to-Script Communication)

When called by another script via Map IO:

1. The calling script passes an array of elements via the `_Map` object under the key "Elements".

2. hsbElementFilter applies the configured filter criteria.

3. The filtered results are written back to the `_Map` object, replacing the original array.

This mode is useful for automated workflows where element filtering needs to happen without user interaction.

## Catalog Support

The script supports catalog presets. If a valid catalog entry name is provided via `_kExecuteKey`, the script will automatically load property values from that catalog entry. This allows you to create reusable filter configurations.

## Typical Use Cases

- **Wall-only operations**: Set operation to "Include" and filter element types to "Wall" to work only with wall elements.

- **Exclude floors from selection**: Set operation to "Exclude" and filter element types to "Floor" to remove all floor elements from your selection.

- **Multi-type filtering**: Filter for multiple types simultaneously (e.g., "Wall;Roof") to include or exclude several element types at once.

- **Automated workflows**: Use as a pre-filter step in larger automated processes where specific element types need to be processed differently.

## Notes

- If the ElementTypes dictionary is not found or is empty, a warning message will be displayed.
- When the filter is disabled (Enabled = False), the script erases itself without processing.
- The script erases itself after processing in interactive mode, leaving only the filtered selection results.
- Debug messages can be enabled for troubleshooting filter behavior.

## Related Scripts

This script is designed to work with other TSL scripts that require element selections. It acts as a pre-processor to ensure only the appropriate elements are passed to subsequent operations.
