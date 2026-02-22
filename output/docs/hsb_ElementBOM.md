# hsb_ElementBOM - Element Bill of Materials Generator

## Overview

**hsb_ElementBOM** is a comprehensive shop drawing tool that generates detailed, formatted Bills of Materials (BOMs) for timber structure elements in Paper Space or Shopdraw Multipage environments. The script creates professional, multi-section material lists that include timber framing members, sheet materials, SIP panels, metal hardware, and trusses - all organized into categorized tables with customizable display options.

**Primary Use**: Generate production-ready material lists for walls, floors, and roofs that can be placed on shop drawings, fabrication documents, or layout sheets.

**Script Type**: O-Type (Object - standalone intelligent entity)
**Version**: 1.47 (September 29, 2024)
**Workspace**: Paper Space or Shopdraw Multipage
**Element Types Supported**: Walls (Stick Frame & SIP), Floors, Roofs

---

## When to Use This Tool

### Typical Workflow Position
1. Complete your element design in Model Space (walls, floors, roofs)
2. Create a Paper Space layout or Shopdraw Multipage view
3. Set up a viewport showing the element
4. Insert **hsb_ElementBOM** to generate the material list
5. The BOM automatically updates when the element changes

### Common Scenarios
- **Shop Drawing Production**: Create detailed material lists for fabrication drawings
- **Material Takeoffs**: Generate quantities for ordering and cost estimation
- **Quality Control**: Verify that all components are accounted for
- **Assembly Documentation**: Provide fabricators with component reference numbers
- **Multi-Element Projects**: Generate separate BOMs for different zones or assemblies

### What Makes This Script Unique
- **Intelligent Grouping**: Automatically categorizes components by type (studs, plates, blocking, sheathing, etc.)
- **Multi-Format Support**: Handles Stick Frame, SIP walls, CLT panels, floors, and roofs
- **Posnum Display**: Can show reference numbers directly on elements in the viewport
- **Zone Filtering**: Include or exclude specific zones from the BOM
- **Assembly Recognition**: Detects prefabricated assemblies (Space Stud Assemblies, Assembly Definitions) and groups them intelligently
- **Two-Column Layout**: Option to display BOM in compact two-column format
- **Joist Reference Integration**: Can use external joist reference catalogs from exporter systems

---

## Script Metadata

### Header Information
```
#Type O                    // Object type - standalone entity
#NumBeamsReq 0             // No beams required
#NumPointsGrip 0           // No grip points
#ImplInsert 1              // Custom insertion logic
#MajorVersion 1
#MinorVersion 47
#Keywords BOM
```

### Version History Highlights
- **v1.47** (09/2024): Add customizable title for "Space Studs" table
- **v1.46** (08/2023): Bugfix - sheeting exclusion filter correction
- **v1.44** (07/2023): Support for Assembly Definition TSL
- **v1.43-42** (11/2022): Subassembly support for GC-SpaceStudAssembly
- **v1.41** (02/2022): Enhanced zone filtering and display options

---

## User Properties (OPM - Object Properties Manager)

### Drawing Space Selection

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Drawing space** | List | "paper space" | Where to place the BOM: "paper space" or "shopdraw multipage" |
| **Dim Style** | DimStyle | Current | Dimension style for table text formatting |
| **Color** | Integer | 3 | Color index for BOM table text |

**Important**: After insertion, the drawing space selection becomes read-only and cannot be changed.

### Content Filtering

| Property | Description | Usage |
|----------|-------------|-------|
| **Beam names to exclude from the BOM** | Semicolon-separated list of beam names to exclude | Enter beam names like "TEMP;LAYOUT;SUPPORT" to filter out unwanted components |
| **Materials to exclude from the BOM** | Semicolon-separated list of materials to exclude | Enter material names like "GYPSUM;INSULATION" to filter specific materials |
| **Exclude zones from BOM** | Semicolon-separated zone numbers to exclude | Enter zone numbers like "1;2;5" to exclude components in those zones |

**Filtering Logic**: The script compares beam names and materials in uppercase, so filtering is case-insensitive.

### Component Display Options

| Property | Options | Default | Effect |
|----------|---------|---------|--------|
| **Show Beams in the BOM** | Yes / No | Yes | Include timber framing members |
| **Show Sheets in the BOM** | Yes / No | Yes | Include sheet materials (OSB, plywood, gypsum, etc.) |
| **Show SIPs in the BOM** | Yes / No | Yes | Include Structural Insulated Panels |
| **Show Metalparts in the BOM** | Yes / No | Yes | Include metal hardware and connectors |
| **Show Trusses in the BOM** | Yes / No | Yes | Include truss entities (metal web joists) |

**Strategy**: Disable sections you don't need to create focused BOMs (e.g., timber-only list for mill, hardware-only for purchasing).

### Table Column Options

| Property | Options | Default | Description |
|----------|---------|---------|-------------|
| **Show Label Column** | Yes / No | Yes | Display the label attribute of components |
| **Show Name Column** | Yes / No | Yes | Display the name attribute of components |
| **Show Material Column** | Yes / No | No | Display material (e.g., "SPF", "LVL") |
| **Show Grade Column** | Yes / No | No | Display grade (e.g., "#2", "1.9E") |
| **Show Angle Column** | Yes / No | Yes | Display end cut angles (e.g., "45>90") |
| **Show Short Length** | Yes / No | No | Calculate and display shortest length for angled cuts |

**Column Width**: Columns auto-size based on the longest entry in that column.

### Angle Display

| Property | Options | Default | Description |
|----------|---------|---------|-------------|
| **Switch to Complementary Angle** | Yes / No | No | Convert angles to complementary (90° - angle) for saw settings |

**Example**:
- Original cut: 30°
- Complementary: 60° (useful for some saw setups)

### Grouping Options

| Property | Options | Default | Description |
|----------|---------|---------|-------------|
| **Group by** | "Posnum & dimension" / "Posnum" | "Posnum & dimension" | How to aggregate identical components |

**Grouping Logic**:
- **Posnum & dimension**: Groups components with same posnum AND same dimensions
- **Posnum only**: Groups all components with same posnum regardless of dimension (useful for assemblies)

### Two-Column Layout

| Property | Options | Default | Description |
|----------|---------|---------|-------------|
| **Show table in two columns** | Yes / No | No | Display timber and SIP BOMs side-by-side to save vertical space |

**Behavior**: Only applies if both **Show Beams** and **Show SIPs** are enabled. Places the second section to the right of the first.

### Posnum Display (On Elements)

| Property | Options | Default | Description |
|----------|---------|---------|-------------|
| **Show Beam Reference** | None / Posnum / Length | None | Display reference text on each beam in viewport |
| **Show Posnum Zone** | 0 (none) to 10 | 0 | Which zone's posnums to display (0 = none, 1-5 = positive zones, 6-10 = negative zones -1 to -5) |
| **Beam Reference Orientation** | Horizontal / Align To Beam Axis | Horizontal | Text orientation for beam references |
| **Dim Style Posnum** | DimStyle | Current | Dimension style for posnum text |
| **Color Posnum** | Integer | 3 | Color for posnum text |

**Zone Mapping**:
- 0 = No posnum display
- 1 = Zone 0 (main zone)
- 2 = Zone 1
- 3 = Zone 2
- 4 = Zone 3
- 5 = Zone 4
- 6 = Zone -1 (inside face)
- 7 = Zone -2
- 8 = Zone -3
- 9 = Zone -4
- 10 = Zone -5

**Anti-Collision**: The script automatically adjusts posnum positions to prevent overlapping text.

### Joist Reference Integration

| Property | Description | Default |
|----------|-------------|---------|
| **Joist Reference Catalogue** | Catalog name for joist reference system | "" (empty) |

**Advanced Feature**: If your workflow uses an external joist reference catalog (via SiteStream exporter DLL), enter the catalog name here. The script will replace generic posnums with joist reference codes.

**Prerequisite**: Requires `hsbSoft.Cad.IO.SiteStream.dll` in the Export/Interfaces folder.

### Space Stud Assembly Title

| Property | Description | Default |
|----------|-------------|---------|
| **Space studs table title** | Custom title for prefabricated space stud assemblies | "Space stud" |

**New in v1.47**: Allows customization of the group name for space stud assemblies, supporting different naming conventions.

---

## Insertion Workflow

### Step 1: Launch the Script
1. Type the script name in the command line or select from toolbar
2. The script displays a dialog showing all OPM properties
3. Configure your BOM settings (what to show, filtering, formatting)
4. Click OK to proceed

### Step 2: Select Drawing Location
The script prompts:
```
Pick a point to show the table
```
- Click where you want the upper-left corner of the BOM table
- This becomes the insertion point (_Pt0)

### Step 3: Select Source (Paper Space or Shopdraw)

**If you selected "paper space":**
```
Select the viewport from which the element is taken
```
- Click on the viewport containing your element
- The script connects to the Element visible in that viewport
- The viewport connection is stored for updates

**If you selected "shopdraw multipage":**
```
Select the view entity from which the module is taken
```
- Click on the ShopDrawView entity
- The script reads the ViewData to extract the Element
- Supports multipage shop drawing workflows

### Step 4: Initial Generation
- The script analyzes the element
- Generates categorized tables
- Displays the BOM at the insertion point
- If "Show Posnum" is enabled, reference numbers appear on beams

---

## BOM Table Structure

### Stick Frame Wall BOM Sections

The script generates multiple grouped sections, each with its own header:

#### 1. Prefabricated Cuts (Timber Framing)
**Sections automatically included based on element content**:

| Section | Components Included |
|---------|---------------------|
| **Space Stud** (or custom name) | Prefabricated space stud assemblies, Assembly Definition entities |
| **Locating Plate** | Bottom-most plates for wall positioning |
| **Bottom Plate** | Main bottom plates |
| **Top Plate** | Single and double top plates, very top plates |
| **Stud** | Standard studs, king studs, jack studs (over/under openings), cripple studs, left/right studs |
| **Cripple** | Supporting beams |
| **Transom** | Transoms, sills |
| **Lintel** | Headers |
| **Blocking** | Blocking, bracing |
| **Vent** | Vent components |
| **Service Battens** | Lath, battens |
| **Battens** | Front edge battens |
| **Connectors** | Center joists (for walls with roof-like features) |
| **Fillet** | Wedge components |
| **Generic** | Unclassified beams |

**Columns** (customizable via OPM):

| Column | Always Shown | Optional | Description |
|--------|--------------|----------|-------------|
| Nr. / Joist Ref | ✓ |  | Posnum or joist reference code |
| Label |  | ✓ | Beam label attribute |
| Name |  | ✓ | Beam name attribute |
| Dimension | ✓ |  | Width x Height (e.g., "38 x 140") |
| Length | ✓ |  | Solid length of member |
| Short L. |  | ✓ | Shortest length (for angled cuts) |
| Angle |  | ✓ | End cut angles (e.g., "90>45 - 45>90") |
| Amount | ✓ |  | Quantity |
| Material |  | ✓ | Material (e.g., "SPF", "DF") |
| Grade |  | ✓ | Grade (e.g., "#2", "MSR 1650") |

**Sorting**: Within each section, components are sorted by:
1. Height (ascending)
2. Length (ascending)

**Grouping**: Controlled by the "Group by" property:
- **Posnum & dimension**: Same posnum + same width/height/length = one line
- **Posnum only**: Same posnum = one line (dimensions may vary)

#### 2. Wallboard (Sheet Materials)
**Sections based on material name** (e.g., "OSB", "GYPSUM", "PLYWOOD"):

| Column | Description |
|--------|-------------|
| Nr. | Sheet posnum |
| Dimension | Width x Length |
| Thickness | Sheet thickness |
| Amount | Quantity |

**Automatic Grouping**: Sheets with identical posnum and dimensions are counted together.

#### 3. Metalparts (Hardware & Connectors)
**Sections based on hardware type** (e.g., "HANGER SIMPSON", "ANCHOR HILTI"):

| Column | Description |
|--------|-------------|
| Nr. | TSL posnum |
| Name/Model | Hardware model name from TSLBOM map |
| Amount | Quantity from TSLBOM |

**Data Source**: Reads the `TSLBOM` or `TSLBOM[]` map from hardware TSL instances.

**Map Structure Expected**:
```
TSLBOM/
  ├─ Name: "HTT22"
  ├─ Type: "HANGER"
  ├─ Manufacturer: "SIMPSON"
  └─ Qty: 2
```

### Floor/Roof BOM Sections

Similar structure but with floor-specific categories:

| Section | Components |
|---------|------------|
| **Joist** | Center joists, rim joists |
| **Rimboard** | Rim beams, back/front/left/right edges |
| **Supporting Beam** | Cross beams |
| **Packer** | Extra blocking |
| **Blocking** | Standard blocking |
| **Batten** | Lath |
| **Ledger** | Ledger beams |
| **Trimmer** | Floor beams |
| **Furring** | Rising beams, cantilever blocks |
| **Generic** | Unclassified |

**Sheathing Section**: Titled "Sheathing" instead of "Wallboard"
**Truss Section**: Titled "Metal Web Joists" instead of "Trusses"

### SIP (Structural Insulated Panel) BOM Sections

**Dynamic Sections**: One section per SIP style found in the element

| Column | Description |
|--------|-------------|
| Label | SIP label + sublabel |
| Width | Panel width (shorter dimension) |
| Length | Panel length (longer dimension) |
| Thickness | Panel thickness |

**Note**: No "Amount" column - each panel is listed individually (panels are typically custom-sized)

**Sorting**: Alphabetical by label

### Truss BOM Section

**Section Title**: "Trusses" (walls) or "Metal Web Joists" (floors)

| Column | Description |
|--------|-------------|
| Nr. | Truss definition name |
| Dimension | Width x Height |
| Length | Truss span |
| Amount | Quantity of identical trusses |

**Grouping**: Trusses with the same definition are counted together

---

## Advanced Features

### Prefabricated Assembly Recognition

#### Space Stud Assemblies
**Detected Scripts**: `hsb_SpaceStudAssembly`, `GC-SpaceStudAssembly`

The script recognizes these as prefabricated units and:
1. Groups all instances with identical geometry into a single BOM line
2. Uses the assembly's overall dimensions (not individual stud dimensions)
3. Reads data from the assembly's map:
   - `Width`: Assembly width
   - `Height`: Assembly height
   - `Length`: Assembly length
   - `SpaceStudAssembly`: Unique identifier for grouping

**Excluded from Main BOM**: Individual beams within space stud assemblies are excluded from the regular stud/blocking sections to prevent double-counting.

#### Assembly Definition TSL
**New in v1.44** - Supports generic assembly definitions:

**Detected Script**: `AssemblyDefinition`

Reads from the map:
- `compareKey`: Grouping identifier
- `Name`: Assembly name
- `Width`, `Height`, `Length`: Dimensions

**Behavior**: Similar to space stud assemblies - counts as a single prefab unit.

### Short Length Calculation

**Enabled by**: "Show Short Length" = Yes

**Purpose**: For components with angled end cuts, calculates the shortest distance along the member (important for material optimization and machine setup).

**Algorithm**:
1. Analyzes all `AnalysedCut` tools on the beam
2. Identifies cuts perpendicular to the beam axis (end cuts)
3. Finds the slice profile at each cut
4. Calculates minimum distance between opposite cut faces
5. Displays in the "Short L." column

**Example**:
- Hip rafter with 45° cuts at both ends
- Nominal length: 3000mm
- Shortest length (along centerline): 2850mm

### Complementary Angle Display

**Enabled by**: "Switch to Complementary Angle" = Yes

**Purpose**: Some saw setups reference the complementary angle rather than the cut angle.

**Conversion Formula**:
```
For each angle α:
  If α < 0: complementary = -90 - α
  If α ≥ 0: complementary = 90 - α
```

**Applies to**:
- CutN (Negative end cut angles)
- CutP (Positive end cut angles)
- CutNC (Negative end cut complementary)
- CutPC (Positive end cut complementary)

**Example Display**:
- Original: "30>90 - 90>60"
- Complementary: "60>0 - 0>30"

### Posnum Anti-Collision System

**Purpose**: When displaying posnums on elements in the viewport, prevent overlapping text.

**Algorithm**:
1. Projects all beam/sheet center points onto the element plane
2. Creates rectangular masks for each posnum text box
3. Detects intersections between masks
4. Shifts overlapping posnums along the beam axis until no intersection
5. Alternates shift direction (+/-, increasing distance)
6. Maximum 30 iterations per posnum

**Result**: Clean, readable posnum display even on dense assemblies.

### Zone-Based Display and Filtering

#### Exclusion Filtering
**Property**: "Exclude zones from BOM"

**Usage**: Enter zone numbers like "1;2;-1" to exclude components in those zones from the BOM table.

**Application**:
- Exclude interior sheeting (zone -1) for exterior-only BOMs
- Exclude temporary bracing (zone 5) from final material lists

#### Posnum Display Zones
**Property**: "Show Posnum Zone"

**Usage**: Select which single zone's posnums to display on elements in the viewport.

**Application**:
- Show zone 0 posnums for main assembly
- Show zone -1 posnums for interior finish schedule

**Note**: Only one zone can be displayed at a time.

### Joist Reference Catalog Integration

**Advanced Feature** for workflows using external material management systems.

**Requirements**:
1. `hsbSoft.Cad.IO.SiteStream.dll` in `[Install]\Export\Interfaces\`
2. Valid catalog name in "Joist Reference Catalogue" property
3. Catalog file in company settings folder

**Process**:
1. Script exports all beams to a ModelMap
2. Calls .NET function `GetBoqBeamTypes` with beam data + catalog name
3. Receives back beam handle → joist code mapping
4. Replaces posnums with joist codes in BOM

**Example**:
- Generic posnum: "245"
- Joist reference: "J-16-2400" (16" depth, 2400mm length)

**Fallback**: If catalog not found or DLL missing, reverts to standard posnum display with a warning.

### Material Name Exclusion

**Properties**: "Beam names to exclude", "Materials to exclude"

**Filtering Logic**:
1. User enters semicolon-separated names
2. Script splits by ";" and trims whitespace
3. Converts to uppercase for case-insensitive matching
4. Compares against beam names or sheet materials
5. Excludes matching components from BOM

**Common Use Cases**:
- Exclude temporary beams: "LAYOUT;TEMP;BRACE"
- Exclude non-structural materials: "INSULATION;VAPOR BARRIER"
- Exclude specific beam names: "NAILER;FURRING"

**Important**:
- For beams: compares against `beam.name()`
- For sheets: compares against `sheet.material()`

---

## Workflow Examples

### Example 1: Simple Wall BOM for Fabrication

**Scenario**: Generate a complete material list for a stick frame wall.

**Steps**:
1. Design wall in Model Space with all framing and sheathing
2. Create Paper Space layout for shop drawing
3. Insert viewport showing wall elevation
4. Launch **hsb_ElementBOM**
5. Configure OPM:
   - Drawing space: "paper space"
   - Show Beams: Yes
   - Show Sheets: Yes
   - Show Metalparts: Yes
   - Show SIPs: No
   - Show Trusses: No
   - Show Angle Column: Yes
   - Show Material Column: Yes
6. Click OK
7. Pick insertion point on drawing
8. Click viewport to link to wall element
9. **Result**: Complete BOM with framing sections, sheathing section, and hardware section

### Example 2: Filtered BOM (Exterior Materials Only)

**Scenario**: Create a BOM showing only exterior materials (exclude interior finishes).

**Steps**:
1. Ensure interior sheathing is in zone -1 (inside face)
2. Launch **hsb_ElementBOM**
3. Configure OPM:
   - Drawing space: "paper space"
   - Exclude zones from BOM: "-1"
   - Show Beams: Yes
   - Show Sheets: Yes
   - Materials to exclude from BOM: "GYPSUM;DRYWALL"
4. Click OK
5. Select insertion point and viewport
6. **Result**: BOM excludes all interior-face sheets and any gypsum materials

### Example 3: Floor Joist List with Posnum Display

**Scenario**: Generate a joist list with reference numbers visible on each joist in the viewport.

**Steps**:
1. Design floor in Model Space
2. Create layout with floor plan viewport
3. Launch **hsb_ElementBOM**
4. Configure OPM:
   - Drawing space: "paper space"
   - Show Beams: Yes
   - Show Sheets: No (only joists, no deck)
   - Show Beam Reference: "Posnum"
   - Show Posnum Zone: 1 (zone 0)
   - Beam Reference Orientation: "Horizontal"
5. Click OK
6. Pick insertion point and viewport
7. **Result**:
   - BOM table with joist sections
   - Posnum labels appear on each joist in the viewport
   - Labels positioned to avoid overlap

### Example 4: Two-Column Compact BOM

**Scenario**: Save vertical space by displaying timber and SIP panels side-by-side.

**Steps**:
1. Design SIP wall with timber frame
2. Create layout with viewport
3. Launch **hsb_ElementBOM**
4. Configure OPM:
   - Show Beams: Yes
   - Show SIPs: Yes
   - Show table in two columns: Yes
5. Click OK
6. Select insertion point and viewport
7. **Result**:
   - Left column: Timber framing sections
   - Right column: SIP panel sections
   - Saves vertical drawing space

### Example 5: Hardware-Only BOM for Purchasing

**Scenario**: Create a BOM showing only metal connectors for ordering.

**Steps**:
1. Complete wall design with hardware TSLs
2. Create layout
3. Launch **hsb_ElementBOM**
4. Configure OPM:
   - Show Beams: No
   - Show Sheets: No
   - Show SIPs: No
   - Show Metalparts: Yes
   - Show Trusses: No
5. Click OK
6. Select insertion point and viewport
7. **Result**: Clean list of hardware items grouped by type and manufacturer

### Example 6: Shopdraw Multipage Workflow

**Scenario**: Use with multipage shop drawing system.

**Steps**:
1. Create Shopdraw Multipage view showing wall
2. Launch **hsb_ElementBOM**
3. Configure OPM:
   - Drawing space: "shopdraw multipage"
   - (other settings as needed)
4. Click OK
5. Pick insertion point
6. **Prompt changes to**: "Select the view entity from which the module is taken"
7. Click on ShopDrawView entity
8. **Result**: BOM reads element from ViewData structure, displays on multipage sheet

---

## Common Issues and Solutions

### Issue: BOM is Empty or Missing Sections

**Possible Causes**:
1. Element not found in viewport
2. All components filtered out by name/material/zone exclusions
3. Component display options all set to "No"

**Solutions**:
- Verify viewport contains a valid Element entity
- Check "Beam names to exclude" and "Materials to exclude" - clear if needed
- Check "Exclude zones from BOM" - clear if needed
- Ensure at least one "Show [Type] in the BOM" is set to "Yes"
- Verify element actually contains components (not an empty element)

### Issue: Posnums Not Displaying on Elements

**Possible Causes**:
1. "Show Beam Reference" set to "None"
2. "Show Posnum Zone" set to 0 (none)
3. Wrong zone selected (e.g., showing zone 1 but beams are in zone 0)

**Solutions**:
- Set "Show Beam Reference" to "Posnum" or "Length"
- Set "Show Posnum Zone" to appropriate value (1 = zone 0, 2 = zone 1, etc.)
- Check which zone your beams are in: use HSB element inspector tools
- Verify "Dim Style Posnum" is set to a valid dimension style

### Issue: BOM Shows Wrong Element

**Cause**: Viewport or ShopDrawView connected to different element than expected.

**Solution**:
- **Paper Space**: Ensure you clicked the correct viewport during insertion
- **Shopdraw Multipage**: Ensure you clicked the correct view entity
- Delete the BOM instance and re-insert, carefully selecting the correct source
- **Note**: The connection is stored in `_Viewport` or `_Entity` array and cannot be changed after insertion

### Issue: Dimensions Show in Wrong Units

**Cause**: Dimension style uses different units than element.

**Solution**:
- Check the "Dim Style" property - ensure it's set to a dimension style with correct units
- The script uses the dimension style's unit settings for all dimension formatting
- For mm elements, use a mm-based dimension style
- For inch elements, use an inch-based dimension style

### Issue: "Joist Ref" Showing "-1" Instead of Codes

**Possible Causes**:
1. DLL not found: `hsbSoft.Cad.IO.SiteStream.dll` missing
2. Catalog not found in company settings
3. Beam handles not matching catalog data

**Solutions**:
- Verify DLL exists: `[Install]\Export\Interfaces\hsbSoft.Cad.IO.SiteStream.dll`
- Check catalog name spelling in "Joist Reference Catalogue" property
- Verify catalog file exists in company TSL settings folder
- **If DLL missing**: Script reverts to posnum display with warning message
- **If catalog missing**: Script shows error dialog, falls back to posnum

### Issue: Space Stud Assemblies Showing Individual Studs

**Cause**: Assembly script not recognized or map data missing.

**Solution**:
- Verify assembly TSL is named exactly "hsb_SpaceStudAssembly" or "GC-SpaceStudAssembly"
- Check assembly map contains required keys:
  - "SpaceStudAssembly": unique identifier
  - "Width", "Height", "Length": dimensions
- Ensure assembly instances have valid beam entities attached
- Regenerate assemblies if they were created with older versions

### Issue: Short Length Column Shows "12345"

**Cause**: Short length calculation failed (no angled cuts found or calculation error).

**Solution**:
- Verify beam actually has angled end cuts
- Check that cuts are proper `AnalysedCut` tools (not just display cuts)
- Disable "Show Short Length" if not needed - reduces processing time

### Issue: BOM Table Text Overlapping or Misaligned

**Possible Causes**:
1. Dimension style text height too large
2. Complex Unicode characters in beam names/materials
3. Coordinate system transformation issues

**Solutions**:
- Use a smaller dimension style or reduce text height in dimension style settings
- Avoid special characters in beam names and material names
- Verify viewport is orthogonal (not perspective or skewed)
- Check that viewport scale is reasonable (not extremely zoomed in/out)

---

## Integration with Other Tools

### Upstream Tools (Before hsb_ElementBOM)

| Tool | Purpose | Output Used |
|------|---------|-------------|
| **hsb_CreateElement** | Create stick frame walls | Element entity with beams, sheets |
| **hsbCLT-MasterPanelManager** | Create CLT/SIP panels | Element with SIP entities |
| **Hilti-*, Simpson*, Rothoblaas*** | Hardware connectors | TSL instances with TSLBOM map data |
| **hsb_SpaceStudAssembly** | Prefab assemblies | Assembly TSLs with dimension maps |
| **AssemblyDefinition** | Generic assemblies | Assembly TSLs with compareKey |

### Downstream Tools (After hsb_ElementBOM)

| Tool | Purpose | How BOM Helps |
|------|---------|---------------|
| **Layout_Dim_Beam** | Dimension shop drawings | Posnum references match BOM |
| **hsb_A4 Layout** | Create printable sheets | BOM is part of the drawing |
| **hsbBOM** | Global project BOM | Element-level BOMs feed into project BOM |
| **bauBIT-Exporter** | Export to production systems | BOM validates exported data completeness |

### Related Documentation Scripts

| Script | Relationship |
|--------|--------------|
| **hsb_WallBOM** | Original wall-only BOM (predecessor to hsb_ElementBOM) |
| **hsb_ElementTable** | Displays element properties (not material list) |
| **HSB_G-BillOfMaterial** | Project-level global BOM across all elements |
| **hsb_ViewTag** | Labels views in layout (complements BOM positioning) |

---

## Summary

**hsb_ElementBOM** is the primary tool for generating professional, production-ready Bills of Materials for timber structure elements in hsbCAD. Its comprehensive feature set supports complex workflows including:

- **Multi-section organization** with automatic component categorization
- **Flexible filtering** by name, material, and zone
- **Assembly recognition** for prefabricated components
- **Visual posnum display** with anti-collision positioning
- **Joist reference integration** for material management systems
- **Customizable table formatting** with optional columns and two-column layout

**Ideal for**: Shop drawing documentation, material ordering, fabrication planning, and quality control verification.

**Workflow Position**: Late-stage documentation - use after element design is complete and hardware is placed.

**Learning Curve**: Moderate - basic use is straightforward (accept defaults), advanced features (joist references, assembly filtering, short length) require understanding of element structure and workflow integration.
