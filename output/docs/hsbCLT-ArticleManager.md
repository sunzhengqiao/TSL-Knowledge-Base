# hsbCLT-ArticleManager

## Overview

The **CLT Article Manager** is a tool for managing Cross-Laminated Timber (CLT) panel article definitions. It attaches layer component data to CLT panels and master panels, allowing you to define and track article specifications including layer thicknesses, surface qualities, material grades, and component descriptions.

The tool reads article data from either:
- An Excel file (via import function using the hsbExcelToMap utility)
- An XML settings file located in the company or installation TSL\Settings folder

Once attached to a panel, the article data becomes accessible through format expressions for use in schedules, labels, and reports. The tool also provides a visual representation of grain directions for each layer when viewing the panel in model space.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object Tool) |
| Model Space | Yes - Primary working environment |
| Paper Space | No |
| Shop Drawing | No |
| Target Entities | CLT Panels (Sip), Master Panels |
| Beams Required | 0 |
| Version | 1.6 |

## Prerequisites

Before using the CLT Article Manager:

1. **CLT Panel or Master Panel must exist** - You need at least one CLT panel or master panel in your drawing to attach the article manager to.

2. **Surface Quality Styles defined** - Your drawing should have Surface Quality Styles configured, as the tool matches articles based on the panel's top and bottom surface qualities.

3. **Article data source** (one of the following):
   - An Excel file with article definitions
   - An XML settings file (`CLT-ArticleManager.xml`) in the company TSL\Settings folder

## Step-by-Step Usage Guide

### Attaching the Article Manager to Panels

1. **Launch the Tool**
   - From the hsbCAD ribbon, navigate to the TSL tools section
   - Select **hsbCLT-ArticleManager** or type the command at the command line

2. **Select Panels**
   - When prompted with "Select panels", click on one or more CLT panels or master panels
   - Press Enter to confirm your selection

3. **Automatic Processing**
   - The tool creates an instance attached to each selected panel
   - It automatically reads the panel's thickness and surface quality settings
   - Matching articles from the database are filtered and displayed

4. **Select Article**
   - Use the Properties Palette to select the appropriate article from the dropdown list
   - Only articles matching the panel thickness and surface qualities appear in the list

### Importing Articles from Excel

1. **Right-click** on the Article Manager instance in the drawing
2. Select **Import Excel Articles** from the context menu
3. Browse to and select your Excel file
4. The system automatically scans for a sheet containing the required columns:
   - **Thickness** - Panel thickness value in mm
   - **Quality 1** - Bottom surface quality name
   - **Quality 2** - Top surface quality name
   - **Components** - Layer structure definition (e.g., "20;30;20" or "20-20;30;20-20")

### Exporting Settings to XML

1. **Right-click** on the Article Manager instance
2. Select **Export Settings** from the context menu
3. If a settings file already exists, confirm whether to overwrite
4. The settings are saved to: `[Company Path]\TSL\Settings\CLT-ArticleManager.xml`

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Article** | Dropdown | (Empty) | Selects the CLT article definition. The list shows only articles that match the panel's thickness and surface quality requirements. |

**Note**: The Article dropdown is read-only (hidden) during insertion and becomes active only after the tool is attached to a panel.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Import Excel Articles** | Opens a file browser to import article definitions from an Excel spreadsheet. The Excel file must contain columns for Thickness, Quality 1, Quality 2, and Components. |
| **Export Settings** | Exports the current article database to an XML file in the company TSL\Settings folder. Prompts for confirmation if a file already exists. |

## Settings Files

### File Location

The tool looks for settings in this order:
1. **Company path**: `[Company]\TSL\Settings\CLT-ArticleManager.xml`
2. **Installation path**: `[hsbCAD Install]\Content\General\TSL\Settings\CLT-ArticleManager.xml`

### Excel Import Format

When importing from Excel, the spreadsheet must contain these columns:

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Thickness | Number (mm) | Total panel thickness |
| Quality 1 | Text | Bottom surface quality name (must match a SurfaceQualityStyle) |
| Quality 2 | Text | Top surface quality name (must match a SurfaceQualityStyle) |
| Components | Text | Layer structure using semicolon notation (see below) |
| Name | Text | (Optional) Article name/code |
| Description | Text | (Optional) Per-layer descriptions, semicolon-separated |
| Grade | Text | (Optional) Per-layer grade designations, semicolon-separated |
| Material | Text | (Optional) Per-layer material names, semicolon-separated |

### Component Notation

Layer thicknesses are defined using semicolons to separate layers:
- Simple layers: `20;30;20` (three layers: 20mm, 30mm, 20mm)
- Parallel grain layers (double layers): `20-20;30;20-20` (layers with same grain direction are hyphenated)

Example: `20-20;30;40;30;40` defines a multi-layer panel where the outer 20mm layers share the same grain direction.

**Note**: The sum of component thicknesses must match the panel's total thickness. Minor tolerances (within 0.2mm) are accepted for rounding differences (e.g., three 33.3mm layers for a 100mm panel).

### Format Expressions

After the Article Manager is attached, you can access article data in schedules and labels using these format expressions:

| Expression | Returns |
|------------|---------|
| `@(CLT-ArticleData.ComponentDescription)` | Layer structure description |
| `@(CLT-ArticleData.ComponentDescriptionAligned)` | Aligned layer description |
| `@(CLT-ArticleData.Layer)` | Number of layers |
| `@(CLT-ArticleData.Quality1)` | Bottom surface quality |
| `@(CLT-ArticleData.Quality2)` | Top surface quality |
| `@(CLT-ArticleData.Description)` | Article description |
| `@(CLT-ArticleData.NumComponents)` | Number of components/layers |
| `@(CLT-ArticleData.Name)` | Article name |
| `@(CLT-ArticleData.Component1.Thickness)` | First layer thickness |
| `@(CLT-ArticleData.Component1.Grade)` | First layer grade |
| `@(CLT-ArticleData.Component1.Material)` | First layer material |
| `@(CLT-ArticleData.Component1.Description)` | First layer description |

**Note**: Replace `Component1` with `Component2`, `Component3`, etc. to access subsequent layers.

## Tips and Best Practices

1. **Style Name Convention**: The tool can pre-filter articles based on the panel style name if it follows this convention: `<Thickness> <NumComponents><SingleDouble>`. For example, "120 5s" indicates 120mm thickness with 5 layers in single direction, while "120 5ss" indicates parallel outer layers.

2. **Surface Quality Matching**: Ensure your panels have surface quality styles assigned before attaching the Article Manager. The tool uses these to filter available articles.

3. **Master Panels**: When attached to a master panel, the tool collects article data from all nested child panels, providing a comprehensive view of materials used.

4. **One Instance Per Panel**: The tool automatically prevents duplicate instances. If you attempt to attach a second Article Manager to a panel that already has one, the new instance is deleted.

5. **Grain Direction Display**: The tool displays a visual representation of layer grain directions near the panel center when viewing in model space.

6. **Automatic Updates**: When you change the article selection, the tool automatically updates associated panels and triggers recalculation of related tools (such as grain direction markers).

7. **Visual Errors**: If your panel turns transparent or shows a warning after assigning the script, it means no article in the catalog matches the panel's thickness or surface qualities. Use "Import Excel Articles" to load the correct data.

8. **Bulk Updates**: You can select multiple panels and run the script simultaneously. If they share the same geometric properties, you can update them all at once via the Properties Palette.

9. **Data Storage**: The data written by this script is stored in the entity's SubMapX under the key `CLT_ArticleData`. This can be referenced in Lists/Labels to show individual layer thicknesses or materials.

10. **Panel Transparency Warning**: If your panel becomes transparent (70% transparency) after attaching the Article Manager, this is normal behavior for valid panels. It indicates the tool is active. If the panel shows warnings or errors, verify that the article database contains matching entries.

11. **Quality Reversal**: If your panel's surface qualities (top/bottom) are reversed compared to the article definition, the tool automatically reverses the layer order to match. This ensures the article data always aligns with the physical panel orientation.

12. **Master Panel Articles**: For Master Panels, if the child panels already have article data attached, the Article Manager displays "no article selection needed" and uses the data from the nested child panels instead.

## Frequently Asked Questions

**Q: Why is my Article dropdown empty?**

A: The dropdown only shows articles that match both the panel thickness and surface quality requirements. Check that:
- Your panel has surface quality styles assigned (top and bottom)
- Your article database contains entries matching the panel's exact thickness
- The quality names in your article data match the Surface Quality Style names in your drawing

**Q: How do I add new articles?**

A: You can either:
1. Edit the XML settings file directly in the company TSL\Settings folder
2. Create an Excel file with the required columns and use "Import Excel Articles"

**Q: Can I use this with regular Sip panels?**

A: Yes, the tool works with both standard CLT panels (Sip) and Master Panels. Simply select the panels during the insertion process.

**Q: What happens if the panel thickness changes?**

A: The tool automatically recalculates when the referenced panel is modified. If the new thickness no longer matches the selected article, you may need to select a different article from the filtered list.

**Q: How do I access the article data in my schedules?**

A: Use the format expressions (e.g., `@(CLT-ArticleData.ComponentDescription)`) in your schedule templates or label formats. The data is stored in the panel's subMapX and can be accessed anywhere format expressions are supported.

**Q: The tool shows "Invalid reference" and deletes itself. Why?**

A: This occurs when the referenced panel has been deleted or is no longer valid. The Article Manager requires a valid panel to remain attached.

**Q: What format should the Excel import file have?**

A: The Excel file must contain the specific column headers: `Thickness`, `Quality 1`, `Quality 2`, and `Components`. Additional optional columns include `Name`, `Description`, `Grade`, and `Material`. All thickness values should be in millimeters.

**Q: Can I use this on regular beams?**

A: No, this script is designed specifically for CLT panels (Sip and MasterPanel entities).

**Q: What happens when I select an article that has reversed qualities?**

A: If the article's Quality 1/Quality 2 don't match the panel's bottom/top qualities (but are reversed), the tool automatically reverses the layer order and all associated data (grades, materials, descriptions) to match the panel's orientation.

## Related Scripts

| Script | Description |
|--------|-------------|
| hsbCLT-GrainDirection | Displays grain direction markers on CLT panels; automatically updated when article changes |
| hsbCLT-MasterPanelManager | Manages CLT master panel configurations |
| hsbCLT-QC | Quality control tools for CLT panels |

## Technical Details

**Script Information:**
- File: `hsbCLT-ArticleManager.mcr`
- Type: O-Type (Object Tool)
- Version: 1.6 (as of November 2025)
- Authors: Thorsten Huck, Marsel Nakuci

**Key Dependencies:**
- `hsbExcelToMap.dll` (hsbCAD 28+) or `hsbExcelToMap.exe` (older versions) for Excel import
- Surface Quality Styles must be defined in the drawing
- XML settings file stored in company TSL\Settings folder
