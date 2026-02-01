# hsbBOM - Bill of Materials

## Description

The **hsbBOM** script generates a Bill of Materials (BOM) table that lists beams, sheets (panels), and TSL components in your timber construction project. It works across three different drawing spaces: Model Space, Paper Space, and Shop Drawing Multipage. The BOM displays position numbers, quantities, dimensions, materials, and other attributes in a customizable table format.

This tool is essential for creating material schedules and part lists for timber elements, walls, roofs, and floor assemblies.

## Script Type

- **Type**: O (Object)
- **Beams Required**: 0
- **Version**: 6.12

## Workflow

### Model Space Insertion

1. Run the script and a dialog will appear with configuration options
2. Click a point in Model Space to set the insertion location
3. Select the entities (beams, sheets, TSL components) you want to include in the BOM
4. The BOM table is generated at the selected point

### Paper Space Insertion

1. Run the script in Paper Space
2. Select an hsbViewport that displays your element
3. Pick an insertion point in Paper Space
4. The BOM automatically extracts all beams and sheets from the viewport

### Shop Drawing Multipage Insertion

1. Edit the block of your multipage
2. Run the script
3. Select an hsbViewport (ShopDrawView)
4. Pick an insertion point in the block drawing

## Properties

### General Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Drawing space | String | model space | Determines the working space (Model Space, Paper Space, or Shopdraw Multipage). Read-only after insertion. |
| Zone selection | String | BOM of complete Element | Controls which zones to include: complete element, current zone + frame, current zone only, or multiple zones |
| Multiple Zones | String | (empty) | Specify zone indices (-5 to +5) separated by semicolons. Only active when "BOM of multiple zones" is selected |
| Display BOM | String | Yes | Whether to display the BOM table (always Yes in Model Space) |
| Sort column | String | Pos | Column used to sort the BOM entries |
| Sort mode | String | Ascending | Sort order (Ascending or Descending) |

### Position Number Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Show PosNum Beams | String | Show PosNum | Controls beam numbering display: Do not show, Show PosNum, Show Size, Show PosNum and Size, Show Log PosNum, Show only in BOM, Show PosNum and Length, Show Length |
| Show PosNum Sheets | String | Show PosNum | Controls sheet numbering display: Do not show, Show PosNum, Show Size, Show PosNum and Size, Show only in BOM, Show Material and Size |
| Show PosNum TSL's | String | Show PosNum | Controls TSL numbering display: Do not show, Show PosNum, Show Name, Show PosNum and Name, Show only in BOM |
| PosNum Background | String | Nothing | Background treatment for position numbers: Nothing, Show Box, Hide Beams, Hide Sheets, Hide TSLs, or combinations |
| Color Background | Integer | 254 | Color index for position number background box |
| PosNum Alignment | String | Parallel X-World | Alignment of position numbers: Parallel to World X-axis, or parallel to object axis (inside or outside) |

### Column Width Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Width Pos | Double | 100 mm | Width of Position column |
| Width Name | Double | 150 mm | Width of Name column |
| Width Pcs | Double | 100 mm | Width of Pieces/Quantity column |
| Width Length | Double | 100 mm | Width of Length column |
| Width Width | Double | 100 mm | Width of Width column |
| Width Height | Double | 100 mm | Width of Height column |
| Width Material | Double | 100 mm | Width of Material column |
| Width Grade | Double | 100 mm | Width of Grade column |
| Width Info | Double | 100 mm | Width of Information column |
| Width Weight | Double | 100 mm | Width of Weight column |
| Width Profile | Double | 100 mm | Width of Profile column |
| Width Label | Double | 100 mm | Width of Label column |
| Width Sublabel | Double | 100 mm | Width of Sublabel column |
| Width Type | Double | 100 mm | Width of Type column |
| Width Angle1 | Double | 100 mm | Width of Angle 1 column |
| Width Angle2 | Double | 100 mm | Width of Angle 2 column |
| Width Angle1C | Double | 100 mm | Width of Complementary Angle 1 column |
| Width Angle2C | Double | 100 mm | Width of Complementary Angle 2 column |
| Width NetArea | Double | 100 mm | Width of Net Area column (sheets only) |
| Width Volume | Double | 100 mm | Width of Volume column (sheets only) |

### Column Order Settings

Each column has a corresponding "Column No." property (integers 0-20) that determines the display order. Set to 0 to hide a column.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Column No. Pos | Integer | 1 | Display order of Position column |
| Column No. Name | Integer | 2 | Display order of Name column |
| Column No. Pcs | Integer | 3 | Display order of Quantity column |
| Column No. Length | Integer | 4 | Display order of Length column |
| Column No. Width | Integer | 5 | Display order of Width column |
| Column No. Height | Integer | 6 | Display order of Height column |
| Column No. Material | Integer | 7 | Display order of Material column |
| Column No. Grade | Integer | 8 | Display order of Grade column |
| Column No. Info | Integer | 9 | Display order of Information column |
| Column No. Weight | Integer | 10 | Display order of Weight column |
| Column No. Profile | Integer | 11 | Display order of Profile column |
| Column No. Label | Integer | 12 | Display order of Label column |
| Column No. Sublabel | Integer | 13 | Display order of Sublabel column |
| Column No. Type | Integer | 14 | Display order of Type column |
| Column No. Angle1 | Integer | 15 | Display order of Angle 1 column |
| Column No. Angle2 | Integer | 16 | Display order of Angle 2 column |
| Column No. Angle1C | Integer | 17 | Display order of Complementary Angle 1 column |
| Column No. Angle2C | Integer | 18 | Display order of Complementary Angle 2 column |
| Column No. NetArea | Integer | 19 | Display order of Net Area column |
| Column No. Volume | Integer | 0 | Display order of Volume column (0 = hidden) |

### Text and Display Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Dimstyle | String | (current) | Dimension style for BOM text |
| Scale | Double | 1 | Scale factor for the BOM table |
| character size | Double | 17 mm | Text height for BOM entries |
| Unit | String | mm | Unit for length values (mm, cm, m, inch, feet) |
| Decimals | Integer | 0 | Number of decimal places for dimensions |
| Unit Area | String | mm2 | Unit for area values (sheets only) |
| Decimals Area | Integer | 0 | Number of decimal places for area values |
| Color | Integer | 171 | Color index for BOM table |
| Dimstyle PosNum | String | (current) | Dimension style for position numbers |
| Color TSL PosNum | Integer | 143 | Color index for TSL position numbers |

### Filter Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Filter TSL | String | (empty) | Filter TSL components by name. Separate multiple entries with semicolons |
| Filter Material | String | (empty) | Include only items matching these materials. Separate multiple entries with semicolons |
| Filter Label | String | (empty) | Include only items matching this label |
| Exclude Material | String | (empty) | Exclude items with these materials. Separate multiple entries with semicolons |

### Advanced Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Offset Factor | Double | 3 | Multiplier for position number offset from entities |
| Switch to Complementary Angle | String | No | Display complementary cutting angles instead of standard angles |
| Use solid size | String | No | Use solid (actual) dimensions instead of nominal beam sizes |

## Context Commands

| Command | Description |
|---------|-------------|
| Add Entity | (Model Space only) Add additional entities (beams, sheets, or TSL components) to an existing BOM after it has been placed |

## BOM Columns Reference

The BOM can display the following data columns for each component:

| Column | Applies To | Description |
|--------|------------|-------------|
| Pos | All | Position number of the component |
| Name | All | Component name |
| Pcs | All | Quantity of identical components |
| Length | Beams | Solid length of the beam |
| Width | Beams, Sheets | Width dimension |
| Height | Beams, Sheets | Height/thickness dimension |
| Material | All | Material designation |
| Grade | Beams | Timber grade |
| Info | All | Additional information field |
| Weight | All | Component weight |
| Profile | Beams | Profile name (for profiled beams) |
| Label | All | Label designation |
| Sublabel | All | Sublabel designation |
| Type | All | Component type |
| Angle1 | Beams | Cutting angle at negative end |
| Angle2 | Beams | Cutting angle at positive end |
| Angle1C | Beams | Complementary cutting angle at negative end |
| Angle2C | Beams | Complementary cutting angle at positive end |
| NetArea | Sheets | Net surface area after cuts |
| Volume | Sheets | Volume of sheet material |

## Tips

- **Hiding Columns**: Set a column's "Column No." property to 0 to hide it from the BOM
- **Reordering Columns**: Change the "Column No." values to rearrange column order
- **TSL Components**: The BOM supports TSL scripts that publish data to a map called "TSLBOM". Subpart listings are possible if supplied by the referenced TSL
- **Automatic Numbering**: If beams do not have position numbers assigned, they will be automatically numbered when added to the BOM
- **Multiple Zones**: When working with Paper Space viewports, you can select specific zones to include in the BOM using the "Multiple Zones" property with zone indices from -5 to +5
- **Performance**: The script uses envelope bodies instead of real bodies for better performance in complex models

## Notes

- The "Drawing space" property becomes read-only after insertion
- In Model Space, the "Display BOM" option is always enabled and read-only
- Zone selection options are only available in Paper Space and Shop Drawing modes
- Cutting angles (Angle1, Angle2, etc.) represent the straight cut angles at beam ends
