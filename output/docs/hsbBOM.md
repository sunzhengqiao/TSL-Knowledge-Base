# hsbBOM - Bill of Materials Generator

## Overview

**hsbBOM** is a comprehensive Bill of Materials (BOM) generation tool for timber construction projects in hsbCAD. It creates detailed, customizable material lists with automatic position number annotations displayed directly on drawings. The script operates seamlessly across three different working environments: Model Space (3D design), Paper Space (layouts for printing), and Shop Drawing Multipage mode (fabrication documentation).

This tool is essential throughout the entire timber construction workflow—from initial material estimation and cost calculation to fabrication documentation and logistics planning. It automatically collects data from beams, sheets (panels), and TSL instances (hardware connections), then presents them in a professional table format with intelligent position number placement that avoids visual clutter through automatic collision detection.

**Script Type:** O-Type (Object - Parametric entity that recalculates when referenced entities change)
**Version:** 6.12 (Latest: June 7, 2021)
**Developer:** hsbCAD GmbH
**Major Version:** 6
**Minor Version:** 12

---

## Key Features

### Multi-Environment Support
- **Model Space Mode:** Select any entities (beams, sheets, TSLs) from your 3D model for custom BOMs
- **Paper Space Mode:** Automatically generate BOMs from Element viewports on layout sheets
- **Shop Drawing Multipage Mode:** Create BOMs synchronized with specific shop drawing views

### Intelligent Position Number Display
- **Automatic Collision Detection:** Position numbers shift intelligently to avoid overlapping
- **Multiple Display Modes:** Show position numbers only, sizes only, or combinations
- **Customizable Alignment:** Parallel to world X-axis, parallel to object axis (inside or outside)
- **Background Masking:** Optional boxes with customizable colors that hide underlying geometry for clarity
- **Zone-Based Color Coding:** Different colors for frame (zone 0), positive zones, negative zones, and TSL entities

### Flexible Table Configuration
- **20 Customizable Columns:** Position, Name, Quantity, Length, Width, Height, Material, Grade, Info, Weight, Profile, Label, Sublabel, Type, Cutting Angles (4 types), Net Area, Volume
- **Column Reordering:** Set display order 1-20 or hide columns entirely by setting to 0
- **Adjustable Column Widths:** Independent width control for each column
- **Automatic Sorting:** Sort by any column in ascending or descending order
- **Unit Conversion:** Support for mm, cm, m, inch, feet with configurable decimal places

### Advanced Filtering
- **Material Filter:** Show only entities matching specific materials (partial match, case-insensitive)
- **Exclude Materials:** Exclude multiple materials using semicolon-separated list
- **Label Filter:** Filter by entity labels
- **TSL Filter:** Include only specific TSL types by name (semicolon-separated)
- **Zone Selection:** Complete element, current zone, current zone + frame, or multiple custom zones

### TSL Integration
- **TSLBOM Map Support:** Any TSL can publish data to hsbBOM via standardized Map interface
- **Subpart Listings:** Hierarchical position numbers (e.g., 1.1, 1.2) for TSL components
- **Custom Properties:** TSLs can define Name, Qty, Length, Width, Height, Material, Grade, Info, Profile, Label, Sublabel, Type
- **Automatic Extraction:** TSL entities connected to beams or elements are automatically discovered

### Professional Output
- **Summary Totals:** Automatic calculation of total weight and area when applicable
- **Dimension Styles:** Use existing AutoCAD dimension styles for consistent text formatting
- **Scaling Support:** Scale table and text for different viewport scales
- **Color Customization:** Independent color control for table, position numbers, and TSL position numbers
- **Catalog Insertion:** Support for preset configurations from hsbCAD TSL catalog

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object - Parametric) |
| Beams Required | 0 |
| Points Required | 1 (Insertion point) |
| Insertion Method | Point selection + Entity/Viewport selection |
| Working Spaces | Model Space, Paper Space, Shop Drawing Multipage |
| Recalculation | Automatic when linked entities change |
| Right-Click Commands | Add Entity (Model Space only) |

---

## Prerequisites

### For Model Space Insertion

1. **Entities exist in drawing:**
   - Beams (timber members)
   - Sheets (panels, sheathing)
   - TSL instances (hardware, connections)

2. **Position number assignment:**
   - If beams lack position numbers, they will be automatically assigned starting from 1
   - For best control, assign position numbers before inserting hsbBOM

### For Paper Space Insertion

1. **hsbCAD Element Viewport:**
   - Must exist in your layout
   - Must display a valid hsbCAD element
   - Viewport must contain hsb data

2. **Zone configuration:**
   - Element must have defined zones if using zone-based filtering

### For Shop Drawing Multipage Insertion

1. **Multipage block:**
   - Must be editing within a multipage block definition
   - A valid ShopDrawView entity must exist
   - ViewData must be properly configured

---

## Step-by-Step Usage Guide

### Method 1: Model Space Insertion (Custom Selection)

This method gives you complete control over which entities appear in the BOM.

1. **Launch the script:**
   - From hsbCAD TSL catalog, or
   - Type script name in command line

2. **Configure settings (if dialog appears):**
   - If inserting without catalog preset, a dialog appears
   - Configure desired columns, display options, and filters
   - Click OK to proceed

3. **Pick insertion point:**
   - Command prompt: "Select a point"
   - Click where you want the upper-left corner of the BOM table
   - This becomes the reference point (_Pt0)

4. **Select entities:**
   - Command prompt: "Select Entities"
   - Select beams, sheets, and/or TSL instances
   - Use standard AutoCAD selection methods (window, crossing, individual picks)
   - Press Enter when finished

5. **Automatic processing:**
   - Script excludes certain entity types automatically: HSBEELEMENTSAW, HSBEELEMENTMILL, TEXT, LWPOLYLINE, CIRCLE, AEC_DIMENSION_GROUP
   - Beams without position numbers are automatically assigned numbers starting from 1
   - Entities are sorted and grouped by position number

6. **Result:**
   - BOM table appears at insertion point
   - Position numbers are displayed on each entity with automatic collision avoidance
   - Table updates automatically if you modify linked entities

**Adding entities after insertion:**
1. Select the hsbBOM instance in your drawing
2. Right-click → Choose "Add Entity"
3. Select additional beams, sheets, or TSLs
4. Press Enter to confirm
5. BOM table updates automatically

### Method 2: Paper Space Insertion (Viewport-Based)

This method automatically generates BOMs from Element viewports, perfect for construction documentation.

1. **Prepare layout:**
   - Switch to a Paper Space layout (LAYOUT1, LAYOUT2, etc.)
   - Ensure an hsbCAD Element viewport exists showing your timber element

2. **Launch the script:**
   - From hsbCAD TSL catalog or command line

3. **Pick insertion point:**
   - Click in Paper Space where the BOM table should appear
   - Typically placed adjacent to or below the viewport

4. **Select viewport:**
   - Command prompt: "Select the viewport from which the element is taken"
   - Click on the Element viewport border or inside the viewport

5. **Automatic processing:**
   - Script extracts all beams and sheets from the viewport's element
   - Zone-based filtering applies if configured
   - TSL instances connected to element or beams are automatically included
   - Position numbers are overlaid on viewport entities in correct projection

6. **Result:**
   - BOM table appears in Paper Space
   - Position numbers appear overlaid on viewport content
   - Color coding indicates zone membership (frame, positive zones, negative zones)

**Important notes:**
- The "Add Entity" command is NOT available in Paper Space mode
- Use "Zone selection" property to filter by zones
- Position numbers are projected correctly into 2D viewport view

### Method 3: Shop Drawing Multipage Insertion

This method creates BOMs synchronized with shop drawing views for fabrication documentation.

1. **Open multipage block:**
   - Use BEDIT or equivalent to edit multipage block definition
   - Ensure ShopDrawView entities exist in the block

2. **Launch the script:**
   - From hsbCAD TSL catalog or command line

3. **Review setup graphics (displayed during insertion):**
   - Script name
   - Show PosNum Beams: [current setting]
   - Show PosNum Sheets: [current setting]
   - Show PosNum TSL's: [current setting]

4. **Pick insertion point:**
   - Click where the BOM table should appear within the block

5. **Select view entity:**
   - Command prompt: "Select the view entity from which the module is taken"
   - Click on the ShopDrawView entity

6. **Automatic processing:**
   - Script extracts entities from the specific view's show set
   - View projection is applied for correct 2D representation
   - TSL instances within beams are extracted from sub-assemblies

7. **Result:**
   - BOM table synchronized with the selected shop drawing view
   - Position numbers aligned with view projection
   - Setup graphics disappear after insertion (replaced by actual BOM)

---

## Properties Panel Reference

### General Configuration

#### Drawing space
- **Type:** Dropdown (Read-only after insertion)
- **Options:** model space | paper space | shopdraw multipage
- **Description:** Automatically determined during insertion based on insertion context. Cannot be changed after insertion.
- **Auto-Detection Logic:**
  - If viewport selected → Paper Space
  - If ShopDrawView selected → Shopdraw Multipage
  - Otherwise → Model Space

#### Zone selection
- **Type:** Dropdown
- **Default:** BOM of complete Element
- **Options:**
  - **BOM of complete Element:** All zones included
  - **BOM of current Zone + Frame:** Active zone plus frame (zone 0)
  - **BOM of current Zone:** Only the active zone
  - **BOM of multiple zones:** Custom zone list (requires "Multiple Zones" property)
- **Applies to:** Paper Space and Shop Drawing modes only
- **Read-only in:** Model Space

#### Multiple Zones
- **Type:** Text
- **Default:** (empty)
- **Format:** Semicolon-separated zone indices: "0; 1; 2" or "-1; 0; 1"
- **Valid Range:** -5 to +5
- **Description:** Specify custom zone combinations. Separate multiple entries by semicolon (;).
- **Example:** "0; 2; 3" includes frame, zone 2, and zone 3
- **Activation:** Only applies when "Zone selection" is set to "BOM of multiple zones"
- **Auto-Sync:** If you enter values here, "Zone selection" automatically changes to "BOM of multiple zones"

#### Display BOM
- **Type:** Yes/No
- **Default:** Yes
- **Description:** Toggle table visibility. Always forced to "Yes" in Model Space mode.
- **Use Case:** Set to "No" in Paper Space if you only want position numbers without the table

---

### Position Number Display

#### Show PosNum Beams
- **Type:** Dropdown
- **Default:** Show PosNum
- **Options:**
  1. **Do not show:** Beams excluded from position number display (but remain in table if in BOM)
  2. **Show PosNum:** Display position number only (e.g., "1", "2", "3")
  3. **Show Size:** Display beam cross-section dimensions (e.g., "50x150")
  4. **Show PosNum and Size:** Combined display (e.g., "1 50x150")
  5. **Show Log PosNum:** Display Element-Label-Sublabel2 format (e.g., "E1-A-001") - used for log construction
  6. **Show only in BOM:** Include in table but do not display numbers on drawing
  7. **Show PosNum and Length:** Position number and beam length (e.g., "1 3650")
  8. **Show Length:** Length only (e.g., "3650")
- **Size Calculation:** Cross-section is measured along Element X and Z axes (Width x Height)
- **Impact on Table:** If set to "Do not show," beams will NOT appear in the BOM table

#### Show PosNum Sheets
- **Type:** Dropdown
- **Default:** Show PosNum
- **Options:**
  1. **Do not show:** Sheets excluded from position number display and table
  2. **Show PosNum:** Display position number only
  3. **Show Size:** Display sheet dimensions (e.g., "1220x2440")
  4. **Show PosNum and Size:** Combined display (e.g., "5 1220x2440")
  5. **Show only in BOM:** Include in table but do not display numbers on drawing
  6. **Show Material and Size:** Material name and dimensions (e.g., "OSB/3 12mm 1220x2440")
- **Size Format:** Length x Width
- **Material Display (Option 6):** Shows hsbMaterial property + thickness + dimensions

#### Show PosNum TSL's
- **Type:** Dropdown
- **Default:** Show PosNum
- **Options:**
  1. **Do not show:** TSL instances excluded from position number display and table
  2. **Show PosNum:** Display position number only
  3. **Show Name:** Display TSL name from TSLBOM map
  4. **Show PosNum and Name:** Combined display
  5. **Show only in BOM:** Include in table but do not display numbers on drawing
- **Data Source:** Uses "Name" property from TSLBOM map if available, otherwise uses script name
- **Requirement:** TSL must publish a "TSLBOM" map to be included

#### PosNum Background
- **Type:** Dropdown
- **Default:** Nothing
- **Options:**
  - **Nothing:** No background masking
  - **Show Box:** Draw background box only (no geometry hiding)
  - **Hide Beams:** Background box hides beam geometry
  - **Hide Sheets:** Background box hides sheet geometry
  - **Hide TSLs:** Background box hides TSL geometry
  - **Hide Beams & Sheets:** Background box hides both beams and sheets
  - **Hide Beams & TSLs:** Background box hides beams and TSLs
  - **Hide Sheets & TSLs:** Background box hides sheets and TSLs
  - **Hide All:** Background box hides all entity types
- **Purpose:** Improve position number readability when numbers overlap with geometry
- **Technical:** When hiding is enabled, uses _kDrawFilled flag to create wipeout effect

#### Color Background
- **Type:** Integer
- **Default:** 254
- **Valid Range:** -1 to 255 (AutoCAD Color Index)
- **Description:** Color of position number background box
- **Common Values:**
  - 254: Light gray (default)
  - 255: White
  - 0: Black
  - 7: White/Black (automatic contrast)
- **Added in:** Version 6.9 (July 23, 2018)

#### PosNum Alignment
- **Type:** Dropdown
- **Default:** Parallel X-World
- **Options:**
  1. **Parallel X-World:** Position numbers aligned with World X-axis (horizontal in WCS)
  2. **Parallel on X-Axis of Object (inside):** Aligned with beam/entity local X-axis, placed inside geometry
  3. **Parallel on X-Axis of Object (outside):** Aligned with beam/entity local X-axis, placed outside geometry
- **Use Cases:**
  - Option 1: Standard horizontal text, easiest to read on plan views
  - Option 2: Follows beam direction, useful for sloped members
  - Option 3: Follows beam direction but offset from geometry, clearest for complex assemblies

---

### Table Column Widths

Each column width is independently adjustable. All widths are multiplied by the Scale property for viewport scaling.

| Property | Default | Description |
|----------|---------|-------------|
| **Width Pos** | 100 mm | Column width for position numbers |
| **Width Name** | 150 mm | Column width for names/descriptions |
| **Width Pcs** | 100 mm | Column width for piece count (quantity) |
| **Width Length** | 100 mm | Column width for length dimension |
| **Width Width** | 100 mm | Column width for width dimension |
| **Width Height** | 100 mm | Column width for height/thickness dimension |
| **Width Material** | 100 mm | Column width for material names |
| **Width Grade** | 100 mm | Column width for grade/quality |
| **Width Info** | 100 mm | Column width for additional information |
| **Width Weight** | 100 mm | Column width for weight values |
| **Width Profile** | 100 mm | Column width for profile descriptions |
| **Width Label** | 100 mm | Column width for labels |
| **Width Sublabel** | 100 mm | Column width for sublabels |
| **Width Type** | 100 mm | Column width for type descriptions |
| **Width Angle1** | 100 mm | Column width for cutting angle 1 (negative end) |
| **Width Angle2** | 100 mm | Column width for cutting angle 2 (positive end) |
| **Width Angle1C** | 100 mm | Column width for complementary angle 1 (90° - Angle1) |
| **Width Angle2C** | 100 mm | Column width for complementary angle 2 (90° - Angle2) |
| **Width NetArea** | 100 mm | Column width for net area (sheets only) |
| **Width Volume** | 100 mm | Column width for volume (sheets only) |

**Usage Tips:**
- Increase width for columns with long text (Material, Name)
- Reduce width for numeric columns to save space
- All widths scale proportionally with the Scale property

---

### Column Order Configuration

Control which columns appear and in what order. Set to 0 to hide a column completely.

| Property | Default | Description |
|----------|---------|-------------|
| **Column No. Pos** | 1 | Display order for position numbers (typically first) |
| **Column No. Name** | 2 | Display order for name/description |
| **Column No. Pcs** | 3 | Display order for quantity (piece count) |
| **Column No. Length** | 4 | Display order for length dimension |
| **Column No. Width** | 5 | Display order for width dimension |
| **Column No. Height** | 6 | Display order for height/thickness |
| **Column No. Material** | 7 | Display order for material |
| **Column No. Grade** | 8 | Display order for grade/quality |
| **Column No. Info** | 9 | Display order for additional info |
| **Column No. Weight** | 10 | Display order for weight |
| **Column No. Profile** | 11 | Display order for profile description |
| **Column No. Label** | 12 | Display order for label |
| **Column No. Sublabel** | 13 | Display order for sublabel |
| **Column No. Type** | 14 | Display order for type |
| **Column No. Angle1** | 15 | Display order for angle 1 |
| **Column No. Angle2** | 16 | Display order for angle 2 |
| **Column No. Angle1C** | 17 | Display order for complementary angle 1 |
| **Column No. Angle2C** | 18 | Display order for complementary angle 2 |
| **Column No. NetArea** | 19 | Display order for net area (sheets) |
| **Column No. Volume** | 0 | Display order for volume (hidden by default) |

**Configuration Rules:**
- **Set to 0:** Column is completely hidden (not displayed, no width occupied)
- **Set to 1-20:** Column appears in that position (1 = first/leftmost)
- **Duplicate numbers:** Not recommended - will sort in internal order
- **Gaps in numbering:** Allowed - columns appear in numerical order regardless of gaps

**Examples:**
- Hide all dimension columns: Set Length, Width, Height to 0
- Create minimal BOM: Pos=1, Pcs=2, Material=3, all others=0
- Swap position/name order: Pos=2, Name=1
- Show only structural info: Pos=1, Name=2, Length=3, Material=4, Grade=5, all others=0

---

### Sorting Options

#### Sort column
- **Type:** Dropdown
- **Default:** Pos
- **Options:** Pos | Name | Pcs | Length | Width | Height | Material | Grade | Info | Weight | Profile | Label | Sublabel | Type | Angle1 | Angle2 | Angle1C | Angle2C | NetArea | Volume
- **Description:** Determines which column is used for sorting the BOM rows
- **Sorting Logic:**
  - **Beams:** Sorted by selected column
  - **Sheets:** Sorted by selected column
  - **TSLs:** First sorted by position number, then by selected column if the TSL's TSLBOM map contains that property
- **Data Type Awareness:** Numeric columns sort numerically, text columns sort alphabetically

#### Sort mode
- **Type:** Dropdown
- **Default:** Ascending
- **Options:** Ascending | Descending
- **Description:** Sort direction for the selected column
- **Ascending:** A→Z, 0→9, smallest to largest
- **Descending:** Z→A, 9→0, largest to smallest

**Sorting Behavior Details:**
- Entities with the same position number are grouped together (quantity aggregated)
- Within each entity type, sorting applies
- TSLs that lack the sort column property appear after sortable TSLs
- Empty values typically sort to the end in ascending mode

---

### Text and Display Options

#### Dimstyle
- **Type:** Dropdown
- **Options:** All dimension styles defined in the drawing
- **Description:** Dimension style used for table text formatting
- **Controls:** Text font, text height multiplier, text style
- **Default:** Current active dimension style

#### Scale
- **Type:** Double
- **Default:** 1
- **Description:** Global scale factor applied to the entire table and all text
- **Calculation:** All column widths and text heights are multiplied by this value
- **Use Cases:**
  - **Paper Space:** Match viewport scale (e.g., 0.01 for 1:100 scale)
  - **Model Space:** Usually 1 unless working at a specific drawing scale
  - **Large-format prints:** Increase for better readability
- **Example:** Scale=0.5 makes a table half the size, Scale=2 doubles the size

#### character size
- **Type:** Double
- **Default:** 17 mm
- **Description:** Base text height for table content
- **Actual Height:** character size × Scale
- **Impact:** Affects row height and position number text size
- **Recommendation:** 15-20 mm for standard A3/A1 drawings at 1:1 scale

#### Unit
- **Type:** Dropdown
- **Default:** mm
- **Options:** mm | cm | m | inch | feet
- **Description:** Linear dimension unit for Length, Width, Height columns
- **Conversion:** All dimension values from entities are automatically converted to selected unit
- **Display:** Unit abbreviation is NOT shown in table cells

#### Decimals
- **Type:** Integer
- **Default:** 0
- **Range:** 0-4
- **Description:** Number of decimal places for length dimensions
- **Examples:**
  - 0 decimals: "3650" mm
  - 1 decimal: "3650.0" mm
  - 2 decimals: "3650.00" mm

#### Unit Area
- **Type:** Dropdown
- **Default:** mm²
- **Options:** mm² | cm² | m² | inch² | feet²
- **Description:** Area unit for NetArea column (sheets only)
- **Application:** Only applies to sheet entities
- **Automatic Totaling:** Sum of areas appears at bottom of table when NetArea column is visible

#### Decimals Area
- **Type:** Integer
- **Default:** 0
- **Range:** 0-4
- **Description:** Number of decimal places for area values (sheets only)
- **Application:** Only affects NetArea column display

#### Color
- **Type:** Integer
- **Default:** 171
- **Valid Range:** -1 to 255 (AutoCAD Color Index)
- **Description:** Color for table lines and text
- **Auto-Restriction:** Values outside -1 to 255 are automatically reset to 171
- **Common Values:**
  - 171: Neutral gray (default)
  - 7: White/Black (auto contrast)
  - 1-9: Basic colors (red, yellow, green, cyan, blue, magenta, white, dark gray, light gray)

#### Dimstyle PosNum
- **Type:** Dropdown
- **Options:** All dimension styles defined in the drawing
- **Description:** Dimension style used for position number text on drawing
- **Default:** Current active dimension style
- **Independence:** Can be different from main table Dimstyle

#### Color TSL PosNum
- **Type:** Integer
- **Default:** 143
- **Valid Range:** -1 to 255
- **Description:** Color specifically for TSL position numbers on drawing
- **Auto-Restriction:** Values outside -1 to 255 are automatically reset to 143
- **Purpose:** Distinguish TSL position numbers from beam/sheet position numbers

---

### Filtering Options

#### Filter TSL
- **Type:** Text
- **Default:** (empty)
- **Format:** Semicolon-separated TSL script names
- **Case Sensitivity:** Case-insensitive (automatically converted to uppercase)
- **Description:** Include ONLY TSLs whose script names match one of the specified names
- **Example:** "Simpson StrongTie Anchor; BMF Balkenschuh; GA" includes only these three TSL types
- **Matching:** Exact name match required
- **Empty Value:** All TSLs with TSLBOM maps are included

#### Filter Material
- **Type:** Text
- **Default:** (empty)
- **Case Sensitivity:** Case-insensitive
- **Matching:** Partial match - entity material contains the filter text
- **Description:** Show only entities whose material name contains this text
- **Example:** "GL24" shows all GL24 glulam beams, "OSB" shows all OSB sheets
- **Empty Value:** No material filtering applied
- **Applies to:** Beams and sheets

#### Filter Label
- **Type:** Text
- **Default:** (empty)
- **Case Sensitivity:** Case-insensitive
- **Matching:** Partial match - entity label contains the filter text
- **Description:** Show only entities whose label contains this text
- **Example:** "R-" shows only roof beams if labeled "R-1", "R-2", etc.
- **Empty Value:** No label filtering applied
- **Applies to:** Beams and sheets

#### Exclude Material
- **Type:** Text
- **Default:** (empty)
- **Format:** Semicolon-separated material names
- **Case Sensitivity:** Case-insensitive
- **Description:** Exclude entities whose material name contains ANY of the specified texts
- **Example:** "OSB; Gypsum; Insulation" excludes all non-structural materials
- **Matching:** Partial match - if entity material contains any excluded text, it's filtered out
- **Priority:** Exclusion filter applied AFTER inclusion filter
- **Empty Value:** No exclusion filtering applied

**Filter Combination Logic:**
1. Filter Material (inclusion) - if specified, ONLY matching materials pass
2. Filter Label (inclusion) - if specified, ONLY matching labels pass
3. Exclude Material (exclusion) - if specified, matching materials are removed
4. Filter TSL (inclusion) - if specified, ONLY matching TSL names pass
5. All filters combine with AND logic

---

### Advanced Options

#### Offset Factor
- **Type:** Double
- **Default:** 3
- **Description:** Collision detection offset distance multiplier
- **Calculation:** When position numbers collide, they shift by (Offset Factor × text height)
- **Behavior:** Higher values create larger gaps between overlapping position numbers
- **Typical Range:** 1-5
- **Use Cases:**
  - 1-2: Tight spacing, minimal shifting
  - 3: Balanced spacing (default)
  - 4-5: Large gaps, maximum clarity for dense assemblies

#### Switch to Complementary Angle
- **Type:** Yes/No
- **Default:** No
- **Description:** Display complementary cutting angles instead of actual angles
- **Calculation:** Complementary Angle = 90° - Actual Angle
- **Use Case:** Some fabrication shops prefer complementary angle notation
- **Affects Columns:** Angle1C and Angle2C (complementary versions of Angle1 and Angle2)
- **Standard Angles:**
  - Angle1: Cutting angle at beam negative end
  - Angle2: Cutting angle at beam positive end
  - Angle1C: 90° - Angle1
  - Angle2C: 90° - Angle2

#### Use solid size
- **Type:** Yes/No
- **Default:** No
- **Description:** Use actual solid dimensions instead of nominal beam dimensions
- **Comparison:**
  - **No (nominal):** Beam profile dimensions (e.g., 50x150 for a 50x150 beam)
  - **Yes (solid):** Actual measured dimensions after cutting/planing (may be 49x148)
- **Affects:** Length, Width, Height columns for beams
- **Use Case:** Enable for exact fabrication dimensions; disable for nominal ordering dimensions

---

## Right-Click Context Menu

### Add Entity (Model Space Only)

**Command:** Add Entity
**Availability:** Model Space only (disabled in Paper Space and Shop Drawing modes)
**Function:** Add additional entities to an existing BOM

**Usage:**
1. Select the hsbBOM instance in Model Space
2. Right-click on the entity
3. Choose "Add Entity" from context menu
4. Select additional beams, sheets, or TSL instances
5. Press Enter to confirm selection

**Behavior:**
- Newly selected entities are appended to the BOM
- Duplicate entities are ignored (if already in BOM)
- Beams without position numbers are automatically assigned numbers starting from 1
- Table and position numbers update immediately
- Collision detection re-runs for all position numbers

**Limitations:**
- NOT available in Paper Space (entities determined by viewport)
- NOT available in Shop Drawing mode (entities determined by ShopDrawView)

---

## TSL Integration - TSLBOM Map Interface

The hsbBOM script can display data from any TSL that publishes information via the **TSLBOM Map**. This creates a standardized interface for hardware connectors, fasteners, and custom components to appear in bills of materials.

### Publishing Data to hsbBOM (For TSL Developers)

To make a TSL appear in hsbBOM, create a Map called "TSLBOM" in your TSL's _Map:

```c
// In your TSL script:
Map mapBOM;
mapBOM.setString("Name", "Simpson Strong-Tie HTT4");
mapBOM.setInt("Qty", 2);
mapBOM.setDouble("Length", U(150));
mapBOM.setDouble("Width", U(80));
mapBOM.setDouble("Height", U(50));
mapBOM.setString("Mat", "Steel");
mapBOM.setString("Grade", "G90 Galvanized");
mapBOM.setString("Info", "Heavy Tension Tie");
mapBOM.setString("Profile", "L-Shape");
mapBOM.setString("Label", "HW");
mapBOM.setString("Sublabel", "TT");
mapBOM.setString("Type", "Tension Connector");
mapBOM.setInt("Iconside", 0); // Zone index for visibility control

_Map.setMap("TSLBOM", mapBOM);
```

### TSLBOM Map Properties

| Key | Type | Description | Required |
|-----|------|-------------|----------|
| **Name** | String | Display name in BOM table | Recommended |
| **Qty** | Integer | Quantity of this item | Default: 1 |
| **Length** | Double | Length dimension (in current drawing units) | Optional |
| **Width** | Double | Width dimension | Optional |
| **Height** | Double | Height/thickness dimension | Optional |
| **Mat** | String | Material name | Optional |
| **Grade** | String | Grade/quality specification | Optional |
| **Info** | String | Additional information | Optional |
| **Profile** | String | Profile description | Optional |
| **Label** | String | Label text | Optional |
| **Sublabel** | String | Sublabel text | Optional |
| **Type** | String | Type description | Optional |
| **Iconside** | Integer | Zone index (-5 to +5) for visibility control in Paper Space | Default: 0 |

### Subpart Listings

TSLs can include hierarchical subpart listings using the **TslShop/parts** map structure:

```c
// In your TSL script - example for a connector with bolts and washers:
Map mapParts;

// Subpart 1: Bolt
Map mapBolt;
mapBolt.setString("Name", "M12x80 Bolt");
mapBolt.setInt("Qty", 4); // 4 bolts per connector
mapBolt.setDouble("Length", U(80));
mapBolt.setString("Mat", "Steel Grade 8.8");
mapBolt.setString("Type", "Hex Bolt");
mapBolt.setInt("subPosNum", 1); // Optional custom sub-position
mapParts.setMap(0, mapBolt);

// Subpart 2: Washer
Map mapWasher;
mapWasher.setString("Name", "M12 Washer");
mapWasher.setInt("Qty", 8); // 8 washers per connector (2 per bolt)
mapWasher.setDouble("Width", U(24)); // Outer diameter
mapWasher.setDouble("Height", U(2.5)); // Thickness
mapWasher.setString("Mat", "Steel");
mapWasher.setInt("subPosNum", 2);
mapParts.setMap(1, mapWasher);

Map mapShop;
mapShop.setMap("parts", mapParts);
_Map.setMap("TslShop", mapShop);
```

**Subpart Display:**
- Main TSL entry shows in BOM with its position number (e.g., "5")
- Subparts show with hierarchical numbering (e.g., "5.1", "5.2")
- If `subPosNum` is provided, it's used; otherwise auto-incremented
- Subpart quantities are multiplied by parent quantity

**Example Output:**
```
Pos  Name                     Pcs  Length  Material
5    Simpson HTT4             2    -       Steel
5.1  M12x80 Bolt             8    80      Steel Grade 8.8
5.2  M12 Washer              16   -       Steel
```

### Visibility and Zone Control

The **Iconside** property controls visibility in Paper Space zone-based filtering:

- **0:** Frame zone - visible when frame is included
- **1 to 5:** Positive zones - visible when that zone is included
- **-1 to -5:** Negative zones - visible when that zone is included

This allows TSLs to be associated with specific zones of a multi-zone element.

---

## Position Number Display System

The hsbBOM script features an intelligent position number placement system with automatic collision detection and customizable display modes.

### Collision Detection Algorithm

**How it works:**

1. **Initial Placement:** Position number placed at midpoint of entity's extent in the view direction
2. **Bounding Box Creation:** Rectangle created around text based on text length and height
3. **Collision Test:** New bounding box tested against all existing position number boxes
4. **Iterative Shifting:** If collision detected, position shifts along entity axis
5. **Alternating Direction:** Shifts alternate between positive and negative directions with increasing distance
6. **Maximum Iterations:** Up to 20 attempts to find non-overlapping position
7. **Shift Distance:** Each shift = Offset Factor × text height

**Shift Pattern:**
```
Attempt 1: +1 × offset
Attempt 2: -2 × offset
Attempt 3: +3 × offset
Attempt 4: -4 × offset
... (continues up to 20 iterations)
```

### Position Number Color Coding

Position numbers use different colors to indicate zone membership in Paper Space:

| Entity Location | Color Index | Description |
|----------------|-------------|-------------|
| Frame (Zone 0) | 38 | Default frame color (dark gray) |
| Positive Zones (+1 to +5) | 82 | Light green |
| Negative Zones (-1 to -5) | 5 | Blue |
| TSL Entities | 143 (configurable) | Set by "Color TSL PosNum" property |
| Company-Specific (Rubner Haus) | Uses table color | Special handling for specific projects |

**Override for filled backgrounds:**
- When background masking is enabled (Hide Beams/Sheets/TSLs), text color changes to 250 (near-black) for contrast
- Box background uses "Color Background" property

### Alignment Modes Explained

#### Parallel X-World (Default)
- Position numbers always horizontal relative to World Coordinate System
- Text reads from left to right on standard plan views
- Best for: Plan views, elevations with horizontal orientation
- Rotation: 0° regardless of entity orientation

#### Parallel on X-Axis of Object (inside)
- Position numbers align with entity's local X-axis
- Text follows beam/entity direction
- Placed inside the entity's geometry extent
- Best for: Isometric views, sloped members, complex 3D assemblies
- Rotation: Matches entity's angle in view

#### Parallel on X-Axis of Object (outside)
- Position numbers align with entity's local X-axis
- Text follows beam/entity direction
- Offset OUTSIDE the entity's geometry extent by entity height/2
- Best for: Dense assemblies where internal labels overlap
- Rotation: Matches entity's angle in view
- Offset Calculation: Shifts perpendicular to beam axis by entity cross-section height

### Display Mode Details

#### Beams - Size Display
- **Format:** Width × Height (cross-section dimensions)
- **Measurement:** Along Element coordinate system X and Z axes
- **Units:** Converted to selected Unit property
- **Example:** "50x150" for a 50mm × 150mm beam

#### Beams - Length Display
- **Source:** `solidLength()` method (actual length after cutting)
- **Units:** Converted to selected Unit property
- **Format:** Follows Dimstyle PosNum formatting
- **Example:** "3650" for a 3650mm beam

#### Beams - Log PosNum Format
- **Format:** `Element.number - Label - Sublabel2`
- **Example:** "E1-A-001" for Element 1, Label "A", Sublabel2 "001"
- **Use Case:** Log cabin construction with sequential log numbering

#### Sheets - Size Display
- **Format:** Length × Width
- **Source:** `solidLength()` and `solidWidth()` methods
- **Example:** "1220x2440" for a 1220mm × 2440mm sheet

#### Sheets - Material and Size
- **Format:** `Material Thickness Length×Width`
- **Example:** "OSB/3 12 1220x2440"
- **Components:**
  - Material: From `hsbMaterial` property
  - Thickness: Sheet height (dH) rounded to 0.1mm
  - Size: Length × Width

#### TSLs - Name Display
- **Source:** "Name" property from TSLBOM map
- **Fallback:** If no TSLBOM map or Name property, uses TSL script name
- **Example:** "Simpson StrongTie HTT4"

---

## Table Generation Details

### Column Types and Data Sources

#### Beams

| Column | Data Source | Notes |
|--------|-------------|-------|
| Pos | `posnum()` | Auto-assigned if missing |
| Name | `name()` | Beam name property |
| Pcs | Aggregated count | Beams with same posnum grouped |
| Length | `solidLength()` | Actual length after cutting |
| Width | `dD(Element X-axis)` | Cross-section width |
| Height | `dD(Element Z-axis)` | Cross-section height |
| Material | `name("material")` | Material property |
| Grade | `name("grade")` | Grade property |
| Info | `name("information")` | Information property |
| Weight | Not calculated for beams | Reserved for future use |
| Profile | `extrusionProfile()` name | Profile shape name |
| Label | `label()` | Label property |
| Sublabel | `subLabel()` | Sublabel property |
| Type | Fixed: "Beam" | Entity type identifier |
| Angle1 | `startCutAngle()` | Negative end cutting angle |
| Angle2 | `endCutAngle()` | Positive end cutting angle |
| Angle1C | 90° - Angle1 | Complementary angle |
| Angle2C | 90° - Angle2 | Complementary angle |

#### Sheets

| Column | Data Source | Notes |
|--------|-------------|-------|
| Pos | `posnum()` | Position number |
| Name | `name()` | Sheet name |
| Pcs | Aggregated count | Sheets with same posnum grouped |
| Length | `dL()` | Length dimension |
| Width | `dW()` | Width dimension |
| Height | `dH()` | Thickness |
| Material | `name("material")` | Material property |
| Grade | `name("grade")` | Grade property |
| Info | `name("information")` | Information property |
| Weight | Not calculated | Reserved |
| Profile | Not used | N/A for sheets |
| Label | `name("label")` | Label property |
| Sublabel | `name("sublabel")` | Sublabel property |
| Type | Fixed: "Sheet/Lath" | Entity type identifier |
| NetArea | `profShape().area() × Pcs` | Total area, summed at bottom |
| Volume | `volume()` | Sheet volume |

#### TSL Instances

| Column | Data Source | Notes |
|--------|-------------|-------|
| Pos | `posnum()` | Position number |
| Name | TSLBOM map: "Name" | From published TSLBOM map |
| Pcs | TSLBOM map: "Qty" × grouped count | Quantity × instances |
| Length | TSLBOM map: "Length" | Optional dimension |
| Width | TSLBOM map: "Width" | Optional dimension |
| Height | TSLBOM map: "Height" | Optional dimension |
| Material | TSLBOM map: "Mat" | Material name |
| Grade | TSLBOM map: "Grade" | Grade specification |
| Info | TSLBOM map: "Info" | Additional information |
| Weight | TSLBOM map: "Weight" | Weight value, summed at bottom |
| Profile | TSLBOM map: "Profile" | Profile description |
| Label | TSLBOM map: "Label" | Label text |
| Sublabel | TSLBOM map: "Sublabel" | Sublabel text |
| Type | TSLBOM map: "Type" | Type description |

### Sorting Implementation

**Multi-Stage Sorting Process:**

1. **Beams:**
   - Primary: Sort by position number
   - Secondary: Group identical position numbers (aggregate quantity)
   - Tertiary: Sort groups by selected sort column

2. **Sheets:**
   - Same as beams

3. **TSLs:**
   - Primary: Sort by position number
   - Secondary: Check if TSLBOM map contains sort column property
   - Tertiary: Sort TSLs with property by selected column
   - Quaternary: Append TSLs without property at end

**Data Type Handling:**
- Integer columns: Numeric comparison
- Double columns: Numeric comparison with floating-point precision
- String columns: Alphabetical comparison (case-sensitive)

### Summary Row Generation

Automatic summary totals appear at the bottom of the table when applicable:

**Weight Column:**
- Displays when: Column No. Weight > 0 AND at least one entity has weight data
- Calculation: Sum of all weight values
- Format: Decimal with 1 decimal place
- Sources: TSL TSLBOM maps (beams and sheets do not contribute)

**NetArea Column:**
- Displays when: Column No. NetArea > 0 AND at least one sheet exists
- Calculation: Sum of (sheet profile area × quantity)
- Format: Decimal with configured decimal places (Decimals Area property)
- Units: Converted to Unit Area property
- Sources: Sheet entities only (beams and TSLs do not contribute)

---

## Catalog-Based Insertion

The hsbBOM script supports **catalog-based insertion**, allowing you to create preset configurations in the hsbCAD TSL catalog.

### How It Works

1. **Catalog Configuration:**
   - Create catalog entry with predefined property values
   - Assign an execution key to the catalog entry

2. **Insertion Behavior:**
   - If inserted from catalog: Dialog is suppressed, catalog properties applied
   - If inserted manually: Dialog appears (unless _kExecuteKey is set)
   - If inserted by another TSL: Properties can be passed via _Map with "catalogEntry" key

3. **Property Transfer:**
   ```c
   // In another TSL inserting hsbBOM:
   Map mapTransfer;
   mapTransfer.setString("catalogEntry", "MyCatalogKey");
   TslInst bomInst;
   bomInst.dbCreate("hsbBOM", _Pt0);
   bomInst.setMap(mapTransfer);
   ```

### Advantages

- **Consistency:** Standardized BOM formats across projects
- **Efficiency:** No dialog interaction needed for common configurations
- **Automation:** Other TSLs can insert pre-configured BOMs programmatically

### Common Catalog Presets

**Structural BOM (Frame Members Only):**
- Show Columns: Pos, Pcs, Length, Width, Height, Material, Grade
- Filter: Exclude Materials: "OSB; Gypsum; Insulation"
- Sort: Material (Ascending)

**Hardware BOM (TSLs Only):**
- Show Columns: Pos, Name, Pcs, Type, Material
- Show PosNum Beams: Do not show
- Show PosNum Sheets: Do not show
- Sort: Type (Ascending)

**Complete Assembly BOM:**
- Show Columns: All 20 columns visible
- Sort: Pos (Ascending)
- Zone selection: BOM of complete Element

---

## Performance Optimization

### Version 6.8 Enhancement (September 19, 2016)

**Improvement:** Replaced `realBody()` with `envelopeBody(false, true)` for shadow profile extraction.

**Impact:**
- Dramatically faster BOM generation for complex elements
- Reduced memory usage
- Maintains accurate position number placement

**Technical Details:**
- `realBody()`: Generates full ACIS solid geometry (slow, memory-intensive)
- `envelopeBody(false, true)`: Generates simplified bounding envelope (fast, efficient)
- `shadowProfile()`: Extracts 2D profile from envelope for position number placement

### Best Practices for Large Projects

1. **Use Zone Filtering:**
   - Generate separate BOMs for each zone instead of complete element
   - Reduces entity count per BOM instance

2. **Minimize Columns:**
   - Hide unused columns (set Column No. to 0)
   - Fewer columns = faster table generation

3. **Strategic Position Number Display:**
   - Use "Show only in BOM" for dense assemblies
   - Reduces collision detection calculations

4. **Filter Early:**
   - Apply Material and Label filters to reduce processed entities
   - Smaller data set = faster sorting and display

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: Position numbers overlap despite collision detection

**Causes:**
- Very dense assembly with limited space
- Offset Factor too small
- Text size too large relative to entity spacing

**Solutions:**
1. Increase Offset Factor to 4 or 5
2. Reduce character size
3. Use "Parallel on X-Axis of Object (outside)" alignment
4. Enable background masking with "Hide All" option
5. Consider "Show only in BOM" for some entity types

#### Issue: Entities not appearing in BOM

**Causes:**
- Not selected during Model Space insertion
- Filtered out by Material, Label, or TSL filters
- Outside selected zones in Paper Space
- TSL lacks TSLBOM map
- Show PosNum set to "Do not show"

**Solutions:**
1. Use "Add Entity" command (Model Space only)
2. Check Filter Material, Filter Label, Exclude Material properties - clear if needed
3. Change Zone selection to "BOM of complete Element"
4. Verify TSL publishes TSLBOM map (check TSL source code)
5. Change Show PosNum settings to display entities

#### Issue: Position numbers display incorrectly for sloped beams

**Causes:**
- Using version prior to 6.3
- Incorrect viewport projection in Paper Space

**Solutions:**
1. Upgrade to version 6.3 or later (fixed May 10, 2014)
2. Verify Element viewport is properly configured
3. Check that CoordSys transformation is valid

#### Issue: Cannot add entities after insertion

**Causes:**
- BOM inserted in Paper Space (Add Entity disabled)
- BOM inserted in Shop Drawing mode (Add Entity disabled)
- Not selecting the hsbBOM instance

**Solutions:**
1. Verify "Drawing space" property shows "model space"
2. Ensure you right-click on the BOM instance itself
3. In Paper Space: Must re-insert BOM or modify viewport content
4. In Shop Drawing mode: Modify ShopDrawView content

#### Issue: Table appears too small/large in Paper Space

**Causes:**
- Scale property not matched to viewport scale
- Viewport scale changed after BOM insertion

**Solutions:**
1. Calculate correct Scale value: viewport scale factor (e.g., 1:100 = 0.01)
2. Adjust Scale property to match viewport
3. Consider adjusting character size as well

#### Issue: Cutting angles show as 0 or blank

**Causes:**
- Beam ends are perpendicular (90° cut = 0° angle)
- Beam cuts not defined in beam tool data
- Using complementary angles when actual angles are expected

**Solutions:**
1. Verify beam has angled cuts applied (use BeamCut or other cutting tools)
2. Check beam start/end cut definitions
3. Toggle "Switch to Complementary Angle" property
4. Use Angle1C/Angle2C columns if complementary values needed

#### Issue: TSL subparts not appearing

**Causes:**
- TSL doesn't publish TslShop/parts map structure
- Subpart map indices incorrect
- TSL not visible due to zone filtering

**Solutions:**
1. Verify TSL source code publishes parts map correctly
2. Check map indices are sequential (0, 1, 2, ...)
3. Check Iconside property in TSL TSLBOM map
4. Enable "BOM of complete Element" to see all zones

#### Issue: Zone selection property is disabled

**Causes:**
- BOM inserted in Model Space (zone selection only applies to Paper Space/Shop Drawing)

**Solutions:**
1. This is normal behavior - zone selection is read-only in Model Space
2. Use Material/Label filters in Model Space instead
3. For zone-based BOMs, insert in Paper Space

---

## Workflow Examples

### Example 1: Complete Element BOM for Estimation

**Objective:** Generate a comprehensive material list for cost estimation

**Steps:**
1. Insert hsbBOM in Model Space
2. Select all beams and sheets in the element
3. Configure properties:
   - Show Columns: Pos, Name, Pcs, Length, Width, Height, Material, Grade, Weight
   - Sort column: Material
   - Sort mode: Ascending
   - Show PosNum Beams: Show only in BOM
   - Show PosNum Sheets: Show only in BOM
4. Export table data to Excel for costing

**Result:** Clean table grouped by material type without position numbers cluttering the 3D model.

### Example 2: Fabrication Shop Drawing with Zone-Specific BOM

**Objective:** Create a fabrication drawing for wall zone 1 with position-numbered BOM

**Steps:**
1. Create Paper Space layout
2. Insert Element viewport showing zone 1
3. Set viewport scale to 1:50
4. Insert hsbBOM in Paper Space
5. Select the Element viewport
6. Configure properties:
   - Zone selection: BOM of current Zone
   - Scale: 0.02 (to match 1:50 viewport)
   - Show Columns: Pos, Pcs, Length, Width, Material
   - Show PosNum Beams: Show PosNum and Size
   - Show PosNum Sheets: Show Size
   - PosNum Alignment: Parallel on X-Axis of Object (outside)
7. Print to PDF

**Result:** Professional shop drawing with clear position numbers and concise BOM table.

### Example 3: Hardware-Only BOM for Purchasing

**Objective:** Generate a purchase order list of all hardware connectors

**Steps:**
1. Insert hsbBOM in Model Space
2. Select element entities (beams will have connected TSLs)
3. Configure properties:
   - Show Columns: Pos, Name, Pcs, Type, Material, Info
   - Show PosNum Beams: Do not show
   - Show PosNum Sheets: Do not show
   - Show PosNum TSL's: Show only in BOM
   - Sort column: Name
   - Sort mode: Ascending
4. Review table for hardware items only

**Result:** Clean list of only TSL hardware with quantities, no structural members.

### Example 4: Multi-Zone Combined BOM

**Objective:** Generate BOM for frame and two exterior wall zones

**Steps:**
1. Insert hsbBOM in Paper Space
2. Select Element viewport
3. Configure properties:
   - Zone selection: BOM of multiple zones
   - Multiple Zones: "0; 1; 2"
   - Show Columns: Pos, Name, Pcs, Length, Material, Label
   - Sort column: Label
   - Exclude Material: "Insulation; Gypsum"
4. Position numbers display in different colors for each zone

**Result:** Combined BOM showing frame and specified zones with zone-based color coding.

### Example 5: Sheet Material Takeoff with Area Totals

**Objective:** Calculate total sheet material area for ordering

**Steps:**
1. Insert hsbBOM in Model Space
2. Select all sheet entities (OSB, plywood, etc.)
3. Configure properties:
   - Show Columns: Pos, Name, Pcs, Length, Width, Height, Material, NetArea
   - Column No. NetArea: 8 (display it)
   - Unit Area: m²
   - Decimals Area: 2
   - Sort column: Material
   - Show PosNum Sheets: Show Material and Size
4. Check summary row at bottom for total area

**Result:** Material list with area per sheet type and total area in m² for purchasing.

---

## Technical Details

### Coordinate System Transformations

**Model Space to Paper Space:**
```c
CoordSys ms2ps = viewport.coordSys();
// Transform points: point.transformBy(ms2ps)
// Transform vectors: vector.transformBy(ms2ps)
```

**Paper Space to Model Space:**
```c
CoordSys ps2ms = ms2ps;
ps2ms.invert();
// Transform back: point.transformBy(ps2ms)
```

**Shop Drawing View:**
```c
ViewData vwData = arViewData[nIndFound];
CoordSys ms2ps = vwData.coordSys();
Vector3d vecView = ps2ms.vecZ(); // View direction
```

### Shadow Profile Extraction

**Purpose:** Create 2D profile of 3D entity for position number placement

**Method:**
```c
GenBeam gbX;
Plane viewPlane(el.ptOrg(), el.coordSys().vecZ());
PlaneProfile ppSection = gbX.envelopeBody(false, true).shadowProfile(viewPlane);
ppSection.transformBy(ms2ps); // Project to paper space
```

**Performance:** `envelopeBody(false, true)` is significantly faster than `realBody()` for large assemblies.

### Extent Calculation

**Finding position number placement point:**
```c
Vector3d vec = beam.vecX();
vec.transformBy(ms2ps);
vec.normalize();
LineSeg lsEnt = ppSection.extentInDir(vec);
Point3d ptPosNum = lsEnt.ptMid();
```

**Extent Direction:**
- Beams: Along beam local X-axis
- Sheets: Along World Y-axis
- TSLs: Along TSL local X-axis (with Z-parallel check)

### Entity Type Detection

**Excluded Types (Model Space):**
```c
String sExcludeList[] = {
    "HSBEELEMENTSAW",    // Element saw cut tools
    "HSBEELEMENTMILL",   // Element mill tools
    "TEXT",              // AutoCAD text
    "LWPOLYLINE",        // Lightweight polyline
    "CIRCLE",            // Circle
    "AEC_DIMENSION_GROUP" // AEC dimension groups
};
```

**Type Checking:**
```c
if (ent.bIsKindOf(Beam()))      // Timber beam
if (ent.bIsKindOf(Sheet()))     // Panel/sheet
if (ent.bIsKindOf(TslInst()))   // TSL instance
if (ent.bIsKindOf(GenBeam()))   // Generic beam (includes Beam and Sheet)
if (ent.bIsKindOf(Element()))   // Complete element
if (ent.bIsKindOf(ShopDrawView())) // Shop drawing view
```

---

## Related Scripts

### Complementary BOM and Documentation Tools

| Script | Purpose | Relationship to hsbBOM |
|--------|---------|------------------------|
| **hsbScheduleTable** | Generic schedule table generator | Similar table format, different data source |
| **hsbViewTag** | View tags and labels | Complements BOM with view identification |
| **HSB_G-BillOfMaterial** | Alternative BOM generator | Different feature set, similar purpose |
| **hsbLayoutTag** | Layout annotation | Labels for drawings containing BOMs |
| **StackPack** | Material stacking and packaging | Uses BOM data for logistics planning |
| **f_Package** | Package management | Organizes materials from BOM for shipping |
| **f_Truck** | Truck loading | Logistics based on BOM quantities |

### TSL Scripts with TSLBOM Support

The following TSL scripts publish data to hsbBOM via TSLBOM maps:

**Hardware/Fasteners:**
- Simpson StrongTie series (Simpson StrongTie Anchor, BT, EL, etc.)
- BMF series (BMF Balkenschuh, U Shoe, etc.)
- Rothoblaas series (WHT, Titan, ALU, etc.)
- Generic angle brackets (GA, GA-T, etc.)
- Hilti series (Hilti-P2P, Hilti-Verankerung, etc.)

**CLT Connectors:**
- hsbCLT-X-Fix-Connector
- hsbCLT-T-Connector
- hsbCLT-ProfileConnection

**General:**
- Most modern TSL hardware scripts (check script documentation)

### Workflow Integration

**Typical Workflow Chain:**
1. **Design Phase:** Create Element with beams, sheets, TSLs
2. **Documentation Phase:** Insert hsbBOM in Paper Space layouts
3. **Fabrication Phase:** Generate shop drawings with zone-specific BOMs
4. **Logistics Phase:** Use StackPack/f_Package with BOM data
5. **Production Phase:** Use BOM for CNC programming and material preparation

---

## Version History Summary

| Version | Date | Key Changes |
|---------|------|-------------|
| **6.12** | June 7, 2021 | Merged contentDACH changes, added background color property |
| **6.9** | July 23, 2018 | Added "Color Background" property for posnum box |
| **6.8** | Sep 19, 2016 | Performance improvement: envelopeBody instead of realBody |
| **6.7** | Sep 19, 2016 | Sheet material can be shown with size |
| **6.6** | Feb 5, 2015 | Allow multiple materials to be filtered |
| **6.5** | Jan 30, 2015 | Bugfix on posnum display for genbeams in shop drawings |
| **6.4** | Jan 29, 2015 | Element filters work in shop drawings, extracted TSLs from beams |
| **6.3** | May 10, 2014 | Posnum offset for sloped beams corrected |
| **6.2** | May 16, 2012 | TSL validation added |
| **6.1** | Jan 26, 2012 | Remove blank spaces in complementary angles with 0 decimals |
| **6.0** | Dec 12, 2011 | Catalog-based insertion support, automatic posnum assignment |
| **5.9** | Feb 16, 2011 | PosNum text display with length enhanced, new shop draw setup display |
| **5.8** | Jan 28, 2011 | TSL posnum content fixed, new TSL numbering options |
| **4.1** | May 14, 2008 | New options: show posnum and length, alignment options, collision check enhanced |
| **3.0** | Jan 25, 2008 | Shop draw multipage support added |
| **2.5** | Nov 28, 2006 | Multiple zone selection possible |
| **2.2** | Aug 22, 2006 | New fields: cutting angles 1 and 2 |
| **2.1** | July 24, 2006 | New option "Show only in BOM" |
| **1.6** | Dec 1, 2005 | New options: Filter Material and Filter Label |
| **1.1** | Aug 3, 2005 | Support for Model Space and Paper Space |
| **1.0** | July 27, 2005 | Initial release |

---

## Best Practices and Tips

### General Usage

1. **Position Number Assignment:**
   - Assign position numbers to beams BEFORE inserting hsbBOM for better control
   - Use consistent numbering schemes across projects
   - Reserve number ranges for different component types (1-999 structural, 1000+ hardware)

2. **Column Configuration:**
   - Hide unused columns (set Column No. to 0) for cleaner tables
   - Order columns logically: identification first (Pos, Name), then dimensions, then material
   - Use standard column orders within your company for consistency

3. **Filtering Strategy:**
   - Use Material filters for quick structural-only or sheet-only BOMs
   - Combine Exclude Material with multiple materials to eliminate non-structural items
   - Save common filter combinations as catalog presets

4. **Scale and Text Size:**
   - In Paper Space: Scale = viewport scale factor (1:100 = 0.01, 1:50 = 0.02)
   - Adjust character size for readability: 15-20mm for A3/A1 at 1:1 scale
   - Test print at actual size before finalizing

5. **Position Number Clarity:**
   - Enable background masking for dense assemblies
   - Use "outside" alignment for beam-heavy areas
   - Consider "Show only in BOM" for non-critical components

### Model Space vs Paper Space

**Use Model Space when:**
- Custom entity selection needed
- Multiple specialized BOMs from same element
- Working with assemblies, not complete elements
- Need "Add Entity" functionality for iterative updates

**Use Paper Space when:**
- Complete element documentation
- Zone-based filtering required
- Professional drawings for clients/fabricators
- Automatic entity collection from viewport

### Performance Tips

1. **Large Projects (500+ entities):**
   - Use zone filtering to reduce entity count per BOM
   - Hide position numbers for secondary entities ("Show only in BOM")
   - Minimize visible columns
   - Avoid "Show PosNum and Size" on all entities simultaneously

2. **Complex Assemblies:**
   - Split into multiple BOMs by zone or material type
   - Use filtering to create focused BOMs (hardware, structural, sheets)
   - Consider separate BOMs for different trades

3. **Shop Drawing Efficiency:**
   - Use multipage system with individual BOMs per view
   - Keep shop drawing views focused on specific assemblies
   - Avoid showing complete element in a single shop drawing BOM

### Quality Control

1. **Verify BOM Completeness:**
   - Compare total quantities with known element counts
   - Check for missing position numbers
   - Verify TSL instances are included (check TSLBOM map publication)

2. **Check Units:**
   - Verify Unit property matches project standards
   - Confirm area units (mm² vs m²) for sheet materials
   - Check decimal places for precision requirements

3. **Review Position Numbers:**
   - Ensure no overlapping numbers in view
   - Verify color coding for zones is correct
   - Check that critical components are clearly labeled

4. **Validate Filters:**
   - Test Material and Label filters don't exclude intended entities
   - Verify Exclude Material list doesn't over-filter
   - Check zone selection matches intended scope

---

## Frequently Asked Questions (FAQ)

### General Questions

**Q: Can I have multiple hsbBOM instances in one drawing?**
A: Yes. You can insert multiple instances with different configurations (different filters, zones, or entity selections) to create specialized material lists.

**Q: Does hsbBOM update automatically when I modify entities?**
A: Yes, in Model Space and Paper Space. As an O-Type parametric object, hsbBOM recalculates when linked entities change. In Shop Drawing mode, it updates when generating shop drawings.

**Q: Can I export BOM data to Excel?**
A: Not directly from the script. However, you can use AutoCAD table extraction features or copy-paste from the table. Consider using HSB_G-BillOfMaterial for Excel export capabilities.

**Q: Why does my BOM show different entities than expected?**
A: Check your filter settings (Filter Material, Filter Label, Exclude Material, Filter TSL) and zone selection. Also verify that entities were selected during insertion (Model Space) or are in the viewport element (Paper Space).

### Position Number Questions

**Q: Why are position numbers displayed at unexpected locations?**
A: This occurs due to collision detection. When numbers would overlap, they shift along the entity axis. Increase Offset Factor or use "outside" alignment for more predictable placement.

**Q: Can I manually adjust position number locations?**
A: No, position number locations are automatically calculated. However, you can influence placement using PosNum Alignment and Offset Factor properties.

**Q: Why do some entities show position numbers in different colors?**
A: Color coding indicates zone membership in Paper Space: frame (color 38), positive zones (color 82), negative zones (color 5), TSLs (configurable color).

**Q: What does "Show only in BOM" do?**
A: Entities are included in the table with quantities but position numbers are NOT displayed on the drawing. Useful for reducing visual clutter while maintaining complete BOMs.

### Column and Data Questions

**Q: How do I hide a column completely?**
A: Set the corresponding "Column No." property to 0. For example, set "Column No. Weight" to 0 to hide the weight column.

**Q: Why don't cutting angles appear for my beams?**
A: Beams must have angled cuts applied using beam cutting tools. Perpendicular cuts (90°) show as 0° or blank. Verify beam start/end cut definitions.

**Q: What's the difference between Angle1 and Angle1C?**
A: Angle1 is the actual cutting angle. Angle1C is the complementary angle (90° - Angle1). Use whichever notation your fabrication shop prefers. Enable "Switch to Complementary Angle" to swap display.

**Q: How are quantities calculated?**
A: Entities with identical position numbers are grouped, and their count is summed. For example, 5 beams all numbered "1" show as Pcs = 5.

**Q: Why is the NetArea column not showing totals?**
A: Totals only appear when: (1) Column No. NetArea > 0, and (2) at least one sheet entity exists in the BOM. The sum appears in a row at the bottom of the table.

### Zone and Filtering Questions

**Q: What is a "zone" in hsbCAD?**
A: Zones are logical subdivisions of elements. Zone 0 is the frame, positive zones (1-5) typically represent interior/exterior layers, negative zones (-1 to -5) represent opposite faces. Common in wall and floor construction.

**Q: Can I create a BOM for non-sequential zones?**
A: Yes. Use "BOM of multiple zones" option and enter desired zone indices separated by semicolons (e.g., "0; 2; 4").

**Q: Why can't I change "Zone selection" property?**
A: It's read-only in Model Space. Zone selection only applies to Paper Space and Shop Drawing modes where entities come from Element viewports.

**Q: How do filters combine?**
A: Inclusion filters (Filter Material, Filter Label) use AND logic - entities must match ALL specified filters. Then Exclude Material is applied to remove matches. Filter TSL works independently on TSL instances.

### TSL Integration Questions

**Q: Why don't my TSL instances appear in the BOM?**
A: TSLs must publish a "TSLBOM" map to be recognized. Not all TSLs support this feature. Check the TSL's source code or documentation for TSLBOM support.

**Q: Can I add custom properties to TSL BOM entries?**
A: If you have access to the TSL source code, yes. Add additional properties to the TSLBOM map. Standard hsbBOM columns will display the standard properties; custom properties can be added to Info field.

**Q: How do hierarchical position numbers (e.g., 1.1, 1.2) work?**
A: TSLs can publish subparts via the TslShop/parts map. Each subpart gets a hierarchical number based on parent position number. Quantities multiply (parent Qty × subpart Qty).

**Q: What is the "Iconside" property in TSLBOM?**
A: It controls TSL visibility in zone-based Paper Space BOMs. Set to zone index (0 = frame, 1-5 = positive zones, -1 to -5 = negative zones) to associate TSL with a specific zone.

### Technical Questions

**Q: What's the maximum number of entities hsbBOM can handle?**
A: There's no hard limit, but performance degrades beyond ~1000 entities. Use zone filtering or separate BOMs for very large elements (500+ entities recommended per BOM).

**Q: Can hsbBOM work with custom beam profiles?**
A: Yes. hsbBOM works with any beam profile. The Profile column displays the extrusion profile name. Size calculations (Width × Height) are based on cross-section extents.

**Q: Does hsbBOM support bilingual output?**
A: Column headers use translation keys and will display in the user's selected language. Entity data (names, materials) display as entered in entity properties.

**Q: Can I use hsbBOM in 3D views?**
A: Yes, in Model Space mode. Position numbers project into the current view direction. For best results, use standard orthogonal views (plan, elevation) or Paper Space viewports.

### Troubleshooting Questions

**Q: BOM table is too small to read in Paper Space. How do I fix it?**
A: Adjust the "Scale" property to match your viewport scale factor. For 1:100 viewport, use Scale = 0.01. Also check "character size" property.

**Q: Position numbers overlap despite collision detection. What should I do?**
A: Increase "Offset Factor" (try 4-5), enable background masking with "Hide All," use "outside" alignment mode, or set some entities to "Show only in BOM."

**Q: After adding entities, the BOM didn't update. Why?**
A: Ensure you used the "Add Entity" right-click command (Model Space only). If in Paper Space/Shop Drawing mode, you must modify the viewport/view content directly and regenerate the BOM.

**Q: Can I recover if I accidentally delete the BOM table?**
A: If you delete the hsbBOM object entirely, you must re-insert it. In Model Space, you'll need to reselect entities. In Paper Space, just reselect the viewport. Consider using AutoCAD UNDO instead.

---

## Summary

The **hsbBOM** script is a powerful, flexible Bill of Materials generator essential for timber construction documentation workflows. Its intelligent position number placement, extensive filtering options, and support for multiple working environments make it suitable for every phase of the construction process—from initial design and cost estimation through fabrication documentation and logistics planning.

**Key Strengths:**
- **Versatility:** Works seamlessly in Model Space, Paper Space, and Shop Drawing modes
- **Intelligence:** Automatic collision detection ensures clear, readable position numbers
- **Flexibility:** 20 customizable columns with independent width, order, and visibility control
- **Integration:** Standardized TSLBOM interface allows any TSL to publish BOM data
- **Performance:** Optimized for large assemblies using envelope geometry
- **Professionalism:** Supports dimension styles, custom colors, and scaling for polished output

**Typical Applications:**
- Material estimation and cost calculation
- Fabrication shop drawings with part identification
- Hardware and fastener purchase orders
- Zone-specific assembly documentation
- Logistics planning and packaging
- Quality control and verification

By mastering the hsbBOM script's extensive configuration options and understanding its multi-environment capabilities, users can create professional, accurate material documentation that streamlines the entire timber construction workflow from design to installation.

---

**Document Version:** 2.0
**Script Version:** 6.12
**Last Updated:** 2026-02-20
**Author:** hsbCAD Documentation Team
**Status:** Production Release
