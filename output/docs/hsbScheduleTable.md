# hsbScheduleTable

## Description

The **hsbScheduleTable** script creates a schedule table in your drawing based on Excel report definitions. It allows you to select entities (beams, elements, hardware, panels, etc.) and generate a formatted table displaying their properties according to a predefined report template.

This tool is ideal for creating material lists, cut lists, hardware schedules, or any tabular summary of your timber construction components directly within the CAD environment.

## Script Type

**O-Type (Object Script)** - This script operates as an independent object that can be inserted anywhere in your drawing. It does not require pre-selected beams.

## Version

**Version 4.1** (August 2025)

## Key Features

- Creates schedule tables based on Excel report definitions from your company folder
- Supports multiple entity types: beams, elements, sheets, panels, hardware, TSL instances, and metal part collections
- Works in Model Space, Paper Space (viewports), and Block Space (shop drawings)
- Supports nested entity selection (XRef/Block references)
- Customizable display styles with color coding
- Interactive grip points for resizing and repositioning
- Hierarchical nested reports based on elements and TSL instances
- Custom header definitions via settings files

## Properties

### General Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Report Definition** | List | (first available) | Selects the Excel report definition to use for the table layout. Reports are loaded from your company folder. |
| **Sub Report** | List | (none) | When a report contains multiple sections, allows selection of a specific section or "All partial reports". |
| **Filter** | List | (none) | Applies a Painter Definition filter to include only specific entity types in the table. |
| **Child Objects Filter** | List | (none) | Filters child items within parent containers (e.g., specific beams within an element). |
| **Allow selection in XRef** | Yes/No | No | When set to "Yes", allows selecting entities that are nested inside Block References or XRefs. |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Dimstyle** | List | (drawing default) | Sets the dimension style for table text appearance. |
| **Text Height** | Length | 100 mm | Sets the height of table text. Enter 0 to use the Dimstyle default. |
| **Color** | Integer | 0 | Sets the table color. Enter 0 to use the reference entity's color. |
| **Style** | List | Default | Table appearance style: "Default", "Pattern", "Pattern + Highlight 1st column", or "Highlight 1st column". |
| **Alignment** | List | Bottom | Determines whether the table grows upward ("Top") or downward ("Bottom") from the insertion point. |

### Page Header Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Page Header** | List | Main Page Header | Controls header visibility: "Main Page Header", "All Page Headers", or "None". |

## Usage Workflow

### Basic Insertion

1. Start the script using the command or ribbon button
2. Select a report definition from the dialog (shows all reports and their sub-sections)
3. Click OK to confirm the report selection
4. Select the entities you want to include in the table (beams, elements, panels, etc.)
5. Specify the insertion point for the table
6. The schedule table is generated and displayed

### Working with Viewports (Paper Space)

1. Switch to a Layout tab (Paper Space)
2. Insert the script
3. When prompted, select the viewport that contains the entities to report
4. The table will list entities visible in that viewport

### Working with Shop Drawings (Block Space)

1. Open the block containing shop draw viewports
2. Insert the script
3. Select the shop draw viewport(s) to report on
4. Specify the table insertion point

### Modifying Selected Entities

After insertion, you can add or remove entities from the table using the context menu commands.

## Context Menu Commands

Right-click on an existing hsbScheduleTable to access these commands:

| Command | Description |
|---------|-------------|
| **Add Entities** | Prompts you to select additional entities to include in the table. |
| **Remove Entities** | Prompts you to select entities to remove from the table. |
| **Select Report** | Opens a dialog to change the report definition (also triggered by double-click). |
| **Update Report Definition** | Reloads the report definition from the company folder to apply any changes made to the Excel template. |
| **Specify Header** | Allows custom header text overrides for specific report sections. |
| **Import Settings** | Loads table settings from an XML file. |
| **Export Settings** | Saves current table settings to an XML file. |

## Grip Points

The schedule table provides interactive grip points for adjustment:

- **Corner grips**: Drag horizontally to resize column widths, vertically to resize text height, or diagonally to scale both proportionally
- **Column divider grips**: Adjust individual column widths

## Supported Entity Types

The schedule table can report on:

- **GenBeam / Beam**: Timber members with all standard properties
- **Element**: Wall, floor, and roof elements (with nested contents)
- **Sheet**: Panel/sheet materials
- **Sip / MasterPanel**: Structural insulated panels and CLT panels
- **TslInst**: TSL script instances with their custom properties
- **MetalPartCollectionEnt**: Hardware collections
- **HardwareComponent**: Individual hardware items (fasteners, connectors)
- **FastenerAssemblyEnt**: Fastener assembly entities
- **BlockRef**: AutoCAD block references (when nested selection is enabled)

## Report Definitions

Report definitions are Excel files stored in your company folder. Each report defines:

- **Columns**: Which properties to display and their order
- **Headers**: Column header text and formatting
- **Sorting**: Default sort order for rows
- **Grouping**: How to group and summarize data
- **Formatting**: Number formats, units, and rounding

Contact your CAD administrator to create or modify report definitions.

## Tips

- Use the **Filter** property to quickly switch between different entity types without re-selecting
- The **Update Report Definition** command is useful when you have modified the Excel template and want to see the changes immediately
- For large selections, consider using Element selection rather than individual beam selection for better performance
- Column widths are automatically calculated based on content but can be manually adjusted using grip points
- Tables automatically update when referenced entities are modified

## Related Scripts

- **hsbExcel** - Exports data to Excel format
- **Painter Definitions** - Create filters for entity selection

## Technical Notes

- Script file: `hsbScheduleTable.mcr`
- Settings path: `TSL\Settings\` in company or install folder
- Report definitions path: Company folder (uses hsbExcel.dll for report processing)
