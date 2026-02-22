# hsbCenterOfGravity

Calculate and display the center of gravity (COG) for timber elements, assemblies, and solid objects.

## Overview

**hsbCenterOfGravity** is a calculation and visualization tool that determines the center of gravity for selected building components. It calculates the weight and balance point based on material densities, making it essential for:

- Lifting and crane operations planning
- Transport load balancing
- Structural analysis support
- Element weight documentation

The script supports walls, floors, roofs, individual beams, panels, metal parts, mass groups, and assemblies. Results can be displayed in both Model Space and Paper Space (shop drawings and layouts).

## Environment

| Property | Value |
|----------|-------|
| Type | O-Type (Object) |
| Space | Model Space / Paper Space / Shop Drawing |
| Version | 5.32 |

**Requires:**
- Material density database file: `<hsbCompany>\Abbund\Materials.xml`
- DLL: `hsbMaterialDensityTable.dll` (in Utilities folder)

## Prerequisites

- A valid material density database must exist (created automatically on first use with default materials)
- For element-based calculations: Valid hsbCAD elements (walls, roofs, floors)
- For viewport display: Valid hsbViewport with element reference
- For individual entities: Beams, panels, 3DSolids, or TSL instances with volume

## Usage

### Three Insertion Methods

**1. Element Mode**
Select one or more elements (walls, roofs, floors). The script calculates the combined center of gravity for all beams, sheets, panels, TSL objects, and metal parts within each element.

**2. Individual/Assembly Mode**
Select solids directly (beams, panels, metal parts). A dialog appears to choose between:
- **Assembly**: Calculate one COG for the entire selection as a single unit
- **Single instance**: Calculate individual COG for each selected entity separately

**3. Viewport Mode (Paper Space)**
Skip the solid selection with Enter, then select an hsbViewport. The COG displays in the layout based on the viewport's associated element.

### Step-by-Step

1. Launch the script via `TSLINSERT` and select `hsbCenterOfGravity`
2. On first use, a dialog appears to configure the material density database
3. Select entities or elements as prompted
4. Choose the insertion mode (Assembly or Single instance) in the dialog
5. The COG symbol and weight text appear at the calculated position

### Quick Access

- **Double-click** an existing instance to open the density database editor
- Use the catalog entry **ShowDensityDialog** to edit densities directly without inserting

## Parameters (OPM Properties)

### Display

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Symbol Size | Double | 120 mm | Size of the COG symbol. Set to 0 in Paper Space to hide the symbol. |
| Color | Integer | 1 (Red) | Color for symbol and text display (AutoCAD Color Index) |
| Transparency | Integer | 70 | Symbol transparency (-1=byLayer, -2=byBlock, 0-100=percentage) |
| Style | List | Rhomb | Display style options: Rhomb, Circle, Rhomb + Coordinates, Circle + Coordinates |

### Text

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | List | (current) | Dimension style controlling text appearance and precision |
| Text Height | Double | 80 mm | Text height for weight display (0 = use DimStyle setting) |
| Format | String | @(Weight) kg | Format expression for weight display |

**Format Examples:**
- `@(Weight) kg` - Default formatting with dimension style precision
- `@(Weight:RL0) kg` - No decimal places (rounded integer)
- `@(Weight:RL1) kg` - One decimal place

### Filter

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Painter Rule | List | (Disabled) | Filter entities using a painter definition for selective COG calculation |

### General

| Parameter | Type | Description |
|-----------|------|-------------|
| Mode | List | Assembly (combined COG) or Single instance (individual COGs) - set during insertion |
| Include Windows + Doors | Yes/No | Include openings in calculation using "Window" and "Door" material densities |

## Context Menu

| Command | Description |
|---------|-------------|
| Add Entity | Add more entities to the current COG calculation |
| Remove Entity | Remove entities from the calculation |
| Load Densities from Database | Reload density values from the Materials.xml file |
| Add Material to Database | Open the density editor dialog to add/modify materials |
| Show/Hide dependencies | Toggle visual lines connecting all calculated entities to the COG point |

## Material Density Database

The script uses `<hsbCompany>\Abbund\Materials.xml` to look up material densities (in kg/m3).

**Default Materials (created on first use):**

| Material | Density (kg/m3) |
|----------|-----------------|
| Default | 500 |
| Aluminium | 2500 |
| BSH | 500 |
| Edelstahl (Stainless) | 7800 |
| GKB (Gypsum) | 950 |
| Kork (Cork) | 110 |
| KVH | 500 |
| MDF | 900 |
| OSB | 800 |
| Steel | 7700 |

**Special Materials:**
- **Window** - Used for window openings when "Include Windows + Doors" is enabled
- **Door** - Used for door openings when "Include Windows + Doors" is enabled

**Editing Densities:**
1. Double-click any COG instance, or
2. Use the context menu "Add Material to Database", or
3. Run the script with catalog entry "ShowDensityDialog"

## MapIO Interface

Other TSL scripts can call this script programmatically to calculate COG:

```c
Map mapIO;
Map mapEntities;
for (int e = 0; e < ents.length(); e++)
    mapEntities.appendEntity("Entity", ents[e]);
mapIO.setMap("Entity[]", mapEntities);
TslInst().callMapIO("hsbCenterOfGravity", mapIO);

// Get results
Point3d ptCen = mapIO.getPoint3d("ptCen");    // Center of gravity point
double dWeight = mapIO.getDouble("Weight");    // Total weight in kg
```

**Return Values:**
- `ptCen` (Point3d) - The calculated center of gravity point
- `Weight` (Double) - Total calculated weight in kg
- `Missing[]` (Map) - List of materials without defined densities
- `NumEmptyMaterial` (Int) - Count of entities with no material assigned

## Output Data

The script writes calculated values to element and beam mapX for use by other scripts:

**Element Level:**
| SubMapX Key | Value |
|-------------|-------|
| ExtendedProperties\Weight | Total weight in kg |
| ExtendedProperties\ptCen | Center of gravity point |

**Beam Level:**
| SubMapX Key | Value |
|-------------|-------|
| COG\Weight | Individual beam weight in kg |

## Tips and Best Practices

1. **Missing Materials Warning**: If a material is not found in the database, a default density of 500 kg/m3 is used. Check the command line for warnings about missing materials and update your Materials.xml accordingly.

2. **Panel Components**: For multi-component panels (SIP), the script calculates component-by-component when materials differ between layers. This provides accurate results for composite assemblies.

3. **Metal Parts and TSL Instances**: Default to "Steel" material unless a property set with a "Material" property is attached to the entity.

4. **Composite Beams**: The script correctly handles extrusion profiles with multiple materials by calculating each component separately.

5. **Performance Optimization**: When attached to elements, the script uses dependency tracking to avoid unnecessary recalculations. Updates occur automatically when beams or materials change.

6. **Shop Drawings**: The COG symbol automatically publishes a protection area to the multipage collector, preventing overlapping annotations.

7. **Coordinate Display**: Choose "Rhomb + Coordinates" or "Circle + Coordinates" styles to show distances from the COG to element boundaries - useful for crane lift planning.

8. **Custom Blocks**: If a block named "hsbCenterOfGravity" exists in the drawing, it will be used instead of the default symbol geometry.

9. **Zero Weight Results**: If the calculation returns 0 kg, verify:
   - The material is defined in Materials.xml with a valid density
   - The entity has a proper material name assigned
   - The entity has valid volume (not a dummy or zero-volume entity)

## FAQ

**Q: Can I calculate the weight of an entire building?**
A: The script calculates per-element. For an entire building, attach it to each element individually, or use the Individual/Assembly mode to select multiple elements and calculate them as one assembly.

**Q: Why does the COG appear in an unexpected location?**
A: This typically occurs with multi-component panels or when some materials have significantly different densities. The COG is weighted by mass, not geometry - a small heavy component can shift the COG toward it.

**Q: How do I update all COG instances after changing the density database?**
A: Use "Load Densities from Database" from the context menu, or simply regenerate (REGEN) the drawing - the dependency tracking will trigger recalculation.

**Q: What entity types are supported?**
A: Beams, Sheets, Panels (SIP), TSL instances, MassGroups, MassElements, MetalPartCollectionEntities, 3DSolids, and Openings (when enabled).
