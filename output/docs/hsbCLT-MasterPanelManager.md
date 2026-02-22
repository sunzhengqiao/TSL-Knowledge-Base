# hsbCLT-MasterPanelManager

## Overview

The **hsbCLT-MasterPanelManager** is an advanced panel nesting and optimization tool for CLT (Cross-Laminated Timber) and SIP (Structural Insulated Panel) manufacturing workflows. It creates master panels (stock material) from which child panels (individual project panels) are optimally nested, cut, and managed throughout the production pipeline.

This tool is the central control point for panel manufacturing, integrating nesting algorithms, surface quality management, grain direction optimization, CNC feed direction control, and production documentation generation.

**Primary Functions:**
- **Panel Nesting**: Automatically nest child panels using multiple algorithms (AutoNester V5, Rectangular Nester)
- **Material Optimization**: Minimize waste through intelligent packing and auto-sizing
- **Surface Quality Control**: Align panel faces based on quality grades
- **Grain Direction Management**: Optimize master orientation for structural requirements
- **Manufacturing Data Export**: Generate CNC routing data, feed directions, and production labels
- **Documentation**: Create plot viewports for shop drawings and production documentation
- **Integration**: Connect with freight packaging, presorting, and export systems

## Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O (Object - Intelligent Entity) |
| **Environment** | Model Space |
| **Required Beams** | 0 (standalone object) |
| **Current Version** | 14.10 (September 2025) |
| **Minimum hsbDesign** | Version 24 (Version 26+ for directional oversize) |
| **Keywords** | Nesting, CLT, Masterpanel, Childpanel, Sip, XRef |
| **Script File** | hsbCLT-MasterPanelManager.mcr |
| **Settings File** | `<company>\TSL\Settings\MasterPanelManagerSettings.xml` |

## Version History Highlights

- **14.10** (Sep 2025): Write DeliveryMaster as smallest delivery number of nested children
- **14.9** (Aug 2025): Add child panel calculation based on outer contour
- **14.8** (Jun 2025): Visual indication for intersections with master panel overcut protection area
- **14.6-14.7** (Feb-Apr 2025): Inconsistent thickness warning system
- **14.1** (Sep 2024): Support isotropic panel style name convention
- **13.5** (Jun 2024): Plot viewport creation options
- **13.3** (Apr 2024): Warning for unsuccessful panel flipping due to beveled edges
- **12.9** (Feb 2024): Value/range-based auto-sizing properties
- **12.1** (Nov 2023): Bounding waste calculation and DataLink.MasterPanel access
- **12.0** (Nov 2023): Master oversize in X and Y directions (requires hsbDesign 26+)
- **10.7** (Nov 2022): Allow creation of empty master panels
- **10.0** (Jun 2022): Enhanced MapX properties for waste tracking (requires hsbDesign 24+)

## Prerequisites

### Required Software
1. **hsbCAD/hsbDesign 24 or higher**
   - Version 24: Basic functionality
   - Version 26+: Directional master oversize (X and Y)

2. **AutoNester Dongle** (Optional)
   - Required only for AutoNester V5 algorithm
   - Rectangular Nester works without dongle

### Required Data
1. **Panels with Proper Style Definitions**
   - CLT or SIP panels with defined surface quality
   - Grain direction information
   - Thickness specifications

2. **Settings Files**
   - Main: `<company>\TSL\Settings\MasterPanelManagerSettings.xml`
   - Package colors: `<company>\TSL\Settings\Freight-PackageSettings.xml`
   - Master styles: `<company>\Sips\MasterPanelStyle.dwg`

3. **Optional Integration**
   - **hsbCLT-Presorter**: For advanced pre-sorting rules
   - **hsbGrainDirection**: For grain direction display (v3.6+)
   - **Freight system**: For package color coding

## User Properties (OPM Categories)

### Masterpanel Category

| Property | Type | Index | Default | Unit | Description |
|----------|------|-------|---------|------|-------------|
| **Length** | PropDouble | 0 | 0 (by default) | Length | Fixed length for master panel. 0 uses settings default (typically 16000mm). Override this to force specific master dimensions. |
| **Width** | PropDouble | 1 | 0 (by default) | Length | Fixed width for master panel. 0 uses settings default (typically 3200mm). Override for specific dimensions. |
| **Grain Type** | PropString | 2 | "Automatic" | - | Master panel grain orientation: **Automatic** (analyzes child panels and selects dominant direction), **Lengthwise** (force L orientation), **Crosswise** (force C orientation) |
| **Auto Size Mode** | PropString | 3 | "On" | - | Enable/disable automatic size adjustment after nesting. **On**: Master adjusts to grid values or ceiling. **Off**: Uses fixed Length/Width. |

**Workflow Notes:**
- **Automatic Grain Detection**: Script calculates total area of lengthwise vs crosswise child panels and chooses the orientation that minimizes waste
- **Auto Size Priority**: Grid Values → Range Values → Ceiling → Minimum
- **Version Compatibility**: Directional oversize (X/Y) requires hsbDesign 26+

### Childpanel Category

| Property | Type | Index | Default | Unit | Description |
|----------|------|-------|---------|------|-------------|
| **Top Face Alignment** | PropString | 4 | "Higher Quality" | - | How child panel faces align to master: **Unchanged** (keep original), **Higher Quality** (best face up), **Lower Quality** (best face down) |
| **Oversize Format Cut** | PropDouble | 5 | 20mm | Length | Oversize added around child panels for CNC routing/cutting. Can be overridden per-panel via sublabel2 format: `<Machine;Offset>` |
| **Sorting Rule** | PropString | 6 | "Disabled" | - | Pre-sorting rule applied before nesting. Rules defined in settings file. Use with hsbCLT-Presorter for advanced sorting. |

**Surface Quality Logic:**
- **Higher Quality**: Ensures premium surface faces upward on master
- **Floor Panel Exception**: If `KeepFloorReferenceBottom=true`, floor panels maintain reference side on bottom regardless of quality rules
- **Flip Constraints**: Beveled edges may prevent flipping - system shows warning highlight (v13.3+)

### Nester Category

| Property | Type | Index | Default | Unit | Description |
|----------|------|-------|---------|------|-------------|
| **Duration [sec]** | PropDouble | 7 | 1 | Time | Maximum time (seconds) the nester can run. Increase for better optimization on complex nests (e.g., 5-30 seconds). |
| **Spacing** | PropDouble | 8 | 8mm | Length | Minimum spacing between nested child panels. Accounts for saw kerf and safety margins. |
| **Nest in openings** | PropString | 9 | "No" | - | Allow small pieces to nest inside panel openings. **AutoNester only** - not available for Rectangular Nester. |
| **Nester Type** | PropString | 10 | "Rectangular Nester" | - | Algorithm: **Disabled** (manual placement only), **AutoNester** (requires dongle, supports complex shapes and 180° rotation), **Rectangular Nester** (free, rectangular packing only) |

**Nesting Algorithm Comparison:**

| Feature | AutoNester V5 | Rectangular Nester |
|---------|---------------|-------------------|
| License Required | Yes (dongle) | No (free) |
| Complex Shapes | Yes | No (simplified bounds) |
| Rotation Support | 180° | Full 360° |
| Nest in Openings | Yes | No |
| Speed | Slower (configurable) | Fast |
| Best For | Complex CLT with cutouts | Simple rectangular panels |

### Display Category

| Property | Type | Index | Default | Unit | Description |
|----------|------|-------|---------|------|-------------|
| **Masterpanel Format** | PropString | 11 | "@(Style)\P@(SurfaceQuality)" | - | Format string for master panel label. Supports format variables and `\P` for line breaks. |
| **Masterpanel Text Height** | PropDouble | 12 | 80mm | Length | Text height for master panel label display. |
| **Childpanel Format** | PropString | 13 | "@(Style)\n@(SurfaceQuality)" | - | Format string for child panel labels. Supports `\n` or `\P` for line breaks. |
| **Childpanel Text Height** | PropDouble | 14 | 80mm | Length | Text height for child panel labels. |

**Format Variable Reference:**
- `@(Style)` - Panel style name
- `@(SurfaceQuality)` - Surface quality designation
- `@(Number)` - Master panel number
- `@(Yield)` - Nesting efficiency percentage
- `@(GrainDirection)` - L (Lengthwise) or C (Crosswise)
- `@(GrainDirectionText)` - Full text: "Lengthwise" or "Crosswise"
- `@(Thickness)` - Panel thickness
- `@(Area)` - Panel area
- `@(Waste)` - Waste percentage
- `@(QuantityChilds)` - Number of nested children
- **Grain-Dependent Color**: `@(GrainDirection:CW93:LW:12:D)` (v13.7+)

## Step-by-Step Usage Guide

### Creating a New Master Panel (Standard Workflow)

#### 1. Prepare Child Panels
**Before inserting MasterPanelManager:**
- Ensure all child panels (SIP/CLT) are created in model space
- Verify panels have proper style and surface quality definitions
- Optionally run **hsbCLT-Presorter** to group panels by sorting rules

#### 2. Insert the Script
```
Command: (hsb_ScriptInsert "hsbCLT-MasterpanelManager")
```
Or use hsbCAD ribbon/toolbar button if configured.

#### 3. Select Source Panels
**Prompt**: "Select panel(s) or any references to it"

**Acceptable Selections:**
- **Individual Sip/CLT panels** - Direct panel selection
- **Existing child panels** - Panels already nested in other masters
- **Master panels** - Copy/reuse existing master configurations
- **Freight packages** - Select package containing panels
- **Press Enter** - Create empty master panel for manual population

**Multi-Selection Tip**: Select multiple panels or mixed entity types. Script intelligently extracts all child panels from selections.

#### 4. Configure Settings Dialog

The configuration dialog appears with multiple categories:

**Geometry Section:**
- **Length/Width**: Set to 0 for defaults, or specify exact dimensions
- **Oversize X/Y**: Master panel overcut allowance (typically 1mm)
- **Add Openings to Master**: Include child panel openings in master contour

**Alignment Section:**
- **Horizontal Alignment**: Left or Right (affects master reference edge)
- **Keep floor panels reference side**: Prevents flipping floor panels
- **Row Offset**: Spacing between multiple masters (typically 1000mm)

**Auto Size X/Y Sections:**
- **Values**: Semicolon-separated list: `"12000;14000;16000"` or ranges: `"0-12000=12000;12000-14000=14000"`
- **Ceiling Value**: Round up to multiples (e.g., 100mm grid)
- **Min. Size**: Enforce minimum dimension

**Output Section:**
- **Start Number**: First master panel number (default: 1)
- **Create Plot Viewports**: Auto-generate plot viewports if configured

**Display Sections:**
- **DimStyle**: AutoCAD dimension style for text
- **Color**: Display color (master and child)
- **Transparency**: Child panel text transparency (0-100)

**Click OK** to confirm settings.

#### 5. Pick Insertion Point
**Prompt**: "Pick insertion point"
- Click to place master panel origin
- **Auto-execution**: Nesting runs automatically
- Master panel created with nested children

**Insertion Result:**
- Master panel geometry created at insertion point
- Child panels nested within master bounds
- Labels and oversize outlines displayed
- Master oriented along World XY axes

### Running Nesting on Existing Master Panel

#### Method 1: Context Menu (Standard)
1. Select the MasterPanelManager instance
2. Right-click → **"Nesting"**
3. Nester re-optimizes current child panel placement

#### Method 2: Reset Rotations (AutoNester Only)
1. Select the MasterPanelManager instance
2. Right-click → **"Nesting (Reset Rotations)"**
3. Clears manual 180° rotations and re-nests from scratch

**When to Re-nest:**
- After manually moving child panels
- After adding/removing child panels
- After changing nesting parameters (spacing, duration)
- After modifying master dimensions

### Adding Child Panels to Existing Master

1. Select the MasterPanelManager instance
2. Right-click → **"Add Child Panels"**
3. **Prompt**: "Select panel(s) or any references to it"
4. Select additional child panels to nest
5. Press Enter - nesting runs automatically

**Duplicate Detection:**
- System prevents adding same panel twice
- Warning displays if panel already nested elsewhere

### Manual Panel Transformations

#### Rotate Child Panels
1. Select master instance → Right-click → **"Rotate Child"**
2. Select one or more child panels
3. Panels rotate 180° around their geometric center
4. **AutoNester Note**: Rotated panels tracked to prevent re-rotation during nesting

#### Flip Child Panels (Reverse Top/Bottom)
1. Select master instance → Right-click → **"Flip Child"**
2. Select child panels to flip
3. Panels flip vertically (swap top/bottom faces)

**Flip Constraints (v13.3+):**
- Beveled edges may prevent flipping
- System shows **yellow highlight** for panels that cannot flip
- Warning: "Flipping unsuccessful due to geometric constraints"

#### Flip + Rotate Combined
1. Select master instance → Right-click → **"Flip + Rotate Child"**
2. Select panels - applies both operations
3. Useful for mirroring panel orientation

#### Align Panels with Edge (v6.8+)
1. Select master instance → Right-click → **"Align panels with edge"**
2. Select child panels
3. Panels snap to nearest master panel edge (X or Y axis)
4. **Collision Detection**: Alignment aborted if intersection detected

**Auto Edge Alignment:**
- Enable via: Right-click → **"Auto Edge Alignment on/off"**
- When enabled: Nester automatically aligns panels to edges after packing
- **Beveled Edge Handling**: Alignment restricted for panels with beveled edges

### Setting CNC Feed Direction

CNC machines often require specific feed directions for routing operations.

#### Set X-Parallel Feed Direction
1. Select master instance → Right-click → **"../Set X-parallel feeding direction"**
2. **Prompt**: "Select ChildPanel(s), <Enter> to select all"
   - Select specific panels, or press Enter for all
3. **Prompt**: "Select direction, <Enter> to remove feeding direction"
   - Click point to define feed vector
   - Or press Enter to clear feed direction

**Feed Direction Data:**
- Stored in child panel's `MapX: CncData.vecRefFeed`
- **XRef Support**: Feed direction written to XRef source files
- **Visual Indicator**: Optional display of feed direction arrows (configured in settings)

#### Set Y-Parallel Feed Direction
- Same workflow as X-parallel
- Use for perpendicular CNC feed requirements

**Feed Direction Display (v11.3+):**
- Feed direction only shown when explicitly defined
- Color-coded display (configured in settings: `FeedingDirection[].Color`)
- Optional block-based or text-based display

### Managing Master Panel Data

#### Write Master Panel Data to Child Panels
1. Select master instance → Right-click → **"Add Masterpanel Data to Panels"**
2. Data written to each child panel's MapX under key `"Masterpanel"`

**Written Data:**
- Master panel number
- Master panel name
- Master information
- Source drawing file path
- Source drawing file name

**Use Cases:**
- Export systems requiring master panel reference
- Production tracking
- Material traceability

#### Remove Master Panel Data
1. Select master instance → Right-click → **"Remove Masterpanel Data from Panels"**
2. Clears `"Masterpanel"` MapX key from all child panels

### Creating Plot Viewports

Plot viewports generate paper space views for shop drawings.

#### Configure Plot Viewports (One-Time Setup)
1. Select master instance → Right-click → **"Configure Plot Viewports"**
2. Dialog displays all configured layouts

**Dialog Structure:**
- **Column 1: Layout Name** - Paper space layout
- **Column 2: Active** - Checkbox to enable/disable
- **Column 3: Scale** - Viewport scale (e.g., 1:50)

3. Check/uncheck layouts to enable for auto-creation
4. Click OK

#### Create Plot Viewports
1. Select master instance → Right-click → **"Create Plot Viewport"**
2. Viewports created in configured layouts
3. Each viewport named after master panel number

**Auto-Creation:**
- If enabled in settings: Viewports created automatically on master insertion
- Viewports update when master geometry changes

### Exporter Groups

Custom export commands can be configured in settings file.

#### Run Export Command
1. Select master instance → Right-click → **"Run Export [name]"**
2. Name corresponds to `ExporterGroup[].Name` in settings
3. Export executes configured operations

**Export Configuration** (in XML settings):
```xml
<lst nm="ExporterGroup[]">
  <lst nm="Group">
    <str nm="Name" vl="MyExporter"/>
    <!-- Export parameters -->
  </lst>
</lst>
```

## Advanced Features

### Auto-Sizing System (v12.9+)

Auto-sizing adjusts master dimensions to standard sizes or grid values after nesting.

#### Auto-Size Priority Order
1. **Grid Values** - Discrete size list
2. **Range Values** - Conditional sizing: "min-max=value"
3. **Ceiling** - Round up to multiples
4. **Minimum** - Enforce minimum size

#### Configuration Methods

**Method 1: Simple Value List**
```
Auto Size X Values: "12000;14000;16000;18000"
```
Result: Master rounds up to next value (e.g., 13500 → 14000)

**Method 2: Range-Based Sizing**
```
Auto Size X Values: "0-12000=12000;12000-14000=14000;14000-16000=16000"
```
Result:
- Nesting 11500 → Master = 12000
- Nesting 13000 → Master = 14000

**Method 3: Ceiling (Grid Rounding)**
```
Ceiling Value X: 100
```
Result: Round up to nearest 100mm (e.g., 13450 → 13500)

**Method 4: Minimum Size**
```
Min. Size X: 10000
```
Result: Master never smaller than 10000, regardless of nesting

**Combined Example:**
- Grid Values: "14000;16000;18000"
- Min. Size: 12000
- Result: Nesting 11000 → Master = 12000 (minimum enforced)
- Result: Nesting 15000 → Master = 16000 (next grid value)

### Surface Quality Alignment

#### Quality Comparison Logic
Surface qualities compared numerically (A1 > A2 > B1 > B2 > C1...).

**Higher Quality Mode:**
```
Child Panel: Top=B1, Bottom=A1
Alignment: Higher Quality
Result: Panel flipped → Top=A1 (master top face)
```

**Floor Panel Exception:**
```
Setting: KeepFloorReferenceBottom = true
Panel Type: Floor (parallel to XY plane)
Surface Quality: Top=A1, Bottom=A1 (identical)
Result: Reference side kept on bottom (no flip)
```

**Manual Override:**
- Master surface quality can be manually overridden in properties
- Override only accepted if selected quality is higher than calculated

### Grain Direction Optimization

#### Automatic Grain Detection (v6.5+)

When **Grain Type = "Automatic"**:

1. Script analyzes all child panels
2. Calculates total area of lengthwise-oriented panels
3. Calculates total area of crosswise-oriented panels
4. Selects master orientation matching dominant direction

**Example:**
```
Lengthwise panels: 25 m² (grain || to long edge)
Crosswise panels: 15 m² (grain ⊥ to long edge)
Result: Master created as Lengthwise
```

#### Isotropic Panel Support (v14.1+)

For panels without directional grain (e.g., OSB):
- **Settings**: Define `LengthWiseKey`, `CrossWiseKey`, `Delimiter`
- **Style Naming**: Uses delimiter to separate thickness from orientation key
- **Example**: `"OSB-25-L"` → Thickness=25, Orientation=Lengthwise

### Child Panel Oversize Handling

#### Global Oversize
Set via property **"Oversize Format Cut"** (default: 20mm)

Applied to all child panels for CNC routing allowance.

#### Per-Panel Oversize Override (v3.7+)

Child panel's `sublabel2` can specify custom oversize:
```
Format: <Machine;Offset>
Example: "CNC1;25"
```

**Priority**: Panel-specific oversize > Global oversize property

#### Tagged Panel Exception (v2.1+)

Panels with `sublabel2 = "HU"` (hand-used/tagged):
- **No oversize** displayed
- Intended for panels requiring manual handling

#### Width Matching Optimization (v8.4+)

If child panel width matches full master width:
- Oversize ignored in width direction
- Prevents extending panel beyond master bounds

### Thickness Inconsistency Warning (v14.5+)

#### Detection
System checks all nested child panels for consistent thickness.

#### Warning Display
If inconsistent thicknesses detected:
```
Warning: "Inconsistent childpanel thicknesses detected"
```

#### Response Options
1. **Accept Warning**: Continue with mixed thicknesses
2. **Separate Nesting**: Create separate masters per thickness
3. **Right-click** → **"Ignore thickness warning"** - Suppress notification

**Visual Indicator**: Inconsistent panels may show highlight (configurable)

### Overcut Protection Warning (v14.8+)

Master panels have protected overcut zones (defined by MasterOversizeX/Y).

#### Intersection Detection
When child panels manually positioned to intersect overcut area:
- **Yellow highlight** shows intersection zone
- **Snap points** provided for correct placement

#### Toggle Warning Display
1. Select master instance → Right-click → **"Disable oversize warning"**
2. Hides visual warning (for intentional overlaps)

**Command Availability**: Only appears when actual overlap detected

### XRef Panel Support

#### Automatic XRef Handling
Script detects and handles XRef (externally referenced) panels automatically.

#### XRef Lock Management
When writing data to XRef panels:
```
XrefLocker: Locks source database
Write Operation: Data written to source file
Unlock: Automatic after write
```

#### Feed Direction for XRef
Feed direction vectors written to XRef source file's MapX.

#### XRef Purging (v13.2+)
Bugfix ensures proper cleanup of XRef references during master deletion.

### Duplicate Panel Prevention (v11.1+)

System tracks all child panel references to prevent duplicates.

#### Duplicate Detection
- Check panel UID against existing children
- Warning if panel already nested in this master
- **Cross-Master Warning** (v10.8+): Reports if panel nested in different master

**Warning Message:**
```
"Panel [posnum] [name] already nested in [FileName], Masterpanel [Number]"
```

### Presorting Integration

#### hsbCLT-Presorter Connection
If **hsbCLT-Presorter** available in search path:
- Sorting rules applied before nesting
- Panels grouped by configurable criteria
- Optimizes material usage per group

#### Sorting Rules (in Settings)
```xml
<lst nm="Sorting[]">
  <lst nm="Rule">
    <str nm="Name" vl="ByThickness"/>
    <!-- Rule configuration -->
  </lst>
</lst>
```

#### Property: Sorting Rule
Select from configured rules via property dropdown.

**Disabled**: No pre-sorting, nest in selection order.

### Color Coding

#### Package Color Override (v1.9+)
If child panels linked to freight packages:
- Package color read from `Freight-PackageSettings.xml`
- Child panel text color overridden to package color

**Settings File:**
```xml
<Hsb_Map>
  <lst nm="PackageColor[]">
    <lst nm="Package">
      <str nm="Name" vl="Package1"/>
      <int nm="Color" vl="1"/>
    </lst>
  </lst>
</Hsb_Map>
```

#### Element-Based Panel Coloring (v12.6+)
Panels nested in elements or stacked in truck loading:
- Enhanced color coding to distinguish source

#### Grain Direction Symbol Color (v13.7+)
Format supports grain-dependent color coding:
```
@(GrainDirection:CW93:LW:12:D)
```
- Crosswise → Color 93
- Lengthwise → Color 12
- Default → Color D

### Custom Block Tag Display (v4.3+)

#### Block-Based Header
Instead of text labels, use AutoCAD block with attributes.

#### Configuration
**Property**: Block Name (select from detected blocks)

**Block Requirements:**
- Block must exist in drawing
- Attributes named as format variables: `@(ProjectNumber)`, `@(Style)`, etc.

#### Format Resolving (v13.8+)
1. Try to resolve format from master panel data
2. If master data unavailable, use first nested child panel data

#### Custom Block Tag Transparency (v13.6+)
**Setting**: `ChildDisplay.Transparency` (0-100)

#### Tag Location Optimization (v13.6+)
- Tag avoids intersection with child panel openings
- **Toggle Grips**: Right-click → **"Tag Grips On/Off"** - Show/hide tag adjustment grips

#### First Line Override (v12.3+)
**Settings:**
- `Header.textHeight` - Override first line text size
- `Header.Color` - Override first line color

#### Header Position (v4.3+)
**Settings:**
- `Header.X\\Offset` - X offset from master lower-left corner
- `Header.Y\\Offset` - Y offset from master lower-left corner
- 0 = default location below master

### Relation Display

#### Show/Hide Child-to-Source Lines
1. Select master instance → Right-click → **"Show Relation"** or **"Hide Relation"**
2. Lines drawn from nested child panels to original source locations

**Use Case**: Visualize where panels came from (e.g., which wall/floor element)

### Master Panel Style Import (v1.8+)

#### Automatic Style Import
When master panel created:
1. Script determines required style name based on:
   - Thickness
   - Grain direction (L/C)
   - Surface quality
2. Checks if style exists in current drawing
3. If not, imports from **MasterPanelStyle.dwg**

#### Style Naming Convention
**Standard Format**: `[Style]-[Thickness][GrainKey]`
- Example: `"CLT-100L"` - CLT, 100mm thick, Lengthwise
- Example: `"CLT-120C"` - CLT, 120mm thick, Crosswise

**Isotropic Format** (v14.1+): `[Style][Delimiter][Thickness][Delimiter][OrientationKey]`
- Example with Delimiter="-": `"OSB-25-L"`

#### Configuration
**Settings:**
- `Masterpanel Style.StyleDwg` - Full path to style drawing
- `Masterpanel Style.LengthWiseKey` - Key for lengthwise (e.g., "L")
- `Masterpanel Style.CrossWiseKey` - Key for crosswise (e.g., "C")
- `Masterpanel Style.Delimiter` - Separator (e.g., "-")

**Context Command**: Right-click → **"Select Masterstyle Dwg"** - Browse for style file

### Waste Calculation

#### Waste Metrics (v10.0+)
Master panel MapX contains:

| Metric | Key | Description |
|--------|-----|-------------|
| **Net Area** | `AreaNet` | Total area of nested child panels |
| **Gross Area** | `AreaGros` | Total master panel area |
| **Waste %** | `Waste` | `(Gros-Net)/Gros*100` |
| **Bounding Waste** | `BoundingWaste` | Waste based on bounding boxes |
| **Bounding Waste Area** | `BoundingWasteArea` | Bounding box waste area (v12.5+) |
| **Outer Contour Waste** | `OutterContourWaste` | Waste based on outer contours (v14.9+) |
| **Outer Contour Waste Area** | `OutterContourWasteArea` | Outer contour waste area (v14.9+) |
| **Volume** | `Volume` | Master panel volume |
| **Quantity Childs** | `QuantityChilds` | Number of nested panels |

**Access in Formats:**
```
@(Masterpanel.Waste)
@(Masterpanel.AreaNet)
@(Masterpanel.QuantityChilds)
```

#### Yield Display
Yield = 100 - Waste

**Continuously Updated** (v10.1+): Yield recalculates on any change

#### DataLink.MasterPanel (v12.1+)
Each child panel gains access to master panel properties:
```
@(DataLink.MasterPanel.Number)
@(DataLink.MasterPanel.Waste)
```

### Empty Master Panel Creation (v10.7+)

#### Workflow
1. Insert MasterPanelManager
2. **Prompt**: "Select panel(s)..."
3. **Press Enter** without selecting
4. Empty master panel created
5. Manually add panels later via "Add Child Panels"

**Use Case**: Pre-create masters with specific numbering/sizes before population

### Shape Lock (v10.2+)

Remote shape lock prevents automatic shape recalculation.

**MapX Key**: `ShapeLock.Locked`

**Purpose**: Special tools can deactivate automatic master geometry updates for custom workflows.

### Multi-Project Nesting (v5.4+)

Nest panels from multiple projects into shared master panels.

**Configuration**: Requires special settings (contact hsbCAD support)

**Use Case**: Optimize material usage across multiple small projects

## Settings File Reference

### Main Settings File Structure

**Location:** `<company>\TSL\Settings\MasterPanelManagerSettings.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- Geometry -->
  <dbl nm="Length" ut="L" vl="16000"/>
  <dbl nm="Width" ut="L" vl="3200"/>
  <dbl nm="MasterOversize" ut="L" vl="1"/>
  <dbl nm="MasterOversizeY" ut="L" vl="1"/>
  <int nm="AddOpeningToMaster" vl="0"/>

  <!-- Alignment -->
  <int nm="AlignRight" vl="1"/>
  <int nm="KeepFloorReferenceBottom" vl="1"/>
  <dbl nm="MasterRowOffset" ut="L" vl="1000"/>

  <!-- Output -->
  <int nm="MasterStartNumber" vl="1"/>
  <int nm="Color" vl="252"/>
  <str nm="DimStyle" vl="Standard"/>

  <!-- Auto Size -->
  <lst nm="AutoSize">
    <dbl nm="X\Ceiling" ut="L" vl="0"/>
    <dbl nm="Y\Ceiling" ut="L" vl="0"/>
    <dbl nm="X\Minimum" ut="L" vl="0"/>
    <dbl nm="Y\Minimum" ut="L" vl="0"/>

    <!-- Grid Values -->
    <lst nm="X\Value[]">
      <dbl nm="Value" ut="L" vl="12000"/>
      <dbl nm="Value" ut="L" vl="14000"/>
      <dbl nm="Value" ut="L" vl="16000"/>
    </lst>

    <!-- Range Values -->
    <lst nm="X\Range[]">
      <lst nm="Range">
        <dbl nm="Min" ut="L" vl="0"/>
        <dbl nm="Max" ut="L" vl="12000"/>
        <dbl nm="Value" ut="L" vl="12000"/>
      </lst>
    </lst>
  </lst>

  <!-- Child Display -->
  <lst nm="ChildDisplay">
    <str nm="DimStyle" vl="Standard"/>
    <int nm="ColorText" vl="252"/>
    <int nm="Transparency" vl="0"/>
    <str nm="Linetype" vl="CONTINUOUS"/>
    <dbl nm="LineTypeScaleFactor" vl="1"/>
    <int nm="Color" vl="252"/>
  </lst>

  <!-- Header -->
  <lst nm="Header">
    <str nm="Blockname" vl=""/>
    <dbl nm="X\Offset" ut="L" vl="0"/>
    <dbl nm="Y\Offset" ut="L" vl="0"/>
    <int nm="Color" vl="252"/>
    <dbl nm="textHeight" ut="L" vl="0"/>

    <!-- Oversize Color Coding -->
    <lst nm="OversizeColor[]">
      <lst nm="ColorRange">
        <dbl nm="Min" ut="L" vl="0"/>
        <dbl nm="Max" ut="L" vl="10"/>
        <int nm="Color" vl="3"/>
      </lst>
    </lst>
  </lst>

  <!-- Nesting -->
  <lst nm="Nesting">
    <int nm="EdgeAlignment" vl="0"/>
    <int nm="ShowNestingReport" vl="0"/>
  </lst>

  <!-- Feed Direction -->
  <lst nm="FeedingDirection[]">
    <str nm="Blockname" vl=""/>
    <str nm="Text" vl=""/>
    <int nm="Color" vl="1"/>
  </lst>

  <!-- Masterpanel Style -->
  <lst nm="Masterpanel Style">
    <str nm="StyleDwg" vl="C:\hsbCAD\Company\Sips\MasterPanelStyle.dwg"/>
    <str nm="LengthWiseKey" vl="L"/>
    <str nm="CrossWiseKey" vl="C"/>
    <str nm="Delimiter" vl="-"/>
  </lst>

  <!-- Sorting Rules -->
  <lst nm="Sorting[]">
    <lst nm="Rule">
      <str nm="Name" vl="ByThickness"/>
      <!-- Rule parameters -->
    </lst>
  </lst>

  <!-- Plot Viewports -->
  <lst nm="PlotViewport[]">
    <lst nm="Viewport">
      <str nm="Layout" vl="A3-Master"/>
      <int nm="active" vl="1"/>
      <dbl nm="Scale" vl="50"/>
    </lst>
  </lst>

  <!-- Exporter Groups -->
  <lst nm="ExporterGroup[]">
    <lst nm="Group">
      <str nm="Name" vl="ExportCNC"/>
      <!-- Export configuration -->
    </lst>
  </lst>

  <!-- Layer Display -->
  <lst nm="LayerInterference">
    <int nm="Color" vl="242"/>
    <str nm="Linetype" vl="CONTINUOUS"/>
    <dbl nm="LinetypeScale" ut="L" vl="1"/>
    <int nm="Transparency" vl="0"/>
  </lst>

  <!-- Tagged Panel Display -->
  <lst nm="Tagged">
    <int nm="Color" vl="1"/>
    <int nm="ColorOpp" vl="4"/>
    <str nm="Linetype" vl="CONTINUOUS"/>
    <dbl nm="LinetypeScale" ut="L" vl="1"/>
    <int nm="Transparency" vl="80"/>
  </lst>

  <!-- Child Headers -->
  <lst nm="ChildHeader[]">
    <lst nm="Header">
      <str nm="format" vl="@(Style)"/>
      <str nm="BlockName" vl=""/>
      <str nm="DimStyle" vl="Standard"/>
      <dbl nm="TextHeight" ut="L" vl="80"/>
      <int nm="Color" vl="252"/>
    </lst>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Settings Management

#### Configure Settings Dialog
1. Select master instance → Right-click → **"Configure Settings"**
2. Dialog shows all configurable parameters
3. Modify values
4. Click OK - changes saved to MapObject (session-persistent)

#### Import Settings
1. Select master instance → Right-click → **"Import Settings"**
2. Browse for XML settings file
3. Settings loaded and applied

#### Export Settings
1. Select master instance → Right-click → **"Export Settings"**
2. Specify output XML file path
3. Current settings saved to file

**Use Case**: Share settings across projects or backup configurations

### Package Color Settings

**Location:** `<company>\TSL\Settings\Freight-PackageSettings.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="PackageColor[]">
    <lst nm="Package">
      <str nm="Name" vl="Truck1-Package1"/>
      <int nm="Color" vl="1"/>
    </lst>
    <lst nm="Package">
      <str nm="Name" vl="Truck1-Package2"/>
      <int nm="Color" vl="3"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

Child panel text color overridden by package color if panel is in freight system.

## Right-Click Context Menu Reference

### Root Level Commands

| Command | Description | Availability |
|---------|-------------|--------------|
| **Nesting** | Re-run nesting algorithm on current child panels | Always |
| **Nesting (Reset Rotations)** | Run nesting and reset manual 180° rotations | AutoNester only |
| **Add Child Panels** | Select additional child panels to add to master | Always |
| **Rotate Child** | Rotate selected child panels 180 degrees | Always |
| **Flip Child** | Flip selected child panels (toggle top/bottom face) | When flip allowed |
| **Flip + Rotate Child** | Both flip and rotate selected child panels | When flip allowed |
| **Add Masterpanel Data to Panels** | Write master panel reference data to all nested children | Always |
| **Remove Masterpanel Data from Panels** | Clear master panel reference from child panels | When data present |
| **Align panels with edge** | Align selected child panels to closest master edge | Always |
| **Create Plot Viewport** | Generate plot viewports based on configured layouts | When configured |
| **Tag Grips On/Off** | Toggle visibility of tag location adjustment grips | Always |

### Sub-Menu Commands

| Command | Path | Description |
|---------|------|-------------|
| **Set X-parallel feeding direction** | ../ | Define CNC feed direction along X-axis for selected panels |
| **Set Y-parallel feeding direction** | ../ | Define CNC feed direction along Y-axis for selected panels |
| **Show Relation** | (Root) | Display lines connecting child panels to source locations |
| **Hide Relation** | (Root) | Hide child-to-source relation lines |
| **Ignore thickness warning** | (Root) | Suppress warnings about inconsistent thicknesses (v14.6+) |
| **Auto Edge Alignment on/off** | (Root) | Toggle automatic edge alignment during nesting |
| **Disable oversize warning** | (Root) | Hide visual warning for overcut area intersections (v14.8+) |

### Configuration Commands

| Command | Description |
|---------|-------------|
| **Configure Settings** | Open dialog to modify global settings |
| **Configure Plot Viewports** | Configure which layouts generate plot viewports |
| **Select Masterstyle Dwg** | Select drawing containing master panel style definitions |
| **Import Settings** | Load settings from XML file |
| **Export Settings** | Save current settings to XML file |
| **Run Export [name]** | Execute configured exporter groups (dynamic - based on settings) |

## MapX Data Structure

### Master Panel MapX

Master panel instance stores data in MapX under key `"Masterpanel"`:

```
Masterpanel {
  AreaNet: [double] Total area of nested child panels
  AreaGros: [double] Total master panel area
  Waste: [double] Waste percentage
  BoundingWaste: [double] Waste based on bounding boxes
  BoundingWasteArea: [double] Bounding box waste area
  OutterContourWaste: [double] Waste based on outer contours (v14.9+)
  OutterContourWasteArea: [double] Outer contour waste area (v14.9+)
  Volume: [double] Master panel volume
  QuantityChilds: [int] Number of nested child panels
  Yield: [double] Nesting efficiency (100-Waste)
  GrainDirection: [string] "L" or "C"
  GrainDirectionText: [string] "Lengthwise" or "Crosswise"
  GrainDirectionTextShort: [string] Short form
  SurfaceQualityTop: [string] Top surface quality
  SurfaceQualityBottom: [string] Bottom surface quality
  Number: [int] Master panel number
  Name: [string] Master panel name
  Information: [string] Master panel information
  DeliveryMaster: [int] Smallest delivery number of nested children (v14.10+)
  [Custom keys from settings Header custom data]
}
```

### Child Panel MapX

Each child panel gains MapX data:

**Masterpanel Key** (when written via "Add Masterpanel Data"):
```
Masterpanel {
  Information: [string] Master information
  Name: [string] Master name
  Number: [string] Master number
  FullPathName: [string] Source drawing path
  FileName: [string] Source drawing filename
}
```

**CncData Key** (when feed direction set):
```
CncData {
  vecRefFeed: [Vector3d] Feed direction vector
  vecRefSide: [Vector3d] Reference side vector (optional)
  Text: [string] Feed text (optional)
}
```

**DataLink.MasterPanel Key** (v12.1+):
Provides dynamic access to master panel properties from child panel context.

**Presorter Key** (when presorter used):
```
presorter {
  tag: [string] Sorting group tag
  [Other presorter data]
}
```

## Troubleshooting

### Nesting Issues

#### Problem: "No dongle found" Error
**Cause:** AutoNester V5 selected but no dongle detected

**Solutions:**
1. Switch to **Rectangular Nester** (Property: Nester Type)
2. Or install AutoNester dongle license
3. Or select **Disabled** for manual placement only

#### Problem: Nesting Runs Multiple Times
**Cause:** Missing dongle triggering repeated attempts (fixed v8.1+)

**Solution:** Update to v8.1+ or switch to Rectangular Nester

#### Problem: Panels Overlapping Slightly
**Cause:** Spacing too small or AutoNester tolerance issue (fixed v7.9+)

**Solutions:**
1. Increase **Spacing** property (e.g., from 8mm to 10mm)
2. Update to v7.9+ for AutoNester tolerance fix

#### Problem: Panels Not Aligning to Edges
**Cause:** Auto Edge Alignment disabled or beveled edges

**Solutions:**
1. Enable: Right-click → "Auto Edge Alignment on/off"
2. Check setting: `Nesting.EdgeAlignment = 1`
3. Beveled edges restrict alignment (by design v12.8+)

### Master Panel Size Issues

#### Problem: Master Too Small After Nesting
**Cause:** Auto Size settings incorrect or not configured

**Solutions:**
1. Check **Auto Size Mode** = "On"
2. Verify Grid Values or Ceiling configured
3. Set **Min. Size X/Y** to enforce minimum
4. Or disable Auto Size and set fixed **Length/Width**

#### Problem: Master Not Matching Grid Values
**Cause:** Incorrect value format in settings

**Solutions:**
1. Check format: `"12000;14000;16000"` (semicolon-separated)
2. Or range format: `"0-12000=12000;12000-14000=14000"`
3. Reload settings: Right-click → "Import Settings"

### Surface Quality Issues

#### Problem: Panels Not Flipping Despite Quality Rules
**Cause:** Beveled edges preventing flip (v13.3+)

**Identification:**
- Yellow highlight on problem panels
- Warning: "Flipping unsuccessful due to geometric constraints"

**Solutions:**
1. Accept current orientation (beveled edges require specific face)
2. Manually adjust if necessary
3. Or modify panel geometry to remove bevel

#### Problem: Floor Panels Flipped Incorrectly
**Cause:** `KeepFloorReferenceBottom` setting

**Solutions:**
1. Enable: Right-click → "Configure Settings"
2. Set **Keep floor panels reference side** = "Yes"
3. Or check `KeepFloorReferenceBottom = 1` in XML settings

### Thickness Warning Issues

#### Problem: Unwanted Thickness Warning (v14.5+)
**Cause:** Mixed panel thicknesses in nesting

**Solutions:**
1. Right-click → "Ignore thickness warning" (suppress notification)
2. Or separate panels by thickness into different masters
3. Or accept warning if intentional

### Style Import Issues

#### Problem: Master Panel Style Not Applied
**Cause:** Style drawing path incorrect or style naming mismatch

**Solutions:**
1. Right-click → "Select Masterstyle Dwg" - Verify path
2. Check style naming matches convention:
   - Standard: `[Style]-[Thickness][GrainKey]` (e.g., "CLT-100L")
   - Isotropic: Configure Delimiter and keys in settings
3. Verify style exists in MasterPanelStyle.dwg
4. Check settings: `Masterpanel Style.LengthWiseKey`, `CrossWiseKey`

### Export Issues

#### Problem: Feed Direction Not Exported
**Cause:** Feed direction not set or XRef lock failure

**Solutions:**
1. Verify feed direction set: Right-click → "Set X/Y-parallel feeding direction"
2. For XRef panels: Ensure XRef not locked by another user
3. Check `CncData.vecRefFeed` in panel MapX

#### Problem: Master Panel Data Not on Child Panels
**Cause:** "Add Masterpanel Data" not run

**Solution:**
Right-click → "Add Masterpanel Data to Panels"

### Display Issues

#### Problem: Child Panel Text Not Visible
**Cause:** Text height too small or color matches background

**Solutions:**
1. Increase **Childpanel Text Height** property
2. Change **Display Childpanel.Colour Text** to contrasting color
3. Adjust **Transparency** if too transparent

#### Problem: Oversize Outline Not Showing
**Cause:** Oversize = 0 or display settings

**Solutions:**
1. Set **Oversize Format Cut** > 0 (e.g., 20mm)
2. Check child panel `sublabel2` not set to "HU" (tagged panels hide oversize)

#### Problem: Master Panel Not Visible in Certain Views (v11.2+)
**Cause:** Intentional hiding when looking along X/Y-World axes

**Explanation:** Master hidden when viewing from +/-X-World or +/-Y-World to improve model visibility.

**Solution:** Rotate view to isometric or other angle.

### Plot Viewport Issues

#### Problem: Viewports Not Created
**Cause:** Layouts not configured as active

**Solutions:**
1. Right-click → "Configure Plot Viewports"
2. Check **Active** for desired layouts
3. Or enable in settings: `AutoCreationPlotViewport = 1`

#### Problem: Viewport Name Incorrect
**Cause:** Master panel number not set

**Solution:** Verify **Start Number** and master numbering sequence

## Performance Tips

### Nesting Performance

**Faster Nesting:**
1. Use **Rectangular Nester** for simple rectangular panels (faster than AutoNester)
2. Reduce **Duration** for quick approximate results (e.g., 1-2 seconds)
3. Disable **Nest in openings** if not needed
4. Pre-sort panels to reduce nester complexity

**Better Optimization:**
1. Use **AutoNester V5** for complex shapes
2. Increase **Duration** (e.g., 10-30 seconds) for thorough optimization
3. Enable **Auto Edge Alignment** for cleaner layouts
4. Use **Presorter** to group similar panels

### Display Performance

**Reduce Display Complexity:**
1. Hide relation lines when not needed (Right-click → "Hide Relation")
2. Use higher **Transparency** for child tags (reduces visual clutter)
3. Disable custom block tags if simple text sufficient

### Large Project Optimization

**Managing Many Masters:**
1. Use **Row Offset** to organize masters in grid
2. Freeze layers when not editing
3. Enable **Auto Edge Alignment** to reduce manual adjustments

## Advanced Workflows

### Multi-Stage Nesting Workflow

**Scenario:** Optimize panels from multiple building elements

1. **Collection Stage:**
   - Insert empty MasterPanelManager (press Enter at selection)
   - Set master dimensions and auto-size rules

2. **Population Stage:**
   - Right-click → "Add Child Panels"
   - Select panels from first element
   - Nesting runs automatically

3. **Incremental Addition:**
   - Right-click → "Add Child Panels" again
   - Select panels from next element
   - Repeat until master full or all elements processed

4. **Optimization Stage:**
   - Adjust **Spacing** or **Duration**
   - Right-click → "Nesting" to re-optimize
   - Manually rotate/flip specific panels if needed

5. **Documentation Stage:**
   - Right-click → "Add Masterpanel Data to Panels"
   - Right-click → "Create Plot Viewport"
   - Right-click → "Run Export [CNC]"

### Quality-Based Nesting Strategy

**Scenario:** Separate panels by surface quality grades

1. **High-Quality Master:**
   - Set **Top Face Alignment** = "Higher Quality"
   - Select only A-grade panels
   - Create master → Premium face upward

2. **Standard-Quality Master:**
   - Set **Top Face Alignment** = "Unchanged"
   - Select B/C-grade panels
   - Create master → Mixed orientation

3. **Floor Panel Master:**
   - Enable **Keep floor panels reference side**
   - Select floor panels only
   - Create master → Reference side down

### Integration with Production Systems

#### CNC Export Workflow

1. **Set Feed Directions:**
   - Right-click → "Set X-parallel feeding direction"
   - Select all panels → Define feed vector
   - Data written to panel MapX `CncData.vecRefFeed`

2. **Write Master References:**
   - Right-click → "Add Masterpanel Data to Panels"
   - Each panel gets master number, filename, path

3. **Run Export:**
   - Configure exporter group in settings
   - Right-click → "Run Export [CNC]"
   - Export executes custom CNC data generation

#### Freight Integration Workflow

1. **Color Code by Package:**
   - Configure `Freight-PackageSettings.xml`
   - Panels in packages auto-color coded

2. **Nest by Delivery:**
   - Use **Presorter** with delivery-based sorting rule
   - Create masters per delivery group

3. **Track Delivery Master:**
   - MapX `DeliveryMaster` stores smallest delivery number (v14.10+)
   - Use for production sequencing

## Related Scripts

### Core Integration Scripts

| Script | Purpose | Integration Point |
|--------|---------|-------------------|
| **hsbCLT-Presorter** | Pre-sorts panels before nesting | Property: "Sorting Rule" |
| **hsbGrainDirection** (v3.6+) | Manages grain direction display | Automatic - grain direction symbols |
| **hsbFreight-Item** | Freight item management | Package color coding |
| **hsbFreight-Package** | Freight package management | Child panel package linking |

### Supporting Scripts

| Script | Purpose | Relationship |
|--------|---------|--------------|
| **hsbCLT-Drill** | Drilling operations on panels | Nested panels can have drill tools |
| **hsbCLT-Opening** | Panel opening creation | Openings considered in nesting |
| **hsbCLT-JointBoard** | Joint board connections | Child panels can have joints |
| **hsbCLT-Labeler** | Panel labeling | Uses master panel data for labels |
| **TslSettingsIO** | Settings import/export | Settings management backend |

### Export/Documentation Scripts

| Script | Purpose | Integration |
|--------|---------|-------------|
| **sd_MetalpartBOM** | Metal part BOM generation | Can reference nested panels |
| **hsbLayoutDim** | Layout dimensioning | Dimensions master panels |
| **hsbCNC** | CNC data export | Uses feed direction data |

## Keyboard Commands

### Insertion Command
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-MasterpanelManager")) TSLCONTENT
```

### Context Command Shortcuts
```
; Run Nesting
^C^C(defun c:NEST() (hsb_RecalcTslWithKey (_TM "|Nesting|") (_TM "|Select Masterpanel-Manager|"))) NEST

; Set X Feed Direction
^C^C(defun c:FEEDX() (hsb_RecalcTslWithKey (_TM "../|Set X-parallel feeding direction|") (_TM "|Select Masterpanel-Manager|"))) FEEDX

; Set Y Feed Direction
^C^C(defun c:FEEDY() (hsb_RecalcTslWithKey (_TM "../|Set Y-parallel feeding direction|") (_TM "|Select Masterpanel-Manager|"))) FEEDY

; Show Relation
^C^C(defun c:SHOWREL() (hsb_RecalcTslWithKey (_TM "|Show Relation|") (_TM "|Select Masterpanel-Manager|"))) SHOWREL

; Add Child Panels
^C^C(defun c:ADDCHILD() (hsb_RecalcTslWithKey (_TM "|Add Child Panel(s)|") (_TM "|Select Masterpanel-Manager|"))) ADDCHILD

; Rotate Child
^C^C(defun c:ROTCHILD() (hsb_RecalcTslWithKey (_TM "|Rotate Child|") (_TM "|Select Masterpanel-Manager|"))) ROTCHILD

; Flip Child
^C^C(defun c:FLIPCHILD() (hsb_RecalcTslWithKey (_TM "|Flip Child|") (_TM "|Select Masterpanel-Manager|"))) FLIPCHILD

; Flip + Rotate Child
^C^C(defun c:FLIPROT() (hsb_RecalcTslWithKey (_TM "|Flip + Rotate Child|") (_TM "|Select Masterpanel-Manager|"))) FLIPROT
```

## Best Practices

### Design Phase

1. **Plan Master Sizes Early**
   - Determine standard master panel stock sizes
   - Configure Auto Size grid values in settings
   - Set minimum sizes to match smallest available stock

2. **Define Surface Quality Standards**
   - Establish quality grading system (A1, A2, B1, etc.)
   - Configure **Top Face Alignment** strategy
   - Document which faces are premium for your materials

3. **Set Up Style Library**
   - Create MasterPanelStyle.dwg with all panel styles
   - Use consistent naming convention
   - Configure isotropic panel settings if applicable

### Production Phase

1. **Pre-Sort Before Nesting**
   - Group panels by thickness
   - Group by delivery/project if multi-project
   - Use hsbCLT-Presorter for automated sorting

2. **Optimize Nesting Parameters**
   - Start with 1-second Duration, increase if waste high
   - Use Rectangular Nester for speed, AutoNester for quality
   - Enable **Auto Edge Alignment** for manufacturing ease

3. **Validate Before Export**
   - Check waste percentage (target < 15%)
   - Verify all child panels nested (check count)
   - Inspect for thickness inconsistencies

### Manufacturing Phase

1. **Set Feed Directions Consistently**
   - Standardize on X or Y parallel based on CNC setup
   - Document feed direction conventions
   - Verify feed direction written to XRef panels

2. **Write Master Data Before Export**
   - Always run "Add Masterpanel Data to Panels"
   - Verify data written (check child panel MapX)
   - Export CNC data immediately after

3. **Generate Documentation**
   - Configure plot viewports for all required layouts
   - Create plot viewports before releasing to production
   - Verify viewport naming matches master numbering

### Quality Control

1. **Review Nesting Results**
   - Spot-check panel orientations match grain requirements
   - Verify surface quality alignment correct
   - Check oversize allowances appropriate

2. **Monitor Waste Metrics**
   - Track waste percentage per master
   - Identify patterns (certain panels always problematic)
   - Adjust auto-size rules to minimize waste

3. **Validate Export Data**
   - Verify feed direction data in CNC export
   - Check master panel numbers in production labels
   - Ensure delivery sequencing correct

## Frequently Asked Questions

### General Questions

**Q: What's the difference between MasterPanelManager and regular panels?**

A: MasterPanelManager creates "stock panels" (masters) that contain nested "project panels" (children). Regular panels are individual elements. Masters optimize material usage by packing multiple project panels onto standard stock sizes.

---

**Q: Can I use this for materials other than CLT/SIP?**

A: Yes, any panel-based material with defined styles and thicknesses. Configure master styles accordingly. Primarily designed for CLT and SIP but adaptable.

---

**Q: Do I need AutoNester dongle?**

A: No. Rectangular Nester works without dongle and handles most rectangular panel nesting. AutoNester V5 dongle only required for complex shapes with cutouts or if "Nest in openings" needed.

---

### Workflow Questions

**Q: How do I handle panels from multiple projects?**

A: Insert MasterPanelManager → Select panels from all projects → System nests together. Use Presorter with project-based sorting rule to group by project if needed. Multi-project nesting (v5.4+) optimizes across projects.

---

**Q: Can I manually adjust panel positions after nesting?**

A: Yes. Move panels manually, then Right-click → "Nesting" to re-optimize remaining space. Or use "Rotate Child", "Flip Child", "Align panels with edge" for specific adjustments.

---

**Q: How do I create masters with specific numbering?**

A: Set **Start Number** property or configure `MasterStartNumber` in settings before inserting first master. Numbering auto-increments for subsequent masters.

---

**Q: What happens if I change master dimensions after nesting?**

A: Panels remain in current positions. If **Auto Size Mode** = "On", master auto-adjusts after next nesting. If "Off", manually adjust Length/Width properties.

---

### Technical Questions

**Q: Why do some panels show yellow highlights?**

A: Yellow highlights indicate:
- **Beveled edge flip constraint** (v13.3+): Panel cannot flip due to geometry
- **Overcut area intersection** (v14.8+): Panel overlaps master oversize protection zone

Suppress via "Disable oversize warning" if intentional.

---

**Q: How does automatic grain detection work?**

A: System calculates total area of lengthwise-oriented panels vs crosswise. Selects master orientation matching dominant direction (higher total area). Override with manual "Lengthwise" or "Crosswise" if needed.

---

**Q: Can I nest XRef panels?**

A: Yes. XRef panels automatically detected and handled. Feed directions and master data written to XRef source files with automatic lock management.

---

**Q: What's the difference between Waste and BoundingWaste?**

A:
- **Waste**: Based on actual panel shapes (most accurate)
- **BoundingWaste**: Based on panel bounding boxes (simpler calculation)
- **OutterContourWaste** (v14.9+): Based on outer contours

Use Waste for accurate optimization metrics.

---

### Troubleshooting Questions

**Q: Nesting fails with no error - what's wrong?**

A: Check:
1. **Duration** not too short (increase to 5-10 seconds)
2. **Spacing** not too large (panels can't fit)
3. Master dimensions large enough for child panels
4. AutoNester dongle present if AutoNester selected

---

**Q: Why aren't my plot viewports created?**

A: Verify:
1. Right-click → "Configure Plot Viewports" - Layouts marked **Active**
2. Or property **Create Plot Viewports** set before insertion
3. Layouts exist in drawing with correct names

---

**Q: Feed direction disappears after export - why?**

A: Feed direction stored in child panel MapX `CncData.vecRefFeed`. If export system modifies MapX, data may be cleared. Ensure export reads but doesn't overwrite CncData key.

---

**Q: How do I recover if nesting creates too much waste?**

A:
1. Increase **Duration** (e.g., to 10-30 seconds)
2. Try different **Nester Type** (AutoNester vs Rectangular)
3. Manually rotate problem panels, then re-nest
4. Split into multiple masters if panels too varied in size
5. Check **Auto Size Mode** - may be forcing oversized master

---

## Summary

The **hsbCLT-MasterPanelManager** is a comprehensive production tool integrating nesting optimization, material management, and manufacturing data preparation. Key strengths include flexible auto-sizing, multiple nesting algorithms, surface quality control, and seamless integration with CNC/freight/documentation systems.

**When to Use:**
- Optimizing CLT/SIP panel cutting from stock material
- Generating CNC routing data with feed directions
- Managing surface quality requirements
- Integrating with production planning and freight systems

**Best Results:**
- Configure auto-size rules matching your stock sizes
- Use appropriate nesting algorithm for panel complexity
- Pre-sort panels by thickness/quality/project
- Validate waste metrics before releasing to production

**Support Resources:**
- Settings file templates in `<company>\TSL\Settings\`
- Style drawing template: `MasterPanelStyle.dwg`
- Related scripts: hsbCLT-Presorter, hsbGrainDirection
- hsbCAD documentation and support forums
