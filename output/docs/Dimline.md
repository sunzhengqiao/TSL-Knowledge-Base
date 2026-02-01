# Dimline

## Description

This script creates dimension lines based on selected entities in Model Space or Paper Space. You can dimension beams, sheets, panels, SIPs, polylines, and any entity that carries a polyline definition (circles, roof planes, etc.).

The script automatically detects and dimensions various hsbCAD elements including:
- Timber members (beams, sheets, panels)
- Openings (doors, windows)
- Metal parts and hardware
- Tool operations (drills, cuts, slots, mortises)
- Block references and external references (XRefs)

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 10.6 |
| **Requires** | hsbDesign 26 or higher |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Dimensions are projected to the current view plane. |
| Paper Space | Yes | Links to specific Viewports; includes setup graphics for configuration. |
| Shop Drawing | Yes | Supports MultipageController for managing views. |

## User Properties

### Dimension Category

| Property | Default | Description |
|----------|---------|-------------|
| **Dimension Point Mode** | Default | Defines which points of the reference are taken. Options include: Default, First Point, Last Point, Mid Point, Extreme Points, merged variations, and Offset Dimension (Paper Space only). |
| **Delta/Chain Mode** | parallel / parallel | Controls how dimensions are displayed. Options combine parallel, perpendicular, or none for delta and chain modes. Also includes "classic Acad" option. |
| **Reference Point Mode** | Default | Defines which points of the reference are taken. Options: Default, None, First Point, Last Point, Extreme Points, Closest Point. |
| **Shape Mode** | Default | Specifies how the shape of items is interpreted to collect dimension points: Low Detail (bounding box only), Medium Detail (bounding contour with cuts/openings), High Detail (real body, less performant), or Extreme Points. |
| **TSL / Stereotype** | (empty) | Semicolon-separated list of TSL names or stereotypes to append additional dimension points. |
| **Tool Set** | (empty) | Defines the tool set for dimensioning specific tool types. |

### Filter Category

| Property | Default | Description |
|----------|---------|-------------|
| **Dimension** | (from painters) | Defines the painter definition to filter entities. If a painter collection named "Dimension" is found, only painters of this collection are considered. |
| **Reference** | (from painters) | Defines the reference of the dimension. Uses painter definitions for filtering. |

### Display Category

| Property | Default | Description |
|----------|---------|-------------|
| **DimStyle** | (from drawing) | Defines the AutoCAD dimension style to use. |
| **Text Height** | 0 | Defines the text height of the dimension. Use 0 for "by DimStyle". |
| **Scale Factor** | 1 | Defines a scale factor for the dimension values. Must be greater than 0. |
| **Format** | (empty) | Defines format variables and/or static text. Example: `@(Area:CU;m:RL3)m2` displays area in square meters, rounded to 3 decimal digits. |
| **Sequence** | -1 | Defines the sequence for resolving collisions with other dimension lines and tags. -1 = Disabled, 0 = Automatic. |

## Usage Steps

### Step 1: Launch Script

Run the Dimline script from the TSL menu or use command: `TSLINSERT` and select `Dimline.mcr` from the catalog.

### Step 2: Configure Properties

A dialog appears allowing you to set dimension properties:
- Choose the Dimension Point Mode
- Select Delta/Chain display mode
- Pick the appropriate Shape Mode based on detail needed
- Select Dimension Style and other display options

### Step 3: Select Entities

- **In Model Space**: Select beams, sheets, panels, or other entities to dimension.
- **In Paper Space**: Select a viewport first, then the entities within that viewport will be dimensioned.

### Step 4: Place the Dimension Line

Click to specify the location and orientation of the dimension line.

### Step 5: Adjust if Needed

Use grip points or context menu commands to modify the dimension line after placement.

## Context Menu Commands

Right-click on a Dimline instance to access these commands:

### Primary Commands

| Command | Description |
|---------|-------------|
| **Add Points** | Manually add specific points to the dimension line. |
| **Remove Points** | Remove selected points from the dimension line. |
| **Add Entities** | Add additional entities to be dimensioned. |
| **Remove Entities** | Remove entities from the dimension. |
| **Set Alignment** | Adjust the alignment direction of the dimension line. |
| **Select Segment** | Select a specific segment of the dimension line. |
| **Set Diagonal** | Set diagonal dimensioning mode. |
| **Rotate 90 degrees** | Rotate the dimension line orientation by 90 degrees. |
| **Swap Delta/Chain** | Toggle between delta and chain dimension display modes. |
| **Copy Dimline** | Create a copy of the current dimension line. |

### Advanced Commands

| Command | Description |
|---------|-------------|
| **Define Tool Sets** | Configure which tool types (drills, cuts, slots, etc.) to include in dimensioning. |
| **Define Parent Tool Filter** | Set up TSL/Stereotype filters for dimension points. |
| **Set Viewport Reference Mode** | Configure reference mode for hsbCAD viewports (viewport mode only). |
| **Regenerate Shopdrawing** | Refresh the shop drawing display. |
| **Align Dimlines** | Align multiple dimension lines on a page. |
| **Purge Dimlines** | Remove redundant or invalid dimension lines from a multipage. |

### Settings Commands

| Command | Description |
|---------|-------------|
| **Global Settings** | Access global dimension line settings including group assignment options. |
| **Drill Dimension Visibility Settings** | Configure visibility of drill dimensions based on view direction (perpendicular/parallel). |
| **Painter Management** | Manage painter definitions for dimension filtering. |
| **Import Settings** | Import dimension settings from an external XML file. |
| **Export Settings** | Export current dimension settings to an XML file for use in other projects. |

## Settings Files

- **Filename**: `DimlineSettings.xml`
- **Location**: `hsbCompany` path (or user-specified path)
- **Purpose**: Stores configuration data such as dimension styles, offsets, and Painter management modes. Used to standardize settings across projects.

## Tips

- **Performance**: Use "Low Detail" shape mode for faster performance on large models.
- **Precision**: Use "High Detail" shape mode when you need precise dimensioning of complex geometry.
- **Custom Text**: The Format property supports variable formatting for custom dimension text.
- **Paper Space**: When working in layouts, ensure the script is linked to the correct Viewport. Setup graphics (non-plotting lines) will appear to help you visualize the link.
- **Auto-Update**: Dimension lines automatically update when linked elements move or change.
- **Filtering**: Use painter definitions to filter which entities are included in the dimension.
- **Multipage**: This script works with the MultipageController. If you delete an element in the model, use the controller to purge the now-invalid dimension lines.

## FAQ

**Q: My dimensions disappeared in Paper Space.**
A: This likely means the linked geometry is outside the Viewport boundaries or the Viewport scale changed. Check the Setup Graphics layer or use the Set Alignment command.

**Q: How do I copy my setup to another drawing?**
A: Right-click the dimension instance, select "Export Settings" to save an XML file, then "Import Settings" in the new drawing.

**Q: What is the difference between Shape Modes?**
A: Low Detail uses only the bounding box (fastest). Medium Detail includes cuts and openings. High Detail uses the actual 3D body (most accurate but slower).

## Version History

- **10.6** (28.10.2025): Bugfix for accepting default stereotype wildcard '*'
- **10.5** (18.06.2025): Blockspace detection improved
- **10.4** (10.06.2025): Performance improved for metalpart painters, preview improved
- **10.0** (03.06.2025): Bugfix for basepoint on insert and door window combination
- **8.3** (23.07.2024): New mode 'Dimension Offset' available in paperspace
- **6.0** (13.09.2023): Requires hsbDesign 26 or higher, supports multiple block references and metalpart entities
