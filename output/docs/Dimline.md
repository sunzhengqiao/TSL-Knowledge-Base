# Dimline

## Overview and Purpose

**Dimline** is a comprehensive, intelligent dimensioning tool for hsbCAD that creates parametric dimension lines for timber construction drawings. Unlike standard AutoCAD dimensioning, Dimline is entity-aware and automatically updates when linked timber members, walls, panels, or elements are modified. It works seamlessly across Model Space, Paper Space, and Shop Drawing environments.

### Key Capabilities

- **Multi-Entity Support**: Dimensions GenBeams, Elements (walls/floors/roofs), Openings, Sheets, Panels, SIPs, Polylines, Sections, Multipages, Collection entities (Trusses, MetalParts), and Block references
- **Intelligent Point Collection**: Automatically extracts dimension points from entity geometry, tools (drills, cuts, mortises), and TSL-defined requests
- **Advanced Modes**: Chain dimensions, Delta dimensions, Diagonal control dimensions, Gable dimensions, Offset dimensions
- **Parametric Behavior**: Dimensions automatically recalculate when linked entities move or change
- **Painter Filtering**: Use PainterDefinitions to selectively dimension specific entity types or properties
- **Tool Dimensioning**: Optionally dimension manufacturing operations (drills, mortises, slots, beamcuts)

---

## Usage Environment

| Space | Support | Notes |
|-------|---------|-------|
| **Model Space** | Full | Dimension beams, elements, openings, polylines, sections, multipages, collection entities |
| **Paper Space** | Full | Dimension through hsbCAD viewports; supports Offset Dimension mode for deviation measurements |
| **Shop Drawing (Block Space)** | Full | Works with ShopDrawView viewports; auto-generates dimensions during shop drawing production |

---

## Prerequisites

### Software Requirements
- **hsbDesign 26 or higher** (mandatory from Version 6.0+)
- AutoCAD or hsbCAD with active drawing

### Entity Requirements

At least one of the following must exist in the drawing:

**Model Space:**
- GenBeams (timber members)
- Elements (walls, floors, roofs)
- Openings (doors, windows)
- Sheets/Panels/SIPs
- Polylines with geometry definitions
- Sections (Section2d)
- Multipages (MultiPage)
- Collection entities (TrussEntity, MetalPartCollectionEntity, CollectionEntity)
- Block references

**Paper Space:**
- hsbCAD viewport linked to an Element

**Shop Drawings:**
- ShopDrawView viewport

---

## Parameter Reference

### Dimension Category

Parameters controlling what points are dimensioned and how dimensions are displayed.

#### Dimension Point Mode
**Type**: Dropdown
**Default**: `<Default>`
**Location**: Properties Panel > Dimension Category

Controls which points are collected from reference entities.

| Mode | Description | Use Case |
|------|-------------|----------|
| **Default** | All geometry vertices and edges | Standard dimensioning |
| **First Point** | Only the first point of each entity | Simple span dimensions |
| **Last Point** | Only the last point of each entity | Endpoint-only dimensions |
| **Mid Point** | Only the geometric center | Center-to-center dimensions |
| **Extreme Points** | Outermost points in dimension direction | Overall length/width |
| **First Point + Merged** | First points + combined profile vertices | Complex assemblies |
| **Last Point + Merged** | Last points + combined profile vertices | Complex assemblies |
| **Mid Point + Merged** | Mid points + combined profile vertices | Complex assemblies |
| **Extreme Points + Merged** | Extreme points + combined profile vertices | Complex assemblies |
| **Offset Dimension** *(Paper Space only)* | Shows offset/deviation from reference | Quality control, deviation checking |

**Note**: Merged modes combine geometry from multiple selected entities into a single dimension profile, useful for dimensioning assemblies as a unit.

#### Delta/Chain Mode
**Type**: Dropdown
**Default**: `parallel / perpendicular`

Controls display of incremental (delta) and running (chain) dimensions.

| Mode | Delta Display | Chain Display | Use Case |
|------|---------------|---------------|----------|
| **parallel / perpendicular** | Parallel to dim line | Perpendicular to dim line | Standard hsbCAD style |
| **perpendicular / parallel** | Perpendicular to dim line | Parallel to dim line | Alternate arrangement |
| **classic** | AutoCAD baseline style | AutoCAD continue style | AutoCAD compatibility |
| **parallel / Disabled** | Parallel to dim line | None | Delta only |
| **Disabled / perpendicular** | None | Perpendicular to dim line | Chain only |
| **Disabled / Disabled** | None | None | Manual text only |

**Business Logic**: Delta dimensions show segment lengths (useful for cutting lists), while chain dimensions show cumulative distances (useful for layout marking).

#### Reference Point Mode
**Type**: Dropdown
**Default**: `<Default>`

Defines which reference points establish the dimension origin.

| Mode | Description | Use Case |
|------|-------------|----------|
| **None** | No fixed reference | Floating dimensions |
| **First Point** | First point in selection becomes origin | Left-aligned dimensions |
| **Last Point** | Last point in selection becomes origin | Right-aligned dimensions |
| **Extreme Points** | Outermost points | Overall assembly dimensions |
| **Closest Point** | Point nearest to dimension line | Adaptive referencing |

#### Shape Mode
**Type**: Dropdown
**Default**: `<Default>` (Medium Detail)

Controls how entity shapes are interpreted for dimension point collection.

| Mode | Detail Level | Performance | Description |
|------|--------------|-------------|-------------|
| **Low Detail** | Bounding box only | Fastest | Dimensions outer rectangle extremes only |
| **Medium Detail** | Contour with cuts/openings | Balanced | Dimensions outer contour including tool operations (default) |
| **High Detail** | Real body geometry | Slowest | Processes actual 3D solid geometry for maximum accuracy |
| **Extreme Points** | Extremes in dimension direction | Fast | Outermost points along dimension direction only |

**Performance Impact**: Use Low Detail or Medium Detail for complex models with many entities. High Detail can be significantly slower but provides precise geometric dimensioning.

**Restrictions**: Diagonal and Gable dimension modes automatically restrict Shape Mode to Low or Medium Detail.

#### TSL / Stereotype
**Type**: Text (semicolon-separated)
**Default**: (empty)

Specifies additional dimension points from TSL scripts or stereotypes. Semicolon-separated list.

**Examples**:
- `hsbCLT-Drill` – Adds drill center points from CLT drill scripts
- `FastenerType1;FastenerType2` – Adds points from multiple fastener types
- `*` – Wildcard: accepts dimension requests from ANY TSL (use with caution)

**Business Logic**: Many hsbCAD TSL scripts publish "dimension requests" (special coordinate sets stored in their `_Map` under key `"DimRequest[]"`). This property tells Dimline to honor those requests.

**Context Commands**:
- Right-click Dimline → "Define Parent Tool Filter" – Opens dialog to select TSL scripts/stereotypes
- Adds/removes entries from the semicolon list

#### Tool Set
**Type**: Text
**Default**: (empty)

Defines which tool types (machining operations) contribute dimension points.

**Available Tool Types** (examples):
- Drills: Perpendicular, Rotated, Tilted, Head side, 5-Axis
- Cuts: Perpendicular, Hip, Angled, Beveled, Compound
- Mortises: Perpendicular, Rotated, Tilted, 5-Axis, Beam end
- Slots: Perpendicular, Rotated, Tilted, 5-Axis
- Beamcuts: Seat cut, Birdsmouth, Housing, Lap joint, Rabbet, Dado
- Rabbets/Dados: Perpendicular, 5-Axis
- Chamfers

**Context Command**: Right-click Dimline → "Define Tool Sets" – Opens dialog with checkboxes for all tool types

**Use Case**: Manufacturing drawings often need to dimension drill locations, mortise positions, or cut extents. Enable only the relevant tool types to avoid clutter.

---

### Filter Category

Parameters controlling entity filtering via PainterDefinitions.

#### Dimension
**Type**: Dropdown (PainterDefinition)
**Default**: First painter in "Dimension\" collection

Painter definition to filter which entities are dimensioned.

**How It Works**: PainterDefinitions are hsbCAD's filtering system. A painter specifies:
- Entity type (GenBeam, Sheet, Element, Opening, etc.)
- Filter criteria (e.g., "Zone 0 Beams", "Vertical Studs", "Horizontal Joists")

**Default Painters** (auto-created):
- `Dimension\Element\Openings` – Filters openings (doors, windows)
- `Dimension\Element\Beams Vertical` – Filters vertical beams
- `Dimension\Element\Beams Horizontal` – Filters horizontal beams
- `Dimension\Element\Zone 0` – Filters beams in Zone 0

**Painter Management**: Right-click Dimline → "Painter Management" → Access all painters (not just "Dimension\" collection)

**Advanced**: If "Dimension\" collection doesn't exist, Dimline shows ALL available painters.

#### Reference
**Type**: Dropdown (PainterDefinition)
**Default**: First painter in "Dimension\" collection (reference category)

Painter definition to filter reference entities for the dimension origin.

**Use Case**: When dimensioning a wall assembly, you might want to reference only the bottom plate or only the top plate. The Reference painter filters which entities establish the zero point.

**Interaction with Reference Point Mode**: This painter works in conjunction with Reference Point Mode to define origin behavior.

---

### Display Category

Parameters controlling visual appearance of dimensions.

#### DimStyle
**Type**: Dropdown (AutoCAD Dimension Style)
**Default**: Current AutoCAD DimStyle

AutoCAD dimension style to use. **Only linear dimension styles are shown** (angular, radial, diameter styles are excluded).

**Note**: If DimStyle doesn't exist in drawing, Dimline falls back to first available linear style.

#### Text Height
**Type**: Number (Length unit)
**Default**: `0` (use DimStyle default)

Dimension text height override.

- **Value = 0**: Use text height from the selected DimStyle
- **Value > 0**: Override DimStyle text height with this value

**Use Case**: Quickly adjust text size without modifying the DimStyle definition.

#### Scale Factor
**Type**: Number (unitless multiplier)
**Default**: `1.0`
**Valid Range**: Must be > 0

Multiplier for dimension values (e.g., for unit conversion or scaling).

**Examples**:
- `1.0` – Normal (1:1)
- `0.001` – Convert mm to meters (1000mm = 1.0m displayed)
- `0.0393701` – Convert mm to inches (25.4mm = 1.0" displayed)
- `2.0` – Double all dimension values (for scaled drawings)

**Business Logic**: This does NOT affect DimStyle's dimension scale factor (DIMSCALE). This is a value-only multiplier applied to the measured distance.

#### Format
**Type**: Text (format string)
**Default**: (empty – use default dimension text)

Custom format string for dimension text using hsbCAD format variables.

**Format Syntax**:
```
@(VariableName:FormatCode;Unit:Precision)OptionalSuffix
```

**Examples**:
- `@(Length:RL0)` – Length rounded to 0 decimals
- `@(Length:RL3)mm` – Length with 3 decimals + "mm" suffix
- `@(Area:CU;m:RL3)m²` – Area in square meters with 3 decimals
- `Oversail <>` – Shows "Oversail" + dimension value (for offset dimensions)
- `Undersail <>` – Shows "Undersail" + dimension value

**Format Codes**:
- `RL0`, `RL1`, `RL2`, `RL3` – Round Length to 0, 1, 2, 3 decimals
- `CU` – Convert Units
- `m`, `mm`, `cm` – Specify unit

**Offset Dimension Mode**: Use `Oversail <>` or `Undersail <>` notation to prefix deviation values with descriptive text.

#### Sequence
**Type**: Integer
**Default**: `0` (automatic)

Priority for collision resolution with other dimlines and tags.

- **`-1`**: Disabled (no collision avoidance)
- **`0`**: Automatic collision resolution
- **`> 0`**: Manual priority (lower numbers avoid higher numbers)

**Use Case**: When multiple dimension lines overlap, Sequence determines which one shifts position to avoid collision. Critical dimensions can be set to low numbers (e.g., `1`) to remain fixed while less important dimensions (high numbers) adjust.

---

## Usage Instructions

### Basic Workflow

#### Step 1: Launch Dimline

**Method A: Command Line**
```
Command: TSLINSERT
Select script: Dimline.mcr
```

**Method B: Custom Command** (if configured)
```
Command: TSLCONTENT
(Macro: ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Dimline")) TSLCONTENT)
```

#### Step 2: Select Reference Entities

**In Model Space:**
1. Prompt: `"Select references"`
2. Select one or more entities:
   - Click individual beams, elements, openings
   - Use window selection for multiple entities
   - Mix different entity types (beams + sheets + panels)
3. Press `Enter` to confirm selection

**In Paper Space:**
1. Prompt: `"Select a viewport"`
2. Click on an hsbCAD viewport (must be linked to an Element)
3. The script automatically detects the element linked to the viewport

**In Block Space (Shop Drawing):**
1. Prompt: `"Select a viewport"`
2. Click on a ShopDrawView viewport
3. Prompt: `"Pick point outside paperspace to place setup information"`
4. Click outside the viewport to place setup graphics (non-plottable reference geometry)

#### Step 3: Define Dimension Direction

After selecting entities, a **preview dimension** appears. Use **keyboard shortcuts** to configure:

| Key | Action | Description |
|-----|--------|-------------|
| **`X`** | X-Axis | Align dimension along drawing X-axis |
| **`Y`** | Y-Axis | Align dimension along drawing Y-axis |
| **`A`** | Align | Pick two points to define custom alignment |
| **`G`** | Segment | Select a segment from visible geometry to align to |
| **`D`** | Diagonal | Enable diagonal dimension mode (for rafters, hip beams) |
| **`S`** | Swap | Swap text position (delta on top ↔ chain on top) |
| **`P`** | Add Points | Manually add dimension points by clicking |
| **`T`** | Text Height | Adjust text height interactively |
| **`M`** | Match Visuals | Copy style settings (DimStyle, text height, format) from existing Dimline |

**Ortho Mode Support**: Ortho mode (`F8`) is supported for precise orthogonal alignment.

#### Step 4: Place Dimension Line

1. Move cursor to position the dimension line at desired offset from entities
2. Preview shows dimension values in real-time
3. Click to finalize position
4. The dimension line is created and linked to the reference entities

**Grip Points**: After placement, drag the grip at `_Pt0` to reposition the entire dimension line. Additional grips (`_PtG0`, `_PtG1`, etc.) allow fine-tuning specific segments.

---

### Advanced Workflows

#### Dimensioning Specific Tool Types

**Scenario**: You need to dimension only drill hole locations on a CLT panel.

1. Insert Dimline and select the panel
2. Right-click the Dimline instance → **"Define Tool Sets"**
3. Dialog opens with checkboxes for all tool types
4. Check only: `Drill, perpendicular`, `Drill, rotated`, `Drill, tilted`
5. Click OK
6. Dimline now shows only drill center points

**Related Properties**:
- Tool Set property stores selected tool types
- Shape Mode should be Medium or High Detail to process tools

#### Using TSL Dimension Requests

**Scenario**: A custom fastener TSL publishes dimension points. You want Dimline to honor them.

1. Insert Dimline and select entities
2. Right-click the Dimline → **"Define Parent Tool Filter"**
3. Dialog shows list of TSL scripts and stereotypes
4. Select the fastener script name (e.g., `CustomFastener`)
5. Click OK
6. TSL / Stereotype property now contains `CustomFastener`
7. Dimline adds dimension points from that TSL's `_Map["DimRequest[]"]`

**Wildcard**: Enter `*` to accept requests from ALL TSLs (warning: may create many dimension points).

#### Diagonal Dimensions (Rafters, Hip Beams)

**Scenario**: Dimension the true length and position of a rafter along its slope.

1. Insert Dimline and select the rafter beam(s)
2. Press **`D`** (Diagonal mode) during insertion
3. Prompt: `"Select segment"`
4. Click on the rafter's diagonal segment
5. Dimline aligns along the rafter slope
6. Place the dimension line parallel to the rafter

**Alternative**: Right-click existing Dimline → **"Set Diagonal"**

**Automatic Logic**: Diagonal mode finds valid diagonal connections between vertices and restricts Shape Mode to Low or Medium Detail for performance.

#### Gable Dimensions (Non-Orthogonal Elements)

**Scenario**: Dimension a gable wall with sloped top edge in a Paper Space viewport.

1. In Paper Space, insert Dimline
2. Select the viewport showing the gable wall
3. Dimline automatically detects the gable geometry
4. Multiple aligned dimension lines can be created for different edges
5. Each dimension line can align to a different gable edge

**Automatic Activation**: Gable mode activates automatically when dimensioning non-orthogonal elements in viewports.

#### Offset Dimensions (Quality Control)

**Scenario**: Check if wall studs are installed with correct spacing. Show deviations from design.

1. In Paper Space with an hsbCAD viewport
2. Insert Dimline and select viewport
3. Set **Dimension Point Mode** = `Offset Dimension`
4. Set **Format** = `Oversail <>`  (or `Undersail <>`)
5. Dimension shows offset/deviation values from reference
6. Positive values show oversail, negative show undersail

**Use Case**: Quality control, as-built verification, deviation documentation.

#### Multipage Shop Drawings

**Scenario**: A MultiPage contains multiple views. You want consistent dimension alignment.

1. Insert Dimline on a MultiPage entity (or in its block space)
2. Create multiple dimension lines for different views
3. Right-click any Dimline → **"Align Dimlines"**
4. All dimension lines associated with the MultiPage align consistently
5. Right-click any Dimline → **"Purge Dimlines"** to remove redundant dimensions

**Auto-Generation**: When ShopDrawing regenerates, Dimline instances in block space auto-create copies via `_bOnGenerateShopDrawing` event.

---

## Right-Click Context Menu

### Primary Context Menu (Root)

Right-click a selected Dimline instance to access:

| Menu Item | Keyboard | Description |
|-----------|----------|-------------|
| **Add Points** | `P` | Manually add dimension points by clicking locations |
| **Remove Points** | – | Remove previously added manual dimension points |
| **Add Entities** | – | Add more entities to the dimension reference set |
| **Remove Entities** | – | Remove entities from the dimension reference set |
| **Set Alignment** | `A` | Pick two points to define dimension line direction |
| **Select Segment** | `G` | Choose a segment from visible shape to align dimensions |
| **Set Diagonal** | `D` | Enable diagonal dimension mode and select diagonal direction |
| **Rotate 90 deg** | – | Rotate dimension line direction by 90 degrees |
| **Swap Delta/Chain** | `S` | Toggle whether delta or chain dimensions appear on top |
| **Copy Dimline** | – | Create a duplicate of the current dimension line |
| **Define Tool Sets** | – | Open dialog to select tool types (drills, cuts, etc.) for dimensioning |
| **Define Parent Tool Filter** | – | Select TSL scripts/stereotypes that should contribute tool dimensions (sets TSL / Stereotype property) |
| **Set Viewport Reference Mode** *(Paper Space only)* | – | Choose reference location: Fixed, Relative to Dimension Entities, Relative to Extremes |
| **Align Dimlines** *(Multipage only)* | – | Align all dimlines associated with the current MultiPage |
| **Purge Dimlines** *(Multipage only)* | – | Remove redundant dimension lines from the MultiPage |
| **Regenerate Shopdrawing** | – | Force regeneration of the associated shop drawing |
| **Add Dimension** | – | Add another dimension line aligned with the current one |

### Secondary Context Menu (Dimline Submenu)

Right-click Dimline → **"Dimline"** submenu:

| Menu Item | Description |
|-----------|-------------|
| **Global Settings** | Configure group assignment behavior (assign to entity group vs. Layer 0) |
| **Drill Dimension Visibility Settings** | Configure visibility rules for drill dimensions based on view direction (per entity type: Beam, Sheet, Panel, MetalPart). Options: Any view, Perpendicular to View, Parallel to View |
| **Add/Remove RUB-Grid** | Toggle RUB-Grid association for the dimension (advanced feature) |
| **Import Settings** | Load settings from XML configuration file (`Dimline.xml`) |
| **Export Settings** | Save current settings to XML configuration file |
| **Painter Management** | Access painter definition management options (opens painter editor) |

---

## Painter Definitions (Entity Filtering)

### What Are Painters?

**PainterDefinitions** are hsbCAD's intelligent filtering system. A painter defines:
- **Entity Type**: GenBeam, Sheet, Panel, Element, Opening, TslInstance, etc.
- **Filter Criteria**: Logical expressions (e.g., "Zone = 0 AND Orientation = Vertical")

### Default Painters

Dimline auto-creates painters in the `"Dimension\"` collection:

| Painter Path | Entity Type | Filter | Use Case |
|--------------|-------------|--------|----------|
| `Dimension\Element\Openings` | Opening | (all) | Dimension door/window openings |
| `Dimension\Element\Beams Vertical` | GenBeam | Vertical orientation | Dimension studs, posts |
| `Dimension\Element\Beams Horizontal` | GenBeam | Horizontal orientation | Dimension plates, joists |
| `Dimension\Element\Zone 0` | GenBeam | Zone = 0 | Dimension main structure zone |

### Using Painters

**Scenario**: Dimension only vertical studs in a wall, ignoring plates and blocking.

1. Insert Dimline and select the wall element
2. In Properties Panel, set **Dimension** = `Dimension\Element\Beams Vertical`
3. Dimline now dimensions only vertical beams

**Advanced Filtering**: Access Painter Management to create custom painters with complex logic.

### Painter Precedence

- If `"Dimension\"` collection exists, only those painters are shown in dropdown
- If `"Dimension\"` collection doesn't exist, ALL painters are shown
- Use **"Painter Management"** context command to access all painters regardless of collection

---

## Settings and Configuration

### Settings Files

Dimline stores global settings in XML format:

**Company Path** (overrides installation):
```
[Company Path]\TSL\Settings\Dimline.xml
```

**Installation Path** (default):
```
[Install Path]\Content\General\TSL\Settings\Dimline.xml
```

### Settings Content

| Setting Category | Stored Data |
|------------------|-------------|
| **Global Settings** | Group assignment behavior (default: assign to entity group vs. Layer 0) |
| **Drill Visibility Strategies** | Per entity type (Beam, Sheet, Panel, MetalPart): Any view, Perpendicular, Parallel |
| **Painter Management** | Custom painter definitions and preferences |

### Import/Export Settings

**Export Current Settings**:
1. Right-click Dimline → "Dimline" → **"Export Settings"**
2. Choose file location
3. Saves current configuration to XML

**Import Saved Settings**:
1. Right-click Dimline → "Dimline" → **"Import Settings"**
2. Select XML file
3. Settings are applied to current instance

**Use Case**: Standardize dimensioning across projects or share configuration between team members.

---

## Special Features

### Individual Coloring (ByBlock DimStyle)

**Version 9.0+** supports individual coloring when DimStyle uses **ByBlock** color mode.

**How It Works**:
1. Create a DimStyle with:
   - Dimension Line Color = ByBlock
   - Extension Line Color = ByBlock
   - Text Color = ByBlock
2. Assign the DimStyle to Dimline
3. Set Dimline's Color property (in Properties Panel or via AutoCAD Properties)
4. All dimension components inherit the Dimline's color

**Use Case**: Color-code dimensions by category (red = critical, blue = reference, etc.).

### Viewport Reference Location Modes

**Available in Paper Space hsbCAD viewports only.**

Right-click Dimline → **"Set Viewport Reference Mode"**:

| Mode | Description | Use Case |
|------|-------------|----------|
| **Fixed Location** | Setup graphics at fixed point in Paper Space | Consistent layout position |
| **Relative to Dimension Entities** | Setup graphics offset from dimensioned entities | Keeps graphics near geometry |
| **Relative to Extremes** | Setup graphics offset from extreme points | Adaptive positioning |

**Setup Graphics**: Non-plottable reference geometry drawn on T-Layer (Template Layer) in Paper Space. Visible for editing, invisible for plotting.

### Collision Avoidance (Sequence Property)

**Problem**: Multiple dimension lines overlap, making text unreadable.

**Solution**: Dimline automatically resolves collisions using Sequence numbers.

**Configuration**:
- Set critical dimensions to low Sequence numbers (e.g., `1`, `2`, `3`)
- Set optional dimensions to high Sequence numbers (e.g., `100`, `200`)
- Low-numbered dimensions remain fixed, high-numbered dimensions shift position

**Disable**: Set Sequence = `-1` to disable collision avoidance for a specific Dimline.

### Group Assignment

**Default Behavior**: Dimline instances are grouped with their reference entities.

**Override**: Right-click Dimline → "Dimline" → **"Global Settings"** → Set Group Assignment = `No group assignment`

**Effect**: Dimline instances remain on Layer 0 instead of being grouped with entities.

**Use Case**: Dimensions on a separate layer for visibility control.

---

## Tips and Best Practices

### 1. Performance Optimization

**Issue**: Dimensioning complex models with hundreds of entities is slow.

**Solutions**:
- Use **Shape Mode = Low Detail** (bounding box only)
- Use **Painter Filtering** to dimension only relevant entities
- Avoid **High Detail** mode unless necessary
- Reduce Tool Set to only essential tool types

**Benchmark**: Low Detail mode can be 10x faster than High Detail on complex assemblies.

### 2. Matching Existing Dimensions

**Scenario**: A drawing already has Dimline instances with specific styling. You want new dimensions to match.

**Workflow**:
1. Start inserting new Dimline
2. Press **`M`** (Match Visuals) during insertion
3. Click on an existing Dimline instance
4. New Dimline copies: DimStyle, Text Height, Scale Factor, Format

**Saves Time**: No need to manually configure each property.

### 3. Tool Dimensioning for Manufacturing

**Scenario**: CNC shop drawing needs to dimension drill hole centers.

**Workflow**:
1. Insert Dimline on the beam/panel
2. Right-click → **"Define Tool Sets"**
3. Check only: Drill types (perpendicular, rotated, tilted, 5-Axis)
4. Dimensions now show drill locations
5. Use **Format** property to add prefix: `@(Length:RL0) DRILL`

**Related**: Set Shape Mode = Medium or High Detail to process tool geometry.

### 4. Custom Dimension Text Formats

**Examples**:

| Requirement | Format String | Result |
|-------------|---------------|--------|
| Metric with "mm" | `@(Length:RL0)mm` | `2400mm` |
| Meters with 3 decimals | `@(Length:CU;m:RL3)m` | `2.400m` |
| Area in m² | `@(Area:CU;m:RL2)m²` | `5.76m²` |
| Oversail notation | `Oversail <>` | `Oversail 15` |
| Undersail notation | `Undersail <>` | `Undersail -10` |

**Advanced**: Combine static text with variables:
```
STUD @ <> O.C.
```
Result: `STUD @ 400 O.C.` (for 400mm spacing)

### 5. Multipage Workflow

**Scenario**: Shop drawing with 10 views. Each view needs aligned dimensions.

**Workflow**:
1. Insert Dimline on MultiPage entity (or in block space for each view)
2. Create dimension lines for each view
3. Right-click any Dimline → **"Align Dimlines"**
4. All dimensions align consistently
5. Before final output: Right-click → **"Purge Dimlines"** to remove duplicates

**Auto-Regeneration**: When shop drawing regenerates, Dimline instances auto-replicate via `_bOnGenerateShopDrawing` event.

### 6. Viewport Dimensions (Paper Space)

**Tip**: Dimension points outside the viewport boundary are automatically filtered (Version 10.2+).

**Workflow**:
1. Insert Dimline in Paper Space
2. Select hsbCAD viewport
3. Dimline automatically clips dimension points to viewport extents
4. No manual cleanup needed

**Setup Graphics**: Pick point outside viewport to place non-plottable reference geometry (T-Layer).

### 7. Diagonal Dimensions for Rafters

**Scenario**: Dimension true length of a hip rafter along its slope.

**Workflow**:
1. Insert Dimline
2. Select the rafter beam
3. Press **`D`** (Diagonal mode)
4. Click on the rafter's diagonal edge
5. Dimline aligns along the slope
6. Place dimension parallel to rafter

**Automatic Restrictions**: Diagonal mode restricts Shape Mode to Low/Medium Detail and disables certain Reference Point Modes.

### 8. Opening Dimensions

**Scenario**: Dimension door/window rough openings in a wall.

**Workflow**:
1. Insert Dimline
2. Select the wall element (which contains openings)
3. Set **Dimension** painter = `Dimension\Element\Openings`
4. Dimline dimensions only the openings, ignoring studs

**Advanced**: Use **Dimension Point Mode** to control whether to dimension opening edges, centers, or extremes.

### 9. Reference Point Strategies

**Scenario**: Wall framing dimensions should reference the left end plate.

**Workflow**:
1. Insert Dimline and select all wall beams
2. Set **Reference** painter = `Dimension\Element\Plates` (custom painter filtering plates)
3. Set **Reference Point Mode** = `First Point`
4. Dimension zero point aligns to first point of the plate

**Result**: All dimensions are relative to the plate start, consistent with construction drawings.

### 10. Drag Grip Points for Fine-Tuning

**After Placement**:
- Drag `_Pt0` grip: Repositions entire dimension line
- Drag `_PtG0`, `_PtG1`, etc.: Fine-tune individual dimension segments
- Drag `_Grip` (if visible): Special grip for advanced control

**Use Case**: Quickly adjust dimension line position without re-inserting.

---

## Troubleshooting

### Problem: Dimensions Not Appearing

**Possible Causes**:
1. **No valid entities selected**
   - **Solution**: Verify entities exist and are valid (not erased or frozen)
2. **Painter filter excludes all entities**
   - **Solution**: Set Dimension painter to `<Default>` or check painter criteria
3. **Viewport not linked to Element** (Paper Space)
   - **Solution**: Ensure viewport is an hsbCAD viewport linked to a valid Element
4. **Shape Mode = Low Detail on complex geometry**
   - **Solution**: Try Medium or High Detail to capture more points

### Problem: Wrong Dimension Points

**Possible Causes**:
1. **Shape Mode too low**
   - **Solution**: Increase Shape Mode to Medium or High Detail
2. **Tool Set filtering wrong tools**
   - **Solution**: Check "Define Tool Sets" – ensure correct tool types are selected
3. **Dimension Point Mode filtering points**
   - **Solution**: Set Dimension Point Mode to `<Default>` or appropriate mode

### Problem: Performance Issues (Slow Recalculation)

**Possible Causes**:
1. **Shape Mode = High Detail on large assembly**
   - **Solution**: Switch to Low Detail or Medium Detail
2. **Too many entities in selection**
   - **Solution**: Use Painter filtering to reduce entity count
3. **Complex viewport with many visible entities**
   - **Solution**: Freeze unnecessary layers in viewport before dimensioning

**Benchmark**: If recalculation takes >2 seconds, reduce detail level or entity count.

### Problem: Dimension Style Not Available

**Possible Causes**:
1. **DimStyle is angular/radial/diameter** (not linear)
   - **Solution**: Dimline only shows linear dimension styles. Create a linear DimStyle.
2. **DimStyle doesn't exist in drawing**
   - **Solution**: Dimline auto-falls back to first available linear DimStyle. Import required DimStyle.

### Problem: Scale Factor Has No Effect

**Possible Causes**:
1. **Scale Factor = 0 or negative**
   - **Solution**: Scale Factor must be > 0. Set to 1.0 for no scaling.
2. **Format string overrides dimension text**
   - **Solution**: Check Format property – ensure `<>` placeholder is present

### Problem: Offset Dimension Mode Not Available

**Possible Causes**:
1. **Not in Paper Space**
   - **Solution**: Offset Dimension mode only available in Paper Space with hsbCAD viewports
2. **Viewport not hsbCAD type**
   - **Solution**: Ensure viewport is created by hsbCAD (linked to Element)

### Problem: TSL Dimension Requests Not Appearing

**Possible Causes**:
1. **TSL / Stereotype property empty**
   - **Solution**: Use "Define Parent Tool Filter" to add TSL name
2. **TSL doesn't publish dimension requests**
   - **Solution**: Verify TSL script sets `_Map["DimRequest[]"]` with coordinate data
3. **Wildcard `*` not accepted**
   - **Solution**: Version 10.6+ fixed wildcard handling. Update to latest version.

---

## Version History

### Version 10.6 (October 2025)
- **HSB-24316**: Bugfix accepting default stereotype wildcard `*`

### Version 10.5 (June 2025)
- **HSB-24186**: Block space detection improved

### Version 10.4 (June 2025)
- **HSB-24114**: Performance improved working with metalpart painters
- Preview enhanced with visual feedback
- New options to match visuals on insert (keyboard shortcut `M`)

### Version 10.3 (June 2025)
- **HSB-24123**: Page transformation bugfix

### Version 10.2 (June 2025)
- **HSB-24080**: Viewport: Dimension points outside viewport are automatically ignored

### Version 10.1 (June 2025)
- **HSB-24123**: Custom grid can be dimensioned within Paper Space (requires custom setting)

### Version 10.0 (June 2025)
- **HSB-23985**: Bugfix for base point on insert and door/window combination

### Version 9.9 (April 2025)
- **HSB-23736**: Point selection during insert supports ortho mode (`F8`)

### Version 9.8 (April 2025)
- **HSB-23737**: Bugfix for extension line not showing

### Version 9.7 - 9.5 (February 2025)
- **HSB-23539**: Opening and element dimensioning in Model Space enhanced
- Opening support added for Model Space dimensions
- Catching hidden element geometry

### Version 9.4 (February 2025)
- **HSB-23457**: Accepting `Node[]` and `ProfShape` dimension requests from TSLs

### Version 9.3 (January 2025)
- **HSB-23162**: Z-Elevation in block space and model fixed

### Version 9.2 (January 2025)
- **HSB-23162**: Collection of TSL-driven dimension requests prepared

### Version 9.1 (January 2025)
- **HSB-22867**: Offset dimensions made independent from base point location

### Version 9.0 (January 2025)
- **HSB-21565**: Individual coloring support when DimStyle is set to ByBlock
- New context command to realign dimlines, supporting MultipageController

### Version 8.9 - 8.5 (Late 2024)
- Enhanced MultiPage support
- Improved handling of assembled items with metalpart painters
- XRef support for metalparts and polylines in sections
- Openings considered when merging multiple profiles

### Version 8.4 (October 2024)
- **HSB-22817**: Format supports over-/undersail definition for offset dimensions (e.g., `Oversail <>`)

### Version 8.3 (July 2024)
- **HSB-21731**: New "Offset Dimension" mode available in Paper Space viewports

### Version 8.2 - 8.0 (Mid-2024)
- Support for static drills and beamcuts
- Bugfixes for viewport storage in shop drawings

### Version 7.9 - 7.0 (Late 2023 - Early 2024)
- Metalpart painter filtering improved
- Curved beam support enhanced
- Rabbets and Dados added as tools
- Global settings for group assignment behavior
- **Version 7.0**: All collection entity types supported (TrussEntity, MetalPartCollectionEntity, CollectionEntity)

### Version 6.9 - 6.0 (September - December 2023)
- **Version 6.0**: **Requires hsbDesign 26 or higher**
- Multiple block reference support
- Metalpart entities with marker line resolution
- Stereotype requests from block references and metalpart entities
- Gable dimensions with tolerance support
- Performance improvements for Paper Space viewports
- Paper Space setup graphics drawn on non-plottable T-Layer

### Version 5.2 - 4.0 (2023)
- New painter filtering options
- Model support for GenBeams enhanced
- Shape modes renamed (Envelope/Real/Basic → Low/High/Medium Detail)
- Classic dimension mode added
- Diagonal dimension mode introduced (**Version 4.0**)
- Element viewports support multiple aligned dimlines (gable walls)
- Opening support added (**Version 4.7**)
- Scale Factor property introduced (**Version 4.2**)

### Version 3.9 - 3.0 (Early 2023)
- Purge redundant dimlines associated with MultiPage
- Segmented contours reconstruct into arc segments
- TSL dimension requests support (element-based TSLs)
- hsbDesign 25 compatibility (**Version 3.5**)
- Tool options enhanced (copy dimline, drill dimensions)

### Version 2.9 - 2.0 (Late 2022)
- Shadow contour of collection entities improved
- Section support added
- Supports element viewports
- Envelope shape mode uses outer contour with filters

### Version 1.9 - 1.0 (2021-2022)
- **Version 1.0**: Initial release (August 2021)
- Basic functionality: Model Space and Paper Space dimensioning
- GenBeam, Sheet, Panel, Polyline support
- Painter definition filtering
- Tool support: Cut, Slot, Beamcut (beta)
- Metalpart collection support (beta)

---

## Related Scripts

### Dimensioning and Layout
- **`hsbLayoutDim`** – Layout dimension tool for shop drawings
- **`hsbViewDimension`** – View-specific dimensioning
- **`hsbViewCoordinateDimension`** – Coordinate dimensioning
- **`DimRadial`** – Radial dimension tool
- **`DimAngular`** – Angular dimension tool
- **`hsbTslDim`** – Legacy TSL dimension tool

### Shop Drawing
- **`MultipageController`** – Multi-page shop drawing controller (parent of Dimline in shop drawing workflows)
- **`MultipageAnchor`** – Anchor point for multipage layouts
- **`_hsbReport`** – Shop drawing report generator

### Element Tools
- **`hsb_CreateElement`** – Create wall/floor/roof elements
- **`HSB_E-Identification & Marking`** – Element identification
- **`hsbLayoutTag`** – Layout tag tool (similar context menu to Dimline)
- **`hsbViewTag`** – View tag tool

### Painter Management
- **`PainterDefinition`** (system class) – Entity filtering system used by Dimline

### Related Properties
Scripts that publish dimension requests to Dimline:
- **`hsbCLT-Drill`** – CLT drill patterns
- **`hsbCLT-Opening`** – CLT opening details
- **Fastener scripts** (Simpson, Hilti, Rothoblaas, etc.)
- **Custom TSL scripts** using `_Map["DimRequest[]"]` protocol

---

## Technical Details

### Script Metadata
- **Type**: `O` (Object Tool)
- **Version**: 10.6 (Major: 10, Minor: 6)
- **Author**: Thorsten Huck (hsbcad development team)
- **Beams Required**: 0 (no beam selection required)
- **Grip Points**: Variable (depends on mode)
- **File State**: 1 (production-ready)

### Script Classification
- **Category**: Workflow > Layout
- **Usage Context**: Model Space, Paper Space, Shop Drawing (Block Space)
- **Parametric Behavior**: Full – dimensions automatically recalculate when linked entities change

### Dependencies
- **hsbDesign**: Version 26 or higher (mandatory from Version 6.0+)
- **AutoCAD**: Linear DimStyles required
- **Dialog Service**: `TslUtilities.dll` (for UI dialogs)

### Map Communication Protocol

Dimline uses hsbCAD's `Map` system to exchange data:

**Stored in `_Map`**:
- `"vecDir"` (Vector3d) – Dimension direction
- `"deltaOnTop"` (int) – Delta/chain swap flag
- `"CustomPoint[]"` (Map) – User-added manual dimension points
- `"DimRequest[]"` (Map) – TSL dimension requests
- `"UID"` (String) – Unique instance identifier
- `"color"` (int) – Color for ByBlock DimStyles

**Read from TSL Dimension Requests**:
- `_Map["DimRequest[]"]` – Array of dimension requests
- Each request contains:
  - `"ptCoord[]"` (Point3d[]) – Dimension point coordinates
  - `"AllowedView"` (Vector3d) – View direction constraint
  - `"AlsoReverseDirection"` (int) – Bidirectional flag
  - `"vecDimLineDir"` (Vector3d) – Preferred dimension direction
  - `"AllowCrossMark"` (int) – Show cross marks for this point

---

## Summary

**Dimline** is the most comprehensive dimensioning tool in hsbCAD, supporting:
- **All entity types**: Beams, Elements, Openings, Sheets, Panels, Trusses, MetalParts, Block references
- **All workspaces**: Model Space, Paper Space, Shop Drawings
- **All dimension modes**: Chain, Delta, Diagonal, Gable, Offset
- **Advanced filtering**: Painter Definitions, Tool Sets, TSL requests
- **Parametric behavior**: Automatic recalculation on entity changes

**Primary Use Cases**:
1. **Production Drawings**: Dimension wall/floor/roof assemblies for framing
2. **Shop Drawings**: Dimension fabrication details with tool locations
3. **Quality Control**: Offset dimensions to verify as-built vs. design
4. **Multi-View Layouts**: Consistent dimensioning across MultiPage shop drawings

**Key Advantage**: Unlike standard AutoCAD dimensions, Dimline is entity-aware and parametric, automatically updating when timber members move or assemblies change.

---

**For more information, consult the hsbCAD documentation or contact hsbcad support.**
