# hsb_Apply Naillines to Elements

## Overview and Purpose

**hsb_Apply Naillines to Elements** is a comprehensive automated nailing calculation and export system for wall and floor elements in hsbCAD. This script analyzes the structural framing and sheeting geometry within an element, automatically generates nailing patterns for up to 10 independent sheeting zones, calculates nail quantities, and exports detailed nailing specifications for CNC manufacturing, material scheduling, and fabrication shop drawings.

The script handles complex framing scenarios including headers around openings, king studs, supporting beams, angled top plates, trusses, battens, and scarf joints. It distinguishes between perimeter nailing (tighter spacing near sheet edges and openings) and intermediate nailing (wider spacing in sheet field areas), applies staggering options to prevent nail congestion, and can optimize nailing patterns on banks of studs to reduce material waste.

This is one of the most sophisticated nailing automation tools in the hsbCAD ecosystem, serving as the critical link between design geometry and manufacturing output.

---

## Script Classification

| Property | Value |
|----------|-------|
| **Category** | Base / Function |
| **Script Type** | O-Type (Object Script) |
| **Environment** | Model Space |
| **Required Beams** | 0 (attaches to elements) |
| **Implicit Insert** | Yes (prompts for element selection) |
| **DXA Output** | Enabled (exports to databases) |
| **Sequence Number** | 50 (runs after framing scripts) |

---

## Technical Metadata

| Detail | Value |
|--------|-------|
| **Version** | 3.11 |
| **Major Version** | 3 |
| **Minor Version** | 11 |
| **Last Modified** | November 14, 2025 |
| **Original Author** | Alberto Jena (hsbSOFT) |
| **Units** | Millimeters (internally) |
| **File State** | Production |

### Version History Highlights

- **3.11** (Nov 2025): Added zone-specific beam filter override capability
- **3.10** (Nov 2025): Integrated with HSB_G-FilterGenBeams for advanced beam filtering
- **3.8** (Jul 2025): Added support for truss elements
- **3.4** (Nov 2024): Implemented hardware component export for Excel reports
- **3.0** (Feb 2024): General overhaul and consolidation of multiple versions
- **1.72** (Jan 2022): Enhanced header nailing logic
- **1.15** (Jan 2010): Expanded from 2 zones to 10 zones

---

## Prerequisites

Before using this script, ensure the following conditions are met:

1. **Element Existence**: One or more wall or floor **elements** must exist in the drawing with properly configured framing members (studs, plates, headers, joists) and sheeting panels.

2. **Zone Configuration**: Sheeting zones on the element must be configured correctly:
   - Zones 1-5 correspond to positive zone indices (+1 through +5, typically front/exterior side)
   - Zones 6-10 correspond to negative zone indices (-1 through -5, typically back/interior side)
   - Each zone represents a distinct sheeting layer (e.g., exterior OSB, interior gypsum board)

3. **CNC Module** (Optional): If you plan to generate actual CNC nailing output (NailLine entities in the element database), the **hsbCAD CNC Module** must be licensed and available. Without this module, set "Apply CNC Nailing Information?" to **No** to export only nailing quantities and descriptions for reporting.

4. **Beam Filter TSL** (Optional): If you want to use advanced beam filtering via the "Filter definition beams" parameter, the **HSB_G-FilterGenBeams** TSL must be loaded in the current drawing with predefined filter catalog entries.

5. **Dimension Style**: A suitable AutoCAD dimension style should be configured if you wish to display on-screen nailing descriptions (perimeter/intermediate spacing text).

6. **Drawing Units**: The drawing should use either millimeters or inches. The script internally converts all dimensions using the `U()` function to ensure unit consistency.

---

## Key Concepts

### Zone System Explained

The script operates on a **10-zone system** where each zone represents a distinct sheeting layer on the element:

| Property Panel Zone | Element Zone Index | Typical Use | Element Side |
|---------------------|-------------------|-------------|--------------|
| Zone 1 | +1 | Exterior OSB sheathing | Positive (front/exterior) |
| Zone 2 | +2 | Exterior finish layer or second sheathing | Positive (front/exterior) |
| Zone 3 | +3 | Additional exterior layer | Positive (front/exterior) |
| Zone 4 | +4 | Additional exterior layer | Positive (front/exterior) |
| Zone 5 | +5 | Additional exterior layer | Positive (front/exterior) |
| Zone 6 | -1 | Interior gypsum board | Negative (back/interior) |
| Zone 7 | -2 | Second interior layer | Negative (back/interior) |
| Zone 8 | -3 | Additional interior layer | Negative (back/interior) |
| Zone 9 | -4 | Additional interior layer | Negative (back/interior) |
| Zone 10 | -5 | Additional interior layer | Negative (back/interior) |

**Important Notes:**
- Most wall assemblies use only **Zone 1** (exterior sheathing) and **Zone 6** (interior finish).
- Enable additional zones only when the element has multiple sheeting layers (e.g., structural OSB + external finish board + interior gypsum + interior finish).
- Each zone operates independently with its own nailing parameters, tool indices, and spacing values.

### Reference Zone Concept

The **Nailing Reference Zone** parameter allows one zone to calculate its nail lines based on the framing geometry of a different zone. This is critical when:
- Sheeting on the exterior must be nailed to framing that is only visible in the interior zone
- A finish layer must use the same nailing pattern as a structural layer beneath it
- Cross-referencing between positive and negative sides is needed

**Example:** If exterior finish boards (Zone 2) should be nailed at the same stud locations as the structural OSB (Zone 1), set Zone 2's "Nailing Reference Zone" to **1**.

**Rules:**
- Reference Zone = 0 means "use this zone's own framing geometry" (self-referencing, most common)
- Zones 1-5 can reference zones 0, 1, 2, 3, 4, 5
- Zones 6-10 can reference zones 0, 6, 7, 8, 9, 10
- Cross-referencing between positive and negative sides is not supported

### Perimeter vs. Intermediate Nailing

The script automatically classifies each nail line as either **perimeter** (edge) or **intermediate** (center field) based on structural requirements:

**Perimeter Nailing** is applied when:
- The nail line is within ~half the beam width + 1mm of the nearest sheet edge
- The beam type is inherently a perimeter member (TopPlate, BottomPlate, LeftStud, RightStud, AngleTopPlate)
- The beam is a KingStud or SupportingBeam intersecting with the opening zone
- The nail line is on a header edge (left, right, top, bottom depending on adjacent framing)

**Intermediate Nailing** is applied for:
- All other nail lines in the field of the sheet panel, away from edges
- Interior studs in multi-stud banks (when not optimized out)

**Typical Values:**
- Perimeter Spacing: 100mm (4 inches) - tighter spacing for structural requirements
- Intermediate Spacing: 200mm (8 inches) - wider spacing for cost efficiency

### Beam Filtering and Exclusion

The script provides multiple mechanisms to exclude beams from nailing:

1. **Automatic Exclusion:**
   - Beams thinner than 20mm (too narrow for reliable nailing)
   - Dummy beams (_kDummyBeam type)
   - Locating plates (_kLocatingPlate type)
   - Beams not in Zone 0 (the structural frame zone)

2. **Beam Code Exclusion:**
   - Enter beam codes in "Exclude beams with Code" parameter (semicolon-separated)
   - Any beam whose first beam code token matches the list is excluded
   - Useful for specialty members like temporary bracing or alignment beams

3. **Advanced Filtering (HSB_G-FilterGenBeams):**
   - Global filter: Set in Standard Properties "Filter definition beams" - applies to all zones
   - Zone-specific filter: Set in individual zone parameters - overrides global filter for that zone
   - Filters must be predefined in the HSB_G-FilterGenBeams TSL catalog
   - If a filter is selected but the filter TSL is not loaded, the script displays an error and terminates

### Header Nailing Logic

Headers around openings receive special treatment to ensure proper fastening while avoiding double-nailing:

**Analysis Process:**
1. Script identifies headers and checks for adjacent jacks (above and below opening), transoms, and top plates
2. Vertical nail lines are **always** placed on left and right edges where header intersects sheeting
3. Horizontal nail line on **bottom edge** only if there is **no transom** below the header
4. Horizontal nail line on **top edge** only if there is **no top plate** directly above the header

**Rationale:** This approach prevents double-nailing where headers meet other perimeter members (which have their own nail lines), while ensuring all exposed header edges receive proper fastening.

### Truss Support

The script automatically handles truss entities within the element:

1. **Detection:** Identifies truss objects in the element group
2. **Temporary Beam Conversion:** Creates temporary beam representations from truss body geometry
3. **Nailing Calculation:** Generates nail lines through sheeting attached to truss members
4. **Cleanup:** Removes temporary geometry after nailing calculations complete
5. **Treatment:** Treats the truss body as a single continuous beam for nailing purposes

This allows automatic nailing of roof sheeting to truss top chords without manual intervention.

### Scarf Joint Handling

When beams contain scarf joints (created via "hsb_SplitBeamsWithScarfJoint" or "scandibyg_SplitBeamsWithScarfJoint" scripts):
- The script detects the scarf joint location via tool instances attached to the beam
- Nail lines are **split** to avoid nailing through the joint area
- A rectangular exclusion zone (~400mm long) is created around the joint
- This prevents nails from compromising the structural integrity of the scarf joint

---

## Usage Instructions

### Step 1: Launch the Script

Insert the script using the **TSLINSERT** command:

```
Command: TSLINSERT
Script name or path: hsb_Apply Naillines to Elements
```

**Alternative Methods:**
- If you have saved catalog presets, launch from the catalog browser
- Previously used configurations are automatically recalled
- Named presets can be applied via execute keys

### Step 2: Configure Standard Properties

When the Properties Panel appears, first configure the **Standard Properties** group:

#### CNC Module Settings

| Parameter | Recommended Value | Notes |
|-----------|------------------|-------|
| **Apply CNC Nailing Information?** | No (initially) | Set to Yes only when ready for CNC output. Start with No to verify quantities in reports first. |
| **Dim Style** | (your drawing standard) | Dimension style for on-screen nailing description text |
| **Show in Disp Rep** | (leave empty or enter name) | Leave empty to show in all views, or enter a display representation name to show only in that specific view |

#### Frame Nailing Settings

| Parameter | Recommended Value | Notes |
|-----------|------------------|-------|
| **Do you want to apply Frame Nailing Information?** | No (optional feature) | Enable to export frame-to-frame nailing (studs to plates) in addition to sheet-to-frame nailing |
| **Nail Model for Frame** | (select from catalog) | Choose from DuoFast, Paslode strip nails (3.1-3.3mm x 90mm) |
| **Other Nail Type (Frame)** | (leave default) | Only fill if "Other Nail Type" selected above |

**Frame Nailing Note:** The frame nailing calculation is simplified (4 nails for beams <100mm height, 6 for beams <200mm, 8 for beams >200mm). This provides material estimates but should be verified against engineering specifications.

#### Optimization Settings

| Parameter | Recommended Value | Notes |
|-----------|------------------|-------|
| **Stagger nail lines** | No (unless needed) | Offsets nail line start points between zones to avoid multiple nails at same location |
| **Stagger nail lines at stud joint** | Yes (recommended) | Offsets nail lines by half spacing where sheets join on same stud, prevents nail congestion and splitting |
| **Optimize nailing** | Yes (for cost savings) | Reduces nail lines on interior studs in multi-stud banks where not structurally necessary |
| **Show nailing description** | Yes (for verification) | Displays perimeter/intermediate spacing text (e.g., "100 / 200") near element in drawing |

#### Global Constraints

| Parameter | Recommended Value | Notes |
|-----------|------------------|-------|
| **Minimum Nailing Line Length** | 30-50 mm | Nail lines shorter than this are suppressed. Prevents impractical very short nail lines near corners. |
| **Exclude beams with Code** | (enter codes if needed) | Semicolon-separated list of beam codes to exclude (e.g., "TEMP;BRACE;ALIGN") |
| **Filter definition beams** | (select if using filters) | Global beam filter from HSB_G-FilterGenBeams catalog. Applies to all zones unless overridden. |

### Step 3: Configure Zone Parameters

Enable and configure each zone you need. **Most common scenario:** Enable only Zone 1 (exterior sheathing) and Zone 6 (interior finish).

#### For Each Active Zone:

**Enable the Zone:**
- Set "Do you want to nail Zone N?" to **Yes**

**Basic Nailing Parameters:**

| Parameter | Typical Value | Description |
|-----------|---------------|-------------|
| **Nailing Reference Zone** | 0 (self) | Set to 0 for self-referencing. Set to another zone number to use that zone's framing geometry. |
| **Nailing Tool index** | 1 | CNC tool index for standard nail lines. Corresponds to machine tool number. |
| **Perimeter Nail Spacing** | 100 mm (4") | Distance between nails at sheet edges and around openings. |
| **Intermediate Nail Spacing** | 200 mm (8") | Distance between nails in sheet field areas. |
| **Edge Offset** | 20 mm | Distance from nail line end to beam end. Prevents nails too close to beam ends. |
| **Sheet Edge Offset** | 8 mm | Minimum distance between nail line and sheet/beam edge. Areas narrower than 2× this value are skipped. |

**Material and Fastener Selection:**

| Parameter | Notes |
|-----------|-------|
| **Zone Material to be Nailed** | Leave empty to nail all sheets, or enter specific material name (e.g., "OSB", "Gypsum") to nail only that material |
| **Nail Model for Zone N** | Select from catalog (see Fastener Catalog section below) |
| **Other Nail Type Zone N** | Only fill if "Other Nail Type" selected above |

**Tilt Tool Settings** (CNC machines with tilting nail guns):

| Parameter | Typical Value | Notes |
|-----------|---------------|-------|
| **Tilt the Tool** | No (unless machine supports) | Enable if CNC machine can tilt the nailing head for edge nailing |
| **Minimum Distance to Tilt the Tool** | 10 mm | When nail line is closer than this to beam edge, use tilted tool index |
| **Offset Tilt Nailline** | 0 mm | Shifts tilted nail line position. Positive = toward center, Negative = toward edge |
| **Tool index Tilted Left** | 2 | CNC tool index when tilting for left edge nailing |
| **Tool index Tilted Right** | 3 | CNC tool index when tilting for right edge nailing |

**Zone-Specific Filtering:**

| Parameter | Notes |
|-----------|-------|
| **Filter definition beams (Zone)** | Leave empty to use global filter, or select zone-specific filter to override global filter for this zone only |

### Step 4: Select Elements

After confirming the Properties Panel:

1. The command line prompts: **"Select Elements:"**
2. Click on one or more wall or floor elements in the drawing
3. You can select multiple elements at once
4. The script creates a separate instance for each selected element
5. Press **Enter** or **Spacebar** to confirm selection

### Step 5: Automatic Processing

The script now runs automatically for each selected element:

**What Happens Internally:**

1. **Element Analysis:**
   - Identifies all framing beams in Zone 0 (structural frame)
   - Determines beam types (studs, plates, headers, joists, etc.)
   - Calculates beam orientations (horizontal, vertical, angled)

2. **Zone Iteration:**
   - Processes each enabled zone sequentially
   - Finds sheeting panels assigned to the zone
   - Applies material filter if specified

3. **Geometry Calculation:**
   - For each beam-sheet combination:
     - Calculates contact area between beam face and sheet
     - Determines if location is perimeter or intermediate
     - Applies appropriate spacing
     - Checks for minimum line length threshold
     - Handles headers with special logic (left, right, top, bottom edges)
     - Splits nail lines at scarf joints if present

4. **Truss Handling:**
   - Detects truss entities in element group
   - Creates temporary beam representations
   - Generates nail lines through sheeting
   - Cleans up temporary geometry

5. **Filtering:**
   - Excludes beams narrower than 20mm
   - Skips dummy beams and locating plates
   - Applies beam code exclusion list
   - Applies HSB_G-FilterGenBeams filters (global and zone-specific)

6. **Optimization:**
   - If "Optimize nailing" enabled: removes redundant nail lines on interior studs in multi-stud banks
   - If "Stagger at stud joint" enabled: offsets nail lines where sheets join on same stud

7. **CNC Output** (if enabled):
   - Creates NailLine entities in element database
   - Sets zone color coding
   - Assigns tool indices (standard, tilted left, tilted right)
   - Stores spacing values

8. **Data Export:**
   - Writes hardware components (SHEETNAILING, FRAMENAILING) for Bill of Material
   - Exports to DXA for database integration
   - Attaches "hsbElementNailing" property set to element for scheduling
   - Stores nailing info in element's HSB_ElementData MapX

9. **Visual Output:**
   - Displays small cross marker at element origin
   - Shows nailing description text if enabled (perimeter/intermediate spacing for Zone 1)

### Step 6: Review and Verify Results

After processing completes:

**Visual Verification:**
- Small cross marker appears at element origin indicating nailing data is attached
- If "Show nailing description" enabled: perimeter/intermediate spacing text appears near element (e.g., "100 / 200")
- Actual nail lines are visible in appropriate display representation (if CNC output enabled)

**Data Verification:**
1. **Bill of Material:** Check hsbCAD BOM for SHEETNAILING and FRAMENAILING hardware components with correct quantities
2. **Excel Reports:** Export element hardware to Excel to verify nail counts per zone
3. **Property Sets:** Use AutoCAD data extraction to view "hsbElementNailing" property set values
4. **DXA Output:** Check external database for exported nailing specifications

**Troubleshooting:**
- If nail quantities seem too low: Check zone enable settings, material filters, and beam exclusion lists
- If nail lines appear in wrong locations: Verify element zone configuration and reference zone settings
- If no nailing appears: Ensure sheeting exists in the specified zones and beams are in Zone 0
- If filter errors occur: Load the HSB_G-FilterGenBeams TSL and define required filters

---

## Properties Panel Reference

### Standard Properties Group

| Parameter | Type | Index | Default | Category |
|-----------|------|-------|---------|----------|
| Apply CNC Nailing Information? | PropString (Yes/No) | 53 | No | Standard Properties |
| Dim Style | PropString (dropdown) | 54 | (drawing styles) | Standard Properties |
| Show in Disp Rep | PropString | 55 | (empty) | Standard Properties |
| Do you want to apply Frame Nailing Information? | PropString (Yes/No) | 40 | No | Standard Properties |
| Nail Model for Frame | PropString (dropdown) | 41 | (catalog) | Standard Properties |
| Other Nail Type (Frame) | PropString | 42 | **Other Type** | Standard Properties |
| Stagger nail lines | PropString (Yes/No) | 56 | No | Standard Properties |
| Stagger nail lines at stud joint | PropString (Yes/No) | 58 | No | Standard Properties |
| Optimize nailing | PropString (Yes/No) | 59 | No | Standard Properties |
| Show nailing description | PropString (Yes/No) | 57 | No | Standard Properties |
| Minimum Nailing Line Length | PropInt | 50 | 0 mm | Standard Properties |
| Exclude beams with Code | PropString | 60 | (empty) | Standard Properties |
| Filter definition beams | PropString (dropdown) | 61 | (empty) | Standard Properties |

### Zone Parameters (Template)

Each zone (1-10) has identical parameter structure:

| Parameter | Type | Index Range | Default |
|-----------|------|-------------|---------|
| Zone to be Nail | PropInt (read-only) | 0,4,8... | (zone number) |
| Do you want to nail Zone N? | PropString (Yes/No) | 0,3,6... | No |
| Nailing Reference Zone | PropInt (dropdown) | 48,40,41... | 0 |
| Nailing Tool index | PropInt | 1,5,9... | 1 |
| Perimeter Nail Spacing | PropDouble | 0,5,10... | 100 mm |
| Intermediate Nail Spacing | PropDouble | 1,6,11... | 200 mm |
| Edge Offset | PropDouble | 2,7,12... | 20 mm |
| Sheet Edge Offset | PropDouble | 50,51,52... | 8 mm |
| Zone Material to be Nailed | PropString | 1,4,7... | (empty) |
| Nail Model for Zone N | PropString (dropdown) | 30,31,32... | (catalog) |
| Other Nail Type Zone N | PropString | 43,44,45... | **Other Type** |
| Tilt the Tool | PropString (Yes/No) | 2,5,8... | No |
| Minimum Distance to Tilt the Tool | PropDouble | 3,8,13... | 10 mm |
| Offset Tilt Nailline | PropDouble | 4,9,14... | 0 mm |
| Tool index Tilted Left | PropInt | 2,6,10... | 2 |
| Tool index Tilted Right | PropInt | 3,7,11... | 3 |
| Filter definition beams (Zone) | PropString (dropdown) | 62,63,64... | (empty) |

**Index Pattern Notes:**
- Each zone occupies a specific parameter index range to avoid conflicts
- Read-only zone numbers ensure catalog compatibility
- Property indices are carefully allocated to prevent overlap

---

## Fastener Catalog

### Sheet Nailing Fasteners

The script includes a comprehensive catalog of common sheet nailing fasteners:

| Manufacturer | Model | Size | Shank Type | Finish | ITW Code |
|--------------|-------|------|------------|--------|----------|
| DuoFast | IN plastic coil nail | 2.9×50mm | Smooth | EGalv | ITW312618 |
| DuoFast | IN plastic coil nail | 2.7×50mm | Ring | EGalv | ITW312586 |
| DuoFast | IN plastic coil nail | 2.7×65mm | Ring | EGalv | ITW312602 |
| DuoFast | GN plastic coil nail | 2.5×50mm | Ring | EGalv | ITW395931 |
| DuoFast | GN plastic coil nail | 2.5×65mm | Ring | EGalv | ITW395635 |
| NKT | Drywall screw | 3.8×35mm | - | EGalv | ITW137207 |
| NKT | Drywall screw | 3.8×45mm | - | EGalv | ITW136003 |
| NKT | Drywall screw | 3.8×55mm | - | EGalv | ITW136280 |
| Haubold | KG700 staple | 45mm | - | - | ITW574942 |
| Haubold | KG700 staple | 60mm | - | - | ITW574946 |
| Paslode | IM200 S16 fuel pack | 50mm | Staple | - | ITW921371 |
| DuoFast | S50 staple | 10mm | Stainless | - | ITW391330 |
| Paslode | S31 staple | 10mm | Stainless | - | ITW921574 |
| *Custom* | Other Nail Type | - | - | - | User-defined |

### Frame Nailing Fasteners

For frame-to-frame nailing (studs to plates, etc.):

| Manufacturer | Model | Size | Shank Type | Finish | ITW Code |
|--------------|-------|------|------------|--------|----------|
| DuoFast | Plastic strip nail | 3.3×90mm | Screw | EGalv | ITW312250 |
| Paslode | PL tape nail | 3.1×90mm | Screw | GalvPlus | ITW141017 |
| Paslode | PL tape nail fuel pack | 3.1×90mm | Smooth | GalvPlus | ITW141008 |
| *Custom* | Other Nail Type | - | - | - | User-defined |

**Selection Guidelines:**
- **Structural OSB:** Use ring shank coil nails (2.7-2.9mm × 50-65mm) for maximum withdrawal resistance
- **Gypsum board:** Use drywall screws (3.8mm × 35-45mm) for clean installation and adjustability
- **Exterior finish boards:** Use stainless staples or smooth shank nails for corrosion resistance
- **Custom applications:** Select "Other Nail Type" and enter your specification in the "Other Nail Type Zone N" field

---

## Data Export and Integration

The script writes nailing data in multiple formats for seamless integration with downstream systems:

### 1. Hardware Components (Bill of Material)

**SHEETNAILING Components:**
- Created for each active zone
- Quantity: Total nail count for the zone
- Material: Sheet material being nailed (e.g., "OSB", "Gypsum")
- Description: Fastener model and specification
- Notes field format: `"ZoneNumber;ElementNumber"`
  - Excel access: `@(Notes:T0)` for zone, `@(Notes:T1)` for element number
- Linked Entity: The element
- Rep Type: _kRTTsl (TSL-generated)

**FRAMENAILING Components:**
- Created if "Apply Frame Nailing Information?" = Yes
- Quantity: Estimated frame nail count
- Material: Frame material
- Description: Frame fastener model
- Notes field format: `";ElementNumber"`
- Linked Entity: The element

**Bill of Material Integration:**
- Hardware components appear in hsbCAD's Bill of Material reports
- Quantities aggregate across all instances on the same element
- Can be extracted to Excel for material ordering and cost estimation

### 2. DXA Export (Database Integration)

For each active zone, the script exports via DXA interface:

**Exported Fields:**
- Zone identifier (e.g., "Zone 1", "Zone 6")
- Fastener description (e.g., "DuoFast IN plastic coil nail 2.7x50mm ring shank")
- Nail quantity (total nails for the zone)

**Integration Points:**
- ERP systems (material procurement)
- MES systems (manufacturing execution)
- External databases (project data warehouses)
- Custom reporting tools

### 3. Property Set (AutoCAD Scheduling)

The script attaches a property set named **"hsbElementNailing"** to the element with the following fields:

**For Each Zone:**
- `PerimeterSpacing_Zone1` through `PerimeterSpacing_Zone10` (double, in drawing units)
- `IntermediateSpacing_Zone1` through `IntermediateSpacing_Zone10` (double, in drawing units)

**Usage:**
- Accessible through AutoCAD's data extraction wizard
- Can be displayed in schedules and tables
- Queryable via AutoLISP and ObjectARX
- Exported to spreadsheets via data extraction

### 4. Element MapX (Internal hsbCAD Data)

Nailing information is stored in the element's **HSB_ElementData** MapX:

**Structure:**
```
HSB_ElementData
├── Zone1
│   ├── PerimeterSpacing (double)
│   └── IntermediateSpacing (double)
├── Zone2
│   ├── PerimeterSpacing (double)
│   └── IntermediateSpacing (double)
└── ... (up to Zone10)
```

**Uses:**
- Accessed by other TSL scripts for downstream processing
- Used by shop drawing scripts for annotation
- Provides data for custom reporting tools
- Persistent storage with the element

### 5. NailLine Entities (CNC Output)

When "Apply CNC Nailing Information?" = Yes, the script creates **NailLine** entities in the element database:

**NailLine Properties:**
- **Zone Index:** Matches the sheeting zone (1, 2, 3, -1, -2, etc.)
- **Start Point:** Nail line start location in 3D space
- **End Point:** Nail line end location in 3D space
- **Spacing:** Distance between nails along the line
- **Tool Index:** CNC tool number (standard, tilted left, tilted right)
- **Color:** Set to zone index for visual differentiation
- **Reference Zone:** Stored in SubMapX "Nailing" map

**CNC Integration:**
- NailLine entities are read by hsbCAD CNC export modules
- Converted to machine-specific G-code or proprietary formats
- Tool indices map to actual nail gun configurations on the CNC machine
- Spacing values control nail driver trigger timing

---

## Advanced Features

### Multi-Stud Bank Optimization

When "Optimize nailing" is enabled, the script identifies banks of multiple studs (e.g., triple studs at posts) and reduces redundant nail lines:

**Logic:**
1. Detects beams marked with "Middle" submap key (interior studs in a bank)
2. Evaluates if the nail line is far from sheet edges (> distance threshold)
3. For king studs and interior studs, skips nail lines that are not structurally critical
4. Preserves nailing on outer studs and studs near openings

**Benefits:**
- Reduces material cost (fewer nails)
- Reduces machine time
- Maintains structural integrity where needed

**Caution:** Engineering review recommended. Some jurisdictions may require full nailing on all studs.

### Staggering Options

**Basic Stagger ("Stagger nail lines"):**
- Offsets nail line start points by 8mm × zone index
- Prevents multiple zones from placing nails at exactly the same stud location
- Reduces risk of nail collisions and splitting

**Stud Joint Stagger ("Stagger nail lines at stud joint"):**
- Detects where two sheet panels join on the same stud
- Offsets nail lines by half the perimeter spacing (typically 50mm)
- Distributes nailing load across a wider stud area
- Prevents nail congestion at sheet joints
- Highly recommended for structural integrity

### Tilt Tool Functionality

For CNC machines with tilting nail gun heads:

**Purpose:** When nailing near the edge of a beam, the gun can tilt inward to ensure proper nail penetration angle and prevent nail heads from protruding at the edge.

**Configuration:**
1. Enable "Tilt the Tool" for the zone
2. Set "Minimum Distance to Tilt the Tool" (typically 10mm)
3. Configure "Tool index Tilted Left" and "Tool index Tilted Right" to match your machine setup
4. Optionally set "Offset Tilt Nailline" to fine-tune nail line position

**Operation:**
- Script calculates distance from nail line to beam edge
- If distance < minimum: selects tilted tool index (left or right based on side)
- Optionally shifts the nail line position by offset value (positive = toward center)
- Tilted tool index is written to NailLine entity for CNC export

**Machine Requirements:**
- CNC nailing machine must support multiple tool indices with different tilt angles
- Tool indices must be configured in the machine controller
- Coordinate with your CNC programmer to match tool indices

### Beam Filtering System

The script integrates with **HSB_G-FilterGenBeams** TSL for advanced beam selection:

**Filter Types:**
- **Global Filter:** Set in Standard Properties "Filter definition beams"
  - Applies to all zones unless overridden
  - Useful for project-wide beam exclusion rules
- **Zone-Specific Filter:** Set in individual zone "Filter definition beams (Zone)"
  - Overrides global filter for that zone only
  - Useful when different zones need different beam selection criteria

**Filter Definition Process:**
1. Load **HSB_G-FilterGenBeams** TSL in the drawing
2. Create named filter definitions in the filter TSL catalog (e.g., "ExcludeTemporaryBeams", "OnlyPrimaryStuds")
3. In this script, select the filter name from the dropdown
4. The script passes the beam list to the filter TSL and receives filtered results

**Error Handling:**
- If a filter is selected but HSB_G-FilterGenBeams TSL is not loaded: script displays error and terminates
- If a filter name is not found in the catalog: script displays warning and continues without filtering

**Use Cases:**
- Exclude beams with specific material assignments
- Filter by beam depth or width ranges
- Select only beams with certain custom properties
- Implement company-specific nailing rules

---

## Troubleshooting Guide

### No Nailing Data Appears

**Symptoms:** Script completes but no nail lines or quantities are generated.

**Possible Causes:**
1. **No sheeting in zones:** Verify sheeting panels exist and are assigned to the correct zones
2. **Zones not enabled:** Check "Do you want to nail Zone N?" is set to Yes
3. **Beams not in Zone 0:** Only beams in the structural frame zone (0) are nailed
4. **Material filter mismatch:** If "Zone Material to be Nailed" is set, verify exact material name match
5. **All beams filtered out:** Check beam exclusion list and filter definitions

**Solutions:**
- Use hsbCAD's Element Inspector to verify zone assignments
- Ensure framing beams are in Zone 0 (not in sheeting zones)
- Leave "Zone Material to be Nailed" empty for initial testing
- Temporarily disable filters to verify beam availability

### Nail Quantities Too Low

**Symptoms:** Nailing quantities are much lower than expected.

**Possible Causes:**
1. **Optimization enabled:** "Optimize nailing" removes interior stud nail lines
2. **Minimum line length too high:** Short nail lines are being suppressed
3. **Sheet edge offset too large:** Narrow areas are being skipped (threshold = 2× offset)
4. **Beam code exclusion:** Beams are being excluded via beam code list
5. **Filter too restrictive:** HSB_G-FilterGenBeams filter is excluding needed beams

**Solutions:**
- Disable "Optimize nailing" for full coverage
- Reduce "Minimum Nailing Line Length" (try 0 for testing)
- Reduce "Sheet Edge Offset" from 8mm to 5mm
- Clear "Exclude beams with Code" field
- Disable filters temporarily

### Nail Lines in Wrong Locations

**Symptoms:** Nail lines appear on incorrect beams or at wrong positions.

**Possible Causes:**
1. **Reference zone incorrect:** Zone is using another zone's framing geometry
2. **Element zone configuration wrong:** Sheeting assigned to wrong zone indices
3. **Beam orientation detection failed:** Complex geometry confusing beam type detection
4. **Staggering applied incorrectly:** Stagger offsets moving nail lines too far

**Solutions:**
- Set "Nailing Reference Zone" to 0 for self-referencing
- Verify element zone configuration in Element Properties
- Disable staggering options for testing
- Check beam types using hsbCAD Beam Inspector

### CNC Export Fails

**Symptoms:** No NailLine entities in element database, or CNC export errors.

**Possible Causes:**
1. **CNC Module not licensed:** "Apply CNC Nailing Information?" set to Yes without module
2. **Element database locked:** Another process is accessing the element
3. **Zone index conflict:** Multiple scripts writing to same zone
4. **Tool index invalid:** CNC machine doesn't recognize tool number

**Solutions:**
- Verify hsbCAD CNC Module license
- Close all element-modifying scripts and rerun
- Ensure unique zone assignments
- Coordinate tool indices with CNC programmer

### Filter Errors

**Symptoms:** "HSB_G-FilterGenBeams not found" error message.

**Possible Causes:**
1. **Filter TSL not loaded:** HSB_G-FilterGenBeams script not in drawing
2. **Filter name incorrect:** Selected filter doesn't exist in catalog
3. **Catalog not initialized:** Filter TSL loaded but catalog not created

**Solutions:**
- Load HSB_G-FilterGenBeams TSL using TSLINSERT
- Create filter definitions in HSB_G-FilterGenBeams catalog
- Set filter parameter to empty to disable filtering
- Verify filter name spelling matches catalog exactly

### Excel Export Shows No Data

**Symptoms:** Hardware components don't appear in Excel reports.

**Possible Causes:**
1. **Hardware component filter:** Excel template filtering out SHEETNAILING/FRAMENAILING types
2. **Element not in report scope:** Selected elements don't include the nailed element
3. **Notes field format:** Excel formula not parsing Notes field correctly

**Solutions:**
- Verify Excel template includes all hardware types
- Ensure element is selected in report scope
- Use format code `@(Notes:T0)` for zone number, `@(Notes:T1)` for element number
- Check that hardware rep type _kRTTsl is included in report filter

---

## Best Practices and Tips

### Initial Setup

1. **Start Simple:**
   - Enable only Zone 1 (exterior) and Zone 6 (interior) initially
   - Use default spacing values (100mm perimeter, 200mm intermediate)
   - Set "Apply CNC Nailing Information?" to **No** during testing
   - Enable "Show nailing description" to verify calculations

2. **Verify Before CNC:**
   - Run with CNC disabled and check Bill of Material quantities
   - Export to Excel and verify nail counts are reasonable
   - Review on-screen nailing description text
   - Only enable CNC output when quantities are confirmed

3. **Create Catalog Presets:**
   - Save commonly used configurations as named presets
   - Create presets for different wall types (exterior, interior, structural)
   - Use descriptive names (e.g., "ExtWall_OSB100-200", "IntWall_Gypsum150-300")

### Material Filtering

4. **When to Use Material Filter:**
   - When element has multiple sheet materials in the same zone
   - When only specific sheets should be nailed (e.g., structural OSB, not finish boards)
   - When material names are standardized across the project

5. **Material Filter Pitfalls:**
   - Must be **exact match** (case-sensitive)
   - Includes leading/trailing spaces in material name
   - Leave empty for testing to nail all sheets

### Beam Exclusion Strategies

6. **Beam Code Exclusion:**
   - Assign unique codes to temporary/non-structural members
   - Use semicolon separation: `TEMP;BRACE;ALIGN;DUMMY`
   - Codes are compared to first token of beam code string
   - Codes are converted to uppercase for comparison

7. **Advanced Filtering:**
   - Use HSB_G-FilterGenBeams for complex criteria
   - Create reusable filters for company standards
   - Test filters independently before applying to nailing
   - Use zone-specific filters sparingly (adds complexity)

### Zone Configuration

8. **Zone Numbering:**
   - Zones 1-5: Front/exterior side (positive indices)
   - Zones 6-10: Back/interior side (negative indices)
   - Most walls use only Zones 1 and 6
   - Enable additional zones only when element has multiple sheet layers

9. **Reference Zones:**
   - Set to 0 for normal (self-referencing) operation
   - Use only when finish layer must match structural layer nailing pattern
   - Cannot cross-reference between positive and negative sides
   - Verify reference zone has sheeting in correct location

### Spacing Guidelines

10. **Structural Requirements:**
    - Consult engineering specs for perimeter/intermediate spacing
    - Common North American: 4"/8" (100mm/200mm)
    - Common European: 100mm/150mm or 75mm/150mm
    - Tighter spacing for shear walls and high-wind zones

11. **Edge and Sheet Offsets:**
    - **Edge Offset (20mm default):** Prevents nails too close to beam ends (splitting risk)
    - **Sheet Edge Offset (8mm default):** Minimum distance from nail to sheet/beam edge
    - Areas narrower than 2× sheet edge offset are automatically skipped
    - Increase edge offset if beams are prone to splitting

### Optimization Settings

12. **Optimize Nailing:**
    - Enable for cost savings on multi-stud banks (triple studs, posts)
    - Engineering review recommended
    - May not comply with all building codes
    - Consider disabling for shear walls and high-load areas

13. **Stagger at Stud Joint:**
    - **Strongly recommended** for structural integrity
    - Prevents nail congestion where sheets meet on same stud
    - Distributes nailing load across wider stud area
    - Minimal cost impact, significant quality improvement

14. **Basic Stagger:**
    - Use only if nail collision is observed between zones
    - Adds slight complexity to CNC programming
    - Not typically necessary for standard wall assemblies

### CNC Integration

15. **Tool Index Coordination:**
    - Work with CNC programmer to define tool indices
    - Standard tool (index 1): perpendicular nailing
    - Tilted left/right (indices 2/3): angled for edge nailing
    - Document tool index assignments in project standards

16. **Tilt Tool Setup:**
    - Enable only if CNC machine supports tilting
    - Test with small sample before full production
    - Verify offset values with actual machine behavior
    - Coordinate with machine operator on tilt angles

### Display and Documentation

17. **Display Representations:**
    - Create dedicated "Nailing" display rep for clean visualization
    - Enter rep name in "Show in Disp Rep" to isolate nailing annotation
    - Keep standard working views uncluttered
    - Use color-coded zones for visual differentiation

18. **Nailing Description Text:**
    - Enable during setup and verification
    - Disable for final production drawings if not needed
    - Text shows Zone 1 spacing only (perimeter / intermediate)
    - Position is automatic (near element arrow point for walls, origin for floors)

### Frame Nailing

19. **Frame Nailing Limitations:**
    - Calculation is simplified (4/6/8 nails based on beam height)
    - Use for material estimation only
    - Verify against engineering specs
    - Does not account for beam-to-beam orientation
    - Consider disabling if not using CNC for frame nailing

20. **Frame Fastener Selection:**
    - Use longer nails (90mm) for frame-to-frame connections
    - Screw shank for withdrawal resistance
    - Match fastener to framing nailer capabilities

### Element Geometry

21. **Truss Handling:**
    - Automatic detection and processing (v3.8+)
    - Treats truss body as single beam for nailing
    - No user configuration needed
    - Verify nail line orientation on complex truss shapes

22. **Scarf Joint Support:**
    - Automatic split of nail lines at scarf joint locations
    - Relies on hsb_SplitBeamsWithScarfJoint or scandibyg_SplitBeamsWithScarfJoint
    - Exclusion zone ~400mm long around joint
    - Preserves joint structural integrity

23. **Header Considerations:**
    - Script automatically determines which header edges to nail
    - Left and right edges always nailed
    - Top edge nailed only if no top plate above
    - Bottom edge nailed only if no transom below
    - Review complex opening configurations manually

### Quality Assurance

24. **Verification Checklist:**
    - [ ] Enable "Show nailing description" and verify spacing values
    - [ ] Check Bill of Material for SHEETNAILING quantities
    - [ ] Export to Excel and review nail counts per zone
    - [ ] Visually inspect nail lines in nailing display representation
    - [ ] Verify perimeter nailing around openings
    - [ ] Confirm edge nailing on headers
    - [ ] Check that beams narrower than 20mm are excluded
    - [ ] Verify material filter is working (if used)
    - [ ] Test CNC export on sample element before production

25. **Documentation:**
    - Save catalog presets with descriptive names
    - Document tool index assignments in project specs
    - Record spacing requirements for different wall types
    - Create checklists for operators
    - Maintain library of tested filter definitions

### Performance

26. **Large Elements:**
    - Script sequence number is 50 (runs after framing scripts)
    - Processing time scales with beam and sheet count
    - Complex openings (many headers/jacks) increase processing
    - Truss support adds temporary geometry overhead
    - Consider batching elements in groups for large projects

27. **Recalculation:**
    - Script automatically recalculates when element geometry changes
    - Previous nailing instance is erased and recreated
    - Element reconstruction triggers full recalculation
    - Manual recalculation via TSLUPDATE if needed

---

## Integration with Other Scripts

### Parent-Child Relationships

This script does **not** launch child scripts. It is a standalone tool that processes elements.

### Commonly Used Together

| Script Name | Purpose | Integration Point |
|-------------|---------|-------------------|
| **HSB_G-FilterGenBeams** | Advanced beam filtering | Provides filter definitions used by "Filter definition beams" parameters |
| **hsb_SplitBeamsWithScarfJoint** | Scarf joint creation | Script detects these joints and splits nail lines to avoid joint area |
| **scandibyg_SplitBeamsWithScarfJoint** | Scarf joint (Scandinavian) | Alternative scarf joint script, also detected |
| **HSB_G-BillOfMaterial** | BOM generation | Reads SHEETNAILING/FRAMENAILING hardware components |
| **Element creation scripts** | Element builders | Must run before nailing (sequence < 50) |
| **Shop drawing scripts** | Fabrication drawings | Read HSB_ElementData nailing info for annotation |
| **CNC export modules** | Manufacturing output | Read NailLine entities for machine code generation |

### Typical Workflow Sequence

```
1. Element Creation (HSB_W-Panel, hsb_CreateElement, etc.)
   ↓
2. Framing Scripts (stud layout, header generation, plate creation)
   ↓
3. Sheeting Scripts (OSB distribution, gypsum board placement)
   ↓
4. hsb_Apply Naillines to Elements (this script, sequence 50)
   ↓
5. Shop Drawing Generation (annotations, dimensions)
   ↓
6. CNC Export (manufacturing code generation)
   ↓
7. Bill of Material (material ordering, cost estimation)
```

---

## Technical Architecture

### Script Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. INSERTION PHASE (_bOnInsert = TRUE)                          │
│    - Display Properties Panel                                   │
│    - Prompt for element selection                               │
│    - Create instance per selected element                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. INITIALIZATION PHASE                                          │
│    - Parse zone parameters into arrays                           │
│    - Convert PropString Yes/No to boolean arrays                │
│    - Parse beam code exclusion list                             │
│    - Load filter definitions from HSB_G-FilterGenBeams          │
│    - Set sequence number to 50                                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. ELEMENT ANALYSIS PHASE                                        │
│    - Get element coordinate system (X, Y, Z axes)               │
│    - Extract all beams in Zone 0 (structural frame)             │
│    - Rebuild beam code strings                                  │
│    - Classify beam types (header, stud, plate, etc.)            │
│    - Detect trusses and create temporary beam representations   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. ZONE ITERATION LOOP (for each enabled zone)                  │
│    ┌─────────────────────────────────────────────────────────┐  │
│    │ 4a. Get zone sheeting and determine reference zone     │  │
│    │ 4b. Apply material filter (if specified)               │  │
│    │ 4c. Calculate zone plane and sheet profiles            │  │
│    │ 4d. Identify opening zones for perimeter detection     │  │
│    │ 4e. Apply HSB_G-FilterGenBeams filter (if configured)  │  │
│    └─────────────────────────────────────────────────────────┘  │
│                           ↓                                      │
│    ┌─────────────────────────────────────────────────────────┐  │
│    │ 4f. BEAM ITERATION LOOP (for each valid beam)          │  │
│    │     - Filter out excluded beams (dummy, narrow, etc.)  │  │
│    │     - Apply beam code exclusion list                   │  │
│    │     - Determine beam orientation (horizontal/vertical) │  │
│    │     - Calculate beam direction vectors                 │  │
│    │     - Handle headers with special logic                │  │
│    │     - Extract beam contact face in zone plane          │  │
│    │     - Detect and handle scarf joints                   │  │
│    │     - Intersect beam face with sheet profiles          │  │
│    │     - Check for bank optimization markers              │  │
│    │                                                         │  │
│    │     RING ITERATION LOOP (for each contact area):       │  │
│    │       - Calculate nail line extent and direction       │  │
│    │       - Determine perimeter vs. intermediate spacing   │  │
│    │       - Apply staggering offsets                       │  │
│    │       - Select tool index (standard/tilted)            │  │
│    │       - Calculate nail quantity                        │  │
│    │       - Create NailLine entity (if CNC enabled)        │  │
│    │       - Accumulate nail count for zone                 │  │
│    └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. FRAME NAILING CALCULATION (if enabled)                       │
│    - Iterate through all beams                                  │
│    - Exclude perimeter beam types (plates, angle plates)        │
│    - Calculate nails based on beam height:                      │
│      * < 100mm: 4 nails                                         │
│      * 100-200mm: 6 nails                                       │
│      * > 200mm: 8 nails                                         │
│    - Accumulate total frame nail count                          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. DATA EXPORT PHASE                                             │
│    - Create SHEETNAILING hardware components (per zone)         │
│    - Create FRAMENAILING hardware component (if enabled)        │
│    - Write hardware components to instance                      │
│    - Export to DXA (zone, description, quantity)                │
│    - Attach "hsbElementNailing" property set to element         │
│    - Store nailing info in element HSB_ElementData MapX         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 7. VISUAL OUTPUT PHASE                                           │
│    - Draw small cross marker at element origin                  │
│    - Display nailing description text (if enabled)              │
│    - Set display representation filter (if specified)           │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 8. RECALCULATION TRIGGER (automatic)                            │
│    - Triggered on element reconstruction                        │
│    - Erase previous instance on same element                    │
│    - Re-run entire calculation with current parameters          │
└─────────────────────────────────────────────────────────────────┘
```

### Key Functions

**`prepareHardware()`** (lines 218-282)
- Prepares SHEETNAILING and FRAMENAILING hardware components
- Removes existing TSL-type hardware components to avoid duplicates
- Sets linked entity, material, description, and notes fields
- Returns hardware component array

### Data Structures

**Zone Parameter Arrays:**
After parsing PropString/PropInt parameters, the script creates parallel arrays indexed by zone:

```c
int nZoneIndex[z]        // Real zone index (1,2,3,-1,-2,-3,...)
int nRefZone[z]          // Reference zone index (0=self, or other zone)
int bNailYN[z]           // Zone enabled? (TRUE/FALSE)
int nToolingIndex[z]     // Standard CNC tool index
double dSpacingEdge[z]   // Perimeter nail spacing
double dSpacingCenter[z] // Intermediate nail spacing
double dDistEdge[z]      // Edge offset (end of nail line to beam end)
double dDistSheetEdge[z] // Sheet edge offset (minimum edge distance)
String strMaterialZone[z] // Material filter (empty = all materials)
int bTiltTool[z]         // Tilt tool enabled?
double dMinDist[z]       // Minimum distance to trigger tilt
int nToolingIndexLeft[z] // Tilted left tool index
int nToolingIndexRight[z] // Tilted right tool index
double dOffsetNailing[z] // Tilt tool offset
String strNailType[z]    // Fastener description
String filterDefinitions[z] // Filter definition name (zone-specific)
```

**Beam Type Constants:**
```c
_kSFAngledTPLeft       // Angled top plate left
_kSFAngledTPRight      // Angled top plate right
_kSFStudLeft           // Left stud
_kSFStudRight          // Right stud
_kSFTopPlate           // Top plate
_kSFBottomPlate        // Bottom plate
_kHeader               // Header
_kKingStud             // King stud
_kSFSupportingBeam     // Supporting beam
_kSFJackOverOpening    // Jack above opening
_kSFJackUnderOpening   // Jack below opening
_kSFTransom            // Transom
_kDummyBeam            // Dummy beam (excluded)
_kLocatingPlate        // Locating plate (excluded)
```

### Geometry Calculation

**Perimeter Distance Threshold:**
```c
double dDistCloseToEdge = dBmWidth * 0.5 + U(1);
```
Nail line is considered "perimeter" if its midpoint is within this distance from nearest sheet edge.

**Nail Line Construction:**
```c
Point3d ptStart = ptCent - vxBm * ((dLengthNl * 0.5) - (dDistEdge + nDisplacement));
Point3d ptEnd = ptCent + vxBm * ((dLengthNl * 0.5) - (dDistEdge + nDisplacement));
LineSeg lsNL(ptStart, ptEnd);
```

**Nail Quantity:**
```c
double dQtyNails = round(abs(vxBm.dotProduct(ptStart - ptEnd)) / dSpacing) + 1;
```

**Stagger Offset:**
```c
int nDisplacement = 0;
if (nStagger) {
    nDisplacement = abs(U(8) * nZoneIndex[z]);
}
if (nStaggerOnStud && ppStagger.area() > pow(U(0.1), 2)) {
    nDisplacement += nDistToStaggerOnStud;  // Half perimeter spacing
}
```

### Coordinate Systems

**Element Coordinate System:**
```c
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();  // Along wall length (horizontal for walls)
Vector3d vy = csEl.vecY();  // Perpendicular to wall face (thickness direction)
Vector3d vz = csEl.vecZ();  // Vertical (up) for walls
Point3d ptOrg = csEl.ptOrg(); // Element origin
```

**Beam Coordinate System:**
```c
Vector3d vxBm = bm.vecX();  // Along beam length
Vector3d vyBm = bm.vecY();  // Across beam width (in zone plane)
```

Nail line direction is calculated to run along the longer dimension of the beam contact area in the zone plane, typically perpendicular to studs (horizontal nail lines) or along headers (vertical nail lines).

---

## Limitations and Constraints

### Current Limitations

1. **Beam Filtering Dependency:**
   - Advanced filtering requires HSB_G-FilterGenBeams TSL to be loaded
   - If filter selected but TSL not available, script terminates with error
   - No graceful degradation to manual filtering

2. **Frame Nailing Simplification:**
   - Calculation uses simplified logic (4/6/8 nails based on height only)
   - Does not account for beam-to-beam connection type
   - Does not consider beam orientation or angle
   - Should be used for estimation only, not structural design

3. **Reference Zone Constraints:**
   - Cannot cross-reference between positive and negative sides
   - Zones 1-5 can only reference 0,1,2,3,4,5
   - Zones 6-10 can only reference 0,6,7,8,9,10
   - Reference zone must have valid sheeting geometry

4. **Material Filter Sensitivity:**
   - Requires exact case-sensitive material name match
   - Includes leading/trailing spaces
   - No wildcard or partial matching support
   - Single material per zone only

5. **Display Limitations:**
   - On-screen description text shows Zone 1 spacing only
   - Cannot display description for other zones
   - Text position is automatic (not user-configurable)
   - Single display representation filter for all zones

6. **Truss Support:**
   - Treats entire truss as single beam (no member-by-member nailing)
   - Temporary geometry creation adds processing overhead
   - Complex truss shapes may produce unexpected nail line orientations

7. **Performance:**
   - Processing time scales with beam count and sheet complexity
   - Complex openings (many headers/jacks/transoms) increase processing
   - Large elements (>50 beams) may take several seconds
   - Recalculation on every element geometry change

### Known Issues and Workarounds

**Issue 1: Nail lines extend beyond sheet edges**
- **Cause:** Edge offset smaller than beam overhang
- **Workaround:** Increase "Edge Offset" parameter or adjust beam positioning

**Issue 2: Double nailing at header/transom junctions**
- **Cause:** Header and transom both generating nail lines at junction
- **Workaround:** Script should handle this automatically (v3.7+). If occurs, verify transom detection logic.

**Issue 3: Missing nail lines on battens**
- **Cause:** Batten orientation detection failure (fixed in v3.3)
- **Workaround:** Update to v3.3 or later

**Issue 4: Incorrect spacing on headers with depth tolerance**
- **Cause:** Header not flush to wall face (fixed in v3.5)
- **Workaround:** Update to v3.5 or later for automatic tolerance handling

**Issue 5: Optimization removes needed nail lines**
- **Cause:** "Optimize nailing" too aggressive for specific framing configuration
- **Workaround:** Disable optimization for critical structural elements (shear walls, high-load areas)

**Issue 6: Filter not applying to all zones**
- **Cause:** Zone-specific filter overrides global filter
- **Workaround:** Clear zone-specific filters or set global filter to empty

---

## Related Scripts and Ecosystem

### Prerequisite Scripts

| Script | Relationship | Notes |
|--------|--------------|-------|
| **Element creation scripts** | Must run first | hsb_CreateElement, HSB_W-Panel, etc. create elements that this script processes |
| **Framing scripts** | Must run before nailing | HSB_W-Studs, HSB_R-Joist, etc. create beams in Zone 0 |
| **Sheeting scripts** | Must run before nailing | Sheet distribution scripts populate zones 1-10 |

### Companion Scripts

| Script | Relationship | Notes |
|--------|--------------|-------|
| **HSB_G-FilterGenBeams** | Optional integration | Provides advanced beam filtering capability |
| **hsb_SplitBeamsWithScarfJoint** | Auto-detected | Scarf joints are detected and nail lines split accordingly |
| **scandibyg_SplitBeamsWithScarfJoint** | Auto-detected | Alternative scarf joint script (Scandinavian markets) |

### Downstream Scripts

| Script | Relationship | Notes |
|--------|--------------|-------|
| **HSB_G-BillOfMaterial** | Reads hardware components | SHEETNAILING/FRAMENAILING components exported to BOM |
| **Shop drawing scripts** | Read HSB_ElementData | Annotations use perimeter/intermediate spacing values |
| **CNC export modules** | Read NailLine entities | Manufacturing code generation from nail line database |
| **Excel export tools** | Read hardware components | Material scheduling and cost estimation |

### Alternative Scripts

This script is the primary automated nailing solution in hsbCAD. Alternative approaches:

- **Manual NailLine creation:** Use hsbCAD's manual NailLine tool for custom nailing patterns
- **Element-specific scripts:** Some specialized element scripts (e.g., CLT panels) have integrated nailing
- **Third-party tools:** Some manufacturers provide hardware-specific nailing scripts

---

## Glossary of Terms

| Term | Definition |
|------|------------|
| **Element** | Complete wall, floor, or roof assembly containing beams and sheets in hsbCAD |
| **Zone** | Distinct layer within an element (Zone 0 = framing, Zones ±1-5 = sheeting layers) |
| **Perimeter Nailing** | Tighter nail spacing near sheet edges and around openings for structural requirements |
| **Intermediate Nailing** | Wider nail spacing in sheet field areas away from edges |
| **Reference Zone** | Zone whose framing geometry is used for calculating another zone's nail lines |
| **Tool Index** | CNC machine tool number (1 = standard, 2/3 = tilted left/right) |
| **NailLine Entity** | Database entity storing nail line geometry (start, end, spacing, tool) for CNC export |
| **Hardware Component** | hsbCAD data structure for material quantities (SHEETNAILING, FRAMENAILING) |
| **DXA** | Data exchange interface for exporting to external databases and ERP systems |
| **Property Set** | AutoCAD property collection attached to entities for scheduling and data extraction |
| **MapX** | hsbCAD extended data storage mechanism (HSB_ElementData contains nailing info) |
| **Sequence Number** | Execution order (50 = runs after most framing/sheeting scripts) |
| **Edge Offset** | Distance from nail line end to beam end (prevents nails near beam ends) |
| **Sheet Edge Offset** | Minimum distance from nail line to sheet/beam edge (areas < 2× are skipped) |
| **Bank of Studs** | Multiple studs side-by-side (e.g., triple stud at post) |
| **Optimization** | Removal of redundant nail lines on interior studs in multi-stud banks |
| **Staggering** | Offsetting nail line positions to avoid collisions between zones or at joints |
| **Header** | Horizontal beam above opening (door/window) |
| **Jack** | Vertical support beam beside opening (above or below) |
| **Transom** | Horizontal beam below opening (e.g., windowsill support) |
| **King Stud** | Full-height stud beside opening |
| **Supporting Beam** | Structural beam supporting other framing members |
| **Scarf Joint** | Angled timber joint where two beam sections meet end-to-end |
| **Truss** | Prefabricated structural framework (roof or floor) |
| **Batten** | Secondary framing member (typically smaller cross-section) |
| **Dummy Beam** | Non-structural placeholder beam (excluded from nailing) |
| **Locating Plate** | Alignment reference beam (excluded from nailing) |

---

## Summary

**hsb_Apply Naillines to Elements** is the most comprehensive automated nailing solution in hsbCAD, providing:

✅ **10-zone support** for complex multi-layer wall and floor assemblies
✅ **Automatic perimeter vs. intermediate classification** based on structural requirements
✅ **Header nailing intelligence** that avoids double-nailing at junctions
✅ **Truss support** with automatic temporary beam conversion
✅ **Scarf joint detection** to prevent nailing through joints
✅ **Multi-format export** (CNC NailLine entities, Bill of Material, DXA, Property Sets)
✅ **Advanced beam filtering** via HSB_G-FilterGenBeams integration
✅ **Optimization options** to reduce material waste on multi-stud banks
✅ **Staggering capabilities** to prevent nail congestion
✅ **Tilt tool support** for CNC machines with angled nailing

**Typical Use Cases:**
- Automated nailing calculation for standard wall and floor elements
- CNC nailing machine programming data generation
- Material estimation and cost calculation for fasteners
- Shop drawing annotation with perimeter/intermediate spacing values
- ERP system integration for material procurement

**Best For:**
- Production environments with CNC nailing machines
- Projects requiring detailed material tracking and cost control
- Companies with standardized nailing specifications
- Fabrication shops needing automated manufacturing data

**Critical Success Factors:**
1. Proper element zone configuration (framing in Zone 0, sheeting in correct zones)
2. Accurate spacing values matching engineering specifications
3. Material name consistency for filtering
4. CNC tool index coordination with machine configuration
5. Verification of quantities via Bill of Material before CNC export

**Version Maturity:** v3.11 (production-ready, actively maintained, 16-year development history)

---

*Document Generated: 2026-02-20*
*Script Version: 3.11*
*For Technical Support: hsbSOFT (support@hsb-cad.com)*
