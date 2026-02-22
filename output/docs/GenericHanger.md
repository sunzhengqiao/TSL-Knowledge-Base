# GenericHanger

**Intelligent T-Connection Hanger System for Timber Framing**

GenericHanger is a comprehensive parametric tool for automatically placing joist hangers, beam connectors, and structural hardware at T-connections between beams, trusses, and panels. It features automatic product selection based on member dimensions, supports multiple international manufacturers, and handles bulk insertion workflows for efficient production environments.

---

## Usage Environment

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object/Entity) |
| **Environment** | Model Space |
| **Required Beams** | 0 (dynamically selected during insertion) |
| **Version** | 1.25 (March 2025) |
| **Keywords** | hanger, Simpson, Strong, Tie, Wuerth, Screw, Hardware, connector, joist |

---

## Key Features

### Intelligent Automation
- **Automatic Product Selection**: Analyzes joist width, height, and supporting beam geometry to select the optimal hanger from manufacturer catalogs
- **Bulk Insertion Mode**: Automatically detects and connects multiple T-connections in one operation
- **Angle Detection**: Supports both perpendicular (90°) and skewed connections with configurable angle tolerance
- **Collision Avoidance**: Validates hanger placement against female beam geometry to prevent interference

### Multi-Manufacturer Support
- **Pre-configured Catalogs**: Simpson Strong-Tie (UK/DACH), Cullen (UK), Vuetrade (ANZ), Würth
- **Custom Product Definitions**: Add proprietary or region-specific products via XML or dialog
- **Manufacturer Filtering**: Enable/disable specific manufacturers to match project specifications

### Engineered Wood Support (EWP)
- **Web Stiffeners**: Automatically generates vertical web reinforcement for I-joists at hanger locations
- **Backer Blocks**: Creates horizontal backing members between the hanger and the supporting beam
- **Collision Detection**: Merges overlapping stiffeners/backers when multiple hangers share the same support beam

### Production-Ready Features
- **Sequential Tagging**: Assigns alphanumeric identifiers (A, B, C...) to each unique hanger type with optional color coding
- **Flexible Nailing Patterns**: Full or partial fixture configurations with customizable fastener schedules
- **BOM Integration**: Generates hardware lists with manufacturer, model, quantity, and group assignment
- **Shop Drawing Marking**: Places visual indicators on beams (front/back/top/bottom sides) for fabrication

---

## Prerequisites

Before using GenericHanger:

### Model Requirements
1. **Male Members (Incoming Joists)**: Beams, I-joists, or trusses that will be supported by hangers
2. **Female Members (Supporting Structure)**: Beams, panels (SIP/CLT), or trusses that carry the incoming members
3. **T-Connection Geometry**: Members must be positioned with at least partial overlap at the connection zone

### System Configuration
1. **Manufacturer Definitions**: XML files in `[TSL Path]\Settings\` (e.g., `GenericHanger_StrongTie UK.xml`)
2. **Painter Definitions** (Optional): Create custom selection filters via `GenericHanger\` collection in Painter system
3. **hsbEntityTag Script** (Optional): Required only if using automatic tag creation mode

### Common Use Cases
- **Floor Framing**: Connecting joists to girders or rim beams
- **Roof Framing**: Attaching rafters or trusses to ridge beams or headers
- **Wall-to-Floor**: Securing top plates to floor rim joists
- **CLT/SIP Panels**: Connecting solid wood panels to timber beams

---

## Step-by-Step Usage Guide

### Standard Insertion Workflow

#### 1. Launch the Tool
```
TSL Menu → Hardware → GenericHanger
or
Command: (hsb_ScriptInsert "GenericHanger")
```

Optionally pre-select a manufacturer and family:
```
Command: (hsb_ScriptInsert "GenericHanger" "StrongTie?ITSE")
```

#### 2. Configure Product Settings (Dialog)

**Product Category:**
- **Manufacturer**: Choose hardware supplier (e.g., "StrongTie UK", "Cullen UK")
- **Family**: Select product series (e.g., "JHA" = Joist Hanger Adjustable, "ITW" = I-Joist Top Flange)
- **Product**:
  - Leave as `<Automatic>` for intelligent selection
  - Or manually select specific model (e.g., "JHA35/47", "ITW224")

**Tooling Category:**
- **Stretch Incoming Joist**:
  - `No` (Default): Joist length remains unchanged
  - `Yes`: Extends or trims joist to align with supporting beam face
- **Gap**: Distance between joist end and beam face (visible only when stretching is enabled). Use for expansion joints or code clearances.
- **Base Depth**: Depth of beam cut at hanger base for flush mounting. Use when top surfaces must align.
- **Marking**: Controls fabrication marking:
  - `<Disabled>`: No marking
  - `Front Side` / `Back Side`: Places marker on specified beam face
  - `Top Side` / `Bottom Side`: For vertical members
  - `Product + [Side]`: Includes hanger model number in marking
- **Group Assignment**: Determines BOM grouping:
  - `Female Genbeam` (Default): Hardware follows supporting beam's group
  - `Male Genbeam`: Hardware follows incoming joist's group
  - `Female Genbeam, Layer J` / `Male Genbeam, Layer J`: Assigns to specific layer
  - `None`: No group assignment

**Fixture Category:**
- **Entry Name**: Select fastener configuration:
  - `<Disabled>`: No fasteners (manual installation)
  - Predefined entries from manufacturer catalog
  - Custom definitions created via "Add/Edit Fixtures"
- **Mode**:
  - `Full Nailing`: All holes receive fasteners
  - `Partial Nailing`: Reduced pattern per manufacturer specs

**Selection Category** (Insertion Only):
- **Male**: Filter for incoming members (`Beam`, `Truss`, or custom Painter)
- **Female**: Filter for supporting members (`Beam`, `Panel`, `Truss`, or custom Painter)

**Stiffener Category:**
- **Stiffener**: Controls EWP reinforcement:
  - `<Disabled>`: No reinforcement
  - `Web Stiffener`: Vertical blocking between I-joist flanges
  - `Backer Block`: Horizontal backing between hanger and support
  - `Web Stiffener + Backer Block`: Both types

#### 3. Select Male Entities (Incoming Joists)

**Prompt**: `Select male entities (optional all entities for automatic bulk creation)`

- Click on each incoming joist/truss/beam
- For **bulk mode**: Select all joists in the area (10+, 50+, 100+ members)
- **Right-click** or **Enter** to complete selection

**Automatic Filtering:**
- Existing web stiffeners and backer blocks are excluded from selection
- Duplicates are removed

#### 4. Select Female Entities (Supporting Beams)

**Prompt**: `Select female entities`

**Standard Mode** (Few joists selected):
- Click on the supporting beam(s), panel(s), or truss(es)
- Right-click or Enter to complete

**Bulk Auto-Insertion Mode** (Many joists selected):
- Press **Enter** without selecting anything
- Tool automatically finds all supporting beams that intersect with the selected joists
- Creates hangers at each valid T-connection

**Validation:**
- Tool verifies geometric compatibility (T-connection exists)
- Checks for sufficient overlap
- Filters out invalid alignments

#### 5. Automatic Placement

**When Product = `<Automatic>`:**
1. Measures male joist width and height
2. Queries manufacturer catalog for products within dimension ranges
3. Checks angle compatibility (perpendicular or skewed)
4. Validates hanger doesn't collide with female beam section
5. Selects best-fit product
6. Places hanger at calculated insertion point

**Visual Feedback:**
- Hanger appears in 3D at connection
- Hardware components added to entity properties
- Optional tags/markers created based on settings

#### 6. Multi-Instance Cloning (Automatic)

When multiple joists connect to the same beam:
- First hanger instance handles the primary joist pack
- Tool automatically clones additional instances for non-parallel or distant joists
- Each clone inherits all settings from the original
- Optional: Tag instances are created if tagging mode is enabled

### Bulk Insertion Workflow (Production Mode)

For projects with 50-500+ connections:

#### Preparation
1. Model all joists and beams in their final positions
2. Ensure proper naming/layering for painter filtering (optional)
3. Configure global settings: manufacturer, family, fixture pattern, tagging

#### Execution
1. Launch GenericHanger
2. Configure settings once (all hangers will use same product family)
3. **Select Male**: Use window selection to select all joists (e.g., 200 joists)
4. **Select Female**: Press Enter (leave empty)
5. Tool analyzes geometry and places hangers (progress dots shown: `.....`)
6. Final count reported: `"187 hangers created."`

#### Post-Processing
- Review hanger selection log: Right-click any hanger → `Show Selection Log`
- Adjust individual products if needed via Properties panel
- Export hanger schedule: `HSB_G-BillOfMaterial`

---

## Properties Panel Reference

After placement, modify hanger parameters via AutoCAD Properties Palette (OPM).

### Product Category

| Property | Type | Description | Dependency |
|----------|------|-------------|------------|
| **Manufacturer** | Dropdown | Hardware supplier name. Changing this reloads Family and Product lists. | Controls other properties |
| **Family** | Dropdown | Product series within manufacturer. Defines hanger type (standard, adjustable, skewed, etc.). | Controls Product list |
| **Product** | Dropdown | Specific hanger model or `<Automatic>`. Auto mode selects based on joist dimensions and connection geometry. | Affects hardware BOM |

**Notes:**
- Changing Manufacturer clears Family and Product selections
- Changing Family revalidates Product against new catalog
- Invalid products are replaced with `<Automatic>`

### Tooling Category

| Property | Type | Default | Range/Options | Description |
|----------|------|---------|---------------|-------------|
| **Stretch Incoming Joist** | Yes/No | No | Yes, No | Extends or trims male joist to align with female beam face. Creates beam cut at joist end. |
| **Gap** | Length | 0 | 0 - 50mm | Clearance between joist end and beam face. Only visible when Stretch = Yes. Use for thermal expansion or code requirements. |
| **Base Depth** | Length | 0 | 0 - unlimited | Depth of beam cut at hanger base. Creates recess for flush mounting. Use when top surfaces must align (e.g., floor decking). |
| **Marking** | Dropdown | Disabled | See below | Fabrication marking strategy. |
| **Group Assignment** | Dropdown | Female Genbeam | See below | BOM grouping strategy. |

**Marking Options:**
- `<Disabled>`: No marking
- `Back Side`: Mark on beam face away from view direction
- `Bottom Side`: Mark on bottom face (for horizontal members)
- `Front Side`: Mark on beam face toward view direction
- `Top Side`: Mark on top face (for horizontal members)
- `Product + Back Side`: Include model number (e.g., "JHA35/47") on back side
- `Product + Bottom Side`: Model number on bottom
- `Product + Front Side`: Model number on front
- `Product + Top Side`: Model number on top

**Group Assignment Options:**
- `Female Genbeam`: Hanger follows supporting beam's group (most common)
- `Female Genbeam, Layer J`: Supporting beam's group + Layer J assignment
- `Male Genbeam`: Hanger follows incoming joist's group
- `Male Genbeam, Layer J`: Incoming joist's group + Layer J assignment
- `None`: No group assignment (loose hardware)

### Fixture Category

| Property | Type | Description |
|----------|------|-------------|
| **Entry Name** | Dropdown | Fastener configuration name. Options include: `<Disabled>`, manufacturer defaults, custom definitions. |
| **Mode** | Dropdown | Nailing pattern: `Full Nailing` (all holes), `Partial Nailing` (reduced pattern per manufacturer specs). Only visible when Entry Name ≠ Disabled. |

**Fixture Availability:**
- `<All Families>`: Generic fixture works with any product in any family
- Specific Product: Fixture only available for selected product model
- Specific Family: Fixture available for all products in family

**Default Behavior:**
- If Entry Name is blank or invalid: Uses manufacturer's default fixture from product definition
- Quantity calculation: Automatic based on `Header` (female) and `Joist` (male) hole counts

### Selection Category

| Property | Type | Description | Visibility |
|----------|------|-------------|-----------|
| **Male** | Dropdown | Filter for incoming members: `<bySelection>`, `Beam`, `Truss`, or Painter definitions. | Insertion only (hidden after placement) |
| **Female** | Dropdown | Filter for supporting members: `<bySelection>`, `Beam`, `Panel`, `Truss`, or Painter definitions. | Insertion only (hidden after placement) |

**Painter Integration:**
- If `GenericHanger\` collection exists: Only painters in this collection are listed
- Otherwise: All painters matching `Beam`, `Panel`, `Truss` types are available
- Custom painter names are stripped of collection prefix in dropdown

### Stiffener Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Stiffener** | Dropdown | Disabled | Controls EWP reinforcement creation. Options: `<Disabled>`, `Backer Block`, `Web Stiffener`, `Web Stiffener + Backer Block`. |

**Behavior:**
- **Backer Block**: Creates horizontal blocking between hanger and female beam web. For I-joists and open-web trusses.
- **Web Stiffener**: Creates vertical blocking in male joist web at hanger location. For I-joists only.
- **Both**: Creates both types when male is I-joist and female allows backing
- Material, color, dimensions controlled via context menu (see below)

**Automatic Collision Handling:**
- When multiple hangers share the same beam: Backer blocks merge into continuous member
- Overlapping web stiffeners from adjacent hangers are unified
- Each hanger maintains reference to shared reinforcement

---

## Right-Click Context Menu

After placing a hanger, right-click to access advanced commands.

### Primary Commands (Context Root)

| Command | Execution Key | Description |
|---------|---------------|-------------|
| **Flip Side** | `Flip Side` | Mirrors hanger to opposite side of connection. Swaps front/back orientation relative to female beam centerline. |
| **Add Entities** | `Add Entities` | Opens entity selection to add more male or female members to existing hanger configuration. Use when connection geometry changes. |

### Advanced Commands (Submenu)

#### Product Management

| Command | Description | Dialog |
|---------|-------------|--------|
| **Add/Edit Product** | Define custom hanger products not in manufacturer catalogs. | Opens special OPM mode with fields:<br>- Manufacturer Name<br>- Family Name<br>- Product Name<br>- Width (inner dimension)<br>- Thickness (material gauge)<br>- Min/Max Width (joist range)<br>- Min/Max Height (joist range) |

**Add/Edit Product Workflow:**
1. Right-click hanger → `Add/Edit Product`
2. Enter manufacturer name (or select existing)
3. Enter family name (creates new family if doesn't exist)
4. Enter product name
5. Set hanger geometry: Width, Thickness
6. Set joist capacity: Min/Max Width, Min/Max Height
7. Press **Enter** or close Properties
8. Product is saved to catalog and becomes available in Product dropdown

**Validation:**
- Products are validated against joist dimension ranges during selection
- Invalid products (missing dimensions, corrupted data) are filtered from dropdowns
- Validation error log: Right-click → `Show Selection Log`

#### Fixture Management

| Command | Description | Dialog |
|---------|-------------|--------|
| **Add/Edit Fixtures** | Create custom fastener configurations. | Opens special OPM mode with fields:<br>- Entry Name (unique identifier)<br>- Availability (All Families / specific Product / specific Family) |

**Add/Edit Fixtures Workflow:**
1. Right-click hanger → `Add/Edit Fixtures`
2. Enter unique Entry Name (e.g., "Custom_Full", "ProjectX_Partial")
3. Select Availability scope
4. Close Properties
5. Tool opens dynamic dialog: Add hardware components
6. Add rows for each fastener type:
   - Name: "Header" (female), "Joist" (male), or custom
   - Article Number: Screw/nail model (e.g., "Simpson SD9")
   - Quantity: Count per hanger (0 = automatic)
   - Manufacturer, Material, Category, Group, Notes
7. Save fixture definition
8. New entry appears in Fixture → Entry Name dropdown

**Fixture Hardware Dialog:**
- **Name**: Special values "Header" and "Joist" use product's default quantities
- **Quantity = 0**: Automatically calculates from hanger's hole count
- **Name = blank**: Total quantity applies to entire hanger
- **Availability Scope**:
  - `All Families`: Fixture works with any hanger
  - Specific Product: Only available when that exact product is selected
  - Specific Family: Available for all products in family

**Removing Fixtures:**
- Set all hardware quantities to 0 and Entry Name to blank
- Save to delete fixture definition

#### Stiffener/Backer Configuration

| Command | Description | Dynamic Based On |
|---------|-------------|------------------|
| **Edit Web Stiffener Properties** | Configure vertical I-joist reinforcement. | Only shown when male member is I-joist |
| **Edit Backer Block Properties** | Configure horizontal backing member. | Only shown when female member allows backing |
| **Edit Stiffener / Backer Block Properties** | Configure both reinforcement types. | Shown when both are possible |

**Opens special OPM mode with categories:**

**Stiffener Category** (Web Stiffener):
- **Name**: Beam name (e.g., "Web Stiffener")
- **Material**: Wood species (e.g., "Spruce", "LVL")
- **Color**: ACI color index (default: 31)
- **Length**: Vertical height of stiffener
  - `0` = Automatic (matches hanger height)
  - `> 0` = Custom dimension
- **Extra Length**: Additional length beyond hanger height
- **Gap**: Horizontal gap from top and bottom of I-joist web (prevents edge crushing)

**Backer Block Category**:
- **Name**: Beam name (e.g., "Backer Block")
- **Material**: Wood species
- **Color**: ACI color index (default: 31)
- **Length**: Horizontal length along beam
  - `0` = Automatic (matches hanger width + 2×thickness)
  - `> 0` = Custom dimension
- **Extra Length**: Additional length beyond automatic calculation
- **Gap**: Vertical gap from top and bottom of female beam (for wiring clearance)

**Behavior:**
- Changing properties triggers recalculation
- Existing stiffeners/backers are updated or recreated
- Shared backers (multiple hangers) are merged automatically

#### Manufacturer Management

| Command | Description | Use Case |
|---------|-------------|----------|
| **Select Manufacturers** | Enable/disable manufacturers in product dropdown. | Filter to project-approved suppliers or regional availability. Opens checklist dialog. |
| **Export Hanger Definitions [Manufacturer]** | Save current manufacturer's catalog to XML file. | Backup custom products or share with team. File saved to `[Company Path]\Settings\GenericHanger_[Manufacturer].xml`. |
| **Import Hanger Definitions [Manufacturer]** | Load manufacturer catalog from XML file. | Restore backup, import new supplier, or sync with updated regional catalog. |

**Select Manufacturers Workflow:**
1. Right-click → `Select Manufacturers`
2. Dialog shows all available manufacturers with checkboxes
3. Check manufacturers to enable, uncheck to disable
4. Disabled manufacturers hidden from Manufacturer dropdown
5. Settings persist per user/company

#### Tagging System

| Command | Description |
|---------|-------------|
| **Tag Settings** | Configure automatic hanger identification and color coding. |

**Opens special OPM mode:**
- **Tag Mode**:
  - `<Disabled>`: No tagging
  - `Set Tag`: Assigns alphanumeric ID (A, B, C...) to Model Description only
  - `Set + Create Tag`: Assigns ID + creates hsbEntityTag instance at hanger location
- **Sequential Colors**: Semicolon-separated color indices (e.g., "1;2;3;4;5")
  - Each unique hanger type (by posnum) receives next color in sequence
  - Rotates through list if more hanger types than colors

**Tagging Logic:**
1. All hangers in drawing are grouped by `posnum` (position number = unique hardware configuration)
2. Groups are sorted by quantity (most common = A, second = B, etc.)
3. Each hanger's `modelDescription` is set to its letter (A, B, C...)
4. If Create Tag mode: hsbEntityTag instance is placed below hanger
5. If Sequential Colors defined: Each group receives color from list

**Use Cases:**
- Shop drawing callouts: "Install Type A hangers at all floor joists"
- Material takeoff: "Order 47× Type A (JHA35/47), 23× Type B (JHA47/75)"
- Visual QA: Color-code by hanger capacity for quick inspection

#### Angle Tolerance

| Command | Description | Current State |
|---------|-------------|---------------|
| **Allow Angle Deviation** | Enable acceptance of hangers designed for perpendicular connections at slight angles (up to 2°). | Shown when deviation is OFF |
| **Angle Deviation off** | Disable angle tolerance (strict perpendicular only). | Shown when deviation is ON |

**Behavior:**
- When **ON**: Hangers with `MinAlpha=0, MaxAlpha=0` (perpendicular-only products) are allowed if actual angle ≤ 2°
- When **OFF**: Only products with matching `MinAlpha/MaxAlpha` range are selected
- Use for field conditions where framing isn't perfectly square
- **Warning**: Check manufacturer specs before enabling for structural connections

#### Settings Management

| Command | Description | File Location |
|---------|-------------|---------------|
| **Import Settings** | Load global script settings from XML. | User selects file via dialog |
| **Export Settings** | Save current global settings to XML. | User specifies destination file |

**Settings Include:**
- Web stiffener defaults (name, material, color, length, gap)
- Backer block defaults (name, material, color, length, gap)
- Fixture definitions (all custom entries)
- Tag mode and sequential colors
- Angle deviation tolerance

**Use Cases:**
- Standardize settings across project team
- Create templates for different building types
- Backup company-specific configurations

#### Diagnostics

| Command | Description | Visibility |
|---------|-------------|-----------|
| **Show Command for UI Creation** | Display LISP command string for creating toolbar/ribbon button with current manufacturer/family pre-selected. | Always visible |
| **Show Selection Log** | Display validation errors and warnings from last recalculation. | Only visible when issues exist |

**Show Command Output Example:**
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger" "StrongTie UK?JHA")) TSLCONTENT
```
Copy-paste to create custom command button.

**Show Selection Log Output:**
- Geometry validation failures
- Product selection conflicts
- Missing manufacturer data
- Invalid dimension ranges
- Backer block collision warnings

---

## Settings Files and XML Structure

### File Locations

GenericHanger reads configuration from:

1. **Company Settings** (Priority 1):
   - Path: `[Company TSL Path]\Settings\GenericHanger.xml`
   - Contains: Global defaults, custom fixtures, tag settings

2. **Installation Defaults** (Priority 2):
   - Path: `[hsbCAD Install]\Content\General\TSL\Settings\GenericHanger.xml`
   - Contains: Factory defaults

3. **Manufacturer Catalogs**:
   - Path: `[Company or Install]\Settings\GenericHanger_[Manufacturer].xml`
   - Examples:
     - `GenericHanger_StrongTie UK.xml`
     - `GenericHanger_StrongTie DACH.xml`
     - `GenericHanger_Cullen UK.xml`
     - `GenericHanger_Vuetrade_ANZ.xml`

### XML Structure Overview

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <unit ut="L" uv="millimeter"/>

  <!-- Manufacturer Catalog -->
  <lst nm="Manufacturer[]">
    <lst nm="StrongTie UK">
      <!-- Families within manufacturer -->
      <lst nm="Family[]">
        <lst nm="JHA">
          <str nm="Material" vl="Steel"/>
          <str nm="url" vl="https://www.strongtie.co.uk/..."/>

          <!-- Products within family -->
          <lst nm="Product[]">
            <lst nm="JHA35/47">
              <dbl nm="A" ut="L" vl="47"/>  <!-- Inner width -->
              <dbl nm="B" ut="L" vl="35"/>  <!-- Inner height -->
              <dbl nm="C" ut="L" vl="0"/>   <!-- Reserved -->
              <dbl nm="D" ut="L" vl="25"/>  <!-- Seat depth -->
              <dbl nm="E" ut="L" vl="150"/> <!-- Overall height -->
              <dbl nm="F" ut="L" vl="0"/>   <!-- Reserved -->
              <dbl nm="t" ut="L" vl="2"/>   <!-- Material thickness -->
              <dbl nm="Joist\\MinWidth" ut="L" vl="35"/>
              <dbl nm="Joist\\MaxWidth" ut="L" vl="47"/>
              <dbl nm="Joist\\MinHeight" ut="L" vl="97"/>
              <dbl nm="Joist\\MaxHeight" ut="L" vl="250"/>
              <dbl nm="MinAlpha" vl="0"/>   <!-- Min angle (degrees) -->
              <dbl nm="MaxAlpha" vl="0"/>   <!-- Max angle (0=perpendicular) -->
              <int nm="Header" vl="4"/>     <!-- Fastener holes in header -->
              <int nm="Joist" vl="8"/>      <!-- Fastener holes in joist -->
              <str nm="Description" vl="Joist Hanger Adjustable"/>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>

  <!-- Custom Fixtures -->
  <lst nm="Fixture[]">
    <lst nm="Custom_Full">
      <str nm="Availability" vl="All Families"/>
      <lst nm="HardWrComp[]">
        <lst nm="0">
          <str nm="Name" vl="Header"/>
          <str nm="ArticleNumber" vl="Simpson SD9"/>
          <int nm="Quantity" vl="0"/> <!-- 0 = use product default -->
          <str nm="Manufacturer" vl="Simpson"/>
          <str nm="Material" vl="Steel"/>
          <str nm="Category" vl="Fastener"/>
        </lst>
      </lst>
    </lst>
  </lst>

  <!-- Stiffener/Backer Defaults -->
  <lst nm="Stiffener[]">
    <str nm="Name" vl="Web Stiffener"/>
    <str nm="Material" vl="Spruce"/>
    <int nm="Color" vl="31"/>
    <dbl nm="Length" ut="L" vl="0"/>      <!-- 0 = auto -->
    <dbl nm="ExtraLength" ut="L" vl="0"/>
    <dbl nm="Gap" ut="L" vl="10"/>
  </lst>

  <lst nm="Backers[]">
    <str nm="Name" vl="Backer Block"/>
    <str nm="Material" vl="Spruce"/>
    <int nm="Color" vl="31"/>
    <dbl nm="Length" ut="L" vl="0"/>      <!-- 0 = auto -->
    <dbl nm="ExtraLength" ut="L" vl="0"/>
    <dbl nm="Gap" ut="L" vl="10"/>
  </lst>

  <!-- Tag Settings -->
  <lst nm="Tag">
    <int nm="Mode" vl="0"/> <!-- 0=Disabled, 1=Set, 2=Set+Create -->
    <lst nm="SequentialColor[]">
      <int nm="0" vl="1"/>   <!-- Red -->
      <int nm="1" vl="2"/>   <!-- Yellow -->
      <int nm="2" vl="3"/>   <!-- Green -->
    </lst>
  </lst>

  <!-- Angle Tolerance -->
  <lst nm="Parameters">
    <int nm="AllowAngleDeviation" vl="0"/> <!-- 0=Off, 1=On -->
  </lst>
</Hsb_Map>
```

### Product Dimension Reference

| Parameter | Symbol | Description | Typical Range |
|-----------|--------|-------------|---------------|
| **A** | Inner Width | Distance between hanger sidewalls (joist width capacity) | 35-100mm |
| **B** | Inner Height | Minimum joist height that fits in hanger seat | 35-300mm |
| **C** | Reserved | Future use | 0 |
| **D** | Seat Depth | Horizontal bearing surface for joist | 20-50mm |
| **E** | Overall Height | Total vertical dimension of hanger (excluding top flange) | 100-400mm |
| **F** | Reserved | Future use | 0 |
| **t** | Thickness | Material gauge (steel plate thickness) | 1.5-3mm |
| **MinAlpha** | Min Angle | Minimum connection angle (0° = perpendicular) | 0-45° |
| **MaxAlpha** | Max Angle | Maximum connection angle (0° = perpendicular only) | 0-45° |

**Angle Conventions:**
- `MinAlpha=0, MaxAlpha=0`: Perpendicular connections only
- `MinAlpha=0, MaxAlpha=45`: Skewed hangers accepting 0-45° connections
- `MinAlpha=30, MaxAlpha=60`: Specialized skewed hangers for specific angle range

### Creating Custom Manufacturer Catalogs

#### Option 1: Via Dialog (Single Products)
1. Place one hanger instance
2. Right-click → `Add/Edit Product`
3. Fill in manufacturer/family/product details
4. Right-click → `Export Hanger Definitions [Manufacturer]`

#### Option 2: Via XML (Bulk Import)
1. Copy existing manufacturer XML as template
2. Edit `<lst nm="Manufacturer[]">` section:
   - Change manufacturer name
   - Modify family names
   - Update product dimensions and ranges
3. Save to `[Company]\Settings\GenericHanger_[Name].xml`
4. Restart hsbCAD or use `Import Hanger Definitions`

#### Product Validation Rules

Products must pass validation to appear in dropdown:
- `A` (width) > 0
- `t` (thickness) > 0
- `Joist\MinWidth` ≤ `Joist\MaxWidth`
- `Joist\MinHeight` ≤ `Joist\MaxHeight`
- If `Joist\MaxWidth` = 0: No width limit
- If `Joist\MaxHeight` = 0: No height limit

Invalid products are logged: Right-click → `Show Selection Log`

---

## Workflow Examples

### Example 1: Standard Floor Framing

**Scenario**: Connect 40× 38×220mm joists to 63×220mm rim beam

**Steps:**
1. Launch GenericHanger
2. Manufacturer: `Simpson StrongTie UK`
3. Family: `JHUS` (Universal Hanger)
4. Product: `<Automatic>`
5. Stretch Incoming Joist: `Yes`
6. Gap: `3mm` (thermal expansion)
7. Fixture Entry: `<Disabled>` (manual nailing)
8. Stiffener: `<Disabled>` (solid sawn lumber)
9. Select Male: Window select all 40 joists
10. Select Female: Click rim beam
11. Result: 40 hangers placed, automatic product selection chooses "JHUS38"

**BOM Output:**
- JHUS38 × 40 units
- Simpson SD9 Screws × 0 (manual nailing)

### Example 2: I-Joist with Stiffeners

**Scenario**: Connect 240mm I-joists to LSL girder, EWP requires web stiffeners

**Steps:**
1. Launch GenericHanger
2. Manufacturer: `StrongTie DACH`
3. Family: `ITW` (I-Joist Top Mount)
4. Product: `<Automatic>`
5. Stretch: `Yes`, Gap: `0`
6. Fixture Entry: `Full Nailing`
7. Stiffener: `Web Stiffener`
8. Select Male: 24 I-joists
9. Select Female: LSL girder
10. Tool creates 24 hangers + 48 web stiffeners (2 per connection)

**Post-Placement:**
- Right-click → `Edit Web Stiffener Properties`
  - Material: `OSB`
  - Length: `0` (auto-height from hanger)
  - Gap: `15mm` (clearance from flange)

### Example 3: Bulk Project Installation

**Scenario**: 3-story residential building, 387 floor/ceiling joist connections

**Preparation:**
1. Model all floors with joists and beams
2. Create Painter definition: `GenericHanger\FloorJoists` (filters by layer or property)
3. Configure global settings once:
   - Manufacturer: `Cullen UK`
   - Family: `JHS` (Standard Joist Hanger)
   - Stretch: `Yes`, Gap: `5mm`
   - Fixture: `Project_Standard` (custom entry: 8× screws per hanger)
   - Tagging: `Set + Create Tag`, Sequential Colors: `1;2;3;4;5`

**Execution:**
1. Launch GenericHanger (with configured settings from last insert)
2. Male: Window select all 387 joists
3. Female: Press Enter (auto-detect)
4. Coffee break ☕ (tool runs 30-60 seconds)
5. Message: `"387 hangers created."`

**Validation:**
1. Right-click any hanger → `Show Selection Log` (check for errors)
2. Visual inspection: 5 tag colors distribute across drawing
3. Export BOM: Verify hanger types match design intent

**Result:**
- Type A (Tag: A, Color: Red): JHS38 × 187 units (most common)
- Type B (Tag: B, Color: Yellow): JHS47 × 103 units
- Type C (Tag: C, Color: Green): JHS50 × 68 units
- Type D (Tag: D, Color: Blue): JHS63 × 21 units
- Type E (Tag: E, Color: Magenta): JHS75 × 8 units

### Example 4: Skewed Roof Connection

**Scenario**: Rafters at 30° angle to ridge beam

**Steps:**
1. Manufacturer: `Rothoblaas`
2. Family: `WHT` (Wide Universal Hanger)
3. Product: Leave as `<Automatic>`
4. Right-click (after placement) → `Allow Angle Deviation` (enable)
5. Select Male: Rafters
6. Select Female: Ridge beam
7. Tool detects 30° angle, selects products with `MinAlpha≤30, MaxAlpha≥30`

**Note**: If no skewed products exist in catalog, use perpendicular hanger and enable `Allow Angle Deviation` (only for ≤2° deviations).

### Example 5: CLT Panel to Beam

**Scenario**: Connect 100mm CLT wall panel to 160mm GLT floor rim beam

**Steps:**
1. Manufacturer: `StrongTie DACH`
2. Family: `PHD` (Panel Hanger)
3. Product: `<Automatic>`
4. Stiffener: `Backer Block` (backing for panel edge)
5. Male: CLT wall panel (use Painter filter)
6. Female: GLT rim beam
7. Tool creates hanger + horizontal backer block

**Backer Block Configuration:**
- Length: `0` (auto = hanger width + 2×thickness)
- Extra Length: `50mm` (extend beyond hanger for bearing)
- Gap: `20mm` (clearance for conduit)
- Material: `GLT` (match rim beam)

---

## Technical Details

### Geometry Calculation Workflow

#### 1. Entity Analysis
- Cast selected entities to `Beam`, `TrussEntity`, `Sip` types
- Extract envelope bodies (3D solids) for geometric analysis
- Create `PlaneProfile` (2D shadow) for each entity in local coordinate system

#### 2. Connection Validation
- **Male Pack Detection**: Group parallel joists with similar orientation into packs
- **Female Pack Detection**: Group supporting beams/panels with shared bearing plane
- **T-Contact Plane**: Calculate plane perpendicular to female, passing through male centroid
- **Intersection Test**: Verify male and female bodies have contact zone
- **Alignment Check**: Ensure male axis is perpendicular (or within angle tolerance) to female

#### 3. Insertion Point Calculation
```
1. Project male profile onto T-contact plane
2. Get extent (bounding box) of projected profile along female axis
3. Insertion point = midpoint of extent
4. Coordinate system:
   - vecX: Along male width (cross-section)
   - vecY: Along male height (vertical for floor joists)
   - vecZ: Along male axis (toward female)
```

#### 4. Product Selection Logic

**For each product in family:**
1. **Dimensional Check**:
   - Male Width: `Joist\MinWidth ≤ ppMale.dX() ≤ Joist\MaxWidth`
   - Male Height: `Joist\MinHeight ≤ ppMale.dY() ≤ Joist\MaxHeight`
   - If `MaxWidth=0` or `MaxHeight=0`: No upper limit

2. **Angle Check**:
   ```
   dAlpha = angle between male axis and female axis
   bAccept = (MinAlpha ≤ dAlpha ≤ MaxAlpha)
             OR (bAllowAngleDeviation AND MinAlpha=0 AND MaxAlpha=0 AND dAlpha≤2°)
   ```

3. **Collision Check**:
   - Extrude hanger profile (width × thickness) along female axis
   - Test intersection with female beam section
   - Reject if hanger collides with female web/flange

4. **Ranking** (if multiple products match):
   - Prefer smallest hanger that fits (minimize material/cost)
   - Sort by `A` (width), then `B` (height)

#### 5. Reinforcement Generation

**Web Stiffener** (for I-joists):
```
1. Get male joist PlaneProfile at hanger location
2. Identify web area (rectangular section between flanges)
3. Create vertical blocking:
   - Width: Match web thickness
   - Height: Hanger height E + ExtraLength
   - Length (extrusion): Web depth (joist width - 2×flange width)
4. Apply horizontal gap (offset from top/bottom)
5. Create Beam entity, assign to male joist's element group
```

**Backer Block**:
```
1. Get female beam PlaneProfile at insertion plane
2. Subtract hanger seat profile (create hollow for hanger)
3. Apply vertical gap (offset from top/bottom)
4. Simplify profile to rectangular sections (handle HEB, IPN shapes)
5. Extrude along male axis:
   - Length: A + 2×D + 2×ExtraLength (hanger width + seats + extra)
6. Trim at female beam extents (don't exceed beam ends)
7. Union with neighboring backers if collision detected
8. Create Beam entity, assign to female beam's element group
```

**Collision Handling**:
- When multiple hangers share female beam: Check backer intersections
- If `bdBackerNew.hasIntersection(bdExistingBacker)`: Merge bodies
- Update all affected hangers to reference merged backer
- Prevents duplicate overlapping backing members

### Hardware Component Generation

#### HardWrComp Structure

Each hanger adds hardware to `_ThisInst.hardWrComps()`:

1. **Main Component** (Hanger itself):
   ```
   ArticleNumber: Product name (e.g., "JHA35/47")
   Quantity: 1
   Manufacturer: From property
   Model: Family name
   Material: From family definition
   Category: "Connector"
   Group: Inherited from female beam or user-specified
   RepType: _kRTTsl (marks as TSL-generated)
   ScaleX: A (width)
   ScaleY: B (height)
   ScaleZ: D (seat depth)
   ```

2. **Fixture Components** (Fasteners):
   ```
   For each hardware entry in fixture definition:
     ArticleNumber: Screw/nail model
     Quantity: From fixture OR product default (Header/Joist counts)
     Category: "Fastener" or custom
     RepType: _kRTTsl
   ```

**Quantity Calculation Logic**:
- If fixture entry name contains "Header" AND quantity=0: Use `product.getInt("Header")`
- If fixture entry name contains "Joist" AND quantity=0: Use `product.getInt("Joist")`
- If fixture entry name is blank AND quantity=0: Use `Header + Joist`
- Otherwise: Use specified quantity

#### Compare Key and Tagging

**Compare Key** (for grouping identical hangers):
```
CompareKey = Manufacturer + "_" + Family + "_" +
             sorted(ArticleNumber_Quantity for each hardware component)

Example: "StrongTie UK_JHA_JHA35/47_1_SD9_8"
```

Hangers with identical CompareKey receive same `posnum` (position number).

**Tagging Assignment**:
1. Find all GenericHanger instances in drawing
2. Group by `posnum`
3. Count instances per group
4. Sort groups by count (descending)
5. Assign alphanumeric tags: `ToAlphanumeric(1)` = "A", `(2)` = "B", ..., `(27)` = "AA"
6. Set `modelDescription` property to tag
7. Optionally create hsbEntityTag instance below hanger
8. Apply sequential color from list (rotate if more groups than colors)

### Bulk Insertion Algorithm (Mode 9)

When many males selected, no females selected:

```
1. Filter males to beams only (exclude trusses/panels for bulk mode)
2. Apply painter filter if specified
3. For each male beam:
   a. Find other beams NOT parallel to current beam
   b. Filter to beams intersecting capsule around current beam
   c. Filter to beams projecting onto current beam's plane (T-connection test)
   d. If intersections found: Add to male collection
4. Group males into packs (EntityCollection by proximity/element)
5. For each male pack:
   a. Find potential female beams (from all beams NOT in male pack)
   b. Filter females by capsule intersection
   c. Filter females by T-connection projection
   d. Apply female painter filter if specified
   e. For each female in potential list:
      - Calculate T-contact plane
      - Compute insertion point
      - Create new GenericHanger instance at connection
      - Clone with same properties and map
      - Report progress: Print "." for each hanger
6. If tagging enabled: Last created hanger triggers tag assignment for all
7. Report: "N hangers created."
8. Delete distributor instance (mode 9 instance is temporary)
```

**Performance**: ~100 hangers/second on typical hardware

### Painter Definition Integration

**Purpose**: Filter entities by custom criteria (layer, color, element type, etc.)

**Usage:**
1. Create Painter definition: `GenericHanger\FloorJoists`
2. Configure filter (e.g., Layer = "FLOOR_FRAMING", Type = "Beam")
3. GenericHanger automatically detects `GenericHanger\` collection
4. Male/Female dropdowns list only painters in this collection
5. During selection, `pd.filterAcceptedEntities(entities)` applies filter

**Advantages:**
- Consistent selection across multiple placements
- Avoids manual filtering in large drawings
- Reusable definitions for project standards

---

## Troubleshooting

### Issue: "Invalid selection set. Tool will be deleted."

**Cause**: No valid male-female pairs detected.

**Solutions:**
1. **Check geometry**: Male and female must physically intersect
2. **Verify entity types**: Both must be Beam, Truss, or Panel (not dimensions, text, etc.)
3. **Check orientation**: T-connection required (perpendicular or within angle tolerance)
4. **Inspect alignment**: Male axis must project onto female bearing surface
5. **Remove stiffeners/backers**: Tool auto-filters, but manually deselect if error persists

**Debug:**
- Select one male, one female first (simplify to isolate problem)
- Check entity properties: Ensure both are valid GenBeam/Truss/Sip objects

### Issue: Product dropdown shows only "<Automatic>"

**Causes:**
1. **No products in family**: Family exists but Product[] list is empty
2. **All products invalid**: Validation failed (missing A, t, or malformed dimensions)
3. **Joist dimensions out of range**: All products Min/Max ranges exclude current joist size

**Solutions:**
1. **Check family definition**: Right-click → `Export Hanger Definitions` → Open XML → Verify `Product[]` exists
2. **Validate products**: Right-click → `Show Selection Log` → Review validation errors
3. **Add custom product**: Right-click → `Add/Edit Product` → Define product for current joist size
4. **Switch family**: Try different family within same manufacturer

**Example Log Entry:**
```
Product validation failed: JHA25/35
  - Missing parameter: A (Inner Width)
  - Product excluded from selection
```

### Issue: Hanger on wrong side of beam

**Cause**: Tool calculates insertion point based on view direction and geometry; may not match intent.

**Solution:**
- Right-click hanger → `Flip Side`
- Hanger mirrors to opposite side of female beam centerline
- Recalculates in real-time

### Issue: Web stiffener not created for I-joist

**Causes:**
1. **Stiffener property = Disabled**: Check Properties → Stiffener category
2. **Male member is not I-joist**: Only Beams with web flanges supported
3. **Insufficient depth**: Very shallow I-joists may not have web area

**Solutions:**
1. Select hanger → Properties → Stiffener → Set to "Web Stiffener" or "Both"
2. Verify male is Beam type: Check entity properties
3. Check joist profile: Ensure web is detectable (not solid rectangle)

### Issue: Backer block collides with adjacent hanger

**Expected Behavior**: Tool automatically merges overlapping backers.

**If not merging:**
1. Hangers placed in different sessions (first hanger doesn't recalc when second is placed)
2. Solution: Select first hanger → Right-click → Recalc (F5) → Backer merges

### Issue: Fixture quantities incorrect in BOM

**Causes:**
1. **Entry Name = Disabled**: No fixtures added
2. **Quantity = 0 with wrong name**: "Header"/"Joist" keyword missing → Defaults to product Header+Joist
3. **Product missing Header/Joist values**: Custom products may not define hole counts

**Solutions:**
1. Set Entry Name to valid fixture (not `<Disabled>`)
2. Edit fixture: Ensure "Header" and "Joist" names used for auto-quantities
3. For custom products: Right-click → `Add/Edit Product` → Specify Header and Joist hole counts in product XML

### Issue: Tagging not working

**Causes:**
1. **Tag Mode = Disabled**: Check Right-click → `Tag Settings`
2. **hsbEntityTag script missing**: Create Tag mode requires this script in TSL folder
3. **No posnum assigned**: Hanger hardware configuration invalid (no CompareKey)

**Solutions:**
1. Enable tagging: Right-click → `Tag Settings` → Set to "Set Tag" or "Set + Create Tag"
2. Verify hsbEntityTag exists: Check `[Install]\TSL\hsbEntityTag.mcr`
3. Check BOM: Ensure hanger has valid hardware components

**Manual Tag Trigger:**
- Change any property (Manufacturer, Family, Product)
- Tool recalculates tags for all hangers in drawing

### Issue: Bulk insertion creates too few hangers

**Causes:**
1. **Geometry doesn't meet T-connection criteria**: Beams parallel, not intersecting, or too far apart
2. **Painter filter too restrictive**: Custom painter excludes valid entities
3. **Angle out of range**: Products only support perpendicular, but connections are skewed

**Diagnostics:**
1. **Enable Debug Mode**: Modify script: `int bDebug = true;` → Rerun
   - Visual feedback: Color-coded entities (red=valid, gray=rejected)
   - Console messages: Reports filter stages
2. **Manual Selection**: Select fewer males (5-10) and specify females → Check if connections work
3. **Check Selection Log**: Right-click any created hanger → `Show Selection Log`

**Solutions:**
1. **Relax filters**: Use `<bySelection>` instead of Painter
2. **Enable angle deviation**: Right-click → `Allow Angle Deviation`
3. **Adjust geometry**: Ensure beam intersections exist, increase overlap

### Issue: "Could not find product data of family [Name]. Tool will be deleted."

**Cause**: Selected family has no valid products (empty or corrupted catalog).

**Solutions:**
1. **Switch family**: Select different family in same manufacturer
2. **Reimport catalog**: Right-click → `Import Hanger Definitions` → Reload XML
3. **Add product manually**: Right-click → `Add/Edit Product`
4. **Check XML integrity**: Open XML file → Verify `<lst nm="Product[]">` contains product entries

### Issue: Hanger placement pauses/freezes in large drawings

**Cause**: Bulk mode analyzing 100+ beams with complex geometry.

**Workarounds:**
1. **Batch smaller areas**: Select 50-100 joists at a time instead of entire building
2. **Freeze irrelevant layers**: Reduce entity count in selection filter
3. **Use painters**: Pre-filter entities via painter definitions (faster than real-time filtering)
4. **Increase timeout**: Allow 1-2 minutes for very large operations (tool prints progress dots)

**Performance Tips:**
- Close unnecessary drawings
- Simplify beam profiles (use envelopeBody instead of realBody for complex cuts)
- Run overnight for projects with 500+ connections

---

## Tips and Best Practices

### Product Selection Strategy

1. **Use Automatic Mode First**: Let tool select product, then review
2. **Create Project Templates**: Save common configurations via `Export Settings`
3. **Validate Catalog**: After importing new manufacturer, place test hanger → Check log
4. **Document Custom Products**: Add description in XML for future reference

### Fixture Configuration

1. **Name Standards**: Use keywords "Header" and "Joist" for automatic quantities
2. **Availability Scope**: Set to specific family unless truly universal
3. **Test Before Bulk**: Place one hanger with new fixture → Verify BOM output
4. **Full vs Partial**: Partial nailing for temporary bracing, full for final installation

### Stiffener Best Practices

1. **Material Matching**: Use same species as joist for web stiffeners
2. **Gap Settings**: 10-15mm typical for OSB web, 5mm for LVL
3. **Length Calculation**: Let tool auto-calculate (Length=0) unless special condition
4. **Merging Check**: After bulk placement, spot-check backers at dense connections

### Bulk Insertion Workflow

1. **Prepare Model**: Complete all framing before hanger placement
2. **Layer Organization**: Separate joists, beams, panels on different layers
3. **Painter Definitions**: Create filters before bulk operation
4. **Incremental Approach**:
   - Floor 1: Place hangers, verify, export BOM
   - Floor 2: Repeat with same settings
   - Catches issues early, easier to troubleshoot

### Tagging for Production

1. **Sequential Colors**: Use high-contrast palette (1=red, 2=yellow, 3=green, 4=blue, 5=magenta)
2. **Create Tag Mode**: Generate shop drawing tags for field reference
3. **Legend**: After placement, create legend: "A = JHA35/47 (187×), B = JHA47/75 (103×)..."
4. **Color Printing**: Export shop drawings with colors for visual QA

### Quality Assurance

1. **Selection Log Review**: Always check after bulk placement
2. **BOM Validation**: Compare hanger quantities to joist count (should match)
3. **Visual Inspection**: Verify hangers appear on correct beam faces
4. **Spot Checks**: Manually inspect 5-10% of connections for alignment

### Settings Management

1. **Company Standards**: Export global settings to shared network location
2. **Project Templates**: Create project-specific settings for building types
3. **Version Control**: Date settings files (e.g., `GenericHanger_Settings_2025-03.xml`)
4. **Backup Catalogs**: Export manufacturer definitions before modifying

### Performance Optimization

1. **Freeze Unused Layers**: Reduce entity count in active viewport
2. **Close Properties Panel**: Recalculation faster when OPM is closed
3. **Batch Processing**: Process by floor or zone (50-100 hangers per batch)
4. **Night Runs**: For 500+ hanger projects, run overnight

### Integration with Other Tools

1. **hsbEntityTag**: Use for shop drawing callouts
2. **HSB_G-BillOfMaterial**: Export hardware schedules
3. **hsbLayoutDim**: Dimension hanger locations on shop drawings
4. **HSB_D-Element**: Color-code elements by group (match hanger assignment)

---

## Frequently Asked Questions

### General Usage

**Q: Can I use GenericHanger for connections other than T-connections (e.g., beam-to-column, rafter-to-ridge)?**

A: Yes. "T-connection" refers to the geometric relationship (one member perpendicular to another), not the structural element types. Beam-to-column, rafter-to-ridge, joist-to-girder are all T-connections. The tool works with any Beam, Truss, or Panel entities in a T-configuration.

**Q: What's the difference between "Stretch Incoming Joist = Yes" and setting a Gap?**

A:
- **Stretch = No**: Joist length is unchanged. Hanger placed at current joist end position.
- **Stretch = Yes, Gap = 0**: Joist is extended/trimmed to align end face with female beam face (tight fit).
- **Stretch = Yes, Gap = 5mm**: Joist is extended/trimmed to position end face 5mm away from female beam face (clearance).

**Q: When should I use `<Automatic>` vs manually selecting a product?**

A:
- **Use Automatic**: For standard framing where joist sizes vary. Tool optimizes for smallest hanger that fits.
- **Manual Selection**: When project specs require specific model (e.g., client-approved products, fire rating requirements, or matching existing hardware).

**Q: How do I add a manufacturer not in the default list?**

A:
1. Create XML file: `GenericHanger_[Manufacturer].xml` (use existing as template)
2. Place in `[Company]\Settings\` folder
3. Restart hsbCAD or use `Import Hanger Definitions`
4. Manufacturer appears in dropdown

**Q: Can I use this tool for international projects (metric/imperial)?**

A: Yes. All dimensions use `U()` function for unit conversion. Open XML with text editor, verify `<unit ut="L" uv="millimeter"/>` or `uv="inch"` matches your drawing units. Product dimensions auto-convert.

### Product and Hardware

**Q: The product I need isn't in the catalog. What do I do?**

A:
1. **Option 1 (Quick)**: Right-click hanger → `Add/Edit Product` → Enter dimensions → Save
2. **Option 2 (Permanent)**: Edit manufacturer XML → Add `<lst nm="ProductName">` entry → Import
3. **Option 3 (Supplier)**: Request XML catalog from hardware supplier → Import

**Q: How do I know what dimensions (A, B, C, D, E, F, t) to enter for a custom product?**

A:
- **A**: Measure inside width of hanger sidewalls (joist width capacity)
- **B**: Measure inside height from seat to top (minimum joist height)
- **D**: Measure horizontal seat depth (bearing surface)
- **E**: Measure total vertical height (excluding top flange if any)
- **t**: Material thickness (typically 1.5-3mm for steel)
- **C, F**: Leave as 0 (reserved for future use)

Refer to manufacturer's technical drawings or measure physical sample.

**Q: The BOM shows more fasteners than expected. Why?**

A: Check fixture configuration:
- If **Entry Name = blank** and product defines `Header=4, Joist=8`: Total = 12 fasteners
- If **Entry Name = custom** with multiple hardware types: Sum all quantities
- If **Quantity = 0** with name "Header": Uses product's Header count (not 0)

Review: Right-click → `Add/Edit Fixtures` → Check quantities

**Q: Can I use different fixtures for different hangers in the same project?**

A: Yes. Each hanger instance has independent `Fixture → Entry Name` property. Select individual hangers and change via Properties panel. For bulk changes, use painter filters or manual selection sets.

### Geometry and Alignment

**Q: Hangers are placed on the wrong side (hanger body collides with joist approach direction). How do I fix?**

A: Right-click hanger → `Flip Side`. This mirrors the hanger to the opposite side of the female beam centerline. Common scenario: Joists approaching from left should have hanger on right side of beam.

**Q: The tool says "No valid female part" even though I selected a beam. What's wrong?**

A: Validation failed for one of these reasons:
1. **Not a T-connection**: Male and female are parallel (no perpendicular intersection)
2. **No intersection**: Beams don't physically touch
3. **Wrong entity type**: Selected entity is dimension line, text, or non-structural object
4. **Filtered by painter**: If using custom painter, beam may not match filter criteria

**Solution**: Verify geometry in 3D view. Ensure male axis crosses female beam.

**Q: Can I use GenericHanger for skewed connections (non-90° angles)?**

A: Yes, if products support skewed angles:
1. **Check Product**: Verify `MinAlpha` and `MaxAlpha` in product definition (e.g., `MinAlpha=15, MaxAlpha=45` supports 15-45° connections)
2. **Enable Tolerance**: Right-click → `Allow Angle Deviation` (accepts ±2° for perpendicular products)
3. **Manual Selection**: Use specific skewed hanger products (e.g., Simpson LUS, Rothoblaas WHT skewed models)

**Q: What happens if my connection angle changes after hanger placement?**

A: Hanger recalculates when beam geometry changes (if dependency tracking is active). However:
- **Small changes (±2°)**: Hanger updates position
- **Large changes**: May require manual re-selection or flip
- **Exceeds product range**: Tool may delete hanger or show error

Always verify after major geometry edits.

### Stiffeners and Backers

**Q: When do I need web stiffeners vs backer blocks?**

A:
- **Web Stiffeners**: Required for I-joists and open-web trusses to prevent web buckling under hanger loads. Code typically requires vertical blocking between flanges at each hanger.
- **Backer Blocks**: Required when hanger seat doesn't fully bear on female beam (e.g., I-beam female, narrow LVL). Provides continuous horizontal bearing surface.
- **Both**: I-joist (male) to I-beam (female) typically needs both.

Consult structural engineer or code requirements.

**Q: Why are my backer blocks merging into one long member?**

A: **Intentional behavior**. When multiple hangers are close together on the same beam, tool creates one continuous backer block to save material and improve load distribution. Each hanger maintains reference to shared backer.

**Q: Can I manually edit stiffener/backer dimensions after placement?**

A: Yes:
1. Right-click hanger → `Edit Stiffener / Backer Block Properties`
2. Change Length, Extra Length, Gap, Material, Color
3. Properties apply to current hanger's reinforcement only
4. For global changes: Edit settings XML → Import

**Q: The backer block doesn't appear. Why?**

A: Check:
1. **Stiffener property**: Must be set to `Backer Block` or `Both` (not `Disabled`)
2. **Female member type**: Trusses and SIP panels don't support backers (no web to back)
3. **Geometry**: Tool checks if hanger seat area differs from beam section. If perfect fit, no backer needed.

### Bulk Operations and Performance

**Q: Bulk insertion created 180 hangers instead of expected 200. Where are the missing 20?**

A: Check `Show Selection Log` for rejection reasons:
- **Parallel beams**: Some "males" are actually parallel to "females" (no T-connection)
- **No intersection**: Beams too far apart or don't overlap
- **Product unavailable**: Joist dimensions exceed all product ranges
- **Angle out of range**: Connection angle doesn't match any product's MinAlpha/MaxAlpha

**Solution**: Place missing hangers manually or relax filters.

**Q: How long should bulk insertion take?**

A: Performance benchmarks:
- **50 hangers**: 5-10 seconds
- **200 hangers**: 30-60 seconds
- **500 hangers**: 2-5 minutes
- **1000+ hangers**: 5-15 minutes

Depends on hardware, drawing complexity, and entity count. Tool prints progress dots (`.`) during processing.

**Q: Can I cancel bulk insertion mid-process?**

A: Press **Esc** to interrupt. Already-created hangers remain; incomplete hangers are not created. Tool deletes distributor instance cleanly.

**Q: How do I apply the same hanger type to all connections (override automatic selection)?**

A: Two methods:
1. **Before Insertion**: Set Product to specific model (e.g., "JHA35/47"), Stretch = Yes. Tool forces this product for all connections.
2. **After Insertion**: Select all hangers → Properties → Product → Set to desired model → All update simultaneously.

### Tagging and BOM

**Q: What's the difference between "Set Tag" and "Set + Create Tag" modes?**

A:
- **Set Tag**: Assigns alphanumeric ID (A, B, C...) to hanger's `modelDescription` property only. Visible in Properties panel and BOM exports.
- **Set + Create Tag**: Same as above + creates hsbEntityTag instance (visual tag in Model Space) below each hanger. Visible in shop drawings.

**Q: Tags are out of order (C appears before B). How do I fix?**

A: Tags sort by **quantity**, not alphabetically:
- Most common hanger = A
- Second most = B
- Etc.

If you change hanger types (edit Product property), tags become stale. **Re-trigger tagging**:
1. Select any hanger
2. Change Manufacturer or Family (then change back)
3. Tool recalculates all tags in drawing

**Q: Can I export the tag legend to Excel?**

A: Yes, via BOM export:
1. `HSB_G-BillOfMaterial`
2. Filter to show GenericHanger instances
3. Group by `modelDescription` (tag)
4. Export to CSV/Excel
5. Columns include: Tag, Product, Quantity, Manufacturer

### Settings and Configuration

**Q: I shared my settings XML with a colleague, but they don't see my custom products. Why?**

A: Two files required:
1. **Global Settings**: `GenericHanger.xml` (contains fixtures, stiffener defaults, tag settings)
2. **Manufacturer Catalog**: `GenericHanger_[Manufacturer].xml` (contains products)

Share both files. Place in `[Company]\Settings\` folder.

**Q: Can I password-protect or lock manufacturer catalogs?**

A: No built-in locking. Workarounds:
1. **File permissions**: Set XML as read-only via Windows file properties
2. **Network location**: Store master catalog on shared drive, distribute copies
3. **Version control**: Use Git/SVN to track changes

**Q: How do I reset to factory defaults?**

A:
1. Delete `[Company]\Settings\GenericHanger*.xml`
2. Restart hsbCAD
3. Tool loads defaults from `[Install]\Content\General\TSL\Settings\`

---

## Related Scripts and Integration

### Core Timber Framing Tools

- **hsbBeamcut**: Modify joists with end cuts for hanger clearance
- **hsbBlocking**: Add solid blocking between joists (alternative to hangers for some applications)
- **HSB_W-Blocking**: Wall-specific blocking for header-to-stud connections
- **FLR_LADDER**: Create ladder blocking for I-joist floors (used with hangers for lateral support)

### Hardware and Connections

- **GA.mcr**: Generic angle bracket system (similar parametric approach, for corner connections)
- **Simpson StrongTie *.mcr**: Manufacturer-specific scripts for specialized products (e.g., `SimpsonStrongTieEL.mcr` for elevated post bases)
- **Hilti-P2P.mcr**: Post-to-post connectors (complement to beam-to-beam hangers)

### Tagging and Documentation

- **hsbEntityTag**: Manual tagging tool (used by GenericHanger in Create Tag mode)
- **hsbViewTag**: Create tagged views for shop drawings
- **HSB_D-Element**: Display element information (shows hanger groups in color)

### BOM and Reporting

- **HSB_G-BillOfMaterial**: Export hardware schedules with quantities and costs
- **hsbScheduleTable**: Create tabular schedule of hangers in drawing
- **HSB_G-PropertyMapping**: Map hanger properties to custom fields for export

### Shop Drawings

- **sd_BeamAssembly**: Generate assembly drawings with hanger callouts
- **hsbLayoutDim**: Dimension hanger locations on plans
- **HSB_D-Sheet**: Create sheet-level views showing hanger distribution

### Workflow Integration

1. **Frame Model**: hsbCreateElement (walls, floors, roofs)
2. **Place Hangers**: GenericHanger (bulk insertion)
3. **Tag**: Enable Create Tag mode (automatic)
4. **Dimension**: hsbLayoutDim (shop drawings)
5. **BOM**: HSB_G-BillOfMaterial (hardware list)
6. **Export**: bauBIT-Exporter (CNC/manufacturing data)

---

## Advanced Techniques

### Custom Painter Filters

**Create Project-Specific Selection Filters:**

1. **Open Painter Definition Manager**: hsbCAD menu → Painter Definitions
2. **Create Collection**: Name = `GenericHanger`
3. **Add Definition**: Name = `FloorJoists`
   - Type: `Beam`
   - Layer: `FLOOR_FRAMING`
   - Material: `Spruce` (or specific grade)
   - Dimension filter: Width = 38mm, Height = 220-240mm
4. **Add Definition**: Name = `RimBeams`
   - Type: `Beam`
   - Layer: `FLOOR_RIM`
   - Width: 63-90mm
5. **Use in GenericHanger**:
   - Male: Select `FloorJoists`
   - Female: Select `RimBeams`
   - Bulk select entire building → Tool filters automatically

**Benefits:**
- Reusable across multiple floors
- Prevents accidental selection of bracing, blocking, or temporary members
- Faster than manual filtering in large drawings

### Scripted Insertion for Automation

**LISP Command Creation:**

Create custom toolbar button that pre-configures hanger settings:

```lisp
; File: FloorHanger.lsp
; Usage: Load via APPLOAD, then type FLOORHANGER

(defun c:FLOORHANGER ()
  (hsb_ScriptInsert "GenericHanger" "StrongTie UK?JHA")
  ; Pre-selects Manufacturer: StrongTie UK, Family: JHA
)
```

**Batch Processing:**

For multi-building projects, create script that processes each building:

```lisp
(defun c:BULKHANGER ()
  (setq buildings (list "Building_A.dwg" "Building_B.dwg" "Building_C.dwg"))
  (foreach dwg buildings
    (command "OPEN" dwg)
    (hsb_ScriptInsert "GenericHanger")
    ; ... automated selection logic ...
    (command "QSAVE")
  )
)
```

### XML Catalog Maintenance

**Merge Multiple Manufacturer Catalogs:**

```xml
<!-- Combined catalog: GenericHanger_ProjectX.xml -->
<Hsb_Map>
  <lst nm="Manufacturer[]">
    <!-- Import products from Supplier A -->
    <lst nm="SupplierA">
      <!-- Copy <lst nm="Family[]"> from SupplierA XML -->
    </lst>

    <!-- Import products from Supplier B -->
    <lst nm="SupplierB">
      <!-- Copy <lst nm="Family[]"> from SupplierB XML -->
    </lst>
  </lst>
</Hsb_Map>
```

**Batch Product Addition (via Excel):**

1. Export existing catalog to XML
2. Convert XML to Excel (use online tool or Python script)
3. Add rows for new products
4. Convert Excel back to XML
5. Import via `Import Hanger Definitions`

**Python Example (Conceptual):**
```python
import xml.etree.ElementTree as ET
import pandas as pd

# Parse existing XML
tree = ET.parse('GenericHanger_StrongTie.xml')
root = tree.getroot()

# Load new products from Excel
df = pd.read_excel('NewProducts.xlsx')

# Add products to XML tree
for _, row in df.iterrows():
    product = ET.SubElement(family, 'lst', nm=row['ProductName'])
    ET.SubElement(product, 'dbl', nm='A', ut='L', vl=str(row['Width']))
    # ... add other parameters

# Save modified XML
tree.write('GenericHanger_StrongTie_Updated.xml')
```

### Integration with External Databases

**Link to ERP/PLM Systems:**

For enterprise environments, sync hanger catalogs with product database:

1. **Export from ERP**: Query hardware products → CSV
2. **Transform to XML**: Use Python/C# script to convert CSV to GenericHanger XML format
3. **Auto-Import**: Schedule daily import via task scheduler
4. **Push BOM back**: After placement, export BOM → Import to ERP for procurement

**Example Workflow (Construction Company):**
```
ERP (Product Master)
  ↓ (nightly export)
GenericHanger_Company.xml
  ↓ (designer uses)
hsbCAD Model with Hangers
  ↓ (export BOM)
Material Takeoff CSV
  ↓ (import to ERP)
Purchase Orders
```

---

## Version History and Compatibility

### Current Version: 1.25 (March 19, 2025)

**Recent Changes:**
- **1.25** (HSB-23725): Top-mounted hanger bugfix
- **1.24** (HSB-23403): New angle deviation toggle, improved angled hangers, enhanced web stiffeners, command to disable stretching
- **1.23** (HSB-23403): Hangers now accept range of angles (not just exact perpendicular)
- **1.22** (HSB-23507): Cancel in Add/Edit Product no longer prompts for entities
- **1.21** (HSB-23101): Invalid tagging configuration doesn't break insertion, enhanced issue reporting
- **1.20** (HSB-23031): New property for group assignment specification
- **1.19** (HSB-22462): New context commands for tag behavior, validation of manufacturer products
- **1.18** (HSB-22462): Improved auto product detection, manufacturer filtering, bulk insertion for beam connections

**Legacy Versions:**
- **1.0-1.17** (2022-2023): Initial development, EWP support, skewed hangers, custom fixtures, multi-insert
- **0.1-0.9** (2022): Beta testing, core functionality

### Compatibility

**hsbCAD Versions:**
- Minimum: hsbCAD 22 (2022)
- Recommended: hsbCAD 24+ (2024 or later) for full feature support

**Dependencies:**
- **TslUtilities.dll**: Dialog service (included in hsbCAD installation)
- **hsbEntityTag**: Optional, required only for Create Tag mode
- **Manufacturer XMLs**: At least one manufacturer catalog required

**Platform:**
- AutoCAD 2020-2025 (or BricsCAD equivalent)
- Windows 10/11
- .NET Framework 4.7+

---

## Command Reference

### LISP Commands

**Standard Insertion:**
```lisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger")) TSLCONTENT
```

**Pre-configured Manufacturer/Family:**
```lisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger" "StrongTie?ITSE")) TSLCONTENT
```
Format: `"Manufacturer?Family"`

**Context Menu Triggers:**
```lisp
; Flip Side
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select hanger|"))) TSLCONTENT

; Show Issues
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Report Issues|") (_TM "|Select hanger|"))) TSLCONTENT
```

**Batch Processing (Select Multiple Hangers):**
```lisp
; Update all selected hangers to use specific product
(defun c:UPDATEHANGERS ()
  (setq ss (ssget '((0 . "TSLINSTANCE")))) ; Select TslInst entities
  ; ... iterate and update Product property ...
)
```

### Keyboard Shortcuts (Recommended)

Create custom shortcuts in AutoCAD CUI:

- **GH**: GenericHanger standard insertion
- **GHJ**: GenericHanger with JHA family (floor joists)
- **GHI**: GenericHanger with ITW family (I-joists)
- **GHFLIP**: Flip side command

---

## Glossary

| Term | Definition |
|------|------------|
| **Male Member** | Incoming joist, rafter, or beam that is supported by the hanger (perpendicular to female) |
| **Female Member** | Supporting beam, girder, or panel that carries the hanger and male member (parallel to hanger axis) |
| **T-Connection** | Geometric configuration where one member's axis is perpendicular to another's bearing surface |
| **Posnum** | Position number; unique identifier grouping identical hardware configurations (used for tagging) |
| **Compare Key** | String hash of hanger configuration (manufacturer + family + products + quantities) used to assign posnum |
| **Painter Definition** | hsbCAD feature for filtering entities by properties (layer, material, type, dimensions) |
| **Web Stiffener** | Vertical blocking installed between I-joist flanges at hanger locations to prevent web buckling |
| **Backer Block** | Horizontal blocking installed between hanger and supporting beam web to provide bearing surface |
| **Fixture** | Fastener configuration (screws, nails, bolts) used to attach hanger to wood members |
| **Envelope Body** | Simplified 3D solid representing outer boundary of beam (faster calculation than full geometry) |
| **Plane Profile** | 2D projection of 3D body onto a plane (used for intersection and dimension calculations) |
| **RepType** | Representation type; `_kRTTsl` marks hardware as script-generated (vs manual) |
| **Execute Key** | Internal trigger string for recalc commands (e.g., "Flip Side", "Add Entities") |
| **MapObject** | Persistent dictionary object for storing settings across sessions |
| **Alphanumeric Tag** | Sequential letter identifier (A, B, C, ... Z, AA, AB...) assigned based on hanger frequency |

---

**Documentation Version**: 2.0 (Generated for GenericHanger v1.25)
**Last Updated**: 2025-02-21
**Target Audience**: CAD operators, timber frame designers, structural detailers
**Feedback**: Report issues via hsbCAD support or project issue tracker
