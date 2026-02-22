# HSB_G-BillOfMaterial

## Overview

**HSB_G-BillOfMaterial** is a shop drawing script that generates a customizable Bill of Material (BOM) table for hsbCAD elements displayed in a viewport. The script collects information about beams, sheets, SIPs (Structural Insulated Panels), TSL instances with BOM data, and Mass Groups from the selected viewport or a specified group, then displays this data in a formatted table on your drawing.

The table position can be adjusted per element using grip points, and similar items are automatically grouped with quantity counts. The script supports extensive filtering, sorting, and styling options to customize the output to your specific requirements.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Environment | Paper Space (Layout) |
| Viewport Required | Yes |
| Version | 3.2 |
| Keywords | BOM |

---

## Prerequisites

Before using this script, ensure:

1. You have an hsbCAD element (wall, floor, or roof) created in Model Space
2. A Paper Space layout with a viewport displaying the element is set up
3. The viewport is properly linked to the element you want to document

---

## Step-by-Step Usage Guide

### Inserting the Bill of Material

1. **Switch to Paper Space** (Layout tab)

2. **Run the script** using the hsbCAD script insertion command

3. **Select a viewport** when prompted with "Select a viewport"
   - Click on the viewport that contains the element you want to create a BOM for

4. **Select a position** when prompted with "Select a position"
   - Click where you want the table to be placed on your layout

5. **A dialog appears** allowing you to configure initial settings
   - Adjust properties as needed and confirm

6. **The BOM table is generated** at your selected position

### Repositioning the Table

1. **Select the BOM instance** in Paper Space

2. **Use the grip point** to drag the table to a new location

3. Alternatively, use the **Right-Click Menu** options:
   - "Reset location" - Resets the table position for the current element
   - "Reset location for all elements" - Resets positions for all elements

### Filtering Content

The script supports powerful filtering capabilities using the Filter properties:

- **Wildcards supported**: Use `*` for pattern matching
  - `STUD*` matches STUD, STUDS, STUD-1, etc.
  - `*PLATE*` matches TOP-PLATE, PLATE-BOTTOM, PLATES, etc.
  - `*BEAM` matches END-BEAM, CROSS-BEAM, etc.

- **Multiple filters**: Separate values with semicolons (`;`)
  - Example: `STUD;PLATE;HEADER` filters for all three beamcodes

---

## Properties Panel Parameters

### Filter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Include/exclude | Dropdown | Include | Choose whether filters include or exclude matching items |
| Filter beams with beamcode | Text | (empty) | Filter by beam code (supports wildcards and semicolon-separated values) |
| Filter objects with label | Text | (empty) | Filter by label |
| Filter objects with material | Text | (empty) | Filter by material name |
| Filter objects with hsb id | Text | (empty) | Filter by hsbCAD ID |
| Filter objects with name | Text | (empty) | Filter by object name |

### Content Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Use group selection box | Yes/No | No | Use a named group instead of viewport element |
| Group | Dropdown | (list) | Select which group to use (when group selection is enabled) |
| Beams | Show/Hide | Show | Include beams in the BOM |
| Sheeting zone 1-10 | Show/Hide | Show | Include sheets from specific zones (1-5 positive side, 6-10 negative side) |
| Sips | Show/Hide | Show | Include SIP panels in the BOM |
| Tsls | Show/Hide | Show | Include TSL instances with BOM data |
| Mass Groups | Show/Hide | Show | Include Mass Groups in the BOM |

### Properties/columns Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number | Show/Hide | Show | Display position number column |
| Zone index | Show/Hide | Show | Display zone index column |
| Name | Show/Hide | Show | Display name column |
| Beamcode | Show/Hide | Show | Display beamcode column |
| Beamtype | Show/Hide | Show | Display beamtype column |
| Modulename | Show/Hide | Show | Display module name column |
| Label | Show/Hide | Show | Display label column |
| Sublabel | Show/Hide | Show | Display sublabel column |
| Sublabel 2 | Show/Hide | Show | Display sublabel 2 column |
| Width | Show/Hide | Show | Display width column |
| Height | Show/Hide | Show | Display height column |
| Length | Show/Hide | Show | Display length column |
| Netto width | Show/Hide | Hide | Display netto (solid) width column |
| Netto height | Show/Hide | Hide | Display netto (solid) height column |
| Netto length | Show/Hide | Hide | Display netto (solid) length column |
| Material | Show/Hide | Show | Display material column |
| Grade | Show/Hide | Show | Display grade column |
| Information | Show/Hide | Show | Display information column |
| Angle Neg | Show/Hide | Show | Display negative cut angle column |
| Angle Pos | Show/Hide | Show | Display positive cut angle column |
| Quantity | Show/Hide | Show | Display quantity column |
| Description | Show/Hide | Hide | Display description column |

### Sorting Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Primary sortkey | Dropdown | Number | First sorting criterion |
| Secondary sortkey | Dropdown | Number | Second sorting criterion |
| Tertiary sortkey | Dropdown | Number | Third sorting criterion |
| Quaternary sortkey | Dropdown | Number | Fourth sorting criterion |
| Sort mode | Dropdown | Ascending | Sort direction (Ascending/Descending) |

**Available Sort Keys**: Number, Zone index, Name, Beamcode, Beamtype, Module, Label, Sublabel, Sublabel 2, Width, Height, Length, Netto width, Netto height, Netto length, Material, Grade, Information, Angle Neg, Angle Pos, X Position in viewport, Y Position in viewport, Description, Quantity

### Style Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | Dropdown | (current) | Dimension style for text formatting |
| Text size | Number | -1 | Custom text height (-1 uses dimension style default) |
| Margin | Length | 2 mm | Cell padding/margin |
| Draw grid lines | Yes/No | Yes | Show table grid lines |
| Draw headers when empty | Yes/No | Yes | Show column headers even when table is empty |
| Linecolor | Color | -1 | Table grid line color (-1 uses ByLayer) |
| Textcolor: column header | Color | 5 | Header text color |
| Textcolor: content | Color | -1 | Content text color (-1 uses ByLayer) |
| Alignment: column header | Dropdown | Left | Header text alignment (Left/Center/Right) |
| Alignment: content | Dropdown | Left | Content text alignment (Left/Center/Right) |
| Rounding option | Dropdown | Keep existing | Rounding behavior (Keep existing/Round downwards/Round upwards) |

### Miscellaneous Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reference point | Dropdown | Top-Right | Table anchor point (Top-Left/Top-Right/Bottom-Left/Bottom-Right) |
| Rotate table | Angle | 0 | Table rotation angle in degrees |
| Precision | Integer | 0 | Decimal places for dimension values |
| Precision for angles | Integer | 2 | Decimal places for angle values |
| Units | Dropdown | Decimal | Unit format for dimensions |
| Sequence sheet sizes | Dropdown | Keep existing | How to order sheet dimensions (Height/width/length or Width/height/length) |

### Title Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Table title | Text | (empty) | Optional title displayed above the table |
| Draw header grid | Yes/No | Yes | Draw grid around title row |

### Headers Category

Allows customization of all column header text. Each column has a corresponding "Header" property:

| Parameter | Default Value |
|-----------|---------------|
| Header number | NUMBER |
| Header zone index | ZONE INDEX |
| Header name | NAME |
| Header beamcode | BEAMCODE |
| Header beamtype | BEAMTYPE |
| Header modulename | MODULE |
| Header label | LABEL |
| Header sublabel | SUBLABEL |
| Header sublabel 2 | SUBLABEL 2 |
| Header width | WIDTH |
| Header height | HEIGHT |
| Header length | LENGTH |
| Header netto width | NETTO WIDTH |
| Header netto height | NETTO HEIGHT |
| Header netto length | NETTO LENGTH |
| Header material | MATERIAL |
| Header grade | GRADE |
| Header information | INFORMATION |
| Header angle neg. | ANGLE NEG |
| Header angle pos. | ANGLE POS |
| Header quantity | QUANTITY |
| Header description | DESCRIPTION |

### Column indexes Category

Control the display order of columns by assigning index values (lower numbers appear first):

| Parameter | Default | Description |
|-----------|---------|-------------|
| Column index number | 100 | Order position for Number column |
| Column index zone index | 100 | Order position for Zone Index column |
| Column index name | 100 | Order position for Name column |
| Column index beamcode | 100 | Order position for Beamcode column |
| Column index beamtype | 100 | Order position for Beamtype column |
| Column index module | 100 | Order position for Module column |
| Column index label | 100 | Order position for Label column |
| Column index sublabel | 100 | Order position for Sublabel column |
| Column index sublabel 2 | 100 | Order position for Sublabel 2 column |
| Column index width | 100 | Order position for Width column |
| Column index height | 100 | Order position for Height column |
| Column index length | 100 | Order position for Length column |
| Column index netto width | 100 | Order position for Netto Width column |
| Column index netto height | 100 | Order position for Netto Height column |
| Column index netto length | 100 | Order position for Netto Length column |
| Column index material | 100 | Order position for Material column |
| Column index grade | 100 | Order position for Grade column |
| Column index information | 100 | Order position for Information column |
| Column index angle neg. | 100 | Order position for Angle Neg column |
| Column index angle pos. | 100 | Order position for Angle Pos column |
| Column index description | 100 | Order position for Description column |
| Column index quantity | 100 | Order position for Quantity column |

---

## Right-Click Menu Options

| Option | Description |
|--------|-------------|
| Reset location | Resets the table position for the current element to the default location |
| Reset location for all elements | Resets table positions for all elements in the drawing |

---

## Settings Files

This script does not use external XML settings files. All configuration is stored within the script instance properties.

---

## Tips

1. **Grouping identical items**: The script automatically groups items with identical properties and displays the total quantity. Only unique combinations of all visible columns create separate rows.

2. **Using filters effectively**:
   - Use Include mode to show only specific items (e.g., only show studs)
   - Use Exclude mode to hide specific items (e.g., hide all plates)
   - Filters are case-insensitive

3. **Sorting by location**: Use "X Position in viewport" and "Y Position in viewport" as sort keys to order items based on their physical position in the view.

4. **Custom column order**: Use the Column indexes properties to rearrange columns. Set lower index values for columns you want to appear first.

5. **Netto dimensions**: Enable Netto width/height/length columns to show actual solid dimensions after tooling operations have been applied.

6. **Working with groups**: Enable "Use group selection box" to create a BOM from a named group instead of a viewport element. This is useful for creating BOMs of partial assemblies.

7. **Empty table handling**: If no content matches your filters, the table displays "No Content" unless "Draw headers when empty" is enabled, in which case column headers are still shown.

8. **Sheet dimension sequencing**: For sheets, use "Sequence sheet sizes" to ensure consistent ordering of width/height/length values regardless of the sheet's orientation.

---

## FAQ

**Q: Why is my BOM table empty?**
A: Check that:
- The viewport contains a valid hsbCAD element
- Your filter settings are not excluding all items
- The content types you want to show (Beams, Sheets, etc.) are set to "Show"

**Q: How do I include items from multiple zones?**
A: Enable multiple "Sheeting zone" options. Each zone (1-10) can be independently shown or hidden.

**Q: Can I create a BOM for a partial assembly?**
A: Yes, set "Use group selection box" to "Yes" and select the appropriate group from the "Group" dropdown.

**Q: Why are some items showing quantity greater than 1?**
A: Items with identical properties across all visible columns are automatically grouped and their quantities summed.

**Q: How do I change the column order?**
A: Use the "Column indexes" category properties. Lower index values appear first (leftmost).

**Q: Can I rename the column headers?**
A: Yes, use the "Headers" category properties to customize each column header text.

**Q: Why are my dimensions showing decimal places?**
A: Adjust the "Precision" property to 0 for whole numbers, or higher values for more decimal places.

**Q: How do I include TSL instances in the BOM?**
A: Set "Tsls" to "Show". Note that TSL instances must have a "BOM" or "BOM[]" map in their script to be included.

**Q: The table overlaps my viewport. How do I move it?**
A: Either drag the grip point to reposition, or use "Reset location" from the right-click menu.

**Q: Can I show cut angles for sheets?**
A: Yes, enable "Angle Neg" and "Angle Pos" columns. For sheets, these show the edge angles relative to the sheet's X-axis.

---

## Version History

- **3.2** (09/2022): Only switch length and width of sheeting on elementRoof
- **3.1** (09/2022): Add rounding options for rounding around 0.5
- **3.0** (09/2022): Add 4th sort key and categories
- **2.33** (09/2018): Description column now hidden by default
- **2.28** (05/2018): Added MassGroups support and Description column
