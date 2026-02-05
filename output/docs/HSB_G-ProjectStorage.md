# HSB_G-ProjectStorage

## Overview
This script exports hsbCAD model data (geometry and production information) to external files or machinery using the ModelMap exporter. It provides flexible options to export the entire project, specific floor levels, or a user-defined selection of elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on the 3D model and structural groups. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | Not used for generating shop drawings or layouts. |

## Prerequisites
- **Required Entities**: Elements (Beams/Walls/Plates) must exist in the model if not exporting the whole project.
- **Minimum Beam Count**: 0 (Can export empty projects or specific floors).
- **Required Settings**: A valid **ModelMap Exporter Group** must be configured in your hsbCAD environment (e.g., for PPI, BVF, or XML formats).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-ProjectStorage.mcr`.

### Step 2: Configure Export Settings
A properties dialog will appear (unless run from a pre-configured catalog entry).

| Action | Details |
|--------|---------|
| **Entities to export** | Choose the scope from the dropdown: <br> - *Select entire project*: Exports everything.<br> - *Select floor level...*: Requires selecting a floor group below.<br> - *Select current floor level*: Uses the active floor.<br> - *Select elements in drawing*: Prompts you to click objects. |
| **Run exporter group** | Select the target export format (e.g., CNC machine format or BIM exchange format) from the list. |
| **Floorgroup** | (Only active if "Select floor level" is chosen) Select the specific floor to export. |

Click **OK** to proceed.

### Step 3: Select Elements (If applicable)
If you chose **"Select elements in drawing"** in Step 2:
```
Command Line: Select one or more elements to export
Action: Click the desired elements in the model view and press Enter.
```
*Note: For all other modes (Project/Floor), the script proceeds automatically.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Entities to export** | Dropdown | 3 (Select elements in drawing) | Determines the scope of data included in the export: Entire Project, Specific Floor, Current Floor, or User Selection. |
| **Run exporter group** | Dropdown | *First available group* | Selects the specific Exporter configuration (recipe) defined in ModelMap to define file format and data structure. |
| **Floorgroup** | Dropdown | 0 | Specifies the exact building story to export when "Entities to export" is set to "Select floor level". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script is a "fire-and-forget" utility. It performs the export and erases itself immediately; therefore, it does not persist in the drawing to offer right-click options. |

## Settings Files
- **Filename**: Various (Depends on Exporter Group selection, typically XML, CSV, or machine-specific files).
- **Location**: hsbCAD ModelMap Configuration (Company or Installation path).
- **Purpose**: These configurations contain the logic for translating hsbCAD geometry into the specific external file format required by production machinery or analysis software.

## Tips
- **Use Catalog Entries**: If you frequently export to the same machine format using the same scope, create a Catalog Entry. This skips the configuration dialog and runs the export immediately upon insertion.
- **Current Floor Shortcut**: If you are working on a specific floor, use the "Select current floor level" option to quickly export just the visible work without manually selecting objects.
- **Check Output Folder**: Exported files are typically saved in your temporary folder or a directory specified in the Exporter Group settings. Check your specific exporter configuration if you cannot find the output file.

## FAQ
- **Q: Why did the script disappear immediately after I clicked OK?**
  - A: This is normal behavior. The script collects the data, triggers the export process, and then self-destructs (erases the instance). It does not leave a visible object in the CAD model.
- **Q: What happens if I select "Select elements in drawing" but press Enter without selecting anything?**
  - A: The script may terminate without exporting data or export an empty dataset, depending on the specific exporter configuration. Always ensure you select elements if prompted.
- **Q: Can I use this to export IFC files?**
  - A: Yes, provided you have an IFC Exporter Group configured in your ModelMap settings and select it in the "Run exporter group" dropdown.