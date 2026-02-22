# hsbScheduleTable

Creates dynamic schedule tables in drawings based on Excel report definitions. This script generates structured data tables that display information about selected CAD entities, supporting beams, elements, hardware, TSL instances, and more.

---

## Overview

The **hsbScheduleTable** script provides a powerful way to create customizable schedule tables directly in your AutoCAD drawings. Tables are generated from Excel-based report definitions stored in your company folder, allowing you to display entity properties in a formatted table layout. The schedule table automatically updates when linked entities change, and supports multiple environments including Model Space, Paper Space viewports, shop drawings, and multipages.

**Key Capabilities:**
- Generate tables from any Excel report definition in your company folder
- Support for beams, elements, TSL instances, hardware collections, and more
- Filter displayed entities using Painter definitions
- Nested report support for hierarchical data (e.g., beams within elements)
- Interactive resizing via grip points with visual feedback
- Color coding and styling options with multiple visual styles
- Export to shop drawings with batch processing support
- Hierarchical header configurations for grouping columns

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Version | 4.1 |
| Works In | Model Space, Paper Space (via Viewport), Shop Drawings, Block Space, Multipages |

---

## Prerequisites

1. **Report Definitions**: Excel report definitions must exist in your company folder. These define the columns, formatting, and data fields for the schedule table.

2. **Painter Definitions** (Optional): If you want to filter which entities appear in the table, configure Painter definitions in your hsbCAD settings.

3. **Dimension Styles**: At least one dimension style must be defined in the drawing for text formatting.

---

## Step-by-Step Usage Guide

### Inserting a New Schedule Table

1. **Launch the Script**
   - Type the command to insert `hsbScheduleTable` or access it from your TSL menu

2. **Select Report Definition**
   - A dialog appears showing all available report definitions from your company folder
   - Reports may have sub-reports (sections); select the specific section or choose "All partial reports" to include all sections
   - Click OK to confirm your selection

3. **Select Entities**
   - **In Model Space**: Select the entities you want to include in the table (beams, elements, TSL instances, hardware, etc.)
   - **In Paper Space**: Select a viewport to reference its visible entities
   - **In Block Space**: Select shop draw viewports to process
   - **With Multipages**: Select a multipage entity to generate tables for its content
   - **With Section2d**: Select a section to clip and display entities within its volume
   - If "Allow selection in XRef" is enabled, you can select entities inside XRefs or blocks

4. **Place the Table**
   - Click to specify the insertion point for the table
   - The table is drawn with the insertion point at the selected corner (controlled by Alignment property)

### Modifying an Existing Schedule Table

**Using Grip Points:**
- **Location Grip**: Drag to move the entire table. A light blue preview shows the new position.
- **End Grip**: Drag to resize the table
  - Drag horizontally to resize column widths (yellow highlight)
  - Drag vertically to resize text height (green highlight)
  - Drag diagonally to scale both proportionally (light blue highlight)
- **Column Grips**: Diamond-shaped grips between columns allow individual column width adjustments

**Using Properties Panel:**
- Select the schedule table and modify properties in the AutoCAD Properties Palette

**Using Right-Click Menu:**
- Right-click on the schedule table to access additional commands

---

## Properties Panel Parameters

### General Category

| Parameter | Type | Description |
|-----------|------|-------------|
| Report Definition | Dropdown | The active report definition. Double-click the table to change. Read-only after insertion. |
| Sub Report | Dropdown | Specific section within the report. Only visible when multiple sections exist. |
| Filter | Dropdown | Painter definition to filter which entities appear in the table. Select "\<Disabled\>" to show all entities. |
| Child Objects Filter | Dropdown | Painter definition to filter child entities (e.g., beams within an element) when using nested reports. |
| Allow selection in XRef | Yes/No | When "Yes", allows selecting entities inside block references or XRefs. Default: No. |

### Display Category

| Parameter | Type | Description |
|-----------|------|-------------|
| Dimstyle | Dropdown | Dimension style controlling text appearance. Uses linear dimension styles from the drawing. |
| Text Height | Length | Text height for table content. Set to 0 to use dimension style default. Default: 100mm. |
| Color | Integer | Table color. Set to 0 to use reference color (ByLayer). |
| Style | Dropdown | Table visual style (see Visual Styles section below). |
| Alignment | Dropdown | Table alignment relative to insertion point: "Bottom" (table grows upward) or "Top" (table grows downward). |

### Page Header Category

| Parameter | Type | Description |
|-----------|------|-------------|
| Page Header | Dropdown | Controls header display: "Main Page Header" (first page only), "All Page Headers" (every page), "None" (no headers). |

---

## Visual Styles

| Style | Description |
|-------|-------------|
| Default | Standard table appearance with grid lines |
| Pattern | Applies alternating pattern to rows |
| Pattern + Highlight 1st column | Alternating rows with emphasized first column |
| Highlight 1st column | First column highlighted for emphasis |

---

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Entities** | Select additional entities to include in the schedule table. |
| **Remove Entities** | Select entities to remove from the schedule table. |
| **Select Report** | Opens dialog to change the report definition. Same as double-clicking the table. |
| **Update Report Definition** | Reloads the report definition from the company folder. Use after modifying the Excel report file. |
| **Specify Header '[SectionName]'** | Opens dialog to configure hierarchical headers for the specified section. Allows custom grouping of columns with spanning headers. |
| **Import Settings** | Imports settings from the XML settings file in the company folder. |
| **Export Settings** | Exports current settings to the XML settings file for future use. |

---

## Hierarchical Headers

The schedule table supports custom hierarchical header configurations that allow you to group columns under spanning header rows. This is useful for organizing complex data tables.

**To configure hierarchical headers:**
1. Right-click the schedule table
2. Select "Specify Header '[SectionName]'" from the context menu
3. In the dialog, define header rows with captions that span multiple columns
4. Empty columns will be condensed, allowing previous headers to span across
5. Headers are positioned centrally over their spanning columns

**Format Arguments:** Header captions support format arguments such as `@(Projectname)` which resolve to corresponding hsbCAD settings properties.

---

## Settings Files

### Settings File Location

The script uses settings stored in:
- **Company Path**: `[Company Folder]\TSL\Settings\hsbScheduleTable.xml`
- **Installation Path** (fallback): `[hsbCAD Install]\Content\General\TSL\Settings\hsbScheduleTable.xml`

### Settings File Purpose

The settings file stores:
- Hierarchical header configurations for specific reports
- Custom column groupings
- Per-report display preferences

### Report Definition Files

Report definitions are Excel files stored in your company folder. They define:
- Column headers and data fields
- Sorting and grouping rules
- Summary calculations (Sum, Count, etc.)
- Data formatting

---

## Supported Entity Types

The schedule table can report on the following entity types:

| Entity Type | Description |
|-------------|-------------|
| GenBeam | Timber beams and members |
| Element | Wall, roof, and floor assemblies (stick frame elements) |
| TslInst | TSL script instances |
| MetalPartCollectionEnt | Hardware collection entities |
| FastenerAssemblyEnt | Fastener assembly entities |
| Sheet | Panel/sheet materials |
| Sip / Panel | Structural insulated panels |
| MasterPanel / ChildPanel | Panel hierarchy components |
| MultiPage | Multipage entities |
| Section2d | 2D section views |
| ShopDrawView | Shop drawing viewports |
| BlockRef | Block references (with nested entity support) |
| StackEntity / StackPack / StackItem | Stack-related TSL entities |
| Opening | Openings within elements |
| NailLine / SawLine | Element processing features |

---

## Hardware Color Coding

Hardware items support color coding through tokenized notes. Include the following tokens in hardware component notes:

| Token | Description |
|-------|-------------|
| `ColorIndex;N` | Sets color index to N |
| `Transparency;N` | Sets transparency percentage (0-100) |
| `Qty;N` or `Quantity;N` | Quantity override |
| `Length;N`, `Width;N`, `Height;N` | Dimension values |
| `Diameter;N` | Diameter value |

Tokens are separated by semicolons in key-value pairs (e.g., `ColorIndex;3;Transparency;50`).

---

## Nested Entity Collection

The schedule table automatically collects nested entities when analyzing parent objects:

- **GenBeam**: Collects connected tools
- **TslInst**: Collects generated beams and attached entities
- **MetalPartCollectionEnt**: Collects beams and nested entities from the collection definition
- **Element**: Collects beams, openings, attached TSL instances, nail lines, and saw lines
- **MasterPanel**: Collects nested child panels and their SIP entities
- **StackEntity/StackPack**: Collects contained packages and items

This nesting behavior enables comprehensive reporting of hierarchical model structures.

---

## Tips and Best Practices

1. **Report Definition Changes**: After modifying an Excel report definition, use "Update Report Definition" from the right-click menu to refresh the table.

2. **Filtering Entities**: Use Painter definitions to filter which entities appear in the table. This is useful when you only want to show certain beam types or specific hardware.

3. **Nested Reports**: For hierarchical data (e.g., showing beams grouped by element), use report definitions that support nesting and configure the "Child Objects Filter" if needed.

4. **Resizing Tips**:
   - Yellow highlight during drag = resizing columns only
   - Green highlight during drag = resizing text height only
   - Light blue highlight during drag = scaling both proportionally
   - Red indicator appears if column width would become invalid

5. **Shop Drawing Integration**: When placed in block space with shop draw viewports, the table automatically generates content for batch shop drawing production.

6. **Performance**: For large selections, the table may take a moment to calculate. Avoid selecting unnecessary entities.

7. **Multipage Behavior**: The table maintains its position relative to the multipage when the page moves, automatically adjusting coordinates.

8. **Empty Tables**: If the table cannot find content (e.g., no matching entities), it will be automatically deleted with a warning message.

---

## Frequently Asked Questions

**Q: Why is my report definition not appearing in the list?**
A: Report definitions must be Excel files stored in the correct company folder location. Verify the file exists and has the proper format.

**Q: Can I edit the table content directly?**
A: No, the table content is generated from the linked entities. To change what appears, modify the entities or use a different report definition.

**Q: How do I update the table after changing entities?**
A: The table updates automatically when linked entities change. If needed, select the table and use the regenerate command.

**Q: Why are some entities missing from my table?**
A: Check the Filter property. If a Painter definition is active, only matching entities will appear. Set to "\<Disabled\>" to show all.

**Q: Can I have multiple schedule tables for different reports?**
A: Yes, you can insert multiple schedule table instances, each with different report definitions and entity selections.

**Q: How do I customize column headers?**
A: Use the "Specify Header" option from the right-click submenu to configure hierarchical headers. For structural changes, modify the Excel report definition.

**Q: The table shows "could not find any definitions" error. What should I do?**
A: This indicates the report definition file is missing or corrupt. Verify the Excel file exists in your company folder and contains valid section definitions.

**Q: Can I use this with XRefs?**
A: Yes, enable "Allow selection in XRef" property to select entities inside block references or XRefs.

**Q: How do I change the report after inserting the table?**
A: Double-click the table or use "Select Report" from the right-click menu to choose a different report definition.

**Q: What happens if I modify the report definition file?**
A: Use "Update Report Definition" from the context menu to reload the changes. The table stores a copy of the definition at insertion time.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.1 | Aug 2025 | Reactivated Alignment property (top/bottom) |
| 4.0 | Jun 2025 | Improved quantity counting for nested metalpart items |
| 3.9 | Mar 2025 | Improved hardware color and transparency drawing |
| 3.8 | Feb 2025 | Property 'Number' resolves as integer or text |
| 3.7 | Jan 2025 | Hardware supports queries (= and !=), summary type added for hardware |
| 3.6 | Jan 2025 | Analysed drill parameters appended |
| 3.5 | Dec 2024 | Batch shop drawing support |
| 3.4 | Dec 2024 | Additional header overrides, context menu for headers |
| 3.3 | Dec 2024 | Multipage support, block space creation, resize/move grips |
| 3.2 | Nov 2024 | Block reference support, XRef nested selection |
| 3.1 | Nov 2024 | Debug message removed |
| 3.0 | Nov 2024 | Accepting modelDescription/model of TSLs, sequential colors for dependent entities |
| 2.9 | Nov 2024 | FastenerAssemblyEnt support added |
| 2.8 | Oct 2024 | Nested reports extended |
| 2.7 | Oct 2024 | Nested reports based on elements and TSLs supported, custom hierarchical headers via settings |
| 2.6 | Sep 2024 | Accepts entities referenced by stack objects |
| 2.5 | Sep 2024 | Use buffered report if definition not found in company folder |
| 2.4 | Sep 2024 | Additional property export of hardware components via notes |
| 2.3 | Aug 2024 | Summarized hardware supports color coding via tokenized notes |
| 2.2 | Jun 2024 | Implicit summary type function for metalPartCollections |
| 2.1 | Mar 2024 | Erase instance in shopdraw if invalid data |
| 2.0 | Feb 2024 | Bugfix duplicated quantity of element genbeam lists |
| 1.0 | Oct 2023 | Initial version |
