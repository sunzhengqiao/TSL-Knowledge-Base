# f_Truck - Truck Loading and Stacking Management System

## Overview

The **f_Truck** script is a comprehensive logistics planning tool that creates a truck representation with a dynamic stacking grid system for planning and visualizing timber element delivery arrangements. It forms the top-level orchestrator in a three-tier stacking hierarchy (**Truck → Layer → Item**), managing the complete workflow from element selection to documentation generation.

This tool is essential for logistics planning, allowing CAD operators to:
- Organize timber elements, wall panels, CLT components, or mass elements into delivery trucks
- Calculate weight distribution and center of gravity for safety compliance
- Display axle load calculations with visual representations
- Generate plot viewports for fabrication documentation and shipping papers
- Create package weight schedules using hsbPivotSchedule
- Export stacking data to property sets or subMapX for downstream processing
- Visualize stacking efficiency with contact faces, shadow projections, and interference detection

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Environment** | Model Space |
| **Beams Required** | 0 |
| **Version** | 6.70 (Major: 6, Minor: 70) |
| **Last Updated** | November 3, 2025 |
| **Keywords** | Stacking, Truck, Delivery, Nesting |
| **Settings File** | `f_Stacking.xml` |
| **Location** | `[Company Path]\TSL\Settings\` |
| **Dependencies** | f_Layer, f_Item, f_Grid, hsbPivotSchedule, klhStackMatrix (KLH only) |

## Stacking Hierarchy

The f_Truck script operates as the top-level manager in a three-tier hierarchy:

```
f_Truck (this script)
├── Mode 0: Truck Mode (Full visualization with truck outline)
│   └── Creates child instances: f_Layer, f_Item, f_Grid
└── Mode 1: Grid Mode (Lightweight grid-only mode)
    └── Used internally for multi-truck scenarios
```

**Child Scripts:**
- **f_Layer**: Represents one horizontal or vertical row of stacked items
- **f_Item**: Represents individual transformed elements within a layer
- **f_Grid**: Bedding support grid for horizontal stacking (optional)

## Prerequisites

Before using this script:

1. **Stackable Items**: You need timber elements, wall panels, CLT components, or other hsbCAD entities. Items are automatically prepared when added to a truck (marked with `Hsb_Item` metadata).

2. **Settings File** (Optional but Recommended):
   - Location: `[Company Path]\TSL\Settings\f_Stacking.xml`
   - If no file exists, default settings are created in the drawing dictionary
   - Settings persist across drawing sessions via MapObject

3. **Block Definitions** (Optional):
   - Custom truck front display blocks in `[Company Path]\Block\`
   - Used for visual truck representation in grid mode
   - Configurable per truck design via `FrontDistance[]` XML section

4. **Layout Templates** (Optional):
   - Paper space layouts for automatic plot viewport generation
   - Define layouts in XML under `Layout[]` section
   - Supports multiple layouts per truck design

5. **Axle Load Configuration** (KLH Projects):
   - Required for axle load calculation and display
   - Define in XML under `AxleLoadCalculation[]` section
   - Specify axle positions, load limits, and truck designs

## Step-by-Step Usage Guide

### Creating a New Truck

1. **Launch the Script**:
   - Run `f_Truck` from the TSL scripts menu
   - Or type the script name in the command line
   - Or use silent insertion via execute key: `_kExecuteKey=CATALOGNAME`

2. **Configure Properties** (Dialog or Catalog):

   **Dialog Mode** (if no execute key provided):
   - A catalog selection dialog appears if multiple configurations exist
   - Select desired truck configuration or use default settings

   **Property Configuration:**
   - **Length**: Truck bed length (default: 13600mm)
   - **Width**: Truck bed width (default: 2500mm)
   - **Height**: Maximum stacking height (default: 2700mm)
   - **Number**: Delivery sequence number (0 = automatic)
   - **Name**: Descriptive name for the truck (e.g., "Truck 1")
   - **Type**: Choose "Horizontal" or "Vertical" stacking
   - **Design**: Select truck type (see Design Options below)

3. **Place the Truck**:
   - Click a point in the drawing to position the truck origin
   - The insertion point becomes the lower-left corner of the truck bed
   - Truck is locked to World Coordinate System (WCS) - no rotation allowed

4. **Result**:
   - Truck outline is drawn with grid cells
   - Coordinate system visualization appears at insertion point
   - Grid is ready for layer addition

### Adding Items to the Truck (Double-Click Workflow)

The primary workflow for adding items is through **double-clicking grid cells**:

1. **Double-Click** on any stacking grid cell, OR
2. **Right-click** on a grid cell and select **"Add Layer"**

3. **Select Items**:
   - When prompted: `"Select item(s)"`
   - Select one or more elements from your model
   - Items can be GenBeam, Element, Sheet, Sip, or mass elements
   - Press Enter to confirm selection

4. **Set Bedding Height** (Horizontal stacking only):
   - Prompt appears: `"<Enter> to insert with bedding height [default]"`
   - Press Enter to accept the default bedding height
   - Or type a new value (e.g., `80` for 80mm bedding)
   - System remembers bedding heights per row for subsequent layers

5. **Automatic Processing**:
   - System calculates item bounds and determines row position
   - Creates a new **f_Layer** instance at the calculated position
   - Creates **f_Item** instances for each selected element
   - Items are transformed to truck coordinate system
   - Stacking data is written to entity property sets or subMapX
   - Nesting is triggered if configured in settings

6. **Result**:
   - New layer appears in the truck grid
   - Items are displayed with sequential coloring
   - Shadow projections show cumulative stacking
   - Contact faces can be toggled for verification

### Working with KLH/CLT Projects

For KLH (Cross-Laminated Timber) projects, the script automatically detects project type via `projectSpecial()` and enables additional features:

#### KLH-Specific Features

1. **Automatic klhStackMatrix Creation**:
   - Created automatically on truck insertion (`_bOnDbCreated`)
   - Provides stacking matrix visualization for KLH workflow

2. **Extended Design Options**:
   - "Laaprs woodrailer" - Wood rail trailer configuration
   - "Individuell" - Custom axle definitions for special trucks

3. **Property Protection**:
   - Properties are set to read-only by default (controlled by `PropertyReadOnly` in XML)
   - Prevents accidental modification of truck dimensions during stacking
   - **Unblock Properties**: Right-click truck → "Unblock Properties" to enable editing
   - **Block Properties**: Right-click truck → "Block Properties" to re-lock

4. **Layer Separation Management**:
   - **Apply Layer Separation**: Marks f_Item instances for bedding layer insertion
   - **Don't Apply Layer Separation**: Removes bedding layer marking
   - Sets `BeddingRequested` flag in item's map for downstream processing

5. **Weight Calculation Enhancements**:
   - Reads weight from extended data in XML (for panels)
   - Supports net weight from property sets
   - Calculates center of gravity for load distribution
   - Displays weight even if no axle definition is found

6. **Axle Load Calculation and Display**:
   - **Show/Hide axle load calculation**: Toggle display (requires ≥5000kg load)
   - Visual representation of axle positions and loads
   - Warnings for minimum axle weight requirements
   - Color-coded load indicators (red for overload, green for acceptable)

7. **Package Dimensions**:
   - Automatic dimension display for each package
   - Dimensions relative to truck sections
   - Configurable dimension style and offset

8. **Plot Viewport Generation**:
   - **Generate Plot ViewPort**: Creates viewports with hsbPivotSchedule weight tables
   - Creates one viewport per package with weight annotation
   - Positions hsbPivotSchedule instances automatically
   - Supports section views for horizontal stacking

9. **Transformation Tracking**:
   - Stores transformation for each layer separately
   - Critical for CombiTruck scenarios with multiple layers per row
   - Enables accurate projection and section generation

## Properties Panel Parameters

### Geometry Category

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Length** | PropDouble | 13600 mm | > 0 | Total length of the truck loading area. Defines the X-axis extent of the stacking grid. |
| **Width** | PropDouble | 2500 mm | > 0 | Width of the truck loading area. Defines the Y-axis extent of the stacking grid. |
| **Height** | PropDouble | 2700 mm | > 0 | Maximum stacking height. Defines the Z-axis extent for vertical stacking or maximum layer height for horizontal stacking. |

**Note**: For KLH projects, these properties are read-only by default. Use "Unblock Properties" to enable editing.

### Truck Category

| Parameter | Type | Default | Values | Description |
|-----------|------|---------|--------|-------------|
| **Number** | PropInt | 0 | 0-999 | Delivery sequence number. **0 = automatic numbering** (recommended). System assigns next available number. |
| **Name** | PropString | "Truck 1" | Any | Descriptive name for the truck. Used in documentation and property sets. Appears in axle load calculations. |
| **Type** | PropString (List) | Horizontal | Horizontal, Vertical | Stacking orientation. **Cannot be changed after creation** - fundamentally changes grid structure. |
| **Design** | PropString (List) | Open Truck | See Design Options | Truck configuration type. Determines display, layout, and axle calculations. |

**Important**: Type and Design properties become read-only after insertion because they define the fundamental structure of the truck.

### Design Options

| Design | Description | Use Case | Special Features |
|--------|-------------|----------|------------------|
| **Open Truck** | Standard flatbed truck without roof | General timber framing, beams, panels | Head board display, stancions |
| **Closed Truck** | Covered truck with roof display | Protected elements, weather-sensitive materials | Roof visualization, closed design display |
| **Container** | Shipping container configuration | International shipping, standard containers | Container outline, standard dimensions |
| **Package** | For package/pallet stacking | Bundled materials, small items | Package wrapping flags, pallet dimensions |
| **Laaprs woodrailer** | Wood rail trailer (KLH only) | KLH panel transport | Specialized axle configuration, rail display |
| **Individuell** | Custom axle definitions (KLH only) | Special trucks, custom configurations | Multiple axle definitions, custom layouts |

**Design Configuration**: Each design can have custom settings in XML:
- Custom dimensions and offsets
- Display parameters (linetype, color, transparency)
- Axle configurations for load calculation
- Front display blocks
- Layout configurations for plot viewports

## Right-Click Menu Options

### Truck (Root) Context Menu (_kContextRoot)

These commands apply to the truck entity itself:

| Menu Item | Trigger Key | Description | Availability |
|-----------|-------------|-------------|--------------|
| **Unblock Properties** | N/A | Enable property editing. Removes read-only flag from Length, Width, Height, Name, Type, Design properties. | KLH projects only, when properties are blocked |
| **Block Properties** | N/A | Set properties to read-only. Prevents accidental modification during stacking operations. | KLH projects only, when properties are unblocked |
| **Apply Layer Separation** | N/A | Mark selected f_Item instances for layer separation. Prompts to select items, sets `BeddingRequested` flag. | KLH projects and general use |
| **Don't Apply Layer Separation** | N/A | Remove layer separation marking from selected f_Item instances. Clears `BeddingRequested` flag. | KLH projects and general use |
| **Create Child Panels** | N/A | Generate child panel entities from stacked items. Creates separate entities for detailed processing or export. | Always available |
| **Run Export [Group]** | Varies | Execute export using configured exporter groups defined in settings XML `ExporterGroup[]` section. Multiple entries create multiple menu items. | If exporter groups configured |
| **Show axle load calculation** | N/A | Display axle load visualization with weight distribution, center of gravity, and load warnings. | KLH projects, requires axle definition and ≥5000kg |
| **Hide axle load calculation** | N/A | Hide axle load visualization. | KLH projects, when axle load is visible |
| **Generate Plot ViewPort** | N/A | Auto-create plot viewports with package weight schedules using hsbPivotSchedule. Creates viewports for all packages. | KLH projects only |
| **Create Plot Viewports** | N/A | Generate plot viewports based on layout configuration. Creates one viewport per row. Uses layout templates from XML. | Always available |

### Grid Cell Context Menu (_kContext)

These commands apply to individual stacking grid cells:

| Menu Item | Trigger Key | Description | Notes |
|-----------|-------------|-------------|-------|
| **Add Layer** | "TslDoubleClick" | Select and add items to this grid cell. Primary workflow for stacking. | Can also trigger via double-click |
| **Show interferences** | N/A | Toggle collision detection display between stacked items. Shows interference volumes in red. | Default hidden for performance |
| **Hide interferences** | N/A | Hide collision detection display. | When interferences visible |
| **Show contact faces** | N/A | Toggle display of contact surfaces between layers. Shows contact areas with hatching. | Default hidden for performance |
| **Hide contact faces** | N/A | Hide contact surface display. | When contact faces visible |
| **Hide additional row** | N/A | Toggle visibility of extra stacking row for oversized layers. | When additional row is visible |
| **Show additional row** | N/A | Show additional row for oversized items. | When additional row is hidden |
| **Add Bedding Grid** | N/A | Create a bedding support grid for horizontal stacking. Generates f_Grid instances at specified spacing. | Horizontal stacking only |
| **Define Plot Viewport** | N/A | Opens dialog to select paper layout and configure viewport positioning for this grid cell. | Always available |
| **Define Plot Viewport Format** | N/A | Set naming format for plot viewports using property placeholders (e.g., `@(Name)`, `@(Number)`). | Always available |
| **Hide truck dimensions** | N/A | Toggle dimension annotations on truck outline. | KLH projects only, when dimensions visible |
| **Show truck dimensions** | N/A | Show dimension annotations on truck outline. | KLH projects only, when dimensions hidden |

## Settings Files

### Configuration Location

The script reads settings from:
- **Primary**: `[Company Path]\TSL\Settings\f_Stacking.xml`
- **Fallback**: Default settings stored in drawing dictionary via MapObject

**Settings Persistence**:
- Settings are read once at insertion or when MapObject is invalidated
- Stored in drawing dictionary as MapObject with key `"hsbTSL"/"f_Stacking"`
- Dependency set via `setDependencyOnDictObject(mo)` for automatic recalculation
- To reload settings: Delete MapObject from drawing dictionary and recalculate truck

### Settings Structure (XML Format)

The XML settings file uses `<Hsb_Map>` structure. Key sections:

#### Truck Display Settings

```xml
<lst nm="Truck">
  <int nm="Color" vl="252"/>
  <dbl nm="TextHeight" ut="L" vl="70"/>
  <dbl nm="RowOffsetTruck" ut="L" vl="500"/>

  <!-- Contour thickness (HSB-19483) -->
  <lst nm="Contour">
    <dbl nm="Thickness" ut="L" vl="50"/>
    <str nm="ApplyTo" vl="Inside"/>  <!-- Inside|Outside|Center -->
  </lst>
</lst>
```

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| Color | int | 252 | Truck outline color (AutoCAD color index) |
| TextHeight | double | 70mm | Text height for annotations |
| RowOffsetTruck | double | 500mm | Offset from truck origin to first grid row |
| Contour/Thickness | double | 50mm | Thickness applied to truck contour |
| Contour/ApplyTo | string | "Inside" | Thickness application: Inside, Outside, or Center |

#### Grid Settings

```xml
<lst nm="Grid">
  <int nm="Color" vl="250"/>
  <str nm="Linetype" vl="Dashed"/>
  <dbl nm="LinetypeScale" ut="L" vl="10"/>
  <dbl nm="RowOffset" ut="L" vl="1000"/>
  <dbl nm="ColumnOffset" ut="L" vl="1000"/>

  <lst nm="Contour">
    <dbl nm="Thickness" ut="L" vl="30"/>
    <str nm="ApplyTo" vl="Inside"/>
  </lst>
</lst>
```

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| Color | int | 250 | Grid line color |
| Linetype | string | "Dashed" | Grid linetype (must exist in drawing) |
| LinetypeScale | double | 10mm | Scale factor for linetype |
| RowOffset | double | 1000mm | Spacing between grid rows |
| ColumnOffset | double | 1000mm | Spacing between grid columns (vertical stacking) |

#### Layer Visualization Settings

**LayerContact** (Contact faces between layers):
```xml
<lst nm="LayerContact">
  <int nm="Color" vl="76"/>
  <str nm="Linetype" vl="CONTINUOUS"/>
  <dbl nm="LinetypeScale" ut="L" vl="1"/>
  <int nm="Transparency" vl="80"/>  <!-- 0-100, higher = more transparent -->
</lst>
```

**LayerInterference** (Collision detection):
```xml
<lst nm="LayerInterference">
  <int nm="Color" vl="242"/>
  <str nm="Linetype" vl="CONTINUOUS"/>
  <dbl nm="LinetypeScale" ut="L" vl="1"/>
  <int nm="Transparency" vl="50"/>
</lst>
```

**LayerShadow** (Cumulative shadow projection):
```xml
<lst nm="LayerShadow">
  <int nm="Color" vl="78"/>
  <str nm="Linetype" vl="DOTS"/>
  <dbl nm="LinetypeScale" ut="L" vl="1"/>
  <int nm="Transparency" vl="100"/>
</lst>
```

#### HeadBoard Settings

```xml
<lst nm="HeadBoard">
  <int nm="Color" vl="6"/>
  <str nm="Linetype" vl="CONTINUOUS"/>
  <dbl nm="LinetypeScale" ut="L" vl="1"/>
  <int nm="Transparency" vl="0"/>
  <dbl nm="Thickness" ut="L" vl="100"/>
  <int nm="Row" vl="1"/>  <!-- Which row to display head board: -1=all, 0=first, 1=second, etc. -->
</lst>
```

#### Stancion Settings (Vertical stacking support posts)

```xml
<lst nm="Stancion[]">
  <dbl nm="Width" ut="L" vl="400"/>
  <dbl nm="Height" ut="L" vl="2000"/>
  <int nm="Color" vl="40"/>
  <int nm="Transparency" vl="70"/>

  <!-- Optional: Reference to block definition -->
  <str nm="BlockName" vl="Stancion_Block"/>
  <str nm="BlockPath" vl="[Company Path]\Block\"/>
</lst>
```

**Note**: Set Width or Height to 0 to disable stancions.

#### Bedding Grid Settings

```xml
<lst nm="BeddingGrid">
  <dbl nm="EdgeOffset" ut="L" vl="100"/>  <!-- Offset from layer edges -->
</lst>
```

#### Sequential Colors

Define colors for sequential layer coloring:

```xml
<lst nm="SequentialColor[]">
  <int nm="1" vl="14"/>
  <int nm="2" vl="144"/>
  <int nm="3" vl="94"/>
  <int nm="4" vl="134"/>
  <int nm="5" vl="174"/>
  <int nm="6" vl="214"/>
  <int nm="7" vl="24"/>
  <int nm="8" vl="64"/>
  <int nm="9" vl="104"/>
  <int nm="10" vl="154"/>
</lst>
```

Each layer is colored according to its index in this array. Colors cycle if more layers than defined colors.

#### Design Configurations

```xml
<lst nm="Design[]">
  <lst nm="LayoutOpen">
    <str nm="Name" vl="Open Truck"/>
    <!-- Custom settings for this design -->
  </lst>

  <lst nm="LayoutClosed">
    <str nm="Name" vl="Closed Truck"/>
    <!-- Custom settings for this design -->
  </lst>
</lst>
```

#### Axle Load Calculation (KLH)

```xml
<lst nm="AxleLoadCalculation[]">
  <lst nm="0">
    <str nm="Design" vl="Laaprs woodrailer"/>
    <str nm="TruckName" vl=""/>  <!-- Empty = applies to all trucks -->
    <int nm="Type" vl="0"/>  <!-- 0=Horizontal, 1=Vertical -->

    <!-- Axle positions from truck front -->
    <dbl nm="Axle1" ut="L" vl="1200"/>
    <dbl nm="Axle2" ut="L" vl="5800"/>
    <dbl nm="Axle3" ut="L" vl="7400"/>

    <!-- Load limits (optional) -->
    <dbl nm="Axle1Max" vl="8000"/>  <!-- kg -->
    <dbl nm="Axle2Max" vl="12000"/>
    <dbl nm="Axle3Max" vl="12000"/>

    <!-- Minimum axle load warning -->
    <dbl nm="MinAxleLoad" vl="5000"/>  <!-- kg -->
  </lst>

  <!-- Multiple definitions for different designs -->
  <lst nm="1">
    <str nm="Design" vl="Individuell"/>
    <!-- ... -->
  </lst>
</lst>
```

**Important Notes**:
- Design name must match truck's Design property (case-insensitive after translation)
- Multiple designs can be specified separated by semicolons: `"Design 1;Design 2;Design 3"`
- Axle load visualization only appears if total load ≥ 5000kg
- Axle positions are measured from truck insertion point along X-axis

#### Front Distance (Grid Mode Display)

```xml
<lst nm="FrontDistance[]">
  <lst nm="0">
    <str nm="TruckName" vl="Truck 1"/>
    <str nm="Design" vl="Open Truck"/>
    <dbl nm="Distance" ut="L" vl="500"/>  <!-- Distance from grid to front display block -->
    <str nm="BlockName" vl="TruckFront_Block"/>
  </lst>
</lst>
```

Used in Grid Mode (nMode==1) to display truck front representation.

#### Layer Bedding Heights

```xml
<lst nm="Layer">
  <lst nm="Bedding[]">
    <dbl nm="Bedding" ut="L" vl="80"/>  <!-- Row 0 default -->
    <dbl nm="Bedding" ut="L" vl="30"/>  <!-- Row 1 default -->
    <dbl nm="Bedding" ut="L" vl="30"/>  <!-- Row 2 default -->
  </lst>
</lst>
```

Default bedding heights per row for horizontal stacking. System prompts user to accept or override when adding layers.

#### Source Entity Settings

```xml
<lst nm="SourceEntity">
  <str nm="PropsetName" vl="Stacking"/>
  <!-- Or for better performance (HSB-9858): -->
  <str nm="PropsetName" vl="subMapX"/>
</lst>
```

| Setting | Values | Description |
|---------|--------|-------------|
| PropsetName | "Stacking" | Write stacking data to property set on source entities |
| PropsetName | "subMapX" | Write stacking data to subMapX for better performance |

**Recommended**: Use `"subMapX"` for large projects with many stacked items.

#### Weight Property Path

```xml
<lst nm="Truck">
  <str nm="WeightProperty" vl="PropertySet.Weight"/>
</lst>
```

Defines the path to the property containing weight value. Format: `PropertySetName.PropertyName`

#### Exporter Groups

```xml
<lst nm="ExporterGroup[]">
  <lst nm="0">
    <str nm="Name" vl="Export to BTL"/>
    <str nm="ExporterGroup" vl="BTL_Stacking"/>
  </lst>
  <lst nm="1">
    <str nm="Name" vl="Export to CSV"/>
    <str nm="ExporterGroup" vl="CSV_Delivery"/>
  </lst>
</lst>
```

Creates context menu items for quick export. Each entry generates a "Run Export [Name]" menu item.

#### Layout Configurations

```xml
<lst nm="Layout[]">
  <lst nm="0">
    <str nm="LayoutName" vl="A3_Landscape"/>
    <str nm="DesignKey" vl="LayoutOpen"/>  <!-- Matches Design[] key -->
    <dbl nm="Scale" vl="100"/>  <!-- 1:100 -->
    <dbl nm="ViewportOffsetX" ut="L" vl="50"/>
    <dbl nm="ViewportOffsetY" ut="L" vl="50"/>
  </lst>
</lst>
```

Used for automatic plot viewport generation.

#### Item Contour Settings (HSB-19483)

```xml
<lst nm="Item">
  <lst nm="Contour">
    <dbl nm="Thickness" ut="L" vl="20"/>
    <str nm="ApplyTo" vl="Outside"/>
  </lst>
</lst>
```

Applies thickness to item contours when displayed in truck grid.

#### Property Read-Only Flag (KLH)

```xml
<int nm="PropertyReadOnly" vl="1"/>  <!-- 0=editable, 1=read-only -->
```

Controls whether properties are locked by default in KLH projects.

#### Sub-Design Configuration (HSB-24277)

```xml
<lst nm="Design[]">
  <lst nm="LayoutOpen">
    <lst nm="SubDesign[]">
      <lst nm="0">
        <str nm="Name" vl="Variant A"/>
        <!-- Variant-specific settings -->
      </lst>
    </lst>
  </lst>
</lst>
```

Allows multiple sub-configurations within a single design type.

## Property Set Output

### Property Set Definition

The script writes stacking data to source entities as a property set (or subMapX if configured). The default property set name is `"Stacking"` and contains:

| Property Name | Type | Description | Example |
|---------------|------|-------------|---------|
| **Number** | Integer | Truck delivery sequence number | 1, 2, 3... |
| **Name** | String | Truck name/identifier | "Truck 1", "Delivery A" |
| **Type** | String | Stacking type | "Horizontal", "Vertical" |
| **Design** | String | Truck design type | "Open Truck", "Closed Truck" |
| **Layer Index** | Integer | Row number (1-based) | 1, 2, 3... |
| **Package Number** | Integer | Package identifier (if applicable) | -1 (none), 1, 2, 3... |
| **Package Wrapping** | String | Wrapping flag | "Yes", "No" |

**Property Translation**: For non-KLH projects, property names are translated using `T("|PropertyName|")` for localization.

### SubMapX Storage (Performance Mode)

When `PropsetName="subMapX"` is configured, stacking data is stored more efficiently in entity subMapX instead of property sets:

**Key**: `"Hsb_Item"`

**Structure**:
```
MyUid: [Item Handle]
Number: [Truck Number]
Name: [Truck Name]
Type: [Stacking Type]
Design: [Design Type]
LayerIndex: [Row Number]
PackageNumber: [Package Number]
PackageWrapping: [Yes/No]
```

**Advantages of subMapX**:
- Faster write/read operations
- No AutoCAD property set overhead
- Better performance with complex solids (HSB-9303)
- Recommended for large projects with 100+ stacked items

## Data Communication and Map Structure

### Published Data in _Map

The truck publishes the following data to its `_Map` for querying by other scripts (e.g., _hsbReport, f_Tag):

| Key | Type | Description |
|-----|------|-------------|
| **mode** | int | 0=Truck Mode, 1=Grid Mode |
| **isTruck** | int | Flag: true if in Truck Mode |
| **readOnly** | int | Flag: true if properties are read-only |
| **ShowAxelLoad** | int | Flag: true to display axle load calculation |
| **RowBeddings** | Map | Map of row index → bedding height (double) |
| **PackageData** | Map | Package information for downstream processing |
| **EntityRef[]** | Entity[] | Array of all stacked entities (handles) |
| **ptCOG** | Point3d | Center of gravity for loaded truck |
| **ptCOGcombi** | Point3d | Center of gravity for combi truck (KLH) |
| **WeightCombi** | double | Total weight of combi truck (KLH) |

### SubMapX Keys

The truck uses several subMapX keys for parent-child relationships:

| Key | Direction | Contents |
|-----|-----------|----------|
| **Hsb_GridParent** | Truck → Layer | MyUid, ptOrg, vecX, vecY, vecZ |
| **Hsb_LayerParent** | Layer → Item | MyUid, ptOrg, vecX, vecY, vecZ |
| **Hsb_ItemParent** | Item → Source | MyUid, ptOrg, transformation data |
| **Hsb_TruckParent** | Truck → Source | MyUid, ptOrg, vecX, vecY, vecZ |
| **Hsb_PackageParent** | Package → Item | MyUid, package number |

**Coordinate System Vectors**:
- `vecX`, `vecY`, `vecZ` are scaled by truck dimensions (e.g., `vecX*dLength`)
- Stored with `_kScalable` flag for automatic scaling
- `ptOrg` stored with `_kRelative` flag for coordinate system independence

### Layer to Truck Transformation (KLH Mode)

For KLH projects with complex stacking scenarios, the script stores detailed transformation data:

**Key**: `"Layer2Truck_Transformation"`

**Structure** (per layer):
```
[Layer Handle]:
  - TransformationMatrix: [4x4 transformation matrix]
  - RowIndex: [int]
  - ColumnIndex: [int]  (for vertical stacking)
  - bIsCombiTruck: [true/false]
```

This enables accurate projection and section generation for documentation.

## Calculation Methods

### Weight Calculation

Weight is determined from multiple sources in priority order:

1. **Extended Data from XML** (Panels):
   - Read from XML configuration if provided
   - Key: `"Weight"` in panel definition

2. **Property Set** (Configured Path):
   - Uses `WeightProperty` setting (e.g., `"PropertySet.Weight"`)
   - Tokenized path: PropertySetName.PropertyName

3. **Geometry-Based** (Mass Elements):
   - Calculated from body volume and material density
   - Formula: `Weight = Volume × Density`

**Weight Aggregation**:
- Layer weight = Sum of all items in layer
- Truck weight = Sum of all layers
- CombiTruck weight = Sum of multiple trucks (KLH)

### Center of Gravity Calculation

Center of gravity (COG) is calculated as the weighted average of all item positions:

```
COG = Σ(ItemWeight × ItemCenterPoint) / TotalWeight
```

**Per-Grid COG** (KLH Mode):
- Each grid calculates its own COG
- Grid COGs are weighted-averaged for truck COG
- CombiTruck COG aggregates multiple truck COGs

**Fallback**: If weight is zero or calculation fails, COG defaults to truck mid-point: `ptTruck + 0.5 × dLength × vecX`

### Axle Load Distribution (KLH)

For trucks with axle definitions, load distribution is calculated:

1. **Get Axle Positions**: Read from `AxleLoadCalculation[]` configuration
2. **Calculate Lever Arms**: Distance from COG to each axle
3. **Distribute Load**: Using moment equilibrium equations
4. **Apply Minimum Load**: Warn if any axle < MinAxleLoad setting
5. **Check Maximums**: Compare against AxleNMax settings if provided

**Display Logic**:
- Only shown if total weight ≥ 5000kg (HSB-22771)
- Requires matching Design or TruckName in axle definition
- Visual indicators: Text annotations, dimension lines, color-coded warnings

**New Equation (HSB-22608)**: Improved minimum axial weight calculation for better accuracy.

### Contact Face Detection

Contact faces are calculated by intersecting adjacent layer bodies:

1. **Get Layer Bodies**: Real bodies or envelope bodies (for performance)
2. **Boolean Intersection**: Layer[n] ∩ Layer[n+1]
3. **Project to Plane**: Project intersection to Z-plane
4. **Extract Rings**: Get outer rings only (openings excluded)
5. **Display**: Hatched projection with configurable transparency

**Performance Note**: Contact face calculation is disabled by default. Enable via context menu when needed.

### Interference Detection

Interference detection finds collisions between non-adjacent items:

1. **Collect All Item Bodies**: From all layers in truck
2. **Pairwise Intersection**: Check each pair for overlap
3. **Exclude Adjacent Layers**: Don't flag intentional layer contact
4. **Extract Interference Volume**: Boolean intersection of colliding bodies
5. **Display**: Solid volume in interference color (default: red/242)

**Performance Note**: Interference calculation is disabled by default. Enable via context menu for verification.

### Shadow Projection

Shadow projections show the cumulative footprint of stacked layers:

1. **Project Each Layer**: Body.shadowProfile(pnZ) → PlaneProfile
2. **Cumulative Union**: Shadow[n] = Shadow[n-1] ∪ Layer[n] projection
3. **Remove Openings**: Extract outer rings only
4. **Display**: Dotted outline with high transparency

**Purpose**: Visualize stacking efficiency and overhang.

## Workflow Modes

### Mode 0: Truck Mode (Full Visualization)

This is the default mode when inserting f_Truck directly.

**Characteristics**:
- Full truck outline with dimensions
- Stacking grid cells
- Head board display
- Stancion display (vertical stacking)
- Shadow projections
- Contact faces (if enabled)
- Interference detection (if enabled)
- Axle load visualization (if enabled)
- Text annotations

**Use Cases**:
- Primary stacking workflow
- Visual planning and verification
- Documentation generation
- Client presentations

**Flag**: `_Map.setInt("isTruck", true)`

### Mode 1: Grid Mode (Lightweight)

Internal mode used for multi-truck scenarios or when created by parent scripts.

**Characteristics**:
- Grid cells only (no truck outline)
- Minimal visualization
- No head board or stancions
- Optional front display block
- Optimized performance

**Use Cases**:
- CombiTruck scenarios (multiple trucks managed by parent)
- Grid-only visualization
- Embedded in larger stacking systems

**Activation**: Set `_Map.setInt("mode", 1)` before creation

**Display**: Front display block can be shown if configured via `FrontDistance[]` settings.

## Advanced Features

### Package Wrapping Flag

The script tracks whether items should be wrapped as packages:

**Set Flag** (via context menu):
1. Right-click truck → "Apply Layer Separation"
2. Select f_Item instances
3. Flag is set: `item.map().setInt("BeddingRequested", true)`

**Clear Flag** (via context menu):
1. Right-click truck → "Don't Apply Layer Separation"
2. Select f_Item instances
3. Flag is cleared

**Usage**: Downstream scripts can read this flag to insert bedding material or wrapping.

**Property Set**: Flag is written to property set as "Package Wrapping" = "Yes"/"No"

### Child Panel Creation

Generate separate panel entities from stacked items:

**Workflow**:
1. Right-click truck → "Create Child Panels"
2. System creates new entities for each stacked item
3. Entities are linked to parent items via handles
4. Transformation data is preserved

**Use Cases**:
- Export stacked items to separate processing
- Create independent copies for modification
- Interface with other TSL scripts expecting panel entities

### Nesting Integration

The script integrates with nesting tools (f_Layer handles actual nesting):

**Nesting Types**:
- Disabled: No nesting applied
- Autonester: Automatic rectangular nesting
- Rectangular Nester: Grid-based nesting

**Trigger**: When f_Layer property is set to a nester type, or when `callNester` flag is set in layer map.

**Settings**: Nesting configuration is passed through to f_Layer via map communication.

### Export Integration

Run configured exporters directly from truck context menu:

**Configuration**: Define exporter groups in XML `ExporterGroup[]` section

**Menu Generation**: Each exporter group creates a context menu item: "Run Export [Name]"

**Execution**:
1. Right-click truck → "Run Export [Name]"
2. System collects all stacked entities
3. Calls exporter with entity group
4. Exporter processes according to its configuration

**Use Cases**:
- BTL export for CNC machines
- CSV export for production planning
- Custom export formats

### Plot Viewport Generation

Two modes of plot viewport generation:

#### Mode 1: KLH Generate Plot ViewPort

**Trigger**: Right-click truck → "Generate Plot ViewPort"

**Process**:
1. Iterates through all stacking grids (packages)
2. For each package:
   - Creates hsbPivotSchedule with weight data
   - Creates plot viewport with package visualization
   - Positions viewport in paper space layout
   - Links schedule to viewport
3. Creates section views for horizontal stacking
4. Applies configured layout and scale

**Output**:
- One viewport per package
- Weight schedule table per package
- Section views (if horizontal stacking)
- Dimensions and annotations

**Requirements**:
- KLH project type
- Layout configuration in XML
- hsbPivotSchedule script available

#### Mode 2: Create Plot Viewports (General)

**Trigger**: Right-click truck → "Create Plot Viewports"

**Process**:
1. Creates one viewport per stacking row
2. Uses layout configuration from XML `Layout[]` section
3. Applies scale and positioning from settings
4. Links to truck entity for dynamic updates

**Configuration**:
1. Right-click grid → "Define Plot Viewport" to set layout and position
2. Right-click grid → "Define Plot Viewport Format" to set naming convention

**Naming Format**: Use property placeholders:
- `@(Name)` → Truck name
- `@(Number)` → Truck number
- `@(Type)` → Stacking type
- Example: `"Truck_@(Name)_Row_@(LayerIndex)"` → `"Truck_Truck 1_Row_1"`

**Output**:
- One viewport per row
- Configurable naming
- Dynamic link to source geometry

### Bedding Grid Creation

For horizontal stacking, create support grid visualization:

**Workflow**:
1. Right-click grid → "Add Bedding Grid"
2. System creates f_Grid instances
3. Grids are positioned at layer contact points
4. EdgeOffset applied from settings

**Purpose**:
- Visualize bedding material placement
- Plan support structure
- Verify load distribution

**Configuration**: `BeddingGrid\EdgeOffset` setting controls grid inset from layer edges.

### Stancion Display (Vertical Stacking)

For vertical stacking, stancions (support posts) are displayed:

**Configuration**:
- Width, Height: Stancion dimensions
- Color, Transparency: Display properties
- Optional: BlockName and BlockPath for custom block reference

**Positioning**: Stancions are placed at grid column boundaries

**Disable**: Set Width or Height to 0 in settings

**Transparency**: Can be configured for x-ray visualization through stacked items

### Truck Front Display (Grid Mode)

In Grid Mode, truck front can be displayed using block references:

**Configuration** (`FrontDistance[]`):
- TruckName: Match truck name or leave empty for all
- Design: Match design type
- Distance: Offset from grid origin
- BlockName: Block definition name

**Purpose**: Visual reference in grid-only mode

**Fallback**: If block not found, system continues without error

### Dimension Display (KLH)

For KLH projects, truck and package dimensions can be toggled:

**Trigger**: Right-click grid → "Show/Hide truck dimensions"

**Display Elements**:
- Truck outline dimensions (Length, Width, Height)
- Package dimensions
- Row positions
- Grid cell dimensions

**Positioning** (HSB-22893): Dimensions positioned relative to truck sections for clarity

**Orientation** (HSB-24485): Fixed dimension orientation for KLH mode

### Transformation Tracking (CombiTruck)

For complex KLH scenarios with multiple layers per row:

**Purpose**: Track exact transformation for each layer separately

**Storage**: `"Layer2Truck_Transformation"` map with per-layer matrices

**Usage**:
- Accurate section generation
- Projection for documentation
- Export with correct positioning

**Critical**: Enables CombiTruck workflow where multiple trucks are combined

## Performance Considerations

### Envelope Body vs Real Body

**Default**: Script uses `envelopeBody()` for performance when possible

**Real Body**: Used only when accuracy is critical:
- Contact face calculation
- Interference detection
- Weight calculation (mass elements)

**Settings Note**: For complex solids (high resolution), body combining is optimized (HSB-9303)

### Display Toggles

The script provides performance toggles:

| Feature | Default | Performance Impact | When to Enable |
|---------|---------|-------------------|----------------|
| Contact Faces | Hidden | High (Boolean operations) | Verification only |
| Interference | Hidden | Very High (Pairwise intersections) | Collision checking |
| Shadow Projections | Visible | Medium (Projection operations) | Always useful |
| Axle Load | Hidden | Low (Calculation only) | KLH projects with load data |

**Recommendation**: Keep contact faces and interference hidden during stacking, enable for final verification.

### SubMapX vs Property Sets

**Property Set Mode**:
- Standard AutoCAD property sets
- Slower write operations
- Better integration with AutoCAD tools
- Recommended for projects with < 100 stacked items

**SubMapX Mode** (HSB-9858):
- Custom hsbCAD storage
- ~10x faster write operations
- Optimized for large projects
- Recommended for projects with 100+ stacked items

**Configuration**: Set `SourceEntity\PropsetName = "subMapX"` in XML

### Dependency Management

The script sets dependencies carefully to avoid excessive recalculation:

**Dependencies Set**:
- MapObject (settings): `setDependencyOnDictObject(mo)`
- Child layers: `setDependencyOnEntity(layer)` for each layer
- klhStackMatrix: Dependency set on creation (KLH only)

**Dependencies NOT Set**:
- Individual items (managed by layers)
- Property sets (read-only)
- Plot viewports (static after creation)

**Recalculation Triggers**:
- Property changes in OPM
- Child entity changes (layers)
- Settings MapObject changes
- Context menu commands

### Execution Loops

Some operations require multiple calculation passes:

```tsl
setExecutionLoops(2);  // Request 2-pass calculation
```

**Two-Pass Operations**:
- Add Layer (recalc truck after layer creation)
- Property toggle (update display immediately)
- Plot viewport generation (ensure all data is ready)

**Purpose**: Ensure all child entities are created and recalculated before final truck display.

## Tips and Best Practices

### 1. Automatic Numbering
Leave the Number property at 0 to let the system automatically assign sequential truck numbers. This prevents conflicts and ensures proper ordering.

### 2. Stacking Order
Items are arranged in layers. The system automatically determines the row based on the selection location and item bounds. Double-click to add new layers to a grid cell.

### 3. Bedding Heights
For horizontal stacking, the system prompts for bedding height when adding layers:
- **Press Enter**: Accept default bedding height (from settings or previous row)
- **Type Value**: Override with custom bedding height
- **System Memory**: Bedding heights are stored per row in `_Map.getMap("RowBeddings")`

**Default Selection**:
- If row has existing bedding: Use that value
- If row is new: Use indexed default from `Layer\Bedding[]` settings
- If index exceeds array: Use last entry in array

### 4. Performance Optimization
- **Disable Displays**: Keep interference and contact face displays off by default
- **Use SubMapX**: For large projects (100+ items), configure `PropsetName="subMapX"`
- **Hide Rows**: Use "Hide additional row" to reduce visible geometry
- **Limit Bedding Grids**: Only create bedding grids where needed

### 5. KLH Projects
The script detects KLH project type automatically via `projectSpecial()` function:
- **Auto-Locked Properties**: Properties are read-only by default
- **Unblock to Edit**: Right-click → "Unblock Properties" to enable editing
- **Re-Lock**: Right-click → "Block Properties" to protect settings
- **Additional Features**: Axle load, plot viewports, dimension display

### 6. Export Integration
Configure exporter groups in XML for one-click export:
- Define multiple export targets (BTL, CSV, custom formats)
- Each creates a context menu item
- Exports all stacked entities in one operation
- Useful for production planning integration

### 7. Plot Viewport Workflow
For efficient documentation:
1. **Configure First**: Use "Define Plot Viewport" to set layout and position
2. **Set Naming**: Use "Define Plot Viewport Format" with property placeholders
3. **Generate**: Use "Generate Plot ViewPort" (KLH) or "Create Plot Viewports"
4. **Verify**: Check paper space for created viewports
5. **Regenerate**: Delete viewports and regenerate if settings change

### 8. Child Panel Usage
Use "Create Child Panels" when:
- Exporting to external systems that expect separate entities
- Processing stacked items with other TSL scripts
- Creating independent copies for modification
- Interfacing with non-stacking-aware tools

### 9. Weight Data Accuracy
For accurate weight calculations:
- **Panels**: Provide weight in XML extended data
- **Elements**: Ensure property sets have weight values
- **Mass Elements**: Verify material density in hsbCAD settings
- **Path Configuration**: Set correct `WeightProperty` path in XML

### 10. Truck Type Selection
Choose truck type carefully (cannot change after creation):

**Horizontal Stacking**:
- Use for: Floor panels, CLT slabs, flat components
- Benefits: Bedding grids, single column layout, simple workflow
- Considerations: Requires more truck length

**Vertical Stacking**:
- Use for: Wall panels, tall components
- Benefits: More efficient use of truck volume, stancion display
- Considerations: More complex grid (left/right columns), stability concerns

### 11. Design Selection
Choose design based on transport requirements:

| Design | Best For | Key Features |
|--------|----------|--------------|
| Open Truck | Standard framing | Simple, versatile |
| Closed Truck | Weather protection | Roof visualization |
| Container | Shipping | Standard dimensions |
| Package | Bundled materials | Wrapping flags |
| Laaprs woodrailer | KLH transport | Specialized axle config |
| Individuell | Custom trucks | Full customization |

### 12. Layer Separation Workflow
For projects requiring bedding between layers:
1. Stack items normally using "Add Layer"
2. After stacking is complete, select items that need bedding
3. Right-click truck → "Apply Layer Separation"
4. Select f_Item instances that should have bedding below them
5. Flag is set for downstream processing
6. Bedding insertion is handled by separate production scripts

### 13. Avoiding Common Errors

**Error**: "No items found"
- **Cause**: Selected entities are not valid stackable items
- **Solution**: Ensure entities are GenBeam, Element, Sheet, Sip, or mass elements

**Error**: "Layer creation failed"
- **Cause**: Insufficient permissions or invalid insertion point
- **Solution**: Check drawing is not read-only, verify insertion point is valid

**Error**: "Axle load not displayed"
- **Cause**: Weight < 5000kg or no axle definition
- **Solution**: Verify weight data, check `AxleLoadCalculation[]` configuration, ensure Design matches

**Error**: "Properties are grayed out"
- **Cause**: Properties locked (KLH mode) or after insertion
- **Solution**: Right-click → "Unblock Properties" for KLH, or Type/Design are permanently locked

**Error**: "Plot viewports not created"
- **Cause**: Missing layout template or invalid configuration
- **Solution**: Verify layout exists in drawing, check `Layout[]` XML configuration

### 14. Settings File Best Practices

**Organize by Project**:
- Keep default settings in company path
- Create project-specific settings for special requirements
- Use MapObject for drawing-specific overrides

**Version Control**:
- Track f_Stacking.xml in version control
- Document changes to axle definitions
- Keep backup of working configurations

**Testing**:
- Test settings with sample truck before production
- Verify axle load calculations against known values
- Check export integration with downstream tools

## Frequently Asked Questions

### Q: How do I change the truck type after creation?

**A**: The Type property (Horizontal/Vertical) cannot be changed after creation because it fundamentally changes the grid structure and layer logic. To change type:
1. Create a new truck with the desired type
2. Note the items from the old truck (before deleting)
3. Re-add items to the new truck using "Add Layer"
4. Delete the old truck

**Why?**: Grid cell structure, layer positioning, and coordinate systems differ between horizontal and vertical stacking.

### Q: Why are my properties grayed out?

**A**: Properties are read-only in these scenarios:

1. **KLH Projects** (Most Common):
   - Properties locked by default (controlled by `PropertyReadOnly` flag in XML)
   - **Solution**: Right-click truck → "Unblock Properties"
   - **Re-lock**: Right-click truck → "Block Properties"

2. **Type and Design Properties** (Always):
   - Locked after insertion because they define fundamental structure
   - **Solution**: Create new truck with desired type/design

3. **Settings-Driven Lock**:
   - Check `PropertyReadOnly` setting in f_Stacking.xml
   - Set to 0 to disable automatic locking

### Q: How do I remove items from a layer?

**A**: Items are managed through layers:

**Remove Entire Layer**:
1. Select the f_Layer entity (the layer itself, not the truck)
2. Press Delete or use ERASE command
3. Items remain in drawing but are no longer stacked

**Remove Individual Items**:
1. Items are transformed and stored as f_Item instances
2. Deleting an f_Item removes it from the stack
3. Original source entities remain unchanged

**Reset Everything**:
1. Delete the f_Truck entity
2. All f_Layer and f_Item children are removed
3. Source entities remain intact

### Q: Why doesn't the axle load calculation appear?

**A**: Axle load calculation requires all of these conditions:

1. **KLH Project Type**: `projectSpecial()` must return "KLH"
2. **Axle Definition**: `AxleLoadCalculation[]` must exist in XML
3. **Design Match**: Axle definition's Design must match truck's Design property
4. **Sufficient Weight**: Total loaded weight must be ≥ 5000kg (HSB-22771)
5. **Enabled**: Right-click truck → "Show axle load calculation"

**Troubleshooting**:
- Check XML for `<lst nm="AxleLoadCalculation[]">` section
- Verify Design name matches (case-insensitive, after translation)
- Calculate total weight: Check `_Map.getDouble("WeightCombi")`
- Enable display via context menu

**Design Matching**: Multiple designs can be specified separated by semicolons:
```xml
<str nm="Design" vl="Laaprs woodrailer;Open Truck"/>
```

### Q: How do I add custom truck designs?

**A**: Add design definitions to the f_Stacking.xml settings file:

1. **Edit XML** at `[Company Path]\TSL\Settings\f_Stacking.xml`

2. **Add to Design[] Section**:
```xml
<lst nm="Design[]">
  <lst nm="LayoutCustom">  <!-- Unique key -->
    <str nm="Name" vl="Custom Truck"/>
    <int nm="Color" vl="252"/>
    <dbl nm="RowOffset" ut="L" vl="800"/>
    <!-- Add custom settings -->
  </lst>
</lst>
```

3. **Optional: Add Axle Definition**:
```xml
<lst nm="AxleLoadCalculation[]">
  <lst nm="0">
    <str nm="Design" vl="Custom Truck"/>
    <dbl nm="Axle1" ut="L" vl="1500"/>
    <dbl nm="Axle2" ut="L" vl="6000"/>
    <!-- ... -->
  </lst>
</lst>
```

4. **Reload Settings**:
   - Delete MapObject from drawing dictionary (MAPOBJCTRL command in hsbCAD)
   - Or close and reopen drawing
   - Insert new f_Truck - custom design appears in dropdown

### Q: What is the difference between Horizontal and Vertical stacking?

**A**: The two types differ fundamentally:

| Aspect | Horizontal | Vertical |
|--------|-----------|----------|
| **Orientation** | Elements lie flat | Elements stand upright |
| **Grid Layout** | One column | Two columns (left/right) |
| **Best For** | Floor panels, CLT slabs, flat components | Wall panels, tall components |
| **Bedding** | Bedding heights supported | No bedding (stancions instead) |
| **Visual Elements** | Bedding grids, shadow projections | Stancions, dual columns |
| **Alignment** | Centered on truck bed | Left/right alignment |
| **Height Limit** | Layer thickness limit | Truck height limit |
| **Row Offset** | Vertical spacing (Y-axis) | Horizontal spacing (X-axis) |

**Choosing**:
- **Horizontal**: When element thickness < width/height
- **Vertical**: When element height > thickness and width
- **Cannot Change**: Type is locked after creation

### Q: How do I generate documentation for the truck?

**A**: Two methods for plot viewport generation:

#### Method 1: KLH Generate Plot ViewPort

**Use When**: KLH projects, need weight schedules

**Steps**:
1. Ensure items have weight data
2. Right-click truck → "Generate Plot ViewPort"
3. System creates:
   - One viewport per package
   - hsbPivotSchedule with weight per package
   - Section views (if horizontal stacking)
4. Check paper space for viewports

**Configuration**: Requires `Layout[]` section in XML

#### Method 2: Create Plot Viewports (General)

**Use When**: All projects, general documentation

**Steps**:
1. **Define Layout** (first time):
   - Right-click grid → "Define Plot Viewport"
   - Select paper layout from dropdown
   - Set viewport position and scale

2. **Set Naming** (optional):
   - Right-click grid → "Define Plot Viewport Format"
   - Use placeholders: `@(Name)`, `@(Number)`, etc.
   - Example: `"Truck_@(Name)_Row_@(LayerIndex)"`

3. **Generate**:
   - Right-click truck → "Create Plot Viewports"
   - One viewport per row is created

**Result**: Viewports in paper space, linked to truck geometry

### Q: What happens when I apply layer separation?

**A**: The "Apply Layer Separation" command marks items for bedding insertion:

**Process**:
1. Right-click truck → "Apply Layer Separation"
2. Prompt appears: "Select f_Item instances"
3. Select items that should have bedding BELOW them
4. System sets flag: `item.map().setInt("BeddingRequested", true)`
5. Flag is written to property set: "Package Wrapping" = "Yes"

**Purpose**:
- Signals downstream production scripts to insert bedding material
- Bedding is placed between this layer and the next
- Typically used for protective layers (foam, cardboard, plastic)

**Removing**:
- Right-click truck → "Don't Apply Layer Separation"
- Select same items
- Flag is cleared

**Note**: The f_Truck script only sets the flag. Actual bedding insertion is handled by separate production or export scripts.

### Q: How is weight calculated for stacked items?

**A**: Weight can come from multiple sources (in priority order):

#### 1. Extended Data in XML (Panels)

Most accurate for known products:
```xml
<lst nm="Panel">
  <str nm="Name" vl="Panel_A"/>
  <dbl nm="Weight" vl="450"/>  <!-- kg -->
</lst>
```

**Detected**: When panel configuration exists in XML

#### 2. Property Set on Entity

Configured via `WeightProperty` setting:
```xml
<str nm="WeightProperty" vl="PropertySet.Weight"/>
```

**Format**: `PropertySetName.PropertyName`

**Example**: If entity has property set "Materials" with property "NetWeight", set:
```xml
<str nm="WeightProperty" vl="Materials.NetWeight"/>
```

#### 3. Geometry-Based (Mass Elements)

For entities without explicit weight:
```
Weight = Body.volume() × Material.density()
```

**Density**: Read from hsbCAD material database

**Note**: Least accurate, use explicit weight when possible

#### Center of Gravity Calculation

Weighted average of all item positions:
```
COG = Σ(ItemWeight × ItemCenterPoint) / TotalWeight
```

**Per-Grid COG** (KLH): Each grid calculates independently, then aggregated for truck COG.

**Fallback**: If weight is zero, COG defaults to truck mid-point.

### Q: How do I handle multiple trucks in one drawing?

**A**: Several approaches:

#### Approach 1: Multiple Independent Trucks

Simply insert multiple f_Truck instances:
1. Insert first truck normally
2. Insert second truck at different location
3. Each truck has independent numbering (unless set manually)
4. Each truck manages its own layers and items

**Numbering**: Set Number property > 0 for manual control, or leave at 0 for automatic sequential numbering.

#### Approach 2: CombiTruck (KLH Projects)

For related trucks managed together:
1. Parent script creates multiple f_Truck instances in Grid Mode (nMode=1)
2. Each truck shares items from central pool
3. Transformations tracked separately per layer
4. Combined weight and COG calculations

**Configuration**: Requires custom parent script and XML configuration

#### Approach 3: Package System

For package-based stacking:
1. Use Design = "Package"
2. Create packages first
3. Assign packages to trucks
4. Track via PackageNumber property

**Property Set**: Package Number is written to stacked entities

### Q: Can I export the stacking data?

**A**: Yes, multiple export methods:

#### 1. Property Sets

Stacking data is written to source entities:
- Property Set Name: "Stacking" (or configured name)
- Properties: Number, Name, Type, Design, Layer Index, Package Number
- **Access**: AutoCAD's PROPERTIES command or EATTEXT for export

#### 2. SubMapX (Performance Mode)

Configure `PropsetName="subMapX"` for better performance:
- Data stored in entity.subMapX("Hsb_Item")
- Accessible via TSL scripts
- Not visible in standard AutoCAD PROPERTIES palette

#### 3. Exporter Groups

Configure automated export in XML:
```xml
<lst nm="ExporterGroup[]">
  <lst nm="0">
    <str nm="Name" vl="Export to BTL"/>
    <str nm="ExporterGroup" vl="BTL_Stacking"/>
  </lst>
</lst>
```

**Usage**: Right-click truck → "Run Export [Name]"

#### 4. hsbReport Integration

The truck publishes entity array to `_Map`:
```tsl
Entity ents[] = truck.map().getEntityArray("EntityRef[]", "", "Handle");
```

**Access**: Query from _hsbReport or other reporting tools

#### 5. Plot Viewports with Schedules

Generate documentation with weight schedules:
- Right-click → "Generate Plot ViewPort" (KLH)
- Creates hsbPivotSchedule tables
- Viewports can be plotted to PDF or paper

### Q: How do I troubleshoot slow performance?

**A**: Performance optimization checklist:

#### 1. Disable Expensive Displays

```
Right-click → Hide interferences (very expensive)
Right-click → Hide contact faces (expensive)
```

Keep shadow projections visible - they're optimized.

#### 2. Use SubMapX Mode

Edit f_Stacking.xml:
```xml
<str nm="PropsetName" vl="subMapX"/>
```

**Benefit**: ~10x faster write operations for large projects

#### 3. Use Envelope Bodies

The script automatically uses `envelopeBody()` for most operations. Don't force `realBody()` unless necessary.

#### 4. Limit Bedding Grids

Only create bedding grids where needed:
- Right-click → "Add Bedding Grid" selectively
- Don't create for every layer

#### 5. Hide Additional Rows

If not needed:
- Right-click → "Hide additional row"
- Reduces visible geometry

#### 6. Reduce Sequential Colors

Fewer colors = less color changing overhead:
```xml
<lst nm="SequentialColor[]">
  <int nm="1" vl="14"/>
  <int nm="2" vl="94"/>
  <!-- Fewer entries -->
</lst>
```

#### 7. Optimize Complex Solids (HSB-9303)

For high-resolution bodies, the script includes optimizations:
- Body combining improved
- Envelope bodies used more aggressively
- Automatic simplification

**If Still Slow**:
- Check for extremely complex geometry
- Simplify source elements if possible
- Consider splitting into multiple trucks

### Q: Can I customize the truck outline display?

**A**: Yes, via XML settings:

#### Truck Outline

```xml
<lst nm="Truck">
  <int nm="Color" vl="252"/>
  <str nm="Linetype" vl="CONTINUOUS"/>

  <!-- Add thickness (HSB-19483) -->
  <lst nm="Contour">
    <dbl nm="Thickness" ut="L" vl="50"/>
    <str nm="ApplyTo" vl="Inside"/>  <!-- Inside|Outside|Center -->
  </lst>
</lst>
```

#### Grid Lines

```xml
<lst nm="Grid">
  <int nm="Color" vl="250"/>
  <str nm="Linetype" vl="Dashed"/>
  <dbl nm="LinetypeScale" ut="L" vl="10"/>
</lst>
```

#### Shadow Projections

```xml
<lst nm="LayerShadow">
  <int nm="Color" vl="78"/>
  <str nm="Linetype" vl="DOTS"/>
  <int nm="Transparency" vl="100"/>  <!-- 0-100 -->
</lst>
```

#### Sequential Colors

Change layer colors:
```xml
<lst nm="SequentialColor[]">
  <int nm="1" vl="14"/>  <!-- Red -->
  <int nm="2" vl="94"/>  <!-- Blue -->
  <int nm="3" vl="134"/> <!-- Green -->
  <!-- ... -->
</lst>
```

**Reload**: Delete MapObject and recalc truck to apply changes.

## Workflow Example: Planning a CLT Panel Delivery

This comprehensive example walks through a complete stacking workflow:

### Step 1: Prepare the Model

1. **Ensure Panels are Ready**:
   - CLT wall panels modeled as Elements or GenBeams
   - Each panel has identification (posnum, label)
   - Optional: Weight data in property sets or XML

2. **Check Settings**:
   - Verify f_Stacking.xml exists in `[Company Path]\TSL\Settings\`
   - Confirm axle definitions for your truck type
   - Check layout templates in paper space

### Step 2: Create the Truck

1. **Run f_Truck Script**:
   - Type script name or select from menu
   - Or use execute key: `_kExecuteKey=DELIVERY_A`

2. **Configure Properties**:
   - **Length**: 13600mm (standard truck)
   - **Width**: 2500mm
   - **Height**: 2700mm
   - **Number**: 0 (automatic)
   - **Name**: "Delivery A - Monday"
   - **Type**: "Horizontal" (panels lying flat)
   - **Design**: "Laaprs woodrailer" (KLH trailer)

3. **Place Truck**:
   - Click point in model space
   - Truck outline and grid appear
   - Coordinate system displayed at insertion point

### Step 3: Add First Layer

1. **Double-Click First Grid Cell**:
   - Click on grid cell in row 1

2. **Select Panels**:
   - Prompt: "Select item(s)"
   - Window-select 8 wall panels (W01-W08)
   - Press Enter to confirm

3. **Set Bedding Height**:
   - Prompt: "<Enter> to insert with bedding height [80]"
   - Press Enter to accept 80mm default
   - Or type "100" for 100mm bedding

4. **Wait for Processing**:
   - f_Layer instance created
   - f_Item instances created for each panel
   - Nesting applied (if configured)
   - Items displayed with color 1 (sequential coloring)

5. **Verify Layer**:
   - Check panels are positioned correctly
   - Shadow projection shows footprint
   - Layer appears in grid cell

### Step 4: Add Additional Layers

1. **Determine Row Automatically**:
   - System calculates row based on item bounds
   - No need to manually select row number

2. **Add Second Layer**:
   - Double-click second grid cell (or same cell for second row)
   - Select next 8 panels (W09-W16)
   - Press Enter for bedding height (defaults to 80mm from row 1)
   - Or type new value if different

3. **Add Third Layer**:
   - Double-click third grid cell
   - Select panels W17-W24
   - Bedding height prompt uses last value as default
   - Layers stack automatically

4. **Continue Until Full**:
   - Keep adding layers until truck is full
   - System warns if exceeding height limit
   - Shadow projection shows cumulative footprint

### Step 5: Verify Stacking

1. **Check Contact Faces**:
   - Right-click grid → "Show contact faces"
   - Verify layers are properly seated
   - Look for gaps or misalignments
   - Right-click → "Hide contact faces" when done

2. **Check Interferences**:
   - Right-click grid → "Show interferences"
   - Red volumes indicate collisions
   - Adjust items if collisions found
   - Right-click → "Hide interferences" to restore performance

3. **View Shadow Projection**:
   - Shadow shows cumulative footprint
   - Check for overhang beyond truck width
   - Verify efficient use of truck length

### Step 6: Apply Layer Separation (If Needed)

1. **Identify Layers Needing Bedding**:
   - Heavy layers that need extra protection
   - Layers between different panel types
   - Per production requirements

2. **Apply Separation**:
   - Right-click truck → "Apply Layer Separation"
   - Prompt: "Select f_Item instances"
   - Select items in layers that need bedding below
   - Press Enter

3. **Verify Flag**:
   - Property Set "Package Wrapping" = "Yes" for selected items
   - Flag stored for downstream processing

### Step 7: Check Weight and Load Distribution

1. **Enable Axle Load Display**:
   - Right-click truck → "Show axle load calculation"
   - Axle positions displayed
   - Load per axle shown with text annotations
   - Center of gravity marked

2. **Verify Load Requirements**:
   - Check total weight (sum of axle loads)
   - Verify no axle exceeds maximum (if configured)
   - Check minimum axle load warnings (typically 5000kg)
   - Adjust panel distribution if needed

3. **Color-Coded Warnings**:
   - **Red**: Overload or under minimum
   - **Green**: Within acceptable range
   - **Yellow**: Near limits

### Step 8: Generate Documentation

1. **KLH Plot Viewports**:
   - Right-click truck → "Generate Plot ViewPort"
   - System creates:
     - One viewport per package
     - hsbPivotSchedule with weights
     - Section views (if horizontal stacking)
   - Check paper space for viewports

2. **Standard Plot Viewports** (Alternative):
   - First time: Right-click grid → "Define Plot Viewport"
     - Select layout: "A3_Landscape"
     - Set scale: 1:50
     - Set position: X=50, Y=50
   - Right-click grid → "Define Plot Viewport Format"
     - Set format: "Truck_@(Name)_Row_@(LayerIndex)"
   - Right-click truck → "Create Plot Viewports"
   - One viewport per row created

3. **Verify Viewports**:
   - Switch to paper space
   - Check viewport positioning
   - Verify scales are correct
   - Adjust viewport borders if needed

### Step 9: Export Data (If Configured)

1. **Run Exporter**:
   - Right-click truck → "Run Export BTL" (if configured)
   - System collects all stacked entities
   - Calls exporter with entity group
   - Check export output folder

2. **Verify Export**:
   - Check BTL file contains all panels
   - Verify panel positions are correct
   - Confirm stacking data is included

### Step 10: Create Delivery Schedule

1. **Generate Weight Schedule**:
   - If using KLH method, hsbPivotSchedule already created
   - If manual, use hsbReport to query truck data:
     ```tsl
     Entity truck;
     truck.setFromHandle("[truck handle]");
     Entity ents[] = truck.map().getEntityArray("EntityRef[]", "", "Handle");
     // Process entities for report
     ```

2. **Extract Property Sets**:
   - Use AutoCAD EATTEXT to extract stacking property sets
   - Export to Excel or CSV
   - Format as delivery schedule

3. **Print Documentation**:
   - Plot viewports to PDF
   - Include:
     - Truck plan view
     - Section views
     - Weight schedule
     - Stacking sequence
   - Distribute to production and shipping

### Summary

**Total Time**: ~15-30 minutes for 30-40 panels
**Result**: Fully documented truck with weight data, plot viewports, and export files

**Key Points**:
- Double-click workflow is fastest
- System handles transformations automatically
- Weight and COG calculated in real-time
- Documentation generation is semi-automatic
- Export integration streamlines production handoff

## Troubleshooting Guide

### Common Issues and Solutions

| Issue | Symptom | Cause | Solution |
|-------|---------|-------|----------|
| **Items not selectable** | Cannot select items in "Add Layer" | Items not valid for stacking | Ensure items are GenBeam, Element, Sheet, Sip, or mass elements |
| **Bedding height prompt doesn't appear** | No prompt when adding layer | Vertical stacking mode | Vertical stacking doesn't use bedding heights (stancions instead) |
| **Grid cells too small/large** | Grid doesn't match truck size | RowOffset/ColumnOffset settings | Adjust settings in f_Stacking.xml: `RowOffset`, `ColumnOffset` |
| **Shadow projection incorrect** | Shadow doesn't match items | Body calculation error | Check item geometry is valid, try recalculating truck |
| **Weight shows zero** | Weight is 0 despite items | No weight data source | Add weight to property sets or XML, verify `WeightProperty` path |
| **Axle load not calculating** | No axle display appears | See FAQ "Why doesn't axle load appear?" | Verify KLH mode, weight ≥5000kg, axle definition exists |
| **Plot viewports off-position** | Viewports not where expected | Layout configuration error | Check `Layout[]` settings, verify paper space layout exists |
| **Properties locked** | Cannot edit truck dimensions | Read-only mode (KLH) | Right-click → "Unblock Properties" |
| **Layers not stacking** | New layers don't appear | Insertion point calculation error | Check item bounds are valid, try manual placement |
| **Performance very slow** | Truck recalculates slowly | Contact faces/interference enabled | Right-click → Hide expensive displays, use SubMapX mode |
| **Export fails** | Export command does nothing | Exporter group not configured | Check `ExporterGroup[]` in XML, verify exporter exists |
| **Nesting not working** | Items overlap unnecessarily | Nesting disabled or failed | Check f_Layer nesting property, verify nester is available |
| **Stancion not visible** | No stancions in vertical mode | Width or Height set to 0 | Check `Stancion[]` settings, ensure Width > 0 and Height > 0 |
| **Head board missing** | No truck front display | Row setting incorrect | Check `HeadBoard\Row` setting, verify matches desired row |
| **Colors all same** | No sequential coloring | SequentialColor[] not configured | Add color array to XML settings |
| **Contact faces show nothing** | Enabled but no display | Layers don't contact | Verify layers overlap in Z-direction, check layer spacing |
| **Interference false positives** | Shows collisions that aren't real | Tolerance too tight | This is expected - interference shows all overlaps including intentional contact |
| **klhStackMatrix not created** | Missing in KLH projects | Not created on insertion | Check project type, verify `_bOnDbCreated` trigger, manually insert if needed |
| **Transformation errors** | Items positioned incorrectly | Coordinate system mismatch | Truck locks to WCS - ensure source items are in correct coordinates |
| **Property set not written** | No stacking properties on entities | SubMapX mode enabled | Check `PropsetName` setting - if "subMapX", data is in subMapX not property sets |

### Error Messages

| Message | Meaning | Action |
|---------|---------|--------|
| "No items found" | Selected entities invalid | Select valid stackable entities (GenBeam, Element, etc.) |
| "Layer creation failed" | f_Layer couldn't be created | Check permissions, verify insertion point valid, check log for details |
| "Invalid truck handle" | Parent reference broken | Recreate truck, avoid moving or copying incorrectly |
| "Settings file not found" | f_Stacking.xml missing | Script creates default settings - check company path |
| "MapObject creation failed" | Dictionary write error | Check drawing is not read-only, verify permissions |
| "Block definition not found" | Referenced block missing | Check block path, or disable block reference in settings |
| "Layout not found" | Paper layout doesn't exist | Create layout or update `Layout[]` configuration |
| "Exporter group not found" | Export configuration invalid | Verify `ExporterGroup[]` settings, check exporter name |
| "Weight calculation failed" | Cannot determine weight | Add weight to property sets or XML, verify geometry valid |

### Debug Mode

Enable debug output for troubleshooting:

```tsl
int bDebug = _bOnDebug;  // Automatically enabled in debug mode
```

**Activate Debug Mode**:
1. Set system variable in hsbCAD
2. Or modify script temporarily: `int bDebug = true;`

**Debug Output**:
- Console messages with detailed execution flow
- Visual coordinate system display (colored vectors)
- Map contents logged to command line
- Entity handles and relationships displayed

**Example Debug Output**:
```
f_Truck: 8 items collected to create a new layer.
f_Truck: f_Layer created with key Hsb_GridParent: [map contents]
Property Set Stacking successfully created.
f_Truck: writing Stacking to [handle] map: [map contents]
```

## Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| **6.70** | Nov 2025 | Store transformation for each layer separately (multi-layer per row) |
| **6.69** | Sep 2025 | Adjustment to hsbPivotSchedule and PlotViewport creation points |
| **6.68** | Sep 2025 | Fix transformation for vertical stacking (nType==1 && nDesign==2) |
| **6.67** | Sep 2025 | Change position of hsbPivotSchedule |
| **6.66-6.65** | Sep 2025 | Update Layer2Truck transformation for KLH |
| **6.64** | Sep 2025 | Fix when saving "mapsCombi" |
| **6.63** | Sep 2025 | For KLH, fix dimension orientation and starting point |
| **6.62-6.61** | Aug 2025 | Fix transformation for KLH, fix translation |
| **6.60** | Aug 2025 | Adjustment to hsbPivotSchedule creation point |
| **6.59** | Aug 2025 | For KLH: Clean/update "Package wrapped" variable, show "Apply Layer Separation" command |
| **6.58** | Jul 2025 | For panels get weight from extended data if provided in XML |
| **6.57** | Jul 2025 | Dbcreate klhStackMatrix on dbCreated |
| **6.56** | Jul 2025 | Differentiate FrontDistance with truck name; "SubDesign[]" in XML |
| **6.55** | Jun 2025 | Change plot viewport distances for sections |
| **6.54** | Jun 2025 | Display block for front of truck in Grid; extend XML |
| **6.53** | Jun 2025 | Missing transformation for KLH |
| **6.52-6.51** | Jun 2025 | For KLH: save body volume for combi truck, fix shadow at horizontal stacking |
| **6.50** | May 2025 | New commands to generate plot viewports (default only) |
| **6.49-6.45** | May 2025 | Fix section projections, transformation for KLH modes |
| **6.44** | Feb 2025 | Save single bodies in an array |
| **6.43** | Feb 2025 | KLH: save each grid in separate map for Combi |
| **6.42** | Feb 2025 | Provide weight and COG of combiTruck |
| **6.41** | Jan 2025 | For KLH distinguish items from CombiTruck |
| **6.40** | Dec 2024 | Write body, planeprofile, weight and COG to _Map |
| **6.39** | Oct 2024 | Set dim positions relative to truck sections |
| **6.38** | Oct 2024 | Add package dimensions for KLH |
| **6.37** | Oct 2024 | Show min weight text only when truck loaded (≥5000kg) |
| **6.36** | Sep 2024 | New equation for min axial weight |
| **6.35** | Aug 2024 | For KLH show each item in grid |
| **6.34-6.32** | Jul 2024 | Fix and write top/bottom plate flag from layers |
| **6.31** | Apr 2024 | Consider min axle load in calculation |
| **6.30** | Nov 2023 | Avoid duplicated instances of hsbPivotSchedule |
| **6.29** | Nov 2023 | Create hsbPivotSchedule with weight for each package |
| **6.28** | Sep 2023 | Apply contour thickness on inside |
| **6.27-6.26** | Sep 2023 | KLH: Show weight without axle definition, fix read-only properties |
| **6.25** | Jul 2023 | Only take relevant properties when changing stacking extended properties |
| **6.24** | Jul 2023 | Apply thickness to outer contour for Truck and Grid |
| **6.23-6.22** | Jun 2023 | Use PropertyReadOnly flag from XML, set properties read-only for KLH |
| **6.21** | Jun 2023 | Remove display for KLH |
| **6.20** | May 2023 | Set BeddingRequested flag for f_Item |
| **6.19** | May 2023 | Change RowOffset for KLH (distance top to top) |
| **6.18** | May 2023 | Add command "Generate Plot ViewPort" |
| **6.17** | Mar 2023 | Design "Individuell" contains multiple axle definitions |
| **6.16** | Mar 2023 | For KLH get net weight from property set |
| **6.15-6.10** | Jan-Mar 2023 | Fix weight calculation, layer separation flag, load distribution for each axle |
| **6.9** | May 2022 | After projection, remove segments with zero length |
| **6.8** | Apr 2022 | Fix when writing "StackingData" mapX |
| **6.7-6.5** | Nov 2020 | Bugfix stacking data to child entities, package data, HSB-9858 |
| **6.4** | Nov 2020 | New feature: subMapX mode for better performance (HSB-9858) |
| **6.3** | Oct 2020 | Body combining improved for complex solids (HSB-9303) |
| **6.2** | Oct 2020 | New design "Package" for lorry stacking (HSB-8965) |
| **6.1-6.0** | Sep 2020 | Layer transformation bugfix, weight published (HSB-9292, HSB-8915) |
| **5.9-5.0** | 2019-2020 | Package data published, COG calculation, parent UID, package wrapping |
| **Earlier** | 2017-2019 | Initial development, vertical/horizontal stacking, settings system |

**Development Philosophy**: The script has evolved from a simple stacking tool to a comprehensive logistics planning system, with particular focus on KLH/CLT workflows since version 6.10.

## Related Scripts

### Primary Children

| Script | Relationship | Purpose |
|--------|--------------|---------|
| **f_Layer** | Created by "Add Layer" command | Represents one horizontal or vertical row of stacked items. Manages nesting, item positioning, and row-level calculations. |
| **f_Item** | Created by f_Layer | Represents individual transformed elements within a layer. Stores transformation matrices and parent references. |
| **f_Grid** | Created by "Add Bedding Grid" command | Bedding support grid for horizontal stacking. Visualizes bedding material placement. |

### Support Scripts

| Script | Relationship | Purpose |
|--------|--------------|---------|
| **hsbPivotSchedule** | Auto-generated by "Generate Plot ViewPort" (KLH) | Weight schedule table listing package weights. Created in paper space linked to viewports. |
| **klhStackMatrix** | Auto-created on truck creation (KLH) | Stacking matrix visualization for KLH workflow. Provides grid-based overview of stacking arrangement. |

### Integration Points

| Script | Integration | Data Flow |
|--------|-------------|-----------|
| **_hsbReport** | Queries truck data | Reads `_Map.getEntityArray("EntityRef[]")` for reporting |
| **f_Tag** | Uses truck data | Queries layer row via `_Map` for tag positioning |
| **BTL Exporter** | Exports stacked items | Reads property sets or subMapX for export data |
| **Production Scripts** | Reads bedding flags | Uses `BeddingRequested` flag for bedding insertion |
| **Autonester** | Called by f_Layer | Triggered for item optimization within layers |

### Data Dependencies

```
f_Truck
  ├─ Publishes: EntityRef[] (all stacked entities)
  ├─ Publishes: ptCOG, WeightCombi (weight data)
  └─ Creates: f_Layer instances
        ├─ Publishes: Row index, layer data
        └─ Creates: f_Item instances
              └─ Publishes: Transformation data, parent references
```

### Parent Scripts (Advanced)

| Script | Uses f_Truck | Purpose |
|--------|--------------|---------|
| **CombiTruck Manager** | Creates multiple f_Truck in Grid Mode | Manages multi-truck logistics with shared item pools |
| **Delivery Planner** | Orchestrates multiple f_Truck | Plans entire delivery schedule across multiple trucks |

**Note**: Parent scripts are typically custom/project-specific implementations.

## Technical Notes

### Coordinate System

- **World Locked**: Truck is locked to World Coordinate System (WCS)
- **No Rotation**: `_XE=_XW`, `_YE=_YW`, `_ZE=_ZW` - no rotation allowed
- **Z-Locked**: Insertion point Z is set to 0: `_Pt0.setZ(0)`
- **Reason**: Simplifies calculations and ensures consistent orientation for load distribution

### Transformation Flow

```
Source Entity (World Coords)
  ↓ [Transform to Truck CS]
f_Item (Truck-relative)
  ↓ [Transform to Layer CS]
f_Layer (Layer-relative)
  ↓ [Transform to Grid CS]
f_Truck (Grid-relative in Grid Mode)
```

Each transformation is stored in subMapX for reverse calculation.

### Body Operations

| Operation | Body Type | Performance | Accuracy |
|-----------|-----------|-------------|----------|
| Shadow Projection | Envelope | Fast | Good |
| Contact Faces | Real | Slow | Excellent |
| Interference | Real | Very Slow | Excellent |
| Weight | Real (mass elements) | Medium | Excellent |
| Display | Envelope | Fast | Good |

**Recommendation**: Use envelope bodies for display, real bodies for calculation.

### Map Communication Protocol

The f_Truck script uses a sophisticated map communication system:

**Parent → Child** (Truck → Layer):
```tsl
Map m;
m.setString("MyUid", sMyUID);
m.setPoint3d("ptOrg", _Pt0, _kRelative);
m.setVector3d("vecX", vecX*dLength, _kScalable);
m.setVector3d("vecY", vecY*dWidth, _kScalable);
m.setVector3d("vecZ", vecZ*dHeight, _kScalable);
layer.setSubMapX("Hsb_GridParent", m);
```

**Child → Parent** (Layer → Truck):
```tsl
String sParentUID = layer.subMapX("Hsb_GridParent").getString("MyUid");
Entity parent;
parent.setFromHandle(sParentUID);
TslInst truck = (TslInst)parent;
```

**Flags**:
- `_kRelative`: Point is stored relative to UCS
- `_kScalable`: Vector scales with coordinate system

### Property Set vs SubMapX Decision Tree

```
Is Performance Critical?
├─ No → Use Property Sets
│   ├─ Standard AutoCAD integration
│   ├─ Visible in PROPERTIES palette
│   └─ Compatible with EATTEXT
└─ Yes → Use SubMapX
    ├─ 10x faster write operations
    ├─ Better performance with complex solids
    └─ Recommended for 100+ items
```

**Configuration**: `SourceEntity\PropsetName = "Stacking"` or `"subMapX"`

### Recalculation Triggers

The script recalculates on these events:

1. **Property Changes**: Length, Width, Height, Design, Type
2. **Child Entity Changes**: f_Layer recalculation triggers truck recalc
3. **MapObject Changes**: Settings file update via dictionary
4. **Context Commands**: Any right-click menu action
5. **Double-Click**: TslDoubleClick event
6. **Remote Layer Add**: When layer is dragged into truck

**Optimization**: Dependencies are set strategically to avoid excessive recalculation.

### Known Limitations

1. **Rotation Not Supported**: Truck must be aligned to WCS (world axes)
2. **Type Cannot Change**: Horizontal/Vertical is permanent after creation
3. **Design Lock**: Design type cannot be changed after stacking begins (to preserve axle calculations)
4. **Maximum Items**: Performance degrades beyond ~500 items per truck (use SubMapX mode)
5. **Complex Solids**: Very high-resolution bodies may cause slowdowns (use envelope bodies)
6. **Axle Load**: Only calculates for KLH projects with proper XML configuration
7. **Plot Viewports**: Requires pre-existing paper space layouts
8. **Block References**: Missing blocks don't break script but features may not display

### Future Development Considerations

Based on version history, likely future enhancements:

- **Automated Weight Data**: Integration with material databases
- **Advanced Nesting**: More sophisticated packing algorithms
- **Multi-Truck Optimization**: Automatic distribution across multiple trucks
- **Real-Time Load Visualization**: Live weight distribution as items are added
- **Export Enhancements**: More exporter integrations and formats
- **Mobile Interface**: Mobile app for on-site verification
- **Cloud Integration**: Cloud-based delivery planning and tracking

---

**Document Version**: 2.0 (Comprehensive Update)
**Script Version**: 6.70
**Last Updated**: November 2025
**Author**: hsbCAD Development Team
**Maintained By**: TSL Documentation Project

---

*This documentation is auto-generated from TSL source code analysis and enhanced with domain knowledge. For the latest updates, check the script version history in the #BeginDescription section of f_Truck.mcr.*