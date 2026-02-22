# BatchShopdrawing.mcr

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | BatchShopdrawing |
| **Category** | Shop Drawing / Batch Processing |
| **Type** | Object (O-Type) |
| **Version** | 3.1 (03.12.2024) |
| **Author** | Thorsten Huck |
| **Required Beams** | 0 |
| **Grip Points** | Dynamic (based on border shape) |

**Purpose**: This TSL script automates the batch creation and intelligent nesting of shop drawings (MultiPages) for timber construction entities. It creates parent shop drawings from Collection Entities or Assembly TSLs, generates individual shop drawings for nested child entities, and efficiently arranges all drawings onto master sheets with PlotViewports for plotting.

The script operates in three distinct modes:
1. **Mode 1 - Multipage Creation**: Creates new MultiPages from selected entities
2. **Mode 2 - Nesting in PlotViewports**: Arranges created pages onto master sheets
3. **Mode 3 - Border Drawing**: Draws and manages the border around nested pages

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | All operations occur in Model Space |
| Paper Space | No | Script creates PlotViewports for later plotting |
| Shop Drawing | No | This is a utility that *creates* shop drawings |

## Prerequisites

- **Required entities** (at least one):
  - `MetalPartCollectionEnt` (hardware/metal part collections)
  - `CollectionEntity` (generic element collections)
  - `Beam` (individual timber beams)
  - `Sheet` (paneling materials like OSB, gypsum)
  - `Sip` (Structural Insulated Panels)
  - `AssemblyDefinition` TSL instances
  - Existing `MultiPage` entities (for re-nesting)
  - `PlotViewport` entities (for redistribution)
  - `BlockRef` (for header blocks)

- **Required settings**: MultiPage Styles must be configured in the drawing
- **Layout configuration**: At least one Layout must exist if creating PlotViewports

## Workflow

### Step 1: Launch the Script

```
Command: TSLINSERT
Select script: BatchShopdrawing
```

Alternatively, use the catalog system to recall saved configurations.

### Step 2: Configure Properties

A dialog appears showing available MultiPage styles and Painter definitions. Configure:

1. **Collection Styles** - For parent objects (MetalParts, Assemblies)
2. **Individual Styles** - For child entities (Beams, Sheets, Panels)
3. **Filter + Grouping** - Control entity selection and nesting behavior
4. **Plot Viewport** - Define layout and title block settings

### Step 3: Select Entities

```
Command Line: Select entities:
```

Select the entities to process. The selection can include:
- MetalPart collections or Assembly TSLs (for parent drawings)
- Individual beams, sheets, or panels (for individual drawings)
- Existing MultiPages (for re-nesting existing drawings)

**Tip**: Enable "Allow selection in XRef" if your entities are in referenced drawings.

### Step 4: Specify Insertion Point

If a Layout is selected, a preview of the sheet boundary appears. Click to place the master sheet origin. The script then:
1. Creates MultiPages for all selected entities
2. Creates individual drawings for nested children (if enabled)
3. Nests all pages within the sheet boundary
4. Creates PlotViewports for plotting
5. Places title block (if specified)

### Step 5: Review Results

- **Nested pages**: Successfully placed drawings with border
- **Left Over pages**: Drawings that didn't fit (placed to the right of the master)
- **PlotViewports**: Created with formatted names and position numbers

## Properties Panel (OPM)

### Collection Styles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Metalpart Style** | PropString | (from drawing) | MultiPage style for MetalPartCollectionEnt parent objects. Select `<Disabled>` to skip parent drawings. |
| **Metalpart Nestings** | PropString | `<Disabled>` | Controls child entity processing: `<Disabled>` (no children), `Create Nested` (parent + children), `Only Nested` (children only) |
| **Assembly-TSL Style** | PropString | (from drawing) | MultiPage style for AssemblyDefinition TSL parent objects |
| **Assembly Nestings** | PropString | `<Disabled>` | Same options as Metalpart Nestings, but for Assembly TSL children |

### Individual Styles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam** | PropString | (from drawing) | MultiPage style for individual Beam entities. Must be an "Individual Shop Drawing" type style. |
| **Sheet** | PropString | (from drawing) | MultiPage style for Sheet entities (OSB, gypsum, etc.) |
| **Panel** | PropString | (from drawing) | MultiPage style for SIP/Panel entities |
| **Filter** | PropString | (from catalog) | Painter definition to filter which entities receive individual drawings. Particularly useful when processing collection children. |

### Filter + Grouping

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Allow selection in XRef** | PropString | No | When "Yes", allows selection of entities within block references or XRefs |
| **Painter** | PropString | (from catalog) | Painter definition to filter and group selected entities. Uses the `AssemblyShopdrawing` collection if available. |
| **Sort Direction** | PropString | Ascending | Order of processing: `Ascending` (A-Z, smallest first) or `Descending` (Z-A, largest first) |
| **Margin** | PropDouble | 150 mm | Clearance spacing between nested drawings and the sheet edge |
| **Smoothing** | PropDouble | 400 mm | Maximum edge length to simplify when calculating bounding shapes. Higher values create more rectangular borders for better nesting. |
| **Color** | PropInt | 2 (Yellow) | AutoCAD Color Index for the border polyline |

### Plot Viewport

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Layout** | PropString | `<Disabled>` | The paper space layout to use for PlotViewport creation. **Required** for nested shop drawings. |
| **Format** | PropString | `@(Definition:D)@(PosNum:D)` | Naming format for PlotViewports. Supports entity property tokens. |
| **Title Block** | PropString | `<Disabled>` | Block name to insert as the page header/title block at the lower-right corner |

## Right-Click Menu Options (Context Menu)

### Mode 3 (Border Instance) Menu

| Menu Item | Description |
|-----------|-------------|
| **Reset Shape** | Removes any custom rectangular shape and recalculates the border from the underlying MultiPage geometry |
| **Smoothen (Double Click)** | Automatically adjusts the Smoothing value to the largest edge segment found, creating an optimal rectangular border |
| **Specify Rectangle** | Manually define a custom rectangular border by picking two corner points |

## How the Nesting Algorithm Works

1. **Boundary Collection**: For each MultiPage, the script calculates the bounding profile by:
   - Analyzing all views and their showsets
   - Including block references (title blocks, schedule tables)
   - Applying margin spacing

2. **Smoothing**: Simplifies complex jagged edges:
   - Segments shorter than the Smoothing value are absorbed
   - Creates more rectangular shapes for efficient packing

3. **Grouping**: Entities are grouped by their Painter filter key:
   - Same-group items are nested together
   - Parent items are placed before their children
   - Groups are processed in sort order

4. **Nesting**: Uses the Rectangular Nester algorithm:
   - Attempts to fit items within the master sheet
   - Creates additional PlotViewports if needed
   - Aligns items along the top edge for visual consistency

5. **Left Over Handling**: Items that don't fit are:
   - Placed to the right of the last master sheet
   - Grouped by their filter key
   - Given their own border instances

## Tips and Best Practices

### Performance Optimization
- **Smoothing Value**: Start with 300-500mm. Higher values create simpler borders but may waste space; lower values handle complex shapes but slow nesting.
- **Painter Filtering**: Use Painter definitions to pre-filter entities, reducing the number of items to process.

### Layout Planning
- **Multiple Sheets**: The script automatically creates additional PlotViewports when content exceeds one sheet.
- **Title Blocks**: Ensure your title block block definition exists in the drawing before running the script.

### Troubleshooting Common Issues

| Issue | Solution |
|-------|----------|
| "No multipage styles found" | Create MultiPageStyles in the drawing using the hsbCAD configuration tools |
| Drawings not nested | Check that the Layout is selected; increase margin if items overlap |
| Empty selection result | Verify the Painter filter matches your entity types; check entity validity |
| Left Over pages | Increase sheet size, reduce margins, or process in smaller batches |
| Slow processing | Reduce the number of entities; increase smoothing value; check for complex geometries |

### Working with XRefs
- Enable "Allow selection in XRef" when your timber model is in a referenced drawing
- The script will create MultiPages that reference XRef entities
- PlotViewports are created in the current drawing

### Re-nesting Existing Drawings
- Select existing MultiPage entities to re-arrange them
- Previous PlotViewports and header blocks are automatically purged
- Border shapes are recalculated (not reused from cache)

## Version History

| Version | Date | Ticket | Changes |
|---------|------|--------|---------|
| 3.1 | 03.12.2024 | HSB-23092 | Fixed max bounding of border |
| 3.0 | 02.12.2024 | HSB-23092 | New property to enable optional selection of XRef entities |
| 2.9 | 12.11.2024 | HSB-22965 | PlotViewport naming, new command to specify rectangular border |
| 2.8 | 17.06.2024 | HSB-22271 | Bugfix header block creation on insert |
| 2.7 | 17.06.2024 | HSB-22271 | Smoothing property published on insert |
| 2.6 | 03.04.2024 | HSB-20206 | AssemblyDefinition supported to create nested |
| 2.4-2.5 | 11.2023-04.2024 | HSB-20550 | Insert jig and margin grips added, renesting improved |
| 2.1-2.3 | 11.2023 | HSB-20550 | Smoothing property, context menu commands, left over placement |
| 1.5-2.0 | 04-11.2023 | Various | PlotViewports, block refs, dimension purging, polygonal nesting |
| 1.0 | 06.2022 | HSB-15687 | Initial proof of concept for nested individual MultiPages |

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `AssemblyDefinition` | Parent assembly TSL that can be processed by this script |
| `MultiPageStyle` | Configuration entities that define drawing appearance |
| `PainterDefinition` | Filter definitions for entity selection and grouping |
| `PlotViewport` | Output entities created for paper space plotting |
| `hsbScheduleTable` | Schedule tables within MultiPages are included in boundary calculation |
| `DimLine` | Dimension lines are purged when borders are recalculated |

## Technical Notes

### Mode System
The script uses an internal mode system stored in the Map:
- **Mode 1**: Initial creation mode - creates MultiPages from entities
- **Mode 2**: Nesting mode - arranges pages within PlotViewports
- **Mode 3**: Border mode - draws and manages the border around pages

### Entity Dependencies
- The script sets dependencies on all processed MultiPages
- Dependencies trigger automatic recalculation when pages move
- Grip manipulation updates all dependent pages simultaneously

### Grid-Based Placement
When multiple items are nested, the script:
1. Collects grid points from the nested profile
2. Attempts placement at each grid location
3. Tests for intersections with existing items
4. Moves to next row or creates new master if needed

### Format String Tokens
The PlotViewport Format property supports these tokens:
- `@(Definition:D)` - Entity definition name
- `@(PosNum:D)` - Position number
- `@(ScriptName:D)` - TSL script name
- `@(Handle)` - Entity handle
- Any standard hsbCAD entity property
