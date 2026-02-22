# hsbViewHatching.mcr - Automated Section Hatching System

## Overview

**hsbViewHatching** is a sophisticated visualization script that automatically generates hatch patterns for cross-sections of timber construction entities in 2D views. This script transforms technical sectional drawings into visually rich documentation by applying material-specific or rule-based hatching to beams, panels, sheets, and other structural components.

### Primary Purpose

- **Architectural Documentation**: Add professional hatching to building sections, details, and elevations
- **Shop Drawings**: Enhance fabrication drawings with clear material representation
- **Multi-View Coordination**: Apply consistent hatching across multiple viewports simultaneously
- **Material Visualization**: Differentiate materials visually through pattern, color, and transparency

### Key Capabilities

| Feature | Description |
|---------|-------------|
| **Multi-Environment** | Works in Model Space (sections), Paper Space (layout viewports), and Block Space (shop drawings) |
| **Dual Mapping Modes** | Map hatches by material properties OR by painter filter rules |
| **Anisotropic Patterns** | Different patterns for X/Y/Z orientations (wood grain direction) |
| **Dynamic Scaling** | Patterns auto-adjust to plot scale for consistent appearance |
| **Interactive Editing** | Visual jigging interface for modifying hatch properties |
| **Special Patterns** | Built-in insulation wave pattern with auto-scaling |
| **9 Entity Types** | Supports beams, sheets, SIPs, panels, TSL instances, volumes, fasteners, blocks, xRefs |

### Version Information

- **Script Type**: O (Object TSL - parametric instance)
- **Current Version**: 2.90 (June 18, 2025)
- **First Release**: 1.0 (May 29, 2019)
- **Minimum Required**: hsbCAD 23.0.47 or higher
- **Beam Requirement**: 0 (operates independently)

### What Makes This Script Unique

Unlike manual AutoCAD hatching, hsbViewHatching:

1. **Automatically detects** material orientations and applies appropriate patterns
2. **Maintains parametric links** - hatching updates when entities move or modify
3. **Manages multiple viewports** from a single instance
4. **Handles transparency stacking** for overlapping materials
5. **Provides project-wide standards** through XML configuration
6. **Includes interactive modification** without recreating hatches

---

## Core Concepts

### Mapping Modes: Material vs Painter

The script offers two fundamentally different approaches to assigning hatch patterns to entities:

#### Mode 1: By Material (Direct Mapping)

Hatches are assigned based on the **material property** of each entity.

**How It Works:**
1. Script reads the material name from each entity (e.g., "SPF 2x6", "OSB 7/16", "Gypsum 5/8")
2. Searches XML hatch definitions for a matching material name
3. If found, applies that hatch definition
4. If not found, entity remains unhatchched

**XML Configuration:**
```xml
<Hatch>
  <str nm="Name" vl="Spruce-Pine-Fir"/>
  <str nm="Material" vl="SPF 2x6, SPF 2x4, Spruce"/>  <!-- Comma-separated list -->
  <str nm="Active" vl="Yes"/>
  <!-- Pattern definitions follow -->
</Hatch>
```

**Best For:**
- Multi-material assemblies (walls with different stud/sheathing/finish materials)
- Material-specific rendering requirements
- Direct, predictable material→pattern mapping
- Projects with standardized material naming

**Limitations:**
- Requires exact material name matching
- Less flexible for visual grouping
- New materials require XML updates

---

#### Mode 2: By Painter (Rule-Based Mapping)

Hatches are assigned based on **painter filter criteria** - entities passing the same filter get the same hatch.

**How It Works:**
1. Select a painter definition from the dropdown (e.g., "hsbViewHatching_StructuralFraming")
2. Script evaluates each entity against the painter filter rules
3. All entities passing the filter receive the same hatch pattern
4. Pattern name matches the painter name

**Painter Definition Example:**
- Filter: Type = GenBeam AND Layer = "Framing"
- Result: All beams on the Framing layer get identical hatching regardless of material

**Best For:**
- Visual grouping by structural role rather than material
- Simplifying complex assemblies
- Uniform appearance for entity collections
- Flexible rule-based assignment

**Limitations:**
- Requires painter definitions to be set up
- Less material-specific detail
- Can be confusing if filter logic is unclear

---

#### Comparison Table

| Aspect | by Material | by Painter |
|--------|-------------|------------|
| **Basis** | Entity material property | Filter criteria (type, layer, properties) |
| **Granularity** | Fine (different patterns per material) | Coarse (same pattern for groups) |
| **Configuration** | XML hatch definitions | Painter definitions + hatch name matching |
| **Flexibility** | Rigid, predictable | Highly flexible, rule-based |
| **Typical Use** | Material-specific rendering | Visual grouping by role |
| **Setup Effort** | Medium (XML editing) | Higher (painter + hatch setup) |
| **Best For** | Fabrication docs, material callouts | Architectural sections, concept drawings |

---

### Anisotropy: Directional Hatching

Many building materials have directional properties - most notably **wood grain**. Anisotropy allows different hatch patterns for each material axis orientation.

#### When Anisotropy = No (Isotropic)

The same hatch pattern is used regardless of how the material is oriented in the section cut.

**Example:** Concrete, gypsum, insulation - materials with no grain direction

#### When Anisotropy = Yes (Anisotropic)

Different patterns for X, Y, and Z orientations of the material's local coordinate system.

**Example: Timber Beam**

```
Section Cut Through:          Pattern Applied:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Beam End (X-axis normal)  →   X-Orientation (end grain dots)
Beam Side (Y-axis normal) →   Y-Orientation (grain lines)
Beam Top (Z-axis normal)  →   Z-Orientation (grain lines)
```

**How Orientation is Detected:**

1. Script calculates the section plane's normal vector
2. Compares normal to entity's local X, Y, Z axes
3. Determines which axis is most aligned with the section normal
4. Applies the corresponding orientation's hatch definition

**Beam Grain Alignment (v2.31):**
For beams, Y and Z orientation hatching is automatically aligned with the beam's X direction (length) to maintain consistent grain representation.

**Configuration Example:**

```xml
<str nm="Anisotropy" vl="Yes"/>
<Orientation[] nm="Orientation[]">
  <Orientation nm="Orientation">
    <str nm="Orientation" vl="X"/>
    <str nm="Pattern" vl="DOTS"/>      <!-- End grain -->
    <!-- X-specific settings -->
  </Orientation>
  <Orientation nm="Orientation">
    <str nm="Orientation" vl="Y"/>
    <str nm="Pattern" vl="ANSI31"/>    <!-- Side grain -->
    <dbl nm="Angle" ut="" vl="0"/>
  </Orientation>
  <Orientation nm="Orientation">
    <str nm="Orientation" vl="Z"/>
    <str nm="Pattern" vl="ANSI31"/>    <!-- Top grain -->
    <dbl nm="Angle" ut="" vl="90"/>
  </Orientation>
</Orientation[]>
```

---

### Section Level and Depth

These parameters control the **hatching zone** - which entities get hatched based on their position relative to the section plane.

#### Conceptual Model

```
                    Section Plane
                         ↓
    ════════════════════════════════════
         ↑
    Section Level (top boundary)
         ↓
    ┌─────────────────────────────────┐
    │                                 │
    │   HATCHING ZONE                 │  ← Only entities in this
    │   (Depth dimension)             │     zone are hatched
    │                                 │
    └─────────────────────────────────┘
         ↑
    Section Level - Section Depth (bottom boundary)
```

#### Section Level (dSectionLevel)

- **Type**: Length (distance)
- **Default**: 0 (at section plane)
- **Meaning**: Top boundary of the hatching zone, measured perpendicular to the section plane
- **Positive values**: Zone extends into the "front" side of the section
- **Negative values**: Zone extends into the "back" side of the section

#### Section Depth (dSectionDepth)

- **Type**: Length (distance)
- **Default**: 0 (infinite depth)
- **Meaning**: Thickness of the hatching zone

**Special Behavior:**
- **If Depth = 0**: Infinite depth mode - ALL visible entities are hatched regardless of position
- **If Depth > 0**: Finite zone mode - only entities within [Level, Level-Depth] range are hatched

#### Practical Examples

**Example 1: Wall Elevation (Vertical Section)**
```
Goal: Hatch only the wall being cut, not background elements

Settings:
- Section Level: 0 mm (at section plane)
- Section Depth: 200 mm (typical wall thickness)

Result: Only entities within 200mm of the section plane are hatched
```

**Example 2: Floor Plan (Horizontal Section)**
```
Goal: Hatch wall studs at 1200mm above floor

Settings:
- Section Level: 1200 mm (standard plan cut height)
- Section Depth: 100 mm (to capture 89mm studs)

Result: Studs are hatched, floor/ceiling elements are not
```

**Example 3: Show Everything (Perspective Section)**
```
Goal: Hatch all visible geometry regardless of depth

Settings:
- Section Level: 0 mm
- Section Depth: 0 mm (infinite mode)

Result: All visible entities receive hatching
```

#### Grip Point Control (Section2d Only)

When attached to Section2d entities in Model Space, two interactive grip points appear:

- **Green/Cyan Grip**: Controls Section Level (drag to move top boundary)
- **Red/Yellow Grip**: Controls Section Depth (drag to adjust zone thickness)

Grip points move perpendicular to the section plane. Values update in real-time in the Properties Palette.

**Note:** Grip points are NOT available for Layout viewports or Shop Drawing views - use Properties Palette instead.

---

### XML Configuration System

Hatch definitions are stored in XML files, providing project-wide standardization.

#### File Locations (Priority Order)

1. **Company Path**: `[hsbCAD Company Path]\TSL\Settings\hsbViewHatching.xml`
2. **Installation Path**: `[hsbCAD Install Path]\Content\General\TSL\Settings\hsbViewHatching.xml`

The script first checks the Company path. If not found, falls back to Installation path.

#### MapObject Caching

For performance, XML settings are loaded into an AutoCAD dictionary MapObject on first use:

- **Dictionary**: "hsbTSL"
- **Key**: "hsbViewHatching"

This avoids re-parsing XML on every calculation. Settings persist per-drawing.

#### Version Migration (v2.37+)

When the XML version doesn't match the MapObject version:

1. Script loads installation XML (default settings)
2. Merges with company XML (customizations)
3. Missing parameters filled with installation defaults
4. User prompted to Export Settings to update company XML
5. MapObject updated with merged settings

This ensures backward compatibility when new parameters are added.

#### XML Structure Overview

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map nm="root">
  <int nm="Version" vl="3"/>
  <GeneralMapObject nm="GeneralMapObject">
    <int nm="GroupAssignment" vl="0"/>
  </GeneralMapObject>
  <Hatch[] nm="Hatch[]">
    <Hatch nm="Hatch">
      <str nm="Name" vl="Spruce-Pine-Fir"/>
      <str nm="Active" vl="Yes"/>
      <str nm="Anisotropy" vl="Yes"/>
      <str nm="Material" vl="SPF 2x6, SPF 2x4"/>
      <str nm="Contour" vl="Yes"/>
      <int nm="ContourColor" vl="-2"/>
      <dbl nm="ContourThickness" ut="L" vl="0"/>
      <str nm="SupressBeamCross" vl="No"/>
      <str nm="SolidHatch" vl="No"/>
      <int nm="SolidTransparency" vl="0"/>
      <int nm="SolidColor" vl="-2"/>
      <Orientation[] nm="Orientation[]">
        <Orientation nm="Orientation">
          <str nm="Orientation" vl="X"/>
          <str nm="Pattern" vl="DOTS"/>
          <int nm="Color" vl="-2"/>
          <int nm="Transparency" vl="0"/>
          <dbl nm="Angle" ut="" vl="0"/>
          <dbl nm="Scale" ut="" vl="1"/>
          <dbl nm="ScaleMin" ut="" vl="0.1"/>
          <str nm="Static" vl="by Hatch Pattern"/>
        </Orientation>
        <!-- Y and Z orientations follow -->
      </Orientation[]>
    </Hatch>
    <!-- Additional hatches -->
  </Hatch[]>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

---

## Supported Environments

hsbViewHatching operates in three distinct CAD environments, each with specific workflows and behaviors.

### Environment 1: Model Space (Section2d / MultiPage)

**Target Entities**: Section2d, MultiPage view entities in Model Space

**Typical Use Case**: Architectural sections, building details, assembly views

#### Insertion Workflow

1. Create a Section2d or MultiPage view in Model Space
2. Run `TSLINSERT` → select `hsbViewHatching`
3. Command prompts: **"Select Section2d or MultiPage"**
4. Click on the section entity
5. Script automatically creates **two TSL instances** (v2.86):
   - **Main Hatching TSL**: Generates hatch graphics
   - **Level/Depth Control TSL**: Provides grip point controls

#### Dual Instance System (Important)

Starting with version 2.86, the script creates two separate but linked instances:

**Why the Split?**
- Allows independent assignment to groups/layers
- Hatching TSL can be on plotable layer
- Level/Depth control TSL can be on non-plotable T-layer
- Grip points remain accessible without cluttering plotted output

**Dependency Management:**
- Both instances track each other via `_Map` storage
- Deleting one automatically cleans up the other
- `setDependencyOnEntity()` ensures regeneration coordination

#### Grip Point Controls

Two interactive grip points appear on the section:

| Grip Color | Function | Adjusts |
|------------|----------|---------|
| Green/Cyan | Top boundary control | `dSectionLevel` parameter |
| Red/Yellow | Zone thickness control | `dSectionDepth` parameter |

**Behavior:**
- Drag grips perpendicular to section plane
- Properties Palette updates in real-time
- Hatching regenerates automatically
- Grip positions stored in `_PtG[0]` and `_PtG[1]`

#### Special Features

- **Active Zone Integration**: For Element viewports, use context menu → "Set Level and Depth to Active Zone" to auto-calculate boundaries
- **xRef Support**: Enable "Allow Entities in xRef" to include entities from external references
- **Horizontal Sections**: Improved handling for plan cut views (v2.54)

---

### Environment 2: Paper Space (Layout Viewports)

**Target Entities**: Layout viewports (standard AutoCAD or ACA Element viewports)

**Typical Use Case**: Sheet layouts, multi-view documentation, construction drawing sets

#### Insertion Workflow

1. Switch to a Layout tab with viewports
2. Run `TSLINSERT` → select `hsbViewHatching`
3. Command prompts: **"Select a viewport"**
4. Click on a viewport border
5. Command prompts: **"Pick insertion point"**
6. Click to place the TSL instance in Paper Space

**Important:** The insertion point is in Paper Space, but hatching analyzes Model Space entities visible through the viewport.

#### Multi-Viewport Management

**Add Additional Viewports:**
1. Right-click TSL instance
2. Select **"Add Viewport"**
3. Click additional viewport(s)
4. Single TSL instance now controls hatching for all selected viewports

**Why Use Multi-Viewport?**
- Consistent hatching settings across multiple views
- Single point of control for adjustments
- Easier to maintain project standards
- Reduces instance count in drawing

#### Viewport Types

**Standard Viewports:**
- User manually selects entities via "Add Entity(s)" menu
- Hatching applies only to explicitly added entities
- More control, but requires manual setup

**Element Viewports:**
- Automatically includes all entities in the Element's showset
- "Allow Entities in xRef" property controls xRef inclusion
- Active Zone support for automatic Level/Depth calculation

#### Entity Selection (Non-Element Viewports)

**Add Entity(s):**
1. Right-click TSL → "Add Entity(s)"
2. Script switches to Model Space
3. Select entities to include in hatching
4. Return to Layout - hatching updates

**Remove Entity(s):**
1. Right-click TSL → "Remove Entity(s)"
2. Script switches to Model Space
3. Select entities to exclude from hatching
4. Return to Layout - hatching updates

#### Coordinate Transformation

The script handles complex transformations:

- **Model Space → Paper Space (ms2ps)**: Entity geometry transformed to viewport coordinates
- **Paper Space → Model Space (ps2ms)**: Click points transformed for entity selection
- **Viewport Scale/Rotation**: Automatically accounted for in hatch calculation

#### No Grip Points

Unlike Section2d mode, Layout viewports do NOT display grip points. Adjust Section Level and Depth via Properties Palette only.

---

### Environment 3: Block Space (Shop Drawing Viewports)

**Target Entities**: ShopDrawView entities in Multipage shop drawing systems

**Typical Use Case**: Fabrication drawings, batch shop drawing generation, automated documentation

#### Insertion Workflow

**Option A: Direct Insertion (Existing Shop Drawing)**
1. Open a shop drawing with ShopDrawView entities
2. Run `TSLINSERT` → select `hsbViewHatching`
3. Command prompts: **"Select ShopDrawView"**
4. Click on the shop drawing view entity
5. Command prompts: **"Pick insertion point"**
6. Click to place within the block space

**Option B: Block Definition (Template Setup)**
1. Edit the shop drawing block definition
2. Insert hsbViewHatching into the block definition
3. Configure default settings
4. All future shop drawings using this block will have hatching

#### Shop Drawing Generation Mode

When shop drawings regenerate (`_bOnGenerateShopDrawing`), the script:

1. Detects it's in shop drawing generation context
2. Accesses ViewData from the entity collector
3. Finds the correct viewport using UID tracking
4. Creates a **Model Space instance** automatically
5. Flags the entity collector to prevent duplicate creation
6. Transforms coordinates from block space to model space

**Why Model Space Instance?**
- Shop drawing blocks are temporary/volatile
- Model Space instance persists and drives the block space graphics
- Allows parametric updates when entities change
- Maintains dependency tracking

#### UID Tracking System

```
Block Space Instance → stores UID in _Map
   ↓
On shop drawing generation → checks entity collector for UID flag
   ↓
If not flagged → create Model Space instance
   ↓
Flag UID in mapTslCreatedFlags
   ↓
Future regenerations → skip creation (already exists)
```

This prevents creating duplicate instances on every regeneration.

#### ViewData Integration

The script uses hsbCAD's ViewData system:

- **ViewData**: Contains viewport definition, showset, view direction
- **findDataForViewport()**: Locates the specific viewport's data
- **showSetDefineEntities()**: Gets entities visible in this view
- **View direction transformation**: Aligns hatching with viewport orientation

#### Entity Collector Dependency

```
setDependencyOnEntity(entCollector);
```

The TSL instance depends on the entity collector, ensuring:
- Hatching regenerates when shop drawing updates
- Deletion cleanup happens correctly
- ViewData changes trigger recalculation

---

### Environment Comparison Table

| Aspect | Model Space | Paper Space | Block Space |
|--------|-------------|-------------|-------------|
| **Target Entity** | Section2d, MultiPage | Viewport | ShopDrawView |
| **Insertion Point** | Not required | Paper Space point | Block Space point |
| **Grip Points** | Yes (2 grips) | No | No |
| **Multi-Instance** | No (dual TSL system) | Yes (multi-viewport) | Auto Model Space |
| **Entity Selection** | Automatic from view | Manual or Element | Automatic from ViewData |
| **Typical Use** | Architectural sections | Sheet layouts | Fab drawings |
| **Complexity** | Medium | High | Very High |
| **Setup Effort** | Low | Medium | Low (if template) |

---

## Properties Reference

### Section Control Category

These properties define the hatching zone geometry.

#### Section Level

- **Property Name**: `dSectionLevel`
- **Type**: PropDouble (Length)
- **Default**: 0 mm
- **Range**: Any real number (negative allowed)
- **Unit**: Drawing units (mm or inches based on template)

**Description:**
Defines the **top boundary** of the hatching zone, measured perpendicular to the section plane. This is the reference point from which Section Depth is measured.

**Interpretation:**
- **0**: Zone starts at the section plane itself
- **Positive**: Zone starts in front of the section plane (toward viewer)
- **Negative**: Zone starts behind the section plane (away from viewer)

**Visual Control:**
- In Section2d mode: Green/Cyan grip point
- In other modes: Properties Palette only

**Common Values:**
- **Wall Elevations**: 0 (at cut plane)
- **Floor Plans**: 1200 mm (standard plan cut height above floor)
- **Roof Plans**: Variable based on roof height

---

#### Section Depth

- **Property Name**: `dSectionDepth`
- **Type**: PropDouble (Length)
- **Default**: 0 mm (infinite)
- **Range**: 0 or positive (negative automatically converted to 0)
- **Unit**: Drawing units

**Description:**
Defines the **thickness** of the hatching zone. Combined with Section Level, this creates a bounded region for entity filtering.

**Special Behavior:**
- **0**: **Infinite depth mode** - ALL visible entities are hatched regardless of position
- **> 0**: **Finite zone mode** - only entities intersecting [Level, Level-Depth] are hatched

**Zone Calculation:**
```
Top Boundary: dSectionLevel
Bottom Boundary: dSectionLevel - dSectionDepth

If dSectionDepth == 0:
  Bottom Boundary = -∞ (no limit)
```

**Visual Control:**
- In Section2d mode: Red/Yellow grip point
- In other modes: Properties Palette only

**Common Values:**
- **Thin Cuts (plan views)**: 100-200 mm
- **Wall Thickness**: 150-300 mm typical
- **Show All**: 0 mm (infinite)
- **Deep Sections**: 500-1000 mm

**Automatic Calculation:**
For Element viewports with Active Zones:
1. Right-click TSL → "Set Level and Depth to Active Zone"
2. Script calculates zone boundaries from active zone geometry
3. Level and Depth set automatically

---

### Global Factors Category

These properties apply multiplicative scaling to all hatch patterns uniformly.

#### Scaling

- **Property Name**: `dGlobalScaling`
- **Type**: PropDouble (Unitless)
- **Default**: 1.0
- **Range**: 0.01 to 100 (practical range)

**Description:**
Global multiplication factor applied to **all hatch pattern scales** in the drawing. This allows you to make all patterns larger or smaller proportionally without editing individual hatch definitions.

**Calculation:**
```
Final Pattern Scale = (Hatch Definition Scale) × (Global Scaling Factor)
```

**Use Cases:**
- **Plot Scale Adjustment**: If switching from 1:50 to 1:100 drawings, set Global Scaling = 2.0 to maintain visual pattern size
- **Presentation Drawings**: Reduce to 0.5 for finer patterns in large-scale details
- **Quick Tweaking**: Test different overall pattern densities without XML changes

**Tips:**
- Start with 1.0 and adjust incrementally (±0.25)
- Consider using Dynamic Scaling Mode instead for auto-adjustment
- Global Scaling multiplies with individual pattern Scale and ScaleMin

---

#### Transparency

- **Property Name**: `dGlobalTransparency`
- **Type**: PropDouble (Unitless)
- **Default**: 1.0
- **Range**: 0.0 to 1.0+ (values > 1.0 make patterns more opaque)

**Description:**
Global multiplication factor applied to **all transparency values**. Allows quick adjustment of overall hatching visibility without editing individual hatch definitions.

**Calculation:**
```
Final Transparency = (Hatch Definition Transparency) × (Global Transparency) × (Stacking Formula)
```

**Transparency Scale:**
- **0.0**: All hatches become fully opaque (100% solid)
- **1.0**: Normal transparency (uses hatch definition values)
- **>1.0**: Hatches become more transparent (lighter/faded)

**Stacking Formula (v2.18):**
When multiple hatches overlap (e.g., beam through panel), a special formula ensures proper visual layering. The Global Transparency factor is incorporated such that user input of 100 in the hatch definition truly results in 100% transparent when Global = 1.0.

**Use Cases:**
- **Background Hatching**: Set to 1.5-2.0 for subtle material indication
- **Highlight Mode**: Set to 0.5 to emphasize hatches
- **Layering Adjustment**: Fine-tune overlapping material visibility

**Note:** This affects **both** solid fill transparency and pattern transparency proportionally.

---

#### Hatch Mapping

- **Property Name**: `sHatchMapping`
- **Type**: PropString (Selection)
- **Index**: 2
- **Options**: ["by Material", "by Painter"]
- **Default**: "by Material"

**Description:**
Determines the **fundamental strategy** for assigning hatch patterns to entities. This is the most important configuration choice.

**"by Material" Mode:**
- Reads entity's Material property
- Searches XML for hatch definition with matching material name
- Direct, predictable material→hatch mapping
- See "Core Concepts → Mapping Modes" for detailed explanation

**"by Painter" Mode:**
- Evaluates entity against selected Painter filter
- All entities passing filter get the same hatch
- Hatch name must match painter name
- See "Core Concepts → Mapping Modes" for detailed explanation

**When to Switch:**
- Change to "by Painter" when you need visual grouping rather than material-specific rendering
- Change to "by Material" for precise material callouts in fabrication drawings

**UI Behavior:**
Changing this property **dynamically shows/hides** the Filter Properties category in the Properties Palette.

---

### Filter Properties Category

**Visibility:** Only shown when `sHatchMapping = "by Painter"`

These properties control painter-based hatching behavior.

#### Filter by Painter

- **Property Name**: `sPainterStream`
- **Type**: PropString (Selection - Dropdown)
- **Index**: 1
- **Options**: Dynamically populated from PainterDefinition()
- **Default**: "" (disabled)

**Description:**
Selects which **Painter filter** to use for entity evaluation. The dropdown lists all available painter definitions in the drawing.

**Painter Collection Filtering (v2.65):**
If any painter names start with "hsbViewHatching_", the dropdown shows ONLY those painters (collection mode). Otherwise, all painters are shown.

**Usage:**
1. Create painter definitions in hsbCAD (Painter Editor)
2. Name painters descriptively: "hsbViewHatching_StructuralFraming", "hsbViewHatching_Sheathing"
3. Select from dropdown in hsbViewHatching
4. Entities passing that painter's filter get hatched

**Hatch Name Matching:**
The selected painter name is used to find the corresponding hatch definition in XML. Example:

```
Painter Name: "hsbViewHatching_StructuralFraming"
XML Hatch Name: "hsbViewHatching_StructuralFraming"
                 ↑ Must match exactly
```

**Integration with Painter Groups (v2.74):**
If painters use group assignments, hatching respects those groups for visual filtering.

---

#### Allow Entities in xRef

- **Property Name**: `sAllowEntitiesXref`
- **Type**: PropString (Selection - Yes/No)
- **Index**: 3
- **Options**: ["No", "Yes"]
- **Default**: "No"

**Description:**
Controls whether entities in **external references (xRefs)** are included in hatching calculation.

**"No" (Default):**
- Only entities in the current drawing are hatched
- Faster performance
- Simpler dependency tracking

**"Yes" (v2.89):**
- Entities from xRef drawings are included
- Script handles coordinate transformation from xRef to host
- Useful for host drawings with xRef'd framing models

**When to Enable:**
- Host drawing contains section/viewport
- Actual framing is in xRef'd model
- You want hatching to show xRef geometry

**Performance Impact:**
- Moderate - script must traverse xRef entity tree
- Coordinate transformations add calculation time
- Consider disabling if xRefs are not needed

**Dependency Tracking:**
The script sets up proper dependency on xRef entities to ensure regeneration when xRef changes.

---

## Hatch Definition Properties (Dialog)

When using **"Modify Hatch"** or **"Add Hatch"** context menu commands, a comprehensive dialog appears. This section documents all dialog properties.

### Accessing the Dialog

**Method 1: Modify Existing Hatch**
1. Right-click TSL instance → "Modify Hatch"
2. Script enters interactive jigging mode (v2.46+)
3. Visual display shows all hatched entities and materials
4. Click on an entity or material group
5. Dialog opens with that hatch's properties

**Method 2: Add New Hatch**
1. Right-click TSL instance → "Add Hatch"
2. Select entities that need hatching but currently lack a definition
3. Dialog opens with default properties for new hatch

**Multiple Selection (v2.47):**
If multiple hatches are selected, the dialog shows:
- **Common values**: Displayed normally
- **Different values**: Shown as `*VARIES*`
- Changes apply to all selected hatches

---

### Hatch Category

#### Name

- **Type**: String
- **Default**: "" (user enters)
- **Editable**: Read-only when modifying "by Painter" mapping

**Description:**
Unique identifier for this hatch definition. Used for internal tracking and XML storage.

**Naming Conventions:**
- Descriptive of material: "Spruce-Pine-Fir", "OSB-7/16", "Gypsum-5/8"
- For painter mode: Must match painter name exactly
- No special characters recommended (use hyphens/underscores)

---

#### Active

- **Type**: Yes/No
- **Default**: Yes

**Description:**
Enable or disable this hatch definition. When set to "No", the hatch definition remains in XML but is not applied to entities.

**Use Cases:**
- Temporarily disable a hatch for testing
- Keep definitions for optional materials
- Quick toggle without deleting definition

---

#### Anisotropy

- **Type**: Yes/No
- **Default**: No

**Description:**
Controls whether different patterns are used for different material orientations. See "Core Concepts → Anisotropy" for detailed explanation.

**UI Behavior:**
- **No**: Only X-Orientation properties shown
- **Yes**: X, Y, and Z-Orientation sections all shown

---

#### Material

- **Type**: String
- **Default**: "" (user enters)
- **Format**: Comma-separated list

**Description:**
List of material names that this hatch definition applies to. Only relevant when using "by Material" mapping mode.

**Examples:**
```
Single material:    "SPF 2x6"
Multiple materials: "SPF 2x6, SPF 2x4, SPF 2x8, Spruce"
Case sensitivity:   Usually case-insensitive matching
```

**Matching Logic:**
1. Script gets entity's Material property
2. Tokenizes this field by commas
3. Checks if entity material matches any token
4. First match wins if multiple hatch definitions match same material

**Tips:**
- Include all size variants if using dimensional lumber
- Use short, consistent material names
- Avoid leading/trailing spaces (though script trims)

---

### Contour Category

#### Contour

- **Type**: Yes/No
- **Default**: No

**Description:**
Enable or disable **outline drawing** around the hatched profile.

**Use Cases:**
- Emphasize material boundaries
- Improve legibility when patterns are subtle
- Architectural convention for certain materials
- Separate overlapping materials visually

---

#### Color

- **Type**: Integer (Color Index)
- **Default**: -2 (ByEntity)
- **Range**: -2, -1, or 0-255 (AutoCAD Color Index)

**Description:**
Color for the contour outline.

**Special Values:**
- **-2**: ByEntity - use entity's color
- **-1**: ByLayer - use layer's color
- **0-255**: Specific AutoCAD Color Index

**Common Colors:**
- 1 = Red
- 2 = Yellow
- 3 = Green
- 7 = White/Black (depends on background)

---

#### Thickness

- **Type**: Length
- **Default**: 0
- **Unit**: Drawing units

**Description:**
Lineweight/thickness of the contour outline.

**Values:**
- **0**: Use default lineweight
- **> 0**: Specific thickness in drawing units
- Values typically range from 0.1 to 1.0 mm

---

#### Suppress Beam Cross

- **Type**: Yes/No
- **Default**: No

**Description:**
Hide the diagonal cross symbol typically shown on beam section cuts in hsbCAD.

**Use Cases:**
- When cross symbol interferes with hatching
- For cleaner presentation drawings
- When hatching alone is sufficient to identify beams

---

### Solid Hatch Category

The solid hatch provides a **background fill** behind the pattern, with independent color and transparency control.

#### Hatch

- **Type**: Yes/No
- **Default**: No

**Description:**
Enable solid color fill behind the hatch pattern.

**Visual Effect:**
```
No Solid Hatch:  Pattern on transparent background
Solid Hatch:     Pattern on colored background (can be semi-transparent)
```

---

#### Transparency

- **Type**: Integer (0-100)
- **Default**: 0 (opaque)

**Description:**
Transparency of the solid fill.

**Scale:**
- **0**: Fully opaque
- **50**: 50% transparent
- **100**: Fully transparent (invisible)

**Interaction with Global Transparency:**
```
Final Solid Transparency = (Solid Transparency) × (Global Transparency Factor)
```

---

#### Color

- **Type**: Integer (Color Index)
- **Default**: -2 (ByEntity)
- **Range**: -2, -1, or 0-255

**Description:**
Color of the solid fill background.

**Special Values:**
Same as Contour Color (-2 = ByEntity, -1 = ByLayer)

---

### Orientation Categories (X, Y, Z)

When **Anisotropy = Yes**, separate sections appear for X, Y, and Z orientations. Each orientation has identical property sets.

#### Orientation (Label)

- **Type**: String (Read-only)
- **Values**: "X", "Y", or "Z"

**Description:**
Label indicating which material axis this orientation represents. Not editable - for display only.

---

#### Pattern

- **Type**: Selection (Dropdown)
- **Options**: All AutoCAD hatch patterns + "Insulation"
- **Default**: "ANSI31"

**Description:**
The AutoCAD hatch pattern to use for this orientation.

**Common Patterns:**
- **ANSI31**: General purpose (45° lines)
- **ANSI32**: Steel cross-hatch
- **ANSI37**: Fine grid
- **SOLID**: Solid fill
- **DOTS**: Dot pattern (for end grain)
- **Insulation**: Special wave pattern (see below)

**Special Pattern: "Insulation"**

Selecting "Insulation" triggers custom snake/wave pattern generation:

- Generates curly/wave polyline instead of standard hatch
- Auto-scales to cavity width
- Uses predefined arch geometry (6 control points per module)
- Module width: 254 mm, diameter: 127 mm (hardcoded)
- Repetition limit: 400 modules (nInrLimit)
- Ideal for thermal insulation representation

**How It Works:**
1. Script calculates profile width
2. Determines how many 254mm modules fit
3. Generates polyline with arch segments
4. Fills cavity horizontally with wave pattern

---

#### Color

- **Type**: Integer (Color Index)
- **Default**: -2 (ByEntity)
- **Range**: -2, -1, or 0-255

**Description:**
Color of the hatch pattern lines for this orientation.

**Special Values:**
- **-2**: ByEntity
- **-1**: ByLayer
- **0-255**: AutoCAD Color Index

---

#### Transparency

- **Type**: Integer (0-100)
- **Default**: 0 (opaque)

**Description:**
Transparency of the hatch pattern for this orientation.

**Scale:**
- **0**: Fully opaque pattern
- **100**: Fully transparent (invisible)

**Interaction with Global Transparency:**
Multiplied by Global Transparency Factor like solid transparency.

---

#### Angle

- **Type**: Number (Degrees)
- **Default**: 0
- **Range**: -360 to 360 (typical)

**Description:**
Rotation angle of the hatch pattern in degrees.

**Interpretation:**
- **0**: Pattern at default orientation
- **90**: Rotated 90° counterclockwise
- **-45**: Rotated 45° clockwise

**Auto-Rotation:**
The script adds additional rotation based on entity orientation alignment. Final angle = (Angle property) + (Calculated orientation angle).

**Common Values:**
- **0**: Default (X-orientation)
- **90**: Perpendicular (often for Y or Z)
- **45/-45**: Diagonal grain representation

---

#### Scale

- **Type**: Number (Unitless)
- **Default**: 1.0
- **Range**: 0.01 to 100 (practical)

**Description:**
Base scale factor for the hatch pattern.

**Calculation:**
```
Final Scale = (Scale) × (Global Scaling Factor)
```

**Guidelines:**
- **< 1.0**: Denser pattern (smaller spacing)
- **1.0**: Normal pattern spacing
- **> 1.0**: Coarser pattern (larger spacing)

**Typical Values:**
- Beams: 0.5 - 1.5
- Panels: 0.3 - 0.8
- Insulation: Auto-calculated (if using Insulation pattern)

---

#### Scale Min

- **Type**: Number (Unitless)
- **Default**: 0.1
- **Range**: 0.01 to Scale value

**Description:**
Minimum scale threshold for Dynamic Scaling Mode. Only used when Scaling Mode = "Dynamic".

**Purpose:**
Prevents patterns from becoming too small/dense when dynamic scaling reduces pattern size based on area.

**Example:**
```
Scale: 1.0
ScaleMin: 0.1

For small hatched areas:
  Dynamic calculation might suggest scale = 0.05
  Clamped to ScaleMin = 0.1 (readable limit)
```

---

#### Scaling Mode

- **Type**: Selection
- **Options**: ["by Hatch Pattern", "Dynamic"]
- **Default**: "by Hatch Pattern"

**Description:**
Controls how the pattern scale adapts to the hatched area size.

**"by Hatch Pattern" (Static Mode):**
- Uses fixed Scale value
- Same pattern density regardless of area size
- Predictable, consistent appearance
- **Best for**: Single-scale documentation

**"Dynamic" (Adaptive Mode - v2.40):**
- Scale adjusts based on hatched area dimensions
- Larger areas → larger patterns
- Smaller areas → smaller patterns (clamped by ScaleMin)
- Reference: 1000mm dimension = base scale
- **Best for**: Multi-scale documentation sets

**Dynamic Calculation:**
```
Area Dimension = sqrt(Profile Area)
Dynamic Factor = Area Dimension / 1000mm
Final Scale = (Scale) × (Dynamic Factor) × (Global Scaling)
Final Scale = max(Final Scale, ScaleMin)  // Clamp to minimum
```

**Use Cases for Dynamic:**
- Drawing sets with 1:50, 1:100, 1:200 scales
- Details ranging from large assemblies to small connections
- Maintaining visual pattern readability across scale variations

---

## Context Menu Commands

Right-clicking the hsbViewHatching TSL instance reveals a comprehensive set of commands for management and modification.

### Add Viewport

**Availability:** Layout viewports only

**Purpose:** Add additional viewports to be controlled by this TSL instance.

**Workflow:**
1. Right-click TSL → "Add Viewport"
2. Command prompts: "Select viewport to add"
3. Click additional viewport(s) in the layout
4. Hatching now spans all selected viewports
5. Single TSL controls settings for entire set

**Benefits:**
- Unified hatching configuration
- Consistent appearance across views
- Single point of modification
- Reduced instance count

**Limitations:**
- All viewports must use same Section Level/Depth
- All viewports share same Mapping Mode
- Cannot have viewport-specific overrides

---

### Add Entity(s)

**Availability:** Non-Element viewports only (standard viewports, not ACA Element viewports)

**Purpose:** Manually add entities to the hatching calculation.

**Workflow:**
1. Right-click TSL → "Add Entity(s)"
2. Script automatically switches to Model Space
3. Command prompts: "Select entities to add"
4. Select entities (beams, sheets, panels, etc.)
5. Press Enter to finish selection
6. Script returns to Layout
7. Hatching regenerates with new entities included

**Use Cases:**
- Selective hatching (not all visible entities)
- Fine control over included geometry
- Adding entities from different layers
- Including hidden entities

**Storage:**
Selected entities stored in TSL's `_Entity` array and internal Map for persistence.

---

### Remove Entity(s)

**Availability:** Non-Element viewports only

**Purpose:** Exclude specific entities from hatching.

**Workflow:**
1. Right-click TSL → "Remove Entity(s)"
2. Script switches to Model Space
3. Command prompts: "Select entities to remove"
4. Select entities currently being hatched
5. Press Enter to finish
6. Script returns to Layout
7. Hatching regenerates without removed entities

**Use Cases:**
- Exclude background elements
- Hide entities that clutter the view
- Remove entities added by mistake
- Temporary exclusion for presentation

---

### Set Level and Depth to Active Zone

**Availability:** Element viewports with active zones only

**Purpose:** Automatically calculate Section Level and Depth from the viewport's active zone geometry.

**Workflow:**
1. Ensure viewport has an active zone defined (hsbCAD Element system)
2. Right-click TSL → "Set Level and Depth to Active Zone"
3. Script analyzes active zone boundaries
4. Calculates appropriate Level and Depth values
5. Properties updated automatically
6. Hatching regenerates with new zone

**Calculation:**
```
Active Zone has top/bottom boundaries relative to section plane:
  Section Level = Active Zone Top
  Section Depth = Active Zone Top - Active Zone Bottom
```

**Benefits:**
- Quick setup for standard zones
- Consistent with Element zone definitions
- Eliminates manual measurement
- Automatic updates if zone changes

---

### Modify Hatch

**Availability:** Always (v2.46+)

**Purpose:** Interactive modification of hatch properties with visual feedback.

**Workflow:**

1. Right-click TSL → "Modify Hatch"

2. **Jigging Mode Activated:**
   - All hatched entities displayed with current patterns
   - Graphical table shows material groups and their hatches
   - Property boxes show hatch names and orientations
   - Margins and spacing auto-calculated for readability

3. **Selection:**
   - **Option A**: Click on an entity in the view
     - All hatches used by that entity highlighted
     - If entity has multiple layers (SIP), all component hatches selected
   - **Option B**: Click on a material group in the graphical table
     - That hatch definition selected for editing

4. **Dialog Opens:**
   - If single hatch selected: Full property dialog appears
   - If multiple hatches selected: Properties show `*VARIES*` for differing values
   - Edit pattern, colors, transparency, scale, etc.

5. **Apply Changes:**
   - Click OK
   - All instances using that hatch update immediately
   - Changes stored in MapObject (not yet in XML)

6. **Persist Changes:**
   - Use "Export Settings" to save modifications to company XML

**Visual Interface (v2.48 improvement):**

The jigging display includes:
- **Entity Shadows**: Plan profiles of all hatched entities transformed to view
- **Material Boxes**: Colored rectangles labeled with hatch names
- **Highlighting**: Selected entity/material highlighted with transparency
- **Text Labels**: Material names positioned near centers
- **Coordinate System**: View-aligned for intuitive interaction

**Performance (v2.79):**
Jigging performance optimized for large entity counts - uses envelope bodies and cached transformations.

**Multiple Orientation Handling (v2.21):**
If a hatch has Anisotropy = Yes, the dialog shows only properties for the **selected orientation** (X, Y, or Z based on which entity axis was clicked).

---

### Add Hatch

**Availability:** Always (v2.19+)

**Purpose:** Create a new hatch definition for entities currently without hatching.

**Workflow:**

1. Right-click TSL → "Add Hatch"

2. **Entity Selection:**
   - Script identifies entities that:
     - Are visible in the view
     - Have no matching hatch definition
   - If using "by Material": Entities with unmapped materials
   - If using "by Painter": Entities failing all painter filters

3. **Selection Options:**
   - **Option A**: Script prompts for entity selection
   - **Option B**: Jigging mode shows unhatchched entities (v2.46+)
   - Click on entity to create hatch for its material

4. **Dialog Opens:**
   - All properties default to reasonable values:
     - Active: Yes
     - Anisotropy: No
     - Pattern: ANSI31
     - Color: -2 (ByEntity)
     - Scale: 1.0
   - User configures new hatch properties

5. **Hatch Created:**
   - New hatch added to mapSetting
   - Entities matching the material/painter immediately hatched
   - Hatch appears in "Modify Hatch" selections going forward

6. **Persist:**
   - Use "Export Settings" to save new hatch to XML
   - Otherwise only exists in current drawing

**Naming:**
- Script suggests name based on material or painter
- User can override with more descriptive name

---

### Delete Hatch

**Availability:** Always (v2.22+)

**Purpose:** Remove unused hatch definitions to clean up settings.

**Workflow:**

1. Right-click TSL → "Delete Hatch"

2. **Unused Detection:**
   - Script analyzes all hatch definitions
   - Identifies hatches NOT currently applied to any entity
   - These are "orphaned" definitions

3. **Selection Dialog:**
   - Lists only unused hatches
   - User selects which to delete
   - Multiple selection allowed

4. **Deletion:**
   - Selected hatches removed from mapSetting
   - Confirmation message shows how many deleted

5. **Persist:**
   - Use "Export Settings" to remove from XML permanently

**Safety:**
- **Cannot delete active hatches** - only unused ones shown
- Prevents accidental removal of hatches in use
- Can be undone by re-importing settings from XML (if not yet exported)

**Use Cases:**
- Clean up after testing different hatch configurations
- Remove obsolete material definitions
- Reduce XML file size
- Simplify hatch selection lists

---

### Import Settings

**Availability:** Always (v2.37+)

**Purpose:** Load hatch definitions from the company XML file into the current drawing.

**Workflow:**

1. Right-click TSL → "Import Settings"

2. **Source File:**
   - Checks company path: `[Company]\TSL\Settings\hsbViewHatching.xml`
   - If not found, falls back to installation path

3. **Import Process:**
   - Reads XML file
   - Parses all hatch definitions
   - **Overwrites** current drawing's MapObject with XML data
   - All previous drawing-specific modifications lost

4. **Confirmation:**
   - Message: "Settings imported successfully from [path]"

5. **Regeneration:**
   - Hatching updates immediately to reflect imported definitions

**When to Use:**
- **Project Start**: Import company standards to new drawing
- **Reset**: Undo experimental changes and reload defaults
- **Sync**: Pull updates made by others to company XML
- **Template Setup**: Load standard hatches into drawing template

**Warning:**
Import OVERWRITES current MapObject. Any unsaved modifications in the drawing will be lost. Use "Export Settings" first if you want to preserve changes.

---

### Export Settings

**Availability:** Always (v2.37+)

**Purpose:** Save current drawing's hatch definitions to the company XML file.

**Workflow:**

1. Right-click TSL → "Export Settings"

2. **Target File:**
   - Company path: `[Company]\TSL\Settings\hsbViewHatching.xml`
   - If company path doesn't exist, operation fails with error

3. **Export Process:**
   - Reads current MapObject from drawing
   - Converts to XML format
   - **Overwrites** company XML file with current data
   - All previous XML content replaced

4. **Confirmation:**
   - Message: "Settings exported successfully to [path]"

5. **Project-Wide Effect:**
   - Other users/drawings importing settings will now get your modifications
   - Acts as version control commit

**When to Use:**
- **After Modifications**: Save changes made via "Modify Hatch" or "Add Hatch"
- **Standard Updates**: Push new company standards to shared location
- **Backup**: Periodically save known-good configurations
- **Template Updates**: Export from master drawing to update project template

**Warning:**
Export OVERWRITES company XML. Coordinate with team to avoid conflicts. Consider manual backup of XML before exporting significant changes.

---

### Global Settings

**Availability:** Always (v2.69+)

**Purpose:** Configure drawing-wide behaviors for hatching.

**Workflow:**

1. Right-click TSL → "Global Settings"

2. **Dialog Opens:**
   Currently contains:
   - **Group Assignment**: Controls group/layer assignment behavior for hatching graphics

3. **Group Assignment Options:**
   - **0 (Default)**: Standard hsbCAD group assignment
   - **1 (Custom)**: Alternative assignment strategy
   - Affects whether hatch graphics go to element groups or T-layers

4. **Application:**
   - Changes apply to all hsbViewHatching instances in drawing
   - Stored in mapSetting's "GeneralMapObject" section
   - Persists with Import/Export operations

**Use Cases:**
- **T-Layer Routing**: Route section graphics to non-plotable T-layers when sections are grouped
- **Layer Override**: Force hatching to specific layer regardless of element grouping
- **Plot Control**: Separate hatching from element graphics for plot management

**Integration (v2.32):**
For sections assigned to groups, section references are drawn on T-Layer (non-plotable) when certain group assignment mode is active.

---

## Advanced Workflows

### Workflow 1: Setting Up Company Standards

**Scenario:** You are the CAD manager setting up hatching standards for all projects.

**Steps:**

1. **Create Master Drawing:**
   - Open new drawing from company template
   - Insert hsbViewHatching on a test section

2. **Configure Hatch Definitions:**
   - Right-click TSL → "Add Hatch" for each standard material:
     - Structural lumber (SPF 2x4, 2x6, 2x8, etc.)
     - Engineered lumber (LVL, PSL, LSL)
     - Sheathing (OSB 7/16, OSB 15/32, Plywood)
     - Finish (Gypsum 1/2, 5/8)
     - Insulation (Batt, Spray Foam)

3. **Set Anisotropy:**
   - Lumber/LVL: Anisotropy = Yes
     - X: DOTS (end grain)
     - Y: ANSI31 @ 0° (side grain)
     - Z: ANSI31 @ 90° (top grain)
   - Sheathing/Gypsum: Anisotropy = No
     - X: ANSI37 (grid pattern)

4. **Configure Colors:**
   - Option A: ByEntity (-2) - use entity color
   - Option B: Material-specific colors:
     - Lumber: Color 3 (green)
     - Sheathing: Color 7 (white/black)
     - Gypsum: Color 8 (gray)

5. **Set Scales:**
   - Test at common plot scales (1:50, 1:100)
   - Adjust Scale values for readable patterns
   - Consider enabling Dynamic mode for multi-scale sets

6. **Export Standards:**
   - Right-click TSL → "Export Settings"
   - Verifies company path exists
   - Saves to `[Company]\TSL\Settings\hsbViewHatching.xml`

7. **Document for Team:**
   - List of standard materials
   - Naming conventions
   - When to use "by Material" vs "by Painter"
   - Instruction to "Import Settings" on new projects

**Maintenance:**
- Update XML when new materials introduced
- Periodically review and clean up unused hatches
- Version control XML file for history tracking

---

### Workflow 2: Multi-Material Wall Section

**Scenario:** You need to hatch a wall section showing studs, sheathing, and gypsum with different materials.

**Steps:**

1. **Verify Materials:**
   - Ensure wall studs have Material = "SPF 2x6"
   - Ensure OSB has Material = "OSB 7/16"
   - Ensure gypsum has Material = "Gypsum 5/8"

2. **Import Standards:**
   - If not already done: Right-click → "Import Settings"
   - Loads company hatch definitions

3. **Insert Hatching:**
   - Create Section2d through wall
   - TSLINSERT → hsbViewHatching
   - Click section entity

4. **Configure Mapping:**
   - Properties Palette: Hatch Mapping = "by Material"
   - Section Level = 0
   - Section Depth = 200 (or wall thickness)

5. **Verify Hatching:**
   - Studs should show wood grain pattern (anisotropic)
   - OSB shows grid pattern
   - Gypsum shows fine pattern or solid

6. **Adjust Transparency:**
   - If materials overlap visually:
     - Right-click → "Modify Hatch"
     - Click on overlapping material
     - Increase Transparency to 20-30
     - Creates layering effect

7. **Fine-Tune Appearance:**
   - Adjust Global Scaling if patterns too dense/sparse
   - Enable Contour for material boundaries
   - Set contour colors for emphasis

**Troubleshooting:**
- **No hatching on studs?**
  - Check Material property matches XML exactly
  - Verify hatch Active = Yes
  - Check visibility filters

- **Wrong pattern?**
  - Verify material name spelling
  - Check for leading/trailing spaces
  - Review XML Material list for matches

---

### Workflow 3: Shop Drawing Batch Processing

**Scenario:** You have 50 shop drawings to generate and want consistent hatching on all.

**Steps:**

**Setup Phase (Once):**

1. **Edit Block Definition:**
   - Access shop drawing block definition
   - This is the template for all shop drawings

2. **Insert Hatching Template:**
   - Run TSLINSERT within block editor
   - Select hsbViewHatching
   - Click on ShopDrawView entity placeholder
   - Pick insertion point (consistent location)

3. **Configure Default Settings:**
   - Hatch Mapping = "by Material"
   - Section Depth = 0 (show all visible)
   - Global Scaling = 1.0
   - Import company settings

4. **Save Block Definition:**
   - Close block editor
   - Hatching now embedded in template

**Generation Phase (Automatic):**

1. **Generate Shop Drawings:**
   - Use standard hsbCAD shop drawing generation
   - Script creates 50 shop drawing layouts

2. **Automatic Hatching:**
   - For each shop drawing:
     - Block space instance activates
     - On `_bOnGenerateShopDrawing`:
       - Script checks entity collector for UID flag
       - Creates Model Space instance (if not exists)
       - Flags UID to prevent duplicates
     - Model Space instance drives hatching
     - Block space shows hatched graphics

3. **Verification:**
   - Open sample shop drawings
   - Verify hatching appears correctly
   - Check that materials are mapped properly

**Customization (Per Drawing):**

1. **Override for Specific Drawing:**
   - Open Model Space
   - Find the auto-created hsbViewHatching instance
   - Modify properties as needed
   - Changes affect only that shop drawing

2. **Bulk Adjustments:**
   - To change all 50 drawings:
     - Edit the block definition instance
     - Regenerate shop drawings
     - All inherit new settings

**Performance Optimization:**
- Uses envelope bodies for speed
- ViewData caching minimizes lookups
- UID tracking prevents duplicate instances
- Single Model Space instance per shop drawing

---

### Workflow 4: Interactive Hatch Modification

**Scenario:** You need to adjust hatching for better readability after initial setup.

**Steps:**

1. **Enter Jigging Mode:**
   - Right-click hsbViewHatching instance → "Modify Hatch"

2. **Visual Interface Appears:**
   - All hatched entities shown with current patterns
   - Material groups displayed as colored boxes with labels
   - View aligned for intuitive interaction

3. **Selection Strategy:**

   **Strategy A - Select by Entity:**
   - Click directly on an entity in the view
   - Script highlights all hatches used by that entity
   - Useful when entity uses multiple materials (SIP layers)
   - Shows which hatches affect the clicked geometry

   **Strategy B - Select by Material Group:**
   - Click on a material box in the graphical table
   - Script highlights all entities using that hatch
   - Useful for material-wide changes

4. **Multiple Selection (v2.47):**
   - Hold Ctrl/Shift (if supported) or click multiple areas
   - Dialog shows `*VARIES*` for properties that differ
   - Changes apply to all selected hatches
   - Useful for batch transparency adjustments

5. **Property Modification:**

   **Example: Increase Pattern Density**
   - Selected hatch dialog opens
   - Find "Scale" property (current: 1.0)
   - Change to 0.5 (denser pattern)
   - Click OK
   - Pattern updates immediately in view

   **Example: Change Pattern Type**
   - Dialog shows current Pattern = "ANSI31"
   - Dropdown shows all available patterns
   - Select "INSULATION" for wave pattern
   - Pattern regenerates with wave geometry

   **Example: Adjust Transparency**
   - Current Transparency = 0 (opaque)
   - Increase to 50 (semi-transparent)
   - Allows background entities to show through

6. **Iterative Refinement:**
   - Make change → observe result
   - Repeat until satisfied
   - Jigging mode remains active for rapid iteration

7. **Exit Jigging:**
   - Press Esc or right-click → Exit
   - Final hatching remains with modifications

8. **Persist Changes:**
   - Right-click → "Export Settings"
   - Saves modified hatches to company XML
   - Makes changes available to other drawings

**Tips:**
- Use jigging for visual feedback
- Test transparency before committing
- Compare multiple materials side-by-side
- Document significant changes for team

---

## Special Features

### Feature 1: Insulation Pattern Generation

The script includes a built-in **wave/snake pattern generator** specifically designed for insulation representation.

#### Activation

Set Pattern = "Insulation" in any orientation's hatch definition.

#### Visual Appearance

```
Standard Hatch (ANSI31):   Insulation Pattern:
//////////////////////     ∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿
//////////////////////     ∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿
//////////////////////     ∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿
```

#### Generation Algorithm

1. **Profile Analysis:**
   - Script calculates the width of the cavity to be filled
   - For wall cavities: stud spacing (e.g., 400mm, 600mm)
   - For roof cavities: rafter spacing

2. **Module Calculation:**
   ```
   Module Width = 254 mm (hardcoded constant dWidthModule)
   Module Diameter = 127 mm (hardcoded constant dDiameterModule)
   Number of Modules = Cavity Width / Module Width
   ```

3. **Arc Point Generation:**
   Each module consists of 6 control points creating wave shape:
   ```c
   Point 0: (31.7451, 0)        - Wave start
   Point 1: (0, 63.5)           - Peak 1  [nArch=0: line]
   Point 2: (127, 63.5)         - Peak 2  [nArch=1: arc]
   Point 3: (63.5, -63.5)       - Valley  [nArch=0: line]
   Point 4: (190.5, -63.5)      - Valley  [nArch=1: arc]
   Point 5: (158.7549, 0)       - Wave end [nArch=0: line]
   ```

4. **Polyline Assembly:**
   - Repeat module pattern horizontally
   - Connect segments with arcs (nArch=1) or lines (nArch=0)
   - Fill cavity width completely
   - Cap ends appropriately

5. **Repetition Limit:**
   ```c
   int nInrLimit = 400;  // Maximum 400 wave modules
   ```
   - Prevents performance issues with very wide cavities
   - Warns user if limit exceeded
   - Use standard hatch pattern instead for extremely wide spans

#### Scaling Behavior

Unlike standard hatches, Insulation pattern:
- **Ignores Scale property** - auto-calculates based on cavity
- **Ignores Scaling Mode** - always adapts to width
- **Respects Angle** - can be rotated for different orientations
- **Respects Color and Transparency**

#### Use Cases

- **Batt Insulation**: Between studs, joists, rafters
- **Spray Foam**: Irregular cavity fills
- **Rigid Insulation**: Continuous exterior layers (though may want standard pattern)

#### Advantages over Standard Patterns

1. **Auto-Scaling**: No manual scale adjustment needed
2. **Professional Appearance**: Industry-standard representation
3. **Cavity-Aware**: Adapts to actual space dimensions
4. **Lightweight**: Polyline is more efficient than dense hatch

#### Limitations

1. **Horizontal Only**: Pattern assumes horizontal cavities (can rotate but geometry designed for this)
2. **Fixed Geometry**: Cannot customize wave amplitude or frequency
3. **Performance**: Very wide cavities (>100m) may hit limit or slow down
4. **No Dynamic Scaling**: Always same wave size regardless of plot scale

#### Configuration Example

```xml
<Orientation nm="Orientation">
  <str nm="Orientation" vl="X"/>
  <str nm="Pattern" vl="Insulation"/>  <!-- Trigger insulation mode -->
  <int nm="Color" vl="252"/>           <!-- Light color -->
  <int nm="Transparency" vl="30"/>     <!-- Semi-transparent -->
  <dbl nm="Angle" ut="" vl="0"/>       <!-- Horizontal -->
  <dbl nm="Scale" ut="" vl="1"/>       <!-- Ignored for Insulation -->
  <str nm="Static" vl="by Hatch Pattern"/>  <!-- Ignored -->
</Orientation>
```

---

### Feature 2: Dynamic Scaling System

Dynamic Scaling adapts hatch pattern sizes to the hatched area dimensions, maintaining readable patterns across varying plot scales.

#### Problem Being Solved

**Scenario:**
- Detail drawing at 1:10 scale - small beams, need fine patterns
- Assembly drawing at 1:100 scale - large beams, same fine pattern becomes invisible dots

**Traditional Solution:**
- Manually adjust Scale property for each drawing scale
- Requires discipline and consistency
- Easy to forget or get wrong

**Dynamic Solution:**
- Script automatically adjusts scale based on actual hatched area size
- Larger areas → larger patterns
- Smaller areas → smaller patterns (clamped by ScaleMin)

#### Enabling Dynamic Scaling

In hatch definition (per orientation):
```
Scaling Mode = "Dynamic"
Scale = 1.0 (base scale)
ScaleMin = 0.1 (minimum readable scale)
```

#### Calculation Algorithm

```c
// 1. Calculate hatched profile area
double dArea = planeProfile.area();

// 2. Convert area to characteristic dimension
double dDimension = sqrt(dArea);  // Approximate "size" of hatch

// 3. Calculate dynamic factor (v2.40)
// Reference: 1000mm dimension = scale factor 1.0
double dDynamicFactor = dDimension / U(1000);

// 4. Apply to base scale
double dScaleDynamic = dScale * dDynamicFactor;

// 5. Clamp to minimum
if (dScaleDynamic < dScaleMin)
    dScaleDynamic = dScaleMin;

// 6. Apply global scaling
double dFinalScale = dScaleDynamic * dGlobalScaling;
```

#### Reference Dimensions

| Area Size | Dimension | Dynamic Factor | Final Scale (if base=1.0) |
|-----------|-----------|----------------|---------------------------|
| 100×100 mm | 100 mm | 0.1 | 0.1 (clamped to ScaleMin) |
| 500×500 mm | 500 mm | 0.5 | 0.5 |
| 1000×1000 mm | 1000 mm | 1.0 | 1.0 (reference) |
| 2000×2000 mm | 2000 mm | 2.0 | 2.0 |

#### ScaleMin Threshold

**Purpose:** Prevent patterns from becoming too small/dense in small areas.

**Example:**
```
Small beam end (40×90 mm):
  Area = 3,600 mm²
  Dimension = 60 mm
  Dynamic Factor = 0.06
  Without clamp: Scale = 0.06 (too small, illegible)
  With ScaleMin = 0.1: Scale = 0.1 (readable)
```

**Recommended Values:**
- **Fine patterns (ANSI31)**: ScaleMin = 0.1
- **Coarse patterns (DOTS)**: ScaleMin = 0.05
- **Detail drawings**: ScaleMin = 0.15
- **Small text height**: ScaleMin = 0.2

#### Comparison: Static vs Dynamic

| Drawing Element | Static (Scale=1.0) | Dynamic (Scale=1.0, ScaleMin=0.1) |
|-----------------|--------------------|------------------------------------|
| Beam 200×400 mm | Scale = 1.0 | Scale = 0.28 |
| Beam 400×600 mm | Scale = 1.0 | Scale = 0.49 |
| Panel 2400×4800 | Scale = 1.0 | Scale = 3.39 |

Dynamic mode creates **visual consistency** - all hatches appear similarly dense regardless of entity size.

#### When to Use Dynamic vs Static

**Use Dynamic When:**
- Documentation set has multiple plot scales (1:50, 1:100, 1:200)
- Drawings contain elements ranging from small beams to large panels
- Consistency across scale variations is important
- Presentation quality is priority

**Use Static When:**
- Single plot scale throughout project
- Manual control over pattern density preferred
- Specific pattern spacing required by standards
- Matching existing manual hatch work

#### Interaction with Global Scaling

```
Final Scale = (Base Scale) × (Dynamic Factor) × (Global Scaling)
```

**Example:**
```
Base Scale = 1.0
Dynamic Factor = 0.5 (for 500mm dimension)
Global Scaling = 2.0 (user wants coarser overall)

Final Scale = 1.0 × 0.5 × 2.0 = 1.0
```

This allows global adjustments without disrupting dynamic relationships.

---

### Feature 3: Dual TSL Instance System (v2.86)

For Section2d/MultiPage environments, hsbViewHatching creates **two separate TSL instances** that work together.

#### Why the Split?

**Historical Problem:**
- Single TSL contained both hatching graphics and grip point controls
- Users wanted hatching on plotable layer (visible in plots)
- Users wanted grip points on T-layer (non-plotable, tools only)
- Single instance cannot be on two layers simultaneously

**Solution:**
- **Instance 1 (Main)**: Hatching TSL - generates hatch graphics
- **Instance 2 (Companion)**: Level/Depth TSL - provides grip point controls

#### Creation Workflow

When user inserts hsbViewHatching on Section2d:

```c
// 1. User clicks Section2d
// 2. Main hatching TSL created (_ThisInst)

// 3. Check if companion exists
Entity entLevelDepth = _Map.getEntity("entLevelDepth");

if (!entLevelDepth.bIsValid())
{
    // 4. Create companion Level/Depth TSL
    TslInst tslLevelDepth;

    // 5. Set mode flag
    Map mapTsl;
    mapTsl.setInt("mode", 1);  // Level/Depth mode
    mapTsl.setEntity("entSectionHatch", _ThisInst);  // Link back

    // 6. Create instance
    tslLevelDepth.dbCreate("hsbViewHatching", vecX, vecY,
                           beams, entities, points,
                           intProps, doubleProps, stringProps,
                           _kModelSpace, mapTsl);

    // 7. Establish dependencies
    _Entity.append(tslLevelDepth);
    setDependencyOnEntity(tslLevelDepth);
    _Map.setEntity("entLevelDepth", tslLevelDepth);
}
```

#### Mode Detection

Each instance checks its mode on execution:

```c
int nMode = 0;
if (_Map.hasInt("mode"))
    nMode = _Map.getInt("mode");

if (nMode == 1)
{
    // This is Level/Depth control TSL
    // Show grip points
    // Synchronize properties with main hatching TSL
}
else
{
    // This is main hatching TSL
    // Generate hatch graphics
    // Ensure companion exists
}
```

#### Property Synchronization

Changes to properties in either instance propagate to both:

**User modifies Level in Properties Palette:**
1. If modified in Main → copies to Companion
2. If modified in Companion → copies to Main
3. Both instances regenerate with same value

**Implementation:**
```c
// Companion sets properties on Main
Entity entSectionHatch = _Map.getEntity("entSectionHatch");
if (entSectionHatch.bIsValid())
{
    TslInst tslSectionHatch = entSectionHatch;
    tslSectionHatch.setPropDouble(0, dSectionLevel);
    tslSectionHatch.setPropDouble(1, dSectionDepth);
    tslSectionHatch.setPropString(3, sAllowEntitiesXref);
}
```

#### Deletion Cleanup

When user deletes either instance:

```c
if (_bOnDbErase)
{
    if (nMode == 1)
    {
        // Deleting Level/Depth TSL → cleanup Main's reference
        Entity entSectionHatch = _Map.getEntity("entSectionHatch");
        if (entSectionHatch.bIsValid())
        {
            TslInst tslMain = entSectionHatch;
            Map mapMain = tslMain.getMap();
            mapMain.removeKey("entLevelDepth");
            tslMain.setMap(mapMain);
        }
    }
    else
    {
        // Deleting Main → delete companion automatically
        Entity entLevelDepth = _Map.getEntity("entLevelDepth");
        if (entLevelDepth.bIsValid())
            entLevelDepth.erase();
    }
}
```

**Result:** Deleting one instance cleanly removes both - no orphans.

#### Group/Layer Assignment

The split allows independent assignment:

**Typical Setup:**
- **Main Hatching TSL**: Assigned to Element's group, plotable layer
- **Companion Level/Depth TSL**: Assigned to T-layer (non-plotable)

**User Experience:**
- Hatching appears in plots
- Grip points visible during editing but not plotted
- Clean separation of graphics vs controls

#### Dependency Tracking

```c
_Entity.append(tslLevelDepth);
setDependencyOnEntity(tslLevelDepth);
```

Ensures:
- Companion regenerates when Main regenerates
- Section2d updates trigger both instances
- Undo/Redo handles both instances correctly

#### Limitations

- **Section2d/MultiPage Only**: Dual system not used for Layout/ShopDraw modes
- **Increased Complexity**: Two instances to manage instead of one
- **Selection**: Users may be confused seeing two instances in drawing

#### Benefits

- **Layer Flexibility**: Graphics and controls on different layers
- **Group Assignment**: Better integration with hsbCAD group system
- **Plot Control**: Fine-grained control over what appears in output
- **Cleaner Plots**: No grip point graphics in final documentation

---

## Usage Scenarios and Examples

### Scenario 1: First-Time Setup for New Project

**Situation:** You're starting a new project and need to set up hatching for the first time.

**Steps:**

1. **Check for Company Standards:**
   ```
   Path: [Company]\TSL\Settings\hsbViewHatching.xml
   ```
   - If file exists: Company standards are available
   - If missing: You'll create new standards

2. **Open Drawing Template:**
   - Start new drawing from company template
   - Ensure materials are defined in material library

3. **Create Test Section:**
   - Model a simple wall assembly:
     - 2×6 SPF studs
     - 7/16" OSB sheathing exterior
     - 5/8" gypsum interior
   - Create Section2d through wall

4. **Insert Hatching:**
   ```
   Command: TSLINSERT
   Select: hsbViewHatching
   Prompt: "Select Section2d or MultiPage"
   Action: Click section
   ```

5. **First Run - No Settings:**
   - Script checks for XML → not found
   - Loads installation defaults
   - Basic hatching appears with default patterns

6. **Import Installation Defaults:**
   - Right-click TSL → "Import Settings"
   - Loads from installation path
   - Provides starting point for customization

7. **Customize for Your Materials:**

   **Add Hatch for SPF Studs:**
   - Right-click → "Add Hatch"
   - Click on unhatchched stud
   - Configure:
     - Name: "SPF-Framing"
     - Active: Yes
     - Anisotropy: Yes
     - Material: "SPF 2x6, SPF 2x4, SPF 2x8"
     - X-Pattern: DOTS (end grain)
     - Y-Pattern: ANSI31 @ 0°
     - Z-Pattern: ANSI31 @ 90°
     - Color: ByEntity
     - Scale: 1.0

   **Add Hatch for OSB:**
   - Right-click → "Add Hatch"
   - Click on OSB
   - Configure:
     - Name: "OSB-Sheathing"
     - Anisotropy: No
     - Material: "OSB 7/16, OSB 15/32"
     - X-Pattern: ANSI37 (grid)
     - Scale: 0.5

   **Add Hatch for Gypsum:**
   - Similar process with fine pattern or solid

8. **Test and Refine:**
   - Create additional sections (plan, detail)
   - Verify hatching appears correctly
   - Adjust scales for readability
   - Test at different plot scales

9. **Export Company Standards:**
   ```
   Right-click → "Export Settings"
   ```
   - Saves to company path
   - Now available for entire team

10. **Document Standards:**
    - Create team wiki/document listing:
      - Standard material names
      - Hatch patterns used
      - When to use "by Material" vs "by Painter"
      - How to import settings on new projects

**Result:** Company-wide hatching standards established and ready for use.

---

### Scenario 2: Troubleshooting - No Hatching Appears

**Situation:** You inserted hsbViewHatching but no hatching is visible.

**Diagnosis Checklist:**

**1. Check Entity Visibility:**
```
Problem: Entities are on frozen/off layers
Solution: Verify layer states, turn on relevant layers
```

**2. Verify Material Mapping:**
```
Problem: Entity material name doesn't match XML
Example:
  Entity Material = "Spruce 2x6"
  XML Material = "SPF 2x6"
  → No match → No hatching

Solution:
  Option A: Edit entity material to match XML
  Option B: Add "Spruce 2x6" to XML material list:
    <str nm="Material" vl="SPF 2x6, SPF 2x4, Spruce 2x6"/>
```

**3. Check Hatch Active Flag:**
```
Problem: Hatch definition exists but Active = No
Solution:
  - Right-click → "Modify Hatch"
  - Click on unmapped material
  - Set Active = Yes
```

**4. Verify Section Level/Depth:**
```
Problem: Entities outside hatching zone
Example:
  Section Level = 0
  Section Depth = 100mm
  Beam center = 200mm from section plane
  → Beam outside [0, -100] zone → No hatching

Solution:
  - Set Section Depth = 0 (infinite mode) to test
  - If hatching appears, adjust Level/Depth to include entity
  - Use grip points (Section2d) or Properties Palette
```

**5. Test with "by Painter" Mode:**
```
Problem: Material name issues
Diagnostic: Switch modes to isolate problem

Steps:
  1. Properties: Hatch Mapping = "by Painter"
  2. Create simple painter filter: Type = GenBeam
  3. Select painter from dropdown
  4. If hatching appears → material name was the issue
  5. If still no hatching → check other factors
```

**6. Check Painter Filter Logic:**
```
Problem: Using "by Painter" but entities don't pass filter
Example:
  Painter Filter: Type = GenBeam AND Layer = "Framing"
  Entity Layer = "Structure"
  → Fails filter → No hatching

Solution:
  - Review painter definition criteria
  - Verify entities meet ALL filter conditions
  - Simplify filter for testing
```

**7. Verify hsbCAD Version:**
```
Problem: Script requires hsbCAD 23.0.47+
Check: Help → About hsbCAD
If older version: Update hsbCAD or use compatible script version
```

**8. Check for Error Messages:**
```
Problem: Script errors not visible
Solution:
  - Check AutoCAD command line history (F2)
  - Look for red error text
  - Common errors:
    - "No entities found for hatching"
    - "XML file not found"
    - "Material not defined in settings"
```

**9. Test with Simple Geometry:**
```
Problem: Complex assembly causing issues
Diagnostic:
  1. Create single beam in clear space
  2. Set material to known XML material
  3. Create Section2d through beam
  4. Insert hsbViewHatching
  5. If hatching appears → original geometry has issue
  6. If still fails → XML/settings problem
```

**10. Rebuild Settings:**
```
Problem: Corrupted MapObject
Solution:
  1. Right-click → "Import Settings"
  2. Forces reload from XML
  3. Overwrites potentially corrupted MapObject
  4. Test again
```

**Advanced Diagnostic:**

**Enable Debug Mode:**
```c
// In script, look for:
MapObject mo("hsbTSLDev", "hsbTSLDebugController");

// To enable, create this MapObject with script name:
Map m;
m.setString(0, "hsbViewHatching");
MapObject moDev("hsbTSLDev", "hsbTSLDebugController");
moDev.dbCreate(m);
```
Then check command line for detailed debug messages.

---

### Scenario 3: Creating Painter-Based Grouping

**Situation:** You want all structural framing to have the same hatch, regardless of material, for a concept drawing.

**Steps:**

**1. Create Painter Definition:**
```
hsbCAD → Painter Editor → New Painter
Name: "hsbViewHatching_StructuralFraming"
Criteria:
  - Type = GenBeam
  - OR Type = Element
  - Layer includes "Fram" OR "Struct"
Save
```

**2. Create Matching Hatch Definition:**

Option A: Via XML
```xml
<Hatch nm="Hatch">
  <str nm="Name" vl="hsbViewHatching_StructuralFraming"/>
  <str nm="Active" vl="Yes"/>
  <str nm="Anisotropy" vl="No"/>
  <str nm="Material" vl=""/>  <!-- Empty for painter mode -->
  <Orientation[] nm="Orientation[]">
    <Orientation nm="Orientation">
      <str nm="Orientation" vl="X"/>
      <str nm="Pattern" vl="ANSI31"/>
      <int nm="Color" vl="3"/>  <!-- Green -->
      <dbl nm="Scale" ut="" vl="1"/>
    </Orientation>
  </Orientation[]>
</Hatch>
```

Option B: Via "Add Hatch"
```
1. Insert hsbViewHatching
2. Set Hatch Mapping = "by Painter"
3. Select "hsbViewHatching_StructuralFraming" from dropdown
4. Right-click → "Add Hatch"
5. Click on entity
6. Configure hatch with name exactly matching painter
```

**3. Apply to Section:**
```
1. Section2d through building
2. Insert hsbViewHatching
3. Properties:
   - Hatch Mapping = "by Painter"
   - Filter by Painter = "hsbViewHatching_StructuralFraming"
4. All framing elements now uniform hatching
```

**4. Add Additional Groupings:**

**Sheathing Group:**
```
Painter: "hsbViewHatching_Sheathing"
Criteria: Type = Sheet AND Material contains "OSB" OR "Plywood"
Hatch: Grid pattern, Color 252 (light gray)
```

**Finish Group:**
```
Painter: "hsbViewHatching_Finish"
Criteria: Type = Sheet AND Material contains "Gypsum"
Hatch: Solid pattern, Transparency 80%
```

**5. Result:**
- Structural elements: ANSI31 green
- Sheathing: ANSI37 light gray
- Finish: Solid light overlay
- Visual hierarchy clear regardless of specific materials

**Benefits:**
- Quick visual grouping
- Less cluttered than material-specific
- Easy to adjust groups by modifying painter filters
- Good for presentations and concept drawings

---

## Tips and Best Practices

### Performance Optimization

1. **Use Envelope Bodies for Large Projects:**
   - Script automatically uses `envelopeBody()` instead of `realBody()` for complex geometry
   - Faster calculation with acceptable accuracy
   - Minimal visual difference for hatching purposes

2. **Limit Insulation Pattern Use:**
   - Maximum 400 repetitions (nInrLimit)
   - For very wide cavities, use standard hatch instead
   - Consider using ANSI31 @ 45° for large insulation areas

3. **Avoid Excessive Viewport Count:**
   - "Add Viewport" is powerful but impacts performance
   - Limit to 5-10 viewports per instance
   - Create separate instances for unrelated viewport groups

4. **Optimize Section Depth:**
   - Don't use Depth = 0 (infinite) if finite zone sufficient
   - Bounded zones reduce entity filtering overhead
   - Especially important for large models

5. **xRef Inclusion:**
   - Only enable "Allow Entities in xRef" when necessary
   - Coordinate transformation and traversal adds time
   - Test performance impact on large xRef'd models

### Visual Quality

1. **Transparency Stacking:**
   ```
   Overlapping materials:
   - Foreground: Transparency = 0 (opaque)
   - Mid-layer: Transparency = 30
   - Background: Transparency = 60

   Creates depth perception without obscuring entities
   ```

2. **Contour Usage:**
   - Enable contours for material boundary emphasis
   - Use contrasting colors: Hatch = ByEntity, Contour = Black
   - Adjust contour thickness for plot scale (0.2-0.5mm typical)

3. **Pattern Selection:**
   ```
   Material Type        Recommended Pattern
   ─────────────────────────────────────────
   Lumber End Grain   → DOTS
   Lumber Side        → ANSI31 @ 0°
   Lumber Top         → ANSI31 @ 90°
   Plywood/LVL        → ANSI32 (cross-hatch)
   OSB                → ANSI37 (grid)
   Gypsum             → SOLID @ 90% transparency
   Insulation         → Insulation (wave)
   Concrete           → AR-CONC
   Masonry            → AR-BRSTD
   ```

4. **Scale Consistency:**
   - Test patterns at final plot scale before standardizing
   - Aim for 2-3mm spacing between pattern lines at plot
   - Use Dynamic Scaling for multi-scale documentation sets

5. **Color Coordination:**
   - Consider using material-specific colors for presentation
   - Stick with ByEntity for fabrication drawings
   - Gray tones (250-255) work well for backgrounds

### Project Management

1. **Settings Version Control:**
   ```
   Best Practice:
   - Keep hsbViewHatching.xml in version control (Git)
   - Tag versions when making significant changes
   - Document changes in commit messages
   - Backup before major updates
   ```

2. **Team Coordination:**
   - Designate one person as "hatch library owner"
   - Establish approval process for new hatch additions
   - Communicate changes to team before exporting
   - Schedule periodic reviews to clean up unused hatches

3. **Template Integration:**
   ```
   Include in drawing templates:
   - Pre-inserted hsbViewHatching in sample section
   - Company XML pre-imported
   - Standard painter definitions
   - Documentation on usage
   ```

4. **Naming Conventions:**
   ```
   Hatch Names:        [Material]-[Type]
   Examples:           "SPF-Framing", "OSB-Sheathing", "Gypsum-5/8"

   Painter Names:      hsbViewHatching_[Category]
   Examples:           "hsbViewHatching_Structural", "hsbViewHatching_Finish"
   ```

### Common Pitfalls to Avoid

1. **Don't Mix Mapping Modes:**
   - Pick either "by Material" OR "by Painter" per instance
   - Mixing creates confusion about which takes precedence
   - Document which mode is used in project standards

2. **Don't Over-Customize:**
   - Too many hatch definitions = maintenance burden
   - Aim for 10-20 standard hatches for most projects
   - Consolidate similar materials when possible

3. **Don't Forget to Export:**
   - Changes via "Modify/Add Hatch" only affect current drawing
   - Must use "Export Settings" to persist to XML
   - Easy to lose work if drawing corrupts before export

4. **Don't Hard-Code Material Names:**
   - Use flexible material lists in XML: "SPF 2x4, SPF 2x6, SPF 2x8"
   - Avoids creating duplicate hatches for size variants
   - Easier to maintain

5. **Don't Ignore Version Migration:**
   - When prompted to migrate settings, read the message
   - Export after migration to preserve merged settings
   - Installation defaults may differ from your customizations

### Troubleshooting Quick Reference

| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| No hatching | Material name mismatch | Check entity material vs XML |
| Wrong pattern | Multiple definitions match | Ensure unique material names |
| Hatching too dense | Scale too small | Increase Scale or use Dynamic |
| Hatching too sparse | Scale too large | Decrease Scale value |
| Can't see grip points | Not Section2d mode | Use Properties Palette instead |
| Changes not saving | Forgot to Export | Right-click → Export Settings |
| Slow performance | Too many entities | Reduce Section Depth, avoid xRef |
| Insulation not working | Pattern name typo | Verify "Insulation" exactly |
| Transparency not working | Global Transparency = 0 | Increase Global Transparency |
| Entities missing | Outside section zone | Increase Section Depth or set to 0 |

---

## Related Scripts and Integration

### Related hsbCAD Scripts

1. **hsbViewLegend** (v2.8+ integration):
   - Reads hatch usage from hsbViewHatching's `_Map`
   - Auto-generates material legend for drawings
   - Shows which hatches are used in current view
   - Synchronizes with hatching definitions

2. **Section2d**:
   - Primary entity for Model Space hatching
   - Defines section plane and view direction
   - Provides showset of visible entities
   - hsbViewHatching attaches to this

3. **MultiPage**:
   - Shop drawing multipage system
   - Contains ShopDrawView entities
   - hsbViewHatching can work in block definitions
   - Auto-creates Model Space instances

4. **Painter Definitions**:
   - Filter system for entity grouping
   - Used by "by Painter" mapping mode
   - Create in Painter Editor
   - Name with "hsbViewHatching_" prefix for collection

5. **Element Viewports**:
   - ACA/hsbCAD architectural viewports
   - Automatic showset from Element
   - Active Zone integration for Level/Depth
   - Better than standard viewports for hsbCAD workflows

### Workflow Integration Points

**1. Design Phase:**
```
Model → Section2d → hsbViewHatching → Visual Review
```

**2. Documentation Phase:**
```
Layout → Viewports → hsbViewHatching → Sheet Plots
```

**3. Fabrication Phase:**
```
Shop Drawings → ShopDrawView → hsbViewHatching → Fab Docs
```

**4. Legend Generation:**
```
hsbViewHatching (stores usage) → hsbViewLegend → Material Legend
```

### Data Flow

```
XML Settings
   ↓
MapObject (per drawing)
   ↓
hsbViewHatching Instance (per view)
   ↓
Hatch Graphics (AutoCAD entities)
   ↓
Plot Output
```

### Customization Points

**1. XML Structure:**
- Add custom hatch properties by extending XML schema
- Script migrations preserve custom fields

**2. Painter Integration:**
- Custom painter rules for project-specific grouping
- Dynamic filter updates reflect in hatching

**3. Global Settings:**
- Extend GeneralMapObject for project-wide behaviors
- Group assignment logic customizable

**4. Pattern Library:**
- Import custom AutoCAD hatch patterns (.PAT files)
- Reference in XML hatch definitions
- Create company-specific patterns

---

## Version History Highlights

Understanding major versions helps troubleshoot version-specific behavior:

| Version | Date | Major Changes |
|---------|------|---------------|
| **2.90** | Jun 2025 | Fastener entity support |
| **2.89** | Jun 2025 | xRef entity inclusion option |
| **2.86** | Apr 2025 | Dual TSL instance system for sections |
| **2.85** | Apr 2025 | Block reference support |
| **2.79** | Oct 2024 | Jigging performance improvements |
| **2.65** | Oct 2023 | Painter grouping extended |
| **2.53** | Nov 2022 | MultiPage model support added |
| **2.47** | Oct 2022 | Multiple hatch selection (VARIES) |
| **2.46** | Oct 2022 | Interactive jigging for Modify/Add Hatch |
| **2.44** | Oct 2022 | "Hatch Mapping" property (Material vs Painter) |
| **2.42** | Sep 2022 | Insulation snake pattern introduced |
| **2.40** | Sep 2022 | Dynamic scaling with 1000mm reference |
| **2.37** | Jul 2022 | Settings migration system, Import/Export |
| **2.30** | Jan 2022 | SIP multi-layer support |
| **2.14** | Jun 2021 | Mass elements, 3D volumes, walls |
| **2.0** | Mar 2020 | Filter system introduced |
| **1.0** | May 2019 | Initial release |

**Upgrade Considerations:**

- **Pre-2.86 → 2.86+**: Dual instance system may affect layer assignments
- **Pre-2.40 → 2.40+**: Dynamic scaling reference changed, may need rescaling
- **Pre-2.37 → 2.37+**: Settings migration required, check after upgrade

---

## Summary

**hsbViewHatching** is a comprehensive, production-grade hatching system for timber construction documentation. Its dual mapping modes, anisotropic support, dynamic scaling, and interactive editing capabilities make it significantly more powerful than manual AutoCAD hatching.

**Key Strengths:**
- Multi-environment flexibility (Model/Paper/Block space)
- Material-aware or rule-based mapping
- Parametric updates with geometry changes
- Project-wide standardization via XML
- Professional insulation pattern generation

**Best Use Cases:**
- Architectural sections and building details
- Multi-view sheet layouts
- Automated shop drawing generation
- Material-specific fabrication documentation

**Getting Started:**
1. Import company settings (or create new)
2. Insert on Section2d or Layout viewport
3. Configure mapping mode (Material or Painter)
4. Adjust as needed via interactive Modify Hatch
5. Export settings for team use

For additional support, consult hsbCAD documentation or contact technical support.
