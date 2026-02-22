# hsbItemClone

## Overview

hsbItemClone creates flattened, plan-view displays of timber members and panels at user-chosen locations in the drawing. This script is a powerful nesting and layout planning tool that produces top-down silhouette clones of structural elements, annotated with customizable text labels. It enables fabricators and planners to arrange and review parts without manipulating the actual 3D model.

### Supported Entity Types
- **GenBeam** - Generic timber beams
- **Beam** - Standard timber beams
- **Sheet** - Panel materials (OSB, plywood, gypsum)
- **SIP** - Structural Insulated Panels
- **BodyImporter** - Imported solid bodies (TslInst)

### Operating Modes

**Single-Entity Mode (Interactive Placement)**
- Select one entity
- Place clone at a picked point
- Manual positioning with rotation controls
- Ideal for individual part review

**Distribution/Frame Mode (Automatic Layout)**
- Select multiple entities
- Automatically sorts and arranges clones in rows
- Groups by material style and package
- Optimized for production nesting plans

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing View | No |

All geometry and annotations are drawn directly in Model Space, aligned to the World Coordinate System (WCS) X/Y plane with Z=0.

## Prerequisites

- The drawing must contain at least one supported timber entity (GenBeam, Sheet, SIP, Beam, or BodyImporter TslInst)
- For Filter Rules: Relevant entities must exist in the model
- Optional: hsbFreight-Item script for freight package integration

## How to Use

### Step 1: Launch the Script

```
Command: TSLINSERT
Select script: hsbItemClone.mcr
```

The script enters interactive insertion mode.

### Step 2: Configure Properties (Dialog)

A dialog appears with the following options:

**Item Category**
- **Rule**: Select a filter rule (if configured) to restrict entity types and apply custom format expressions
- **Sorting**: Choose sort order for Distribution mode (e.g., Name ascending, Length and Width ascending)
- **Oversize**: Set expansion margin for silhouette outline (default: 0 mm)

**Display Category**
- **Format**: Define text label pattern using @(VariableName) tokens (default: `@(PosNum)\P@(Length) x @(Width)`)
- **DimStyle**: Select AutoCAD dimension style for text rendering
- **Text Height**: Override text height (0 = use DimStyle height)

**Automatic Mode**: If you type a catalog entry name at the command line, the dialog is skipped and catalog values are applied automatically.

### Step 3: Select Source Entities

The command line prompts:
```
Select source genbeams
```
or
```
Select source entities (GenBeam, Sheet, Panel, ...)
```

**Selection Behavior**:
- **Single entity**: Activates Single-Entity Mode → you pick a placement point
- **Multiple entities**: Activates Distribution Mode → automatic row-based layout
- **Nested selections**: Entities in groups or nested structures are supported
- **Freight Items**: If hsbFreight-Item scripts are available, you can select freight package instances to clone their contained parts

**Filter Rules**: When a Filter Rule is active in the settings XML, the prompt lists only permitted entity types.

### Step 4: Pick Target Location (Single-Entity Mode Only)

After selecting one entity:
```
Select target location
```

Click a point in the drawing. The clone appears with its center at the chosen point, aligned flat on the WCS X/Y plane.

Press **Escape** to cancel → the script instance is erased automatically.

### Step 5: Review the Clone

**Single-Entity Mode**:
- Clone appears as a 2D silhouette at the target location
- Label text drawn according to Format expression
- Grain direction arrow (if @(Graindirection) is in Format and entity is Sheet/SIP)
- Ready for interactive rotation/flipping via right-click menu

**Distribution Mode**:
- All clones arranged in sorted rows automatically
- Grouped by style (material + thickness or SIP style)
- Double-size gap between different material groups
- Frame instance erases itself after creating individual clones
- Individual clones remain editable

## Properties Panel (OPM Parameters)

All parameters are live-editable in the AutoCAD Properties Palette.

### Item Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Rule** | PropString (dropdown) | Disabled | Selects an active Filter Rule from settings XML. Filter Rules restrict which entity types are allowed and can define custom format expressions per material class. Read-only when only one rule is configured. |
| **Sorting** | PropString (dropdown) | First option in settings | Selects sort order for Distribution mode. Options defined in settings XML (e.g., Name ascending, Length and Width ascending). Read-only when only one option is configured. |
| **Oversize** | PropDouble | 0 mm | Expands silhouette outline outward by this amount. When greater than zero, an additional oversize boundary is drawn around the body in a configurable color and line type. Useful for cutting allowances or machining margins. |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | PropString | `@(PosNum)\P@(Length) x @(Width)` | Defines the text label drawn at the clone location. Uses @(VariableName) tokens resolved from source entity properties. Multiple lines separated by `\P`. Use the **Set Format Expression** context menu to add/remove variables interactively. |
| **DimStyle** | PropString (dropdown) | First available DimStyle | AutoCAD dimension style used for text rendering. Read-only if fixed in settings XML. |
| **Text Height** | PropDouble | 0 (from DimStyle) | Overrides label text height. Set to 0 to inherit from DimStyle. Read-only if fixed in settings XML. |

## Right-Click Context Menu

Right-click on an hsbItemClone instance to access these commands:

| Menu Item | Description |
|-----------|-------------|
| **Rotate 90°** | Rotates clone 90° around WCS Z axis at placement point. Useful for reorienting long members. |
| **Rotate 180°** | Rotates clone 180° around WCS Z axis at placement point. |
| **Flip Face** | Rotates clone 180° around source entity local X axis, revealing the opposite face. Critical for panels/sheets with distinct top and bottom surfaces (e.g., SIP panels with different surface quality ratings). |
| **Set Format Expression** | Opens interactive command-line list of all object properties available for the source entity. Enter a positive index number to add that variable to Format, or negative index to remove it. Available variables depend on entity type (GenBeam, Sheet, SIP, etc.). |
| **Show Relation / Hide Relation** | Toggles visual step-wise connector line between clone placement point and source entity center in 3D space. Connector travels along WCS X → Y → Z axes in sequence. Diagnostic aid only, has no effect on fabrication output. |
| **Show Grain Direction In Model** | **Global command** affecting all hsbItemClone instances in the drawing. When active, the grain direction symbol is drawn directly on the original 3D entity in model space, enabling consistency checks of grain orientations across roof/floor panel areas. |
| **Hide Grain Direction In Model** | Disables global grain direction display on 3D entities. |

## Format Expression Variables

The **Format** property supports @(VariableName) tokens resolved from the source entity. Use `\P` to insert line breaks.

### Standard Variables (All Entity Types)

| Variable Token | Meaning | Example Output |
|----------------|---------|----------------|
| @(PosNum) | Position number of the entity | 101 |
| @(Length) | Overall length | 2440 |
| @(Width) | Overall width | 1220 |
| @(Name) | Material or article name | GL24h |
| @(Color) | Entity color number | 7 |

### GenBeam-Specific Variables

| Variable Token | Meaning | Example Output |
|----------------|---------|----------------|
| @(SolidLength) | Net solid length after all cuts | 2435 |
| @(SolidWidth) | Net solid width after all cuts | 1218 |
| @(SolidHeight) | Net solid height | 180 |
| @(Calculate Weight) | Calculated weight in kg (via hsbCenterOfGravity) | 45.2 kg |
| @(Beamtype) | Beam type designation | Post, Joist, Stud |

### Sheet-Specific Variables

| Variable Token | Meaning | Example Output |
|----------------|---------|----------------|
| @(Material) | Sheet material name | OSB/3 |
| @(Thickness) | Sheet thickness | 15 |
| @(Graindirection) | **Graphical symbol** - Inserts grain direction arrow inline with text | ↔ (arrow graphic) |
| @(GrainDirectionText) | Grain direction as text | Lengthwise or Crosswise |
| @(GrainDirectionTextShort) | Short form | Grain LW or Grain CW |
| @(LengthGrain...) | Length measured along grain axis. Append format codes like `@(LengthGrain:PL1;2)` for precision control. | 2440.0 |
| @(WidthGrain...) | Width measured perpendicular to grain axis. Append format codes like `@(WidthGrain:PL1;0)` | 1220 |

**Grain Direction Axis Definition**: Controlled by `GrainDirectionSheet` setting (0-5):
- 0 = Sheet local X axis (default)
- 1 = Sheet local Y axis
- 2 = Parent element X axis
- 3 = Parent element Y axis
- 4 = Align to longest dimension
- 5 = Align to shortest dimension

### SIP-Specific Variables

| Variable Token | Meaning | Example Output |
|----------------|---------|----------------|
| @(Style) | SIP style name | 200mm Wall Panel |
| @(Graindirection) | **Graphical symbol** - Grain direction arrow | ↔ (arrow graphic) |
| @(GrainDirectionText) | Grain direction as text | Lengthwise or Crosswise |
| @(GrainDirectionTextShort) | Short form | Grain LW or Grain CW |
| @(SurfaceQuality) | Combined surface quality (bottom/top) | S3 (S2) |
| @(SurfaceQualityTop) | Top surface quality | S2 |
| @(SurfaceQualityBottom) | Bottom surface quality | S3 |
| @(SipComponent.Name) | Core component name | EPS Core |
| @(SipComponent.Material) | Core material | EPS 100 |

**Surface Quality Display Logic**: The displayed surface depends on viewing direction. If viewing from top (Z+), top quality is shown first. If viewing from bottom (Z-), bottom quality is shown first.

### Format Expression Examples

```
Basic dimensions:
@(PosNum)\P@(Length) x @(Width)
→ 101
  2440 x 1220

With material and weight:
@(PosNum) @(Name)\P@(SolidLength) x @(SolidWidth)\P@(Calculate Weight)
→ 101 GL24h
  2435 x 1218
  45.2 kg

Sheet with grain direction:
@(PosNum) @(Material) @(Thickness)mm\P@(LengthGrain:PL1;0) x @(WidthGrain:PL1;0)\P@(Graindirection) @(GrainDirectionTextShort)
→ 201 OSB/3 15mm
  2440 x 1220
  ↔ Grain LW

SIP with surface quality:
@(PosNum) @(Style)\P@(Length) x @(Width)\P@(SurfaceQuality)\P@(Graindirection)
→ 301 200mm Wall Panel
  2440 x 1220
  S3 (S2)
  ↔
```

## Settings Files

The script reads configuration from:
```
[Company Path]\TSL\Settings\hsbItemClone.xml
```

If no file exists, built-in defaults are used and a default settings map is saved to that path for future customization.

### XML Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- Distribution Layout -->
  <dbl nm="MaxRowLength" ut="L" vl="25000"/>
  <dbl nm="Interdistance" ut="L" vl="500"/>
  <int nm="DisplayMode" vl="0"/>
  <int nm="GrainDirectionSheet" vl="0"/>

  <!-- Sorting Presets -->
  <lst nm="Sort[]">
    <lst nm="Element">
      <str nm="Name" vl="Name ascending"/>
      <lst nm="OrderBys">
        <lst nm="OrderBy">
          <str nm="Property" vl="Name"/>
          <int nm="IsAscending" vl="1"/>
        </lst>
      </lst>
    </lst>
  </lst>

  <!-- Filter Rules -->
  <lst nm="FilterRule[]">
    <lst nm="Element">
      <str nm="Name" vl="Sheets Only"/>
      <lst nm="AllowedClass[]">
        <str nm="Element" vl="sheet"/>
      </lst>
      <lst nm="Format[]">
        <lst nm="Element">
          <str nm="Format" vl="@(Material)"/>
          <str nm="Value" vl="OSB/3"/>
          <int nm="Operation" vl="1"/>
        </lst>
      </lst>
    </lst>
  </lst>

  <!-- Display Settings -->
  <lst nm="Display\Text">
    <int nm="Color" vl="7"/>
    <dbl nm="TextHeight" ut="L" vl="0"/>
    <str nm="DimStyle" vl="Standard"/>
  </lst>

  <lst nm="Display\Body">
    <str nm="LineType" vl="CONTINUOUS"/>
    <dbl nm="LineTypeScale" vl="1"/>
    <int nm="Color" vl="7"/>
  </lst>

  <lst nm="Display\Oversize">
    <str nm="LineType" vl="DASHED"/>
    <dbl nm="LineTypeScale" vl="1"/>
    <int nm="Color" vl="1"/>
  </lst>

  <lst nm="Display\GrainDirection">
    <int nm="ColorWall" vl="12"/>
    <int nm="ColorRoof" vl="34"/>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Key Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| **MaxRowLength** | Double | 25000 mm | Maximum X extent of a single row in Distribution mode before starting a new row. Adjust based on available nesting area width. |
| **Interdistance** | Double | 500 mm | Gap between adjacent clones in Distribution mode. Minimum spacing for visual separation. |
| **DisplayMode** | Integer | 0 | 0 = envelope body (fast, default), 1 = real body (slower, includes all notches and cuts). Use mode 1 for exact geometry including complex tooling. |
| **GrainDirectionSheet** | Integer | 0 | Controls grain direction axis for Sheet entities: 0=Entity X, 1=Entity Y, 2=Element X, 3=Element Y, 4=Longest dimension, 5=Shortest dimension. |
| **Sort[]** | Map Array | Name ascending | Named sorting presets. Each preset defines one or more properties to sort by and direction (ascending/descending). Properties: Name, Length, Width, SolidLength, SolidWidth, etc. |
| **FilterRule[]** | Map Array | None | Named filter rules. Each defines AllowedClass[] (which entity types) and optional Format[] value filters. Operation: 0=Exclude matching, 1=Include matching. |
| **Display\Text\Color** | Integer | 7 | Text label color (AutoCAD color index). |
| **Display\Text\TextHeight** | Double | 0 | Global text height override. 0 = use DimStyle height. When set, OPM field becomes read-only. |
| **Display\Text\DimStyle** | String | First available | Global DimStyle override. When set, OPM field becomes read-only. |
| **Display\Body\LineType** | String | CONTINUOUS | Line type for main body outline. |
| **Display\Body\LineTypeScale** | Double | 1 | Line type scale for body outline. |
| **Display\Body\Color** | Integer | 7 | Body outline color. |
| **Display\Oversize\LineType** | String | DASHED | Line type for oversize boundary. |
| **Display\Oversize\LineTypeScale** | Double | 1 | Line type scale for oversize boundary. |
| **Display\Oversize\Color** | Integer | 1 | Oversize boundary color (typically red for visibility). |
| **Display\GrainDirection\ColorWall** | Integer | 12 | Grain direction symbol color for wall elements. |
| **Display\GrainDirection\ColorRoof** | Integer | 34 | Grain direction symbol color for roof/floor elements. |

### Settings Cache

Settings are cached in the AutoCAD drawing dictionary under the key:
```
hsbTSL / hsbItemClone
```

**Cache Refresh**: Changes to the XML file require:
- Reload the drawing, or
- Run the script once with debug mode active (`_bOnDebug = true`)

## Distribution Mode (Multi-Entity) Workflow

Distribution mode activates automatically when you select **multiple entities** during insertion.

### Automatic Layout Process

1. **Style Grouping**: Entities are grouped by style key:
   - **Beams**: `beam_[Material]_[Height]`
   - **Sheets**: `sheet_[Material]_[Height]`
   - **SIPs**: `[SIP Style Name]`
   - **If Freight Item selected**: `_Pak[PackageNumber]` appended to style

2. **Sorting**: Within each style group, entities are sorted according to the selected Sorting preset (e.g., by Name, Length, Width)

3. **Row Layout**:
   - Clones placed left-to-right in rows starting from insertion point
   - Gap between clones = **Interdistance** setting (default 500mm)
   - When row length exceeds **MaxRowLength** setting (default 25000mm), new row starts below
   - Double-size gap inserted between different style groups for visual separation

4. **Frame Cleanup**: The Distribution frame instance erases itself after creating all individual clones

5. **Result**: Individual hsbItemClone instances remain, each independently editable via OPM and right-click menu

### Duplicate Detection

If an hsbItemClone instance already exists in the drawing linked to a specific source entity, Distribution mode skips that entity to prevent duplicates. The command line reports:
```
Entity [PosNum] already has a clone at [X, Y, Z]
```

### Freight Package Integration

When **hsbFreight-Item** scripts are available:

1. Select freight package TslInst instances during entity selection
2. Script extracts underlying GenBeams from package items
3. Package number is appended to style key: `[Style]_Pak0001`
4. Clones from the same package are kept together in layout
5. Useful for organizing production by shipping package

## Grain Direction Features

### Grain Direction Symbol (@(Graindirection))

For **Sheet** and **SIP** entities, including the `@(Graindirection)` token in the Format expression inserts a graphical arrow symbol inline with the text label.

**Symbol Appearance**:
- Horizontal arrow with notches: `↔`
- Size: Scaled to current text height
- Color: ColorWall (wall elements) or ColorRoof (roof/floor elements) from settings
- Orientation: Aligned to grain axis (vecXGrain)

**Symbol Logic**:
- Automatically detects grain direction vector from entity
- For Sheets: Grain axis determined by GrainDirectionSheet setting (0-5)
- For SIPs: Grain axis from SipStyle.woodGrainDirection()
- Symbol only appears when grain direction is defined (non-zero length vector)

### Grain Direction in Model Space

Use the **Show Grain Direction In Model** context menu command to display grain symbols directly on **all** 3D entities in model space.

**Use Case**: Quality control for roof/floor panel layouts
- Verify all panels have consistent grain orientation
- Identify misaligned panels visually before fabrication
- Eave area grain direction validation (Baufritz-specific)

**Toggle**: Right-click any hsbItemClone instance → **Hide Grain Direction In Model** to disable

### Grain Direction Text Variables

Alternative to graphical symbol for documentation or BOM integration:

- `@(GrainDirectionText)` → "Lengthwise" or "Crosswise"
- `@(GrainDirectionTextShort)` → "Grain LW" or "Grain CW"

### Grain Alignment Rules (GrainDirectionSheet)

The `GrainDirectionSheet` setting (in XML or per-FilterRule) controls how the grain axis is determined for **Sheet** entities:

| Value | Grain Axis | Use Case |
|-------|------------|----------|
| 0 | Sheet local X axis | Default - respects individual sheet placement |
| 1 | Sheet local Y axis | Grain perpendicular to sheet length |
| 2 | Parent Element X axis | Align grain to wall/floor orientation |
| 3 | Parent Element Y axis | Grain perpendicular to element orientation |
| 4 | Longest dimension | Automatic alignment to length |
| 5 | Shortest dimension | Automatic alignment to width |

**Example**: For wall sheathing where grain should always run vertically regardless of sheet rotation, use `GrainDirectionSheet = 2` (Element X axis).

## Filter Rules System

Filter Rules provide advanced entity filtering and format customization based on material properties.

### Filter Rule Structure

Each Filter Rule defines:
1. **Name**: Rule identifier (appears in Rule dropdown)
2. **AllowedClass[]**: List of permitted entity class names (genbeam, sheet, beam, sip, tslinst.bodyimporter)
3. **Format[]**: Optional value filters to include/exclude specific materials or colors
4. **GrainDirectionSheet**: Optional override for grain direction logic (0-5)

### AllowedClass[] Options

```xml
<lst nm="AllowedClass[]">
  <str nm="Element" vl="genbeam"/>
  <str nm="Element" vl="sheet"/>
  <str nm="Element" vl="beam"/>
  <str nm="Element" vl="sip"/>
  <str nm="Element" vl="entpline"/>
  <str nm="Element" vl="tslinst.bodyimporter"/>
</lst>
```

### Format[] Value Filters

Each Format[] element defines:
- **Format**: Property to evaluate (use @(PropertyName) syntax or special cases like @(Color), @(Beamtype))
- **Value** or **Value[]**: Value(s) to match against
- **Operation**: 0 = Exclude matching entities, 1 = Include only matching entities

**Example: OSB Sheets Only**
```xml
<lst nm="Format[]">
  <lst nm="Element">
    <str nm="Format" vl="@(Material)"/>
    <str nm="Value" vl="OSB/3"/>
    <int nm="Operation" vl="1"/>
  </lst>
</lst>
```
Result: Only OSB/3 sheets are allowed through the filter.

**Example: Exclude Red Entities**
```xml
<lst nm="Format[]">
  <lst nm="Element">
    <str nm="Format" vl="@(Color)"/>
    <str nm="Value" vl="1"/>
    <int nm="Operation" vl="0"/>
  </lst>
</lst>
```
Result: All entities except color 1 (red) are allowed.

**Example: Multiple Allowed Materials**
```xml
<lst nm="Format[]">
  <lst nm="Element">
    <str nm="Format" vl="@(Material)"/>
    <lst nm="Value[]">
      <str nm="Element" vl="OSB/3"/>
      <str nm="Element" vl="OSB/4"/>
      <str nm="Element" vl="Plywood"/>
    </lst>
    <int nm="Operation" vl="1"/>
  </lst>
</lst>
```
Result: Only OSB/3, OSB/4, and Plywood sheets pass the filter.

### Special Filter Properties

| Property | Entity Type | Description |
|----------|-------------|-------------|
| @(Color) | All | Entity color number (1-255) |
| @(Beamtype) | GenBeam | Beam type from _BeamTypes[] (Post, Joist, Stud, etc.) |
| @(Material) | GenBeam, Sheet | Material name |
| @(Name) | GenBeam, Sheet | Article or material name |
| @(Style) | SIP | SIP style name |

### Workflow: Creating a Custom Filter Rule

**Scenario**: Clone only CLT panels (sheets) with thickness 80mm or 120mm for nesting layout.

**XML Configuration**:
```xml
<lst nm="FilterRule[]">
  <lst nm="Element">
    <str nm="Name" vl="CLT Panels Only"/>
    <lst nm="AllowedClass[]">
      <str nm="Element" vl="sheet"/>
    </lst>
    <lst nm="Format[]">
      <lst nm="Element">
        <str nm="Format" vl="@(Material)"/>
        <str nm="Value" vl="CLT"/>
        <int nm="Operation" vl="1"/>
      </lst>
      <lst nm="Element">
        <str nm="Format" vl="@(Thickness)"/>
        <lst nm="Value[]">
          <str nm="Element" vl="80"/>
          <str nm="Element" vl="120"/>
        </lst>
        <int nm="Operation" vl="1"/>
      </lst>
    </lst>
  </lst>
</lst>
```

**Usage**:
1. Save XML to `[Company]\TSL\Settings\hsbItemClone.xml`
2. Reload drawing or run script with debug mode
3. Insert hsbItemClone → Dialog shows "CLT Panels Only" in Rule dropdown
4. Select Rule → Only CLT sheets with 80mm or 120mm thickness are selectable

## Advanced Features

### Coordinate System Transformation

The script transforms 3D entities to 2D plan view using coordinate system alignment:

**Source Coordinate System** (3D Entity):
- Origin: Entity center point
- X: Entity local X axis (or grain direction for sheets/SIPs)
- Y: Entity local Y axis (perpendicular to grain)
- Z: Entity local Z axis (extrusion direction)

**Target Coordinate System** (2D Clone):
- Origin: User-selected placement point (_Pt0)
- X: World X axis (_XW)
- Y: World Y axis (_YW)
- Z: World Z axis (_ZW), but forced to Z=0

**Transformation**: `cs2Clone.setToAlignCoordSys(source, target)`

This ensures:
- Clone is flat on WCS X/Y plane
- Original entity orientation preserved in plan view
- Rotations via context menu work in WCS

### Body Extraction Modes

**DisplayMode = 0 (Envelope Body - Default)**:
- Uses `gb.envelopeBody(true, true)`
- Fast calculation
- Shows bounding box envelope
- Ignores small notches, slots, drills
- Recommended for nesting visualization

**DisplayMode = 1 (Real Body)**:
- Uses `gb.realBody()` or `tsl.realBody()`
- Slower calculation
- Shows exact geometry including all tooling
- Recommended for precise fabrication drawings

Set in XML: `<int nm="DisplayMode" vl="1"/>`

### Oversize Boundary

When **Oversize** > 0:
- Main body outline drawn in Body color/linetype
- Additional boundary drawn at Oversize distance outward
- Oversize boundary color/linetype configurable in settings
- Useful for:
  - Cutting allowances (add 5-10mm)
  - Machining margins
  - Safety zones for automated nesting

**PlaneProfile Operation**:
```c
ppShape.shrink(-dOversize);  // Negative value expands outward
```

### Relation Connector (Show Relation)

The **Show Relation** toggle draws a step-wise connector between clone (2D) and source entity (3D):

**Connector Path**:
1. Start at clone placement point (_Pt0)
2. Travel along WCS X axis to match source entity X coordinate
3. Travel along WCS Y axis to match source entity Y coordinate
4. Travel along WCS Z axis to match source entity Z coordinate (center point)

**Use Case**: Diagnostic tool to verify which 3D part a given 2D clone represents, especially in complex layouts with hundreds of clones.

**Performance**: No impact on fabrication output, purely visual.

### Weight Calculation Integration

The `@(Calculate Weight)` variable calls the **hsbCenterOfGravity** script via MapIO to calculate weight:

**Process**:
1. Pass entity to hsbCenterOfGravity MapIO interface
2. Receive calculated weight in kg
3. Format to 2 decimal places if < 10kg, else 0 decimals
4. Append " kg" unit suffix

**Formula**: Weight = Volume × Material Density (from hsbCAD material library)

**Example Output**:
```
@(Calculate Weight)
→ 45.2 kg   (if weight < 10kg)
→ 128 kg    (if weight >= 10kg)
```

### Catalog Integration

The script supports **catalog entries** for rapid insertion with predefined property sets.

**Catalog Name**: `scriptName + "-Frame"` → `hsbItemClone-Frame`

**Workflow**:
1. Create catalog entry in hsbCAD catalog manager
2. Define property values (Rule, Sorting, Format, DimStyle, etc.)
3. Insert via command: `TSLINSERT hsbItemClone [CatalogEntryName]`
4. Dialog is skipped, catalog values applied automatically

**Use Case**: Standardized nesting layouts for different production departments (e.g., "Wall Panels", "Floor Panels", "SIP Sheets").

### SubMapX Data Storage

Each clone stores reference data in SubMapX under key "Hsb_ItemClone":

**Stored Data**:
- **UID**: Source entity handle (for duplicate detection)
- **ptOrg**: Clone placement point (relative)
- **vecX**: Clone X axis × SolidLength (scalable)
- **vecY**: Clone Y axis × SolidWidth (scalable)
- **vecZ**: Clone Z axis × SolidHeight (scalable)
- **profShape**: PlaneProfile (2D silhouette geometry)

**Use Case**: Downstream scripts can read clone data to:
- Link back to source 3D entity
- Extract exact dimensions
- Retrieve shape geometry for CNC export

### Baufritz Grain Direction Validation

Special feature for **Baufritz** projects (controlled by `projectSpecial() == "BAUFRITZ"`):

**Automatic Eave Area Grain Check**:
1. Detects if current sheet is in roof eave area (intersects multiple roof elements)
2. Collects all hsbItemClone instances from adjacent roof elements
3. Analyzes grain direction vectors
4. Identifies majority grain direction
5. If current sheet grain differs from majority → highlights in red

**Visual Indication**:
- Red filled polygon around grain direction symbol
- Red lines extending to sheet edges
- Only visible when "Show Grain Direction In Model" is active

**Purpose**: Quality control to prevent mixing lengthwise and crosswise panels in critical eave regions where consistent grain orientation is required for structural performance.

## Tips and Best Practices

### Layout Planning Workflow

**Step 1: Prepare 3D Model**
- Complete all framing and paneling in 3D
- Assign position numbers (PosNum)
- Set grain directions for sheets/SIPs
- Organize parts into freight packages if applicable

**Step 2: Configure Settings**
- Create hsbItemClone.xml with company standards
- Define Filter Rules for each material group
- Set up Sorting presets (by Length, Width, Package, etc.)
- Configure Display colors and line types

**Step 3: Create Nesting Layouts**
- Use Distribution mode for automatic layouts
- Select all parts of one material type
- Let script sort and arrange in rows
- Review and manually adjust individual clones if needed

**Step 4: Export for CNC**
- Clones remain in model space as flat 2D profiles
- Export to DXF/DWG for CNC nesting software
- SubMapX data available for custom export scripts

### Format Expression Design

**Keep It Concise**: Labels with 1-3 lines are easiest to read at typical zoom levels.

**Example - Minimal**:
```
@(PosNum)
→ 101
```

**Example - Standard**:
```
@(PosNum)\P@(Length) x @(Width)
→ 101
  2440 x 1220
```

**Example - Detailed**:
```
@(PosNum) @(Name)\P@(SolidLength) x @(SolidWidth) x @(SolidHeight)\P@(Calculate Weight)
→ 101 GL24h
  2435 x 1218 x 180
  45.2 kg
```

**Grain Direction Placement**: Place `@(Graindirection)` at the end of a line for best visual alignment:
```
@(PosNum) @(Material)\P@(Graindirection) @(GrainDirectionTextShort)
→ 201 OSB/3
  ↔ Grain LW
```

### Style Grouping Strategy

In Distribution mode, style keys control grouping. Customize for your workflow:

**Default Style Keys**:
- Beams: `beam_[Material]_[Height]`
- Sheets: `sheet_[Material]_[Height]`
- SIPs: `[SIP Style Name]`

**Add Package Grouping**: Use hsbFreight-Item selection to append `_Pak[Number]`

**Result**: Parts group by material first, then by package within each material group.

### Oversize for Cutting Allowances

Set Oversize to your saw kerf + safety margin:

**Example**:
- Saw kerf: 3mm
- Safety margin: 2mm
- Oversize: 5mm

**Visual Result**:
- Inner boundary = exact part geometry
- Outer boundary = cutting line with allowance

### Grain Direction Validation Checklist

Before production:

1. **Enable Global Display**: Right-click → "Show Grain Direction In Model"
2. **Visual Scan**: Look for grain symbols on all panels in model space
3. **Check Consistency**: Verify all wall panels have vertical grain, all floor panels have parallel grain
4. **Identify Errors**: Misaligned panels show wrong symbol orientation
5. **Correct in 3D**: Rotate or replace panels in 3D model
6. **Recalc Clones**: Clones update automatically when source entities change

### Single-Entity Mode Uses

When to use Single-Entity Mode (select one entity):

- **Detail Drawings**: Create plan views of individual complex parts
- **Assembly Instructions**: Show specific part with custom label
- **Custom Positioning**: Place clone at exact location with precise rotation
- **Isolated Review**: Study one part without distraction

### Distribution Mode Uses

When to use Distribution Mode (select multiple entities):

- **Production Nesting**: Layout all panels of one type for CNC cutting
- **Material Optimization**: Review total material required, identify similar parts
- **Package Planning**: Group parts by shipping package
- **BOM Visualization**: See all unique parts sorted and counted

## Common Issues and Solutions

### Issue: Clone Disappears Immediately After Insertion

**Cause**: Selected source entity has no valid body geometry or zero volume.

**Solution**:
- Select the source entity in 3D model
- Verify it has been fully defined and calculated
- Check for errors in element generation
- Recalculate the entity (select → right-click → Recalculate)
- Try again with hsbItemClone

### Issue: "The type is not supported yet" Message

**Cause**: Unsupported entity type selected.

**Supported Types**: GenBeam, Sheet, SIP, Beam, BodyImporter TslInst

**Solution**:
- Verify entity class: Select entity → Properties Panel → Object Type
- If using Filter Rules, add entity class to AllowedClass[] in XML:
  ```xml
  <lst nm="AllowedClass[]">
    <str nm="Element" vl="[entityclass]"/>
  </lst>
  ```

### Issue: Sorting Dropdown is Empty or Locked

**Cause**: Settings XML has no Sort[] entries or only one entry.

**Solution**:
- Edit `hsbItemClone.xml`
- Add multiple Sort[] entries with different OrderBy properties
- Example:
  ```xml
  <lst nm="Sort[]">
    <lst nm="Element">
      <str nm="Name" vl="Length Ascending"/>
      <lst nm="OrderBys">
        <lst nm="OrderBy">
          <str nm="Property" vl="SolidLength"/>
          <int nm="IsAscending" vl="1"/>
        </lst>
      </lst>
    </lst>
    <lst nm="Element">
      <str nm="Name" vl="Name Ascending"/>
      <lst nm="OrderBys">
        <lst nm="OrderBy">
          <str nm="Property" vl="Name"/>
          <int nm="IsAscending" vl="1"/>
        </lst>
      </lst>
    </lst>
  </lst>
  ```
- Reload drawing

### Issue: Grain Direction Arrow Does Not Appear

**Cause**: Grain direction vector not defined or entity is not Sheet/SIP.

**Solution**:
1. Verify `@(Graindirection)` is in Format expression
2. Verify entity is Sheet or SIP (not Beam or BodyImporter)
3. Check if grain direction is assigned:
   - Select sheet in 3D model
   - Properties Panel → Grain Direction
   - If "No grain direction", assign via element settings or script
4. Check GrainDirectionSheet setting (0-5) is appropriate for your layout

### Issue: Distribution Mode Creates Fewer Clones Than Expected

**Cause**: Duplicate clones already exist for some entities.

**Command Line Output**:
```
Entity 105 already has a clone at 12500, 8000, 0
```

**Solution**:
- Script prevents duplicate clones by checking SubMapX UID references
- Either:
  - Delete existing clones first, or
  - Skip re-cloning those entities (intentional behavior to prevent duplicates)

### Issue: XML Settings Changes Not Taking Effect

**Cause**: Settings cached in drawing database dictionary.

**Solution**:
1. **Method 1**: Start new drawing session
   - Save and close current drawing
   - Reopen → Settings reloaded from XML

2. **Method 2**: Force reload with debug mode
   - Edit script temporarily: Set `int bDebug = true;` at line 61
   - Run script once → Forces XML reload
   - Edit script back: Set `int bDebug = false;`

3. **Method 3**: Delete cached MapObject
   - Use hsbCAD developer tools to purge dictionary object:
   - Dictionary: "hsbTSL"
   - Key: "hsbItemClone"

### Issue: Text Height Locked in OPM

**Cause**: TextHeight fixed in settings XML.

**Behavior**: When `Display\Text\TextHeight` is set to a non-zero value in XML, the OPM field becomes read-only.

**Solution**:
- Edit `hsbItemClone.xml`
- Set `<dbl nm="TextHeight" ut="L" vl="0"/>` (zero = use DimStyle height)
- Reload drawing
- OPM field becomes editable

**Rationale**: Enforces consistent label formatting across all users in a project.

### Issue: Clones Not Flat on Drawing Plane

**Cause**: User accidentally rotated clone in 3D (unlikely but possible via custom scripts).

**Solution**:
- Clones are always forced to Z=0 during creation
- Delete and recreate clone
- Ensure no custom scripts are transforming clone instances after creation

### Issue: Grain Symbol Points Wrong Direction

**Cause**: GrainDirectionSheet setting doesn't match your layout convention.

**Solution**:
- Determine correct grain axis for your project:
  - Wall sheathing: Usually align to wall height (Element X or Y)
  - Floor sheathing: Usually align to joist direction
- Edit XML: `<int nm="GrainDirectionSheet" vl="2"/>` (try values 0-5)
- Or override per FilterRule:
  ```xml
  <lst nm="FilterRule[]">
    <lst nm="Element">
      <str nm="Name" vl="Wall Sheets"/>
      <int nm="GrainDirectionSheet" vl="2"/>
      ...
    </lst>
  </lst>
  ```
- Reload and test

### Issue: Oversize Boundary Not Visible

**Cause**: Oversize color same as background or line type not loaded.

**Solution**:
- Check Oversize parameter > 0 in OPM
- Edit XML Display\Oversize settings:
  ```xml
  <lst nm="Display\Oversize">
    <str nm="LineType" vl="DASHED"/>
    <int nm="Color" vl="1"/>
  </lst>
  ```
- Ensure DASHED linetype is loaded in drawing: `LINETYPE` command → Load → DASHED

### Issue: Format Variables Show as Blank

**Cause**: Variable not supported by entity type or property not set.

**Solution**:
- Use **Set Format Expression** context menu to see available variables for your entity type
- Example: `@(SurfaceQuality)` only works for SIPs, not for Beams
- Check if property is set on source entity:
  - Select entity → Properties Panel
  - Verify property has a value (not blank)
- Remove unsupported variables from Format expression

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.11 | 01.02.2024 | HSB-21273: Collection via freight items supported. Items referenced via freight item sorted by package. |
| 1.10 | 13.11.2023 | HSB-20615: Implement grain direction check for Baufritz eave area validation. |
| 1.9 | 13.11.2023 | HSB-20615: Add trigger to show/hide grain direction in model (global display). |
| 1.8 | 20.10.2020 | HSB-9338: Internal naming bugfix. |
| 1.7 | 07.04.2020 | HSB-7236: Bugfix sheet grain direction rules. |
| 1.6 | 19.02.2020 | HSB-6716: New display properties LengthGrain and WidthGrain introduced. |
| 1.5 | 18.02.2020 | HSB-6716: Filter rules introduced, new sheet grain alignments, grain symbol display enhanced. |
| 1.4 | 04.10.2019 | HSB-5710: Bugfix if no grain direction set against panels. |
| 1.3 | 17.09.2019 | Default property adjusted to \P syntax for line breaks. |
| 1.2 | 09.04.2019 | New parameters in settings, line feed now done with '\P' instead of '|'. |
| 1.1 | 04.10.2018 | Supports BodyImporter, bugfix location panel. |
| 1.1 | 12.09.2018 | Supports all GenBeam types and supports special nesting. |
| 1.0 | 15.05.2018 | Initial release. |

## Related Scripts

- **hsbFreight-Item**: Freight package management for grouping parts by shipment
- **hsbCenterOfGravity**: Weight calculation MapIO interface (called by @(Calculate Weight))
- **hsbLayoutDim**: Dimension annotation for nesting layouts
- **hsbLayoutTag**: Additional tagging system for clones
- **hsbEntityTag**: Alternative tagging approach for model space entities

## Technical Details

**Script Type**: O (Object)
**Beams Required**: 0
**Keywords**: Nesting, plan view, child
**Version**: 1.11 (Major: 1, Minor: 11)

**Performance Considerations**:
- Single-Entity Mode: Fast (~0.1s per clone)
- Distribution Mode: Scales linearly with entity count (~0.1s per entity)
- DisplayMode 1 (real body): 2-5x slower than DisplayMode 0 (envelope body)
- Large layouts (500+ clones): Consider splitting into multiple runs or using catalog automation

**Memory Usage**:
- Minimal per instance (stores only SubMapX reference data)
- PlaneProfile geometry is compact (2D outline only)
- Distribution mode peak memory during sorting (released after clone creation)

**Dependencies**:
- TSL engine version 8
- hsbCAD core libraries
- Optional: hsbFreight-Item (for package support)
- Optional: hsbCenterOfGravity (for weight calculation)
- Optional: TslUtilities.dll (for future dialog enhancements)

## Frequently Asked Questions

**Q: Can I use hsbItemClone for non-timber materials like steel beams?**
A: Yes, if represented as GenBeam or Beam entities. The script works with any GenBeam-based object. Format expressions will show available properties for your entity type.

**Q: How do I export clones for CNC nesting software?**
A: Clones are standard AutoCAD entities (solids + text) in model space. Export the drawing area containing clones to DXF or DWG. Most CNC software can import DXF outlines directly.

**Q: Can I rotate clones to save material?**
A: Yes, use context menu **Rotate 90°** to rotate individual clones. In Distribution mode, you can also manually move clones after automatic layout is complete.

**Q: What's the difference between SolidLength and Length?**
A: **Length** = Envelope dimension (bounding box). **SolidLength** = Net dimension after all cuts, notches, and tooling. Use SolidLength for accurate fabrication dimensions.

**Q: Can I clone entire walls or elements?**
A: No, hsbItemClone works at the GenBeam level (individual beams, sheets, panels). To clone all parts of an element, select all beams in that element and use Distribution mode.

**Q: How do I create custom sorting presets?**
A: Edit hsbItemClone.xml, add new Sort[] entries. Available sort properties: Name, Length, Width, SolidLength, SolidWidth, SolidHeight, Material, PosNum, Color. Combine multiple OrderBy entries for multi-level sorting.

**Q: Can clones update automatically when source entities change?**
A: Yes, clones recalculate when their source entity changes (via dependency tracking). However, if you delete and recreate a source entity, you must also delete and recreate the clone (new handle/UID).

**Q: What happens if I move the source entity in 3D?**
A: The clone does not move automatically (placement point is independent). However, the clone geometry and labels update to reflect the new source entity state. Use **Show Relation** to verify the link.

**Q: Can I use hsbItemClone in Paper Space layouts?**
A: No, hsbItemClone only operates in Model Space. For paper space annotations, use hsbLayoutDim or hsbLayoutTag scripts instead.

**Q: How do I batch-create clones for all panels in my project?**
A: Use Distribution mode: Select all panels at once (window selection or filter), pick insertion point. The script creates and arranges all clones automatically. For very large projects (1000+ panels), consider splitting by floor or zone to improve performance.
