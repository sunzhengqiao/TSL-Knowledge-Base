# HSB_G-ProjectGrouping

Assign group information to elements for batch processing, stacking, or truck loading organization.

## Script Type

**O-Type (Object Script)** - This is a standalone object that can be inserted into model space without requiring pre-selected beams or other entities. It operates on elements you select during insertion.

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.00 | 31.01.2019 | First revision |
| 1.01 | 31.01.2019 | Trigger show group info TSL |
| 1.02 | 31.01.2019 | Correct typo in group |
| 1.03 | 01.04.2019 | Support different grouping types |
| 1.04 | 21.05.2019 | Trigger new show group info TSL |
| 1.05 | 31.10.2019 | Remove padding of group name |
| 1.06 | 09.12.2021 | Recalc all grouping info TSLs in the drawing |

## User Properties

| Property | Type | Default | Options | Description |
|----------|------|---------|---------|-------------|
| Group type | String (Dropdown) | Batch | Batch, Stacking, Truck | Select the standard grouping category for organizing elements |
| Custom group type | String (Dropdown) | (empty) | (empty), SalesOrder | Optional custom grouping type that overrides standard type if set |
| Group name | String | (empty) | User-defined | The identifier/name for this group assignment |

## Purpose

This script allows you to organize hsbCAD elements (walls, floors, roofs) into logical groups for:

- **Batch** - Grouping elements for batch production or processing
- **Stacking** - Organizing elements for stacking order in the factory
- **Truck** - Assigning elements to specific truck loads for delivery
- **SalesOrder** - Custom grouping by sales order (when using custom group type)

## Usage Workflow

### Step 1: Insert the Script

1. Run the script command `HSB_G-ProjectGrouping`
2. A dialog will appear automatically with the grouping options

### Step 2: Configure Group Settings

1. **Group type**: Select from the dropdown:
   - `Batch` - For production batch organization
   - `Stacking` - For factory stacking sequence
   - `Truck` - For delivery truck assignment

2. **Custom group type** (optional): If you need a custom category like `SalesOrder`, select it here. When a custom type is selected, it overrides the standard group type.

3. **Group name**: Enter the group identifier (e.g., "Batch-001", "Truck-A", "Stack-03")

### Step 3: Select Elements

After confirming the dialog:
1. The command line will prompt: "Select elements"
2. Select the wall, floor, or roof elements you want to assign to this group
3. Press Enter to confirm the selection

### Step 4: Automatic Updates

Once elements are assigned:
- The group information is stored in each element's metadata
- Any `HSB_I-ShowGroupingInformation` or `Batch & Stack Info` TSL instances in the drawing are automatically recalculated to display updated grouping information

## Technical Details

### Data Storage

The script stores group information in each selected element using the key format:
- `Hsb_BatchChild` (for Batch type)
- `Hsb_StackingChild` (for Stacking type)
- `Hsb_TruckChild` (for Truck type)
- `Hsb_SalesOrderChild` (for SalesOrder custom type)

Each element receives a `ParentUID` value matching the Group name you specified.

### Related Scripts

This script works in conjunction with:
- `HSB_I-ShowGroupingInformation` - Displays grouping information visually
- `Batch & Stack Info` - Alternative grouping information display

## Notes

- The script can only be inserted once per action (multiple insertions are blocked)
- Group names are stored without padding for cleaner data handling
- When the script runs, it automatically triggers recalculation of all grouping information display TSLs in the drawing
