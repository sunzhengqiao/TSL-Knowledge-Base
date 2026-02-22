# hsbViewTag

**Version:** 14.1
**Type:** O (Object-Type Script)
**Environment:** Paper Space / Model Space (Viewports, Sections, Multipages, Shop Drawings)

---

## Overview

hsbViewTag is a comprehensive labeling and annotation tool for hsbCAD that creates intelligent, parametric position number tags and descriptive labels in both paper space and model space environments. This tool is essential for production documentation, shop drawings, and assembly layouts.

### Core Capabilities

- **Multi-Environment Support**: Works seamlessly across Paper Space viewports, Model Space sections, Multipages, and Shop Drawing viewports
- **Intelligent Entity Collection**: Automatically collects and tags entities based on type, zone, or painter definitions
- **Advanced Collision Detection**: Prevents overlapping tags through sophisticated clash detection algorithms
- **Format Variables**: Powerful template system using `@(Property)` syntax to display any entity property
- **Grouping and Sequencing**: Groups identical items and coordinates with other annotation tools
- **Live Update**: Tags automatically recalculate when referenced entities or viewports change

### Typical Use Cases

1. **Shop Drawing Annotation**: Tag beams, sheets, and panels with position numbers and dimensions
2. **Assembly Layouts**: Label components with quantity counts and material specifications
3. **Hardware Schedules**: Display fastener assemblies with model numbers and descriptions
4. **Element Identification**: Tag walls, floors, and roofs with element numbers and codes
5. **Section Views**: Annotate cross-sections with depth-filtered entity labels

---

## Prerequisites

### System Requirements
- **hsbCAD Version:** 24.1.11 or higher (some features require version 26+)
- **AutoCAD/BricsCAD:** Compatible with host CAD platform
- **Drawing Setup:** Configured dimension styles and text styles

### Required Elements
- **Minimum Beam Count:** 0 (can tag any supported entity type)
- **Reference Context:** At least one of the following must be available:
  - AutoCAD Viewport (in Paper Space layout)
  - hsbCAD Element Viewport
  - ACA Section2d (Architectural Desktop Section)
  - MultiPage (shop drawing system)
  - ShopDrawView (block-based shop drawing viewport)

### Supported Entity Types

| Type | Description | Typical Properties |
|------|-------------|-------------------|
| byZone | All GenBeams in current zone | PosNum, Length, Width, Height |
| Beam | Timber beam members | Material, Surface Quality, Zone Alignment |
| Sheet | Panel materials (OSB, Plywood) | Width, Height, Grain Direction |
| Panel | SIP panels | SipComponentName, SipComponentMaterial |
| GenBeam | Generic beam entities | All beam properties |
| TSL | TSL script instances | Scriptname, ModelDescription, MaterialDescription |
| Opening | Generic openings | Description, HeightRough, WidthRough |
| Door | Door openings | Opening-specific properties |
| Window | Window openings | StyleNameSF, GapTop, GapBottom |
| Window Assembly | Window assemblies | Assembly properties |
| Truss | Roof trusses | Truss-specific data |
| Metalpart | Hardware connectors | Definition, ColorIndex |
| Massgroup | Grouped mass elements | Entity grouping data |
| Element | Wall/Floor/Roof elements | ElementNumber, Code, Information |
| Masselement | Individual mass elements | Width, Height, Radius, ShapeType |
| Fastener Assembly | Fastener collections | Name, Type, Manufacturer, Model, ArticleNumber |

---

## Insertion Workflow

### Basic Insertion (Standard Dialog)

1. **Launch Tool**
   - Run `hsbViewTag` from TSL palette or command line
   - Standard properties dialog appears

2. **Configure Content**
   - **Type**: Select entity type to tag (byZone, Beam, Sheet, Panel, etc.)
   - **Format**: Enter format string using `@(Property)` syntax
     - Leave empty for automatic defaults (PosNum for beams, Scriptname for TSLs)
     - Examples: `@(PosNum)`, `@(Width) x @(Height)`, `@(Material)`
     - Multi-line: Use `\P` for line breaks: `@(PosNum)\P@(Material)`
   - **Painter/Rule**: Optionally select a painter definition to filter entities
   - **PainterGrouping**: Enable to use painter's groupBy settings

3. **Configure Display**
   - **Style**: Choose tag orientation
     - byEntity: Follows entity orientation
     - Horizontal: Always horizontal text
     - Vertical: Always vertical text
     - Add ", Frame" for border boxes
     - Add ", grouped" for automatic grouping of nearby identical tags
   - **Placement**: Define tag positioning strategy
     - Viewport: Within viewport bounds
     - Viewport, not on parent: Outside entity geometry
     - Not on parent: Outside geometry (most calculation)
     - Custom: Manual grip-based positioning
     - Static Location: Fixed position
   - **Color**: -2=byEntity, -1=byLayer, 0=byBlock, or color index
   - **Transparency**: -100 to 100 (negative = colored background, positive = white background)
   - **Text Height**: 0 = use dimension style height, or specific value
   - **Dimstyle**: Select dimension style for text formatting
   - **Sequence**: -1=Disabled (default), 0=Auto (coordinates with other tags/dimensions)

4. **Configure Leader (Optional)**
   - **Linetype**: Select linetype for leader line or "< Leader Disabled >"

5. **Select Reference**
   - **Paper Space Mode**: Click on a viewport to reference
   - **Model Space Mode**: Select a Section2d or MultiPage entity
   - **Block Space Mode**: Select a ShopDrawView

6. **Optional Entity Selection** (Viewport mode only)
   - If AutoSelection is ON: All matching entities are collected automatically
   - If AutoSelection is OFF or you want specific entities:
     - Switch to model space when prompted
     - Select specific entities to tag
     - Press Enter when done

7. **Place Anchor Point**
   - Pick a point to anchor the tagging system
   - **Paper Space**: Pick outside viewport area
   - **Model Space**: Pick near section or multipage
   - **Block Space**: Pick in block space

8. **Confirmation**
   - Tags are generated and distributed automatically
   - Collision detection prevents overlaps
   - Tags update dynamically when entities or viewports change

### Silent Insertion (Catalog Mode)

```lisp
^C^C(defun c:INSERTTAG() (hsb_ScriptInsert "hsbViewTag" "MyCatalogEntry")) INSERTTAG
```

Use `_kExecuteKey` to load predefined settings from catalog, bypassing dialog.

---

## Parameters Reference (OPM Properties)

### Content Category

| Property | Index | Type | Default | Description |
|----------|-------|------|---------|-------------|
| **Type** | 0 | PropString | byZone | Entity type to collect and tag. Options: byZone, Beam, Sheet, Panel, GenBeam, TSL, Opening, Door, Window, Window Assembly, Truss, Metalpart, Massgroup, Element, Masselement, Fastener Assembly |
| **Format** | 1 | PropString | (empty) | Text format template using `@(Property)` syntax. Empty defaults to PosNum for beams, Scriptname for TSLs. Use `\P` for line breaks. Round numbers with `:` notation: `@(Length:0)` = no decimals, `@(Length:1)` = one decimal |

### Filter Category

| Property | Index | Type | Default | Description |
|----------|-------|------|---------|-------------|
| **Painter/Rule** | 2 | PropString | <Disabled> | Filter entities using a painter definition or XML rule. Painter definitions take priority. Only active definitions are shown |
| **PainterGrouping** | 8 | PropString | No | Enable to use the painter definition's groupBy parameters for tag grouping. When Yes and painter format contains `@()`, painter format is used |

### Display Category

| Property | Index | Type | Default | Description |
|----------|-------|------|---------|-------------|
| **Style** | 3 | PropString | Horizontal | Tag display style. Options: byEntity, Horizontal, Vertical. Add ", Frame" for bordered box. Add ", grouped" for automatic grouping of nearby identical items |
| **Placement** | 4 | PropString | Viewport | Tag placement strategy. Viewport = within bounds, "Viewport, not on parent" = outside entity, "Not on parent" = advanced avoidance, Custom = manual, Static Location = fixed position |
| **Color** | - | PropInt | -2 | Tag color. -2=byEntity, -1=byLayer, 0=byBlock, >0=AutoCAD color index |
| **Transparency** | - | PropInt | 70 | Transparency value [-100, 100]. Negative = colored background, Positive = white/light background. Higher absolute values = more transparent |
| **Text Height** | - | PropDouble | 0 | Text height. 0 = use dimension style height. Set explicit value to override |
| **Dimstyle** | 5 | PropString | (current) | Dimension style name for text formatting (font, size, spacing) |
| **Sequence** | - | PropInt | -1 | Execution sequence for collision resolution with other tags/dimensions. -1=Disabled (default since v14.0), 0=Auto. **Note**: Read-only, sequencing disabled by default |

### Leader Category

| Property | Index | Type | Default | Description |
|----------|-------|------|---------|-------------|
| **Linetype** | 6 | PropString | < Leader Disabled > | Leader line type. Select a linetype to draw pointer from tag to entity, or "< Leader Disabled >" for no leader |

### Hidden/Internal

| Property | Index | Type | Description |
|----------|-------|------|-------------|
| **Painter Definition** | 7 | PropString | Stores serialized painter definition data. Auto-created when painter is selected. Read-only (hidden in production) |

---

## Format Variables System

### Syntax Rules

1. **Basic Format**: `@(PropertyName)`
   - Example: `@(PosNum)` displays the position number
2. **Rounding Numbers**: `@(PropertyName:decimals)`
   - Example: `@(Length:0)` rounds to integer, `@(Length:2)` shows 2 decimals
3. **Multi-line Tags**: Use `\P` as line separator
   - Example: `@(PosNum)\P@(Material)` creates two-line tag
4. **Combining Multiple**: Chain multiple properties
   - Example: `@(Width) x @(Height) x @(Length)` displays dimensions

### Universal Variables (All Entity Types)

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(PosNum)` | Position number assigned to entity | "101", "W-23" |
| `@(Quantity)` | Item count (triggers grouping of identical items) | "5x", "12x" |
| `@(Weight)` | Calculated weight (requires "CALCULATE WEIGHT" in format) | "45.2 kg" |

### GenBeam / Beam Variables

| Variable | Description | Data Type |
|----------|-------------|-----------|
| `@(Length)` | Member length | Double (with units) |
| `@(Width)` | Member width | Double (with units) |
| `@(Height)` | Member depth/height | Double (with units) |
| `@(Material)` | Material name | String |
| `@(Surface Quality)` | Texture/surface setting | String |
| `@(Zone Alignment)` | Position relative to zone | "Front Face", "Back Face", "All Faces", "No Face" |
| `@(ColorIndex)` | AutoCAD color index | Integer |
| `@(Beamtype)` | Beam type classification | String |

### Panel / SIP Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `@(GrainDirectionText)` | Full grain direction | "Lengthwise", "Crosswise" |
| `@(GrainDirectionTextShort)` | Abbreviated grain | "Grain LW", "Grain CW" |
| `@(Graindirection)` | Grain direction symbol (2-space placeholder for symbol) | "  " (with symbol) |
| `@(SurfaceQuality)` | Surface quality description | "Sanded", "Unsanded" |
| `@(surfaceQualityBottom)` | Bottom surface quality | String |
| `@(surfaceQualityTop)` | Top surface quality | String |
| `@(SipComponent.Name)` | SIP component name | "OSB", "Foam Core" |
| `@(SipComponent.Material)` | SIP component material | "EPS", "Polyurethane" |

### Element Variables

| Variable | Description |
|----------|-------------|
| `@(ElementNumber)` | Element number identifier |
| `@(Code)` | Element code |
| `@(Information)` | Element information field |
| `@(Subtype)` | Element subtype classification |

### Opening Variables

| Variable | Description | Applies To |
|----------|-------------|------------|
| `@(OpeningDescription)` | Opening description | All openings |
| `@(Description)` | General description | All openings |
| `@(HeightRough)` | Rough opening height | All openings |
| `@(WidthRough)` | Rough opening width | All openings |
| `@(StyleNameSF)` | StickFrame style name | StickFrame openings |
| `@(DescriptionPacking)` | Packing description | StickFrame openings |
| `@(DescriptionPlate)` | Plate description | StickFrame openings |
| `@(DescriptionSF)` | StickFrame description | StickFrame openings |
| `@(GapSide)` | Side gap dimension | Windows/Doors |
| `@(GapTop)` | Top gap dimension | Windows/Doors |
| `@(GapBottom)` | Bottom gap dimension | Windows/Doors |

### TSL Instance Variables

| Variable | Description |
|----------|-------------|
| `@(Scriptname)` | TSL script name |
| `@(ModelDescription)` | Model description from properties |
| `@(MaterialDescription)` | Material description from properties |
| `@(PosNum)` | Position number (if numbered) |

### MetalPart Variables

| Variable | Description |
|----------|-------------|
| `@(Definition)` | MetalPart definition name |
| `@(ColorIndex)` | Entity color index |

### MassElement Variables

| Variable | Description |
|----------|-------------|
| `@(Height)` | Element height |
| `@(Width)` | Element width |
| `@(Depth)` | Element depth |
| `@(Radius)` | Radius (for curved elements) |
| `@(Rise)` | Rise value |
| `@(ShapeType)` | Shape type as string |

### Fastener Assembly Variables

| Variable | Description | Category |
|----------|-------------|----------|
| `@(Name)` | Component name | Component Data |
| `@(Type)` | Fastener type | Component Data |
| `@(SubType)` | Fastener subtype | Component Data |
| `@(Manufacturer)` | Manufacturer name | Component Data |
| `@(Material)` | Material specification | Component Data |
| `@(Model)` | Model designation | Component Data |
| `@(Category)` | Fastener category | Component Data |
| `@(Group)` | Fastener group | Component Data |
| `@(Coating)` | Surface coating | Component Data |
| `@(Grade)` | Material grade | Component Data |
| `@(Norm)` | Standard/Norm | Component Data |
| `@(ArticleNumber)` | Article/Part number | Article Data |
| `@(Description)` | Full description | Article Data |
| `@(Notes)` | Additional notes | Article Data |
| `@(FastenerLength)` | Total fastener length | Article Data |
| `@(ThreadLength)` | Thread length | Article Data |
| `@(StackThickness)` | Stack thickness requirement | Component Data |
| `@(SinkDiameter)` | Sink/countersink diameter | Component Data |
| `@(MainDiameter)` | Main shaft diameter | Component Data |

### Special Format Functions

| Function | Description | Example |
|----------|-------------|---------|
| `CALCULATE WEIGHT` | Triggers weight calculation for all collected entities | `@(CALCULATE WEIGHT)@(Weight)` |
| `@(QUANTITY)` | Automatically groups identical items and shows count | `@(Quantity) @(PosNum)` → "3x 101" |

---

## Context Menu Commands

Access by right-clicking on an existing hsbViewTag instance.

### Entity Collection

| Command | Description | When Available |
|---------|-------------|----------------|
| **Add entities** | Add specific entities to tag collection | Viewport mode |
| **Remove entities** | Remove entities from collection | Viewport mode |
| **Auto Selection on/off** | Toggle automatic entity collection | Viewport mode |

### Zone Control

| Command | Description | Input Required |
|---------|-------------|----------------|
| **Add Zone Index** | Override zone filtering (999 = all zones) | Integer zone index |
| **Remove Zone Index** | Remove zone override, use viewport default | - |

### Tag Area Management

| Command | Description | Use Case |
|---------|-------------|----------|
| **Set preferred tag areas** | Define regions where tags should preferably be placed | Graphical polyline selection |
| **Remove preferred tag areas** | Clear preferred area restrictions | - |
| **Add No-Tag Area** | Exclude regions from tag placement | Reserve space for other annotations |
| **Remove No-Tag Area** | Clear exclusion zones | - |

### Section Control

| Command | Description | Effect |
|---------|-------------|--------|
| **Set Section Depth** | Define section cut depth graphically | Filters entities by distance from section plane |
| **Set Section Offset** | Set offset from section line | Shifts the filter plane |

### Display and Editing

| Command | Description | Behavior |
|---------|-------------|----------|
| **Edit in Place** | Enable manual tag repositioning via grips | Tags become draggable, automatic placement disabled |
| **Disable Edit in Place** | Return to automatic placement | Tags recalculate positions automatically |
| **Text Alignment** | Set text alignment (Left/Center/Right) | Available in block space |

### TSL-Specific Commands

| Command | Description | Workflow |
|---------|-------------|----------|
| **Set TSL definitions** | Select which TSL scripts to tag | Opens multi-selection list of available scripts |
| **Assign Posnums** | Auto-number unnumbered entities | Assigns sequential position numbers to items without PosNum |

### Settings Management

| Command | Description | File Format |
|---------|-------------|------------|
| **Painter Group Settings** | Configure painter group display options | Opens dialog for colors, transparency, solid hatch |
| **Import Settings** | Load tag settings from XML | XML file selection |
| **Export Settings** | Save current settings to XML | Saves to Company\TSL\Settings\hsbViewTag.xml |
| **Export Default Settings** | Save default settings template | Creates base configuration XML |

---

## Display Styles Explained

### Orientation Modes

| Style | Tag Orientation | Best For |
|-------|----------------|----------|
| **byEntity** | Aligns with entity's primary axis | Sloped beams, angled members |
| **Horizontal** | Always horizontal, regardless of entity | Floor plans, elevations |
| **Vertical** | Always vertical | Vertical member labels, side elevations |

### Frame Variants (Add ", Frame")

- Adds a rounded rectangular border around tag text
- Background filled according to transparency setting
- Examples: "Horizontal, Frame", "byEntity, Frame"

### Grouped Variants (Add ", grouped")

- Automatically combines nearby identical tags into single tag
- Shows quantity prefix (e.g., "3x 101")
- Reduces visual clutter in dense areas
- Requires `@(Quantity)` in format or identical format results
- Examples: "Horizontal, grouped", "Vertical, Frame, grouped"

---

## Placement Modes Detailed

### Viewport
- Tags placed within viewport boundary
- Fast calculation
- May overlap with entity geometry
- **Best for**: Simple layouts where overlap is not critical

### Viewport, not on parent
- Tags placed within viewport boundary
- Avoids overlapping parent entity geometry
- Moderate calculation time
- **Best for**: General purpose tagging with clean appearance

### Not on parent
- Advanced placement avoiding all entity outlines
- Most computationally intensive
- Creates cleanest layouts, especially for floor plans (optimized in v13.0+)
- **Best for**: Professional presentation drawings, floor plans

### Custom -> specify
- Manual control via grip editing
- "Edit in Place" mode automatically enabled
- User can drag tags to preferred positions
- Tags remember custom positions
- **Best for**: Final tweaking, special layout requirements

### Static Location
- Tags placed at fixed location relative to anchor point
- Useful for legend-style displays
- Text alignment based on top-left corner
- **Best for**: Shop drawing legends, fixed annotation blocks

---

## Grouping and Quantity Display

### Automatic Grouping Conditions

Tags are grouped when:
1. **Format contains `@(Quantity)`** AND
2. **Multiple entities have identical format result** AND
3. **Entities are within proximity threshold** AND
4. **Style includes "grouped" suffix** OR **Painter grouping is enabled**

### Grouping Strategies

#### By Identical Properties
```
Format: @(Quantity) @(Width) x @(Height) x @(Length)
Result: "5x 38 x 140 x 3000"
```
Groups all beams with same dimensions.

#### By Position Number
```
Format: @(Quantity) @(PosNum)
Result: "12x W-101"
```
Groups identical position numbers.

#### By Material
```
Format: @(Quantity) @(PosNum)\P@(Material)
Result: "3x 201
        SPF No.2"
```
Groups same PosNum and Material.

### Painter-Based Grouping

When **PainterGrouping = Yes** and painter definition has `groupBy` parameters:
- Painter's groupBy definition controls grouping logic
- Painter format used instead of Format property (if Format is empty)
- Subgroups can display colored hatches on geometry (configured in Painter Group Settings)

### Proximity Grouping (HSB-5169, BeamPacks)

For adjacent identical beams:
- Uses BeamPack logic to combine neighboring beams
- Delimiter configurable (default: "x")
- Example: "3x 2x4x10'" indicates 3 beams, each 2"x4"x10'

---

## Section Filtering

### Section Depth and Offset

When tagging entities in Section2d views:

**Section Depth**:
- Defines the "thickness" of the section cut
- Only entities within this depth from the section plane are tagged
- Set to 0 to show only entities exactly on the cutting plane
- Graphical definition via "Set Section Depth" context menu

**Section Offset**:
- Shifts the section plane forward or backward
- Positive offset moves in the section direction
- Negative offset moves opposite
- Graphical definition via "Set Section Offset" context menu

**Workflow**:
1. Right-click tag instance
2. Select "Set Section Depth"
3. Graphical jig displays:
   - Blue hatched area = section range
   - Yellow hatched area = entities intersecting range
4. Click to set depth
5. Repeat for offset if needed

### ClipVolume Integration

For ACA Section2d:
- Automatically uses section's ClipVolume
- Respects xRef entity selection
- Supports sections in host drawing referencing xRef entities (HSB-9215)

---

## Painter Definitions Integration

### Painter Definition Priority

Painter definitions (when available) take precedence over XML-based filter rules:
1. **Type Filter**: Painter's type (Beam, Sheet, GenBeam, etc.) must match selected Type
2. **Entity Filter**: Painter's filter expression applied to entity collection
3. **Format**: Painter's format used if PainterGrouping=Yes and Format property is empty
4. **Grouping**: Painter's groupBy definition used if PainterGrouping=Yes

### Supported Painter Types

| Painter Type | Compatible With | Notes |
|--------------|-----------------|-------|
| Beam | Beam, GenBeam | Timber beam members |
| Sheet | Sheet, GenBeam | Panel materials |
| Panel | Panel, GenBeam, SIP | SIP panels |
| GenBeam | GenBeam | Generic beams |
| TslInstance | TSL | TSL script instances |
| Entity | Masselement | Mass elements |
| MetalPartCollectionEntity | Metalpart | Hardware connectors |
| Element | Element | Wall/Floor/Roof elements |
| ElementRoof | Element | Roof elements specifically |
| Opening | Opening | Door/Window openings |
| FastenerAssemblyEnt | Fastener Assembly | Fastener collections |

### Creating Painter from hsbViewTag

When a painter is selected and settings stored:
- Hidden "Painter Definition" property stores serialized painter data
- If painter doesn't exist in catalog, it's auto-created on dbCreate
- Allows sharing tag configurations via DWG file

### Painter Group Settings (HSB-13442)

Context menu: "Painter Group Settings"

**Available when**: PainterGrouping = Yes AND painter has groupBy definition

**Settings**:
- **Solid Hatch**: Enable/disable solid hatch on subgroup geometry
- **Color**: Sequential colors for subgroups (semicolon-separated RGB: "24;154;64;214;64")
- **Transparency**: Transparency of subgroup hatches (0-100)

**Result**: Painter subgroups display colored regions on entity geometry in viewport/section.

---

## Collision Detection and Sequencing

### Collision Detection Algorithm

hsbViewTag uses sophisticated algorithms to prevent overlapping tags:

1. **Tag Protection Profiles**: Each tag generates a PlaneProfile representing its occupied area
2. **Protection Range Sharing**: Tags read protection ranges from other hsbViewTag instances
3. **Displacement Logic**: When collision detected, tag is displaced in preferred direction:
   - Horizontal style: Displaced vertically
   - Vertical style: Displaced horizontally
   - byEntity: Displaced perpendicular to entity axis
4. **Iterative Resolution**: Multiple passes to resolve cascading collisions

### Sequencing (Disabled by Default in v14.0+)

**Property**: Sequence = -1 (Disabled) or 0 (Auto)

**Note**: Sequencing is now read-only and defaults to Disabled (HSB-24122). This simplifies collision resolution and improves performance.

**Legacy Behavior** (v<14.0):
- Lower sequence numbers execute first and claim display area
- Higher sequence numbers avoid already-claimed areas
- 0 = Auto assigns sequence based on creation order
- Sequence coordination worked with hsbViewDimension and other tag instances

**Current Recommendation**: Use "Add No-Tag Area" to reserve space instead of sequencing.

---

## Working with Different Reference Types

### Paper Space Viewports

**AutoCAD Viewports**:
1. Insert hsbViewTag in Paper Space layout
2. Select viewport by clicking on it (or use graphical jig if multiple)
3. Optional: Select specific entities in model space
4. Tags placed in paper space, referencing model space entities

**hsbCAD Element Viewports**:
- Similar to AutoCAD viewports
- Additional support for element-based filtering
- Zone indices from viewport settings automatically applied

**Zone Handling**:
- Viewport zone settings filter which entities are collected
- "Add Zone Index" context menu can override (999 = all zones)
- Floorplan viewports accept GenBeams from any zone (HSB-10500)

### Model Space Sections (Section2d)

**ACA Sections**:
1. Insert hsbViewTag in Model Space
2. Select Section2d entity
3. Tags placed in model space near section
4. Section depth/offset can filter entities

**xRef Support** (HSB-9037):
- Sections in host drawing can reference entities in xRef
- Section2d can be placed in host, entities in xRef

**ClipVolume**:
- Section's ClipVolume automatically used
- Entities outside ClipVolume excluded

### MultiPage (Shop Drawings)

**Model Space Multipages**:
1. Insert in Model Space
2. Select MultiPage entity
3. If multiple views, graphical jig appears to select specific view
4. Tags placed relative to multipage layout

**Block Space Multipages**:
- Preview mode shows placeholder values
- Actual values generated when multipage is instantiated
- "Block Creation Mode" allows preview with example formatting

### ShopDrawView (Block Space)

**Shop Drawing Viewports**:
1. Detect block space environment (no GenBeams/Multipages in model)
2. Select ShopDrawView entity
3. Tags created in block definition
4. Transfer to instantiated shop drawings automatically

**Text Alignment** (HSB-23183):
- Context menu "Text Alignment" available in block space
- Options: Left, Center, Right
- Aligns tag text within tag boundary

---

## Advanced Features

### MetalPartCollectionEntity Support

**Nested Entity Tagging** (HSB-20497, requires hsbDesign 26+):
- Can tag individual components within MetalPartCollectionEntity
- Nested GenBeams contribute to quantity if in group mode
- Isometric views corrected (HSB-21294)

**Workflow**:
1. Set Type = Metalpart
2. Select painter with type "MetalPartCollectionEntity" OR use default collection
3. Tags individual components (beams, sheets, TSLs) within collection
4. Format can access component properties

### StackItem and StackPack Support (HSB-21973, HSB-23435)

**Stack Entity Types**:
- **StackItem**: Individual items in stack
- **StackPack**: Grouped stacks
- **StackEntity**: Generic stack entities

**Features**:
- Entities referenced by StackItems are accepted
- StackPacks and entities providing only solid in model view supported
- PosNum extracted from referenced entities if StackItem format includes `@(PosNum)`

### FastenerAssembly Support (HSB-23212, v13.9+)

**Type**: Fastener Assembly

**Data Access**:
- Component data (Name, Type, SubType, Manufacturer, Material, Model, etc.)
- Article data (ArticleNumber, Description, FastenerLength, ThreadLength, etc.)
- Comprehensive format variables for all fastener properties

**Use Case**: Tag fastener assemblies with model numbers and specifications for procurement lists.

### Numbering Unnumbered Items (HSB-19843, v11.0+)

**Context Menu**: "Assign Posnums"

**Availability**: Appears when unnumbered GenBeams or TSLs are detected AND format includes `@(PosNum)`

**Workflow**:
1. hsbViewTag detects entities without position numbers
2. Context menu command becomes available
3. Select "Assign Posnums"
4. Entities are automatically numbered sequentially
5. Tags update to show new numbers

**Visual Indicator**: Unnumbered items highlighted if `@(PosNum)` in format (HSB-16765)

### Weight Calculation

**Format Function**: `@(CALCULATE WEIGHT)`

**Workflow**:
```
Format: @(CALCULATE WEIGHT)@(Quantity) @(PosNum)\P@(Weight)
```

**Result**:
- Script calculates total weight of all collected entities
- Displays weight per tag (respects grouping)
- Uses entity material density and volume

### Grain Direction Symbol (Panels/SIP)

**Format Variable**: `@(Graindirection)` (note: lowercase 'd')

**Behavior**:
- Inserts a two-space placeholder in text
- Grain direction symbol drawn graphically at placeholder location
- Symbol orientation matches panel grain direction

**Example**:
```
Format: @(PosNum) @(Graindirection)
Result: "P-101  ↔"  (symbol drawn graphically)
```

### Zone Alignment Display (HSB-12678, v6.6+)

**Format Variable**: `@(Zone Alignment)`

**Applies To**: GenBeams within Elements

**Values**:
- "Front Face" - Beam on front face of zone/element
- "Back Face" - Beam on back face
- "All Faces" - Beam spans all faces
- "No Face" - Not associated with face

**Use Case**: Indicate which side of a wall a stud is on.

### Edit in Place Mode (HSB-18668, v10.8+)

**Activation**:
- Context menu: "Edit in Place"
- Placement: "Custom -> specify"

**Features**:
- Tags display glyph grips for repositioning
- Grouped tags support grips to reposition within range
- Drag tag to new location
- Position persists across recalculations

**Deactivation**:
- Context menu: "Disable Edit in Place"
- Returns to automatic placement

### Preferred Tag Areas and No-Tag Areas

**Preferred Tag Areas**:
- Context menu: "Set preferred tag areas"
- Define polyline regions where tags should preferably be placed
- Tags attempt to place within these regions first
- Falls back to normal placement if no space available

**No-Tag Areas**:
- Context menu: "Add No-Tag Area"
- Define exclusion zones (reserved for other annotations)
- Tags avoid these regions
- Multiple no-tag areas can be defined
- Use "Remove No-Tag Area" to clear

**Use Case**: Reserve space for title blocks, dimension chains, or manual annotations.

---

## Performance Optimization

### Calculation Complexity by Placement Mode

| Placement Mode | Calculation Speed | Entity Geometry Used |
|----------------|-------------------|----------------------|
| Viewport | Fastest | Entity center point only |
| Viewport, not on parent | Medium | Entity bounding box |
| Not on parent | Slower | Full entity profile outline |
| Custom | Fast (after initial) | Cached positions |
| Static Location | Fastest | Fixed position |

### Performance Tips

1. **Use Painter Definitions**: Filtering via painters is faster than collecting all entities
2. **Disable Sequencing**: Keep Sequence = -1 (now default)
3. **Avoid "Not on parent" for large drawings**: Use "Viewport, not on parent" instead
4. **Static Location for legends**: Use for non-changing annotation blocks
5. **Limit Section Depth**: Smaller section depth = fewer entities to process

### Entity Collection Optimization

**Auto Selection** (HSB-17894):
- Default: ON (collects all matching entities automatically)
- Turn OFF via context menu if you want to manually select specific entities
- Manual selection faster for small subsets in large drawings

**Painter Filtering**:
- Painter filter expression evaluated on entity collection
- Reduces entity count before tag generation
- Example: Filter only beams with Length > 2000mm

---

## Troubleshooting

### Common Issues and Solutions

| Problem | Possible Causes | Solution |
|---------|----------------|----------|
| **No entities collected** | Type setting doesn't match entities; Zone mismatch; Painter filter too restrictive | Check Type matches entities in view; Verify zone indices; Simplify painter filter |
| **Tags overlapping** | Collision detection not working; Insufficient space in viewport | Enable "not on parent" placement; Add No-Tag Areas to reserve space; Use "grouped" style |
| **Tags not visible** | Color set to background; Transparency 100; Layer off | Set Color to contrasting index; Reduce transparency; Check layer visibility |
| **Wrong format display** | Syntax error in format; Property name incorrect; Property doesn't exist for entity type | Verify `@(PropertyName)` syntax; Check property name spelling; Confirm property applies to selected Type |
| **Script erased on recalc** | Reference viewport/section deleted; Drawing corruption | Ensure viewport/section still valid; Reload drawing; Check for xRef issues |
| **Leader not showing** | Linetype set to disabled; Leader color matches background | Select linetype from dropdown; Check leader color in settings XML |
| **Tags on wrong entities** | Type set incorrectly; Painter filter not working | Verify Type setting; Check painter definition; Use "Add entities" to manually select |
| **Grouped tags incorrect** | Missing `@(Quantity)` in format; PainterGrouping not enabled; Entities not identical | Add `@(Quantity)` to format; Enable PainterGrouping if using painter; Check entity properties are identical |
| **Weight not calculating** | Missing `@(CALCULATE WEIGHT)` prefix; Material density not defined | Add `@(CALCULATE WEIGHT)` before `@(Weight)`; Assign material with density |
| **Grain symbol missing** | Typo in variable name; SIP/Panel not detected | Use `@(Graindirection)` (lowercase 'd'); Ensure Type = Panel or Sheet |
| **Unnumbered items not showing** | Format doesn't include `@(PosNum)`; Highlighting disabled | Add `@(PosNum)` to format; Visual indicator appears automatically |
| **Tags don't update** | Dependency tracking broken; Drawing needs regeneration | Recalculate TSL; Regen drawing (REGEN); Check for orphaned references |

### Error Messages

| Message | Meaning | Action |
|---------|---------|--------|
| "Select a viewport" | No viewport found or selected | Ensure you're in Paper Space layout with viewports |
| "Select reference" | No Section/MultiPage selected | Select valid Section2d or MultiPage entity |
| "Select shopdraw viewport" | In block space but no ShopDrawView | Ensure ShopDrawView exists in block |
| "Invalid reference" | Reference entity deleted or invalid | Re-insert tag with valid reference |

### Debug Mode

**Enable Debug Output**:
```c
int bDebug = 1; // Set in script or via _bOnDebug
```

**Debug Features**:
- Console messages showing execution flow
- Visual debugging via `.vis()` methods
- Protection profile visualization
- Collision detection visualization

---

## Version-Specific Features

### Version 14.x (Current)

- **14.1** (HSB-24510): Improved solid handling for element display
- **14.0** (HSB-24122): Sequencing disabled by default (read-only property)

### Version 13.x

- **13.9** (HSB-23212): FastenerAssembly type support added
- **13.8** (HSB-23688): Tag placement improved for TSL references, "not on parent" placement enhanced
- **13.7** (HSB-23435): StackPacks and entities providing only solid in model view supported
- **13.6** (HSB-23183): Text alignment commands in block space
- **13.3** (HSB-22503): Alignment text and grain symbol adjusted
- **13.0** (HSB-22175): "Not on parent" modes significantly improved for floor plans

### Version 12.x

- **12.0** (HSB-20497): Nested entity tagging in MetalPartCollectionEntities (requires hsbDesign 26+)

### Version 11.x

- **11.0** (HSB-19843): Context menu to number unnumbered items
- **11.1-11.2** (HSB-18094): TSL selection supports multiple selection from list

### Version 10.x

- **10.8** (HSB-18668): Grouped tags support glyph grips for repositioning
- **10.1** (HSB-17894): Optional entity selection in viewport mode

### Version 9.x

- **9.5** (HSB-16765): Grouped styles added, rounded rectangle outlines
- **9.0** (HSB-16117): New OPM format control (requires hsbDesign 24.1.11+)

### Version 7.x

- **7.0** (HSB-13442): Painter groupBy definition support, automatic painter creation from catalog

### Version 5.x

- **5.0** (HSB-7922): Painter definitions can be selected as rule (requires hsbDesign 23+)

---

## Integration with Other Scripts

### Related hsbCAD Scripts

| Script | Relationship | Integration |
|--------|-------------|-------------|
| **hsbViewDimension** | Dimension tool | Shares collision detection, sequencing coordination (legacy) |
| **MultipageController** | Shop drawing system | Provides MultiPage references for tagging |
| **Painter Definitions** | Entity filtering | Used as filter rules and format sources |
| **hsbLayoutDim** | Layout dimensioning | Collision coordination via sequence |
| **hsb_ScriptInsert** | TSL insertion utility | Programmatic insertion support |

### Workflow Integration Points

**Before hsbViewTag**:
1. Create Elements (walls, floors, roofs) with hsbCAD element tools
2. Number entities with position numbers (or use "Assign Posnums")
3. Create painter definitions for complex filtering
4. Set up viewports, sections, or multipages
5. Configure dimension styles

**After hsbViewTag**:
1. Export to shop drawings (MultiPage system)
2. Generate bills of material (tags provide position numbers)
3. Create assembly instructions (tags provide part identification)
4. Coordinate with dimension scripts (shared collision detection)

---

## Best Practices

### Format String Design

**DO**:
- Use clear, concise format strings
- Round dimensions appropriately: `@(Length:0)` for construction, `@(Length:2)` for precision
- Combine related properties: `@(Width) x @(Height) x @(Length)`
- Use multi-line for complex data: `@(PosNum)\P@(Material)\P@(Quantity)`

**DON'T**:
- Include too much information (makes tags hard to read)
- Forget rounding on dimensions (unnecessary decimals)
- Use properties that don't exist for selected Type

### Placement Strategy

**Floor Plans**: "Not on parent" for cleanest appearance (optimized in v13.0+)
**Elevations**: "Horizontal" or "Vertical" style with "Viewport, not on parent"
**Sections**: Use Section Depth to filter entities by cut distance
**Shop Drawings**: "Static Location" for legend-style blocks, "Viewport" for part labels

### Painter Usage

**When to Use Painters**:
- Complex filtering requirements (material, size ranges, etc.)
- Standardized tag formats across multiple drawings
- Grouping by specific properties (painter groupBy)
- Multiple tag types on same viewport (different painters)

**When to Use Direct Type Selection**:
- Simple filtering (all beams, all sheets)
- One-off tagging tasks
- Quick annotations

### Grouping Strategy

**Use Grouping** (`@(Quantity)` + "grouped" style):
- Repetitive members (studs, joists)
- Hardware schedules (identical fasteners)
- Material schedules (identical panels)

**Avoid Grouping**:
- Unique items (each needs individual label)
- When exact position identification is critical
- Mixed property sets (grouping won't trigger)

### Performance Considerations

**Large Drawings** (>1000 entities):
- Use Painter filtering to reduce entity count
- Avoid "Not on parent" unless necessary
- Disable sequencing (now default)
- Consider multiple tag instances for different zones/types

**Small Drawings** (<100 entities):
- "Not on parent" acceptable
- Full formatting options available
- Grouping provides cleaner appearance

---

## XML Settings File

### File Location

**Company Path** (preferred):
```
[CompanyPath]\TSL\Settings\hsbViewTag.xml
```

**Installation Path** (fallback):
```
[InstallPath]\Content\General\TSL\Settings\hsbViewTag.xml
```

### Settings Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Style[]">
    <lst nm="Style">
      <str nm="Name" vl="byEntity"/>
      <str nm="BeamPackDelimiter" vl="x"/>
      <int nm="isActive" vl="1"/>
    </lst>
  </lst>

  <lst nm="FilterRule[]">
    <lst nm="FilterRule">
      <str nm="Name" vl="My Rule"/>
      <int nm="Type" vl="1"/>
      <int nm="isActive" vl="1"/>
    </lst>
  </lst>

  <lst nm="PainterGroup[]">
    <lst nm="PainterGroup">
      <str nm="Painter" vl="MyPainter"/>
      <int nm="Transparency" vl="80"/>
      <str nm="Color" vl="24;154;64;214;64"/>
      <str nm="Solid Hatch" vl="No"/>
    </lst>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Settings Parameters

**Style[]**:
- `Name`: Style name (appears in dropdown)
- `BeamPackDelimiter`: Character used to separate quantity (default: "x")
- `isActive`: 1=active (shown), 0=inactive (hidden)

**FilterRule[]**:
- `Name`: Rule name
- `Type`: Entity type index (matches sTypes array)
- `isActive`: 1=active, 0=inactive

**PainterGroup[]**:
- `Painter`: Painter definition name
- `Transparency`: 0-100
- `Color`: Sequential RGB colors (semicolon-separated)
- `Solid Hatch`: "Yes"/"No"

### Import/Export Settings

**Export Current Settings**:
1. Right-click tag instance
2. Select "Export Settings"
3. XML file saved to company path

**Import Settings**:
1. Right-click tag instance
2. Select "Import Settings"
3. Select XML file
4. Settings applied to current instance

**Export Default Settings**:
1. Used on first insertion when no settings file exists
2. Creates default XML template
3. Can be customized as company standard

---

## Examples

### Example 1: Simple Position Number Tags

**Goal**: Tag all beams with position numbers

**Settings**:
- Type: Beam
- Format: `@(PosNum)` (or leave empty for auto)
- Style: Horizontal
- Placement: Viewport

**Result**: Each beam tagged with its position number (e.g., "101", "102", "W-23")

---

### Example 2: Beam Schedule Tags

**Goal**: Show beam dimensions and material

**Settings**:
- Type: Beam
- Format: `@(PosNum)\P@(Width) x @(Height) x @(Length:0)\P@(Material)`
- Style: Horizontal, Frame
- Placement: Viewport, not on parent

**Result**: Multi-line tags:
```
W-101
38 x 140 x 2400
SPF No.2
```

---

### Example 3: Grouped Stud Tags

**Goal**: Tag wall studs with quantity

**Settings**:
- Type: Beam
- Format: `@(Quantity) @(PosNum)`
- Style: Horizontal, grouped
- Placement: Viewport

**Result**: Grouped tags like "12x S-101" for 12 identical studs

---

### Example 4: Panel Grain Direction

**Goal**: Show panel position and grain

**Settings**:
- Type: Panel
- Format: `@(PosNum) @(Graindirection) @(GrainDirectionTextShort)`
- Style: Horizontal, Frame
- Placement: Not on parent

**Result**: Tags like "P-201 ↔ Grain LW" (symbol drawn graphically)

---

### Example 5: Fastener Schedule

**Goal**: Tag fastener assemblies with specifications

**Settings**:
- Type: Fastener Assembly
- Format: `@(Manufacturer) @(Model)\P@(ArticleNumber)\P@(FastenerLength:0)mm`
- Style: Horizontal, Frame
- Placement: Viewport

**Result**:
```
Simpson Strong-Tie
LUS24
#123456
60mm
```

---

### Example 6: Opening Schedule

**Goal**: Tag openings with rough dimensions

**Settings**:
- Type: Window
- Format: `@(OpeningDescription)\P@(WidthRough:0) x @(HeightRough:0)`
- Style: Horizontal, Frame
- Placement: Viewport, not on parent

**Result**:
```
Window Type A
914 x 1219
```

---

### Example 7: Section View with Depth Filter

**Goal**: Tag only beams within 500mm of section cut

**Workflow**:
1. Insert hsbViewTag in model space
2. Select Section2d
3. Right-click tag → "Set Section Depth"
4. Graphical jig: pick point 500mm from section line
5. Tags only show beams within 500mm depth

**Settings**:
- Type: Beam
- Format: `@(PosNum)`
- Style: byEntity
- Section Depth: 500mm

---

### Example 8: MetalPart Component Tags

**Goal**: Tag individual beams within metal connector

**Settings**:
- Type: Metalpart
- Painter/Rule: Select painter with type "MetalPartCollectionEntity"
- Format: `@(PosNum) @(Definition)`
- Style: Horizontal
- Placement: Viewport

**Result**: Tags on each beam component of the metal part assembly

---

### Example 9: Weight Schedule

**Goal**: Show total weight per beam type

**Settings**:
- Type: Beam
- Format: `@(CALCULATE WEIGHT)@(Quantity) @(PosNum)\P@(Weight:1) kg`
- Style: Horizontal, Frame, grouped
- Placement: Viewport

**Result**: Tags like:
```
5x B-301
112.5 kg
```
(Total weight of 5 beams)

---

### Example 10: Zone-Specific Tags

**Goal**: Tag only zone 2 beams

**Settings**:
- Type: byZone (or Beam with painter filter)
- Format: `@(PosNum)`
- Context Menu: "Add Zone Index" → Enter "2"

**Result**: Only beams in zone 2 are tagged

---

## Summary

hsbViewTag is a production-grade annotation tool providing:

✓ **Comprehensive Entity Support**: 16 entity types from beams to fastener assemblies
✓ **Flexible Formatting**: Powerful `@(Property)` template system with 80+ variables
✓ **Intelligent Placement**: Advanced collision detection with 5 placement strategies
✓ **Multi-Environment**: Paper space, model space, sections, multipages, shop drawings
✓ **Grouping and Filtering**: Painter definitions, quantity grouping, zone filtering
✓ **Production Features**: Weight calculation, grain symbols, manual positioning, no-tag areas
✓ **Performance**: Optimized for large drawings with painter filtering and disabled sequencing

**Minimum Version**: hsbCAD 24.1.11 (some features require v26+)
**Script Type**: O-Type (Object script)
**Update Frequency**: Tags recalculate automatically when entities or viewports change

---

## Related Documentation

- **hsbViewDimension**: Dimension tool with collision coordination
- **MultipageController**: Shop drawing layout system
- **Painter Definitions**: Entity filtering and formatting system
- **hsbCAD Element Tools**: Creating walls, floors, roofs for tagging
- **Shop Drawing System**: Integration with fabrication documentation

---

**Document Version**: 2.0
**Script Version**: 14.1
**Last Updated**: 2025-02-20
